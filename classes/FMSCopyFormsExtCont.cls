/* 
Change History
 * 6-Jan-2017   Anil Kumar Reddy L  Modified code to validate parent form.
   06/28/2017      RRai    Modified the code to remove hardcoding.  
   11/07/2107	Akash      Modified the code to rearrange what has already been created - issue 272 
   13/07/2017	Abhita Bansal  Modified the method "populateObj" to refresh the page
   18/07/2017	Inshu Misra    Modified the continue method against Export Control issue
   01/11/2017   Anirban Roy	   Modified code to remove RIT validation when created under IMC
*/
public class FMSCopyFormsExtCont {
    
    public String formId{get;set;}
    public Form_Management_System__c formObj{get;set;}
    public Id zeroLevelId{get;set;}
    public Map<Id, Form_Management_System__c> allGrandChildrenOfMainMap{get;set;}
    public transient  List<Form_Management_System__c> formMainObjList{get;set;}
    public List<Id> possibleParents{get;set;}
    public transient  String selParentFMSObject{get;set;}
    public Form_Management_System__c modifiedFMSObj{get;set;}
    public final String FMS_IMC_FORM = EnvironmentVariable.get('FMS_IMC_FORM'); 
    public final String FMS_DDR_FORM = EnvironmentVariable.get('FMS_DDR_FORM'); 
    public final String FMS_MAIN_FORM = EnvironmentVariable.get('FMS_MAIN_FORM'); 
    public final String FMS_RIT_FORM = EnvironmentVariable.get('FMS_RIT_FORM'); 
    public final String FMS_SP_FORM = EnvironmentVariable.get('FMS_SP_FORM');
    
    public FMSCopyFormsExtCont(ApexPages.StandardController controller) {   
        formMainObjList = new List<Form_Management_System__c>{};
        possibleParents = new List<Id>();
        modifiedFMSObj = null;
        selParentFMSObject = '';
        if(formId == null || formId == ''){
            formId = ApexPages.currentPage().getParameters().get('id');  
        }
        if(formId != null && formId != ''){
            formObj = [SELECT id, name, State_of_the_Form__c, Form_Name__c, Customer__c, Technology__c, Form_Type__c, SubmissionType__c, Parent_Form_Id__c, 
                        Main_Form_Id__c, CreatedDate, LastModifiedDate FROM Form_Management_System__c WHERE id = :formId];                      
            zeroLevelId = Id.valueOf(formObj.id);
            if(formObj.Main_Form_Id__c == null || String.valueOf(formObj.Main_Form_Id__c) == ''){
                zeroLevelId = formObj.id;
            }else {
                zeroLevelId = formObj.Main_Form_Id__c;
            }
            allGrandChildrenOfMainMap = new Map<Id, Form_Management_System__c>([SELECT id, name, Form_Name__c, Parent_Form_Id__c, Main_Form_Id__c, State_of_the_Form__c, 
                        SubmissionType__c, Form_Type__c, CreatedDate, LastModifiedDate FROM Form_Management_System__c WHERE Main_Form_Id__c = :zeroLevelId ORDER BY Form_Type__c]);
            formMainObjList = [SELECT id, name, Form_Name__c, Parent_Form_Id__c, Main_Form_Id__c, State_of_the_Form__c, Form_Type__c, SubmissionType__c, CreatedDate, LastModifiedDate 
                        FROM Form_Management_System__c WHERE id = :zeroLevelId LIMIT 1] ;
            List<Form_Management_System__c> tempList = new List<Form_Management_System__c>();
            allGrandChildrenOfMainMap.put(zeroLevelId, formMainObjList[0]);
                 
        }else{
            formObj = new Form_Management_System__c();
        }
        if(allGrandChildrenOfMainMap != null && !allGrandChildrenOfMainMap.isEmpty()){
            for(Id fmsId : allGrandChildrenOfMainMap.keySet()){
                if(allGrandChildrenOfMainMap.get(fmsId).Form_Type__c == FMS_IMC_FORM  && (allGrandChildrenOfMainMap.get(formId).Form_Type__c == FMS_IMC_FORM  || allGrandChildrenOfMainMap.get(formId).Form_Type__c == FMS_RIT_FORM  )){
                    if(allGrandChildrenOfMainMap.get(fmsId).State_of_the_Form__c == 'Submitted' || allGrandChildrenOfMainMap.get(fmsId).State_of_the_Form__c == 'Frozen' || allGrandChildrenOfMainMap.get(fmsId).State_of_the_Form__c == 'RequestToThaw' || allGrandChildrenOfMainMap.get(fmsId).State_of_the_Form__c == 'Thawed'){
                        possibleParents.add(fmsId);
                    }
                }else if(allGrandChildrenOfMainMap.get(fmsId).Form_Type__c == FMS_RIT_FORM  && allGrandChildrenOfMainMap.get(formId).Form_Type__c == FMS_DDR_FORM ){
                    if((allGrandChildrenOfMainMap.get(fmsId).State_of_the_Form__c == 'SubmitToProcess' && allGrandChildrenOfMainMap.get(fmsId).SubmissionType__c == 'Final Submission' )|| (allGrandChildrenOfMainMap.get(fmsId).State_of_the_Form__c == 'HoldRTMforClientDecision' && allGrandChildrenOfMainMap.get(fmsId).SubmissionType__c == 'Final Submission') || (allGrandChildrenOfMainMap.get(fmsId).State_of_the_Form__c == 'ProceedToRTM' && allGrandChildrenOfMainMap.get(fmsId).SubmissionType__c == 'Final Submission') || (allGrandChildrenOfMainMap.get(fmsId).State_of_the_Form__c == 'RTMComplete' && allGrandChildrenOfMainMap.get(fmsId).SubmissionType__c == 'Final Submission')){
                        possibleParents.add(fmsId);
                    }
                }               
            }
            if(formObj.Form_Type__c != FMS_DDR_FORM && formObj.Form_Type__c != FMS_MAIN_FORM && (allGrandChildrenOfMainMap.get(zeroLevelId).State_of_the_Form__c == 'Submitted' || allGrandChildrenOfMainMap.get(zeroLevelId).State_of_the_Form__c == 'Frozen' || allGrandChildrenOfMainMap.get(zeroLevelId).State_of_the_Form__c == 'RequestToThaw' || allGrandChildrenOfMainMap.get(zeroLevelId).State_of_the_Form__c == 'Thawed')){
                possibleParents.add(zeroLevelId);
            }
        }
    }
    
