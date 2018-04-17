/*
Author:         Bhavana Mohan
Company:        Cognizant Technology Solution
Description:    

History:
BMohan     2082013     -     Class Creation
*/
public class CPKReportRelatedList{
    public CPK_Report__c  cpkReportins;
    Public Boolean dateInRange;
    Public Boolean recordCount;
    Public Boolean recordCountForDate;
    Public String recordName;
    Date myDate;
    public Boolean noreptm{get;set;}
    
    public CPKReportRelatedList(ApexPages.StandardController controller){
        
        dateInRange = false;
        if(ApexPages.currentPage().getParameters().get('Id') != null){
            cpkReportins = [select Reminder__c,
                               Remind_To_Upload__c,
                               id,Report_Cycle__c,Report_Cycle_Day__c,
                               QA_Approver__c,
                               QA_Approver_backUp__c,OpenTextId__c 
                               from CPK_Report__c  where id =: ApexPages.currentPage().getParameters().get('Id')];
        }
        noreptm=false;
    }
    public String recid{get;set;}
    
    public void deleteRecord(){
       Monthly_CPK_Report__c[]  rec = [select Name,Id,Approved__c,
                                            Month__c,Report_Due_Date__c,
                                            CreatedById, createdDate,
                                            CPK_Report__c from Monthly_CPK_Report__c where id =: recId];      
      
        if(rec != null && rec.size() > 0){
            try{
                delete rec ;
            }
            Catch(Exception e){
            system.debug('Exception while deleting the record:'+e);
            }
        }
    }
    
    public Boolean getRenderNewButton(){
        DateCalculation();
        if(dateInRange && recordCount && cpkReportins.OpenTextId__c != null){
           return True;
        }else{ 
            return False;
        }   
    }
    
    public Boolean getRenderTable(){
        getReport();
        return recordCountForDate ; 
    }
    
    
    public void DateCalculation(){
        
        List<Monthly_CPK_Report__c> monthlyCpkRepList = new List<Monthly_CPK_Report__c>();
        if(cpkReportins.Reminder__c != null){
            if(cpkReportins.Report_Cycle__c == 'Monthly'){
                recordName='M';
                myDate = cpkReportins.Reminder__c.addMonths(-1);
                if(system.Today() >= myDate && system.Today() < cpkReportins.Reminder__c){
                    dateInRange = True;
                }
            }else if(cpkReportins.Report_Cycle__c == 'Bi-Monthly'){
                recordName='BM';
                myDate = cpkReportins.Reminder__c.addMonths(-2);
                if(system.Today() >= myDate && system.Today() < cpkReportins.Reminder__c){
                    dateInRange = True;
                }
            }else if(cpkReportins.Report_Cycle__c == 'Quarterly'){
                recordName='Q';
                myDate = cpkReportins.Reminder__c.addMonths(-3);
                if(system.Today() >= myDate && system.Today() < cpkReportins.Reminder__c){
                    dateInRange = True; 
                }
            }else if(cpkReportins.Report_Cycle__c == 'Half yearly'){
                recordName='HF';
                myDate = cpkReportins.Reminder__c.addMonths(-6);
                if(system.Today() >= myDate && system.Today() < cpkReportins.Reminder__c){
                    dateInRange = True;
                }
            }
        }
        monthlyCpkRepList = queryReport();
        if(monthlyCpkRepList != null && monthlyCpkRepList.size() > 0){
            recordCount = False;
        }else{
            recordCount = True;
        } 
     }
     
    /*public pageReference ByPassReport()
    {
       ClsUpdateCPKReportOnReportUpload.UpdateReportDueDate(cpkReportins);
       update cpkReportins;
       return null;
    }*/
     
    public Id SubfolderId;
    
    public pagereference empty(){
        return null;
    }
    
    public pageReference NewReport(){
        
        List<Monthly_CPK_Report__c> monthlyCpkReportList = new List<Monthly_CPK_Report__c>();
        
        monthlyCpkReportList.add(ClsUpdateCPKReportOnReportUpload.createNewReport(cpkReportins,recordName));
        if(monthlyCpkReportList != null && monthlyCpkReportList.size()>0){
            try{   
                if(noreptm){
                    monthlyCpkReportList[0].Approved__c='No Reports';
                }
                insert monthlyCpkReportList[0];   
                SubfolderId=monthlyCpkReportList[0].id;
            }catch(DMLException e){
                System.debug('Exception occured during inserting Monthly CPK Report is'+e);
            }
        }
        return null;
    }
    
