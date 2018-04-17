@isTest
global class FMSMockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        String xmlrequest = '<?xml version="1.0" ?><CustomerApprovalParamsRequest><result>'+200+'</result><comments>'+2222+'</comments><customerApprovalFlag>'+'200'+'</customerApprovalFlag><customerApprovalText>'+'Test Approval'+'</customerApprovalText></CustomerApprovalParamsRequest>';
        res.setBody(xmlrequest );
        res.setStatusCode(200);
        return res;
    }
    
}