/* 
  @Author <Ram Rai>
   @name <StepPlanViewExt >
   @CreateDate <27/02/2017>
   @Description <> 
   @Version <1.0>
   
   
Change History:
    DATE            NAME                    Comments

    28-Jun-2017     Ram Rai                 Removed Hard Coding.
    10-July-2017     Ram Rai                Added the Code for the PDF fix of Step Plan. #Issue 402
*/
public with sharing class FMSStepPlanViewExtPDF {

    public String fId {get;set;}
    public Form_Management_System__c formObj {get;set;}
    public List<Form_Management_System__c> fmList{get;set;}
    public boolean isPortalUser { get;set; }
    public boolean isFMSAdmin {get;set;}
    public boolean hasChildren { get;set;}
    Map<Id,List<Attachment>> fmMap = new Map<Id,List<Attachment>>();
    public String frmState{get;set;}
    public Set < Id > grpUsers = new Set < Id > ();
    public String userType = Schema.SObjectType.User.getKeyPrefix();
    public list<wrapperClass> wrapperList{get;set;}
    public boolean popupVal{get;set;}
    public String stateChangeComments{get;set;}
    public String selection{get;set;}
    public Id frmId{get;set;}
    public String approvedBy{get;set;} 
    public final String FMS_SP_FORM = EnvironmentVariable.get('FMS_SP_FORM');
        
    public String getFormId() {
        return ApexPages.currentPage().getParameters().get('id');
        
    }
  /*
   *************************************    
   @ Name -  Constructor 
   @ Description -
   @ Parameter - None
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */  
    public FMSStepPlanViewExtPDF(ApexPages.StandardController controller) {
            
        Set<Id> fmId = new Set<Id>();
        fId = ApexPages.currentPage().getParameters().get('id');        
        Id grpId = [SELECT ID, Name FROM Group WHERE DeveloperName = 'FMS_Admin_Group'].id;
        wrapperList = new list<wrapperClass>();
         List<Attachment> attList = new List<Attachment>();
       
        if(fId != null && fId != ''){
            formObj = [SELECT id, name, ProductName__c,Mandatory_State_Change_Comments__c, ProductRevision__c, Form_Name__c, ProductApplication__c, HasReleaseGuidelines__c, ItarData__c, HazardousUse__c, 
            Customer__c, Customer_Name__c, Customer_Name__r.SAP_Account_Number__c, Customer_Name__r.Customer_Category__c, EmailPrimary__c, NamePrimary__c, 
            StatePrimary__c, PhonePrimary__c, CountryPrimary__c, RolePrimary__c, Technology__c, ReleaseProcessFlow__c, TestServices__c, Packaging_Services__c, TestLevels__c, 
            Chip_Interconnect__c, IntConBumpSource__c, ChipEdgeWLCSP__c, Name__c, Email__c, Phone__c, AssetProtectionCode__c, MedicalDevice__c, Selected_Contact_Ids__c,
            NuclearDevice__c, Weapon__c, QuoteOnly__c, QuoteOnly_Old_Value__c, State_of_the_Form__c, WireBondSplit__c, WireBondSplitTAT__c, WireBondWaferReq__c, ItarCategory__c,
            C4Split__c, C4SplitTAT__c, C4WaferReq__c, OtherSplits__c, RejectionReason__c ,OtherSplitDets__c, ClientResponseDt__c, NeedBizComment__c, BusinessComments__c, WireBondPadPitch__c, 
            History_Time__c, CreatedBy.Name,Parent_Form_Id__c ,Reviewed_By__c , Main_Form_Id__c,PrelimOrFinal__c,ReviewedBy__c ,Selection__c,LastModifiedBy.Name, CreatedBy.Email, LastModifiedBy.Email, CreatedDate, LastModifiedDate, Form_Description__c, Form_Type__c FROM Form_Management_System__c WHERE id = :fId];  
        }
         
       fmList = new List<Form_Management_System__c>();
         fmList = [SELECT id, name, UniqueWebRDTSId__c,Main_Form_Id__r.name,CustomerApprovalFlag__c,ProductName__c,Mandatory_State_Change_Comments__c, ProductRevision__c, Form_Name__c, ProductApplication__c, HasReleaseGuidelines__c, ItarData__c, HazardousUse__c, 
            Customer__c, Customer_Name__c, Customer_Name__r.SAP_Account_Number__c, Customer_Name__r.Customer_Category__c, EmailPrimary__c, NamePrimary__c, 
            StatePrimary__c, PhonePrimary__c, CountryPrimary__c, RolePrimary__c, Technology__c, ReleaseProcessFlow__c, TestServices__c, Packaging_Services__c, TestLevels__c, 
            Chip_Interconnect__c, IntConBumpSource__c, ChipEdgeWLCSP__c, Name__c, Email__c, Phone__c, AssetProtectionCode__c, MedicalDevice__c, Selected_Contact_Ids__c,
            NuclearDevice__c, Weapon__c, QuoteOnly__c, QuoteOnly_Old_Value__c, State_of_the_Form__c, WireBondSplit__c, WireBondSplitTAT__c, WireBondWaferReq__c, ItarCategory__c,
            C4Split__c, C4SplitTAT__c, C4WaferReq__c, OtherSplits__c,Reviewed_By__c ,RejectionReason__c , Selection__c ,OtherSplitDets__c, ClientResponseDt__c, NeedBizComment__c, BusinessComments__c, WireBondPadPitch__c, 
            History_Time__c, CreatedBy.Name, Main_Form_Id__c,PrelimOrFinal__c,ReviewedBy__c,LastModifiedBy.Name, CreatedBy.Email, LastModifiedBy.Email, CreatedDate, LastModifiedDate, Form_Description__c, Form_Type__c from Form_Management_System__c where main_form_id__c =: formObj.Main_Form_Id__c and Form_Type__c =: FMS_SP_FORM   order by CreatedDate desc];
             
             fmId.add(formObj.id);
             for(Form_Management_System__c  fm :fmList  ){
                 fmId.add(fm.id);
             }
             
             attList = [SELECT Description,Id,Name,BodyLength,ContentType,ParentId FROM Attachment where ParentId in: fmId];
             
             for(Attachment at : attList ){
                 List<attachment> lst = new list <attachment>();
                 if(fmMap.containskey(at.ParentId)){
                     lst = fmmap.get(at.parentId);
                     lst.add(at);
                     fmmap.put(at.parentid, lst);
                 }
                 else
                 fmMap.put(at.ParentId ,new List<Attachment> {at});
                   
             }
                         
             Integer i;
             Integer Size;
             if(!fmList.isempty()){
            if( fmList.size()!= 0){
            Size = fmList.size();
            frmState = fmList[0].State_of_the_Form__c;
            
            
            if(fmList[0].Selection__c =='None'){
            selection = '';
            
            }
            else
            selection = fmList[0].Selection__c ;
            
            }
            
            
           
            frmId = fmList[0].id;
                      
            i =fmList.size() ;
             }
             //Code added by Ram Rai to Fix Approver and Reviewer in for SP PDF issue 402
                if(fmList != null){
                           
               Integer siz = fmList.size(); 
               if( siz > 0)
               approvedBy = fmList[siz-1].Reviewed_By__c ;   
               }
             else{
             selection = formObj.Selection__c ;
             frmState = formObj.State_of_the_Form__c;
             }
            for(Form_Management_System__c fms: fmList ){
            
            wrapperClass fmWrap1 = new wrapperClass(fms);

            
            fmWrap1.prelimPara = '';
            fmWrap1.prelimName = 'Preliminary Step Plan:';
            if(fms.PrelimOrFinal__c =='Final'){ 
                i--;  
            }
            if(fms.PrelimOrFinal__c =='Preliminary'){   
            fmWrap1.counterWrap = i;
             i--;
             }
            fmWrap1.lstattch = fmMap.get(fms.id);
            
             
            wrapperList.add(fmWrap1);
           
         }
       
        
                  
     }    
       /*
   *************************************    
   @ Name -  Wrapper Class
   @ Description - 
   @ Parameter - 
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */  
    public class wrapperClass{
        
        public Form_Management_System__c wrapFmObj{get;set;}
        public Integer counterWrap{get;set;}
        public String prelimPara {get;set;}
        public String prelimName{get;set;}
        public List<Attachment> lstattch{get;set;}
        
        public wrapperClass(Form_Management_System__c WrapfmObj ) {
            
            this.wrapFmObj=WrapfmObj ; 
            this.prelimPara = '';  
                
        }                      
    }       
    
  
    

}