/*  Author : Ashwini Dengi
    Description : This Batch class is used to keep track on organization limit.
    Code Creation: 6/17/2015
    */

global Class RM_Organizationlimit implements Database.Batchable<Sobject>,Database.Stateful,Database.AllowsCallouts{
    String Query;
    String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
    String endpointUrl = baseUrl;
    Public RM_Organizationlimit (){
        if(UserInfo.getUserType() != 'Standard'){
            endpointUrl += '/GlobalfoundryView';
        }else{
            if(baseUrl.containsIgnoreCase('GlobalfoundryView')){
                endpointUrl += '/GlobalfoundryView';
            }
        }
    }
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String jsonInput='';
            String dataendpointUrl =endpointUrl ;
            dataendpointUrl += '/services/data/v33.0/limits';
            Http httpProtocol = new Http();
            HttpRequest request = new HttpRequest();
            RM_user__c a = RM_user__c.getInstance();
            String username = a.username__c;
            String password = a.password__c;
            String sessionID;
              if(!Test.isRunningTest())
            sessionID= login(username ,password );
            else
            {
            SingleRequestMock fakeID = new SingleRequestMock(200,'ok', '[{<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="urn:partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><loginResponse><result><metadataServerUrl>https://globalfoundries--DevTrans.cs6.my.salesforce.com/services/Soap/m/29.0/00DN0000000Tocq</metadataServerUrl><passwordExpired>false</passwordExpired><sandbox>true</sandbox><serverUrl>https://globalfoundries--DevTrans.cs6.my.salesforce.com/services/Soap/u/29.0/00DN0000000Tocq</serverUrl><sessionId>00DN0000000Tocq!AR4AQAnlq02YZejpf4tPaJ3YfG2Jfev_je2dfSoig0Rpbg_xFgr6_hIEPZTRAoLOdS9qlwuF5Gim5Xxw9p4cbLNl7nRaEIJk</sessionId><userId>005900000031pKsAAI</userId><userInfo><accessibilityMode>false</accessibilityMode><currencySymbol>$</currencySymbol><orgAttachmentFileSizeLimit>5242880</orgAttachmentFileSizeLimit><orgDefaultCurrencyIsoCode>USD</orgDefaultCurrencyIsoCode><orgDisallowHtmlAttachments>false</orgDisallowHtmlAttachments><orgHasPersonAccounts>false</orgHasPersonAccounts><organizationId>00DN0000000TocqMAC</organizationId><organizationMultiCurrency>false</organizationMultiCurrency><organizationName>GLOBALFOUNDRIES</organizationName><profileId>00e90000001232aAAA</profileId><roleId>00E90000000R2R0EAK</roleId><sessionSecondsValid>7200</sessionSecondsValid><userDefaultCurrencyIsoCode xsi:nil="true"/><userEmail>ashwinidengi@gmail.com</userEmail><userFullName>Ashwini Basavaraj</userFullName><userId>005900000031pKsAAI</userId><userLanguage>en_US</userLanguage><userLocale>en_US</userLocale><userName>ashwinibasavaraj.d@cognizant.com.devtrans</userName><userTimeZone>Asia/Kolkata</userTimeZone><userType>Standard</userType><userUiSkin>Theme3</userUiSkin></userInfo></result></loginResponse></soapenv:Body></soapenv:Envelope>}]');
            Test.setMock(HttpCalloutMock.class, fakeID);
            sessionID= login(username ,password );
            SingleRequestMock fakeResponse = new SingleRequestMock(200,'ok', '[{"ConcurrentAsyncGetReportInstances":{"Remaining":200,"Max":200},"ConcurrentSyncReportRuns":{"Remaining":20,"Max":20},"DailyApiRequests":{"Remaining":14971,"Max":15000},"DailyAsyncApexExecutions":{"Remaining":250000,"Max":250000},"DailyBulkApiRequests":{"Remaining":5000,"Max":5000},"DailyGenericStreamingApiEvents":{"Remaining":10000,"Max":10000},"DailyStreamingApiEvents":{"Remaining":10000,"Max":10000},"DailyWorkflowEmails":{"Remaining":135,"Max":135},"DataStorageMB":{"Remaining":4,"Max":5},"FileStorageMB":{"Remaining":5,"Max":20},"HourlyAsyncReportRuns":{"Remaining":1200,"Max":1200},"HourlyDashboardRefreshes":{"Remaining":200,"Max":200},"HourlyDashboardResults":{"Remaining":5000,"Max":5000},"HourlyDashboardStatuses":{"Remaining":999999999,"Max":999999999},"HourlySyncReportRuns":{"Remaining":500,"Max":500},"HourlyTimeBasedWorkflow":{"Remaining":50,"Max":50},"MassEmail":{"Remaining":10,"Max":10},"SingleEmail":{"Remaining":15,"Max":15},"StreamingApiConcurrentClients":{"Remaining":20,"Max":20}}]');
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            }
            request.setHeader('Authorization', 'OAuth '+sessionID);
            request.setEndPoint(dataendpointUrl);
            request.setMethod('GET');
            HttpResponse response = httpProtocol.send(request);
            jsonInput = response.getBody();
            List <orglimit_status__c> listorglimit= new List<orglimit_status__c>();
            JSONParser parser = JSON.createParser(jsonInput);
            while (parser.nextToken() != null) {
            orglimit_status__c neworglimit= new orglimit_status__c();
            parser.nextToken();
            neworglimit.Name__c =parser.getText();
            parser.nextToken();
            parser.nextToken();
            if(parser.getText() == 'Remaining')
            {
                parser.nextToken();
                neworglimit.Remaining__c = parser.getIntegerValue();
            }
            if(parser.getText() == 'Max'){
            parser.nextToken();
            neworglimit.Max_Limit__c = parser.getIntegerValue();
            }
            parser.nextToken();
            if(parser.getText() == 'Max')
            {
                parser.nextToken();
                neworglimit.Max_Limit__c =parser.getIntegerValue();
            }
            if(parser.getText() == 'Remaining'){
            parser.nextToken();
                neworglimit.Remaining__c = parser.getIntegerValue();
            }
            
            if((neworglimit.Remaining__c  != null) || (neworglimit.Max_Limit__c!= null)){
            listorglimit.add(neworglimit);
            }
        }
        insert listorglimit;
        
        Query='select Id,Name from orglimit_status__c limit 10';
        return Database.getQueryLocator(Query);
    }
    global void execute(Database.BatchableContext BC, List<Sobject> scope)
    {
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
       
        system.debug('The batch Apex "Organizationlimit" job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.');
        
    }
   
   private final String NS_SOAP = 'http://schemas.xmlsoap.org/soap/envelope/';
   private final String NS_SF = 'urn:partner.soap.sforce.com';

   public String login(String user, String password)
   {
        String  soapendpointUrl= endpointUrl; 
        soapendpointUrl += '/services/Soap/u/29.0';
        // As per http://wiki.developerforce.com/page/Enterprise_Login
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');   
        req.setTimeout(60000);
        req.setEndpoint(soapendpointUrl);
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');        
        req.setHeader('SOAPAction', '""');
        req.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' +user+ '</username><password>' + password + '</password></login></Body></Envelope>');        
        HttpResponse res =  new Http().send(req);
        system.debug('res'+res.getbody());
        if(res.getStatusCode() != 200)
        {
            Dom.Document responseDocument = res.getBodyDocument();
            Dom.Xmlnode rootElm = responseDocument.getRootElement(); // soapenv:Envelope
            Dom.Xmlnode bodyElm = rootElm.getChildElement('Body', NS_SOAP); // soapenv:Body 
            Dom.Xmlnode faultElm = bodyElm.getChildElement('Fault', NS_SOAP); // soapenv:Fault
            Dom.Xmlnode faultStringElm = faultElm.getChildElement('faultstring', null); // faultstring 
            throw new LoginException(faultStringElm.getText()); 
        }
        // As per http://wiki.developerforce.com/page/Enterprise_Login
        If(!Test.IsRunningtest()){
            Dom.Document responseDocument = res.getBodyDocument();
            Dom.Xmlnode rootElm = responseDocument.getRootElement(); // soapenv:Envelope
            Dom.Xmlnode bodyElm = rootElm.getChildElement('Body', NS_SOAP); // soapenv:Body 
            Dom.Xmlnode loginResponseElm = bodyElm.getChildElement('loginResponse', NS_SF); // loginResponse
            Dom.Xmlnode resultElm = loginResponseElm.getChildElement('result', NS_SF); // result
            Dom.Xmlnode sessionIdElm = resultElm.getChildElement('sessionId', NS_SF); // sessionId
            return sessionIdElm.getText();
        }
        else{
            return null;
        }
    }
    
    public class LoginException extends Exception {}
    
    public class SingleRequestMock implements HttpCalloutMock {
    Public Integer code;
    Public String status;
    Public String bodyAsString;
    public SingleRequestMock(Integer code, String status, String body) {
    this.code = code;
    this.status = status;
    this.bodyAsString = body;
    }
    public HTTPResponse respond(HTTPRequest req) {
    HttpResponse resp = new HttpResponse();
    resp.setStatusCode(code);
    resp.setStatus(status);
    resp.setBody(bodyAsString);
    return resp;
    }
    }
}