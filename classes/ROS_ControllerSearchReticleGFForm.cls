/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Functionality to change Reticle Obsolescence from Customer Portal,Update GE Form in mass for Fab User,Updating GE Form on individual Reticle record                  
* History       :   

Initials        Date                Description
-----------------------------------------------------------------------------------------
Ankit Singhal   01/09/2013  Created the Class
Sameer Matale   02/20/2014  Case# 7056 Fix
Nikhil Jain     02/19/2014  Added the functionality to Notify Customer by email
Sameer Matale   03/04/2014  Sharing with FTA and FAS
Sameer Matale   03/07/2014  Update code to include more reticles in email notification to customer
Nikhil Jain     27/03/2014  Optimized the code.
Nikhil Jain     15/04/2014  Added the logic for UserType and Category based Search Result Columns
Vijay Mahajan   20/05/2014  Added moveToActiveReticles and continueProcessing methods to process inactive reticles
Nikhil Jain     20/05/2014  Added the logic for storing Forwarder Information  
Nikhil Jain     24/07/2014  Restricting user to Notify or give Disposition(Scrap,Return,Keep) for Reticles belonging to previous cycles.
Commented the Recalculate sharing logic and created a new fuction: redirectToRecalculate()
Nikhil Jain     22/09/2014  Nullifying the field Date_Inactive_to_Active_Insertion__c once the Reticle from Inactive to Active have been processed accordingly.
Sunil Arora     24/09/2014  Added field company name for shipping address
DBiswal         06182015    Added fuctionality for PI/YE and Trade Compliance users.
DBiswal         08192015    Added Witness Arrival Date functionality.
DBiswal         09042015    Removed commented codes and debug statements.
Sunil Arora     04/12/2015  Logic update for Fabstr field for case # 49753.
Prashant        10/12/2015  Included logic to capture 1000th records in the list for export functionality for case # 00050078.
DBiswal         11182015    Added euc form functionality.
Prashant        06/12/2016  Changed Logic to resolve collection size limit case # 00050318.
Rnadella        23042017    Added Ros Phase 2 enhancements

**/

