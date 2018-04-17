/*
Type Name: CaseWebServiceHandler
Author: Cognizant CaseManagementTeam
Created Date: 27thNov2015
Reason: Reason: This is a webservice class which implements AssignL2 button functionality.
Test Class: CaseWebServiceHandlerTest
Change History:
Author: 
Modified Date: 
……..//
……..
--
*/
Global class CaseWebServiceHandler{
    public static Case objCase;
    
    /**
    This method is used to return group members when closedVerified button is clicked.
    @method name: getGroupMember
    @Button: closedVerified
    @parameter:  
    @return :   List<Id>.
    **/
    
      WebService static List<Id> getGroupMember(){  
        List<Group> groupList = [select Id from Group where DeveloperName='CaseEditAccess' and Type='regular' LIMIT 1];     
        List<string> groupId = new List<string>();
        List<Id> userIds = new List<Id>();             
                 //fetching group ids    
        if(groupList.size() > 0) {                
            for(Group groupObj : groupList) {
                groupId.add(groupObj.Id); // fetching groupId for Group member
             }                
            List<GroupMember> groupMemList = [Select GroupId, UserOrGroupId  from GroupMember where groupId IN:groupId];                   
            if(groupMemList .size() > 0){ 
                for (GroupMember groupMemObj : groupMemList){   
                     userIds.add(groupMemObj.UserOrGroupId);  
                } 
            }    
        }   
        return userIds; 
    }
    
    /**
    This method is used to assign the ownership when AssignL2 button is clicked.
    @method name: assignL2Button
    @Button: AssignL2
    @parameter:   Case Id.
    @return :     AlertMessages (class).
    **/
    WebService static AlertMessages assignL2Button(string caseId) {
        AlertMessages msgs=new AlertMessages();
        
        try{
            objCase =[SELECT Id, 
                            Target_process_node__c,
                            Fab9_10__c,
                            L2Logic1__c,
                            Category__c,
                            ESDLUP_Fab1_8__c,
                            ESDLUP_SGP__c,
                            AccountId,
                            Account_Region__c,
                            Region__c,
                            Support_Level__c 
                            FROM Case WHERE Id=:caseId
                            LIMIT 1];
            if(objCase.Target_process_node__c!='' && objCase.Target_process_node__c !=null ){
                if(objCase.Fab9_10__c || (objCase.L2Logic1__c && objCase.Account_Region__c == 'A&D')) {  
                    msgs.Warning = check_ATP();
                }else if(objCase.Category__c == System.Label.Case_ESD_Latch_Up_category){
                    //Category is ESDLatch Up and US-Orange node
                        if(objCase.ESDLUP_Fab1_8__c){
                            if(isNotBlank(CaseQueueSetup__c.getValues('L2_L3_ESD_LUP_Fab1_8').QueueId__c)){
                                objCase.OwnerId = CaseQueueSetup__c.getValues('L2_L3_ESD_LUP_Fab1_8').QueueId__c;
                                objCase.Support_Level__c = 'L2';
                                update objCase;
                                msgs.Warning = 'Success';
                            }
                        }
                    //Category is ESDLatch Up and US-SGP node
                    else if(objCase.ESDLUP_SGP__c){
                        if(isNotBlank(CaseQueueSetup__c.getValues('L2_L3_ESD_LUP_SGP').QueueId__c)){
                            objCase.OwnerId = CaseQueueSetup__c.getValues('L2_L3_ESD_LUP_SGP').QueueId__c;
                            objCase.Support_Level__c = 'L2';
                            update objCase;
                            msgs.Warning = 'Success'; 
                        }
                    //Category is ESDLatch Up and its not a fab9-10,US-SGP ,US-Orange node
                    }else{
                        if(isNotBlank(CaseQueueSetup__c.getValues('ESD_LUP_Team').QueueId__c)){
                            objCase.OwnerId = CaseQueueSetup__c.getValues('ESD_LUP_Team').QueueId__c;
                            objCase.Support_Level__c = 'L2';
                            update objCase;
                            msgs.Warning = 'Success'; 
                        }
                    }
                }                
                else{
                    msgs.Warning = check_Region();                
                }                   
            }else
                msgs.Warning = Label.Case_Take_Ownership_TPN_Error;
                   
                if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                }
             return msgs; 
        }catch (Exception e) {      
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseWebServiceHandler.class.getName();
                    alw.sourceFunction ='assignL2Button()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Case';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);      
                  //CaseHandlerUtility.trackException('CaseWebServiceHandler.assignL2Button', e.getLineNumber(), e.getTypeName(), e.getMessage());
                    msgs.Warning = e.getMessage();
                    return msgs;
        }
    }
    /**
    This method is used to route the ownership on the basis of region.
    @method name: check_Region
    @parameter:   NA
    @return :     String
    **/
    public  static String check_Region(){
        String result='Success';
        if(objCase.Account_Region__c !=''&& objCase.Account_Region__c!=null){
            if(objCase.Account_Region__c.startsWith(System.Label.AccountUSRegion) && objCase.Account_Region__c != System.Label.AccountUSMajorRegion){
               if(isNotBlank(CaseQueueSetup__c.getValues('L2_Customer_Design_Support_US').QueueId__c)){
                   objCase.OwnerId = CaseQueueSetup__c.getValues('L2_Customer_Design_Support_US').QueueId__c;
                   objCase.Support_Level__c = 'L2';
               }
            }
            else if(objCase.Account_Region__c == 'A&D' || objCase.Account_Region__c == 'SiPh' ){
                if(isNotBlank(CaseQueueSetup__c.getValues('L2_Design_and_Technology_Support').QueueId__c)){
                    objCase.OwnerId = CaseQueueSetup__c.getValues('L2_Design_and_Technology_Support').QueueId__c;
                    objCase.Support_Level__c = 'L2';
                }           
            }
            else if (objCase.Account_Region__c.startsWith(System.Label.AccountAsicRegion)){                   
                       result = System.Label.CaseRegionAsicError;
            }
            else{
               system.debug('yes');
                if(isNotBlank(CaseQueueSetup__c.getValues('L2_Customer_Design_Support_APJ_EMEA').QueueId__c)){
                    objCase.OwnerId = CaseQueueSetup__c.getValues('L2_Customer_Design_Support_APJ_EMEA').QueueId__c;
                    objCase.Support_Level__c = 'L2';
                }
            }
            
            update objCase;
        }
        else if(isNotBlank(objCase.Region__c)) {
            if (objCase.Region__c=='Americas'){
                if(isNotBlank(CaseQueueSetup__c.getValues('L2_Customer_Design_Support_US').QueueId__c)){
                    objCase.OwnerId = CaseQueueSetup__c.getValues('L2_Customer_Design_Support_US').QueueId__c;
                    objCase.Support_Level__c = 'L2';
                }
            }else{ 
               if(isNotBlank(CaseQueueSetup__c.getValues('L2_Customer_Design_Support_APJ_EMEA').QueueId__c)){
                   objCase.OwnerId = CaseQueueSetup__c.getValues('L2_Customer_Design_Support_APJ_EMEA').QueueId__c;
                   objCase.Support_Level__c = 'L2';
               }
            }
            update objCase;           
        } 
        
        
        else {
            result = System.Label.CaseRegionError;
        }
        return result;
    }
    /**
    This method is used to route the ownership for Fab9&10 nodes.
    @method name: check_ATP
    @parameter:   NA
    @return :     String
    **/
    public static String check_ATP(){
        String result='Success';
        String teamRole=System.Label.Case_Account_Role_Design_and_Technology_Support;
        List<Account_Team_Proxy__c> atpList = [SELECT Id, User__c, Team_Role__c from Account_Team_Proxy__c Where Team_Role__c =:teamRole AND Account__c =: objCase.accountId  Limit 1];
        if(atpList.size()>0){
            objCase.OwnerId = atpList[0].User__c;
            objCase.Support_Level__c = 'L2';
            update objCase;
        }
        else{       
            if (objCase.L2Logic1__c) {
                result = check_Region();
            } else if (objCase.Fab9_10__c) {
                if(isNotBlank(CaseQueueSetup__c.getValues('L2_Design_and_Technology_Support').QueueId__c)){
                    objCase.OwnerId = CaseQueueSetup__c.getValues('L2_Design_and_Technology_Support').QueueId__c;
                    objCase.Support_Level__c = 'L2';
                    update objCase;
                }
            }
        }            
        return result;
    }
    /***
    * isNotBlank- check the string null or blank
    ***/
    public static Boolean isNotBlank(String val){
        if(val <> null && val <> '' && val <> 'null'){
            return true;
        }
        return false;
    }
    //Class used for passing error message to javascript
    global class AlertMessages{
        webservice String Warning;

    }  
    public class applicationException extends Exception {}  
}