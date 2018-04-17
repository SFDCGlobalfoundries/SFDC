/*
    Author: Anirban Roy
    Description: This is for the email to be sent on approval of Export Control Form.
    History: 
        ARoy    09172013    - Code creation.
        ARoy    10032013    - modified code for device link in sfdc instance and customer portal instance.
        Prashant  10042016    -Modified Code to add Customer Name & Region(Case # 00054230)
*/

public class ExportControlApprovalController {
  
  public Id paramId {get;set;}
  private List<DeviceWrapper> listDevices {get;set;}
  public static String sfdcInstance = EnvironmentVariable.get('SFDC_INSTANCE');
  public static String sfdcCustomerPortal = EnvironmentVariable.get('SFDC_CUSTOMER_PORTAL');
  
  public ExportControlApprovalController(){}
  
  public List<DeviceWrapper> getListDevices(){
    
    this.listDevices = new List<DeviceWrapper>();
    for (Device_Export_Control_Junction__c j : [SELECT    Device__c
                                , Device__r.Name
                                ,Fab__c
                                ,Export_Control_Form__c
                                ,Export_Control_Form__r.Account__r.name
                                ,Export_Control_Form__r.Account__r.Region__c
                          FROM    Device_Export_Control_Junction__c
                          WHERE    Export_Control_Form__c = :this.paramId]) {
      DeviceWrapper dw = new DeviceWrapper();
      dw.deviceName = j.Device__r.Name;
      dw.deviceLink = sfdcInstance + '/' + j.Device__c;
      dw.deviceLinkForCustomerPortal = sfdcCustomerPortal + '/' + j.Device__c;
      dw.Accountregion=j.Export_Control_Form__r.Account__r.Region__c;
      dw.Accountname=j.Export_Control_Form__r.Account__r.name;
      dw.fabname=j.Fab__c;
      this.listDevices.add(dw);
    }
  
    return this.listDevices;
  }
  
  public class DeviceWrapper {
    public String deviceName {get;set;}
    public String deviceLink {get;set;}
    public String deviceLinkForCustomerPortal {get;set;}
    public String Accountregion{get;set;}
    public String Accountname{get;set;}
    public String fabname{get;set;}
  }
}