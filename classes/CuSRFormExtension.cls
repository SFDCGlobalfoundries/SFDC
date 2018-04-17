/*
Author: Shyam Ravindra Nair
Description: Apex class will act as extension to below visualforce pages
    1) CuSRForm
    2) CuSRFormViewPage
History:
SNair     11112014     - code creation
SNair     12112014     - updated logic for Save method
SNair     13112014     - updated logic for Cancel method.
SNair     13112014     - updated logic for displaying Attachment. Also added new button to add attachment.
SNair     18112014     - added logic for Approver.
SNair     19112014     - updated logic for Approver.
SNair     20112014     - updated logic for saving th record, individual fab approvals
SNair     21112014     - made Customer Requestor standard lookup with filter criteria.
SNair     24112014     - Updated logic for implementation.
SNair     25112014     - updated logic for Stakeholder's Approval.
SNair     26112014     - updated logic for Stakeholder's Approval.
SNair     01122014     - updated logic for approval and implementation site vise.
SNair     02122014     - updated logic for approval and implementation site vise.
SNair     09122014     - added logic to save selected scope to Scope__c field.
SNair     11122014     - added logic to validate initiator section fields before save.
SNair     15122014     - added logic for Cost analysis.
SNair     17122014     - added logic for tab navigation.
SNair     30122014     - Implemented custom object for Implementation.
SNair     30122014     - updated logic for System Approver.
SNair     03012015     - updated logic for Notification Group.
SNair     03012015     - added logic for users.
SNair     05012015     - added logic for retrieving technologies from Process object.
SNair     14012015     - updated logicc for additional fab.
PSamal    06122017     - Case-00051184(Changes for new site - Essex Junction, East Fishkill, ASIC)
*/

public class CuSRFormExtension {
        
        //added by Shyam Nair on 5/6/2015
    public Map<String, CuSR_Disable_CreateNew_Form__c> cusrDisableCreateNewForm{get;set;}
    
        //Added by Shyam Nair on 4/14/2015 - do get CuSR Void History details
        public List<CuSR_Void_History__c> cusrVoidHistoryList{get;set;}
        public boolean showVoidHistory{get;set;}
        public boolean disableSingaporeForVoid{get;set;}
        
        //Added by Shyam Nair on 4/6/2015 - variables for getting attachments
        public String contentId{get;set;}
        public List<ContentDocumentLink> contentDocumentList{get;set;}
        //public List<Attachment> feedAttachmentList{get;set;}
        //public static final Integer NUM_ATTACHMENTS_TO_ADD=1; 
        
        //End
        
        //public boolean showAttachmentError{get;set;}
        public boolean editForm{get;set;}
        public boolean showApproveReject{get;set;}
        
        public boolean editOwner{get;set;}
        
        public boolean displayIndividualFabOwnerField{get;set;}
        
        public boolEan editFab{get;set;}
        public boolean editFab1{get;set;}
        public boolean editFab2{get;set;}
        public boolean editFab3{get;set;}
        public boolean editFab3e{get;set;}
        public boolean editFab5{get;set;}
        public boolean editFab6{get;set;}
        public boolean editFab7{get;set;}
        public boolean editFab8{get;set;}
        public boolean editFab9{get;set;}
        public boolean editFab10{get;set;}
        public boolean editASIC{get;set;}
        
        public boolean showFieldError{get;set;}
        
        public boolean showRaisedDateReasonField{get;set;}
        
        public boolean displayReceivedDatePopup{get;set;}
        
        public boolean additionalFAB1Pending{get;set;}
        public boolean additionalFAB2Pending{get;set;}
        public boolean additionalFAB3Pending{get;set;}
        public boolean additionalFAB3EPending{get;set;}
        public boolean additionalFAB5Pending{get;set;}
        public boolean additionalFAB6Pending{get;set;}
        public boolean additionalFAB7Pending{get;set;}
        public boolean additionalFAB8Pending{get;set;}
        public boolean additionalFAB9Pending{get;set;}
        public boolean additionalFAB10Pending{get;set;}
        public boolean additionalASICPending{get;set;}
        
        public boolean additionalFAB1Approved{get;set;}
        public boolean additionalFAB2Approved{get;set;}
        public boolean additionalFAB3Approved{get;set;}
        public boolean additionalFAB3EApproved{get;set;}
        public boolean additionalFAB5Approved{get;set;}
        public boolean additionalFAB6Approved{get;set;}
        public boolean additionalFAB7Approved{get;set;}
        public boolean additionalFAB8Approved{get;set;}
        public boolean additionalFAB9Approved{get;set;}
        public boolean additionalFAB10Approved{get;set;}
        public boolean additionalASICApproved{get;set;}

    //instance of object CuSR_Form__c
    public CuSR_Form__c cusrForm{get;set;}
    //String to store current record Id
    public String recId{get;set;}
    //instance of User to store current user details
    public User currentUser{get;set;}
    //to save Body of the attachment
    //public Transient Blob fileBody{get;set;}
    //to save attachment name
    //public String fileName{get;set;}
    //instance of pageReference
    public pageReference pgRef{get;set;}
    //string to hold current URL
    public String currentUrl{get;set;}
    //string to hold return url
    public String sourceUrl{get;set;}
    //List of Attachment to hold attachments under the CuSR Record
    public List<Attachment> attachmentList{get;set;}
    //List of CuSR Approval Process records related to current CuSR Form record
    List<CuSR_Approval_Process__c> cusrApprovalProcessList{get;set;}
    
    //variable to hold account id
    public String customerId{get;set;}
    //variable to hold contact id
    public String customerReqId{get;set;}
    public String customerReqName{get;set;}
    
    //List of CuSR Approvers
    public List<CuSR_Approval_Process__c> cusrApproverList{get;set;}
    //flag to check if fields are validated
    public boolean validateFields{get;set;}
    //flag to display message for Scope section
    public boolean showScopeMessage{get;set;}
    //count to check the no of fabs selected
    public Integer fabCount{get;set;}

    //to store system approver details
    public CuSR_Approval_Process__c dresdenSystemOwnerApproval{get;set;}
    public List<wrapperApprover> dresdenSystemOwnerApproverList{get;set;}
    //flag to show System Owner section
    public boolean showDresdenSystemOwner{get;set;}
    //boolean to enable approvers
    public boolean enableDresdenSystemApprover1{get;set;}
    public boolean enableDresdenSystemApprover2{get;set;}
    public boolean enableDresdenSystemApprover3{get;set;}
    public boolean enableDresdenSystemApprover4{get;set;}
    public boolean enableDresdenSystemApprover5{get;set;}
    
    //to store system approver details
    public CuSR_Approval_Process__c singaporeSystemOwnerApproval{get;set;}
    public List<wrapperApprover> singaporeSystemOwnerApproverList{get;set;}
    //flag to show System Owner section
    public boolean showSingaporeSystemOwner{get;set;}
    //boolean to enable approvers
    public boolean enableSingaporeSystemApprover1{get;set;}
    public boolean enableSingaporeSystemApprover2{get;set;}
    public boolean enableSingaporeSystemApprover3{get;set;}
    public boolean enableSingaporeSystemApprover4{get;set;}
    public boolean enableSingaporeSystemApprover5{get;set;}
    
    //to store singapore common fab approver details
    public CuSR_Approval_Process__c singaporeFabOwnerApproval{get;set;}
    public List<wrapperApprover> singaporeFabOwnerApproverList{get;set;}
    //flag to show System Owner section
    public boolean showSingaporeFabOwner{get;set;}
    //boolean to enable approvers
    public boolean enableSingaporeFabApprover1{get;set;}
    public boolean enableSingaporeFabApprover2{get;set;}
    public boolean enableSingaporeFabApprover3{get;set;}
    public boolean enableSingaporeFabApprover4{get;set;}
    public boolean enableSingaporeFabApprover5{get;set;}
    
    //to store system approver details
    public CuSR_Approval_Process__c maltaSystemOwnerApproval{get;set;}
    public List<wrapperApprover> maltaSystemOwnerApproverList{get;set;}
    //flag to show System Owner section
    public boolean showMaltaSystemOwner{get;set;}
    //boolean to enable approvers
    public boolean enableMaltaSystemApprover1{get;set;}
    public boolean enableMaltaSystemApprover2{get;set;}
    public boolean enableMaltaSystemApprover3{get;set;}
    public boolean enableMaltaSystemApprover4{get;set;}
    public boolean enableMaltaSystemApprover5{get;set;}
    
    ////to store Essex Junction common fab approver details
    public CuSR_Approval_Process__c essexJunctionSystemOwnerApproval{get;set;}
    public List<wrapperApprover> essexJunctionSystemOwnerApproverList{get;set;}
    //flag to show System Owner section
    public boolean showEssexJunctionSystemOwner{get;set;}
    //boolean to enable approvers
    public boolean enableEssexJunctionSystemApprover1{get;set;}
    public boolean enableEssexJunctionSystemApprover2{get;set;}
    public boolean enableEssexJunctionSystemApprover3{get;set;}
    public boolean enableEssexJunctionSystemApprover4{get;set;}
    public boolean enableEssexJunctionSystemApprover5{get;set;}
    
    ////to store East Fishkill common fab approver details
    public CuSR_Approval_Process__c eastFishkillSystemOwnerApproval{get;set;}
    public List<wrapperApprover> eastFishkillSystemOwnerApproverList{get;set;}
    //flag to show System Owner section
    public boolean showEastFishkillSystemOwner{get;set;}
    //boolean to enable approvers
    public boolean enableEastFishkillSystemApprover1{get;set;}
    public boolean enableEastFishkillSystemApprover2{get;set;}
    public boolean enableEastFishkillSystemApprover3{get;set;}
    public boolean enableEastFishkillSystemApprover4{get;set;}
    public boolean enableEastFishkillSystemApprover5{get;set;}
    
    ////to store ASIC common fab approver details
    public CuSR_Approval_Process__c asicSystemOwnerApproval{get;set;}
    public List<wrapperApprover> asicSystemOwnerApproverList{get;set;}
    //flag to show System Owner section
    public boolean showASICSystemOwner{get;set;}
    //boolean to enable approvers
    public boolean enableASICSystemApprover1{get;set;}
    public boolean enableASICSystemApprover2{get;set;}
    public boolean enableASICSystemApprover3{get;set;}
    public boolean enableASICSystemApprover4{get;set;}
    public boolean enableASICSystemApprover5{get;set;}
    
    
    //flags to enable sites in Approval tab
    public boolean showSingaporeSection{get;set;}
    public boolean showMaltaSection{get;set;}
    public boolean showEssexJunctionSection{get;set;}
    public boolean showEastFishkillSection{get;set;}
    public boolean showASICSection{get;set;}
    public boolean showDresdenSection{get;set;}
    
    //flag to display individual fab tables
    public boolean showFab1table{get;set;}
    // to hold Fab 1 Approvers
    public CuSR_Approval_Process__c fab1Approver{get;set;}
    public List<wrapperApprover> fab1ApproverList{get;set;}
    //String to hold Fab 1 Implementation Id
    public String fab1ImplementationId{get;set;}
    //boolean to enable Fab 1 approvers
    public boolean enableFab1Approver1{get;set;}
    public boolean enableFab1Approver2{get;set;}
    public boolean enableFab1Approver3{get;set;}
    public boolean enableFab1Approver4{get;set;}
    public boolean enableFab1Approver5{get;set;}
    
    //flag to display individual fab tables
    public boolean showFab2table{get;set;}
    // to hold Fab 2 Approvers
    public CuSR_Approval_Process__c fab2Approver{get;set;}
    public List<wrapperApprover> fab2ApproverList{get;set;}
    //String to hold Fab 2 Implementation Id
    public String fab2ImplementationId{get;set;}
    //boolean to enable Fab 2 approvers
    public boolean enableFab2Approver1{get;set;}
    public boolean enableFab2Approver2{get;set;}
    public boolean enableFab2Approver3{get;set;}
    public boolean enableFab2Approver4{get;set;}
    public boolean enableFab2Approver5{get;set;}
    
    //flag to display individual fab tables
    public boolean showFab3table{get;set;}
    //to hold Fab 2 Approvers
    public CuSR_Approval_Process__c fab3Approver{get;set;}
    public List<wrapperApprover> fab3ApproverList{get;set;}
    //String to hold Fab 2 Implementation Id
    public String fab3ImplementationId{get;set;}
    //boolean to enable Fab 3 approvers
    public boolean enableFab3Approver1{get;set;}
    public boolean enableFab3Approver2{get;set;}
    public boolean enableFab3Approver3{get;set;}
    public boolean enableFab3Approver4{get;set;}
    public boolean enableFab3Approver5{get;set;}
    
    //flag to display individual fab tables
    public boolean showFab3etable{get;set;}
    //to hold Fab 3e Approvers
    public CuSR_Approval_Process__c fab3eApprover{get;set;}
    public List<wrapperApprover> fab3eApproverList{get;set;}
    //String to hold Fab 3e Implementation Id
    public String fab3eImplementationId{get;set;}
    //boolean to enable Fab 3e approvers
    public boolean enableFab3eApprover1{get;set;}
    public boolean enableFab3eApprover2{get;set;}
    public boolean enableFab3eApprover3{get;set;}
    public boolean enableFab3eApprover4{get;set;}
    public boolean enableFab3eApprover5{get;set;}
    
    //flag to display individual fab tables
    public boolean showFab5table{get;set;}
    //to hold Fab 5 Approvers
    public CuSR_Approval_Process__c fab5Approver{get;set;}
    public List<wrapperApprover> fab5ApproverList{get;set;}
    //String to hold Fab 5 Implementation Id
    public String fab5ImplementationId{get;set;}
    //boolean to enable Fab 5 approvers
    public boolean enableFab5Approver1{get;set;}
    public boolean enableFab5Approver2{get;set;}
    public boolean enableFab5Approver3{get;set;}
    public boolean enableFab5Approver4{get;set;}
    public boolean enableFab5Approver5{get;set;}
    
    //flag to display individual fab tables
    public boolean showFab6table{get;set;}
    //to hold Fab 6 Approvers
    public CuSR_Approval_Process__c fab6Approver{get;set;}
    public List<wrapperApprover> fab6ApproverList{get;set;}
    //String to hold Fab 6 Implementation Id
    public String fab6ImplementationId{get;set;}
    //boolean to enable Fab 6 approvers
    public boolean enableFab6Approver1{get;set;}
    public boolean enableFab6Approver2{get;set;}
    public boolean enableFab6Approver3{get;set;}
    public boolean enableFab6Approver4{get;set;}
    public boolean enableFab6Approver5{get;set;}
    
    //flag to display individual fab tables
    public boolean showFab7table{get;set;}
    //to hold Fab 7 Approvers
    public CuSR_Approval_Process__c fab7Approver{get;set;}
    public List<wrapperApprover> fab7ApproverList{get;set;}
    //String to hold Fab 7 Implementation Id
    public String fab7ImplementationId{get;set;}
    //boolean to enable Fab 7 approvers
    public boolean enableFab7Approver1{get;set;}
    public boolean enableFab7Approver2{get;set;}
    public boolean enableFab7Approver3{get;set;}
    public boolean enableFab7Approver4{get;set;}
    public boolean enableFab7Approver5{get;set;}
    
    //flag to display individual fab tables
    public boolean showFab8table{get;set;}
    //to hold Fab 8 Approvers
    public CuSR_Approval_Process__c fab8Approver{get;set;}
    public List<wrapperApprover> fab8ApproverList{get;set;}
    //String to hold Fab 8 Implementation Id
    public String fab8ImplementationId{get;set;}
    //boolean to enable Fab 8 approvers
    public boolean enableFab8Approver1{get;set;}
    public boolean enableFab8Approver2{get;set;}
    public boolean enableFab8Approver3{get;set;}
    public boolean enableFab8Approver4{get;set;}
    public boolean enableFab8Approver5{get;set;}
    
    //flag to display individual fab tables
    public boolean showFab9table{get;set;}
    //to hold Fab 9 Approvers
    public CuSR_Approval_Process__c fab9Approver{get;set;}
    public List<wrapperApprover> fab9ApproverList{get;set;}
    //String to hold Fab 9 Implementation Id
    public String fab9ImplementationId{get;set;}
    //boolean to enable Fab 9 approvers
    public boolean enableFab9Approver1{get;set;}
    public boolean enableFab9Approver2{get;set;}
    public boolean enableFab9Approver3{get;set;}
    public boolean enableFab9Approver4{get;set;}
    public boolean enableFab9Approver5{get;set;}
    
    //flag to display individual fab tables
    public boolean showFab10table{get;set;}
    //to hold Fab 10 Approvers
    public CuSR_Approval_Process__c fab10Approver{get;set;}
    public List<wrapperApprover> fab10ApproverList{get;set;}
    //String to hold Fab 10 Implementation Id
    public String fab10ImplementationId{get;set;}
    //boolean to enable Fab 10 approvers
    public boolean enableFab10Approver1{get;set;}
    public boolean enableFab10Approver2{get;set;}
    public boolean enableFab10Approver3{get;set;}
    public boolean enableFab10Approver4{get;set;}
    public boolean enableFab10Approver5{get;set;}
    
    //flag to display individual fab tables
    public boolean showASICtable{get;set;}
    //to hold ASIC Approvers
    public CuSR_Approval_Process__c asicApprover{get;set;}
    public List<wrapperApprover> asicApproverList{get;set;}
    //String to hold ASIC Implementation Id
    public String asicImplementationId{get;set;}
    //boolean to enable ASIC approvers
    public boolean enableASICApprover1{get;set;}
    public boolean enableASICApprover2{get;set;}
    public boolean enableASICApprover3{get;set;}
    public boolean enableASICApprover4{get;set;}
    public boolean enableASICApprover5{get;set;}
    
    //flag to display PM tab
    public boolean showAMTab{get;set;}
    //to hold AM approver details
    public CuSR_Approval_Process__c amApprover{get;set;}
    public List<wrapperApprover> amApproverList{get;set;}
    
    
    //list of tasks related to CuSR record
    public List<CuSR_Implementation__c> implementationList{get;set;}
    //list of tasks for individual fabs
    public List<CuSR_Implementation__c> fab1TaskList{get;set;}
    public List<CuSR_Implementation__c> fab2TaskList{get;set;}
    public List<CuSR_Implementation__c> fab3TaskList{get;set;}
    public List<CuSR_Implementation__c> fab3eTaskList{get;set;}
    public List<CuSR_Implementation__c> fab5TaskList{get;set;}
    public List<CuSR_Implementation__c> fab6TaskList{get;set;}
    public List<CuSR_Implementation__c> fab7TaskList{get;set;}
    public List<CuSR_Implementation__c> fab8TaskList{get;set;}
    public List<CuSR_Implementation__c> fab9TaskList{get;set;}
    public List<CuSR_Implementation__c> fab10TaskList{get;set;}
    public List<CuSR_Implementation__c> asicTaskList{get;set;}
    
    public List<CuSR_Cost__c> dresdenCostList{get;set;}
    public boolean showDresdenCostTable{get;set;}
    public String dresdenCostRecordId{get;set;}
    
    //Cost for Singapore
    //public CuSR_Cost__c singaporeCost{get;set;}
    public List<CuSR_Cost__c> singaporeCostList{get;set;}
    public boolean showSingaporeCostTable{get;set;}
    public String singaporeCostRecordId{get;set;}
    
    //Cost for Malta
    //public CuSR_Cost__c maltaCost{get;set;}
    public List<CuSR_Cost__c> maltaCostList{get;set;}
    public boolean showMaltaCostTable{get;set;}
    public String maltaCostRecordId{get;set;}
    
    //Cost for Essex Junction
    //public CuSR_Cost__c essexJunctionCost{get;set;}
    public List<CuSR_Cost__c> essexJunctionCostList{get;set;}
    public boolean showEssexJunctionCostTable{get;set;}
    public String essexJunctionCostRecordId{get;set;}
    
    //Cost for East Fishkill
    //public CuSR_Cost__c eastFishkillCost{get;set;}
    public List<CuSR_Cost__c> eastFishkillCostList{get;set;}
    public boolean showEastFishkillCostTable{get;set;}
    public String eastFishkillCostRecordId{get;set;}
    
    //Cost for ASIC
    //public CuSR_Cost__c asicCost{get;set;}
    public List<CuSR_Cost__c> asicCostList{get;set;}
    public boolean showASICCostTable{get;set;}
    public String asicCostRecordId{get;set;}
    
    //List to get all CuSR Cost data
    public List<CuSR_Cost__c> costList{get;set;}
    
    
    //string to get fab from Dresden Cost tab
    public String singaporeSelectedFab{get;set;}
    
    //String to save the selected tab name
    public String selectedTabName{get;set;}
    
    //String to save the selected Dresden subtab name
    public String selectedDresdenSubTabName{get;set;}
    
    //String to save the selected Singapore subtab name
    public String selectedSingaporeSubTabName{get;set;}
    
    //String to save the selected Malta subtab name
    public String selectedMaltaSubTabName{get;set;}
    
    //String to save the selected Essex Junction subtab name
    public String selectedEssexJunctionSubTabName{get;set;}
    
    //String to save the selected East Fishkill subtab name
    public String selectedEastFishkillSubTabName{get;set;}
    
    //String to save the selected ASIC subtab name
    public String selectedASICSubTabName{get;set;}
    
    //boolean to display error messages on Dreden tab
    public boolean showDresdenErrorMessage{get;set;}
    //boolean to display error messages on Singapore tab
    public boolean showSingaporeErrorMessage{get;set;}
    //boolean to display error messages on Malta tab
    public boolean showMaltaErrorMessage{get;set;}
    //boolean to display error messages on Essex Junction tab
    public boolean showEssexJunctionErrorMessage{get;set;}
    //boolean to display error messages on East Fishkill tab
    public boolean showEastFishkillErrorMessage{get;set;}
    //boolean to display error messages on ASIC tab
    public boolean showASICErrorMessage{get;set;}
    
    public boolean showDresdenApprovalError{get;set;}
    public boolean showSingaporeApprovalError{get;set;}
    public boolean showMaltaApprovalError{get;set;}
    public boolean showEssexJunctionApprovalError{get;set;}
    public boolean showEastFishkillApprovalError{get;set;}
    public boolean showASICApprovalError{get;set;}
    
    public boolean validateFab1Approvers{get;set;}
    public boolean validateFab2Approvers{get;set;}
    public boolean validateFab3Approvers{get;set;}
    public boolean validateFab3eApprovers{get;set;}
    public boolean validateFab5approvers{get;set;}
    public boolean validateFab6Approvers{get;set;}
    public boolean validateFab7Approvers{get;set;}
    public boolean validateFab8Approvers{get;set;}
    public boolean validateFab9Approvers{get;set;}
    public boolean validateFab10Approvers{get;set;}
    public boolean validateASICApprovers{get;set;}
    
    public boolean validateDresdenSystemApprover{get;set;}
    public boolean validateSingaporeSystemApprover{get;set;}
    public boolean validateMaltaSystemApprover{get;set;}
    public boolean validateEssexJunctionSystemApprover{get;set;}
    public boolean validateEastFishkillSystemApprover{get;set;}
    public boolean validateASICSystemApprover{get;set;}
    
    public boolean validateSingaporeFabApprover{get;set;}
    
    //to hold current user
    public User loggedInUser{get;set;}
    
    //to hold current user's profile
    public Profile loggedInProfile{get;set;}
    
    public boolean accessToAddButtonOnCostAndImplementation{get;set;}
    public boolean cusrFormInitiator{get;set;}
    public boolean fab1CEUser{get;set;}
    public boolean fab2CEUser{get;set;}
    public boolean fab3CEUser{get;set;}
    public boolean fab3eCEUser{get;set;}
    public boolean fab5CEUser{get;set;}
    public boolean fab6CEUser{get;set;}
    public boolean fab7CEUser{get;set;}
    public boolean fab8CEUser{get;set;}
    public boolean fab9CEUser{get;set;}
    public boolean fab10CEUser{get;set;}
    public boolean asicCEUser{get;set;}
    public boolean afterImplmentationAccess{get;set;}
    public boolean afterImplementationAccessForSelectedCE{get;set;}
    public boolean afterImplementationVoidAccess{get;set;}
    public boolean pmUser{get;set;}
    public boolean isAMUser{get;set;}
    public boolean dresdenSytemOwnerApprover{get;set;}
    public boolean singaporeSytemOwnerApprover{get;set;}
    public boolean maltaSytemOwnerApprover{get;set;}
    public boolean essexJunctionSytemOwnerApprover{get;set;}
    public boolean eastFishkillSytemOwnerApprover{get;set;}
    public boolean asicSytemOwnerApprover{get;set;}
    
    public boolean fab1ApprovalUser{get;set;}
    public boolean fab2ApprovalUser{get;set;}
    public boolean fab3ApprovalUser{get;set;}
    public boolean fab3eApprovalUser{get;set;}
    public boolean fab5ApprovalUser{get;set;}
    public boolean fab6ApprovalUser{get;set;}
    public boolean fab7ApprovalUser{get;set;}
    public boolean fab8ApprovalUser{get;set;}
    public boolean fab9ApprovalUser{get;set;}
    public boolean fab10ApprovalUser{get;set;}
    public boolean asicApprovalUser{get;set;}
    public boolean fabApprovalUser{get;set;}
    
    public boolean pmErrorMessage{get;set;}
    
    //list to hold process values
    public List<Process__c> processList{get;set;}
    
    //For Technology
    public List<String> leftSelected{get;set;}
    public List<String> rightSelected{get;set;}
    public Set<string> leftvalues = new Set<string>();
    public Set<string> rightvalues = new Set<string>();
    public boolean showTechError{get;set;}
    
    //For Notification Group
    public List<String> leftSelectedUsers{get;set;}
    public List<String> rightSelectedUsers{get;set;}
    public Set<string> leftUserValues = new Set<string>();
    public Set<string> rightUserValues = new Set<string>();
    public String searchUser{get;set;}
    public Map<String,Id> rightUserMap{get;set;}
    public Map<String,Id> leftUserMap{get;set;}
    
    //List to get existing notification group members
    public List<CuSR_Notification_Group__c> cusrNotificationGroupList{get;set;}
    //String to hold id of Notification Group record
    public String memberId{get;set;}
    
    //To display additional Fab
    public boolean displayAdditionalFabMessage{get;set;}
    public boolean displayPendingAdditionalFabMessage{get;set;}
    public boolean displayApprovedAdditionalFabMessage{get;set;}
    
    public Group pmGroup{get;set;}
    
    public Map<String, CUSR_Tab_Id__c> cusrTabURLMap{get;set;}  
    
    public String cusrTabURL{get;set;}
    
