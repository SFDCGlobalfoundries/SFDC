/*
    Author:      Deepti Narayan Biswal
    Description: This class makes callouts to OpenText for created CPK Report Folder every month.

    History:
    DBiswal    02112015 - Class Creation.
*/
global class batchMonthlycpkReportFolderCallout implements Database.batchable<sObject>,Database.AllowsCallouts{
    
   global Database.QueryLocator start(Database.BatchableContext BC){
      String query = 'SELECT Id,name,OpenTextId__c,ParentOpenTextId__c,Sync_to_OpenText__c FROM Monthly_CPK_Report__c WHERE Sync_to_OpenText__c = true';
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, 
                       List<Monthly_CPK_Report__c> scope){
      
      //Callout to OpenText
      for(Monthly_CPK_Report__c QueryRecord : scope){
            try{
                String ReportName=QueryRecord.name;
                String CPKOTId=QueryRecord.OpenTextId__c;
                System.debug('&&&&&&'+QueryRecord.id);
                System.debug('&&&&&&'+ReportName);
                System.debug('&&&&&&'+QueryRecord.ParentOpenTextId__c);
                if(CPKOTId==null || CPKOTId==''){            
                    String StatusMessage;
                    QualityService.QACreateFolderService_pt Folderequest = new QualityService.QACreateFolderService_pt();
                    Folderequest.timeout_x=120000;
                    List<QualityService.CreateFolderRequest_element> lstFCrequests = new List<QualityService.CreateFolderRequest_element>();
                
                    List<QualityService.Response> FCresponse = new List<QualityService.Response>();
                    QualityService.CreateFolderRequest_element FCrequest= new QualityService.CreateFolderRequest_element();
                    List<QualityService.CreateFolder> FolderList=new List<QualityService.CreateFolder>();
                    QualityService.CreateFolder createfolderrequest = new QualityService.CreateFolder();
                    createfolderrequest.Source='CPK';
                    createfolderrequest.OpenTextId='';
                    createfolderrequest.ParentOpenTextId=QueryRecord.ParentOpenTextId__c;
                    createfolderrequest.FolderName=ReportName;
                    FolderList.add(createfolderrequest);
                    FCrequest.CreateFolderList=FolderList;
                    lstFCrequests.add(FCrequest);
                    if(!Test.isRunningTest()){
                        if(Environment_Variable__c.getInstance('ROS_GEForm_certificate_enable').value__c != 'false'){
                            Folderequest.clientCertName_x=Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE').Value__c;
                        }
                        FCResponse=Folderequest.CreateFolder(FolderList);
                    }
                    else{
                        List<QualityService.Response> FCDummyresponse=new List<QualityService.Response>();
                        QualityService.Response res=new QualityService.Response();
                
                        res.Status='Success';
                        res.OpenTextId='1222222'+';';
                        FCDummyresponse.add(res);
                        FCResponse=FCDummyresponse;               
                    }
                    System.debug('))))))))'+FCResponse[0].Status);
                    if(FCResponse[0].Status.contains('Success')){
                        Queryrecord.OpenTextId__c=FCResponse[0].OpenTextId;
                        Queryrecord.Sync_to_OpenText__c = false;
                        database.update(Queryrecord);
                    }
                    else{
                        StatusMessage=FCResponse[0].ErrorMessage;
                        System.debug('----->'+StatusMessage);
                    }
                }
            } catch(DMLException e){
                System.debug('The exception thrown during update is '+e.getMessage());
            }
                        
      }
           
   }

   global void finish(Database.BatchableContext BC){
       
       AsyncApexJob a = [SELECT ApexClassId,CreatedDate,ExtendedStatus,Id,JobItemsProcessed,
                           JobType,MethodName,NumberOfErrors,ParentJobId,Status,
                           TotalJobItems FROM AsyncApexJob WHERE id = :BC.getJobId()];
       system.debug('deepti2 '+a); 

   }
}