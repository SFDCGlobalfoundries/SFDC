/*Author: Meghna Ganguly
    Description: Controller for Opportunity Control Point VF Page
    
    History:
    Created-Meghna Ganguly-02/20/2017-code creation.
    Modified-Poulami Saha-06/15/2017-The fields in control point 1,2 should be shown as alert but allow users to complete the checkpoint
            Poulami Saha-07/12/2017-Auto check the pricing CP3 box whenever CP2 is completed
            Poulami Saha-07/26/2017-The missing fields in control point 2 should be shown as error message and will not allow users to complete the checkpoint
                                    The missing fields in control point 1 should be shown as information message and will allow users to complete the checkpoint
*/
public class OpportunityControlPoint_Ctrl {

    //added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
    // the actual account
    public  opportunity opp{get;set;}
    public boolean isedit{get;set;}
    public boolean prediscovery{get;set;}
    public string message{get;set;}
    public List<opportunity> listofOptyrec;
    public Error_Codes__c settings;
    public Boolean refreshPage {get; set;}
    public Boolean showCP3 {get; set;}
    
    public OpportunityControlPoint_Ctrl(ApexPages.StandardController controller) {
        //message='';
        isedit=false;
        prediscovery=true;
        settings = Error_Codes__c.getInstance('OPP_SUCCESSFUL_UPDATE');
        refreshPage=false;
        //initialize the stanrdard controller
        this.controller = controller;
        this.opp = (opportunity)controller.getRecord();
        string queryString = 'select id';
        for(Schema.FieldSetMember fld :SObjectType.opportunity.FieldSets.ARCControlPOint3.getFields()) {
         queryString += ', ' + fld.getFieldPath();
        }
        queryString += ',Account.Recordtype.Name,Account_Stage__c,Deal_Grading_status__c, AM_CP1__c,FAE_CP1__c,PLM_CP1__c,MarketSegment_CP1__c';
        queryString += ',AM_CP2__c,FAE_CP2__c,PLM_CP2__c,MarketSegment_CP2__c,Finance_Check_CP2__c';
        queryString += ',AM_CP3__c,FAE_CP3__c,PLM_CP3__c,MarketSegment_CP3__c,Finance_Check_CP3__c,OwnerId,Option__c,Quote__c, Informal_Quote__c'; 
        queryString += ',AM_last_modified_by_CP1__c,AM_last_modified_date_CP1__c,AM_last_modified_by_CP2__c,AM_last_modified_date_CP2__c,AM_last_modified_by_CP3__c,AM_last_modified_date_CP3__c,FAE_last_modified_by_CP1__c,FAE_last_modified_date_CP1__c,FAE_last_modified_by_CP2__c,FAE_last_modified_date_CP2__c,FAE_last_modified_by_CP3__c,FAE_last_modified_date_CP3__c'; 
        queryString += ',PLM_last_modified_by_CP2__c,PLM_last_modified_date_CP2__c,PLM_last_modified_by_CP3__c,PLM_last_modified_date_CP3__c,Market_Segment_last_modified_by_CP2__c,Market_Segment_last_modified_date_CP2__c,Market_Segment_last_modified_by_CP3__c,Market_Segment_last_modified_date_CP3__c,Pricing_last_modified_by_CP3__c,Pricing_last_modified_date_CP3__c,Assigned_PLM__c,Assigned_Segment_Marketing__c';
        queryString += ' from opportunity where id=\''+opp.id+'\'';         
        List<opportunity> oppList = Database.query(queryString);
        opp=oppList[0];
        
        if(opp.AM_CP2__c && opp.FAE_CP2__c && opp.PLM_CP2__c && opp.MarketSegment_CP2__c){
            showCP3 = true;
        }else{
            showCP3 = false;
        }
        
        checkPreDiscovery();
    }
    public pagereference edit(){
        //message='';
        isedit=true;
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
      
    public pagereference save(){
        //message=''; 
        
        try{        
            markReviewFlagcp3();
            markReviewFlagcp2();
            if(opp.StageName == '0.Pre-Discovery' ||test.isrunningtest())markReviewFlagcp1();
            /*if(opp.AM_CP2__c == true && opp.FAE_CP2__c == true && opp.PLM_CP2__c == true && opp.MarketSegment_CP2__c == true){
                opp.Finance_Check_CP3__c = true;
            }*/
            //update opp;
            Database.SaveResult SR = Database.update(opp);
            isedit=false;
            if(opp.AM_CP1__c || opp.FAE_CP1__c || opp.AM_CP2__c || opp.FAE_CP2__c ||opp.PLM_CP2__c
             ||opp.MarketSegment_CP2__c || opp.AM_CP3__c || opp.FAE_CP3__c ||opp.PLM_CP3__c
              ||opp.MarketSegment_CP3__c||opp.Finance_Check_CP3__c ){
                 
               // refreshPage=true;
             }  
            listofOptyrec = [select id,Product_Line__c, Business_Unit__c, CloseDate, AccountId, Name, StageName, Market_Segment__c, Process_Geometry__c, Process_Family__c, Target_Process_Node__c, Obstacles__c, Opportunity_Obstacles__c, Production_Confidence__c, Opportunity_Sourcing_Type__c, Fab_Split__c, Fab_Assignment_1__c, Process_Platform__c, Approved_GMPL_BX009_DW__c, GF_Target_Share__c, X1st_Product_TO_Date__c, X1st_Product_Production_Date__c, Years_of_Production__c, Describe_Product_Development_Plan__c, Is_GF_Committed_to_Process__c, Customer_Decision_Maker__c, Paste_Commitment_Text_from_Customer__c, Informal_Quote__c, Does_entered_ASP_Align_with_Quote__c, Quote__c,Account.Recordtype.Name,AM_CP1__c,FAE_CP1__c,PLM_CP1__c,MarketSegment_CP1__c,AM_CP2__c,FAE_CP2__c,PLM_CP2__c,MarketSegment_CP2__c,Finance_Check_CP2__c,AM_CP3__c,FAE_CP3__c,PLM_CP3__c,MarketSegment_CP3__c,Finance_Check_CP3__c from opportunity where id =: opp.id];
            OpportunitySendMailClass opty = new OpportunitySendMailClass();
            opty.opportunitychecklistmember(listofOptyrec);
            system.debug('Opp for mail: ' +listofOptyrec);

        }catch (Exception e) {
            GlobalUtility.logMessage('Error','OpportunityControlPoint_Ctrl','save','','Exception while creating/updating Opportunity record',String.valueof(e.getMessage()),'','Opportunity Management',e,0);
            }
        
       return null;
    }
   
    private pagereference markReviewFlagcp1(){
        //message='';
        if(opp.AM_CP1__c || opp.FAE_CP1__c ||test.isrunningtest()){
            boolean checkflag=false;
            for(Schema.FieldSetMember fld :SObjectType.opportunity.FieldSets.ARCControlPOint1.getFields()) {
                /*if(opp.get(fld.getFieldPath())==null){
                    checkflag=true;
                    //message+='Please enter value for '+fld.label+'\n';
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Please enter value for '+fld.label);
                    ApexPages.addMessage(myMsg); 
                }*/
                
                if(fld.getFieldPath() != 'Approved_GMPL_BX009_DW__c'){
                    if(opp.get(fld.getFieldPath())==null){
                        checkflag=true;
                        //message+='Please enter value for '+fld.label+'\n';
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Please enter value for '+fld.label);
                        ApexPages.addMessage(myMsg); 
                    }
                }
                else{
                    if(opp.Process_Platform__c != 'GF Baseline plus custom modules' && opp.Process_Platform__c != 'GF Baseline'){
                        if(opp.get(fld.getFieldPath())==null){
                            checkflag=true;
                            //message+='Please enter value for '+fld.label+'\n';
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Please enter value for '+fld.label);
                            ApexPages.addMessage(myMsg); 
                        }
                    }
                    
                }
            }
            /*if(checkflag){
                opp.AM_CP1__c=false;
                opp.FAE_CP1__c=false;
               
                update opp;
                
                return null;
            }else{*/
                //update opp;
                isedit=false;
                //message+=settings.Message__c;
                //return null;
            //}
              
        }
        return null;
    }
    
    private pagereference markReviewFlagcp2(){
        //message='';
        if(opp.AM_CP2__c || opp.FAE_CP2__c ||opp.PLM_CP2__c ||opp.MarketSegment_CP2__c ||test.isrunningtest()){
            system.debug('opp.Quote__c-->'+opp.Quote__c);
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
                    //message+='Please enter value for '+fld.label+'\n';
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
                return null;
            }else{
                //update opp;
                isedit=false;
                //message+=settings.Message__c;
                
                if(opp.AM_CP2__c && opp.FAE_CP2__c && opp.PLM_CP2__c && opp.MarketSegment_CP2__c){
                    showCP3 = true;
                }else{
                    showCP3 = false;
                }
                
                return null;
            }
        }
        return null;
    }
    
    public void checkControlpoint1(){
       // opportunity opp = new opportunity(PicklistOldValue__c = false);
        opp.PicklistOldValue__c = false;
        update opp;
         refreshPage=true;
            }
    
    private pagereference markReviewFlagcp3(){
        //message='';
        if(opp.AM_CP3__c || opp.FAE_CP3__c ||opp.PLM_CP3__c ||opp.MarketSegment_CP3__c||opp.Finance_Check_CP3__c||test.isrunningtest()){
            boolean checkflag=false;
            boolean checkPLMFlag = false;
            system.debug('opp.Informal_Quote__c-->'+opp.Informal_Quote__c);
            system.debug('opp.Quote__c-->'+opp.Quote__c);
            system.debug('opp.Option__c -->'+opp.Option__c);
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
                    GlobalUtility.logMessage('Error','OpportunityControlPoint_Ctrl','markReviewFlagcp3','','Exception while creating/updating Opportunity record',String.valueof(e.getMessage()),'','Opportunity Management',e,0);
                 }
                return null;
            }else{
                
                 //update opp;
                
                isedit=false;
                //message+= settings.Message__c;
                 return null;
            }
             
        }
        return null;
    }
    
}