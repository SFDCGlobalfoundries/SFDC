/*    
Author: Bhupesh Mukhija 
Description: Constant Class for Manual Device.

History:
Bhupesh Mukhija     31052013     -      Class Creted.

*/
public class ManualDeviceConstants {
    
    // DEVICE STAGE CONSTANTS
    public static final String DEVICE_STAGE_DESIGN_IN = CS_Device_Stage__c.getInstance('DEVICE_STAGE_DESIGN_IN').Value__c;
    public static final String DEVICE_STAGE_EOL = CS_Device_Stage__c.getInstance('DEVICE_STAGE_EOL').Value__c;
    public static final String DEVICE_STAGE_PRODUCTION = CS_Device_Stage__c.getInstance('DEVICE_STAGE_PRODUCTION').Value__c;
    public static final String DEVICE_STAGE_PROTOTYPE = CS_Device_Stage__c.getInstance('DEVICE_STAGE_PROTOTYPE').Value__c;
    public static final String DEVICE_STAGE_RTR = CS_Device_Stage__c.getInstance('DEVICE_STAGE_RTR').Value__c;
    public static final String DEVICE_STAGE_SOLUTIONING = CS_Device_Stage__c.getInstance('DEVICE_STAGE_SOLUTIONING').Value__c;
    public static final String DEVICE_STAGE_TAPEOUT = CS_Device_Stage__c.getInstance('DEVICE_STAGE_TAPEOUT').Value__c;
    
    // PICKLIST VALUES CONSTANTS
    public static final String PV_YES   = CS_Manual_Device__c.getInstance('MANUAL_DEVICE_PV_YES').Value__c;
    public static final String PV_NO    = CS_Manual_Device__c.getInstance('MANUAL_DEVICE_PV_NO').Value__c;
        public static final String MDEVICE_ID_MULTIPLE = 'MULTIPLE';
    
    // MANUAL DEVICE STATUS CONSTANTS
    public static final String MDEVICE_PRODUCTION = CS_Manual_Device__c.getInstance('MANUAL_DEVICE_PRODUCTION').Value__c;
    public static final String MDEVICE_PROTO_RISK_PROD  = CS_Manual_Device__c.getInstance('MANUAL_DEVICE_PROTO_RISK_PROD').Value__c;
    public static final String MDEVICE_TAPEOUT  = CS_Manual_Device__c.getInstance('MANUAL_DEVICE_TAPEOUT').Value__c;
    public static final String MDEVICE_RETROFIT  = CS_Manual_Device__c.getInstance('MANUAL_DEVICE_RETROFIT').Value__c;
    
    // MANUAL DEVICE ERROR MESSAGES
    public static final String MDEVICE_RETROFIT_ERROR = CS_Manual_Device__c.getInstance('MANUAL_DEVICE_RETROFIT_ERROR').Value__c;
    public static final String MDEVICE_TEAM_ROOM_PUBLISH_ERROR = CS_Manual_Device__c.getInstance('MANUAL_DEVICE_TEAM_ROOM_PUBLISH_ERROR').Value__c;
    public static final String MDEVICE_TEAM_ROOM_PUBLISH_INFO = CS_Manual_Device__c.getInstance('MANUAL_DEVICE_TEAM_ROOM_PUBLISH_INFO').Value__c;
    public static final String MDEVICE_DUPLICATE_DEVICE_ERROR = CS_Manual_Device__c.getInstance('MANUAL_DEVICE_DUPLICATE_DEVICE_ERROR').Value__c;
    public static final String MDEVICE_INVALID_ACCOUNT_ERROR = CS_Manual_Device__c.getInstance('MANUAL_DEVICE_ACCOUNT_ERROR').Value__c;
    public static final String MDEVICE_NO_RESULTS = 'No records found for Selected Criteria';
    public static final String MDEVICE_REPORT_FOLDER = CS_Manual_Device__c.getInstance('MDEVICE_REPORT_FOLDER').Value__c;
    public static final String MDEVICE_OWNER_USER_FID = CS_Manual_Device__c.getInstance('MANUAL_DEVICE_OWNER_USER_FID').Value__c;
}