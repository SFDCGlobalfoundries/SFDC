/* 
 * Author:
 * Company: Cognizant Technology Solutions Asia Pacific Pte Ltd
 * Description: It is a ClsPWCARportOnFV class. It is binded with vfPWCAReportOnFV page. It fetches PWCA publication records and show on the page
 *             
 * History:
 * <Vijay>     28032014 - added filter criteria as 'PWCA publication Ready To Publish equals to true' in query  
 * <Nikhil>    10062014 - Updated the filtering and search logic. 
 */

public with sharing class ClsPWCARportOnFV extends QS_Paginator{
    public String pwcaId{get;set;}
    public String searchKeyword{get;set;}
    public String srcFVUrl{get;set;}
    public PWCA_publication__c pwcaReportins {get;set;}
    public Integer cpkReportReturnedSize{get;set;}
    public Boolean cpkReportReturned{get;set;}
    public static final String PWCA_publicATION_DOCUMENT_STATUS = 'Effective';

    public PageReference onLoadIframeAction() {
    if(ApexPages.currentPage().getParameters().get('Id') != null)
      pwcaReportins = [Select p.Wafer_ID__c, 
                             p.Valid_Till__c, 
                             p.Type_of_Metal_Layers__c, 
                             p.Type_of_Document__c,
                             p.TypeofDocument__c, 
                             p.Technology_Node__c, 
                             p.Targets_used_in_metal_deposition__c, 
                             p.Source__c, 
                             p.Reviewer_Needed__c, 
                             p.Regional_Site_Approval__c, 
                             p.RecordTypeId, 
                             p.Ready_To_Publish__c, 
                             p.OwnerId, 
                             p.No_of_Metal_Layers__c, 
                             p.Name, 
                             p.Lot_ID__c, 
                             p.IsDeleted, 
                             p.Information_from_YE__c,
                             p.Information_from_YE__r.Name, 
                             p.Id,p.OpenTextid__c,p.OpenTextIdPublish__c, 
                             p.Fab__c, 
                             p.Dopants_Used_for_Implantation__c, 
                             p.Document_Status__c, 
                             p.Device_ID__c 
                             From PWCA_publication__c p where p.id=: ApexPages.currentPage().getParameters().get('Id') limit 1];
      srcFVUrl = Label.CpkFVOpenTextUrlFirst+pwcaReportins.OpenTextIdPublish__c+Label.CpkFVOpenTextUrlSecond+getUserShortName();
      System.debug('----->'+srcFVUrl);
      return null;
    }
    
    public void Search(){
        String searchQuery= '';
        String fabsToSearch;
        pageNumber = 1;
        goToFirstPage();
        pwcaReportAccList.clear();
        
        searchQuery = 'Select p.PWCA_publication__r.Effective_Date__c, '+
                            ' p.PWCA_publication__r.Document_Title__c, '+
                            ' p.PWCA_publication__r.Valid_Till__c, '+
                            ' p.PWCA_publication__r.Technology_Node__c, '+
                            ' p.PWCA_publication__r.Fab__c, '+
                            ' p.PWCA_publication__r.CreatedDate, '+
                            ' p.PWCA_publication__r.Name, '+
                            ' p.Account__c '+
                        ' From PWCAAssociated_Customers__c p '+
                        ' WHERE p.PWCA_publication__r.Document_Status__c =\''+ PWCA_publicATION_DOCUMENT_STATUS + '\''+
                            ' AND p.PWCA_publication__r.Ready_To_Publish__c = true ';
                            
                        
        if(AccountId != NULL && AccountId !=''){
            searchQuery = searchQuery + ' AND p.Account__c = \''+ AccountId +'\'';
        }
        
        if(techNodeSelected != NULL && techNodeSelected != 'None'){
            techNodeSelected = techNodeSelected.replace('[','').replace(']','').replace(',',';');
            searchQuery = searchQuery + '  AND p.PWCA_publication__r.Technology_Node__c = \''+techNodeSelected+'\'';
        }
        if(fabSelected != NULL && fabSelected != '[None]'){
            fabSelected = fabSelected.replace('[','').replace(']','');
            string fabToSearch='';
            for(String fab:fabSelected.split(',')){
                fabToSearch = fabToSearch + '\''+fab.trim()+'\',';            
            }
            fabToSearch = fabToSearch.subString(0,fabToSearch.length()-1);
            searchQuery = searchQuery + '  AND p.PWCA_publication__r.Fab__c IN ('+fabToSearch+')';
        }
        searchQuery = searchQuery + ' ORDER BY p.CreatedDate DESC  limit 10000';
        
        system.debug('########Query#####'+searchQuery );
        pwcaReportAccList = database.Query(searchQuery);
        if(pwcaReportAccList.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No results found. Please change the filters and try again.'));
        }
        prepareStdSetController(pwcaReportAccList);
    }
    
    //Nikhil-- Picklist values for FAB and Certificate Type
    public List<SelectOption> lstFabOptions{get;set;}
    public List<SelectOption> lstTechNodeOptions{get;set;}
    public String fabSelected{get;set;}
    public string techNodeSelected{get;set;}
    public String AccountId;
    
    public void populatePicklistValues(){
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('PWCA_publication__c');
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        
        List<Schema.PicklistEntry> picklist_certType = field_map.get('Technology_Node__c').getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : picklist_certType) { 
            lstTechNodeOptions.add(new SelectOption(a.getValue(),a.getValue()));
        }
        lstTechNodeOptions.sort();
        lstTechNodeOptions.add(0,new SelectOption('None','--None--'));
        
        List<Schema.PicklistEntry> picklist_fabs = field_map.get('Fab__c').getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a : picklist_fabs) { 
            lstFabOptions.add(new SelectOption(a.getValue(),a.getValue()));
        }
        lstFabOptions.sort();
        lstFabOptions.add(0,new SelectOption('None','--None--'));
        fabSelected = 'None';
        techNodeSelected = 'None';
    }
    
    public PageReference onClickRedirect() {
        PageReference redirect = new PageReference('/apex/VfPwcaIframeOnFv?id='+pwcaId); 
        redirect.setRedirect(true); 
        return redirect;
    }

    public List<PWCA_publication__c > pwcaReports{get;set;}
    public List<PWCAAssociated_Customers__c> pwcaReportAccList{get;set;}
    
    public ClsPWCARportOnFV(){
        
        //Nikhil-- for popoulating the picklist options for the filters
        lstFabOptions = new List<SelectOption>();
        lstTechNodeOptions = new List<SelectOption>();
        pwcaReportAccList = new List<PWCAAssociated_Customers__c>();
        
        populatePicklistValues();
        
        List<User> usrList = [Select u.Contact.AccountId,u.Id,
                                     u.ContactId,
                                     u.Contact.Contact_Short_Name__c ,
                                     u.Contact.Department__c 
                                 FROM User u 
                                 WHERE u.Id =: UserInfo.getUserId()];
        
        if(!usrList.isEmpty()){
            AccountId = usrList[0].Contact.AccountId;
        }
        
        if(AccountId != null && AccountId != ''){
            pwcaReportAccList = [Select p.PWCA_publication__r.Effective_Date__c,
                                       p.PWCA_publication__r.Document_Title__c,
                                       p.PWCA_publication__r.Valid_Till__c,
                                       p.PWCA_publication__r.Technology_Node__c, 
                                       p.PWCA_publication__r.Fab__c, 
                                       p.PWCA_publication__r.CreatedDate, 
                                       p.PWCA_publication__r.Name,
                                       p.Account__c 
                                   From PWCAAssociated_Customers__c p 
                                   WHERE P.Account__c = :AccountId 
                                       AND P.PWCA_publication__r.Ready_To_Publish__c = true
                                       AND p.PWCA_publication__r.Document_Status__c =: PWCA_publicATION_DOCUMENT_STATUS 
                                   ORDER BY p.CreatedDate DESC  limit 10000];
        }
        if(pwcaReportAccList!= NULL && pwcaReportAccList.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No results found. Please change the filters and try again.'));
        }
        prepareStdSetController(pwcaReportAccList);
        System.debug('pwcaReportAccList====='+pwcaReportAccList);
    }
    
    private string getUserShortName(){
        User user = [SELECT accountId,Portal_Login__c,HCM_Login_ID__c,UserType,Parent_Account_Short_Name__c,FederationIdentifier FROM User WHERE Id =:userInfo.getUserId()];
        if (user.HCM_Login_ID__c == null || user.HCM_Login_ID__c =='')
              return user.FederationIdentifier;// Federation ID will be always populated.
        else 
              return user.HCM_Login_ID__c;// In case federation Id is null it will take Hcm Id 
    }
    
    public List<PWCAAssociated_Customers__c> getPWCAaccessData(){
        List<PWCAAssociated_Customers__c> getPWCAaccessData = new List<PWCAAssociated_Customers__c>();
        for(SObject record : getSObjectDataSet()) {
           getPWCAaccessData.add((PWCAAssociated_Customers__c) record);
        }
        return getPWCAaccessData;
    }
}