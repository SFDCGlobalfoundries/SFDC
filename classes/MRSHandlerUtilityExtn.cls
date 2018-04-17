/*
Test class:
MRSHandlerUtilityTest3
MRSHandlerUtilityTest4
MRSHandlerUtilityTest5
MRSHandlerUtilityExtnTest
*/
public class MRSHandlerUtilityExtn {
    // Code added for TASK-2261 BEGIN 
    /**
        Check if each MRS Layer has at least one "Prime" MRS Layer Chip and at least one "Frame" MRS Layer Chip
        UPDATED: This rule is not applied to <=22nm (SWGP-395)
        @method name: hasFrameAndPrime
        @parameter:   1. MRS Layer
                      2. List of related layer chip
        @return :     boolean value
     **/ 
    public static boolean hasFrameAndPrime(MRS_Layer_Association__c layer, List<MRS_Layer_Chip_Association__c> mrsLayerChips){
        boolean hasFrame = false;
        boolean hasPrime = false;
        try{
            Environment_Variable__c ev                 = Environment_Variable__c.getInstance('Swift_Default_Tech_Geo_MDP_1P1F');
            if( layer.Tech_Geo_Int__c!=null && layer.Tech_Geo_Int__c!='' && ev!=null && ev.Value__c!=null){
                if( Double.valueOf( layer.Tech_Geo_Int__c.trim() ) <= Double.valueOf( ev.Value__c.trim() ) ) return true;
            }
        
            for(MRS_Layer_Chip_Association__c chip : mrsLayerChips){
                if(chip.Layer__c == layer.ID &&  chip.Layer_Chip_Status__c=='Released'){
                    if(chip.Chip_Name__c == 'Frame') hasFrame = true;
                    else hasPrime = true;
                }
            }
        }catch(Exception ex){logException(ex, 'MRSHandlerUtilityExtn', 'hasFrameAndPrime');  }
        return (hasFrame && hasPrime);
    }
    // Code added for TASK-2261 END
    /*
    * @description load environment variable, create a new one with default value if not exist
    * @param name variable name
    *        defaultValue 
    * @return 
    */
    public static String loadEnvVariable(String name, String defaultValue){
        if( Environment_Variable__c.getInstance(name)==null ) insert new Environment_Variable__c(Name=name,Value__c=defaultValue);
        return Environment_Variable__c.getInstance(name).Value__c;
    }
    
    /*
    * @description set default value of Customer/Foundry GDSOUT Review for all 22nm and below PTRF
    * @param MRS_Layer_Chip_Association__c layerChip
    * @return 
    */
    public static void setDefaultGDSOUTReview(MRS_Layer_Chip_Association__c layerChip){
        try{
            Double techGeo              = Double.valueOf(layerChip.Tech_Geo__c.toUppercase().substringBefore('UM').trim());
            Double defaultTechGeo       = Double.valueOf( MRSHandlerUtilityExtn.loadEnvVariable('Swift_Default_Tech_Geo_GDSOUTReview','0.022') );
            if(techGeo <= defaultTechGeo && !Test.isRunningTest()){
                layerChip.Foundry_GDSOUT_Review__c = 'N.A.';
                layerChip.Customer_GDSOUT_Review__c = 'N.A.';
            }
        }catch(Exception ex){   logException(ex, 'MRSHandlerUtilityExtn', 'setDefaultGDSOUTReview');  }
    }
    
    /*
    * @description Default Customer/Foundry Frame Mockup review to N.A. for 20nm and below
    * @param MRS_Layer_Chip_Association__c layerChip
    * @return 
    */
    public static void setDefaultFrameMockupReview(MRS_Layer_Chip_Association__c layerChip){
        try{
            Double techGeo              = Double.valueOf(layerChip.Tech_Geo__c.toUppercase().substringBefore('UM').trim());
            Double defaultTechGeo       = Double.valueOf( MRSHandlerUtilityExtn.loadEnvVariable('Swift_Default_Tech_Geo_Frame_Mockup','0.020') );
            if(techGeo <= defaultTechGeo && !Test.isRunningTest()){
                layerChip.Foundry_Frame_Mockup__c    = 'N.A.';
                layerChip.Customer_Frame_Mockup__c   = 'N.A.';
            }
        }catch(Exception ex){   logException(ex, 'MRSHandlerUtilityExtn', 'setDefaultFrameMockupReview');  }
    }
    
