/*
    Author: Zymark Ambat
    Description: This Class serves as the trigger for MPW_Train_Maintenance__c.
    History: 
        ZAmbat      08052014    - Code creation.
*/    

trigger MPWTrainMaintenanceTrigger on MPW_Train_Maintenance__c (Before Insert,Before Update,after update) {
    Set<Id> mpwIds = new Set<Id>();
    Set<Id> MSTIds = new Set<Id>(); 
    Map<String, MPW_Train_Maintenance__c> MPWTMMap = new Map<String, MPW_Train_Maintenance__c>(); 
    Map<String,Id> MapMST = new Map<String,Id>();
    Set<String> setMaskTitle= new Set<String>();
    List <Mask_Set_Title__c> MSTToInsert = new List <Mask_Set_Title__c>();
    List <Mask_Set_Title__c> MSTToUpdate = new List <Mask_Set_Title__c>();
    Set <MSTAccount__c> MSTAccountToInsert = new Set <MSTAccount__c>();
    Set <ID> setMSTAccount = new Set <ID>();
    List <MSTAccount__c> MSTAccountToUpsert = new List <MSTAccount__c>();
        IF(Trigger.IsAfter){
        for (MPW_Train_Maintenance__c m : trigger.New) {
            if (m.Customer_Tapeout_Date__c != trigger.oldMap.get(m.Id).Customer_Tapeout_Date__c
                || m.Other_Tapeout_Date__c != trigger.oldMap.get(m.Id).Other_Tapeout_Date__c) {
                mpwIds.add(m.Id);
            }
        }
        
        if (mpwIds.size() > 0) {
            List<Device__c> listDevices = new List<Device__c>(); 
            for (MPW_Train_Maintenance__c m : [SELECT   Id
                                                        , Customer_Tapeout_Date__c
                                                        , Other_Tapeout_Date__c
                                                        , (SELECT   Id
                                                                    , Name
                                                                    , Account__r.RecordTypeId
                                                                    , Current_Forecast_Tapeout_Date__c
                                                                    , Actual_Tapeout_Date_GMT__c
                                                           FROM     Devices__r
                                                           WHERE    Actual_Tapeout_Date_GMT__c = null
                                                                    AND Tapeout_Type__c = :Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_GLOBALSHUTTLE_MPW').Value__c)
                                               FROM     MPW_Train_Maintenance__c
                                               WHERE    Id IN :mpwIds]) {
                if (m.Devices__r.size() > 0) {  
                    for (Device__c d : m.Devices__r) {
                        if (d.Account__r.RecordTypeId == Environment_Variable__c.getInstance('ACCT_RT_ID_CUSTOMER').Value__c
                            || d.Account__r.RecordTypeId == Environment_Variable__c.getInstance('ACCT_RT_ID_EN_PARTNER').Value__c
                            || d.Account__r.RecordTypeId == Environment_Variable__c.getInstance('ACCT_RT_ID_RESELLER').Value__c) {
                            if (d.Current_Forecast_Tapeout_Date__c != m.Customer_Tapeout_Date__c) {
                                d.Current_Forecast_Tapeout_Date__c = m.Customer_Tapeout_Date__c;
                                listDevices.add(d);     
                            }
                        } else if (d.Account__r.RecordTypeId == Environment_Variable__c.getInstance('ACCT_RT_ID_GF_INTERNAL').Value__c) {
                            if (d.Current_Forecast_Tapeout_Date__c != m.Other_Tapeout_Date__c) {
                                d.Current_Forecast_Tapeout_Date__c = m.Other_Tapeout_Date__c;
                                listDevices.add(d); 
                            }
                        }
                    }
                }
            }
            
            if (listDevices.size() > 0) {
                update listDevices;
            }
        }
        }
      
    IF(Trigger.IsBefore && Trigger.IsInsert ){
    
    for (MPW_Train_Maintenance__c m : trigger.New) {
       
        if (m.Geometry__c =='0.35um' || m.Geometry__c =='0.18um'|| m.Geometry__c =='0.11/0.13um'|| m.Geometry__c =='14nm' || m.Geometry__c =='22nm') {
            m.Reticle_Type__c = 'Single Layer Reticle (SLR)';
           
        }
        Else if (m.Geometry__c =='40nm' || m.Geometry__c =='28nm') {
            m.Reticle_Type__c= 'Multi Layer Reticle (MLR)';
        }
        Else if (m.Geometry__c =='65/55nm' || m.Geometry__c =='55/65nm'  ) {
           m.Reticle_Type__c = 'Multi Node Reticle (MNR)';
        }
        Else {
           m.Reticle_Type__c = '';
        }
    }
    
   }
   
   IF(Trigger.IsAfter){
   for (MPW_Train_Maintenance__c m : trigger.New) {
        MPWTMMap.put(m.Name, m);
    }
        List<Mask_Set_Title__c> lstMaskSetTitle = new List<Mask_Set_Title__c>();

        for(Mask_Set_Title__c mst: [SELECT Name,Reticle_Type__c FROM Mask_Set_Title__c WHERE Name In: MPWTMMap.KeySet() ]){
            setMaskTitle.add(mst.name);
            lstMaskSetTitle.add(mst);
        }
       
        
            for (MPW_Train_Maintenance__c m : [SELECT   Id
                                                        , Name
                                                        , Reticle_Type__c
                                                        ,Publish__c
                                                        ,Active__c
                                                        , (SELECT   Id
                                                                    ,Customer_Company_Name__c
                                                           FROM     MPW_Reservations__r
                                                           WHERE    Customer_Company_Name__c != null)
                                               FROM     MPW_Train_Maintenance__c
                                               WHERE    Id IN :Trigger.new]) {
                                         
                if(m.Publish__c == True && m.Active__c == True){
                    If(setMaskTitle == NULL || setMaskTitle.size()==0){
                        Mask_Set_Title__c MST = new Mask_Set_Title__c (); 
                        MST.Name = m.Name; 
                        MST.Reticle_Type__c = m.Reticle_Type__c;
                        MST.Manual_Creation__c = False;
                        MSTToInsert.add(MST); 
                        
                        IF(m.MPW_Reservations__r != Null){
                            For(MPW_Reservation__c MPWres : m.MPW_Reservations__r){
                                 MSTAccount__c MSTAcc  = new MSTAccount__c();
                                 MSTAcc.Account__c = MPWres.Customer_Company_Name__c;
                                 MSTAccountToInsert.add(MSTAcc);                                                    
                            }
                        } 
                    } 
                    Else if(setMaskTitle!=Null && m.Reticle_Type__c != Trigger.oldMap.get(m.Id).Reticle_Type__c){
                    lstMaskSetTitle[0].Reticle_Type__c = m.Reticle_Type__c;
                    MSTToUpdate.add(lstMaskSetTitle[0]);
                    }
                }      
            }
      
    try {
            if(MSTToInsert!= Null && MSTToInsert.size()>0){
                upsert MSTToInsert;
                For(Mask_Set_Title__c MST:MSTToInsert){
                    MapMST.put(MST.Name,MST.ID);
                }

            }
          
            if(MSTAccountToInsert!= Null){
                if (setMaskTitle == NULL || setMaskTitle.size()==0){
                    For(MPW_Train_Maintenance__c m : Trigger.new){
                        if(MapMST != NULL && 
                            MapMST.containskey(m.Name)){
                            For(MSTAccount__c MSTAcc : MSTAccountToInsert){
                               MSTAcc.Mask_Set_Title__c = MapMST.get(m.Name);
                               MSTAcc.Account__c = MSTAcc.Account__c;
                               MSTAccountToUpsert.add(MSTAcc);
                               
                             
                            }
                        }
                    } 
                }  
                upsert MSTAccountToUpsert;
            }
            if(MSTToUpdate!=Null && MSTToUpdate.size()>0){
                Update MSTToUpdate;
            
            }
    }   
    catch (system.Dmlexception e) {
                system.debug (e);
    }
   } 
       
        
}