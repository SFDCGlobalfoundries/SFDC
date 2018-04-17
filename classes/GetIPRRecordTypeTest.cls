/*@Author < Nikhil bajaj >
@name < Create IPR from Rfq Related List>
@CreateDate < 1/20/2017 >
@Description < This class allowing to create IPR Record from button on rfq related list>
@Version <1.0>
*/
@isTest
Private class GetIPRRecordTypeTest{
    public String Request_Type {get; set;}
    List<IP_Request__c> iprlist = new List<IP_Request__c>();
    List<RFQ_IPR__c> rfq_iprList = new List<RFQ_IPR__c>();
    
    static testMethod void createIPRRec(){
           Map<String,Object> fieldValueRFQMap = new Map<String,Object>();
           RFQ__c rfq = IPRDataFactory.createRFQ(fieldValueRFQMap);
          
           PageReference pageRef = Page.CreateIPRFrom_RFQ;
           
           Test.setCurrentPageReference(pageRef); 
           System.currentPageReference().getParameters().put('id', rfq.id);
           
           
           Map<String,Object> fieldValueIPRMap = new Map<String,Object>();
           RecordType rt =[select id,Name from RecordType where SobjectType='IP_Request__c' and Name='AMS' Limit 1];
              
           RFQ__c rfqinfo=[Select Device__r.Id ,Company_Name__c ,Opportunity__c  from RFQ__c where RFQ__c.Id=:rfq.id];
           fieldValueIPRMap.put('Customer_Account_Name__c',rfqinfo.Company_Name__c); 
           fieldValueIPRMap.put('Opportunity__c',rfqinfo.Opportunity__c); 
           fieldValueIPRMap.put('RecordtypeID', rt.Id);
           IP_Request__c ipr = IPRDataFactory.createIPR(fieldValueIPRMap);
                     
           Map<String,Object> fieldValueRFQIPRMap = new Map<String,Object>();
           fieldValueRFQIPRMap.put('IP_Request__c',ipr.id); 
           fieldValueRFQIPRMap.put('RFQ__c',rfq.id); 
           RFQ_IPR__c rfqipr = IPRDataFactory.createRFQIPR(fieldValueRFQIPRMap);
           
           ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ipr);
           GetIPRRecordType ec = new GetIPRRecordType(sc);
           ec.CreateIPR();

              Test.setCurrentPage(pageRef);

           
           ApexPages.Standardcontroller sc2 = new ApexPages.Standardcontroller(rfqipr);
           GetIPRRecordType ec2 = new GetIPRRecordType(sc2);
           Test.startTest();
           try{
           ec2.CreateRFQIPR(rfq.id,ipr.id);
           Test.stopTest();
          }catch (Exception excp) {
                ApexPages.addMessages(excp);
                GlobalUtility.logMessage('Error','GetIPRRecordType','CreateIPR','','Exception while creating RFQIPR Record',String.valueof(excp.getMessage()),'','IP Request',excp,0);
                
            }
    }

    static testMethod void TestRecordType(){
        IP_Request__c ipr = new IP_Request__c();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ipr);
        GetIPRRecordType obj = new GetIPRRecordType(sc);
        Test.startTest();
        obj.getRecordType();
        Test.stopTest();
  
    }
 
    static testMethod void TestRequestType() {
        IP_Request__c ipr = new IP_Request__c();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ipr);
        GetIPRRecordType obj = new GetIPRRecordType(sc);
        Test.startTest();
        obj.getRequestType();
        Test.stopTest();
  
    }



}