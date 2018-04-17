/*****************************************************************
Created by: Karna Shiva
Date: 25-04-2017
Description: This class used for making REST API Calls to WebRDTS for 
First method was used for sending step plan form approval information to WebRDTS and second method was
used for getting x,y rotation values on main form step plan section

*Modified By        Date            Comments
*Inshu Misra        31-May-2017     modified the logic to handle the DropBox Data...#IM
*Inshu Misra        2-Jun-2017      added sender email field in packages to address the same from the JSON response...#IM
****************************************************************/

public class FMSDropServiceStepPlanDetails_API {

public string statusCode;
public string comments;

public void FMSStepPlaApproval_API(Integer stepPlanRequestid,String formid,string approvalStatus, String approvaltext){   
    
String xmlrequest = '<?xml version="1.0" ?><CustomerApprovalParamsRequest><stepPlanRequestId>'+stepPlanRequestid +'</stepPlanRequestId><FMSFormId>'+formid+'</FMSFormId><customerApprovalFlag>'+approvalStatus+'</customerApprovalFlag><customerApprovalText>'+approvaltext+'</customerApprovalText></CustomerApprovalParamsRequest>';

Http http =new Http();
HttpRequest req =new HttpRequest();
req.setEndpoint(Environment_Variable__c.getInstance('FMS_CUST_APRVL_TO_WEBRDTS_ENDPOINT').value__c);
req.setmethod('POST');
req.setHeader('Content-Type', 'application/xml');     
req.setBody(xmlrequest); 
req.setTimeout(120000);

HttpResponse res = http.send(req);  

Dom.Document doc = res.getBodyDocument();

//Retrieve the root element for this document.
 Dom.XMLNode address = doc.getRootElement();
 statusCode = address.getChildElement('result', null).getText();
   
}
//GetTechnologyDefault
public static map<String,String> GetTechnologyDefault(String technology) {
        String body = '<?xml version="1.0" ?><TechnologyDefaultParamsRequest><technology>'+technology+'</technology></TechnologyDefaultParamsRequest>' ;
        HttpRequest req = new HttpRequest();
        req.setEndPoint(Environment_Variable__c.getInstance('FMS_GET_SP_ROTATION_VALUE_ENDPOINT').value__c);
        req.setMethod('POST');
        req.setHeader('accept', 'application/xml');
        req.setHeader('content-type','application/xml');
        req.setBody(body);
        req.setTimeout(120000);
        Http http = new Http();
        HttpResponse res = http.send(req);
        if(res.getStatusCode() != 200) {
          return new map<String,string>();
        }
        XmlStreamReader xsr = new XmlStreamReader(res.getBody());
        map<String,String> mpResponse = new map<String,String>();
        while(xsr.hasNext()) {
           xsr.next();
          
           if(xsr.getEventType() == XmlTag.START_ELEMENT) {
             if(xsr.getlocalname() != 'technology_defaults') {             
                  String startEle = xsr.getlocalname();
                  xsr.next(); 
                  if(xsr.getEventType() == XmlTag.CHARACTERS) {                   
                    mpResponse.put(startEle,xsr.getText());                    
                  }
                  xsr.next(); 
              }
              if(xsr.getEventType() == XmlTag.END_ELEMENT) { 
                continue;
              }
           }
        }
        return mpResponse;
  }
  
  //Dropbox
  public static FMSDropServiceStepPlanDetails_API.Dropbox dropBoxService(String userEmail) {
    String body = '{"userEmail" : "'+userEmail+'"}' ;
    HttpRequest req = new HttpRequest();
    req.setEndPoint(Environment_Variable__c.getInstance('FMS_DROPBOX_ENDPOINT').value__c);
    req.setMethod('POST');
    req.setHeader('accept', 'application/json');
    req.setHeader('content-type','application/json');
    
    req.setHeader('Authorization', Environment_Variable__c.getInstance('FMS_DROPBOX_AUTH_CODE').value__c);
   
    req.setBody(body);
    req.setTimeout(120000);
    Http http = new Http();
    HttpResponse res = http.send(req);
    if(res.getStatusCode() != 200) {
      return NULL;
    }
    FMSDropServiceStepPlanDetails_API.Dropbox db = (FMSDropServiceStepPlanDetails_API.Dropbox)JSON.deserialize(res.getBody(), Dropbox.class);
    return db;
  }
  
  public class Dropbox{
    public String statusCode{get;set;}
    public String  message{get;set;}
    public Data data{get;set;}
  }
  public class Data{
      public Packages[] packages{get;set;}
      public Packages_To_User[] packages_To_User{get;set;}  
    }

    public class Packages_to_user {
        public String id{get;set;}
        public File[] files{get;set;}
        public String packageName{get;set;}
        public String expireDate{get;set;}
        public String sentDate{get;set;}
        public String pkgSenderEmail{get;set;}
        public String[] pkgReceiversEmail{get;set;} 
    }

    public class Packages {
        public String id{get;set;}
        public File[] files{get;set;}
        public String packageName{get;set;}
        public String expireDate{get;set;}
        public String sentDate{get;set;}
        public String pkgSenderEmail{get;set;}
        public String[] pkgReceiversEmail{get;set;}  
    }
    
    public class File{
        public String fileId{get;set;}
        public String fileName{get;set;}
        public String fileSize{get;set;}
    }
}