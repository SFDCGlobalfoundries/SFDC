/**********************************************************************************************************************************
Class:         ViewFreeDevicesController
-----------------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  22/10/2013
Reason:        Controls the ViewFreeDevices Visualforce page to show the free devices of the proposal
***********************************************************************************************************************************/

public with sharing class ViewFreeDevicesController {

    //Current Proposal
    public Apttus_Proposal__Proposal__c CurrentProposal { get; set; }
    
    //The free devices (Products of family="Devices")
    public List<Product2> LstFreeDevices { get; set; }
    
    //Delimiter
    final String szDelimiter = '<:>';
    //Constructor (Extension)
    public ViewFreeDevicesController(ApexPages.StandardController controller){
        CurrentProposal = [Select Id,
                                  Name,
                                  Free_Devices__c,
                                  Mask_Set_Long__c
                                  //Mask_Set__c
                                  //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
                             From Apttus_Proposal__Proposal__c
                            Where Id =: ApexPages.currentPage().getParameters().get('Id')];
        
        System.Debug('[DEBUG :: JOYDEV] >> CurrentProposal: ' + CurrentProposal);
        
        //Query strings generated from field sets
        String szFreeDevicesQuery = 'Select ';
        
        for(Schema.FieldSetMember f : SObjectType.Product2.FieldSets.Free_Devices_Columns.getFields()) {
            szFreeDevicesQuery += f.getFieldPath() + ', ';
        }
        
        //Generate the Device Id tokens from Free Devices field of the current proposal
        String szDeviceIdTokens = '(';
        
        if(CurrentProposal.Free_Devices__c != null){
            for(String szDeviceId : CurrentProposal.Free_Devices__c.split(szDelimiter)){
                szDeviceIdTokens += '\'' + szDeviceId + '\',';                                 
            }
        }
        
        szDeviceIdTokens = (szDeviceIdTokens != '(' ? szDeviceIdTokens.substring(0, szDeviceIdTokens.length() - 1) + ')' : '');
        
        szFreeDevicesQuery += 'Id FROM Product2 Where ProductCode IN ' + (szDeviceIdTokens != '' ? szDeviceIdTokens : '(\'\')');
        
        System.Debug('[DEBUG :: JOYDEV] >> szFreeDevicesQuery: ' + szFreeDevicesQuery);
        
        LstFreeDevices = Database.query(szFreeDevicesQuery);
        
        System.Debug('[DEBUG :: JOYDEV] >> LstFreeDevices: ' + LstFreeDevices);
        
        LstFreeDevices = (LstFreeDevices.size() == 0 ? Null : LstFreeDevices);
    }
    
    
}