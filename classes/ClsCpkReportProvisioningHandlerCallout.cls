/*------------------------------------------------------------  
Author:        Amar Smruti Pattanaik
Company:       CTS
Description:   This class is used to identify Account change and make callout to OT for provisioning/De-provisioning.
  History:
  ASPattanaik 24102016 - Class Creation.
--------------------------------------------------------------*/
global without sharing class ClsCpkReportProvisioningHandlerCallout {

    global static Map<Id,List<CPK_Report_Access_List__c>> associateCustMap = new Map<Id,List<CPK_Report_Access_List__c>>();
    global static String sfdcId; //to store associate customer ID
    @Future(callout = true)
    //This method is used to identify Account level change in Authorized_for_ASIC_business__c and make call out to OT for provisioning & De-provisioning
    public static void customerCpkProvisioningUpdateASICFuture(Map<Id,String> accNewValMap,Map<Id,String> accOldValMap){

        customerCpkProvisioningUpdateASIC(accNewValMap,accOldValMap);
    }
    
    @future(callout = true)
        public static void callutmethod(String accId, Integer Opid, String sfId, String Act){
            deprovisionCallOut(accId,Opid,sfId,Act);
        }
    
    
    //synchronous call
    public static void customerCpkProvisioningUpdateASIC(Map<Id,String> accNewValMap,Map<Id,String> accOldValMap){
            
            //List to store cpkreports
            List<CPK_Report__c> cpkReportList = new List<CPK_Report__c>(); 
            cpkReportList = [SELECT Id,Name,For_All_ASIC_Customers__c,ASIC_Report__c FROM CPK_Report__c WHERE ASIC_Report__c = 'ASIC'];

            //Map to store Associate customers
            Map<Id,CPK_Report_Access_List__c> accessList = new Map<Id,CPK_Report_Access_List__c>([SELECT Account__c,CPK_Report__c,Account__r.Short_Name__c,CPK_Report__r.OpenTextIdPublish__c,CPK_Report__r.ASIC_Report__c, Id FROM CPK_Report_Access_List__c WHERE CPK_Report__c != null AND Account__r.Authorized_for_ASIC_business__c = 'No' ]);
 
            List<CPK_Report_Access_List__c> associateCustList = new List<CPK_Report_Access_List__c>();
            List<CPK_Report_Access_List__c> associateCustomerList = new List<CPK_Report_Access_List__c>();
            List<String> accOpenTextList = new List<String>();
            List<String> accOpenTextListPro = new List<String>();
            Set<Id> setOfIds = new Set<Id>();
            Set<Id> accIds = new Set<id>();
            //list of Accounts for trigger.old
            list<account> oldtrigger=new list<account>();
            //list of Account for Trigger.new
            list<account> newtrigger=new list<account>(); 
            for(Id accId : accOldValMap.keySet()){
                  String fieldValList1=accOldValMap.get(accId);
                  String fieldValList2=accNewValMap.get(accId);
                  Account accOldRec=new Account();
                  Account accNewRec=new Account();
                  accOldRec.Id=accId ;
                  accNewRec.Id=accId ;
                  if(!string.isEmpty(fieldValList1)) {
                      accOldRec.Authorized_for_ASIC_business__c = fieldValList1;
                  }
                  else{
                        accOldRec.Authorized_for_ASIC_business__c = '';
                  }
                  if(!string.isEmpty(fieldValList2)){
                      accNewRec.Authorized_for_ASIC_business__c = fieldValList2; 
                  }
                  else{
                        accNewRec.Authorized_for_ASIC_business__c = '';               
                  }

                  oldtrigger.add(accOldRec);
                  newtrigger.add(accNewRec); 
                  
            }

 
             for(integer i = 0; i< newtrigger.size(); i++){       
            
                if(newtrigger[i].Authorized_for_ASIC_business__c == 'Yes' && oldtrigger[i].Authorized_for_ASIC_business__c == 'No'){ 
                  if(cpkReportList.size() > 0){
                    for(CPK_Report__c cc : cpkReportList){
                          for(Account Acc : newtrigger){
                            System.debug('******acc'+acc);
                            accIds.add(Acc.id);
                            // for associating accounts with ASIC Business 'Yes' and For All ASIC 'Yes'
                            if(acc.Authorized_for_ASIC_business__c == 'Yes' && cc.For_All_ASIC_Customers__c == 'Yes'){
                                  CPK_Report_Access_List__c ascl = new CPK_Report_Access_List__c();
                                  ascl.CPK_Report__c = cc.Id;
                                  ascl.Account__c = Acc.Id;
                                  associateCustList.add(ascl); 
                            }
                            try{

                                  
                                  if(associateCustList.size()>0){
                                      // inserting new access list records and associating accounts with cpk reports
                                      Database.SaveResult[] srList = Database.insert(associateCustList, false);
                                      for (Database.SaveResult sr : srList) {
                                          if(sr.isSuccess()){ 
                                                setOfIds.add(sr.getId());
                                              }
                                          }
                                      }


                                      
                              }catch(Exception e){ 
                              }

                          }
                        }

                        
                  }
                }else if(newtrigger[i].Authorized_for_ASIC_business__c == 'No' && oldtrigger[i].Authorized_for_ASIC_business__c == 'Yes'){
                  System.debug('in else block of Authorized_for_ASIC_business__c');
                  for(Account ac: newtrigger){
                      accIds.add(ac.id);
                  }
                  
                  

                  for(CPK_Report_Access_List__c cr : accessList.values()){
                    if(accIds.contains(cr.Account__c) && cr.CPK_Report__c != null && cr.CPK_Report__r.ASIC_Report__c == 'ASIC'){
                        if(cr.Account__r.Short_Name__c != null && cr.CPK_Report__r.OpenTextIdPublish__c != null){
                              accOpenTextListPro.add(cr.Account__r.Short_Name__c+'-'+cr.CPK_Report__r.OpenTextIdPublish__c+'-'+cr.Id);
                        }
                          associateCustomerList.add(cr);
                      } 
                  }
                  }

                  try{
                        // deprovisioning callout to Open Text happens here
                        if(Environment_Variable__c.getInstance('CPK_service_enable').value__c != 'false'){
                            if(accOpenTextListPro != null && accOpenTextListPro.size()>0){
                                String Action = 'Deprovision'; 
                                for(String str : accOpenTextListPro){
                                   String[] accOtId = str.split('-'); 
                                   deprovisionCallOut(accOtId[0],Integer.valueOf(accOtId[1]),accOtId[2],Action);
                                   
                                }
                            }
                            
                        }
                      }catch(Exception e){
                       
                         GlobalUtility.logMessage('Error', 'ClsCpkReportProvisioningHandlerCallout', 
                                                       'ClsCpkReportProvisioningHandlerCallout Error','','CPKReport','Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),'','CPK DeProvisioning',e,2300);
                        }
                
              //}
            }
            
            
            if(setOfIds != null && setOfIds.size()>0){
                List<CPK_Report_Access_List__c> tempList = [SELECT Id, Account__c, CPK_Report__c, CPK_Report__r.ASIC_Report__c, Account__r.Short_Name__c, CPK_Report__r.OpenTextIdPublish__c FROM CPK_Report_Access_List__c where Id IN: setOfIds]; 
                for(CPK_Report_Access_List__c cr : tempList){
                    if(accIds.contains(cr.Account__c) && cr.CPK_Report__c != null && cr.CPK_Report__r.ASIC_Report__c == 'ASIC'){
                        if(cr.Account__r.Short_Name__c != null && cr.CPK_Report__r.OpenTextIdPublish__c != null){
                              accOpenTextList.add(cr.Account__r.Short_Name__c+'-'+cr.CPK_Report__r.OpenTextIdPublish__c);
                        }
                          
                      } 
                }   
                                  
                if(Environment_Variable__c.getInstance('CPK_service_enable').value__c != 'false'){
                    if(accOpenTextList != null && accOpenTextList.size()>0){
                        String Action = 'Provision';
                        sfdcId = 'NA';
                        for(String str : accOpenTextList){
                            String[] accOtId = str.split('-');
                            callutmethod(accOtId[0],Integer.valueOf(accOtId[1]),sfdcId,Action);
                             
                        }
                      }
                 }
            }
            
            if(associateCustomerList.size() >0){
                /// deleting associated customers for All ASIC 'No' - Deprovisioning
                Utility.CPK_ACCESS_LIST_TRIGGER_RUNNING = true;
                delete associateCustomerList;
            }
    

    }



    @Future(callout = true)
    //This method is used to identify Account level change in Has_Valid_NDA__c,Valid_Tech_Geos__c,Tech_Geo_Granted__c and make call out to OT for provisioning & De-provisioning
    public static void customerCpkProvisioningUpdateGeometryFuture(Map<Id,String> accNewValMap,Map<Id,String> accOldValMap){

        customerCpkProvisioningUpdateGeometry(accNewValMap,accOldValMap);
    }


    //synchronous call
    public static void customerCpkProvisioningUpdateGeometry(Map<Id,String> accNewValMap,Map<Id,String> accOldValMap){

         
        //list of Accounts for trigger.old
        list<account> oldtrigger = new list<account>();
        //list of Account for Trigger.new
        list<account> newtrigger = new list<account>();
        for(Id accId : accOldValMap.keySet()){

            List<String> fieldValList1 = accOldValMap.get(accId).split('#');
            List<String> fieldValList2 = accNewValMap.get(accId).split('#');

            Account accOldRec = new Account();
            Account accNewRec = new Account();

            accOldRec.Id = accId;
            accNewRec.Id = accId;

            if(!fieldValList1.isEmpty()) {
                  accOldRec.Valid_Tech_Geos__c=(fieldValList1.get(0)!=null)?fieldValList1.get(0):'';
                  accOldRec.Tech_Geo_Granted__c =(fieldValList1.get(1)!=null)?fieldValList1.get(1):'';
                  accOldRec.Has_Valid_NDA__c=(fieldValList1.get(2)!=null && fieldValList1.get(2).equalsIgnoreCase('true'))?true:false;
              }

            if(!fieldValList2.isEmpty()){
                    accNewRec.Valid_Tech_Geos__c=(fieldValList2.get(0)!=null)?fieldValList2.get(0):'';
                  accNewRec.Tech_Geo_Granted__c =(fieldValList2.get(1)!=null)?fieldValList2.get(1):'';
                  accNewRec.Has_Valid_NDA__c=(fieldValList2.get(2)!=null && fieldValList2.get(2).equalsIgnoreCase('true'))?true:false;
              }
              
              oldtrigger.add(accOldRec);
              newtrigger.add(accNewRec);
 
        }
             customerCpkProvisioningUpdate(newtrigger,oldtrigger);

    }

    
    public static void customerCpkProvisioningUpdate(list<account> newtrigger, list<account> oldtrigger){

      //to store acc Ids those have NDA expired     
        set<String> accidsNDAexpire = new set<String>();


      //to store acc Ids those have NDA active
      set<String> accidsNDAactivated = new set<String>();              
      //to store acc Ids those have Authorized for asic business = Yes
      //set<String> accidsASICActivated = new set<String>();
      //to store acc Ids those have Authorized for asic business = NO
      //set<String> accidsASICDeactivated = new set<String>();
      //to store acc IDs for Valid Tech Geos added
      set<String> accidsTechactivated = new set<String>();
      //to store acc Ids for Valid Tech Geos removed
      set<String> accidsTechexpire = new set<String>();
      //to store acc Ids for Tech Geos Granted added
      set<Id> accidsTechGranted = new set<Id>();
      //to store acc Ids for Tech Geos Granted added
      set<String> accidsTechRemoved = new set<String>();
      //map to store ASIC accounts
      //map<ID,Account> mapAccASIC = new map<ID,Account>();
      //map to store Vaid Tech Geo and accounts
      map<id,set<string>> mapAccTechActivated = new map<id,set<string>>();
      //map to store removed Valid Tech Geos and Accounts
      map<id,set<String>> mapAccTechExpire = new map<id,set<String>>();
      //map to store Tech Geos granted and Accounts added
      map<id,set<String>> mapAccTechGranted = new map<id,set<String>>();
      //map to store Tech Geos granted and Accounts removed
      map<id,set<String>> mapAccTechRemoved = new map<id,set<String>>();
      List<CPK_Report_Access_List__c> associateCustomerListGeo = new List<CPK_Report_Access_List__c>();
      List<String> accOpenTextListDepro = new List<String>();
      List<CPK_Report_Access_List__c> associateCustList = new List<CPK_Report_Access_List__c>();
      Set<Id> setOfIds = new Set<Id>();
      List<String> accOpenTextList = new List<String>();
      
      List<CPK_Report__c> cpkReportList = new List<CPK_Report__c>();
      cpkReportList =[SELECT Id,Name,For_All_ASIC_Customers__c,ASIC_Report__c,Geometry__c FROM CPK_Report__c WHERE ASIC_Report__c = 'Geometry'];
      
      

      //process valid Tech Geo via NDA
      for(integer i = 0; i< newtrigger.size(); i++){
        if(newtrigger[i].Has_Valid_NDA__c == false && oldtrigger[i].Has_Valid_NDA__c == true){
          accidsNDAexpire.add(String.ValueOf(newtrigger[i].id));
        }
        if(newtrigger[i].Has_Valid_NDA__c == true && oldtrigger[i].Has_Valid_NDA__c == false){
          accidsNDAactivated.add(String.ValueOf(newtrigger[i].id));
        }


         
        if(newtrigger[i].Valid_Tech_Geos__c!=oldtrigger[i].Valid_Tech_Geos__c){
            
          if(newtrigger[i].Valid_Tech_Geos__c!=null && oldtrigger[i].Valid_Tech_Geos__c!=null){
            
            for(string s :newtrigger[i].Valid_Tech_Geos__c.split(';')){
                
    
                if(s.length()>5 && oldtrigger[i].Valid_Tech_Geos__c!=null && !oldtrigger[i].Valid_Tech_Geos__c.contains(s.substring(0,6))){
                    
    
                    if(mapAccTechActivated!=null && mapAccTechActivated.containskey(newtrigger[i].id)){
                        
                        set<string> temp=new set<string>();
                        temp=mapAccTechActivated.get(newtrigger[i].id);
                        temp.add(s.substring(0,6));
                        mapAccTechActivated.put(newtrigger[i].id,temp);
                        accidsTechactivated.add(newtrigger[i].id);
                    }
                    else{
                        
    
                        set<string> temp=new set<string>();
                        temp.add(s.substring(0,6));
                        mapAccTechActivated.put(newtrigger[i].id,temp);
                        accidsTechactivated.add(newtrigger[i].id);
                    }    
                }
            }
            for(string s :oldtrigger[i].Valid_Tech_Geos__c.split(';')){
              
                if(s.length()>5 && newtrigger[i].Valid_Tech_Geos__c!=null && !newtrigger[i].Valid_Tech_Geos__c.contains(s.substring(0,6))){
                    if(mapAccTechExpire!=null && mapAccTechExpire.containskey(newtrigger[i].id)){
                       
                        set<string> temp=new set<string>();
                        temp=mapAccTechExpire.get(newtrigger[i].id);
                        temp.add(s.substring(0,6));
                        mapAccTechExpire.put(newtrigger[i].id,temp);
                        accidsTechexpire.add(newtrigger[i].id);
                    }
                    else{
                        set<string> temp=new set<string>();
                        temp.add(s.substring(0,6));
                        mapAccTechExpire.put(newtrigger[i].id,temp);
                        accidsTechexpire.add(newtrigger[i].id);
                    }    
                }
            }
          }
           
        }

        // Process Manually granted tech geos at account
       

        
        if(newtrigger[i].Tech_Geo_Granted__c!=oldtrigger[i].Tech_Geo_Granted__c){
          if(newtrigger[i].Tech_Geo_Granted__c!=null && oldtrigger[i].Tech_Geo_Granted__c!=null){
            if(newtrigger[i].Has_Valid_NDA__c == true){
                for(string s :newtrigger[i].Tech_Geo_Granted__c.split(';')){
                    if(s.length()>5 && !oldtrigger[i].Tech_Geo_Granted__c.contains(s.substring(0,6))){
                        if(mapAccTechGranted!=null && mapAccTechGranted.containskey(newtrigger[i].id)){
                            set<string> temp=new set<string>();
                            temp=mapAccTechGranted.get(newtrigger[i].id);
                            temp.add(s.substring(0,6));
                            mapAccTechGranted.put(newtrigger[i].id,temp);
                            accidsTechGranted.add(newtrigger[i].id);
                        }
                        else{
                            set<string> temp=new set<string>();
                            temp.add(s.substring(0,6));
                            mapAccTechGranted.put(newtrigger[i].id,temp);
                            accidsTechGranted.add(newtrigger[i].id);
                        }    
                    }
                }
            }
            for(string s :oldtrigger[i].Tech_Geo_Granted__c.split(';')){
                if(s.length()>5 && !newtrigger[i].Tech_Geo_Granted__c.contains(s.substring(0,6))){
                    if(mapAccTechRemoved!=null && mapAccTechRemoved.containskey(newtrigger[i].id)){
                        set<string> temp=new set<string>();
                        temp=mapAccTechRemoved.get(newtrigger[i].id);
                        temp.add(s.substring(0,6));
                        mapAccTechRemoved.put(newtrigger[i].id,temp);
                        accidsTechRemoved.add(newtrigger[i].id);
                    }
                    else{
                        set<string> temp=new set<string>();
                        temp.add(s.substring(0,6));
                        mapAccTechRemoved.put(newtrigger[i].id,temp);
                        accidsTechRemoved.add(newtrigger[i].id);
                    }    
                }
            }
          }
         
          
        }
      }
      //for provisioning 
          if(accidsTechGranted != null && mapAccTechGranted!= null){
          
         
            if(cpkReportList.size() > 0){
                for(CPK_Report__c cc : cpkReportList){
                    for(Id acc: accidsTechGranted){
                        if(cc.For_All_ASIC_Customers__c == 'Yes' && cc.ASIC_Report__c == 'Geometry' && mapAccTechGranted.get(acc)!=null && mapAccTechGranted.get(acc).contains(cc.Geometry__c.substring(0,6))){ 
                                      CPK_Report_Access_List__c ascl = new CPK_Report_Access_List__c();
                                      ascl.CPK_Report__c = cc.Id;
                                      ascl.Account__c = Acc;
                                      associateCustList.add(ascl); 
                        }
                    }       
                }
                
                try{

                                  
                      if(associateCustList.size()>0){
                          // inserting new access list records and associating accounts with cpk reports
                          Database.SaveResult[] srList = Database.insert(associateCustList, false);
                          for (Database.SaveResult sr : srList) {
                              if(sr.isSuccess()){ 
                                    setOfIds.add(sr.getId());
                                  }
                              }
                          }
               
                    }catch(Exception e){ 
                        }
            }
            if(setOfIds != null && setOfIds.size()>0){
                List<CPK_Report_Access_List__c> tempList = [SELECT Id, Account__c, CPK_Report__c, CPK_Report__r.ASIC_Report__c, Account__r.Short_Name__c, CPK_Report__r.OpenTextIdPublish__c FROM CPK_Report_Access_List__c where Id IN: setOfIds]; 
                for(CPK_Report_Access_List__c cr : tempList){
                    for(Id acc: accidsTechGranted){
                        if(acc == cr.Account__c && cr.CPK_Report__c != null && cr.CPK_Report__r.ASIC_Report__c == 'Geometry'){
                            if(cr.Account__r.Short_Name__c != null && cr.CPK_Report__r.OpenTextIdPublish__c != null){
                                  accOpenTextList.add(cr.Account__r.Short_Name__c+'-'+cr.CPK_Report__r.OpenTextIdPublish__c);
                            }
                              
                          }
                    } 
                }   
                                  
                if(Environment_Variable__c.getInstance('CPK_service_enable').value__c != 'false'){
                    if(accOpenTextList != null && accOpenTextList.size()>0){
                        String Action = 'Provision';
                        sfdcId = 'NA';
                        for(String str : accOpenTextList){
                            String[] accOtId = str.split('-');
                            callutmethod(accOtId[0],Integer.valueOf(accOtId[1]),sfdcId,Action);
                             
                        }
                      }
                 }
            }
          }
          
          
          //for deprovisioning logic
           
            if(accidsTechRemoved != null && mapAccTechRemoved!= null){  
                Map<Id,CPK_Report_Access_List__c> mapAccessReportListTechRemoved = new Map<Id,CPK_Report_Access_List__c>([SELECT Id,Account__c,CPK_Report__c,Account__r.Short_Name__c,CPK_Report__r.OpenTextIdPublish__c,CPK_Report__r.ASIC_Report__c,CPK_Report__r.Geometry__c FROM CPK_Report_Access_List__c WHERE CPK_Report__c != null AND CPK_Report__r.ASIC_Report__c ='Geometry' AND Account__c IN: accidsTechRemoved]);
             
                for(CPK_Report_Access_List__c cr : mapAccessReportListTechRemoved.values()){ 
                    if(accidsTechRemoved.contains(cr.Account__c) && cr.CPK_Report__c != null && cr.CPK_Report__r.ASIC_Report__c == 'Geometry' && mapAccTechRemoved.get(cr.account__c)!=null && mapAccTechRemoved.get(cr.Account__c).contains(cr.CPK_Report__r.Geometry__c.substring(0,6))){ 
                        if(cr.Account__r.Short_Name__c != null && cr.CPK_Report__r.OpenTextIdPublish__c != null){
                              accOpenTextListDepro.add(cr.Account__r.Short_Name__c+'-'+cr.CPK_Report__r.OpenTextIdPublish__c+'-'+cr.Id);
                        }
                          associateCustomerListGeo.add(cr);
                      } 
                  }
                   
                  try{
                        // deprovisioning callout to Open Text happens here
                        if(Environment_Variable__c.getInstance('CPK_service_enable').value__c != 'false'){
                            if(accOpenTextListDepro != null && accOpenTextListDepro.size()>0){
                                String Action = 'Deprovision'; 
                                for(String str : accOpenTextListDepro){
                                   String[] accOtId = str.split('-'); 
                                   deprovisionCallOut(accOtId[0],Integer.valueOf(accOtId[1]),accOtId[2],Action);
                                   
                                }
                            }
                            
                        }
                      }catch(Exception e){
                       
                         GlobalUtility.logMessage('Error','ClsCpkReportProvisioningHandlerCallout','ClsCpkReportProvisioningHandlerCallout Error','','CPKReport','Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),'','CPK DeProvisioning',e,2300);
                        }
                
                 
            } 
                    if(associateCustomerListGeo.size() >0){
                        /// deleting associated customers for All ASIC 'No' - Deprovisioning
                        Utility.CPK_ACCESS_LIST_TRIGGER_RUNNING = true;
                        delete associateCustomerListGeo;
                    }           
        
    }


      /*
   This method is used for making deprovisioning callout to with account short names and open text ids

  */
  public static void deprovisionCallOut(String accName, Integer otId,String sfId,String action){
       
        DocumentDeprovisioningService.DocumentDeProvisioningService_pt deprovisionRequest = new DocumentDeprovisioningService.DocumentDeProvisioningService_pt(); 
        deprovisionRequest.timeout_x=120000;
        List<DocumentDeprovisioningService.DeProvisionRequest_element> lstFCrequests = new List<DocumentDeprovisioningService.DeProvisionRequest_element>();
        
        List<DocumentDeprovisioningService.Response> FCresponse = new List<DocumentDeprovisioningService.Response>(); 
        DocumentDeprovisioningService.DeProvisionRequest_element FCrequest= new DocumentDeprovisioningService.DeProvisionRequest_element();
        List<DocumentDeprovisioningService.DeProvision> FolderList=new List<DocumentDeprovisioningService.DeProvision>();
        DocumentDeprovisioningService.DeProvision createfolderrequest = new DocumentDeprovisioningService.DeProvision();
        createfolderrequest.Source='CPK';
        createfolderrequest.OTID=otId;
        createfolderrequest.SFDCId= sfId; 
        createfolderrequest.Action=action;
        createfolderrequest.UserName=accName;
        FolderList.add(createfolderrequest); 
        FCrequest.DeProvisionList=FolderList;
        lstFCrequests.add(FCrequest);
        
        if(!Test.isRunningTest()){
            try{
                
                        deprovisionRequest.clientCertName_x=Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE').Value__c;
                
                FCResponse=deprovisionRequest.process(FolderList);
            }catch(Exception e){
                 
            }
        }
        else{
            List<DocumentDeprovisioningService.Response> FCDummyresponse=new List<DocumentDeprovisioningService.Response>();
            DocumentDeprovisioningService.Response res=new DocumentDeprovisioningService.Response();
            res.ReturnStatus ='Success';
            FCDummyresponse.add(res);
            FCResponse=FCDummyresponse;
        }
         
        if(FCResponse[0].ReturnStatus.contains('Success')){ 
        }
                    
   }
}