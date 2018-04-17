/*
Author: Bhavana Mohan
Company: Cognizant
Description: sfdc - .net Integration Webservice
History:
created     27/3/2014 
-----
Modified Date: 09/16/2014
Reason: Added DRT PTRF Uniqueness logic - Populated field DRT PTRF Unique Identifier
-----
Long Luu 15-Aug-2016
- Update PrimeDieData/ScribelineDropinsData attributes (Add in new fields).
- Add logic for Create/Update ptrf with new status add-in: GlobalShuttle Updates
-----
Author: Cognizant Technology Solutions    
*/

/****************************************************************************\
|*****************************************************************************| 
|**                       Summary 15-Aug-2016                               **|
|*****************************************************************************| 
|*****************************************************************************| 
|** SWGP-884: Integration for Reserved Prime Die Sizes(pre-shrink)          **|
|** in MPW Reservation from SFDC to SWIFT PTRF for comparison against       **|
|** Prime Die Sizes(post shrink) during PTRF creation.                      **|    
|*****************************************************************************|
|** DESCRIPTION                                                             **|
|** To pass in Reserved Prime Die Sizes(pre-shrink) in MPW Reservation      **|
|** from SFDC to SWIFT PTRF so as to be used for comparison upon Prime      **|
|** Die Size is calculated by the system after user has entered the         **|
|** rotation and shrink factor during PTRF creation.                        **|
|*****************************************************************************|
|** Pre-requisite to SWNG-6286 in .NET                                      **|
|** MPW Reservation to SWIFT PTRF via Oracle Database                       **|
|** + MPW Reservation system to push MPW, Mask Set Title, Account shortname,**| 
|** CRM DID, Prime Die Name, Size X & Y, etc to a oracle database for       **|
|** SWIFT PTRF to read                                                      **|
|*****************************************************************************|
|** .Net PTRF to SFDC PTRF via AIA                                          **|
|** + .Net PTRF to sync Window Coordinates, Rotation, Shrink To, Size X & Y,**|
|** etc to SFDC PTRF via AIA                                                **|
|** + .Net PTRF to add a new trigger point when PTRF reaches                **|
|** "GlobalShuttle Updates" status                                          **|
|** + SFDC PTRF to update the Chips and Mask Layers of PTRF,                **|
|** Order Status at "GlobalShuttle Updates" status                          **| 
|** (similar behavior as "Open" status)                                     **|
|** ----------------------------------------------------------------------- **|
|*****************************************************************************|   
\****************************************************************************/

