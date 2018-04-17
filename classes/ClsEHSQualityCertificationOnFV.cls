/*
Type Name: AttachFeedItemController
Author: JK Technosoft Ltd (Ravi Teja B)
Reason: This class is used to attach files as feed items.

Change History:
Author: 
Modified Date: 
Reason: Merged 
Change History: 

*/
public with sharing class ClsEHSQualityCertificationOnFV extends QS_Paginator{
    public String qcId{get;set;}
    public String qcrecId{get;set;}
    public String srcFVUrl{get;set;}
    public Other_EHS_CSR_Certificate__c qcReportins {get;set;}
    public String srcEHSUrl{get;set;}
    public String rectypName{get; set;}
	public Boolean isEHSList {get; set;}
    public static final String QUALITY_CERTIFICATE_STAGE = 'Approved';
    
    // public list<Other_EHS_CSR_Certificate__c> ehslst{get;set;}
    public PageReference onLoadIframeAction() {
        if(ApexPages.currentPage().getParameters().get('Id') != null)
            qcReportins = [Select c.Certificate_Type__c,
                           c.Certificate_Title__c, c.RecordType.Name,
                           c.Name,c.FileId__c, c.LastModifiedDate,Date_of_Occurrence__c,Issue_Description__c
                           From Other_EHS_CSR_Certificate__c c where c.id=: ApexPages.currentPage().getParameters().get('Id') limit 1];
        rectypName = qcReportins.RecordType.Name;
        string baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('ApexPages.currentPage().getUrl()------>'+ApexPages.currentPage().getUrl()+'==='+ApexPages.currentPage().getHeaders().get('Host'));
        if(baseUrl.contains('globalfoundryview'))
            srcEHSUrl= baseUrl+'/GlobalfoundryView/apex/EHS_zipAndDownload?id='+ ApexPages.currentPage().getParameters().get('Id');
        else
            srcEHSUrl= baseUrl+'/apex/EHS_zipAndDownload?id='+ ApexPages.currentPage().getParameters().get('Id');
        system.debug('srcEHSUrl>>>'+srcEHSUrl);
        return null;
    }
    public PageReference backAction() {
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('baseUrl =' + baseUrl);
        
        PageReference pageRef = new PageReference(baseUrl+'/GlobalfoundryView'+'/apex/'+'vfEHSQualityCertificationOnFV?RecordType='+qcReportins.RecordTypeId);
        pageRef.setRedirect(true);
        return pageRef;
    }    
    public void Search(){
        system.debug('inside search==');
        String searchQuery= '';
        String fabsToSearch;
        pageNumber = 1;
        goToFirstPage();        
        qcAccList.clear();
        system.debug('rectypName&&'+rectypName);
        searchQuery = 'Select Other_EHS_CSR_Disclosures__r.Fabs__c,'+                        
            
            'Other_EHS_CSR_Disclosures__r.Certificate_Type__c,'+
            'Other_EHS_CSR_Disclosures__r.Certificate_Title__c,'+
            'Other_EHS_CSR_Disclosures__r.Expiry_Date__c,'+
            'Other_EHS_CSR_Disclosures__r.Effective_Date__c,'+
            'Other_EHS_CSR_Disclosures__r.Date_of_Occurrence__c,'+
            'Other_EHS_CSR_Disclosures__r.Issue_Description__c,'+
            'Other_EHS_CSR_Disclosures__r.Name,'+
            'Other_EHS_CSR_Disclosures__r.Id,'+
            'Other_EHS_CSR_Disclosures__c,'+                        
            'CreatedDate,'+
            'Account__c'+
            ' From EHS_Access_List__c '+
            ' WHERE Name != NULL'+
            '  AND Other_EHS_CSR_Disclosures__r.Stage__c = \''+QUALITY_CERTIFICATE_STAGE + '\''+ 
            '  AND (Customer_Black_List__c = null OR Customer_Black_List__c =\'\')'+
            '  AND Other_EHS_CSR_Disclosures__r.Expiry_Date__c >= TODAY AND Other_EHS_CSR_Disclosures__r.RecordType.Name =\''+ rectypName + '\'';
        
        if(AccountId != NULL && AccountId !=''){
            searchQuery = searchQuery + ' AND Account__c = \''+ AccountId +'\'';
        }
        
        if(certificateGroup != NULL && certificateGroup != 'None'){
            if(certificateGroup == 'REACH'){
                searchQuery = searchQuery + '  AND Other_EHS_CSR_Disclosures__r.Certificate_Type__c like \'REACH%\'';
                
            }else if(certificateGroup == 'MD'){
                searchQuery = searchQuery + '  AND (Other_EHS_CSR_Disclosures__r.Certificate_Type__c like \'Material%\') ';
            }else if(certificateGroup == 'CMRT'){
                searchQuery = searchQuery + '  AND (Other_EHS_CSR_Disclosures__r.Certificate_Type__c like \'CMRT%\') ';
            }
        }
        
        if(certTypeSelected != NULL && certTypeSelected != 'None'){
            certTypeSelected = certTypeSelected.replace('[','').replace(']','').replace(',',';');
            searchQuery = searchQuery + '  AND Other_EHS_CSR_Disclosures__r.Certificate_Type__c = \''+certTypeSelected+'\'';
        }
        if(fabSelected != NULL && fabSelected != '[None]'){
            fabSelected = fabSelected.replace('[','').replace(']','');
            string fabToSearch='';
            for(String fab:fabSelected.split(',')){
                fabToSearch = fabToSearch + '\''+fab.trim()+'\',';            
            }
            fabToSearch = fabToSearch.subString(0,fabToSearch.length()-1);
            searchQuery = searchQuery + '  AND Other_EHS_CSR_Disclosures__r.Fabs__c INCLUDES ('+fabToSearch+')';
        }
        searchQuery = searchQuery + ' ORDER BY CreatedDate limit 10000';
        
        system.debug('########Query#####'+searchQuery );
        qcAccList = database.Query(searchQuery);
        system.debug('qcAccList=='+qcAccList);
        if(qcAccList.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No results found. Please change the filters and try again.'));
        }
        prepareStdSetController(qcAccList);
    }
    
    public PageReference onClickRedirect() {
        system.debug('qcId&&'+qcId);
        PageReference redirect = new PageReference('/apex/VFEHSQualityCertificationIframe?id='+qcId +'&RecordType='+qcrecId); 
        redirect.setRedirect(true); 
        return redirect;
    }
    
    public List<Other_EHS_CSR_Certificate__c> qcReports;
    public List<EHS_Access_List__c> qcAccList{get;set;}
    
    //Nikhil-- Picklist values for FAB and Certificate Type
    public List<SelectOption> lstFabOptions{get;set;}
    //public List<SelectOption> lstCertTypeOptions{get;set;}
    public List<SelectOption> lstCertGroups{get;set;}
    public String fabSelected{get;set;}
    public String certTypeSelected{get;set;}
    public String AccountId;
    public String certificateGroup{get;set;}
    
    public ClsEHSQualityCertificationOnFV(){    
        ID recId = ApexPages.currentPage().getParameters().get('Id');
        if(recId !=null)
            qcReportins  = [Select c.Certificate_Type__c,
                            c.Certificate_Title__c, c.RecordType.Name,
                            c.Name,c.FileId__c, c.LastModifiedDate,Date_of_Occurrence__c,Issue_Description__c
                            From Other_EHS_CSR_Certificate__c c where id=: recId  limit 1];
        if(qcReportins!=null)
            rectypName = qcReportins.RecordType.Name;
        String rectpId = ApexPages.currentPage().getParameters().get('RecordType');
        if(rectpId != null){
            List<RecordType> rt = [Select Id,Name from Recordtype where Id=:rectpId];
            if(rt.size() > 0)
                rectypName = rt[0].Name;
        }
		isEHSList = true;

        system.debug('========&&rectypName'+rectypName);
        if(rectypName == 'Business Continuity Mgmt Approved'){
            isEHSList = false;
        }
        
        lstFabOptions = new List<SelectOption>();
        //lstCertTypeOptions = new List<SelectOption>();
        lstCertGroups = new List<SelectOption>();
        qcAccList = new List<EHS_Access_List__c>();
        populatePicklistValues();
        certificateGroup ='';
        List<User> usrList = [Select u.Contact.AccountId,u.Id,
                              u.ContactId,
                              u.Contact.Contact_Short_Name__c ,
                              u.Contact.Department__c From User u where u.Id =: UserInfo.getUserId()];
        
        if(!usrList.isEmpty()){
            AccountId = usrList[0].Contact.AccountId;
        }
        
        if(AccountId != null && AccountId != '' && rectpId != null){
            qcAccList = [Select q.Other_EHS_CSR_Disclosures__r.Fabs__c,                        
                         q.Other_EHS_CSR_Disclosures__r.Certificate_Type__c,
                         q.Other_EHS_CSR_Disclosures__r.Certificate_Title__c,
                         q.Other_EHS_CSR_Disclosures__r.Expiry_Date__c,
                         q.Other_EHS_CSR_Disclosures__r.Effective_Date__c,
                         q.Other_EHS_CSR_Disclosures__r.Date_of_Occurrence__c,
                         q.Other_EHS_CSR_Disclosures__r.Issue_Description__c,
                         q.Other_EHS_CSR_Disclosures__r.Name,
                         q.Other_EHS_CSR_Disclosures__r.Id,
                         q.Other_EHS_CSR_Disclosures__c,
                         q.CreatedDate,                        
                         q.Account__c,
                         q.Other_EHS_CSR_Disclosures__r.Stage__c
                         From EHS_Access_List__c q 
                         WHERE 
                         q.Account__c = :AccountId 
                         AND q.Other_EHS_CSR_Disclosures__r.Stage__c =:QUALITY_CERTIFICATE_STAGE 
                         AND (Customer_Black_List__c = null OR Customer_Black_List__c ='') AND Other_EHS_CSR_Disclosures__r.RecordTypeId =: rectpId 
                         AND ((q.Other_EHS_CSR_Disclosures__r.Expiry_Date__c >= TODAY AND q.Other_EHS_CSR_Disclosures__r.Date_of_Occurrence__c = null) OR (q.Other_EHS_CSR_Disclosures__r.Date_of_Occurrence__c != null AND q.Other_EHS_CSR_Disclosures__r.Expiry_Date__c = null)) 
                         ORDER BY q.CreatedDate DESC  limit 10000];
            system.debug('qcAccList&&'+qcAccList);
            
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
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Other_EHS_CSR_Certificate__c');
        system.debug('targetType'+targetType );
        Sobject Object_name = targetType.newSObject();
        system.debug('Object_name &&'+Object_name );
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        system.debug('sobject_type&&'+sobject_type );
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        system.debug('sobject_describe&&'+sobject_describe );
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        system.debug('field_map&&'+field_map ); 
        /*
List<Schema.PicklistEntry> picklist_certType = field_map.get('Certificate_Type__c').getDescribe().getPickListValues();
for (Schema.PicklistEntry a : picklist_certType) { 
lstCertTypeOptions.add(new SelectOption(a.getValue(),a.getValue()));
}
lstCertTypeOptions.sort();
lstCertTypeOptions.add(0,new SelectOption('None','--None--'));
*/
        List<Schema.PicklistEntry> picklist_fabs = field_map.get('Fabs__c').getDescribe().getPickListValues();
        system.debug('picklist_fabs&&'+picklist_fabs);
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
    public List<EHS_Access_List__c> QcAccessData {get; set;}
    public List<EHS_Access_List__c> getQcAccessData(){
        //List<EHS_Access_List__c> QcAccessData = new List<EHS_Access_List__c>();
        set<Id> accessIds = new set<Id>();
        Id recId;
        for(SObject record : getSObjectDataSet()) {
            accessIds.add(record.id);
        }       
        QcAccessData = [Select Id,Name, Other_EHS_CSR_Disclosures__r.Certificate_Title__c,Other_EHS_CSR_Disclosures__r.Certificate_Type__c,
                        Other_EHS_CSR_Disclosures__r.Fabs__c,Other_EHS_CSR_Disclosures__r.Effective_Date__c,Other_EHS_CSR_Disclosures__r.Expiry_Date__c,
                        Other_EHS_CSR_Disclosures__r.Id,Other_EHS_CSR_Disclosures__r.Issue_Description__c,Other_EHS_CSR_Disclosures__r.Date_of_Occurrence__c,
                        Other_EHS_CSR_Disclosures__r.Name from EHS_Access_List__c where Id in: accessIds];
        if(QcAccessData.size() > 0)
            recId = QcAccessData[0].Other_EHS_CSR_Disclosures__c;
        
        return QcAccessData;
    }
    
    
    public List<SelectOption> getlstCertTypeOptions() {
        List<SelectOption> options = new List<SelectOption>();
        if (certificateGroup.equals('REACH')) {
            options.add(new SelectOption('REACH Article 33 SVHC Declaration','REACH Article 33 SVHC Declaration'));
            
        }else if (certificateGroup.equals('MD')) {
            options.add(new SelectOption('Material Declaration','Material Declaration'));          
            
        }else if (certificateGroup.equals('CMRT')) {
            options.add(new SelectOption('CMRT (Conflict Minerals Declaration)','CMRT (Conflict Minerals Declaration)'));          
            
        }else{
			options.add(new SelectOption('Presentation','Presentation'));
            options.add(new SelectOption('Brochure','Brochure'));
            options.add(new SelectOption('Other','Other'));
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