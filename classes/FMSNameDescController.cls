/*
* @ Author :- Ashwin Dash
* @ Description :- contains the logic for rendering the mainform page 2
* @ Date :- 04/07/2016
* @ Change History :-  
    *06-Mar-2017        Abhita Bansal       Changed the logic in component for #DEF 212, 217, 456
	*28-Jun-2017		Abhita Bansal		Removed hard coding and System debugs
**/
public class FMSNameDescController {
    public String formID1{get;set;}
    public String formType1{get;set;}
    public String parentId1{get;set;}
    public String accId1{get;set;}
    public Form_Management_System__c formObj{get;set;}
    public String formTypeNew{get;set;}
    public String customerName{get;set;}
    public String sapAccNumber{get;set;}
    public boolean showField {get;set;}
    public String formName {get;set;}
    public String formAutoId {get;set;}
    public List<Form_Management_System__c> spObjectIds;
    public Form_Management_System__c spObject{get;set;}
    public Form_Management_System__c spObject1{get;set;}
    public boolean lastModDate {get;set;}
    public final String FMS_SP_FORM = EnvironmentVariable.get('FMS_SP_FORM'); 
    public final String FMS_MAIN_FORM = EnvironmentVariable.get('FMS_MAIN_FORM'); 
    
    public FMSNameDescController (){
        spObjectIds = new List<Form_Management_System__c>();
        showField = false;
        Integer size ;
        lastModDate = false;
        formType1 = ApexPages.currentPage().getParameters().get('Type');
        accId1 = ApexPages.currentPage().getParameters().get('AccountId');
        formID1 = ApexPages.currentPage().getParameters().get('Id');
        parentId1 = ApexPages.currentPage().getParameters().get('ParentId');
        if(formID1 != null && formID1 != ''){
          showField = true;
          formObj = [SELECT id, Name, Form_Name__c,main_Form_Id__c , Parent_Form_Id__c, Form_Type__c, Customer__c, Form_Description__c, CreatedDate, LastModifiedDate, CreatedBy.Name, 
                  LastModifiedBy.Name, SAP_Account_Number__c FROM Form_Management_System__c WHERE id = : formID1 LIMIT 1]; 
          if(formObj.Form_Type__c == FMS_SP_FORM) {
              spObjectIds = [SELECT id, Name, Form_Name__c, Parent_Form_Id__c, Form_Type__c, Customer__c, 
                                  Form_Description__c, CreatedDate, LastModifiedDate, CreatedBy.Name, 
                                  LastModifiedBy.Name, SAP_Account_Number__c 
                        FROM Form_Management_System__c 
                        WHERE main_Form_Id__c = : formObj.main_Form_Id__c 
                        AND Form_Type__c = :FMS_SP_FORM
                        Order By CreatedDate asc];
                         if(spObjectIds !=null)   
                         size = spObjectIds.size();            
              if(!spObjectIds.isEmpty() && spObjectIds <> NULL){
                  spObject = spObjectIds[0];
                  if(size >1) {
                  spObject1 = spObjectIds[size -1];
                  lastModDate = true;
                  }
              } else{
                spObject = formObj;
              }
          }             
        } else {
          if(formType1 != null && formType1 != ''){
            showField = false;
            if(formType1 == 'Main' || formType1 == 'Other' || formType1 == 'IMC'){
              formTypeNew = FMS_MAIN_FORM;
            } 
            if(parentId1 != null && parentId1 != ''){
              Form_Management_System__c fms = [SELECT id, Name, Form_Name__c, Customer__c, SAP_Account_Number__c FROM Form_Management_System__c WHERE id = : parentId1 LIMIT 1];
              customerName = fms.Customer__c;
              sapAccNumber = fms.SAP_Account_Number__c;
              formName = fms.Form_Name__c;
              formAutoId = fms.Name;
            }
            if(accId1 != null && accId1 != ''){
              Account acc = [Select Id, Name, SAP_Account_Number__c from Account where Id = :accId1];
              customerName = acc.Name;
              sapAccNumber = acc.SAP_Account_Number__c;
            }
          }    
        }
    }
}