    /*
    * @description log unexpected exception.
    * @param MRS_Layer_Chip_Association__c layerChip
    *        String className
    *        String methodName
    * @return 
    */
    public static void logException(Exception ex, String className, String methodName){
        insert new SWIFT_Application_Log__c(
            Debug_Level__c            = 'ERROR',
            Apex_Component_Name__c    = className,
            Method__c                 = methodName,
            Message_ID__c             = '',
            Error_Message__c          = ex.getMessage(),
            Stack_Trace__c            = ex.getStackTraceString()
        );
    }
    
    /*
    * @description prevent layer status changed from Shipped to any other status (TASK-2458)
    * @param List<MRS_Layer_Association__c> newList
    *        Map<Id, MRS_Layer_Association__c> oldMap
    * @return 
    */
    public static void validateLayerStatusUpdate(List<MRS_Layer_Association__c> newList, Map<Id, MRS_Layer_Association__c> oldMap){
        try{
            Set<String> preStatus = new Set<String>{'Shipped'};
            for(MRS_Layer_Association__c layer : newList){
                if(oldMap.containsKey(layer.Id) && preStatus.contains(oldMap.get(layer.Id).Layer_Status__c) && layer.Layer_Status__c=='Released'){
                    layer.Layer_Status__c   = oldMap.get(layer.Id).Layer_Status__c;
                }
            }
        }catch(Exception ex){   logException(ex, 'MRSHandlerUtilityExtn', 'validateLayerStatusUpdate');  }
    }
    
    /*
    * @description Update 'Last Sync' date (TASK-2462/SWGP-130)
    * @param 
    * @return 
    */
    public static void updateLastSyncDate(Map<Id, MRS_Layer_Chip_Association__c> oldMap, Map<Id, MRS_Layer_Chip_Association__c> newMap){
        
        User usr = [Select Id, Name from User where Id = : UserInfo.getUserId()];
        
        if(!usr.Name.equalsIgnoreCase('SWIFT Integration')){
            
            //Map of each Last Sync field with a set of fields could be updated in corresponding CAD webservice
            Map<String, Set<String>> LastSyncDateMap = new Map<String, Set<String> > {
                'Last_Sync_Req_Timestamp_Send_Prime__c'     => new Set<String>{'Send_Prime_Data__c'},
                'Last_Sync_Req_Timestamp_Send_Frame__c'     => new Set<String>{'Send_Frame_Data__c'},
                'Last_Sync_Req_Timestamp_Receive_MEBES__c'  => new Set<String>{'Prime_MEBES_Received__c','Frame_MEBES_Received__c'},
                'Last_Sync_Req_Timestamp_Remote_JobCust__c' => new Set<String>{'Customer_Prime_Remote_Jobview_Setup__c','Customer_Frame_Remote_Jobview_Setup__c'},
                'Last_Sync_Req_Timestamp_Remote_Jobview__c' => new Set<String>{'Foundry_Prime_Remote_Jobview_Setup__c','Foundry_Frame_Remote_Jobview_Setup__c'}
            };
            
            Set<String> setValues = new Set<String>{'Done'};
            
            try{
                MRS_Layer_Chip_Association__c oldChip;
                
                for( MRS_Layer_Chip_Association__c newChip : newMap.values() ){
                    
                    oldChip = oldMap.get( newChip.ID );
                    
                    for(String lastSyncField : LastSyncDateMap.keySet() ){
                    
                        //Check if any field is changed to Done
                        for( String field : LastSyncDateMap.get(lastSyncField) ){
                    
                            if( String.valueOF(oldChip.get(field)) != String.valueOF(newChip.get(field)) && setValues.contains( String.valueOF(newChip.get(field)) )  ){
                                newChip.put( lastSyncField, System.now() );
                                break;
                            }
                        }
                    }
                    
                }
            }catch(Exception ex){   logException(ex, 'MRSHandlerUtilityExtn', 'updateLastSyncDate');  }
        }
    }
    
