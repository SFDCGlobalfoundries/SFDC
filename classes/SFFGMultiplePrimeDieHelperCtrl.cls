/**
* Author: Devendra Babu Itraju
* Company: GF
* Project: Standard Foundry Frame Generation 
* Description: 
*  
*  
* History:
*    <Devendra Babu Itraju> 2016-03-10 - Created
**/
public without sharing class SFFGMultiplePrimeDieHelperCtrl {
    public static List<SFFG_CreatePrimeDieCtrl.primeDieWrapper> addNewRow(List<SFFG_CreatePrimeDieCtrl.primeDieWrapper> pdWrapList){
        SFFG_CreatePrimeDieCtrl.primeDieWrapper newRecord = new SFFG_CreatePrimeDieCtrl.primeDieWrapper();
        SFFG_Prime_Die__c primeDie = new SFFG_Prime_Die__c();        
        newRecord.record = primeDie;
        newRecord.index = pdWrapList.size();
        pdWrapList.add(newRecord);
        return pdWrapList;
    }
    
     public static List<SFFG_CreatePrimeDieCtrl.primeDieWrapper> removeRow(Integer rowToRemove, List<SFFG_CreatePrimeDieCtrl.primeDieWrapper> pdWrapList){
        SFFG_Prime_Die__c primeDie = new SFFG_Prime_Die__c();        
        primeDie = pdWrapList.get(rowToRemove).record;
        pdWrapList.remove(rowToRemove);
        delete primedie;
        return pdWrapList;
    }
    
   
    public static void save(List<SFFG_CreatePrimeDieCtrl.primeDieWrapper> pdWrapList,id frameId) {
    	
        List<SFFG_Prime_Die__c> primeDieListToInsert = new List<SFFG_Prime_Die__c>();
        if(pdWrapList !=null && !pdWrapList.isEmpty()){
            for(SFFG_CreatePrimeDieCtrl.primeDieWrapper primeDie : pdWrapList ){
                SFFG_Prime_Die__c accTemp = primeDie.record;
                accTemp.Standard_Foundry_Frame__c =frameId;
                primeDieListToInsert.add(accTemp);
               
            }
            Upsert primeDieListToInsert;
        }
    }
}