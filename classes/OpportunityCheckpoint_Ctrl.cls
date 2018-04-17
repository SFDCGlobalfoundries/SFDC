/*Author: Meghna Ganguly
    Description: Controller for Opportunity Checkpoint VF Page
    
    History:
    Created-Meghna Ganguly-02/20/2017-code creation.
    Modified-Poulami Saha-06/15/2017-Replaced Obstacles field with Opportunity Obstacles
            Poulami Saha-06/15/2017-The fields in control point 1,2 should be shown as alert but allow users to complete the checkpoint
            Poulami Saha-07/12/2017-Auto check the pricing CP3 box whenever CP2 is completed
            Poulami Saha-07/26/2017-The missing fields in control point 2 should be shown as error message and will not allow users to complete the checkpoint
                                    The missing fields in control point 1 should be shown as information message and will allow users to complete the checkpoint
*/

public class OpportunityCheckpoint_Ctrl {
    //added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
    // the actual account
    public  opportunity opp{get;set;}
    public Account acc;
    public boolean isedit{get;set;}
    public boolean isedit2{get;set;}
    public string message{get;set;}
    public boolean hasAccess{get;set;}
    public boolean prediscovery{get;set;}
    public Error_Codes__c settings;
    public List<opportunity> listofOptyrec;
    public List<SelectOption> productLineOptions {get;set;}
    public List<SelectOption> bunitOptions {get;set;}
    public List<SelectOption> msegmentOptions {get;set;} 
    public List<SelectOption> pgeometryOptions {get;set;}
    public List<SelectOption> pfamilyOptions {get;set;}
    public List<SelectOption> tpnOptions {get;set;}
    public List<SelectOption> pconfidenceOptions {get;set;}
    public List<SelectOption> osourcingOptions {get;set;}
    public List<SelectOption> pgffabOptions {get;set;}
    public List<SelectOption> platformcateOptions {get;set;}
    public List<SelectOption> gfcommittedOptions {get;set;}
    public List<SelectOption> customdecisionOptions {get;set;}
    public List<SelectOption> enteredaspOptions {get;set;}
    public Boolean showCP3 {get; set;}
    public Boolean showDGStatus {get;set;}
    
