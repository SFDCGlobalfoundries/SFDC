/**
* Author: GF
* Project: Test Class Automation  
* Description: This data factory class will be used to create Device data in different Test classes
**/

@isTest
public class DeviceDataFactory
{
    /* Method to create Device Test Data record Dynamically*/
    public static List<Device__c> createDevices(List<Map<String,Object>> fieldValueMaps,Integer numDevices)    
    {
        // Validate parameters
        if (fieldValueMaps != null && fieldValueMaps.size() != numDevices)
        {
            throw new DataFactoryException ('FieldValueMap Size must be equal to number of Devices you want to create.');
        }
        
        List<Device__c> deviceList = new List<Device__c>();
        
        for(Integer i=0;i<numDevices;i++)                    
        {
            Device__c device = new Device__c(Name = 'TESTDEVICEZAIH12345677'+i,
                                Fab__c = 'FAB 2',
                                GSOP_Assignment_Tapeout_Plan__c = 'No',
                                Market_Segment__c = 'Automotive',
                                Semiconductor_Device__c = 'Analog Amplifier',
                                End_Customer__c = 'Test Customer',
                                Stage__c = 'Design In',
                                Status__c = 'Active',
                                Siebel_Device_ID__c = '1234567890'+i,
                                Tapeout_Type__c = 'Customer MPW',
                                PLM_Device_ID__c = 'ANBQP60ACO8CH-U01',
                                Device_Mask_Set_Title__c = 'TA330',
                                Confidence_Level_Tapeout__c = '100',
                                Original_Forecasted_Tapeout_Date__c = date.today().addDays(7),
                                CRMDID__c = 'CDID0000001.00',
                                Device_Type__c = 'Base',
                                reticle_type__c = 'Small Field Reticle (SFR)',
                                End_Application__c = 'Body'
                                );
            
            if (fieldValueMaps != null)
            {      
                Map<String,Object> fieldValueMap = fieldValueMaps.get(i);
                for(String fieldName: fieldValueMap.keySet())
                {
                    device.put(fieldName, fieldValueMap.get(fieldName));        
                }
            }
            deviceList.add(device);    
        }
        
        insert deviceList;
        
        return deviceList;
    }
          
    /* Method to create one Device Test Data record Dynamically*/
    public static Device__c createDevice(Map<String,Object> fieldValueMap)
    {
        // Create Device with default data that is required, this will handle cases where required fields are not set
        Device__c device = new Device__c(Name = 'TESTDEVICEZAIH12345677',
                                Fab__c = 'FAB 2',
                                GSOP_Assignment_Tapeout_Plan__c = 'No',
                                Market_Segment__c = 'Automotive',
                                Semiconductor_Device__c = 'Analog Amplifier',
                                End_Customer__c = 'Test Customer',
                                Stage__c = 'Design In',
                                Status__c = 'Active',
                                Siebel_Device_ID__c = '1234567890',
                                Tapeout_Type__c = 'Customer MPW',
                                PLM_Device_ID__c = 'ANBQP60ACO8CH-U01',
                                Device_Mask_Set_Title__c = 'TA330',
                                Confidence_Level_Tapeout__c = '100',
                                Original_Forecasted_Tapeout_Date__c = date.today().addDays(7),
                                CRMDID__c = 'CDID0000001.00',
                                Device_Type__c = 'Base',
                                reticle_type__c = 'Small Field Reticle (SFR)',
                                End_Application__c = 'Body'
                                );       
              
        for(String fieldName: fieldValueMap.keySet())
        {
            device.put(fieldName, fieldValueMap.get(fieldName));        
        }

        insert device;
            
        return device;
    }   
}