public with sharing class ROS_ControllerSearchReticleGFForm{ 
    public Set<string> uniquedev {get;set;}
    public List<List<String>> lDataString {get;set;}
    public Id recordID;
    public String Category{get;set;}
    public String UserType {get;set;}
    public List<String> UserField {get;set;}
    public String DeviceId{get;set;}
    public String Fab{get;set;}
    public String ReticleId{get;set;}
    public String Location{get;set;}
    public String Cycle{get;set;}
    public string waivedReason{get;set;}
    public boolean wReasonFlag{get;set;}
    public String HSCode {get;set;}
    public String Item {get;set;}
    public Boolean showhsSection = false;
    public Date WitArrivDate {get;set;}
    public String splInst {get;set;}
    public Set<String> accwitSet = new Set<String>();
    public Boolean showWitdate {get;set;}
    public EUC_Form__c eucFormTemp {get; set;}
    public List<String> reticleDetails {get; set;}
    public Boolean displayeucPopup {get; set;}
    public Boolean displayeucMsg {get;set;}
    public Map<String,String> reticleProdMap {get; set;}
    public String eucEmailId {get; set;}
    public Boolean isediteuc {get; set;}
    public Boolean eucedited {get; set;}
  public String enduserstmt1{get;set;}
    public String enduserstmt1_1{get;set;}
    public String enduserstmt5{get;set;}
    public String enduserstmt5_1{get;set;}
    public String enduserstmt6{get;set;}
    public String enduserstmt6_1{get;set;}
    public String enduserstmt7{get;set;}
    public String enduserstmt7_1{get;set;}
    public String enduserstmt8{get;set;}
    public String enduserstmt8_1{get;set;}
    public String enduserstmt9{get;set;}
    public String enduserstmt9_1{get;set;}
    public String enduserstmt10{get;set;}
    public String enduserstmt10_1{get;set;}
    public String enduserstmt11{get;set;}
    public String enduserstmt11_1{get;set;}
    public String devselected {get; set;}
    public List<SelectOption> devOptions {get; set;}
    public Boolean dispRetsec {get;set;}
    public list<reticle__c> listPSMRets {get; set;}
    public Attachment eucAttach {get; set;}
    public Id eucdevIdParent {get; set;}
    public Id eucdevIdChild {get; set;}
    public Id retIdChild {get; set;}
    public string retStatus {get; set;}
    public String devdisplayed {get; set;}
    public List<SelectOption> devlist {get; set;}
    public List<Reticle__c> reteucList = new List<Reticle__c>();
    public Boolean checkeucupload {get; set;}
    public String accId {get; set;}
    public List<eucConWrapper> listeucConWrapper {get; set;}
    public String shippingArea {get; set;}
    public Boolean displayeucQues {get; set;}
    
    public String ROSCycle;
    public String Categorycondition;
    public List<ReticleWrapper> Summaries=new List<ReticleWrapper>();
    public List<Fab__c> LFabs{get;set;}
    public List<ROS_Cycle__c> LROSCycles{get;set;}
    public String whereClause {get;set;}
    public boolean Checkbox{get;set;}
    public List<Reticle__c> selectedReticles;
    public String UpdateROSStatus{get;set;}
    public Id RowId{get;set{RowId= value;}}
    public boolean IsFabUser{get;set;}
    public boolean Allselected{get;set;}
    public String AccountName{get;set;}
    public Reticle__c res {get;set;}
    
    public List<SelectedReticleWrapper> SelReturnReticles{get;set;}
    public List<SelectedReticleWrapper> STFReticles;
    public String CurrentCycle {get;set;}
    public Boolean isDisableChkBx {get;set;}
    public Boolean isDisplayButtons{get;set;}
    public Boolean hasNotifyUpdateError{get;set;}
    public User loggedInUser;
    public string radioValue{get;set;}
    public attachment custAttach {get;set;}//added by ravikiran 
    public String dispositionType{get;set;}
    public String queryColumns {get;set;}
    public String strExportHeader{get;set;}
    public List<SelectOption> lOptionDispositionType {public get; private set;}
    public List<SelectOption> lOptionRegionType {public get; private set;}
    public String disp{get;set{disp= value;}}
    public set<id>retIdSet = new set<id>(); 
    private ApexPages.StandardSetController stdSetController {private get; private set;}
    //shuchi - Added for button visibility of Read only customer profile
    public Boolean accessReadWrite{get;set;}
    List<Portal_Tab_Access__c> portalTab = new List<Portal_Tab_Access__c>();
    public set<id>SetPSMRets{get;set;}
    public Map<Device__c,ROS_STFObsolescenceProcess.STFclassWrapper> RetcileListDevice;
    public Map<Device__c,ROS_STFObsolescenceProcess.STFclassWrapper> getRetcileListDevice(){
        this.RetcileListDevice = ROS_STFObsolescenceProcess.reticlDeviceLevelDisplay((List<reticle__c>) stdSetController.getRecords());
        return this.RetcileListDevice;
    }
    
    //Added by Ravikiran 
    public pageReference reDirectForm(){
        set<id>accountIdSet = new set<id>();
        
        system.debug(':::**'+summaries);
        for(Reticlewrapper retwrapper : summaries){ if(retwrapper.isselected == true){retIdSet.add(retwrapper.eachreticlewrapper.id);
                accountIdSet.add(retwrapper.eachreticlewrapper.Account__c);
            }
        }
        if(accountIdSet.size()==1){ if(retIdSet.size()>0){ PageReference  pf = Page.ROSVF_CusFeedbackAttachment;
                pf.setRedirect(false);return pf;//forward on server side
                //return null;
            }else{ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select atleast one Reticle'));return null;
            }
        }else {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Feedback cannot be attached to Reticles with Different Customers'));
            return null;
        }
    }
    
    
    public pagereference attachCusFeedback(){
        list<Reticle__c>LSelectedReticles = new list<Reticle__c>();
        list<attachment>cAttachList = new list<attachment>();
        system.debug(':::**retIdSetAFTER'+retIdSet);
        for(id  retId : retIdSet){ attachment att = new attachment();custAttach.ParentId = retId;
            att.body=custAttach.body;att.name=custAttach.name;
            att.description=custAttach.description;att.ParentId = retId;
            system.debug(':::**att.ParentId'+att.ParentId +'**' +retId);
            system.debug(':::**custAttach' +custAttach);
            system.debug(':::**Attach' +att);
            cAttachList.add(att);
            
            if(wReasonFlag){ Reticle__c rtn = new Reticle__c(id=retId);
                rtn.Debit_Note_Waive_Off__c = true;rtn.Reason_for_Waive_Off__c=waivedReason;
                LSelectedReticles.add(rtn);
            }
        }
        system.debug(':::**'+cAttachList);
        try{
            insert cAttachList;
            custAttach.body=null;
            if(LSelectedReticles.size()>0){ database.update(LSelectedReticles,false); 
            }ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.confirm, 'Uploaded Successfully')); }catch(Exception ex){ ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
        }
        
        return null ;
    }
    //DBiswal
    public List<SelectOption> getAreas() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Within Singapore','Within Singapore'));
        options.add(new SelectOption('Outside of Singapore','Outside of Singapore'));return options;
    }
    
    public PageReference returnKeep() {
        List<Reticle__c> LselectedReticles = new List<Reticle__c>();
        boolean isKeepSuccess=true;
        for(Reticlewrapper retwrapper : summaries){
            if(retwrapper.isselected == true){
                if(retwrapper.eachreticlewrapper.ROS_Cycle__r.name == NULL ||retwrapper.eachreticlewrapper.ROS_Cycle__r.name == '' ||retwrapper.eachreticlewrapper.ROS_Cycle__r.name == CurrentCycle)
                {
                    retwrapper.eachreticlewrapper.ROS_Status__c='Keep';
                    retwrapper.eachreticlewrapper.Pending_Debit_Note_Date__c=system.today();
                    LselectedReticles.add(retwrapper.eachreticlewrapper);}else{ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Disposition cannot be done for reticles that belongs to Inactive cycle. Please make a cycle selection that is correctly Active.'));return null;
                }
            }
        }
        if(!LselectedReticles.isEmpty()){
            isKeepSuccess = ROS_ControllerSearchReticlePortalUsers.returnDispositionType(LselectedReticles); }else{ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select atleast one Reticle for disposition.'));
            return null;
        }
        
        if(isKeepSuccess){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Request for Reticles Disposition submitted successfully'));

        } 
        return null;
    }
    //Shuchi- Added to view scrap certificates
    public PageReference ViewScrapCertificate() {        
        return new pageReference('/apex/ROSVF_ScrapCertificateView').setRedirect(true);
    }    
    public PageReference returnRetilce(){
        PageReference retVal;
        Set<String> sAccount = new Set<String>();
        String accountId;
        
        try{
            for(Reticlewrapper retwrapper : summaries){
                if(retwrapper.isselected == true) {
                    if(retwrapper.eachreticlewrapper.ROS_Cycle__r.name == NULL || retwrapper.eachreticlewrapper.ROS_Cycle__r.name == '' || retwrapper.eachreticlewrapper.ROS_Cycle__r.name == CurrentCycle)
                    {
                        sAccount.add(retwrapper.eachreticlewrapper.Account__c);
                        accountId = retwrapper.eachreticlewrapper.Account__c;}else{ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Disposition cannot be done for reticles that belongs to Inactive cycle. Please make a cycle selection that is correctly Active.'));return null;
                    }
                }
            }
            if(sAccount != null && !sAccount.isEmpty()){
                if (sAccount.size() > 1) {
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Disposition cannot be given to Reticles with Different Customers'));retVal = null;                } else if (sAccount.size() == 1) {
                    retVal = new PageReference('/apex/ROSVF_shippingAddress?AccountId=' + accountId);
                    retVal.setRedirect(false);} }else{ ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select atleast one Reticle for disposition.')); return null;
            }
            return retVal; }catch(Exception e){ROS_Util.InsertException(e,'ROS_SearchReticlesGFForm.UpdateBulkReticles','ROS');return null;}
    }
    
    public String getLDataString(){
        return null;
    }
    
    public List<Reticle__c> getselectedreticles(){
        selectedReticles = new List<Reticle__c>();
        selectedReticles.clear();        
        for(Reticlewrapper retwrapper: summaries){
            if(retwrapper.isselected == true) {
                selectedReticles.add(retwrapper.eachreticlewrapper);   
            }
        }    
        return selectedReticles;
    }
    
    public List<SelectedReticleWrapper> getReturnReticles(){    
        return SelReturnReticles;
    }
    
    /*******************************************
GE Form Search Variables
********************************************/
    public ROS_GEFormModel GEFormRequest;
    public String formSearchDate{get;set;}
    public ROS_RetreiveGEForm_1.result_element[] resReticle;
    public String formSearchTxt { get; set;}
    public List<String> LFormnumbers{get;set;}
    public List<FormWrapper> LWrapper{get;set;}
    public List<Selectoption> AllForms{get;set;}
    public boolean GEFormResults{get;set;}
    public String geFormId {get;set;}
    public String SelectedFormId{get;set;}
    public boolean IsStandardUser{get;set;}
    public ROS_GEFormModel getGEFormRequest(){
        if(GEFormRequest == null) {
            GEFormRequest =  new ROS_GEFormModel();
        }
        return GEFormRequest;
    }
    /****************************
Disposal Certificate
****************************/
    public Id CertificateId;
    public Account currentRecord{get;set;}
    public boolean CertificateCreated{get;set;}
    public ROS_Disposal_Certificate__c CertificateRecord{get;set;}
    public String ScrappingCompany{get;set;}
    public String ScrappingCompanyAddress{get;set;}
    public List<Reticle__c> LScrapReticles{get;set;}
    
    
    /********************************************
START Shipping Address Update Visualforce
********************************************/
    //Assigning Forwarder Information
    public Map<Id,Forwarder_Information__c> MapfwdInformations{get;set;}
    public Forwarder_Information__c NewFwdInfo = new Forwarder_Information__c();
    public string selectedFwdInfo1;
    public string selectedsplinst;
    public String splinstforsubmit;
    
    public static List<Shipping_Address__c> shipAddress{get;set;}
    public Shipping_Address__c newAddress = new Shipping_Address__c();
    public boolean IsnewAddress{get;set;}
    
    private string SelectedAddress_1;
    public Shipping_Address__c Shipaddress_1;
    public string addressId {get;set;}
    public Id shipaddressaccount;
    
    public String ShippingAddress{get;set{ShippingAddress= value;}}
    public Boolean IsReturnSubmitted{get;set;}
    public Boolean IsAllReturnSubmitted{get;set;}
    
    public String ForwarderAccountNumber{get;set;}
    public String ForwarderName{get;set;}
    public String ContactName{get;set;}    
    public String ContactPhoneNumber{get;set;}
    public string selectedAddress1;
    
    public void showaddress() {
        this.selectedAddress1 = 'Other';
        this.IsnewAddress = true;
    }
    
    public Shipping_Address__c getShipaddress_1(){
        return this.Shipaddress_1;
    }    
    
    public void ShowAddressAccount() {
        this.Shipaddress_1=  [Select id,Name,Account__c,Account__r.Name,Address1__c,Address2__c,
                              Shipping_Country__c,Shipping_State__c,zip_code__c
                              from Shipping_Address__c where id =: addressId limit 1];
    }
    
    public Shipping_Address__c  getNewAddress(){
        Shipping_Address__c obj = new Shipping_Address__c();
        this.newAddress = obj;
        return obj;
    }
    
    public Forwarder_Information__c getNewFwdInfo(){
        Forwarder_Information__c obj = new Forwarder_Information__c();
        this.NewFwdInfo = obj;
        return obj;
    }
    
    public PageReference ShippingAddressSave(){
        newAddress.Account__c = shipaddressaccount;
        boolean isSucess = ROS_ShippingAddressProcess.saveNewAddress(newAddress);
        addressProcess();
        if(!isSucess){ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Error in Address')); 
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm,'Address Added Sucessfully'));  
        }
        this.selectedaddress1 = null;
        return null;
    }
    
    public PageReference FwdInfoSave(){
        NewFwdInfo.Account__c = shipaddressaccount;
        boolean isSucess = ROS_ShippingAddressProcess.saveNewFwdInfo(NewFwdInfo);
        addressProcess();
        if(!isSucess){ ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Error in Forwarder Information')); 
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm,'Forwarder Information added Successfully'));  
        }
        this.selectedFwdInfo1 = null;
        return null;
    }
    
    public PageReference storesplinst(){
        splInst = Apexpages.currentPage().getParameters().get('SIinput');
        if(splInst!= null && splInst != ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm,'Instructions saved'));  }else{ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please enter something'));  
        }
        return null;
    }
    
    public PageReference deletesplinst(){
        splInst = null;
        return null;
    }
    
    public PageReference ShippingAddressAssign(){
        for(SelectedReticleWrapper  eachreticlewrapper : SelReturnReticles){
            if(eachreticlewrapper.IsChecked == true){if(eachreticlewrapper.eachSelectedreticlewrapper.Shipping_Address__c == null && SelectedAddress1.length() > 0){
                    if(SelectedAddress1 != 'Other'){
                        eachreticlewrapper.eachSelectedreticlewrapper.Shipping_Address__c = SelectedAddress1; }else if(SelectedAddress1 == 'Other'){eachreticlewrapper.eachSelectedreticlewrapper.Shipping_Address__c = newAddress.Id;
                    }
                    eachreticlewrapper.eachSelectedreticlewrapper.ROS_Status__c= 'Return'; 
                }
                
                if(eachreticlewrapper.eachSelectedreticlewrapper.Forwarder_Information__c == NULL && selectedFwdInfo1 != NULL){
                    string tempFwdInfoId;
                    if(selectedFwdInfo1 != 'Other'){
                        eachreticlewrapper.eachSelectedreticlewrapper.Forwarder_Information__c = selectedFwdInfo1;tempFwdInfoId = selectedFwdInfo1;
                    }else if(selectedFwdInfo1 == 'Other'){ eachreticlewrapper.eachSelectedreticlewrapper.Forwarder_Information__c = NewFwdInfo.Id;
                        tempFwdInfoId = NewFwdInfo.Id;
                    }
                    eachreticlewrapper.eachSelectedreticlewrapper.Forwarder_Name__c    = MapfwdInformations.get(tempFwdInfoId).Forwarder_Name__c;
                    eachreticlewrapper.eachSelectedreticlewrapper.Account_Number__c    = MapfwdInformations.get(tempFwdInfoId).Account_No__c; 
                    eachreticlewrapper.eachSelectedreticlewrapper.Contact_Name__c      = MapfwdInformations.get(tempFwdInfoId).Contact_Name__c;
                    eachreticlewrapper.eachSelectedreticlewrapper.Contact_Phone_Number__c= MapfwdInformations.get(tempFwdInfoId).Contact_Phone_No__c;
                }            
            }
        }
        newAddress=null;  
        NewFwdInfo=null;
        IsnewAddress=false;
        return null;
    }
    
    public PageReference selectAddress(){
        SelectedAddress_1 = selectedAddress1;
        return null;
    }
    
    public PageReference CleanAddress() {
        for(SelectedReticleWrapper  eachreticlewrapper : SelReturnReticles){
            if(eachreticlewrapper.IsChecked == true && eachreticlewrapper.IsInserted==false){
                eachreticlewrapper.eachSelectedreticlewrapper.Shipping_Address__c = null;
                eachreticlewrapper.eachSelectedreticlewrapper.ROS_Status__c = null;
                eachreticlewrapper.eachSelectedreticlewrapper.Forwarder_Name__c=null;
                eachreticlewrapper.eachSelectedreticlewrapper.Account_Number__c=null;
                eachreticlewrapper.eachSelectedreticlewrapper.Contact_Name__c=null;
                eachreticlewrapper.eachSelectedreticlewrapper.Contact_Phone_Number__c=null;
                eachreticlewrapper.eachSelectedreticlewrapper.Forwarder_Information__c = null;
            }
        }
        selectedAddress1 = null;
        selectedFwdInfo1 = null;
        return null;
    }
    
    public Pagereference CancelShippingAddress()
    {              
        PageReference  retVal = new PageReference('/apex/ROSVF_SearchReticlesGFForm');
        retval.setredirect(true); 
        return retVal ;
    }
    
    public PageReference ShippingAddressInsert(){
        IsAllReturnSubmitted=false;
        IsReturnSubmitted=false;
        Integer SelReturnSize;
        Integer InsertedSize;
        Boolean isMissingForwarderInfo = false;
        Boolean isReticleSelected = false;
        
        try{
            List<Reticle__c> LInsertedReticles=new List<Reticle__c>();
            
            for(SelectedReticleWrapper  eachreticlewrapper : SelReturnReticles){
                if(eachreticlewrapper.IsChecked) {
                    isReticleSelected = true;
                    if(eachreticlewrapper.eachSelectedreticlewrapper.Forwarder_Name__c == null || eachreticlewrapper.eachSelectedreticlewrapper.Account_Number__c == null) {
                        isMissingForwarderInfo = true;
                        break;
                    }
                }
            }
            
            if(!isReticleSelected) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select atleast one reticle for disposition.'));
                return null;}else if(isMissingForwarderInfo){ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Forwarder Name and Forwarder Account Number are mandatory for Reticles '));
                return null;
            }
            
            SelReturnSize=SelReturnReticles.size();
            for(SelectedReticleWrapper  eachreticlewrapper : SelReturnReticles){
                
                if(eachreticlewrapper.IsChecked == true && eachreticlewrapper.eachSelectedreticlewrapper.Shipping_Address__c!=null){   
                    eachreticlewrapper.IsInserted=true;
                    //DBiswal
                    if(!String.isEmpty(this.splInst) && (!String.isEmpty(this.selectedsplinst) && this.selectedsplinst == 'Yes')){eachreticlewrapper.eachSelectedreticlewrapper.Special_Instructions__c = splInst;
                    }
                    LInsertedReticles.add(eachreticlewrapper.eachSelectedreticlewrapper);
                }
            }
            
            InsertedSize=LInsertedReticles.size();
            if(SelReturnSize==InsertedSize){
                IsAllReturnSubmitted=true;        
            }
            
            if(!LInsertedReticles.isEmpty()){
                IsReturnSubmitted = ROS_ControllerSearchReticlePortalUsers.returnDispositionType(LInsertedReticles);
            }else{ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select atleast one Reticle for disposition.')); return null;
            }            
            if(IsReturnSubmitted){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Request for Reticles Disposition submitted successfully'));
                Reticlesearch(); }else{ ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Some error occurred. Please contact system administrator.')); return null;
            }
        }  catch(exception ex){ROS_Util.insertException(ex, 'ROS_ControllerSearchReticleGFForm','ROS'); return null;
        }        
        
        if(InsertedSize>0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM,+InsertedSize+' out of '+SelReturnSize+' Reticles disposed successfully'));
        }else{ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Atleast one reticle with Assigned Address is required for Disposition'));
        }        
        return null; 
    }
    
    /* Method is used for Add shipping Address in JQuery Model window. */ 
    public Reticle__c getAddress(){
        return res;
    }
    
    public string getselectedAddress1(){
        return this.selectedAddress1;
    }
    
    public void setselectedAddress1(string val){
        this.selectedAddress1  = val;
    }
    
    public string getselectedFwdInfo1(){
        return this.selectedFwdInfo1;
    }
    
    public void setselectedFwdInfo1(string val){
        this.selectedFwdInfo1  = val;
    }
    
    public List<selectOption> getradioOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No'));
        return options;
    }
    
    public string getselectedsplinst(){
        return this.selectedsplinst;
    }
    
    public void setselectedsplinst(string val){
        this.selectedsplinst = val;
    }
    
    public string getsplinstforsubmit(){
        return splinstforsubmit;
    }
    
    public void setsplinstforsubmit(string val){
        this.splinstforsubmit = val;
    }
    
    public List<Reticle__c> getsplinstlist(){
        List<Reticle__c> retlist = new List<Reticle__c>();
        for(SelectedReticleWrapper  eachreticlewrapper : SelReturnReticles){if(eachreticlewrapper.IsChecked == true){retlist.add(eachreticlewrapper.eachSelectedreticlewrapper);
            }
        }
        return retlist;
    }
    
    public pagereference ShipaddressAccountId(){
        SelReturnReticles.clear();
        for(Reticlewrapper retwrapper: summaries){
            if(retwrapper.isselected == true) {
                SelReturnReticles.add(new SelectedReticleWrapper(retwrapper.eachReticleWrapper, true)); 
            }
        }
        Allselected = true;
        shipaddressaccount=ApexPages.currentPage().getParameters().get('AccountId');   
        
        //DBiswal 11182015
        if(!Test.isrunningTest()){eucFormTemp = [SELECT Id,To_Address_1__c,To_Address_2__c,To_Address_3__c,End_User_Stmt_Sec_1__c,End_User_Stmt_Sec_2_1__c,End_User_Stmt_Sec_2_2__c,End_User_Stmt_Sec_2_3__c,End_User_Stmt_Sec_3__c,End_User_Stmt_Sec_4__c,End_User_Stmt_Sec_5__c,
                           End_User_Stmt_Sec_6__c,End_User_Stmt_Sec_7__c,End_User_Stmt_Sec_8__c,End_User_Stmt_Sec_9__c,Signature_1__c,Signature_2__c,Signature_3__c,Signature_4__c,Signature_5__c FROM EUC_Form__c WHERE Name='EUC-00001' LIMIT 1];
        } else {
            eucFormTemp = [SELECT Id,To_Address_1__c,To_Address_2__c,To_Address_3__c,End_User_Stmt_Sec_1__c,End_User_Stmt_Sec_2_1__c,End_User_Stmt_Sec_2_2__c,End_User_Stmt_Sec_2_3__c,End_User_Stmt_Sec_3__c,End_User_Stmt_Sec_4__c,End_User_Stmt_Sec_5__c,
                           End_User_Stmt_Sec_6__c,End_User_Stmt_Sec_7__c,End_User_Stmt_Sec_8__c,End_User_Stmt_Sec_9__c,Signature_1__c,Signature_2__c,Signature_3__c,Signature_4__c,Signature_5__c FROM EUC_Form__c LIMIT 1];            
        }
        reticleDetails = Environment_Variable__c.getInstance('ROS_EUCForm_Table_Headers').value__c.split(';');Set<String> eucFabs = new Set<String>();
        eucFabs.addAll(Environment_Variable__c.getInstance('ROS_EUCForm_Fabs').value__c.split(';'));
        for(SelectedReticleWrapper  eachreticlewrapper : SelReturnReticles){
            if(eachreticlewrapper.IsChecked == true){
                Integer count = 0;
                if(eachreticlewrapper.eachSelectedreticlewrapper.Reticle_Type__c =='PSM' && eachreticlewrapper.eachSelectedreticlewrapper.EUC_Form_Sent__c == false){
                    for(String s : eachreticlewrapper.eachSelectedreticlewrapper.FabStr__c.contains(',') ? eachreticlewrapper.eachSelectedreticlewrapper.FabStr__c.split(',') : eachreticlewrapper.eachSelectedreticlewrapper.FabStr__c.split(';')){
                        if(eucFabs.contains(s)){
                            count++;
                        }
                    }
                    if(count > 0){
                        reteucList.add(eachreticlewrapper.eachSelectedreticlewrapper);
                    }
                }
            }
        }if(reteucList.size() > 0){
            displayeucQues = true;
            reticleProdMap = new Map<String,String>();
            Set<String> uniquehscode = new Set<String>();
            for(Reticle__c ret : reteucList){
                for(String str : reticleDetails){
                    if(str == System.Label.ROS_ProductDescription){
                        if(!reticleProdMap.containsKey(str)){
                            reticleProdMap.put(str,'Semiconductor Reticle');
                        }
                    }else if(str == System.Label.ROS_ProductCode){
                        if(!reticleProdMap.containsKey(str)){reticleProdMap.put(str,'DL3B001.h');
                        }
                    }else if(str == System.Label.ROS_HSCode){
                        if((ret.HS_Code__c != null && ret.HS_Code__c != '') && !uniquehscode.contains(ret.HS_Code__c)){
                            uniquehscode.add(ret.HS_Code__c);
                        }
                        if(uniquehscode.size()>0 && uniquehscode != null){
                            for(String s : uniquehscode){
                                if(!reticleProdMap.containsKey(str)){
                                    reticleProdMap.put(str,s);}else{if(reticleProdMap.get(str).containsNone(s)){reticleProdMap.put(str,reticleProdMap.get(str)+', '+ s);
                                    }
                                }
                            }} else { reticleProdMap.put(str,Environment_Variable__c.getInstance('Default HS Code').Value__c);
                        }
                    }else if(str == System.Label.ROS_Brand){
                        if(!reticleProdMap.containsKey(str)){
                            reticleProdMap.put(str,'N/A');
                        }
                    }else if(str == System.Label.ROS_Model){
                        if(!reticleProdMap.containsKey(str)){
                            reticleProdMap.put(str,ret.Name);
                        }else{ reticleProdMap.put(str,reticleProdMap.get(str)+', '+ ret.Name);
                        }
                    }else if(str == System.Label.ROS_Value){
                        if(!reticleProdMap.containsKey(str)){
                            reticleProdMap.put(str,'US$100/each');
                        }
                    }
                }
                accId = ret.Account__c;}if(reticleProdMap != null && reticleProdMap.get(System.Label.ROS_Model) != null){reticleProdMap.put(System.Label.ROS_Quantity,String.valueOf(reticleProdMap.get(System.Label.ROS_Model).split(',').size())+' nos');
            }
        } else {
            displayeucPopup = false;
            displayeucQues = false;accId = '';
        }                    
        return null;
    }
    
    public pageReference refresheucForm(){
        if(shippingArea != null && shippingArea != ''){
            try{
                List<Reticle__c> retlisttoUpdate = new List<Reticle__c>();
                if(shippingArea.equalsIgnoreCase('Within Singapore')){ for(Reticle__c ret : reteucList){
                        ret.EUC_Form_Required__c = false;
                        retlisttoUpdate.add(ret);
                    }
                    displayeucPopup = false;
                } else {
                    for(Reticle__c ret : reteucList){                        ret.EUC_Form_Required__c = true;retlisttoUpdate.add(ret);
                    }
                    displayeucPopup = true;
                }
                if(retlisttoUpdate.size() > 0){
                    update retlisttoUpdate;
                }} catch(Exception e) { displayeucMsg = true;ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Some error occured. Please Contact your Administrator.'));
                return null;
            }
            displayeucQues = false;
        }        
        return null;
    }
    
    //DBiswal 11182015
    public pageReference sendeucMail(){
        if(eucEmailId != '' && eucEmailId != null){
            Set<String> uniqueemailset = new Set<String>();
            List<String> toAddressList = new List<String>();
            for(String mail : eucEmailId.contains(';') ? eucEmailId.split(';') : eucEmailId.split(',')){
                uniqueemailset.add(mail);
            }toAddressList.addAll(uniqueemailset); Messaging.EmailFileAttachment csvAttch = new Messaging.EmailFileAttachment();
            csvAttch.setFileName('EUC_Form_'+'DL3B001.h'+'.doc');
            PageReference pagetosend = Page.ROSVF_EUCForm;
            Blob b = !Test.isRunningTest() ? pagetosend.getContent() : Blob.ValueOf('dummy<text<');
            String newBlob = '';
            for(String s : b.toString().split('<')){
                if(!s.startsWith('link')){if(!newBlob.endsWith('<')){
                        newBlob += '<';
                    }
                    newBlob += s;
                }
            }
            csvAttch.setBody(Blob.valueof(newBlob));
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSenderDisplayName('ROS System');
            mail.setToAddresses(toAddressList);
            mail.setCcAddresses(new List<String>{UserInfo.getUserEmail()});
            mail.setHtmlBody('Hi,<br/><br/>Fab is making arrangement on the reticles return and as the listed reticles are PSM type, Singapore custom requires an EUC form before shipment. Please sign the attach EUC form and return the signed copy to '+UserInfo.getUserEmail()+' and your customer service support soonest possible.<br/><br/>Thank you');
            mail.setSubject('Reticles return for Device '+'DL3B001.h'+' requires EUC form completion');
            mail.setSaveAsActivity(false);
            mail.setFileAttachments(new List<Messaging.EmailFileAttachment>{csvAttch});
            try{
                Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
                List<Reticle__c> lstretstoupdate = new List<Reticle__c>();
                for(Reticle__c ret : reteucList){
                    ret.EUC_Form_Sent__c = true;
                    lstretstoupdate.add(ret);
                }
                update lstretstoupdate;} catch(Exception e) {displayeucMsg = true; ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error sending Notification'));
                return null;
            }
        } else {
            displayeucMsg = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No email address provided'));
            return null;
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Notification sent successfully.'));
        displayeucPopup = false;
        displayeucMsg = false;
        return null;
    }
    
    public class eucConWrapper{
        public Contact eachCon {get;set;}
        public Boolean isSelected {get;set;}   
        
        public eucConWrapper(Contact eachContact,Boolean value) {
            eachCon = eachContact;
            isSelected =value;
        }
    }
    
    public pageReference euclookupinit(){
        accId = ApexPages.currentPage().getParameters().get('accid');
        eucEmailId = ApexPages.currentPage().getParameters().get('eucEmailId');
        if(accId != null){
            List<Contact> conlist = [SELECT Id,Name,Account.Name,Phone,Email,Role__c FROM Contact WHERE AccountId=:accId AND Name!=null AND Email!=null];
            if(conlist.size()>0){
                listeucConWrapper = new List<eucConWrapper>();
                for(Contact c : conlist){
                    if((eucEmailId != null && eucEmailId != '') && (c.Email != null && c.Email != '')){
                        if(eucEmailId.containsIgnoreCase(c.Email)){listeucConWrapper.add(new eucConWrapper(c,true));
                        } else {
                            listeucConWrapper.add(new eucConWrapper(c,false));}} else {listeucConWrapper.add(new eucConWrapper(c,false));
                    }} }else {ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No Contacts Present'));return null;
            }
        }else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No Account Selected'));
            return null;
        }
        return null;
    }
    
    public pageReference closeeucPopup(){
        displayeucPopup = false;
        displayeucMsg = false;
        return null;
    }
    
    public pageReference editeucForm(){
        isediteuc = true;
        displayeucMsg = false;
        enduserstmt1_1 = null;
        enduserstmt5_1 = null;
        enduserstmt6_1 = null;
        enduserstmt7_1 = null;
        enduserstmt8_1 = null;
        enduserstmt9_1 = null;
        enduserstmt10_1 = null;
        enduserstmt11_1 = null;
        
        return null;
    }
    
    public void reseteucform(){
        eucedited = false;
        isediteuc = false;
        displayeucMsg = false;
    enduserstmt1_1 = null;
        enduserstmt5_1 = null;
        enduserstmt6_1 = null;
        enduserstmt1 = null;
        enduserstmt5 = null;
        enduserstmt6 = null;
        enduserstmt7_1 = null;
        enduserstmt8_1 = null;
        enduserstmt9_1 = null;
        enduserstmt10_1 = null;
        enduserstmt11_1 = null;
        enduserstmt7 = null;
        enduserstmt8 = null;
        enduserstmt9 = null;
        enduserstmt10 = null;
        enduserstmt11 = null;
        eucEmailId = '';
    }
    
    public pageReference saveeucForm(){
         enduserstmt1_1 = ApexPages.currentPage().getParameters().get('saveenduserstmt1');
        enduserstmt1 = enduserstmt1_1;
        enduserstmt5_1 = ApexPages.currentPage().getParameters().get('saveenduserstmt5');
        enduserstmt5 = enduserstmt5_1;
        enduserstmt6_1 = ApexPages.currentPage().getParameters().get('saveenduserstmt6');
        enduserstmt6 = enduserstmt6_1;
        enduserstmt7_1 = ApexPages.currentPage().getParameters().get('saveenduserstmt7');
        enduserstmt7 = enduserstmt7_1;
        enduserstmt8_1 = ApexPages.currentPage().getParameters().get('saveenduserstmt8');
        enduserstmt8 = enduserstmt8_1;
        enduserstmt9_1 = ApexPages.currentPage().getParameters().get('saveenduserstmt9');
        enduserstmt9 = enduserstmt9_1;
        enduserstmt10_1 = ApexPages.currentPage().getParameters().get('saveenduserstmt10');
        enduserstmt10 = enduserstmt10_1;
        enduserstmt11_1 = ApexPages.currentPage().getParameters().get('saveenduserstmt11');
        enduserstmt11 = enduserstmt11_1;
        eucedited = true;
        isediteuc = false;
        displayeucMsg = true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Form is saved successfully.'));
        return null;
    }
    
    public void disPSMRets(){
        system.debug('@@@@' +devselected);
        eucdevIdParent=devselected;
        listPSMRets = new list<reticle__c>();
        for(Reticle__c ret : ((List<Reticle__c>)stdSetController.getRecords())){
            for(String eachdev : ret.GlobalFoundries_Device_ID__c.contains(',') ? ret.GlobalFoundries_Device_ID__c.split(',') : ret.GlobalFoundries_Device_ID__c.split(';')){
                if(uniquedev.contains(eachdev.deleteWhitespace())){
                    listPSMRets.add(ret);
                }
                
            }
            
            
            SetPSMRets = new set<id>();if(!devselected.equalsIgnoreCase('None')){ dispRetsec = true;
                for(Reticle_Device__c ret1 : [Select id ,Reticle__c from Reticle_Device__c where 
                                              Device__c =:devselected]){SetPSMRets.add(ret1.Reticle__c);
                                              }
            } 
        }
    }
    public PageReference eucAttachReset() {
        eucAttach = new Attachment();
        return null;
    }
    
    public PageReference eucAttachupload() {
        Device__c eucdevNameChild = new Device__c(); 
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        List<Reticle__c> psmRetstoUpdate = new List<Reticle__c>();
        Attachment eucAttach1 = new Attachment();
        eucAttach1 = eucAttach;
        eucAttach1.OwnerId = UserInfo.getUserId();
        eucdevIdChild = ApexPages.currentPage().getParameters().get('devid');
        retIdChild= ApexPages.currentPage().getParameters().get('retid');
        retStatus=ApexPages.currentPage().getParameters().get('status');
        if(eucdevIdChild != null){
            eucAttach1.ParentId = eucdevIdChild;
            eucdevNameChild = [SELECT Name, MES_Device_Id__c,PLM_Device_ID__c ,CRMDID__c 
                               FROM Device__c WHERE Id=:eucdevIdChild LIMIT 1];
        } else {eucAttach1.ParentId = retIdChild;}
        eucAttach1.IsPrivate = false;
        
        try {
            insert eucAttach1;
            if(retIdChild<>null){ //Null point check for euc form
                reticle__c rec = new reticle__c(id=retIdChild);
                if(retStatus.contains('STF')){
                    rec.Reticle_workflow_Status__c = 'Pending for STF Obsolescence';
                }else{ rec.Reticle_workflow_Status__c = 'Pending for Fab\'s Follow-up';
                }
                
                rec.EUC_Form_Link__c = baseUrl + '/servlet/servlet.FileDownload?file=' + eucAttach1.Id;
                rec.EUC_Form_Submitted__c = true;
                psmRetstoUpdate.add(rec);
            }
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment' +e.getmessage()));
            return null;
        } finally {
            eucAttach = new Attachment(); 
        }
        
        
        
        for(Reticle__c ret : [SELECT Id,Name,EUC_Form_Submitted__c,GlobalFoundries_Device_ID__c,Reticle_workflow_Status__c ,Csr_notified_date__c  FROM Reticle__c WHERE ROS_Status__c = 'Return' AND ROS_Cycle__r.name = :CurrentCycle 
                              AND Reticle_Type__c='PSM' AND (Reticle_workflow_Status__c='Pending for EUC Form,Pending for STF Obsolescence' OR Reticle_workflow_Status__c='Pending for EUC Form')]){
                                  system.debug('>>>>>' +ret.GlobalFoundries_Device_ID__c);
                                  system.debug('>>>>>' +eucdevNameChild.MES_Device_Id__c);
                                  system.debug('>>>>>' +eucdevNameChild.PLM_Device_ID__c);
                                  system.debug('>>>>>' +eucdevNameChild.CRMDID__c);
                                  set<string>gfDevSet = new set<string>();
                                  
                                  
                                  for(String eachdev : ret.GlobalFoundries_Device_ID__c.contains(',') ? ret.GlobalFoundries_Device_ID__c.split(',') : ret.GlobalFoundries_Device_ID__c.split(';')){ gfDevSet.add(eachdev.deleteWhitespace());
                                  }
                                  
                                  
                                  
                                  if((gfDevSet.contains(eucdevNameChild.MES_Device_Id__c) ||  gfDevSet.contains(eucdevNameChild.PLM_Device_ID__c) ||
                                      gfDevSet.contains(eucdevNameChild.CRMDID__c))){
                                          
                                          ret.EUC_Form_Submitted__c = true;if(eucAttach1.Id != null){ ret.EUC_Form_Link__c = baseUrl + '/servlet/servlet.FileDownload?file=' + eucAttach1.Id;
                                          }if(ret.Reticle_workflow_Status__c == 'Pending for EUC Form,Pending for STF Obsolescence'){
                                              ret.Reticle_workflow_Status__c = 'Pending for STF Obsolescence';
                                          } else if(ret.Reticle_workflow_Status__c == 'Pending for EUC Form'){ ret.Reticle_workflow_Status__c = 'Pending HS Code Assignment';
                                          } psmRetstoUpdate.add(ret);
                                          
                                          system.debug('>>>>>>'+psmRetstoUpdate);
                                      }
                              }
        
        if(psmRetstoUpdate != null){
            try {
                Database.update(psmRetstoUpdate,false); } catch (DMLException e) {ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error updating Reticles'));
                return null;
            }
        }
        checkeucupload = true;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully')); return null;
    }
    
    public Pagereference addressProcess() {
        newAddress=null;
        shipAddress = null;
        //Company_Name__c added by Sunil Arora for case # 34809
        shipAddress = new List<Shipping_Address__c>([ SELECT zip_code__c
                                                     , Shipping_State__c
                                                     , Shipping_Country__c
                                                     , Company_Name__c
                                                     , Id
                                                     , Address2__c
                                                     , Address1__c
                                                     , Shipping_Address_Full__c
                                                     , Account__c
                                                     FROM Shipping_Address__c
                                                     WHERE Account__c =:shipaddressaccount]);
        mapfwdInformations  = new map<Id,Forwarder_Information__c>([SELECT Id, Account_No__c, Contact_Name__c, 
                                                                    Contact_Phone_No__c, Forwarder_Name__c, Account__c 
                                                                    FROM Forwarder_Information__c
                                                                    WHERE Account__c =:shipaddressaccount]);
        return null;
    }
    
    public pageReference nullifyAddress(){
        ForwarderAccountNumber=null;
        ForwarderName=null;
        ContactName=null;
        ContactPhoneNumber=null;
        
        SelectedAddress1 = null;
        selectedFwdInfo1 = null;
        splinstforsubmit = null; //DBiswal
        selectedsplinst = null;
        addressProcess();
        return null;
    }
    
    public List<SelectOption> getShippingAddresses() {
        Reticle__c updateret=new Reticle__c();
        
        if(res != null){
            ShippingAddress = res.Account__r.Bill_To_Address_1__c 
                + '\n'+ res.Account__r.Bill_To_Address_2__c
                + '\n' + res.Account__r.Bill_To_Address_3__c
                + '\n' + res.Account__r.Bill_To_Address_4__c
                + '\n' + res.Account__r.Bill_To_City__c
                + '\n' + res.Account__r.Bill_To_Country__c
                + '\n' + res.Account__r.Bill_To_State__c
                + '\n' + res.Account__r.Bill_To_Location__c
                + '\n' + updateret.Account__r.Bill_To_Postal_Zip_Code__c;
            
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('ShippingAddress',ShippingAddress));
            options.add(new SelectOption('Other','Other'));
            
            return options;
        }else{
            return null;
        }
    }    
    /********************************************
END Shipping Address Update Visualforce
********************************************/
    
    public void changeDispositiontype() {
        List<Schema.PicklistEntry> lPicklistEntry = Reticle__c.ROS_Status__c.getDescribe().getPicklistValues();
        lOptionDispositionType = new List<SelectOption>();
        dispositionType='nullVal';
        lOptionDispositionType.add(new SelectOption('nullVal', 'None'));
        
        if(category == 'pGeForm' || category == 'pDisShip'){
            dispositionType='Return';
            lOptionDispositionType.add(new Selectoption('Return','Return'));
        }
        else if(category == 'pDisCert'){
            dispositionType='Scrap';
            lOptionDispositionType.add(new Selectoption('Scrap','Scrap'));
        }
        else if(category=='pDebitNote'){
            dispositionType='Keep';
            lOptionDispositionType.add(new Selectoption('Keep','Keep'));
        }
        else if(category=='pStfObsel'){
            lOptionDispositionType.add(new Selectoption('Return','Return'));
            lOptionDispositionType.add(new Selectoption('Scrap','Scrap'));
        }        
        else if(category=='pEucForm'){
            dispositionType='Return';
            lOptionDispositionType.add(new Selectoption('Return','Return'));
        }
        //DBiswal 06182015
        else if(category=='pHSCodAsign'){
            dispositionType='Return';
            lOptionDispositionType.add(new Selectoption('Return','Return'));
        }
        //DBiswal 07082015
        else if(category=='pWADate'){
            dispositionType='Scrap';
            lOptionDispositionType.add(new Selectoption('Scrap','Scrap'));
            //DBiswal 08192015
            showWitdate = false;
            List<Reticle__c> lRet = [SELECT Id,Name,Reticle_workflow_Status__c,ROS_Status__c,Witness_Arrival_Date__c ,Csr_notified_date__c  FROM Reticle__c 
                                     WHERE ROS_Status__c = 'Scrap' AND Witness_Arrival_Date__c != null AND ROS_Cycle__r.Name =: CurrentCycle AND Account__r.Short_Name__c IN: accwitSet];
            if(lRet != null && lRet.size() > 0){
                WitArrivDate = lRet[0].Witness_Arrival_Date__c;
            } else{
                WitArrivDate = Date.today() + 30;
            }
        }
        //DBiswal 08242015
        else if(category=='pCstfdbk'){
            List<Reticle__c> lRet1 = [SELECT Id,Name,Reticle_workflow_Status__c,ROS_Status__c,Witness_Arrival_Date__c ,Csr_notified_date__c  FROM Reticle__c 
                                      WHERE ROS_Status__c = 'Scrap' AND Witness_Arrival_Date__c != null AND ROS_Cycle__r.Name =: CurrentCycle AND Account__r.Short_Name__c IN: accwitSet];
            if(lRet1 != null && lRet1.size() > 0){
                WitArrivDate = lRet1[0].Witness_Arrival_Date__c;
            }
        }
        else{
            for(Schema.PicklistEntry picklistEntry :lPicklistEntry) {
                SelectOption selOption = new SelectOption(picklistEntry.getValue(), picklistEntry.getValue());
                lOptionDispositionType.add(selOption);
            }
        }
        //Nikhil-- As per change mentioned on 13Apr14
        checkbox = false;
        
    }
    
    public ROS_ControllerSearchReticleGFForm(){
        custAttach = new attachment();
        wReasonFlag=false;
        SelReturnReticles = new list<SelectedReticleWrapper>();
        STFReticles = new list<SelectedReticleWrapper>();
        CertificateCreated=false;
        currentcycle=ROS_Util.getCurrentROSCycle();
        cycle=currentcycle;
        isDisplayButtons=true;
        recordID = ApexPages.currentPage().getParameters().get('id');
        UserType =  ROS_Util.UserType();        
        isDisableChkBx = false;
        //shuchi - Added for button visibility of Read only customer profile  
        accessReadWrite = true;      
        portalTab = [select id,My_Reticles_Read_Only__c from Portal_Tab_Access__c where Contact__c in (select ContactId from User where id=:UserInfo.getUserId()) limit 1];
        for(Portal_Tab_Access__c p : portalTab){
            if(p.My_Reticles_Read_Only__c == true && UserType == 'Customer'){accessReadWrite = false; 
            }                
        }
        List<Schema.PicklistEntry> lPicklistEntry = Reticle__c.ROS_Status__c.getDescribe().getPicklistValues();
        lOptionDispositionType = new List<SelectOption>();
        lOptionDispositionType.add(new SelectOption('nullVal', 'None'));
        for (Schema.PicklistEntry picklistEntry :lPicklistEntry) {
            SelectOption selOption = new SelectOption(picklistEntry.getValue(), picklistEntry.getValue());
            lOptionDispositionType.add(selOption);
        }
        
        //Added by Ravikiran for ROS 
        List<Schema.PicklistEntry> lPicklistEntryR = Account.Region__c.getDescribe().getPicklistValues();
        lOptionRegionType = new List<SelectOption>();
        lOptionRegionType.add(new SelectOption('nullVal', 'None'));
        for (Schema.PicklistEntry picklistEntry :lPicklistEntryR) {
            SelectOption selOption = new SelectOption(picklistEntry.getValue(), picklistEntry.getValue());
            lOptionRegionType.add(selOption);
        }
        //Nikhil-- For userType and category based search result columns
        String  myCS1;
        if(category == NULL || category == ''){
            myCS1 = ROS_Query_UserType_Category__c.getValues(UserType + '-' + 'None').Fields__c;
        }else{myCS1 = ROS_Query_UserType_Category__c.getValues(UserType + '-' + category).Fields__c;
        }
        UserField = new List<String>();           
        
        for(String Str : myCS1.split(',')){
            UserField.add(Str);
        }
        if(recordId!=null) {
            selectedReticles= new List<Reticle__c>();  
            
            Reticle__c eachreticle = new Reticle__c();
            eachreticle = [ Select Id,Name,Pending_Debit_Note_Date__c,GlobalFoundries_Device_ID__c,Device_ID__c,ROS_Cycle__r.Name,ROS_Status__c,GE__c ,Csr_notified_date__c  FROM Reticle__c where Id=:recordID ];
            selectedReticles.add(eachreticle);
        }
        
        loggedInUser = [select id,UserType,AccountId  from User where Id=:UserInfo.getUserId()];
        if(loggedInUser.UserType=='Standard'){
            IsStandardUser = true;
        }
        AllForms = new List<Selectoption>();
        List<Fab_User__c> LFabUsers = new List<Fab_User__c>([Select Id from Fab_User__c where User__c=:UserInfo.getUserId() and Is_ROS_User__c =: true]);
        if(LFabUsers.isEmpty())
            IsFabUser=false;
        else if(!(LFabUsers.isEmpty()))
            IsFabUser=true;
        
        Checkbox=false;
        AccountName='';
        
        
        ROSCycle = ROS_Util.getCurrentROSCycle();
        LFabs = new List<Fab__c>([Select Id,Name from Fab__c order by Name]);
        LROSCycles = new List<ROS_Cycle__c>([ SELECT Id, Name FROM ROS_Cycle__c ORDER BY Cycle_Start_Date__c]);
        
        selectedOptionNotify = 'With_Reticle';
        hasNotifyUpdateError = false;
        selReticles = new List<String>();
        
        //DBiswal 08192015
        ROS_Witness_Arrival_Accounts__c roswa = ROS_Witness_Arrival_Accounts__c.getOrgDefaults();
        List<String> accList = roswa.Account_Short_Name__c.split(',');
        if(!accList.isEmpty()){
            accwitSet.addAll(accList);
        }
        //DBiswal 11182015
        displayeucPopup = false;
        displayeucMsg = false;
        displayeucQues = false;
        isediteuc = false;
        eucedited = false;
        dispRetsec = false;
        eucAttach = new Attachment();
        checkeucupload = false;
        
        getHelpText();
    }
    
    public List<Selectoption> getFabs(){
        List<Selectoption> AllFabs = new List<Selectoption>();
        AllFabs.add(new selectOption('noFab','None'));
        for(Fab__c eachFab : Lfabs) {
            AllFabs.add(new selectOption(eachFab.Name,eachFab.Name));
        }
        return AllFabs;    
    }
    
    public List<Selectoption> getCycles() {
        List<Selectoption> AllCycles = new List<Selectoption>();
        AllCycles.add(new selectOption('', 'None'));
        if(category != 'Active Reticles' ){
            for(ROS_Cycle__c eachCycle : LROSCycles){
                AllCycles.add(new selectOption(eachCycle.Name,eachCycle.Name)); 
            }
        }else{
            Cycle = null;
        }
        return AllCycles;    
    }
    
    public List<Reticlewrapper> getSelectedRetwrapper(){
        if(Category != 'pHSCodAsign'){
            summaries.clear();
            for (Reticle__c eachReticle : ((List<Reticle__c>)stdSetController.getRecords())){           
                Summaries.add(new reticlewrapper(eachreticle,false)); 
            }
        } else {
            if(summaries.isEmpty() || showhsSection == false){
                summaries.clear();
                for (Reticle__c eachReticle : ((List<Reticle__c>)stdSetController.getRecords())){           
                    Summaries.add(new reticlewrapper(eachreticle,false)); 
                }
            } 
        }
        Allselected = false;
        showhsSection = false;
        return summaries;    
    }
    
    //Search Reticle Function
    public void reticleSearch(){
        
        String queryColumns = '';
        whereClause = 'WHERE Name != null ';
        isDisableChkBx = false;
        Checkbox = true;        
        
        //Nikhil-- For userType and category based search result columns
        // for filtering the columns based on Category selected by the respective user
        String  tempFields;
        
        if((Category == NULL || Category == '') && ROS_Query_UserType_Category__c.getValues(UserType + '-' + 'None') != NULL){
            tempFields = ROS_Query_UserType_Category__c.getValues(UserType + '-' + 'None').Fields__c;
        }else if(ROS_Query_UserType_Category__c.getValues(UserType + '-' + Category) != NULL){
            tempFields = ROS_Query_UserType_Category__c.getValues(UserType + '-' + Category).Fields__c;
        }else{
            tempFields = 'Account__r.Name,Name,Reticle_Type__c,GlobalFoundries_Device_ID__c,Device_ID__c,FabStr__c';
        }
        UserField.clear();
        UserField.addAll(tempFields.split(','));
        
        if (ROS_Query_UserType_Category__c.getValues('ALLCOLUMNS_ONE').Fields__c != null) {
            queryColumns = queryColumns + ROS_Query_UserType_Category__c.getValues('ALLCOLUMNS_ONE').Fields__c;
        }
        
        if (ROS_Query_UserType_Category__c.getValues('ALLCOLUMNS_TWO').Fields__c != null) {
            queryColumns = queryColumns + ROS_Query_UserType_Category__c.getValues('ALLCOLUMNS_TWO').Fields__c;
        }
        if (category != null && !category.equalsIgnoreCase('none')) {
            if (category.equalsIgnoreCase('Active Reticles')) {
                isDisableChkBx = true;
                if(UserType!='Customer' && UserType!='CSR'){
                    isDisplayButtons=false;
                    whereClause = whereClause + ' AND IsActive__c = true';
                }else{whereClause = whereClause + ' AND IsActive__c = true';
                }
            }else if (category.equalsIgnoreCase('InActive Reticles')) {
                isDisableChkBx = true;
                if(UserType!='Customer' && UserType!='CSR'){
                    isDisplayButtons=false;
                    whereClause = whereClause + ' AND IsActive__c = false';
                }else{ whereClause = whereClause + ' AND IsActive__c = false';
                }
            } else if (category.equalsIgnoreCase('Archived Reticles')) {
                isDisplayButtons=false;                
                whereClause = whereClause + ' AND Reticle_Workflow_Status__c = \'Closed\' AND ROS_Status__c != null ';
            } else if (category.equalsIgnoreCase('pDisCert')) {
                isDisableChkBx = true;
                whereClause = whereClause + ' AND ROS_Status__c = \'Scrap\' AND Reticle_Workflow_Status__c = \'' +  String.escapeSingleQuotes('Pending for Fab\'s Follow-up') +'\' AND Scrapped_Certificate_Generated__c = false ';
            } else if (category.equalsIgnoreCase('pNotifyCust')) {
                isDisableChkBx = true;
                whereClause = whereClause + ' AND ROS_Status__c = null AND Reticle_Workflow_Status__c = \'Pending to Notify Customer\' ';
            } else if (category.equalsIgnoreCase('pStfObsel')) {
                isDisableChkBx = true;
                whereClause = whereClause + ' AND (ROS_Status__c = \'Scrap\' OR ROS_Status__c = \'Return\') AND (Reticle_Workflow_Status__c = \'Pending for STF Obsolescence\' OR Reticle_Workflow_Status__c = \'Pending for EUC Form,Pending for STF Obsolescence\') AND STF_Obsolence__c = false ';
            } else if (category.equalsIgnoreCase('pCstfdbk')) {
                isDisplayButtons=true;
                isDisableChkBx = true;
                whereClause = whereClause + ' AND ROS_Status__c = null AND Reticle_Workflow_Status__c = \'Pending for Customer Feedback\' ';
            } else if (category.equalsIgnoreCase('pEucForm')) {
                isDisplayButtons=true;
                isDisableChkBx = true;
                whereClause = whereClause + ' AND ROS_Status__c = \'Return\' AND Reticle_Type__c = \'PSM\' AND (Reticle_Workflow_Status__c = \'Pending for EUC Form,Pending for STF Obsolescence\' OR Reticle_Workflow_Status__c = \'Pending for EUC Form\') ';
            } else if (category.equalsIgnoreCase('pGeForm')) {
                isDisableChkBx = true;
                whereClause = whereClause + ' AND ROS_Status__c = \'Return\' AND GE__c = null AND Reticle_Workflow_Status__c = \'' +  String.escapeSingleQuotes('Pending for Fab\'s Follow-up')+ '\' ';
            } else if (category.equalsIgnoreCase('pDebitNote')) {
                isDisableChkBx = true;
                whereClause = whereClause + ' AND ROS_Status__c = \'Keep\' AND Debit_Note_Waive_Off__c = false AND Debit_Note_Number__c = null AND Reticle_Workflow_Status__c = \'Pending Debit Note\' ';
            }
            else if (category.equalsIgnoreCase('pDisShip')) {
                isDisableChkBx = false;
                whereClause = whereClause + ' AND ROS_Status__c = \'Return\' AND Reticle_Workflow_Status__c = \'Pending for Shipment\' ';
            }else if (category.equalsIgnoreCase('pforVerification')) {
                isDisableChkBx = true;
                isDisplayButtons=true;
                whereClause = whereClause + ' AND New_Inactive_Days__c != null';
            }
            //DBiswal 06182015
            else if (category.equalsIgnoreCase('pHSCodAsign')) {
                isDisableChkBx = true;
                whereClause = whereClause + ' AND ROS_Status__c = \'Return\' AND Reticle_Workflow_Status__c = \'Pending HS Code Assignment\'  AND HS_Code_Assigned__c = false ';
            }
            //DBiswal 07082015
            else if (category.equalsIgnoreCase('pWADate')) {
                isDisableChkBx = true;
                whereClause = whereClause + ' AND ROS_Status__c = \'Scrap\' AND Reticle_Workflow_Status__c = \'Pending Witness Arrival Date\' ';
            }
            
            if(!category.equalsIgnoreCase('pforVerification')){
                whereClause = whereClause + ' AND New_Inactive_Days__c = null';
            }
        }else{
            whereClause = whereClause + ' AND New_Inactive_Days__c = null';
        }
        
        if (dispositionType != null && dispositionType.length() > 0 && !dispositionType.equalsIgnoreCase('nullVal')) {
            if (!category.equalsIgnoreCase('Archived Reticles') || !category.equalsIgnoreCase('none')) {
                whereClause = whereClause + ' AND ROS_Status__c LIKE \'' + dispositionType + '%\' ';
            }
        }
        
        if (ReticleId != null && ReticleId.length() > 0) {
            whereClause = whereClause + ' AND Name LIKE \'' + ReticleId + '%\' ';
        }
        
        if (Fab != null && Fab.length() > 0 && !Fab.equalsIgnoreCase('noFab')) {
            //--case#00063427---Start---Jabee---
            if(Fab=='Fab 3'){ whereClause = whereClause + ' AND FabStr__c=\'' + Fab + '\' ';
                
            }
            if(Fab=='Fab 3E'){whereClause = whereClause + ' AND FabStr__c=\'' + Fab + '\' ';
            }
            if(Fab=='Fab 1'){ whereClause = whereClause + ' AND FabStr__c=\'' + Fab + '\' ';
            }
            if(Fab=='Fab 2'){whereClause = whereClause + ' AND FabStr__c=\'' + Fab + '\' ';
            }
            if(Fab=='Fab 5'){ whereClause = whereClause + ' AND FabStr__c=\'' + Fab + '\' ';
            }
            if(Fab=='Fab 6'){whereClause = whereClause + ' AND FabStr__c=\'' + Fab + '\' ';
            }
            if(Fab=='Fab 7'){whereClause = whereClause + ' AND FabStr__c=\'' + Fab + '\' ';
            }
            if(Fab=='Fab 8'){
                whereClause = whereClause + ' AND FabStr__c=\'' + Fab + '\' ';
            }
            if(Fab=='Fab 9'){ whereClause = whereClause + ' AND FabStr__c=\'' + Fab + '\' ';
            }
            if(Fab=='Fab 10'){whereClause = whereClause + ' AND FabStr__c=\'' + Fab + '\' ';
            }
            if(Fab=='Fab 35'){whereClause = whereClause + ' AND FabStr__c=\'' + Fab + '\' ';
            }
            //--case#00063427---End---Jabee---
        }
        
        if (DeviceId != null && DeviceId.length() > 0) {
            whereClause = whereClause + ' AND Id IN ( SELECT Reticle__c FROM Reticle_Device__c ' 
                + ' WHERE GF_Device_Id__c LIKE \'' + DeviceId + '%\' '
                + ' OR CRM_Device_ID__c LIKE \'' + DeviceId + '%\') ';
        }
        
        if (Location != null && Location.length() > 0 && !Location.equalsIgnoreCase('nullVal')) {
            whereClause = whereClause + ' AND Account_Region__c = \'' + Location + '\' ';
        }
        
        if (AccountName != null && AccountName.length() > 0) {
            whereClause = whereClause + ' AND Account__r.Name LIKE \'' + AccountName + '%\' ';
        }
        
        if (Cycle != null && Cycle.length() > 0) {
            whereClause = whereClause + ' AND Ros_Cycle__r.Name = \'' + Cycle + '\' ';
        }
        
        if (geFormId != null && geFormId.length() > 0) {
            whereClause = whereClause + ' AND GE__c LIKE \'' + geFormId + '%\' ';
        }
        //Nikhil -- Added condition for Portal Users
        system.debug('%%%S%%%E%%A%%R%%C%%H%%%'+whereClause);
        if(UserType == 'Customer'){ whereClause = whereClause + ' AND Account__c = \'' + loggedInUser.AccountId + '\' ';
        }
        if(Test.isRunningTest()) {
            stdSetController = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT ' + queryColumns + ' ,Shipping_Address__r.Address1__c,Shipping_Address__r.Address2__c,Shipping_Address__r.Shipping_Country__c,Shipping_Address__r.shipping_State__c,Shipping_Address__r.zip_code__c,Account__r.Short_Name__c,Witness_Arrival_Date__c,Special_Instructions__c,Acknowledge_Special_Instructions__c,STF_Obsolence__c,HS_Code_Assigned__c,EUC_Form_Sent__c ,Csr_notified_date__c  FROM Reticle__c ' + whereClause +' ORDER BY CreatedDate Desc, Name ASC limit 50'));
        }else{
            if(userType != 'Customer') stdSetController = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT ' + queryColumns + ' ,Shipping_Address__r.Address1__c,Shipping_Address__r.Address2__c,Shipping_Address__r.Shipping_Country__c,Shipping_Address__r.shipping_State__c,Shipping_Address__r.zip_code__c,Account__r.Short_Name__c,Witness_Arrival_Date__c,Special_Instructions__c,Acknowledge_Special_Instructions__c,STF_Obsolence__c,HS_Code_Assigned__c,EUC_Form_Sent__c ,Csr_notified_date__c  FROM Reticle__c ' + whereClause +' ORDER BY Name ASC limit '+Environment_Variable__c.getInstance('ROS_TOTAL_DATA_LOAD').Value__c+''));
            else stdSetController = new ApexPages.StandardSetController(ROS_ControllerSearchReticlePortalUsers.queryReticlesSystemMode2('SELECT ' + queryColumns + ' ,Shipping_Address__r.Address1__c,Shipping_Address__r.Address2__c,Shipping_Address__r.Shipping_Country__c,Shipping_Address__r.shipping_State__c,Shipping_Address__r.zip_code__c,Account__r.Short_Name__c,Witness_Arrival_Date__c,Special_Instructions__c,Acknowledge_Special_Instructions__c,STF_Obsolence__c,HS_Code_Assigned__c,EUC_Form_Sent__c ,Csr_notified_date__c  FROM Reticle__c ' + whereClause +' ORDER BY Name ASC limit '+Environment_Variable__c.getInstance('ROS_TOTAL_DATA_LOAD').Value__c+''));
        }
        stdSetController.setPageSize(Integer.valueOf(Environment_Variable__c.getInstance('ROS_IMPORT_EXPORT_PAGESIZE').Value__c));
        
        stdSetController.setPageNumber(1);
        Allselected=false;
        if(stdSetController.getRecords().isEmpty()){
            Checkbox = false;
            showWitdate = true;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info,'No Records found for your Search'));
        }
        //DBiswal 12042015
        else{
            if (category != null && !category.equalsIgnoreCase('none')) {
                if(category.equalsIgnoreCase('pEucForm')){
                    uniquedev = new Set<String>();devOptions = new List<SelectOption>();
                    devOptions.add(new SelectOption('None','None'));for(Reticle__c ret : ((List<Reticle__c>)stdSetController.getRecords())){
                        if(String.isNotBlank(ret.GlobalFoundries_Device_ID__c)){
                            for(String eachdev : ret.GlobalFoundries_Device_ID__c.contains(',') ? ret.GlobalFoundries_Device_ID__c.split(',') : ret.GlobalFoundries_Device_ID__c.split(';')){
                                uniquedev.add(eachdev.deleteWhitespace());
                                system.debug('>>>>>' +uniquedev);
                            }
                        }
                    }
                    if(uniquedev.size()>0){
                        for(Device__c eachdev : [Select Id,Name,Account__c,MES_Device_Id__c,PLM_Device_ID__c,CRMDID__c 
                                                 from Device__c 
                                                 where name in :(uniquedev) 
                                                 or MES_Device_Id__c in :(uniquedev) 
                                                 or PLM_Device_ID__c in :(uniquedev) 
                                                 or CRMDID__c in :(uniquedev)]){devOptions.add(new SelectOption(eachdev.id,eachdev.name));
                                                 }}else{  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No Devices found , Attach the form directly to the Reticle'));
                    }
                }
            }
        }
    }
    
    public void beginning() {
        stdSetController.first();        
    }
    
    public void previous() {
        stdSetController.previous();        
    }
    
    public void next() {
        stdSetController.next();        
    }
    
    public void end() {
        stdSetController.last();        
    }
    
    public Boolean getDisableNext() { 
        if (stdSetController.getHasNext()) {
            return false; } else {
            return true;
        }
    }
    
    public Boolean getDisablePrevious() { 
        if (stdSetController.getHasPrevious()) {
            return false;
        } else {
            return true;
        }
    }
    
    public Integer getPageNumber() {
        return stdSetController.getPageNumber();
    }
    
    public Integer getTotalPages() {
        return (Integer) Math.ceil(Double.valueOf(stdSetController.getResultSize()) / stdSetController.getPageSize());
    }
    
    public Integer getDisplayRecordStart() {
        return ((stdSetController.getPageNumber() - 1) * stdSetController.getPageSize()) + 1;
    }
    
    public Integer getDisplayRecordEnd() {
        if ((stdSetController.getResultSize() - ((stdSetController.getPageNumber() - 1) * stdSetController.getPageSize())) < stdSetController.getPageSize()) {
            return stdSetController.getResultSize();
        } else {
            return stdSetController.getPageNumber() * stdSetController.getPageSize();
        }
    }
    
    public Integer getTotalRecords() {
        return stdSetController.getResultSize();
    }
    
    public class ReticleWrapper{
        public Reticle__c eachreticlewrapper{get;set;}
        public Boolean IsSelected {get;set;}   
        
        public ReticleWrapper(Reticle__c eachReticle,Boolean value) {
            eachreticlewrapper=eachreticle;
            IsSelected =value;
        }
    }
    
    /****************************************************
GE Form Search Methods        
****************************************************/
    public Pagereference Cancel(){    
        formsearchdate=null;
        pagereference BacktoReticleSearch=page.ROSVF_SearchReticlesGFForm;
        BacktoReticleSearch.setRedirect(true); 
        return BacktoReticleSearch;   }
    
    public Pagereference applyGEForm(){        
        for(Reticle__c eachreticle :selectedReticles){
            eachReticle.GE__c=SelectedFormId;
        }
        update selectedReticles;
        Reticlesearch();
        pagereference BacktoReticleSearch = page.ROSVF_SearchReticlesGFForm;
        BacktoReticleSearch.setRedirect(false);
        return BacktoReticleSearch;
    }
    
    public PageReference NavigatetoGEForm() {
        PageReference retVal = null;
        Set<String> sAccount = new Set<String>();
        Boolean isSelectionInvalid = false;
        Integer checkAckflag = 0;
        
        for(Reticlewrapper retwrapper : summaries) {
            if(retwrapper.isselected == true) {
                if(!sAccount.isEmpty() && !sAccount.contains(retwrapper.eachreticlewrapper.Account__c)) {
                    isSelectionInvalid = true;
                    break;
                }else if(sAccount.isEmpty()) {
                    sAccount.add(retwrapper.eachreticlewrapper.Account__c);
                }
                //DBiswal
                if(retwrapper.eachreticlewrapper.Special_Instructions__c != null && retwrapper.eachreticlewrapper.Acknowledge_Special_Instructions__c == false){
                    checkAckflag++;
                }
            }
        }
        
        if (sAccount != null) {
            if(sAccount.isEmpty()) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select atleast one Reticle.'));
                retVal = null;
            }else if(isSelectionInvalid) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'GE Form cannot be assigned to Reticles with Different Customers. Please select Reticles for one customer only.'));
                retVal = null;
            }else if(checkAckflag > 0){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please acknowledge the special Instructions provided to Reticles.'));
            }else if (sAccount.size() == 1) {
                GEFormRequest =  new ROS_GEFormModel();
                Allforms.clear();
                GEFormResults = false;
                retVal = Page.ROS_GEForm; retVal.setRedirect(false);}
        }
        return retVal;
    }
    
    // UPDATE EVIDENCE CERITIFICATE
    public PageReference updateEvidenceCertificate () {
        if (selectedReticles != null && !selectedReticles.isEmpty()) {
            for(Reticle__c eachreticle : selectedReticles){
                eachReticle.Evidence_Certificate__c = true;
            }
            Database.update(selectedReticles);
            reticleSearch();
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING, 'Please select atleast one Reticle to update.'));
        }
        return null;
    }
    
    public PageReference formSearch() {
        Allforms.clear();
        LWrapper=new List<FormWrapper>();
        LFormnumbers=new List<String>();
        
        ROS_RetreiveGEForm_1.GEReticleSyncService_pt request=new ROS_RetreiveGEForm_1.GEReticleSyncService_pt();
        
        request.timeout_x=120000;
        String OrgID=UserInfo.getOrganizationId();
        String RequestNo=formSearchTxt;
        String SearchDate=formSearchDate;
        if(!Test.isRunningTest()){resReticle=ROS_GE_FormProcess.GefornProcess(GEFormRequest);
        }
        if (resReticle==null){
            GEFormResults=false;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No Results Found'));
            return null;
        }
        if (resReticle!=null){GEFormResults=true; for(ROS_RetreiveGEForm_1.result_element eachresponse: resReticle){
                if(eachresponse.Status != 'Closed') {FormWrapper eachwrapper= new FormWrapper(eachresponse.RequestNo);
                    LWrapper.add(eachwrapper);AllForms.add(new selectOption(eachresponse.RequestNo,eachresponse.RequestNo));
                }
            }
            if(AllForms.isEmpty()) { GEFormResults=false;
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No Results Found'));
            }
        }return null;
    }
    
    public Class FormWrapper{
        public String formId{get;set;}public Boolean isSelected{get;set;} 
        
        public FormWrapper(String fid) {
            formId = fid;
            isSelected = false;
        }
    }
    
    public PageReference exportCsvFile() {
        exportDataCsv();
        System.PageReference retVal = new System.PageReference('/apex/ROS_Reticle_Export');
        return retVal ;
    }
    
    public PageReference exportCsvFileNotify() {
        exportDataCsvNotify();System.PageReference retVal = new System.PageReference('/apex/ROS_Reticle_Export');return retVal ;
    }
    
    public String NullCheck(object inputText){
        if(inputText != NULL){
            return string.valueOf(inputText).replaceAll('\n','').trim();
        }else{return '';
        }
    }
    
    public void exportDataCsv() {
        String userType = ROS_Util.UserType();
        List<String> lUserField = new List<String>();
        List<Reticle__c> lReticle;
        
        if(Test.isRunningTest()){
            string queryStr  = 'SELECT Account__r.Name,Name,Reticle_Type__c,';
            queryStr += ' Shipping_Address__r.Address1__c,Shipping_Address__r.Address2__c,Shipping_Address__r.Shipping_State__c,Shipping_Address__r.Shipping_Country__c,Shipping_Address__r.zip_code__c,';
            queryStr += ' Forwarder_Information__r.Forwarder_Name__c,Forwarder_Information__r.Account_No__c,Forwarder_Information__r.Contact_Name__c,Forwarder_Information__r.Contact_Phone_No__c,Forwarder_Name__c,Account_Number__c,Contact_Name__c,Contact_Phone_Number__c ';
            lReticle = Database.query( queryStr +' ,Csr_notified_date__c  FROM Reticle__c ' + whereClause +' ORDER BY Name ASC Limit 20');
            lUserField.add('Name');
            lUserField.add('Account__r.Name');
            lUserField.add('Reticle_Type__c');
            lUserField.add('Shipping_Address__r.Name');
            lUserField.add('Forwarder_Information__r.Name');
        }
        else if(UserType != NULL  && ROS_Query_UserType_Category__c.getInstance(UserType.replace('System Administrator','System Admin')+'_Export-'+category) != NULL){
            lUserField = ROS_Query_UserType_Category__c.getInstance(UserType.replace('System Administrator','System Admin') +'_Export-'+ category).Fields__c.split(',');
            string queryString='';            
            string fieldsToExport = ROS_Query_UserType_Category__c.getInstance(UserType.replace('System Administrator','System Admin') + '_Export-'+ category).Fields__c ;
            if(fieldsToExport != NULL && fieldsToExport.contains('Shipping_Address__r.Name')){
                fieldsToExport = fieldsToExport +  ', Shipping_Address__r.Address1__c,Shipping_Address__r.Address2__c,Shipping_Address__r.Shipping_State__c,Shipping_Address__r.Shipping_Country__c,Shipping_Address__r.zip_code__c ';
            }
            if(fieldsToExport != NULL && fieldsToExport.contains('Forwarder_Information__r.Name')){
                fieldsToExport = fieldsToExport +  ', Forwarder_Name__c,Account_Number__c,Contact_Name__c,Contact_Phone_Number__c ';
            }
            queryString = 'SELECT ' + fieldsToExport + ' ,Csr_notified_date__c  FROM Reticle__c ' + whereClause + ' ORDER BY Name ASC LIMIT 50000';
            
            if(userType != 'Customer'){
                lReticle = Database.query(queryString);
            }else{
                lReticle = ROS_ControllerSearchReticlePortalUsers.queryReticlesSystemMode(queryString);
            }
        }
        
        lDataString = new List<List<String>>();
        List<String> lRecordList = new List<String>();
        Boolean isColumnString = true;
        
        
        strExportHeader = '';
        String dataString = '';
        
        if (lReticle != null && !lReticle.isEmpty()) {if (lUserField != null && !lUserField.isEmpty()) { for (Reticle__c eachReticle :lReticle) {
                    Integer counter = 0; dataString = '';
                    for (String strField :lUserField){
                        if(strField.contains('Account__r')) {
                            if (counter == lUserField.size() - 1) {
                                dataString = dataString + '"' + eachReticle.Account__r.Name + '"'; } else {
                                dataString = dataString + '"' + eachReticle.Account__r.Name + '"' + ',';
                            }}else if(strField.contains('ROS_Cycle__r')){
                            if (counter == lUserField.size() - 1) {
                                dataString = dataString + '"' + NullCheck(eachReticle.ROS_Cycle__r.Name) + '"';
                            } else {
                                dataString = dataString + '"' + NullCheck(eachReticle.ROS_Cycle__r.Name) + '"' + ',';
                            }
                        }else if(strField.contains('Shipping_Address__r')){
                            dataString = dataString + '"' + eachReticle.Shipping_Address__r.Address1__c;
                            dataString = dataString + '\n' +eachReticle.Shipping_Address__r.Address2__c;
                            dataString = dataString + '\n' +eachReticle.Shipping_Address__r.Shipping_State__c;
                            dataString = dataString + '\n' +eachReticle.Shipping_Address__r.Shipping_Country__c;
                            if(counter == lUserField.size() - 1){
                                dataString = dataString + '\n' +eachReticle.Shipping_Address__r.zip_code__c + '"';
                            }else{
                                dataString = dataString + '\n' +eachReticle.Shipping_Address__r.zip_code__c + '"' + ',';
                            }
                        }else if(strField.contains('Forwarder_Information__r')){
                            dataString = dataString + '"' + eachReticle.Forwarder_Name__c;
                            dataString = dataString + '\n' +eachReticle.Account_Number__c;
                            dataString = dataString + '\n' +eachReticle.Contact_Name__c;
                            if(counter == lUserField.size() - 1){
                                dataString = dataString + '\n' +eachReticle.Contact_Phone_Number__c+ '"';  }else{
                                dataString = dataString + '\n' +eachReticle.Contact_Phone_Number__c+ '"' + ',';
                            }
                        }
                        else { if (counter == lUserField.size() - 1) {dataString = dataString + '"' + NullCheck(eachReticle.get(strField)) + '"';
                            } else { dataString = dataString + '"' + NullCheck(eachReticle.get(strField)) + '"' + ',';
                            }
                        }
                        
                        if(isColumnString){
                            if (counter == lUserField.size() - 1){                        
                                if(ROS_Column_Definition__c.getInstance(''+strField+'') != NULL){
                                    strExportHeader = strExportHeader + ROS_Column_Definition__c.getInstance(''+strField+'').Label__c;
                                }else{
                                    strExportHeader = strExportHeader + 'Test Label';
                                }
                            }else{
                                if(ROS_Column_Definition__c.getInstance(''+strField+'') != NULL){
                                    strExportHeader = strExportHeader + ROS_Column_Definition__c.getInstance(''+strField+'').Label__c+',';
                                }else{
                                    strExportHeader = strExportHeader + 'Test Label' +',';
                                }
                            }
                        }counter++;
                    }
                    isColumnString = false;                    
                    //Prashant- Changed Logic to resolve collection size limit case # 00050318
                    lRecordList.add(dataString); if(lRecordList.size() == 1000)
                    {
                        lDataString.add(lRecordList);
                        lRecordList = new List<String>();
                    }
                    
                }
                lDataString.add(lRecordList);
            }               
        }else{
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'No Data For Export, Please search before Exporting Data.'));
        }
    }
    
    public void exportDataCsvNotify() {
        String userType = ROS_Util.UserType(); List<String> lUserField = new List<String>();
        List<Reticle__c> lReticle;
        if(Test.isRunningTest()){
            string queryStr  = 'SELECT Account__r.Name,Name,Reticle_Type__c,';
            queryStr += ' Shipping_Address__r.Address1__c,Shipping_Address__r.Address2__c,Shipping_Address__r.Shipping_State__c,Shipping_Address__r.Shipping_Country__c,Shipping_Address__r.zip_code__c,';
            queryStr += ' Forwarder_Information__r.Forwarder_Name__c,Forwarder_Information__r.Account_No__c,Forwarder_Information__r.Contact_Name__c,Forwarder_Information__r.Contact_Phone_No__c,Forwarder_Name__c,Account_Number__c,Contact_Name__c,Contact_Phone_Number__c ';
            lReticle = Database.query( queryStr +' ,Csr_notified_date__c  FROM Reticle__c ORDER BY Name ASC Limit 20');
            lUserField.add('Name');
            lUserField.add('Account__r.Name');
            lUserField.add('Reticle_Type__c');
            lUserField.add('Shipping_Address__r.Name');lUserField.add('Forwarder_Information__r.Name'); }
        else if(UserType != NULL && ROS_Query_UserType_Category__c.getInstance(UserType.replace('System Administrator','System Admin')+'_Export-'+category)!= NULL){
            lUserField = ROS_Query_UserType_Category__c.getInstance(UserType.replace('System Administrator','System Admin') +'_Export-'+ category).Fields__c.split(',');
            string queryString='';         
            string fieldsToExport = ROS_Query_UserType_Category__c.getInstance(UserType.replace('System Administrator','System Admin') + '_Export-'+ category).Fields__c ;
            if(fieldsToExport != NULL && fieldsToExport.contains('Shipping_Address__r.Name')){
                fieldsToExport = fieldsToExport +  ', Shipping_Address__r.Address1__c,Shipping_Address__r.Address2__c,Shipping_Address__r.Shipping_State__c,Shipping_Address__r.Shipping_Country__c,Shipping_Address__r.zip_code__c ';
            }
            if(fieldsToExport != NULL && fieldsToExport.contains('Forwarder_Information__r.Name')){
                fieldsToExport = fieldsToExport +  ', Forwarder_Name__c,Account_Number__c,Contact_Name__c,Contact_Phone_Number__c ';
            }
            queryString = 'SELECT ' + fieldsToExport + ' ,Csr_notified_date__c  FROM Reticle__c WHERE id in :selReticles ORDER BY Name ASC LIMIT 50000';
            
            if(userType != 'Customer'){
                lReticle = Database.query(queryString);
            }
            else{
                lReticle = ROS_ControllerSearchReticlePortalUsers.queryReticlesSystemMode(queryString);
            }
        }
        
        lDataString = new List<List<String>>();
        List<String> lRecordList = new List<String>();
        Boolean isColumnString = true;
        
        strExportHeader = '';
        String dataString = '';
        
        if (lReticle != null && !lReticle.isEmpty()) {
            if (lUserField != null && !lUserField.isEmpty()) {
                for (Reticle__c eachReticle :lReticle) {
                    Integer counter = 0;
                    dataString = '';
                    for (String strField :lUserField) {
                        if(strField.contains('Account__r')){
                            if(counter == lUserField.size() - 1) {
                                dataString = dataString + '"' + eachReticle.Account__r.Name + '"';
                            } else {
                                dataString = dataString + '"' + eachReticle.Account__r.Name + '"' + ',';
                            }
                        }else if(strField.contains('ROS_Cycle__r')) {
                            if (counter == lUserField.size() - 1) {
                                dataString = dataString + '"' + NullCheck(eachReticle.ROS_Cycle__r.Name) + '"';
                            } else {
                                dataString = dataString + '"' + NullCheck(eachReticle.ROS_Cycle__r.Name) + '"' + ',';
                            }
                        }else if (strField.contains('Shipping_Address__r')) {
                            dataString = dataString + '"' + eachReticle.Shipping_Address__r.Address1__c;
                            dataString = dataString + '\n' +eachReticle.Shipping_Address__r.Address2__c;
                            dataString = dataString + '\n' +eachReticle.Shipping_Address__r.Shipping_State__c;
                            dataString = dataString + '\n' +eachReticle.Shipping_Address__r.Shipping_Country__c;
                            if (counter == lUserField.size() - 1) {
                                dataString = dataString + '\n' +eachReticle.Shipping_Address__r.zip_code__c + '"';
                            }else{
                                dataString = dataString + '\n' +eachReticle.Shipping_Address__r.zip_code__c + '"' + ',';
                            }
                        }else if (strField.contains('Forwarder_Information__r')) {
                            dataString = dataString + '"' + eachReticle.Forwarder_Name__c;
                            dataString = dataString + '\n' +eachReticle.Account_Number__c;
                            dataString = dataString + '\n' +eachReticle.Contact_Name__c;
                            if (counter == lUserField.size() - 1){
                                dataString = dataString + '\n' +eachReticle.Contact_Phone_Number__c+ '"';
                            }else{
                                dataString = dataString + '\n' +eachReticle.Contact_Phone_Number__c+ '"' + ',';
                            }
                        }
                        else {
                            if (counter == lUserField.size() - 1) {
                                dataString = dataString + '"' + NullCheck(eachReticle.get(strField)) + '"';
                            } else {
                                dataString = dataString + '"' + NullCheck(eachReticle.get(strField)) + '"' + ',';
                            }
                        }
                        
                        if(isColumnString){
                            if (counter == lUserField.size() - 1){
                                if(ROS_Column_Definition__c.getInstance(''+strField+'') != NULL){
                                    strExportHeader = strExportHeader + ROS_Column_Definition__c.getInstance(''+strField+'').Label__c;
                                }else{
                                    strExportHeader = strExportHeader + 'Test Label';
                                }
                            }else{
                                if(ROS_Column_Definition__c.getInstance(''+strField+'') != NULL){
                                    strExportHeader = strExportHeader + ROS_Column_Definition__c.getInstance(''+strField+'').Label__c+',';
                                }else{
                                    strExportHeader = strExportHeader + 'Test Label' + ',';
                                }
                            }
                        }
                        counter++;
                    }
                    isColumnString = false;
                    //Prashant- Changed Logic to resolve collection size limit case # 00050318
                    lRecordList.add(dataString);
                    if(lRecordList.size() == 1000)
                    {
                        lDataString.add(lRecordList);
                        lRecordList = new List<String>();
                    }
                    
                }
                lDataString.add(lRecordList);
                
            }               
        } else {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'No Data For Export, Please search before Exporting Data.'));
        }
    }
    
    public PageReference createDispositionCertificate() {
        PageReference retVal = null;
        Set<String> sAccount = new Set<String>();
        String accountId;
        Boolean isSelectionInvalid = false;
        
        //DBiswal 07092015
        Integer counter = 0;
        
        for(Reticlewrapper retwrapper : summaries) {
            if(retwrapper.isselected == true) {
                if(!sAccount.isEmpty() && !sAccount.contains(retwrapper.eachreticlewrapper.Account__c)) {
                    isSelectionInvalid = true;
                    break;
                }else if(sAccount.isEmpty()) {
                    sAccount.add(retwrapper.eachreticlewrapper.Account__c);
                    accountId = retwrapper.eachreticlewrapper.Account__c;
                }
                if(retwrapper.eachreticlewrapper.Reticle_workflow_Status__c == 'Pending for Fab\'s Follow-up' 
                   && retwrapper.eachreticlewrapper.ROS_Status__c == 'Scrap'
                   && (!accwitSet.isEmpty() && accwitSet.contains(retwrapper.eachreticlewrapper.Account__r.Short_Name__c))){
                       if(Date.today() < retwrapper.eachreticlewrapper.Witness_Arrival_Date__c){counter++;
                       }
                   }
            }
        }
        
        if (sAccount != null) {
            if(sAccount.isEmpty()) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select atleast one Reticle.'));
                retVal = null;
            }else if(counter > 0){ ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You can not generate Disposal Certificate before Witness Arrival Date'));
                retVal = null;
            }else if(isSelectionInvalid) { ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Disposition Certificate cannot be created for Reticles with Different Customers. Please select Reticles for one customer only.'));
                retVal = null;
            }else if (sAccount.size() == 1) {
                retVal = new PageReference('/apex/ROSVF_scrapCretificate?AccountId=' + accountId);
            }
        }
        return retVal;
    }
    
    
    // DISPOSITION CERTIFICATE RELATED CODE
    public ROS_Disposal_Certificate__c disposalCertificate=new ROS_Disposal_Certificate__c();
    public Id Scrappedaccount;
    
    public PageReference GenerateDisposalCertificate(){
        Database.SaveResult result;
        set<id> accountId = new set<id>() ;
        if(selectedreticles.size() <= 0){ ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Select Atleast One Reticle to generate Disposal Certificate'));
        }else{
            Savepoint sp = Database.setSavepoint();
            try{
                insert disposalCertificate;
                List<reticle__c> RS = new List<reticle__c>();
                string rosCycle='';
                string customerDeviceId='';
                string reticleId='';
                for(reticle__c obj : selectedreticles){
                    obj.Disposal_Certificate__c = disposalCertificate.Id;
                    obj.Reticle_workflow_Status__c = 'Closed';
                    obj.Scrapped_Certificate_Generated__c = true;
                    rosCycle=obj.ROS_Cycle__r.name;
                    customerDeviceId+=formatter(obj.Device_ID__c)+',';
                    reticleId+=formatter(obj.name)+',';
                    accountId.add(obj.Account__c);
                }
                
                Database.SaveResult[] resultreS = Database.update(selectedreticles,false);
                CertificateCreated=true;list<string>emailList= new list<string>();
                system.debug('???<<>>accountId' +accountId);
                for(Account_Team_Proxy__c atp :[Select id , Team_Role__c,User_Email__c from Account_Team_Proxy__c
                                                where Account__c =:accountId and User__r.isActive=true]){
                                                    if(atp.Team_Role__c=='Primary Customer Service Rep' || atp.Team_Role__c== 'Backup Customer Service Rep' ) {
                                                        emailList.add(atp.User_Email__c);
                                                    }              
                                                }
                system.debug('???<<>>emailList' +emailList);
                if(emailList.isEmpty()){emailList.add(label.Scrap_certificate_notification);
                }   ROS_Disposal_Certificate__c dp=[Select id,name,Account__r.name,createdDate from ROS_Disposal_Certificate__c where id =:disposalCertificate.Id];                             
                system.debug('???<<>>emailList' +emailList);
                Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                mail.setToAddresses(emailList);
                mail.setSubject('Notification-Reticle Scrap Certificate :'+ dp.name+ ' '+'for'+ ' '+dp.Account__r.name+ ' '+'is available');
                String hbody = '<html><body>Dear CSRs,<br><br>';
                hbody += 'This is to inform you that scrap certificate has been uploaded in SFDC : <br><br>';
                hbody +='Customer:' + ' '+dp.Account__r.name +'<br><br>';
                hbody +='ROS cycle:' + ' '+rosCycle+'<br><br>';
                hbody +='Customer Device ID: ' + ' '+customerDeviceId.removeEnd(',')+'<br><br>';  
                hbody +='Scrap Certificate create date:' + ' '+dp.createdDate+'<br><br>'; 
                hbody +='Reticle Id :' + ' '+reticleId.removeEnd(',')+'<br><br>';
                hbody +='Access the following URL to see scrap certificate attachment :<br><br>';
                hbody +=URL.getSalesforceBaseUrl().toExternalForm()+'/'+dp.id;
                hbody +='</html></body>';
                mail.setHtmlBody(hbody);
                Messaging.SingleEmailMessage[] messages =  new List<Messaging.SingleEmailMessage> {mail};Messaging.sendEmail(messages);
                
            }catch(exception ex){
                //Database.rollback(sp);
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            }                
        }
        return null;
    }
    
    public string formatter(string s){
        if(s!=null)return s;
        else return '';
    }
    
    // Need to remove this Code
    public pagereference createFile(){
        String filename=disposalCertificate.Scrap_Date__c+'_Scrap_Certificate.pdf';     
        Savepoint sp = Database.setSavepoint();
        try{              
            PageReference P=page.rosvf_scrappdf; 
            P.getparameters().put('resultId',disposalCertificate.Id);       
            blob body ;
            if(!Test.isRunningTest()){
                body = P.getContent();
            }else{
                body = blob.valueOf('test');
            }
            attachment pdf = new attachment();
            pdf.body=body;
            pdf.Name=filename;
            pdf.ParentId =disposalCertificate.Id;
            pdf.isPrivate = false;
            Database.SaveResult resultreS = Database.insert(pdf,false);
            
            if(resultreS.isSuccess()){
                disposalCertificate.PDF_Generated__c =  true;
                disposalCertificate.OwnerId = [Select id from Group where Name =: 'WWMS ROS Team' limit 1].Id;
                update disposalCertificate;
                
                
            }
        }catch(exception ex){
            Database.rollback(sp);
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
        }      
        return new Pagereference('/'+disposalCertificate.Id);
    }
    
    public ROS_Disposal_Certificate__c getDisposalCertificate(){
        List<Reticle__c> SelRet=getSelectedReticles();        
        disposalCertificate.account__c =SelRet[0].Account__c;
        return this.disposalCertificate ;
    }
    
    // NOTIFY CUSTOMER
    public boolean displayPopup{get; set;} 
    public boolean displayNotifyByEmail{get; set;}    
    public string selectedOptionNotify{get;set;}
    public string emailBody{get;set;}
    public string emailSubject{get;set;}
    public string toAddress{get;set;}
    public string ccAddress{get;set;}
    public string bccAddress{get;set;}
    
    EmailTemplate et;
    Set<String> setUniqueReticle ;
    List<String> selReticles;
    
    public List<SelectOption> getItemsforNotify() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('With_Reticle','With Reticle'));
        options.add(new SelectOption('Without_Reticle','Without Reticle')); 
        return options;
    }
    
    public void closePopup() {        
        displayPopup = false; 
        displayNotifyByEmail = false;
        selectedOptionNotify = 'With_Reticle';
    }
    
    public void showPopup(){
        setUniqueReticle = new Set<String>();
        selReticles.clear();
        boolean cycleError = false;
        for(Reticlewrapper retwrapper : summaries){
            if(retwrapper.isselected == true){
                if(retwrapper.eachreticlewrapper.ROS_Cycle__r.name == NULL || retwrapper.eachreticlewrapper.ROS_Cycle__r.name == '' ||retwrapper.eachreticlewrapper.ROS_Cycle__r.name == CurrentCycle)
                {
                    setUniqueReticle.add(retwrapper.eachreticlewrapper.Account__c);
                    selReticles.add(retwrapper.eachreticlewrapper.id);
                    emailSubject = retwrapper.eachreticlewrapper.ROS_Cycle__r.name;
                    if(setUniqueReticle.size() > 1) {
                        break;
                    }
                }else{
                    cycleError = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Customer Notification cannot be done for reticles that belongs to Inactive cycle. Please make a cycle selection that is correctly Active.'));
                    break;
                }
            }
        }
        if(setUniqueReticle.size() == 1 && cycleError == false) {
            displayPopup = true;
        }
        else if(setUniqueReticle.size() < 1 && cycleError == false){
            displayPopup = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'No Reticles selected'));
        }
        else if(setUniqueReticle.size() > 1 && cycleError == false){
            displayPopup = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select Reticles corresponding to only one Account.'));
        }
    }
    
    public void displayNotifyWindow(){
        displayPopup = false;
        displayNotifyByEmail = true;
        et = [select id,body,subject from EmailTemplate where DeveloperName='ROS_NotifyCustomer'];
        emailBody    = et.body;        
        emailSubject = et.subject.replace('{!Reticle__c.ROS_Cycle__c}',emailSubject);
    }
    
    public void updateReticleStatus(){
        List<Reticle__c> LSelectedReticles=new List<Reticle__c>();
        for(Reticlewrapper retwrapper : summaries){
            if(retwrapper.isselected == true) {
                retwrapper.eachreticlewrapper.Reticle_Workflow_Status__c='Pending for Customer Feedback';
                LSelectedReticles.add(retwrapper.eachreticlewrapper);
            }
        }
        if(!LSelectedReticles.isEmpty()) {
            try {
                update LSelectedReticles;
                hasNotifyUpdateError = false;}catch(Exception ex) { hasNotifyUpdateError = true;ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, System.Label.ROS_ErrorMessage));
            }
        }
    }
    
    public PageReference notifyCustomer(){
        displayPopup = false;
        displayNotifyByEmail = false;
        
        List<Reticle__c> LSelectedReticles=new List<Reticle__c>();
        for(Reticlewrapper retwrapper : summaries){
            if(retwrapper.isselected == true)
            {
                LSelectedReticles.add(retwrapper.eachreticlewrapper);
            }            
        }
        
        if(!LSelectedReticles.isEmpty()){
            Messaging.reserveSingleEmailCapacity(1);
            Messaging.SingleEmailMessage m = new Messaging.SingleEmailMessage();
            
            m.setToAddresses(toAddress.split(';'));
            
            List<String> lstCCaddresses = new List<String>();
            lstCCaddresses.add(System.Label.ROS_DefaultEmailAddress);
            if(ccAddress.trim() != ''){                
                lstCCaddresses.addAll(ccAddress.split(';'));                
            }
            m.setCcAddresses(lstCCaddresses);
            
            if(bccAddress.trim() != ''){
                m.setBccAddresses(bccAddress.split(';'));
            }
            m.setSubject(emailSubject);
            m.setPlainTextBody(emailBody);
            
            if(selectedOptionNotify == 'With_Reticle'){
                exportDataCsvNotify();                
                string textForCSV= strExportHeader+'\n';
                for(List<String> lstData:lDataString){
                    for(String data:lstData){
                        textForCSV = textForCSV+data;
                        textForCSV = textForCSV+'\n';
                    }
                }
                Blob b = Blob.valueOf(textForCSV);
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('Export.csv');
                efa.setBody(b);                
                m.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            }
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { m });
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, ROS_Error_Messages__c.getInstance('Notify customer').Value__c));
            reticleSearch();
        }
        return null;
    }
    
    //CLEAR SEARCH
    public PageReference clearSearch() {
        summaries=new List<ReticleWrapper>();
        category = 'none';
        dispositionType = 'nullVal';
        ReticleId = '';
        Fab = 'noFab';
        DeviceId = '';
        cycle = '';
        AccountName = '';
        Location = '';
        geFormId = '';
        summaries.clear();
        checkbox = false;
        return null;
    }
    
    //Tlai 16042014 STF
    public PageReference RedirectSTF(){
        SelReturnReticles.clear();
        
        //Nikhil-- 5/19/2014 --changes to avoid duplicate reticles
        Set<String> uniqueSelReticles = new Set<String>();
        
        hscode = null;
        Item = null;
        for(Device__c devId : RetcileListDevice.keySet()){
            if(RetcileListDevice.get(devId).isSelected){
                for(Reticle__c rt : RetcileListDevice.get(devId).deviveRetcileList){
                    if(!uniqueSelReticles.contains(rt.Id)){
                        SelReturnReticles.add(new SelectedReticleWrapper(rt, true)); 
                        uniqueSelReticles.add(rt.Id);
                    }
                }
            }
        }
        
        if(SelReturnReticles.size() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select at least one Device.'));
            return null;
        }PageReference  pf = Page.ROSVF_STFObsolescence; pf.setRedirect(false);AllSelected = true;return pf;
    }  
    
    //DBiswal 06182015
    public PageReference updatePIYEstep(){
        SelReturnReticles.clear();
        Set<Id> setSelReticles = new Set<Id>();
        List<Reticle__c> listRettoUpdate = new List<Reticle__c>();
        try{    
            /*
for(Device__c devId : RetcileListDevice.keySet()){
if(RetcileListDevice.get(devId).isSelected){
for(Reticle__c rt : RetcileListDevice.get(devId).deviveRetcileList){
if(!setSelReticles.contains(rt.Id)){
SelReturnReticles.add(new SelectedReticleWrapper(rt, true)); 
setSelReticles.add(rt.Id);
}
}
}
}*/
            system.debug('<<:>>SelectedRetwrapper' +summaries);
            for(Reticlewrapper rets: summaries){
                system.debug('<<:>>SelectedRetwrapper' +rets);
                if(rets.IsSelected){
                    setSelReticles.add(rets.eachreticlewrapper.id);
                }
            }
            system.debug('<<:>>SelectedRetwrapper' +setSelReticles);
            //SelReturnReticles changed to setSelReticles by ravikiran 
            if(setSelReticles.size() == 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ROS_Error_Messages__c.getInstance('Obselence_Error').Value__c));
                return null;
            } else{
                if(!setSelReticles.isEmpty()){
                    for(Reticle__c ret : [SELECT Id, Reticle_workflow_Status__c, ROS_Status__c, ROS_Cycle__r.name, STF_Obsolence__c, HS_Code__c, Item__c 
                                          ,Csr_notified_date__c  FROM Reticle__c WHERE Id IN : setSelReticles]){
                                              if((ret.ROS_Cycle__r.name == NULL || ret.ROS_Cycle__r.name == '' || ret.ROS_Cycle__r.name == CurrentCycle)){
                                                  if(ret.Reticle_workflow_Status__c == 'Pending for STF Obsolescence'){
                                                      if(ret.ROS_Status__c == 'Return'){
                                                          ret.Reticle_workflow_Status__c = 'Pending HS Code Assignment';
                                                      }else{
                                                          ret.Reticle_workflow_Status__c = 'Pending for Fab\'s Follow-up';
                                                      }
                                                      
                                                      ret.STF_Obsolence__c = true;                            
                                                      listRettoUpdate.add(ret);
                                                  } else if(ret.Reticle_workflow_Status__c == 'Pending for EUC Form,Pending for STF Obsolescence'){
                                                      ret.Reticle_workflow_Status__c = 'Pending for EUC Form';
                                                      ret.STF_Obsolence__c = true;
                                                      listRettoUpdate.add(ret);
                                                  }
                                              } else{
                                                  ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Obsolescence cannot be done for reticles that belongs to Inactive cycle. Please make a cycle selection that is correctly Active.'));
                                                  return null;
                                              }
                                          }
                }      
                if(listRettoUpdate != null && listRettoUpdate.size()>0){
                    system.debug('<<:>>listRettoUpdate' +listRettoUpdate);
                    Database.update(listRettoUpdate);
                    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM,'Request for Reticles Obsolescence submitted successfully'));
                    reticleSearch();                   
                }
            }
            return null;
        } catch(Exception e){
            system.debug('<<:>>insideException' +e.getMessage());
            return null;
        }
    }
    
    //DBiswal 07082015
    public PageReference submitWitArrivDate(){
        List<Reticle__c> listRet = new List<Reticle__c>();
        
        if(WitArrivDate != null){
            if(WitArrivDate > Date.today()){
                if(!stdSetController.getRecords().isEmpty()){
                    for(Reticle__c retcheck : ((List<Reticle__c>)stdSetController.getRecords())){
                        if(retcheck.Reticle_workflow_Status__c == 'Pending Witness Arrival Date'){
                            if(retcheck.ROS_Cycle__r.name == NULL ||
                               retcheck.ROS_Cycle__r.name == '' || 
                               retcheck.ROS_Cycle__r.name == CurrentCycle)
                            {
                                retcheck.Witness_Arrival_Date__c = WitArrivDate;
                                retcheck.Reticle_workflow_Status__c = 'Pending for STF Obsolescence';
                                listRet.add(retcheck);
                            }else{
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please make a cycle selection that is Active.'));
                                return null;
                            }
                        }
                    }
                }
                //for witness arrival date change of existing records
                else {
                    List<Reticle__c> lretBRCM = [SELECT Id,Account__r.Name,Account__r.Short_Name__c,ROS_Status__c,Reticle_workflow_Status__c,ROS_Cycle__c,STF_Obsolence__c,Witness_Arrival_Date__c ,Csr_notified_date__c  FROM Reticle__c
                                                 WHERE ROS_Status__c = 'Scrap' AND ROS_Cycle__r.Name =: CurrentCycle AND Account__r.Short_Name__c IN: accwitSet];
                    
                    for(Reticle__c ret : lretBRCM){
                        if(ret.Reticle_workflow_Status__c == 'Pending for STF Obsolescence' || ret.STF_Obsolence__c == false){
                            ret.Witness_Arrival_Date__c = WitArrivDate;
                            ret.Reticle_workflow_Status__c = 'Pending for STF Obsolescence';
                            listRet.add(ret);
                        }
                    }
                }
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select a future date.'));
                return null;
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please provide a date.'));
            return null;
        }
        
        if(!listRet.isEmpty()){
            Database.update(listRet);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Witness Arrival Date is assigned for Reticles'));
            Reticlesearch();
            showWitdate = false;
            return null;
        }else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'No Reticles are available to scrap.'));
            return null;
        }
    }
    
    public PageReference updateDebitReference() {
        IsDebitNoteSaved=false;
        PageReference  retVal = new PageReference('/apex/ROSVF_debitnote');
        return retVal;
    }
    public List<Reticle__c> resdebitNote = new List<Reticle__c>();
    
    public PageReference loadreticleForDebitNote(){
        Set<id> reticleId = new Set<Id>();
        for(Reticlewrapper retwrapper : summaries){
            if(retwrapper.isselected == true) {         
                reticleId.add(retwrapper.eachreticlewrapper.id);
            } 
            
        }
		if(!reticleId.IsEmpty()){
                this.resdebitNote  = [
                    Select id,Name,Debit_Note_Number__c from 
                    Reticle__c where Id in : reticleId 
                    and Debit_Note_Waive_Off__c 
                    <> true 
                ];        
            }
        return null;
    }
    
    Set<Id> selectedId =  new Set<Id>();
    public PageReference StfFill(){
        for(SelectedReticleWrapper  eachreticlewrapper : SelReturnReticles){
            if(eachreticlewrapper.IsChecked){
                eachreticlewrapper.eachSelectedreticlewrapper.HS_Code__c = HSCode;
                eachreticlewrapper.eachSelectedreticlewrapper.Item__c = Item;
            }
        }
        return null;
    }
    
    public List<Reticle__c> getupdateDebitReticle() {
        return this.resdebitNote;
    }
    
    public boolean IsDebitNoteSaved{get;set;}
    
    public PageReference saveDebitNote(){
        try{
            update resdebitNote;
            IsDebitNoteSaved=true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, ROS_Error_Messages__c.getInstance('Debit note Number').Value__c));
        }
        catch(Exception ex){
            ROS_Util.insertException(ex, 'ROS_ControllerSearchReticleGFForm','ROS');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Debit Note Number Assignment Failed,Please try again.'));
            return null;
        }
        return null;
    }
    
    //DEBIT NOTE WAIVE OFF
    public PageReference debitNoteWaiveOff(){
        system.debug('???+wReasonFlag' +wReasonFlag);
        wReasonFlag =true;
        //Map<id,Reticle__c>LSelectedReticles = new Map<id,Reticle__c>();
        
        try{
            for(Reticlewrapper retwrapper : summaries){
                if(retwrapper.isselected == true) {
                    //retwrapper.eachreticlewrapper.Debit_Note_Waive_Off__c = true;
                    retIdSet.add(retwrapper.eachreticlewrapper.id);
                    // LSelectedReticles.put(retwrapper.eachreticlewrapper.id,retwrapper.eachreticlewrapper);
                }
            }
            system.debug('???+retIdSet' +retIdSet);    
            PageReference  pf = Page.ROSVF_CusFeedbackAttachment;
            pf.setRedirect(false);//forward on server side
            return pf;       
            /* Database.update(LSelectedReticles.values);
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, ROS_Error_Messages__c.getInstance('Request Waive Off').Value__c));
reticleSearch();*/
        }catch(Exception e) {
            ROS_Util.InsertException(e,'ROS_SearchReticlesGFForm.UpdateBulkReticles','ROS');
        }
        return null;
    }
    
    //TLai 14042014 
    public PageReference redirectScrap(){
        SelReturnReticles.clear();
        integer recNo = 0;
        for(Reticlewrapper retwrapper : summaries){
            if(retwrapper.isselected == true){
                if(retwrapper.eachreticlewrapper.ROS_Cycle__r.name == NULL ||
                   retwrapper.eachreticlewrapper.ROS_Cycle__r.name == '' ||
                   retwrapper.eachreticlewrapper.ROS_Cycle__r.name == CurrentCycle)
                {
                    SelReturnReticles.add(new SelectedReticleWrapper(retwrapper.eachreticlewrapper, true));
                    recNo++;
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Disposition cannot be done for reticles that belongs to Inactive cycle. Please make a cycle selection that is correctly Active.'));
                    return null;
                }
            }
        }
        
        if(recNo > 0){
            PageReference  pf = Page.ROSVF_SCRAP;
            pf.setRedirect(false);//forward on server side
            Allselected = true;
            return pf;
        }else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select atleast one Reticle to scrap.'));
            return null;
        }
        
    } 
    
    //Tlai 14042014
    public PageReference performScrap() {
        List<Reticle__c> listSelectedReticle = new List<Reticle__c>();
        boolean isScrapSuccess = false;
        
        for(SelectedReticleWrapper selRetWrp : SelReturnReticles){
            if(selRetWrp.isChecked == true) {
                selRetWrp.eachSelectedreticlewrapper.ROS_Status__c= 'Scrap';
                //DBiswal 07082015
                if(!accwitSet.isEmpty() && accwitSet.contains(selRetWrp.eachSelectedreticlewrapper.Account__r.Short_Name__c) && WitArrivDate != null){
                    selRetWrp.eachSelectedreticlewrapper.Reticle_workflow_Status__c = 'Pending for STF Obsolescence';
                    selRetWrp.eachSelectedreticlewrapper.Witness_Arrival_Date__c = WitArrivDate;
                } else if(!accwitSet.isEmpty() && accwitSet.contains(selRetWrp.eachSelectedreticlewrapper.Account__r.Short_Name__c) && WitArrivDate == null){
                    selRetWrp.eachSelectedreticlewrapper.Reticle_workflow_Status__c = 'Pending Witness Arrival Date';
                }
                listSelectedReticle.add(selRetWrp.eachSelectedreticlewrapper);
            }
        }
        if(!listSelectedReticle.isEmpty()){
            isScrapSuccess = ROS_ControllerSearchReticlePortalUsers.returnDispositionType(listSelectedReticle); }else{ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select atleast one Reticle for disposition.'));
            return null;
        }
        
        if(isScrapSuccess){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Request for Reticles Disposition submitted successfully'));
            Reticlesearch(); }else{ ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Some error occurred. Please contact system administrator.'));
            return null;
        }        
        Pagereference pf =page.ROSVF_SearchReticlesGFForm;
        pf.setRedirect(false);
        return pf;
    }
    
    public PageReference assign(){
        //DBiswal 06222015
        integer selectedRet = 0;
        for(Reticlewrapper retwrap : summaries){
            if(retwrap.isselected == true && retwrap.eachreticlewrapper.ROS_Status__c=='Return'){
                retwrap.eachreticlewrapper.HS_Code__c = hscode;
                retwrap.eachreticlewrapper.Item__c= Item;
                selectedRet++;
            }
        }
        if(selectedRet == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select atleast one Reticle for Assigning HS Code and Item #'));
            return null;
        } else{
            showhsSection = true;
            return null;
        }
    }
    
    // STF OBSELESCENCE Tlai 16042014
    public PageReference performSTFObsolescence() { 
        //DBiswal 06222015  
        List<Reticle__c> listtoUpdate = new List<Reticle__c>();
        integer recNo = 0;
        try{
            for(Reticlewrapper retwrap : summaries){
                if(retwrap.isSelected){
                    if((retwrap.eachreticlewrapper.ROS_Cycle__r.name == NULL || retwrap.eachreticlewrapper.ROS_Cycle__r.name == '' || retwrap.eachreticlewrapper.ROS_Cycle__r.name == CurrentCycle)){
                            if(retwrap.eachreticlewrapper.STF_Obsolence__c == true && retwrap.eachreticlewrapper.Reticle_workflow_Status__c == 'Pending for STF Obsolescence'){
                                if(retwrap.eachreticlewrapper.ROS_Status__c=='Return'){
                                    retwrap.eachreticlewrapper.Reticle_workflow_Status__c = 'Pending HS Code Assignment';
                                }else{retwrap.eachreticlewrapper.Reticle_workflow_Status__c = 'Pending for Fab\'s Follow-up';
                                }
                                
                            }else if(retwrap.eachreticlewrapper.Reticle_workflow_Status__c == 'Pending HS Code Assignment'){retwrap.eachreticlewrapper.Reticle_workflow_Status__c = 'Pending for Fab\'s Follow-up';
                            }
                            
                            if((retwrap.eachreticlewrapper.HS_Code__c==null || retwrap.eachreticlewrapper.Item__c==null)&& retwrap.eachreticlewrapper.ROS_Status__c=='Return'){ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please input HS Code and Item Number for each \'Return\' Reticle'));
                                return null;    
                            }
                            listtoUpdate.add(retwrap.eachreticlewrapper);
                        }else{ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Disposition cannot be done for reticles that belongs to Inactive cycle. Please make a cycle selection that is correctly Active.'));
                            return null;
                        }
                }           
            }
            if(!listtoUpdate.isEmpty()){
                Database.update(listtoUpdate,false);
            }else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select atleast one Reticle for Updating HS Code and Item #'));
                return null;}}catch(Exception e){return null;
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Request for updating HS Code and Item # for Reticles successful'));
        reticleSearch();
        return null;    
    }
    
    /**
* This method moves inactive reticles to active reticles
*
* @author  Vijay Mahajan
* @company CTS
* @date    19/05/2014 
*/
    public PageReference moveToActiveReticles(){
        List<Reticle__c> selectedReticleList = new List<Reticle__c>();
        for(Reticlewrapper retwrapper : summaries){
            if(retwrapper.isSelected) {
                retwrapper.eachreticlewrapper.Reticle_workflow_Status__c = null;
                retwrapper.eachreticlewrapper.ROS_Cycle__c = null;
                retwrapper.eachreticlewrapper.ROS_Status__c = null;
                retwrapper.eachreticlewrapper.Day_Inactive__c = retwrapper.eachreticlewrapper.New_Inactive_Days_Formula__c;
                retwrapper.eachreticlewrapper.New_Inactive_Days__c = null;
                retwrapper.eachreticlewrapper.Date_Inactive_to_Active_Insertion__c = null;
                selectedReticleList.add(retwrapper.eachreticlewrapper);
            }                
        }
        try{
            if(!selectedReticleList.isEmpty()){
                update selectedReticleList;
                List<Reticle_Device__c> reticleDeviceList = [SELECT Id, Name, Is_Temporary__c 
                                                             FROM   Reticle_Device__c 
                                                             WHERE  Reticle__c =:selectedReticleList AND Is_Temporary__c = true];
                if(reticleDeviceList != null && !reticleDeviceList.isEmpty()){
                    for(Reticle_Device__c reticleDevice:reticleDeviceList){
                        reticleDevice.Is_Temporary__c = false;
                    }
                    
                    update reticleDeviceList;
                }
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Reticles have been activated successfully'));
                reticleSearch();}else{ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select atleast one Reticle to move to active.'));
                return null; }}catch(Exception e){ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Some error occurred. Please contact to system administrator.'));
        }
        return null;
    }
    
    /**
* This method removes the inactive reticle from 'pending for verification' category and keeps it in inactive state.
*
* @author  Vijay Mahajan
* @company CTS
* @date    19/05/2014 
*/
    public PageReference continueProcessing(){
        List<Reticle__c> selectedReticleList = new List<Reticle__c>();
        for(Reticlewrapper retwrapper : summaries){
            if(retwrapper.isSelected) {
                retwrapper.eachreticlewrapper.New_Inactive_Days__c = null;
                retwrapper.eachreticlewrapper.Date_Inactive_to_Active_Insertion__c = null;
                selectedReticleList.add(retwrapper.eachreticlewrapper);
            }                
        }
        try{
            if(!selectedReticleList.isEmpty()){
                update selectedReticleList;
                List<Reticle_Device__c> reticleDeviceList = [SELECT Id, Name, Is_Temporary__c 
                                                             FROM   Reticle_Device__c 
                                                             WHERE  Reticle__c =:selectedReticleList AND Is_Temporary__c = true];
                if(reticleDeviceList != null && !reticleDeviceList.isEmpty()){
                    delete reticleDeviceList;
                }
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Reticles have been processed successfully'));
                reticleSearch();
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select atleast one Reticle to continue processing.'));
                return null;} }catch(Exception e){ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Some error occurred. Please contact to system administrator.'));
        }
        return null;
    }
    
    public PageReference redirectToRecalculate(){
        PageReference pageRef = Page.ROSVF_RecalculateSharing;
        pageRef.setRedirect(false);
        return pageRef;
    }
    
    public PageReference redirectToDisposalCert(){
        PageReference pageRef = Page.ROSVF_DisposalCertificate;
        pageRef.setRedirect(false);
        return pageRef;
    }
    
    //addded for displaying helpText for Category
    public Map<String,String> mapHelpText{get;set;}
    public List<String> lstHelpText{get;set;}
    public void getHelpText(){        
        mapHelpText = new Map<String,String>();
        lstHelpText = new List<String>();
        
        if(UserType == 'FAB'){
            if(Environment_Variable__c.getInstance('ROS_HelpText_All_Archive_Reticles') != NULL){
                mapHelpText.put('All Archive Reticles',Environment_Variable__c.getInstance('ROS_HelpText_All_Archive_Reticles').Value__c);
            }
            if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_Fab_FollowUp') != NULL){
                mapHelpText.put('5a. Pending Fab FollowUp (Return)',Environment_Variable__c.getInstance('ROS_HelpText_Pending_Fab_FollowUp').Value__c);
            }
            if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_Scrap_Certificate') != NULL){
                mapHelpText.put('5b. Pending Scrap Certificate (Scrap)',Environment_Variable__c.getInstance('ROS_HelpText_Pending_Scrap_Certificate').Value__c);
            }
            if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_for_Shipment') != NULL){
                mapHelpText.put('5c. Pending for Shipment (Return)',Environment_Variable__c.getInstance('ROS_HelpText_Pending_for_Shipment').Value__c);
            }
        }else{
            if(Environment_Variable__c.getInstance('ROS_HelpText_All_Reticles') != NULL){
                mapHelpText.put('All Reticles',Environment_Variable__c.getInstance('ROS_HelpText_All_Reticles').Value__c);
            }
            if(Environment_Variable__c.getInstance('ROS_HelpText_All_Active_Reticles') != NULL){
                mapHelpText.put('All Active Reticles',Environment_Variable__c.getInstance('ROS_HelpText_All_Active_Reticles').Value__c);
            }
            if(Environment_Variable__c.getInstance('ROS_HelpText_All_Inactive_Reticles') != NULL){
                mapHelpText.put('All Inactive Reticles',Environment_Variable__c.getInstance('ROS_HelpText_All_Inactive_Reticles').Value__c);
            }
            if(Environment_Variable__c.getInstance('ROS_HelpText_All_Archive_Reticles') != NULL){
                mapHelpText.put('All Archive Reticles',Environment_Variable__c.getInstance('ROS_HelpText_All_Archive_Reticles').Value__c);
            }
            if(UserType == 'System Administrator'){
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_Notify_Customer') != NULL){
                    mapHelpText.put('1. Pending to Notify Customer',Environment_Variable__c.getInstance('ROS_HelpText_Pending_Notify_Customer').Value__c);
                }
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_Customer_Feedback') != NULL){
                    mapHelpText.put('2. Pending Customer Feedback',Environment_Variable__c.getInstance('ROS_HelpText_Pending_Customer_Feedback').Value__c);
                }
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_STF_Obsolescence') != NULL){
                    mapHelpText.put('3. Pending STF Obsolescence', Environment_Variable__c.getInstance('ROS_HelpText_Pending_STF_Obsolescence').Value__c);
                }
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_Debit_Note') != NULL){
                    mapHelpText.put('4. Pending Debit Note',       Environment_Variable__c.getInstance('ROS_HelpText_Pending_Debit_Note').Value__c);
                }
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_Fab_FollowUp') != NULL){
                    mapHelpText.put('5a. Pending Fab FollowUp (Return)',Environment_Variable__c.getInstance('ROS_HelpText_Pending_Fab_FollowUp').Value__c);
                }
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_Scrap_Certificate') != NULL){
                    mapHelpText.put('5b. Pending Scrap Certificate (Scrap)',Environment_Variable__c.getInstance('ROS_HelpText_Pending_Scrap_Certificate').Value__c);
                }
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_for_Shipment') != NULL){
                    mapHelpText.put('5c. Pending for Shipment (Return)',Environment_Variable__c.getInstance('ROS_HelpText_Pending_for_Shipment').Value__c);
                }
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_Active_Ver') != NULL){
                    mapHelpText.put('6. Pending for Active Reticle Verification',Environment_Variable__c.getInstance('ROS_HelpText_Pending_Active_Ver').Value__c);
                }
                //DBiswal 06182015
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_HS_Code_Assign') != NULL){
                    mapHelpText.put('7. Pending HS Code Assignment',Environment_Variable__c.getInstance('ROS_HelpText_Pending_HS_Code_Assign').Value__c);
                }
                //DBiswal 07082015
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_Wit_Arriv_Date') != NULL){
                    mapHelpText.put('8. Pending Witness Arrival Date',Environment_Variable__c.getInstance('ROS_HelpText_Pending_Wit_Arriv_Date').Value__c);
                }
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_EUC_Form') != NULL){
                    mapHelpText.put('9. Pending EUC Form',Environment_Variable__c.getInstance('ROS_HelpText_Pending_EUC_Form').Value__c);
                }
            }else if(UserType == 'CSR'){
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_Notify_Customer') != NULL){
                    mapHelpText.put('1. Pending to Notify Customer',Environment_Variable__c.getInstance('ROS_HelpText_Pending_Notify_Customer').Value__c);
                }
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_Customer_Feedback') != NULL){
                    mapHelpText.put('2. Pending Customer Feedback',Environment_Variable__c.getInstance('ROS_HelpText_Pending_Customer_Feedback').Value__c);
                }
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_Debit_Note') != NULL){
                    mapHelpText.put('4. Pending Debit Note',Environment_Variable__c.getInstance('ROS_HelpText_Pending_Debit_Note').Value__c);
                }
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_EUC_Form') != NULL){
                    mapHelpText.put('9. Pending EUC Form',Environment_Variable__c.getInstance('ROS_HelpText_Pending_EUC_Form').Value__c);
                }
            } else if(UserType == 'Solution Team'){
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_STF_Obsolescence') != NULL){
                    mapHelpText.put('3. Pending STF Obsolescence', Environment_Variable__c.getInstance('ROS_HelpText_Pending_STF_Obsolescence').Value__c);
                }
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_Active_Ver') != NULL){
                    mapHelpText.put('6. Pending for Active Reticle Verification',Environment_Variable__c.getInstance('ROS_HelpText_Pending_Active_Ver').Value__c);
                }
            }
            //DBiswal 06152015 - View for PI/YE users
            else if(UserType == 'PI/YE Team'){
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_STF_Obsolescence') != NULL){mapHelpText.put('3. Pending STF Obsolescence', Environment_Variable__c.getInstance('ROS_HelpText_Pending_STF_Obsolescence').Value__c);
                }
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_Active_Ver') != NULL){ mapHelpText.put('6. Pending for Active Reticle Verification',Environment_Variable__c.getInstance('ROS_HelpText_Pending_Active_Ver').Value__c);
                }
            }
            //DBiswal 06182015
            else if(UserType == 'Trade Comp'){
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_HS_Code_Assign') != NULL){mapHelpText.put('7. Pending HS Code Assignment',Environment_Variable__c.getInstance('ROS_HelpText_Pending_HS_Code_Assign').Value__c);
                }
            }
            //DBiswal 07082015
            else if(UserType == 'CE'){if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_Wit_Arriv_Date') != NULL){mapHelpText.put('8. Pending Witness Arrival Date',Environment_Variable__c.getInstance('ROS_HelpText_Pending_Wit_Arriv_Date').Value__c);
                }
            }else if(UserType == 'Customer'){
                if(Environment_Variable__c.getInstance('ROS_HelpText_Pending_Customer_Feedback') != NULL){
                    mapHelpText.put('2. Pending Customer Feedback',Environment_Variable__c.getInstance('ROS_HelpText_Pending_Customer_Feedback').Value__c);
                }
            }else if(UserType == 'None'){
            }else{
            }
        }
        if(mapHelpText.keySet().contains('All Reticles'))                         { lstHelpText.add('All Reticles'); }
        if(mapHelpText.keySet().contains('All Active Reticles'))                  { lstHelpText.add('All Active Reticles'); }
        if(mapHelpText.keySet().contains('All Inactive Reticles'))                { lstHelpText.add('All Inactive Reticles'); }
        if(mapHelpText.keySet().contains('All Archive Reticles'))                 { lstHelpText.add('All Archive Reticles'); }
        if(mapHelpText.keySet().contains('1. Pending to Notify Customer'))        { lstHelpText.add('1. Pending to Notify Customer'); }
        if(mapHelpText.keySet().contains('2. Pending Customer Feedback'))         { lstHelpText.add('2. Pending Customer Feedback'); }
        if(mapHelpText.keySet().contains('3. Pending STF Obsolescence'))          { lstHelpText.add('3. Pending STF Obsolescence'); }
        if(mapHelpText.keySet().contains('4. Pending Debit Note'))                { lstHelpText.add('4. Pending Debit Note'); }
        if(mapHelpText.keySet().contains('5a. Pending Fab FollowUp (Return)'))    { lstHelpText.add('5a. Pending Fab FollowUp (Return)'); }
        if(mapHelpText.keySet().contains('5b. Pending Scrap Certificate (Scrap)')){ lstHelpText.add('5b. Pending Scrap Certificate (Scrap)'); }
        if(mapHelpText.keySet().contains('5c. Pending for Shipment (Return)'))    { lstHelpText.add('5c. Pending for Shipment (Return)'); }
        if(mapHelpText.keySet().contains('6. Pending for Active Reticle Verification')){ lstHelpText.add('6. Pending for Active Reticle Verification'); }
        //DBiswal 06182015
        if(mapHelpText.keySet().contains('7. Pending HS Code Assignment')){ lstHelpText.add('7. Pending HS Code Assignment'); }
        if(mapHelpText.keySet().contains('8. Pending Witness Arrival Date')){ lstHelpText.add('8. Pending Witness Arrival Date'); }
        if(mapHelpText.keySet().contains('9. Pending EUC Form')){ lstHelpText.add('9. Pending EUC Form'); }
    }
    
    public pageReference cancelCustFeedback(){
        
        for(id retId :retIdSet){
  for(Reticlewrapper retwrapper : summaries){
    if(retwrapper.eachreticlewrapper.id ==retId){
       retwrapper.isselected = true;
    }
    }
}
        PageReference  retVal = new PageReference('/apex/ROSVF_SearchReticlesGFForm');      
        retval.setredirect(false); 
        return retVal ;
        
        
    }
    
    public void notifyCSR(){
        try{
        SelReturnReticles.clear();
        Set<string> setSelReticles = new Set<string>();
        Set<string> setMaskSetReticle = new Set<string>();
        Set<Id> setSelAccounts = new Set<Id>();
        set<string>devNameSet = new set<string>();
        string cycle='';
        string account='';
        string maskSet='';
        string fab='';
        if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        for(Reticlewrapper rets: summaries){
            
            if(rets.IsSelected){
                setMaskSetReticle.add(rets.eachreticlewrapper.name.substringBefore('-'));
                maskSet=rets.eachreticlewrapper.name.substringBefore('-');
                setSelReticles.add(rets.eachreticlewrapper.id);
                setSelAccounts.add(rets.eachreticlewrapper.Account__c);
                account=rets.eachreticlewrapper.Account__r.name;
                cycle=rets.eachreticlewrapper.ros_cycle__r.name;
                fab=rets.eachreticlewrapper.FabStr__c;
                if(String.isNotBlank(rets.eachreticlewrapper.GlobalFoundries_Device_ID__c)){
                    for(String eachdev : rets.eachreticlewrapper.GlobalFoundries_Device_ID__c.contains(',') ? rets.eachreticlewrapper.GlobalFoundries_Device_ID__c.split(',') : rets.eachreticlewrapper.GlobalFoundries_Device_ID__c.split(';')){
                        devNameSet.add(eachdev.deleteWhitespace());
                        
                    }
                }
            }
        }
        
        if(setSelAccounts.size()==0){
            ApexPages.addMessage((new ApexPages.Message(ApexPages.severity.ERROR, 'Please select atleast one Reticle')));
        } else if(setSelAccounts.size()>1){
            ApexPages.addMessage((new ApexPages.Message(ApexPages.severity.ERROR, 'Please select Reticles which belongs to same Customer')));
        }else if(setMaskSetReticle.size()>1){
            ApexPages.addMessage((new ApexPages.Message(ApexPages.severity.ERROR, 'Please select Reticles which belongs to same MaskSet')));
        } else if(setSelReticles.size() > 0 && setSelAccounts.size() >0){
            Ros_reticleHandler hnd = new Ros_reticleHandler();
            set<string>roleSet = new set<string>{'Primary Customer Service Rep','Backup Customer Service Rep'};
                Map<id,list<Account_Team_Proxy__c>>csrEmailAddMap = hnd.findEmailAdd(roleSet,setSelAccounts);
            string setRetBody =findDevRet(devNameSet,Cycle);
            string body = '<html><body>'+'Dear Csr,'+'<br><br>';
            body +='We are unable to proceed with the obsolescence of the STF due to not all mask had been disposed. Please ensure that full list of reticle disposition is given before we can proceed with the STF obsoletion to avoid delay in execution.'+'<br><br>';
            body +=setRetBody+'<br><br>';
            body +='Access the following URL to go to SFDC:'+'<br>';
            body+=system.label.PIYE_Body;
            list<string>emailAddList = new list<string>();
            
            string accId ='';
            for(id ins:setSelAccounts){
                accId=ins;
            }
            for(Account_team_proxy__c act:csrEmailAddMap.get(accId)){
                emailAddList.add(act.User_Email__c);
            }    
            list<string>ccList = new list<string>();
            Set<id>userEmailId = new Set<id>();
            for(groupmember gpm:[select group.name,userorgroupid from groupmember
                                 where groupid in
                                 (Select id from group where name =:'PI/YE ROS '+fab+' Team' )]){
                                     if(string.valueOf(gpm.userorgroupid).startsWith('005')) {
                                         userEmailId.add(gpm.userorgroupid);
                                     }    
                                 }
            for(user us:[Select id,email from  user where id in:userEmailId]){
                ccList.add(us.email);
            }
             OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress 
                                        WHERE Address = 'noreply-salesforce@globalfoundries.com'];
            string subject ='ROS Cycle '+cycle+' -Partial Disposition Alert '+maskSet+'+'+account ;
            list<Messaging.SingleEmailMessage> mails = new list<Messaging.SingleEmailMessage>();   
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(emailAddList);
            mail.setSubject(subject);
            mail.setHtmlBody(body);
            mail.setCcAddresses(ccList);
            mail.setOrgWideEmailAddressId(owa.id);
            mails.add(mail);
            hnd.sendEmails(mails);
            list<reticle__c> rtnList = new list<reticle__c>();
            for(id  rt:setSelReticles){
                reticle__c rtn = new reticle__c(id=rt);
                rtn.Csr_notified_date__c= system.today();
                rtnList.add(rtn);
            }
            
            update rtnList;
            cancelCustFeedback();
            
            
        }
        }catch (exception e){
        ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ROS_ControllerSearchReticleGFForm.class.getName();
            alw.sourceFunction = 'setDefaultOwner()';
            alw.ApplicationName='ROS';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw); 
        
    }
    }
    public string findDevRet(set<string>uniquedev,string cycle){
        try{
        string body='';
        body ='<table border=1">' ;
        body+='<tr><th >Reticle associate with the device</th>';
        body+='<th >Device</th>';
        body+='<th >Reticle Workflow Status</th>';
        body+='<th >Customer Notify Date</th></tr>';
        set<string>rtName = new set<string>();
        for(Reticle_Device__c rd:[Select id,Reticle__c,Reticle__r.name,Reticle__r.Reticle_workflow_Status__c,
                                  Reticle__r.GlobalFoundries_Device_ID__c,Reticle__r.Customer_Notify_Date__c 
                                  from Reticle_Device__c where (GF_Device_Id__c in :(uniquedev) 
                                  or CRM_Device_ID__c in :(uniquedev) )
                                  and Reticle__r.ROS_Status__c !='Keep'
                                  and Reticle__r.ros_cycle__r.name=:cycle])
        {
            
            if(!rtName.contains(rd.Reticle__r.name)){
            body+= '<tr ><td >' + rd.Reticle__r.name + '</td>';
            body+= '<td>' + rd.Reticle__r.GlobalFoundries_Device_ID__c+ '</td>';
            body+= '<td>' + rd.Reticle__r.Reticle_workflow_Status__c + '</td>';
            body+= '<td>' + rd.Reticle__r.Customer_Notify_Date__c+'</td></tr>';
            rtName.add(rd.Reticle__r.name);
        }   
        } 
        body+='</table>';
        
        if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
            return body;
    } catch (exception e){
        ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ROS_ControllerSearchReticleGFForm.class.getName();
            alw.sourceFunction = 'setDefaultOwner()';
            alw.ApplicationName='ROS';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw); 
        return null;
    }
    }
    public class applicationException extends Exception {}
}