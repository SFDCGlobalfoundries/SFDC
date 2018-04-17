/**
 * Author:
 * Company: Cognizant Technology Solutions Asia Pacific Pte Ltd
 * Description: It is a ClsPWCARportOnFV class. It is binded with vfPWCAReportOnFV page. It fetches PWCA Publication records and show on the page
 *             
 * History:
 * <Vijay>     28032014 - added filter criteria as 'Count_Report_Uploaded__c >= 1 and Approved__c = 'Approved' in query 
 * <Vijay>     27072014 - implemented searh CPK Report based on FAB, Geommetry and Techonology and pagination functionality
 */

public with sharing class ClsCpkReportOnFV extends QS_Paginator{
    public String cpkId{get;set;}
    public String srcFVUrl{get;set;}
    public CPK_Report__c cpkReportObj {get;set;}
    public String selectedFab{get;set;}
    public List<SelectOption> fabOptions {get;set;}
    private String userAccountId;
    private String query;
    public List<SelectOption> geometryOptions {get;set;}
    public List<SelectOption> technologyOptions {get;set;}
    public String selectedGeometry {get;set;}
    public String selectedTechnology {get;set;}
    public static final String CPK_REPORT_APPROVED_STATUS = 'Approved';
    public static final String CPK_REPORT_NO_REPORTS_STATUS = 'No Reports';
    public static final String CPK_REPORT_GEOMETRY_FIELD_NAME = 'Geometry__c';
    public static final String CPK_REPORT_TECHNOLOGY_FIELD_NAME = 'Technology__c';
    private  Map<String, Schema.SObjectField> CPKReportFieldMap;
    public Integer recordCount {get;set;}
    
    public ClsCpkReportOnFV(){
        cpkReportObj = new CPK_Report__c();
        CPKReportFieldMap = CPK_Report__c.getSObjectType().getDescribe().fields.getMap();
        List<User> usrList = [SELECT Contact.AccountId FROM User WHERE Id =: UserInfo.getUserId()];
        if(!usrList.isEmpty()){
                userAccountId = usrList[0].Contact.AccountId;
        }
        populateFABOptions();
        populateGeometryOptions();
        populateTechnologyOptions();
        Search();
    }    
     
    private void populateFABOptions(){
        system.debug('-------In populateFABOptions Method---------');
        List<FAB__c> fabList  = [SELECT Id, Name FROM FAB__c Order By Name Asc];
        fabOptions = new List<SelectOption>();
        fabOptions.add(new SelectOption('','--None--'));
        if(!fabList.isEmpty()){
            for(FAB__c fab :fabList){
                fabOptions.add(new SelectOption(fab.Id, fab.Name));
            }
        }
    }
    
    public void populateGeometryOptions(){
        system.debug('-------In getGeometryOptions Method---------');
        List<Schema.PicklistEntry> geometryPicklistValues = CPKReportFieldMap.get(CPK_REPORT_GEOMETRY_FIELD_NAME).getDescribe().getPickListValues();
        geometryOptions = new List<SelectOption>();
        geometryOptions.add(new SelectOption('','--None--'));
        for (Schema.PicklistEntry a : geometryPicklistValues) { 
            geometryOptions.add(new SelectOption(a.getValue(),a.getValue()));
        }
    }
    
     public void populateTechnologyOptions(){
        system.debug('-------In getTechnologyOptions Method---------');
        List<Schema.PicklistEntry> technologyPicklistValues = CPKReportFieldMap.get(CPK_REPORT_TECHNOLOGY_FIELD_NAME).getDescribe().getPickListValues();
        technologyOptions = new List<SelectOption>();
        technologyOptions.add(new SelectOption('','--None--'));
        for (Schema.PicklistEntry a : technologyPicklistValues) { 
            technologyOptions.add(new SelectOption(a.getValue(),a.getValue()));
        }
    }
     
    public PageReference onLoadIframeAction() {
        if(ApexPages.currentPage().getParameters().get('Id') != null)
        cpkReportObj = [SELECT c.Technology__c, 
                             c.Report_Cycle__c, 
                             c.Process_Descriptions__c,
                             c.Name, c.LastModifiedDate,
                             c.OpenTextId__c,OpenTextIdPublish__c,c.FABS__c, 
                             c.FABS__r.Name,c.Fab_Assign__c,Release_Date__c  
                        FROM   CPK_Report__c c 
                        WHERE  c.id=: ApexPages.currentPage().getParameters().get('Id') limit 1];
                      
      srcFVUrl = Label.CpkFVOpenTextUrlFirst + cpkReportObj.OpenTextIdPublish__c + Label.CpkFVOpenTextUrlSecond+ getUserShortName();
      
      System.debug('----->'+srcFVUrl);
      return null;
    }
    
    public void Search(){
        query ='';
        List<sObject> lstSObject = new List<sObject>();
        pageNumber = 1;
        recordCount = 0;
        //goToFirstPage();
        prepareQueryString();
        System.debug('query---------'+query);
        try{
            if(!String.isBlank(query)){
                lstSObject = Database.query(query);
                recordCount = lstSObject.size();
                if(lstSObject != null && lstSObject.isEmpty()){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No results found. Please change the filters and try again.'));
                }
                prepareStdSetController(lstSObject);
            }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There was some error, Please contact to System Administrator'));
        }
    }
    
    private void prepareQueryString() {
        String orderByClause =  ' ORDER BY CPK_Report__r.Release_Date__c DESC limit 10000';
        
        query = 'SELECT Id, CreatedDate, CPK_Report__r.FABS__c, CPK_Report__r.Technology__c, CPK_Report__r.Geometry__c, '+
                'CPK_Report__r.Id, CPK_Report__r.Process_Descriptions__c, CPK_Report__r.Name, CPK_Report__r.Fab_Assign__c, '+
                'CPK_Report__r.FABS__r.Name, CPK_Report__c, Account__c, CPK_Report__r.Report_Month__c, CPK_Report__r.Release_Date__c From CPK_Report_Access_List__c '; 
        
                
        String whereClause = ' WHERE CPK_Report__c IN (Select CPK_Report__c From Monthly_CPK_Report__c '+
                             ' Where ((Count_Report_Uploaded__c >= 1 AND Approved__c = \'' + String.escapeSingleQuotes(CPK_REPORT_APPROVED_STATUS) +'\') '+
                             ' OR (Move_To_Provisioning__c = true AND Approved__c  = \'' + String.escapeSingleQuotes(CPK_REPORT_NO_REPORTS_STATUS) +'\')))';
                             
        if(!String.isBlank(userAccountId)){
            whereClause = whereClause + ' AND Account__c = \''+ String.escapeSingleQuotes(userAccountId) +'\'';
        }           
        
        if(!String.isBlank(selectedGeometry)){
            whereClause = whereClause +  ' AND CPK_Report__r.Geometry__c = \'' + String.escapeSingleQuotes(selectedGeometry) +'\''; 
        }
        
        if(!String.isBlank(selectedTechnology)){
            whereClause = whereClause +  ' AND CPK_Report__r.Technology__c = \'' + String.escapeSingleQuotes(selectedTechnology) +'\''; 
        }
        
        if(!String.isBlank(selectedFab)){
            whereClause = whereClause +  ' AND CPK_Report__r.FABS__c = \'' + String.escapeSingleQuotes(selectedFab) +'\''; 
        }
        query = query + whereClause + orderByClause;
    }
    
    public List<CPK_Report_Access_List__c> getCPKReportAccessList(){
        return (List<CPK_Report_Access_List__c>) getSObjectDataSet();
    }

    
    public PageReference onClickRedirect() {
      PageReference redirect = new PageReference('/apex/VfCpkIframeOnFv?id='+cpkId); 
      redirect.setRedirect(true); 
      return redirect;
    }

    
    /*
    * @ Author        :- Navneet Rajput
    * @ Company       :- CTS
    * @ Date          :- 19/11/2013  
    * @ Description   :- Common Method which return user short name
    **/
      
    private string getUserShortName(){
        User user = [SELECT accountId,Portal_Login__c,HCM_Login_ID__c,UserType,Parent_Account_Short_Name__c,FederationIdentifier FROM User WHERE Id =:userInfo.getUserId()];
        if (user.HCM_Login_ID__c == null || user.HCM_Login_ID__c =='')
              return user.FederationIdentifier;// Federation ID will be always populated.
        else 
              return user.HCM_Login_ID__c;// In case federation Id is null it will take Hcm Id 
    }
    
   
}