/*@Author < Nikhil bajaj >
@name < Create IPR from Rfq vf>
@CreateDate < 1/5/2017 >
@Description < This class allowing to create IPR Record from button on rfq related list>
@Version <1.0>
*/
public class GetIPRRecordType {
   public String selectedrequesttype{get;set;}
   public String selectedrecordtype{get;set;}
   Public List<SelectOption> requesttype= new List<SelectOption>();
   public  List<SelectOption> recordtype = new List<SelectOption>();
     
   public GetIPRRecordType(ApexPages.StandardController controller){
       requesttype.add(new SelectOption('IP Request','IP Request'));
       requesttype.add(new SelectOption('Services','Services'));
       requesttype.add(new SelectOption('Licensing','Licensing'));
       requesttype.add(new SelectOption('Grading','Grading'));
       
       recordtype.add(new SelectOption('AMS','AMS'));
       recordtype.add(new SelectOption('BITSTACK','BITSTACK'));
       recordtype.add(new SelectOption('CORE','CORE'));
       recordtype.add(new SelectOption('Clocking','Clocking'));
       recordtype.add(new SelectOption('IO','IO'));
       recordtype.add(new SelectOption('IP Characterization & Qual','IP Characterization & Qual'));
       recordtype.add(new SelectOption('Image/Package','Image/Package'));
       recordtype.add(new SelectOption('L1-HTOL','L1-HTOL'));
       recordtype.add(new SelectOption('LOGIC','LOGIC'));
       recordtype.add(new SelectOption('MCM or Silicon Interposer','MCM or Silicon Interposer'));
       recordtype.add(new SelectOption('MEMORY','MEMORY'));
       recordtype.add(new SelectOption('Methodology','Methodology'));
       recordtype.add(new SelectOption('NVM','NVM'));
       recordtype.add(new SelectOption('OTHERS','OTHERS'));
       recordtype.add(new SelectOption('Other Services','Other Services'));
       recordtype.add(new SelectOption('PD Services','PD Services'));
       recordtype.add(new SelectOption('PHYS','PHYS'));
       recordtype.add(new SelectOption('Partial Good','Partial Good'));
       recordtype.add(new SelectOption('Processors','Processors'));
       recordtype.add(new SelectOption('Redundancy','Redundancy'));
       recordtype.add(new SelectOption('SQPL (AOQL)','SQPL (AOQL)'));
       recordtype.add(new SelectOption('Tested Wafer Deliverables','Tested Wafer Deliverables'));
       recordtype.add(new SelectOption('Voltage Islands','Voltage Islands'));
    }
    //picklist to select requesttype
    public List<SelectOption> getRequestType(){
        return requesttype;
    } 
 
    //picklist to select recordtype
    public List<SelectOption> getRecordType() {
        return recordtype;
    }
    // will create IPR Record  with the selected requesttype and recordtype from the picklist
    public pageReference CreateIPR(){
        try{
            Id Rfq_id =ApexPages.currentPage().getParameters().get('id');
            Id rec_id =Schema.SObjectType.IP_Request__c.getRecordTypeInfosByName().get(selectedrecordtype).getRecordTypeId();
            IP_Request__c IPR = new IP_Request__c();
            IPR.RecordtypeID = rec_id;
            RFQ__c rfqinfo=[Select Device__r.Id ,Company_Name__c ,Opportunity__c  from RFQ__c where RFQ__c.Id=:Rfq_id];
            //assigning rfq value in ipr record  
            IPR.Request_Type__c = selectedrequesttype;
            IPR.Device__c =rfqinfo.Device__r.Id;
            IPR.Customer_Account_Name__c = rfqinfo.Company_Name__c;
            
            insert IPR;
            createRFQIPR(Rfq_id ,IPR.id);
            PageReference ref = new PageReference('/'+IPR.id);
            return ref;
           }catch (Exception excp) {
                ApexPages.addMessages(excp);
                GlobalUtility.logMessage('Error','GetIPRRecordType','CreateIPR','','Exception while creating IPR Record',String.valueof(excp.getMessage()),'','IP Request',excp,0);
                return null;
            }     
    }
    
    public pageReference createRFQIPR(Id RFQ ,Id IPR){
        List<RFQ_IPR__c> rfq_iprList = new List<RFQ_IPR__c>();
        RFQ_IPR__c RFQIPR = new RFQ_IPR__c();
        RFQIPR.RFQ__c=RFQ ;
        RFQIPR.IP_Request__c = IPR;
        rfq_iprList.add(RFQIPR);
        insert rfq_iprList;
        return null;
    }
    
    
     
}