    public OpportunityCheckpoint_Ctrl(ApexPages.StandardController controller) {
        message='';
        isedit=false;
        isedit2=false;
        prediscovery=true;
        hasAccess = false;
        settings = Error_Codes__c.getInstance('OPP_SUCCESSFUL_UPDATE');
    
        productLineOptions = new List<SelectOption>();
        bunitOptions = new List<SelectOption>();
        msegmentOptions = new List<SelectOption>();
        pgeometryOptions = new List<SelectOption>();
        pfamilyOptions = new List<SelectOption>();
        tpnOptions = new List<SelectOption>();
        pconfidenceOptions = new List<SelectOption>();
        osourcingOptions = new List<SelectOption>();
        pgffabOptions = new List<SelectOption>();
        platformcateOptions = new List<SelectOption>();
        gfcommittedOptions = new List<SelectOption>();
        customdecisionOptions = new List<SelectOption>();
        enteredaspOptions = new List<SelectOption>();
        
        Schema.DescribeFieldResult pLine = Opportunity.Product_Line__c.getDescribe();
        Schema.DescribeFieldResult bUnit = Opportunity.Business_Unit__c.getDescribe();
        Schema.DescribeFieldResult mSegment = Opportunity.Market_Segment__c.getDescribe();
        Schema.DescribeFieldResult pGeometry = Opportunity.Process_Geometry__c.getDescribe();
        Schema.DescribeFieldResult pFamily = Opportunity.Process_Family__c.getDescribe();
        Schema.DescribeFieldResult tpNode = Opportunity.Target_Process_Node__c.getDescribe();
        Schema.DescribeFieldResult pConfidence = Opportunity.Production_Confidence__c.getDescribe();
        Schema.DescribeFieldResult oSourcing = Opportunity.Opportunity_Sourcing_Type__c.getDescribe();
        Schema.DescribeFieldResult pgFab = Opportunity.Fab_Assignment_1__c.getDescribe();
        Schema.DescribeFieldResult platCateg = Opportunity.Process_Platform__c.getDescribe();
        Schema.DescribeFieldResult gfCommit = Opportunity.Is_GF_Committed_to_Process__c.getDescribe();
        Schema.DescribeFieldResult custDecision = Opportunity.Customer_Decision_Maker__c.getDescribe();
        Schema.DescribeFieldResult enteredAsp = Opportunity.Does_entered_ASP_Align_with_Quote__c.getDescribe();
       
        
        //initialize the stanrdard controller
       
        opp = (opportunity)controller.getRecord();
        List<opportunity> oppList = [Select Product_Line__c,Business_Unit__c,CloseDate,AccountId,Name,StageName,Market_Segment__c,Process_Geometry__c,Process_Family__c,Target_Process_Node__c,
        Obstacles__c,Opportunity_Obstacles__c,Production_Confidence__c,Opportunity_Sourcing_Type__c,Fab_Split__c,Fab_Assignment_1__c,Process_Platform__c,Approved_GMPL_BX009_DW__c,
        GF_Target_Share__c,X1st_Product_TO_Date__c,X1st_Product_Production_Date__c,Years_of_Production__c,Describe_Product_Development_Plan__c,
        Is_GF_Committed_to_Process__c,Customer_Decision_Maker__c,Paste_Commitment_Text_from_Customer__c,Informal_Quote__c,Option__c,Does_entered_ASP_Align_with_Quote__c,
        Quote__c,OwnerId,Account_Owner__c,AM_CP1__c,FAE_CP1__c,PLM_CP1__c,MarketSegment_CP1__c,AM_CP2__c,FAE_CP2__c,PLM_CP2__c,MarketSegment_CP2__c,Finance_Check_CP2__c,
        AM_CP3__c,FAE_CP3__c,PLM_CP3__c,MarketSegment_CP3__c,Finance_Check_CP3__c,Opportunity_Health__c,Deliverable_Type__c,Design_Win_w_NWR_Revenue__c,
        Description__c,Estimated_Die_X_dim_mm__c,Estimated_Die_Y_dim_mm__c,Application_and_Socket_Def__c, die_target_device__c,Assigned_PLM__c,Assigned_Segment_Marketing__c,Account_Stage__c,Deal_Grading_status__c from Opportunity where id =: opp.id]; 
        if(oppList!=null){
        opp=oppList[0];
        if(opp.AM_CP2__c && opp.FAE_CP2__c && opp.PLM_CP2__c && opp.MarketSegment_CP2__c){
            showCP3 = true;
        }else{
            showCP3 = false;
        }
        
        if(opp.Product_Line__c == 'ASIC' || opp.Product_Line__c == 'SiPh'){
            showDGStatus = true;
        }else{
            showDGStatus = false;
        }
        
        acc = [Select OwnerId from Account where id=: opp.AccountId limit 1];
        }
        checkAccess();
        checkPreDiscovery();
        for (Schema.Picklistentry picklistEntry:pLine.getPicklistValues()){

            productLineOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));