    public PageReference populateObj(){     // Modified By Abhita to refresh the page
        if(selParentFMSObject != null && selParentFMSObject != ''){
            modifiedFMSObj = formObj.clone(true, true, false, false);
            modifiedFMSObj.Parent_Form_Id__c = Id.valueOf(selParentFMSObject);
            return null;
        } else {// Added the code By Abhita to refresh the page on selection of "== Select a parent =="
            PageReference pgRef = new PageReference('/apex/FMSCopyForms?Id=' + formObj.Id);
            pgRef.setRedirect(true);
            return pgRef;
        }// Ends here by Abhita
    }  
            
    public List<SelectOption> getParentList(){
        
        //code added by Akash to rearrange options in hierarichal order
        // We are already preparing the ordered list i hierarchy component, using the same list
        // to rearrange what has already been created - issue 272        
        set<Id> stAddedFMSId = new set<Id>();
        list<Id> tempPossibleParent = new list<Id>();
        for(String fId : FMSHierarchyCompController.lstStringFormIds) {
          for(Id fmId : possibleParents) {
            if(fmId == fId && !stAddedFMSId.contains(fId)) {
              tempPossibleParent.add(fId);
              stAddedFMSId.add(fId);
            }
          }
        }
        possibleParents = tempPossibleParent;
       //--code added ends here - issue 272
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '----Select form parent----'));
        for(Id i : possibleParents){
            options.add(new SelectOption(i,allGrandChildrenOfMainMap.get(i).Form_Name__c));
        }
        return options;
    }
    
    public PageReference continueMethod(){

        if(selParentFMSObject == null || selParentFMSObject == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error : Select Parent for new addendum form is a required field' ));
            return null;
        }
		//18-7-2017 Added below code against Export Control issue...#IM
        Form_Management_System__c fmsObj = [select Id, Device__c, Device__r.Export_Control_Status__c, Customer_Name__c, Customer_Name__r.SAP_Account_Number__c, Form_Type__c, Customer_Name__r.Contract_Customer__c from Form_Management_System__c where Id =:selParentFMSObject];
        if(formObj.Form_Type__c == FMS_RIT_FORM && fmsObj!=null && fmsObj.Form_Type__c != FMS_IMC_FORM && !UtilityCls.isRITAddendumAllowed(fmsObj)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error : RIT form creation under the selected form is unavailable until after an export control form has been submitted and subsequent approval is granted by GF Global Trade Compliance' ));
            return null;
        }

        PageReference pgRef = new PageReference('/apex/FMSmainFormCreation');
        pgRef.getParameters().put('id', formObj.Id);
        pgRef.getParameters().put('tranx', 'Copy');
        if(formObj.Form_Type__c == FMS_RIT_FORM  ){
            pgRef.getParameters().put('Type', 'RIT');
        }else if(formObj.Form_Type__c == FMS_IMC_FORM ){
            pgRef.getParameters().put('Type', 'IMC');
        }else if(formObj.Form_Type__c == FMS_DDR_FORM ){
            pgRef.getParameters().put('Type', 'DDR');
        }
        pgRef.getParameters().put('ParentId', selParentFMSObject);
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public PageReference cancelRecord(){
        String urlOnFormType = '';
        if(formObj.Form_Type__c == FMS_RIT_FORM){
            urlOnFormType = '/apex/FMSRITFormViewPage?id='+formObj.id;
        }else if(formObj.Form_Type__c == FMS_IMC_FORM){
            urlOnFormType = '/apex/FMSIMCFormViewPage?id='+formObj.id;
        }else if(formObj.Form_Type__c == FMS_DDR_FORM){
            urlOnFormType = '/apex/FMSDDRFormViewPage?id='+formObj.id;
        }
        PageReference pgRef = new PageReference(urlOnFormType);
        pgRef.setRedirect(true);
        return pgRef;
    }

}