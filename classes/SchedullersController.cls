/*
    Author:
    Description: This is a scheduller class for retry logic to push the outbound message for integration. 
    History:
        ARoy        04192013    - code modified for Account and Account Team Proxy to add Martinistore Integration.
        ZAmbat      04192013    - code modified to add retry logic for Lot Prefix object.
        ARoy        04262013    - modified code to add test data for the test method.
        Asolito     06102013    - added fab deletion error retry logic
        ARoy        06182013    - code modified to add retry logic for Device,Account Hierarchy, Opportunity Program Team Member
                                  and IP Form Matching Result.
        ARoy        09022013    - code modified to add retry logic for New Part Creation Form.       
        PS          11222013    - Code modified to add retry logic for BPM Device/CDRS sync.    
        TLai        11032014    - Code modified to change Fab_Deletion_Sync_Status__c to 'ERROR' in account team proxy   
        ZAmbat      07152014    - Updated code as per CASE 29910.  
        TLai        15072014    - Updated code as per case 29910    
        ZAmbat      10082014    - Updated code:  Commented out retryBPM(BPMDeviceList) and put it outside the for loop.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
*/

public class SchedullersController {
//
    public SchedullersController(Id cronTrigId){
    
      List<Retry_Logic__c> rl=[select id, name,Time_to_Recall__c, MinutesToResendRecord__c,  MaxRecordsPerObject__c, log__c from Retry_Logic__c limit 1 ];
        if(rl.size()>0)
        {
            String logUpdate = '';
            
            // Calculate the next time to run the scheduler in minutes
            integer min = Integer.valueof(rl[0].Time_to_Recall__c);
            integer recordLimit = Integer.valueof(rl[0].MaxRecordsPerObject__c);
            Datetime sysTime = System.now();
            sysTime = sysTime.addMinutes(min);
            String sch = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
 
             // Calculate datetime filter to query for records to resend for integration 
            integer resendMinutes = Integer.valueof(rl[0].MinutesToResendRecord__c);
            Datetime filterDateTime = System.now();
            if(!Test.isRunningTest()){
                filterDateTime = filterDateTime.addMinutes(0 - resendMinutes );
            }else{
                filterDateTime = System.now().addMinutes(resendMinutes);
            }  
            logUpdate =  '\n' + String.valueof(System.now()) +  'Schedule start:' + logUpdate ;
 
            // Changes made by Anirban on 04/19/2013
            List<Account> accList = new List<Account>();
            Account accObj;
            for(Account acc:[SELECT id,name, Siebel_Error_Message__c,Siebel_Sync_id__c, Martinistore_Sync_Status__c, Siebel_Status__c,
                        LastModifiedDate 
                        FROM Account 
                        WHERE LastModifiedDate < :filterDateTime and ( (Siebel_Sync_id__c !=null AND Siebel_AccountComplete__c = 'TRUE' ) AND ( Martinistore_Sync_Status__c='ERROR' or Martinistore_Sync_Status__c ='SENT') )
                        ORDER BY LastModifiedDate  ASC
                        LIMIT :recordLimit  ]){
            /*for(Account acc:[SELECT id,name, Siebel_Error_Message__c,Siebel_Sync_id__c, Martinistore_Sync_Status__c, Siebel_Status__c,
                        LastModifiedDate 
                        FROM Account 
                        WHERE LastModifiedDate < :filterDateTime and ((Siebel_Sync_id__c !=null and (Siebel_Status__c='SENT' or  Siebel_Status__c='ERROR') and 
                        Siebel_AccountComplete__c = 'TRUE') or Martinistore_Sync_Status__c='ERROR') 
                        ORDER BY LastModifiedDate  ASC
                        LIMIT :recordLimit  ]){*/
                    accObj = new Account(id=acc.id);
                    //Tlai 15072104 Commented
                    //if(acc.Siebel_Status__c=='SENT' || acc.Siebel_Status__c=='ERROR'){
                        accObj.Siebel_Sync_id__c=String.valueof(System.now());
                    //}
                    //if(acc.Martinistore_Sync_Status__c=='ERROR'){
                        accObj.name=acc.name;
                    //}
                    accList.add(accObj);
                    logUpdate =  '\n' + String.valueof(System.now()) +  'Account: (' + acc.id + ') ' + acc.name + logUpdate ;
            }
            
            List<Opportunity> oppList = new List<Opportunity>();
            for(Opportunity opp:[SELECT id,name, Siebel_Error_Message__c,Siebel_Sync_id__c, LastModifiedDate 
                        FROM Opportunity 
                        WHERE LastModifiedDate < :filterDateTime and Siebel_Sync_id__c !=null and Siebel_Opportunity_Complete__c = 'TRUE' and ( Martinistore_Sync_Status__c='ERROR' or Martinistore_Sync_Status__c ='SENT')
                        ORDER BY LastModifiedDate  ASC
                        LIMIT :recordLimit   ]){
            /*for(Opportunity opp:[SELECT id,name, Siebel_Error_Message__c,Siebel_Sync_id__c, LastModifiedDate 
                        FROM Opportunity 
                        WHERE LastModifiedDate < :filterDateTime and Siebel_Sync_id__c !=null and (Siebel_Status__c='SENT' or  Siebel_Status__c='ERROR') and Siebel_Opportunity_Complete__c = 'TRUE'
                        ORDER BY LastModifiedDate  ASC
                        LIMIT :recordLimit   ]){*/
                oppList.add(new Opportunity(id=opp.id,Siebel_Sync_id__c=String.valueof(System.now())));
                logUpdate =  '\n' + String.valueof(System.now()) +  'Opportunity: (' + opp.id + ') ' + opp.name + logUpdate ;
            }
            
            //Changes made by Anirban on 04/19/2013
            List<Account_Team_Proxy__c> atpList = new List<Account_Team_Proxy__c>();
            Account_Team_Proxy__c atpObj;
            //TLai  11032014 : Change Fab_Deletion_Sync_Status__c from 'ERRROR' to 'ERROR'
             for(Account_Team_Proxy__c atp:[SELECT id,name, Siebel_Error_Message__c, Martinistore_Sync_Status__c, Siebel_Sync_id__c, LastModifiedDate, Siebel_Status__c,Fab_Deletion_Sync_Status__c  
                        FROM Account_Team_Proxy__c WHERE LastModifiedDate < :filterDateTime and (Siebel_Sync_id__c !=null  AND (Martinistore_Sync_Status__c='ERROR' or Martinistore_Sync_Status__c ='SENT'))
                        ORDER BY LastModifiedDate  ASC
                        LIMIT :recordLimit ]){
            /*for(Account_Team_Proxy__c atp:[SELECT id,name, Siebel_Error_Message__c, Martinistore_Sync_Status__c, Siebel_Sync_id__c, LastModifiedDate, Siebel_Status__c,Fab_Deletion_Sync_Status__c  
                        FROM Account_Team_Proxy__c WHERE LastModifiedDate < :filterDateTime and ((Siebel_Sync_id__c !=null and (Siebel_Status__c='SENT' or  Siebel_Status__c='ERROR' or Fab_Deletion_Sync_Status__c = 'ERROR')) or Martinistore_Sync_Status__c='ERROR')
                        ORDER BY LastModifiedDate  ASC
                        LIMIT :recordLimit ]){*/
                atpObj = new Account_Team_Proxy__c(id=atp.id);
                //if(atp.Siebel_Status__c=='SENT' || atp.Siebel_Status__c=='ERROR' || atp.Fab_Deletion_Sync_Status__c == 'ERROR'){
                    atpObj.Siebel_Sync_id__c=String.valueof(System.now());
                //}
                /*if(atp.Martinistore_Sync_Status__c=='ERROR'){
                    atpObj.Siebel_Error_Message__c=atp.Siebel_Error_Message__c;
                }*/
                atpList.add(atpObj);
                logUpdate =  '\n' + String.valueof(System.now()) +  'AcctTeamProxy: (' + atp.id + ') ' + atp.name + logUpdate;
            }
            
            List<Device__c> devList = new List<Device__c>();
            List<Device__c> BPMDeviceList = new List<Device__c>();//list to store BPM request sent devices.
            /*for(Device__c dev:[SELECT id,name, Siebel_Error_Message__c, Siebel_Sync_id__c,BPM_Status__c, LastModifiedDate  
                        FROM Device__c WHERE LastModifiedDate < :filterDateTime and Siebel_Sync_id__c !=null 
                        and (Siebel_Status__c='SENT' or  Siebel_Status__c='ERROR' 
                        or Martinistore_Sync_Status__c='SENT' or Martinistore_Sync_Status__c='ERROR' 
                        OR (BPM_Status__c != NULL AND BPM_Status__c != 'SUCCESS') )
                        ORDER BY LastModifiedDate  ASC
                        LIMIT :recordLimit ]){*/
                        
            // ZAmbat 07152014
            for(Device__c dev : [SELECT     id
                                            , name
                                            , Siebel_Error_Message__c
                                            , Siebel_Sync_id__c
                                            , BPM_Status__c
                                            , LastModifiedDate  
                                 FROM       Device__c 
                                 WHERE      LastModifiedDate < :filterDateTime 
                                            AND Siebel_Sync_id__c != null
                                            AND (Martinistore_Sync_Status__c='SENT' 
                                                 OR Martinistore_Sync_Status__c='ERROR' 
                                                 OR (BPM_Status__c != NULL AND BPM_Status__c != 'SUCCESS'))
                                 ORDER BY   LastModifiedDate  ASC
                                 LIMIT      :recordLimit ]) {            
                devList.add(new Device__c(id=dev.id,Siebel_Sync_id__c=String.valueof(System.now()))); 
                
                //PS : 11222013 creating BPM list
                if(dev.BPM_Status__c != NULL && dev.BPM_Status__c != 'SUCCESS'){
                    BPMDeviceList.add(dev);    
                }
                
                logUpdate =  '\n' + String.valueof(System.now()) +  'Device: (' + dev.id + ') ' + dev.name + logUpdate; 
                // ZAmbat 10082014
                //retryBPM(BPMDeviceList);
                        
            }
            // ZAmbat 10082014
            retryBPM(BPMDeviceList);
            
            // ZAmbat 04/19/2013
            List<Lot_Prefix__c> lpList = new List<Lot_Prefix__c>();
            for (Lot_Prefix__c lp : [SELECT     Id
                                                , Name
                                                , Martinistore_Sync_Status__c
                                                , Last_Sync_to_Martinistore_Status__c
                                     FROM       Lot_Prefix__c
                                     WHERE      LastModifiedDate < :filterDateTime
                                                AND (Martinistore_Sync_Status__c = 'SENT' 
                                                    OR Martinistore_Sync_Status__c = 'ERROR')]) {
                lpList.add(lp);
                logUpdate =  '\n' + String.valueof(System.now()) +  'Lot Prefix: (' + lp.Id + ') ' + lp.Name + logUpdate ;
            }
            
            //=====Account Hierarchy=======//
            List<Account_Hierarchy__c> ahList = new List<Account_Hierarchy__c>();
            for (Account_Hierarchy__c ah : [SELECT      Id
                                                        , Name
                                                        , Martinistore_Sync_Status__c
                                                        , Last_Sync_to_Martinistore_Status__c
                                            FROM        Account_Hierarchy__c
                                            WHERE       LastModifiedDate < :filterDateTime
                                                AND (Martinistore_Sync_Status__c = 'SENT' 
                                                    OR Martinistore_Sync_Status__c = 'ERROR')]) {
                ahList.add(ah);
                logUpdate =  '\n' + String.valueof(System.now()) +  'Account Hierarchy: (' + ah.Id + ') ' + ah.Name + logUpdate ;                                       
            }
            
            //=====Opportunity Program Team Member=======//
            List<Opportunity_Program_Team_Member__c> opTmList = new List<Opportunity_Program_Team_Member__c>();
            for (Opportunity_Program_Team_Member__c opTm : [SELECT      Id
                                                        , Name
                                                        , Martinistore_Sync_Status__c
                                            FROM        Opportunity_Program_Team_Member__c
                                            WHERE       LastModifiedDate < :filterDateTime
                                                AND (Martinistore_Sync_Status__c = 'SENT' 
                                                    OR Martinistore_Sync_Status__c = 'ERROR')]) {
                opTmList.add(opTm);
                logUpdate =  '\n' + String.valueof(System.now()) +  'Opportunity Program Team Member: (' + opTm.Id + ') ' + opTm.Name + logUpdate ;                                     
            }
            
            //=========IP Matching Result============//
            List<IP_Form_Matching_Result__c> ipFrmMatResList = new List<IP_Form_Matching_Result__c>();
            for (IP_Form_Matching_Result__c ipFrmMatRes : [SELECT       Id
                                                                        , Name
                                                                        , Martinistore_Sync_Status__c                                               
                                                            FROM        IP_Form_Matching_Result__c
                                                            WHERE       LastModifiedDate < :filterDateTime
                                                                AND (Martinistore_Sync_Status__c = 'SENT' 
                                                                    OR Martinistore_Sync_Status__c = 'ERROR')]) {
                ipFrmMatResList.add(ipFrmMatRes);
                logUpdate =  '\n' + String.valueof(System.now()) +  'IP Form Matching Result: (' + ipFrmMatRes.Id + ') ' + ipFrmMatRes.Name + logUpdate ;                                       
            }
            
            //============New Part Creation Form==========//
            List<New_Part_Creation_Form__c> npcList = new List<New_Part_Creation_Form__c>();
            for (New_Part_Creation_Form__c npc : [SELECT        Id
                                                                , Name
                                                                , PLM_Sync_Status__c
                                                                , Last_Sync_to_PLM_Status__c
                                                     FROM       New_Part_Creation_Form__c
                                                     WHERE      LastModifiedDate < :filterDateTime
                                                                AND (PLM_Sync_Status__c = 'SENT' 
                                                                    OR PLM_Sync_Status__c = 'ERROR')]) {
                npcList.add(npc);
                logUpdate =  '\n' + String.valueof(System.now()) +  'New Part Creation Form: (' + npc.Id + ') ' + npc.Name + logUpdate ;
            }
            
            //=====New Part Creation Form=======//
            try {
                if (npcList.size() > 0) {
                    update npcList;  
                }
            } catch (System.Dmlexception e) {
                for (Integer i = 0; i < e.getNumDml(); i++) {
                      logUpdate =  '\n' + String.valueof(System.now()) +  'New Part Creation Form: (' + e.getDmlMessage(i) + ') ' + logUpdate;
                }
            }           
                                          
            //=====Account Hierarchy=======//
            try {
                if (ahList.size() > 0) {
                    update ahList;  
                }
            } catch (System.Dmlexception e) {
                for (Integer i = 0; i < e.getNumDml(); i++) {
                      logUpdate =  '\n' + String.valueof(System.now()) +  'Account Hierarchy: (' + e.getDmlMessage(i) + ') ' + logUpdate;
                }
            }
            
            //=====Opportunity Program Team Member=======//
            try {
                if (opTmList.size() > 0) {
                    update opTmList;  
                }
            } catch (System.Dmlexception e) {
                for (Integer i = 0; i < e.getNumDml(); i++) {
                      logUpdate =  '\n' + String.valueof(System.now()) +  'Opportunity Program Team Member: (' + e.getDmlMessage(i) + ') ' + logUpdate;
                }
            }
            
            //========IP Matching Result========//
            try {
                if (ipFrmMatResList.size() > 0) {
                    update ipFrmMatResList;  
                }
            } catch (System.Dmlexception e) {
                for (Integer i = 0; i < e.getNumDml(); i++) {
                      logUpdate =  '\n' + String.valueof(System.now()) +  'IP Form Matching Result: (' + e.getDmlMessage(i) + ') ' + logUpdate;
                }
            }
            
            // ZAmbat 04/19/2013
            try {
                if (lpList.size() > 0) {
                    Update lpList;  
                }
            } catch (System.Dmlexception e) {
                for (Integer i = 0; i < e.getNumDml(); i++) {
                      logUpdate =  '\n' + String.valueof(System.now()) +  'Lot Prefix: (' + e.getDmlMessage(i) + ') ' + logUpdate;
                }
            }
            
            try {
                if(accList.size()>0) {
                    update accList;
                }
            } catch (System.DmlException e) {
                for (Integer i = 0; i < e.getNumDml(); i++) {
                      logUpdate =  '\n' + String.valueof(System.now()) +  'Acct: (' + e.getDmlMessage(i) + ') ' + logUpdate;
                 }
            }   
                
            try {
                if(oppList.size()>0){ 
                    update oppList;
                }
            } catch (System.DmlException e) {
                for (Integer i = 0; i < e.getNumDml(); i++) {
                      logUpdate =  '\n' + String.valueof(System.now()) +  'Oppty: (' + e.getDmlMessage(i) + ') ' + logUpdate;
                 }
            }              
            
            try {
                if(atpList.size()>0) {
                    update atpList; 
                }
            } catch (System.DmlException e) {
                for (Integer i = 0; i < e.getNumDml(); i++) {
                      logUpdate =  '\n' + String.valueof(System.now()) +  'AcctProxy: (' + e.getDmlMessage(i) + ') ' + logUpdate;
                 }
            }
            
            try {
                if(devList.size()>0) {
                    update devList;
                }
            } catch (System.DmlException e) {
                for (Integer i = 0; i < e.getNumDml(); i++) {
                      logUpdate =  '\n' + String.valueof(System.now()) +  'Device: (' + e.getDmlMessage(i) + ') ' + logUpdate;
                 }
            }                  

            
            rl[0].log__c = 'Last Run :' + String.valueof(System.now());
            update rl[0];
            
            Schedulers s = new Schedulers();
            String jobID = System.schedule('Schedulers' + sysTime.getTime(),sch, s);
            System.debug('New Job Id for Schedulers' + sysTime.getTime() + ' : ' + jobID);
            System.debug(logUpdate);
            System.abortJob(cronTrigId);
            
        } 
     }  
     
     /**************************************** BPM method to call web service: Start **************************************
         @Method Name:    retryBPM
         @Return Type:    Void
         @parameter:      List<Device>
         @Reason:         This method calls web service method to integrate with BPM system.
     **********************************************************************************************************************/
     public void retryBPM(List<Device__c>  DeviceList){
         for(Device__c dev : DeviceList){
             if( !Test.isRunningTest() && !system.isBatch() && !system.isFuture()){
                 //call web method for integration with BPM 
                 BPMDeviceIntegration.deviceBPMSFDCIntegrationMethod(dev.id,false);
             }
         }
     }
        
     /**************************************** BPM method to call web service: End *****************************************/     
}