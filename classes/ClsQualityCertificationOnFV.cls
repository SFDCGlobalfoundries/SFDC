/**
 * Author:
 * Company: Cognizant Technology Solutions Asia Pacific Pte Ltd
 * Description: It is a ClsQualityCertificationOnFV class. It is binded with vfQualityCertificateFV page. It fetches quality certificates and show on the page
 *             
 * History:
 * <Vijay>     28032014 - added filter criteria as 'Quality Certificate Stage equals to Approved' in query  
 * <Vijay>     08042014 - updated the query filter criteria.
 * <Nikhil>    10062014 - Updated the filtering and search logic.
 */
public with sharing class ClsQualityCertificationOnFV extends QS_Paginator{
    public String qcId{get;set;}
    public String srcFVUrl{get;set;}
    public Quality_Certificate__c qcReportins {get;set;}
    
    public static final String QUALITY_CERTIFICATE_STAGE = 'Approved';
    
    public PageReference onLoadIframeAction() {
        if(ApexPages.currentPage().getParameters().get('Id') != null)
              qcReportins = [Select c.Certificate_Type__c, 
                             c.Certificate_Title__c, 
                             c.Name, c.LastModifiedDate,OpenTextId__c,OpenTextIdPublish__c
                             From Quality_Certificate__c c where c.id=: ApexPages.currentPage().getParameters().get('Id') limit 1];
        srcFVUrl = Label.CpkFVOpenTextUrlFirst+qcReportins.OpenTextIdPublish__c+Label.CpkFVOpenTextUrlSecond+getUserShortName();
        System.debug('------>'+srcFVUrl);
        return null;
    }
    
    public void Search(){
        String searchQuery= '';
        String fabsToSearch;
        pageNumber = 1;
        goToFirstPage();
        
        qcAccList.clear();
        searchQuery = 'Select q.Quality_Certificate__r.FAB__c,'+
                         'q.Quality_Certificate__r.Fabs__c,'+
                         'q.Quality_Certificate__r.Source__c,'+
                         'q.Quality_Certificate__r.Certificate_Type__c,'+
                         'q.Quality_Certificate__r.Certificate_Title__c,'+
                         'q.Quality_Certificate__r.Expiry_Date__c,'+
                         'q.Quality_Certificate__r.Effective_Date__c,'+
                         'q.Quality_Certificate__r.Name,'+
                         'q.Quality_Certificate__r.Id,'+
                         'q.Quality_Certificate__c,'+
                         'q.Quality_Certificate__r.Fab_Assign__c,'+
                         'q.CreatedDate,'+
                         'q.Account__c'+
                      ' From QC_Access_List__c q'+
                      ' WHERE Name != NULL'+
                      '  AND q.Quality_Certificate__r.Stage__c = \''+QUALITY_CERTIFICATE_STAGE + '\''+ 
                      '  AND (Customer_Black_List__c = null OR Customer_Black_List__c =\'\')'+
                      '  AND q.Quality_Certificate__r.Expiry_Date__c >= TODAY ';
        
        if(AccountId != NULL && AccountId !=''){
            searchQuery = searchQuery + ' AND q.Account__c = \''+ AccountId +'\'';
        }
        
        if(certificateGroup != NULL && certificateGroup != 'None'){
            if(certificateGroup == 'ISO'){
                searchQuery = searchQuery + '  AND q.Quality_Certificate__r.CertificateType__c like \'ISO%\'';
            }else if(certificateGroup == 'Others'){
                searchQuery = searchQuery + '  AND (NOT q.Quality_Certificate__r.CertificateType__c like \'ISO%\') ';
            }
        }
        
        if(certTypeSelected != NULL && certTypeSelected != 'None'){
            certTypeSelected = certTypeSelected.replace('[','').replace(']','').replace(',',';');
            searchQuery = searchQuery + '  AND q.Quality_Certificate__r.CertificateType__c = \''+certTypeSelected+'\'';
        }
        if(fabSelected != NULL && fabSelected != '[None]'){
            fabSelected = fabSelected.replace('[','').replace(']','');
            string fabToSearch='';
            for(String fab:fabSelected.split(',')){
                fabToSearch = fabToSearch + '\''+fab.trim()+'\',';            
            }
            fabToSearch = fabToSearch.subString(0,fabToSearch.length()-1);
            searchQuery = searchQuery + '  AND q.Quality_Certificate__r.Fabs__c INCLUDES ('+fabToSearch+')';
        }
        searchQuery = searchQuery + ' ORDER BY q.CreatedDate limit 10000';
        
        system.debug('########Query#####'+searchQuery );
        qcAccList = database.Query(searchQuery);
        if(qcAccList.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No results found. Please change the filters and try again.'));
        }
        prepareStdSetController(qcAccList);
    }
    
    public PageReference onClickRedirect() {
        PageReference redirect = new PageReference('/apex/VFQualityCertificationIframe?id='+qcId); 
        redirect.setRedirect(true); 
        return redirect;
    }
    
    public List<Quality_Certificate__c> qcReports;
    public List<QC_Access_List__c> qcAccList{get;set;}
    
    //Nikhil-- Picklist values for FAB and Certificate Type
    public List<SelectOption> lstFabOptions{get;set;}
    //public List<SelectOption> lstCertTypeOptions{get;set;}
    public List<SelectOption> lstCertGroups{get;set;}
    public String fabSelected{get;set;}
    public String certTypeSelected{get;set;}
    public String AccountId;
    public String certificateGroup{get;set;}
    
    public ClsQualityCertificationOnFV(){
        
        //Nikhil-- for popoulating the picklist options for the filters
        lstFabOptions = new List<SelectOption>();
        //lstCertTypeOptions = new List<SelectOption>();
        lstCertGroups = new List<SelectOption>();
        qcAccList = new List<QC_Access_List__c>();
        
        populatePicklistValues();
        certificateGroup ='';
        List<User> usrList = [Select u.Contact.AccountId,u.Id,
                                     u.ContactId,
                                     u.Contact.Contact_Short_Name__c ,
                                     u.Contact.Department__c From User u where u.Id =: UserInfo.getUserId()];
        
        if(!usrList.isEmpty()){
            AccountId = usrList[0].Contact.AccountId;
        }
        
        if(AccountId != null && AccountId != ''){
            qcAccList = [Select q.Quality_Certificate__r.FAB__c,
                         q.Quality_Certificate__r.Fabs__c,
                         q.Quality_Certificate__r.Source__c,
                         q.Quality_Certificate__r.Certificate_Type__c,
                         q.Quality_Certificate__r.Certificate_Title__c,
                         q.Quality_Certificate__r.Expiry_Date__c,
                         q.Quality_Certificate__r.Effective_Date__c,
                         q.Quality_Certificate__r.Name,
                         q.Quality_Certificate__r.Id,
                         q.Quality_Certificate__c,
                         q.CreatedDate,
                         q.Quality_Certificate__r.Fab_Assign__c,
                         q.Account__c,
                         q.Quality_Certificate__r.Stage__c
                         From QC_Access_List__c q 
                         WHERE 
                         q.Account__c = :AccountId 
                         AND q.Quality_Certificate__r.Stage__c =:QUALITY_CERTIFICATE_STAGE 
                         AND (Customer_Black_List__c = null OR Customer_Black_List__c ='') 
                         AND q.Quality_Certificate__r.Expiry_Date__c >= TODAY 
                         ORDER BY q.CreatedDate DESC  limit 10000];
        }
        if(qcAccList.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No results found. Please change the filters and try again.'));
        }
        prepareStdSetController(qcAccList);
        System.debug('qcAccList====='+qcAccList);
    }
    
    private string getUserShortName(){
        User user = [SELECT accountId,Portal_Login__c,HCM_Login_ID__c,UserType,Parent_Account_Short_Name__c,FederationIdentifier FROM User WHERE Id =:userInfo.getUserId()];
        if(user.HCM_Login_ID__c == null || user.HCM_Login_ID__c =='')
            return user.FederationIdentifier; //Federation ID will be always populated.
        else 
            return user.HCM_Login_ID__c; //In case federation Id is null it will take Hcm Id 
    } 
    
    public void populatePicklistValues(){
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Quality_Certificate__c');
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        
        /*
        List<Schema.PicklistEntry> picklist_certType = field_map.get('Certificate_Type__c').getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : picklist_certType) { 
            lstCertTypeOptions.add(new SelectOption(a.getValue(),a.getValue()));
        }
        lstCertTypeOptions.sort();
        lstCertTypeOptions.add(0,new SelectOption('None','--None--'));
        */
        List<Schema.PicklistEntry> picklist_fabs = field_map.get('Fabs__c').getDescribe().getPickListValues();
        
        /*
        Set<SelectOption> setFabNames = new Set<SelectOption>();
        for (Schema.PicklistEntry a : picklist_fabs) { 
            if(a.getValue() == 'FAB 2' || a.getValue() == 'FAB 3' || a.getValue() == 'FAB 35'){
                setFabNames.add(new SelectOption('GIGAplus','GIGA+'));
            }else{
                setFabNames.add(new SelectOption(a.getValue(),a.getValue()));
            }
        }
        lstFabOptions.addAll(setFabNames);
        */
        for (Schema.PicklistEntry a : picklist_fabs){
            lstFabOptions.add(new SelectOption(a.getValue(),a.getValue()));
        }
        lstFabOptions.sort();
        lstFabOptions.add(0,new SelectOption('None','--None--'));
        fabSelected = 'None';
        certTypeSelected = 'None';
        certificateGroup = 'None';
    }
    
    public List<QC_Access_List__c> getQcAccessData(){
        List<QC_Access_List__c> QcAccessData = new List<QC_Access_List__c>();
        for(SObject record : getSObjectDataSet()) {
           QcAccessData.add((QC_Access_List__c) record);
        }
        return QcAccessData;
    }
    
    public List<SelectOption> getlstCertTypeOptions() {
        List<SelectOption> options = new List<SelectOption>();
        if (certificateGroup.equals('ISO')) {
            options.add(new SelectOption('ISO','ISO'));
            options.add(new SelectOption('ISO 9001','ISO 9001'));
            options.add(new SelectOption('ISO 14001','ISO 14001'));
            options.add(new SelectOption('ISO 15048','ISO 15048'));
            options.add(new SelectOption('ISO TS16949','ISO TS16949'));
            options.add(new SelectOption('ISO14001 and OHSAS18001','ISO14001 and OHSAS18001'));
        }else if (certificateGroup.equals('Others')) {
            options.add(new SelectOption('BizSafe Star','BizSafe Star'));
            options.add(new SelectOption('ODS-Free','ODS-Free'));
            options.add(new SelectOption('OHSAS','OHSAS'));            
            options.add(new SelectOption('OHSAS 18001','OHSAS 18001'));            
            options.add(new SelectOption('SONY Green Partners','SONY Green Partners'));
            options.add(new SelectOption('TS','TS'));
        }else{
        }
        if(options != NULL && !options.isEmpty()){
            options.sort();
            options.add(0,new SelectOption('None','--None--'));
        }else{
            options.add(new SelectOption('None','--None--'));
        }
        return options;
    }
}