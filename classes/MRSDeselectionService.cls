/*
SWGP-882: [PTRF WS] PTRF Layer Chip Deselection
Test class is:
- MRSDeselectionServiceTest
*/
global class MRSDeselectionService {
    
    global class Notification {
        webservice String messageId;//required
        webservice String ptrfNumber;//required
        webservice List<LayerChip> layerChipList;//required
        webservice List<PTRFMaskLayer> ptrfMaskLayerList;//optional
        webservice List<PTRFChip> ptrfChipList;//optional
        webservice DateTime timeStamp;//required
    }
    
    global class LayerChip {
        webservice Integer no;//required
        webservice String sfdcId;//optional
        webservice String layerNumber;//required
        webservice String revision;//required
        webservice String chipName;//required
        webservice String romCode;//required
    }
    
    global class PTRFMaskLayer {
        webservice Integer no;//required
        webservice String layerNumber;//required
        webservice String revision;//required
        webservice String romCode;//optional
    }
    
    global class PTRFChip {
        webservice Integer no;//required
        webservice String chipName;//required
        webservice String chipType;//required
    }
    
    //response unhandled error to AIA/PTRF @ catch statement
    webservice static String notification(Notification msg) {
        
        //swgp-1109 : On/Off Switches for MRS/DRT
        Environment_Variable__c env = Environment_Variable__c.getInstance('SWIFT_SWITCH_PTRF_DESELECTION');
        if(null != env && env.value__c != 'ON') {
            Error_Codes__c errCode = Error_Codes__c.getInstance('MRS_SERVICE_DOWN_503');
            if(null != errCode) throw new MRSWebserviceException(errCode.message__c);
            else throw new MRSWebserviceException('We are sorry!!! 503 Service Unavailable. The server is currently unavailable (because it is overloaded or down for maintenance).');
        }
        //======================================================= 
        
        String response = '';
        try { 
            return MRSDeselectionServiceHandler.fetchInstance(msg).processWs();
        } catch(Exception e)  {
            String responseText = 'error: ' + e.getMessage() + ' # ' + e.getStackTraceString();//this text will be return to AIA
            
            //catch concurrency: unable to lock row issue for retrying
            boolean isLockError = false;
            Error_Codes__c lockErr = Error_Codes__c.getInstance('MRS_LOCK_EXCEPTION');
            if(null != lockErr) isLockError = e.getMessage().containsIgnoreCase(lockErr.message__c);
            else isLockError = e.getMessage().containsIgnoreCase('unable to obtain exclusive access');
            if(isLockError) MRSDeselectionUtils.logUnhandledException(e, json.serialize(msg), msg.messageId, 'MRSDeselectionService', 'notification', msg.ptrfNumber, responseText);
            
            //catch unhandled exception
            if(null != msg) MRSDeselectionUtils.logUnhandledException(e, json.serialize(msg), msg.messageId, 'MRSDeselectionService', 'notification', msg.ptrfNumber, responseText);
            else MRSDeselectionUtils.logUnhandledException(e, '<uncatchable_error>', 'uncatchable_error', 'MRSDeselectionService', 'notification', '<uncatchable_error>', responseText);
            
            return responseText; 
        }
    }
}