    //Constructor
    public CuSRFormExtension(ApexPages.StandardController sc){
        showVoidHistory = false;
       //feedAttachmentList = new List<Attachment>{new Attachment()};
        showApproveReject = false;
        editOwner = false;
        cusrTabURLMap = CUSR_Tab_Id__c.getAll();
        cusrTabURL = cusrTabURLMap.get('CuSR Tab URL').Tab_URL__c;
        displayReceivedDatePopup = false;
        editForm = false;
        editFab = false;
        editFab1 = false;
        editFab2 = false;
        editFab3 = false;
        editFab3e = false;
        editFab5 = false;
        editFab6 = false;
        editFab7 = false;
        editFab8 = false;
        editFab9 = false;
        editFab10 = false;
        editASIC = false;
        showRaisedDateReasonField = false;
        leftSelectedUsers = new List<String>();
        rightSelectedUsers = new List<String>();
        rightUserMap = new Map<String,Id>();
        leftUserMap = new Map<String,Id>();
        showTechError = false;
        leftSelected = new List<String>();
        rightSelected = new List<String>();
        showAMTab = false;
        showDresdenErrorMessage= false;
        showSingaporeErrorMessage= false;
        showMaltaErrorMessage= false;
        showEssexJunctionErrorMessage = false;
        showEastFishkillErrorMessage = false;
        showASICErrorMessage = false;
        
        showDresdenCostTable = false;
        showSingaporeCostTable = false;
        showMaltaCostTable = false;
        showEssexJunctionCostTable = false;
        showEastFishkillCostTable = false;
        showASICCostTable = false;
        showScopeMessage = false;
        showDresdenSystemOwner= false;
        showSingaporeSystemOwner = false;
        showSingaporeFabOwner = false;
        showMaltaSystemOwner = false;
        showEssexJunctionSystemOwner = false;
        showEastFishkillSystemOwner = false;
        showASICSystemOwner = false;
        
        showSingaporeSection = false;
        showMaltaSection = false;
        showEssexJunctionSection = false;
        showEastFishkillSection = false;
        showASICSection = false;
        showDresdenSection = false;
        showFab1table = false;
        showFab2table = false;
        showFab3table = false;
        showFab3etable = false;
        showFab5table = false;
        showFab6table = false;
        showFab7table = false;
        showFab8table = false;
        showFab9table = false;
        showFab10table = false;
        showASICtable = false;
        enableDresdenSystemApprover1 = false;
        enableDresdenSystemApprover2 = false;
        enableDresdenSystemApprover3 = false;
        enableDresdenSystemApprover4 = false;
        enableDresdenSystemApprover5 = false;
        enableSingaporeSystemApprover1 = false;
        enableSingaporeSystemApprover2 = false;
        enableSingaporeSystemApprover3 = false;
        enableSingaporeSystemApprover4 = false;
        enableSingaporeSystemApprover5 = false;
        enableSingaporeFabApprover1 = false;
        enableSingaporeFabApprover2 = false;
        enableSingaporeFabApprover3 = false;
        enableSingaporeFabApprover4 = false;
        enableSingaporeFabApprover5 = false;
        enableMaltaSystemApprover1 = false;
        enableMaltaSystemApprover2 = false;
        enableMaltaSystemApprover3 = false;
        enableMaltaSystemApprover4 = false;
        enableMaltaSystemApprover5 = false;
        enableEssexJunctionSystemApprover1 = false;
        enableEssexJunctionSystemApprover2 = false;
        enableEssexJunctionSystemApprover3 = false;
        enableEssexJunctionSystemApprover4 = false;
        enableEssexJunctionSystemApprover5 = false;
        enableEastFishkillSystemApprover1 = false;
        enableEastFishkillSystemApprover2 = false;
        enableEastFishkillSystemApprover3 = false;
        enableEastFishkillSystemApprover4 = false;
        enableEastFishkillSystemApprover5 = false;
        enableASICSystemApprover1 = false;
        enableASICSystemApprover2 = false;
        enableASICSystemApprover3 = false;
        enableASICSystemApprover4 = false;
        enableASICSystemApprover5 = false;
        enableFab1Approver1 = false;
        enableFab1Approver2 = false;
        enableFab1Approver3 = false;
        enableFab1Approver4 = false;
        enableFab1Approver5 = false;
        enableFab2Approver1 = false;
        enableFab2Approver2 = false;
        enableFab2Approver3 = false;
        enableFab2Approver4 = false;
        enableFab2Approver5 = false;
        enableFab3Approver1 = false;
        enableFab3Approver2 = false;
        enableFab3Approver3 = false;
        enableFab3Approver4 = false;
        enableFab3Approver5 = false;
        enableFab3eApprover1 = false;
        enableFab3eApprover2 = false;
        enableFab3eApprover3 = false;
        enableFab3eApprover4 = false;
        enableFab3eApprover5 = false;
        enableFab5Approver1 = false;
        enableFab5Approver2 = false;
        enableFab5Approver3 = false;
        enableFab5Approver4 = false;
        enableFab5Approver5 = false;
        enableFab6Approver1 = false;
        enableFab6Approver2 = false;
        enableFab6Approver3 = false;
        enableFab6Approver4 = false;
        enableFab6Approver5 = false;
        enableFab7Approver1 = false;
        enableFab7Approver2 = false;
        enableFab7Approver3 = false;
        enableFab7Approver4 = false;
        enableFab7Approver5 = false;
        enableFab8Approver1 = false;
        enableFab8Approver2 = false;
        enableFab8Approver3 = false;
        enableFab8Approver4 = false;
        enableFab8Approver5 = false;
        enableFab9Approver1 = false;
        enableFab9Approver2 = false;
        enableFab9Approver3 = false;
        enableFab9Approver4 = false;
        enableFab9Approver5 = false;
        enableFab10Approver1 = false;
        enableFab10Approver2 = false;
        enableFab10Approver3 = false;
        enableFab10Approver4 = false;
        enableFab10Approver5 = false;
        
        enableASICApprover1 = false;
        enableASICApprover2 = false;
        enableASICApprover3 = false;
        enableASICApprover4 = false;
        enableASICApprover5 = false;
        
        cusrNotificationGroupList = new List<CuSR_Notification_Group__c>();
        sourceUrl = ApexPages.currentPage().getParameters().get('ReturnUrl');
        this.selectedTabName  = ApexPages.currentPage().getParameters().get('tabname'); 
        this.selectedDresdenSubTabName = ApexPages.currentPage().getParameters().get('dresdensubtabname');
        this.selectedSingaporeSubTabName = ApexPages.currentPage().getParameters().get('singaporesubtabname');
        this.selectedMaltaSubTabName = ApexPages.currentPage().getParameters().get('maltasubtabname');
        this.selectedEssexJunctionSubTabName = ApexPages.currentPage().getParameters().get('essexjunctionsubtabname');
        this.selectedEastFishkillSubTabName = ApexPages.currentPage().getParameters().get('eastfishkillsubtabname');
        this.selectedASICSubTabName = ApexPages.currentPage().getParameters().get('asicsubtabname');
        
        //String to store query to get current CuSR Form record
        String cusrFormQuery;
        
        //Instance of UtilClassToGetAllFields class to get all fields
        UtilClassToGetAllFields utilClass = new UtilClassToGetAllFields();
        
        //Calling method to get all fields from CuSR_Form__c and store on string
        String queryString = utilClass.getAllFields('CuSR_Form__c');
        system.debug('Fields are'+queryString);
        //pass the current record
        cusrForm=(CuSR_Form__c)sc.getRecord(); 
        //store the current record id
        recId = cusrForm.Id;
        //String to hold CuSR Form Approval Process fields
        String approverFields = utilClass.getAllFields('CuSR_Approval_Process__c');
        
        accessToAddButtonOnCostAndImplementation = false;
        cusrFormInitiator = false;
        fab1CEUser = false;
        fab2CEUser = false;
        fab3CEUser = false;
        fab3eCEUser = false;
        fab5CEUser = false;
        fab6CEUser = false;
        fab7CEUser = false;
        fab8CEUser = false;
        fab9CEUser = false;
        fab10CEUser = false;
        asicCEUser = false;
        afterImplmentationAccess = false;
        afterImplementationAccessForSelectedCE = false;
        afterImplementationVoidAccess = false;
        pmUser = false;
        isAMUser = false;
        dresdenSytemOwnerApprover = false;
        singaporeSytemOwnerApprover = false;
            maltaSytemOwnerApprover = false;
            essexJunctionSytemOwnerApprover = false;
            eastFishkillSytemOwnerApprover = false;
            asicSytemOwnerApprover = false;
            fab1ApprovalUser = false;
            fab2ApprovalUser = false;
            fab3ApprovalUser = false;
            fab3eApprovalUser = false;
            fab5ApprovalUser = false;
            fab6ApprovalUser = false;
            fab7ApprovalUser = false;
            fab8ApprovalUser = false;
            fab9ApprovalUser = false;
            fab10ApprovalUser = false;
            asicApprovalUser = false;
            fabApprovalUser = false;
        
        //check if it is edit mode for new record
        if(cusrForm !=null && recId != null){
                
            //query for current record
            cusrFormQuery = 'select '+queryString+' from CuSR_Form__c where Id = \''+recId+'\'';
            cusrForm = database.query(cusrFormQuery);
            if(cusrForm.Status__c == 'New' || cusrForm.Status__c == 'Rejected'){
                editForm = true;
            }
            if(cusrForm.Status__c == 'New' || cusrForm.Status__c == 'Implemented' || cusrForm.Status__c == 'Rejected'){
                editFab = true;
            }
            Date currentDate = Date.today();
                Date date2DaysBack = currentDate - 2;
                if(cusrForm.Request_Received_Date__c < date2DaysBack){
                        showRaisedDateReasonField = true;
                }
            if(cusrForm.Customer_Requestor__c != null){
                Contact c = [select Id, Name from Contact where Id = :cusrForm.Customer_Requestor__c];
                customerReqId = c.Id;
                customerReqName = c.Name; 
                //customerId = cusrForm.Customer_Name__c;  
            }    
            if(cusrForm.Customer_Name__c != null){
                customerId = cusrForm.Customer_Name__c;
            }
            cusrVoidHistoryList = new List<CuSR_Void_History__c>();
            String voidFields = utilClass.getAllFields('CuSR_Void_History__c');
            String voidQuery = 'select '+voidFields+' from CuSR_Void_History__c where CuSR_Form__c = \''+cusrForm.Id+'\' order by Voided_On__c DESC';
            cusrVoidHistoryList = Database.query(voidQuery);
            if(cusrVoidHistoryList.size()>0){
                showVoidHistory = true;
            }
            attachmentList = new List<Attachment>();
            String attachmentFields = utilClass.getAllFields('Attachment');
            String queryAttachment = 'select '+attachmentFields+'  from Attachment where ParentId = \''+cusrForm.Id+'\'';
            attachmentList = database.query(queryAttachment);
            //enableSites();
            //query string for CuSR Approval Process
            String approvalQuery = 'select '+approverFields+' from CuSR_Approval_Process__c where CuSR_Form__c = \''+cusrForm.Id+'\' order by CuSR_Form__c asc';
            cusrApproverList = Database.query(approvalQuery);
            dresdenSystemOwnerApproval= new CuSR_Approval_Process__c();
            singaporeSystemOwnerApproval= new CuSR_Approval_Process__c();
            singaporeFabOwnerApproval= new CuSR_Approval_Process__c();
            maltaSystemOwnerApproval= new CuSR_Approval_Process__c();
            essexJunctionSystemOwnerApproval= new CuSR_Approval_Process__c();
            eastFishkillSystemOwnerApproval= new CuSR_Approval_Process__c();
            asicSystemOwnerApproval= new CuSR_Approval_Process__c();
            fab1Approver = new CuSR_Approval_Process__c();
            fab2Approver = new CuSR_Approval_Process__c();
            fab3Approver = new CuSR_Approval_Process__c();
            fab3eApprover = new CuSR_Approval_Process__c();
            fab5Approver = new CuSR_Approval_Process__c();
            fab6Approver = new CuSR_Approval_Process__c();
            fab7Approver = new CuSR_Approval_Process__c();
            fab8Approver = new CuSR_Approval_Process__c();
            fab9Approver = new CuSR_Approval_Process__c();
            fab10Approver = new CuSR_Approval_Process__c();
            asicApprover = new CuSR_Approval_Process__c();
            amApprover = new CuSR_Approval_Process__c();
            costList = new List<CuSR_Cost__c>();
            dresdenCostList = new List<CuSR_Cost__c>();
            singaporeCostList = new List<CuSR_Cost__c>();
            maltaCostList = new List<CuSR_Cost__c>();
            essexJunctionCostList = new List<CuSR_Cost__c>();
            eastFishkillCostList = new List<CuSR_Cost__c>();
            asicCostList = new List<CuSR_Cost__c>();
            if(cusrApproverList.size() > 0){
                for(CuSR_Approval_Process__c cusrApprv : cusrApproverList){
                    if(cusrApprv.Type_of_Approver__c == 'System Owner' && cusrApprv.Site__c == 'Dresden'){
                        dresdenSystemOwnerApproval = cusrApprv;
                        if(dresdenSystemOwnerApproval.Status__c == 'Pending Approval'){
                                dresdenSystemOwnerApproverList = new List<wrapperApprover>();
                                for(ProcessInstanceWorkitem workItem: [select p.Id, p.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: dresdenSystemOwnerApproval.Id]){
                                        dresdenSystemOwnerApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                                }
                        }
                    }
                    if(cusrApprv.Type_of_Approver__c == 'System Owner' && cusrApprv.Site__c == 'Singapore'){
                        singaporeSystemOwnerApproval = cusrApprv;
                        if(singaporeSystemOwnerApproval.Status__c == 'Pending Approval'){
                                singaporeSystemOwnerApproverList = new List<wrapperApprover>();
                                for(ProcessInstanceWorkitem workItem: [select p.Id, p.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: singaporeSystemOwnerApproval.Id]){
                                        singaporeSystemOwnerApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                                }
                        }
                    }
                    if(cusrApprv.Type_of_Approver__c == 'System Owner' && cusrApprv.Site__c == 'Malta'){
                        maltaSystemOwnerApproval = cusrApprv;
                        if(maltaSystemOwnerApproval.Status__c == 'Pending Approval'){
                                maltaSystemOwnerApproverList = new List<wrapperApprover>();
                                for(ProcessInstanceWorkitem workItem: [select p.Id, p.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: maltaSystemOwnerApproval.Id]){
                                        maltaSystemOwnerApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                                }
                        }
                    }
                    if(cusrApprv.Type_of_Approver__c == 'System Owner' && cusrApprv.Site__c == 'Essex Junction'){
                        essexJunctionSystemOwnerApproval = cusrApprv;
                        if(essexJunctionSystemOwnerApproval.Status__c == 'Pending Approval'){
                                essexJunctionSystemOwnerApproverList = new List<wrapperApprover>();
                                for(ProcessInstanceWorkitem workItem: [select p.Id, p.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: essexJunctionSystemOwnerApproval.Id]){
                                        essexJunctionSystemOwnerApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                                }
                        }
                    }
                    if(cusrApprv.Type_of_Approver__c == 'System Owner' && cusrApprv.Site__c == 'East Fishkill'){
                        eastFishkillSystemOwnerApproval = cusrApprv;
                        if(eastFishkillSystemOwnerApproval.Status__c == 'Pending Approval'){
                                eastFishkillSystemOwnerApproverList = new List<wrapperApprover>();
                                for(ProcessInstanceWorkitem workItem: [select p.Id, p.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: eastFishkillSystemOwnerApproval.Id]){
                                        eastFishkillSystemOwnerApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                                }
                        }
                    }
                    if(cusrApprv.Type_of_Approver__c == 'System Owner' && cusrApprv.Site__c == 'ASIC'){
                        asicSystemOwnerApproval = cusrApprv;
                        if(asicSystemOwnerApproval.Status__c == 'Pending Approval'){
                                asicSystemOwnerApproverList = new List<wrapperApprover>();
                                for(ProcessInstanceWorkitem workItem: [select p.Id, p.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: asicSystemOwnerApproval.Id]){
                                        asicSystemOwnerApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                                }
                        }
                    }
                    if(cusrApprv.Type_of_Approver__c == 'FAB Owner'){
                        singaporeFabOwnerApproval = cusrApprv;
                        if(singaporeFabOwnerApproval.Status__c == 'Pending Approval'){
                                singaporeFabOwnerApproverList = new List<wrapperApprover>();
                                for(ProcessInstanceWorkitem workItem: [select p.Id, p.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: singaporeFabOwnerApproval.Id]){
                                        singaporeFabOwnerApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                                }
                        }
                    }
                    if(cusrApprv.Type_of_Approver__c == 'FAB 1 Owner'){
                        fab1Approver = cusrApprv;
                        if(fab1Approver.Status__c == 'Pending Approval'){
                                fab1ApproverList = new List<wrapperApprover>();
                                for(ProcessInstanceWorkitem workItem: [select p.Id, p.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: fab1Approver.Id]){
                                        fab1ApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                                }
                        }
                    }
                    if(cusrApprv.Type_of_Approver__c == 'FAB 2 Owner'){
                        fab2Approver = cusrApprv;
                        if(fab2Approver.Status__c == 'Pending Approval'){
                                fab2ApproverList = new List<wrapperApprover>();
                                for(ProcessInstanceWorkitem workItem: [select p.Id, p.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: fab2Approver.Id]){
                                        fab2ApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                                }
                        }
                    }
                    if(cusrApprv.Type_of_Approver__c == 'FAB 3 Owner'){
                        fab3Approver = cusrApprv;
                        if(fab3Approver.Status__c == 'Pending Approval'){
                                fab3ApproverList = new List<wrapperApprover>();
                                for(ProcessInstanceWorkitem workItem: [select p.Id, p.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: fab3Approver.Id]){
                                        fab3ApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                                }
                        }
                    }
                    if(cusrApprv.Type_of_Approver__c == 'FAB 3E Owner'){
                        fab3eApprover = cusrApprv;
                        if(fab3eApprover.Status__c == 'Pending Approval'){
                                fab3eApproverList = new List<wrapperApprover>();
                                for(ProcessInstanceWorkitem workItem: [select p.Id, p.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: fab3eApprover.Id]){
                                        fab3eApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                                }
                        }
                    }
                    if(cusrApprv.Type_of_Approver__c == 'FAB 5 Owner'){
                        fab5Approver = cusrApprv;
                        if(fab5Approver.Status__c == 'Pending Approval'){
                                fab5ApproverList = new List<wrapperApprover>();
                                for(ProcessInstanceWorkitem workItem: [select p.Id, p.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: fab5Approver.Id]){
                                        fab5ApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                                }
                        }
                    }
                    if(cusrApprv.Type_of_Approver__c == 'FAB 6 Owner'){
                        fab6Approver = cusrApprv;
                        if(fab6Approver.Status__c == 'Pending Approval'){
                                fab6ApproverList = new List<wrapperApprover>();
                                for(ProcessInstanceWorkitem workItem: [select p.Id, p.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: fab6Approver.Id]){
                                        fab6ApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                                }
                        }
                    }
                    if(cusrApprv.Type_of_Approver__c == 'FAB 7 Owner'){
                        fab7Approver = cusrApprv;
                        if(fab7Approver.Status__c == 'Pending Approval'){
                                fab7ApproverList = new List<wrapperApprover>();
                                for(ProcessInstanceWorkitem workItem: [select p.Id, p.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: fab7Approver.Id]){
                                        fab7ApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                                }
                        }
                    }
                    if(cusrApprv.Type_of_Approver__c == 'FAB 8 Owner'){
                        fab8Approver = cusrApprv;
                        if(fab8Approver.Status__c == 'Pending Approval'){
                                fab8ApproverList = new List<wrapperApprover>();
                                for(ProcessInstanceWorkitem workItem: [select p.Id, p.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: fab8Approver.Id]){
                                        fab8ApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                                }
                        }
                    }
                    if(cusrApprv.Type_of_Approver__c == 'FAB 9 Owner'){
                        fab9Approver = cusrApprv;
                        if(fab9Approver.Status__c == 'Pending Approval'){
                                fab9ApproverList = new List<wrapperApprover>();
                                for(ProcessInstanceWorkitem workItem: [select p.Id, p.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: fab9Approver.Id]){
                                        fab9ApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                                }
                        }
                    }
                    if(cusrApprv.Type_of_Approver__c == 'FAB 10 Owner'){
                        fab10Approver = cusrApprv;
                        if(fab10Approver.Status__c == 'Pending Approval'){
                                fab10ApproverList = new List<wrapperApprover>();
                                for(ProcessInstanceWorkitem workItem: [select p.Id, p.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: fab10Approver.Id]){
                                        fab10ApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                                }
                        }
                    }
                    if(cusrApprv.Type_of_Approver__c == 'ASIC Owner'){
                        asicApprover = cusrApprv;
                        if(asicApprover.Status__c == 'Pending Approval'){
                                asicApproverList = new List<wrapperApprover>();
                                for(ProcessInstanceWorkitem workItem: [select p.Id, p.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: asicApprover.Id]){
                                        asicApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                                }
                        }
                    }
                    if(cusrApprv.Type_of_Approver__c == 'AM'){
                        amApprover = cusrApprv;
                        if(amApprover.Status__c == 'Pending Approval'){
                                amApproverList = new List<wrapperApprover>();
                                for(ProcessInstanceWorkitem workItem: [select p.Id, p.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: amApprover.Id]){
                                        amApproverList.add(new wrapperApprover(workItem.Id, workItem.ActorId, 'Pending'));
                                }
                        }
                    }
                }
            }
            enableSites();
            individualFabApprovertoYes();
            retrieveSelectedTechnologies();
            getNotificationGroup();
            enableAMTab();
            showSystemOwnerListMethod();
            enableDresdenSystemOwnerApprovers();
            enableSingaporeSystemOwnerApprovers();
            enableMaltaSystemOwnerApprovers();
            enableEssexJunctionSystemOwnerApprovers();
            enableEastFishkillSystemOwnerApprovers();
            enableASICSystemOwnerApprovers();
            enableFab1OwnerApprovers();
            enableFab2OwnerApprovers();
            enableFab3OwnerApprovers();
            enableFab3eOwnerApprovers();
            enableFab5OwnerApprovers();
            enableFab6OwnerApprovers();
            enableFab7OwnerApprovers();
            enableFab8OwnerApprovers();
            enableFab9OwnerApprovers();
            enableFab10OwnerApprovers();
            enableASICOwnerApprovers();
            enableSingaporeFabOwnerApprovers();
            showSingaporeFabOwnerListMethod();
            //get implementation records
            String implementationFields = utilClass.getAllFields('CuSR_Implementation__c');
            String implemetationQuery = 'select '+implementationFields+' from CuSR_Implementation__c where CuSR_Form__c =\''+cusrForm.Id+'\'';
            implementationList = Database.query(implemetationQuery);
            segregateImplementationRecords();
            segregateCostRecords();
            if(dresdenCostList.size() > 0)
                showDresdenCostTable = true;
            if(singaporeCostList.size() > 0)
                showSingaporeCostTable = true;
            if(maltaCostList.size() > 0)
                showMaltaCostTable = true;
            if(essexJunctionCostList.size() > 0)
                showEssexJunctionCostTable = true;
            if(eastFishkillCostList.size() > 0)
                showEastFishkillCostTable = true;
            if(asicCostList.size() > 0)
                showASICCostTable = true;
            setCurrentUser();  
            displayAdditionalFabMessageMethod();
            displayPendingAdditionalFabOnMessage();
            displayApprovedAdditionalFabOnMessage();
            if(!(cusrForm.FAB_1_Void__c) && cusrForm.Status__c == 'New' || cusrForm.Status__c == 'Rejected' || (cusrForm.Status__c == 'Implemented' && cusrForm.Additional_FAB_1__c == false && (fab1Approver.Id == null || fab1Approver.Status__c == 'Rejected'))){
                editFab1 = true;
            }
            if(!(cusrForm.FAB_2_Void__c) && cusrForm.Status__c == 'New' || cusrForm.Status__c == 'Rejected' || (cusrForm.Status__c == 'Implemented' && cusrForm.Additional_FAB_2__c == false && (fab2Approver.Id == null || fab2Approver.Status__c == 'Rejected'))){
                editFab2 = true;
            }
            if(!(cusrForm.FAB_3_Void__c) && cusrForm.Status__c == 'New' || cusrForm.Status__c == 'Rejected' || (cusrForm.Status__c == 'Implemented' && cusrForm.Additional_FAB_3__c == false && (fab3Approver.Id == null || fab3Approver.Status__c == 'Rejected'))){
                editFab3 = true;
            }
            if(!(cusrForm.FAB_3E_Void__c) && cusrForm.Status__c == 'New' || cusrForm.Status__c == 'Rejected' || (cusrForm.Status__c == 'Implemented' && cusrForm.Additional_FAB_3E__c == false && (fab3eApprover.Id == null || fab3eApprover.Status__c == 'Rejected'))){
                editFab3e = true;
            }
            if(!(cusrForm.FAB_5_Void__c) && cusrForm.Status__c == 'New' || cusrForm.Status__c == 'Rejected' || (cusrForm.Status__c == 'Implemented' && cusrForm.Additional_FAB_5__c == false && (fab5Approver.Id == null || fab5Approver.Status__c == 'Rejected'))){
                editFab5 = true;
            }
            if(!(cusrForm.FAB_6_Void__c) && cusrForm.Status__c == 'New' || cusrForm.Status__c == 'Rejected' || (cusrForm.Status__c == 'Implemented' && cusrForm.Additional_FAB_6__c == false && (fab6Approver.Id == null || fab6Approver.Status__c == 'Rejected'))){
                editFab6 = true;
            }
            if(!(cusrForm.FAB_7_Void__c) && cusrForm.Status__c == 'New' || cusrForm.Status__c == 'Rejected' || (cusrForm.Status__c == 'Implemented' && cusrForm.Additional_FAB_7__c == false && (fab7Approver.Id == null || fab7Approver.Status__c == 'Rejected'))){
                editFab7 = true;
            }
            if(!(cusrForm.FAB_8_Void__c) && cusrForm.Status__c == 'New' || cusrForm.Status__c == 'Rejected' || (cusrForm.Status__c == 'Implemented' && cusrForm.Additional_FAB_8__c == false && (fab8Approver.Id == null || fab8Approver.Status__c == 'Rejected'))){
                editFab8 = true;
            }
            if(!(cusrForm.FAB_9_Void__c) && cusrForm.Status__c == 'New' || cusrForm.Status__c == 'Rejected' || (cusrForm.Status__c == 'Implemented' && cusrForm.Additional_FAB_9__c == false && (fab9Approver.Id == null || fab9Approver.Status__c == 'Rejected'))){
                editFab9 = true;
            }
            if(!(cusrForm.FAB_10_Void__c) && cusrForm.Status__c == 'New' || cusrForm.Status__c == 'Rejected' || (cusrForm.Status__c == 'Implemented' && cusrForm.Additional_FAB_10__c == false && (fab10Approver.Id == null || fab10Approver.Status__c == 'Rejected'))){
                editFab10 = true;
            }
            
            if(!(cusrForm.ASIC_Void__c) && cusrForm.Status__c == 'New' || cusrForm.Status__c == 'Rejected' || (cusrForm.Status__c == 'Implemented' && cusrForm.Additional_ASIC__c == false && (asicApprover.Id == null || asicApprover.Status__c == 'Rejected'))){
                editASIC = true;
            }
            contentDocumentList = new List<ContentDocumentLink>();
            contentDocumentList = [SELECT ContentDocument.LatestPublishedVersionId, ContentDocumentId, ContentDocument.Title, ContentDocument.ContentModifiedDate, ContentDocument.OwnerId FROM ContentDocumentLink WHERE LinkedEntityId =: cusrForm.Id order by ContentDocument.ContentModifiedDate desc];
            disableSingaporeForVoidMethod();
            
        }
        else{
            //instantiate CuSR Form
            cusrForm = new CuSR_Form__c();
            //instantiate user object
            currentUser = [select id, Department from User where Id=: userinfo.getUserId()];
            cusrForm.ownerId = currentUser.Id;
            cusrForm.Department__c = currentUser.Department;
            loggedInUser = [select Id, Name from User where Id =: userInfo.getUserId()];
            system.debug('Logged in user'+loggedInUser.Name);
            loggedInProfile = [select Id, Name from Profile where Id =: userInfo.getProfileId()];
            system.debug('Logged in profile'+loggedInProfile.Name);
            if(loggedInUser.Id == cusrForm.OwnerId || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                cusrFormInitiator = true;
            }
            editForm = true;
            editFab = true;
            editForm = true;
                editFab1 = true;
                editFab2 = true;
                editFab3 = true;
                editFab3e = true;
                editFab5 = true;
                editFab6 = true;
                editFab7 = true;
                editFab8 = true;
                editFab9 = true;
                editFab10 = true;
                editASIC = true;
            leftvalues.add('ALL TECHNOLOGIES');
        }
    }
    
    public void disableSingaporeForVoidMethod(){
      disableSingaporeForVoid = false;
      boolean disableFab2 = false;
      boolean disableFab3 = false;
      boolean disableFab3e = false;
      boolean disableFab5 = false;
      boolean disableFab6 = false;
      boolean disableFab7 = false;
      if((cusrForm.FAB_2__c && !(cusrForm.FAB_2_Void__c)) || (cusrForm.FAB_3__c && !(cusrForm.FAB_3_Void__c)) || (cusrForm.FAB_3E__c && !(cusrForm.FAB_3E_Void__c)) || (cusrForm.FAB_5__c && !(cusrForm.FAB_5_Void__c)) || (cusrForm.FAB_6__c && !(cusrForm.FAB_6_Void__c)) || (cusrForm.FAB_7__c && !(cusrForm.FAB_7_Void__c))){
        disableSingaporeForVoid = false;
      }
      else{
        disableSingaporeForVoid = true;
      }
      /*if(cusrForm.FAB_2_Void__c){
        disableFab2 = true;
      }
      if(cusrForm.FAB_3_Void__c){
        disableFab3 = true;
      }
      if(cusrForm.FAB_3E_Void__c){
        disableFab3e = true;
      }
      if(cusrForm.FAB_5_Void__c){
        disableFab5 = true;
      }
      if(cusrForm.FAB_6_Void__c){
        disableFab6 = true;
      }
      if(cusrForm.FAB_7_Void__c){
        disableFab7 = true;
      }
      if(disableFab2 && disableFab3 && disableFab3e && disableFab5 && disableFab6 && disableFab7){
        disableSingaporeForVoid = true;
      }*/
    }
    
    //method to make Individual Fab Approver field value Yes
    public void individualFabApprovertoYes(){
        displayIndividualFabOwnerField = true;
        integer fabCount = 0;
        if(cusrForm.FAB_2__c){
                fabCount++;
        }
        if(cusrForm.FAB_3__c){
                fabCount++;
        }
        if(cusrForm.FAB_3E__c){
                fabCount++;
        }
        if(cusrForm.FAB_5__c){
                fabCount++;
        }
        if(cusrForm.FAB_6__c){
                fabCount++;
        }
        if(cusrForm.FAB_7__c){
                fabCount++;
        }
        if(fabCount == 1){
                cusrForm.Singapore_Individual_Fab_Owner_Approval__c = 'Yes';
                displayIndividualFabOwnerField = false;
        }
    }
    
    //method to get Account Id
    public void retrieveAccountId(){
        if(cusrForm.Customer_Name__c != null){
            customerId = cusrForm.Customer_Name__c; 
        }else{
            customerId = '';
        }
    }
    
    //to display Additional Fab added message
    public void displayAdditionalFabMessageMethod(){
        displayAdditionalFabMessage = false;
        if((cusrForm.Additional_FAB_1__c || cusrForm.Additional_FAB_2__c || cusrForm.Additional_FAB_3__c || cusrForm.Additional_FAB_3E__c || cusrForm.Additional_FAB_5__c || cusrForm.Additional_FAB_6__c || cusrForm.Additional_FAB_7__c || cusrForm.Additional_FAB_8__c || cusrForm.Additional_FAB_9__c || cusrForm.Additional_FAB_10__c || cusrForm.Additional_ASIC__c) && cusrForm.Status__c != 'Void'){
                displayAdditionalFabMessage = true;
        }
    }
    
