/*
    Author: Zymark Ambat
    Description: This serves as the contoller class for VF Component for the Resubmission_of_Export_Control_VF 
                 VF Email Template.
    History: 
        ZAmbat      06052013    - Code creation.
        ARoy        10032013    - modified code for device link in sfdc instance and customer portal instance. 
         Prashant  10042016    -Modified Code to add Customer Name & Region(Case # 00054230).               
*/

public class ApprovalProcessCommentsController {
    
    public Id paramId {get;set;}
    public List<DeviceWrapper> listDevices {get;set;}
    private String approvalComment {get;set;}
    public static String sfdcInstance = EnvironmentVariable.get('SFDC_INSTANCE');
    public static String sfdcCustomerPortal = EnvironmentVariable.get('SFDC_CUSTOMER_PORTAL');
    
    public ApprovalProcessCommentsController() {}
    
    public String getComments() {
        try {
            if (this.paramId != null) {
                // Get the latest action from Approval Process
                List<ProcessInstance> listProcessInstance = [
                    SELECT      Id
                                , (SELECT Comments FROM Steps WHERE StepStatus != 'NoResponse' AND Comments != null ORDER BY CreatedDate DESC)
                    FROM        ProcessInstance
                    WHERE       TargetObjectId = :this.paramId
                                AND Status IN ('Rejected', 'Recalled')
                    ORDER BY    LastModifiedDate DESC
                    LIMIT 1
                ];
                
                // Set message
                this.approvalComment = Environment_Variable__c.getInstance('NO_COMMENTS_FOUND').Value__c;
                
                // Check if there are comments made on the Approval Process
                if (listProcessInstance.size() > 0) {
                    if (listProcessInstance[0].Steps.size() > 0) {
                        this.approvalComment = listProcessInstance[0].Steps[0].Comments;
                    }
                }
                
                this.listDevices = new List<DeviceWrapper>();
                for (Device_Export_Control_Junction__c j : [SELECT      Device__c
                                                                        ,Device__r.Name
                                                                        ,Export_Control_Form__c
                                                                        ,Export_Control_Form__r.Account__r.name
                                                                        ,Export_Control_Form__r.Account__r.Region__c
                                                            FROM        Device_Export_Control_Junction__c
                                                            WHERE       Export_Control_Form__c = :this.paramId]) {
                    DeviceWrapper dw = new DeviceWrapper();
                    dw.deviceName = j.Device__r.Name;
                    dw.deviceLink = sfdcInstance + '/' + j.Device__c;
                    dw.deviceLinkForCustomerPortal = sfdcCustomerPortal + '/' + j.Device__c;
                    dw.Accountregion=j.Export_Control_Form__r.Account__r.Region__c;
                    dw.Accountname=j.Export_Control_Form__r.Account__r.name;
                    this.listDevices.add(dw);
                }
            } else {
                Error_Codes__c ecc = Error_Codes__c.getInstance('NO_ID_FOUND');
                this.approvalComment = ecc.Message__c;
            }
            
            return this.approvalComment;
        } Catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
    
    public class DeviceWrapper {
        public String deviceName {get;set;}
        public String deviceLink {get;set;}
        public String deviceLinkForCustomerPortal {get;set;}
         public String Accountregion{get;set;}
        public String Accountname{get;set;}
    }
}