    /*
    Email will be sent per single MST >>> same tech geo enforcement
    This method is used to send email for SWGP-919 & SWGP-920
    - String emailTemplate: email template name
    - list<String> additionalToAddresses: additional email addresses that need to be in the loop
    - list<mrs_layer_association__c> targetLayers: query id,name,mask_layer_rev__c,Mask_Set_Title_Name__c,tech_geo_int__c
    
    Environment variable: SWIFT_Notify_Email_Cutoff
    */
    public static void sendPendingHoldResumeEmail(String emailTemplate, list<String> additionalToAddresses, list<mrs_layer_association__c> targetLayers) {
        
        //VALIDATION_1
        if(String.isBlank(emailTemplate) || targetLayers.isEmpty()) return;
        
        if(additionalToAddresses == null) additionalToAddresses = new list<String>();
        Decimal techGeoValue = 0.0;
        Environment_Variable__c techGeoCutOff = Environment_Variable__c.getInstance('SWIFT_Notify_Email_Cutoff');
        if(techGeoCutOff != null) techGeoValue = Decimal.valueOf(techGeoCutOff.Value__c);
        
        boolean isMpw = targetLayers.get(0).Mask_Set_Title_Name__c.startsWithIgnoreCase('MPW');
        
        //VALIDATION_2
        if(!isMpw && Decimal.valueOf(targetLayers.get(0).tech_geo_int__c) < techGeoValue) return;//this email is only send for >= 22 for non mpw        
        else if(isMpw && Decimal.valueOf(targetLayers.get(0).tech_geo_int__c) <= techGeoValue) return;//this email is only send for > 22 for mpw
                
        //query ecs (recType: General) by email template
        List<Email_Config_Settings__c> ecsList = [
            SELECT Email_Template_Name__c,BCC__c,CC__c,Id, Customer_Jobviewer_Type__c, Foundry_Jobviewer_Type__c,Name,
                MPW_PTRF__c, Send_Mail_To_Customer_AS_Submitter__c, Tech_Geo_Value__c,TO__c,Send_Mail_To_Customer__c
            FROM Email_Config_Settings__c 
            WHERE Email_Template_Name__c = :emailTemplate  and Available_For_Use__c = true and RecordType.Name = 'General' and MPW_PTRF__c = :isMpw
            limit 1
        ];
        
        //VALIDATION_3
        if(ecsList.isEmpty()) return;
        
        //build recipients
        Map<String, List<String>> recipientList = MRSApprovalUtility.buildRecipientList(ecsList);
        
        //VALIDATION_4
        if(recipientlist.get('TO').isEmpty() && recipientlist.get('CC').isEmpty() && recipientlist.get('BCC').isEmpty()) return;
        
        list<String> layerTestList = new list<String>();
        for(mrs_layer_association__c m: targetLayers) layerTestList.add(m.Name + m.mask_layer_rev__c);
        
        //query email template
        EmailTemplate template= [select id,Subject,Body,HtmlValue,Developername from EmailTemplate where DeveloperName=:emailTemplate];
        String subject = template.Subject.replace('<MST>',targetLayers.get(0).Mask_Set_Title_Name__c).replace('<LAYER>',String.join(layerTestList, ', '));
        String body    = template.Body.replace('<MST>',targetLayers.get(0).Mask_Set_Title_Name__c).replace('<LAYER>',String.join(layerTestList, ', ')).replace('#ECS',ecsList.get(0).name);
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'swift@globalfoundries.com'];
        
        //construct email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        if(!owea.isEmpty()) mail.setOrgWideEmailAddressId(owea.get(0).Id);
                
        additionalToAddresses.addAll(recipientList.get('TO'));
        mail.setToAddresses(additionalToAddresses);
        mail.setCcAddresses(recipientList.get('CC'));
        mail.setBccAddresses(recipientList.get('BCC'));
        mail.setSubject(subject);
        mail.setPlainTextBody(body);

