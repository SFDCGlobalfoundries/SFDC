/*
* @ Author          :- Navneet Rajput
* @ Organization    :- Cognizant Technology solutions
* @ Project         :- SwiftGen
* @ Description     :- handles Device validation,DeviceTapeout and partial cancellation of Device object on PTRF record inser/update operation.   
* @ Date            :- 21th April 2014
* @ Change History
*       Baij    16072014    Order_Date__c & Transaction_Type__C has been removed
        Vijay   15082014    implemented business logic:- when Device.PLM Device Id IS NOT NULL and Device Prototype Date IS NOT NULL then Update
                            Device Stage to 'Prototype'
        Vijay	03112015	For TD Test Chip Internal Device the PTRF order type can be 'New Prototype' and 'Retrofit'. In Frame tapeout block the 
        					TD Test Chip Tapeout Type check is added.
**/
public with sharing class PTRF_AfterTriggerService {
    
    //This device list used to update the device with stage as 'Prototype' after it is updated with stage as 'Tapeout'
    List<Device__c> deviceList = new List<Device__c>();
    //PTRF creation will be happend form SWIFT system  
   //Method perform device related validations once PTRF record is inserted/updated in to SFDC
   public void validatePTRFAssociatedDevice(List<PTRF__c> ptrfRecords, Map<Id,PTRF__c> mapOfOldRecords){
         system.debug('Inside validatePTRFAssociatedDevice>>>>>>>>>>>>'+ptrfRecords);
         try{
             List<Device__c> listDevice = null;
             List<String> listOfCrmDID = new List<String>();
             if (ptrfRecords!=null && !ptrfRecords.isEmpty()){
                 for(PTRF__c ptrfObj : ptrfRecords){
                    listOfCrmDID.add(ptrfObj.CRMDID__c);
                 }
                 system.debug('listOfCrmDID>>>>>>>>>>>>>'+listOfCrmDID);
                 if (listOfCrmDID!=null && !listOfCrmDID.isempty()){    
                        listDevice = [
                                        SELECT      Id
                                                    , Name
                                                    , Device_Id__c
                                                    , Stage__c
                                                    , CRMDID__c
                                                    , Device_Mask_Set_Title__c
                                                    , PTRF_Id__c
                                                    , Actual_Tapeout_Date_GMT__c
                                                    , PLM_Device_ID__c
                                                    , Prototype_Date__c
                                                    , Tapeout_Type__c
                                        FROM        Device__c
                                        WHERE       CRMDID__c IN : listOfCrmDID
                                    ];
                 }                          
                 system.debug('listDevice>>>>>>>>>>>>>>>'+listDevice);                               
                 if (listDevice!=null && !listDevice.isEmpty()) {
                   // update device for current PTRF
                    Map<String,Device__c> ptrfAndDeviceObjectMap = new Map<String,Device__c>();
                    List<Device__c> listOfUpdatedDevices = new List<Device__c>();
                    // Perform partial as well as device cancelation operations
                    //List<Device__c> devicelistOfUpdatedTapoutDates = PTRF_AfterTriggerService.checkCancelationAndUpdateTapoutDateOnDevice(listDevice,mapOfOldRecords);
                    List<Device__c> devicelistOfUpdatedTapoutDates = new List<Device__c>();
                    PTRF__c oldPtrf = null;
                    
                    if (mapOfOldRecords!=null && !mapOfOldRecords.isEmpty()){
                        oldPtrf = mapOfOldRecords.get(ptrfRecords[0].Id);
                    }
                    system.debug('oldPtrf>>>>>>'+oldPtrf);
                    
                    if (ptrfRecords[0].CRMDID__c!=null && ptrfRecords[0].Status__c == 'Cancel'){
                        system.debug('Inside Cancellation >>>>>>>>>>>>>');
                        devicelistOfUpdatedTapoutDates = checkCancellationAndUpdateTapoutDateOnDevice(listDevice[0]);
                        
                    }
                    //Partial PTRF Cancellation
                    else if(oldPtrf<>null && oldPtrf.Prime_Tapeout__c==true && ptrfRecords[0].Prime_Tapeout__c==false){
                        system.debug('Inside Partial Cancellation >>>>>>>>>>>>>>');
                        devicelistOfUpdatedTapoutDates = checkCancellationAndUpdateTapoutDateOnDevice(listDevice[0]);
                    }
                    // Following code is use for validation of device tapeout conditions and update device accordingly
                    
                    else if (ptrfRecords[0].CRMDID__c != null && ptrfRecords[0].Status__c == 'Perform Tapeout Options'){
                        system.debug('Inside Perform tape out>>>>>>>>>>>>>>>>>');
                        Device__c updatedTapoutDeviceObj = updateDevicePTRF(ptrfRecords[0], listDevice[0]);
                        if(updatedTapoutDeviceObj != null){
                            devicelistOfUpdatedTapoutDates.add(updatedTapoutDeviceObj);
                        }
                    }else{
                        system.debug('---------In Else--------');
                    }
                    
                    if (devicelistOfUpdatedTapoutDates!=null && !devicelistOfUpdatedTapoutDates.isEmpty()){
                        System.debug('devicelistOfUpdatedTapoutDates----------'+devicelistOfUpdatedTapoutDates);
                        update devicelistOfUpdatedTapoutDates;
                    }
                    
                    // Device will be updated with stage as 'Prototype' after it is updated with stage as 'Tapeout' 
                    //It is neccessary to maintain Device history instead of updating device directly with stage 'Prototype'
                    if(deviceList != null && !deviceList.isEmpty()){
                        System.debug('deviceList ----------'+deviceList );
                        update deviceList;
                    }
                    
                } else {
                    //ptrfObj.addError('No device found for '+ptrfObj.Name);
                }
             }                                  
         } catch (Exception e){
            // Need to decide where and how to keep track of exception
            system.debug('Exception while updating PTRF >>>>>>>>>>>>>>>>> '+e.getMessage());
         }
   } 
    
    /*
    * @ Description         : Method validate all device cancellation related validation and update device as per business rules 
    * @ Change History      :
    * @ Date                : 4/16/2014 
    * @ Param               : PTRF__c object and Device__c Object
    */
    public List<Device__c> checkCancellationAndUpdateTapoutDateOnDevice(Device__c deviceRecords){
        system.debug('Inside checkCancelationOnDevice :: ');   
        String DEVICE_TAPEOUT = '';
        String PTRF_CANCEL = '';
        
        if (Environment_Variable__c.getInstance('DEVICE_STAGE_TAPEOUT')!=null){
            String stage = Environment_Variable__c.getInstance('DEVICE_STAGE_TAPEOUT').Value__c;
            DEVICE_TAPEOUT = (!String.isBlank(stage)) ? stage : 'Tapeout';
        }else{
            DEVICE_TAPEOUT = 'Tapeout';
        }
        
        if (Environment_Variable__c.getInstance('PTRF_TXN_TYPE_CANCEL')!=null){
            String stage = Environment_Variable__c.getInstance('PTRF_TXN_TYPE_CANCEL').Value__c;
            PTRF_CANCEL = (!String.isBlank(stage)) ? stage : 'CANCEL';
        }else{
            PTRF_CANCEL = 'CANCEL';
        }  
           
        Map<String,List<PTRF__c>> mapOfPtrfRecords = new Map<String,List<PTRF__c>>();
        List<Device__c> listOfDeviceRecords = new List<Device__c>();
      //  system.debug('deviceDID List ########## '+deviceDIDList);
        List<PTRF__c> ptrfRecords=[SELECT   Transaction_Date__c
                                            , Status__c 
                                            , Process_ID__c
                                            , Prime_Tapeout__c
                                            , Prime_Status__c
                                            , Prime_DRT__c
                                            , Order_Type__c
                                            , Number_of_Selected_Prime_Dies__c
                                            , Mask_Set_Title__c
                                            , MaskSetTitle__c
                                            , Id
                                            , Frame_Status__c
                                            , Frame_Mockup__c
                                            , Frame_GDSOUT_Review__c
                                            , Frame_DRT__c
                                            , Frame_Tapeout__c
                                            , DRC_Only__c
                                            , Prime_GDSOUT_Review__c
                                            , Device__c
                                            , Device_Id__c
                                            , CRMDID__c
                                            , Name 
                                   FROM     PTRF__c
                                   WHERE    CRMDID__c =: deviceRecords.CRMDID__c];
        // Below code is not bulkified and it is used in partial cancelation part of functionality. 
        // It will help to set Actual Tapout date to transaction date on certain set of conditions.
        if (ptrfRecords!=null && !ptrfRecords.isEmpty()){
            boolean isTrue = false;
            for(PTRF__c ptrf : ptrfRecords){
                system.debug('Total Number of Prime Dies>>>>>>>>>>>>>>>>  '+ptrf.Number_of_Selected_Prime_Dies__c);
                if (ptrf.Prime_Tapeout__c==true && ptrf.Status__c == 'Perform Tapeout Options' && ptrf.Number_of_Selected_Prime_Dies__c>0){
                    system.debug('No need to update device Date >>>> '+ptrf);
                    isTrue =true;
                    break;
                } 
            }
            if (deviceRecords.Stage__c == DEVICE_TAPEOUT && !isTrue) {
                 deviceRecords.Actual_Tapeout_Date_GMT__c = null;
                 listOfDeviceRecords.add(deviceRecords);
            }
        }
        system.debug('listOfDeviceRecords>>>>>>'+listOfDeviceRecords);
        return listOfDeviceRecords;
    }// End of checkCancelationOnDevice function
    
    /*
    * @ Description         : Validate PTRF records and Update Device/PTRF record 
    * @ Change History      :
    * @ Date                : 2/16/2014
    * @ Param               : PTRF__c object and Device__c Object
    */
    
    public Device__c updateDevicePTRF(PTRF__c ptrf, Device__c device) {
        //Check Null values of custom setting variabels
        String PTRF_LIFECYCLE = '';
        String DEVICE_DESIGNING = '';
        String DEVICE_TAPEOUT = '';
        String MASKSET_TITLE = '';
        String DEVICE_TAPEOUT_TYPE_RETROFIT = '';
        String DEVICE_STAGE_PROTOTYPE = '';
        String DEVICE_TAPEOUT_TYPE_TDTESTCHIP = '';
        Boolean isDeviceUpdated = false;
        
        if (Environment_Variable__c.getInstance('PTRF_TXN_TYPE_LIFECYCLE')!=null){
            String stage = Environment_Variable__c.getInstance('PTRF_TXN_TYPE_LIFECYCLE').Value__c;
            PTRF_LIFECYCLE = (!String.isBlank(stage)) ? stage : 'LIFECYCLE';
        }else{
             PTRF_LIFECYCLE = 'LIFECYCLE';
        }
        
        if (Environment_Variable__c.getInstance('DEVICE_STAGE_DESIGNIN')!=null){
            String stage = Environment_Variable__c.getInstance('DEVICE_STAGE_DESIGNIN').Value__c;
            DEVICE_DESIGNING = (!String.isBlank(stage)) ? stage : 'Design In';
        }else{
            DEVICE_DESIGNING = 'Design In';
        }
        
        if (Environment_Variable__c.getInstance('DEVICE_STAGE_TAPEOUT')!=null){
            String stage = Environment_Variable__c.getInstance('DEVICE_STAGE_TAPEOUT').Value__c;
            DEVICE_TAPEOUT = (!String.isBlank(stage)) ? stage : 'Tapeout';
        }else{
            DEVICE_TAPEOUT = 'Tapeout';
        }
        
        if (Environment_Variable__c.getInstance('PTRF_MASK_SET_TITLE_PREFIX')!=null){
            String stage = Environment_Variable__c.getInstance('PTRF_MASK_SET_TITLE_PREFIX').Value__c;
            MASKSET_TITLE = (!String.isBlank(stage)) ? stage : 'MPW';
        }else{
            MASKSET_TITLE = 'MPW';
        }
        if (Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_RETROFIT')!= null){
            String stage = Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_RETROFIT').Value__c;
            DEVICE_TAPEOUT_TYPE_RETROFIT = (!String.isBlank(stage)) ? stage : 'Retrofit';
        }else{
            DEVICE_TAPEOUT_TYPE_RETROFIT = 'Retrofit';
        }
        if (Environment_Variable__c.getInstance('DEVICE_STAGE_PROTOTYPE')!=null){
            String stage = Environment_Variable__c.getInstance('DEVICE_STAGE_PROTOTYPE').Value__c;
            DEVICE_STAGE_PROTOTYPE = (!String.isBlank(stage)) ? stage:'Prototype';
        }else{
            DEVICE_STAGE_PROTOTYPE = 'Prototype';
        }
		
		if (Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_TDTESTCHIP')!=null){
            String stage = Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_TDTESTCHIP').Value__c;
            DEVICE_TAPEOUT_TYPE_TDTESTCHIP = (!String.isBlank(stage)) ? stage:'TD Test Chip';
        }else{
            DEVICE_TAPEOUT_TYPE_TDTESTCHIP = 'TD Test Chip';
        }
        
        if ((device.Stage__c == DEVICE_DESIGNING || ((device.Stage__c == DEVICE_TAPEOUT || device.Stage__c == DEVICE_STAGE_PROTOTYPE) && device.Actual_Tapeout_Date_GMT__c == null)) &&
            ptrf.Prime_Tapeout__c == true && ptrf.Number_of_Selected_Prime_Dies__c>0) {
                
            system.debug('Inside updateDevicePTRF>>>>>>>>>>> ');                                                    
            // 1St Condition :: Update Device Stage to Device Tapeout
            if ((DEVICE_TAPEOUT!=null && DEVICE_TAPEOUT!='') && (device.Stage__c != DEVICE_TAPEOUT && device.Stage__c != DEVICE_STAGE_PROTOTYPE)){
                device.Stage__c = DEVICE_TAPEOUT;
            }
            // 2nd Condition :: Update Device MaskSet Title
            if (ptrf.MaskSetTitle__c!=null){
                List<Mask_Set_Title__c> maskSetTitle = [SELECT Id,
                                                               Name
                                                        from   Mask_Set_Title__c
                                                        WHERE  Id = : ptrf.MaskSetTitle__c 
                                                       ];
                if (maskSetTitle!=null && !maskSetTitle.isEmpty()){                                       
                    device.Device_Mask_Set_Title__c = maskSetTitle[0].Name;
                    
                    if (maskSetTitle[0].Name.left(3)!= null && 
                        maskSetTitle[0].Name.left(3).toUpperCase() != MASKSET_TITLE) {
                        // Update Device Id
                        if (ptrf.Device_Id__c != null){
                            device.Name = ptrf.Device_Id__c;
                        }
                     } 
                }
                system.debug('Inside PTRF Device Mask Set Title>>>>>>>>>>>'+device.Device_Mask_Set_Title__c);
            }            
            // 3rd Condition :: If order status is prototype then update Actual device Tapeout date to ptrf transition date 
            system.debug('ptrf.Order_Type__c>>>>>>>>>>>>>>>>>>> '+ptrf.Order_Type__c);
             
            if(ptrf.Order_Type__c!= null && ptrf.Order_Type__c!= ''){  
                if (ptrf.Order_Type__c.toUpperCase() =='New ProtoType'.toUpperCase()){
                    List<Mask_Layer__c> maskLayerRecords = [SELECT Tapeout__c
                                                                    ,Sort_Order__c
                                                                    ,PTRF__c
                                                            FROM    Mask_Layer__c
                                                            WHERE   PTRF__c =: ptrf.Id
                                                            AND     Tapeout__c = true
                                                            AND     Sort_Order__c <= 3   
                                                            ];
                    system.debug('maskLayerRecords>>>>>>>>>>>>>>>>> '+maskLayerRecords);                                        
                    if (maskLayerRecords!=null && !maskLayerRecords.isEmpty()){
                        if (ptrf.Transaction_Date__c!=null){
                            device.Actual_Tapeout_Date_GMT__c = ptrf.Transaction_Date__c;
                        } else {
                            device.Actual_Tapeout_Date_GMT__c = date.newInstance(datetime.now().year(), datetime.now().month(), datetime.now().day());
                        }
                        isDeviceUpdated = true;                           
                    }
                } 
                if (ptrf.Order_Type__c.toUpperCase() == DEVICE_TAPEOUT_TYPE_RETROFIT.toUpperCase()) {                                   
                // 4th Condition :: If order status is Retrofit then update Actual device Tapeout date to ptrf transition date      
                    List<Mask_Layer__c> maskLayerRecords = [SELECT Tapeout__c
                                                                    ,Sort_Order__c
                                                                    ,PTRF__c
                                                            FROM    Mask_Layer__c
                                                            WHERE   PTRF__c =: ptrf.Id
                                                            AND     Tapeout__c = true
                                                            ];
                    system.debug('maskLayerRecords for Retrofit>>>>>>>>>>>>'+maskLayerRecords);                                                    
                    if (maskLayerRecords!=null && !maskLayerRecords.isEmpty()){
                        if (ptrf.Transaction_Date__c!=null){
                            device.Actual_Tapeout_Date_GMT__c = ptrf.Transaction_Date__c;
                        } else {
                            device.Actual_Tapeout_Date_GMT__c = date.newInstance(datetime.now().year(), datetime.now().month(), datetime.now().day());
                        }
                        isDeviceUpdated = true;
                    }
                }
                if(isDeviceUpdated){
                    if(!String.isBlank(device.PLM_Device_ID__c) && device.Prototype_Date__c != null &&  device.Stage__c != DEVICE_STAGE_PROTOTYPE){
                        Device__c deviceObj = new Device__c(Id = device.Id, Stage__c = DEVICE_STAGE_PROTOTYPE);
                        deviceList.add(deviceObj);
                        system.debug('Updated deviceObj Record is >>>>>>>>>>>>>>>>>>>>'+deviceObj);
                    }
                }
            }
                
            system.debug('Updated Device Record is >>>>>>>>>>>>>>>>>>>>'+device);
            
            return device;
            
        } else if (device.Stage__c == DEVICE_DESIGNING && ptrf.Prime_Tapeout__c == false &&
                  (ptrf.Frame_Tapeout__c == true || ptrf.DRC_Only__c == true || ptrf.Prime_GDSOUT_Review__c == true || ptrf.Frame_Mockup__c == true)) {
            // Update Mask Set Title
            if (ptrf.MaskSetTitle__c!= null){
                List<Mask_Set_Title__c> maskSetTitle = [SELECT Id,
                                                               Name
                                                        from   Mask_Set_Title__c
                                                        WHERE  Id = : ptrf.MaskSetTitle__c 
                                                       ];
                                                       
                if (maskSetTitle!= null && !maskSetTitle.isEmpty()){
                    if(!String.isBlank(maskSetTitle[0].Name)){                                       
                        device.Device_Mask_Set_Title__c = maskSetTitle[0].Name;
                        
                        if (maskSetTitle[0].Name.left(3)!= null && 
                            maskSetTitle[0].Name.left(3).toUpperCase() != MASKSET_TITLE) {
                            // Update Device Id
                            if (ptrf.Device_Id__c!=null){
                                device.Name = ptrf.Device_Id__c;
                            }
                        } 
                    }
                }
                system.debug('Inside PTRF Device Mask Set Title>>>>>>>>>>>'+device.Device_Mask_Set_Title__c);
            }
            
            if(ptrf.Frame_Tapeout__c && ptrf.Order_Type__c.toUpperCase() == DEVICE_TAPEOUT_TYPE_RETROFIT.toUpperCase() && 
            			(device.Tapeout_Type__c == DEVICE_TAPEOUT_TYPE_RETROFIT || device.Tapeout_Type__c == DEVICE_TAPEOUT_TYPE_TDTESTCHIP)){
            
                if (!String.isBlank(DEVICE_TAPEOUT)){
                    device.Stage__c = DEVICE_TAPEOUT;
                }
               
                if (ptrf.Transaction_Date__c != null){
                    device.Actual_Tapeout_Date_GMT__c = ptrf.Transaction_Date__c;
                }else {
                    device.Actual_Tapeout_Date_GMT__c = date.newInstance(datetime.now().year(), datetime.now().month(), datetime.now().day());
                }
                
                if(!String.isBlank(device.PLM_Device_ID__c) && device.Prototype_Date__c != null){
                    Device__c deviceObj = new Device__c(Id = device.Id, Stage__c = DEVICE_STAGE_PROTOTYPE);
                    deviceList.add(deviceObj);
                    system.debug('Updated deviceObj Record is >>>>>>>>>>>>>>>>>>>>'+deviceObj);
                }
            }
            return device;
        }
        return null;
    }// End of updateDevicePTRF
}