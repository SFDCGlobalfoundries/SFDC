/**
 *  Class:      ConfigPlusHeaderComponentCntrlTest
 *----------------------------------------------------------------------------------------------------------------------------------- 
 * Author:      Prosenjit Saha
 * Description: This Controller class for ConfigPlusHeaderComponent
 *
 *
 * History:
 *              PSaha          09212015     - code creation.
                Ravi Teja.B    21072017     - Approval Stage of Config is included two more values for Process Flow Accepted
 */

public class ConfigPlusHeaderComponentCntrl {

    public String configID {get; set;}   
        
    private Apttus_Proposal__Proposal__c config;
    
    public String ConfigPlusStep {
        get {                                    
            if(config != null ){                               
                if(config.Process_Technology_Lookup__c != null || config.Process_Technology__c != null || config.Process_Technology_Name_Edit__c != null){                    
                    return 'progtrckr-done';
                } else {
                    return 'progtrckr-active';
                }
            } else{
                return 'progtrckr-active';
            }        
        }
        set;
    }
    
    public String ConfigPlusAdditionalStep {
        get {                                    
            if(config.Process_Technology_Lookup__c != null || config.Process_Technology__c != null || config.Process_Technology_Name_Edit__c != null){                               
                if(config.Apttus_Proposal__Approval_Stage__c != null && (config.Apttus_Proposal__Approval_Stage__c == 'Draft' || config.Apttus_Proposal__Approval_Stage__c == 'Generated') ){                    
                    return 'progtrckr-active';
                } else {
                    return 'progtrckr-done';
                }
            }else{
                return 'progtrckr-todo';
            }        
        }
        set;
    }
    
    
    public String ConfigPlusApprovalStep {
        get {                                    
            if((config.Process_Technology_Lookup__c != null || config.Process_Technology__c != null || config.Process_Technology_Name_Edit__c != null)
                && config.Apttus_Proposal__Approval_Stage__c != null && (config.Apttus_Proposal__Approval_Stage__c != 'Draft' && config.Apttus_Proposal__Approval_Stage__c != 'Generated')){                               
                if(!config.Apttus_Proposal__Approval_Stage__c.contains('Process Flow Accepted')) { //Modified By Ravi Teja.B 21072017                   
                    return 'progtrckr-active';
                } else {
                    return 'progtrckr-done';
                }
            }else{
                return 'progtrckr-todo';
            }        
        }
        set;
    }
    
    public String ConfigPlusApproved {
        get {                                    
            if((config.Process_Technology_Lookup__c != null || config.Process_Technology__c != null || config.Process_Technology_Name_Edit__c != null)
                && config.Apttus_Proposal__Approval_Stage__c != null && (config.Apttus_Proposal__Approval_Stage__c != 'Draft' && config.Apttus_Proposal__Approval_Stage__c != 'Generated' && config.Apttus_Proposal__Approval_Stage__c.contains('Process Flow Accepted'))){//Modified By Ravi Teja.B 21072017                               
                return 'progtrckr-done';
                
            }else{
                return 'progtrckr-todo';
            }        
        }
        set;
    }
    
    public ConfigPlusHeaderComponentCntrl (){  
        this.config = new Apttus_Proposal__Proposal__c();
        
        for(Apttus_Proposal__Proposal__c rec: [SELECT product_name__c
                                                      , product_revision__c
                                                      , Process_Technology__c
                                                      , Process_Technology_Lookup__c
                                                      , Apttus_Proposal__Approval_Stage__c
                                                      , Process_Technology_Name_Edit__c
                                                 FROM Apttus_Proposal__Proposal__c
                                                 WHERE id = :ApexPages.currentPage().getParameters().get('id')]){
            this.config = rec; 
        }                                           
    }  
    
    public PageReference back(){
        PageReference pageRef = new PageReference('/'+configId );
        pageRef.setRedirect(true);
        return pageRef;
    }                      
}