    /* public Monthly_CPK_Report__c QueryRecord;
    public PageReference Createfolder(){
    
        PageReference returnUrl;
        try{
            QueryRecord=[Select Id,name,OpenTextId__c,ParentOpenTextId__c from Monthly_CPK_Report__c where Id=:SubfolderId];
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
                if(noreptm){
                    createfolderrequest.FolderName=ReportName+'--No Reports for this Month';
                }else{
                    createfolderrequest.FolderName=ReportName;
                }
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
                        //List<String> OTIds=new list<String>(FCResponse[0].OpenTextId.split(';'));
                        Queryrecord.OpenTextId__c=FCResponse[0].OpenTextId;
                        //Queryrecord.OpenTextIdPublish__c=OTIds[1];
                        database.update(Queryrecord);
                        //StatusMessage='Folder Created Successfully in OpenText';
                        //returnUrl = new PageReference('/'+QueryRecord.id);
                        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,StatusMessage);
                        //ApexPages.addMessage(myMsg);
                        return null;
                    
                    }
                    else{
                    
                        StatusMessage=FCResponse[0].ErrorMessage;
                        System.debug('----->'+StatusMessage);
                        //returnUrl = page.VfQCNewRecord;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,StatusMessage);
                        ApexPages.addMessage(myMsg);
                        return null;
                    }
                    if(noreptm){
                        database.delete(subfolderid);
                    }
            }
        }catch(DMLException e){
            ApexPages.addMessages(e);
        }
        
        return null;  
    } */
    
    //DBiswal 02102015
    @future(callout=true)
    public static void Createfolder(Id SubfolderId){
        Boolean noreptm = false;
        Monthly_CPK_Report__c QueryRecord;
        
        try{
            QueryRecord = [Select Id,name,OpenTextId__c,ParentOpenTextId__c,Approved__c,Sync_to_OpenText__c from Monthly_CPK_Report__c where Id =:SubfolderId];
                String ReportName=QueryRecord.name;
                String CPKOTId=QueryRecord.OpenTextId__c;
                System.debug('&&&&&&'+QueryRecord.id);
                System.debug('&&&&&&'+ReportName);
                System.debug('&&&&&&'+QueryRecord.ParentOpenTextId__c);
                if('No Reports'.equals(QueryRecord.Approved__c)){
                    noreptm =true;
                }
            
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
                    if(noreptm){
                        createfolderrequest.FolderName=ReportName+'--No Reports for this Month';
                    } else{
                        createfolderrequest.FolderName=ReportName;
                    }
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
                        //List<String> OTIds=new list<String>(FCResponse[0].OpenTextId.split(';'));
                        Queryrecord.OpenTextId__c=FCResponse[0].OpenTextId;
                        Queryrecord.Sync_to_OpenText__c = false;
                        //Queryrecord.OpenTextIdPublish__c=OTIds[1];
                        database.update(Queryrecord);                   
                    }
                    else{                    
                        StatusMessage=FCResponse[0].ErrorMessage;
                        System.debug('----->'+StatusMessage);
                    }
                    if(noreptm){
                        //database.delete(QueryRecord.id);
                    }
                }
            
        }catch(Exception e){
            System.debug('The exception thrown is '+e.getMessage());
        }  
         
    }
    
    
    public  List<Monthly_CPK_Report__c> queryReport(){
        return [select Name,Id,Approved__c,Month__c,Report_Due_Date__c,CreatedById, createdDate,CPK_Report__c ,Move_To_Provisioning__c,Reviewed__c from Monthly_CPK_Report__c where CPK_Report__c = :ApexPages.currentPage().getParameters().get('Id') AND Report_Due_Date__c =: cpkReportins.Reminder__c ORDER BY createdDate DESC Limit 1];      
    }
    
    public  List<Monthly_CPK_Report__c> queryReportForMany(){
        return [select Name,Id,Month__c,Report_Due_Date__c,Approved__c,CreatedById, createdDate,CPK_Report__c ,Move_To_Provisioning__c,Reviewed__c from Monthly_CPK_Report__c where CPK_Report__c = :ApexPages.currentPage().getParameters().get('Id') ORDER BY createdDate DESC];      
    }
    
    public List<Monthly_CPK_Report__c> getReport() {
        List<Monthly_CPK_Report__c> monthlyReport = queryReportForMany();//[select Name,Id,Month__c,Report_Due_Date__c,Approved__c,CreatedById, createdDate,CPK_Report__c ,Move_To_Provisioning__c from Monthly_CPK_Report__c where CPK_Report__c = :ApexPages.currentPage().getParameters().get('Id') ORDER BY createdDate DESC Limit 1];      
        recordCountForDate = False;
        if(monthlyReport.size() > 0 && monthlyReport != null){
            return monthlyReport;
        }else{
            recordCountForDate = True;
        }
        return null;
    }
}