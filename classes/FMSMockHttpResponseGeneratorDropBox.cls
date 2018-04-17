@isTest
global class FMSMockHttpResponseGeneratorDropBox implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        String xmlrequest = '{"message":"null","statusCode":200,"data":{"packages":[{"id":101,"packageName":"KSE RIT Test1","pkgReceiversEmail":["kim.salzmann@globalfoundries.com","fdryrel@globalfoundries.com"],"pkgSenderEmail":"karen.edwards@globalfoundries.com","files":[{"fileId":101,"fileName":"throughfocus176.zip","fileSize":3478639},{"fileId":102,"fileName":"throughfocus174.zip","fileSize":3471171}],"sentDate":"2017-06-17 03:13:15","expireDate":"2017-07-01 03:08:59"}],"packages_to_user":[{"id":218,"packageName":"KSE RIT Test","pkgReceiversEmail":["kim.salzmann@globalfoundries.com","fdryrel@globalfoundries.com"],"pkgSenderEmail":"karen.edwards@globalfoundries.com","files":[{"fileId":550,"fileName":"throughfocus176.zip","fileSize":3478639},{"fileId":549,"fileName":"throughfocus174.zip","fileSize":3471171}],"sentDate":"2017-06-17 03:13:15","expireDate":"2017-07-01 03:08:59"},{"id":242,"packageName":"kim test 2","pkgReceiversEmail":["kim.salzmann@globalfoundries.com","fdryrel@globalfoundries.com"],"pkgSenderEmail":"karen.edwards@globalfoundries.com","files":[{"fileId":604,"fileName":"Apache_OpenOffice_4.0.0_Win_x86_install_en-US.exe","fileSize":143436858}],"sentDate":"2017-06-23 03:52:02","expireDate":"2017-07-07 03:50:27"}]}}';
        res.setBody(xmlrequest);
        res.setStatusCode(200);
        return res;
    }
    
}