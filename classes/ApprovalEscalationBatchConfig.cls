/******************************************************************************************************************************
Class:         ApprovalEscalationBatchforConfig
-------------------------------------------------------------------------------------------------------------------------------
Author:        Karna Shiva (GF - 1016934)
Created Date:  06/04/2016
Reason:        Batch class will send escalation email to Approvers managers when approval request is pending more than equals to
               5 days.
History:       

*******************************************************************************************************************************/
global class ApprovalEscalationBatchConfig implements Database.batchable<sobject>{

global String ObjectName,Status;
global integer days;
public String  oldRecordManager,multipleObjectid='',ElapsedTimeInDays='';
public Id oldactorid,actorid,oldManagerId,managerId ;

global approvalEscalationBatchConfig(String ObjectName, Integer Days, String Status){

    this.ObjectName=ObjectName;
    this.Days = Days;
    this.Status = Status;
}

String Query ='SELECT ActorId,CreatedDate,ElapsedTimeInDays,Id,ProcessInstanceId, processinstance.TargetObjectId FROM ProcessInstanceWorkitem  where ProcessInstanceid in('+
                 ' select ProcessInstanceid FROM ProcessInstanceNode p WHERE '+
                 ' p.NodeStatus =:Status and p.processInstance.targetobject.type =:ObjectName' +
                 ' ) and ElapsedTimeInDays > :Days Order by Actorid';

    global Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(Query);   
}
    
