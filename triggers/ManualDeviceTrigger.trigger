/*
    Author: Bhupesh Mukhija
    Description: This trigger validates Device Id during insertion of Manual Device through UI or Data Loader. 
                Also, updates related device for Project Update and Publish Report field updates.
    History:
        BMukhija        06032013         - code creation.
        ASinghal        26072013         - Changes done as part of Case 00001643 to remove Publishto Field Mapping and add Attn To field mapping  from manualDevice to Device.
*/
trigger ManualDeviceTrigger on Manual_Device__c (before insert, before update) {
    // FETCH NEW AND OLD VALUES FOR ALL FIELDS
    List<Manual_Device__c> lManualDevice = Trigger.new;
    Map<Id, Manual_Device__c> mOldManualDevice = Trigger.oldMap;

    // DECLERATIONS
    Set<String> sDeviceId = new Set<String>();
    Set<String> sAccountName = new Set<String>();    

    List<Device__c> lDevice = new List<Device__c>();
    List<Manual_Device__c> lMDevice = new List<Manual_Device__c>();

    Map<Id, Manual_Device__c> mManualDevice = new Map<Id, Manual_Device__c>();
    
    Map<String, String> mAccount = new Map<String, String>();

    if (!ManualDeviceHelper.flagSaveReport) {
        // GET ACCOUNT AND DEVICE DATA TO UPDATE UPDATE ACCOUNT NAME FIELD FROM ACCOUNT FIELD
        for (Manual_Device__c eachManualDevice :lManualDevice) {
            sDeviceId.add(eachManualDevice.Device_Id__c);
            if(eachManualDevice.Account_Name__c <> null)
            sAccountName.add(eachManualDevice.Account_Name__c.toUpperCase());
            if(eachManualDevice.Account_Name__c <> null)
            eachManualDevice.Account_Name__c = eachManualDevice.Account_Name__c.toUpperCase();
            eachManualDevice.Device_Id__c = eachManualDevice.Device_Id__c.toUpperCase();
        }
        //System.debug('@@@@@sDeviceId'+sDeviceId );
    
        for(Account accountA : [ SELECT Name
                                   FROM Account 
                                   WHERE Name IN : sAccountName ]){
        //System.debug('@@@@@Name'+accountA.Name.toUpperCase() + '@@@@@@ID' +accountA.Id );
        
                                   mAccount.put(accountA.Name.toUpperCase(), accountA.Id);                        
        }

        mAccount.put(ManualDeviceConstants.MDEVICE_ID_MULTIPLE, '123456789');
        for (Manual_Device__c eachManualDevice :lManualDevice) {
            if(eachManualDevice.Account_Name__c<>null && mAccount.get(eachManualDevice.Account_Name__c.toUpperCase()) == null){
                eachManualDevice.Account_Name__c.AddError(ManualDeviceConstants.MDEVICE_INVALID_ACCOUNT_ERROR);
            }
        }
    }
    
    // POPULATE MAP WITH FETCHED RECORD TYPES.
    /*for (RecordType eachRecordType :lRecordType) {
        mRecordType.put(eachRecordType.DeveloperName, eachRecordType.Id);
    }*/

    if (Trigger.isInsert) {
        // CHECK IF THIS INSERT IS FROM UI OR BULK LOAD.
        if (!ManualDeviceHelper.flagHelper) {
            // GET ALL ACTIVE DEVICES AND MANUAL DEVICES.
            lDevice = [ SELECT Name 
                        FROM Device__c 
                        WHERE Stage__c != :ManualDeviceConstants.DEVICE_STAGE_EOL
                            AND Name != :ManualDeviceConstants.MDEVICE_ID_MULTIPLE
                            AND Name IN :sDeviceId ];
                            
            //System.debug('@@@@@ManualDeviceConstants.MDEVICE_ID_MULTIPLE '+ ManualDeviceConstants.MDEVICE_ID_MULTIPLE );                             
            //System.debug('@@@@@sDeviceId '+ sDeviceId );    //vixit 
            
            if(sDeviceId != null){
            lMDevice = [ SELECT Account_Name__c, Device_Id__c 
                         FROM Manual_Device__c 
                         WHERE isActive__c = true
                            AND Device_Id__c != :ManualDeviceConstants.MDEVICE_ID_MULTIPLE
                            //AND Device_Id__c IN :sDeviceId 
                            ];
            }
                            
            //System.debug('@@@@@lMDevice '+ lMDevice );  //vixit                     

            // ADD ALL IDs FOR ACTIVE DEVICES AND MANUAL DEVICES IN THE SET FOR VALIDATION.
            sDeviceId.clear();
            if (!lDevice.isEmpty()) {
                for (Device__c eachDevice :lDevice) { 
                    sDeviceId.add(eachDevice.Name);
                }
            }

            if (!lMDevice.isEmpty()) {


                List<Manual_Device__c> mdList = new List<Manual_Device__c>();
                List<String> accNameList = new List<String>();
                
                for (Manual_Device__c eachManualDevice :lMDevice) {
                    if (eachManualDevice.Device_Id__c.toUpperCase() != ManualDeviceConstants.MDEVICE_ID_MULTIPLE) {
                        sDeviceId.add(eachManualDevice.Device_Id__c);
                    }
                    accNameList.add(eachManualDevice.Account_Name__c);
                }
                List<Account> acnList=[select Id, Name from Account where Name in:accNameList];
                
                //System.debug('@@@@@acnList '+ acnList );  //vixit 
                
                Map<String, String> acnMap = new Map<String, String>();
                for(Account acnObj:acnList){
                    acnMap.put(acnObj.Name,acnObj.Id);
                }
                for (Manual_Device__c eachManualDevice :Trigger.new) {
                    eachManualDevice.Account__c = acnMap.get(eachManualDevice.Account_Name__c);
                    //mdList.add(eachManualDevice);
                    //System.debug('@@@@@eachManualDevice '+ eachManualDevice.Account__c );  //vixit
                }
                 

            }

            // CHECK FOR DEVICE ID ALREADY EXISTING IN DEVICE AND MANUAL DEVICE
            for (Manual_Device__c eachManualDevice :lManualDevice) {
                if (sDeviceId.contains(eachManualDevice.Device_Id__c)) {
                    eachManualDevice.Device_Id__c.addError(ManualDeviceConstants.MDEVICE_DUPLICATE_DEVICE_ERROR);
                }
            }
        }
        /*for (Manual_Device__c eachManualDevice :lManualDevice) {
            eachManualDevice.RecordTypeId = mRecordType.get('Manual_Device_DI_Read_Only');
            eachManualDevice.Device_Id__c = eachManualDevice.Device_Id__c.toUpperCase();

            //ManualDeviceHelper.manualDeviceAccountValidation(eachManualDevice, lAccount);
        }  */                 
    } else if (Trigger.isUpdate && !ManualDeviceHelper.flagMDevUpdate) {
    
/////////
            System.debug('@@@Update@@sDeviceId '+ sDeviceId );    //vixit 
            if(sDeviceId != null){
            lMDevice = [ SELECT Account_Name__c, Device_Id__c 
                         FROM Manual_Device__c 
                         WHERE isActive__c = true
                            AND Device_Id__c != :ManualDeviceConstants.MDEVICE_ID_MULTIPLE
                            AND Device_Id__c IN :sDeviceId 
                            ];
            }
            System.debug('@@Update@@@lMDevice '+ lMDevice );  //vixit 

            
            if (!lMDevice.isEmpty()) {


                //List<Manual_Device__c> mdList = new List<Manual_Device__c>();
                List<String> accNameList = new List<String>();
                
                for (Manual_Device__c eachManualDevice :Trigger.new) {
                    accNameList.add(eachManualDevice.Account_Name__c);
                    //mdIdaccNameMap.put(eachManualDevice.Id,eachManualDevice.Account_Name__c);
                }
                if (accNameList <> null && accNameList.size() >0)
                System.debug('@@Update@@@accNameList '+ accNameList );  //vixit
                                
                List<Account> acnList=[select Id, Name from Account where Name in:accNameList];
                
                System.debug('@@@@@acnList '+ acnList );  //vixit 
                
                if(acnList<>null && acnList.size() > 0){
                    Map<String, String> acnMap = new Map<String, String>();
                    for(Account acnObj:acnList){
                        acnMap.put(acnObj.Name,acnObj.Id);
                    }
                    for (Manual_Device__c eachManualDevice :Trigger.new) {
                        eachManualDevice.Account__c = acnMap.get(eachManualDevice.Account_Name__c);
                        //System.debug('@@@@@eachManualDevice '+ eachManualDevice.Account__c );  //vixit
                    }
                }
                 

            }
    
//////////

            // CONTROL RECORD TYPE FOR DEVICE ID READ ONLY OR DEVICE ID, PUBLISH REPORT READ ONLY
            for (Manual_Device__c eachManualDevice :lManualDevice) {
                if (eachManualDevice != null) {             
                    // POPULATE MAP FOR PROJECT UPDATE AND PUBLISH REPORT UPDATE AT DEVICE LEVEL.
                    if (eachManualDevice.Device__c != null) {
                        mManualDevice.put(eachManualDevice.Device__c, eachManualDevice);
                    }
                }
            }
    
            // UPDATE DEVICES FOR PROJECT UPDATE AND PUBLISH REPORT FIELD.
            if (!mManualDevice.isEmpty() && !ManualDeviceHelper.flagHelper) {
                for (Device__c eachDevice :[ SELECT Id
                                                  , Project_Update__c
                                                  , Publish_Report__c
                                                  , Attn_To__c
                                             FROM Device__c 
                                             WHERE Id in: mManualDevice.keySet() ]) {
                    eachDevice.Project_Update__c = mManualDevice.get(eachDevice.id).Project_Update__c;
                    //eachDevice.Publish_Report__c = mManualDevice.get(eachDevice.id).Publish_Report__c;
                    eachDevice.Attn_To__c = mManualDevice.get(eachDevice.id).Attn_To__c;
                    lDevice.add(eachDevice);
                }
                if (!lDevice.isEmpty())
                Database.saveResult[] aSaveResult = Database.update(lDevice);
            }
    }
}