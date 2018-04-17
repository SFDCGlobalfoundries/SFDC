/**
 * Change History:
    DATE            NAME                    Comments

    05-Jun-2017     Ram Rai                 Defect fix for Step Plan.
    08-Jun-2017     Ram Rai                 Defect Fix for Step Plan #262    
    28-Jun-2017     Ram Rai                 Removed Hard Coding
    10-July-2017    Ram Rai                 Removed the Debugs. 

 * */
public with sharing class FMSStepPlanEditExt {

    
    public String fId {get;set;}
    public Form_Management_System__c formObj {get;set;}
    public boolean isPortalUser { get;set; }
    public boolean isFMSAdmin {get;set;}
    public boolean hasChildren { get;set;}
    public Set < Id > grpUsers = new Set < Id > ();
    public String userType = Schema.SObjectType.User.getKeyPrefix();
    public list<wrapperClass> wrapperList{get;set;}
    public boolean popupVal{get;set;}
    public String stateChangeComments{get;set;}
    public String selection{get;set;}
    public List<Form_Management_System__c> fmList{get;set;}
    public String Selectionval{get;set;}
    public Boolean resonBox{get;set;}
    public Integer lSize{get;set;}
    public List<SelectOption> statusOptions {get;set;}
    public boolean apprveReject{get;set;}
    public boolean escape;
    public final String FMS_SELECT_VAL = EnvironmentVariable.get('FMS_SELECT_VALUE'); 
    public final String FMS_SP_FORM = EnvironmentVariable.get('FMS_SP_FORM');
    public boolean skipvalidation;
        
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
    public FMSStepPlanEditExt(ApexPages.StandardController controller) {
            
         fId = ApexPages.currentPage().getParameters().get('id');        
        Id grpId = [SELECT ID, Name FROM Group WHERE DeveloperName = 'FMS_Admin_Group'].id;
        wrapperList = new list<wrapperClass>();
        Map<Id,List<Attachment>> fmMap = new Map<Id,List<Attachment>>();
        List<Attachment> attList = new List<Attachment>();
        Set<Id> fmId = new Set<Id>();
        statusOptions = new List<SelectOption>();
         
        resonBox = false;
        escape = false;
         if(fId != null && fId != ''){
            formObj = [SELECT id, name, ProductName__c, ProductRevision__c, Form_Name__c, ProductApplication__c, HasReleaseGuidelines__c, ItarData__c, HazardousUse__c, 
            Customer__c, Customer_Name__c, Customer_Name__r.SAP_Account_Number__c, Customer_Name__r.Customer_Category__c, EmailPrimary__c, NamePrimary__c, 
            StatePrimary__c, PhonePrimary__c, CountryPrimary__c, RolePrimary__c, Technology__c, ReleaseProcessFlow__c, TestServices__c, Packaging_Services__c, TestLevels__c, 
            Chip_Interconnect__c, IntConBumpSource__c, ChipEdgeWLCSP__c, Name__c, Email__c, Phone__c, AssetProtectionCode__c, MedicalDevice__c, Selected_Contact_Ids__c,
            NuclearDevice__c, Weapon__c, QuoteOnly__c, QuoteOnly_Old_Value__c, State_of_the_Form__c, WireBondSplit__c, WireBondSplitTAT__c, WireBondWaferReq__c, ItarCategory__c,
            C4Split__c, C4SplitTAT__c, C4WaferReq__c, OtherSplits__c, OtherSplitDets__c, ClientResponseDt__c, NeedBizComment__c, BusinessComments__c, WireBondPadPitch__c, 
            History_Time__c, CreatedBy.Name, Main_Form_Id__c,PrelimOrFinal__c,LastModifiedBy.Name, Selection__c ,CreatedBy.Email, LastModifiedBy.Email, CreatedDate, LastModifiedDate,RejectionReason__c , Form_Description__c, Form_Type__c FROM Form_Management_System__c WHERE id = :fId];  
        }
          
        List<Form_Management_System__c> fmList = new List<Form_Management_System__c>();
        fmList = [SELECT id, name, ProductName__c, ProductRevision__c, Form_Name__c, ProductApplication__c, HasReleaseGuidelines__c, ItarData__c, HazardousUse__c, 
            Customer__c, Customer_Name__c, Customer_Name__r.SAP_Account_Number__c, Customer_Name__r.Customer_Category__c, EmailPrimary__c, NamePrimary__c, 
            StatePrimary__c, PhonePrimary__c, CountryPrimary__c, RolePrimary__c, Technology__c, ReleaseProcessFlow__c, TestServices__c, Packaging_Services__c, TestLevels__c, 
            Chip_Interconnect__c, IntConBumpSource__c, ChipEdgeWLCSP__c, Name__c, Email__c, Phone__c, AssetProtectionCode__c, MedicalDevice__c, Selected_Contact_Ids__c,
            NuclearDevice__c, Weapon__c, QuoteOnly__c, QuoteOnly_Old_Value__c, State_of_the_Form__c, WireBondSplit__c, WireBondSplitTAT__c, WireBondWaferReq__c, ItarCategory__c,
            C4Split__c, C4SplitTAT__c, C4WaferReq__c,PrelimOrFinal__c , OtherSplits__c, Selection__c ,OtherSplitDets__c, ClientResponseDt__c, NeedBizComment__c, BusinessComments__c, WireBondPadPitch__c, 
            History_Time__c, CreatedBy.Name, Main_Form_Id__c,LastModifiedBy.Name, CreatedBy.Email, LastModifiedBy.Email, CreatedDate, LastModifiedDate,RejectionReason__c,Form_Description__c, Form_Type__c from Form_Management_System__c where main_form_id__c =: formObj.Main_Form_Id__c and Form_Type__c =:FMS_SP_FORM  order by CreatedDate desc];   
            
            
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
            
            
            
            
            if( fmList.size()!= 0)
            selection = fmList[0].Selection__c ;
                      
             Integer i=fmList.size();
             
             lSize = fmList.size();
             integer j=0; 
        for(Form_Management_System__c fms: fmList ){
              
            wrapperClass fmWrap = new wrapperClass(fms);
            fmWrap.prelimPara = 'This represents the approved and finalized version of the layout for your wafers. To ensure that you have all required information for your dicing requirements, please download please download this finalized version, replacing your preliminary Step Plan.';
            fmWrap.prelimName = 'Preliminary Step Plan:';
            fmWrap.counterWrap = i;
            fmWrap.lstattch = fmMap.get(fms.id);
            if(j==0)
            fmWrap.Max = true;
           else
            fmWrap.Max = false;
            
            wrapperList.add(fmWrap);
             --i;
             ++j;
         }
        
         
         if (UserInfo.getUserType() == 'Standard'){
         
	         for(GroupMember m: [Select Id, UserOrGroupId From GroupMember Where GroupId = : grpId]){
	            if(((String) m.UserOrGroupId).startsWith(userType)) {
	                grpUsers.add(m.UserOrGroupId);
	            }
	         }
         }
        
        if (grpUsers.contains(UserInfo.getUserId())) {
            isFMSAdmin = true;
        } else {
            isFMSAdmin = false;
        }
        if (UserInfo.getUserType() != 'Standard') {
            isPortalUser = true;
        } else {
            isPortalUser = false;
        }       
        
         fetchData();   
         if(wrapperList !=null){
             if(wrapperList[0].wrapFmObj.Selection__c =='Reject Preliminary Step Plan' || wrapperList[0].wrapFmObj.Selection__c =='Approve Preliminary Step Plan')       
                apprveReject = true;
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
        public Boolean Max{get;set;}
        public List<Attachment> lstattch{get;set;}
        
        
        public wrapperClass(Form_Management_System__c WrapfmObj ) {
            
            this.wrapFmObj=WrapfmObj ; 
            this.prelimPara = '';  
                
        }                      
    }       
    
   /*
   *************************************    
   @ Name - displResnBox
   @ Description - 
   @ Parameter - 
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */ 
    public void displResnBox(){
         
         
        if(Selectionval =='Reject Preliminary Step Plan'){
        
            resonBox = true;
            fetchData();
        }else if(Selectionval =='Approve Preliminary Step Plan'){
        
            resonBox = false;
            fetchData();
        }                  
    }    
   /*
   *************************************    
   @ Name - fetchData
   @ Description - 
   @ Parameter - 
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */        
    public list<Form_Management_System__c> fetchData(){
    
        fmList = [SELECT id, name, ProductName__c, ProductRevision__c, Form_Name__c, ProductApplication__c, HasReleaseGuidelines__c, ItarData__c, HazardousUse__c, 
                 Customer__c, Customer_Name__c, Customer_Name__r.SAP_Account_Number__c, Customer_Name__r.Customer_Category__c, EmailPrimary__c, NamePrimary__c, 
                StatePrimary__c, PhonePrimary__c, CountryPrimary__c, RolePrimary__c, Technology__c, ReleaseProcessFlow__c, TestServices__c, Packaging_Services__c, TestLevels__c, 
                Chip_Interconnect__c, IntConBumpSource__c, ChipEdgeWLCSP__c, Name__c, Email__c, Phone__c, AssetProtectionCode__c, MedicalDevice__c, Selected_Contact_Ids__c,
                NuclearDevice__c, Weapon__c, QuoteOnly__c, QuoteOnly_Old_Value__c, State_of_the_Form__c, WireBondSplit__c, WireBondSplitTAT__c, WireBondWaferReq__c, ItarCategory__c,
                C4Split__c, C4SplitTAT__c, C4WaferReq__c, OtherSplits__c, Selection__c ,OtherSplitDets__c, ClientResponseDt__c, NeedBizComment__c, BusinessComments__c, WireBondPadPitch__c, 
                History_Time__c, CreatedBy.Name, Main_Form_Id__c,LastModifiedBy.Name, CreatedBy.Email,RejectionReason__c, LastModifiedBy.Email, CreatedDate, LastModifiedDate, Form_Description__c, Form_Type__c from Form_Management_System__c WHERE Parent_Form_Id__c= :fId order by CreatedDate asc];
       
        return fmList; 
    }
   /*
   *************************************    
   @ Name - save
   @ Description - 
   @ Parameter - 
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */          
    public PageReference save(){
        List<Form_Management_System__c> fmListNew =  new List<Form_Management_System__c>();
        for(wrapperClass wc : wrapperList){
            
            fmListNew.add(wc.wrapFmObj);
            break;
           
        }
        if(!escape) {  
        
        String St =   fmListNew[0].RejectionReason__c;           
        if(fmListNew[0].Selection__c  == FMS_SELECT_VAL )
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error:Select One: is a Required field'));
        else if(fmListNew[0].Selection__c =='Reject Preliminary Step Plan' && st==null)
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error:Rejection Reason: is a Required field'));
        else{
            
            try{
                update fmListNew;         
            }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
           }
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Your form has been saved successfully'));   
            return null;
        } 
        }else {
            try{
                update fmListNew;         
            }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'save()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
           }
            
            PageReference pgRef = new PageReference('/apex/FMSStepPlanFormView');
            pgRef.getParameters().put('id', fId );
            if(fmListNew[0].Selection__c  == FMS_SELECT_VAL)
            pgRef.getParameters().put('err', 'error');
            if((fmListNew[0].RejectionReason__c == null || fmListNew[0].RejectionReason__c == '') && fmListNew[0].Selection__c  == 'Reject Preliminary Step Plan')
            pgRef.getParameters().put('err1', 'error1');
            
                   
            pgRef.setRedirect(true);
            
            return pgRef;        
        }         
        return null;
    }
   /*
   *************************************    
   @ Name - cancel
   @ Description - 
   @ Parameter - 
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */       
    public PageReference cancel(){
    
        PageReference pgRef = new PageReference('/apex/FMSStepPlanFormView');
        pgRef.getParameters().put('id', fid);       
        pgRef.setRedirect(true);
        return pgRef;        
    }
    
   /*
   *************************************    
   @ Name - validateSave
   @ Description - 
   @ Parameter - 
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */     
    public PageReference validateSave(){
       
        PageReference pgRef = new PageReference('/apex/FMSStepPlanFormView');       
        pgRef.getParameters().put('id', fId );
        pgRef.setRedirect(true);
        
        return pgRef;       
   }
   /*
   *************************************    
   @ Name - saveandExit
   @ Description - 
   @ Parameter - 
   @ Return Type - 
   @ Created By - Ram Rai
   ****************************************
   */   
   
   public PageReference saveandExit(){  
   
        List<Form_Management_System__c> fmListNew =  new List<Form_Management_System__c>();
        for(wrapperClass wc : wrapperList){
            
            fmListNew.add(wc.wrapFmObj);
            break;
            
        }
        escape = true;
        String St =   fmListNew[0].RejectionReason__c; 
        if(fmListNew[0].Selection__c  == FMS_SELECT_VAL ){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error:Select One: is a Required field'));  
             return null;
            }
               
        else if(fmListNew[0].Selection__c =='Reject Preliminary Step Plan' && st==null){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error:Rejection Reason: is a Required field'));
             return null; 
        }   
         try{
                update fmListNew;         
            }catch(Exception e){
            UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'saveandExit()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
           } 
        PageReference pgRef = new PageReference('/apex/FMSStepPlanFormView');
        pgRef.getParameters().put('id', fId );      
        pgRef.setRedirect(true);            
       return pgRef;  
             
                   
    }     
}