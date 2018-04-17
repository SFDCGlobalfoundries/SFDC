/******************************************************************************************************************************
Class:         CreateProposalPDFNPC_Test 
-------------------------------------------------------------------------------------------------------------------------------
Author:        Akash Aggarwal
Created Date:  20/05/2016
Reason:        Test class for CreateProposalPDFNPC class
Akash  20052016    -  Code creation.
*******************************************************************************************************************************/

@isTest
private class CreateProposalPDFNPC_Test {

      static testMethod void testCreateContactFrmEmail() {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        email.subject = 'a3Dp0000000blJy';
        email.plainTextBody = 'FromEmail';
        env.fromAddress = 'akash.aggarwal@globalfoundries.com';
        CreateProposalPDFNPC creatC = new CreateProposalPDFNPC();
        creatC.handleInboundEmail(email, env );

    }
}