    //method to display pending additional FABs in message
    public void displayPendingAdditionalFabOnMessage(){
        additionalFAB1Pending = false;
        additionalFAB2Pending = false;
        additionalFAB3Pending = false;
        additionalFAB3EPending = false;
        additionalFAB5Pending = false;
        additionalFAB6Pending = false;
        additionalFAB7Pending = false;
        additionalFAB8Pending = false;
        additionalFAB9Pending = false;
        additionalFAB10Pending = false;
        additionalASICPending = false;
        displayPendingAdditionalFabMessage = false;
        
        if(cusrForm.Status__c != 'Void'){
          if(cusrForm.Additional_FAB_1__c == true && !(cusrForm.FAB_1_Void__c)){
                  if(fab1Approver.Status__c != 'Approved'){
                          displayPendingAdditionalFabMessage = true;
                          additionalFAB1Pending = true;
                  }
                  if(cusrForm.Dresden_System_Owner_Approval_Required__c == 'Yes' && dresdenSystemOwnerApproval.Status__c != 'Approved'){
                          displayPendingAdditionalFabMessage = true;
                          additionalFAB1Pending = true;
                  }
          }
          if(cusrForm.Additional_FAB_2__c == true && !(cusrForm.FAB_2_Void__c)){
                  if((cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' || cusrForm.Singapore_Individual_Fab_Owner_Approval__c == null) && fab2Approver.Status__c != 'Approved'){
                          displayPendingAdditionalFabMessage = true;
                          additionalFAB2Pending = true;
                  }
                  if((cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' || cusrForm.Singapore_Individual_Fab_Owner_Approval__c == null) && singaporeFabOwnerApproval.Status__c != 'Approved'){
                          additionalFAB2Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
                  if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'Yes' && singaporeSystemOwnerApproval.Status__c != 'Approved'){
                          additionalFAB2Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
          }
          if(cusrForm.Additional_FAB_3__c == true && !(cusrForm.FAB_3_Void__c)){
                  if((cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' || cusrForm.Singapore_Individual_Fab_Owner_Approval__c == null) && fab3Approver.Status__c != 'Approved'){
                          additionalFAB3Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
                  if((cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' || cusrForm.Singapore_Individual_Fab_Owner_Approval__c == null) && singaporeFabOwnerApproval.Status__c != 'Approved'){
                          additionalFAB3Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
                  if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'Yes' && singaporeSystemOwnerApproval.Status__c != 'Approved'){
                          additionalFAB3Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
          }
          if(cusrForm.Additional_FAB_3E__c == true && !(cusrForm.FAB_3E_Void__c)){
                  if((cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' || cusrForm.Singapore_Individual_Fab_Owner_Approval__c == null) && fab3eApprover.Status__c != 'Approved'){
                          additionalFAB3EPending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
                  if((cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' || cusrForm.Singapore_Individual_Fab_Owner_Approval__c == null) && singaporeFabOwnerApproval.Status__c != 'Approved'){
                          additionalFAB3EPending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
                  if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'Yes' && singaporeSystemOwnerApproval.Status__c != 'Approved'){
                          additionalFAB3EPending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
          }
          if(cusrForm.Additional_FAB_5__c == true && !(cusrForm.FAB_5_Void__c)){
                  if((cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' || cusrForm.Singapore_Individual_Fab_Owner_Approval__c == null) && fab5Approver.Status__c != 'Approved'){
                          additionalFAB5Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
                  if((cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' || cusrForm.Singapore_Individual_Fab_Owner_Approval__c == null) && singaporeFabOwnerApproval.Status__c != 'Approved'){
                          additionalFAB5Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
                  if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'Yes' && singaporeSystemOwnerApproval.Status__c != 'Approved'){
                          additionalFAB5Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
          }
          if(cusrForm.Additional_FAB_6__c == true && !(cusrForm.FAB_6_Void__c)){
                  if((cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' || cusrForm.Singapore_Individual_Fab_Owner_Approval__c == null) && fab6Approver.Status__c != 'Approved'){
                          additionalFAB6Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
                  if((cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' || cusrForm.Singapore_Individual_Fab_Owner_Approval__c == null) && singaporeFabOwnerApproval.Status__c != 'Approved'){
                          additionalFAB6Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
                  if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'Yes' && singaporeSystemOwnerApproval.Status__c != 'Approved'){
                          additionalFAB6Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
          }
          if(cusrForm.Additional_FAB_7__c == true && !(cusrForm.FAB_7_Void__c)){
                  if((cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' || cusrForm.Singapore_Individual_Fab_Owner_Approval__c == null) && fab7Approver.Status__c != 'Approved'){
                          additionalFAB7Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
                  if((cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' || cusrForm.Singapore_Individual_Fab_Owner_Approval__c == null) && singaporeFabOwnerApproval.Status__c != 'Approved'){
                          additionalFAB7Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
                  if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'Yes' && singaporeSystemOwnerApproval.Status__c != 'Approved'){
                          additionalFAB7Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
          }
          if(cusrForm.Additional_FAB_8__c == true && !(cusrForm.FAB_8_Void__c)){
                  if(fab8Approver.Status__c != 'Approved'){
                          additionalFAB8Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
                  if(cusrForm.Malta_System_Owner_Approval_Required__c == 'Yes' && maltaSystemOwnerApproval.Status__c != 'Approved'){
                          additionalFAB8Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
          }
          if(cusrForm.Additional_FAB_9__c == true && !(cusrForm.FAB_9_Void__c)){
                  if(fab9Approver.Status__c != 'Approved'){
                          additionalFAB9Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
                  if(cusrForm.Esx_Jun_System_Owner_Approval_Required__c == 'Yes' && essexJunctionSystemOwnerApproval.Status__c != 'Approved'){
                          additionalFAB9Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
          }
          if(cusrForm.Additional_FAB_10__c == true && !(cusrForm.FAB_10_Void__c)){
                  if(fab10Approver.Status__c != 'Approved'){
                          additionalFAB10Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
                  if(cusrForm.EastFishkillSystemOwnerApproval_Required__c == 'Yes' && eastFishkillSystemOwnerApproval.Status__c != 'Approved'){
                          additionalFAB10Pending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
          }
          
          if(cusrForm.Additional_ASIC__c == true && !(cusrForm.ASIC_Void__c)){
                  if(asicApprover.Status__c != 'Approved'){
                          additionalASICPending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
                  if(cusrForm.ASIC_System_Owner_Approval_Required__c == 'Yes' && asicSystemOwnerApproval.Status__c != 'Approved'){
                          additionalASICPending = true;
                          displayPendingAdditionalFabMessage = true;
                  }
          }
        }
    }
    
    //method to show approver additional fabs on messsage
    public void displayApprovedAdditionalFabOnMessage(){
        additionalFAB1Approved = false;
        additionalFAB2Approved = false;
        additionalFAB3Approved = false;
        additionalFAB3EApproved = false;
        additionalFAB5Approved = false;
        additionalFAB6Approved = false;
        additionalFAB7Approved = false;
        additionalFAB8Approved = false;
        additionalFAB9Approved = false;
        additionalFAB10Approved = false;
        additionalASICApproved = false;
        displayApprovedAdditionalFabMessage = false;
        
        if(cusrForm.Status__c != 'Void'){
          if(cusrForm.Additional_FAB_1__c){
                  if(cusrForm.Dresden_System_Owner_Approval_Required__c == 'No' && fab1Approver.Status__c == 'Approved'){
                          additionalFAB1Approved = true;
                          displayApprovedAdditionalFabMessage = true;
                  }
                  if(cusrForm.Dresden_System_Owner_Approval_Required__c == 'Yes' && dresdenSystemOwnerApproval.Status__c == 'Approve' && fab1Approver.Status__c == 'Approved'){
                          additionalFAB1Approved = true;
                          displayApprovedAdditionalFabMessage = true;
                  }
          }
          if(cusrForm.Additional_FAB_2__c){
                  if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'No'){
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' && singaporeFabOwnerApproval.Status__c == 'Approved'){
                                  additionalFAB2Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && fab2Approver.Status__c == 'Approved'){
                                  additionalFAB2Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                  }
                  if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'Yes'){
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' && singaporeSystemOwnerApproval.Status__c == 'Approved' && singaporeFabOwnerApproval.Status__c == 'Approved'){
                                  additionalFAB2Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && fab2Approver.Status__c == 'Approved' && singaporeSystemOwnerApproval.Status__c == 'Approved'){
                                  additionalFAB2Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                  }
          }
          if(cusrForm.Additional_FAB_3__c){
                  if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'No'){
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' && singaporeFabOwnerApproval.Status__c == 'Approved'){
                                  additionalFAB3Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && fab3Approver.Status__c == 'Approved'){
                                  additionalFAB3Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                  }
                  if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'Yes'){
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' && singaporeSystemOwnerApproval.Status__c == 'Approved' && singaporeFabOwnerApproval.Status__c == 'Approved'){
                                  additionalFAB3Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && fab3Approver.Status__c == 'Approved' && singaporeSystemOwnerApproval.Status__c == 'Approved'){
                                  additionalFAB3Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                  }
          }
          if(cusrForm.Additional_FAB_3E__c){
                  if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'No'){
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' && singaporeFabOwnerApproval.Status__c == 'Approved'){
                                  additionalFAB3EApproved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && fab3eApprover.Status__c == 'Approved'){
                                  additionalFAB3EApproved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                  }
                  if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'Yes'){
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' && singaporeSystemOwnerApproval.Status__c == 'Approved' && singaporeFabOwnerApproval.Status__c == 'Approved'){
                                  additionalFAB3EApproved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && fab3eApprover.Status__c == 'Approved' && singaporeSystemOwnerApproval.Status__c == 'Approved'){
                                  additionalFAB3EApproved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                  }
          }
          if(cusrForm.Additional_FAB_5__c){
                  if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'No'){
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' && singaporeFabOwnerApproval.Status__c == 'Approved'){
                                  additionalFAB5Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && fab5Approver.Status__c == 'Approved'){
                                  additionalFAB5Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                  }
                  if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'Yes'){
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' && singaporeSystemOwnerApproval.Status__c == 'Approved' && singaporeFabOwnerApproval.Status__c == 'Approved'){
                                  additionalFAB5Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && fab5Approver.Status__c == 'Approved' && singaporeSystemOwnerApproval.Status__c == 'Approved'){
                                  additionalFAB5Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                  }
          }
          if(cusrForm.Additional_FAB_6__c){
                  if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'No'){
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' && singaporeFabOwnerApproval.Status__c == 'Approved'){
                                  additionalFAB6Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && fab6Approver.Status__c == 'Approved'){
                                  additionalFAB6Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                  }
                  if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'Yes'){
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' && singaporeSystemOwnerApproval.Status__c == 'Approved' && singaporeFabOwnerApproval.Status__c == 'Approved'){
                                  additionalFAB6Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && fab6Approver.Status__c == 'Approved' && singaporeSystemOwnerApproval.Status__c == 'Approved'){
                                  additionalFAB6Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                  }
          }
          if(cusrForm.Additional_FAB_7__c){
                  if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'No'){
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' && singaporeFabOwnerApproval.Status__c == 'Approved'){
                                  additionalFAB7Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && fab7Approver.Status__c == 'Approved'){
                                  additionalFAB7Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                  }
                  if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'Yes'){
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' && singaporeSystemOwnerApproval.Status__c == 'Approved' && singaporeFabOwnerApproval.Status__c == 'Approved'){
                                  additionalFAB7Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                          if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && fab7Approver.Status__c == 'Approved' && singaporeSystemOwnerApproval.Status__c == 'Approved'){
                                  additionalFAB7Approved = true;
                                  displayApprovedAdditionalFabMessage = true;
                          }
                  }
          }
          if(cusrForm.Additional_FAB_8__c){
                  if(cusrForm.Malta_System_Owner_Approval_Required__c == 'No' && fab8Approver.Status__c == 'Approved'){
                          additionalFAB8Approved = true;
                          displayApprovedAdditionalFabMessage = true;
                  }
                  if(cusrForm.Malta_System_Owner_Approval_Required__c == 'Yes' && maltaSystemOwnerApproval.Status__c == 'Approve' && fab8Approver.Status__c == 'Approved'){
                          additionalFAB8Approved = true;
                          displayApprovedAdditionalFabMessage = true;
                  }
          }
          if(cusrForm.Additional_FAB_9__c){
                  if(cusrForm.Esx_Jun_System_Owner_Approval_Required__c == 'No' && fab9Approver.Status__c == 'Approved'){
                          additionalFAB9Approved = true;
                          displayApprovedAdditionalFabMessage = true;
                  }
                  if(cusrForm.Esx_Jun_System_Owner_Approval_Required__c == 'Yes' && essexJunctionSystemOwnerApproval.Status__c == 'Approve' && fab9Approver.Status__c == 'Approved'){
                          additionalFAB9Approved = true;
                          displayApprovedAdditionalFabMessage = true;
                  }
          }
          if(cusrForm.Additional_FAB_10__c){
                  if(cusrForm.EastFishkillSystemOwnerApproval_Required__c == 'No' && fab10Approver.Status__c == 'Approved'){
                          additionalFAB10Approved = true;
                          displayApprovedAdditionalFabMessage = true;
                  }
                  if(cusrForm.EastFishkillSystemOwnerApproval_Required__c == 'Yes' && eastFishkillSystemOwnerApproval.Status__c == 'Approve' && fab10Approver.Status__c == 'Approved'){
                          additionalFAB10Approved = true;
                          displayApprovedAdditionalFabMessage = true;
                  }
          }
          
          if(cusrForm.Additional_ASIC__c){
                  if(cusrForm.ASIC_System_Owner_Approval_Required__c == 'No' && asicApprover.Status__c == 'Approved'){
                          additionalASICApproved = true;
                          displayApprovedAdditionalFabMessage = true;
                  }
                  if(cusrForm.ASIC_System_Owner_Approval_Required__c == 'Yes' && asicSystemOwnerApproval.Status__c == 'Approve' && asicApprover.Status__c == 'Approved'){
                          additionalASICApproved = true;
                          displayApprovedAdditionalFabMessage = true;
                  }
          }
        }
    }
    
    //method to set user
    public void setCurrentUser(){
        
        loggedInUser = [select Id, Name from User where Id =: userInfo.getUserId()];
        system.debug('Logged in user'+loggedInUser.Name);
        loggedInProfile = [select Id, Name from Profile where Id =: userInfo.getProfileId()];
        system.debug('Logged in profile'+loggedInProfile.Name);
        if(loggedInUser.Id == cusrForm.OwnerId || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
            editOwner = true;
        }
        if(loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
            showApproveReject = true;
        }
        if((loggedInUser.Id == cusrForm.OwnerId || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers') && cusrForm.Status__c != 'Implemented'){
            cusrFormInitiator = true;
        }       
        System.debug('Is Initiator'+cusrFormInitiator);
        Account acc = new Account();
        List<Account_Team_Proxy__c> accProxy = new List<Account_Team_Proxy__c>();
        if(cusrForm.Customer_Name__c != null){
            acc = [select Id from Account where Id =: cusrForm.Customer_Name__c];
            accProxy = [select Id, User__c, Account__c, Team_Role__c, Fab_Assignment__c from Account_Team_Proxy__c where Account__c =: acc.Id and Team_Role__c =: 'Customer Engineer'];
        }
        /*acc = [select Id from Account where Id =: cusrForm.Customer_Name__c];
        List<Account_Team_Proxy__c> accProxy = new List<Account_Team_Proxy__c>();
        accProxy = [select Id, User__c, Account__c, Team_Role__c, Fab_Assignment__c from Account_Team_Proxy__c where Account__c =: acc.Id and Team_Role__c =: 'Customer Engineer'];*/
        if(!accProxy.isEmpty()){
            for(Account_Team_Proxy__c member: accProxy){
                    if((member.Fab_Assignment__c.contains('FAB 1') && member.User__c == loggedInUser.Id) || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab1CEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('FAB 2') && member.User__c == loggedInUser.Id) || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab2CEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('FAB 3') && member.User__c == loggedInUser.Id) || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab3CEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('FAB 3E') && member.User__c == loggedInUser.Id) || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab3eCEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('FAB 5') && member.User__c == loggedInUser.Id) || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab5CEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('FAB 6') && member.User__c == loggedInUser.Id) || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab6CEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('FAB 7') && member.User__c == loggedInUser.Id) || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab7CEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('FAB 8') && member.User__c == loggedInUser.Id) || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab8CEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('FAB 9') && member.User__c == loggedInUser.Id) || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab9CEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('FAB 10') && member.User__c == loggedInUser.Id) || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab10CEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('ASIC') && member.User__c == loggedInUser.Id) || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            asicCEUser = true;
                    }
                    if((cusrForm.Status__c == 'Implemented' || cusrForm.Status__c == 'Pending Implementation') && member.User__c == loggedInUser.Id && member.Team_Role__c == 'Customer Engineer'){
                            afterImplmentationAccess = true; 
                            if(member.Fab_Assignment__c.contains('FAB 1') && cusrForm.FAB_1__c == true){
                                afterImplementationAccessForSelectedCE = true;
                                if(fab1Approver.Status__c == 'Approved'){
                                    afterImplementationVoidAccess = true;
                                }
                            }
                            if(member.Fab_Assignment__c.contains('FAB 2') && cusrForm.FAB_2__c == true){
                                afterImplementationAccessForSelectedCE = true;
                                if(fab2Approver.Status__c == 'Approved'){
                                    afterImplementationVoidAccess = true;
                                }
                            }
                            if(member.Fab_Assignment__c.contains('FAB 3') && cusrForm.FAB_3__c == true){
                                afterImplementationAccessForSelectedCE = true;
                                if(fab3Approver.Status__c == 'Approved'){
                                    afterImplementationVoidAccess = true;
                                }
                            }
                            if(member.Fab_Assignment__c.contains('E') && cusrForm.FAB_3E__c == true){
                                afterImplementationAccessForSelectedCE = true;
                                if(fab3eApprover.Status__c == 'Approved'){
                                    afterImplementationVoidAccess = true;
                                }
                            }
                            if(member.Fab_Assignment__c.contains('FAB 5') && cusrForm.FAB_5__c == true){
                                afterImplementationAccessForSelectedCE = true;
                                if(fab5Approver.Status__c == 'Approved'){
                                    afterImplementationVoidAccess = true;
                                }
                            }
                            if(member.Fab_Assignment__c.contains('FAB 6') && cusrForm.FAB_6__c == true){
                                afterImplementationAccessForSelectedCE = true;
                                if(fab6Approver.Status__c == 'Approved'){
                                    afterImplementationVoidAccess = true;
                                }
                            }
                            if(member.Fab_Assignment__c.contains('FAB 7') && cusrForm.FAB_7__c == true){
                                afterImplementationAccessForSelectedCE = true;
                                if(fab7Approver.Status__c == 'Approved'){
                                    afterImplementationVoidAccess = true;
                                }
                            }
                            if(member.Fab_Assignment__c.contains('FAB 8') && cusrForm.FAB_8__c == true){
                                afterImplementationAccessForSelectedCE = true;
                                if(fab8Approver.Status__c == 'Approved'){
                                    afterImplementationVoidAccess = true;
                                }
                            }
                            if(member.Fab_Assignment__c.contains('FAB 9') && cusrForm.FAB_9__c == true){
                                afterImplementationAccessForSelectedCE = true;
                                if(fab9Approver.Status__c == 'Approved'){
                                    afterImplementationVoidAccess = true;
                                }
                            }
                            if(member.Fab_Assignment__c.contains('FAB 10') && cusrForm.FAB_10__c == true){
                                afterImplementationAccessForSelectedCE = true;
                                if(fab10Approver.Status__c == 'Approved'){
                                    afterImplementationVoidAccess = true;
                                }
                            }
                            
                            if(member.Fab_Assignment__c.contains('ASIC') && cusrForm.ASIC__c == true){
                                afterImplementationAccessForSelectedCE = true;
                                if(asicApprover.Status__c == 'Approved'){
                                    afterImplementationVoidAccess = true;
                                }
                            }
                    }
            }
        }
        if((loggedInUser.Id == cusrForm.OwnerId || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers') && cusrForm.Status__c == 'Implemented'){
                afterImplmentationAccess = true;
                afterImplementationAccessForSelectedCE = true;
                //afterImplementationVoidAccess = true;
        }
        if((loggedInUser.Id == cusrForm.OwnerId || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers') && (cusrForm.Status__c == 'Implemented' || cusrForm.Status__c == 'Pending Implementation')){
                afterImplementationVoidAccess = true;
        }
        Set<Id> userIds = new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        pmGroup = new Group();
        pmGroup = [select Type, Id, Name from Group where Type =: 'QUEUE' and Name ='CuSR PM Queue'];
        for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: pmGroup.Id]){
                if(((String)m.UserOrGroupId).startsWith(userType)){
                        userIds.add(m.UserOrGroupId);
                }
        }
        system.debug('Group User Ids are '+userIds);
        if(userIds.contains(loggedInUser.Id) || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                pmUser = true;
        }
        system.debug('Is PM User'+pmUser);
        
        List<Id> amUserIDs = new List<Id>();
        List<Id> dresdenSysUserId = new List<Id>();
        List<Id> singaporeSysUserId = new List<Id>();
        List<Id> maltaSysUserId = new List<Id>();
        List<Id> essexJunctionSysUserId = new List<Id>();
        List<Id> eastFishkillSysUserId = new List<Id>();
        List<Id> asicSysUserId = new List<Id>();
        List<Id> fab1UserIDs = new List<Id>();
        List<Id> fab2UserIDs = new List<Id>();
        List<Id> fab3UserIDs = new List<Id>();
        List<Id> fab3eUserIDs = new List<Id>();
        List<Id> fab5UserIDs = new List<Id>();
        List<Id> fab6UserIDs = new List<Id>();
        List<Id> fab7UserIDs = new List<Id>();
        List<Id> fab8UserIDs = new List<Id>();
        List<Id> fab9UserIDs = new List<Id>();
        List<Id> fab10UserIDs = new List<Id>();
        List<Id> asicUserIDs = new List<Id>();
        List<Id> fabUserIDs = new List<Id>();
        for(CuSR_Approval_Process__c approver: cusrApproverList){
                if(approver.Type_Of_Approver__c == 'AM'){
                        if(approver.Approver1__c != null){
                                amUserIDs.add(approver.Approver1__c);
                        }
                        if(approver.Approver2__c != null){
                                amUserIDs.add(approver.Approver2__c);
                        }
                        if(approver.Approver3__c != null){
                                amUserIDs.add(approver.Approver3__c);
                        }
                        if(approver.Approver4__c != null){
                                amUserIDs.add(approver.Approver4__c);
                        }
                        if(approver.Approver5__c != null){
                                amUserIDs.add(approver.Approver5__c);
                        }
                }
                if(approver.Type_of_Approver__c == 'System Owner' && approver.Site__c  == 'Dresden'){
                        if(approver.Approver1__c != null){
                                dresdenSysUserId.add(approver.Approver1__c);
                        }
                        if(approver.Approver2__c != null){
                                dresdenSysUserId.add(approver.Approver2__c);
                        }
                        if(approver.Approver3__c != null){
                                dresdenSysUserId.add(approver.Approver3__c);
                        }
                        if(approver.Approver4__c != null){
                                dresdenSysUserId.add(approver.Approver4__c);
                        }
                        if(approver.Approver5__c != null){
                                dresdenSysUserId.add(approver.Approver5__c);
                        }
                }
                if(approver.Type_of_Approver__c == 'System Owner' && approver.Site__c  == 'Singapore'){
                        if(approver.Approver1__c != null){
                                singaporeSysUserId.add(approver.Approver1__c);
                        }
                        if(approver.Approver2__c != null){
                                singaporeSysUserId.add(approver.Approver2__c);
                        }
                        if(approver.Approver3__c != null){
                                singaporeSysUserId.add(approver.Approver3__c);
                        }
                        if(approver.Approver4__c != null){
                                singaporeSysUserId.add(approver.Approver4__c);
                        }
                        if(approver.Approver5__c != null){
                                singaporeSysUserId.add(approver.Approver5__c);
                        }
                }
                if(approver.Type_of_Approver__c == 'System Owner' && approver.Site__c  == 'Malta'){
                        if(approver.Approver1__c != null){
                                maltaSysUserId.add(approver.Approver1__c);
                        }
                        if(approver.Approver2__c != null){
                                maltaSysUserId.add(approver.Approver2__c);
                        }
                        if(approver.Approver3__c != null){
                                maltaSysUserId.add(approver.Approver3__c);
                        }
                        if(approver.Approver4__c != null){
                                maltaSysUserId.add(approver.Approver4__c);
                        }
                        if(approver.Approver5__c != null){
                                maltaSysUserId.add(approver.Approver5__c);
                        }
                }
                if(approver.Type_of_Approver__c == 'System Owner' && approver.Site__c  == 'Essex Junction'){
                        if(approver.Approver1__c != null){
                                essexJunctionSysUserId.add(approver.Approver1__c);
                        }
                        if(approver.Approver2__c != null){
                                essexJunctionSysUserId.add(approver.Approver2__c);
                        }
                        if(approver.Approver3__c != null){
                                essexJunctionSysUserId.add(approver.Approver3__c);
                        }
                        if(approver.Approver4__c != null){
                                essexJunctionSysUserId.add(approver.Approver4__c);
                        }
                        if(approver.Approver5__c != null){
                                essexJunctionSysUserId.add(approver.Approver5__c);
                        }
                }
                if(approver.Type_of_Approver__c == 'System Owner' && approver.Site__c  == 'East Fishkill'){
                        if(approver.Approver1__c != null){
                                eastFishkillSysUserId.add(approver.Approver1__c);
                        }
                        if(approver.Approver2__c != null){
                                eastFishkillSysUserId.add(approver.Approver2__c);
                        }
                        if(approver.Approver3__c != null){
                                eastFishkillSysUserId.add(approver.Approver3__c);
                        }
                        if(approver.Approver4__c != null){
                                eastFishkillSysUserId.add(approver.Approver4__c);
                        }
                        if(approver.Approver5__c != null){
                                eastFishkillSysUserId.add(approver.Approver5__c);
                        }
                }
                if(approver.Type_of_Approver__c == 'System Owner' && approver.Site__c  == 'ASIC'){
                        if(approver.Approver1__c != null){
                                asicSysUserId.add(approver.Approver1__c);
                        }
                        if(approver.Approver2__c != null){
                                asicSysUserId.add(approver.Approver2__c);
                        }
                        if(approver.Approver3__c != null){
                                asicSysUserId.add(approver.Approver3__c);
                        }
                        if(approver.Approver4__c != null){
                                asicSysUserId.add(approver.Approver4__c);
                        }
                        if(approver.Approver5__c != null){
                                asicSysUserId.add(approver.Approver5__c);
                        }
                }
                if(approver.Type_of_Approver__c == 'FAB Owner' && approver.Site__c  == 'Singapore'){
                        if(approver.Approver1__c != null){
                                fabUserIDs.add(approver.Approver1__c);
                        }
                        if(approver.Approver2__c != null){
                                fabUserIDs.add(approver.Approver2__c);
                        }
                        if(approver.Approver3__c != null){
                                fabUserIDs.add(approver.Approver3__c);
                        }
                        if(approver.Approver4__c != null){
                                fabUserIDs.add(approver.Approver4__c);
                        }
                        if(approver.Approver5__c != null){
                                fabUserIDs.add(approver.Approver5__c);
                        }
                }
                if(approver.Type_of_Approver__c == 'FAB 1 Owner' && approver.Site__c  == 'Dresden'){
                        if(approver.Approver1__c != null){
                                fab1UserIDs.add(approver.Approver1__c);
                        }
                        if(approver.Approver2__c != null){
                                fab1UserIDs.add(approver.Approver2__c);
                        }
                        if(approver.Approver3__c != null){
                                fab1UserIDs.add(approver.Approver3__c);
                        }
                        if(approver.Approver4__c != null){
                                fab1UserIDs.add(approver.Approver4__c);
                        }
                        if(approver.Approver5__c != null){
                                fab1UserIDs.add(approver.Approver5__c);
                        }
                }
                if(approver.Type_of_Approver__c == 'FAB 2 Owner' && approver.Site__c  == 'Singapore'){
                        if(approver.Approver1__c != null){
                                fab2UserIDs.add(approver.Approver1__c);
                        }
                        if(approver.Approver2__c != null){
                                fab2UserIDs.add(approver.Approver2__c);
                        }
                        if(approver.Approver3__c != null){
                                fab2UserIDs.add(approver.Approver3__c);
                        }
                        if(approver.Approver4__c != null){
                                fab2UserIDs.add(approver.Approver4__c);
                        }
                        if(approver.Approver5__c != null){
                                fab2UserIDs.add(approver.Approver5__c);
                        }
                }
                if(approver.Type_of_Approver__c == 'FAB 3 Owner' && approver.Site__c  == 'Singapore'){
                        if(approver.Approver1__c != null){
                                fab3UserIDs.add(approver.Approver1__c);
                        }
                        if(approver.Approver2__c != null){
                                fab3UserIDs.add(approver.Approver2__c);
                        }
                        if(approver.Approver3__c != null){
                                fab3UserIDs.add(approver.Approver3__c);
                        }
                        if(approver.Approver4__c != null){
                                fab3UserIDs.add(approver.Approver4__c);
                        }
                        if(approver.Approver5__c != null){
                                fab3UserIDs.add(approver.Approver5__c);
                        }
                }
                if(approver.Type_of_Approver__c == 'FAB 3E Owner' && approver.Site__c  == 'Singapore'){
                        if(approver.Approver1__c != null){
                                fab3eUserIDs.add(approver.Approver1__c);
                        }
                        if(approver.Approver2__c != null){
                                fab3eUserIDs.add(approver.Approver2__c);
                        }
                        if(approver.Approver3__c != null){
                                fab3eUserIDs.add(approver.Approver3__c);
                        }
                        if(approver.Approver4__c != null){
                                fab3eUserIDs.add(approver.Approver4__c);
                        }
                        if(approver.Approver5__c != null){
                                fab3eUserIDs.add(approver.Approver5__c);
                        }
                }
                if(approver.Type_of_Approver__c == 'FAB 5 Owner' && approver.Site__c  == 'Singapore'){
                        if(approver.Approver1__c != null){
                                fab5UserIDs.add(approver.Approver1__c);
                        }
                        if(approver.Approver2__c != null){
                                fab5UserIDs.add(approver.Approver2__c);
                        }
                        if(approver.Approver3__c != null){
                                fab5UserIDs.add(approver.Approver3__c);
                        }
                        if(approver.Approver4__c != null){
                                fab5UserIDs.add(approver.Approver4__c);
                        }
                        if(approver.Approver5__c != null){
                                fab5UserIDs.add(approver.Approver5__c);
                        }
                }
                if(approver.Type_of_Approver__c == 'FAB 6 Owner' && approver.Site__c  == 'Singapore'){
                        if(approver.Approver1__c != null){
                                fab6UserIDs.add(approver.Approver1__c);
                        }
                        if(approver.Approver2__c != null){
                                fab6UserIDs.add(approver.Approver2__c);
                        }
                        if(approver.Approver3__c != null){
                                fab6UserIDs.add(approver.Approver3__c);
                        }
                        if(approver.Approver4__c != null){
                                fab6UserIDs.add(approver.Approver4__c);
                        }
                        if(approver.Approver5__c != null){
                                fab6UserIDs.add(approver.Approver5__c);
                        }
                }
                if(approver.Type_of_Approver__c == 'FAB 7 Owner' && approver.Site__c  == 'Singapore'){
                        if(approver.Approver1__c != null){
                                fab7UserIDs.add(approver.Approver1__c);
                        }
                        if(approver.Approver2__c != null){
                                fab7UserIDs.add(approver.Approver2__c);
                        }
                        if(approver.Approver3__c != null){
                                fab7UserIDs.add(approver.Approver3__c);
                        }
                        if(approver.Approver4__c != null){
                                fab7UserIDs.add(approver.Approver4__c);
                        }
                        if(approver.Approver5__c != null){
                                fab7UserIDs.add(approver.Approver5__c);
                        }
                }
                if(approver.Type_of_Approver__c == 'FAB 8 Owner' && approver.Site__c  == 'Malta'){
                        if(approver.Approver1__c != null){
                                fab8UserIDs.add(approver.Approver1__c);
                        }
                        if(approver.Approver2__c != null){
                                fab8UserIDs.add(approver.Approver2__c);
                        }
                        if(approver.Approver3__c != null){
                                fab8UserIDs.add(approver.Approver3__c);
                        }
                        if(approver.Approver4__c != null){
                                fab8UserIDs.add(approver.Approver4__c);
                        }
                        if(approver.Approver5__c != null){
                                fab8UserIDs.add(approver.Approver5__c);
                        }
                }
                if(approver.Type_of_Approver__c == 'FAB 9 Owner' && approver.Site__c  == 'Essex Junction'){
                        if(approver.Approver1__c != null){
                                fab9UserIDs.add(approver.Approver1__c);
                        }
                        if(approver.Approver2__c != null){
                                fab9UserIDs.add(approver.Approver2__c);
                        }
                        if(approver.Approver3__c != null){
                                fab9UserIDs.add(approver.Approver3__c);
                        }
                        if(approver.Approver4__c != null){
                                fab9UserIDs.add(approver.Approver4__c);
                        }
                        if(approver.Approver5__c != null){
                                fab9UserIDs.add(approver.Approver5__c);
                        }
                }
                if(approver.Type_of_Approver__c == 'FAB 10 Owner' && approver.Site__c  == 'East Fishkill'){
                        if(approver.Approver1__c != null){
                                fab10UserIDs.add(approver.Approver1__c);
                        }
                        if(approver.Approver2__c != null){
                                fab10UserIDs.add(approver.Approver2__c);
                        }
                        if(approver.Approver3__c != null){
                                fab10UserIDs.add(approver.Approver3__c);
                        }
                        if(approver.Approver4__c != null){
                                fab10UserIDs.add(approver.Approver4__c);
                        }
                        if(approver.Approver5__c != null){
                                fab10UserIDs.add(approver.Approver5__c);
                        }
                }
                if(approver.Type_of_Approver__c == 'ASIC Owner' && approver.Site__c  == 'ASIC'){
                        if(approver.Approver1__c != null){
                                asicUserIDs.add(approver.Approver1__c);
                        }
                        if(approver.Approver2__c != null){
                                asicUserIDs.add(approver.Approver2__c);
                        }
                        if(approver.Approver3__c != null){
                                asicUserIDs.add(approver.Approver3__c);
                        }
                        if(approver.Approver4__c != null){
                                asicUserIDs.add(approver.Approver4__c);
                        }
                        if(approver.Approver5__c != null){
                                asicUserIDs.add(approver.Approver5__c);
                        }
                }
        }
        if(!amUserIDs.isEmpty()){
                for(User am: [select Id from User where Id IN: amUserIDs]){
                        if(am.Id == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin'|| loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                                isAMUser = true;
                                system.debug('IS AM User');
                        }
                }
        }
        if(!dresdenSysUserId.isEmpty()){
                for(User u: [select Id from User where Id IN: dresdenSysUserId]){
                        if(u.Id == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                                dresdenSytemOwnerApprover = true;
                        }
                }
        }
        if(!singaporeSysUserId.isEmpty()){
                for(User u: [select Id from User where Id IN: singaporeSysUserId]){
                        if(u.Id == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                                singaporeSytemOwnerApprover = true;
                        }
                }
        }
        if(!maltaSysUserId.isEmpty()){
                for(User u: [select Id from User where Id IN: maltaSysUserId]){
                        if(u.Id == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                                maltaSytemOwnerApprover = true;
                        }
                }
        }
        if(!essexJunctionSysUserId.isEmpty()){
                for(User u: [select Id from User where Id IN: essexJunctionSysUserId]){
                        if(u.Id == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                                essexJunctionSytemOwnerApprover = true;
                        }
                }
        }
        if(!eastFishkillSysUserId.isEmpty()){
                for(User u: [select Id from User where Id IN: eastFishkillSysUserId]){
                        if(u.Id == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                                eastFishkillSytemOwnerApprover = true;
                        }
                }
        }
        if(!asicSysUserId.isEmpty()){
                for(User u: [select Id from User where Id IN: asicSysUserId]){
                        if(u.Id == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                                asicSytemOwnerApprover  = true;
                        }
                }
        }
        if(!fabUserIDs.isEmpty()){
                for(User u: [select Id from User where Id IN: fabUserIDs]){
                        if(u.Id == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                                fabApprovalUser = true;
                        }
                }
        }
        if(!fab1UserIDs.isEmpty()){
                for(User u: [select Id from User where Id IN: fab1UserIDs]){
                        if(u.Id == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                                fab1ApprovalUser = true;
                        }
                }
        }
        if(!fab2UserIDs.isEmpty()){
                for(User u: [select Id from User where Id IN: fab2UserIDs]){
                        if(u.Id == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                                fab2ApprovalUser = true;
                        }
                }
        }
        if(!fab3UserIDs.isEmpty()){
                for(User u: [select Id from User where Id IN: fab3UserIDs]){
                        if(u.Id == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                                fab3ApprovalUser = true;
                        }
                }
        }
        if(!fab3eUserIDs.isEmpty()){
                for(User u: [select Id from User where Id IN: fab3eUserIDs]){
                        if(u.Id == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                                fab3eApprovalUser = true;
                        }
                }
        }
        if(!fab5UserIDs.isEmpty()){
                for(User u: [select Id from User where Id IN: fab5UserIDs]){
                        if(u.Id == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                                fab5ApprovalUser = true;
                        }
                }
        }
        if(!fab6UserIDs.isEmpty()){
                for(User u: [select Id from User where Id IN: fab6UserIDs]){
                        if(u.Id == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                                fab6ApprovalUser = true;
                        }
                }
        }
        if(!fab7UserIDs.isEmpty()){
                for(User u: [select Id from User where Id IN: fab7UserIDs]){
                        if(u.Id == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                                fab7ApprovalUser = true;
                        }
                }
        }
        if(!fab8UserIDs.isEmpty()){
                for(User u: [select Id from User where Id IN: fab8UserIDs]){
                        if(u.Id == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                                fab8ApprovalUser = true;
                        }
                }
        }
        if(!fab9UserIDs.isEmpty()){
                for(User u: [select Id from User where Id IN: fab9UserIDs]){
                        if(u.Id == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                                fab9ApprovalUser = true;
                        }
                }
        }
        if(!fab10UserIDs.isEmpty()){
                for(User u: [select Id from User where Id IN: fab10UserIDs]){
                        if(u.Id == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                                fab10ApprovalUser = true;
                        }
                }
        }
        if(!asicUserIDs.isEmpty()){
                for(User u: [select Id from User where Id IN: asicUserIDs]){
                        if(u.Id == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                                asicApprovalUser = true;
                        }
                }
        }
        if(!accProxy.isEmpty()){
            for(Account_Team_Proxy__c member: accProxy){
                if(member.Fab_Assignment__c.contains('FAB 1') && cusrForm.FAB_1__c && member.User__c == loggedInUser.Id){
                    system.debug('Is FAB 1 CE');
                    accessToAddButtonOnCostAndImplementation = true;
                }
                if(member.Fab_Assignment__c.contains('FAB 2') && cusrForm.FAB_2__c && member.User__c == loggedInUser.Id){
                    system.debug('Is FAB 2 CE');
                    accessToAddButtonOnCostAndImplementation = true;
                }
                if(member.Fab_Assignment__c.contains('FAB 3') && cusrForm.FAB_3__c && member.User__c == loggedInUser.Id){
                    system.debug('Is FAB 3 CE');
                    accessToAddButtonOnCostAndImplementation = true;
                }
                if(member.Fab_Assignment__c.contains('E') && cusrForm.FAB_3E__c && member.User__c == loggedInUser.Id){
                    system.debug('Is FAB 4 CE');
                    accessToAddButtonOnCostAndImplementation = true;
                }
                if(member.Fab_Assignment__c.contains('FAB 5') && cusrForm.FAB_5__c && member.User__c == loggedInUser.Id){
                    system.debug('Is FAB 5 CE');
                    accessToAddButtonOnCostAndImplementation = true;
                }
                if(member.Fab_Assignment__c.contains('FAB 6') && cusrForm.FAB_6__c && member.User__c == loggedInUser.Id){
                    system.debug('Is FAB 6 CE');
                    accessToAddButtonOnCostAndImplementation = true;
                }
                if(member.Fab_Assignment__c.contains('FAB 7') && cusrForm.FAB_7__c && member.User__c == loggedInUser.Id){
                    system.debug('Is FAB 7 CE');
                    accessToAddButtonOnCostAndImplementation = true;
                }
                if(member.Fab_Assignment__c.contains('FAB 8') && cusrForm.FAB_8__c && member.User__c == loggedInUser.Id){
                    system.debug('Is FAB 8 CE');
                    accessToAddButtonOnCostAndImplementation = true;
                }
                if(member.Fab_Assignment__c.contains('FAB 9') && cusrForm.FAB_9__c && member.User__c == loggedInUser.Id){
                    system.debug('Is FAB 9 CE');
                    accessToAddButtonOnCostAndImplementation = true;
                }
                if(member.Fab_Assignment__c.contains('FAB 10') && cusrForm.FAB_10__c && member.User__c == loggedInUser.Id){
                    system.debug('Is FAB 10 CE');
                    accessToAddButtonOnCostAndImplementation = true;
                }
                if(member.Fab_Assignment__c.contains('ASIC') && cusrForm.ASIC__c && member.User__c == loggedInUser.Id){
                    system.debug('Is ASIC CE');
                    accessToAddButtonOnCostAndImplementation = true;
                }
            }
        }
        
        if(cusrFormInitiator || dresdenSytemOwnerApprover || singaporeSytemOwnerApprover || maltaSytemOwnerApprover || essexJunctionSytemOwnerApprover ||  eastFishkillSytemOwnerApprover || asicSytemOwnerApprover || fabApprovalUser || fab1ApprovalUser || fab2ApprovalUser || fab3ApprovalUser || fab3eApprovalUser || fab5ApprovalUser || fab6ApprovalUser || fab7ApprovalUser || fab8ApprovalUser || fab9ApprovalUser || fab10ApprovalUser ||  asicApprovalUser || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
            system.debug('Have access to Add button on Cost and Implementation tabs.');
            accessToAddButtonOnCostAndImplementation = true;
        }
    }
    
    //mthod to get Notification Group List
    public void getNotificationGroup(){
        UtilClassToGetAllFields utilClass = new UtilClassToGetAllFields();
        String notificationGroupFields = utilClass.getAllFields('CuSR_Notification_Group__c');
        String notificationGroupQuery = 'select '+notificationGroupFields+' from CuSR_Notification_Group__c where CuSR_Form__c = \''+cusrForm.Id+'\' order by User__c ASC';
        cusrNotificationGroupList = Database.query(notificationGroupQuery);
        if(!cusrNotificationGroupList.isEmpty()){
            for(CuSR_Notification_Group__c member: cusrNotificationGroupList){
                rightUserValues.add(member.User_Name__c);
                rightUserMap.put(member.User_Name__c, member.User__c);
            }
        }
    }
    
    
    //method to delete row from Notification Group List
    public void delRowFromNotificationGroupList(){
        try{
            Integer index = 0;
            for(CuSR_Notification_Group__c member: cusrNotificationGroupList){
                if(member.Id == memberId){
                    break;
                }
                index++;    
            } 
            cusrNotificationGroupList.remove(index);
            if(memberId == null){
                return;
            }
            delete [select Id from CuSR_Notification_Group__c where Id =: memberId];
        }
        catch(Exception e){
            
        }
    }
    
    public void deleteFeedAttachment(){
        try{
            Integer index=0;
            String contentDocId;
            for(ContentDocumentLink cont: contentDocumentList){
                if(cont.ContentDocumentId == contentId){
                    contentDocId = cont.ContentDocument.LatestPublishedVersionId;
                    break;
                }
                index++;
            }
            contentDocumentList.remove(index);
            if(contentId == null){
                return;
            }
            
            delete [select LatestPublishedVersionId from ContentDocument where LatestPublishedVersionId =: contentDocId];
        }
        catch(Exception e){
            
        }
    }
    
    //method to enable AM tab
    public void enableAMTab(){
        if(amApprover.Id != null){
            showAMTab = true;
            system.debug('AM Tab is enabled : '+showAMTab);
        }
    }
    
    //method to segregate Cost records
    public void segregateCostRecords(){
        UtilClassToGetAllFields utilClass = new UtilClassToGetAllFields();
        String costQueryFields = utilClass.getAllFields('CuSR_Cost__c');
        String costQueryString = 'select '+costQueryFields+' from CuSR_Cost__c where CuSR_Form__c = \''+cusrForm.Id+'\'';
        costList = Database.query(costQueryString);
        for(Cusr_Cost__c cost: costList){
            if(cost.Site__c == 'Dresden'){
                dresdenCostList.add(cost);
            }
            if(cost.Site__c == 'Singapore'){
                singaporeCostList.add(cost);
            }
            if(cost.Site__c == 'Malta'){
                maltaCostList.add(cost);
            }
            if(cost.Site__c == 'Essex Junction'){
                essexJunctionCostList.add(cost);
            }
            if(cost.Site__c == 'East Fishkill'){
                eastFishkillCostList.add(cost);
            }
            if(cost.Site__c == 'ASIC'){
                asicCostList.add(cost);
            }
        }
    }
    
    //method to segregate implementation records at fab level
    public void segregateImplementationRecords(){
        fab1TaskList = new List<CuSR_Implementation__c>();
        fab2TaskList = new List<CuSR_Implementation__c>();
        fab3eTaskList = new List<CuSR_Implementation__c>();
        fab3TaskList = new List<CuSR_Implementation__c>();
        fab5TaskList = new List<CuSR_Implementation__c>();
        fab6TaskList = new List<CuSR_Implementation__c>();
        fab7TaskList = new List<CuSR_Implementation__c>();
        fab8TaskList = new List<CuSR_Implementation__c>();
        fab9TaskList = new List<CuSR_Implementation__c>();
        fab10TaskList = new List<CuSR_Implementation__c>();
        asicTaskList = new List<CuSR_Implementation__c>();
        
        //fab1WrapperClass = new List<implementationWrapperClass>();
        
        if(implementationList != null){
            for(CuSR_Implementation__c implementation : implementationList){
                if(implementation.Fab__c == 'FAB 1'){
                    fab1TaskList.add(implementation);
                    //fab1WrapperClass.add(new implementationWrapperClass(implementation));
                }
                if(implementation.Fab__c == 'FAB 2'){
                    fab2TaskList.add(implementation);
                }
                if(implementation.Fab__c == 'FAB 3'){
                    fab3TaskList.add(implementation);
                }
                if(implementation.Fab__c == 'FAB 3E'){
                    fab3eTaskList.add(implementation);
                }
                if(implementation.Fab__c == 'FAB 5'){
                    fab5TaskList.add(implementation);
                }
                if(implementation.Fab__c == 'FAB 6'){
                    fab6TaskList.add(implementation);
                }
                if(implementation.Fab__c == 'FAB 7'){
                    fab7TaskList.add(implementation);
                }
                if(implementation.Fab__c == 'FAB 8'){
                    fab8TaskList.add(implementation);
                }
                if(implementation.Fab__c == 'FAB 9'){
                    fab9TaskList.add(implementation);
                }
                if(implementation.Fab__c == 'FAB 10'){
                    fab10TaskList.add(implementation);
                }
                if(implementation.Fab__c == 'ASIC'){
                    asicTaskList.add(implementation);
                }
            }
        }
    }
    
    
    //Method to enable fab site sections
    public void enableSites(){
        if(cusrForm.FAB_1_Void__c || cusrForm.FAB_1__c || (cusrForm.Status__c == 'Implemented' && (fab1Approver.Id != null || dresdenSystemOwnerApproval.Id != null))){
            showFab1table = true;
            showDresdenSection = true;
        }
       /* if(cusrForm.FAB_8_Void__c || cusrForm.FAB_8__c || (cusrForm.Status__c == 'Implemented' && (fab8Approver.Id != null || maltaSystemOwnerApproval.Id != null))){
            showFab8table = true;
            showMaltaSection = true;
        } */
        
        if(cusrForm.FAB_8_Void__c ||  cusrForm.FAB_8__c || (cusrForm.Status__c == 'Implemented' && (fab8Approver.Id != null || maltaSystemOwnerApproval.Id != null ))){
            
            showMaltaSection = true;
            
            if(cusrForm.FAB_8_Void__c || cusrForm.FAB_8__c || (cusrForm.Status__c == 'Implemented' && fab8Approver.Id != null))
                showFab8table = true;
        }
        
        if(cusrForm.FAB_9_Void__c || cusrForm.FAB_9__c || (cusrForm.Status__c == 'Implemented' && (fab9Approver.Id != null ||  essexJunctionSystemOwnerApproval.Id != null ))){
            
            showEssexJunctionSection = true;
            
            if(cusrForm.FAB_9_Void__c || cusrForm.FAB_9__c || (cusrForm.Status__c == 'Implemented' && fab9Approver.Id != null))
                showFab9table = true;
        }
        
        if(cusrForm.FAB_10_Void__c || cusrForm.FAB_10__c || (cusrForm.Status__c == 'Implemented' && (fab10Approver.Id != null ||  eastFishkillSystemOwnerApproval.Id != null ))){
            
            showEastFishkillSection = true;
            
            if(cusrForm.FAB_10_Void__c || cusrForm.FAB_10__c || (cusrForm.Status__c == 'Implemented' && fab10Approver.Id != null))
                showFab10table = true;
        }
        
        if(cusrForm.ASIC_Void__c || cusrForm.ASIC__c || (cusrForm.Status__c == 'Implemented' && (asicApprover.Id != null ||  asicSystemOwnerApproval.Id != null ))){
            
            showASICSection = true;
            
            if(cusrForm.ASIC_Void__c || cusrForm.ASIC__c || (cusrForm.Status__c == 'Implemented' && asicApprover.Id != null))
                showASICtable = true;
        }
        
        if(cusrForm.FAB_2_Void__c || cusrForm.FAB_3_Void__c || cusrForm.FAB_3E_Void__c || cusrForm.FAB_5_Void__c || cusrForm.FAB_6_Void__c || cusrForm.FAB_7_Void__c || cusrForm.FAB_2__c || cusrForm.FAB_3__c || cusrForm.FAB_3E__c || cusrForm.FAB_5__c || cusrForm.FAB_6__c || cusrForm.FAB_7__c || (cusrForm.Status__c == 'Implemented' && (fab2Approver.Id != null || fab3Approver.Id != null || fab3eApprover.Id != null || fab5Approver.Id != null || fab6Approver.Id != null || fab7Approver.Id != null || singaporeSystemOwnerApproval.Id != null || singaporeFabOwnerApproval.Id != null))){
            showSingaporeSection = true;
            if(cusrForm.FAB_2_Void__c || cusrForm.FAB_2__c || (cusrForm.Status__c == 'Implemented' && fab2Approver.Id != null))
                showFab2table = true;
            if(cusrForm.FAB_3_Void__c || cusrForm.FAB_3__c || (cusrForm.Status__c == 'Implemented' && fab3Approver.Id != null))
                showFab3table = true;
            if(cusrForm.FAB_3E_Void__c || cusrForm.FAB_3E__c || (cusrForm.Status__c == 'Implemented' && fab3eApprover.Id != null))
                showFab3etable = true;
            if(cusrForm.FAB_5_Void__c || cusrForm.FAB_5__c || (cusrForm.Status__c == 'Implemented' && fab5Approver.Id != null))
                showFab5table = true;
            if(cusrForm.FAB_6_Void__c || cusrForm.FAB_6__c || (cusrForm.Status__c == 'Implemented' && fab6Approver.Id != null))
                showFab6table = true;
            if(cusrForm.FAB_7_Void__c || cusrForm.FAB_7__c || (cusrForm.Status__c == 'Implemented' && fab7Approver.Id != null))
                showFab7table = true;    
        }    
    }
    
    //Method to save attachment
    /*public void saveAttachment(Id CuSRFormId){
        CuSR_Form__c cusr = new CuSR_Form__c();
        cusr = [select Id, Name from CuSR_Form__c where Id =: CuSRFormId];
        //List<FeedItem> toInsertList = new List<FeedItem>();
        try{
            for(Attachment attch: feedAttachmentList){
                if(cusr != null && attch.Body != null && attch.Name != null){
                    Feeditem post = new FeedItem();
                    post.ParentId = cusr.Id;
                    post.Body = 'New attachment added.';
                    post.ContentData = attch.Body;
                    post.ContentFileName = cusr.Name+'_'+attch.Name;
                    post.Title = cusr.Name+'_'+attch.Name;
                    attch = null;
                    //toInsertList.add(post);
                    insert post;
                }
            }
        }
        catch(Exception e){
            
        }
    }
    
    //method to add more attachments
    public void addMoreAttachment(){
        for (Integer idx=0; idx<NUM_ATTACHMENTS_TO_ADD; idx++){
            feedAttachmentList.add(new Attachment());
        }
    }*/
    
    //method to validate fields before save
    public void validateFieldsBeforeSave(){
        showFieldError = false;
        //showAttachmentError = false;
        fabCount = 0;
        validateFields = true;
        if(cusrForm.FAB_1__c){
            fabCount++;
        }
        if(cusrForm.FAB_2__c){
            fabCount++;
        }
        if(cusrForm.FAB_3__c){
            fabCount++;
        }
        if(cusrForm.FAB_3E__c){
            fabCount++;
        }
        if(cusrForm.FAB_5__c){
            fabCount++;
        }
        if(cusrForm.FAB_6__c){
            fabCount++;
        }
        if(cusrForm.FAB_7__c){
            fabCount++;
        }
        if(cusrForm.FAB_8__c){
            fabCount++;
        }
        if(cusrForm.FAB_9__c){
            fabCount++;
        }
        if(cusrForm.FAB_10__c){
            fabCount++;
        }
        if(cusrForm.ASIC__c){
            fabCount++;
        }
        if(fabCount == 0){
            showFieldError = true;
            validateFields = false;
            showScopeMessage = true;
        }
        if(rightvalues.isEmpty()){
                        showFieldError = true;
                showTechError = true;
                validateFields = false;
        }
        if(cusrForm.Scope_of_the_CuSR__c.contains('Others') && (cusrForm.If_Others__c == '' ||cusrForm.If_Others__c == null)){
                showFieldError = true;
            validateFields = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Other field cannot be blank if Scope is Others.'));    
            //cusrForm.If_Others__c.addError('Please mention if Scope is Others.');
        }
        if(cusrForm.Request_Received_Date__c == null){
                showFieldError = true;
            validateFields = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Request Received Date.'));
            //cusrForm.Request_Received_Date__c.addError('Please select a date.');
        }
        if(cusrForm.Customer_Name__c == null){
                showFieldError = true;
            validateFields = false;
            //cusrForm.Customer_Name__c.addError('Please select a customer.');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a customer.'));
        }
        /*if(customerReqName == '' || customerReqName == null){
            showFieldError = true;
            validateFields = false;
            //cusrForm.Customer_Requestor__c.addError('Please select a requestor.');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a Requestor.'));
        }*/
        if(cusrForm.Legacy__c == false && (customerReqId == null || customerReqId == '')){
            showFieldError = true;
            validateFields = false;
            //cusrForm.Customer_Requestor__c.addError('Please select a requestor.');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a Requestor.'));
        }
        if(cusrForm.Legacy__c == false && customerReqId != null && cusrForm.Customer_Requestor_Email__c == null){
                showFieldError = true;
            validateFields = false;
            //cusrForm.Customer_Requestor_Email__c.addError('Please enter an email address.');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Customer Requestor Email cannot be blank.'));
        }
        if(cusrForm.Notify_Customer_after_Implementation__c == null){
                showFieldError = true;
            validateFields = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Notify Customer After Implementation cannot be blank.'));
            //cusrForm.Notify_Customer_after_Implementation__c.addError('Please make a selection.');
        }
        if(cusrForm.Requested_Effective_Date__c == null){
                showFieldError = true;
            validateFields = false;
            //cusrForm.Requested_Effective_Date__c.addError('Please select a date.');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Request Effective Date cannot blank.'));
        }
        if(cusrForm.Validity_Period_of_this_Request__c == null){
                showFieldError = true;
            validateFields = false;
            //cusrForm.Validity_Period_of_this_Request__c.addError('Please make a selection.');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the Validity Period.'));
        }
        if(cusrForm.Validity_Period_of_this_Request__c != 'EOL' && cusrForm.Validity_Period__c == null){
                showFieldError = true;
            validateFields = false;
            //cusrForm.Validity_Period__c.addError('Please make a selection.');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Validity.'));
        }
        if(cusrForm.Actual_Requirement__c == null){
                showFieldError = true;
            validateFields = false;
            //cusrForm.Actual_Requirement__c.addError('Please fill in the requirement.');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Actual Requirement cannot be blank.'));
        }
        if(cusrForm.Justification_for_Request__c == null){
                showFieldError = true;
            validateFields = false;
            //cusrForm.Justification_for_Request__c.addError('Please fill in the justification for the request.');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Justification cannot be blank.'));
        }
        if(cusrForm.Scope_of_the_CuSR__c == null){
                showFieldError = true;
            validateFields = false;
            //cusrForm.Scope_of_the_CuSR__c.addError('Please select a scope.');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the Scope of the CUSR.'));
        }
        if(cusrForm.Is_this_a_one_time_requirement__c == 'No' && cusrForm.If_No_then_provide_details__c == null){
                showFieldError = true;
            validateFields = false;
            //cusrForm.If_No_then_provide_details__c.addError('Please fill in the details.');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter details if this is not a one time requirement.'));
        }
        if(cusrForm.Special_Requirement__c == null){
                showFieldError = true;
            validateFields = false;
            //cusrForm.Special_Requirement__c.addError('Please fill in the special requirement details.');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill in the special requirement details.'));
        }
        Date currentDate = Date.today();
        Date date2DaysBack = currentDate - 2;
       //case 47601
        if((cusrForm.Request_Received_Date__c < date2DaysBack) && (cusrForm.Reason__c == '' || cusrForm.Reason__c == null) && (cusrForm.Status__c == null || cusrForm.Status__c == '') && (cusrForm.Status__c != 'Implemented')){
            validateFields = false;
            showFieldError = true;
            showRaisedDateReasonField = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter reasons why this request is created after 2 days from the Received Date from the customer.'));
        }
        if((cusrForm.Request_Received_Date__c > currentDate ) && (cusrForm.Status__c == '' || cusrForm.Status__c == null)){
            validateFields = false;
            showFieldError = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Received Date cannot be greater that today.'));
        }
        if((cusrForm.Requested_Effective_Date__c < currentDate ) && (cusrForm.Status__c == '' || cusrForm.Status__c == null)){
            validateFields = false;
            showFieldError = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Requested Effective Date cannot be less that today.'));
        }
        /*if(validateFields == false && fileBody != null){
            fileBody = null;
            fileName = '';
            showAttachmentError = true;
        }*/
    }
    
    //method to validate Received Date
    public void validateRequestReceivedDate(){
        displayReceivedDatePopup = false;
        showRaisedDateReasonField = false;
        Date currentDate = Date.today();
        system.debug('Current Date is '+currentDate);
        Date date2DaysBack = currentDate - 2;
        system.debug('2 days back : '+date2DaysBack);
        if((cusrForm.Request_Received_Date__c < date2DaysBack) && (cusrForm.Status__c == null || cusrForm.Status__c == '' || cusrForm.Status__c == 'Implemented')){
                system.debug('Received Date validation error');
                displayReceivedDatePopup = true;
                showRaisedDateReasonField = true;
        }
    }
    
    public void closeReceivedDatePopup(){
        displayReceivedDatePopup = false;
    }
    
    //method for Cancel button on PM Tab
    public pageReference cancelPM(){
        pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrForm.Id);
        pgRef.getParameters().put('tabname','pm');
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    
    //method to save CuSR record
    public pageReference saveRecord(){
        //showAttachmentError = false;
        validateFieldsBeforeSave();
        if(!validateFields){
            return null;
        }
        else{
            if(cusrForm.Id == null){
                cusrForm.Status__c = 'New';
            }
            if(customerReqId != ''){
                Contact c = [select Id from Contact where Id =: customerReqId];
                cusrForm.Customer_Requestor__c = c.Id;
            }
            if(cusrForm.Status__c != 'Implemented'){
                cusrForm.Scope__c = saveSelectedScope();    
            }
            system.Debug('Final Scope is '+cusrForm.Scope__c);
            if(!rightvalues.isEmpty()){
                cusrForm.Technology__c = saveSelectedTechnologies();    
            }
            upsert cusrForm;
            saveNotificationGroup();
            pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrForm.Id);  
            pgRef.setRedirect(true);
            return pgRef;
        }
    }
    
    //method do save and naavigate to add attachment page
    /*public pageReference saveAndAddAttachments(){
      validateFieldsBeforeSave();
        if(!validateFields){
            return null;
        }
        else{
            if(cusrForm.Id == null){
                cusrForm.Status__c = 'New';
            }
            if(customerReqId != ''){
                Contact c = [select Id from Contact where Id =: customerReqId];
                cusrForm.Customer_Requestor__c = c.Id;
            }
            if(cusrForm.Status__c != 'Implemented'){
                cusrForm.Scope__c = saveSelectedScope();    
            }
            system.Debug('Final Scope is '+cusrForm.Scope__c);
            if(!rightvalues.isEmpty()){
                cusrForm.Technology__c = saveSelectedTechnologies();    
            }
            upsert cusrForm;
            saveNotificationGroup();
            pgRef = new pageReference('/apex/CuSRFormAttachmentPage?CuSRFormId='+cusrForm.Id);
            pgRef.setRedirect(true);
            return pgRef;
        }
    }*/
    
    //method to pass selected technologies
    public String saveSelectedTechnologies(){
        String techValues = '';
        for(String selectedTech: rightvalues){
                techValues += selectedTech+';';
        }
        techValues = techValues.subString(0,techValues.length()-1);
        return techValues;
    }
    
    //Method to cancel Edit
    public pageReference CancelAction(){
        if(sourceUrl != null){
            pgRef = new pageReference(sourceUrl);
        }
        else{
            pgRef = new pageReference('/'+cusrTabURL);
        }
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    //method to display system owner section
    public void showSystemOwnerListMethod(){
        if(cusrForm.Dresden_System_Owner_Approval_Required__c=='Yes'){
            showDresdenSystemOwner= true;
        }
        else{
            showDresdenSystemOwner= false;
        }
        if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'Yes'){
            showSingaporeSystemOwner= true;
        }
        else{
            showSingaporeSystemOwner= false;
        }
        if(cusrForm.Malta_System_Owner_Approval_Required__c == 'Yes'){
            showMaltaSystemOwner= true;
        }
        else{
            showMaltaSystemOwner= false;
        }
        
        if(cusrForm.Esx_Jun_System_Owner_Approval_Required__c == 'Yes'){
            showEssexJunctionSystemOwner= true;
        }
        else{
            showEssexJunctionSystemOwner= false;
        }
        
        if(cusrForm.EastFishkillSystemOwnerApproval_Required__c == 'Yes'){
            showEastFishkillSystemOwner= true;
        }
        else{
            showEastFishkillSystemOwner= false;
        }
        
        if(cusrForm.ASIC_System_Owner_Approval_Required__c == 'Yes'){
            showASICSystemOwner= true;
        }
        else{
            showASICSystemOwner= false;
        }
    }
    
    public void enableDresdenSystemOwnerApprovers(){
        if(dresdenSystemOwnerApproval.No_of_Approvers__c == '1'){
            enableDresdenSystemApprover1 = true;
            enableDresdenSystemApprover2 = false;
            enableDresdenSystemApprover3 = false;
            enableDresdenSystemApprover4 = false;
            enableDresdenSystemApprover5 = false;
        }
        if(dresdenSystemOwnerApproval.No_of_Approvers__c == '2'){
            enableDresdenSystemApprover1 = true;
            enableDresdenSystemApprover2 = true;
            enableDresdenSystemApprover3 = false;
            enableDresdenSystemApprover4 = false;
            enableDresdenSystemApprover5 = false;
        }
        if(dresdenSystemOwnerApproval.No_of_Approvers__c == '3'){
            enableDresdenSystemApprover1 = true;
            enableDresdenSystemApprover2 = true;
            enableDresdenSystemApprover3 = true;
            enableDresdenSystemApprover4 = false;
            enableDresdenSystemApprover5 = false;
        }
        if(dresdenSystemOwnerApproval.No_of_Approvers__c == '4'){
            enableDresdenSystemApprover1 = true;
            enableDresdenSystemApprover2 = true;
            enableDresdenSystemApprover3 = true;
            enableDresdenSystemApprover4 = true;
            enableDresdenSystemApprover5 = false;
        }
        if(dresdenSystemOwnerApproval.No_of_Approvers__c == '5'){
            enableDresdenSystemApprover1 = true;
            enableDresdenSystemApprover2 = true;
            enableDresdenSystemApprover3 = true;
            enableDresdenSystemApprover4 = true;
            enableDresdenSystemApprover5 = true;
        }
        if(dresdenSystemOwnerApproval.No_of_Approvers__c == ''){
            enableDresdenSystemApprover1 = false;
            enableDresdenSystemApprover2 = false;
            enableDresdenSystemApprover3 = false;
            enableDresdenSystemApprover4 = false;
            enableDresdenSystemApprover5 = false;
        }
    }
    
    public void enableSingaporeSystemOwnerApprovers(){
        if(singaporeSystemOwnerApproval.No_of_Approvers__c == '1'){
            enableSingaporeSystemApprover1 = true;
            enableSingaporeSystemApprover2 = false;
            enableSingaporeSystemApprover3 = false;
            enableSingaporeSystemApprover4 = false;
            enableSingaporeSystemApprover5 = false;
        }
        if(singaporeSystemOwnerApproval.No_of_Approvers__c == '2'){
            enableSingaporeSystemApprover1 = true;
            enableSingaporeSystemApprover2 = true;
            enableSingaporeSystemApprover3 = false;
            enableSingaporeSystemApprover4 = false;
            enableSingaporeSystemApprover5 = false;
        }
        if(singaporeSystemOwnerApproval.No_of_Approvers__c == '3'){
            enableSingaporeSystemApprover1 = true;
            enableSingaporeSystemApprover2 = true;
            enableSingaporeSystemApprover3 = true;
            enableSingaporeSystemApprover4 = false;
            enableSingaporeSystemApprover5 = false;
        }
        if(singaporeSystemOwnerApproval.No_of_Approvers__c == '4'){
            enableSingaporeSystemApprover1 = true;
            enableSingaporeSystemApprover2 = true;
            enableSingaporeSystemApprover3 = true;
            enableSingaporeSystemApprover4 = true;
            enableSingaporeSystemApprover5 = false;
        }
        if(singaporeSystemOwnerApproval.No_of_Approvers__c == '5'){
            enableSingaporeSystemApprover1 = true;
            enableSingaporeSystemApprover2 = true;
            enableSingaporeSystemApprover3 = true;
            enableSingaporeSystemApprover4 = true;
            enableSingaporeSystemApprover5 = true;
        }
        if(singaporeSystemOwnerApproval.No_of_Approvers__c == ''){
            enableSingaporeSystemApprover1 = false;
            enableSingaporeSystemApprover2 = false;
            enableSingaporeSystemApprover3 = false;
            enableSingaporeSystemApprover4 = false;
            enableSingaporeSystemApprover5 = false;
        }
    }
    
    public void enableMaltaSystemOwnerApprovers(){
        if(maltaSystemOwnerApproval.No_of_Approvers__c == '1'){
            enableMaltaSystemApprover1 = true;
            enableMaltaSystemApprover2 = false;
            enableMaltaSystemApprover3 = false;
            enableMaltaSystemApprover4 = false;
            enableMaltaSystemApprover5 = false;
        }
        if(maltaSystemOwnerApproval.No_of_Approvers__c == '2'){
            enableMaltaSystemApprover1 = true;
            enableMaltaSystemApprover2 = true;
            enableMaltaSystemApprover3 = false;
            enableMaltaSystemApprover4 = false;
            enableMaltaSystemApprover5 = false;
        }
        if(maltaSystemOwnerApproval.No_of_Approvers__c == '3'){
            enableMaltaSystemApprover1 = true;
            enableMaltaSystemApprover2 = true;
            enableMaltaSystemApprover3 = true;
            enableMaltaSystemApprover4 = false;
            enableMaltaSystemApprover5 = false;
        }
        if(maltaSystemOwnerApproval.No_of_Approvers__c == '4'){
            enableMaltaSystemApprover1 = true;
            enableMaltaSystemApprover2 = true;
            enableMaltaSystemApprover3 = true;
            enableMaltaSystemApprover4 = true;
            enableMaltaSystemApprover5 = false;
        }
        if(maltaSystemOwnerApproval.No_of_Approvers__c == '5'){
            enableMaltaSystemApprover1 = true;
            enableMaltaSystemApprover2 = true;
            enableMaltaSystemApprover3 = true;
            enableMaltaSystemApprover4 = true;
            enableMaltaSystemApprover5 = true;
        }
        if(maltaSystemOwnerApproval.No_of_Approvers__c == ''){
            enableMaltaSystemApprover1 = false;
            enableMaltaSystemApprover2 = false;
            enableMaltaSystemApprover3 = false;
            enableMaltaSystemApprover4 = false;
            enableMaltaSystemApprover5 = false;
        }
    }
    
    public void enableEssexJunctionSystemOwnerApprovers(){
        if(essexJunctionSystemOwnerApproval.No_of_Approvers__c == '1'){
            enableEssexJunctionSystemApprover1 = true;
            enableEssexJunctionSystemApprover2 = false;
            enableEssexJunctionSystemApprover3 = false;
            enableEssexJunctionSystemApprover4 = false;
            enableEssexJunctionSystemApprover5 = false;
        }
        if(essexJunctionSystemOwnerApproval.No_of_Approvers__c == '2'){
            enableEssexJunctionSystemApprover1 = true;
            enableEssexJunctionSystemApprover2 = true;
            enableEssexJunctionSystemApprover3 = false;
            enableEssexJunctionSystemApprover4 = false;
            enableEssexJunctionSystemApprover5 = false;
        }
        if(essexJunctionSystemOwnerApproval.No_of_Approvers__c == '3'){
            enableEssexJunctionSystemApprover1 = true;
            enableEssexJunctionSystemApprover2 = true;
            enableEssexJunctionSystemApprover3 = true;
            enableEssexJunctionSystemApprover4 = false;
            enableEssexJunctionSystemApprover5 = false;
        }
        if(essexJunctionSystemOwnerApproval.No_of_Approvers__c == '4'){
            enableEssexJunctionSystemApprover1 = true;
            enableEssexJunctionSystemApprover2 = true;
            enableEssexJunctionSystemApprover3 = true;
            enableEssexJunctionSystemApprover4 = true;
            enableEssexJunctionSystemApprover5 = false;
        }
        if(essexJunctionSystemOwnerApproval.No_of_Approvers__c == '5'){
            enableEssexJunctionSystemApprover1 = true;
            enableEssexJunctionSystemApprover2 = true;
            enableEssexJunctionSystemApprover3 = true;
            enableEssexJunctionSystemApprover4 = true;
            enableEssexJunctionSystemApprover5 = true;
        }
        if(essexJunctionSystemOwnerApproval.No_of_Approvers__c == ''){
            enableEssexJunctionSystemApprover1 = false;
            enableEssexJunctionSystemApprover2 = false;
            enableEssexJunctionSystemApprover3 = false;
            enableEssexJunctionSystemApprover4 = false;
            enableEssexJunctionSystemApprover5 = false;
        }
    }
    
    public void enableEastFishkillSystemOwnerApprovers(){
        if(eastFishkillSystemOwnerApproval.No_of_Approvers__c == '1'){
            enableEastFishkillSystemApprover1 = true;
            enableEastFishkillSystemApprover2 = false;
            enableEastFishkillSystemApprover3 = false;
            enableEastFishkillSystemApprover4 = false;
            enableEastFishkillSystemApprover5 = false;
        }
        if(eastFishkillSystemOwnerApproval.No_of_Approvers__c == '2'){
            enableEastFishkillSystemApprover1 = true;
            enableEastFishkillSystemApprover2 = true;
            enableEastFishkillSystemApprover3 = false;
            enableEastFishkillSystemApprover4 = false;
            enableEastFishkillSystemApprover5 = false;
        }
        if(eastFishkillSystemOwnerApproval.No_of_Approvers__c == '3'){
            enableEastFishkillSystemApprover1 = true;
            enableEastFishkillSystemApprover2 = true;
            enableEastFishkillSystemApprover3 = true;
            enableEastFishkillSystemApprover4 = false;
            enableEastFishkillSystemApprover5 = false;
        }
        if(eastFishkillSystemOwnerApproval.No_of_Approvers__c == '4'){
            enableEastFishkillSystemApprover1 = true;
            enableEastFishkillSystemApprover2 = true;
            enableEastFishkillSystemApprover3 = true;
            enableEastFishkillSystemApprover4 = true;
            enableEastFishkillSystemApprover5 = false;
        }
        if(eastFishkillSystemOwnerApproval.No_of_Approvers__c == '5'){
            enableEastFishkillSystemApprover1 = true;
            enableEastFishkillSystemApprover2 = true;
            enableEastFishkillSystemApprover3 = true;
            enableEastFishkillSystemApprover4 = true;
            enableEastFishkillSystemApprover5 = true;
        }
        if(eastFishkillSystemOwnerApproval.No_of_Approvers__c == ''){
            enableEastFishkillSystemApprover1 = false;
            enableEastFishkillSystemApprover2 = false;
            enableEastFishkillSystemApprover3 = false;
            enableEastFishkillSystemApprover4 = false;
            enableEastFishkillSystemApprover5 = false;
        }
    }
    
    public void enableASICSystemOwnerApprovers(){
        if(asicSystemOwnerApproval.No_of_Approvers__c == '1'){
            enableASICSystemApprover1 = true;
            enableASICSystemApprover2 = false;
            enableASICSystemApprover3 = false;
            enableASICSystemApprover4 = false;
            enableASICSystemApprover5 = false;
        }
        if(asicSystemOwnerApproval.No_of_Approvers__c == '2'){
            enableASICSystemApprover1 = true;
            enableASICSystemApprover2 = true;
            enableASICSystemApprover3 = false;
            enableASICSystemApprover4 = false;
            enableASICSystemApprover5 = false;
        }
        if(asicSystemOwnerApproval.No_of_Approvers__c == '3'){
            enableASICSystemApprover1 = true;
            enableASICSystemApprover2 = true;
            enableASICSystemApprover3 = true;
            enableASICSystemApprover4 = false;
            enableASICSystemApprover5 = false;
        }
        if(asicSystemOwnerApproval.No_of_Approvers__c == '4'){
            enableASICSystemApprover1 = true;
            enableASICSystemApprover2 = true;
            enableASICSystemApprover3 = true;
            enableASICSystemApprover4 = true;
            enableASICSystemApprover5 = false;
        }
        if(asicSystemOwnerApproval.No_of_Approvers__c == '5'){
            enableASICSystemApprover1 = true;
            enableASICSystemApprover2 = true;
            enableASICSystemApprover3 = true;
            enableASICSystemApprover4 = true;
            enableASICSystemApprover5 = true;
        }
        if(asicSystemOwnerApproval.No_of_Approvers__c == ''){
            enableASICSystemApprover1 = false;
            enableASICSystemApprover2 = false;
            enableASICSystemApprover3 = false;
            enableASICSystemApprover4 = false;
            enableASICSystemApprover5 = false;
        }
    }
    
    public void saveDresdenSystemOwnerApprovers(){
        if(dresdenSystemOwnerApproval.Id == null && (dresdenSystemOwnerApproval.Approver1__c != null || dresdenSystemOwnerApproval.Approver2__c != null || dresdenSystemOwnerApproval.Approver3__c != null || dresdenSystemOwnerApproval.Approver4__c != null || dresdenSystemOwnerApproval.Approver5__c != null)){
                dresdenSystemOwnerApproval.CuSR_Form__c = cusrForm.Id;
            dresdenSystemOwnerApproval.Status__c = 'New';
            dresdenSystemOwnerApproval.Type_of_Approver__c = 'System Owner';   
            dresdenSystemOwnerApproval.Site__c = 'Dresden';
            insert dresdenSystemOwnerApproval;
        }
        else if(dresdenSystemOwnerApproval.id != null){
            upsert dresdenSystemOwnerApproval;
        }
        else{
            return;
        }
    }
    
    public void saveSingaporeSystemOwnerApprovers(){
        if(singaporeSystemOwnerApproval.Id == null && (singaporeSystemOwnerApproval.Approver1__c != null || singaporeSystemOwnerApproval.Approver2__c != null || singaporeSystemOwnerApproval.Approver3__c != null || singaporeSystemOwnerApproval.Approver4__c != null || singaporeSystemOwnerApproval.Approver5__c != null)){
            singaporeSystemOwnerApproval.CuSR_Form__c = cusrForm.Id;
            singaporeSystemOwnerApproval.Status__c = 'New';
            singaporeSystemOwnerApproval.Type_of_Approver__c = 'System Owner';   
            singaporeSystemOwnerApproval.Site__c = 'Singapore';
            insert singaporeSystemOwnerApproval;
        }
        else if(singaporeSystemOwnerApproval.Id != null){
            system.debug('Singapore System Owner updated.');
            update singaporeSystemOwnerApproval;
        }
        else{
            return;
        }
    }
    
    public void saveMaltaSystemOwnerApprovers(){
        if(maltaSystemOwnerApproval.Id == null && (maltaSystemOwnerApproval.Approver1__c != null || maltaSystemOwnerApproval.Approver2__c != null || maltaSystemOwnerApproval.Approver3__c != null || maltaSystemOwnerApproval.Approver4__c != null || maltaSystemOwnerApproval.Approver5__c != null)){
            maltaSystemOwnerApproval.CuSR_Form__c = cusrForm.Id;
            maltaSystemOwnerApproval.Status__c = 'New';
            maltaSystemOwnerApproval.Type_of_Approver__c = 'System Owner';   
            maltaSystemOwnerApproval.Site__c = 'Malta';
            insert maltaSystemOwnerApproval;
        }
        else if(maltaSystemOwnerApproval.id != null){
            upsert maltaSystemOwnerApproval;
        }
        else{
            return;
        }
    }
    
    public void saveEssexJunctionSystemOwnerApprovers(){
        if(essexJunctionSystemOwnerApproval.Id == null && (essexJunctionSystemOwnerApproval.Approver1__c != null || essexJunctionSystemOwnerApproval.Approver2__c != null || essexJunctionSystemOwnerApproval.Approver3__c != null || essexJunctionSystemOwnerApproval.Approver4__c != null || essexJunctionSystemOwnerApproval.Approver5__c != null)){
            essexJunctionSystemOwnerApproval.CuSR_Form__c = cusrForm.Id;
            essexJunctionSystemOwnerApproval.Status__c = 'New';
            essexJunctionSystemOwnerApproval.Type_of_Approver__c = 'System Owner';   
            essexJunctionSystemOwnerApproval.Site__c = 'Essex Junction';
            insert essexJunctionSystemOwnerApproval;
        }
        else if(essexJunctionSystemOwnerApproval.id != null){
            upsert essexJunctionSystemOwnerApproval;
        }
        else{
            return;
        }
    }
    
    public void saveEastFishkillSystemOwnerApprovers(){
        if(eastFishkillSystemOwnerApproval.Id == null && (eastFishkillSystemOwnerApproval.Approver1__c != null || eastFishkillSystemOwnerApproval.Approver2__c != null || eastFishkillSystemOwnerApproval.Approver3__c != null || eastFishkillSystemOwnerApproval.Approver4__c != null || eastFishkillSystemOwnerApproval.Approver5__c != null)){
            eastFishkillSystemOwnerApproval.CuSR_Form__c = cusrForm.Id;
            eastFishkillSystemOwnerApproval.Status__c = 'New';
            eastFishkillSystemOwnerApproval.Type_of_Approver__c = 'System Owner';   
            eastFishkillSystemOwnerApproval.Site__c = 'East Fishkill';
            insert eastFishkillSystemOwnerApproval;
        }
        else if(eastFishkillSystemOwnerApproval.id != null){
            upsert eastFishkillSystemOwnerApproval;
        }
        else{
            return;
        }
    }
    
    public void saveASICSystemOwnerApprovers(){
        if(asicSystemOwnerApproval.Id == null && (asicSystemOwnerApproval.Approver1__c != null || asicSystemOwnerApproval.Approver2__c != null || asicSystemOwnerApproval.Approver3__c != null || asicSystemOwnerApproval.Approver4__c != null || asicSystemOwnerApproval.Approver5__c != null)){
            asicSystemOwnerApproval.CuSR_Form__c = cusrForm.Id;
            asicSystemOwnerApproval.Status__c = 'New';
            asicSystemOwnerApproval.Type_of_Approver__c = 'System Owner';   
            asicSystemOwnerApproval.Site__c = 'ASIC';
            insert asicSystemOwnerApproval;
        }
        else if(asicSystemOwnerApproval.id != null){
            upsert asicSystemOwnerApproval;
        }
        else{
            return;
        }
    }
    
    public pageReference saveDresden(){
        validateFab1ApproverMethod();
        validateDresdenSystemApproverMethods();
        if(!(validateFab1Approvers) || !(validateDresdenSystemApprover)){
            return null;
        }
        else{
            saveFab1OwnerApprovers();
            //saveDresdenCost();
            saveDresdenSystemOwnerApprovers();
            //List<CuSR_Implementation__c> selectedFab1ImplementationList = new List<CuSR_Implementation__c>();
            upsert cusrForm;
            pgRef = new pageReference('/'+cusrForm.Id);
            pgRef.getParameters().put('tabname','dresden');
            pgRef.getParameters().put('dresdensubtabname','dresdenapproval');
            pgRef.setRedirect(true);
            return pgRef;
        }
    }
    
    
    public pageReference saveSingapore(){
        
                //saveSingaporeCost();
                validateFab2ApproverMethod();
                validateFab3ApproverMethod();
                validateFab3eApproverMethod();
                validateFab5ApproverMethod();
                validateFab6ApproverMethod();
                validateFab7ApproverMethod();
                validateSingaporeSystemApproverMethods();
                validateSingaporeFabApproverMethods();
                if(validateFab2Approvers==false||validateFab3Approvers==false||validateFab3eApprovers==false||validateFab5Approvers==false||validateFab6Approvers==false||validateFab7Approvers==false||validateSingaporeSystemApprover==false||validateSingaporeFabApprover==false){
                    return null;
                }
                else{
                    saveSingaporeSystemOwnerApprovers();
                    saveSingaporeFabOwnerApprovers();
                    saveFab2OwnerApprovers();
                    saveFab3OwnerApprovers();
                    saveFab3eOwnerApprovers();
                    saveFab5OwnerApprovers();
                    saveFab6OwnerApprovers();
                    saveFab7OwnerApprovers();
                    upsert cusrForm;
                    //submitForApproval();
                    pgRef = new pageReference('/'+cusrForm.Id);
                    pgRef.getParameters().put('tabname','singapore');
                    pgRef.getParameters().put('singaporesubtabname','singaporeapproval');
                    pgRef.setRedirect(true);
                    return pgRef;
                }
    }
    
    public pageReference saveMalta(){
                validateMaltaSystemApproverMethods();
                validateFab8ApproverMethod();
                if(validateFab8Approvers==false || validateMaltaSystemApprover==false){
                    return null;
                }
                else{
                    saveMaltaSystemOwnerApprovers();
                    saveFab8OwnerApprovers();
                    //List<CuSR_Implementation__c> selectedFab8ImplementationList = new List<CuSR_Implementation__c>();
                    upsert cusrForm;
                    pgRef = new pageReference('/'+cusrForm.Id);
                    pgRef.getParameters().put('tabname','malta');
                    pgRef.getParameters().put('maltasubtabname','maltaapproval');
                    pgRef.setRedirect(true);
                    return pgRef;
                }
    }
    
    public pageReference saveEssexJunction(){
                validateEssexJunctionSystemApproverMethods();
                validateFab9ApproverMethod();
                if(validateFab9Approvers==false || validateEssexJunctionSystemApprover==false){
                    return null;
                }
                else{
                    saveEssexJunctionSystemOwnerApprovers();
                    saveFab9OwnerApprovers();
                    //List<CuSR_Implementation__c> selectedFab8ImplementationList = new List<CuSR_Implementation__c>();
                    upsert cusrForm;
                    pgRef = new pageReference('/'+cusrForm.Id);
                    pgRef.getParameters().put('tabname','essexjunction');
                    pgRef.getParameters().put('essexjunctionsubtabname','essexjunctionapproval');
                    pgRef.setRedirect(true);
                    return pgRef;
                }
    }
    
    public pageReference saveEastFishkill(){
                validateEastFishkillSystemApproverMethods();
                validateFab10ApproverMethod();
                if(validateFab10Approvers==false || validateEastFishkillSystemApprover==false){
                    return null;
                }
                else{
                    saveEastFishkillSystemOwnerApprovers();
                    saveFab10OwnerApprovers();
                    //List<CuSR_Implementation__c> selectedFab8ImplementationList = new List<CuSR_Implementation__c>();
                    upsert cusrForm;
                    pgRef = new pageReference('/'+cusrForm.Id);
                    pgRef.getParameters().put('tabname','eastfishkill');
                    pgRef.getParameters().put('eastfishkillsubtabname','eastfishkillapproval');
                    pgRef.setRedirect(true);
                    return pgRef;
                }
    }
    
    public pageReference saveASIC(){
                validateASICSystemApproverMethods();
                validateASICApproverMethod();
                if(validateASICApprovers==false || validateASICSystemApprover==false){
                    return null;
                }
                else{
                    saveASICSystemOwnerApprovers();
                    saveASICOwnerApprovers();
                    //List<CuSR_Implementation__c> selectedFab8ImplementationList = new List<CuSR_Implementation__c>();
                    upsert cusrForm;
                    pgRef = new pageReference('/'+cusrForm.Id);
                    pgRef.getParameters().put('tabname','asic');
                    pgRef.getParameters().put('asicsubtabname','asicapproval');
                    pgRef.setRedirect(true);
                    return pgRef;
                }
    }
    
    public pageReference dresdenSubmitForApproval(){
        boolean validateApprovers = true;
        showDresdenApprovalError = false;
        if(cusrForm.Status__c != '' && cusrForm.Dresden_System_Owner_Approval_Required__c == null){
                //showDresdenApprovalError = true;
                //cusrForm.Dresden_System_Owner_Approval_Required__c.addError('Please make a selection.');
                validateApprovers = false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select if System Owner Approval is required or not.'));
                //return null;
        }
        if(cusrForm.FAB_1__c == true && !(cusrForm.FAB_1_Void__c) && ((cusrForm.Dresden_System_Owner_Approval_Required__c == 'Yes' && dresdenSystemOwnerApproval.Id ==null) || fab1Approver.Id == null)){
            validateApprovers = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the approver details for Dresden.'));
        }
        if(!validateApprovers){
            showDresdenApprovalError = true;
            return null;                    
        }
        else{
            if(cusrForm.Status__c != '' && cusrForm.Dresden_System_Owner_Approval_Required__c == null){
                showDresdenApprovalError = true;
                //cusrForm.Dresden_System_Owner_Approval_Required__c.addError('Please make a selection.');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select if System Owner Approval is required or not.'));
                return null;
            }
            else{
                if(cusrForm.FAB_1__c == true && !(cusrForm.FAB_1_Void__c)){
                    cusrForm.Dresden_Ready_for_Approval__c = true;
                }
                if(!cusrForm.CEsInformed__c){
                    informCEsAfterSubmission();
                    cusrForm.CEsInformed__c = true;
                }
                update cusrForm;
                pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrForm.Id);
                pgRef.getParameters().put('tabname','dresden');
                pgRef.getParameters().put('dresdensubtabname','dresdenapproval');
                pgRef.setRedirect(true);
                return pgRef;
            }
        }
    }
    
    public pageReference singaporeSubmitForApproval(){
        boolean validateApprovers = true;
        showSingaporeApprovalError = false;
        if(cusrForm.Status__c != '' && cusrForm.Singapore_System_Owner_Approval_Required__c == null ){
                validateApprovers = false;
                //cusrForm.Singapore_System_Owner_Approval_Required__c.addError('Please make a selection.');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select if System Owner Approval is required or not.'));
                //return null;
        }
        if(cusrForm.Status__c != '' && cusrForm.Singapore_Individual_Fab_Owner_Approval__c == null){
                validateApprovers = false;
                //cusrForm.Singapore_Individual_Fab_Owner_Approval__c.addError('Please make a selection.');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select if Individual Owner Approval is required or not.'));
                //return null;
        }
        if((cusrForm.FAB_2__c == true && !(cusrForm.FAB_2_Void__c)) || (cusrForm.FAB_3__c == true && !(cusrForm.FAB_3_Void__c)) || (cusrForm.FAB_3E__c == true && !(cusrForm.FAB_3E_Void__c)) || (cusrForm.FAB_5__c == true && !(cusrForm.FAB_3E_Void__c)) || (cusrForm.FAB_6__c == true && !(cusrForm.FAB_6_Void__c)) || (cusrForm.FAB_7__c == true && !(cusrForm.FAB_7_Void__c))){
            if((cusrForm.Singapore_System_Owner_Approval_Required__c == 'Yes' && singaporeSystemOwnerApproval.Id == null) || (cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && ((cusrForm.FAB_2__c == true && !(cusrForm.FAB_2_Void__c) && fab2Approver.Id == null) || (cusrForm.FAB_3__c == true && !(cusrForm.FAB_3_Void__c) && fab3Approver.Id == null) || (cusrForm.FAB_3E__c == true && !(cusrForm.FAB_3E_Void__c) && fab3eApprover.Id == null) || (cusrForm.FAB_5__c == true && !(cusrForm.FAB_5_Void__c) && fab5Approver.Id == null) || (cusrForm.FAB_6__c == true && !(cusrForm.FAB_6_Void__c) && fab6Approver.Id == null) || (cusrForm.FAB_7__c == true && !(cusrForm.FAB_7_Void__c) && fab7Approver.Id == null))) || (cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' && singaporeFabOwnerApproval.Id == null) || cusrForm.Singapore_Individual_Fab_Owner_Approval__c == null){
                validateApprovers = false;
            }
        }
        if(!validateApprovers){
                showSingaporeApprovalError = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the approver details for Singapore'));
                return null;               
        }
        else{
            
                if((cusrForm.FAB_2__c == true && !(cusrForm.FAB_2_Void__c)) || (cusrForm.FAB_3__c == true && !(cusrForm.FAB_3_Void__c)) || (cusrForm.FAB_3E__c == true && !(cusrForm.FAB_3E_Void__c)) || (cusrForm.FAB_5__c == true && !(cusrForm.FAB_3E_Void__c)) || (cusrForm.FAB_6__c == true && !(cusrForm.FAB_6_Void__c)) || (cusrForm.FAB_7__c == true && !(cusrForm.FAB_7_Void__c))){
                    cusrForm.Singapore_Ready_for_Approval__c = true;
                }
                if(!cusrForm.CEsInformed__c){
                    informCEsAfterSubmission();
                    cusrForm.CEsInformed__c = true;
                }
                update cusrForm;
                pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrForm.Id);
                    pgRef.getParameters().put('tabname','singapore');
                pgRef.getParameters().put('singaporesubtabname','singaporeapproval');
                pgRef.setRedirect(true);
                return pgRef;
        }
    }
    
    public pageReference maltaSubmitForApproval(){
        boolean validateApprovers = true;
        showMaltaApprovalError = false;
        if(cusrForm.Status__c != '' && cusrForm.Malta_System_Owner_Approval_Required__c == null ){
                validateApprovers = false;
                //cusrForm.Malta_System_Owner_Approval_Required__c.addError('Please make a selection.');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select if System Owner Approval is required or not.'));
                //return null;
        }
       /** if(((cusrForm.FAB_8__c == true && !(cusrForm.FAB_8_Void__c)) || (cusrForm.FAB_9__c == true && !(cusrForm.FAB_9_Void__c)) || (cusrForm.FAB_10__c == true && !(cusrForm.FAB_10_Void__c))) && ((cusrForm.Malta_System_Owner_Approval_Required__c == 'Yes' && maltaSystemOwnerApproval.Id ==null) || fab8Approver.Id == null  || fab9Approver.Id == null  || fab10Approver.Id == null)){
            system.debug(cusrForm.FAB_8__c+'********ZZZZZZ********'+cusrForm.FAB_8_Void__c);
            validateApprovers = false;
        }**/
        if(cusrForm.FAB_8__c == true && !(cusrForm.FAB_8_Void__c) && ((cusrForm.Malta_System_Owner_Approval_Required__c == 'Yes' && maltaSystemOwnerApproval.Id ==null) || fab8Approver.Id == null)){
            validateApprovers = false;
        }
        if(!validateApprovers){
            showMaltaApprovalError = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the approver details for Malta.'));
            return null;       
        }
        else{

            if(cusrForm.FAB_8__c == true && !(cusrForm.FAB_8_Void__c)){
                    cusrForm.Malta_Ready_for_Approval__c = true;
                }
                if(!cusrForm.CEsInformed__c){
                    informCEsAfterSubmission();
                    cusrForm.CEsInformed__c = true;
                }
                update cusrForm;
                pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrForm.Id);
                pgRef.getParameters().put('tabname','malta');
                pgRef.getParameters().put('maltasubtabname','maltaapproval');
                pgRef.setRedirect(true);
                return pgRef;
               
        }
    }
    
    public pageReference essexJunctionSubmitForApproval(){
        boolean validateApprovers = true;
        showEssexJunctionApprovalError = false;
        if(cusrForm.Status__c != '' && cusrForm.Esx_Jun_System_Owner_Approval_Required__c == null ){
                validateApprovers = false;
                //cusrForm.Esx_Jun_System_Owner_Approval_Required__c.addError('Please make a selection.');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select if System Owner Approval is required or not.'));
                //return null;
        }
       /** if(((cusrForm.FAB_8__c == true && !(cusrForm.FAB_8_Void__c)) || (cusrForm.FAB_9__c == true && !(cusrForm.FAB_9_Void__c)) || (cusrForm.FAB_10__c == true && !(cusrForm.FAB_10_Void__c))) && ((cusrForm.Esx_Jun_System_Owner_Approval_Required__c == 'Yes' && maltaSystemOwnerApproval.Id ==null) || fab8Approver.Id == null  || fab9Approver.Id == null  || fab10Approver.Id == null)){
            system.debug(cusrForm.FAB_8__c+'********ZZZZZZ********'+cusrForm.FAB_8_Void__c);
            validateApprovers = false;
        }**/
        if(cusrForm.FAB_9__c == true && !(cusrForm.FAB_9_Void__c) && ((cusrForm.Esx_Jun_System_Owner_Approval_Required__c == 'Yes' && essexJunctionSystemOwnerApproval.Id ==null) || fab9Approver.Id == null)){
            validateApprovers = false;
        }
        if(!validateApprovers){
            showEssexJunctionApprovalError = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the approver details for Malta.'));
            return null;       
        }
        else{

            if(cusrForm.FAB_9__c == true && !(cusrForm.FAB_9_Void__c)){
                    cusrForm.Essex_Junction_Ready_for_Approval__c = true;
                }
                if(!cusrForm.CEsInformed__c){
                    informCEsAfterSubmission();
                    cusrForm.CEsInformed__c = true;
                }
                update cusrForm;
                pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrForm.Id);
                pgRef.getParameters().put('tabname','essexJunction');
                pgRef.getParameters().put('maltasubtabname','essexJunctionAapproval');
                pgRef.setRedirect(true);
                return pgRef;
               
        }
    }
    
    public pageReference eastFishkillSubmitForApproval(){
        boolean validateApprovers = true;
        showEastFishkillApprovalError = false;
        if(cusrForm.Status__c != '' && cusrForm.EastFishkillSystemOwnerApproval_Required__c == null ){
                validateApprovers = false;
                //cusrForm.EastFishkillSystemOwnerApproval_Required__c.addError('Please make a selection.');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select if System Owner Approval is required or not.'));
                //return null;
        }
       /** if(((cusrForm.FAB_8__c == true && !(cusrForm.FAB_8_Void__c)) || (cusrForm.FAB_9__c == true && !(cusrForm.FAB_9_Void__c)) || (cusrForm.FAB_10__c == true && !(cusrForm.FAB_10_Void__c))) && ((cusrForm.EastFishkillSystemOwnerApproval_Required__c == 'Yes' && maltaSystemOwnerApproval.Id ==null) || fab8Approver.Id == null  || fab9Approver.Id == null  || fab10Approver.Id == null)){
            system.debug(cusrForm.FAB_8__c+'********ZZZZZZ********'+cusrForm.FAB_8_Void__c);
            validateApprovers = false;
        }**/
        if(cusrForm.FAB_10__c == true && !(cusrForm.FAB_10_Void__c) && ((cusrForm.EastFishkillSystemOwnerApproval_Required__c == 'Yes' && eastFishkillSystemOwnerApproval.Id ==null) || fab10Approver.Id == null)){
            validateApprovers = false;
        }
        if(!validateApprovers){
            showEastFishkillApprovalError = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the approver details for Malta.'));
            return null;       
        }
        else{

            if(cusrForm.FAB_10__c == true && !(cusrForm.FAB_10_Void__c)){
                    cusrForm.East_Fishkill_Ready_for_Approval__c = true;
                }
                if(!cusrForm.CEsInformed__c){
                    informCEsAfterSubmission();
                    cusrForm.CEsInformed__c = true;
                }
                update cusrForm;
                pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrForm.Id);
                pgRef.getParameters().put('tabname','eastFishkill');
                pgRef.getParameters().put('maltasubtabname','eastFishkillApproval');
                pgRef.setRedirect(true);
                return pgRef;
               
        }
    }
    
    public pageReference asicSubmitForApproval(){
        boolean validateApprovers = true;
        showASICApprovalError = false;
        if(cusrForm.Status__c != '' && cusrForm.ASIC_System_Owner_Approval_Required__c == null ){
                validateApprovers = false;
                //cusrForm.ASIC_System_Owner_Approval_Required__c.addError('Please make a selection.');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select if System Owner Approval is required or not.'));
                //return null;
        }
       /** if(((cusrForm.FAB_8__c == true && !(cusrForm.FAB_8_Void__c)) || (cusrForm.FAB_9__c == true && !(cusrForm.FAB_9_Void__c)) || (cusrForm.FAB_10__c == true && !(cusrForm.FAB_10_Void__c))) && ((cusrForm.ASIC_System_Owner_Approval_Required__c == 'Yes' && maltaSystemOwnerApproval.Id ==null) || fab8Approver.Id == null  || fab9Approver.Id == null  || fab10Approver.Id == null)){
            system.debug(cusrForm.FAB_8__c+'********ZZZZZZ********'+cusrForm.FAB_8_Void__c);
            validateApprovers = false;
        }**/
        if(cusrForm.ASIC__c == true && !(cusrForm.ASIC_Void__c) && ((cusrForm.ASIC_System_Owner_Approval_Required__c == 'Yes' && asicSystemOwnerApproval.Id ==null) || asicApprover.Id == null)){
            validateApprovers = false;
        }
        if(!validateApprovers){
            showASICApprovalError = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the approver details for ASIC.'));
            return null;       
        }
        else{

            if(cusrForm.ASIC__c == true && !(cusrForm.ASIC_Void__c)){
                    cusrForm.ASIC_Ready_for_Approval__c = true;
                }
                if(!cusrForm.CEsInformed__c){
                    informCEsAfterSubmission();
                    cusrForm.CEsInformed__c = true;
                }
                update cusrForm;
                pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrForm.Id);
                pgRef.getParameters().put('tabname','asic');
                pgRef.getParameters().put('maltasubtabname','asicapproval');
                pgRef.setRedirect(true);
                return pgRef;
               
        }
    }
    
    //method to display Fab owner section
    public void showSingaporeFabOwnerListMethod(){
        if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No'){
            showSingaporeFabOwner = true;
        }
        else{
            showSingaporeFabOwner = false;
        }
    }
    
    //method to enable fab owner approvers    
    public void enableSingaporeFabOwnerApprovers(){
        if(singaporeFabOwnerApproval.No_of_Approvers__c == '1'){
            enableSingaporeFabApprover1 = true;
            enableSingaporeFabApprover2 = false;
            enableSingaporeFabApprover3 = false;
            enableSingaporeFabApprover4 = false;
            enableSingaporeFabApprover5 = false;
        }
        if(singaporeFabOwnerApproval.No_of_Approvers__c == '2'){
            enableSingaporeFabApprover1 = true;
            enableSingaporeFabApprover2 = true;
            enableSingaporeFabApprover3 = false;
            enableSingaporeFabApprover4 = false;
            enableSingaporeFabApprover5 = false;
        }
        if(singaporeFabOwnerApproval.No_of_Approvers__c == '3'){
            enableSingaporeFabApprover1 = true;
            enableSingaporeFabApprover2 = true;
            enableSingaporeFabApprover3 = true;
            enableSingaporeFabApprover4 = false;
            enableSingaporeFabApprover5 = false;
        }
        if(singaporeFabOwnerApproval.No_of_Approvers__c == '4'){
            enableSingaporeFabApprover1 = true;
            enableSingaporeFabApprover2 = true;
            enableSingaporeFabApprover3 = true;
            enableSingaporeFabApprover4 = true;
            enableSingaporeFabApprover5 = false;
        }
        if(singaporeFabOwnerApproval.No_of_Approvers__c == '5'){
            enableSingaporeFabApprover1 = true;
            enableSingaporeFabApprover2 = true;
            enableSingaporeFabApprover3 = true;
            enableSingaporeFabApprover4 = true;
            enableSingaporeFabApprover5 = true;
        }
        if(singaporeFabOwnerApproval.No_of_Approvers__c == ''){
            enableSingaporeFabApprover1 = false;
            enableSingaporeFabApprover2 = false;
            enableSingaporeFabApprover3 = false;
            enableSingaporeFabApprover4 = false;
            enableSingaporeFabApprover5 = false;
        }
    }
    
    public void saveSingaporeFabOwnerApprovers(){
        if(singaporeFabOwnerApproval.Id == null && cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' && (singaporeFabOwnerApproval.Approver1__c != null || singaporeFabOwnerApproval.Approver2__c != null || singaporeFabOwnerApproval.Approver3__c != null || singaporeFabOwnerApproval.Approver4__c != null || singaporeFabOwnerApproval.Approver5__c != null)){
            singaporeFabOwnerApproval.CuSR_Form__c = cusrForm.Id;
            singaporeFabOwnerApproval.Status__c = 'New';
            singaporeFabOwnerApproval.Type_of_Approver__c = 'FAB Owner';
            singaporeFabOwnerApproval.Site__c = 'Singapore';
            insert singaporeFabOwnerApproval;
        }
        else if(singaporeFabOwnerApproval.Id != null){
            upsert singaporeFabOwnerApproval;
        }
        else{
            return;
        }
    }
    
    //method to enable fab 1 owner approvers    
    public void enableFab1OwnerApprovers(){
        if(fab1Approver.No_of_Approvers__c == '1'){
            enableFab1Approver1 = true;
            enableFab1Approver2 = false;
            enableFab1Approver3 = false;
            enableFab1Approver4 = false;
            enableFab1Approver5 = false;
        }
        if(fab1Approver.No_of_Approvers__c == '2'){
            enableFab1Approver1 = true;
            enableFab1Approver2 = true;
            enableFab1Approver3 = false;
            enableFab1Approver4 = false;
            enableFab1Approver5 = false;
        }
        if(fab1Approver.No_of_Approvers__c == '3'){
            enableFab1Approver1 = true;
            enableFab1Approver2 = true;
            enableFab1Approver3 = true;
            enableFab1Approver4 = false;
            enableFab1Approver5 = false;
        }
        if(fab1Approver.No_of_Approvers__c == '4'){
            enableFab1Approver1 = true;
            enableFab1Approver2 = true;
            enableFab1Approver3 = true;
            enableFab1Approver4 = true;
            enableFab1Approver5 = false;
        }
        if(fab1Approver.No_of_Approvers__c == '5'){
            enableFab1Approver1 = true;
            enableFab1Approver2 = true;
            enableFab1Approver3 = true;
            enableFab1Approver4 = true;
            enableFab1Approver5 = true;
        }
        if(fab1Approver.No_of_Approvers__c == ''){
            enableFab1Approver1 = false;
            enableFab1Approver2 = false;
            enableFab1Approver3 = false;
            enableFab1Approver4 = false;
            enableFab1Approver5 = false;
        }
    }
    
    public void saveFab1OwnerApprovers(){
        if(fab1Approver.Id == null && (fab1Approver.Approver1__c != null || fab1Approver.Approver2__c != null || fab1Approver.Approver3__c != null || fab1Approver.Approver4__c != null || fab1Approver.Approver5__c != null)){
                fab1Approver.CuSR_Form__c = cusrForm.Id;
                fab1Approver.Status__c = 'New';
                fab1Approver.Type_of_Approver__c = 'FAB 1 Owner';
                fab1Approver.Site__c = 'Dresden';
                fab1Approver.Fab__c = 'FAB 1';
                insert fab1Approver;
        }
        else if(fab1Approver.Id != null){
            upsert fab1Approver;
        }
        else{
            return;
        }
    }
    
    //method to enable fab 2 owner approvers    
    public void enableFab2OwnerApprovers(){
        if(fab2Approver.No_of_Approvers__c == '1'){
            enableFab2Approver1 = true;
            enableFab2Approver2 = false;
            enableFab2Approver3 = false;
            enableFab2Approver4 = false;
            enableFab2Approver5 = false;
        }
        if(fab2Approver.No_of_Approvers__c == '2'){
            enableFab2Approver1 = true;
            enableFab2Approver2 = true;
            enableFab2Approver3 = false;
            enableFab2Approver4 = false;
            enableFab2Approver5 = false;
        }
        if(fab2Approver.No_of_Approvers__c == '3'){
            enableFab2Approver1 = true;
            enableFab2Approver2 = true;
            enableFab2Approver3 = true;
            enableFab2Approver4 = false;
            enableFab2Approver5 = false;
        }
        if(fab2Approver.No_of_Approvers__c == '4'){
            enableFab2Approver1 = true;
            enableFab2Approver2 = true;
            enableFab2Approver3 = true;
            enableFab2Approver4 = true;
            enableFab2Approver5 = false;
        }
        if(fab2Approver.No_of_Approvers__c == '5'){
            enableFab2Approver1 = true;
            enableFab2Approver2 = true;
            enableFab2Approver3 = true;
            enableFab2Approver4 = true;
            enableFab2Approver5 = true;
        }
        if(fab2Approver.No_of_Approvers__c == ''){
            enableFab2Approver1 = false;
            enableFab2Approver2 = false;
            enableFab2Approver3 = false;
            enableFab2Approver4 = false;
            enableFab2Approver5 = false;
        }
    }
    
    public void saveFab2OwnerApprovers(){
        if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && fab2Approver.Id == null && (fab2Approver.Approver1__c != null || fab2Approver.Approver2__c != null || fab2Approver.Approver3__c != null || fab2Approver.Approver4__c != null || fab2Approver.Approver5__c != null)){
                fab2Approver.CuSR_Form__c = cusrForm.Id;
                fab2Approver.Status__c = 'New';
                fab2Approver.Type_of_Approver__c = 'FAB 2 Owner';
                fab2Approver.Site__c = 'Singapore';
                fab2Approver.Fab__c = 'FAB 2';
            insert fab2Approver;
        }
        else if(fab2Approver.Id != null){
            upsert fab2Approver;
        }
        else{
            return;
        }
    }
    
