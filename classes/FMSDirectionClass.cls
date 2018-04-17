/*
 * @ Author :- Abhita Bansal
 * @ Description :- contains the logic for redirecting the form to view and edit Pages.
 * @ Date :- 21/12/2016
 * @ Change History :-  
 *  DATE                NAME            Comment
	28/6/2017		Abhita Bansal		Removed the hard coding of Form Types
**/
public class FMSDirectionClass{
    
    public Form_Management_System__c formObj{get;set;}
    public String fId{get;set;}
    public String ParentId;
    public final String FMS_IMC_FORM = EnvironmentVariable.get('FMS_IMC_FORM');
    public final String FMS_RIT_FORM = EnvironmentVariable.get('FMS_RIT_FORM');
    public final String FMS_DDR_FORM = EnvironmentVariable.get('FMS_DDR_FORM');
    public final String FMS_MAIN_FORM = EnvironmentVariable.get('FMS_MAIN_FORM');
    public final String FMS_SP_FORM = EnvironmentVariable.get('FMS_SP_FORM');
    
    public FMSDirectionClass(ApexPages.standardController controller){
        fId = ApexPages.currentPage().getParameters().get('id'); 
        if( fId != null &&  fId != ''){
            String fmsFields = '';
            fmsFields = UtilityCls.getAllFields('Form_Management_System__c'); 
            fmsFields += ', Customer_Name__r.SAP_Account_Number__c, Customer_Name__r.Customer_Category__c,'; 
            fmsFields += ' Customer_Name__r.Id,Customer_Name__r.Name,Device__r.Name,Device__r.id, Opportunity__r.id,';
            fmsFields += ' Opportunity__r.Name, Parent_Form_Id__r.recordtype.Name, Customer_Name__r.SAP_Account_Id__c';       
            string soql = 'select ' + fmsFields + ' from Form_Management_System__c WHERE Id = \''+  fId +'\'';
            formObj = database.query(soql); 
        }
        ParentId = formObj.Parent_Form_Id__c;
    }
    
    public Pagereference redirectTo(){
        PageReference Pg;
        RecordType rt = [Select Id, Name from RecordType where Id =: formObj.RecordTypeId];
        if(rt.Name == FMS_DDR_FORM) {
            pg = new PageReference('/apex/FMSDDRFormPage?id='+formObj.id); 
        } else if(rt.Name == FMS_RIT_FORM) {
            pg = new PageReference('/apex/FMSRITFormNewEditPage1?id='+formObj.id+'&pageNo=1');
        } else if(rt.Name == FMS_IMC_FORM) {
            pg = new PageReference('/apex/FMSIMCFormPage?id='+formObj.id+'&pageNo=1');
        } else if(rt.Name == FMS_MAIN_FORM) {
            pg = new PageReference('/apex/FMSmainFormCreationPg1?id='+formObj.id+'&pageNo=1');
        } else if(rt.Name == FMS_SP_FORM) {
            if(ParentId != null && ParentId != '') {
                 pg = new PageReference('/apex/FMSStepPlanEditForm?id='+ParentId);
            } else {
                pg = new PageReference('/apex/FMSStepPlanEditForm?id='+formObj.Id);
            }
        }
        return pg;
    }
    
    public Pagereference redirectToView(){
        PageReference Pg;
        RecordType rt = [Select Id, Name from RecordType where Id =: formObj.RecordTypeId];
        if(rt.Name == FMS_DDR_FORM) {
            pg = new PageReference('/apex/FMSDDRFormViewPage?id='+formObj.id); 
        } else if(rt.Name == FMS_RIT_FORM) {
            pg = new PageReference('/apex/FMSRITFormViewPage?id='+formObj.id+'&pageNo=1');
        } else if(rt.Name == FMS_IMC_FORM) {
            pg = new PageReference('/apex/FMSIMCFormViewPage?id='+formObj.id+'&pageNo=1');
        } else if(rt.Name == FMS_MAIN_FORM) {
            pg = new PageReference('/apex/FMSmainFormViewPage?id='+formObj.id+'&pageNo=1');
        } else if(rt.Name == FMS_SP_FORM) {
            if(ParentId != null && ParentId != '') {
                 pg = new PageReference('/apex/FMSStepPlanFormView?id='+ParentId);
            } else {
                pg = new PageReference('/apex/FMSStepPlanFormView?id='+formObj.Id);
            }
        }
        return pg;
    }
}