global with sharing class PTRF_DotNetService {
    
    public static string recursivecall = 'YES';
    
    global class PTRFDataRecievedOnPerformTapeout {
        webservice string messageID;
        webservice PTRFData ptrf;
        webservice list < Jobviewer > jobviewers;
        webservice List < MaskLayerData > maskLayers;
        webservice list < PrimeDieData > primeDies;
        webservice list < ScribelineDropinsData > scribelineDropins;
        webservice string action;
        webservice datetime actionDateTime;
    }

    global class PTRFDataRecievedDiesLayersDeselected {
        webservice string messageID;
        webservice string ptrfNumber;
        webservice List < MaskLayerData > maskLayers;
        webservice list < PrimeDieData > primeDies;
        webservice list < ScribelineDropinsData > scribelineDropins;
        webservice string action;
    }

    global class PTRFDataRecievedOnJobviewDataChange {
        webservice string messageID;
        webservice string ptrfNumber;
        webservice string customerJobview;
        webservice string processOwnerJobview;
        webservice list < Jobviewer > jobviewers;
    }
    
    global class PTRFData {
        webservice string ptrfNumber;
        webservice string maskSetTitle;
        webservice string reticleType;
        webservice string primeDRT;
        webservice string frameDRT;
        webservice string techGeo;
        webservice string orderType;
        webservice boolean primeTapeout;
        webservice boolean primeGDSOUT_Review;
        webservice boolean frameTapeout;
        webservice boolean frameMockup;
        webservice boolean frameGDSOUT_Review;
        webservice boolean DRC_Only;
        webservice boolean bumpRequest;
        webservice string accountShortName;
        webservice string orderStatus;
        webservice string customerJobView;
        webservice string processOwnerJobview;
        webservice string CRMDID;
        webservice string deviceId;
        webservice date transactionDate;
        webservice string DRCoption;
        webservice string processid;
        webservice string Fab;
        webservice string Maskshop;
        webservice string MaskshopId;
        webservice string MaskTitleforROMcode;
    }

    global class Jobviewer {
        webservice string jobviewType;
        webservice boolean MEBES;
        webservice string userId;
        webservice string emailAddress;
        webservice boolean GDSOUT;
        webservice boolean frameMockup;
    }

    global class MaskLayerData {
        webservice string maskLayerName;
        webservice string maskLayerNumber;
        webservice string maskRev;
        webservice string romCode;
        webservice Decimal sortOrder;
        webservice boolean tapeoutFlag;
        webservice string logicalOperation;
        webservice string logicalOperationType;
        //swgp-899: Auto trigger Customer Mebes Jobview field to "N.A" for Top Up layers for GlobalShuttle MPW Device.
        //>>> need to add a new ws attribute flag here to indicate topup layer >>> .net sends this info to mrs
        webservice String maskLayerType;//swgp-899
    }

    global class PrimeDieData {
        webservice string primeDieName;
        webservice boolean tapeoutFlag;
        //swgp-884
        //Integration for Reserved Prime Die Sizes(pre-shrink) in MPW Reservation 
        //from SFDC to SWIFT PTRF for comparison against Prime Die Sizes(post shrink) 
        //during PTRF creation.
        webservice integer sn;
        webservice string topCellName;
        webservice decimal wcLowerLeft_X;
        webservice decimal wcLowerLeft_Y;
        webservice decimal wcUpperRight_X;
        webservice decimal wcUpperRight_Y;
        webservice integer antiClockWiseRotation;
        webservice integer eBeamShrink;
        webservice decimal primeDieSize_X;
        webservice decimal primeDieSize_Y;
        //swgp-884-end
    }

    global class ScribelineDropinsData {
        webservice string scribelineName;
        webservice boolean tapeoutFlag;
        //swgp-884       
        //Integration for Reserved Prime Die Sizes(pre-shrink) in MPW Reservation 
        //from SFDC to SWIFT PTRF for comparison against Prime Die Sizes(post shrink) 
        //during PTRF creation.
        webservice integer sn;
        webservice string topCellName;
        webservice decimal wcLowerLeft_X;
        webservice decimal wcLowerLeft_Y;
        webservice decimal wcUpperRight_X;
        webservice decimal wcUpperRight_Y;
        webservice integer antiClockWiseRotation;
        webservice integer eBeamShrink;
        webservice decimal scribelineDropinSize_X;
        webservice decimal scribelineDropinSize_Y;
        //swgp-884-end
    }

    global class ResponseData {
        webservice string messageId;
        webservice string ptrfNumber;
        webservice string status;
        webservice string errorMessage;
    }

    public static list < string > ptrfNumberList;
    
    webservice static void sync_PTRF_Status_PerformTapeoutOptions(list < PTRFDataRecievedOnPerformTapeout > ptrfData) {
        
        //swgp-1109 : On/Off Switches for MRS/DRT
        Environment_Variable__c env = Environment_Variable__c.getInstance('SWIFT_SWITCH_SEND_PTRF_PACKAGE_WS');
        if(null != env && env.value__c != 'ON') 
        {
            throw new MRSWebserviceException('We are sorry!!! 503 Service Unavailable. The server is currently unavailable (because it is overloaded or down for maintenance).');
            return;//safe-guard
        }
        //=======================================================
        
        boolean isEmptyMstError = false;//SWGP-740
        list < PTRF__c > ptrfList = new list < PTRF__c > ();
        list < PTRF_JobViewer_Info__c > jobviewInfoList = new list < PTRF_JobViewer_Info__c > ();
        list < Mask_Layer__c > maskLayerList = new list < Mask_Layer__c > ();
        list < Chip_Detail__c > chipDetailList = new list < Chip_Detail__c > ();
        list < Chip_Detail__c > chipDetailScribeLineList = new list < Chip_Detail__c > ();
        list < ResponseData > responseDataList = new list < ResponseData > ();
        string integrationPayload = '';
        Boolean PTRF_Status = False;
        Boolean dmlOperation = False;
        Boolean ptrfInsert = False;
        PTRF__c ptrfInst = new PTRF__c();
        integer NumberofLayers = 0;
        integer NumberofChips = 0;
        string ptrfNumberStr = '';
        
        try {
            //============================================================================================
            integrationPayload = 
                'ptrfNumber:"'                      + ptrfData[0].ptrf.ptrfNumber           
                + '"\r\nmaskSetTitle:"'             + ptrfData[0].ptrf.maskSetTitle         
                + '"\r\nreticleType:"'              + ptrfData[0].ptrf.reticleType          
                + '"\r\nprimeDRT:"'                 + ptrfData[0].ptrf.primeDRT             
                + '"\r\nprimeGDSOUT_Review:"'       + ptrfData[0].ptrf.primeGDSOUT_Review   
                + '"\r\nframeTapeout:"'             + ptrfData[0].ptrf.frameTapeout         
                + '"\r\nframeMockup:"'              + ptrfData[0].ptrf.frameMockup          
                + '"\r\nframeGDSOUT_Review:"'       + ptrfData[0].ptrf.frameGDSOUT_Review   
                + '"\r\nDRC_Only:"'                 + ptrfData[0].ptrf.DRC_Only             
                + '"\r\nbumpRequest:"'              + ptrfData[0].ptrf.bumpRequest          
                + '"\r\naccountShortName:"'         + ptrfData[0].ptrf.accountShortName     
                + '"\r\norderStatus:"'              + ptrfData[0].ptrf.orderStatus          
                + '"\r\ncustomerJobView:"'          + ptrfData[0].ptrf.customerJobView      
                + '"\r\nprocessOwnerJobview:"'      + ptrfData[0].ptrf.processOwnerJobview  
                + '"\r\nCRMDID:"'                   + ptrfData[0].ptrf.CRMDID               
                + '"\r\ndeviceId:"'                 + ptrfData[0].ptrf.deviceId             
                + '"\r\ntransactionDate:"'          + ptrfData[0].ptrf.transactionDate      
                + '"\r\nDRCoption:"'                + ptrfData[0].ptrf.DRCoption            
                + '"\r\nprocessid:"'                + ptrfData[0].ptrf.processid            
                + '"\r\nFab:"'                      + ptrfData[0].ptrf.Fab                  
                + '"\r\nMaskshop:"'                 + ptrfData[0].ptrf.Maskshop             
                + '"\r\nMaskTitleforROMcode:"'      + ptrfData[0].ptrf.MaskTitleforROMcode  + '"';
            //============================================================================================
                
            ptrfNumberStr = ptrfData[0].ptrf.ptrfNumber;

            //SWGP-365: MRS chips created for Open PTRF
            //swgp-884: add in GlobalShuttle Updates status
            if (null != ptrfData[0].ptrf.orderStatus && !('GlobalShuttle Updates;Open;Perform Tapeout Options'.containsIgnoreCase(ptrfData[0].ptrf.orderStatus))) {
                logValidationError(integrationPayload, 'Incorrect - PTRF Order Status: ' + ptrfData[0].ptrf.orderStatus, ptrfData[0].messageID, 'PTRF_DotNetService', 'sync_PTRF_Status_PerformTapeoutOptions', 'DEBUG', ptrfNumberStr);
                calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrf.ptrfNumber, 'ERROR', 'Incorrect - PTRF Order Status: ' + ptrfData[0].ptrf.orderStatus);
                return;
            } //SWGP-365: MRS chips created for Open PTRF
            //swgp-884: add in GlobalShuttle Updates status

            set < string > userNameFound = new set < string > ();
            set < string > userNameCustFound = new set < string > ();
            map < String, string > jvHCM_email = new map < string, string > ();
            list < MST_Config__c > mstConfigList = new list < MST_Config__c > ();
            
            // Code for enforcing same technology geometry for all PTRFs under an MST for MNR Reticle Type: Start
            map < string, string > mapMSTtechGeo = new map < string, string > ();
            
            try {
                
                if (ptrfData != null && ptrfData[0].ptrf != null && ptrfData[0].ptrf.maskSetTitle != null && ptrfData[0].ptrf.reticleType != 'Multi Node Reticle (MNR)') {
                    
                    List < ptrf__c > lstPTRF = new list < ptrf__c > ();
                    
                    lstPTRF = [select Tech_Geo_Value__c 
                        from ptrf__c 
                        where Mask_Set_Title__c = : ptrfData[0].ptrf.maskSetTitle 
                            and Tech_Geo_Value__c != null 
                            and Recticle_Type__c != 'Multi Node Reticle (MNR)'
                        order by createddate asc limit 1
                    ];
                    
                    if (lstPTRF.size() > 0 && lstPTRF[0].Tech_Geo_Value__c != ptrfData[0].ptrf.techGeo) {
                        
                        map < string, Error_codes__c > mapErrorCode = Error_codes__c.getAll();
                        string ErrorMessage = mapErrorCode.get('PTRF_MNR_Multiple_TechGeo').Message__c;
                        
                        logValidationError(
                            integrationPayload, 
                            ErrorMessage, 
                            ptrfData[0].messageID, 'PTRF_DotNetService', 
                            'sync_PTRF_Status_PerformTapeoutOptions', 
                            'DEBUG', 
                            ptrfNumberStr
                        );
                        
                        calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrf.ptrfNumber, 'ERROR', ErrorMessage);
                        return;
                    }
                }
            } catch (exception e) {
                PTRF_DotNetService.saveErrorLog(e, 'PTRF__c', ptrfData[0].messageID + ' | ' + ptrfNumberStr, integrationPayload);
                sendMail(e.getMessage(), ptrfNumberStr + ' - ' + e.getStackTraceString());
            }
            // Code for enforcing same technology geometry for all PTRFs under an MST for MNR Reticle Type: End
            
            //---------
            //======================================================================================//
            //SWGP-672: this line of code is just attached to 672
            //log payload immediately here
            try { 
                logValidationError(
                    integrationPayload,//Integration_Payload
                    'Incoming payload (shortened version) from SWIFT PTRF',//stack trace
                    ptrfData[0].messageID, 
                    'PTRF_DotNetService',//Apex Component Name
                    'sync_PTRF_Status_PerformTapeoutOptions',//method
                    'DEBUG',//Debug Level
                    ptrfNumberStr); } 
            catch(Exception e) {}//save a log should not cause any errors, catch here is just for precaution
            //======================================================================================//

            if (ptrfData[0].ptrf.accountShortName != null && ptrfData[0].ptrf.maskSetTitle != null) {
                
                try {
                    
                    list < account > acc = new list < account > ();
                    
                    if (ptrfData[0].ptrf != null && ptrfData[0].ptrf.accountShortName != null) { acc = [select id from account where Short_Name__c = : ptrfData[0].ptrf.accountShortName]; }
                    
                    list < Mask_Set_Title__c > mst = new list < Mask_Set_Title__c > ();
                    
                    if (ptrfData[0].ptrf != null && ptrfData[0].ptrf.maskSetTitle != null) { mst = [select id from Mask_Set_Title__c where name = : ptrfData[0].ptrf.maskSetTitle order by createddate desc]; }
                    
                    list < ptrf__c > lstPTRF = new list < ptrf__c > ([select id, Status__c, PTRF_External_ID__c from ptrf__c where name = : ptrfData[0].ptrf.ptrfNumber order by createddate asc limit 1]);
                    
                    if (lstPTRF.size() > 0) {
                        //SWGP-618
                        if('Cancel;Closed'.containsIgnoreCase(lstPTRF.get(0).status__c.trim())) {
                            
                            //return failure
                            logValidationError(
                                integrationPayload, 
                                'Incorrect - SFDC.PTRF Order Status: ' + lstPTRF.get(0).status__c, 
                                ptrfData[0].messageID, 'PTRF_DotNetService', 
                                'sync_PTRF_Status_PerformTapeoutOptions', 
                                'DEBUG', 
                                ptrfNumberStr
                            );
                            
                            calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrf.ptrfNumber, 'ERROR', 'PTRF is: ' + lstPTRF.get(0).status__c);
                            return;
                        }
                        //SWGP-618-END     
                                           
                        ptrfInst = lstPTRF[0];
                    }

                    list < Process_Technology__c > processTech = new list < Process_Technology__c > ();
                    
                    try {
                        if (ptrfData[0].ptrf != null && ptrfData[0].ptrf.processid != null) {
                            
                            Process__c process = new Process__c();
                            process = [select Process_Technology__c from Process__c where Name = : ptrfData[0].ptrf.processid limit 1];
                            
                            if (process.Process_Technology__c != Null) {
                                processTech = [select Lifecycle__c from Process_Technology__c where name = : process.Process_Technology__c order by createddate desc];
                            }
                        }
                    } catch(exception e) {
                        PTRF_DotNetService.saveErrorLog(e, 'PTRF__c', ptrfData[0].messageID + ' | ' + ptrfNumberStr, integrationPayload);
                        sendMail(e.getMessage(), ptrfNumberStr + ' - ' + e.getStackTraceString());
                    }


                    ptrfInst.Name = ptrfData[0].ptrf.ptrfNumber;
                    ptrfInst.PTRF_External_ID__c = ptrfData[0].ptrf.ptrfNumber;
                    ptrfInst.Mask_Set_Title__c = ptrfData[0].ptrf.maskSetTitle;
                    
                    if (mst != null && mst.size() > 0) {ptrfInst.MaskSetTitle__c = mst[0].id;}
                    
                    ptrfInst.Process_ID__c = ptrfData[0].ptrf.processid;
                    ptrfInst.Recticle_Type__c = ptrfData[0].ptrf.reticleType;
                    ptrfInst.Order_Type__c = ptrfData[0].ptrf.orderType;
                    ptrfInst.Prime_Tapeout__c = ptrfData[0].ptrf.primeTapeout;
                    ptrfInst.Prime_GDSOUT_Review__c = ptrfData[0].ptrf.primeGDSOUT_Review;
                    ptrfInst.Frame_Tapeout__c = ptrfData[0].ptrf.frameTapeout;
                    ptrfInst.Frame_Mockup__c = ptrfData[0].ptrf.frameMockup;
                    ptrfInst.DRC_Only__c = ptrfData[0].ptrf.DRC_Only;
                    ptrfInst.Bump_Request__c = ptrfData[0].ptrf.bumpRequest;
                    
                    //ptrfInst.Status__c='Open';
                    if (lstPTRF.size() < 0) { ptrfInsert = False; }
                    
                    if (lstPTRF.size() > 0 && ptrfInst.Status__c == 'Perform Tapeout Options') { ptrfInsert = True; }
                    
                    if (!ptrfInsert) {
                        
                        //Update Order Type and Reticle Type in order to bypass validation errors.
                        if (lstPTRF.size() > 0 && (ptrfInst.Order_Type__c == Null || ptrfInst.Recticle_Type__c == Null)) {
                            ptrfInst.Order_Type__c = ptrfData[0].ptrf.orderType;
                            ptrfInst.Recticle_Type__c = ptrfData[0].ptrf.reticleType;
                            try {update ptrfInst;} catch (exception e) {PTRF_DotNetService.saveErrorLog(e, 'PTRF__c', ptrfData[0].messageID + ' | ' + ptrfNumberStr, integrationPayload);sendMail(e.getMessage(), ptrfNumberStr + ' - ' + e.getStackTraceString());}
                        }
                        
                        if (lstPTRF.size() > 0 && ptrfData[0].ptrf.orderStatus == 'Perform Tapeout Options' && ptrfInst.MaskSetTitle__c != null) {
                            ptrfInst.Status__c = 'Perform Tapeout Options';
                            ptrfInst.status_from_dotNET__c = 'Perform Tapeout Options';
                        }
                        
                        //swgp-884
                        //>>> if ptrf is already created: update it from Open to GS Updates
                        //if it is PTO/Closed/Cancel >>> the validation at begining will stop this request
                        if (lstPTRF.size() > 0 && ptrfData[0].ptrf.orderStatus == 'GlobalShuttle Updates') {
                            ptrfInst.Status__c = 'GlobalShuttle Updates';
                            ptrfInst.status_from_dotNET__c = 'GlobalShuttle Updates';
                        }//swgp-884
                        
                        if (lstPTRF.size() < 1 && ptrfData[0].ptrf.orderStatus == 'Perform Tapeout Options') {
                            ptrfInst.Status__c = 'Open';
                            ptrfInst.status_from_dotNET__c = 'Perform Tapeout Options';
                            PTRF_Status = True;
                        }
                        
                        //SWGP-740: [PTRF WS] Add-in new response error for SendPTRFPackage if MST is not existed
                        //to be hot deploy in 11-July-2016
                        if (lstPTRF.size() > 0 && ptrfData[0].ptrf.orderStatus == 'Perform Tapeout Options' && ptrfInst.MaskSetTitle__c == null) {
                            //change below is related to swgp-884
                            //if ptrf is not existed and first signal is pto with empty mst
                            //>>> auto assign open status for the ptrf
                            //if ptrf is already existed and first signal is pto
                            //>>> keep existing order status
                            ptrfInst.Status__c = String.isBlank(ptrfInst.Status__c) ? 'Open' : ptrfInst.Status__c;
                            
                            ptrfInst.status_from_dotNET__c = 'Perform Tapeout Options';
                            isEmptyMstError = true;//SWGP-840
                        }
                        //SWGP-740-END

                        if (lstPTRF.size() < 1 && ptrfData[0].ptrf.orderStatus == 'Open') {
                            ptrfInst.Status__c = 'Open';
                            ptrfInst.status_from_dotNET__c = 'Open';
                        }
                        //swgp-884: Integration for Reserved Prime Die Sizes(pre-shrink) in MPW Reservation 
                        //          from SFDC to SWIFT PTRF for comparison against Prime Die Sizes(post shrink) during PTRF creation
                        //NEW PTRF (open is not created yet)
                        else if(lstPTRF.size() < 1 && ptrfData[0].ptrf.orderStatus == 'GlobalShuttle Updates') { 
                            ptrfInst.Status__c = 'GlobalShuttle Updates';
                            ptrfInst.status_from_dotNET__c = 'GlobalShuttle Updates';
                        }
                        //swgp-884
                        
                        ptrfInst.Customer_jobview__c = ptrfData[0].ptrf.customerJobView;
                        ptrfInst.CRMDID_Request__c = ptrfData[0].ptrf.CRMDID;
                        ptrfInst.Tech_Geo_Value__c = ptrfData[0].ptrf.techGeo;
                        ptrfInst.Device_Id__c = ptrfData[0].ptrf.deviceId;
                        ptrfInst.Source_Inbound_Timestamp__c = ptrfData[0].actionDateTime;
                        list < device__c > device = new list < device__c > ();
                        
                        if (ptrfData[0].ptrf != null && ptrfData[0].ptrf.CRMDID != null) device = [select id from device__c where CRMDID__c = : ptrfData[0].ptrf.CRMDID];
                        
                        if (device != null && device.size() > 0) ptrfInst.Device__c = device[0].id;
                        
                        ptrfInst.Customer_Short_Name_Int__c = ptrfData[0].ptrf.accountShortName;
                        
                        if (acc != null && acc.size() > 0) ptrfInst.Customer__c = acc[0].id;
                        
                        ptrfInst.Prime_DRT__c = ptrfData[0].ptrf.primeDRT;
                        ptrfInst.Frame_DRT__c = ptrfData[0].ptrf.frameDRT;
                        ptrfInst.Foundry_Jobview__c = ptrfData[0].ptrf.processOwnerJobview;
                        ptrfInst.Frame_GDSOUT_Review__c = ptrfData[0].ptrf.frameGDSOUT_Review;
                        ptrfInst.Transaction_Date__c = ptrfData[0].ptrf.TransactionDate;
                        ptrfInst.PTRF_DRC_Option__c = ptrfData[0].ptrf.DRCoption;
                        
                        if (processTech.size() > 0) { ptrfInst.Process_Technology_Lifecycle_Phase__c = processTech[0].Lifecycle__c; }
                        
                        ptrfInst.Fab__c = ptrfData[0].ptrf.Fab;
                        ptrfInst.Maskshop__c = ptrfData[0].ptrf.Maskshop;
                        ptrfInst.Maskshop_Id__c = ptrfData[0].ptrf.MaskshopId;
                        ptrfInst.Mask_Title_for_ROM_code__c = ptrfData[0].ptrf.MaskTitleforROMcode;

                        //include GS_Updates which is related to swgp-884
                        if (ptrfData[0].ptrf.orderStatus == 'Open' || ptrfData[0].ptrf.orderStatus == 'GlobalShuttle Updates') dmlOperation = True;

                        if (lstPTRF.size() == 0) {
                            
                            if (dmlOperation) { insert ptrfInst; }                             
                            else {
                                if (ptrfInst.MaskSetTitle__c != null) {

                                    ptrfInst.status_from_dotNET__c = 'Perform Tapeout Options';
                                    upsert ptrfInst PTRF_External_ID__c;
                                } else {
                                    ptrfInst.Status__c = 'Open';
                                    ptrfInst.status_from_dotNET__c = 'Perform Tapeout Options';
                                    upsert ptrfInst PTRF_External_ID__c;
                                }
                            }

                            //Insert PTRF DRT
                            if ((ptrfData[0].ptrf != null && ptrfData[0].ptrf.primeDRT != null) || (ptrfData[0].ptrf != null && ptrfData[0].ptrf.framedrt != null)) {
                                
                                list < DRT_PTRF_Association__c > lstpDRT = new list < DRT_PTRF_Association__c > ();
                                list < DRT__c > lstDRTFrame = new list < DRT__c > ();
                                list < DRT__c > lstDRTPrime = new list < DRT__c > ();
                                if (ptrfData[0].ptrf != null && ptrfData[0].ptrf.frameDRT != null) lstDRTFrame = [select id from drt__C where Mask_Set_Title__r.Name = : ptrfData[0].ptrf.maskSetTitle and Name = : ptrfData[0].ptrf.FrameDRT and status__c = 'Active'
                                limit 1];
                                if (ptrfData[0].ptrf != null && ptrfData[0].ptrf.primeDRT != null) lstDRTPrime = [select id from drt__C where Mask_Set_Title__r.Name = : ptrfData[0].ptrf.maskSetTitle and Name = : ptrfData[0].ptrf.primeDRT and status__c = 'Active'
                                limit 1];

                                list < DRT_PTRF_Association__c > lstPTRFDRT = new list < DRT_PTRF_Association__c > ();
                                
                                if (lstDRTFrame != null && lstDRTFrame.size() > 0) {
                                    DRT_PTRF_Association__c pDRT = new DRT_PTRF_Association__c();
                                    pDRT.PTRF__c = ptrfInst.id;
                                    pDRT.DRT__c = lstDRTFrame[0].id;
                                    pDRT.DRT_PTRF_Unique_Identifier__c = lstDRTFrame[0].id + '|' + ptrfInst.id;
                                    lstpDRT.add(pDRT);
                                }
                                
                                if (lstDRTPrime != null && lstDRTPrime.size() > 0) {
                                    DRT_PTRF_Association__c pDRT = new DRT_PTRF_Association__c();
                                    pDRT.PTRF__c = ptrfInst.id;
                                    pDRT.DRT__c = lstDRTPrime[0].id;
                                    pDRT.DRT_PTRF_Unique_Identifier__c = lstDRTPrime[0].id + '|' + ptrfInst.id;
                                    lstpDRT.add(pDRT);
                                }
                                
                                if (lstpDRT != null && lstpDRT.size() > 0) Database.insert(lstpDRT, false);
                            }
                        }
                        
                        set < string > userShortnameList = new set < string > ();
                        set < string > userIdList = new set < string > ();
                        map < string, string > userIdHCMIdMap = new map < string, string > ();
                        
                        if (ptrfData[0] != null && ptrfData[0].jobviewers != null) {

                            for (Jobviewer jobview: ptrfData[0].jobviewers) {
                                
                                if (jobview.jobviewType == 'ProcessOwner') {
                                    if (jobview.userId != null && jobview.userId != '') userShortnameList.add(jobview.userId.toLowerCase());
                                } else {
                                    if (jobview.userId != null && jobview.userId != '') userIdList.add(jobview.userId.toLowerCase());
                                }
                            }

                            if (userShortnameList != null && userShortnameList.size() > 0) {
                                
                                for (User usr: [Select u.HCM_Login_ID__c, u.Id From User u where u.HCM_Login_ID__c IN: userShortnameList]) {
                                    userIdHCMIdMap.put(usr.HCM_Login_ID__c.toUpperCase(), usr.Id);
                                    userNameFound.add(usr.HCM_Login_ID__c.toLowerCase());
                                }
                            }
                            
                            userShortnameList.removeAll(userNameFound);
                            
                            if (userIdList != null && userIdList.size() > 0) {
                                
                                for (User usr: [Select u.HCM_Login_ID__c, u.FederationIdentifier, u.Id From User u where u.FederationIdentifier IN: userIdList]) {
                                    userIdHCMIdMap.put(usr.FederationIdentifier, usr.Id);
                                    userNameCustFound.add(usr.FederationIdentifier.toLowerCase());
                                }
                            }
                            
                            userIdList.removeAll(userNameCustFound);
                            
                            for (Jobviewer jobview: ptrfData[0].jobviewers) {
                                
                                if (jobview.userId != null && jobview.userId != '') {
                                    if (userIdList.contains(jobview.userId.toLowerCase())) { jvHCM_email.put(jobview.userId, jobview.emailAddress); }
                                    if (userShortnameList.contains(jobview.userId.toLowerCase())) { jvHCM_email.put(jobview.userId, jobview.emailAddress); }
                                }
                                
                                if (jobview.userId == null || jobview.userId == '') jvHCM_email.put(jobview.emailAddress, jobview.emailAddress);
                                
                                PTRF_JobViewer_Info__c ptrfJobviewInfo = new PTRF_JobViewer_Info__c();
                                ptrfJobviewInfo.Jobview__c = jobview.jobviewType;
                                ptrfJobviewInfo.PTRF__c = ptrfInst.Id;

                                if (jobview.userId != null && jobview.userId != '' && userIdHCMIdMap.keySet() != null) {
                                    if (jobview.jobviewType == 'ProcessOwner' && userIdHCMIdMap.keySet().contains(jobview.userId.toUpperCase())) ptrfJobviewInfo.User__c = userIdHCMIdMap.get(jobview.userId.toUpperCase());
                                    if (jobview.jobviewType == 'Customer' && userIdHCMIdMap.keySet().contains(jobview.userId)) ptrfJobviewInfo.User__c = userIdHCMIdMap.get(jobview.userId);
                                }
                                
                                if (jobview.jobviewType == 'ProcessOwner') ptrfJobviewInfo.Jobview__c = 'Foundry';

                                ptrfJobviewInfo.Email_Address__c = jobview.emailAddress;

                                if (jobview.MEBES) ptrfJobviewInfo.Jobview_Type__c = 'MEBES Jobview';
                                
                                if (jobview.GDSOUT) {
                                    if (ptrfJobviewInfo.Jobview_Type__c != null && ptrfJobviewInfo.Jobview_Type__c != '') ptrfJobviewInfo.Jobview_Type__c = ptrfJobviewInfo.Jobview_Type__c + ';' + 'Prime GDSOUT Review';
                                    else ptrfJobviewInfo.Jobview_Type__c = 'Prime GDSOUT Review';
                                }
                                
                                if (jobview.frameMockup) {
                                    if (ptrfJobviewInfo.Jobview_Type__c != null && ptrfJobviewInfo.Jobview_Type__c != '') ptrfJobviewInfo.Jobview_Type__c = ptrfJobviewInfo.Jobview_Type__c + ';' + 'Frame Mockup';
                                    else ptrfJobviewInfo.Jobview_Type__c = 'Frame Mockup';
                                }
                                
                                jobviewInfoList.add(ptrfJobviewInfo);
                            }
                            
                            if (lstPTRF.size() > 0) {
                                list < PTRF_JobViewer_Info__c > delJobviewers = new list < PTRF_JobViewer_Info__c > ();
                                delJobviewers = [select id from PTRF_JobViewer_Info__c where PTRF__c = : ptrfInst.Id];
                                if (delJobviewers != null && delJobviewers.size() > 0) delete delJobviewers;
                            }

                            if (jobviewInfoList != null && jobviewInfoList.size() > 0) {
                                
                                try {
                                    insert jobviewInfoList;
                                    if (jvHCM_email.keySet().size() > 0) sendMail(ptrfInst.Name, jvHCM_email);
                                } catch (Exception e) {
                                    PTRF_DotNetService.saveErrorLog(e, 'PTRF__c', ptrfData[0].messageID + ' | ' + ptrfNumberStr, integrationPayload);
                                    sendMail(e.getMessage(), ptrfNumberStr + ' - ' + e.getStackTraceString());
                                }
                            }
                        }
                        
                        set < id > setlyrId = new set < id > ();
                        
                        if (ptrfData[0] != null && ptrfData[0].maskLayers != null) {

                            if (lstPTRF.size() > 0) { setlyrId.add(ptrfInst.Id); }

                            for (MaskLayerData maskLayer: ptrfData[0].maskLayers) {
                                Mask_Layer__c maskLayerIns = new Mask_Layer__c();
                                maskLayerIns.Name = maskLayer.maskLayerName;
                                maskLayerIns.PTRF__c = ptrfInst.Id;
                                maskLayerIns.Mask_Layer_Number__c = maskLayer.maskLayerNumber;
                                maskLayerIns.Mask_Layer_Rev__c = maskLayer.maskRev;
                                maskLayerIns.ROM_Code__c = maskLayer.romCode;
                                maskLayerIns.Tapeout__c = maskLayer.tapeoutFlag;
                                
                                //swgp-899: add in new field to determine topup layer so that customer mebes jobview can be triggered to N.A. if its layer is top up
                                maskLayerIns.Mask_Layer_Type__c = maskLayer.maskLayerType;
                                //swgp-899-end
                                
                                if (maskLayer.tapeoutFlag) { NumberofLayers += 1; }
                                
                                maskLayerIns.LogicalOperation__c = maskLayer.logicalOperation;
                                maskLayerIns.LogicalOperationType__c = maskLayer.logicalOperationType;
                                
                                //Changes for TASK-2373: Replacing comma separated TECN with semicolon separated TECNs
                                if (maskLayer.logicalOperationType == 'TECN' && maskLayer.logicalOperation != null && maskLayer.logicalOperation.indexOf(',') != -1) { maskLayerIns.LogicalOperation__c = maskLayer.logicalOperation.replace(',', ';'); }
                                
                                maskLayerIns.sort_Order__c = maskLayer.sortOrder;
                                maskLayerList.add(maskLayerIns);
                            }
                        }
                        
                        if (!setlyrId.isEmpty()) {
                            list < Mask_Layer__c > delLayers = new list < Mask_Layer__c > ();
                            delLayers = [select id from Mask_Layer__c where PTRF__c in : setlyrId];
                            if (delLayers.size() > 0) { delete delLayers; }
                        }
                        
                        if (maskLayerList != null && maskLayerList.size() > 0) {
                            try {
                                insert maskLayerList;
                            } catch (Exception e) {
                                PTRF_DotNetService.saveErrorLog(e, 'PTRF__c', ptrfData[0].messageID + ' | ' + ptrfNumberStr, integrationPayload);
                                sendMail(e.getMessage(), ptrfNumberStr + ' - ' + e.getStackTraceString());
                            }
                        }
                        
                        //=========================================================================================
                        //swgp-884: Integration for Reserved Prime Die Sizes(pre-shrink) in MPW Reservation 
                        //from SFDC to SWIFT PTRF for comparison against Prime Die Sizes(post shrink) during PTRF creation.
                        //*** UPDATE NEW FIELDS HERE
                        if (ptrfData[0] != null && ptrfData[0].primeDies != null) {
                            
                            for (primeDieData primeDie: ptrfData[0].primeDies) {
                                
                                Chip_Detail__c chipDetail = new Chip_Detail__c();
                                chipDetail.Name = primeDie.primeDieName;
                                chipDetail.PTRF__c = ptrfInst.id;
                                chipDetail.Tapeout__c = primeDie.tapeoutFlag;
                                
                                //swgp-884 - new fields to be added here                                
                                chipDetail.SN__c = primeDie.sn;
                                chipDetail.Top_Cell_Name__c = primeDie.topCellName;
                                chipDetail.WCLowerLeft_X__c = primeDie.wcLowerLeft_X;
                                chipDetail.WCLowerLeft_Y__c = primeDie.wcLowerLeft_Y;
                                chipDetail.WCUpperRight_X__c = primeDie.wcUpperRight_X;
                                chipDetail.WCUpperRight_Y__c = primeDie.wcUpperRight_Y;
                                chipDetail.Anti_Clockwise_Rotation_degrees__c = string.valueOf(primeDie.antiClockWiseRotation);
                                chipDetail.EBeamShrink__c = primeDie.eBeamShrink;
                                chipDetail.Size_X_um__c = primeDie.primeDieSize_X;
                                chipDetail.Size_Y_um__c = primeDie.primeDieSize_Y;                              
                                //swgp-884 - new fields to be added end
                                
                                if (primeDie.tapeoutFlag) NumberofChips += 1;
                                
                                chipDetail.RecordTypeId = getCustomSettingData('PRIME_DIE_RECORD_TYPE');
                                chipDetailList.add(chipDetail);
                            }
                        }
                        
                        if (ptrfData[0] != null && ptrfData[0].scribelineDropins != null) {
                            
                            for (ScribelineDropinsData scribeLine: ptrfData[0].scribelineDropins) {
                                
                                Chip_Detail__c chipDetail = new Chip_Detail__c();
                                chipDetail.Name = scribeLine.scribeLineName;
                                chipDetail.PTRF__c = ptrfInst.id;
                                chipDetail.Tapeout__c = scribeLine.tapeoutFlag;
                                
                                //swgp-884 - new fields to be added here         
                                chipDetail.SN__c = scribeLine.sn;
                                chipDetail.Top_Cell_Name__c = scribeLine.topCellName;
                                chipDetail.WCLowerLeft_X__c = scribeLine.wcLowerLeft_X;
                                chipDetail.WCLowerLeft_Y__c = scribeLine.wcLowerLeft_Y;
                                chipDetail.WCUpperRight_X__c = scribeLine.wcUpperRight_X;
                                chipDetail.WCUpperRight_Y__c = scribeLine.wcUpperRight_Y;
                                chipDetail.Anti_Clockwise_Rotation_degrees__c = string.valueOf(scribeLine.antiClockWiseRotation);
                                chipDetail.EBeamShrink__c = scribeLine.eBeamShrink;
                                chipDetail.Size_X_um__c = scribeLine.scribelineDropinSize_X;
                                chipDetail.Size_Y_um__c = scribeLine.scribelineDropinSize_Y;                         
                                //swgp-884 - new fields to be added end
                                
                                if (scribeLine.tapeoutFlag) NumberofChips += 1;
                                
                                chipDetail.RecordTypeId = getCustomSettingData('SCRIBE_LINE_DROPINS_RECORD_TYPE');
                                chipDetailScribeLineList.add(chipDetail);
                            }
                        }
                        //swgp-884: Integration for Reserved Prime Die Sizes(pre-shrink) in MPW Reservation 
                        //from SFDC to SWIFT PTRF for comparison against Prime Die Sizes(post shrink) during PTRF creation.
                        //=========================================================================================
                        
                        if (lstPTRF.size() > 0) {
                            
                            list < Chip_Detail__c > delChips = new list < Chip_Detail__c > ();
                            delChips = [select id from Chip_Detail__c where PTRF__c = : ptrfInst.Id];
                            if (delChips != null && delChips.size() > 0) delete delChips;
                        }
                        
                        if (chipDetailList != null && chipDetailList.size() > 0) {
                            try { insert chipDetailList; } catch (Exception e) { PTRF_DotNetService.saveErrorLog(e, 'PTRF__c', ptrfData[0].messageID + ' | ' + ptrfNumberStr, integrationPayload); sendMail(e.getMessage(), ptrfNumberStr + ' - ' + e.getStackTraceString()); }
                        }
                        
                        if (chipDetailScribeLineList != null && chipDetailScribeLineList.size() > 0) {
                            try {insert chipDetailScribeLineList;} catch (Exception e) {PTRF_DotNetService.saveErrorLog(e, 'PTRF__c', ptrfData[0].messageID + ' | ' + ptrfNumberStr, integrationPayload);sendMail(e.getMessage(), ptrfNumberStr + ' - ' + e.getStackTraceString());}
                        }
                        
                        if (lstPTRF.size() > 0) {

                            if (ptrfInst.MaskSetTitle__c == null && ptrfData[0].ptrf.maskSetTitle != null && ptrfInst.Order_Type__c != null) {
                                update ptrfInst;
                                DRTSwiftUtility.createMSTfromPTRF(ptrfData[0].ptrf.maskSetTitle, ptrfData[0].ptrf.ptrfNumber, ptrfData[0].ptrf.reticleType);
                            } else if (ptrfInst.MaskSetTitle__c != null && ptrfData[0].ptrf.orderStatus == 'Perform Tapeout Options' && ptrfInst.Order_Type__c != null) {
                                ptrfInst.status__c = 'Perform Tapeout Options';
                                update ptrfInst;
                            } else if (ptrfInst.Order_Type__c != null) update ptrfInst;
                        }

                        if (lstPTRF.size() < 1) {
                            
                            list < ptrf__c > lstPTRFUpdt = new list < ptrf__c > ([select id, MaskSetTitle__c, Status__c from ptrf__c where name = : ptrfData[0].ptrf.ptrfNumber limit 1]);
                            
                            if (lstPTRFUpdt.size() > 0 && lstPTRFUpdt[0].MaskSetTitle__c != null && ptrfInst.Order_Type__c != null) {
                                if (PTRF_Status) { lstPTRFUpdt[0].Status__c = 'Perform Tapeout Options'; }
                                update lstPTRFUpdt;
                            }
                            
                            if (lstPTRFUpdt.size() > 0 && lstPTRFUpdt[0].MaskSetTitle__c == null && ptrfData[0].ptrf.maskSetTitle != null) {
                                DRTSwiftUtility.createMSTfromPTRF(ptrfData[0].ptrf.maskSetTitle, ptrfData[0].ptrf.ptrfNumber, ptrfData[0].ptrf.reticleType);
                            }
                        }
                        
                        boolean bSendResponse = TRUE;
                        
                        try {
                            if (ptrfData[0].ptrf.primeTapeout && ptrfData[0].ptrf.frameTapeout) {
                                decimal iLayerChip = decimal.valueOf(NumberofLayers * (NumberofChips + 1));
                                if ((integer.valueOf(iLayerChip)) > 4200) {calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrf.ptrfNumber, 'ERROR', 'The combination of selected mask layer versus chips has exceeded maximum record of 4200. Please consider to split into multiple PTRFs.');bSendResponse = FALSE;}
                            } else if (ptrfData[0].ptrf.primeTapeout) {
                                decimal iLayerChip = decimal.valueOf(NumberofLayers * NumberofChips);
                                if ((integer.valueOf(iLayerChip)) > 4200) {calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrf.ptrfNumber, 'ERROR', 'The combination of selected mask layer versus chips has exceeded maximum record of 4200. Please consider to split into multiple PTRFs.');bSendResponse = FALSE;}
                            } else if (ptrfData[0].ptrf.frameTapeout) {
                                decimal iLayerChip = decimal.valueOf(NumberofLayers);
                                if ((integer.valueOf(iLayerChip)) > 4200) {calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrf.ptrfNumber, 'ERROR', 'The combination of selected mask layer versus chips has exceeded maximum record of 4200. Please consider to split into multiple PTRFs.');bSendResponse = FALSE;}
                            }
                        } catch (exception e) {
                            PTRF_DotNetService.saveErrorLog(e, 'PTRF__c', ptrfData[0].messageID + ' | ' + ptrfNumberStr, integrationPayload);
                            sendMail(e.getMessage(), ptrfNumberStr + ' - ' + e.getStackTraceString());
                        }
                        
                        if (bSendResponse) {
                            
                            /*SWGP-840-to check for error result of MST empty and response an error
                            to send response here because the logic above is beyond readable and after mst validation, the code is doing something else?*/
                            if(isEmptyMstError) { 
                                //return failure
                                logValidationError(
                                    integrationPayload, 
                                    'Mask Set Title is not existed in SFDC. Please ask Bhanu/SFDC_Support to create and retrigger this signal.', 
                                    ptrfData[0].messageID, 'PTRF_DotNetService', 
                                    'sync_PTRF_Status_PerformTapeoutOptions', 
                                    'DEBUG', 
                                    ptrfNumberStr
                                );
                                
                                calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrf.ptrfNumber, 'ERROR', 'Mask Set Title is not existed in SFDC. Please ask Bhanu/SFDC_Support to create and retrigger this signal.');
                            /*SWGP-840-END*/
                            } else {
                                calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrf.ptrfNumber, 'SUCCESS', null);
                            }
                        }
                    } else {
                        calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrf.ptrfNumber, 'ERROR', 'PTRF already moved to Perform Tapeout Options status.');
                    }
                    
                } catch (exception e) {
                    calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrf.ptrfNumber, 'ERROR', e.getMessage());
                    PTRF_DotNetService.saveErrorLog(e, 'PTRF__c', ptrfData[0].messageID + ' | ' + ptrfNumberStr, integrationPayload);
                    sendMail(e.getMessage(), ptrfNumberStr + ' - ' + e.getStackTraceString());
                }
            }
            
            // Send Error to SWIFT .NET
            else { calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrf.ptrfNumber, 'ERROR', 'Necessary parameters not defined: Customer ShortName,Mask Set Title'); }
            
        } catch (Exception e) {
            PTRF_DotNetService.saveErrorLog(e, 'PTRF__c', ptrfData[0].messageID + ' | ' + ptrfNumberStr, integrationPayload);
            sendMail(e.getMessage(), ptrfNumberStr + ' - ' + e.getStackTraceString());
        }
    }    
    
    webservice static void sync_PTRF_Chip_MaskLayer_Deselected(list < PTRFDataRecievedDiesLayersDeselected > ptrfData) {
        
        //swgp-1109 : On/Off Switches for MRS/DRT
        Environment_Variable__c env = Environment_Variable__c.getInstance('SWIFT_SWITCH_PTRF_OLD_DESELECTION');
        if(null != env && env.value__c != 'ON') 
        {
            throw new MRSWebserviceException('We are sorry!!! 503 Service Unavailable. The server is currently unavailable (because it is overloaded or down for maintenance).');
            return;//safe-guard
        }
        //=======================================================
        
        String responseMsg = 'SUCCESS';//swgp-672
        list < PTRF__c > ptrfInsList = new list < PTRF__c > ();
        list < MRS_Layer_Association__c > maskLayerList = new list < MRS_Layer_Association__c > ();
        list < string > chipDetailList = new list < string > ();
        list < string > chipDetailScribeLineList = new list < string > ();
        map < id, MRS_Layer_Chip_Association__c > mrsChipLayerAssMap = new map < id, MRS_Layer_Chip_Association__c > ();
        list < MRS_Layer_Chip_Association__c > mrsChipLayerAssIns = new list < MRS_Layer_Chip_Association__c > ();
        list < MRS_Layer_Chip_Association__c > mrsChipLayerAssChipsIns = new list < MRS_Layer_Chip_Association__c > ();
        list < ResponseData > responseDataList = new list < ResponseData > ();
        list < string > maskLayerIdList = new list < string > ();
        set < string > setPTRFlayer = new set < string > ();
        
        for (PTRF__c ptrfIns: [select id,Prime_Tapeout__c,Name,Frame_Tapeout__c from PTRF__c where Name = : ptrfData[0].ptrfNumber limit 1]) { ptrfInsList.add(ptrfIns);}
        
        if (ptrfInsList != null && ptrfInsList.size() > 0) {
            
            list < string > maskLayerNameList = new list < string > ();
            set < string > maskLayerInExisting = new set < string > ();
            set < string > maskLInExisting = new set < string > ();
            set < string > maskLayerChipInExisting = new set < string > ();
            set < string > chipInExisting = new set < string > ();
            set < string > pdExisting = new set < string > ();
            list < string > chipNameList = new list < string > ();
            list < string > scribeNameList = new list < string > ();
            set < string > chipScribeNameList = new set < string > ();
            string missingList = 'Few';
            Boolean verifyUpdate = True;
            
            if (ptrfData[0].maskLayers != null && ptrfData[0].maskLayers.size() > 0) {
                
                for (MaskLayerData maskLayer: ptrfData[0].maskLayers) {
                    
                    maskLayerNameList.add(maskLayer.maskLayerNumber);
                    
                    if (maskLayer.romCode != null && maskLayer.romCode != '') maskLayerInExisting.add(maskLayer.maskLayerNumber + '|' + maskLayer.maskRev + '|' + maskLayer.romCode);
                    else maskLayerInExisting.add(maskLayer.maskLayerNumber + '|' + maskLayer.maskRev);
                }
            }
            
            if (ptrfData[0].primeDies != null && ptrfData[0].primeDies.size() > 0) {
                
                for (primeDieData primeDie: ptrfData[0].primeDies) {

                    chipNameList.add(primeDie.primeDieName);
                    chipScribeNameList.add(primeDie.primeDieName);
                }
            }
            
            list < Chip_Detail__c > lstChipDetailupdt = new list < Chip_Detail__c > ();
            list < Mask_Layer__c > lstLayersupdt = new list < Mask_Layer__c > ();
            list < Mask_Layer__c > lstLayers = new list < Mask_Layer__c > ();

            if (ptrfData[0].scribelineDropins != null && ptrfData[0].scribelineDropins.size() > 0) {

                for (ScribelineDropinsData scribeLine: ptrfData[0].scribelineDropins) {
                    scribeNameList.add(scribeLine.scribeLineName);
                    chipScribeNameList.add(scribeLine.scribeLineName);
                }
            }
            
            set < string > drtNameSet = new set < string > ();
            set < string > drtChipSet = new set < string > ();
            set < MRS_Layer_Chip_Association__c > MRSdrtNameSet = new set < MRS_Layer_Chip_Association__c > ();
            string mstName;
            string Fdrt;
            string Pdrt;
            map < string, list < MRS_Layer_Chip_Association__c >> MRSPdrtNameMap = new map < string, list < MRS_Layer_Chip_Association__c >> ();
            map < string, list < MRS_Layer_Chip_Association__c >> MRSFdrtNameMap = new map < string, list < MRS_Layer_Chip_Association__c >> ();
            map < string, list < MRS_Layer_Chip_Association__c >> MRSdrtNameMap = new map < string, list < MRS_Layer_Chip_Association__c >> ();
            
            if (maskLayerNameList != null && maskLayerNameList.size() > 0) {
                
                mrsChipLayerAssIns = [
                    select m.PTRF__c,m.DRT_Name__c,m.PTRF_Number__c,m.Name, m.Mask_Set_Title_Name__c,m.Mask_Layer__c,
                        m.Rev__c,m.ROM_Code__c,m.Id, m.DRT__r.Type__c,m.Layer__r.Id,m.Layer__c,m.Layer_Chip_Status__c,
                        m.Chip_Name__c 
                    from MRS_Layer_Chip_Association__c m
                    where m.PTRF__c = : ptrfInsList[0].Id AND m.Mask_Layer__c IN: maskLayerNameList
                ];
                
                if (mrsChipLayerAssIns != null && mrsChipLayerAssIns.size() > 0) {
                    
                    mstName = mrsChipLayerAssIns[0].Mask_Set_Title_Name__c;
                    
                    for (MRS_Layer_Chip_Association__c mrsChipLayer: mrsChipLayerAssIns) {
                        
                        if (mrsChipLayer.DRT_Name__c != null && mrsChipLayer.DRT_Name__c != '') {
                            
                            drtNameSet.add(mrsChipLayer.DRT_Name__c);
                            if (mrsChipLayer.DRT__r.Type__c == 'PRIME') Pdrt = mrsChipLayer.DRT_Name__c;
                            else Fdrt = mrsChipLayer.DRT_Name__c;
                        }
                    }
                    
                    Map<String,String> mapLayerToPTRF = new Map<String,String>();
                    
                    Set<ID> relatedPTRFSet = new Set<ID>();
                    
                    for (DRT_PTRF_Association__c obj: [select PTRF__c, PTRF__r.Status__c, DRT__c from DRT_PTRF_Association__c
                        where PTRF__c not in : ptrfInsList and DRT__r.Name in : drtNameSet and PTRF__r.Status__c = 'Perform Tapeout Options']) {
                        relatedPTRFSet.add(obj.PTRF__c);
                    }
                    
                    String tmpLayerKey;
                    
                    for (Mask_Layer__c layer: [select Id, Mask_Layer_Number__c, Mask_Layer_Rev__c, ROM_Code__c, PTRF__c, PTRF__r.Frame_DRT__c,PTRF__r.Prime_DRT__c from Mask_Layer__c
                        where PTRF__c in : relatedPTRFSet and PTRF__r.MaskSetTitle__r.Name=:mstName and Tapeout__c=true and Mask_Layer_Number__c IN :maskLayerNameList order by PTRF__r.Name asc]) {
                        tmpLayerKey = layer.Mask_Layer_Number__c + layer.Mask_Layer_Rev__c + ( String.isBlank(layer.ROM_Code__c)?'':layer.ROM_Code__c );
                        
                        if(layer.PTRF__r.Frame_DRT__c!=null && !mapLayerToPTRF.containsKey( tmpLayerKey +  layer.PTRF__r.Frame_DRT__c)){
                            mapLayerToPTRF.put( tmpLayerKey +  layer.PTRF__r.Frame_DRT__c, layer.PTRF__c );
                        }
                        
                        if(layer.PTRF__r.Prime_DRT__c!=null && !mapLayerToPTRF.containsKey( tmpLayerKey +  layer.PTRF__r.Prime_DRT__c)){
                            mapLayerToPTRF.put( tmpLayerKey +  layer.PTRF__r.Prime_DRT__c, layer.PTRF__c );
                        }
                    }
                    
                    if (drtNameSet != null && drtNameSet.size() > 0) {
                        
                        for (MRS_Layer_Chip_Association__c mrsIns: [
                            select m.PTRF__c,m.DRT_Name__c,m.PTRF_Number__c,m.Name, m.Mask_Set_Title_Name__c,
                                m.Mask_Layer__c,m.Rev__c,m.ROM_Code__c,m.Id, m.DRT__r.Type__c,
                                m.Layer__r.Id,m.Layer__c,m.Layer_Chip_Status__c,m.Chip_Name__c ,Is_Cancel_After_Off_Hold__c
                            from MRS_Layer_Chip_Association__c m
                            where m.Mask_Set_Title_Name__c = : mstName and PTRF__c=:ptrfInsList[0].Id 
                                AND m.DRT_Name__c IN: drtNameSet 
                                AND m.Mask_Layer__c IN: maskLayerNameList 
                                AND m.Layer_Chip_Status__c != 'Cancel' 
                            order by PTRF_Number__c asc
                        ]) {
                            tmpLayerKey = mrsIns.Mask_Layer__c + mrsIns.Rev__c + ( String.isBlank(mrsIns.ROM_Code__c)?'':mrsIns.ROM_Code__c );
                            if( mapLayerToPTRF.containsKey( tmpLayerKey + mrsIns.DRT_Name__c )){ drtChipSet.add(mrsIns.Id); }
                        }
                    }

                    for (MRS_Layer_Chip_Association__c mrsChipLayer: mrsChipLayerAssIns) {
                        
                        if (mrsChipLayer.ROM_Code__c != null && mrsChipLayer.ROM_Code__c != '') maskLayerChipInExisting.add(mrsChipLayer.Mask_Layer__c + '|' + mrsChipLayer.Rev__c + '|' + mrsChipLayer.ROM_Code__c);
                        else maskLayerChipInExisting.add(mrsChipLayer.Mask_Layer__c + '|' + mrsChipLayer.Rev__c);

                        if (ptrfData[0].maskLayers != null && ptrfData[0].maskLayers.size() > 0) {
                            
                            for (MaskLayerData maskLayer: ptrfData[0].maskLayers) {
                                
                                if ((((mrsChipLayer.ROM_Code__c == null || mrsChipLayer.ROM_Code__c == '') && (maskLayer.romCode == null || maskLayer.romCode == '')) || mrsChipLayer.ROM_Code__c == maskLayer.romCode) && mrsChipLayer.Mask_Layer__c == maskLayer.maskLayerNumber && mrsChipLayer.Rev__c == maskLayer.maskRev) {

                                    if (!drtChipSet.contains(mrsChipLayer.id)) {
                                                                                
                                        //swgp-950 check for hold layer chip status, set flag Is_Cancel_After_Off_Hold__c
                                        if(mrsChipLayer.layer_Chip_status__c != 'Hold') {
                                            mrsChipLayer.Layer_Chip_Status__c = 'Cancel';
                                        } else {
                                            mrsChipLayer.Is_Cancel_After_Off_Hold__c = true;
                                        }
                                        mrsChipLayerAssMap.put(mrsChipLayer.id, mrsChipLayer);
                                        //swgp-950
                                        
                                    } else {
                                        
                                        tmpLayerKey = mrsChipLayer.Mask_Layer__c + mrsChipLayer.Rev__c + ( String.isBlank(mrsChipLayer.ROM_Code__c)?'':mrsChipLayer.ROM_Code__c ) + mrsChipLayer.DRT_Name__c;
                                        
                                        if( mapLayerToPTRF.containsKey(tmpLayerKey) ){
                                            mrsChipLayer.PTRF__c = mapLayerToPTRF.get(tmpLayerKey);
                                            mrsChipLayerAssMap.put(mrsChipLayer.id, mrsChipLayer);
                                        }
                                    }
                                    
                                    if (maskLayer.romCode == null || maskLayer.romCode == '') setPTRFlayer.add(ptrfInsList[0].Id + '|' + maskLayer.maskLayerNumber + '|' + maskLayer.maskRev);
                                    else setPTRFlayer.add(ptrfInsList[0].Id + '|' + maskLayer.maskLayerNumber + '|' + maskLayer.maskRev + '|' + maskLayer.romCode);
                                }
                            }
                        }
                    }
                    
                    if (!maskLayerChipInExisting.containsAll(maskLayerInExisting)) {
                        mrsChipLayerAssMap = new map < Id, MRS_Layer_Chip_Association__c > ();
                        verifyUpdate = False;
                    }
                    
                } else {
                    
                    for (MaskLayerData maskLayer: ptrfData[0].maskLayers) {
                    
                        if (maskLayer.romCode == null || maskLayer.romCode == '') setPTRFlayer.add(ptrfInsList[0].Id + '|' + maskLayer.maskLayerNumber + '|' + maskLayer.maskRev);
                        else setPTRFlayer.add(ptrfInsList[0].Id + '|' + maskLayer.maskLayerNumber + '|' + maskLayer.maskRev + '|' + maskLayer.romCode);
                    }
                }

                if (setPTRFlayer != null && !setPTRFlayer.isempty()) {

                    lstLayers = [select id, ptrf__c, name, Mask_Layer_Number__c, Mask_Layer_Rev__c, ROM_Code__c from Mask_Layer__c where ptrf__c = : ptrfInsList[0].Id];

                    for (Mask_Layer__c lyr: lstLayers) {
                        
                        if (lyr.ROM_Code__c == null || lyr.ROM_Code__c == '') {
                            
                            maskLInExisting.add(lyr.Mask_Layer_Number__c + '|' + lyr.Mask_Layer_Rev__c);
                            
                            if (setPTRFlayer.contains(lyr.ptrf__c + '|' + lyr.Mask_Layer_Number__c + '|' + lyr.Mask_Layer_Rev__c)) {
                                lyr.Tapeout__c = false;
                                lstLayersupdt.add(lyr);
                            }
                        } else {
                            
                            maskLInExisting.add(lyr.Mask_Layer_Number__c + '|' + lyr.Mask_Layer_Rev__c + '|' + lyr.ROM_Code__c);
                            if (setPTRFlayer.contains(lyr.ptrf__c + '|' + lyr.Mask_Layer_Number__c + '|' + lyr.Mask_Layer_Rev__c + '|' + lyr.ROM_Code__c)) {
                                lyr.Tapeout__c = false;
                                lstLayersupdt.add(lyr);
                            }
                        }
                    }
                    
                    if (!maskLInExisting.containsAll(maskLayerInExisting)) {
                        lstLayersupdt = new list < Mask_Layer__c > ();
                        verifyUpdate = False;
                        missingList = 'Layers';
                    }
                }
            }
            
            if (chipNameList != null && chipNameList.size() > 0) {
                
                //swgp-950 include Is_Cancel_After_Off_Hold__c
                mrsChipLayerAssChipsIns = [
                    select m.PTRF__c, m.Rev__c, m.ROM_Code__c, m.PTRF_Number__c, m.Name, m.Mask_Layer__c,
                        m.Id, m.Layer__r.Id, m.Layer__c, m.Layer_Chip_Status__c, m.Chip_Name__c 
                        ,Is_Cancel_After_Off_Hold__c
                    from MRS_Layer_Chip_Association__c m
                    where m.PTRF__c = : ptrfInsList[0].Id AND m.Chip_Name__c IN: chipNameList
                ];
                
                for (MRS_Layer_Chip_Association__c mrsChipLayer: mrsChipLayerAssChipsIns) {
                    chipInExisting.add(mrsChipLayer.Chip_Name__c);
                    
                    //swgp-950 check for hold layer chip status, set flag Is_Cancel_After_Off_Hold__c
                    if(mrsChipLayer.Layer_Chip_Status__c != 'Hold') {
                        mrsChipLayer.Layer_Chip_Status__c = 'Cancel';
                    } else {
                        mrsChipLayer.Is_Cancel_After_Off_Hold__c = true;
                    }                    
                    mrsChipLayerAssMap.put(mrsChipLayer.id, mrsChipLayer);
                    //swgp-950-end
                }
                
                if (!chipInExisting.containsAll(chipNameList)) {
                    mrsChipLayerAssMap = new map < Id, MRS_Layer_Chip_Association__c > ();
                    verifyUpdate = False;
                }
            }

            if (scribeNameList != null && scribeNameList.size() > 0) {
                
                mrsChipLayerAssChipsIns = [
                    select m.PTRF__c, m.Rev__c,m.ROM_Code__c,m.PTRF_Number__c,m.Name,m.Mask_Layer__c,m.Id,
                        m.Layer__r.Id,m.Layer__c,m.Layer_Chip_Status__c,m.Chip_Name__c
                    from MRS_Layer_Chip_Association__c m
                    where m.PTRF__c = : ptrfInsList[0].Id AND m.Chip_Name__c IN: scribeNameList
                ];
                
                for (MRS_Layer_Chip_Association__c mrsChipLayer: mrsChipLayerAssChipsIns) {
                    chipInExisting.add(mrsChipLayer.Chip_Name__c);
                    
                    //swgp-950 check for hold layer chip status, set flag Is_Cancel_After_Off_Hold__c
                    if(mrsChipLayer.Layer_Chip_Status__c != 'Hold') {
                        mrsChipLayer.Layer_Chip_Status__c = 'Cancel';
                    } else {
                        mrsChipLayer.Is_Cancel_After_Off_Hold__c = true;
                    }
                    mrsChipLayerAssMap.put(mrsChipLayer.id, mrsChipLayer);
                    //swgp-950
                }

                if (!chipInExisting.containsAll(scribeNameList)) {
                    mrsChipLayerAssMap = new map < Id, MRS_Layer_Chip_Association__c > ();
                    verifyUpdate = False;
                }
            }
            
            if (chipScribeNameList != null && chipScribeNameList.size() > 0) {
                
                for (Chip_Detail__c chipDt: [select Tapeout__c, ptrf__c, id, Name from Chip_Detail__c where Name IN: chipScribeNameList AND ptrf__c = : ptrfInsList[0].Id]) {
                    pdExisting.add(chipDt.Name);
                    chipDt.Tapeout__c = False;
                    lstChipDetailupdt.add(chipDt);
                }
                
                if (!pdExisting.containsAll(chipScribeNameList)) {
                    lstChipDetailupdt = new list < Chip_Detail__c > ();
                    verifyUpdate = False;
                    missingList += 'Prime Dies/Scribe Lines';
                }
            }

            List < MRS_Layer_Chip_Association__c > mrsChipLayerAssList = new List < MRS_Layer_Chip_Association__c > (mrsChipLayerAssMap.values());//swgp-950: this line parse the list to update
            
            try {
                
                if (verifyUpdate) {
                    
                    //swgp-950: to gate cancel for hold layer chip right here instead of inside trigger
                    if (mrsChipLayerAssList != null && mrsChipLayerAssList.size() > 0) { MRSHandlerUtility.updateLayerChip(mrsChipLayerAssList); }       
                    
                    if (lstChipDetailupdt != null && lstChipDetailupdt.size() > 0) { update lstChipDetailupdt; }
                    
                    if (lstLayersupdt != null && lstLayersupdt.size() > 0) { update lstLayersupdt; }
                    
                    calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrfNumber, 'SUCCESS', '');
                } else {
                                  
                    calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrfNumber, 'SUCCESS', missingList + 'missing');
                    responseMsg = missingList + 'missing';//swgp-672
                }
                
            } catch (DMLException e) {
                calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrfNumber, 'ERROR', e.getMessage());
                responseMsg = e.getMessage();//swgp-672
            } catch (Exception e) {
                responseDataList.add(serviceResponse(ptrfData[0].messageID, ptrfData[0].ptrfNumber, 'ERROR', e.getMessage()));
                calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrfNumber, 'ERROR', e.getMessage());
                responseMsg = e.getMessage();//swgp-672
            }

        } else { //Send Error Message for PTRF not existing
            calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrfNumber, 'ERROR', 'PTRF Number does not exist.');
            responseMsg = 'PTRF Number does not exist.';
        }
        
        //==========================================
        //SWGP-672: [PTRF WS] Chip's deselected in PTRF however in MRS, chips are still active
        //LOG payload here in future method
        //cast ptrfData to string >>> parse into future method >>> deserialize again 
        //>>> iterate over the list and extract layer/chip >>> save as string into log
        try{ logValidationError(
            json.serialize(ptrfData.get(0)), 
            responseMsg, 
            ptrfData.get(0).messageID, 
            'PTRF_DotNetService', 
            'sync_PTRF_Chip_MaskLayer_Deselected', 
            'DEBUG', 
            ptrfData.get(0).ptrfNumber); } catch(exception e) {}    
        //SWGP-672    
        //==========================================
    }
    
    webservice static void sync_PTRF_NewJobView_ChangesInJobView(list < PTRFDataRecievedOnJobviewDataChange > ptrfData) {
        
        //swgp-1109 : On/Off Switches for MRS/DRT
        Environment_Variable__c env = Environment_Variable__c.getInstance('SWIFT_SWITCH_JOBVIEWER_SYNCING');
        if(null != env && env.value__c != 'ON') 
        {
            throw new MRSWebserviceException('We are sorry!!! 503 Service Unavailable. The server is currently unavailable (because it is overloaded or down for maintenance).');
            return;//safe-guard
        }
        //=======================================================
        
        list < PTRF__c > ptrfInsList = new list < PTRF__c > ();
        map < String, string > jvHCM_email = new map < string, string > ();
        set < PTRF_JobViewer_Info__c > jobviewInfoList = new set < PTRF_JobViewer_Info__c > ();
        list < PTRF_JobViewer_Info__c > ptrfJobviewInfoList = new list < PTRF_JobViewer_Info__c > ();
        list < PTRF_JobViewer_Info__c > ptrfJobviewInfoUpdateList = new list < PTRF_JobViewer_Info__c > ();
        list < PTRF_JobViewer_Info__c > jobInfoDeleteList = new list < PTRF_JobViewer_Info__c > ();
        list < ResponseData > responseDataList = new list < ResponseData > ();
        ptrfInsList = [select id from PTRF__c where Name = : ptrfData[0].ptrfNumber limit 1];
        set < string > userName = new set < string > ();
        set < string > userNameFound = new set < string > ();
        set < string > userNameCust = new set < string > ();
        set < string > userNameCustFound = new set < string > ();
        set < string > userEmailNotFound = new set < string > ();
        boolean jobviewExist = False;
         
        map < string, string > userNameMap = new map < string, string > ();
        
        if (ptrfInsList != null && ptrfInsList.size() > 0 && ptrfData[0].jobviewers != null) {
            
            list < PTRF_JobViewer_Info__c > jobViewerList = [
                select p.User__c,p.PTRF__c,p.Name,p.Jobview__c,p.Jobview_Type__c,p.Id,p.Email_Address__c 
                from PTRF_JobViewer_Info__c p
                where p.PTRF__c = : ptrfInsList[0].id
            ];
            
            for (Jobviewer jobview: ptrfData[0].jobviewers) {
                
                if (jobview.jobviewType == 'ProcessOwner') {
                    if (jobview.userId != null && jobview.userId != '') userName.add(jobview.userId.toLowerCase());
                } else if (jobview.jobviewType == 'Customer' && jobview.userId != null) {
                    if (jobview.userId != null && jobview.userId != '') userNameCust.add(jobview.userId.toLowerCase());
                }
            }
            
            if (userName != null && userName.size() > 0) {
                
                for (User user: [select u.HCM_Login_ID__c,u.id from User u where u.HCM_Login_ID__c IN: userName]) {
                    
                    userNameMap.put(user.HCM_Login_ID__c.toUpperCase(), user.Id);
                    userNameFound.add(user.HCM_Login_ID__c.toLowerCase());
                }
            }
            
            userName.removeAll(userNameFound);
            
            if (userNameCust != null && userNameCust.size() > 0) {
                
                for (User user: [Select u.HCM_Login_ID__c, u.FederationIdentifier, u.Id From User u where u.FederationIdentifier IN: userNameCust]) {
                    userNameMap.put(user.FederationIdentifier, user.Id);
                    userNameCustFound.add(user.FederationIdentifier.toLowerCase());
                }
            }
            
            userNameCust.removeAll(userNameCustFound);
            
            for (Jobviewer jobview: ptrfData[0].jobviewers) {
                
                if (jobview.userId != null && jobview.userId != '') {
                    
                    if (userNameCust.contains(jobview.userId.toLowerCase())) { jvHCM_email.put(jobview.userId, jobview.emailAddress); }
                    
                    if (userName.contains(jobview.userId.toLowerCase())) { jvHCM_email.put(jobview.userId, jobview.emailAddress); }
                }
                
                jobviewExist = False;
                
                for (PTRF_JobViewer_Info__c ptrfJV: jobViewerList) {
                    
                    if (jobview.jobviewType != null && (jobview.jobviewType == ptrfJV.Jobview__c || (jobview.jobviewType == 'ProcessOwner' && ptrfJV.Jobview__c == 'Foundry'))) {
                
                        if (jobview.userId != null) {

                            if (ptrfJV.User__c != null && userNameMap.get(jobview.userId.toUpperCase()) == ptrfJV.User__c) {
                                
                                jobviewExist = True;
                                ptrfJV.Jobview_Type__c = '';
                                
                                if (jobview.MEBES) {
                                    
                                    if (ptrfJV.Jobview_Type__c != null && ptrfJV.Jobview_Type__c != '') {
                                        
                                        if (!ptrfJV.Jobview_Type__c.contains('MEBES Jobview')) { ptrfJV.Jobview_Type__c = ptrfJV.Jobview_Type__c + ';' + 'MEBES Jobview'; }
                                        
                                    } else ptrfJV.Jobview_Type__c = 'MEBES Jobview';
                                }
                                
                                if (jobview.GDSOUT) {
                                    
                                    if (ptrfJV.Jobview_Type__c != null && ptrfJV.Jobview_Type__c != '') {
                                        if (!ptrfJV.Jobview_Type__c.contains('Prime GDSOUT Review')) ptrfJV.Jobview_Type__c = ptrfJV.Jobview_Type__c + ';' + 'Prime GDSOUT Review';
                                    } else ptrfJV.Jobview_Type__c = 'Prime GDSOUT Review';
                                }
                                
                                if (jobview.frameMockup) {
                                    
                                    if (ptrfJV.Jobview_Type__c != null && ptrfJV.Jobview_Type__c != '') {
                                        if (!ptrfJV.Jobview_Type__c.contains('Frame Mockup')) ptrfJV.Jobview_Type__c = ptrfJV.Jobview_Type__c + ';' + 'Frame Mockup';
                                    } else ptrfJV.Jobview_Type__c = 'Frame Mockup';
                                }
                                
                                ptrfJV.Email_Address__c = jobview.emailAddress;
                                jobviewInfoList.add(ptrfJV);
                                ptrfJobviewInfoUpdateList.add(ptrfJV);
                            }
                        } else {
                            
                            if (jobview.userId == null) jvHCM_email.put(jobview.emailAddress, jobview.emailAddress);
                            
                            if (jobview.emailAddress == ptrfJV.Email_Address__c) {
                                
                                jobviewExist = True;
                                ptrfJV.Jobview_Type__c = '';
                                
                                if (jobview.MEBES) {
                                    
                                    if (ptrfJV.Jobview_Type__c != null && ptrfJV.Jobview_Type__c != '') {
                                        
                                        if (!ptrfJV.Jobview_Type__c.contains('MEBES Jobview')) { ptrfJV.Jobview_Type__c = ptrfJV.Jobview_Type__c + ';' + 'MEBES Jobview'; }
                                    } else ptrfJV.Jobview_Type__c = 'MEBES Jobview';
                                }
                                
                                if (jobview.GDSOUT) {
                                    
                                    if (ptrfJV.Jobview_Type__c != null && ptrfJV.Jobview_Type__c != '') {
                                        if (!ptrfJV.Jobview_Type__c.contains('Prime GDSOUT Review')) ptrfJV.Jobview_Type__c = ptrfJV.Jobview_Type__c + ';' + 'Prime GDSOUT Review';
                                    } else ptrfJV.Jobview_Type__c = 'Prime GDSOUT Review';
                                }
                                
                                if (jobview.frameMockup) {
                                    
                                    if (ptrfJV.Jobview_Type__c != null && ptrfJV.Jobview_Type__c != '') {
                                        if (!ptrfJV.Jobview_Type__c.contains('Frame Mockup')) ptrfJV.Jobview_Type__c = ptrfJV.Jobview_Type__c + ';' + 'Frame Mockup';
                                    } else ptrfJV.Jobview_Type__c = 'Frame Mockup';
                                }
                                
                                jobviewInfoList.add(ptrfJV);
                                ptrfJobviewInfoUpdateList.add(ptrfJV);
                            }
                        }
                    }
                }
                
                if (!jobviewExist) {
                    
                    if (jobview.userId == null || jobview.userId == '') jvHCM_email.put(jobview.emailAddress, jobview.emailAddress);
                    
                    PTRF_JobViewer_Info__c ptrfJobViewerInfo = new PTRF_JobViewer_Info__c();
                    ptrfJobViewerInfo.Email_Address__c = jobview.emailAddress;
                
                    if (jobview.jobviewType == 'ProcessOwner') ptrfJobViewerInfo.Jobview__c = 'Foundry';
                    else ptrfJobViewerInfo.Jobview__c = jobview.jobviewType;
                    
                    if (jobview.frameMockup) { ptrfJobViewerInfo.Jobview_Type__c = 'Frame Mockup'; }
                    
                    if (jobview.GDSOUT) {
                        if (ptrfJobViewerInfo.Jobview_Type__c != null) ptrfJobViewerInfo.Jobview_Type__c = ptrfJobViewerInfo.Jobview_Type__c + ';' + 'Prime GDSOUT Review';
                        else ptrfJobViewerInfo.Jobview_Type__c = 'Prime GDSOUT Review';
                    }
                    
                    if (jobview.MEBES) {
                        if (ptrfJobViewerInfo.Jobview_Type__c != null) ptrfJobViewerInfo.Jobview_Type__c = ptrfJobViewerInfo.Jobview_Type__c + ';' + 'MEBES Jobview';
                        else ptrfJobViewerInfo.Jobview_Type__c = 'MEBES Jobview';
                    }
                    
                    ptrfJobViewerInfo.PTRF__c = ptrfInsList[0].id;
                    
                    if (userNameMap.keySet() != null && userNameMap.keySet().size() > 0 && jobview.userId != null && jobview.userId != '') { //
                        if (jobview.jobviewType == 'ProcessOwner' && userNameMap.keySet().contains(jobview.userId.toUpperCase())) ptrfJobViewerInfo.User__c = userNameMap.get(jobview.userId.toUpperCase());
                        if (jobview.jobviewType == 'Customer' && userNameMap.keySet().contains(jobview.userId)) { ptrfJobViewerInfo.User__c = userNameMap.get(jobview.userId); }
                    }
                    
                    ptrfJobviewInfoList.add(ptrfJobViewerInfo); //
                    jobviewInfoList.add(ptrfJobViewerInfo);
                }
            }

            //remove the jobview from the ptrf
            for (PTRF_JobViewer_Info__c ptrfJV: jobViewerList) { if (jobviewInfoList.contains(ptrfJV)) {} else { jobInfoDeleteList.add(ptrfJV); } }
            
            try {
                if (jobInfoDeleteList != null && jobInfoDeleteList.size() > 0) { delete jobInfoDeleteList; }
                
                if (ptrfJobviewInfoList != null && ptrfJobviewInfoList.size() > 0) { insert ptrfJobviewInfoList; }
                
                if (ptrfJobviewInfoUpdateList != null && ptrfJobviewInfoUpdateList.size() > 0) { update ptrfJobviewInfoUpdateList; }
                
                calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrfNumber, 'SUCCESS', '');
            } catch (DMLException e) { calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrfNumber, 'ERROR', e.getMessage()); }
            catch (Exception e) { calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrfNumber, 'ERROR', e.getMessage()); }
            
            if (jvHCM_email.keySet().size() > 0) sendMail(ptrfData[0].ptrfNumber, jvHCM_email);
        }
        //Send Error Message for PTRF not existing
        else {
            MRSdotNETResponseCalloutService.SwiftMRSPTRFSyncResponseService_pt stub = new MRSdotNETResponseCalloutService.SwiftMRSPTRFSyncResponseService_pt();
            calloutResponse(ptrfData[0].messageID, ptrfData[0].ptrfNumber, 'ERROR', 'PTRF Number does not exist.');
        }
    }

    public static string getCustomSettingData(String custSettingName) {
        map < String, Environment_Variable__c > customSettingMap = new map < String, Environment_Variable__c > ();
        customSettingMap = Environment_Variable__c.getAll();
        Environment_Variable__c environmentVariable = customSettingMap.get(custSettingName);
        return environmentVariable.Value__c;
    }

    public static ResponseData serviceResponse(string messageId, string ptrfNumber, string status, string errorMessage) {
        ResponseData responseData = new ResponseData();
        responseData.messageId = messageId;
        responseData.ptrfNumber = ptrfNumber;
        responseData.status = status;
        if (status == 'ERROR') { responseData.errorMessage = errorMessage; }
        return responseData;
    }
    
    @future(callout = TRUE)
    public static void calloutResponse(String messageId, String ptrfNumber, String status, String errorMessage) {
        
        if (!Test.isRunningTest()) {
            MRSdotNETResponseCalloutService.SwiftMRSPTRFSyncResponseService_pt stub = new MRSdotNETResponseCalloutService.SwiftMRSPTRFSyncResponseService_pt();
            //Including SSL Certificate      
            String certificate = Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE').value__c;
            if (certificate != NULL && certificate != 'NO') { stub.clientCertName_x = certificate; }
            stub.SwiftMRSPTRFSyncResponse(messageId, ptrfNumber, status, errorMessage);
        }
    }
    
    public static void sendMail(string ptrfNumber, map < string, string > jvHCM_EmailMap) {
        
        string[] Addresses = new string[] {};
        
        if (Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.contains(';')) {
            Addresses.addAll(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.split(';'));
        } else {
            Addresses.add(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c);
        }
        
        string bodyPart3; 
        string bodyPart2;
        Boolean part3 = false;
        Boolean part2 = false;
        
        if (!jvHCM_EmailMap.isEmpty()) {
            
            for (string hcmId: jvHCM_EmailMap.keySet()) {
                
                if (hcmId != jvHCM_EmailMap.get(hcmId)) {
                    
                    part2 = true;
                    
                    if (bodyPart2 != null) {
                        if (hcmId == null && jvHCM_EmailMap.get(hcmId) == null) bodyPart2 += 'UserId : ' + '' + ' & Email Address : ' + '' + ';' + '\n';
                        else if (hcmId == null) bodyPart2 += 'UserId : ' + '' + ' Email Address : ' + jvHCM_EmailMap.get(hcmId) + ';' + '\n';
                        else if (jvHCM_EmailMap.get(hcmId) == null) bodyPart2 += 'UserId : ' + hcmId + ' & Email Address : ' + '' + ';' + '\n';
                        else bodyPart2 += 'UserId : ' + hcmId + ' & Email Address : ' + jvHCM_EmailMap.get(hcmId) + ';' + '\n';
                    } else {
                        if (hcmId == null && jvHCM_EmailMap.get(hcmId) == null) bodyPart2 = 'UserId :' + hcmId + ' & Email Address : ' + jvHCM_EmailMap.get(hcmId) + ';' + '\n';
                        else if (hcmId == null) bodyPart2 = 'UserId :' + '' + '& Email Address : ' + jvHCM_EmailMap.get(hcmId) + ';' + '\n';
                        else if (jvHCM_EmailMap.get(hcmId) == null) bodyPart2 = 'UserId :' + hcmId + ' & Email Address : ' + '' + ';' + '\n';
                        else bodyPart2 = 'UserId :' + hcmId + ' & Email Address : ' + jvHCM_EmailMap.get(hcmId) + ';' + '\n';
                    }
                } else {
                    part3 = true;
                    if (bodyPart3 != null) bodyPart3 += 'UserId : Blank Value & Email Address : ' + hcmId + ';' + '\n';
                    else bodyPart3 = 'UserId : Blank Value & Email Address : ' + hcmId + ';' + '\n';
                }

            }
        }

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(Addresses);

        EmailTemplate etCAD_AllService = [select id, Name, Subject, Body from EmailTemplate where DeveloperName = 'SWIFT_DotNet_JobviewerNotFound' limit 1];
        string subject = etCAD_AllService.subject;
        string textValue = etCAD_AllService.Body;
        mail.setSubject(subject);         
        textValue = textValue.replace('<PTRFNumber>', 'PTRF NUMBER : ' + ptrfNumber);//textValue = textValue.replace('<MRS.Chip Name>','');

        if (Part2) textValue = textValue.replace('<User Id:Email Address>', bodyPart2);
        else textValue = textValue.replace('<User Id:Email Address>', '');
        if (Part3) textValue = textValue.replace('<EmailAddress>', bodyPart3);
        else textValue = textValue.replace('<EmailAddress>', '');
        mail.setPlainTextBody(textValue);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    public static void sendMail(String e, String ptrfNumber) {
        
        try {
            string ptrfNum = 'PTRF Number = ' + ptrfNumber + '\n';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {};
            if (Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.contains(';')) { toAddresses.addAll(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.split(';')); } else { toAddresses.add(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c); }
            mail.setToAddresses(toAddresses);
            mail.setSubject('PTRF Perfrom Tapeout Option Status Error Out in Org : ' + UserInfo.getOrganizationName());
            mail.setPlainTextBody(ptrfNum + e);
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch (exception exp) {}
    }

    public static void saveErrorLog(Exception e, string objectName, string messageId, string integrationPayload) {
        
        list < SWIFTcustomLogUtility.customLogClass > lstlog = new list < SWIFTcustomLogUtility.customLogClass > ();
        SWIFTcustomLogUtility.customLogClass log = new SWIFTcustomLogUtility.customLogClass();
        log.debugLevel = 'ERROR';
        log.componentName = 'PTRF DotNetService';
        log.ComponentID = [select id from apexclass where name = 'PTRF_DotNetService'].id;
        log.errorMessage = objectName + ':' + e.getmessage();
        log.stackTrace = e.getstacktracestring();
        log.messageID = messageId;
        log.method = 'PTRF_DotNetService';
        log.integrationPayload = integrationPayload;
        lstLog.add(log);
        try { SWIFTcustomLogUtility.saveCustomLog(lstLog); } catch (exception excptn) {}
    }

    /*
     * @description      - Log validation error
     *                   - Log all incoming message and respone message if debug mode is ON
     * @param errorMsg   - Validation error message
     *                   - OR: response message if debug mode is on
     * @param debugLevel     DEBUG | ERROR 
     *        msg original request message
     * @return 
     */
    public static void logValidationError(String wsMsg, String errorMsg, String msgId, String className, String methodName, String debugLevel, String ptrfNumber) {
        
        // wsMsg is JSON format
        if (wsMsg.length() > 32000) wsMsg = wsMsg.subString(0, 32000);
        if (errorMsg.length() > 32000) errorMsg = errorMsg.subString(0, 32000);

        SWIFT_Application_Log__c log = new SWIFT_Application_Log__c(
        Debug_Level__c = debugLevel, Apex_Component_Name__c = className, Method__c = methodName,
        Integration_Payload__c = wsMsg, Stack_Trace__c = errorMsg, Error_Message__c = '',
        Message_ID__c = msgId + ' | ' + ptrfNumber);

        insert log;
    }
    
    /****************************************************************************\
    |*****************************************************************************| 
    |** Summary                                                                 **|
    |** SWGP-882: [PTRF WS] PTRF Layer Chip Deselection                         **|
    |** SWNG-4671: SWNG-4671 PTRF Layer Chip Deselection                        **|
    |** ----------------------------------------------------------------------- **|
    |** Description                                                             **|
    |** PTRF-AIA-MRS Integration on Deselect Layer Chip.                        **|
    |** PTRF will call MRS's web service to cancel layer chip in MRS.           **|
    |** ----------------------------------------------------------------------- **|
    |** As a user, I want MRS to take in deselection signal at                  **|
    |** layer chip level which will be sent from .NET PTRF (source system).     **|
    |** + New deselect ws at MRS.                                               **|
    |** + Data will be at layer chip level.                                     **|
    |** ----------------------------------------------------------------------- **|
    |** All code below this snippet will be related to this new integration.    **|
    |*****************************************************************************|   
    \****************************************************************************/
    //postpone after SWGP-884
    
    //CREATED: PTRF_DotNetServiceHandler
    /*
    global class DeselectLayerChip {
        webservice string transactionId;
        webservice string transactionStatus;
        //-------------------------------------------------
        webservice string ptrfNumber;
        webservice list <LayerChip> layerChipList;
        webservice string deselectedReason;
        webservice string deselectedBy;//user login ID
        webservice datetime timestamp;//time when ws is sent
    }
    
    global class LayerChip {
        webservice string layerChipStatus;//case insensitive
        webservice string layerChipErrorMsg;//case insensitive
        //-------------------------------------------------
        webservice string chipName;//case insensitive
        webservice string layerNumber;//case insensitive
        webservice string LayerRevision;//case insensitive
    }
    
    webservice static DeselectLayerChip deselectLayerChip(DeselectLayerChip msgData) {
        return null;
        //PTRF_DotNetServiceHandler.fetch().deseletLayerChip(msgData);
        //return new DeselectLayerChip();
    }
    */
    //=================================================================================
}