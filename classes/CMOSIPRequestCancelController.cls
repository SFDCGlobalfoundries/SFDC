public class CMOSIPRequestCancelController {
  public CMOS_BU_IP_Request__c objIPRequest{get;set;}
  
   public CMOSIPRequestCancelController(){
   	   String strId=ApexPages.currentPage().getParameters().get('Id');
   	  objIPRequest=[Select stage__c,Reason_Why_Cancelled__c,OtherReasonWhyCancelled__c from CMOS_BU_IP_Request__c where id=:strId];
   	   //objIPRequest = (CMOS_BU_IP_Request__c) controller.getRecord();
   	  objIPRequest.stage__c='Cancelled';
   }
   
   public pagereference save(){
   	try{
   	 objIPRequest.stage__c='Cancelled';
   	 objIPRequest.IP_Project__c=null;
   	 update objIPRequest;
   	 
   	  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm,'IP Request is successfully cancelled.')); 
   	}catch(Exception ex){
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,''+ex.getDmlMessage(0))); 
      } 
      
      return null;
   }
   
}