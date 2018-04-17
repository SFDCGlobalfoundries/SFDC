/*
    Author: Mallika Seth
    Description: This trigger for Pairing table to update MPRF number on Mask set title records.
    History: 
        MSeth      13112015    - Code creation.
*/  
trigger PairingTableTrigger on Pairing_Table__c (After Insert, After Update) {
if(!IntegrationUserUtil.isSkipTrigger()){
        
        Boolean isIntegrationUser = false;
        IntegrationUsers__c setting = IntegrationUsers__c.getValues(userInfo.getUserId());   
Map<String, Pairing_Table__c> PairingTableMap = new Map<String, Pairing_Table__c>(); 
Set<String> setMaskTitle= new Set<String>();
Set<String> setPairingTable= new Set<String>();
List<Mask_Set_Title__c> lstMaskSetTitle = new List<Mask_Set_Title__c>();
List<Mask_Set_Title__c> lstMSTUpdate = new List<Mask_Set_Title__c>();
List<Pairing_Table__c> lstPairingTable = new List<Pairing_Table__c>();
    // list of Pairing table records in Trigger.new
    for (Pairing_Table__c PT : trigger.New) {
         PairingTableMap.put(PT.Mask_Set_Title_Text__c, PT );
 
    }
    // List of mask set title records matching in Pairing table trigger.new
    for(Mask_Set_Title__c mst: [SELECT Name,Reticle_Type__c,MPRF__c FROM Mask_Set_Title__c WHERE Name In: PairingTableMap.KeySet() ]){
            setMaskTitle.add(mst.name);
            lstMaskSetTitle.add(mst);
    }
    // List of Pairing table from existing records in system
    for(Pairing_Table__c PairingTable: [SELECT ID,Name,PRF_Number__c,Mask_Set_Title_Text__c FROM Pairing_Table__c WHERE Mask_Set_Title_Text__c In: PairingTableMap.KeySet() ]){
            setPairingTable.add(PairingTable.Mask_Set_Title_Text__c);
            lstPairingTable.add(PairingTable);
    }

    // comparing largest MPRF number from existing pairing table records of same mask set title and new records in trigger.new
    for (Pairing_Table__c PT : trigger.New) {
     For(Mask_Set_Title__c lstMST: lstMaskSetTitle){
        if(lstMST.name == PT.Mask_Set_Title_Text__c){
         if(setPairingTable!= Null && setPairingTable.contains(PT.Mask_Set_Title_Text__c)){
                For(Pairing_Table__c lstPT : lstPairingTable ) {
                    if(lstPT.Mask_Set_Title_Text__c == PT.Mask_Set_Title_Text__c && lstPT.ID != PT.ID){
                        if(PT.PRF_Number__c >= lstPT.PRF_Number__c){
                         lstMST.MPRF__c = PT.PRF_Number__c;
                         
                        }
                        Else{
                            lstMST.MPRF__c = lstPT.PRF_Number__c;
                        }   
                        
                   
                    }
                }
                lstMSTUpdate.add(lstMST); 
                            }
          Else if(setPairingTable== Null || setPairingTable.size()==0) {
          lstMST.MPRF__c = PT.PRF_Number__c;
          lstMSTUpdate.add(lstMST); 
          
         }                   
        }
      }
    }
    // Updating MPRF number on mask set title.
    if (lstMSTUpdate.size() > 0) {
        update lstMSTUpdate;
   }
  }  
}