    //method to enable fab 3 owner approvers    
    public void enableFab3OwnerApprovers(){
        if(fab3Approver.No_of_Approvers__c == '1'){
            enableFab3Approver1 = true;
            enableFab3Approver2 = false;
            enableFab3Approver3 = false;
            enableFab3Approver4 = false;
            enableFab3Approver5 = false;
        }
        if(fab3Approver.No_of_Approvers__c == '2'){
            enableFab3Approver1 = true;
            enableFab3Approver2 = true;
            enableFab3Approver3 = false;
            enableFab3Approver4 = false;
            enableFab3Approver5 = false;
        }
        if(fab3Approver.No_of_Approvers__c == '3'){
            enableFab3Approver1 = true;
            enableFab3Approver2 = true;
            enableFab3Approver3 = true;
            enableFab3Approver4 = false;
            enableFab3Approver5 = false;
        }
        if(fab3Approver.No_of_Approvers__c == '4'){
            enableFab3Approver1 = true;
            enableFab3Approver2 = true;
            enableFab3Approver3 = true;
            enableFab3Approver4 = true;
            enableFab3Approver5 = false;
        }
        if(fab3Approver.No_of_Approvers__c == '5'){
            enableFab3Approver1 = true;
            enableFab3Approver2 = true;
            enableFab3Approver3 = true;
            enableFab3Approver4 = true;
            enableFab3Approver5 = true;
        }
        if(fab3Approver.No_of_Approvers__c == ''){
            enableFab3Approver1 = false;
            enableFab3Approver2 = false;
            enableFab3Approver3 = false;
            enableFab3Approver4 = false;
            enableFab3Approver5 = false;
        }
    }
    