global void execute(Database.BatchableContext BC, list<ProcessInstanceWorkitem> scope){      

    
List<id> PublicGroupids = new List<id>();
List<id> Configids = new List<id>();
List<String>  ManagerEmailids = new List<String>();
Map<id,string> mapProcessDetail = new Map<id,string>();
Map<id,String> mapConfigPending = new Map<id,String>();

for(ProcessInstanceWorkitem op:scope){
  
  if(op.Actorid == oldactorid)
  {
    multipleObjectid = multipleObjectid +','+ op.processinstance.TargetObjectId;
     
      ElapsedTimeInDays = ElapsedTimeInDays+','+  String.valueOf(op.ElapsedTimeInDays);
      
     mapProcessDetail.put(op.actorid,multipleObjectid);
    
      
  }else{
       multipleObjectid = op.processinstance.TargetObjectId;
       oldactorid = op.Actorid;
       mapProcessDetail.put(op.actorid,multipleObjectid);
     
    }
       PublicGroupids.add(op.ActorId);
      Configids.add(op.processinstance.TargetObjectId);
    
    ElapsedTimeInDays = String.valueof(Integer.valueOf(op.ElapsedTimeInDays));
    
    mapConfigPending.put(op.processinstance.TargetObjectId,ElapsedTimeInDays); 

 }

Map<id,String> mapConfigDetail = new Map<id,String>();

List<Apttus_Proposal__Proposal__c> configdetailsQuery = [ select Device__r.Name,Current_Forecast_Tapeout_Date__c,Name,Fab_Name__c,Process_Technology_Name__c,id from Apttus_Proposal__Proposal__c where id in:Configids];

for (Apttus_Proposal__Proposal__c app: configdetailsQuery ) {
  mapConfigDetail.put(app.id,app.Name+',,'+app.Process_Technology_Name__c+',,'+app.Fab_Name__c+',,'+app.Device__r.Name+',,'+app.Current_Forecast_Tapeout_Date__c);
 }

List<user>  ussr =[select Name,Manager.Name,Manager.email,Manager.id from user where id in(Select UserOrGroupId From GroupMember Where Group.type='Queue' and GroupId In :PublicGroupids)  and ( Not Manager.email like '%example%') order by Manager.name];

Map<id,String> mapManagerDetail = new Map<id,String>();

String usernames='',manyNames='';

for (User p: ussr) {

  if(p.Manager.id == oldManagerId){
  
    if(usernames <> null) {
         manyNames = usernames+','+p.Name;
     }
     else{
         manyNames = ','+manyNames + ','+p.Name;
     }
               
     usernames = '';
     mapManagerDetail.put(p.Manager.id,manyNames);
   
  }else{
       usernames = p.Name;
       oldManagerId = p.Manager.id;
       
       mapManagerDetail.put(p.Manager.id,usernames);
         
  }
}

List<Messaging.SingleEmailMessage> multmail = new List<Messaging.SingleEmailMessage>();

List<user>  mssr =[select Manager.Name,Manager.email,Manager.id from user where id in(Select UserOrGroupId From GroupMember Where Group.type='Queue' and GroupId In :PublicGroupids)   and ( Not Manager.email like '%example%') order by Manager.name];
    
List<OrgWideEmailAddress> orzemail = [select address,id  from OrgWideEmailAddress where address like'sfdc%' limit 1];

List<Group> GrpDetails = [Select Name,id From Group Where Id In :PublicGroupids];

Map<id,String> mapGroupDetailName = new Map<id,String>();

for (Group Grp: GrpDetails) {
   mapGroupDetailName.put(Grp.Id,Grp.Name);
}

List<GroupMember> GrpMembers = [Select UserOrGroupId,Groupid From GroupMember Where Group.type='Queue' and GroupId In :PublicGroupids];

Map<id,String> mapGroupDetail = new Map<id,String>();

for (GroupMember GrpMem: GrpMembers) {
   mapGroupDetail.put(GrpMem.UserOrGroupId,GrpMem.Groupid);
}
OrgWideEmailAddress orgemailid= [select id, Address from OrgWideEmailAddress where Address like'noreply%' limit 1];
    
for(User Usr :mssr) {

String  UsrNames  ='',Configuratordetail='';
  
   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
  String[] toAddresses = new String[] {Usr.Manager.Email};
  
  mail.setOrgWideEmailAddressId(orgemailid.id);
 
   mail.setToAddresses(toAddresses);
   mail.setTargetObjectId(usr.manager.id);
  
   Configuratordetail = '<table border="1"><tr><th>Configuration</th><th>Technology</th><th>Fab Name</th><th>Pending Days</th><th>Device Name</th><th>Forecast TO Date</th></br>';
    
    for(String ConfiguratorDetailsMapResult : mapProcessDetail.get(mapGroupDetail.get(Usr.id)).split(',')){

       string days = mapConfigPending.get(ConfiguratorDetailsMapResult);
       
    String[] ProposalDetails = mapConfigDetail.get(ConfiguratorDetailsMapResult).split(',,');
    
    Configuratordetail  += '<tr><td><a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/'+ConfiguratorDetailsMapResult +' > '
     +ProposalDetails[0]+'</a> </td> <td>'+ ProposalDetails[1] +'</td><td>'+ProposalDetails[2]+'</td><td>'+days+'</td>'+'</td><td>'+ProposalDetails[3]+'</td>'+'</td><td>'+ProposalDetails[4]+'</td></tr>';
 }   
  Configuratordetail  += '</table>';
  mail.setSubject('Escalation Email for Configuration approval for Pending more than 5 days ');
  mail.setSaveAsActivity(false);
     
  String body = 'Dear '+Usr.Manager.Name+',';
   
   body += '<br/>';
   body += '<br/>';   
   body += '<b>This is an escalation email. Following Configurations are submitted for approval & are pending for more 5 days.</b>';
   body += '<br/>';   
   body += '<br/>'; 
   body += '<b>Please close them or assign it to the right queue member to approve and close.</b>';
   body += '<br/>';  
   body += '<br/>';      
   body += '<b>List of Configurations pending approval for more than 5 days.</b>';
   body += '<br/>';  
   body += '<br/>';  
   body += Configuratordetail;
   body += '<br/>';  
   body += '<br/>'; 
   body += 'Best and Regards,'+'<br/>'+'<b>Configurator Team</b>';  
   mail.setHtmlBody(body); 
   
   body ='';
  if(Usr.manager.Name <> oldRecordManager && Usr.Manager.email <> null){
      multmail.add(mail);
          oldRecordManager=Usr.manager.Name;
           system.debug('Manager name in add email'+ Usr.manager.name);
      }
    }
 try{
  Messaging.sendEmail(multmail);  
  }
  catch(exception e)
  {
  system.debug(e);
  }
 }
global void finish(Database.BatchableContext BC){
  }
}