/*
Type Name: MRSVoidChipExtn
Author: Cognizant 
Created Date: 17-April-2014
Reason: 
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
……..
……..
*/

public without sharing class MRSVoidChipExtn{
 public String selectedAccount {get ;set;}
 public String selectedMST {get ;set;}
 public String selectedLayer {get ;set;}
 public  MRS_Layer_Chip_Association__c mrsChipLayerlst{get;set;}
 public String voidReason {get ;set;}
 String Id;
 public Boolean isBreadcrumbActive {get;set;}
 public displayWrapperClass displayWrapperObj{get;set;}
 public Boolean alternateTable {get;set;}
 public List<MRS_Layer_Chip_Association__c> lstMLCA {get; set;} 
 public MRSVoidChipExtn(ApexPages.StandardController controller) {
  
     Id= ApexPages.currentPage().getParameters().get('id');
     if(Id!=null)
     {
         lstMLCA = new List<MRS_Layer_Chip_Association__c>();     
         alternateTable =true;
         mrsChipLayerlst = MRSHandlerUtility.retriveMRSLayerChip(Id);
         String url = ApexPages.currentPage().getHeaders().get('Host');
         if(url.contains(Label.Swift_Host_URL)){
                isBreadcrumbActive = true;
         }else{
              isBreadcrumbActive =false;
         }
         if(mrsChipLayerlst.PTRF__r.Name!=null || mrsChipLayerlst.PTRF__r.Name!='')
         {
          displayWrapperObj= new displayWrapperClass(mrsChipLayerlst.Chip__r.Name,mrsChipLayerlst.PTRF__r.Name,mrsChipLayerlst.Layer_Chip_Status__c,mrsChipLayerlst.PTRF__c);
         }
     }
     
 }
 /**
 @Method: proceed
 @param: null
 @return: void
 @ description: This method is used to save the Layer Chip Status.
 **/
 public void proceed()
 {
     if(voidReason != null  && voidReason.trim() !=''){
        
             mrsChipLayerlst.Layer_Chip_Status__c='Void';
             mrsChipLayerlst.Void__c = voidReason ;
             try{
                update mrsChipLayerlst;
             }catch(Exception e){
                System.debug('::exception'+e.getMessage());
             }
             alternateTable =false;
             mrsChipLayerlst = MRSHandlerUtility.retriveMRSLayerChip(Id);
             
                       
             
             try{
                 sendEmail();
                
                /*
                if(lstMLCA!=null && lstMLCA.size()>0 )
                 {  
                    system.debug('$$$$Size of layer chip association::'+lstMLCA.size() );            
                    EmailHandlerUtility.coreEmailMethod('MRS_Void_Chip_Template',lstMLCA,'','',false ); // generic email method called
                 }
                 
                 */
                 
                                     
             }catch(Exception e){}
             displayWrapperObj= new displayWrapperClass(mrsChipLayerlst.Chip__r.Name,mrsChipLayerlst.PTRF__r.Name,mrsChipLayerlst.Layer_Chip_Status__c,mrsChipLayerlst.PTRF__c);
        
     }else
     {
          Map<String,Error_Codes__c> mapErrorCodes = Error_Codes__c.getAll();
          ApexPages.Message  myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,mapErrorCodes.get('VOID_REASON').Message__c);
          ApexPages.addMessage(myMsg);
         displayWrapperObj= new displayWrapperClass(mrsChipLayerlst.Chip__r.Name,mrsChipLayerlst.PTRF__r.Name,mrsChipLayerlst.Layer_Chip_Status__c,mrsChipLayerlst.PTRF__c);
     }
     
 }
 /**
 @Method:discard
 @param: null
 @return : void
 @Description : This method is used to rever back the page to Layer Chip summary. 
 **/
 public PageReference discard()
 {
     PageReference page;
     if(isBreadcrumbActive)
     { 
         page = new PageReference(System.Label.SWIFT_Community_URL + 'VFMRSLayerChipSummary?id='+Id);
     }else
     {
         page = new PageReference(System.Label.Internal_URL + 'VFMRSLayerChipSummary?id='+Id);
     }
     return page ;
 }
 /**
 @Method:exportToExcel
 @param: null
 @return : void
 @Description : This method is used to export the data into excel
 **/
 public PageReference exportToExcel()
 {
      PageReference  page =new PageReference('/apex/VFMRSVoidChipExcel');
      return page;
 }
 /**
    @Inner Class: displayWrapperClass
    @Description : This method is used to display the data into Void page.
 **/
 public class displayWrapperClass
 {
     public String chipName{get;set;}
     public String ptrfOrDRTNumber {get;set;}
     public String layerChipStatus {get ;set;}
     public Id ptrfId {get;set;}
     
     public displayWrapperClass(String chipName,String ptrfOrDRTNumber,String layerChipStatus, Id ptrfId)
     {
         this.chipName = chipName;
         this.ptrfOrDRTNumber = ptrfOrDRTNumber;
         this.layerChipStatus = layerChipStatus;
         this.ptrfId =ptrfId;
     }
 }
 /**
 @Method:exportToCSV
 @param: null
 @return : void
 @Description : This method is used to export the data into csv
 **/
 public PageReference exportToCSV()
 {
     PageReference  page =new PageReference('/apex/VFMRSVoidChipCSV');
      return page;
 }
 /**
 @Method:sendEmail
 @param: null
 @return : void
 @Description : This method is send the email when the chips gets void.
 **/
 public void sendEmail()
 {   
       
       
       Map<String,List<MRS_Layer_Chip_Association__c>> mapLCACategory= new Map<String,List<MRS_Layer_Chip_Association__c>>();
       
       
      Map<String,String> nameValue = new Map<String,String>();  
      
      nameValue.put('USER_ID',UserInfo.getUserName());
      nameValue.put('USER_NAME',UserInfo.getName());
      
      if(mrsChipLayerlst!=null)
      {
         lstMLCA.add(mrsChipLayerlst);              
      }  
     
     
     EmailSubjectBodyPerPTRF emailObject = new EmailSubjectBodyPerPTRF();
        if(lstMLCA != null && lstMLCA.size() > 0){
            emailObject.emailSubBodyPerPTRF(lstMLCA,'MRS_Void_Chip_Template',nameValue,'NA',null);
        } 
                
 }
 /**
 @Method: retreiveTableAfterSave
 @param: null
 @return: void
 @Description : This method is used to retreive the data after saving
 **/
 public void retreiveTableAfterSave()
 {
     if(voidReason.trim() !=''){
      mrsChipLayerlst = MRSHandlerUtility.retriveMRSLayerChip(Id);
      }
 }
}