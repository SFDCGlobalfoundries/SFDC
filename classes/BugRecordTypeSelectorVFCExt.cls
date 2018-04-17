/*********************************************************************************/
  // Purpose      : BugRecordTypeSelectorVFCExt class is responsible for major responsibilities / business logic required in UCM Project
  // Date created : 05 April, 2016
  // Created by   : UCM Team
  // Author       : Manikumar M 
  // Description  : Responsible to change the recordtype.
  // Change History 
  //    1. [Modify By] [Modify Date] 
  //        [Reason] :
/*********************************************************************************/
public class BugRecordTypeSelectorVFCExt{

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
    public BugRecordTypeSelectorVFCExt(ApexPages.StandardController controller) {
        fieldId = '';
        fieldValue = '';
        this.bugObj = (Bug__c)controller.getRecord();
        bugRecordTypeList = new List<RecordType>();
        for(RecordType rt: [select id, name, DeveloperName, description from recordtype where IsActive = true 
                                    and sobjecttype='Bug__c' and DeveloperName ='PDK_Request']) {
            bugRecordTypeList.add(rt);
        }
        bugRecordTypes = new List<SelectOption>();
        for(RecordType bugRT : bugRecordTypeList) {
            bugRecordTypes.add(new SelectOption(bugRT.id,System.Label.PDKWorkRequestRecordTypeName));
        }
        wrId = bugObj.Id;
        bugNumber = [Select Id,Name,IsBug__c,IsPDKRequest__c,RecordTypeId from Bug__c where Id=:wrId].Name;
    }
    
    // @return The custom edit page for Bug, with the specified record type ID
    public PageReference editWithRecordType() {
        fieldValue = 'New Request';
        fieldId = System.Label.BugStatusID;
        bugObj.RecordTypeId= selectedrecordtype;
        PageReference nextPage = new PageReference('/'+wrId+'/e?RecordType='+bugObj.RecordTypeId+'&'+fieldId+'='+fieldValue+'&retURL=%2F'+wrId);
        Bug__c bugObjStatus = new Bug__c(Status__c = 'New Request',id=bugObj.Id,Stages__c='New Request-Draft');
        update bugObjStatus;
        nextPage.setRedirect(true);
        return nextPage;
    }
}