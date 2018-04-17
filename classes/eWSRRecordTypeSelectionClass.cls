/*
    Author: Abhita Bansal
    Description: This Class is used to replicate the Standard Record Type Selection Page and based on Fab Assigned for user,
                 it will direct the page to correct record Type
    History: 
    ABansal     11/28/2014 - Code Creation
    ABansal     12/3/2014 - Update the Logic for Record direction and added the error message
    ABansal     12/10/2014 - Change the Logic for FAB 5JV
*/
public class eWSRRecordTypeSelectionClass{
    
    //public String s_CurrentCaseRecordtypeID {get; set;}
    public String s_Fab2RecordtypeID {get; set;}
    public String s_Fab3RecordtypeID {get; set;}
    public String s_Fab3ERecordtypeID {get; set;}
    public String s_Fab5RecordtypeID {get; set;}
    public String s_Fab5JVRecordtypeID {get; set;}
    public String s_Fab6RecordtypeID {get; set;}
    public String s_Fab7RecordtypeID {get; set;}
    public Pagereference redirectPage {get;set;}
    public string s_Url {get;set;}
    public String s_currenteWSRId {get; set;}
    public String s_retURL {get; set;}
    public String s_redirecteWSRID {get; set;}
    public List<String> fabAssignedList = new List<String>();    
    public String str_eWSRRecordType{get;set;}
    public List<RecordType> lst_eWSRRecordTypeList{get;set;}
    public Boolean booleanFab2{get;set;}
    public Boolean booleanFab3{get;set;}
    public Boolean booleanFab3E{get;set;}
    public Boolean booleanFab5{get;set;}
    public Boolean booleanFab5JV{get;set;}
    public Boolean booleanFab6{get;set;}
    public Boolean booleanFab7{get;set;}
    public Boolean showMsg{get;set;}
    public Profile systemAdminProfileId ;
    public List<Id> userId;
    public Boolean gpYes;
    