    public void saveFab3OwnerApprovers(){
        if(fab3Approver.Id == null && cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && (fab3Approver.Approver1__c != null || fab3Approver.Approver2__c != null || fab3Approver.Approver3__c != null || fab3Approver.Approver4__c != null || fab3Approver.Approver5__c != null)){
                fab3Approver.CuSR_Form__c = cusrForm.Id;
                fab3Approver.Status__c = 'New';
                fab3Approver.Type_of_Approver__c = 'FAB 3 Owner';
                fab3Approver.Site__c = 'Singapore';
                fab3Approver.Fab__c = 'FAB 3';
            insert fab3Approver;
        }
        else if(fab3Approver.Id != null){
            upsert fab3Approver;
        }
        else{
            return;
        }
    }
    
    //method to enable fab 3E owner approvers    
    public void enableFab3eOwnerApprovers(){
        if(fab3eApprover.No_of_Approvers__c == '1'){
            enableFab3eApprover1 = true;
            enableFab3eApprover2 = false;
            enableFab3eApprover3 = false;
            enableFab3eApprover4 = false;
            enableFab3eApprover5 = false;
        }
        if(fab3eApprover.No_of_Approvers__c == '2'){
            enableFab3eApprover1 = true;
            enableFab3eApprover2 = true;
            enableFab3eApprover3 = false;
            enableFab3eApprover4 = false;
            enableFab3eApprover5 = false;
        }
        if(fab3eApprover.No_of_Approvers__c == '3'){
            enableFab3eApprover1 = true;
            enableFab3eApprover2 = true;
            enableFab3eApprover3 = true;
            enableFab3eApprover4 = false;
            enableFab3eApprover5 = false;
        }
        if(fab3eApprover.No_of_Approvers__c == '4'){
            enableFab3eApprover1 = true;
            enableFab3eApprover2 = true;
            enableFab3eApprover3 = true;
            enableFab3eApprover4 = true;
            enableFab3eApprover5 = false;
        }
        if(fab3eApprover.No_of_Approvers__c == '5'){
            enableFab3eApprover1 = true;
            enableFab3eApprover2 = true;
            enableFab3eApprover3 = true;
            enableFab3eApprover4 = true;
            enableFab3eApprover5 = true;
        }
        if(fab3eApprover.No_of_Approvers__c == ''){
            enableFab3eApprover1 = false;
            enableFab3eApprover2 = false;
            enableFab3eApprover3 = false;
            enableFab3eApprover4 = false;
            enableFab3eApprover5 = false;
        }
    }
    
