/*
* @ Author :- Anil Kumar Reddy L
* @ Description :- Class contains logic for subscribing other User.
* @ Date :- 02/09/2016
* @ Change History :-  
DATE            NAME            Comments
6-Dec-2016      Inshu Misra     Added code for exception framework...#IM
20-Jun-2017     Defect Fix 154
10-Jul-2017     Ram Rai         Added the code to Display FMS enabled Contact #issue 393
01-Sept-2017     Ram Rai          Modified the code to fix Subscription Issue
**/
public without sharing class FMSSubscribeOtherUserCtrl {
    
    public FMS_Subscription__c subscribe {
        get;
        set;
    }
    public String formId{get;set;}
    public String baseURL;
    public String myString{get;set;}
    public String internalUsername{get;set;}
    public String internalUserId{get;set;}
    public Boolean isExternalUser {get;set;}
    public Boolean noUser{get;set;}
    public Set<Id> accId = new Set<Id>();
    public Set<Id> accId1 = new Set<Id>();
    public Map<Id,List<Account>> accMap = new Map<Id,List<Account>>();
    public Map<Id,Id> accPrt = new Map<Id,Id>();
    public list<String> lstCont {get;set;}
    public String selectedAccId{get;set;}
    public List<SelectOption> cnName{get;set;}    
    public Set<string> customerLeftValues{get;set;}
    public List<FMS_Subscription__c>  subscpList;
    public String latestFormId;
  
 
   
    public FMSSubscribeOtherUserCtrl() {
        subscribe = new FMS_Subscription__c();
        formId = ApexPages.currentPage().getParameters().get('id');
        baseURL = ApexPages.currentPage().getParameters().get('baseURL');
        cnName = new List<SelectOption>();
        customerLeftValues = new Set<String>(); 
        Contact dmeaCont;
        lstCont = new list<String>();
        subscpList = new List<FMS_Subscription__c>();
        
        latestFormId=getLatestSPForm(formId); //Ravindra - Changes for subscribing latest step plan
       
        
        if(UserInfo.getUserType()!='Standard'){
            isExternalUser = true;            
        }else {
            isExternalUser = false;
        }
        
        if(isExternalUser){
            
            User loggedInUser = [SELECT id, Name, ContactId FROM User WHERE id = :UserInfo.getUserId() LIMIT 1];
            dmeaCont = [SELECT id, Name,account.name,accountid,Account.SAP_Account_Number__c FROM Contact WHERE id = :loggedInUser.ContactId LIMIT 1]; 
            accId.add(dmeaCont.accountid);
            
            
            String currentAccId = dmeaCont.accountid;
            for(Account_Hierarchy__c ahc : [select parent_id__c,account_id__c from Account_Hierarchy__c where Account_Id__c =:currentAccId ]){
                accId.add(ahc.parent_id__c);
            }       
             // Code added by Ram Rai to show FMS enable Contact  
            for(Contact cn : [SELECT id, Name,account.name,(select id from Access_Setup__r where Tapeout_Fab_9_10__c =true limit 1),accountid,Account.SAP_Account_Number__c FROM Contact WHERE (accountid in:accId and ( Is_Portal_User_Active__c =true and Is_Portal_User_Created__c =true))]){ 
                for(Portal_Tab_Access__c a : cn.Access_Setup__r){
                    if(dmeaCont.id != cn.id)
                        cnName.add(new SelectOption(cn.id,cn.name));
                }                
            }
            
            if(cnName.ISEMPTY()){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No user available to subscribe'));
                noUser = true;
            }
            
        }  
    }
    
    
    public PageReference subscribeOnSubmit() {
        
        Id userId;
        
        if (subscribe.User_Name__c != null) {
            if(!isExternalUser )
                userId = subscribe.User_Name__c;
            else
                userId = subscribe.User_Name__c;
        }
        
        User loggedInUser1;
        
        if(isExternalUser){
            loggedInUser1 = [SELECT id, Name, ContactId FROM User WHERE ContactId  = :selectedAccId limit 1];
        } else {
            
            if(String.isNotBlank(internalUserId ))
                loggedInUser1 = [SELECT id, Name, ContactId FROM User WHERE id= :internalUserId ];
        }
        
        String userNm = '';
        if(loggedInUser1 !=null){            
            //Ravindra - Changes for subscribing latest step plan
            userNm = loggedInUser1.id;
               
        }else{            
            //Ravindra - Changes for subscribing latest step plan
            userNm = internalUserId;
        }
        // Added the sharing for Subscription Object 1Sept2017 
        subscpList = [SELECT id,Form_Id__c FROM FMS_Subscription__c WHERE  User_Name__c =:userNm and (Form_Inserted__c = true or Form_Status_Change__c = true or Form_Updated__c=true or Form_Deleted__c = true) and Form_Id__c =:latestFormId and Saved_Search_Id__c = null]; 
        system.debug('-subscpList -'+subscpList );
        if( subscpList  ==null || subscpList.size() ==0 ){
            
            if(userId != UserInfo.getUserId()) {
              //  if ([select count() from FMS_Subscription__c WHERE Form_Id__c = : formId and User_Name__c = : userId and MySubscriptionId__c = '' and Saved_Search_Id__c = ''] == 0) {
              //  
              //  //Ravindra - Changes for subscribing latest step plan
                if ([select count() from FMS_Subscription__c WHERE Form_Id__c = : latestFormId and User_Name__c = : userId and MySubscriptionId__c = '' and Saved_Search_Id__c = '' and (Form_Inserted__c = true or Form_Status_Change__c = true or Form_Updated__c=true or Form_Deleted__c = true)] == 0) {
                    
                    User loggedInUser ;
                    if(isExternalUser){
                        loggedInUser = [SELECT id, Name, ContactId FROM User WHERE ContactId  = :selectedAccId LIMIT 1];
                    }  
                    List<FMS_My_Subscription__c> fmsMySubList = [SELECT id,Subscribed_All__c,Subscribed_Date__c,UnSubscribed_Date__c,UserName__c from FMS_My_Subscription__c where UserName__c =:Userinfo.getUserId()];   
                    FMS_My_Subscription__c fmsMySub = new FMS_My_Subscription__c();
                    fmsMySub.Subscribed_All__c = true;
                    fmsMySub.Subscribed_Date__c = system.today();
                    if(isExternalUser){
                        loggedInUser = [SELECT id, Name, ContactId FROM User WHERE ContactId  = :selectedAccId LIMIT 1];
                        fmsMySub.UserName__c = loggedInUser.id;
                    }                 
                    else{
                        if(String.isNotBlank(internalUserId ))
                            fmsMySub.UserName__c = internalUserId;
                        else{
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select any user');
                            ApexPages.addMessage(myMsg);
                            return null;
                        }
                        
                    }
                  //  try{ 
                        system.debug('--fmsMySub-'+fmsMySub);
                        insert fmsMySub;
                  //  } Catch(Exception Ex){}
                    
                    FMS_Subscription__c fmsSubscribe = new FMS_Subscription__c();      
                    fmsSubscribe.Form_Id__c = latestFormId;
                    fmsSubscribe.Form_Inserted__c = true;
                    fmsSubscribe.Form_Status_Change__c = true;
                    fmsSubscribe.Form_Updated__c = true;
                    fmsSubscribe.Form_Deleted__c = true;
                    fmsSubscribe.MySubscriptionId__c = fmsMySub.id;
                    
                    if(isExternalUser){
                        
                        loggedInUser = [SELECT id, Name, ContactId FROM User WHERE ContactId  = :selectedAccId LIMIT 1];
                        
                        fmsSubscribe.User_Name__c = loggedInUser.id;
                    }
                    else{
                        
                        if(String.isNotBlank(internalUserId ))
                            fmsSubscribe.User_Name__c = internalUserId;
                        else{
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select any user');
                            ApexPages.addMessage(myMsg);
                            return null;
                        }
                        
                    }
                    
                    fmsSubscribe.Subscribed_Date__c = system.today();
                //    try{
                        
                        system.debug('--fmsSubscribe-'+fmsSubscribe);
                        insert fmsSubscribe;
                        
                        
                        List<User> usrList = new  List<User>();
                        usrList  = [select id from user where id =: internalUserId and IsPortalEnabled=true];
                        Id usId;
                        if(usrList  !=null && usrList.size()>0){
                            usId = usrList[0].id;
                        }
                        
                        FMS_Subscription__Share fmsRecordShare1 = new FMS_Subscription__Share();
                        if(isExternalUser){
                            loggedInUser = [SELECT id, Name, ContactId FROM User WHERE ContactId  = :selectedAccId LIMIT 1];
                            fmsRecordShare1 .UserOrGroupId = loggedInUser.id;
                        }else{
                            fmsRecordShare1 .UserOrGroupId = internalUserId ;
                        }
                        
                        
                        fmsRecordShare1.ParentId = fmsSubscribe.Id;
                        fmsRecordShare1.AccessLevel = 'Edit';
                        try{
                            if(fmsRecordShare1.UserOrGroupId !=null)
                                insert fmsRecordShare1;
                        } Catch (Exception Ex){}
                        FMS_My_Subscription__Share fmsRecordShare = new FMS_My_Subscription__Share();
                        
                        fmsRecordShare.ParentId = fmsMySub.Id;
                        
                        if(isExternalUser){
                            loggedInUser = [SELECT id, Name, ContactId FROM User WHERE ContactId  = :selectedAccId LIMIT 1];
                            fmsRecordShare.UserOrGroupId = loggedInUser.id;
                        } 
                        
                        else{
                            fmsRecordShare.UserOrGroupId = internalUserId ;
                        }
                        
                        fmsRecordShare.AccessLevel = 'Edit';
                        if(fmsRecordShare.UserOrGroupId !=null)
                            try{
                                insert fmsRecordShare;
                            }Catch(Exception Ex){}
                        
                        
                 //   } catch(Exception e){
                  //      UtilityCls.saveExceptionLog(FMSSubscribeOtherUserCtrl.class.getName(), 'subscribeOnSubmit()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
              //      }
                    
                    List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
                    List<Form_Management_System__c> fms = new List<Form_Management_System__c>([select Customer__c,Name__c,Customer_Name__c,Customer_Name__r.Name ,CreatedBy.Name,LastModifiedBy.Name,CreatedBy.Email,LastModifiedBy.Email,CreatedDate,LastModifiedDate,Form_Name__c,Name,Form_Description__c,State_of_the_Form__c, Form_Type__c,ID,Days_left_for_deletion__c,Parent_Form_Id__c,Parent_Form_Id__r.Name from Form_Management_System__c where Id =:fmsSubscribe.Form_Id__c]);
                    Set<String> uId = new Set<String>();
                    
                    uId.add(fmsSubscribe.User_Name__c);
                    //19-07-2017....email issue...#IM
                    Map<Id, Form_Management_System__c> fmMap = FMSEmailTemplates.getPrimaryStepPlanMap(fms);
                    messages.add(FMSEmailTemplates.createTemplate(fmMap.get(fms[0].Id), null, Label.Form_On_Behalf_Email, uId));
                    Messaging.SendEmailResult[] results;
                    if(!messages.isEmpty()){
                        try{
                            results = Messaging.sendEmail(messages);
                        }Catch(Exception Ex){
                            if(Ex.getMessage().contains('INVALID_EMAIL')){
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Email Id');
                                ApexPages.addMessage(myMsg);
                            }
                            
                            return null;
                        }
                        for(Messaging.SendEmailResult res: results){
                            if (!res.success) {
                                
                            }
                        }
                    }
                    
                    PageReference pg = new PageReference(baseURL);
                    pg.setRedirect(true);
                    return pg;
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The opted user is already subscribed to the Form'));
                    return null;
                } 
            } else {            
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The opted user is already subscribed to the Form'));
                return null;
            }
        } else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Selected User is already subscribed to this form'));
            return null;
            
        }
        return null;
    }
    
    public PageReference subscribeCancel() {
        PageReference pg = new PageReference(baseURL);
        pg.setRedirect(true);
        return pg;
    }
    
       //Ravindra - Added method for getting latest Step Plan (Starts)
    public String getLatestSPForm(String spFormId){
        String ltformId;
        try{
        Form_Management_System__c formObj = [SELECT id,Latest_Step_Plan__c FROM Form_Management_System__c WHERE id = :spFormId];  
        if(formObj.Latest_Step_Plan__c!=null){
           ltformId =formObj.Latest_Step_Plan__c;
        }
        else{
           ltformId=formObj.id;
        }
       }
        catch (Exception e){
             UtilityCls.saveExceptionLog(FMSSubscribeOtherUserCtrl.class.getName(), 'getLatestSPForm()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
      return ltformId;
    }
    //Ravindra - Added method for getting latest Step Plan (ends)
}