    public eWSRRecordTypeSelectionClass(ApexPages.standardController controller){
              
        lst_eWSRRecordTypeList = [select Id, Name, DeveloperName, Description from RecordType where SobjectType =:eWSRConstantsVariablesClass.EWSRFORMSOBJECT];
        System.debug('list of record Type:'+lst_eWSRRecordTypeList);
        
        
        String publicGroup = eWSRConstantsVariablesClass.FAB5JVPUBLICGP;          
        Group grp = getPublicGp(publicGroup);
        userId = getUserIds(grp.Id);
        
        booleanFab2 = false;
        booleanFab3 = false;
        booleanFab3E = false;
        booleanFab5 = false;
        booleanFab5JV = false;
        booleanFab6 = false;
        booleanFab7 = false; 
        gpYes = false;     
        showMsg = false;
        
        User user = [select Fab_Assigned__c,ProfileID  from User where Id = :UserInfo.getUserId()];
        systemAdminProfileId = [select Id from Profile where Name =:eWSRConstantsVariablesClass.SYSADMINPROFILE Limit 1];
        
        for(Id users1 : userId ){
                    if(user.Id == users1){
                        gpYes = true;
                    }
                }
        
        if(user.Fab_Assigned__c  == null && user.ProfileID != systemAdminProfileId.Id && gpYes != true){
            showMsg = true;
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,eWSRConstantsVariablesClass.ERRORMSGNOFAB));
        }
        
        
            
        s_Fab2RecordtypeID = Schema.getGlobalDescribe().get(eWSRConstantsVariablesClass.EWSRFORMSOBJECT).getDescribe().getRecordTypeInfosByName().get(eWSRConstantsVariablesClass.FAB2RECORDTYPE).getRecordTypeId();
        s_Fab3RecordtypeID = Schema.getGlobalDescribe().get(eWSRConstantsVariablesClass.EWSRFORMSOBJECT).getDescribe().getRecordTypeInfosByName().get(eWSRConstantsVariablesClass.FAB3RECORDTYPE).getRecordTypeId();
        s_Fab3ERecordtypeID = Schema.getGlobalDescribe().get(eWSRConstantsVariablesClass.EWSRFORMSOBJECT).getDescribe().getRecordTypeInfosByName().get(eWSRConstantsVariablesClass.FAB3ERECORDTYPE).getRecordTypeId();
        s_Fab5RecordtypeID = Schema.getGlobalDescribe().get(eWSRConstantsVariablesClass.EWSRFORMSOBJECT).getDescribe().getRecordTypeInfosByName().get(eWSRConstantsVariablesClass.FAB5RECORDTYPE).getRecordTypeId();
        s_Fab5JVRecordtypeID = Schema.getGlobalDescribe().get(eWSRConstantsVariablesClass.EWSRFORMSOBJECT).getDescribe().getRecordTypeInfosByName().get(eWSRConstantsVariablesClass.FAB5JVRECORDTYPE).getRecordTypeId();
        s_Fab6RecordtypeID = Schema.getGlobalDescribe().get(eWSRConstantsVariablesClass.EWSRFORMSOBJECT).getDescribe().getRecordTypeInfosByName().get(eWSRConstantsVariablesClass.FAB6RECORDTYPE).getRecordTypeId();
        s_Fab7RecordtypeID = Schema.getGlobalDescribe().get(eWSRConstantsVariablesClass.EWSRFORMSOBJECT).getDescribe().getRecordTypeInfosByName().get(eWSRConstantsVariablesClass.FAB7RECORDTYPE).getRecordTypeId();
        //s_DEPCaseRecordtypeID = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get('DEP Case').getRecordTypeId(); 
        
        s_currenteWSRId = ApexPages.currentPage().getParameters().get('Id');
        System.debug('Current URl:'+s_currenteWSRId );
        //s_cloneId = ApexPages.currentPage().getParameters().get('cloneId');
        s_retURL = ApexPages.currentPage().getParameters().get('retURL');
        s_redirecteWSRID = ApexPages.currentPage().getParameters().get('Id');
        
    }
    
    public static Group getPublicGp(String PName){
            Group gp = [Select Type, id From Group where Type=:eWSRConstantsVariablesClass.PUBLICGP And Name =:PName Limit 1];
            return gp;
    }
    
    public static List<Id> getUserIds(String gpId){
           List<Id> userList = new List<Id>();
           for(GroupMember groupMem : [Select UserOrGroupId From GroupMember where GroupId =:gpId]){
                userList.add(groupMem.UserOrGroupId);
           }
           return userList;
    }
     
    public Pagereference redirectTo(){
        String fab;
        String fabValue;
        list<String> fabList = new List<String>();  
        
        //List<User> users = getUsers(userId);
        for(User user:[select Fab_Assigned__c,ProfileID, Id from User where Id = :UserInfo.getUserId()]){
            fab = user.Fab_Assigned__c;
            System.debug('Fab'+fab);
            if(fab == null && user.ProfileID == systemAdminProfileId.Id ){
                booleanFab2 = true;
                booleanFab3 = true;
                booleanFab3E = true;
                booleanFab5 = true;
                booleanFab5JV = true;
                booleanFab6 = true;
                booleanFab7 = true; 
            }
            else if(fab == null && user.ProfileID != systemAdminProfileId.Id){
                System.debug('Enter');
                for(Id users1 : userId ){
                    if(user.Id == users1){
                        s_Url = '/apex/eWSRFormsNewEditPage?RecordType='+s_Fab5JVRecordtypeID;
                        redirectPage = new PageReference (s_Url);
                        redirectPage.getParameters().put('Id',s_currenteWSRId );
                        redirectPage.getParameters().put('retURL',s_retURL);
                        redirectPage.setRedirect(true);
                    }
                
                }
                
            }
            else{
                fabList = fab.split(';');
                if(fabList.size() != 1){
                    for(Integer i=0;i<fabList.size();i++){
                        fabValue = fabList[i];
                        if(fabValue == eWSRConstantsVariablesClass.FAB2RECORDTYPE){
                            booleanFab2 = true;
                        }
                        else if(fabValue == eWSRConstantsVariablesClass.FAB3RECORDTYPE){
                            booleanFab3 = true;
                        }
                        else if(fabValue == eWSRConstantsVariablesClass.FAB3ERECORDTYPE){
                            booleanFab3E = true;
                        }
                        else if(fabValue == eWSRConstantsVariablesClass.FAB5RECORDTYPE){
                            booleanFab5 = true;
                        }
                        /*else if(fabValue == 'FAB 5JV'){
                            booleanFab5JV = true;
                        }*/
                        else if(fabValue == eWSRConstantsVariablesClass.FAB6RECORDTYPE){
                            booleanFab6 = true;
                        }
                        else{
                            booleanFab7 = true;
                        }
                    }
                    for(Id users1 : userId ){
                    if(user.Id == users1){
                        booleanFab5JV = true;
                    }
                }
                    return null;
                }
                
                else{
                    if(fabList[0] == eWSRConstantsVariablesClass.FAB2RECORDTYPE){
                        s_Url = '/apex/eWSRFormsNewEditPage?RecordType='+s_Fab2RecordtypeID;
                    }
                    else if(fabList[0] == eWSRConstantsVariablesClass.FAB3RECORDTYPE){
                        s_Url = '/apex/eWSRFormsNewEditPage?RecordType='+s_Fab3RecordtypeID;
                    }
                    else if(fabList[0] == eWSRConstantsVariablesClass.FAB3ERECORDTYPE){
                        s_Url = '/apex/eWSRFormsNewEditPage?RecordType='+s_Fab3ERecordtypeID;
                    }
                    else if(fabList[0] == eWSRConstantsVariablesClass.FAB5RECORDTYPE){
                        s_Url = '/apex/eWSRFormsNewEditPage?RecordType='+s_Fab5RecordtypeID;
                    }
                   /* else if(fabList[0] == 'FAB 5JV'){
                        s_Url = '/apex/eWSRFormCreation?RecordType='+s_Fab5JVRecordtypeID;
                    }*/
                    else if(fabList[0] == eWSRConstantsVariablesClass.FAB6RECORDTYPE){
                        s_Url = '/apex/eWSRFormsNewEditPage?RecordType='+s_Fab6RecordtypeID;
                    }
                    else{
                        s_Url = '/apex/eWSRFormsNewEditPage?RecordType='+s_Fab7RecordtypeID;
                    }
                }
                
                
                
                redirectPage = new PageReference (s_Url);
                redirectPage.getParameters().put('Id',s_currenteWSRId );
                redirectPage.getParameters().put('retURL',s_retURL);
                redirectPage.setRedirect(true);
            }
            
            
            
        }   
              /*  for(i=0;1<fabList.size();i++){
                    fab
                }
            fab = fabList [fabList.size()-1];
            System.debug('Fab1'+fabList);
            System.debug('fab'+fab);
            if(fab == null){
                booleanFab2 = true;
            }
            if(fab == 'FAB 2'){
                booleanFab2 = true;
            }
            if(fab == 'FAB 3'){
                booleanFab3 = true;
            }
            if(fab == 'FAB 3E'){
                booleanFab3E = true;
            }
            if(fab == 'FAB 5'){
                booleanFab5 = true;
            }
            if(fab == 'FAB 5JV'){
                booleanFab5JV = true;
            }
            if(fab == 'FAB 6'){
                booleanFab6 = true;
            }
            if(fab == 'FAB 7'){
                booleanFab7 = true;
            }
            if(user.Fab_Assigned__c != null){
            
            fabAssignedList.add(user.Fab_Assigned__c );
            }
        }
        System.debug('Fab Assigned List:'+fabAssignedList.size());
        if(fabAssignedList.isEmpty() || fabAssignedList.size()>1){
            return null;
        }
     */
       return redirectPage;   
            
    }
    
    public pageReference m_Continue(){
        pageReference pr;
        String passURL;
        if(str_eWSRRecordType == eWSRConstantsVariablesClass.FAB2RECORDTYPE){
            passURL = '/apex/eWSRFormsNewEditPage?RecordType='+s_Fab2RecordtypeID ;
        }
        if(str_eWSRRecordType == eWSRConstantsVariablesClass.FAB3RECORDTYPE){
            passURL = '/apex/eWSRFormsNewEditPage?RecordType='+s_Fab3RecordtypeID ;
        }
        if(str_eWSRRecordType == eWSRConstantsVariablesClass.FAB3ERECORDTYPE){
            passURL = '/apex/eWSRFormsNewEditPage?RecordType='+s_Fab3ERecordtypeID ;
        }
        if(str_eWSRRecordType == eWSRConstantsVariablesClass.FAB5RECORDTYPE){
            passURL = '/apex/eWSRFormsNewEditPage?RecordType='+s_Fab5RecordtypeID ;
        }
        if(str_eWSRRecordType == eWSRConstantsVariablesClass.FAB5JVRECORDTYPE){
            passURL = '/apex/eWSRFormsNewEditPage?RecordType='+s_Fab5JVRecordtypeID ;
        }
        if(str_eWSRRecordType == eWSRConstantsVariablesClass.FAB6RECORDTYPE){
            passURL = '/apex/eWSRFormsNewEditPage?RecordType='+s_Fab6RecordtypeID ;
        }
        if(str_eWSRRecordType == eWSRConstantsVariablesClass.FAB7RECORDTYPE){
            passURL = '/apex/eWSRFormsNewEditPage?RecordType='+s_Fab7RecordtypeID ;
        }
        
        pr = new pageReference(passURL);
        pr.getParameters().put('retURL',s_retURL);
        pr.setRedirect(true);
        return pr;  
    }
  
    
    public pageReference m_Cancel(){
        pageReference pr = new PageReference(s_retURL);
        pr.setRedirect(true);
        return pr;
    }
    
}