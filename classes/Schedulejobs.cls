/*  Author : Ashwini Dengi
    Description : This Batch class is used to send a mail for scheduled jobs expiring in one month.
    Code Creation: 7/22/2015
    */

global Class Schedulejobs implements Database.Batchable<Sobject>{
    String Query;
   
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        datetime a= system.today().addmonths(1);
        if(!Test.isRunningTest()){
        Query='SELECT Id, CronJobDetailId, NextFireTime,CronJobDetail.Name,CronJobDetail.Jobtype, EndTime,CreatedById FROM CronTrigger where EndTime<=:a ORDER BY EndTime ASC NULLS LAST ';
        }else{
        Query='SELECT Id, CronJobDetailId, NextFireTime,CronJobDetail.Name,CronJobDetail.Jobtype, EndTime,CreatedById FROM CronTrigger limit 100';
        }
        
        return Database.getQueryLocator(Query);
    }
    global void execute(Database.BatchableContext BC, List<CronTrigger> scope)
    {
        
        Map<ID,CronTrigger> map1 = new Map <ID,CronTrigger>();
        
        
            For(CronTrigger r:scope){
                
                map1.put(r.CronJobDetailId,r);
                
                
            }
           Map<ID,String>map2 = new map<ID,String>();
           Map<ID,String>map3 = new map<ID,String>();
           List<User> runninguser = [SELECT Id,name FROM user];
           For(User u:runninguser ){
           map2.put(u.Id,u.Name);
           
           }
           
           List<Report> reportname = [SELECT Id,name FROM Report];
           For(Report rp :reportname ){
           Map3.put(rp.Id,rp.name);
           }
           List<Dashboard> dash=[SELECT Id,Title FROM Dashboard];
           for(Dashboard d:dash){
           Map3.put(d.Id,d.Title);
           }
            String tableBody = '';
            for(Id cjId : Map1.keySet()){
                If(Map1.get(cjId).NextFireTime !=null) {
                    tableBody += '<tr><td>';
                  If(Map1.get(cjId).CronJobDetail.Jobtype=='1'||Map1.get(cjId).CronJobDetail.Jobtype=='7'||Map1.get(cjId).CronJobDetail.Jobtype=='A'||Map1.get(cjId).CronJobDetail.Jobtype=='4'||Map1.get(cjId).CronJobDetail.Jobtype=='9'||map3.get(Map1.get(cjId).CronJobDetail.Name)== null)
                      tableBody += (Map1.get(cjId).CronJobDetail.Name);
                  else
                    tableBody += map3.get(Map1.get(cjId).CronJobDetail.Name);
                    tableBody += '</td>';
                    tableBody += '<td>';
                    tableBody += Map1.get(cjId).NextFireTime;
                    tableBody += '</td>';
                    tableBody += '<td>';
                    tableBody += Map1.get(cjId).EndTime;
                    tableBody += '</td>';
                    tableBody += '<td>';
                    tableBody += map2.get(Map1.get(cjId).CreatedById);
                    tableBody += '</td></tr>';
                  }
            }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'dl.IT.Salesforce_Admin@globalfoundries.com'};
        mail.setToAddresses(toAddresses);
        string  fromaddress = 'Noreply_salesforce@globalfoundries.com';
        mail.setReplyTo(fromaddress);
        mail.setSenderDisplayName(fromaddress);
        mail.setSubject('List of Scheduled jobs expiring in next month');
        String messageBody = '<html><body>Dear team <br><br>Please find below list of scheduled jobs which are going to expire on given end time.<br><br><table border=\"1\" style=\"width:100%\"><tr><th>Job Name</th><th>Next Scheduled Run</th><th>End Time</th><th>Running User</th> </tr>'+tableBody +'</table><br><br>Thank you.</body></html>';
        mail.setHtmlBody(messageBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    
    }
    
         
    global void finish(Database.BatchableContext BC)
    {
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
        mail.setSubject('Scheduled job status' + a.Status);
        mail.setPlainTextBody('The batch Apex "Schedulejobs" job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}