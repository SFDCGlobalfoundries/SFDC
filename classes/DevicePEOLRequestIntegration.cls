/*
    Author: Ariz Solito
    Description: Integration for Device PEOL Request to ERP
    History: 
    Asolito      07/07/2015    - Apex code created       
*/
public class DevicePEOLRequestIntegration {

    //Method will do callout to ERP
    @future(callout=true)
    public static void doCallout(List<String> requestIDs){
        DevicePEOLSyncService.DevicePEOLSyncService_pt sync;
        DevicePEOLSyncService.DeviceDetailsType devices;
        
        List<Device_PEOL_Request__c> requests = [SELECT id,customer__r.customer_number__c,erp_status_message__c,
                                                       (SELECT erp_device__r.name,fab__c,last_time_buy_date__c,
                                                               last_time_ship_date__c,erp_status_message__c
                                                          FROM Device_PEOL_Request_Details__r)
                                                   FROM Device_PEOL_Request__c 
                                                   WHERE id IN :requestIDs];
                                                   
        //Instantiate the device PEOL request service methods
        List<Device_PEOL_Request_Detail__c> requestDetails = new List<Device_PEOL_Request_Detail__c>();
        for(Device_PEOL_Request__c d: requests){            
            devices = new DevicePEOLSyncService.DeviceDetailsType();
            devices.DeviceDetail = new List<DevicePEOLSyncService.DeviceDetailType>();
            
            //add the devices
            for(Device_PEOL_Request_Detail__c r: d.Device_PEOL_Request_Details__r){
                DevicePEOLSyncService.DeviceDetailType detail = new DevicePEOLSyncService.DeviceDetailType();
                    detail.id = r.id; detail.device = r.erp_device__r.name; detail.fab = r.fab__c.deleteWhiteSpace();
                    detail.lastTimeBuyDate = r.last_time_buy_date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''); 
                    detail.lastTimeShipDate = r.last_time_ship_date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');                    
                    devices.DeviceDetail.add(detail);
            } 
            
            //do callout
            sync = new DevicePEOLSyncService.DevicePEOLSyncService_pt();            
            try {
                String result = sync.DevicePEOLSyncRequest(d.id, d.customer__r.customer_number__c,devices);
                
                //success response from AIA
                if(result == 'OK'){
                    d.erp_status_message__c = 'Waiting for ERP Response'; d.erp_status_message_error__c = '';
                    
                    for(Device_PEOL_Request_Detail__c r: d.Device_PEOL_Request_Details__r){
                        r.erp_status_message__c = 'Waiting for ERP Response'; r.erp_status_message_error__c = '';
                        requestDetails.add(r);
                    } 
                //failed response from AIA                                       
                } else {
                    d.erp_status_message__c = 'ERROR';
                    d.erp_status_message_error__c = 'Failed response from AIA';
                    
                    for(Device_PEOL_Request_Detail__c r: d.Device_PEOL_Request_Details__r){
                        r.erp_status_message__c = 'ERROR';
                        r.erp_status_message_error__c = 'failed response from AIA';
                        requestDetails.add(r);
                    } 
                }
            } catch (Exception e){
                //can't connect to AIA            
                d.erp_status_message__c = 'ERROR';  d.erp_status_message_error__c = e.getMessage().left(254);
                for(Device_PEOL_Request_Detail__c r: d.Device_PEOL_Request_Details__r){
                    r.erp_status_message__c = 'ERROR';  r.erp_status_message_error__c = e.getMessage().left(254);
                    requestDetails.add(r);
                }
            }                        
        }
        //update the erp status message for the form and device details
        try {
            update requests;
            update requestDetails;
            
        } catch (Exception e){
            DevicePEOLRequestIntegration.sendMail('AT CODE LINE : '+ e.getLineNumber() + ' MESSAGE'+ e.getMessage());
        }                                                                                           
    }

    /**     
    *  method:         SendMail
    *  return type:    none
    *  purpose:        this method sends mail with error logs to the email ids passed on in argument 
    **/
    public static void sendMail(String message) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        mail.setSubject('DEVICE PEOL Request update Failed');  
        mail.setToAddresses(new List<String>{'dl.IT.Salesforce_Support@globalfoundries.com', UserInfo.getUserEmail()});
        mail.setSenderDisplayName('GLOBALFOUNDRIES: PEOL Request Application');
        mail.setPlainTextBody('PEOL Record Sent to ERP Failed with Message : \n' + message);
        if(!Test.isRunningTest()){  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); }
        
    }       
}