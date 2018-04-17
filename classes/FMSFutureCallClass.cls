/*
 * @ Author :- Anil Kumar Reddy L
 * @ Description :- contains the logic for updating device in Async call.
 * @ Date :- 21/12/2016
 * @ Change History :-  
 *  DATE                NAME            Comment
23-May-2017          Abhita Bansal     Added the code for outbound Message Integration
28-Jun-2017			 Abhita Bansal	   Removed System debugs and added exceptional handling code
**/
public class FMSFutureCallClass
{
    @future
    public static void updateDeviceFMSID(Set<ID> recordIds)
    {   
        // Get those records based on the IDs
        List<Form_Management_System__c> fmsList = [SELECT ID,device__c,Technology__c,name FROM Form_Management_System__c WHERE ID IN : recordIds];
        List<device__c> deviceList = new List<device__c>();
        for(Form_Management_System__c fmsRecord : fmsList){
            if(fmsRecord.device__c != null){
                Device__c devRec = new Device__c(id=fmsRecord.device__c ,FMS_ID__c = fmsRecord.name);
                deviceList.add(devRec);
            }
        }
        if(!deviceList.isEmpty()){
            try {
                update deviceList;
            } catch(Exception e) {
                UtilityCls.saveExceptionLog(FMSFutureCallClass.class.getName(), 'updateDeviceFMSID()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        }
    }
    
    @future
    public static void updatePTNumber(List<ID> recordIds){

        List<Form_Management_System__c> fmsList = [SELECT ID,device__c,Technology__c,name FROM Form_Management_System__c WHERE ID IN : recordIds];
        List<String> fmsTech = new List<String>();
        for(Form_Management_System__c fmsRecord : fmsList){
            if(fmsRecord.device__c != null){
                fmsTech.add(fmsRecord.Technology__c);
            }
        }
        if(fmsTech.size() > 0){
            List<product2> productList = [SELECT ID,PT_Number__c , Name FROM Product2 where name IN :fmsTech];
            
            Map<String,String> PTMapping = new Map<String,String>();
            
            for(product2 prd : productList){
                
                PTMapping.put(prd.name , prd.PT_Number__c);
            }
            List<Process_Technology__c> processTechList= [Select id,PT_Number__c from Process_Technology__c where PT_Number__c IN:PTMapping.values()];
            Map<String,Id> ProcssPTMapping = new Map<String,Id>();
            for(Process_Technology__c procTech : processTechList){
                ProcssPTMapping.put(procTech.PT_Number__c, procTech.id);
            }
            List<Device__c> deviceLst = new List<Device__c>();
            for(Form_Management_System__c fmsRecord : fmsList){             
                String PTnumber = PTMapping.get(fmsRecord.Technology__c);
                if(PTNumber!=null){
                    if(ProcssPTMapping.get(PTnumber)!=null){
                        if(fmsRecord.device__c!= null){
                            Device__c dev = new Device__c(id=fmsRecord.device__C,Process_Technology_2__c = ProcssPTMapping.get(PTnumber));
                            deviceLst.add(dev);
                        }
                    }
                }
            }
            if(!deviceLst.isEmpty()){
                try {
                    update deviceLst;
                } catch(Exception e) {
                    UtilityCls.saveExceptionLog(FMSFutureCallClass.class.getName(), 'updatePTNumber()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
                }
            }
        } 
    }
    @future
    public static void updateStage(ID deviceId){
        Device__c device = new Device__c(id=deviceId,Stage__c='Tapeout');
        try {
            update device;
        } catch(Exception e) {
            UtilityCls.saveExceptionLog(FMSFutureCallClass.class.getName(), 'updateStage()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
    }
    
    @future
    public static void updateFieldsInForm(Set<ID> recordIds,String pageURL){
        List<Form_Management_System__c> fms = [Select Id, FormURL__c, Form_Type__c from Form_Management_System__c where Id IN:recordIds];
        Form_Management_System__c fmsRecord;   

        if(fms != null && !fms.isEmpty()){
            fmsRecord = fms[0];
            if(fmsRecord.FormURL__c == null || fmsRecord.FormURL__c == ''){
                if(fmsRecord.Form_Type__c.contains('Main')){
                    if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                        fmsRecord.FormURL__c = System.Label.FMS_External_URL + '/GlobalfoundryView/apex/FMSmainFormViewPage?id='+fmsRecord.id;
                    } else {
                        fmsRecord.FormURL__c = System.Label.FMS_Internal_URL + '/apex/FMSmainFormViewPage?id='+fmsRecord.id; 
                    }
                } else if (fmsRecord.Form_Type__c.contains('IMC')){
                    if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                        fmsRecord.FormURL__c = System.Label.FMS_External_URL + '/GlobalfoundryView/apex/FMSIMCFormViewPage?id='+fmsRecord.id;
                    } else {
                        fmsRecord.FormURL__c = System.Label.FMS_Internal_URL + '/apex/FMSIMCFormViewPage?id='+fmsRecord.id; 
                    }
                } else if (fmsRecord.Form_Type__c.contains('RIT')) {
                    if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                        fmsRecord.FormURL__c = System.Label.FMS_External_URL + '/GlobalfoundryView/apex/FMSRITFormViewPage?id='+fmsRecord.id;
                    } else {
                        fmsRecord.FormURL__c = System.Label.FMS_Internal_URL + '/apex/FMSRITFormViewPage?id='+fmsRecord.id; 
                    }
                } else if (fmsRecord.Form_Type__c.contains('DDR')) {
                    if(PageURL.containsIgnoreCase('GlobalfoundryView')){
                        fmsRecord.FormURL__c = System.Label.FMS_External_URL + '/GlobalfoundryView/apex/FMSDDRFormViewPage?id='+fmsRecord.id;
                    } else {
                        fmsRecord.FormURL__c = System.Label.FMS_Internal_URL + '/apex/FMSDDRFormViewPage?id='+fmsRecord.id; 
                    }
                }       
            }
            FMSEmailTemplates.SendEditEmail = false;
            try {
                update fmsRecord;
            } catch(Exception e) {
                UtilityCls.saveExceptionLog(FMSFutureCallClass.class.getName(), 'updateFieldsInForm()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        }
    }
}