/*
SWGP-882: [PTRF WS] PTRF Layer Chip Deselection
Test class is:
- MRSDeselectionServiceTest
*/
public class MRSDeselectionServiceHandler {
    
    public map<String, String> layerChipErrorSet;//key is 'no.' + m.no + '#' + m.sfdcId
    public map<String, String> maskLayerErrorSet;//key is 'no.' + m.no + '#' + m.layerNumber + m.revision + (m.romCode == null ? '' : m.romCode)
    public map<String, String> chipDetailErrorSet;//key is 'no.' + m.no + '#' + m.chipName
    
    public set<String> chipUniqueIdentifierSet;
    
    
    //TO-DO-FIX
    //LAYER_CHIP
    public set<String> lc_ptrfSet;
    public set<String> lc_layerSet;
    public set<String> lc_revSet;
    public set<String> lc_chipSet;
    
    //PTRF_LAYER
    public set<String> lc_ptrfSet2;
    public set<String> lc_layerSet2;
    public set<String> lc_revSet2;
    
    //PTRF_CHIP_DETAIL
    public set<String> lc_ptrfSet3;
    public set<String> lc_chipSet3;
    //END-TO-DO-FIX
    
    //request payload, use throughout this class
    private MRSDeselectionService.Notification notification;
    
    private static MRSDeselectionServiceHandler instance = null;
    private MRSDeselectionServiceHandler(MRSDeselectionService.Notification notification) {
        this.notification = notification;
        this.layerChipErrorSet = new map<String, String>();
        this.maskLayerErrorSet = new map<String, String>();
        this.chipDetailErrorSet = new map<String, String>();
        this.chipUniqueIdentifierSet = new set<String>();         
        
        
        this.lc_layerSet = new set<String>();
        this.lc_revSet = new set<String>();
        this.lc_chipSet = new set<String>();
        
        this.lc_layerSet2 = new set<String>();
        this.lc_revSet2 = new set<String>();
        
        this.lc_chipSet3 = new set<String>();
    }
    
    public static MRSDeselectionServiceHandler fetchInstance(MRSDeselectionService.Notification notification) {
        if(null == instance) instance = new MRSDeselectionServiceHandler(notification);
        return instance; 
    }
    
    public String processWs() {
        String validateMsg = validate();
        if(String.isBlank(validateMsg)) execute();
        String responseToPTRF = finish(validateMsg);
        //====================================================
        return responseToPTRF;
    }
    
    /*
    Initial validation, if fail >>> return error immediately
    if no fatal failures (empty param) >>> extract data for processing
    */
    private String validate() {
        if(null == notification.messageId) {
            Environment_Variable__c env = Environment_Variable__c.getInstance('SWIFT_MESSAGE_ID_EMPTY');
            if(null != env) return env.value__c;
            return 'error: messageId is empty';
        }
        
        if(null == notification.ptrfNumber) {
            Environment_Variable__c env = Environment_Variable__c.getInstance('SWIFT_PTRF_EMPTY');
            if(null != env) return env.value__c;
            return 'error: ptrfNumber is empty';
        }
        
        if(null == notification.layerChipList) {
            Environment_Variable__c env = Environment_Variable__c.getInstance('SWIFT_EMPTY_L_CHIP_LIST');
            if(null != env) return env.value__c;
            return 'error: layer chip list is empty';
        }
        
        list<ptrf__c> ptrf = [select id,status__c from ptrf__c where name = :notification.ptrfNumber limit 1];
        if(ptrf.isEmpty()) {
            Environment_Variable__c env = Environment_Variable__c.getInstance('SWIFT_PTRF_NOT_FOUND');
            if(null != env) return env.value__c;
            return 'error: PTRF not found in SFDC';
        }
        
        if(ptrf.get(0).status__c != 'Perform Tapeout Options') {
            Environment_Variable__c env = Environment_Variable__c.getInstance('SWIFT_PTRF_STATUS_NOT_PTO');
            if(null != env) return env.value__c;
            return 'error: PTRF Order Status not in Perform Tapeout Options';
        }
        return '';
    }
    
    private void extractLayerChip() {
        //layer chip
        for(MRSDeselectionService.LayerChip c: notification.layerChipList) {
            //NEW_REQUEST : change id to combination of layerNumber + revision + chipName + romCode(if have)
            lc_layerSet.add(c.layerNumber);
            lc_revSet.add(c.revision);
            lc_chipSet.add(c.chipName);            
        }
    }    
    