        try { Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail}); } catch(Exception e) {}
    }
    
    //@future 
    public static void sendPendingHoldResumeEmail_future(String emailTemplate, set<id> layerIdSet) {
        
        list<mrs_layer_association__c> targetLayers = [
            select id,name,mask_layer_rev__c,Mask_Set_Title_Name__c,tech_geo_int__c,hold_by__c 
            from mrs_layer_association__c 
            where id in :layerIdSet
        ];        
        list<user> usrs = [select id,email from user where id = :targetLayers.get(0).Hold_By__c];        
        list<String> emails = usrs.isEmpty() ? null : new list<String>{usrs.get(0).email};
        try { sendPendingHoldResumeEmail(emailTemplate, emails, targetLayers); } catch(Exception e) {}
    }
    
    /*
    SWGP-998
    This method is used to reset syncing flag in MRS_Layer_Chip_Syncing_Status__c
    This method is initialy invoked in MRS_Layer_Chip_Association_SWIFT_AUPD everytime layer chip is updated
    */
    public static void resetSyncingFlagChip(set<id> lcidSet) {
        if(lcidSet.isEmpty()) return;        
        list<MRS_Layer_Chip_Syncing_Status__c> lcs = [select id from MRS_Layer_Chip_Syncing_Status__c where MRS_Layer_Chip_Association__c in :lcidSet];        
        for(MRS_Layer_Chip_Syncing_Status__c m: lcs) m.Is_Synced_With_MSIH__c = false;
        update lcs;
    }
    
    /*
    SWGP-998
    This method is used to reset syncing flag in MRS_Layer_Syncing_Status__c
    This method is initialy invoked in MRS_Layer_Association_SWIFT_AUPD everytime layer is updated
    */
    public static void resetSyncingFlagLayer(set<id> lidSet) {
        if(lidSet.isEmpty()) return;
        list<MRS_Layer_Syncing_Status__c> lcs = [select id from MRS_Layer_Syncing_Status__c where MRS_Layer_Association__c in :lidSet];
        for(MRS_Layer_Syncing_Status__c m: lcs) m.Is_Synced_With_MSIH__c = false;
        update lcs;
    }
    
    
    
    
    
    
    public static List < MRS_Layer_Association__c > sortMaskLayer2(set < String > setPTRFIds, List < MRS_Layer_Association__c > LayerObj) {
        List < MRS_Layer_Association__c > WrapperList = new List < MRS_Layer_Association__c > ();
        List < MRS_Layer_Association__c > tempWrapperList = new List < MRS_Layer_Association__c > ();
        List < MRS_Layer_Association__c > tempAppenderList = new List < MRS_Layer_Association__c > ();
        Map < String, List < Mask_Layer__c >> firstFramePTRFMap = new Map < String, List < Mask_Layer__c >> ();
        Map < String, List < Mask_Layer__c >> firstPrimePTRFMap = new Map < String, List < Mask_Layer__c >> ();
        Map < String, List < Mask_Layer__c >> PTRFTrueMap = new Map < String, List < Mask_Layer__c >> ();
        Map < String, List < MRS_Layer_Association__c >> MapLayerObjToName = new Map < String, List < MRS_Layer_Association__c >> ();
        Map < String, List < MRS_Layer_Association__c >> WrapperMap = new Map < String, List < MRS_Layer_Association__c >> ();
        List < Mask_Layer__c > firstFramePTRF = new List < Mask_Layer__c > ();
        List < Mask_Layer__c > firstPrimePTRF = new List < Mask_Layer__c > ();
        List < Mask_Layer__c > TempMaskLayerList = new List < Mask_Layer__c > ();
        List < Mask_Layer__c > PTRFTrueList = new List < Mask_Layer__c > ();
        List < AggregateResult > AggResult = new List < AggregateResult > ();
        Map < Id, List < Mask_Layer__c >> PTRFtoLayerMap = new Map < Id, List < Mask_Layer__c >> ();
        Boolean isFramePTRF = false;
        Boolean isPrimePTRF = false;
        String firstFrameId = NULL;
        String firstPrimeId = NULL;
        
        for (Mask_Layer__c newMaskLayer: [
            select Name, Mask_Layer_Number__c, PTRF__c, Tapeout__c, Sort_Order__c 
            from Mask_Layer__c 
            where PTRF__c in : setPTRFIds
                and Mask_Layer_Number__c not in ('NULL', 'null', '', null) and ptrf__r.status__c != 'Cancel'
                ORDER BY Sort_Order__c ASC
        ]) {
            
            if (PTRFtoLayerMap.containsKey(newMaskLayer.PTRF__c)) {
                List < Mask_Layer__c > LayerList = PTRFtoLayerMap.get(newMaskLayer.PTRF__c);
                LayerList.add(newMaskLayer);
                PTRFtoLayerMap.put(newMaskLayer.PTRF__c, LayerList);
            } else {
                PTRFtoLayerMap.put(newMaskLayer.PTRF__c, new List < Mask_Layer__c > {
                    newMaskLayer
                });
            }
        }
        for (MRS_Layer_Association__c newLayerObj: LayerObj) {
            if (MapLayerObjToName.containsKey(newLayerObj.Name)) {
                List < MRS_Layer_Association__c > LayerList = MapLayerObjToName.get(newLayerObj.Name);
                LayerList.add(newLayerObj);
                MapLayerObjToName.put(newLayerObj.Name, LayerList);
            } else {
                MapLayerObjToName.put(newLayerObj.Name, new List < MRS_Layer_Association__c > {
                    newLayerObj
                });
            }
        }
        tempAppenderList.clear();
        Map < String, String > TheMap = new Map < String, String > ();
        Set < String > PTRFSet = new Set < String > ();
        List < String > PTRFSortList = new List < String > ();
        List < String > PTRFSortListAfterPrimeFrameCheck = new List < String > ();
        
        //SWGP-1187
        //AggResult = [select PTRF__c from MRS_Layer_Chip_Association__c where PTRF__c in : setPTRFIds group by PTRF__C ORDER BY min(CreatedDate) ASC];
        
        AggResult = [select Id from PTRF__c where Id in : setPTRFIds group by Id ORDER BY min(CreatedDate) ASC];
        
        for (AggregateResult obj: AggResult) {
            //PTRFSortList.add(String.valueOf(obj.get('PTRF__c')));
            PTRFSortList.add(String.valueOf(obj.get('Id')));
        }
        
        Map < Id, Boolean > CheckForFrameTapeout = new Map < Id, Boolean > ();
        
        //swgp-1187
        List < PTRF__c > listPTRF = [select Id, Frame_Tapeout__c from PTRF__c where Id in : PTRFSortList];
        //listPTRF.addAll( (list<PTRF__c>) AggResult);
        
        
        for (PTRF__c t: listPTRF) {
            CheckForFrameTapeout.put(t.Id, t.Frame_Tapeout__c);
        }
        for (String PTRFId: PTRFSortList) {
            Boolean isPresentFrame = CheckForFrameTapeout.get(PTRFId);
            TempMaskLayerList = PTRFtoLayerMap.get(PTRFId);
            if (TempMaskLayerList != NULL) {
                if (!isFramePTRF) {
                    if (isPresentFrame) {
                        isFramePTRF = true;
                        firstFrameId = PTRFId;
                    } else {
                        if (!isPrimePTRF) {
                            isPrimePTRF = true;
                            firstPrimeId = PTRFId;
                        }
                    }
                }
            }
        }
        if (isFramePTRF && firstFrameId != NULL) {
            firstFramePTRF = PTRFtoLayerMap.get(firstFrameId);
            PTRFSortListAfterPrimeFrameCheck.add(String.valueOf(firstFrameId));
        } else {
            if (firstPrimeId != NULL && isPrimePTRF) {
                firstPrimePTRF = PTRFtoLayerMap.get(firstPrimeId);
                PTRFSortListAfterPrimeFrameCheck.add(String.valueOf(firstPrimeId));
            }
        }
        List < Mask_Layer__c > currentPTRF = new List < Mask_Layer__c > ();
        for (String PTRFId: PTRFSortList) {
            currentPTRF.clear();
            if (isFramePTRF && firstFrameId != NULL) {
                if (PTRFId != firstFrameId) {
                    PTRFSortListAfterPrimeFrameCheck.add(PTRFId);
                }
            } else {
                if (firstPrimeId != NULL && isPrimePTRF) {
                    if (PTRFId != firstPrimeId) {
                        PTRFSortListAfterPrimeFrameCheck.add(PTRFId);
                    }
                }
            }
        }
        for (String strSortedPTRF: PTRFSortListAfterPrimeFrameCheck) {
            currentPTRF = PTRFtoLayerMap.get(strSortedPTRF);
            if (currentPTRF != NULL) {
                for (Mask_Layer__c currentMaskLayer: currentPTRF) {
                    List < MRS_Layer_Association__c > presentInList = MapLayerObjToName.get(currentMaskLayer.Mask_Layer_Number__c);
                    List < MRS_Layer_Association__c > ListDeltaCheck = WrapperMap.get(currentMaskLayer.Mask_Layer_Number__c);
                    if (presentInList != NULL) {
                        if (ListDeltaCheck == NULL) {
                            WrapperList.addAll(presentInList);
                            WrapperMap.clear();
                            for (MRS_Layer_Association__c newLayerObj: WrapperList) {
                                if (WrapperMap.containsKey(newLayerObj.Name)) {
                                    List < MRS_Layer_Association__c > LayerList = WrapperMap.get(newLayerObj.Name);
                                    LayerList.add(newLayerObj);
                                    WrapperMap.put(newLayerObj.Name, LayerList);
                                } else {
                                    WrapperMap.put(newLayerObj.Name, new List < MRS_Layer_Association__c > {
                                        newLayerObj
                                    });
                                }
                            }
                        }
                    }
                }
            }
        }
        return WrapperList;
    }
}