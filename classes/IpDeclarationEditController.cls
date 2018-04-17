/*
  Author: Win
  Description: load data and populate to the form.
  History:
    win           06162013    - code creation.       
    win           07222013    - added logic for whitelist and IP_tech.      
    Nbustillos    08122013    - Removed reference to IP_Component__c and change it to Name. 
    Asolito       08292013    - added run flag for IP Matching  
    Aroy          09132013    - removed Status__c = 'Matched' as no longer required as per MD50.
    Aroy          09132013    - added init() method to redirect to standard view for standard user and VF for customer portal.
                              - added the cancel functionality for retrofit with FoundryView      .
    Nbustillos    10162013    - Added logic to only query selected IP declaration when form is not Draft/Undeclared.
                              - Created getSelectedIpComponentList() method.
    ZAmbat        05272014    - Updated code to redirect IP Declaration page based on current user.      
    TLai          12032014    - Added logic to populated IP Components from configurator  
    PSaha         12082014    - Added Configured IP logic.                
*/

public class IpDeclarationEditController {
    
    static final string DEFAULT_FORMAT = EnvironmentVariable.get('IP_DECLARATION_DEFAULT_FORMAT');
    static final string QUALCOMM_CUSTOM_FORMAT = EnvironmentVariable.get('IP_DECLARATION_CUSTOM_FORMAT_QUALCOMM');
    static final string STATUS_DRAFT = EnvironmentVariable.get('IP_DECLARATION_STATUS_DRAFT');
    static final string STATUS_UNDECLARED = EnvironmentVariable.get('IP_DECLARATION_STATUS_UNDECLARED');
    static final string STATUS_PSUBMISSION = EnvironmentVariable.get('IP_DECLARATION_STATUS_PSUBMISSION');
    static final string STATUS_RECALLED = EnvironmentVariable.get('IP_DECLARATION_STATUS_RECALLED');
    
    public IP_Declaration_Form__c IpDecForm { get; set; }
    
    //*********************************
    // 09132013 - Aroy : added for init check and cancel functionality
    public String queryStr{get;set;}
    public Boolean initialised{get;set;}
    private ApexPages.StandardController controller;
    //*********************************
    
    //collection of the class/wrapper objects xIP_Component_from_ERP__c
    public List<xIPComponentFromERP> ipComponentList {get; set;}
    
    //public List<xIPConfiguration> configIPList {get;set;}
    
    //for selectOption for 5vOnly.
    transient List<SelectOption> only5vOptions {get; set;}
    
    //for attachment
    public AttachmentUploadUtil attUtil = new AttachmentUploadUtil();
    public Attachment attachOthers { get; set; } //for uploading
    private List<Attachment> ipDecAtts; //for displaying
    
    // Retrieve the list of Attachment with 'Other' description
    public List<Attachment> getIpDecAtts(){
        ipDecAtts = [select id, name,description from Attachment 
                      where parentid = :IpDecForm.id 
                      order by lastmodifieddate desc];

        if(ipDecAtts.size()>0){
            return ipDecAtts;
        }else{
            return null;
        }       
    }
    
