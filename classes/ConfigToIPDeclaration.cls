/**********************************************************************************************************************************
Class:         ConfigToIPDeclaration
-----------------------------------------------------------------------------------------------------------------------------------
Author:        Monalisa Mohapatra
Description: <Brief description of the apex class or trigger>
History:
Monalisa     05122014     - Code Creation
***********************************************************************************************************************************/

public class ConfigToIPDeclaration{
    
    public string devId {get;set;}
    public string acntId {get;set;}
    public boolean showExposedDevice {get;set;}
    public boolean showConfig {get;set;}
    public boolean showErrorMessage {get;set;}
    public boolean showIPForm {get;set;}
    public Apttus_Proposal__Proposal__c config {get;set;}
    public Device__c device {get;set;}
    public IP_Declaration_Form__c IpForm {get;set;}
    
    public ConfigToIPDeclaration() {    
        this.config = new Apttus_Proposal__Proposal__c();
        this.config = [SELECT Id
                        , Apttus_Proposal__Account__c
                        , Apttus_Proposal__Opportunity__c
                        , Apttus_Proposal__Proposal_Name__c
                        , Device__c
                        , Name
                        , APTPS_Primary__c   
                        , Apttus_Proposal__Approval_Stage__c
                            
                        FROM        Apttus_Proposal__Proposal__c
                        WHERE       Id = :ApexPages.currentPage().getParameters().get('proposalId')
                        LIMIT 1
                    ];
        
        showConfig = true;
        devId = this.config.Device__c;
        
        if(devId!= null){
            retriveDevice();
        }else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please associate a device to get IP declaration from customer.'));
                    this.showErrorMessage = true;
                showExposedDevice = true;
                showIPForm = false;
        }
    }
    
    public void retriveDevice(){
        try{
            //Retrieving Device detail
            this.device = new Device__c();
            this.device = [SELECT   Id
                                , Name
                                , CRMDID__c
                                , Account__c
                                , Requested_from_Configuration__c
                                , Expose_Device_to_Customer__c
                                , IP_Declaration_Form_Count__c
                                
                                FROM     Device__c
                                WHERE    Id =: devId
                        ];
            if(this.device != null){
                showExposedDevice = true;
                showErrorMessage =false;
                    if(!this.device.Requested_from_Configuration__c){
                        this.device.Requested_from_Configuration__c = true; 
                    }
                // Retrieving IP Declaration Form 
                
                if(this.device.Expose_Device_to_Customer__c && this.device.IP_Declaration_Form_Count__c==1){
                    this.IpForm = new IP_Declaration_Form__c();
                    this.IpForm = [SELECT   Id
                                            , Name
                                            , Fab__c
                                            , IP_Status__c
                                            , Customer_Name__c
                                            , Device__c
                                            , Configuration__c
                                            FROM     IP_Declaration_Form__c
                                            WHERE    Device__c =: devId];
                    showIPForm = true;              
                }else{
                	if(config.Apttus_Proposal__Approval_Stage__c == 'Draft'){
                		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please submit/approve the configuration to create IP declaration form for customer.'));
                		showExposedDevice = FALSE; 
                	}
                	else{
                    	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please expose device to create IP declaration form for customer.'));
                	}
                    this.showErrorMessage = true;
                    showIPForm = false;
                }   
            }
            //update this.device;
        }catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            this.showErrorMessage = true;
        }   
    }
    public PageReference cancel() {
        PageReference pageRef = new PageReference('/' + this.config.Id);
        return pageRef;
    }
    
    /*
    @Method Name:    exposeDeviceToCustomer
    @Return Type:    PageReference 
    @parameter:      NA
    @Reason:         Calling exsisting Expose Device functionality
    @Author:         Prosenjit Saha
    @Created Date:   12092014
    @Change History: ..
                     ..
    */
    public PageReference exposeDeviceToCustomer (){
        update this.device;
        return (new pagereference('/apex/DeviceExposeToCustomerVF?deviceId='+this.device.id));
    }
}