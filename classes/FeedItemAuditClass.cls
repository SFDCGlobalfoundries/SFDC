/*  Author : Ashwini Dengi
    Description : This Batch class is used to send the confidential file uploaded in chatter to chatter auditors for review.
    Code Creation: 21/11/2014
    */

global Class FeedItemAuditClass implements Database.Batchable<ContentVersion>{
    global Iterable<ContentVersion> start(Database.BatchableContext bc) {
        String s1='';
        Integer i;
        List<List<sObject>> lstListObj = new List<List<sObject>>();
        List<Chatter_Audit_Setting__c> chatterVal = [Select Exact_Match_Terms__c,ID FROM Chatter_Audit_Setting__c];
        for(i=0;i<chatterVal.size();i++){
            s1 += '\"'+chatterVal[i].Exact_Match_Terms__c+'\"'+' OR ';
        }
        s1=s1.substring(0, s1.length()-4);
        String searchQuery = 'FIND \'' +s1+'\' IN ALL FIELDS RETURNING ContentVersion(ID,Title,PublishStatus,ContentDocumentId,OwnerId,ContentModifiedDate)limit 2000';
        lstListObj = search.query(searchquery);
        return (List<ContentVersion>)lstListObj [0];
   }

   global void execute(Database.BatchableContext bc, List<ContentVersion> scope) {
        List<Flagged_File_Post__c> lstExistFlagpostdata=new List<Flagged_File_Post__c>([select Id,Chatter_File_ID__c from Flagged_File_Post__c]);
        List<Flagged_File_Post__c> listFlagFilePost = new List<Flagged_File_Post__c>();
        List<ContentDocumentLink>  Linktoauditors = new List<ContentDocumentLink>();
        List<Chatter_Audit_Date__c> Datetostartinsert = [Select Start_Date__c,ID FROM Chatter_Audit_Date__c];
        Map<ID,Flagged_File_Post__c> map1 = new Map<ID,Flagged_File_Post__c>();
        ID gfauditID;
        Organization orgDetails = [SELECT Id, LanguageLocaleKey FROM Organization WHERE Id = :UserInfo.getOrganizationId() limit 1];
        if(!Test.isRunningTest()){
             gfauditID = [select ID from CollaborationGroup where Name = 'GF Chatter Auditors'].ID;
        }else{
             gfauditID = [select ID from CollaborationGroup where Name = 'GF Chatter Auditorss'].ID;
        }
       
        for(Flagged_File_Post__c flg:lstExistFlagpostdata)
        {
            map1.put(flg.Chatter_File_ID__c,flg);
        }
       system.debug('lstExistFlagpostdata'+lstExistFlagpostdata);
       Map<ID,string> map2 = new Map<ID,string>();
       String uName;
       List<user> ownerids = [select Name,ID from user];
       for(user u:ownerids)
       {
           map2.put(u.ID,u.Name);
       }
        //Inserting a record in FlaggedFilePost and ContentdocumentLink.
        
        for (ContentVersion r:scope){
        
            if(!map1.containsKey(r.ContentDocumentId)){
                if(r.ContentModifiedDate>=Datetostartinsert[0].Start_Date__c){
                    List<ContentDocumentLink> sharing = [Select ContentDocumentId,LinkedEntityId,ShareType,Visibility from ContentDocumentLink where ContentDocumentId =:r.ContentDocumentId];
                    for(ContentDocumentLink g:sharing){
                        if(g.LinkedEntityId == orgDetails.ID){
                        Flagged_File_Post__c f = new Flagged_File_Post__c();
                        f.Chatter_File_ID__c = r.ContentDocumentId;
                        system.debug('r.ContentDocumentId'+r.ContentDocumentId);
                        f.File_Name__c = r.Title;
                        f.Chatter_File_Verified__c = false;
                        f.Comments__c = 'need to check';
                        if(map2.containsKey(r.OwnerId))
                        {
                            uName=map2.get(r.OwnerId);
                            
                        }
                        f.File_owner_name__c = uName;
                        f.File_uploaded_date__c = r.ContentModifiedDate;
                        listFlagFilePost.add(f);
                        ContentDocumentLink a= new ContentDocumentLink();
                        a.ContentDocumentId = r.ContentDocumentId;
                        a.LinkedEntityId = gfauditID;
                        a.ShareType = 'V';
                        a.Visibility = 'AllUsers'; 
                        Linktoauditors.add(a);
                        }
                    }
                    
                }
            }
        }
        
        try{
        Database.insert(listFlagFilePost,false); 
        Database.insert(Linktoauditors,false);
        }catch(Exception e)
        {
            e.getMessage();
        }
       for(Flagged_File_Post__c fg : listFlagFilePost){
            integer k=0;
           if(!map1.containsKey(fg.Chatter_File_ID__c)){
                // Get the report ID
               if(!Test.isRunningTest()){
                List <Report> reportList = [SELECT Id,DeveloperName FROM Report where 
                DeveloperName = 'Flagged_File_Post_For_Review'];
                String reportId = (String)reportList.get(0).get('Id');
                // Run the report
                Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);
               }
               else{
               }
                Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
                List<ID> usersidtosendemails = new List<ID>();
                For(CollaborationGroupMember q : [SELECT MemberId FROM CollaborationGroupMember WHERE CollaborationGroupId =:gfauditID]){
                    usersidtosendemails.add(q.MemberId);
                }
                Id templateId = [select id, name from EmailTemplate where developername =: 'Chatter_Audit'].id;
                mail.settargetObjectIds(usersidtosendemails);
                mail.setTemplateId(templateId);
                mail.setSaveAsActivity(false); 
                string  fromaddress = 'sfdc_support@globalfoundries.com';
                mail.setReplyTo(fromaddress);
                mail.setSenderDisplayName('system support');
                Messaging.sendEmail(new Messaging.MassEmailMessage[] {mail});
                k=k+1;
                }
                If(k==1)
                    Break;   
           
       
    }
   
   }

    global void finish(Database.BatchableContext bc) {
        
        // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob WHERE Id =
                            :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        If(a.NumberOfErrors > 0){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'dl.IT.Salesforce_Admin@globalfoundries.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Chatter Audit for non compliance uploaded files ' + a.Status);
        mail.setPlainTextBody('The batch Apex "FeedItemAuditClass" job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    
    }
}