    private void extractMaskLayer() {
        if(null == notification.ptrfMaskLayerList) return;
        //ptrf mask layer
        for(MRSDeselectionService.PTRFMaskLayer c: notification.ptrfMaskLayerList) {            
            lc_layerSet2.add(c.layerNumber);
            lc_revSet2.add(c.revision);
        }
    }    
    
    private void extractChipDetail() {
        if(null == notification.ptrfChipList) return; 
        //ptrf chip detail
        for(MRSDeselectionService.PTRFChip c: notification.ptrfChipList) {
            lc_chipSet3.add(c.chipName);
        }
    }
    
    /*
    need to include logic that
    - when layer chip is hold >>> do not allow update to cancel
    - when layer chip is resume >>> auto update to cancel if previously was cancelled
    
    find logic of SWGP-950 on how to set
    */
    private String execute() {        
        extractLayerChip();
        extractMaskLayer();
        extractChipDetail();
        
        //lists that to be updated by end of this execute() method
        list<mrs_layer_chip_association__c> ulist = new list<mrs_layer_chip_association__c>();
        list<mask_layer__c> mlist = new list<mask_layer__c>();
        list<chip_detail__c> clist = new list<chip_detail__c>();
        
        //source email: MPW034A: Notification: MPW034A Hold Tapeout activities - Unhold - MRS status
        lc_chipSet.add('Frame');//add frame chip to cancel Frame when whole layer is deselected <<< workaround as the fix should be in .NET instead of MRS
        
        //deselect layer chip
        //TO-DO-FIX
        map<String, mrs_layer_chip_association__c> mapLayerTrip = new map<String, mrs_layer_chip_association__c>();
        for(mrs_layer_chip_association__c m: [
            select id,layer_chip_status__c,ptrf__r.name,layer__r.name,layer__r.mask_layer_rev__c,chip__r.name,layer__r.rom_code__c
            from mrs_layer_chip_association__c
            where 
                ptrf__r.name = :notification.ptrfNumber
                and layer__r.name in :lc_layerSet
                and layer__r.mask_layer_rev__c in :lc_revSet
                and chip__r.name in :lc_chipSet
                and Layer_Chip_Status__c IN ('Not Ready','In Progress','Released','Hold','Void','Pending Foundry Release') // = NOT CANCEL
        ]) { 
            String key = m.ptrf__r.name + m.layer__r.name + m.layer__r.mask_layer_rev__c + m.chip__r.name 
                + (String.isBlank(m.layer__r.rom_code__c) ? '' : m.layer__r.rom_code__c);
                
            mapLayerTrip.put(key, m); 
        }
        
        for(MRSDeselectionService.LayerChip m: notification.layerChipList) {
            String key = notification.ptrfNumber + m.layerNumber + m.revision + m.chipName + (String.isBlank(m.romCode) ? '' : m.romCode);
            if(mapLayerTrip.containsKey(key)) {
                mrs_layer_chip_association__c c = (mrs_layer_chip_association__c) mapLayerTrip.get(key);
                //applied swgp-950 logic here
                //if the chip is on hold >>> do not allow cancellation
                //after the chip is resumed >>> auto set back to cancel using Is_Cancel_After_Off_Hold__c flag
                if(c.Layer_Chip_Status__c != 'Hold') c.Layer_Chip_Status__c = 'Cancel';
                else c.Is_Cancel_After_Off_Hold__c = true;
                ulist.add(c);
            } else {
                //log missing layer chip error
                //NEW_REQUEST : change id to combination of layerNumber + revision + chipName + romCode(if have 
                layerChipErrorSet.put('no.' + m.no + '#' + key, 'layer chip not found in MRS or already been Cancelled');//success_with_warning: <no#id> layer chip id not found in MRS
            }
        }
        
        //deselect ptrf mask layer
        if(null != notification.ptrfMaskLayerList) {
            
            //TO-DO-FIX
            map<String, mask_layer__c> mapLayer = new map<String, mask_layer__c>();
            for(mask_layer__c m: [
                select id,ptrf__r.name, Mask_Layer_Number__c,Mask_Layer_Rev__c,rom_code__c
                from mask_layer__c
                where 
                    ptrf__r.name = :notification.ptrfNumber
                    and Mask_Layer_Number__c in :lc_layerSet2
                    and Mask_Layer_Rev__c in :lc_revSet2
            ]) {                

                String key = m.ptrf__r.name + m.Mask_Layer_Number__c + m.Mask_Layer_Rev__c  + (String.isBlank(m.rom_code__c) ? '' : m.rom_code__c);
                mapLayer.put(key, m);
                
                //source email: MPW034A: Notification: MPW034A Hold Tapeout activities - Unhold - MRS status
                //add frame chip to cancel Frame when whole layer is deselected <<< workaround as the fix should be in .NET instead of MRS
                String frameKey = m.ptrf__r.name + m.Mask_Layer_Number__c + m.Mask_Layer_Rev__c + 'Frame' + (String.isBlank(m.rom_code__c) ? '' : m.rom_code__c);                
                if(mapLayerTrip.containsKey(frameKey)) {
                    mrs_layer_chip_association__c c = (mrs_layer_chip_association__c) mapLayerTrip.get(frameKey);
                    if(c.Layer_Chip_Status__c != 'Hold') c.Layer_Chip_Status__c = 'Cancel';
                    else c.Is_Cancel_After_Off_Hold__c = true;
                    ulist.add(c);
                }
            }
            
            for(MRSDeselectionService.PTRFMaskLayer m: notification.ptrfMaskLayerList) {
                String key = notification.ptrfNumber + m.layerNumber + m.revision + (m.romCode == null ? '' : m.romCode);
                
                if(mapLayer.containsKey(key)) {
                    mask_layer__c l = (mask_layer__c) mapLayer.get(key);
                    l.tapeout__c = false;
                    mlist.add(l);
                } else {
                    //log missing layer error
                    //success_with_warning: <no#layerNumber+revsison+romCode> mask layer not found
                    maskLayerErrorSet.put('no.' + m.no + '#' + m.layerNumber + m.revision + (m.romCode == null ? '' : m.romCode), 'mask layer not found');
                }
            }
        }

        //deselect chip detail
        if(null != notification.ptrfChipList) {
            
            //TO-DO-FIX
            map<String, chip_detail__c> chipMap = new map<String, chip_detail__c>();
            for(chip_detail__c c: [
                select id,name,ptrf__r.name
                from Chip_Detail__c
                where 
                    ptrf__r.name = :notification.ptrfNumber
                    and name in :lc_chipSet3
            ]) { 
                chipMap.put(c.ptrf__r.name + c.name, c);
            }
            
            for(MRSDeselectionService.PTRFChip m: notification.ptrfChipList) {
                String key = notification.ptrfNumber + m.chipName;
                if(chipMap.containsKey(key)) {
                    chip_detail__c c = chipMap.get(key);
                    c.tapeout__c = false;
                    clist.add(c);
                } else {
                    //log missing chip error
                    chipDetailErrorSet.put('no.' + m.no + '#' + m.chipName, 'chip not found');//success_with_warning: <chipName> chip not found
                }
            }
        }
        
        //DML statements
        dmlHandling(ulist, mlist, clist);
        return '';
    }
    