    public void saveFab3eOwnerApprovers(){
        if(fab3eApprover.Id == null && cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && (fab3eApprover.Approver1__c != null || fab3eApprover.Approver2__c != null || fab3eApprover.Approver3__c != null || fab3eApprover.Approver4__c != null || fab3eApprover.Approver5__c != null)){
                fab3eApprover.CuSR_Form__c = cusrForm.Id;
                fab3eApprover.Status__c = 'New';
                fab3eApprover.Type_of_Approver__c = 'FAB 3E Owner';
                fab3eApprover.Site__c = 'Singapore';
                fab3eApprover.Fab__c = 'FAB 3E';
                insert fab3eApprover;
        }
        else if(fab3eApprover.Id != null){
            upsert fab3eApprover;
        }
        else{
            return;
        }
    }
    
    //method to enable fab 5 owner approvers    
    public void enableFab5OwnerApprovers(){
        if(fab5Approver.No_of_Approvers__c == '1'){
            enableFab5Approver1 = true;
            enableFab5Approver2 = false;
            enableFab5Approver3 = false;
            enableFab5Approver4 = false;
            enableFab5Approver5 = false;
        }
        if(fab5Approver.No_of_Approvers__c == '2'){
            enableFab5Approver1 = true;
            enableFab5Approver2 = true;
            enableFab5Approver3 = false;
            enableFab5Approver4 = false;
            enableFab5Approver5 = false;
        }
        if(fab5Approver.No_of_Approvers__c == '3'){
            enableFab5Approver1 = true;
            enableFab5Approver2 = true;
            enableFab5Approver3 = true;
            enableFab5Approver4 = false;
            enableFab5Approver5 = false;
        }
        if(fab5Approver.No_of_Approvers__c == '4'){
            enableFab5Approver1 = true;
            enableFab5Approver2 = true;
            enableFab5Approver3 = true;
            enableFab5Approver4 = true;
            enableFab5Approver5 = false;
        }
        if(fab5Approver.No_of_Approvers__c == '5'){
            enableFab5Approver1 = true;
            enableFab5Approver2 = true;
            enableFab5Approver3 = true;
            enableFab5Approver4 = true;
            enableFab5Approver5 = true;
        }
        if(fab5Approver.No_of_Approvers__c == ''){
            enableFab5Approver1 = false;
            enableFab5Approver2 = false;
            enableFab5Approver3 = false;
            enableFab5Approver4 = false;
            enableFab5Approver5 = false;
        }
    }
    
    public void saveFab5OwnerApprovers(){
        if(fab5Approver.Id == null && cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && (fab5Approver.Approver1__c != null || fab5Approver.Approver2__c != null || fab5Approver.Approver3__c != null || fab5Approver.Approver4__c != null || fab5Approver.Approver5__c != null)){
                fab5Approver.CuSR_Form__c = cusrForm.Id;
                fab5Approver.Status__c = 'New';
                fab5Approver.Type_of_Approver__c = 'FAB 5 Owner';
                fab5Approver.Site__c = 'Singapore';
                fab5Approver.Fab__c = 'FAB 5';
                insert fab5Approver;
        }
        else if(fab5Approver.Id != null){
            upsert fab5Approver;
        }
        else{
            return;
        }
    }
    
    //method to enable fab 6 owner approvers    
    public void enableFab6OwnerApprovers(){
        if(fab6Approver.No_of_Approvers__c == '1'){
            enableFab6Approver1 = true;
            enableFab6Approver2 = false;
            enableFab6Approver3 = false;
            enableFab6Approver4 = false;
            enableFab6Approver5 = false;
        }
        if(fab6Approver.No_of_Approvers__c == '2'){
            enableFab6Approver1 = true;
            enableFab6Approver2 = true;
            enableFab6Approver3 = false;
            enableFab6Approver4 = false;
            enableFab6Approver5 = false;
        }
        if(fab6Approver.No_of_Approvers__c == '3'){
            enableFab6Approver1 = true;
            enableFab6Approver2 = true;
            enableFab6Approver3 = true;
            enableFab6Approver4 = false;
            enableFab6Approver5 = false;
        }
        if(fab6Approver.No_of_Approvers__c == '4'){
            enableFab6Approver1 = true;
            enableFab6Approver2 = true;
            enableFab6Approver3 = true;
            enableFab6Approver4 = true;
            enableFab6Approver5 = false;
        }
        if(fab6Approver.No_of_Approvers__c == '5'){
            enableFab6Approver1 = true;
            enableFab6Approver2 = true;
            enableFab6Approver3 = true;
            enableFab6Approver4 = true;
            enableFab6Approver5 = true;
        }
        if(fab6Approver.No_of_Approvers__c == ''){
            enableFab6Approver1 = false;
            enableFab6Approver2 = false;
            enableFab6Approver3 = false;
            enableFab6Approver4 = false;
            enableFab6Approver5 = false;
        }
    }
    
    public void saveFab6OwnerApprovers(){
        if(fab6Approver.Id == null && cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && (fab6Approver.Approver1__c != null || fab6Approver.Approver2__c != null || fab6Approver.Approver3__c != null || fab6Approver.Approver4__c != null || fab6Approver.Approver5__c != null)){
                fab6Approver.CuSR_Form__c = cusrForm.Id;
                fab6Approver.Status__c = 'New';
                fab6Approver.Type_of_Approver__c = 'FAB 6 Owner';
                fab6Approver.Site__c = 'Singapore';
                fab6Approver.Fab__c = 'FAB 6';
                insert fab6Approver;
        }
        else if(fab6Approver.Id != null){
            upsert fab6Approver;
        }
        else{
            return;
        }
    }
    
    //method to enable fab 7 owner approvers    
    public void enableFab7OwnerApprovers(){
        if(fab7Approver.No_of_Approvers__c == '1'){
            enableFab7Approver1 = true;
            enableFab7Approver2 = false;
            enableFab7Approver3 = false;
            enableFab7Approver4 = false;
            enableFab7Approver5 = false;
        }
        if(fab7Approver.No_of_Approvers__c == '2'){
            enableFab7Approver1 = true;
            enableFab7Approver2 = true;
            enableFab7Approver3 = false;
            enableFab7Approver4 = false;
            enableFab7Approver5 = false;
        }
        if(fab7Approver.No_of_Approvers__c == '3'){
            enableFab7Approver1 = true;
            enableFab7Approver2 = true;
            enableFab7Approver3 = true;
            enableFab7Approver4 = false;
            enableFab7Approver5 = false;
        }
        if(fab7Approver.No_of_Approvers__c == '4'){
            enableFab7Approver1 = true;
            enableFab7Approver2 = true;
            enableFab7Approver3 = true;
            enableFab7Approver4 = true;
            enableFab7Approver5 = false;
        }
        if(fab7Approver.No_of_Approvers__c == '5'){
            enableFab7Approver1 = true;
            enableFab7Approver2 = true;
            enableFab7Approver3 = true;
            enableFab7Approver4 = true;
            enableFab7Approver5 = true;
        }
        if(fab7Approver.No_of_Approvers__c == ''){
            enableFab7Approver1 = false;
            enableFab7Approver2 = false;
            enableFab7Approver3 = false;
            enableFab7Approver4 = false;
            enableFab7Approver5 = false;
        }
    }
    
    public void saveFab7OwnerApprovers(){
        if(fab7Approver.Id == null && cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && (fab7Approver.Approver1__c != null || fab7Approver.Approver2__c != null || fab7Approver.Approver3__c != null || fab7Approver.Approver4__c != null || fab7Approver.Approver5__c != null)){
                fab7Approver.CuSR_Form__c = cusrForm.Id;
                fab7Approver.Status__c = 'New';
                fab7Approver.Type_of_Approver__c = 'FAB 7 Owner';
                fab7Approver.Site__c = 'Singapore';
                fab7Approver.Fab__c = 'FAB 7';
                insert fab7Approver;
        }
        else if(fab7Approver.Id != null){
            upsert fab7Approver;
        }
        else{
            return;
        }
    }
    
    //method to enable fab 8 owner approvers    
    public void enableFab8OwnerApprovers(){
        if(fab8Approver.No_of_Approvers__c == '1'){
            enableFab8Approver1 = true;
            enableFab8Approver2 = false;
            enableFab8Approver3 = false;
            enableFab8Approver4 = false;
            enableFab8Approver5 = false;
        }
        if(fab8Approver.No_of_Approvers__c == '2'){
            enableFab8Approver1 = true;
            enableFab8Approver2 = true;
            enableFab8Approver3 = false;
            enableFab8Approver4 = false;
            enableFab8Approver5 = false;
        }
        if(fab8Approver.No_of_Approvers__c == '3'){
            enableFab8Approver1 = true;
            enableFab8Approver2 = true;
            enableFab8Approver3 = true;
            enableFab8Approver4 = false;
            enableFab8Approver5 = false;
        }
        if(fab8Approver.No_of_Approvers__c == '4'){
            enableFab8Approver1 = true;
            enableFab8Approver2 = true;
            enableFab8Approver3 = true;
            enableFab8Approver4 = true;
            enableFab8Approver5 = false;
        }
        if(fab8Approver.No_of_Approvers__c == '5'){
            enableFab8Approver1 = true;
            enableFab8Approver2 = true;
            enableFab8Approver3 = true;
            enableFab8Approver4 = true;
            enableFab8Approver5 = true;
        }
        if(fab8Approver.No_of_Approvers__c == ''){
            enableFab8Approver1 = false;
            enableFab8Approver2 = false;
            enableFab8Approver3 = false;
            enableFab8Approver4 = false;
            enableFab8Approver5 = false;
        }
    }
    
    public void saveFab8OwnerApprovers(){
        if(fab8Approver.Id == null && (fab8Approver.Approver1__c != null || fab8Approver.Approver2__c != null || fab8Approver.Approver3__c != null || fab8Approver.Approver4__c != null || fab8Approver.Approver5__c != null)){
                fab8Approver.CuSR_Form__c = cusrForm.Id;
                fab8Approver.Status__c = 'New';
                fab8Approver.Type_of_Approver__c = 'FAB 8 Owner';
                fab8Approver.Site__c = 'Malta';
                fab8Approver.Fab__c = 'FAB 8';
                insert fab8Approver;
        }
        else if(fab8Approver.Id != null){
            upsert fab8Approver;
        }
        else{
            return;
        }
    }
    //method to enable fab 9 owner approvers    
    public void enableFab9OwnerApprovers(){
        if(fab9Approver.No_of_Approvers__c == '1'){
            enableFab9Approver1 = true;
            enableFab9Approver2 = false;
            enableFab9Approver3 = false;
            enableFab9Approver4 = false;
            enableFab9Approver5 = false;
        }
        if(fab9Approver.No_of_Approvers__c == '2'){
            enableFab9Approver1 = true;
            enableFab9Approver2 = true;
            enableFab9Approver3 = false;
            enableFab9Approver4 = false;
            enableFab9Approver5 = false;
        }
        if(fab9Approver.No_of_Approvers__c == '3'){
            enableFab9Approver1 = true;
            enableFab9Approver2 = true;
            enableFab9Approver3 = true;
            enableFab9Approver4 = false;
            enableFab9Approver5 = false;
        }
        if(fab9Approver.No_of_Approvers__c == '4'){
            enableFab9Approver1 = true;
            enableFab9Approver2 = true;
            enableFab9Approver3 = true;
            enableFab9Approver4 = true;
            enableFab9Approver5 = false;
        }
        if(fab9Approver.No_of_Approvers__c == '5'){
            enableFab9Approver1 = true;
            enableFab9Approver2 = true;
            enableFab9Approver3 = true;
            enableFab9Approver4 = true;
            enableFab9Approver5 = true;
        }
        if(fab9Approver.No_of_Approvers__c == ''){
            enableFab9Approver1 = false;
            enableFab9Approver2 = false;
            enableFab9Approver3 = false;
            enableFab9Approver4 = false;
            enableFab9Approver5 = false;
        }
    }
    
    public void saveFab9OwnerApprovers(){
        if(fab9Approver.Id == null && (fab9Approver.Approver1__c != null || fab9Approver.Approver2__c != null || fab9Approver.Approver3__c != null || fab9Approver.Approver4__c != null || fab9Approver.Approver5__c != null)){
                fab9Approver.CuSR_Form__c = cusrForm.Id;
                fab9Approver.Status__c = 'New';
                fab9Approver.Type_of_Approver__c = 'FAB 9 Owner';
                fab9Approver.Site__c = 'Essex Junction';
                fab9Approver.Fab__c = 'FAB 9';
                insert fab9Approver;
        }
        else if(fab9Approver.Id != null){
            upsert fab9Approver;
        }
        else{
            return;
        }
    }
    
    //method to enable fab 10 owner approvers    
    public void enableFab10OwnerApprovers(){
        if(fab10Approver.No_of_Approvers__c == '1'){
            enableFab10Approver1 = true;
            enableFab10Approver2 = false;
            enableFab10Approver3 = false;
            enableFab10Approver4 = false;
            enableFab10Approver5 = false;
        }
        if(fab10Approver.No_of_Approvers__c == '2'){
            enableFab10Approver1 = true;
            enableFab10Approver2 = true;
            enableFab10Approver3 = false;
            enableFab10Approver4 = false;
            enableFab10Approver5 = false;
        }
        if(fab10Approver.No_of_Approvers__c == '3'){
            enableFab10Approver1 = true;
            enableFab10Approver2 = true;
            enableFab10Approver3 = true;
            enableFab10Approver4 = false;
            enableFab10Approver5 = false;
        }
        if(fab10Approver.No_of_Approvers__c == '4'){
            enableFab10Approver1 = true;
            enableFab10Approver2 = true;
            enableFab10Approver3 = true;
            enableFab10Approver4 = true;
            enableFab10Approver5 = false;
        }
        if(fab10Approver.No_of_Approvers__c == '5'){
            enableFab10Approver1 = true;
            enableFab10Approver2 = true;
            enableFab10Approver3 = true;
            enableFab10Approver4 = true;
            enableFab10Approver5 = true;
        }
        if(fab10Approver.No_of_Approvers__c == ''){
            enableFab10Approver1 = false;
            enableFab10Approver2 = false;
            enableFab10Approver3 = false;
            enableFab10Approver4 = false;
            enableFab10Approver5 = false;
        }
    }
    
    public void saveFab10OwnerApprovers(){
        if(fab10Approver.Id == null && (fab10Approver.Approver1__c != null || fab10Approver.Approver2__c != null || fab10Approver.Approver3__c != null || fab10Approver.Approver4__c != null || fab10Approver.Approver5__c != null)){
                fab10Approver.CuSR_Form__c = cusrForm.Id;
                fab10Approver.Status__c = 'New';
                fab10Approver.Type_of_Approver__c = 'FAB 10 Owner';
                fab10Approver.Site__c = 'East Fishkill';
                fab10Approver.Fab__c = 'FAB 10';
                insert fab10Approver;
        }
        else if(fab10Approver.Id != null){
            upsert fab10Approver;
        }
        else{
            return;
        }
    }
    
    //method to enable ASIC owner approvers    
    public void enableASICOwnerApprovers(){
        if(asicApprover.No_of_Approvers__c == '1'){
            enableASICApprover1 = true;
            enableASICApprover2 = false;
            enableASICApprover3 = false;
            enableASICApprover4 = false;
            enableASICApprover5 = false;
        }
        if(asicApprover.No_of_Approvers__c == '2'){
            enableASICApprover1 = true;
            enableASICApprover2 = true;
            enableASICApprover3 = false;
            enableASICApprover4 = false;
            enableASICApprover5 = false;
        }
        if(asicApprover.No_of_Approvers__c == '3'){
            enableASICApprover1 = true;
            enableASICApprover2 = true;
            enableASICApprover3 = true;
            enableASICApprover4 = false;
            enableASICApprover5 = false;
        }
        if(asicApprover.No_of_Approvers__c == '4'){
            enableASICApprover1 = true;
            enableASICApprover2 = true;
            enableASICApprover3 = true;
            enableASICApprover4 = true;
            enableASICApprover5 = false;
        }
        if(asicApprover.No_of_Approvers__c == '5'){
            enableASICApprover1 = true;
            enableASICApprover2 = true;
            enableASICApprover3 = true;
            enableASICApprover4 = true;
            enableASICApprover5 = true;
        }
        if(asicApprover.No_of_Approvers__c == ''){
            enableASICApprover1 = false;
            enableASICApprover2 = false;
            enableASICApprover3 = false;
            enableASICApprover4 = false;
            enableASICApprover5 = false;
        }
    }
    
    public void saveASICOwnerApprovers(){
        if(asicApprover.Id == null && (asicApprover.Approver1__c != null || asicApprover.Approver2__c != null || asicApprover.Approver3__c != null || asicApprover.Approver4__c != null || asicApprover.Approver5__c != null)){
                asicApprover.CuSR_Form__c = cusrForm.Id;
                asicApprover.Status__c = 'New';
                asicApprover.Type_of_Approver__c = 'ASIC Owner';
                asicApprover.Site__c = 'ASIC';
                asicApprover.Fab__c = 'ASIC';
                insert asicApprover;
        }
        else if(asicApprover.Id != null){
            upsert asicApprover;
        }
        else{
            return;
        }
    }
    
    public String saveSelectedScope(){
        String selectedScope = '';
        if(cusrForm.FAB_1__c)
            selectedScope += '; FAB 1';
        if(cusrForm.FAB_2__c)
            selectedScope += '; FAB 2';
        if(cusrForm.FAB_3__c)
            selectedScope += '; FAB 3';
        if(cusrForm.FAB_3E__c)
            selectedScope += '; FAB 3E';
        if(cusrForm.FAB_5__c)
            selectedScope += '; FAB 5';
        if(cusrForm.FAB_6__c)
            selectedScope += '; FAB 6';
        if(cusrForm.FAB_7__c)
            selectedScope += '; FAB 7';
        if(cusrForm.FAB_8__c)
            selectedScope += '; FAB 8';  
        if(cusrForm.FAB_9__c)
            selectedScope += '; FAB 9';
        if(cusrForm.FAB_10__c)
            selectedScope += '; FAB 10';
        if(cusrForm.ASIC__c)
            selectedScope += '; ASIC'; 
        if(selectedScope != ''){
            selectedScope = selectedScope.subString(2);
            system.debug('Scope string is '+selectedScope);
            //cusrForm.Scope__c = selectedScope;
        }  
        return selectedScope;      
    }
    
