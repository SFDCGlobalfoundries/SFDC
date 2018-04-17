/*
    Author: Anirban Roy
    Description: This is the controller class for the muli-level approval process for NPC.
    History: 
        ARoy      01092014    - Code creation.
        ARoy      02182014    - Add No_of_PIYE_Approvers__c field to the query.
        ZAmbat    03032014    - Updated code to populate PIYE lookup fields even if NPCForm.Fab__c is in NPC_FAB_LIST.
        ZAmbat    07142014    - Updated code as per CASE 29911.
        ZAmbat    12052014    - Updated code as per CASE 7573.
        DBiswal   12152014    - Updated code for FAE approval.      
        DBiswal   12182014    - Updated code for coming out of Approval when Reason for New Part is 'Fab to Fab Transfer'.
        SArora    04242015    - Code updated for case # 40782 to use new field PIYE_Approver_4__c
        SNune     10012015    - Updated code for fixing case 47700,40544.
        Prajnith  10102016    - Updated code for fixing Device reactivation.        
*/

public class NPCFormMultiApprProcessController{
    private string recId {get;set;}
    public New_Part_Creation_Form__c npcForm {get;set;}
    public boolean isPIYEApproval {get; set;} 
    public String comments{get; set;}
    public boolean npcFabCheck {get; set;}
    public String fabList = Environment_Variable__c.getInstance('NPC_FAB_LIST').Value__c;
    public Boolean maskCheck = false;
    public List<AttachmentWrapper> listAttachments {get; set;}             // Dipak 04102016
    public string attachId {get;set;}                                   // Dipak 04102016
    public string selectedOrderRange {get;set;}
    public boolean isLithoPage {get;set;}
	public string Reticle_ReturntoCustomer {get;set;}    
    // Constructor
    public NPCFormMultiApprProcessController(){
        this.recId = ApexPages.currentPage().getParameters().get('id');
        system.debug('***ID***'+this.recId);
        this.isPIYEApproval = false;
        this.maskCheck = false;
        isLithoPage = false;
         this.listAttachments = new List<AttachmentWrapper>();      // Dipak 04102016
        Reticle_ReturntoCustomer = EnvironmentVariable.get('NPC_STF_Reticle_Customer');
        //DBiswal 12152014 - Added more fields to query
        //query updated by Sunil Arora for case # 40782 to use new field PIYE_Approver_4__c
        this.npcForm = [
                    SELECT      Id
                                , Name
                                , Primary_Device_AM2__C
                                , Comments1__c 
                                , Primary_Device_AM__C  
                                , No_of_PI_YE_Assignes__c 
                                , Planned_Implementation_Date__c
                                , Actual_Implementation_Date__c
                                , Action__c
                                , Comments__c
                                , Comments2__c               // Dipak 15112016
                                , Notification_Group__c
                                , Litho_Validate_Reticle_is_in_GF__c
                                , Date_to_Ship_Reticle_to_Mask_Shop__c
                                , Mask_Shop_Name__c
                                , Mask_Shop_Site__c
                                , Mask_Shop_Address__c
                                , Assignee_1__c
                                , Assignee_2__c
                                , Additional_Recipient_1__c
                                , Is_reticle_available__c
                                , STF_Activation_Steps__c
                                , NRE_25K_USD__c
                                , NRE_25K_USD_Is_Acknowledged_by_Customer__c
                                , NRE_Comments__c
                                , Risk_Waiver__c
                                , Min_Order_qty_agreement_with_customer__c
                                , Min_Order_qty_agreement_customer_Text__c 
                                , Min_Order_Create__c
                                , Account_Name__c
                                , Fab__c
                                , New_Part_ID__c
                                , Reason_for_New_Part__c
                                , Tapeout_Required__c
                                , No_of_Approvers__c
                                , PIYE_Approver_1__c
                                , PIYE_Approver_2__c
                                , PIYE_Approver_3__c, PIYE_Approver_4__c
                                , No_of_PIYE_Approvers__c
                                , BASE_Device__c
                                , BASE_Device__r.OwnerId
                                , Originating_Device__c
                                , Originating_Device__r.Opportunity_Program__c
                                , NPC_Form_Status__c
                                , Approver_1__c 
                                , Approver_2__c
                                , Approver_3__c 
                                , Approver_4__c
                                , Approver_5__c 
                                , Approver_6__c
                                , Approver_7__c 
                                , Approver_8__c
                                , Approver_9__c 
                                , Approver_10__c
                                , (SELECT Layer__c,New_Part_Creation_Form__c from Masks__r)                                                            
                    FROM        New_Part_Creation_Form__c
                    WHERE       Id = :this.recId
                  ];        
        
        if(npcForm!=null){  
        if(string.isEmpty(npcForm.STF_Activation_Steps__c) &&  npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c){
            isLithoPage = true;
        }         
            ////condition updated by Sunil Arora for case # 40782 to use new field PIYE_Approver_4__c
            if(npcForm.PIYE_Approver_1__c!=null || npcForm.PIYE_Approver_2__c!=null || npcForm.PIYE_Approver_3__c!=null || npcForm.PIYE_Approver_4__c!=null){
               
               npcForm.No_of_PIYE_Approvers__c = 0;     
            }
            
            
            // OR Comments = 'Auto Submission'                                 
            List<ProcessInstance> piList = [SELECT      Id
                                                        , (SELECT Id, StepStatus, Comments FROM Steps WHERE Comments = 'Auto Submission After CE Approval' OR Comments = 'Auto Submission After FE Action')
                                            FROM        ProcessInstance 
                                            WHERE       TargetObjectId = :this.npcForm.Id
                                            ORDER BY    CreatedDate DESC];                                 
                                             
            if(piList!=null && piList.size()>0){
                
                
                if (piList[0].Steps.size() > 0) {
                    this.isPIYEApproval = true;
                }
            }
            
            //SNune 10012015 - Updated code to fix case 40544 
            if(fabList.contains(npcForm.Fab__c) && npcForm.Reason_for_New_Part__c != 'Fab to Fab Transfer'){
                this.npcFabCheck = false;
            }else{
                this.npcFabCheck = true;
            }
            // Set attachment Dipak 04102016 Start
       
        AttachmentWrapper aw = new AttachmentWrapper();
        aw.id = 'NPCFormVF:form1:BlkEdit:repeatAttach:0:attach';
        aw.label = 'Attachment(s)';
        aw.attachment = new Attachment();
        this.listAttachments.add(aw);
        
        //yathish st
        AttachmentWrapper aw1 = new AttachmentWrapper();
        aw1.id = 'NPCFormVF:form1:BlkEdit:repeatAttach:01:attach';
        aw1.label = 'Attachment(s)';
        aw1.attachment = new Attachment();
        this.listAttachments.add(aw1);
        //yathish End
         // Set attachment Dipak 04102016 End   
            //DBiswal 03232015 - For Mask layer validation          
            if((this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c 
                || this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c) && this.npcForm.Masks__r.size() > 0){
                this.maskCheck = true;
            } else if(this.npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c 
                    && this.npcForm.Reason_for_New_Part__c != Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c){
                this.maskCheck = true;
            }
        }
    }
   
