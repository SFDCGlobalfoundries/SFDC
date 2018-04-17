/*
@Author < Nikhil bajaj >
@name < IP_Request vf>
@CreateDate < 1/5/2017 >
@Description < This class allowing to select IPR Record in RFQ_IPR from button on rfq related list>
@Version <1.0>
*/
public class IPRequestRecord{
    
    public String msg{get;set;}
        public List<ipRequest> ipRequestList {get; set;}
        Public List<String> finaliprequestrecords{set;get;}
        Public List<IP_Request__c> all_ipr{set;get;}
        List<RFQ_IPR__c> added_ipr_RFQIPR{set;get;}
        Id Currentpageid =ApexPages.currentPage().getParameters().get('id');
        
        public String getRfqId(){
        String rfqId =ApexPages.currentPage().getParameters().get('name');
        return 'RFQ_No: '+rfqId;
        }  

        //geting IPR which is not added in RFQ_IPR 
    public List<ipRequest> getIPR(){
        if(ipRequestList == null){
            ipRequestList = new List<ipRequest>();
            Set<String> ipr_inRFQIPR = new Set<String>();
            Set<String> ipr_inIPR = new Set<String>();
            added_ipr_RFQIPR =[SELECT IP_Request__c from RFQ_IPR__c where RFQ__c =: Currentpageid];
            //list of ipr in RFQ_IPR      
            for(RFQ_IPR__c r: added_ipr_RFQIPR){
                ipr_inRFQIPR.add(r.IP_Request__c);
             }
            RFQ__c  device= [SELECT  Device__r.name  FROM RFQ__c WHERE Id = :Currentpageid];
            
            //getting all ipr from iprequest based on the device which is common between  rfq,rfq_ipr and ipr
            all_ipr = [Select id,Name FROM IP_Request__c  where Device__c =: device.Device__c ];
            
            
            //list of ipr in IPR
            for(IP_Request__c i: all_ipr){
                ipr_inIPR.add(i.id);
             }
          
            //removing ipr alredy added in rfqipr from the list
             for(String s: ipr_inRFQIPR){
                if(ipr_inIPR.contains(s)){
                ipr_inIPR.remove(s);
                }       
             }
         
              
             List<IP_Request__c> iprequestrecords = [Select Id, Name ,IP_Name__c ,RFQ__c,Request_Type__c,IP_Type__c from IP_Request__c where Id In:ipr_inIPR];        
             List<RFQ_IPR__c>  rfqipr =[Select RFQ__c from RFQ_IPR__c where IP_Request__c in :iprequestrecords ];
             for(IP_Request__c iprRec: iprequestrecords) {
                ipRequestList.add(new ipRequest(iprRec));
             }
       
        }
            return ipRequestList;
  
    } 


    //finding the selected IPRecords
    public PageReference processSelected() {
        List<IP_Request__c > selectedIPRList = new List<IP_Request__c>();
        for(ipRequest selectIPR : getIPR()) {
            if(selectIPR.selected == true) {
                selectedIPRList.add(selectIPR.ipr);
            
            } 
        }
        
        List<RFQ_IPR__c> finalrecord = new List<RFQ_IPR__c >();
        RFQ_IPR__c insertIPin_IPRRFQ ;
                     
       //processing the selected record and creating rfq_ipr 
       for(IP_Request__c processRec: selectedIPRList) {
           insertIPin_IPRRFQ = new RFQ_IPR__c();
           insertIPin_IPRRFQ.RFQ__c = Currentpageid;
           insertIPin_IPRRFQ.IP_Request__c = processRec.id;
           finalrecord.add(insertIPin_IPRRFQ);
        }
       ipRequestList =null;
       try{
           insert finalrecord;
        } 
       catch (Exception excp) {
           ApexPages.addMessages(excp);
           GlobalUtility.logMessage('Error','IpRequestRecord','processSelected','','Exception while selecting IPR records',String.valueof(excp.getMessage()),'','IP Request',excp,0);
           return null;
        }
       
       PageReference returntoRFQ = new PageReference('/'+Currentpageid);
       return returntoRFQ;
      
    }


    public PageReference cancel(){
        PageReference backtoRFQ = new PageReference('/'+Currentpageid);
        return backtoRFQ;
    }

    //wrapper class to ipr records
    public class ipRequest {
        public IP_Request__c ipr {get; set;}
        public RFQ_IPR__c rfq{get;set;}
        public Boolean selected {get; set;}
        //public wrapperContact[] contacts {get; private set;}
    
        public ipRequest(IP_Request__c c) {
            ipr = c;
            selected = false;
        }
    }

}