    //Method for Edit button on Initiator Tab
    public pageReference EditButtonOnInitiatorTab(){
        pgRef = new pageReference('/apex/CuSRForm?id='+cusrForm.Id);
        pgRef.getParameters().put('tabname','initiator');
        pgRef.getParameters().put('ReturnUrl',ApexPages.currentPage().getUrl());
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    //Method for Edit button on Dresden Approval SubTab
    public pageReference EditButtonOnDresdenApprovalTab(){
        pgRef = new pageReference('/apex/CuSRForm?id='+cusrForm.Id);
        pgRef.getParameters().put('tabname','dresden');
        pgRef.getParameters().put('dresdensubtabname','dresdenapproval');
        pgRef.getParameters().put('ReturnUrl',ApexPages.currentPage().getUrl());
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    //Method for Edit button on Dresden Implementation SubTab
    public pageReference EditButtonOnDresdenImplementationTab(){
        pgRef = new pageReference('/apex/CuSRForm?id='+cusrForm.Id);
        pgRef.getParameters().put('tabname','dresden');
        pgRef.getParameters().put('dresdensubtabname','dresdenimplementation');
        pgRef.getParameters().put('ReturnUrl',ApexPages.currentPage().getUrl());
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    //Method for Edit button on Singapore Approval SubTab
    public pageReference EditButtonOnSingaporeApprovalTab(){
        pgRef = new pageReference('/apex/CuSRForm?id='+cusrForm.Id);
        pgRef.getParameters().put('tabname','singapore');
        pgRef.getParameters().put('singaporesubtabname','singaporeapproval');
        pgRef.getParameters().put('ReturnUrl',ApexPages.currentPage().getUrl());
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    //Method for Edit button on Singapore Implementation SubTab
    public pageReference EditButtonOnSingaporeImplementationTab(){
        pgRef = new pageReference('/apex/CuSRForm?id='+cusrForm.Id);
        pgRef.getParameters().put('tabname','singapore');
        pgRef.getParameters().put('singaporesubtabname','singaporeimplementation');
        pgRef.getParameters().put('ReturnUrl',ApexPages.currentPage().getUrl());
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    //Method for Edit button on Malta Approval SubTab
    public pageReference EditButtonOnMaltaApprovalTab(){
        pgRef = new pageReference('/apex/CuSRForm?id='+cusrForm.Id);
        pgRef.getParameters().put('tabname','malta');
        pgRef.getParameters().put('maltasubtabname','maltaapproval');
        pgRef.getParameters().put('ReturnUrl',ApexPages.currentPage().getUrl());
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    //Method for Edit button on Malta Implementation SubTab
    public pageReference EditButtonOnMaltaImplementationTab(){
        pgRef = new pageReference('/apex/CuSRForm?id='+cusrForm.Id);
        pgRef.getParameters().put('tabname','malta');
        pgRef.getParameters().put('maltasubtabname','maltaimplementation');
        pgRef.getParameters().put('ReturnUrl',ApexPages.currentPage().getUrl());
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    //Method for Edit button on Essex Junction Approval SubTab
    public pageReference EditButtonOnEssexJunctionApprovalTab(){
        pgRef = new pageReference('/apex/CuSRForm?id='+cusrForm.Id);
        pgRef.getParameters().put('tabname','essexjunction');
        pgRef.getParameters().put('maltasubtabname','essexjunctionapproval');
        pgRef.getParameters().put('ReturnUrl',ApexPages.currentPage().getUrl());
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    //Method for Edit button on Essex Junction Implementation SubTab
    public pageReference EditButtonOnEssexJunctionImplementationTab(){
        pgRef = new pageReference('/apex/CuSRForm?id='+cusrForm.Id);
        pgRef.getParameters().put('tabname','essexjunction');
        pgRef.getParameters().put('maltasubtabname','essexjunctionimplementation');
        pgRef.getParameters().put('ReturnUrl',ApexPages.currentPage().getUrl());
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    //Method for Edit button on East Fishkill Approval SubTab
    public pageReference EditButtonOnEastFishkillApprovalTab(){
        pgRef = new pageReference('/apex/CuSRForm?id='+cusrForm.Id);
        pgRef.getParameters().put('tabname','eastfishkill');
        pgRef.getParameters().put('maltasubtabname','eastfishkillapproval');
        pgRef.getParameters().put('ReturnUrl',ApexPages.currentPage().getUrl());
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    //Method for Edit button on East Fishkill Implementation SubTab
    public pageReference EditButtonOnEastFishkillImplementationTab(){
        pgRef = new pageReference('/apex/CuSRForm?id='+cusrForm.Id);
        pgRef.getParameters().put('tabname','eastfishkill');
        pgRef.getParameters().put('maltasubtabname','eastfishkillimplementation');
        pgRef.getParameters().put('ReturnUrl',ApexPages.currentPage().getUrl());
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    //Method for Edit button on ASIC Approval SubTab
    public pageReference EditButtonOnASICApprovalTab(){
        pgRef = new pageReference('/apex/CuSRForm?id='+cusrForm.Id);
        pgRef.getParameters().put('tabname','asic');
        pgRef.getParameters().put('maltasubtabname','asicapproval');
        pgRef.getParameters().put('ReturnUrl',ApexPages.currentPage().getUrl());
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    //Method for Edit button on ASIC Implementation SubTab
    public pageReference EditButtonOnASICImplementationTab(){
        pgRef = new pageReference('/apex/CuSRForm?id='+cusrForm.Id);
        pgRef.getParameters().put('tabname','asic');
        pgRef.getParameters().put('maltasubtabname','asicimplementation');
        pgRef.getParameters().put('ReturnUrl',ApexPages.currentPage().getUrl());
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    //method for Edit button on PM tab
    public pageReference EditButtonOnPMTab(){
        pgRef = new pageReference('/apex/CuSRForm?Id='+cusrForm.Id);
        pgRef.getParameters().put('tabname','pm');
        pgRef.getParameters().put('ReturnUrl',ApexPages.currentPage().getUrl());
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    //Method to create new Cost for Dresden Site
    public pageReference addCuSRCostForDresden(){
        pgRef = new pageReference('/apex/CuSRNewEditCostInfo');
        pgRef.getParameters().put('Site','Dresden');
        pgRef.getParameters().put('CuSRForm',cusrForm.Id);
        pgRef.setRedirect(true);
        return pgRef;
        
    }
    
    //Method to create new Cost for Singapore Site
    public pageReference addCuSRCostForSingapore(){
        pgRef = new pageReference('/apex/CuSRNewEditCostInfo');
        pgRef.getParameters().put('Site','Singapore');
        pgRef.getParameters().put('CuSRForm',cusrForm.Id);
        pgRef.setRedirect(true);
        return pgRef;
        
    }
    
    //Method to create new Cost for Malta Site
    public pageReference addCuSRCostForMalta(){
        pgRef = new pageReference('/apex/CuSRNewEditCostInfo');
        pgRef.getParameters().put('Site','Malta');
        pgRef.getParameters().put('CuSRForm',cusrForm.Id);
        pgRef.setRedirect(true);
        return pgRef;
        
    }
    
    //Method to create new Cost for Essex Junction Site
    public pageReference addCuSRCostForEssexJunction(){
        pgRef = new pageReference('/apex/CuSRNewEditCostInfo');
        pgRef.getParameters().put('Site','Essex Junction');
        pgRef.getParameters().put('CuSRForm',cusrForm.Id);
        pgRef.setRedirect(true);
        return pgRef;
        
    }
    
    //Method to create new Cost for East Fishkill Site
    public pageReference addCuSRCostForEastFishkill(){
        pgRef = new pageReference('/apex/CuSRNewEditCostInfo');
        pgRef.getParameters().put('Site','East Fishkill');
        pgRef.getParameters().put('CuSRForm',cusrForm.Id);
        pgRef.setRedirect(true);
        return pgRef;
        
    }
    
    //Method to create new Cost for ASIC Site
    public pageReference addCuSRCostForASIC(){
        pgRef = new pageReference('/apex/CuSRNewEditCostInfo');
        pgRef.getParameters().put('Site','ASIC');
        pgRef.getParameters().put('CuSRForm',cusrForm.Id);
        pgRef.setRedirect(true);
        return pgRef;
        
    }
    
    public void validateFab1ApproverMethod(){
        validateFab1Approvers = true;
        if((fab1Approver.No_of_Approvers__c == '1' && fab1Approver.Approver1__c == null)||(fab1Approver.No_of_Approvers__c == '2' && (fab1Approver.Approver1__c == null || fab1Approver.Approver2__c == null))||(fab1Approver.No_of_Approvers__c == '3' && (fab1Approver.Approver1__c == null || fab1Approver.Approver2__c == null || fab1Approver.Approver3__c == null))||(fab1Approver.No_of_Approvers__c == '4' && (fab1Approver.Approver1__c == null || fab1Approver.Approver2__c == null || fab1Approver.Approver3__c == null || fab1Approver.Approver4__c == null))||(fab1Approver.No_of_Approvers__c == '5' && (fab1Approver.Approver1__c == null || fab1Approver.Approver2__c == null || fab1Approver.Approver3__c == null || fab1Approver.Approver4__c == null || fab1Approver.Approver5__c == null))){
            validateFab1Approvers = false;
            showDresdenErrorMessage = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter the approvers for FAB 1.'));
        }
    }
    
    public void validateFab2ApproverMethod(){
        validateFab2Approvers = true;
        if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && ((fab2Approver.No_of_Approvers__c == '1' && fab2Approver.Approver1__c == null)||(fab2Approver.No_of_Approvers__c == '2' && (fab2Approver.Approver1__c == null || fab2Approver.Approver2__c == null))||(fab2Approver.No_of_Approvers__c == '3' && (fab2Approver.Approver1__c == null || fab2Approver.Approver2__c == null || fab2Approver.Approver3__c == null))||(fab2Approver.No_of_Approvers__c == '4' && (fab2Approver.Approver1__c == null || fab2Approver.Approver2__c == null || fab2Approver.Approver3__c == null || fab2Approver.Approver4__c == null))||(fab2Approver.No_of_Approvers__c == '5' && (fab2Approver.Approver1__c == null || fab2Approver.Approver2__c == null || fab2Approver.Approver3__c == null || fab2Approver.Approver4__c == null || fab2Approver.Approver5__c == null)))){
            validateFab2Approvers = false;
            showSingaporeErrorMessage = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter the approvers for FAB 2.'));
        }
    }
    
    public void validateFab3ApproverMethod(){
        validateFab3Approvers = true;
        if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && ((fab3Approver.No_of_Approvers__c == '1' && fab3Approver.Approver1__c == null)||(fab3Approver.No_of_Approvers__c == '2' && (fab3Approver.Approver1__c == null || fab3Approver.Approver2__c == null))||(fab3Approver.No_of_Approvers__c == '3' && (fab3Approver.Approver1__c == null || fab3Approver.Approver2__c == null || fab3Approver.Approver3__c == null))||(fab3Approver.No_of_Approvers__c == '4' && (fab3Approver.Approver1__c == null || fab3Approver.Approver2__c == null || fab3Approver.Approver3__c == null || fab3Approver.Approver4__c == null))||(fab3Approver.No_of_Approvers__c == '5' && (fab3Approver.Approver1__c == null || fab3Approver.Approver2__c == null || fab3Approver.Approver3__c == null || fab3Approver.Approver4__c == null || fab3Approver.Approver5__c == null)))){
            validateFab3Approvers = false;
            showSingaporeErrorMessage = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter the approvers for FAB 3.'));
        }
    }
    
    public void validateFab3eApproverMethod(){
        validateFab3eApprovers = true;
        if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && ((fab3eApprover.No_of_Approvers__c == '1' && fab3eApprover.Approver1__c == null)||(fab3eApprover.No_of_Approvers__c == '2' && (fab3eApprover.Approver1__c == null || fab3eApprover.Approver2__c == null))||(fab3eApprover.No_of_Approvers__c == '3' && (fab3eApprover.Approver1__c == null || fab3eApprover.Approver2__c == null || fab3eApprover.Approver3__c == null))||(fab3eApprover.No_of_Approvers__c == '4' && (fab3eApprover.Approver1__c == null || fab3eApprover.Approver2__c == null || fab3eApprover.Approver3__c == null || fab3eApprover.Approver4__c == null))||(fab3eApprover.No_of_Approvers__c == '5' && (fab3eApprover.Approver1__c == null || fab3eApprover.Approver2__c == null || fab3eApprover.Approver3__c == null || fab3eApprover.Approver4__c == null || fab3eApprover.Approver5__c == null)))){
            validateFab3eApprovers = false;
            showSingaporeErrorMessage = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter the approvers FAB 3E.'));
        }
    }
    
    public void validateFab5ApproverMethod(){
        validateFab5Approvers = true;
        if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && ((fab5Approver.No_of_Approvers__c == '1' && fab5Approver.Approver1__c == null)||(fab5Approver.No_of_Approvers__c == '2' && (fab5Approver.Approver1__c == null || fab5Approver.Approver2__c == null))||(fab5Approver.No_of_Approvers__c == '3' && (fab5Approver.Approver1__c == null || fab5Approver.Approver2__c == null || fab5Approver.Approver3__c == null))||(fab5Approver.No_of_Approvers__c == '4' && (fab5Approver.Approver1__c == null || fab5Approver.Approver2__c == null || fab5Approver.Approver3__c == null || fab5Approver.Approver4__c == null))||(fab5Approver.No_of_Approvers__c == '5' && (fab5Approver.Approver1__c == null || fab5Approver.Approver2__c == null || fab5Approver.Approver3__c == null || fab5Approver.Approver4__c == null || fab5Approver.Approver5__c == null)))){
            validateFab5Approvers = false;
            showSingaporeErrorMessage = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter the approvers for FAB 5.'));
        }
    }
    
    public void validateFab6ApproverMethod(){
        validateFab6Approvers = true;
        if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && ((fab6Approver.No_of_Approvers__c == '1' && fab6Approver.Approver1__c == null)||(fab6Approver.No_of_Approvers__c == '2' && (fab6Approver.Approver1__c == null || fab6Approver.Approver2__c == null))||(fab6Approver.No_of_Approvers__c == '3' && (fab6Approver.Approver1__c == null || fab6Approver.Approver2__c == null || fab6Approver.Approver3__c == null))||(fab6Approver.No_of_Approvers__c == '4' && (fab6Approver.Approver1__c == null || fab6Approver.Approver2__c == null || fab6Approver.Approver3__c == null || fab6Approver.Approver4__c == null))||(fab6Approver.No_of_Approvers__c == '5' && (fab6Approver.Approver1__c == null || fab6Approver.Approver2__c == null || fab6Approver.Approver3__c == null || fab6Approver.Approver4__c == null || fab6Approver.Approver5__c == null)))){
            validateFab6Approvers = false;
            showSingaporeErrorMessage = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter the approvers for FAB 6.'));
        }
    }
    
    public void validateFab7ApproverMethod(){
        validateFab7Approvers = true;
        if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'Yes' && ((fab7Approver.No_of_Approvers__c == '1' && fab7Approver.Approver1__c == null)||(fab7Approver.No_of_Approvers__c == '2' && (fab7Approver.Approver1__c == null || fab7Approver.Approver2__c == null))||(fab7Approver.No_of_Approvers__c == '3' && (fab7Approver.Approver1__c == null || fab7Approver.Approver2__c == null || fab7Approver.Approver3__c == null))||(fab7Approver.No_of_Approvers__c == '4' && (fab7Approver.Approver1__c == null || fab7Approver.Approver2__c == null || fab7Approver.Approver3__c == null || fab7Approver.Approver4__c == null))||(fab7Approver.No_of_Approvers__c == '5' && (fab7Approver.Approver1__c == null || fab7Approver.Approver2__c == null || fab7Approver.Approver3__c == null || fab7Approver.Approver4__c == null || fab7Approver.Approver5__c == null)))){
            validateFab7Approvers = false;
            showSingaporeErrorMessage = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter the approvers for FAB 7.'));
        }
    }
    
    public void validateFab8ApproverMethod(){
        validateFab8Approvers = true;
        if((fab8Approver.No_of_Approvers__c == '1' && fab8Approver.Approver1__c == null)||(fab8Approver.No_of_Approvers__c == '2' && (fab8Approver.Approver1__c == null || fab8Approver.Approver2__c == null))||(fab8Approver.No_of_Approvers__c == '3' && (fab8Approver.Approver1__c == null || fab8Approver.Approver2__c == null || fab8Approver.Approver3__c == null))||(fab8Approver.No_of_Approvers__c == '4' && (fab8Approver.Approver1__c == null || fab8Approver.Approver2__c == null || fab8Approver.Approver3__c == null || fab8Approver.Approver4__c == null))||(fab8Approver.No_of_Approvers__c == '5' && (fab8Approver.Approver1__c == null || fab8Approver.Approver2__c == null || fab8Approver.Approver3__c == null || fab8Approver.Approver4__c == null || fab8Approver.Approver5__c == null))){
            validateFab8Approvers = false;
            showMaltaErrorMessage = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter the approvers for FAB 8.'));
        }
    }
    public void validateFab9ApproverMethod(){
        validateFab9Approvers = true;
        if((fab9Approver.No_of_Approvers__c == '1' && fab9Approver.Approver1__c == null)||(fab9Approver.No_of_Approvers__c == '2' && (fab9Approver.Approver1__c == null || fab9Approver.Approver2__c == null))||(fab9Approver.No_of_Approvers__c == '3' && (fab9Approver.Approver1__c == null || fab9Approver.Approver2__c == null || fab9Approver.Approver3__c == null))||(fab9Approver.No_of_Approvers__c == '4' && (fab9Approver.Approver1__c == null || fab9Approver.Approver2__c == null || fab9Approver.Approver3__c == null || fab9Approver.Approver4__c == null))||(fab9Approver.No_of_Approvers__c == '5' && (fab9Approver.Approver1__c == null || fab9Approver.Approver2__c == null || fab9Approver.Approver3__c == null || fab9Approver.Approver4__c == null || fab9Approver.Approver5__c == null))){
            validateFab9Approvers = false;
            showEssexJunctionErrorMessage = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter the approvers for FAB 9.'));
        }
    }
    public void validateFab10ApproverMethod(){
        validateFab10Approvers = true;
        if((fab10Approver.No_of_Approvers__c == '1' && fab10Approver.Approver1__c == null)||(fab10Approver.No_of_Approvers__c == '2' && (fab10Approver.Approver1__c == null || fab10Approver.Approver2__c == null))||(fab10Approver.No_of_Approvers__c == '3' && (fab10Approver.Approver1__c == null || fab10Approver.Approver2__c == null || fab10Approver.Approver3__c == null))||(fab10Approver.No_of_Approvers__c == '4' && (fab10Approver.Approver1__c == null || fab10Approver.Approver2__c == null || fab10Approver.Approver3__c == null || fab10Approver.Approver4__c == null))||(fab10Approver.No_of_Approvers__c == '5' && (fab10Approver.Approver1__c == null || fab10Approver.Approver2__c == null || fab10Approver.Approver3__c == null || fab10Approver.Approver4__c == null || fab10Approver.Approver5__c == null))){
            validateFab10Approvers = false;
            showEastFishkillErrorMessage = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter the approvers for FAB 10.'));
        }
    }
    
    public void validateASICApproverMethod(){
        validateASICApprovers = true;
        if((asicApprover.No_of_Approvers__c == '1' && asicApprover.Approver1__c == null)||(asicApprover.No_of_Approvers__c == '2' && (asicApprover.Approver1__c == null || asicApprover.Approver2__c == null))||(asicApprover.No_of_Approvers__c == '3' && (asicApprover.Approver1__c == null || asicApprover.Approver2__c == null || asicApprover.Approver3__c == null))||(asicApprover.No_of_Approvers__c == '4' && (asicApprover.Approver1__c == null || asicApprover.Approver2__c == null || asicApprover.Approver3__c == null || asicApprover.Approver4__c == null))||(asicApprover.No_of_Approvers__c == '5' && (asicApprover.Approver1__c == null || asicApprover.Approver2__c == null || asicApprover.Approver3__c == null || asicApprover.Approver4__c == null || asicApprover.Approver5__c == null))){
            validateASICApprovers = false;
            showASICErrorMessage = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter the approvers for ASIC.'));
        }
    }
    
    public void validateDresdenSystemApproverMethods(){
        validateDresdenSystemApprover = true;
        if(cusrForm.Dresden_System_Owner_Approval_Required__c == 'Yes' &&  ((dresdenSystemOwnerApproval.No_of_Approvers__c == '1' && dresdenSystemOwnerApproval.Approver1__c == null)||(dresdenSystemOwnerApproval.No_of_Approvers__c == '2' && (dresdenSystemOwnerApproval.Approver1__c == null || dresdenSystemOwnerApproval.Approver2__c == null))||(dresdenSystemOwnerApproval.No_of_Approvers__c == '3' && (dresdenSystemOwnerApproval.Approver1__c == null || dresdenSystemOwnerApproval.Approver2__c == null || dresdenSystemOwnerApproval.Approver3__c == null))||(dresdenSystemOwnerApproval.No_of_Approvers__c == '4' && (dresdenSystemOwnerApproval.Approver1__c == null || dresdenSystemOwnerApproval.Approver2__c == null || dresdenSystemOwnerApproval.Approver3__c == null || dresdenSystemOwnerApproval.Approver4__c == null))||(dresdenSystemOwnerApproval.No_of_Approvers__c == '5' && (dresdenSystemOwnerApproval.Approver1__c == null || dresdenSystemOwnerApproval.Approver2__c == null || dresdenSystemOwnerApproval.Approver3__c == null || dresdenSystemOwnerApproval.Approver4__c == null || dresdenSystemOwnerApproval.Approver5__c == null)))){
            validateDresdenSystemApprover= false;
            showDresdenErrorMessage = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter the approvers for Dresden System Owner.'));
        }
    }
    
    public void validateSingaporeSystemApproverMethods(){
        validateSingaporeSystemApprover = true;
        if(cusrForm.Singapore_System_Owner_Approval_Required__c == 'Yes' &&  ((singaporeSystemOwnerApproval.No_of_Approvers__c == '1' && singaporeSystemOwnerApproval.Approver1__c == null)||(singaporeSystemOwnerApproval.No_of_Approvers__c == '2' && (singaporeSystemOwnerApproval.Approver1__c == null || singaporeSystemOwnerApproval.Approver2__c == null))||(singaporeSystemOwnerApproval.No_of_Approvers__c == '3' && (singaporeSystemOwnerApproval.Approver1__c == null || singaporeSystemOwnerApproval.Approver2__c == null || singaporeSystemOwnerApproval.Approver3__c == null))||(singaporeSystemOwnerApproval.No_of_Approvers__c == '4' && (singaporeSystemOwnerApproval.Approver1__c == null || singaporeSystemOwnerApproval.Approver2__c == null || singaporeSystemOwnerApproval.Approver3__c == null || singaporeSystemOwnerApproval.Approver4__c == null))||(singaporeSystemOwnerApproval.No_of_Approvers__c == '5' && (singaporeSystemOwnerApproval.Approver1__c == null || singaporeSystemOwnerApproval.Approver2__c == null || singaporeSystemOwnerApproval.Approver3__c == null || singaporeSystemOwnerApproval.Approver4__c == null || singaporeSystemOwnerApproval.Approver5__c == null)))){
            validateSingaporeSystemApprover= false;
            showSingaporeErrorMessage = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter the approvers for Singapore System Owner.'));
        }
    }
    
    public void validateMaltaSystemApproverMethods(){
        validateMaltaSystemApprover = true;
        if(cusrForm.Malta_System_Owner_Approval_Required__c == 'Yes' &&  ((maltaSystemOwnerApproval.No_of_Approvers__c == '1' && maltaSystemOwnerApproval.Approver1__c == null)||(maltaSystemOwnerApproval.No_of_Approvers__c == '2' && (maltaSystemOwnerApproval.Approver1__c == null || maltaSystemOwnerApproval.Approver2__c == null))||(maltaSystemOwnerApproval.No_of_Approvers__c == '3' && (maltaSystemOwnerApproval.Approver1__c == null || maltaSystemOwnerApproval.Approver2__c == null || maltaSystemOwnerApproval.Approver3__c == null))||(maltaSystemOwnerApproval.No_of_Approvers__c == '4' && (maltaSystemOwnerApproval.Approver1__c == null || maltaSystemOwnerApproval.Approver2__c == null || maltaSystemOwnerApproval.Approver3__c == null || maltaSystemOwnerApproval.Approver4__c == null))||(maltaSystemOwnerApproval.No_of_Approvers__c == '5' && (maltaSystemOwnerApproval.Approver1__c == null || maltaSystemOwnerApproval.Approver2__c == null || maltaSystemOwnerApproval.Approver3__c == null || maltaSystemOwnerApproval.Approver4__c == null || maltaSystemOwnerApproval.Approver5__c == null)))){
            validateMaltaSystemApprover= false;
            showMaltaErrorMessage = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter the approvers for Malta System Owner.'));
        }
    }
    
    public void validateEssexJunctionSystemApproverMethods(){
        validateEssexJunctionSystemApprover = true;
        if(cusrForm.Esx_Jun_System_Owner_Approval_Required__c == 'Yes' &&  ((essexJunctionSystemOwnerApproval.No_of_Approvers__c == '1' && essexJunctionSystemOwnerApproval.Approver1__c == null)||(essexJunctionSystemOwnerApproval.No_of_Approvers__c == '2' && (essexJunctionSystemOwnerApproval.Approver1__c == null || essexJunctionSystemOwnerApproval.Approver2__c == null))||(essexJunctionSystemOwnerApproval.No_of_Approvers__c == '3' && (essexJunctionSystemOwnerApproval.Approver1__c == null || essexJunctionSystemOwnerApproval.Approver2__c == null || essexJunctionSystemOwnerApproval.Approver3__c == null))||(essexJunctionSystemOwnerApproval.No_of_Approvers__c == '4' && (essexJunctionSystemOwnerApproval.Approver1__c == null || essexJunctionSystemOwnerApproval.Approver2__c == null || essexJunctionSystemOwnerApproval.Approver3__c == null || essexJunctionSystemOwnerApproval.Approver4__c == null))||(essexJunctionSystemOwnerApproval.No_of_Approvers__c == '5' && (essexJunctionSystemOwnerApproval.Approver1__c == null || essexJunctionSystemOwnerApproval.Approver2__c == null || essexJunctionSystemOwnerApproval.Approver3__c == null || essexJunctionSystemOwnerApproval.Approver4__c == null || essexJunctionSystemOwnerApproval.Approver5__c == null)))){
            validateEssexJunctionSystemApprover= false;
            showEssexJunctionErrorMessage = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter the approvers for Essex Junction System Owner.'));
        }
    }
    
    public void validateEastFishkillSystemApproverMethods(){
        validateEastFishkillSystemApprover = true;
        if(cusrForm.EastFishkillSystemOwnerApproval_Required__c == 'Yes' &&  ((eastFishkillSystemOwnerApproval.No_of_Approvers__c == '1' && eastFishkillSystemOwnerApproval.Approver1__c == null)||(eastFishkillSystemOwnerApproval.No_of_Approvers__c == '2' && (eastFishkillSystemOwnerApproval.Approver1__c == null || eastFishkillSystemOwnerApproval.Approver2__c == null))||(eastFishkillSystemOwnerApproval.No_of_Approvers__c == '3' && (eastFishkillSystemOwnerApproval.Approver1__c == null || eastFishkillSystemOwnerApproval.Approver2__c == null || eastFishkillSystemOwnerApproval.Approver3__c == null))||(eastFishkillSystemOwnerApproval.No_of_Approvers__c == '4' && (eastFishkillSystemOwnerApproval.Approver1__c == null || eastFishkillSystemOwnerApproval.Approver2__c == null || eastFishkillSystemOwnerApproval.Approver3__c == null || eastFishkillSystemOwnerApproval.Approver4__c == null))||(eastFishkillSystemOwnerApproval.No_of_Approvers__c == '5' && (eastFishkillSystemOwnerApproval.Approver1__c == null || eastFishkillSystemOwnerApproval.Approver2__c == null || eastFishkillSystemOwnerApproval.Approver3__c == null || eastFishkillSystemOwnerApproval.Approver4__c == null || eastFishkillSystemOwnerApproval.Approver5__c == null)))){
            validateEastFishkillSystemApprover= false;
            showEastFishkillErrorMessage = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter the approvers for East Fishkill System Owner.'));
        }
    }
    
    public void validateASICSystemApproverMethods(){
        validateASICSystemApprover = true;
        if(cusrForm.ASIC_System_Owner_Approval_Required__c == 'Yes' &&  ((asicSystemOwnerApproval.No_of_Approvers__c == '1' && asicSystemOwnerApproval.Approver1__c == null)||(asicSystemOwnerApproval.No_of_Approvers__c == '2' && (asicSystemOwnerApproval.Approver1__c == null || asicSystemOwnerApproval.Approver2__c == null))||(asicSystemOwnerApproval.No_of_Approvers__c == '3' && (asicSystemOwnerApproval.Approver1__c == null || asicSystemOwnerApproval.Approver2__c == null || asicSystemOwnerApproval.Approver3__c == null))||(asicSystemOwnerApproval.No_of_Approvers__c == '4' && (asicSystemOwnerApproval.Approver1__c == null || asicSystemOwnerApproval.Approver2__c == null || asicSystemOwnerApproval.Approver3__c == null || asicSystemOwnerApproval.Approver4__c == null))||(asicSystemOwnerApproval.No_of_Approvers__c == '5' && (asicSystemOwnerApproval.Approver1__c == null || asicSystemOwnerApproval.Approver2__c == null || asicSystemOwnerApproval.Approver3__c == null || asicSystemOwnerApproval.Approver4__c == null || asicSystemOwnerApproval.Approver5__c == null)))){
            validateASICSystemApprover= false;
            showASICErrorMessage = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter the approvers for ASIC System Owner.'));
        }
    }
    
    public void validateSingaporeFabApproverMethods(){
        validateSingaporeFabApprover = true;
        if(cusrForm.Singapore_Individual_Fab_Owner_Approval__c == 'No' && ((singaporeFabOwnerApproval.No_of_Approvers__c == '1' && singaporeFabOwnerApproval.Approver1__c == null)||(singaporeFabOwnerApproval.No_of_Approvers__c == '2' && (singaporeFabOwnerApproval.Approver1__c == null || singaporeFabOwnerApproval.Approver2__c == null))||(singaporeFabOwnerApproval.No_of_Approvers__c == '3' && (singaporeFabOwnerApproval.Approver1__c == null || singaporeFabOwnerApproval.Approver2__c == null || singaporeFabOwnerApproval.Approver3__c == null))||(singaporeFabOwnerApproval.No_of_Approvers__c == '4' && (singaporeFabOwnerApproval.Approver1__c == null || singaporeFabOwnerApproval.Approver2__c == null || singaporeFabOwnerApproval.Approver3__c == null || singaporeFabOwnerApproval.Approver4__c == null))||(singaporeFabOwnerApproval.No_of_Approvers__c == '5' && (singaporeFabOwnerApproval.Approver1__c == null || singaporeFabOwnerApproval.Approver2__c == null || singaporeFabOwnerApproval.Approver3__c == null || singaporeFabOwnerApproval.Approver4__c == null || singaporeFabOwnerApproval.Approver5__c == null)))){
            validateSingaporeFabApprover = false;
            showSingaporeErrorMessage = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter the approvers for Fab Owner.'));
        }
    }
    
    //method to navigate to void form
    /*public pageReference voidAction(){
        pgRef = new pageReference('/apex/CuSRFormReasonToVoidForm?Id='+cusrForm.Id);
        pgRef.getParameters().put('ReturnUrl',ApexPages.currentPage().getUrl());
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    //method to void the request
    public pageReference submitToVoid(){
        pgRef = new pageReference('/'+cusrForm.Id);
        cusrForm.Status__c = 'Void';
        update cusrForm;
        pgRef.setRedirect(true);
        return pgRef;
    }*/
    
    //method to save updated CUSR after implementation
    /*public pageReference saveUpdatedCUSR(){
        pgRef = new pageReference('/'+cusrForm.Id);
        update cusrForm;
        pgRef.getParameters().put('tabname','initiator');
        pgRef.setRedirect(true);
        return pgRef;
    }*/
    
    public pageReference saveUpdatedCUSR(){
        pgRef = new pageReference('/'+cusrForm.Id);
        validateFieldsBeforeSave();
        if(!validateFields){
            /*if(fileBody != null){
                fileBody = null;
                fileName = '';
                showAttachmentError = true;
            }*/
            return null;
        }
        else{
            update cusrForm;
            pgRef.getParameters().put('tabname','initiator');
            pgRef.setRedirect(true);
            return pgRef;
        }
    }
    
    public pageReference cancelUpdateCUSR(){
        pgRef = new pageReference('/'+cusrForm.Id);
        pgRef.getParameters().put('tabname','initiator');
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public void validatePMApproval(){
        pmErrorMessage = false;
        if(cusrForm.Any_Cost_Impact__c == 'Yes' && (cusrForm.PM_Comments__c == '' || cusrForm.PM_Comments__c == null)){
            pmErrorMessage = true;
            cusrForm.PM_Comments__c.addError('Please mention comments for Approval.');
        }
    }
    
    //method for PM Approval
    public pageReference pmApproved(){
        validatePMApproval();
        if(pmErrorMessage){
                return null;
        }
        else{
            cusrForm.PM_Approved_By__c = loggedInUser.Id;
            update cusrForm;
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments(cusrForm.PM_Comments__c);
            req.setAction('Approve');
            Id workItemId = getWorkItemId(cusrForm.id);
            req.setWorkitemId(workItemId);
            Approval.ProcessResult result =  Approval.process(req);
            /*cusrForm.PM_Approved_By__c = loggedInUser.Id;
            update cusrForm;*/
            pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrForm.Id);
            pgRef.getParameters().put('tabname','initiator');
            pgRef.setRedirect(true);
            return pgRef;
        }
    }
    
    //method to reject by PM
    public pageReference pmRejected(){
        pmErrorMessage = false;
        if(cusrForm.PM_Comments__c == '' || cusrForm.PM_Comments__c == null){
                pmErrorMessage = true;
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please mention comments for Rejection.'));
                cusrForm.PM_Comments__c.addError('Please mention comments for Rejection.');
            return null;
        }
        else{
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments(cusrForm.PM_Comments__c);
            req.setAction('Reject');
            Id workItemId = getWorkItemId(cusrForm.id);
            req.setWorkitemId(workItemId);
            Approval.ProcessResult result =  Approval.process(req);
            resetCuSRForm();
            sendEmailAfterPMRejection();
            pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrForm.Id);
            pgRef.getParameters().put('tabname','initiator');
            pgRef.setRedirect(true);
            return pgRef;
        }
    }
    
    public void sendEmailAfterPMRejection(){
        String userType = Schema.SObjectType.User.getKeyPrefix();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        UtilClassToGetAllFields utilClass = new UtilClassToGetAllFields();
        Set<Id> ccIdSet = new Set<Id>();
        if(cusrForm.Customer_Name__c != null){
            Account acc = [select Id, Name from Account where Id =: cusrForm.Customer_Name__c];
            String fieldsAccountTeamProxy = utilClass.getAllFields('Account_Team_Proxy__c');
            fieldsAccountTeamProxy += ', User__r.Name';
            String queryAccountTeamProxy = 'select '+fieldsAccountTeamProxy+' from Account_Team_Proxy__c where Account__c = \''+acc.Id+'\' and Team_Role__c = \'Customer Engineer\'';
            List<Account_Team_Proxy__c> accountTeamProxyList = Database.query(queryAccountTeamProxy);
            pmGroup = new Group();
            pmGroup = [select Type, Id, Name from Group where Type =: 'QUEUE' and Name ='CuSR PM Queue'];
            for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: pmGroup.Id]){
                if(((String)m.UserOrGroupId).startsWith(userType)){
                    ccIdSet.add(m.UserOrGroupId);
                }
            }
            for(Account_Team_Proxy__c ce : accountTeamProxyList){
                if((ce.Fab_Assignment__c.contains('FAB 1') && cusrForm.FAB_1__c) || (ce.Fab_Assignment__c.contains('FAB 2') && cusrForm.FAB_2__c) || (ce.Fab_Assignment__c.contains('FAB 3') && cusrForm.FAB_3__c) || (ce.Fab_Assignment__c.contains('E') && cusrForm.FAB_3E__c) || (ce.Fab_Assignment__c.contains('FAB 5') && cusrForm.FAB_5__c) || (ce.Fab_Assignment__c.contains('FAB 6') && cusrForm.FAB_6__c) || (ce.Fab_Assignment__c.contains('FAB 7') && cusrForm.FAB_7__c) || (ce.Fab_Assignment__c.contains('FAB 8') && cusrForm.FAB_8__c) || (ce.Fab_Assignment__c.contains('FAB 9') && cusrForm.FAB_9__c) || (ce.Fab_Assignment__c.contains('FAB 10') && cusrForm.FAB_10__c) || (ce.Fab_Assignment__c.contains('ASIC') && cusrForm.ASIC__c)){
                    ccIdSet.add(ce.User__c);    
                }
            } 
            if(cusrApproverList.size() > 0){
                for(CuSR_Approval_Process__c cusrApp: cusrApproverList){
                    if(cusrApp.Approver1__c != null){
                        ccIdSet.add(cusrApp.Approver1__c);
                    }
                    if(cusrApp.Approver2__c != null){
                        ccIdSet.add(cusrApp.Approver2__c);
                    }
                    if(cusrApp.Approver3__c != null){
                        ccIdSet.add(cusrApp.Approver3__c);
                    }
                    if(cusrApp.Approver4__c != null){
                        ccIdSet.add(cusrApp.Approver4__c);
                    }
                    if(cusrApp.Approver5__c != null){
                        ccIdSet.add(cusrApp.Approver5__c);
                    } 
                }
            }
            List<User> ccUserList = [select Id, Name, Email from User where Id IN: ccIdSet];
            Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
            List<String> ccList = new List<String>();
            for(User c: ccUserList){
                ccList.add(c.Email);
            }
            singleMail.setTargetObjectId(cusrForm.OwnerId);
            singleMail.setCcAddresses(ccList);
            singleMail.saveAsActivity = false;
            singleMail.setSubject('Customer Specific Request '+cusrForm.Name+' for Account '+acc.Name+' is Rejected by PM');
            String body = 'Dear User,';
            body += '<br/>';
            body += '<br/>';
            body += 'Customer Specific Request '+cusrForm.Name+' for Account '+acc.Name+' is Rejected by PM.';
            body += '<br/>';
            body += 'Please click the below link to access the record.';
            body += '<br/>';
            body += '<br/>';
            String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id;
            body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+hyperLink+'</a>';
            //body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+cusrForm.Name+'</a>';
            body += '<br/>';
            body += '<br/>';
            body += 'Thank you,';
            body += '<br/>';
            body += 'For further clarification/query , please contact the Initiator of the CuSR.';
            body += '<br/>';
            body += 'This is a system generated auto email. Please do not reply.';
            singleMail.setHtmlBody(body);
            mails.add(singleMail);
        }
        if(mails.size() > 0){
            Messaging.sendEmail(mails);
        }   
    }
    
    public void resetCuSRForm(){
        List<CuSR_Approval_Process__c> cusrApprovalProcessList = new List<CuSR_Approval_Process__c>();
        cusrApprovalProcessList = [select Id, Status__c, CuSR_Form__c from CuSR_Approval_Process__c where CuSR_Form__c =: cusrForm.Id];
        for(CuSR_Approval_Process__c cusrApprovalProcess: cusrApprovalProcessList){
                cusrApprovalProcess.Approved__c = false;
                //update cusrApprovalProcess;
        }
        update cusrApprovalProcessList;
        cusrForm.Dresden_Ready_for_Approval__c = false;
                cusrForm.Singapore_Ready_for_Approval__c = false;
                cusrForm.Malta_Ready_for_Approval__c = false;
                cusrForm.Stakeholder_Approval_Completed__c = false;
                cusrForm.Status__c = 'Rejected';
                cusrForm.Fifth_Day_Reminder__c = false;
                cusrForm.Ninth_Day_Reminder__c = false;
                update cusrForm;                
    }
    
    //method to get workitemid
    public Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;
        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: targetObjectId]){
            retVal  =  workItem.Id;
        }
        return retVal;
    }
    
    public PageReference selectclick(){
        rightselected.clear();
        for(String s : leftselected){
            leftvalues.remove(s);
            rightvalues.add(s);
        }
        return null;
    }
     
    public PageReference unselectclick(){
        leftselected.clear();
        for(String s : rightselected){
            rightvalues.remove(s);
            leftvalues.add(s);
        }
        return null;
    }
    
    public List<SelectOption> getunSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftvalues);
        tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
        return options;
    }
 