   // Dipak 21102016 Start
    
    public PageReference detailNPC() {
        PageReference pageRef;
        if ((this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_EXEC').Value__c 
        || this.npcForm.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c) 
        && this.npcForm.Reason_for_New_Part__c == EnvironmentVariable.get('NPC_REASON_STF')) {
            pageRef = new PageReference('/apex/NPCPIYUpdate');
        pageRef.getParameters().put('id',npcForm.Id);
        pageRef.setRedirect(true);
        
        }return pageRef;
    }
    
   // Dipak 21102016 End 
    
    // Approve NPC by CE and PIYE
    
     public PageReference approveNPC(){      
        // Dipak 04102016 Start
        String pageHeaderReferer = ApexPages.currentPage().getHeaders().get('Referer');
      if(npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c){        
      if(pageHeaderReferer != null && pageHeaderReferer.containsIgnoreCase('NPCLithoFormValidation'))
      {
              if(String.isEmpty(npcForm.Litho_Validate_Reticle_is_in_GF__c) && String.isEmpty(npcForm.NRE_25K_USD_Is_Acknowledged_by_Customer__c) ){
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, EnvironmentVariable.get('NPC_STF_LITHOVALIDATE')));
                    return null;                    
                } 
                
          
            if(npcForm.Is_reticle_available__c == EnvironmentVariable.get('NPC_STF_Reticle_GF')){ 
                this.comments = npcForm.Comments1__c;  
                if(npcForm.Litho_Validate_Reticle_is_in_GF__c == 'NO'){                   
                    rejectNPC();
                    return getNPCDetailPage();                      
                }
                                       system.debug('display litho validation error');
           }           
           if(npcForm.NPC_Form_Status__c  == 'Pending CE Approval' && npcForm.PIYE_Approver_1__c == null && npcForm.PIYE_Approver_2__c == null && npcForm.PIYE_Approver_3__c == null){
        ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, EnvironmentVariable.get('NPC_STF_PIHOD_1')));
             return null;
            }

           set<ID> userIDS = new set<ID>();
           if(npcForm.PIYE_Approver_1__c != null)
               userIDS.add(npcForm.PIYE_Approver_1__c);
           if(npcForm.PIYE_Approver_2__c != null)               
               userIDS.add(npcForm.PIYE_Approver_2__c);       
           if(npcForm.PIYE_Approver_3__c != null)                   
               userIDS.add(npcForm.PIYE_Approver_3__c);           
           shareNPCtoPIYE(userIDS,npcForm.BASE_Device__c);
           
         }           
        // Yathish st.... 
        if(pageHeaderReferer != null && pageHeaderReferer.containsIgnoreCase('NPCFormMultiApproval')){
           if(npcForm.Min_Order_Create__c ==null){ 
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select Min order qty duration'));
             return null;
            system.debug('radio button is not selected');
          }
          else if(npcForm.Min_Order_qty_agreement_with_customer__c ==null){ 
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Min Order Quantity is mandatory field, Please enter a value'));
             return null;
            system.debug('Min Order Quantity is not selected');
          }
        }
        //Yathish End
          if(pageHeaderReferer != null && pageHeaderReferer.containsIgnoreCase('NPCPIYApproval'))
          {
           if(npcForm.Assignee_1__c == null && npcForm.Assignee_2__c == null){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select atleast one Assignee'));
             return null;
            }
            
          system.debug('im in 1');
          npcForm.PI_YE_Approval_Status__c = 'Status 1';
          npcForm.STF_Activation_Steps__c = 'Step 1';
            if(npcForm.Assignee_1__c  != null){
                  npcForm.No_of_PI_YE_Assignes__c = 1; 
             }
             if(npcForm.Assignee_2__c  != null && npcForm.Assignee_1__c == null){
                  npcForm.Assignee_1__c  = npcForm.Assignee_2__c;
                  npcForm.No_of_PI_YE_Assignes__c = 1;                 
             }
             if (npcForm.Assignee_1__c != null && npcForm.Assignee_2__c != null) {
                  npcForm.No_of_PI_YE_Assignes__c = 2; 
             }
          } 
          npcForm.NRE_25K_USD__c = true;
          if(npcForm.NRE_25K_USD_Is_Acknowledged_by_Customer__c == null){
                npcForm.NRE_25K_USD__c = false;      
          }       
        if(pageHeaderReferer != null && pageHeaderReferer.containsIgnoreCase('NPCFormMultiApproval')){    
        if(npcForm.NRE_25K_USD__c == false){ 
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select NRE 25K USD Is Acknowledged by Customer'));
             return null;
            system.debug('checkbox is not checked 1');
          }
        if(npcForm.Risk_Waiver__c == false){ 
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select Risk Waiver Is Acknowledged By Customer'));
             return null;
            system.debug('checkbox is not checked 1');
          }
          
          List<Attachment> listInsertAttachments = new List<Attachment>(); 
                System.debug('lsit attach values  '+this.listAttachments);
                for (AttachmentWrapper a : this.listAttachments) {
                    if (a.attachment.Body != null) {
                        a.attachment.ParentId = this.npcForm.Id;
                        if(a.id == 'NPCFormVF:form1:BlkEdit:repeatAttach:0:attach')
                        {
                            a.attachment.name='NRE 25k';
                        }
                        if(a.id == 'NPCFormVF:form1:BlkEdit:repeatAttach:01:attach')
                        {
                            a.attachment.name='Risk Waiver';
                        }
                        listInsertAttachments.add(a.attachment);
                    }
                   
                }   
                if (listInsertAttachments.size() > 0) {
                    insert listInsertAttachments;
                }
              else{
                 ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select attachment'));
            //return new PageReference('/apex/NPCFormMultiApproval');
            return null;
            system.debug('Attachment validation error');
                }
         }
        
            
       
           if(pageHeaderReferer != null && pageHeaderReferer.containsIgnoreCase('NPCPIYUpdate')){
           if(npcForm.Planned_Implementation_Date__c == null){ 
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'planned implementation date is not selected'));
             return null;
            system.debug('planned implementation date is not selected');
          }
        }
              
         // Dipak 31102016 End
                
        // Dipak 04102016 End
      }  
        system.debug('1111');   
        if(this.maskCheck == true){
        system.debug('2222');
         if(npcForm != null && !isPIYEApproval && npcForm.Reason_For_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c) {            
      
                if( npcForm.PIYE_Approver_1__c != null && npcForm.PIYE_Approver_2__c != null && npcForm.PIYE_Approver_3__c != null){
                      npcForm.No_of_PIYE_Approvers__c = 3;
                } 
                else if( (npcForm.PIYE_Approver_1__c != null && npcForm.PIYE_Approver_2__c != null) ||  (npcForm.PIYE_Approver_2__c != null && npcForm.PIYE_Approver_3__c != null) || (npcForm.PIYE_Approver_3__c != null && npcForm.PIYE_Approver_1__c != null)){
                      npcForm.No_of_PIYE_Approvers__c = 2;
                } 
                else{
                      npcForm.No_of_PIYE_Approvers__c = 1;
                }              
            } 
            else if(npcForm != null && !isPIYEApproval && (!(fabList.contains(npcForm.Fab__c)) || npcForm.Reason_for_New_Part__c == 'Fab to Fab Transfer')
                && (npcForm.PIYE_Approver_1__c != null || npcForm.PIYE_Approver_2__c != null
                || npcForm.PIYE_Approver_3__c != null || npcForm.PIYE_Approver_4__c != null)){
                system.debug('3333');
                system.debug('npcForm.PIYE_Approver_1__c==>'+npcForm.PIYE_Approver_1__c);
                system.debug('npcForm.PIYE_Approver_2__c==>'+npcForm.PIYE_Approver_2__c);
                system.debug('npcForm.PIYE_Approver_3__c==>'+npcForm.PIYE_Approver_3__c);
                // Removing similar approvers in the user lookups
                //=================================================//
                if(npcForm.PIYE_Approver_1__c != null && npcForm.PIYE_Approver_1__c == npcForm.PIYE_Approver_2__c){
                system.debug('4444');
                    npcForm.PIYE_Approver_2__c = null;
                }
                system.debug('5555');
                if(npcForm.PIYE_Approver_2__c != null && npcForm.PIYE_Approver_2__c == npcForm.PIYE_Approver_3__c){
                system.debug('6666');
                    npcForm.PIYE_Approver_3__c = null;
                }
                system.debug('7777');
                if(npcForm.PIYE_Approver_1__c != null && npcForm.PIYE_Approver_1__c == npcForm.PIYE_Approver_3__c){
                    system.debug('8888');
                    npcForm.PIYE_Approver_3__c = null;
                }
                //If conditions added by Sunil Arora for case # 40782 to use new field PIYE_Approver_4__c
                system.debug('9999');
                if(npcForm.PIYE_Approver_1__c != null && npcForm.PIYE_Approver_1__c == npcForm.PIYE_Approver_4__c){
                    system.debug('10000');
                    npcForm.PIYE_Approver_4__c = null;
                }
                system.debug('10001');
                if(npcForm.PIYE_Approver_2__c != null && npcForm.PIYE_Approver_2__c == npcForm.PIYE_Approver_4__c){
                    system.debug('10002');
                    npcForm.PIYE_Approver_4__c = null;
                }
                system.debug('10003');
                if(npcForm.PIYE_Approver_3__c != null && npcForm.PIYE_Approver_3__c == npcForm.PIYE_Approver_4__c){
                    system.debug('10004');
                    npcForm.PIYE_Approver_4__c = null;
                }
                system.debug('10005');
                
                //=================================================//
                
                // Copying PIYE_Approvers so that its having values in order
                //=========================================================//
                if(npcForm.PIYE_Approver_1__c == null && npcForm.PIYE_Approver_2__c != null){
                system.debug('10006');
                    npcForm.PIYE_Approver_1__c = npcForm.PIYE_Approver_2__c;
                    npcForm.PIYE_Approver_2__c = null;
                }
                system.debug('10007');
                if(npcForm.PIYE_Approver_1__c == null && npcForm.PIYE_Approver_3__c != null){
                    system.debug('10008');
                    npcForm.PIYE_Approver_1__c = npcForm.PIYE_Approver_3__c;
                    npcForm.PIYE_Approver_3__c = null;
                }
                system.debug('10009');
                if(npcForm.PIYE_Approver_2__c == null && npcForm.PIYE_Approver_3__c != null){
                    system.debug('10010');
                    npcForm.PIYE_Approver_2__c = npcForm.PIYE_Approver_3__c;
                    npcForm.PIYE_Approver_3__c = null;
                }
                system.debug('10011');
                //If conditions added by Sunil Arora for case # 40782 to use new field PIYE_Approver_4__c
                if(npcForm.PIYE_Approver_1__c == null && npcForm.PIYE_Approver_4__c != null){
                    system.debug('10012');
                    npcForm.PIYE_Approver_1__c = npcForm.PIYE_Approver_4__c;
                    npcForm.PIYE_Approver_4__c = null;
                }
                system.debug('10013');
                if(npcForm.PIYE_Approver_2__c == null && npcForm.PIYE_Approver_4__c != null){
                    system.debug('10014');
                    npcForm.PIYE_Approver_2__c = npcForm.PIYE_Approver_4__c;
                    npcForm.PIYE_Approver_4__c = null;
                }
                system.debug('10015');
                if(npcForm.PIYE_Approver_3__c == null && npcForm.PIYE_Approver_4__c != null){
                    npcForm.PIYE_Approver_3__c = npcForm.PIYE_Approver_4__c;
                    npcForm.PIYE_Approver_4__c = null;
                }
                 system.debug('10016');       
                //=========================================================//
                
                // Number of PIYE Approvers assignment
                //=========================================================//
                Integer i=0;
                List<String> usrIdPiyeList = new List<String>();
                if(npcForm.PIYE_Approver_1__c != null){             
                    i++;
                    usrIdPiyeList.add(npcForm.PIYE_Approver_1__c);
                }
                if(npcForm.PIYE_Approver_2__c != null){
                    i++;
                    usrIdPiyeList.add(npcForm.PIYE_Approver_2__c);
                }
                if(npcForm.PIYE_Approver_3__c != null){
                    i++;
                    usrIdPiyeList.add(npcForm.PIYE_Approver_3__c);
                }
                //If conditions added by Sunil Arora for case # 40782 to use new field PIYE_Approver_4__c
                if(npcForm.PIYE_Approver_4__c != null){
                    i++;
                    usrIdPiyeList.add(npcForm.PIYE_Approver_4__c);
                }
                npcForm.No_of_PIYE_Approvers__c = i;
                //=========================================================//
                
                // Add the PIYE approvers to the Device Share
                //=========================================================//
                addToDeviceShare(usrIdPiyeList);
                //=========================================================// 
                
                // Check for the PIYE approvers to be part of Device__Share
                //=========================================================//           
                
                  //====================================================//
            }else if(npcForm != null && (fabList.contains(npcForm.Fab__c) && npcForm.Reason_for_New_Part__c != 'Fab to Fab Transfer') && !isPIYEApproval){
            //}else if(npcForm != null && (fabList.contains(npcForm.Fab__c) && npcForm.Reason_for_New_Part__c != 'Fab to Fab Transfer' && npcForm.Reason_for_New_Part__c != 'Device Reactivation') && !isPIYEApproval){
                
                system.debug('10017');
                String fabApprovers = Environment_Variable__c.getInstance('Fab235Approvers').Value__c;
                String[] fabArr = fabApprovers.split(',');
                List<String> fabApproverList = new List<String>();
                for(String s : fabArr){
                    fabApproverList.add(s);
                }
                // Add the PIYE approvers to the Device Share
                //=========================================================//
                addToDeviceShare(fabApproverList);
                //=========================================================// 
                
                // ZAmbat 03032014
                npcForm.No_of_PIYE_Approvers__c = fabApproverList.size();
                for (integer i=0; i<fabApproverList.size(); i++) {
                    if (i == 0) {
                    system.debug('10018');
                        npcForm.PIYE_Approver_1__c = fabApproverList[i];
                    }else if (i == 1) {
                        npcForm.PIYE_Approver_2__c = fabApproverList[i];
                    }else if (i == 2) {
                    system.debug('10022');
                        npcForm.PIYE_Approver_3__c = fabApproverList[i];
                    }
                    //If conditions added by Sunil Arora for case # 40782 to use new field PIYE_Approver_4__c
                     else if (i == 3) {
                     system.debug('10024');
                        npcForm.PIYE_Approver_4__c = fabApproverList[i];
                    }
                    system.debug('10025');
                }
               system.debug('10026'); 
            }else if(this.npcFabCheck && !isPIYEApproval 
                && npcForm.PIYE_Approver_1__c == null && npcForm.PIYE_Approver_2__c == null
                && npcForm.PIYE_Approver_3__c == null && npcForm.PIYE_Approver_4__c == null){
                //condition updated by Sunil Arora for case # 40782 to use new field PIYE_Approver_4__c
                
                 system.debug('10028');
                ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please provide atleast 1 PI/YE Approver before approving the NPC Form.'));
                return null;
            }
           
            system.debug('10029');
            if(this.npcForm.Reason_for_New_Part__c == 'New Probe Card Flow' && this.npcForm.NPC_Form_Status__c == EnvironmentVariable.get('NPC_STATUS_PEND_MASK_ADD_FE')) {
                //DBiswal 12152014 - Added approvers for CE
                system.debug('10030');
                Device__c device = [SELECT      Id
                                               , Opportunity_Program__c
                                               , Fab__c
                                    FROM       Device__c
                                    WHERE      Id = :npcForm.BASE_Device__c];
                 if (device.Opportunity_Program__c != null) {
                 system.debug('10031');
                     // Retrieve Opportunity Program Team Members                   
                     List<Opportunity_Program_Team_Member__c> tempListOPTM = [
                        SELECT      Id
                                    , User__c
                                    , Fab_Assignment__c
                        FROM        Opportunity_Program_Team_Member__c
                        WHERE       Opportunity_Program__c = :device.Opportunity_Program__c
                                    AND Team_Role__c = 'Customer Engineer'
                                    AND User__r.IsActive = true
                                    AND Fab_Assignment__c LIKE :('%' + device.Fab__c + '%')
                        ORDER BY    CreatedDate
                        LIMIT 10
                        ];
                    
                    List<Opportunity_Program_Team_Member__c> listOPTM = new List<Opportunity_Program_Team_Member__c>();
                    if (tempListOPTM.size() > 0) {
                    system.debug('10032');
                        if (device.Fab__c == 'FAB 3') {
                        system.debug('10033');
                            for (Opportunity_Program_Team_Member__c o : tempListOPTM) {
                            system.debug('10034');
                                List<string> listFab = o.Fab_Assignment__c.split(';');
                                Set<string> setFab = new Set<string>();
                                setFab.addAll(listFab);
                                if (setFab.contains('FAB 3')) {
                                system.debug('10035');
                                    listOPTM.add(o);
                                }
                                system.debug('10036');
                            }
                            system.debug('10037');
                        } 
                        else {
                        system.debug('10039');
                            listOPTM.addAll(tempListOPTM);
                        }
                        system.debug('10040');
                    }
                    system.debug('10041');                   
                     // Clear values
                     npcForm.Approver_1__c = null;
                     npcForm.Approver_2__c = null;
                     npcForm.Approver_3__c = null;
                     npcForm.Approver_4__c = null;
                     npcForm.Approver_5__c = null;
                     npcForm.Approver_6__c = null;
                     npcForm.Approver_7__c = null;
                     npcForm.Approver_8__c = null;
                     npcForm.Approver_9__c = null;
                     npcForm.Approver_10__c = null;
                        
                     // Fill in Approvers
                     npcForm.No_of_Approvers__c = listOPTM.size();
                     system.debug('10042');
                     if (listOPTM.size() > 0) {
                     system.debug('10043');
                        if (listOPTM.size() == 1) {
                        system.debug('10044');
                           npcForm.Approver_1__c = listOPTM[0].User__c;
                        } else if (listOPTM.size() == 2) {
                        system.debug('10045');
                           npcForm.Approver_1__c = listOPTM[0].User__c;
                           npcForm.Approver_2__c = listOPTM[1].User__c;
                        } else if (listOPTM.size() == 3) {
                        system.debug('10046');
                           npcForm.Approver_1__c = listOPTM[0].User__c;
                           npcForm.Approver_2__c = listOPTM[1].User__c;
                           npcForm.Approver_3__c = listOPTM[2].User__c;
                        } else if (listOPTM.size() == 4) {
                        system.debug('10047');
                           npcForm.Approver_1__c = listOPTM[0].User__c;
                           npcForm.Approver_2__c = listOPTM[1].User__c;
                           npcForm.Approver_3__c = listOPTM[2].User__c;
                           npcForm.Approver_4__c = listOPTM[3].User__c;
                        } else if (listOPTM.size() == 5) {
                        system.debug('10048');
                           npcForm.Approver_1__c = listOPTM[0].User__c;
                           npcForm.Approver_2__c = listOPTM[1].User__c;
                           npcForm.Approver_3__c = listOPTM[2].User__c;
                           npcForm.Approver_4__c = listOPTM[3].User__c;
                           npcForm.Approver_5__c = listOPTM[4].User__c;
                        } else if (listOPTM.size() == 6) {
                        system.debug('10049');
                           npcForm.Approver_1__c = listOPTM[0].User__c;
                           npcForm.Approver_2__c = listOPTM[1].User__c;
                           npcForm.Approver_3__c = listOPTM[2].User__c;
                           npcForm.Approver_4__c = listOPTM[3].User__c;
                           npcForm.Approver_5__c = listOPTM[4].User__c;
                           npcForm.Approver_6__c = listOPTM[5].User__c;
                        } else if (listOPTM.size() == 7) {
                        system.debug('10050');
                           npcForm.Approver_1__c = listOPTM[0].User__c;
                           npcForm.Approver_2__c = listOPTM[1].User__c;
                           npcForm.Approver_3__c = listOPTM[2].User__c;
                           npcForm.Approver_4__c = listOPTM[3].User__c;
                           npcForm.Approver_5__c = listOPTM[4].User__c;
                           npcForm.Approver_6__c = listOPTM[5].User__c;
                           npcForm.Approver_7__c = listOPTM[6].User__c;
                         } else if (listOPTM.size() == 8) {
                           npcForm.Approver_1__c = listOPTM[0].User__c;
                           npcForm.Approver_2__c = listOPTM[1].User__c;
                           npcForm.Approver_3__c = listOPTM[2].User__c;
                           npcForm.Approver_4__c = listOPTM[3].User__c;
                           npcForm.Approver_5__c = listOPTM[4].User__c;
                           npcForm.Approver_6__c = listOPTM[5].User__c;
                           npcForm.Approver_7__c = listOPTM[6].User__c;
                           npcForm.Approver_8__c = listOPTM[7].User__c;
                         } else if (listOPTM.size() == 9) {
                           npcForm.Approver_1__c = listOPTM[0].User__c;
                           npcForm.Approver_2__c = listOPTM[1].User__c;
                           npcForm.Approver_3__c = listOPTM[2].User__c;
                           npcForm.Approver_4__c = listOPTM[3].User__c;
                           npcForm.Approver_5__c = listOPTM[4].User__c;
                           npcForm.Approver_6__c = listOPTM[5].User__c;
                           npcForm.Approver_7__c = listOPTM[6].User__c;
                           npcForm.Approver_8__c = listOPTM[7].User__c;
                           npcForm.Approver_9__c = listOPTM[8].User__c;
                         } else if (listOPTM.size() == 10) {
                           npcForm.Approver_1__c = listOPTM[0].User__c;
                           npcForm.Approver_2__c = listOPTM[1].User__c;
                           npcForm.Approver_3__c = listOPTM[2].User__c;
                           npcForm.Approver_4__c = listOPTM[3].User__c;
                           npcForm.Approver_5__c = listOPTM[4].User__c;
                           npcForm.Approver_6__c = listOPTM[5].User__c;
                           npcForm.Approver_7__c = listOPTM[6].User__c;
                           npcForm.Approver_8__c = listOPTM[7].User__c;
                           npcForm.Approver_9__c = listOPTM[8].User__c;
                           npcForm.Approver_10__c = listOPTM[9].User__c;
                         }
                      }
                 }  
                 
                 // Clear values
                 npcForm.FAE_Approver_1__c = null;
                 npcForm.FAE_Approver_2__c = null;
                 npcForm.FAE_Approver_3__c = null;
            }  
            if(npcForm.Min_Order_Create__c != null && npcForm.Min_Order_qty_agreement_with_customer__c != null){
                npcForm.Min_Order_qty_agreement_customer_Text__c = npcForm.Min_Order_qty_agreement_with_customer__c + ' ' +npcForm.Min_Order_Create__c;
            }    
            update npcForm;
            
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            //addComments(req);
            req.setComments(this.comments);
            system.debug('10051'+ req);
            req.setAction('Approve');
            Id workItemId = getWorkItemId(npcForm.id);

            system.debug('isPIYEApproval ===================> ' + isPIYEApproval);
            system.debug('workItemId ===================> ' + workItemId);            
            // Dipak 24102016 End    
            if(workItemId == null)
            {
                system.debug('10052');
                system.debug('Error');
            }
            // Approval by CE and then auto-submit
            else if(!isPIYEApproval && workItemId!=null)
            {
                system.debug('10053');
                req.setWorkitemId(workItemId);
                // Submit the request for approval
                Approval.ProcessResult result =  Approval.process(req);
                system.debug('result.isSuccess() ===================> ' + result.isSuccess());
                if(result.isSuccess()){
                  system.debug('10054');
                    //DBiswal 12182014 - For not entering into approval process when Reason for new Part is 'Fab to Fab Transfer'
                    if(this.npcForm.Reason_for_New_Part__c != 'Fab to Fab Transfer' && this.npcForm.Reason_for_New_Part__c != 'Change in PID'){  
                        //DBiswal 12152014 - For FAE Approval
                        system.debug('10055');
                        Approval.ProcessSubmitRequest reqSubmit = new Approval.ProcessSubmitRequest();
                        if(this.npcForm.Reason_for_New_Part__c == 'New Probe Card Flow' && this.npcForm.NPC_Form_Status__c == EnvironmentVariable.get('NPC_STATUS_PEND_MASK_ADD_FE')){
                            system.debug('10056');
                            reqSubmit.setComments('Auto Submission After FAE Approval');
                        } else {
                        system.debug('10057');
                        if(npcForm.Reason_For_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c){
                            reqSubmit.setComments('Auto Submission');
                        }
                        else
                        {
                          reqSubmit.setComments('Auto Submission After CE Approval');
                        }
                            system.debug('10058');
                        }
                        system.debug('10059');
                        reqSubmit.setObjectId(npcForm.id);  
                        Approval.Processresult resSubmit = Approval.process(reqSubmit);
                         system.debug('10060'+ resSubmit);
                    }
                    system.debug('10061');
                }
                system.debug('10062');
            }
            
            // Dipak 18102016 Start
            else if(isPIYEApproval && workItemId!=null && this.npcForm.STF_Activation_Steps__c == 'Step 1' 
                    && this.npcForm.Reason_for_New_Part__c == Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c
                    ){
                    
            // Dipak 24102016 End 
            system.debug('10064');
                req.setWorkitemId(workItemId);
                // Submit the request for approval
                Approval.ProcessSubmitRequest reqSubmit1 = new Approval.ProcessSubmitRequest();  // Dipak 18102016
                reqSubmit1.setObjectId(npcForm.id);                                              // Dipak 18102016  
                Approval.ProcessResult result =  Approval.process(req);
                system.debug('**PK****'+ reqSubmit1);                
                Approval.Processresult resSubmit = Approval.process(reqSubmit1);                 // Dipak 18102016
               req.setWorkitemId(workItemId);                                                   // Dipak 18102016
               system.debug('1006511'+ resSubmit );   
            }                    
            // Approval by PIYE
            else if(isPIYEApproval && workItemId!=null){
            system.debug('10064');
                req.setWorkitemId(workItemId);
                // Submit the request for approval 
                Approval.ProcessResult result =  Approval.process(req);
                system.debug('10065'+ result);
            }
                         
            system.debug('10066');
            return getNPCDetailPage();
        } else {
        system.debug('10067');
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('NPC_MASK_COUNT_FOR_APPROVAL_VALIDATION').Message__c));
            return null;
        }
    }
    // Reject NPC by CE and PIYE
    public PageReference rejectNPC(){
        
        if(String.isNotBlank(this.comments)){
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            //addComments(req);
            req.setComments(this.comments);
            
            req.setAction('Reject');
            Id workItemId = getWorkItemId(npcForm.id);
    
            if(workItemId == null)
            {
                system.debug('Error');
            }else{
                req.setWorkitemId(workItemId);
                // Submit the request for approval
                Approval.ProcessResult result =  Approval.process(req);
            }
            
            return getNPCDetailPage();
        }else{
             ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please enter Comments for rejecting NPC.'));
             return null;
        }
    }
    
    // Cancel NPC by CE and PIYE
    public PageReference cancelNPC(){        
        return getNPCDetailPage();
    }
    
    // Redirect to the NPC Readonly page
    private PageReference getNPCDetailPage(){
        PageReference pgRef = new PageReference('/apex/NPCFormInternalReadOnlyVF');
        pgRef.getParameters().put('id',npcForm.Id);
        pgRef.setRedirect(true);
        return pgRef;
    }    
    
    // Retrieve the last workitem among the list
    public Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;
        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
                                                where p.ProcessInstance.TargetObjectId =: targetObjectId]){
            retVal  =  workItem.Id;
        }
        return retVal;
    }
    
    // Add users to the Device Share
    private void addToDeviceShare(List<String> usrIdPiyeList){
        List<Device__Share> devShareList = new List<Device__Share>();
        for(Id idPiyeUsr : usrIdPiyeList){              
            if(idPiyeUsr != npcForm.BASE_Device__r.OwnerId){
                Device__Share ds = new Device__Share();
                ds.AccessLevel = 'Edit';
                ds.RowCause = Schema.Device__Share.RowCause.NPC_Approver__c;
                ds.ParentId = npcForm.BASE_Device__c;
                ds.UserOrGroupId = idPiyeUsr;
                devShareList.add(ds);
            }
        }
        if(devShareList.size()>0){
            insert devShareList;
        }
        
    }
    
    // ZAmbat 12052014
    // Get the FEs based on the Device's Opportunity Program Team
    public List<string> retrieveFEs() {
        List<string> listFEIds = new List<string>();
        for (Opportunity_Program_Team_Member__c o : [SELECT      Id
                                                                , User__c
                                                     FROM        Opportunity_Program_Team_Member__c
                                                     WHERE       Opportunity_Program__c = :this.npcForm.Originating_Device__r.Opportunity_Program__c
                                                                 AND (   Team_Role__c = 'Field Application Engineer' 
                                                                      OR Team_Role__c = 'Primary Field Application Engineer'
                                                                      OR (Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                                                      OR (Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE)
                                                                      )
                                                                 AND User__r.IsActive = true
                                                                 //AND Fab_Assignment__c LIKE :('%' + this.npcForm.Fab__c + '%')
                                                     ORDER BY    CreatedDate
                                                     LIMIT 10]) {
            listFEIds.add(o.User__c);
        }  
        
        return listFEIds;                  
    }

      // dipak 02112016 start
      public List<SelectOption> getTypes(){
       List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = New_Part_Creation_Form__c.Min_Order_Create__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
       for( Schema.PicklistEntry f : ple){
           options.add(new SelectOption(f.getLabel(), f.getValue().capitalize()));
        }       
      return options;
    }
    // dipak 02112016 end
      public Attachment getRemoveAttachment() {
        if (this.attachId == null) {
            for (AttachmentWrapper aw : this.listAttachments) {
                aw.attachment = new Attachment();
            }
        } else {
            for (AttachmentWrapper aw : this.listAttachments) {
                if (this.attachId == aw.id) {
                    aw.attachment = new Attachment();
                }
            }
            
            this.attachId = null;
        }
        
        return new Attachment();
    }
    
    public void addMore() {
        AttachmentWrapper aw = new AttachmentWrapper();
        aw.id = 'NPCFormVF:form1:BlkEdit:repeatAttach:' + this.listAttachments.size() + ':attach';
        aw.label = '';
        aw.attachment = new Attachment();
        this.listAttachments.add(aw);
    }
    public void refreshAttachments() {
        // Set attachment
        this.listAttachments = new List<AttachmentWrapper>();
        AttachmentWrapper aw = new AttachmentWrapper();
        aw.id = 'NPCFormVF:form1:BlkEdit:repeatAttach:0:attach';
        aw.label = 'Attachment(s)';
        aw.attachment = new Attachment();
        this.listAttachments.add(aw);
    }
      public class AttachmentWrapper {
        public string id {get;set;}
        public string label {get;set;}
        public Attachment attachment {get;set;} 
    }
      // Dipak 27092016 End
   public static void shareNPCtoPIYE(set<Id> uIds,ID recordID){  
       list<Device__share>  oDevicesShare = new list<Device__share>();          
        for(id ouserid : uIds){
             Device__Share rec = new Device__Share();
                rec.AccessLevel = 'Read';
                rec.ParentId = recordID;
                rec.RowCause = Schema.Device__Share.RowCause.Manual;
                rec.UserOrGroupId = ouserid;           
            oDevicesShare.add(rec);
        }   
        if(!oDevicesShare.isEmpty()) 
            insert   oDevicesShare;     
   }      
}