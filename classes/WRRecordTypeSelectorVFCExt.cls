/*********************************************************************************/
  // Purpose      : WRRecordTypeSelectorVFCExt class is responsible for major responsibilities / business logic required in UCM Project
  // Date created : 03 April, 2016
  // Created by   : UCM Team
  // Author       : Manikumar M 
  // Description  : Responsible to change the recordtype.
  // Change History 
  //    1. [Modify By] [Modify Date] 
  //        [Reason] :
/*********************************************************************************/
public class WRRecordTypeSelectorVFCExt{

    /*
     * A Bug record template to facilitate Salesforce-native user input.
     */
    public Bug__c bugObj{ get; set; }
    public string wrId;
    public string fieldId{ get; set; }
    public List<RecordType> bugRecordTypeList {set; get;}
    public String bugNumber{get;set;}
    public string fieldValue;
    public String selectedrecordtype{get;set;}
    public List<SelectOption> bugRecordTypes {set; get;}
    

    
    // Default constructor that initializes member variables
    public WRRecordTypeSelectorVFCExt(ApexPages.StandardController controller) {
        fieldId = '';
        fieldValue = '';
        this.bugObj = (Bug__c)controller.getRecord();
        bugRecordTypeList = new List<RecordType>();
        for(RecordType rt: [select id, name, DeveloperName, description from recordtype where IsActive = true and sobjecttype='Bug__c' and DeveloperName != 'PDK_Request2' 
            and DeveloperName !='PDK_Request3' and DeveloperName !='Simulation_Request' and DeveloperName !='PDK_Request']) {
            bugRecordTypeList.add(rt);
        }
        bugRecordTypes = new List<SelectOption>();
        for(RecordType bugRT : bugRecordTypeList) {
            bugRecordTypes.add(new SelectOption(bugRT.id,bugRT.name));
        }
        wrId = bugObj.Id;
        bugNumber = [Select Id,Name,IsBug__c,IsPDKRequest__c,RecordTypeId from Bug__c where Id=:wrId].Name;
    }
    
    // @return The custom edit page for Bug, with the specified record type ID
    public PageReference editWithRecordType() {
        fieldValue = 'New';
        fieldId = System.Label.BugStatusID;
        bugObj.RecordTypeId= selectedrecordtype;
        PageReference nextPage = new PageReference('/'+wrId+'/e?RecordType='+bugObj.RecordTypeId+'&'+fieldId+'='+fieldValue+'&retURL=%2F'+wrId);
        nextPage.setRedirect(true);
        return nextPage;
    }
}