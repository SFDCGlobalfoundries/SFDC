/*
    Class Name:    CPQConfigApprovalHandler 
    Author:        Prosenjit Saha(PS)
    Description:   This Class manages Approval process for Configurations.
    History: 
      PS           02122015    - Code Create.
      ARoy         01112016    - Code modified for Config PIYE Approver User population. 
    PS           04072016    - Code Modified: if approved by packaging team update Approved by packaging team TRUE

      Nbajaj       03212017    - Code Modified for Approver who is not part of queue.
      Ravi Teja.B  21072017    - As Approval Stage of Configurator has been added with new Process Flow Accepted Values changes are made accordingly.
*/
public with sharing class CPQConfigApprovalHandler {
     /*
        Method :        updateApprovalStatus
        Paremeter:      List<ID> ConfigIDs 
        Return Type:    NA
    */
     public static void updateApprovalStatus( List<Apttus_Proposal__Proposal__c> TriggeredConfig ){
        List<Apttus_Proposal__Proposal__c> UpdateConfig = new List<Apttus_Proposal__Proposal__c>();
        User usr = getHCMUser();
        Map<String,ConfigApprovalStages__c> apprlStage = ConfigApprovalStages__c.getall();
        for(Apttus_Proposal__Proposal__c config : TriggeredConfig){
            if(config.Approval_Check__c ){
                String userType = getUserType(config.Fab_Name__c); 
              
                if(userType == 'PackagingUser'){
                    config.Apttus_Proposal__Approval_Stage__c = 'Package Accepted Phase';
                }else if(userType == 'PIYEUser'){
                    config.Apttus_Proposal__Approval_Stage__c = 'Process Accepted Phase';
                }else if(userType == 'Admin'){
                    //Added by Ravi Teja.B 21072017
                    if(config.Purpose_of_the_Configuration__c == 'Final'){
                        config.Apttus_Proposal__Approval_Stage__c = 'Process Flow Accepted';
                    }
                    if(apprlStage.containsKey('Process Flow Accepted DW') && apprlStage.containsKey('Process Flow Accepted for Prelim')){
                        if(config.Purpose_of_the_Configuration__c == 'For Design Win'){
                            config.Apttus_Proposal__Approval_Stage__c = apprlStage.get('Process Flow Accepted DW').Value__c;
                        }
                        else if(config.Purpose_of_the_Configuration__c == 'Preliminary'){
                            config.Apttus_Proposal__Approval_Stage__c = apprlStage.get('Process Flow Accepted for Prelim').Value__c;
                        }
                    }
                }else if(userType == 'Unauthorized'){
                    //nbajaj added --Case -00065079
                    /*Here "Unauthorized" means approver may not be part of PIYE or packaging Queue*/
                    /* If approver is not from PIYE and Packaging Queue we are checking the last approver queue name(PIYE or Packaging-needed to decide the approval stage) 
                    and last approver profile(user profile having keyword PIYE) */
                    
                    List<ProcessInstance> piList = new List<ProcessInstance>([SELECT Id 
                                                                              FROM ProcessInstance 
                                                                              where TargetObjectId =:Trigger.new 
                                                                            ORDER BY CreatedDate 
                                                                              DESC LIMIT 1]);  
                                       
                    List<ProcessInstanceStep>piSteps= new List<ProcessInstanceStep>([SELECT Id,Comments,Actor.Name,ActorId,OriginalActorId  
                                                                                     FROM ProcessInstanceStep 
                                                                                     where ProcessInstanceId in :piList 
                                                                                     and StepStatus ='Approved']);
                         
                                                                                     
                                                                                         
                   if(!piSteps.isEmpty()){
                        Id originalApprover = piSteps[0].OriginalActorId;
                        
                        
                        Id actualApprover = piSteps[0].ActorId;
                        
     
                        List<User> excepUserList = new List<User>([Select Profile.name from User where Id =:actualApprover]);
                        
                        
                        Boolean isPiyeApprover = !excepUserList.isEmpty() ? excepUserList[0].Profile.name.contains('PIYE') : false;
                        
                        List<Group> assignedQList = new List<Group>([select Name from Group 
                                                                     where id = :originalApprover and Type = 'Queue']);
                        
                        
                        Boolean assigToPiyeTeam= !assignedQList.isEmpty() ? assignedQList[0].name.contains('PI/YE') : false;
                        Boolean assigToPackagingTeam= !assignedQList.isEmpty() ? assignedQList[0].name.contains('Packaging') : false;
     
                        if(isPiyeApprover ==true && assigToPIYETeam ==true){
                             config.Apttus_Proposal__Approval_Stage__c = 'Process Accepted Phase';
                        }else if(isPiyeApprover ==true && assigToPackagingTeam ==true){
                             config.Apttus_Proposal__Approval_Stage__c = 'Package Accepted Phase';
                        }else{
                             config.Apttus_Proposal__Approval_Stage__c =config.Apttus_Proposal__Approval_Stage__c;
                        }
                   }
                }
               
        //04072016 PS : if approved by packaging team update Approved by packaging team TRUE.               
                config.Approved_by_Packaging_Team__c = (userType == 'PackagingUser' || 
                                                         (userType == 'Unauthorized' && config.Apttus_Proposal__Approval_Stage__c == 'Package Accepted Phase')) ?
                                                            TRUE : FALSE ; 
                
                //01112016 ARoy : Code modified for Config PIYE Approver User population.               
                if(config.Apttus_Proposal__Approval_Stage__c != null && ((userType == 'Admin' && config.Apttus_Proposal__Approval_Stage__c.contains('Process Flow Accepted'))//Modified By Ravi Teja.B 21072017
                    || (userType == 'PIYEUser' && config.Apttus_Proposal__Approval_Stage__c == 'Process Accepted Phase')
                    || (userType == 'Unauthorized' && config.Apttus_Proposal__Approval_Stage__c == 'Process Accepted Phase'))) {
                    config.Config_PIYE_Approver__c = usr.HCM_Login_Id__c;
                }
            }
        }
     }
    
     /*
        Method :        submitForApproval
        Paremeter:      List<ID> ConfigIDs 
        Return Type:    String - result
    */
    public static String submitForApproval( List<ID> TriggeredSubmitConfig ){
        Savepoint sp = Database.setSavepoint();
        for(Apttus_Proposal__Proposal__c config : [select id,Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c where id IN :TriggeredSubmitConfig]){

            if(config.Apttus_Proposal__Approval_Stage__c == 'Package Accepted Phase' 
                || config.Apttus_Proposal__Approval_Stage__c ==  'Process Accepted Phase' 
                || config.Apttus_Proposal__Approval_Stage__c == 'Submitted Phase'){
                Boolean isSuccess = false;
                string comment;
                if(String.isEmpty(comment)){ comment = 'Submit for Approval...';}
                try{
                    isSuccess = submitRequest(config.id, comment);

                    if(!isSuccess){
                        return 'Failed to submit the Configuration, please contact system admin';
                    }
                }catch(Exception ex){
                    database.rollback(sp);
                    return ex.getMessage();
                
                }
            }
        }
        return null;    
        
        // ConfigList;      
    }
    
    /*
        Method :        getUserType
        Paremeter:      String Device Fab 
        Return Type:    String
    */
    public static string getUserType(String FabName) {
        
        String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
        if(UserInfo.getUserType()  != 'Standard'){
            return ('Unauthorized');
        }
        else{
            if(profileName.contains('Admin')){
                return ('Admin');
            }
            else{
                List<String> QueueName  = new List<String> (); 
                //Kanishk: check null value 
                FabName=FabName!=null && FabName!=''?FabName.replaceAll( '\\s+', ''):'';
               
                String PIYEQ = 'PI/YE Users '+ FabName;
                String PackagingQ = 'Packaging Users '+ FabName;
                QueueName.add(PIYEQ);
                QueueName.add(PackagingQ); 
                List<String> UserGroupNameList = new List<String>();
                for(GroupMember member : [ SELECT   Group.Name
                                                    , UserOrGroupId
                                           FROM     GroupMember 
                                           WHERE    ( Group.Name = :PIYEQ 
                                                        OR Group.Name = :PackagingQ )
                                           AND      Group.Type = 'Queue'
                                           AND      UserOrGroupId = :UserInfo.getUserId()]){
                    UserGroupNameList.add(member.Group.Name);                           
                }

                return((UserGroupNameList.size() == 1 && UserGroupNameList[0].contains('Packaging')) 
                        ? 'PackagingUser'
                            : (UserGroupNameList.size() == 1 && UserGroupNameList[0].contains('PI/YE'))
                                ? 'PIYEUser'
                                    :  (UserGroupNameList.size() != 0 )
                                        ? 'Admin'
                                        : 'Unauthorized');
            }
        }
    }
    
    /*
        Method :        submitRequest
        Paremeter:      ID - Configuration ID 
        Return Type:    boolean - true/false
    */
    public static Boolean submitRequest(Id configID, String comment) {
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments(comment);
        req.setObjectId(configID);  
        Approval.Processresult result = Approval.process(req);

        return result.isSuccess();
        
    }
    
    /*
        Method :        getHCMUser
        Paremeter:      none 
        Return Type:    User
    */
    //01112016 ARoy : Code modified for Config PIYE Approver User population.
    public static User getHCMUser(){
        User u = [select HCM_Login_Id__c,id from User where id = :UserInfo.getUserId() limit 1];
        return u;
    }            
    
}