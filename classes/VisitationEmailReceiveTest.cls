/*Author: Vijay Vemuru
    Description: This Test class is for Visitation Inbound Email Handler
    History:
    Created     -     Vijay Vemuru-    04/06/2016      - code creation.
*/
@isTest(seeAllData=false)
private class VisitationEmailReceiveTest {
	
	@testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'GLOBALFOUNDRIES INTERNAL');
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_RESELLER'));
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
                
        AccountDataFactory.createAccount(fieldValueMap);
    }

    static testMethod void myTestMethod() {
    
        String AccId = [SELECT id FROm Account LIMIT 1].id;
        Visitation_Record__c CVA = new Visitation_Record__c();
	        CVA.Account__c = AccId;
	        CVA.Visit_Name__c = 'Test';
	        CVA.Visit_Type__c = 'Visit from Customer';
	        CVA.Add_as_attendee_Escort__c = TRUE;
	        CVA.Add_as_attendee_Requestor__c =TRUE;
	        CVA.Add_as_attendee_Host__c = TRUE;
	        CVA.Start_Date__c = System.Today().addDays(1);
	        CVA.End_Date__c = System.Today().addDays(3);
	        CVA.Purpose__c = 'QBR';
	        CVA.Visit_Location__c = 'Singapore';
        insert CVA;
        CVA = [SELECT name From Visitation_Record__c WHERE id=:CVA.id];
        
       // Create a new email, envelope object and Attachment
       Messaging.InboundEmail email = new Messaging.InboundEmail();
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
       Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
       email.subject = 'test#'+((CVA.name==null || CVA.name == '')?'testname':CVA.name)+' - Please';
       env.fromAddress = 'user@acme.com';
    
       // set the body of the attachment
       inAtt.body = blob.valueOf('test');
       inAtt.fileName = 'my attachment name';
       inAtt.mimeTypeSubType = 'plain/txt';
    
       email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt }; 
    
       // call the class and test it with the data in the testMethod
       VisitationEmailReceive emailServiceObj = new VisitationEmailReceive();
       
        emailServiceObj.handleInboundEmail(email, env );  
       
        Visitation_Setting__c visitSet = (Visitation_Setting__c.getinstance('SHOW CHATTER TAB') != null)?Visitation_Setting__c.getinstance('SHOW CHATTER TAB'):new Visitation_Setting__c(name='SHOW CHATTER TAB');        
       visitSet.value_boolean__c = !visitSet.value_boolean__c;      
       upsert visitSet;
       try{
        	emailServiceObj.handleInboundEmail(email, env );
       }catch(Exception excp) {
       		System.debug('*********Exception while creating the feeds ********'+excp.getMessage());
       } 
       
       try {
            email.subject = 'Verify your Salesforce Organization-Wide Address';
            emailServiceObj.handleInboundEmail(email, env ); 
       }catch(Exception excp){
       		System.debug('*******excepion while sending the verification code ********'+excp.getMessage());
       }
          
    } 
}