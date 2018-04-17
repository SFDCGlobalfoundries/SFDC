/*
* @ Author :- Devendra
* @ Description :- Super user functionality 
* @ Date :-23/01/2017
* @ Change History :-  	
**/
public with sharing class DWC_SuperUserCtrl {
	public boolean isSuperUser{get;set;}
	public list<user> fabUsers{get;set;}
    public string selectedGroup{get;set;}
    public groupmember newuser{get;set;}
    public string rmvid{get;set;}
    public DWC_SuperUserCtrl(){
    	rmvid='';
    	fabUsers=new list<user>();
    	newuser=new groupmember();
    	set<id> dwcSuperUserIds= DfmUtilityCls.getUsersFromPublicGroup('DWC_Super_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_Super_Users').keySet():NULL;
    	
    	if(dwcSuperUserIds!=null && dwcSuperUserIds.contains(userinfo.getuserId())){
    		isSuperUser=true;
    	}else{
    		isSuperUser=false;
            
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Only Super User can access this page'));          	 
    	}
    	selectedGroup='Fab1_CollaboratorReader';
        getUsers();
        
    }
    
    public pagereference addMember(){
    	if(newuser.userorgroupid!=null && selectedGroup!=null){
    		Group grp=[SELECT id,DeveloperName FROM Group WHERE DeveloperName = :selectedGroup limit 1];
    		newuser.groupid=grp.id;
    		insert newuser;
    		newuser=new groupmember();
    		getUsers();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'User successfully added'));
    	}else{
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select the user'));
    	}
    	return null;
    }
    
    public pagereference removeMember(){
    	if(rmvid!=null){
    		delete [select id from groupmember where userorgroupid=:rmvid];
    	}
    	getUsers();
    	return null;
    }
    
    public List<SelectOption> getgroups() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Fab1_CollaboratorReader','Fab1_CollaboratorReader'));
            options.add(new SelectOption('Fab7_CollaboratorReader','Fab7_CollaboratorReader'));
            options.add(new SelectOption('Fab8_CollaboratorReader','Fab8_CollaboratorReader'));
            options.add(new SelectOption('Fab10_CollaboratorReader','Fab10_CollaboratorReader'));
            return options;
        }
        
    public void getUsers(){
    	fabUsers=new list<user>();
    	if(selectedGroup!=null){
    		set<id> userids = DfmUtilityCls.getUsersFromPublicGroup(selectedGroup)<>NULL ?DfmUtilityCls.getUsersFromPublicGroup(selectedGroup).keyset():NULL;
    		fabUsers=[select id,name from user where id in:userids];
    	}
    }
    
    public void sendMail() {
        List<Messaging.SingleEmailMessage> notifymails = new List<Messaging.SingleEmailMessage>();
        List<EmailTemplate> template = [SELECT Id,Name,DeveloperName,HtmlValue,subject,body FROM EmailTemplate WHERE DeveloperName='DWC_Generic_Template'];
		
        set<String> idList = new set<String>();
        List<String> mailToAddresses = new List<String>();
        Group g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE DeveloperName = 'DWC_Super_Users'];
        for (GroupMember gm : g.groupMembers) {
        idList.add(gm.userOrGroupId);
        }
        User[] usr = [SELECT email FROM user WHERE id IN :idList];
        for(User u : usr) {
        mailToAddresses.add(u.email);
        }
        
      string collid= ApexPages.currentPage().getParameters().get('id');
      system.debug('collaboratorID'+collid);
      Wavier_Collaborator__c wc =[select id, FAB__c from Wavier_Collaborator__c where id=:collid];
      string fabName=wc.FAB__c;
        // string newbody ='';
        // if(template[0].body.containsignorecase('Username')){
        //  newbody=template[0].body.replaceAll('Username', userinfo.getName());         
        
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //mail.setTargetObjectId('005O0000003keeB');
        //mail.setTemplateId(template[0].id);
        mail.setToAddresses(mailToAddresses);
        mail.setSubject(template[0].subject);
        //mail.setPlainTextBody(template[0].body.replaceAll('Username', userinfo.getName()));
       // mail.setHtmlBody(template[0].HtmlValue.replaceAll('Username', userinfo.getName())); 
        mail.setWhatId(wc.id); 
        mail.setHtmlBody(template[0].HtmlValue.replace('FAB',fabName).replace('Username', userinfo.getName())); 
        mail.setCcAddresses(new list<string>{userinfo.getUserEmail()});
        mail.setSaveAsActivity(false);
        //system.debug('mail****'+mail);
        notifymails.add(mail);
        if(notifymails.size()>0){
           
        Messaging.sendEmail(notifymails);
      	//system.debug('Error****'+notifymails);
        }
   
    }
    
}