    // Delete and Empty attachment list.
    private void emptyAttachment() {
        try {
            system.debug('emptyAttachment #1');
            List<Attachment> atts = getIpDecAtts();
            system.debug('emptyAttachment #2' + atts);
            if(atts != null){
                system.debug('emptyAttachment #3');
                delete atts;
                system.debug('emptyAttachment #4' + atts);
            }
        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
    }
    
    
    public List<SelectOption> getOnly5vOptions() {
        system.debug('getOnly5vOptions==>'+'getOnly5vOptions');
        if(only5vOptions == null){
            only5vOptions = new List<SelectOption>();
            //TODO: read data from query.
            //for(Profile p : [SELECT Id, Name FROM Profile]) only5vOptions.add(new SelectOption(p.Id, p.Name));
            only5vOptions.add(new SelectOption('', 'Select...'));
            only5vOptions.add(new SelectOption('Yes', 'Yes'));
            only5vOptions.add(new SelectOption('No', 'No'));
        }
        return only5vOptions;
    }
    
    //***************************************************************************************************//
    //09132013 - Aroy - init method to check whether the user is a Customer Portal User or Stndard User
    public PageReference init(){
        PageReference pr = null; 
        if (!initialised){ 
                String custPortalUsrTyp = EnvironmentVariable.get('USER_TYPE_CUST_PORTAL');            
                String usrType = '';                         
                Id profId = UserInfo.getProfileId();
                List<Profile> profNameList = [select name, UserType from Profile where Id = :profId limit 1];
                if(profNameList.size()>0){
                        usrType = profNameList[0].UserType;
                }
                system.debug('usrType ==============> ' + usrType);
                if(usrType!=custPortalUsrTyp ){ 
                    //pr = new PageReference('/'+IpDecForm.Id+'/e?nooverride=1&retURL='+queryStr);
                    // check if view or edit
                    // ZAmbat 05272014
                    string retURL = ApexPages.currentPage().getParameters().get('retURL');
                    if (retURL != null) {
                        pr = new PageReference('/'+IpDecForm.Id+'/e?nooverride=1&retURL=' + retURL);    
                    } else {
                        pr = new PageReference('/'+IpDecForm.Id+'?nooverride=1');
                    }
                    
                    pr.setRedirect(true);
                }
                initialised=true;
        }
        return pr;
    }
    //***************************************************************************************************//
        
    public IpDeclarationEditController(ApexPages.StandardController controller){
        this.controller = controller;
        this.ipDecForm= (IP_Declaration_Form__c)controller.getRecord();
        //system.debug('ipDecForm==>'+ipDecForm);
        //init IP Declaration Form
        if(ipDecForm.id != null ){
            List<IP_Declaration_Form__c> iplist = [
                    SELECT CRM_Device_ID__c, Customer_Contact__c, Customer_Name__c, Device_Name__c, Email_Address__c, 
                        Fab__c, Form_Completed__c, Form_Submitted_Date__c, Geometry__c, Job_Title__c, 
                        Mask_Set_Title__c, Other_3rd_Party_IP__c, Phone__c, Process_Technology__c, 
                        Project_Name__c, Status__c, Device__c, Notes_to_New_Owner__c, IP_Technology__c, Account__c,
                        Nothing_to_Declare__c, IP_Declaration_Template__c, OwnerId__c, IP_Status__c,
                        Configuration__c, Revision_Required__c, Is_Config_Used__c,Revision_Required_Formula__c,
                        configuration__r.APTPS_Primary__c,configuration__r.Apttus_Proposal__Approval_Stage__c
                    from IP_Declaration_Form__c where id = :ipDecForm.id
                ];
            //Tlai 2/12/2014 
            if(iplist.size() == 1){ //Form is found
                ipDecForm = iplist.get(0);
                attachOthers = getAttachOthers(); //obsolete, replace by getIpDeclaAttach
                getIpComponentList();
            }
            if(getReadOnly() && IpDecForm.Status__c == 'Reassigned'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Form is pending review by new owner.'));
            }else if(getReadOnly() && (IpDecForm.Status__c == 'Draft' || IpDecForm.Status__c == 'Pending Resubmission' || IpDecForm.Status__c == 'Recalled')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You must be the owner in order to edit this form.'));
            }
        }
        //******************************************
        // 09132013 - Aroy - added for init method
        /*PageReference pgr = ApexPages.currentPage();
        queryStr = pgr.getParameters().get('retURL');
        if(queryStr <> null){
            queryStr = queryStr.substringAfter('/');
        }*/
        initialised = false;
        //******************************************
    }
    /*** PSaha 12082014
    Description: Get configured IPs from Proposal Line items and Base IP
    Input: N/A
    Output: List of string: returns all the tech types related to configured IPs
    ***/
    /*private set<String> getIPTechTypes(){

        //configIPList = new List<xIPConfiguration>();
        set<String> techTypeSet = new set<String>();
        // 1-start: retrieve IP list from configuration
        set<String> ipSet = new set<String>();
        if(ipDecForm.Configuration__c != null){
            Apttus_Proposal__Proposal__c proposal = [select id, IPs__c from Apttus_Proposal__Proposal__c where id = :ipDecForm.Configuration__c];
            if(proposal != null && !String.isBlank(proposal.IPs__c)){
                for(String ipNo : proposal.IPs__c.split('<:>')){
                    if(!String.isblank(ipNo))ipSet.add(ipNo);
                }
            }
        }
        // 1-end
        
        if(ipSet.size() > 0){
            // 2- start : retrieve techtype list from base_IP__c
            for(Base_IP__c baseIp : [select id, Tech_Type__c,IP_Number__c,Description__c from base_ip__c where IP_Number__c in :ipSet and Tech_Type__c != null]){
                techTypeSet.add(baseIp.Tech_Type__c);
                xIPConfiguration tempIPConfig = new xIPConfiguration ();
                    tempIPConfig.IPname = baseIp.Description__c; 
                    tempIPConfig.IPTechType = baseIp.Tech_Type__c;
                //configIPList.add(tempIPConfig);
            }
        }
        return techTypeSet;
    }*/
    
    
    /*Tlai 3/12/2014
    Description:  Populate IP Componet List from configuration
    Input:  N/A
    Output: list of xIPComponentFromERP to be displayed
    **/
    private List<xIPComponentFromERP> getIpComponentListfrConfig() {
        if(ipComponentList == null) {
            ipComponentList = new List<xIPComponentFromERP>();
            //set<string> techTypeSet = getIPTechTypes();
            
            //configIPList = new List<xIPConfiguration>();
            
            // 1-start: retrieve IP list from configuration
            set<String> ipSet = new set<String>();
            if(ipDecForm.Configuration__c != null){
                Apttus_Proposal__Proposal__c proposal = [select id, IPs__c from Apttus_Proposal__Proposal__c where id = :ipDecForm.Configuration__c];
                if(proposal != null && !String.isBlank(proposal.IPs__c)){
                    for(String ipNo : proposal.IPs__c.split('<:>')){
                        if(!String.isblank(ipNo))ipSet.add(ipNo);
                    }
                }
            }
            // 1-end
            
            if(ipSet.size() > 0){
                // 2- start : retrieve techtype list from base_IP__c
                //set<String> techTypeSet = new set<String>();
                Set<String> IPComponentSet = new Set<String>();
                
                for(Base_IP__c baseIp : [select     id, Technology__c,IP_Number__c,Description__c,Ip_Vendor__c,Ip_Type__c,IP_COMPONENT__C  
                                         from       base_ip__c 
                                         where      IP_Number__c in :ipSet 
                                         //and  Technology__c != null
                                         and        IP_COMPONENT__C != null]){
                    IPComponentSet.add(baseIp.IP_COMPONENT__C) ; 
                    
                    /*xIPConfiguration tempIPConfig = new xIPConfiguration ();
                        tempIPConfig.IPname = baseIp.Description__c; 
                        tempIPConfig.IPTechType = baseIp.Tech_Type__c;
                    configIPList.add(tempIPConfig);*/
                }
                //2 - end 
                if(IPComponentSet.size() > 0){
                    // 3 - start : retrieve erp list from IP_Component_from_ERP__c
                    List<IP_Declaration_Component__c> existingComponents = getExistingSelectedIPComponentList();
                    for(IP_Component_from_ERP__c ip: [SELECT Id, Enabled_Flag__c, FV_IP_Type__c, FV_Vendor__c, OIC_IP_Component__c, 
                                    Tech_Geo__c, Tech_Type__c, To_Show_5V_Only__c, To_Show_Design_ID__c, IP_Type__c, IP_Type_Desc__c, 
                                    Vendor__c, Name, Geometry_um__c
                                FROM IP_Component_from_ERP__c 
                                WHERE Enabled_Flag__c = true
                                and name in :IPComponentSet
                                ]) {
                        ipComponentList.add(new xIPComponentFromERP(ip, existingComponents, true));
                    }// 3 - end
                    
                }
            }
            
        }
        
        return ipComponentList;
    }
    
    
    //use to load the list of IPComponent available for selection.
    private List<xIPComponentFromERP> getIpComponentList() {
        if(ipComponentList == null) {
            if(ipDecForm.Device__c != null) {
                
                // load from whitelist or IP From ERP if Draft/Undeclared
                if(ipDecForm.Status__c == STATUS_DRAFT || ipDecForm.Status__c == STATUS_UNDECLARED || 
                   ipDecForm.Status__c == STATUS_PSUBMISSION || ipDecForm.Status__c == STATUS_RECALLED){
                    
                    if(ipDecForm.Is_Config_Used__c){
                        getIpComponentListfrConfig();
                    }else {
                        getIpComponentListFromWhiteList();
                        if(ipComponentList == null) { 
                            //if no whitelist record is found, continue to read from ERP.
                            getIpComponentListFromERP();
                        }
                    }
                    
                }else{
                    // load only from declared components
                    // added comment by tlai 3/12/2014 -> for display purpose only
                    getSelectedIpComponentList();
                    //get configured IPs 
                    //if(ipDecForm.Is_Config_Used__c){
                        //getIPTechTypes();
                    //}
                }
            }
        }
        
        system.debug('>>> ipComponentList: ' + ipComponentList);
        return ipComponentList;
    }
    
    /*
        populate the ipComponentList if whitelist is defined.
    */
    private void getIpComponentListFromWhiteList(){
        List<IP_White_List__c> whiteList = [
            SELECT Reference_IP_Component_from_ERP__c from IP_White_List__c where Account__c = :ipDecForm.Account__c
        ];
        if(whiteList.size() > 0){ //whitelist is found
            List<String> whiteListStr = new List<String>();
            for(IP_White_List__c whiteL : whiteList){
                whiteListStr.add(whiteL.Reference_IP_Component_from_ERP__c);
            }
            
            ipComponentList = new List<xIPComponentFromERP>();
            List<IP_Declaration_Component__c> existingComponents = getExistingSelectedIPComponentList();
            for(IP_Component_from_ERP__c erp: [SELECT Id, Enabled_Flag__c, FV_IP_Type__c, FV_Vendor__c, OIC_IP_Component__c, 
                            Tech_Geo__c, Tech_Type__c, To_Show_5V_Only__c, To_Show_Design_ID__c, IP_Type__c, IP_Type_Desc__c, 
                            Vendor__c, Name, Geometry_um__c
                        FROM IP_Component_from_ERP__c 
                        WHERE Enabled_Flag__c = true
                        and Id in :whiteListStr
                        ]) {
                ipComponentList.add(new xIPComponentFromERP(erp, existingComponents, false));
            }
        }
    }
    
    /*
        if whitelist if not defined; populate the ipComponentList with IP Technology.
    */
    private void getIpComponentListFromERP() {
        if( String.isEmpty(ipDecForm.IP_Technology__c)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'IpDeclarationEditController: Device.IP_Technology cannot be null.'));
        }else{ 
            //system.debug('ipDecForm.Geometry__c ==> '+ipDecForm.Geometry__c);
            ipComponentList = new List<xIPComponentFromERP>();
            
            //retrieve existing selected IP Component; used to set the existing values.                    
            List<String> ipTechList = new List<String>();
            if(ipDecForm.IP_Technology__c.indexOf(';') > 0){
                ipTechList = ipDecForm.IP_Technology__c.split(';');
            }else{
                ipTechList.add(ipDecForm.IP_Technology__c);
            }
            
            List<IP_Declaration_Component__c> existingComponents = getExistingSelectedIPComponentList();
            for(IP_Component_from_ERP__c erp: [SELECT Id, Enabled_Flag__c, FV_IP_Type__c, FV_Vendor__c, OIC_IP_Component__c, 
                            Tech_Geo__c, Tech_Type__c, To_Show_5V_Only__c, To_Show_Design_ID__c, IP_Type__c, IP_Type_Desc__c, 
                            Vendor__c, Name, Geometry_um__c
                        FROM IP_Component_from_ERP__c 
                        WHERE Enabled_Flag__c = true
                        //and Geometry_um__c like '%.028UM'
                        //and Process_Geometry_NM__c = :ipDecForm.Geometry__c
                        and Tech_Type__c in :ipTechList
                        //LIMIT 20
                        ]) {
                ipComponentList.add(new xIPComponentFromERP(erp, existingComponents, false));
            }
        }
    }
    
    /*
        if for is not undeclared or draft load only those that are declared.
    */
    private void getSelectedIpComponentList(){
        system.debug('>>> START');
        if(ipComponentList == null) ipComponentList = new List<xIPComponentFromERP>(); 
        Map<id, IP_Declaration_Component__c> mDeclaredComponent = new map<id,IP_Declaration_Component__c>();
        
        // get the declared Ips
        for(IP_Declaration_Component__c ipDeclared : getExistingSelectedIPComponentList()){
            mDeclaredComponent.put(ipDeclared.Master_IP_Component__c, ipDeclared);
        }
        
        // get the erp component from ERP related to these ips
        for(IP_Component_from_ERP__c erp : [SELECT Id, Enabled_Flag__c, FV_IP_Type__c, FV_Vendor__c, OIC_IP_Component__c, 
                            Tech_Geo__c, Tech_Type__c, To_Show_5V_Only__c, To_Show_Design_ID__c, IP_Type__c, IP_Type_Desc__c, 
                            Vendor__c, Name, Geometry_um__c FROM IP_Component_from_ERP__c WHERE Id in :mDeclaredComponent.keySet()]) {
           // get the Ip declaration form
           IP_Declaration_Component__c ipDeclaredComp = mDeclaredComponent.get(erp.Id);
           ipComponentList.add(new xIPComponentFromERP(erp, ipDeclaredComp));           
        }
        system.debug('>>> END');
    }
    /*
    //this is our wrapper/container class for IPs from Configuration 
    public class xIPConfiguration{
        public String IPname {get;set;}
        public String IPTechType {get;set;}
        
        //This is the contructor method.
        public xIPConfiguration(){
        }
    }*/
    
    // This is our wrapper/container class. A container class is a class, a data structure, or an abstract data type whose instances are collections of other objects. In this example a wrapper class contains both the standard salesforce object Contact and a Boolean value
    public class xIPComponentFromERP {
        public IP_Component_from_ERP__c erpIp {get; set;}
        public Boolean selected {get; set;}
        public String only5v {get; set;}
        public String designId {get; set;}
 
        //This is the contructor method. When we create a new xIp object we pass a erp-ip that is set to the erpIp property.
        public xIPComponentFromERP(IP_Component_from_ERP__c ip, List<IP_Declaration_Component__c> existingComponents) {
            erpIp = ip;
            for(IP_Declaration_Component__c com: existingComponents) {
                //system.debug('checking againts existing ......');
                if(ip.id == com.Master_IP_Component__c){
                    selected = true;
                    if(com.X5V_Only__c != null){
                        only5v = com.X5V_Only__c;
                    }
                    designId = com.Design_ID__c;
                    break;
                }else{
                    selected = false;
                }
            }
            
        }
        
        //This is the contructor method. When we create a new xIp object we pass a erp-ip that is set to the erpIp property.
        public xIPComponentFromERP(IP_Component_from_ERP__c ip, List<IP_Declaration_Component__c> existingComponents, boolean autoSelect) {
            erpIp = ip;
            
            for(IP_Declaration_Component__c com: existingComponents) {
                if(ip.id == com.Master_IP_Component__c){
                    selected = true;
                    if(com.X5V_Only__c != null){
                        only5v = com.X5V_Only__c;
                    }
                    designId = com.Design_ID__c;
                    break;
                }else{
                    selected = false;
                }
            }
            if(selected == null) selected = false;
            selected = autoSelect || selected;
            
        }
        
        public xIPComponentFromERP(IP_Component_from_ERP__c ip,IP_Declaration_Component__c ipDec){
            erpIp = ip; 
            selected = true;
            if(ipDec!=null){
                
                if(ipDec.X5V_Only__c!=null){
                    only5v = ipDec.X5V_Only__c;
                } 
                
                if(ipDec.Design_ID__c!=null){
                    designId = ipDec.Design_ID__c;
                }
            }
        }
    }
    
    //the old selected Ip Component will be deleted, and new selected will be inserted.
    private void processSelectedIP() { 
        List<xIPComponentFromERP> selectedIpComponents = new List<xIPComponentFromERP>();
        
        for(xIPComponentFromERP xIp:  ipComponentList) {
            //system.debug('xIp.selected=' + xIp.selected);
            if(xIp.selected == true) {
                selectedIpComponents.add(xIp);
                //start validation
                if(xIp.erpIp.To_Show_5V_Only__c && String.isEmpty(xIp.only5v)){
                    String msg = '5V Only for (' + xIp.erpIp.FV_Vendor__c + '/' + xIp.erpIp.FV_IP_Type__c + ') cannot be empty.';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, msg));
                }
                if(xIp.erpIp.To_Show_Design_ID__c && String.isEmpty(xIp.designId)){
                    String msg = 'Design Id for (' + xIp.erpIp.FV_Vendor__c + '/' + xIp.erpIp.FV_IP_Type__c + ') cannot be empty.';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, msg));
                }
            }
        }
        if(ApexPages.hasMessages()){
            return; //if validation failed, return the form without saving selected IP Component.
        }
        refreshSelectedIPComponent(selectedIpComponents); //delete old, insert new.
    }
    
    private List<IP_Declaration_Component__c> getExistingSelectedIPComponentList(){
        return [SELECT Id, Name, Master_IP_Component__c, X5V_Only__c, Design_ID__c, IP_Declaration_Form__c
                FROM IP_Declaration_Component__c 
                WHERE  IP_Declaration_Form__r.id = :ipDecForm.id]; 
    }

    //Delete the previous selected component, and insert newly selected components.
    private void refreshSelectedIPComponent(List<xIPComponentFromERP> selectedIpComponents) {
        List<IP_Declaration_Component__c> existingComponents = getExistingSelectedIPComponentList(); 
        List<IP_Declaration_Component__c> newComponents = new List<IP_Declaration_Component__c>();
        try {
            delete existingComponents;
        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        for(xIPComponentFromERP xIp: selectedIpComponents) {
            IP_Component_from_ERP__c ip = xIp.erpIp;
            IP_Declaration_Component__c newlySelectComponent = 
                new IP_Declaration_Component__c(Master_IP_Component__c = ip.id, 
                                                IP_Declaration_Form__c = ipDecForm.id,
                                                 FV_IP_Type__c = ip.FV_IP_Type__c, 
                                                 FV_Vendor__c = ip.FV_Vendor__c, 
                                                 IP_Component__c = ip.Name,
                                                 IP_Type__c = ip.IP_Type__c, 
                                                 IP_Type_Desc__c = ip.IP_Type_Desc__c, 
                                                 OIC_IP_Component__c = ip.OIC_IP_Component__c,
                                                 Tech_Geometry__c = ip.Tech_Geo__c, 
                                                 Tech_Type__c = ip.Tech_Type__c, 
                                                 Vendor__c = ip.Vendor__c,
                                                 X5V_Only__c = xIp.only5v, 
                                                 Design_ID__c = xIp.designId);
            newComponents.add(newlySelectComponent);
        }                    
        try {
            insert newComponents;
            
            //Added ASOLITO 08292013 - set IP Matching Flag to true
            IpDeclarationMatching.hasMatchingRun = true;
        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }                 
    }
    
    private void submitForm(){
        system.debug('======>'+ipDecForm.Id);
        String result = IpDeclarationFormService.submitForApproval(ipDecForm.Id); //call submit approval via WS.
        if(result != 'OK'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, result));
        }
    }
    
    /*private void saveForm(){
        saveForm('Draft');
    }*/
    
    //upsert IP Declaration Form with new status.
    //update existing userID to OwnerID
    //update existing userID to Last_Assigned_Customer_User field.
    /*private void saveForm(String status) {
        try {
            if(status != null){
                ipDecForm.Status__c = status;
                ipDecForm.OwnerId__c = Userinfo.getUserid();
                ipDecForm.Last_Assigned_Customer_User__c = Userinfo.getUserid();
                upsert IpDecForm;
                
                //update IP Declaration status at Device level.
                //for(Device__c d : [SELECT IP_Declaration_Status__c from Device__c where id =: ipDecForm.Status__c]){
                //    d.IP_Declaration_Status__c = status;
                //    update d;
                //}
            }
        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
    }*/
    
    public Attachment getAttachOthers() {
        system.debug('getAttachOthers==>'+'getAttachOthers. ipDecForm.id='+ipDecForm.id);
        system.debug('attUtil==>'+attUtil);
        if(attachOthers == null){
            //retrieve the attachment
            Map<String, Attachment> attachMap = new Map<String, Attachment>();
            attachMap =  attUtil.getAttachments(ipDecForm.id);
            system.debug('1.='+attachMap);
            system.debug('2.='+AttachmentUploadUtil.OTHER);
            system.debug('3.='+attachMap.get(AttachmentUploadUtil.OTHER));
            attachOthers = attachMap.get(AttachmentUploadUtil.OTHER);
            system.debug('4.='+attachOthers);
        }
        return attachOthers;
    }
    
    // Method to save the attachments
    private void saveAttachment() {   
        system.debug('saveAttachment #1' + IpDecForm);
        system.debug('saveAttachment #1' + attachOthers);
        if(IpDecForm != null && attachOthers != null){
            system.debug('saveAttachment #2');
            emptyAttachment();
            system.debug('saveAttachment #3');
            attachOthers.id = null; //this is needed, as the old attachment already being deleted.
            attUtil.attachMap.put(AttachmentUploadUtil.OTHER, attachOthers);
            system.debug('saveAttachment #4');
            if(attUtil.saveAttachList()){
                system.debug('saveAttachment #5');
                string msg = 'Error when saving attachment. Please remove the attachment or try save with other file.';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
            }
        }
    }

    
    // to load selected IP Component list.
    
    public PageReference submit() {
        
        system.debug('in submit() ... ');
        processSelectedIP();
        saveAttachment();
        if(ApexPages.hasMessages()){ return null; }//if validation failed, return to the same page.
            
        submitForm();
        if(ApexPages.hasMessages()){return null; } //if validation failed, return to the same page.
            
        //*******************************************************************
        //09132013 - Aroy : added the redirection to integrate with FoundryView
        PageReference ipDecPage = new PageReference('/apex/IPDeclarationEdit');
        ipDecPage.getParameters().put('id',IpDecForm.Id);
        ipDecPage.getParameters().put('retURL','/'+IpDecForm.Device__c);
        String chkPg = ApexPages.currentPage().getParameters().get('type');
        if(chkPg == 'list'){
            ipDecPage.getParameters().put('type','list');
        }
        ipDecPage.setRedirect(true);
        return ipDecPage;
        //********************************************************************
    }

    public PageReference save() {
        
        if(ipDecForm.Is_Config_Used__c){
            if(!validateConfig()) return null;
            ipDecForm.Status__c = 'Submitted to Globalfoundries';
            ipDecForm.Revision_Required__c = 'FALSE';
            
        } else {
            ipDecForm.Status__c = 'Draft';
            ipDecForm.Revision_Required__c = null;
        }
        
        processSelectedIP();
        saveAttachment();
        if(ApexPages.hasMessages()) return null;
        
        ipDecForm.OwnerId__c = Userinfo.getUserid();
        ipDecForm.Last_Assigned_Customer_User__c = Userinfo.getUserid();
        
        update ipDecForm;
        
        //return null;
        //*******************************************************************
        //09132013 - Aroy : added the redirection to integrate with FoundryView
        PageReference ipDecPage = new PageReference('/apex/IPDeclarationEdit');
        ipDecPage.getParameters().put('id',IpDecForm.Id);
        ipDecPage.getParameters().put('retURL','/'+IpDecForm.Device__c);
        String chkPg = ApexPages.currentPage().getParameters().get('type');
        if(chkPg == 'list'){
            ipDecPage.getParameters().put('type','list');
        }
        ipDecPage.setRedirect(true);
        return ipDecPage;
        //********************************************************************
    }
    
    
    public PageReference cancel() {
        //*******************************************************************
        //09132013 - Aroy : added the retrofit cancel functionality to integrate with FoundryView
        String chkPg = ApexPages.currentPage().getParameters().get('type');
        if(chkPg=='list'){
            PageReference ipDecPage = new PageReference('/apex/MyDevices?sfdc.tabName=01r900000003eSG');
            ipDecPage.getParameters().put('name','IPDeclaration');
            ipDecPage.setRedirect(true);
            return ipDecPage;
        }
        return controller.cancel();
        //********************************************************************
        //system.debug('in cancel() ... ');
        //return new PageReference('/'+IpDecForm.Id);
    }
    
    public PageReference reAssign() {
        //return  IpDeclarationChangeOwner
        system.debug('in reAssign() ... ');
        //*******************************************************************
        //09132013 - Aroy : added the retrofit cancel functionality to integrate with FoundryView
        PageReference ipDecPage = new PageReference('/apex/IpDeclarationChangeOwner');
        ipDecPage.getParameters().put('id',IpDecForm.Id);
        String chkPg = ApexPages.currentPage().getParameters().get('type');
        if(chkPg == 'list'){
            ipDecPage.getParameters().put('type','list');
        }
        ipDecPage.setRedirect(true);
        return ipDecPage;
        //********************************************************************
        //return new PageReference('/apex/IpDeclarationChangeOwner?id='+IpDecForm.Id);
        //return null;
    }
    
    /** Tlai 2/12/2014
        Populate IP components
    **/
    public void refreshIPComp(){
        if(ipDecForm.Is_Config_Used__c){//Change to Manual IP Selection
            
            ipComponentList = null;
            getIpComponentListFromWhiteList();
            if(ipComponentList == null) { //if no whitelist record is found, continue to read from ERP.
                getIpComponentListFromERP();
            }
            
            ipDecForm.Is_Config_Used__c = false;
            ipDecForm.Revision_Required__c = Null;
            
            
        }else if(validateConfig()){//Change to IP selection from Configurator
            
            ipComponentList = null;
            getIpComponentListfrConfig();
            ipDecForm.Is_Config_Used__c = true;
            ipDecForm.Revision_Required__c = 'FALSE';
        }
        
    }
    
    private boolean validateConfig(){
        IP_Declaration_Form__c form = [SELECT CRM_Device_ID__c, Customer_Contact__c, Customer_Name__c, Device_Name__c, Email_Address__c, 
                        Fab__c, Form_Completed__c, Form_Submitted_Date__c, Geometry__c, Job_Title__c, 
                        Mask_Set_Title__c, Other_3rd_Party_IP__c, Phone__c, Process_Technology__c, 
                        Project_Name__c, Status__c, Device__c, Notes_to_New_Owner__c, IP_Technology__c, Account__c,
                        Nothing_to_Declare__c, IP_Declaration_Template__c, OwnerId__c, IP_Status__c,
                        Configuration__c, Revision_Required__c, Is_Config_Used__c,Revision_Required_Formula__c,
                        configuration__r.APTPS_Primary__c,configuration__r.Apttus_Proposal__Approval_Stage__c,configuration__r.name
                    from IP_Declaration_Form__c where id = :ipDecForm.id];
            
        if(form.Configuration__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Configuration is not populated.')); return false;
        }
        
        ipDecForm.Configuration__c =  form.Configuration__c;            
        String apprvStage = form.configuration__r.Apttus_Proposal__Approval_Stage__c;
        if(ipDecForm.configuration__r.APTPS_Primary__c == false || apprvStage == 'Draft' ||apprvStage == 'Pre-Submitted Phase' || apprvStage == 'Rejected Phase'){
            String path =  URL.getCurrentRequestUrl().toExternalForm().contains('/GlobalfoundryView/')?'/GlobalfoundryView/':'/';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'IP component cannot be populated as configuration <a href="'+ path + ipDecForm.Configuration__c+'">'  + form.configuration__r.name +'</a>is not yet approved.')); return false;
        }
        
        return true;
    }
    public boolean getReadOnly(){
        if(getEditable()){
            return false;
        }
        return true;
    }
    
    /*
        It's editable when:
        1. status are below:
            a. Draft
            b. Reassigned
            c. Pending Resubmission
            d. Recalled
        2. OwnerId__c field is empty
        3. OwnerId__c match user ID
        conditions: 1 AND (2 or 3)
    */
    public boolean getEditable(){
        
        if(IpDecForm.Status__c == 'Draft' || IpDecForm.Status__c == 'Reassigned' || IpDecForm.Status__c == 'Pending Resubmission' || IpDecForm.Status__c == 'Recalled' || IpDecForm.Status__c == 'Undeclared'){
            if(String.isEmpty(IpDecForm.OwnerId__c)){
                return true;
            }else if(IpDecForm.OwnerId__c == Userinfo.getUserid()){
                return true;
            }
        }
        return false;
    } 
    
    /* pdf is ready when:
        1. status are 
            a. Submitted
            b. Approved
            c. Matched
    */
    public boolean getPdfReady(){
        // 09132013 - ARoy : Removed IpDecForm.Status__c == 'Matched' as no longer required (Task - 352)
        if(IpDecForm.Status__c == 'Submitted' || IpDecForm.Status__c == 'Approved' || IpDecForm.Status__c == 'Submitted to Globalfoundries' ){
            return true;
        }
        return false;
    }  
    public String getOther3rdPartyIP(){
        if(String.isEmpty(ipDecForm.Other_3rd_Party_IP__c)){
            return 'NA';
        }
        return ipDecForm.Other_3rd_Party_IP__c;
    } 
    public boolean getQualcommFormat(){
        if(IpDecForm.IP_Declaration_Template__c == QUALCOMM_CUSTOM_FORMAT)
            return true;
        else
            return false;
    }
    
    public boolean getDefaultFormat(){
        if(IpDecForm.IP_Declaration_Template__c == DEFAULT_FORMAT)
            return true;
        else
            return false;
    }
    
}