            // obtain and assign default value
            if(opp.Product_Line__c == null || opp.Product_Line__c == ''){
                if (picklistEntry.defaultValue){
                    opp.Product_Line__c = pickListEntry.getValue();
                } 
            }           
        } 
        for (Schema.Picklistentry picklistEntry:bUnit.getPicklistValues()){

            bunitOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));

            // obtain and assign default value
            if(opp.Business_Unit__c == null || opp.Business_Unit__c == ''){
                if (picklistEntry.defaultValue){
                    opp.Business_Unit__c = pickListEntry.getValue();
                } 
            }
        } 
        for (Schema.Picklistentry picklistEntry:mSegment.getPicklistValues()){

            msegmentOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));

            // obtain and assign default value
            if(opp.Market_Segment__c == null || opp.Market_Segment__c == ''){
                if (picklistEntry.defaultValue){
                    opp.Market_Segment__c = pickListEntry.getValue();
                }
            }
        } 
        for (Schema.Picklistentry picklistEntry:pGeometry.getPicklistValues()){

            pgeometryOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));

            // obtain and assign default value
            if(opp.Process_Geometry__c == null || opp.Process_Geometry__c == ''){
                if (picklistEntry.defaultValue){
                    opp.Process_Geometry__c = pickListEntry.getValue();
                } 
            }           
        } 
        for (Schema.Picklistentry picklistEntry:pFamily.getPicklistValues()){

            pfamilyOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));

            // obtain and assign default value
            if(opp.Process_Family__c == null || opp.Process_Family__c == ''){
                if (picklistEntry.defaultValue){
                    opp.Process_Family__c = pickListEntry.getValue();
                } 
            }           
        } 
        for (Schema.Picklistentry picklistEntry:tpNode.getPicklistValues()){

            tpnOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));

            // obtain and assign default value
            if(opp.Target_Process_Node__c == null || opp.Target_Process_Node__c == ''){
                if (picklistEntry.defaultValue){
                    opp.Target_Process_Node__c = pickListEntry.getValue();
                }  
            }
        } 
        for (Schema.Picklistentry picklistEntry:pConfidence.getPicklistValues()){

            pconfidenceOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));

            // obtain and assign default value
            if(opp.Production_Confidence__c == null || opp.Production_Confidence__c == ''){
                if (picklistEntry.defaultValue){
                    opp.Production_Confidence__c = pickListEntry.getValue();
                }
            }

        } 
        for (Schema.Picklistentry picklistEntry:oSourcing.getPicklistValues()){

            osourcingOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));

            // obtain and assign default value
            if(opp.Opportunity_Sourcing_Type__c == null || opp.Opportunity_Sourcing_Type__c == ''){
                if (picklistEntry.defaultValue){
                    opp.Opportunity_Sourcing_Type__c = pickListEntry.getValue();
                }  
            }
        } 
        for (Schema.Picklistentry picklistEntry:pgFab.getPicklistValues()){

            pgffabOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));

            // obtain and assign default value
            if(opp.Fab_Assignment_1__c == null || opp.Fab_Assignment_1__c == ''){
                if (picklistEntry.defaultValue){
                    opp.Fab_Assignment_1__c = pickListEntry.getValue();
                } 
            }           
        } 
        for (Schema.Picklistentry picklistEntry:platCateg.getPicklistValues()){

            platformcateOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));

            // obtain and assign default value
            if(opp.Process_Platform__c == null || opp.Process_Platform__c == ''){
                if (picklistEntry.defaultValue){
                    opp.Process_Platform__c = pickListEntry.getValue();
                }  
            }   
        } 
        for (Schema.Picklistentry picklistEntry:gfCommit.getPicklistValues()){

            gfcommittedOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));

            // obtain and assign default value
            if(opp.Is_GF_Committed_to_Process__c == null || opp.Is_GF_Committed_to_Process__c == ''){   
                if (picklistEntry.defaultValue){
                    opp.Is_GF_Committed_to_Process__c = pickListEntry.getValue();
                }  
            }
        } 
        for (Schema.Picklistentry picklistEntry:custDecision.getPicklistValues()){

            customdecisionOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));

            // obtain and assign default value
            if(opp.Customer_Decision_Maker__c == null || opp.Customer_Decision_Maker__c == ''){
                if (picklistEntry.defaultValue){
                    opp.Customer_Decision_Maker__c = pickListEntry.getValue();
                }  
            }
        } 
        for (Schema.Picklistentry picklistEntry:enteredAsp.getPicklistValues()){

            enteredaspOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));

            // obtain and assign default value
            if(opp.Does_entered_ASP_Align_with_Quote__c == null || opp.Does_entered_ASP_Align_with_Quote__c == ''){
                if (picklistEntry.defaultValue){
                    opp.Does_entered_ASP_Align_with_Quote__c = pickListEntry.getValue();
                }  
            }
        } 
    }
    public pagereference edit(){
        isedit=true;
        
       return null;
    }
    
    public pagereference edit2(){
        isedit2=true;
       return null;
    }
    
    public pagereference checkAccess(){
        if((UserInfo.getUserId() == opp.OwnerId)||(UserInfo.getUserId() == acc.OwnerId)){
        hasAccess=true;
        }
       return null;
    }
    
     public pagereference checkPreDiscovery(){
       
       Map<Id, Account_Team_Proxy__c> atpMap = new Map<Id, Account_Team_Proxy__c>();
       
       for (Account_Team_Proxy__c atp : [ select Id,User__r.Id,User__c,User__r.Name,Team_Role__c,Account__c
                from Account_Team_Proxy__c where Account__c =:opp.accountId and ((Team_Role__c='Account Manager') OR(Team_Role__c='Primary Account Manager') )]) {
                
            atpMap.put(atp.Account__c, atp);
        }
        
         Account_Team_Proxy__c atpc = atpMap.get(opp.accountId);
            if(atpc!=null&&atpc.User__c!=null){
            if (opp.OwnerId == atpc.User__r.Id) {
               prediscovery= false;  
            }
          }
       return null;
    }
    
   public Pagereference doCancel(){
        
        pageReference pageRef = new pageReference('/apex/OpportunityCheckpoint?id='+opp.id);
        pageRef.setRedirect(true);
        return pageRef;
   
    } 
    
    public Pagereference doCancel2(){
        
        pageReference pageRef = new pageReference('/apex/OpportunityCheckpoint?id='+opp.id);
        pageRef.setRedirect(true);
        return pageRef;
   
    }
    public Pagereference doSave(){
        
        try{   
            markReviewcp3Field();
            markReviewcp2Field();
            if(opp.StageName == '0.Pre-Discovery' ||test.isrunningtest())markReviewcp1Field();
            //update opp;
            Database.SaveResult SR = Database.update(opp);
            isedit=false;
        
        }catch (Exception e) {
            GlobalUtility.logMessage('Error','OpportunityCheckPoint_Ctrl','doSave','','Exception while creating/updating Opportunity record',String.valueof(e.getMessage()),'','Opportunity Management',e,0);
        }
        
        
        return null;
   
    }
    
    public Pagereference doSave2(){
        
        try{   
            markReviewFlagcp3();
            markReviewFlagcp2();
            if(opp.StageName == '0.Pre-Discovery' ||test.isrunningtest())markReviewFlagcp1();
            /*if(opp.AM_CP2__c == true && opp.FAE_CP2__c == true && opp.PLM_CP2__c == true && opp.MarketSegment_CP2__c == true){
                opp.Finance_Check_CP3__c = true;
            }*/
            //update opp;
            Database.SaveResult SR = Database.update(opp);
            isedit2=false;
            listofOptyrec = [select id,Product_Line__c, Business_Unit__c, CloseDate, AccountId, Name, StageName, Market_Segment__c, Process_Geometry__c, Process_Family__c, Target_Process_Node__c, Obstacles__c, Opportunity_Obstacles__c, Production_Confidence__c, Opportunity_Sourcing_Type__c, Fab_Split__c, Fab_Assignment_1__c, Process_Platform__c, Approved_GMPL_BX009_DW__c, GF_Target_Share__c, X1st_Product_TO_Date__c, X1st_Product_Production_Date__c, Years_of_Production__c, Describe_Product_Development_Plan__c, Is_GF_Committed_to_Process__c, Customer_Decision_Maker__c, Paste_Commitment_Text_from_Customer__c, Informal_Quote__c,Option__c, Does_entered_ASP_Align_with_Quote__c, Quote__c,Account.Recordtype.Name,AM_CP1__c,FAE_CP1__c,PLM_CP1__c,MarketSegment_CP1__c,AM_CP2__c,FAE_CP2__c,PLM_CP2__c,MarketSegment_CP2__c,Finance_Check_CP2__c,AM_CP3__c,FAE_CP3__c,PLM_CP3__c,MarketSegment_CP3__c,Finance_Check_CP3__c from opportunity where id =: opp.id];
            OpportunitySendMailClass opty = new OpportunitySendMailClass();
            opty.opportunitychecklistmember(listofOptyrec);
            system.debug('Opp for mail: ' +listofOptyrec);
        
        }catch (Exception e) {
            GlobalUtility.logMessage('Error','OpportunityCheckPoint_Ctrl','doSave','','Exception while creating/updating Opportunity record',String.valueof(e.getMessage()),'','Opportunity Management',e,0);
            }
        
        return null;
   
    }
    
    private pagereference markReviewFlagcp1(){
        message='';
        if(opp.AM_CP1__c || opp.FAE_CP1__c ||test.isrunningtest()){
            boolean checkflag=false;
            for(Schema.FieldSetMember fld :SObjectType.opportunity.FieldSets.ARCControlPOint1.getFields()) {
                /*if(opp.get(fld.getFieldPath())==null){
                    checkflag=true;
                    message+='Please enter value for '+fld.label+'\n';
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please enter value for '+fld.label);
                   ApexPages.addMessage(myMsg); 
                }*/
                if(fld.getFieldPath() != 'Approved_GMPL_BX009_DW__c'){
                    if(opp.get(fld.getFieldPath())==null){
                        checkflag=true;
                        //message+='Please enter value for '+fld.label+'\n';
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please enter value for '+fld.label);
                        ApexPages.addMessage(myMsg); 
                    }
                }
                else{
                    if(opp.Process_Platform__c != 'GF Baseline plus custom modules' && opp.Process_Platform__c != 'GF Baseline'){
                        if(opp.get(fld.getFieldPath())==null){
                            checkflag=true;
                            //message+='Please enter value for '+fld.label+'\n';
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please enter value for '+fld.label);
                            ApexPages.addMessage(myMsg); 
                        }
                    }
                }
            }
            /*if(checkflag){
                opp.AM_CP1__c=false;
                opp.FAE_CP1__c=false;
               try{
                update opp; 
                }
               catch (Exception e) {
                GlobalUtility.logMessage('Error','OpportunityCheckPoint_Ctrl','markReviewFlagcp1','','Exception while creating/updating Opportunity record',String.valueof(e.getMessage()),'','Opportunity Management',e,0);
                }
                return null;
            }else{
                try{
                 update opp;
                 }
                catch (Exception e) {
                GlobalUtility.logMessage('Error','OpportunityCheckPoint_Ctrl','markReviewFlagcp1','','Exception while creating/updating Opportunity record',String.valueof(e.getMessage()),'','Opportunity Management',e,0);
                } 
                isedit=false;
                isedit2=false;
                message+=settings.Message__c;
                 
                 return null;
            }*/
            isedit=false;
            isedit2=false;
                
        }
        return null;
    }
    
    private pagereference markReviewcp1Field(){
        if(opp.AM_CP1__c || opp.FAE_CP1__c ||test.isrunningtest()){
            boolean checkflag=false;
            for(Schema.FieldSetMember fld :SObjectType.opportunity.FieldSets.ARCControlPOint1.getFields()) {
                if(fld.getFieldPath() != 'Approved_GMPL_BX009_DW__c'){
                    if(opp.get(fld.getFieldPath())==null){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please enter value for '+fld.label);
                        ApexPages.addMessage(myMsg); 
                    }
                }
                else{
                    if(opp.Process_Platform__c != 'GF Baseline plus custom modules' && opp.Process_Platform__c != 'GF Baseline'){
                        if(opp.get(fld.getFieldPath())==null){
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please enter value for '+fld.label);
                            ApexPages.addMessage(myMsg); 
                        }
                    }
                }
            }
            isedit=false;
            isedit2=false;
                
        }
        return null;
    }
    
    private pagereference markReviewFlagcp2(){
    
        message='';
        if(opp.AM_CP2__c || opp.FAE_CP2__c ||opp.PLM_CP2__c ||opp.MarketSegment_CP2__c ||test.isrunningtest()){
            boolean checkflag=false;
            boolean checkPLMFlag = false;
            if(opp.Account_Stage__c != 'Authorized' && opp.Account_Stage__c != 'Qualified'){
                checkflag=true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Account Stage should be Qualified or Authorized');
                ApexPages.addMessage(myMsg); 
            }
            
            for(Schema.FieldSetMember fld :SObjectType.opportunity.FieldSets.ARCControlPOint2.getFields()) {
                /*if(opp.get(fld.getFieldPath())==null){
                    checkflag=true;
                    message+='Please enter value for '+fld.label+'\n';
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter value for '+fld.label);
                    ApexPages.addMessage(myMsg); 
                }*/
                if(fld.getFieldPath() != 'Approved_GMPL_BX009_DW__c'){
                    if(opp.get(fld.getFieldPath())==null){
                        checkflag=true;
                        //message+='Please enter value for '+fld.label+'\n';
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter value for '+fld.label);
                        ApexPages.addMessage(myMsg); 
                    }
                }
                else{
                    /*if(opp.Process_Platform__c != 'GF Baseline plus custom modules' && opp.Process_Platform__c != 'GF Baseline'){
                        if(opp.get(fld.getFieldPath())==null){
                            checkflag=true;
                            //message+='Please enter value for '+fld.label+'\n';
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter value for '+fld.label);
                            ApexPages.addMessage(myMsg); 
                        }
                    }*/
                    if(opp.PLM_CP2__c){
                        if(opp.get(fld.getFieldPath())==null){
                            checkPLMFlag=true;
                            //message+='Please enter value for '+fld.label+'\n';
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter value for '+fld.label);
                            ApexPages.addMessage(myMsg); 
                        }
    
                    }
                }
            }
            if(checkflag || checkPLMFlag){
                if(checkflag){
                    opp.AM_CP2__c=false;
                    opp.FAE_CP2__c=false;
                    opp.PLM_CP2__c=false;
                    opp.MarketSegment_CP2__c=false;
                }else{
                    opp.PLM_CP2__c=false;
                }
                try{
                //update opp;
                }
                catch (Exception e) {
            GlobalUtility.logMessage('Error','OpportunityCheckPoint_Ctrl','markReviewFlagcp2','','Exception while creating/updating Opportunity record',String.valueof(e.getMessage()),'','Opportunity Management',e,0);
                }
                return null;
            }else{
                
                 //update opp;
               
                isedit=false;
                isedit2=false;
                //message+=settings.Message__c;
                if(opp.AM_CP2__c && opp.FAE_CP2__c && opp.PLM_CP2__c && opp.MarketSegment_CP2__c){
                    showCP3 = true;
                }else{
                    showCP3 = false;
                }
              
                 return null;
            }
            //isedit=false;
            //isedit2=false;
                
        }
        return null;
    }
    
    private pagereference markReviewcp2Field(){
        if(opp.AM_CP2__c || opp.FAE_CP2__c ||opp.PLM_CP2__c ||opp.MarketSegment_CP2__c ||test.isrunningtest()){
            if(opp.Account_Stage__c != 'Authorized' && opp.Account_Stage__c != 'Qualified'){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Account Stage should be Qualified or Authorized');
                ApexPages.addMessage(myMsg); 
            }
            
            for(Schema.FieldSetMember fld :SObjectType.opportunity.FieldSets.ARCControlPOint2.getFields()) {
                if(fld.getFieldPath() != 'Approved_GMPL_BX009_DW__c'){
                    if(opp.get(fld.getFieldPath())==null){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter value for '+fld.label);
                        ApexPages.addMessage(myMsg); 
                    }
                }
                else{
                    /*if(opp.Process_Platform__c != 'GF Baseline plus custom modules' && opp.Process_Platform__c != 'GF Baseline'){
                        if(opp.get(fld.getFieldPath())==null){
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter value for '+fld.label);
                            ApexPages.addMessage(myMsg); 
                        }
                    }*/
                    if(opp.PLM_CP2__c){
                        if(opp.get(fld.getFieldPath())==null){
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter value for '+fld.label);
                            ApexPages.addMessage(myMsg); 
                        }
    
                    }
                }
            }
            isedit=false;
            isedit2=false;
        }
        return null;
    }
    
    private pagereference markReviewFlagcp3(){
        message='';
        if(opp.AM_CP3__c || opp.FAE_CP3__c ||opp.PLM_CP3__c ||opp.MarketSegment_CP3__c||opp.Finance_Check_CP3__c||test.isrunningtest()){
            boolean checkflag=false;
            boolean checkPLMFlag = false;
            if(opp.Informal_Quote__c == null && opp.Quote__c == null && opp.Option__c == null){
                checkflag=true;
                //message+='Please enter value for any of 1 fields Quote # (DW), Informal Quote(DW), Accepted Option (DW)';
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter value for any of 1 fields Quote # (DW), Informal Quote(DW), Accepted Option (DW)');
                ApexPages.addMessage(myMsg); 
            }
            if(opp.Account_Stage__c != 'Authorized' && opp.Account_Stage__c != 'Qualified'){
                checkflag=true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Account Stage should be Qualified or Authorized');
                ApexPages.addMessage(myMsg); 
            }
            
            for(Schema.FieldSetMember fld :SObjectType.opportunity.FieldSets.ARCControlPOint3.getFields()) {
                                
                if(fld.getFieldPath() != 'Approved_GMPL_BX009_DW__c'){
                    if(opp.get(fld.getFieldPath())==null){
                        checkflag=true;
                        //message+='Please enter value for '+fld.label+'\n';
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter value for '+fld.label);
                        ApexPages.addMessage(myMsg); 
                    }
                }
                else{
                    /*if(opp.Process_Platform__c != 'GF Baseline plus custom modules' && opp.Process_Platform__c != 'GF Baseline'){
                        if(opp.get(fld.getFieldPath())==null){
                            checkflag=true;
                            //message+='Please enter value for '+fld.label+'\n';
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter value for '+fld.label);
                            ApexPages.addMessage(myMsg); 
                        }
                    }*/
                    if(opp.PLM_CP3__c){
                        if(opp.get(fld.getFieldPath())==null){
                            checkPLMFlag=true;
                            //message+='Please enter value for '+fld.label+'\n';
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter value for '+fld.label);
                            ApexPages.addMessage(myMsg); 
                        }
    
                    }
                }
            }
            if(checkflag || checkPLMFlag){
                if(checkflag){
                    opp.AM_CP3__c=false;
                    opp.FAE_CP3__c=false;
                    opp.PLM_CP3__c=false;
                    opp.MarketSegment_CP3__c=false;
                }else{
                    opp.PLM_CP3__c=false;
                }
                try{
                    //update opp;
                }
                catch (Exception e) {
                    GlobalUtility.logMessage('Error','OpportunityCheckPoint_Ctrl','markReviewFlagcp3','','Exception while creating/updating Opportunity record',String.valueof(e.getMessage()),'','Opportunity Management',e,0);
                }
                return null;
            }else{
                try{
                    //update opp;
                }
                catch (Exception e) {
                    GlobalUtility.logMessage('Error','OpportunityCheckPoint_Ctrl','markReviewFlagcp3','','Exception while creating/updating Opportunity record',String.valueof(e.getMessage()),'','Opportunity Management',e,0);
                }
                isedit=false;
                isedit2=false;
                //message+=settings.Message__c;
             
                return null;
            }

                
        }
        return null;
    }

    private pagereference markReviewcp3Field(){
        if(opp.AM_CP3__c || opp.FAE_CP3__c ||opp.PLM_CP3__c ||opp.MarketSegment_CP3__c||opp.Finance_Check_CP3__c||test.isrunningtest()){
            if(opp.Informal_Quote__c == null && opp.Quote__c == null && opp.Option__c == null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter value for any of 1 fields Quote # (DW), Informal Quote(DW), Accepted Option (DW)');
                ApexPages.addMessage(myMsg); 
            }
            if(opp.Account_Stage__c != 'Authorized' && opp.Account_Stage__c != 'Qualified'){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Account Stage should be Qualified or Authorized');
                ApexPages.addMessage(myMsg); 
            }
            
            for(Schema.FieldSetMember fld :SObjectType.opportunity.FieldSets.ARCControlPOint3.getFields()) {
                if(fld.getFieldPath() != 'Approved_GMPL_BX009_DW__c'){
                    if(opp.get(fld.getFieldPath())==null){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter value for '+fld.label);
                        ApexPages.addMessage(myMsg); 
                    }
                }
                else{
                    /*if(opp.Process_Platform__c != 'GF Baseline plus custom modules' && opp.Process_Platform__c != 'GF Baseline'){
                        if(opp.get(fld.getFieldPath())==null){
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter value for '+fld.label);
                            ApexPages.addMessage(myMsg); 
                        }
                    }*/
                    if(opp.PLM_CP3__c){
                        if(opp.get(fld.getFieldPath())==null){
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter value for '+fld.label);
                            ApexPages.addMessage(myMsg); 
                        }
    
                    }
                }
            }
            isedit=false;
            isedit2=false;
        }
        return null;
    }
    
    
}