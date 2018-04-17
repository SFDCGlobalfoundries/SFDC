/*
    Company:        Cognizant Technology Solution
    Description:    Batch Class to send Email in there are any Reticles pending for Inactive to Active Verification
    History:
    NJain    23-Sep-14    Created the class
    NJain    13-Oct-14    Added all fields that were visible in ROS page view under Verification category in the Email
*/
public class ROS_BATCH_InactiveToActiveEmail implements Database.Batchable<sObject>,Database.Stateful{
    
    public List<Reticle__c> lstReticlesForVerification;
    
    public ROS_BATCH_InactiveToActiveEmail(){
         lstReticlesForVerification = new List<Reticle__c>();
    }
    public Database.QueryLocator start(Database.BatchableContext BC){    
        String query;
        if(Test.isRunningTest()){
            query= ' Select Id,Account__r.name, Name, IsActive__c,Reticle_Type__c, GlobalFoundries_Device_ID__c, '+
                   ' Device_ID__c, FabStr__c, Day_Inactive_Formula__c, New_Inactive_Days_Formula__c, '+
                   ' Reticle_Workflow_Status__c,ROS_Status__c ' + 
                   ' FROM Reticle__c WHERE New_Inactive_Days__c != NULL LIMIT 1';
        }else{
            query= ' Select Id,Account__r.name, Name, IsActive__c,Reticle_Type__c, GlobalFoundries_Device_ID__c, '+
                   ' Device_ID__c, FabStr__c, Day_Inactive_Formula__c, New_Inactive_Days_Formula__c, '+
                   ' Reticle_Workflow_Status__c,ROS_Status__c ' + 
                   ' FROM Reticle__c WHERE New_Inactive_Days__c != NULL';
        }
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC ,List<Reticle__c> scope){
        for(Reticle__c ret:scope){
            lstReticlesForVerification.add(ret);
        }
    }
    
    public void finish(Database.BatchableContext bc){
    
        system.debug('##lstReticlesForVerification##'+lstReticlesForVerification);
        
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,  
                            TotalJobItems, CreatedBy.Email, ExtendedStatus  
                            from AsyncApexJob where Id = :BC.getJobId()];  
                            
        if(lstReticlesForVerification != NULL && !lstReticlesForVerification.isEmpty()){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
            List<String> toAddresses = new List<String>();
            if(System.Label.ROS_EmailPendingVerification != NULL && System.Label.ROS_EmailPendingVerification != ''){
                toAddresses.addAll(System.Label.ROS_EmailPendingVerification.split(';'));
            }else{
                toAddresses.add('parveen.aggarwal@globalfoundries.com.test');
            }
            mail.setToAddresses(toAddresses);  
            mail.setSubject('Reticles pending for Inactive to Active verification');  
    
            String body;
            body = 'Hi Team,<br/><br/>Following ' + lstReticlesForVerification.size() + ' Reticles are pending for Inactive to Active Verification.<br/><br/>';
            lstReticlesForVerification.sort();
            body += '<html><body><table border="1" style="border-collapse: collapse;">';
            body += '<tr><th>Account Name</th><th>Reticle Id</th><th>Reticle Type</th><th>GF Device Id</th>';
            body +=     '<th>Customer Device Id</th><th>Fab</th><th>Inactive Days</th><th>New Inactive Days</th>';
            body +=     '<th>Reticle Workflow Status</th><th>Disposition Type</th></tr>';
            
            for(Reticle__c reticle: lstReticlesForVerification){
                body += '<tr><td>' + reticle.Account__r.name+'</td>' +
                            '<td>' + reticle.name + '</td>' +
                            '<td>' + reticle.Reticle_Type__c +'</td>' +
                            '<td>' + reticle.GlobalFoundries_Device_ID__c + '</td>' + 
                            '<td>' + reticle.Device_ID__c + '</td>' +
                            '<td>' + reticle.FabStr__c + '</td>' + 
                            '<td>' + Integer.valueOf(reticle.Day_Inactive_Formula__c) + '</td>' +
                            '<td>' + Integer.valueOf(reticle.New_Inactive_Days_Formula__c) + '</td>' +
                            '<td>' + reticle.Reticle_Workflow_Status__c + '</td>' +
                            '<td>' + NULLCHECK(reticle.ROS_Status__c) + '</td></tr>';
            }
            
            body += '</html></body></table>\n';            
            body += '<br/>Request you to please process these Reticles accordingly.<br/>';
            body += '<br/>Thanks and Regards,<br/>ROS System';
            mail.setHTMLBody(body);
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    public String NULLCHECK(String inputValue){
        if(inputValue != NULL){
            return inputValue;
        }else{
            return '';
        }
    }
}