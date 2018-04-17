/*
Author: Bhavana Mohan
Company: Cognizant
Description: MRS CAD Integration Webservice
History:
created     27/3/2014
-----------------------------------------------------
All original codes by Cognizant were removed and replaced by MRSCADGeneralService 
except for the interface (data structure e.g. MRSDataRecievedOnLayerGeneration, MRSDataRecievedOnSendPrimeData, etc. )

History:
- Original ws disabled on Sep-2015
- Original ws removed completely Mar-2017

Swift Team, 2017.
*/
global class MRS_CADService {
    
    public static list < MSTPtrfChipLayer > mstPtrfChipLayerList;
    public static set < string > ptrfNumberSet;
    public static set < string > chipNameSet;
    public static map < string, string > layerNameRevMap;
    public static list < MSTPtrfChipLayer > NotExistingChipLayerList = new list < MSTPtrfChipLayer > ();
    public static list < MSTPtrfChipLayer > existingChipLayerList = new list < MSTPtrfChipLayer > ();
    public static MRSCADResponseCalloutService.transactionStatus[] transactionInfo = new list < MRSCADResponseCalloutService.transactionStatus > ();
    public static MRSCADResponseCalloutService.transactionStatus[] transactionInfoValidated = new list < MRSCADResponseCalloutService.transactionStatus > ();
    public static String LEVEL_DEBUG    = 'DEBUG';
    public static String LEVEL_ERROR    = 'ERROR';
    public static String METHOD_NAME;

    global class MRSDataRecievedOnLayerGeneration {
        webservice string messageID;
        webservice string maskSetTitle;
        webservice list < PTRFData > ptrf;
        webservice string jobStatus;
        webservice dateTime sourceInboundRequestTimestamp;
        webservice string additionalEmailContent; // for sync_Layer_Generation_Job_Completion method
        webservice string additionalEmailContent_customer;//SWGP-805    
    }
    global class MRSDataRecievedOnSendPrimeData {
        webservice string messageID;
        webservice string maskSetTitle;
        webservice list < PTRFData > ptrf;
        webservice string jobStatus;
        webservice dateTime sourceInboundRequestTimestamp;
        webservice Boolean reTapeoutFlag; // for sync_Send_Prime_Data_Job_Completion ,sync_Send_Frame_Data_Job_Completion  method
    }

    global class MRSDataRecievedOnSendFrameData {
        webservice string messageID;
        webservice string maskSetTitle;
        webservice list < PTRFData > ptrf;
        webservice string jobStatus;
        webservice dateTime sourceInboundRequestTimestamp;
        webservice Boolean reTapeoutFlag; // for sync_Send_Prime_Data_Job_Completion ,sync_Send_Frame_Data_Job_Completion  method
    }
    
    // for sync_Send_Prime_Data_Job_Completion ,sync_Send_Frame_Data_Job_Completion  method
    global class MRSDataRecievedOnSendData {
        webservice string messageID;
        webservice string maskSetTitle;
        webservice list < PTRFData > ptrf;
        webservice string jobStatus;
        webservice dateTime sourceInboundRequestTimestamp;
        webservice Boolean reTapeoutFlag;
    }

    global class MRSDataRecievedOnSyncRemoteJobView {
        webservice string messageID;
        webservice string maskSetTitle;
        webservice dateTime sourceInboundRequestTimestamp;
        webservice list < JobViewData > jobView; // for sync_Remote_Jobview_Setup_Ready method               
        
    }

    global class MRSDataRecievedOnSyncMEBESReceive {
        webservice string messageID;
        webservice string maskSetTitle;
        webservice dateTime sourceInboundRequestTimestamp;
        webservice list < JobDeckData > jobdecks; // for sync_Remote_Jobview_Setup_Ready , sync_Receive_MEBES_Data_from_Maskshop method
        webservice string jobViewRemarks;
        webservice list < PTRFData > ptrf;
        webservice Boolean customerJobViewAtFoundry;
    }

    global class MRSDataRecievedOnORCNStatusChange {
        webservice string messageID;
        webservice string maskSetTitle;
        webservice list < PTRFData > ptrf;
        webservice dateTime sourceInboundRequestTimestamp;
    }

    global class PTRFData {
        webservice string ptrfNumber;
        webservice string technology;
        webservice list < ChipData > chip;
    }

    global class JobViewData {
        webservice string jobViewGroup;
        webservice string jobViewType;
        webservice string jobViewRemarks;
        webservice list < JobDeckData > jobDecks;
        webservice string emailToList;
        webservice list < PTRFData > ptrf;
    }

    global class JobDeckData {
        webservice string jobDeck;
    }

    global class ChipData {
        webservice string chipName;
        webservice string chipType;
        webservice list < LayerData > layer;
    }


    global class LayerData {
        webservice string maskLayer;
        webservice string maskRev;
        webservice Boolean resetFlag;
        webservice string jobStatus;
    }

    public class MSTPtrfChipLayer {
        public string messageId;
        public string mst;
        public string ptrfNumber;
        public string chipName;
        public string chipType;
        public string layer;
        public string rev;
        public string jobviewGroup;
        public string jobviewType;
        public string jobDeck;
        public string jobStatus;
        public Boolean resetFlag;
        public boolean customerJobViewAtFoundry;
        public dateTime sourceInboundRequestTimestamp;
        public string errormessage;
        public string status;
        public string transactErrormessage;
        public string transactStatus;
        
        public MSTPtrfChipLayer(){
            messageId       = '';
            mst             = '';
            ptrfNumber      = '';
            chipName        = '';
            chipType        = '';
            layer           = '';
            rev             = '';
        }
    }
    
    //swgp-1109
    public static boolean isServiceAvailable() {
        Environment_Variable__c env = Environment_Variable__c.getInstance('SWIFT_SWITCH_CAD_WS');
        if(null == env) return true;//if cannot find config value >>> service always ON
        if(env.value__c == 'ON') return true;//service is on
        return false;//service is off
    }

    /*
    LG WS
    */
    webservice static void sync_Layer_Generation_Job_Completion(list < MRSDataRecievedOnLayerGeneration > mrsData) {
        //swgp-1109
        if(!isServiceAvailable()) throw new MRSWebserviceException('We are sorry!!! 503 Service Unavailable. The server is currently unavailable (because it is overloaded or down for maintenance).');
        
        MRSDataRecievedOnLayerGeneration d = (mrsData!=null && !mrsData.isEmpty()) ? mrsData.get(0) : new MRSDataRecievedOnLayerGeneration();           
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_LG).handleRequest( JSON.serialize( d ) );
    }
    
    /*
    SEND DATA WS
    */
    webservice static void sync_Send_Prime_Data_Job_Completion(list < MRSDataRecievedOnSendPrimeData > mrsData) {
        //swgp-1109
        if(!isServiceAvailable()) throw new MRSWebserviceException('We are sorry!!! 503 Service Unavailable. The server is currently unavailable (because it is overloaded or down for maintenance).');
        
        MRSDataRecievedOnSendPrimeData d = (mrsData!=null && !mrsData.isEmpty())? mrsData.get(0): new MRSDataRecievedOnSendPrimeData();
        String msgJson = json.serialize( d );//change send prime data type to common type which use for both prime/frame
        MRS_CADService.MRSDataRecievedOnSendData requestMsg = (MRS_CADService.MRSDataRecievedOnSendData)JSON.deserialize(msgJson, MRS_CADService.MRSDataRecievedOnSendData.class);        
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_SEND_DATA).handleRequest( JSON.serialize( requestMsg ) );
    }
    
    /*
    SEND DATA WS
    */
    webservice static void sync_Send_Frame_Data_Job_Completion(list < MRSDataRecievedOnSendFrameData > mrsData) {
        //swgp-1109
        if(!isServiceAvailable()) throw new MRSWebserviceException('We are sorry!!! 503 Service Unavailable. The server is currently unavailable (because it is overloaded or down for maintenance).');
        
        MRSDataRecievedOnSendFrameData d = (mrsData!=null && !mrsData.isEmpty())? mrsData.get(0): new MRSDataRecievedOnSendFrameData();
        String msgJson = json.serialize( d );//change send frame data type to common type which use for both prime/frame
        MRS_CADService.MRSDataRecievedOnSendData requestMsg = (MRS_CADService.MRSDataRecievedOnSendData)JSON.deserialize(msgJson, MRS_CADService.MRSDataRecievedOnSendData.class);
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_SEND_DATA).handleRequest( JSON.serialize( requestMsg ) );
    }
    
    /*
    RJV WS
    */
    webservice static void sync_Remote_Jobview_Setup_Ready(list < MRSDataRecievedOnSyncRemoteJobView > mrsData) {
        //swgp-1109
        if(!isServiceAvailable()) throw new MRSWebserviceException('We are sorry!!! 503 Service Unavailable. The server is currently unavailable (because it is overloaded or down for maintenance).');
        
        MRSDataRecievedOnSyncRemoteJobView d = (mrsData!=null && !mrsData.isEmpty())? mrsData.get(0): new MRSDataRecievedOnSyncRemoteJobView();
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_REMOTE_JOBVIEW).handleRequest( JSON.serialize( d ) );
    }

    /*
    MEBES Received WS
    */
    webservice static void sync_Receive_MEBES_Data_from_Maskshop(list < MRSDataRecievedOnSyncMEBESReceive > mrsData) {
        //swgp-1109
        if(!isServiceAvailable()) throw new MRSWebserviceException('We are sorry!!! 503 Service Unavailable. The server is currently unavailable (because it is overloaded or down for maintenance).');
        
        MRSDataRecievedOnSyncMEBESReceive d = (mrsData!=null && !mrsData.isEmpty())? mrsData.get(0): new MRSDataRecievedOnSyncMEBESReceive();
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_MEBES_RECEIVED).handleRequest( JSON.serialize( d ) );
    }
    
    /*
    ORC WS
    */
    webservice static void sync_ORCN_Job_Status_Change(list < MRSDataRecievedOnORCNStatusChange > mrsData) {
        //swgp-1109
        if(!isServiceAvailable()) throw new MRSWebserviceException('We are sorry!!! 503 Service Unavailable. The server is currently unavailable (because it is overloaded or down for maintenance).');
        
        MRSDataRecievedOnORCNStatusChange d = (mrsData!=null && !mrsData.isEmpty()) ? mrsData.get(0) : new MRSDataRecievedOnORCNStatusChange();         
        MRSCADGeneralService.fetchService(MRSCADGeneralService.WS_ORC).handleRequest( JSON.serialize( d ) );
    }

    public static void sendMailLayerChip(map<string, list<string>> mapchipsMissing, map<string, list<string>> maplayersMissing, string messageid, string MST, datetime requestTime, string subjectAdd) {
        
        try {
            string[] swiftAdmn = new String[] {};
            string bodyPart3 = '';
            string bodyPart4 = '';
            string bodyPart34 = '';
            string bodyPart45 = '';

            if (Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.contains(';')) {
                swiftAdmn.addAll(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.split(';'));
            } else {
                swiftAdmn.add(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c);
            }
            
            if (Environment_Variable__c.getInstance('SWIFT_CAD_EMAIL').Value__c.contains(';')) {
                swiftAdmn.addAll(Environment_Variable__c.getInstance('SWIFT_CAD_EMAIL').Value__c.split(';'));
            } else {
                swiftAdmn.add(Environment_Variable__c.getInstance('SWIFT_CAD_EMAIL').Value__c);
            }

            if (mapchipsMissing != null && !mapchipsMissing.keyset().isEmpty()) {
                
                for (string ptrf: mapchipsMissing.keyset()) {
                    bodyPart3 = ptrf;
                    if (mapchipsMissing.get(ptrf).size() > 0) {
                        for (string chip: mapchipsMissing.get(ptrf)) {
                            if (bodyPart34 == '' || bodyPart34 == null) {
                                bodyPart34 = chip + ';';
                            } else {
                                bodyPart34 += chip + ';';
                            }
                        }
                    }
                }
            }
            
            if (maplayersMissing != null && !maplayersMissing.keyset().isEmpty()) {
                
                for (string ptrf: maplayersMissing.keyset()) {
                    bodyPart3 = ptrf;

                    if (!maplayersMissing.keyset().isEmpty() && maplayersMissing.get(ptrf).size() > 0) {
                        for (string layer: maplayersMissing.get(ptrf)) {
                            if (bodyPart45 == '' || bodyPart45 == null) {
                                bodyPart45 = layer + ';';
                            } else {
                                bodyPart45 += layer + ';';
                            }
                        }
                    }
                }
            }

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(swiftAdmn);

            EmailTemplate etCAD_AllService = [select id, Name, Subject, Body from EmailTemplate where DeveloperName = 'SWIFT_CAD_Missing_Layer_Chip' limit 1];
            string subject = etCAD_AllService.subject;
            string textValue = etCAD_AllService.Body;
            subject = subject.replace('<CAD.Service>', subjectAdd);
            mail.setSubject(subject);

            if (mapchipsMissing.keyset().size() > 0 && mapchipsMissing.keyset() != null) textValue = textValue.replace('<MRS.Chip Name>', bodyPart34);
            else textValue = textValue.replace('<MRS.Chip Name>', '');
            
            textValue = textValue.replace('<CAD.Service>', subjectAdd);
            textValue = textValue.replace('<messageid>', messageid);
            textValue = textValue.replace('<mst>', MST);
            
            if (requestTime != null) textValue = textValue.replace('<timestamp>', string.valueOf(requestTime.addHours(-8)));
            else textValue = textValue.replace('<timestamp>', '');
            
            textValue = textValue.replace('<ptrf>', bodyPart3);

            if (maplayersMissing.keyset().size() > 0 && maplayersMissing.keyset() != null) textValue = textValue.replace('<MRS.Mask Layer>', bodyPart45);
            else textValue = textValue.replace('<MRS.Mask Layer>', '');
            
            mail.setPlainTextBody(textValue);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch (exception e) {}
    }
}