    //response to AIA/PTRF @ catch statement
    @TestVisible
    private void dmlHandling(list<mrs_layer_chip_association__c> ulist, list<mask_layer__c> mlist, list<chip_detail__c> clist) {
        update ulist;
        update mlist;
        update clist;
    }
    
    private String finish(String validateMsg) {
        String result = validateMsg;
        if(!layerChipErrorSet.isEmpty()) result += String.valueOf(layerChipErrorSet.keySet()) + ': layer chip not found in MRS. \r\n';
        if(!maskLayerErrorSet.isEmpty()) result += String.valueOf(maskLayerErrorSet.keySet()) + ': mask layer not found. \r\n';
        if(!chipDetailErrorSet.isEmpty()) result += String.valueOf(chipDetailErrorSet.keySet()) + ': chip not found. \r\n';
        //==============================
        
        String responseTxt = '';
        if(String.isBlank(result))                      responseTxt = 'success';
        else if(result.containsIgnoreCase('error:'))    responseTxt = result; 
        else                                            responseTxt = 'success_with_warning: ' + result;
        
        //debug flag here to turn on/off logging
        //if flag >>>
        saveLog(responseTxt);
        //==============================
        return responseTxt;//success or success_with_warning: <msg>
    }
    
    private void saveLog(String result) {
        try {
            Environment_Variable__c env = Environment_Variable__c.getInstance('SWIFT_L_C_DESELECTION_DEBUG_SWITCH');
            if(env.Value__c != 'ON') return;
            
            //build response structure here
            MRSDeselectionUtils.NotificationResponse response = new MRSDeselectionUtils.NotificationResponse();
            response.transactionStatus = 'success';
            response.transactionErrorMessage = '';
            response.messageId = notification.messageId;
            response.ptrfNumber = notification.ptrfNumber;
            response.layerChipList = new List<MRSDeselectionUtils.LayerChipResponse>();
            response.ptrfMaskLayerList = new List<MRSDeselectionUtils.PTRFMaskLayerResponse>();
            response.ptrfChipList = new List<MRSDeselectionUtils.PTRFChipResponse>();
            
            if(result.containsIgnoreCase('error:')) {
                MRSDeselectionUtils.logRequestResponse(
                    json.serialize(notification),
                    json.serialize(response),
                    result,//general error message (eg how many chips not found...)
                    notification.messageId, 
                    'MRSDeselectionService', 
                    'notification', 
                    notification.ptrfNumber
                );
                return;//if validate() contains error >>> no need to build further response as initial already fail
            }
            
            //response.layerChipList
            for(MRSDeselectionService.LayerChip c: notification.layerChipList) {
                MRSDeselectionUtils.LayerChipResponse temp = new MRSDeselectionUtils.LayerChipResponse();
                temp.errorMessage = '';
                
                //NEW_REQUEST : key change id to combination of layerNumber + revision + chipName + romCode(if have 
                String subKey = notification.ptrfNumber + c.layerNumber + c.revision + c.chipName + (String.isBlank(c.romCode) ? '' : c.romCode);
                String key = 'no.' + c.no + '#' + subKey;
                if(layerChipErrorSet.containsKey(key)) {
                    temp.status = 'error';
                    temp.errorMessage = (String) layerChipErrorSet.get(key);
                } else {
                    temp.status = 'success';
                }
                
                temp.no = c.no;
                temp.sfdcId = c.sfdcId;
                temp.layerNumber = c.layerNumber;
                temp.revision = c.revision;
                temp.chipName = c.chipName;
                temp.romCode = c.romCode;
                
                response.layerChipList.add(temp);
            }
            
            //response.ptrfMaskLayerList
            if(null != notification.ptrfMaskLayerList) {
                for(MRSDeselectionService.PTRFMaskLayer c: notification.ptrfMaskLayerList) {
                    MRSDeselectionUtils.PTRFMaskLayerResponse temp = new MRSDeselectionUtils.PTRFMaskLayerResponse();
                    temp.errorMessage = '';
                    
                    String key = 'no.' + c.no + '#' + c.layerNumber + c.revision + (String.isBlank(c.romCode) ? '' : c.romCode);
                    if(maskLayerErrorSet.containsKey(key)) {
                        temp.status = 'error';
                        temp.errorMessage = (String) maskLayerErrorSet.get(key);
                    } else {
                        temp.status = 'success';
                    }

                    temp.no = c.no; 
                    temp.layerNumber = c.layerNumber; 
                    temp.revision = c.revision;
                    temp.romCode = c.romCode;
                    
                    response.ptrfMaskLayerList.add(temp);
                }
            }
            
            //response.ptrfChipList
            if(null != notification.ptrfChipList) {
                for(MRSDeselectionService.PTRFChip c: notification.ptrfChipList) {
                    MRSDeselectionUtils.PTRFChipResponse temp = new MRSDeselectionUtils.PTRFChipResponse();
                    temp.errorMessage = '';
                    
                    String key = 'no.' + c.no + '#' + c.chipName;
                    if(chipDetailErrorSet.containsKey(key)) {
                        temp.status = 'error';
                        temp.errorMessage = (String) chipDetailErrorSet.get(key);
                    } else {
                        temp.status = 'success';
                    }
                    
                    temp.no = c.no;
                    temp.chipName = c.chipName;
                    temp.chipType = c.chipType;
                    
                    response.ptrfChipList.add(temp);
                }
            } 
            
            MRSDeselectionUtils.logRequestResponse(
                json.serialize(notification),
                json.serialize(response),
                result,//general error message (eg how many chips not found...)
                notification.messageId, 
                'MRSDeselectionService', 
                'notification', 
                notification.ptrfNumber
            );
        } catch(Exception e) {}//for whatever reason if saving log causes an error >>> should not affect the main logic >>> a vanished log is ok
    }
}