    public List<SelectOption> getSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightvalues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }
    
    public void queryFab1Technologies(){
                //String selectedFab = ApexPages.currentPage().getParameters().get('fab1param');
                List<AggregateResult> processList = new List<AggregateResult>(); 
                boolean clearRightValues = false;
            String query = 'select Org_ID__c, Tech_Type__c, Tech_Geometry__c from Process__c where Org_ID__c = \'FAB 1\' group by Org_ID__c, Tech_Type__c, Tech_Geometry__c';
            processList = database.query(query);
            system.debug('Size of process: '+processList.size());
            if(processList.size() > 0){
                for(AggregateResult processes: processList){
                        if(cusrForm.FAB_1__c){
                                leftvalues.add(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                        else{
                                        clearRightValues = true;
                                leftvalues.remove(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                }  
                if(clearRightValues){
                        rightvalues.clear();
                        leftvalues.add('ALL TECHNOLOGIES');
                }     
            }
        }
        
        public void queryFab2Technologies(){
                //String selectedFab = ApexPages.currentPage().getParameters().get('fab1param');
                List<AggregateResult> processList = new List<AggregateResult>(); 
                boolean clearRightValues = false;
            String query = 'select Org_ID__c, Tech_Type__c, Tech_Geometry__c from Process__c where Org_ID__c = \'FAB 2\' group by Org_ID__c, Tech_Type__c, Tech_Geometry__c';
            processList = database.query(query);
            system.debug('Size of process: '+processList.size());
            if(processList.size() > 0){
                for(AggregateResult processes: processList){
                        if(cusrForm.FAB_2__c){
                                leftvalues.add(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                        else{
                                        clearRightValues = true;
                                leftvalues.remove(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                }
                if(clearRightValues){
                        rightvalues.clear();
                        leftvalues.add('ALL TECHNOLOGIES');
                }       
            }
        }
        
        public void queryFab3Technologies(){
                //String selectedFab = ApexPages.currentPage().getParameters().get('fab1param');
                List<AggregateResult> processList = new List<AggregateResult>(); 
                boolean clearRightValues = false;
            String query = 'select Org_ID__c, Tech_Type__c, Tech_Geometry__c from Process__c where Org_ID__c = \'FAB 3\' group by Org_ID__c, Tech_Type__c, Tech_Geometry__c';
            processList = database.query(query);
            system.debug('Size of process: '+processList.size());
            if(processList.size() > 0){
                for(AggregateResult processes: processList){
                        if(cusrForm.FAB_3__c){
                                leftvalues.add(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                        else{
                                        clearRightValues = true;
                                leftvalues.remove(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                }   
                if(clearRightValues){
                        rightvalues.clear();
                        leftvalues.add('ALL TECHNOLOGIES');
                }    
            }
        }
        
        public void queryFab3eTechnologies(){
        //String selectedFab = ApexPages.currentPage().getParameters().get('fab1param');
        List<AggregateResult> processList = new List<AggregateResult>(); 
            String query = 'select Org_ID__c, Tech_Type__c, Tech_Geometry__c from Process__c where Org_ID__c = \'FAB 3E\' group by Org_ID__c, Tech_Type__c, Tech_Geometry__c';
            boolean clearRightValues = false;
            processList = database.query(query);
            system.debug('Size of process: '+processList.size());
            if(processList.size() > 0){
                for(AggregateResult processes: processList){
                        if(cusrForm.FAB_3E__c){
                                leftvalues.add(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                        else{
                                        clearRightValues = true;
                                leftvalues.remove(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                }  
                if(clearRightValues){
                        rightvalues.clear();
                        leftvalues.add('ALL TECHNOLOGIES');
                }     
            }
        }
        
        public void queryFab5Technologies(){
        //String selectedFab = ApexPages.currentPage().getParameters().get('fab1param');
        List<AggregateResult> processList = new List<AggregateResult>(); 
            String query = 'select Org_ID__c, Tech_Type__c, Tech_Geometry__c from Process__c where Org_ID__c = \'FAB 5\' group by Org_ID__c, Tech_Type__c, Tech_Geometry__c';
            boolean clearRightValues = false;
            processList = database.query(query);
            system.debug('Size of process: '+processList.size());
            if(processList.size() > 0){
                for(AggregateResult processes: processList){
                        if(cusrForm.FAB_5__c){
                                leftvalues.add(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                        else{
                                        clearRightValues = true;
                                leftvalues.remove(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                }  
                if(clearRightValues){
                        rightvalues.clear();
                        leftvalues.add('ALL TECHNOLOGIES');
                }      
            }
        }
        
        public void queryFab6Technologies(){
        //String selectedFab = ApexPages.currentPage().getParameters().get('fab1param');
        List<AggregateResult> processList = new List<AggregateResult>(); 
        boolean clearRightValues = false;
            String query = 'select Org_ID__c, Tech_Type__c, Tech_Geometry__c from Process__c where Org_ID__c = \'FAB 6\' group by Org_ID__c, Tech_Type__c, Tech_Geometry__c';
            processList = database.query(query);
            system.debug('Size of process: '+processList.size());
            if(processList.size() > 0){
                for(AggregateResult processes: processList){
                        if(cusrForm.FAB_6__c){
                                leftvalues.add(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                        else{
                                        clearRightValues = true;
                                leftvalues.remove(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                }  
                if(clearRightValues){
                        rightvalues.clear();
                        leftvalues.add('ALL TECHNOLOGIES');
                }      
            }
        }
        
        public void queryFab7Technologies(){
        //String selectedFab = ApexPages.currentPage().getParameters().get('fab1param');
        List<AggregateResult> processList = new List<AggregateResult>(); 
        boolean clearRightValues = false;
            String query = 'select Org_ID__c, Tech_Type__c, Tech_Geometry__c from Process__c where Org_ID__c = \'FAB 7\' group by Org_ID__c, Tech_Type__c, Tech_Geometry__c';
            processList = database.query(query);
            system.debug('Size of process: '+processList.size());
            if(processList.size() > 0){
                for(AggregateResult processes: processList){
                        if(cusrForm.FAB_7__c){
                                leftvalues.add(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                        else{
                                        clearRightValues = true;
                                leftvalues.remove(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                }
                if(clearRightValues){
                        rightvalues.clear();
                        leftvalues.add('ALL TECHNOLOGIES');
                }       
            }
        }
        
        public void queryFab8Technologies(){
        //String selectedFab = ApexPages.currentPage().getParameters().get('fab1param');
        List<AggregateResult> processList = new List<AggregateResult>(); 
        boolean clearRightValues = false;
            String query = 'select Org_ID__c, Tech_Type__c, Tech_Geometry__c from Process__c where Org_ID__c = \'FAB 8\' group by Org_ID__c, Tech_Type__c, Tech_Geometry__c';
            processList = database.query(query);
            system.debug('Size of process: '+processList.size());
            if(processList.size() > 0){
                for(AggregateResult processes: processList){
                        if(cusrForm.FAB_8__c){
                                leftvalues.add(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                        else{
                                        clearRightValues = true;
                                leftvalues.remove(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                }  
                if(clearRightValues){
                        rightvalues.clear();
                        leftvalues.add('ALL TECHNOLOGIES');
                }     
            }
        }
        public void queryFab9Technologies(){
        //String selectedFab = ApexPages.currentPage().getParameters().get('fab1param');
        List<AggregateResult> processList = new List<AggregateResult>(); 
        boolean clearRightValues = false;
            String query = 'select Org_ID__c, Tech_Type__c, Tech_Geometry__c from Process__c where Org_ID__c = \'FAB 9\' group by Org_ID__c, Tech_Type__c, Tech_Geometry__c';
            processList = database.query(query);
            system.debug('Size of process: '+processList.size());
            if(processList.size() > 0){
                for(AggregateResult processes: processList){
                        if(cusrForm.FAB_9__c){
                                leftvalues.add(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                        else{
                                        clearRightValues = true;
                                leftvalues.remove(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                }  
                if(clearRightValues){
                        rightvalues.clear();
                        leftvalues.add('ALL TECHNOLOGIES');
                }     
            }
        }
        public void queryFab10Technologies(){
        //String selectedFab = ApexPages.currentPage().getParameters().get('fab1param');
        List<AggregateResult> processList = new List<AggregateResult>(); 
        boolean clearRightValues = false;
            String query = 'select Org_ID__c, Tech_Type__c, Tech_Geometry__c from Process__c where Org_ID__c = \'FAB 10\' group by Org_ID__c, Tech_Type__c, Tech_Geometry__c';
            processList = database.query(query);
            system.debug('Size of process: '+processList.size());
            if(processList.size() > 0){
                for(AggregateResult processes: processList){
                        if(cusrForm.FAB_10__c){
                                leftvalues.add(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                        else{
                                        clearRightValues = true;
                                leftvalues.remove(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                }  
                if(clearRightValues){
                        rightvalues.clear();
                        leftvalues.add('ALL TECHNOLOGIES');
                }     
            }
        }
        public void queryASICTechnologies(){
        //String selectedFab = ApexPages.currentPage().getParameters().get('fab1param');
        List<AggregateResult> processList = new List<AggregateResult>(); 
        boolean clearRightValues = false;
            String query = 'select Org_ID__c, Tech_Type__c, Tech_Geometry__c from Process__c where Org_ID__c = \'ASIC\' group by Org_ID__c, Tech_Type__c, Tech_Geometry__c';
            processList = database.query(query);
            system.debug('Size of process: '+processList.size());
            if(processList.size() > 0){
                for(AggregateResult processes: processList){
                        if(cusrForm.ASIC__c){
                                leftvalues.add(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                        else{
                                        clearRightValues = true;
                                leftvalues.remove(processes.get('Tech_Type__c')+' '+processes.get('Tech_Geometry__c'));
                        }
                }  
                if(clearRightValues){
                        rightvalues.clear();
                        leftvalues.add('ALL TECHNOLOGIES');
                }     
            }
        }
        //called at Constructor to populate Technology picklist with existing values
        public void retrieveSelectedTechnologies(){
                if(cusrForm.Technology__c != null || cusrForm.Technology__c != ''){
                        boolean checkAllTechnologies = false;
                    String selectedTechologies = cusrForm.Technology__c;
                    String[] seperatedArray = selectedTechologies.split(';');
                    system.debug('Technology Array is'+seperatedArray);
                    for(String s: seperatedArray){
                        if(s == 'ALL TECHNOLOGIES'){
                                checkAllTechnologies = true;
                        }
                    }
                    if(!checkAllTechnologies){
                        leftvalues.add('ALL TECHNOLOGIES');
                    }
                    for(String s: seperatedArray){
                            rightvalues.add(s);
                    }
                    if(cusrForm.FAB_1__c){
                            queryFab1Technologies();
                    }
                    if(cusrForm.FAB_2__c){
                            queryFab2Technologies();
                    }
                    if(cusrForm.FAB_3__c){
                            queryFab3Technologies();
                    }
                    if(cusrForm.FAB_3E__c){
                            queryFab3eTechnologies();
                    }
                    if(cusrForm.FAB_5__c){
                            queryFab5Technologies();
                    }
                    if(cusrForm.FAB_6__c){
                            queryFab6Technologies();
                    }
                    if(cusrForm.FAB_7__c){
                            queryFab7Technologies();
                    }
                    if(cusrForm.FAB_8__c){
                            queryFab8Technologies();
                    }
                    if(cusrForm.FAB_9__c){
                            queryFab9Technologies();
                    }
                    if(cusrForm.FAB_10__c){
                            queryFab10Technologies();
                    }
                    if(cusrForm.ASIC__c){
                            queryASICTechnologies();
                    }
                    for(String rvalues: rightvalues){
                            leftvalues.remove(rvalues);
                    }   
                }
        }
        
        //For Notification Group
        public PageReference selectUserClick(){
                rightSelectedUsers.clear();
                for(String s : leftSelectedUsers){
                    leftUserValues.remove(s);
                    if(!rightUserValues.contains(s)){
                        rightUserValues.add(s); 
                    }
                    for(string key : leftUserMap.keySet()){
                        if(key == s){
                            rightUserMap.put(key, leftUserMap.get(key));    
                        }
                    }
                    leftUserMap.remove(s);
                }
                return null;
        }
     
            public PageReference unselectUserClick(){
                leftSelectedUsers.clear();
                List<CuSR_Notification_Group__c> deleteCusrNotificationGroupList = new List<CuSR_Notification_Group__c>();
                for(String s : rightSelectedUsers){
                    rightUserValues.remove(s);
                    leftUserValues.add(s);
                    for(String key: rightUserMap.keySet()){
                        if(key == s){
                            leftUserMap.put(key, rightUserMap.get(key));
                        }
                    }
                    if(!cusrNotificationGroupList.isEmpty()){
                        for(CuSR_Notification_Group__c member: cusrNotificationGroupList){
                                if(member.User__c == rightUserMap.get(s)){
                                        //delete member;
                                        deleteCusrNotificationGroupList.add(member);
                                }
                        }       
                    }
                    rightUserMap.remove(s);
                }
                if(deleteCusrNotificationGroupList.size() > 0){
                    delete deleteCusrNotificationGroupList;
                }
                return null;
            }
            
            public List<SelectOption> getunSelectedUserValues(){
                List<SelectOption> options = new List<SelectOption>();
                List<string> tempList = new List<String>();
                tempList.addAll(leftUserValues);
                tempList.sort();
                for(string s : tempList)
                    options.add(new SelectOption(s,s));
                return options;
            }
         
            public List<SelectOption> getSelectedUserValues(){
                List<SelectOption> options1 = new List<SelectOption>();
                List<string> tempList = new List<String>();
                tempList.addAll(rightUserValues);
                tempList.sort();
                for(String s : tempList)
                    options1.add(new SelectOption(s,s));
                return options1;
            }
            
            public void SearchUser(){
                String s = '%'+searchUser+'%';
                leftUserValues.clear();
                leftUserMap.clear();
                for(User searchedUser : [select Id, Name from User where Name like: s and UserType = 'Standard' and IsPortalEnabled = false and isActive = true limit 100]){
                    leftUserValues.add(searchedUser.Name);
                    leftUserMap.put(searchedUser.Name, searchedUser.Id);
                }
            }
            
            public void saveNotificationGroup(){
                List<CuSR_Notification_Group__c> selectedNotificationGroup = new List<CuSR_Notification_Group__c>();
                if(!rightUserMap.isEmpty()){
                    for(String key: rightUserMap.keySet()){
                        selectedNotificationGroup.add(new CuSR_Notification_Group__c(CuSR_Form__c = cusrForm.Id, User__c = rightUserMap.get(key), User_Name__c = key));
                    }
                }
                Set<Id> existingNotificationSet = new Set<Id>();
                for(CuSR_Notification_Group__c member: cusrNotificationGroupList){
                    existingNotificationSet.add(member.User__c);
                }
                if(!selectedNotificationGroup.isEmpty()){
                    if(!cusrNotificationGroupList.isEmpty()){
                        List<CuSR_Notification_Group__c> member2List = new List<CuSR_Notification_Group__c>();
                        for(CuSR_Notification_Group__c member2: selectedNotificationGroup){
                            for(CuSR_Notification_Group__c member1: cusrNotificationGroupList){
                                if(member1.User__c == member2.User__c){
                                    
                                }
                                else{
                                    if(!existingNotificationSet.contains(member2.User__c)){
                                        //insert member2;
                                        member2List.add(member2);
                                        break;
                                    }
                                }
                            }
                        }
                        if(member2List.size() > 0){
                            insert member2List;
                        }
                    }
                    else{
                        upsert selectedNotificationGroup;
                    }
                }
            }
            
            //method to add new Implementation record
            public pageReference addNewFab1Implementation(){
                pgRef = new pageReference('/apex/CuSRImplementationEditPage');
                pgRef.getParameters().put('selectedfab','FAB 1');
                        pgRef.getParameters().put('CuSRFormId',cusrForm.Id);
                        pgRef.setRedirect(true);
                        return pgRef;
            }
            
            public pageReference addNewFab2Implementation(){
                pgRef = new pageReference('/apex/CuSRImplementationEditPage');
                pgRef.getParameters().put('selectedfab','FAB 2');
                        pgRef.getParameters().put('CuSRFormId',cusrForm.Id);
                        pgRef.setRedirect(true);
                        return pgRef;
            }
            
            public pageReference addNewFab3Implementation(){
                pgRef = new pageReference('/apex/CuSRImplementationEditPage');
                pgRef.getParameters().put('selectedfab','FAB 3');
                        pgRef.getParameters().put('CuSRFormId',cusrForm.Id);
                        pgRef.setRedirect(true);
                        return pgRef;
            }
            
            public pageReference addNewFab3eImplementation(){
                pgRef = new pageReference('/apex/CuSRImplementationEditPage');
                pgRef.getParameters().put('selectedfab','FAB 3E');
                        pgRef.getParameters().put('CuSRFormId',cusrForm.Id);
                        pgRef.setRedirect(true);
                        return pgRef;
            }
            
            public pageReference addNewFab5Implementation(){
                pgRef = new pageReference('/apex/CuSRImplementationEditPage');
                pgRef.getParameters().put('selectedfab','FAB 5');
                        pgRef.getParameters().put('CuSRFormId',cusrForm.Id);
                        pgRef.setRedirect(true);
                        return pgRef;
            }
            
            public pageReference addNewFab6Implementation(){
                pgRef = new pageReference('/apex/CuSRImplementationEditPage');
                pgRef.getParameters().put('selectedfab','FAB 6');
                        pgRef.getParameters().put('CuSRFormId',cusrForm.Id);
                        pgRef.setRedirect(true);
                        return pgRef;
            }
            
            public pageReference addNewFab7Implementation(){
                pgRef = new pageReference('/apex/CuSRImplementationEditPage');
                pgRef.getParameters().put('selectedfab','FAB 7');
                        pgRef.getParameters().put('CuSRFormId',cusrForm.Id);
                        pgRef.setRedirect(true);
                        return pgRef;
            }
            
            public pageReference addNewFab8Implementation(){
                pgRef = new pageReference('/apex/CuSRImplementationEditPage');
                pgRef.getParameters().put('selectedfab','FAB 8');
                        pgRef.getParameters().put('CuSRFormId',cusrForm.Id);
                        pgRef.setRedirect(true);
                        return pgRef;
            }
            
            public pageReference addNewFab9Implementation(){
                pgRef = new pageReference('/apex/CuSRImplementationEditPage');
                pgRef.getParameters().put('selectedfab','FAB 9');
                        pgRef.getParameters().put('CuSRFormId',cusrForm.Id);
                        pgRef.setRedirect(true);
                        return pgRef;
            }
            
            public pageReference addNewFab10Implementation(){
                pgRef = new pageReference('/apex/CuSRImplementationEditPage');
                pgRef.getParameters().put('selectedfab','FAB 10');
                        pgRef.getParameters().put('CuSRFormId',cusrForm.Id);
                        pgRef.setRedirect(true);
                        return pgRef;
            }
            public pageReference addNewASICImplementation(){
                pgRef = new pageReference('/apex/CuSRImplementationEditPage');
                pgRef.getParameters().put('selectedfab','ASIC');
                        pgRef.getParameters().put('CuSRFormId',cusrForm.Id);
                        pgRef.setRedirect(true);
                        return pgRef;
            }
            public class wrapperApprover{
                public Id procId{get;set;}
                public User ApproverId{get;set;}
                public String StepStatus{get;set;}
                public wrapperApprover(Id pId, Id aId, String s){
                        procId = pId;
                        ApproverId = [select Id, Name from User where Id = :aId];
                        StepStatus = s;
                }
            }
            
            public void informCEsAfterSubmission(){
                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                UtilClassToGetAllFields utilClass = new UtilClassToGetAllFields();
                if(cusrForm.Customer_Name__c != null){
                    Account acc = [select Id, Name from Account where Id =: cusrForm.Customer_Name__c];
                    User originator = [select Id, Name, Email from User where Id =: cusrForm.OwnerId];
                    String fieldsAccountTeamProxy = utilClass.getAllFields('Account_Team_Proxy__c');
                    fieldsAccountTeamProxy += ', User__r.Name';
                    String queryAccountTeamProxy = 'select '+fieldsAccountTeamProxy+' from Account_Team_Proxy__c where Account__c = \''+acc.Id+'\' and Team_Role__c = \'Customer Engineer\'';
                    List<Account_Team_Proxy__c> accountTeamProxyList = Database.query(queryAccountTeamProxy);
                    String unselectedFABs = '';
                    boolean fab1Present = false;
                    boolean fab2Present = false;
                    boolean fab3Present = false;
                    boolean fab3EPresent = false;
                    boolean fab5Present = false;
                    boolean fab6Present = false;
                    boolean fab7Present = false;
                    boolean fab8Present = false;
                    boolean fab9Present = false;
                    boolean fab10Present = false;
                    boolean asicPresent = false;
                    
                    if(!accountTeamProxyList.isEmpty()) {
                        for(Account_Team_Proxy__c ce: accountTeamProxyList){
                            system.debug('Current ce is '+ce.User__c);
                            if(cusrForm.FAB_1__c && ce.Fab_Assignment__c.contains('FAB 1')){
                                fab1present = true;
                                if(unselectedFABs.contains('FAB 1;')){
                                    unselectedFABs = unselectedFABs.replace('FAB 1;','');
                                }
                            }
                            else{
                                    if(!(unselectedFABs.contains('FAB 1;')) && cusrForm.FAB_1__c && fab1present == false){
                                        unselectedFABs += 'FAB 1;';
                                    }
                            }
                            if(cusrForm.FAB_2__c && ce.Fab_Assignment__c.contains('FAB 2')){
                                fab2present = true;
                                if(unselectedFABs.contains('FAB 2;')){
                                    unselectedFABs = unselectedFABs.replace('FAB 2;','');
                                }
                            }
                            else{
                                    if(!(unselectedFABs.contains('FAB 2;')) && cusrForm.FAB_2__c && fab2present == false){
                                        unselectedFABs += 'FAB 2;';
                                    }
                            }
                            if(cusrForm.FAB_3__c && ce.Fab_Assignment__c.contains('FAB 3')){
                                fab3present = true;
                                if(unselectedFABs.contains('FAB 3;')){
                                    unselectedFABs = unselectedFABs.replace('FAB 3;','');
                                }
                            }
                            else{
                                    if(!(unselectedFABs.contains('FAB 3;')) && cusrForm.FAB_3__c && fab3present == false){
                                        unselectedFABs += 'FAB 3;';
                                    }
                            }
                            if(cusrForm.FAB_3E__c && ce.Fab_Assignment__c.contains('E')){
                                fab3Epresent = true;
                                if(unselectedFABs.contains('FAB 3E;')){
                                    unselectedFABs = unselectedFABs.replace('FAB 3E;','');
                                }
                            }
                            else{
                                    if(!(unselectedFABs.contains('FAB 3E;')) && cusrForm.FAB_3E__c && fab3Epresent == false){
                                        unselectedFABs += 'FAB 3E;';
                                    }
                            }
                            if(cusrForm.FAB_5__c && ce.Fab_Assignment__c.contains('FAB 5')){
                                fab5present = true;
                                if(unselectedFABs.contains('FAB 5;')){
                                    unselectedFABs = unselectedFABs.replace('FAB 5;','');
                                }
                            }
                            else{
                                    if(!(unselectedFABs.contains('FAB 5;')) && cusrForm.FAB_5__c && fab5present == false){
                                        unselectedFABs += 'FAB 5;';
                                    }
                            }
                            if(cusrForm.FAB_6__c && ce.Fab_Assignment__c.contains('FAB 6')){
                                fab6present = true;
                                if(unselectedFABs.contains('FAB 6;')){
                                    unselectedFABs = unselectedFABs.replace('FAB 6;','');
                                }
                            }
                            else{
                                    if(!(unselectedFABs.contains('FAB 6;')) && cusrForm.FAB_6__c && fab6present == false){
                                        unselectedFABs += 'FAB 6;';
                                    }
                            }
                            if(cusrForm.FAB_7__c && ce.Fab_Assignment__c.contains('FAB 7')){
                                fab7present = true;
                                if(unselectedFABs.contains('FAB 7;')){
                                    unselectedFABs = unselectedFABs.replace('FAB 7;','');
                                }
                            }
                            else{
                                    if(!(unselectedFABs.contains('FAB 7;')) && cusrForm.FAB_7__c && fab7present == false){
                                        unselectedFABs += 'FAB 7;';
                                    }
                            }
                            if(cusrForm.FAB_8__c && ce.Fab_Assignment__c.contains('FAB 8')){
                                fab8present = true;
                                if(unselectedFABs.contains('FAB 8;')){
                                    unselectedFABs = unselectedFABs.replace('FAB 8;','');
                                }
                            }
                            else{
                                    if(!(unselectedFABs.contains('FAB 8;')) && cusrForm.FAB_8__c && fab8present == false){
                                        unselectedFABs += 'FAB 8;';
                                    }
                            }
                            if(cusrForm.FAB_9__c && ce.Fab_Assignment__c.contains('FAB 9')){
                                fab9present = true;
                                if(unselectedFABs.contains('FAB 9;')){
                                    unselectedFABs = unselectedFABs.replace('FAB 9;','');
                                }
                            }
                            else{
                                    if(!(unselectedFABs.contains('FAB 9;')) && cusrForm.FAB_9__c && fab9present == false){
                                        unselectedFABs += 'FAB 9;';
                                    }
                            }
                            if(cusrForm.FAB_10__c && ce.Fab_Assignment__c.contains('FAB 10')){
                                fab10present = true;
                                if(unselectedFABs.contains('FAB 10;')){
                                    unselectedFABs = unselectedFABs.replace('FAB 10;','');
                                }
                            }
                            else{
                                    if(!(unselectedFABs.contains('FAB 10;')) && cusrForm.FAB_10__c && fab10present == false){
                                        unselectedFABs += 'FAB 10;';
                                    }
                            }
                            if(cusrForm.ASIC__c && ce.Fab_Assignment__c.contains('ASIC')){
                                asicPresent = true;
                                if(unselectedFABs.contains('ASIC;')){
                                    unselectedFABs = unselectedFABs.replace('ASIC;','');
                                }
                            }
                            else{
                                    if(!(unselectedFABs.contains('ASIC;')) && cusrForm.ASIC__c && asicPresent == false){
                                        unselectedFABs += 'ASIC;';
                                    }
                            }
                            system.debug('CUrrent unselecte FAbs are'+unselectedFABs);
                        }
                        if(unselectedFABs != ''){
                            unselectedFABs = unselectedFABs.removeEnd(';');
                            system.debug('Unselected Fabs are '+unselectedFABs);
                        }
                        Set<Id> ceIdSet = new Set<Id>();        
                        for(Account_Team_Proxy__c ce : accountTeamProxyList){
                            if((ce.Fab_Assignment__c.contains('FAB 1') && cusrForm.FAB_1__c) || (ce.Fab_Assignment__c.contains('FAB 2') && cusrForm.FAB_2__c) || (ce.Fab_Assignment__c.contains('FAB 3') && cusrForm.FAB_3__c) || (ce.Fab_Assignment__c.contains('E') && cusrForm.FAB_3E__c) || (ce.Fab_Assignment__c.contains('FAB 5') && cusrForm.FAB_5__c) || (ce.Fab_Assignment__c.contains('FAB 6') && cusrForm.FAB_6__c) || (ce.Fab_Assignment__c.contains('FAB 7') && cusrForm.FAB_7__c) || (ce.Fab_Assignment__c.contains('FAB 8') && cusrForm.FAB_8__c) || (ce.Fab_Assignment__c.contains('FAB 9') && cusrForm.FAB_9__c) || (ce.Fab_Assignment__c.contains('FAB 10') && cusrForm.FAB_10__c) || (ce.Fab_Assignment__c.contains('ASIC') && cusrForm.ASIC__c)){
                                ceIdSet.add(ce.User__c);    
                            }
                        } 
                        if(!ceIdSet.isEmpty()){
                            List<User> ceUserList = [select Id, Email, Name from User where Id IN: ceIdSet];
                            Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                            List<String> ceList = new List<String>();
                            for(User c: ceUserList){
                                ceList.add(c.Email);
                            }
                            system.debug('CE emails are '+ceList.size());
                            singleMail.setToAddresses(ceList);
                            List<String> ccList = new List<String>();
                            ccList.add(originator.Email);
                            singleMail.setCcAddresses(ccList);
                            singleMail.saveAsActivity = false;
                            singleMail.setSubject('You have a Customer Specific Request '+cusrForm.Name+' for '+acc.Name+' to review');
                            String body = 'Dear Users';
                            body += '<br/>';
                            body += '<br/>';
                            body += 'A new CuSR Form is waiting for your review.';
                            body += 'Please click the below link to access the record.';
                            body += '<br/>';
                            body += '<br/>';
                            String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id;
                            body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+hyperLink+'</a>';
                            //body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+cusrForm.Name+'</a>';
                            body += '<br/>';
                            body += '<br/>';
                            body += 'Thank you,';
                            body += '<br/>';
                            body += 'For further clarification/query, please contact the CE.';
                            body += '<br/>';
                            body += 'This is a system generated auto email. Please do not reply.';
                            singleMail.setHtmlBody(body);
                            mails.add(singleMail);
                        } 
                        if(unselectedFABs != ''){
                            Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                            singleMail.setTargetObjectId(originator.Id);
                            singleMail.saveAsActivity = false;
                            //singleMail.setSubject('Customer Specific Request CuSR '+cusrForm.Name+' for '+acc.Name+'.');
                            singleMail.setSubject('Customer Engineers are not defined for '+acc.Name+' for Customer Specific Request '+cusrForm.Name);
                            String body = 'Dear '+originator.Name+', ';
                            body += '<br/>';
                            body += '<br/>';
                            //body += 'CE for '+ce.Fab_Assignment__c+' is not defined in Account Team.';
                            body += 'CE for following FABs are not defined in Account Team.';
                            body += '<br/>';
                            body += unselectedFABs;
                            body += '<br/>';
                            body += '<br/>';
                            body += 'You can access the CuSR using the following link:';
                            body += '<br/>';
                            body += '<br/>';
                            String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id;
                            body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+hyperLink+'</a>';
                            //body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+cusrForm.Name+'</a>';
                            body += '<br/>';
                            body += '<br/>';
                            body += 'Thank you,';
                            body += '<br/>';
                            body += 'For further clarification/query, please contact the CE.';
                            body += '<br/>';
                            body += 'This is a system generated auto email. Please do not reply.';
                            singleMail.setHtmlBody(body);
                            mails.add(singleMail);
                        } 
                    }
                    else{
                        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                        singleMail.setTargetObjectId(originator.Id);
                        singleMail.saveAsActivity = false;
                        //singleMail.setSubject('Customer Specific Request CuSR '+cusrForm.Name+' for '+acc.Name+'.');
                        singleMail.setSubject('Customer Engineers are not defined for '+acc.Name+' for Customer Specific Request '+cusrForm.Name);
                        String body = 'Dear '+originator.Name+', ';
                        body += '<br/>';
                        body += '<br/>';
                        //body += 'CE for '+ce.Fab_Assignment__c+' is not defined in Account Team.';
                        body += 'CE for following FABs are not defined in Account Team.';
                        body += '<br/>';
                        body += cusrForm.Scope__c;
                        body += '<br/>';
                        body += '<br/>';
                        body += 'You can access the CuSR using the following link:';
                        body += '<br/>';
                        body += '<br/>';
                        String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id;
                        body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+hyperLink+'</a>';
                        //body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+cusrForm.Name+'</a>';
                        body += '<br/>';
                        body += '<br/>';
                        body += 'Thank you,';
                        body += '<br/>';
                        body += 'For further clarification/query, please contact the CE.';
                        body += '<br/>';
                        body += 'This is a system generated auto email. Please do not reply.';
                        singleMail.setHtmlBody(body);
                        mails.add(singleMail);
                    } 
                    if(mails.size() > 0){
                        Messaging.sendEmail(mails);
                        system.debug('Succesfully send email'+mails.size());
                    }
                }
            }
    
    public pageReference checkNewButton(){
        
        cusrDisableCreateNewForm = CuSR_Disable_CreateNew_Form__c.getAll();
        boolean check = cusrDisableCreateNewForm.get('Disable New Form').Disable_New__c;
        if(check){
            pgRef = new pageReference('/apex/CuSRFormMaintenancePage');
            pgRef.setRedirect(true);
            return pgRef;
        }
        else{
            return null;
        }
    }
                
}