/*
    Class Name:    CreateProposalPDFNPC 
    Author:        Akash Aggarwal and Anirban Roy
    Description:   This class automatically creates a proposal pdf for the configuration whenenver a new configuration is created via NPC/Copy/Reevise device functionality
    History: 
      Akash       17052016    - Code creation.      
*/
global class CreateProposalPDFNPC implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,

    Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();  
        Schema.DescribeSObjectResult r = Apttus_Proposal__Proposal__c.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        string proposalId = email.subject.substring(email.subject.indexOf(keyPrefix));          
        PageReference pagePdf = new PageReference('/apex/CPQ_Proposal_pdf?id='+proposalId); 
        if(!Test.isRunningTest()) {
          pagePdf.getContent();
        }              
        result.success = true;
        return result;
    }
 }