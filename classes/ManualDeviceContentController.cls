/**
* @author       :   Bhupesh Mukhija
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Functionality to generate PDF and Excel Document
* History       :

Initials        Date                        Description
BMukhija        08/07/2013                  Created class
ASinghal        13/08/2013                  Added logic for generating CE Raw Files
**/
public class ManualDeviceContentController {
    // CLASS MEMBER MANUAL DEVICE LISTS DECLERATIONS
    public List<Manual_Device__c> protoRiskList {get; set;}
    public List<Manual_Device__c> productionList {get; set;}
    public List<Manual_Device__c> tapeoutList {get; set;}
    public List<Manual_Device__c> productionrawlist {get;set;}
    public List<Manual_Device__c> protorawrisklist {get;set;}
    public List<Manual_Device__c> tapeoutrawlist {get;set;}
    public String location;

    public ManualDeviceContentController(ApexPages.StandardController controller) {
        // CLASS MEMBER MANUAL DEVICE LISTS DECLERATIONS INITIALIZATION
        protoRiskList = new List<Manual_Device__c>();
        productionList = new List<Manual_Device__c>();
        tapeoutList = new List<Manual_Device__c>(); 
        protorawRiskList= new List<Manual_Device__c>();
        productionrawList= new List<Manual_Device__c>();
        tapeoutrawlist = new List<Manual_Device__c>();
        location = 'Fab__c';
    }

    /***********************************************************
    * Name              : manualDeviceTapeoutToExcel
    * Description       : method for collecting all ready to  
    *                     export tapeout type devices
    * Input Parameters  : None
    * Return            : void
    ************************************************************/    
    public void manualDeviceTapeoutToExcel() {
            // QUERY FOR ALL DEVICES TAPEOUT SHEET DEVICES AND READY TO EXPORT  
            tapeoutList = [ SELECT Account_Name__c
                                 , Region__c
                                 , Process_Family__c
                                 , Geometry__c
                                 , Technology__c
                                 , Device_Id__c
                                 , Fab__c
                                 , Attn_To__c
                                 , Project_Update__c
                                 , Proto_Functional_Status__c
                                 , Yield__c
                                 , ET_Met_Target__c
                                 , Prime_Die__c
                                 , Forecast_GDSII_In__c
                                 , Forecast_1st_3_reticle_Lot_Start__c
                                 , Device__r.Actual_Tapeout_Date_GMT__c
                            FROM Manual_Device__c
                            WHERE IsActive__c = true
                                AND Status__c = :Label.GF_CE_Tapeout
                                AND Export__c = true
                                AND Publish_Report__c = :Label.GF_CE_Yes ];
           // QUERY FOR ALL DEVICES TAPEOUT SHEET DEVICES  
            tapeoutrawList = [ SELECT Account_Name__c
                                 , Region__c
                                 , Process_Family__c
                                 , Geometry__c
                                 , Technology__c
                                 , Device_Id__c
                                 , Fab__c
                                 , Attn_To__c
                                 , Project_Update__c
                                 , Proto_Functional_Status__c
                                 , Yield__c
                                 , ET_Met_Target__c
                                 , Prime_Die__c
                                 , Forecast_GDSII_In__c
                                 , Forecast_1st_3_reticle_Lot_Start__c
                                 , Device__r.Actual_Tapeout_Date_GMT__c
                            FROM Manual_Device__c
                            WHERE IsActive__c = true
                                AND Status__c = :Label.GF_CE_Tapeout
                                AND Publish_Report__c = :Label.GF_CE_Yes ]; 
                                
            ManualDeviceHelper.sortList(tapeoutList, location  , 'asc');
            ManualDeviceHelper.sortList(tapeoutrawList, location  , 'asc');
            
    }

    /***********************************************************
    * Name              : manualDeviceProdToPdf
    * Description       : method for collecting all ready to  
    *                     export Production type devices
    * Input Parameters  : None
    * Return            : void
    ************************************************************/    
    public void manualDeviceProdToPdf() {
            // QUERY FOR ALL DEVICES PRODUCTION SHEET DEVICES AND READY TO EXPORT
            productionList = [ SELECT Account_Name__c
                                   , Region__c
                                   , Geometry__c
                                   , Technology__c
                                   , Device_Id__c
                                   , Fab__c
                                   , Attn_To__c
                                   , Project_Update__c
                               FROM Manual_Device__c
                               WHERE IsActive__c = true
                                  AND Status__c = :Label.GF_CE_Production
                                  AND Export__c = true
                                  AND Publish_Report__c = :Label.GF_CE_Yes
                                  ORDER BY Fab__c, Account_Name__c ASC ];
           
           // QUERY FOR ALL DEVICES PRODUCTION SHEET DEVICES 
            productionrawList = [ SELECT Account_Name__c
                                   , Region__c
                                   , Geometry__c
                                   , Technology__c
                                   , Device_Id__c
                                   , Fab__c
                                   , Attn_To__c
                                   , Project_Update__c
                               FROM Manual_Device__c
                               WHERE IsActive__c = true
                                  AND Status__c = :Label.GF_CE_Production
                                  AND Publish_Report__c = :Label.GF_CE_Yes
                                  ORDER BY Fab__c, Account_Name__c ASC ];  
           }
           

    /***********************************************************
    * Name              : manualDeviceProtoToPdf
    * Description       : method for collecting all ready to  
    *                     export ProtoRisk Production type devices
    * Input Parameters  : None
    * Return            : void
    ************************************************************/        
    public void manualDeviceProtoToPdf() {
            // QUERY FOR ALL DEVICES PROTO SHEET DEVICES AND READY TO EXPORT
            protoRiskList = [ SELECT Account_Name__c
                                   , Region__c
                                   , Geometry__c
                                   , Technology__c
                                   , Device_Id__c
                                   , Fab__c
                                   , Attn_To__c
                                   , Project_Update__c
                                   , Proto_Functional_Status__c
                                   , Yield__c
                                   , ET_Met_Target__c
                                   , Prime_Die__c
                              FROM Manual_Device__c
                              WHERE IsActive__c = true
                                  AND Status__c = :Label.GF_CE_Proto_Risk_Production
                                  AND Export__c = true
                                  AND Publish_Report__c = :Label.GF_CE_Yes
                                  ORDER BY Fab__c, Account_Name__c ASC  ];
             // QUERY FOR ALL DEVICES PROTO SHEET DEVICES 
            protorawRiskList = [ SELECT Account_Name__c
                                   , Region__c
                                   , Geometry__c
                                   , Technology__c
                                   , Device_Id__c
                                   , Fab__c
                                   , Attn_To__c
                                   , Project_Update__c
                                   , Proto_Functional_Status__c
                                   , Yield__c
                                   , ET_Met_Target__c
                                   , Prime_Die__c
                              FROM Manual_Device__c
                              WHERE IsActive__c = true
                                  AND Status__c = :Label.GF_CE_Proto_Risk_Production
                                  AND Publish_Report__c = :Label.GF_CE_Yes
                                  ORDER BY Fab__c, Account_Name__c ASC  ];                     
             

            //ManualDeviceHelper.sortList(protoRiskList, location , 'asc');
    }
}