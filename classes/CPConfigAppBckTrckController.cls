/*
    Class Name:    CPConfigAppBckTrckController 
    Author:        Anirban Roy
    Description:   This is a controller class for Configurator Plus Backtrack process.
    History: 
      ARoy           11162015    - Code Created.
	  SNune			 16062016    -  Updated.
	  Ravi Teja.B    06072017    - Updated as it is not getting unlocked when record is backtracked by FAE.
      Ravi Teja.B    21072017    - Modified as the process flow accepted stage for configuration will be modified based on purpose of configuration.
      
*/
public class CPConfigAppBckTrckController{
    
    // Declare variables
    public Apttus_Proposal__Proposal__c prop {get;set;}
    public String configId {get;set;}
    
    // Constructor
    public CPConfigAppBckTrckController(){
        configId = ApexPages.currentPage().getParameters().get('id');        
    }        
    
    // Initialization Method called on page load action
    public PageReference init(){   
        prop = [select    name,id,Backtrack_Status__c
                          , Initial_Submitter__c    
                          , Fab_Name__c
                          , Apttus_Proposal__Approval_Stage__c
                          , Approval_Check__c 
                          , Backtrack_Check__c 
                          , RecordTypeID
                          , Apttus_Proposal__Account__c,Backtrack_counter__c
                from      Apttus_Proposal__Proposal__c
                where     id = :configId for update
               ];        
        Profile adminId = [SELECT Id from Profile where Name='GF FAE/FTS'];
        // Performs user information check based on fab    
        // Backtrack to FAE enable to all FAE user profiles 
        if(CPQConfigApprovalHandler.getUserType(prop.Fab_Name__c)!='Unauthorized' || UserInfo.getProfileId()== adminId.Id ){               
            
            // Invoke the backtrack process to backtrack the record to FAE user 
            String retMsg = backTrackApproval(configId, '', 'Backtrack to FAE');
            
            // If the backtrack is successful then show a custom success message else an error message.
            if(retMsg == 'success'){
                ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.INFO,'Configurator Record backtracked to FAE.'));
            }else{
                ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR,'Error occured during backtrack of a Configurator Plus record. A case has'+
                                                           ' been created and CPQ Team has been notified.'));
            }
            
        }else{
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR,'Only FAE/Packaging/PIYE user(s) can backtrack a Configurator Plus record.'));
        }
        return null;
    }    
    
    /*
    Method :        Back track approval request
    Paremeter:      ID - BX041 ID 
    Return Type:    String - message of result
    */
    public String backTrackApproval(Id configId, String comment, String backTrackStatus){
        
        // Condition for backtrack status based on different approval stage
        if(backTrackStatus != null && prop.Apttus_Proposal__Approval_Stage__c != null && (prop.Apttus_Proposal__Approval_Stage__c == 'Configuration Design Phase' 
                || prop.Apttus_Proposal__Approval_Stage__c == 'Process Accepted Phase' 
                || prop.Apttus_Proposal__Approval_Stage__c == 'Package Accepted Phase'
                || prop.Apttus_Proposal__Approval_Stage__c.contains('Process Flow Accepted') //Modified By Ravi Teja.B 21072017
                || prop.Apttus_Proposal__Approval_Stage__c == 'Rejected Phase')){                                                   
            
            try{                

                boolean recallStatus = (!prop.Apttus_Proposal__Approval_Stage__c.contains('Process Flow Accepted'))?recallReq(configId, comment):true; //Modified By Ravi Teja.B 21072017
                prop.Backtrack_Status__c = backTrackStatus;       
                prop.Apttus_Proposal__Approval_Stage__c = 'Draft';
                
                //change record type to Proposal from Device in case initial submitter is false.
                if(prop.Initial_Submitter__c == NULL ){
                    String ConfigRecordtypeID ; 
                    for(RecordType rt : [select id
                                        , developername
                                        , name 
                                 from   RecordType 
                                 where  id = :prop.id
                                 or     developername = 'Proposal_from_Device']){
                         ConfigRecordtypeID = rt.id;    
                     }
                     if(ConfigRecordtypeID != NULL){
                         prop.RecordTypeID =  ConfigRecordtypeID  ;
                     }
                }
                prop.Approval_Check__c = false;
                prop.Backtrack_Check__c  = (prop.Initial_Submitter__c != null)? TRUE : FALSE ;
                prop.Backtrack_counter__c = prop.Backtrack_counter__c == null ? 1 : prop.Backtrack_counter__c +1;
                
                update prop;
                
                return 'success'; 
            }catch(Exception ex){
                postExceptionToCPQTeam(Prop, ex);
                return 'error';
            }
                    
        }        
        return null;       
    }
    
    /**
     * @author Surendranadh Nune
     * @description This method is used to create a case for the exception encounterd.
     */ 
    public static void postExceptionToCPQTeam(Apttus_Proposal__Proposal__c Prop, Exception ex){
        
        List<AssignmentRule> arList = new List<AssignmentRule>();
        arList = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];

        if(!arList.isEmpty()){
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId= arList[0].id;
            dmlOpts.EmailHeader.triggerUserEmail = true;
            Case caseObj = new Case(Subject='Configuration Error : ' + prop.name + ': ' + ex.getMessage() + ': occured at : ' + System.now(),
                                    Status = 'New',
                                    Business_process__c = 'Product Configurator', Application__c = 'Salesforce', 
                                    Region__c = 'Singapore',Type = 'Issue', 
                                    Recordtype = new RecordType(name='SFDC Support'),
                                    Description = 'Exception occured in configuration record with record id : ' + prop.id + '\n\n' + ex.getStackTraceString());
            caseObj.setOptions(dmlOpts);
    
            insert caseObj;
        }
    }
    // Cancel functionality
    public PageReference cancel(){
        return new PageReference('/'+configId);
    }
    
    // Recall Approval Process
    private boolean recallReq(Id propId, String comment) {
        list<ProcessInstanceWorkitem> piwList = [SELECT    Id 
                                                 FROM      ProcessInstanceWorkitem
                                                 WHERE     ProcessInstance.TargetObjectId = :propId
                                                 AND       ProcessInstance.Status = 'Pending'
                                                 LIMIT 1];
        if(piwList.isEmpty()){
        	//Added By Ravi Teja.B 06072017
        	if(Approval.isLocked(propId)){
            	Apttus_Proposal__Proposal__c ap = new Apttus_Proposal__Proposal__c(Id=propId);
				Approval.UnlockResult unlockedRersult = Approval.unlock(ap);    
            }
        	return false;
        }              
       
        Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
        pwr.setComments(comment);
        pwr.setAction('Removed');
        pwr.setWorkitemId(piwList[0].Id);        
        Approval.ProcessResult result =  Approval.process(pwr);
        return result.isSuccess();
    }
}