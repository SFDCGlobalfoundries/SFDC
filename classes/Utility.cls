/*
    Author: Zymark Ambat
    Description: This serves as a helper/utility class.
    History: 
        ZAmbat      02272013    - Code creation.
        ZAmbat		08272014	- Updated code to generate Id for Opportunity.Siebel_Opportunity_Id__c.
*/
public class Utility {
    // Returns the latest available CRMDID
    public static String generateNewCRMDID() {
        CRMDID__c crmdid = CRMDID__c.getInstance('CRMDID_No');
        Integer seqNo = Integer.valueOf(crmdid.CRMDID_No__c);
        
        String newId = 'CDID' + String.valueOf(seqNo).leftPad(7).replace(' ', '0') + '.00';
        
        return newId;
    }
    
    // Updates the latest available sequence number by 1
    public static void updateCRMDIDSequenceNo() {
        CRMDID__c crmdid = CRMDID__c.getInstance('CRMDID_No');
        crmdid.CRMDID_No__c++;
        
        UPDATE crmdid;
    }
    
    // Generates new CRMDIDs for Device records
    public static Map<String, String> retrieveMapNewCRMDID(Map<String, String> mapDevice) {
        CRMDID__c crmdid = CRMDID__c.getInstance('CRMDID_No');
        Integer seqNo = Integer.valueOf(crmdid.CRMDID_No__c);
        
        Map<String, String> retMapDevice = new Map<String, String>();
        for (String s : mapDevice.keySet()) {
            String newId = 'CDID' + String.valueOf(seqNo).leftPad(7).replace(' ', '0') + '.00';
            retMapDevice.put(s, newId);
            
            seqNo++;
        }
        
        crmdid.CRMDID_No__c = seqNo;
        UPDATE crmdid;
        
        return retMapDevice;
    }
    
    // ZAmbat 08272014
    public static void generateSiebelOpportunityId(List<Opportunity> listOpportunity) {
   		integer seqNo = integer.valueOf(Environment_Variable__c.getInstance('SIEBEL_OPPTY_ID_SEQUENCE_NO').Value__c);
   		for (Opportunity o : listOpportunity) {
   			o.Siebel_Opportunity_Id__c = '1-OPP-' + string.valueOf(seqNo).leftPad(6).replace(' ', '0');
   			seqNo++;
   		}
   		
   		Environment_Variable__c.getInstance('SIEBEL_OPPTY_ID_SEQUENCE_NO').Value__c = string.valueOf(seqNo);
   		update Environment_Variable__c.getInstance('SIEBEL_OPPTY_ID_SEQUENCE_NO');
    }
	
	//Njain 08Jun16 Method to return the sorted ATP with PFAE on the top
    public static List<Account_Team_Proxy__c> getSortedFAE(List<Account_Team_Proxy__c> lstATP){
        List<Account_Team_Proxy__c> PrimaryFAE  = new List<Account_Team_Proxy__c>();
        List<Account_Team_Proxy__c> OtherFAE    = new List<Account_Team_Proxy__c>();
        List<Account_Team_Proxy__c> FinalFAE    = new List<Account_Team_Proxy__c>();
        for(Account_Team_Proxy__c atpRec: lstATP){
            if(atpRec.Team_Role__c == 'Primary Field Application Engineer'){
                PrimaryFAE.add(atpRec);
            }else{
                OtherFAE.add(atpRec);
            }
        }
        if(PrimaryFAE != NULL && !PrimaryFAE.isEmpty()){
            FinalFAE.addAll(PrimaryFAE);
        }
        if(OtherFAE != NULL && !OtherFAE.isEmpty()){
            FinalFAE.addAll(OtherFAE);
        }
        return FinalFAE;
    }
    
    //Njain 08Jun16 Method to return the sorted OPTM with PFAE on the top
    public static List<Opportunity_Program_Team_Member__c> getSortedOPTMforPFAE(List<Opportunity_Program_Team_Member__c> lstOPTM){
        List<Opportunity_Program_Team_Member__c> PrimaryFAE  = new List<Opportunity_Program_Team_Member__c>();
        List<Opportunity_Program_Team_Member__c> OtherFAE    = new List<Opportunity_Program_Team_Member__c>();
        List<Opportunity_Program_Team_Member__c> FinalFAE    = new List<Opportunity_Program_Team_Member__c>();
        for(Opportunity_Program_Team_Member__c atpRec: lstOPTM){
            if(atpRec.Team_Role__c == 'Primary Field Application Engineer'){
                PrimaryFAE.add(atpRec);
            }else{
                OtherFAE.add(atpRec);
            }
        }
        if(PrimaryFAE != NULL && !PrimaryFAE.isEmpty()){
            FinalFAE.addAll(PrimaryFAE);
        }
        if(OtherFAE != NULL && !OtherFAE.isEmpty()){
            FinalFAE.addAll(OtherFAE);
        }
        return FinalFAE;
    }
	// constants
     public static boolean CPK_ACCESS_LIST_TRIGGER_RUNNING = false;
}