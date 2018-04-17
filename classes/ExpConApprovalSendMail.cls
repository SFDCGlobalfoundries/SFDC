/*
    Author: Anirban Roy
    Description: This is a helper class for DeviceUpdateTrigger to send Export Control Waiver emails.
    History: 
        ARoy      09092013    - Code creation.
        ARoy      10042013    - Code modified to delete the Device Export Control Junction object to waive the 
                                Export Control Form when the Export_Control_Waiver_Flag__c is updated to 'Yes'.
        ZAmbat    10292013    - Updated code to set Device__c.Export_Control_Form_Status__c to 'Waived'.
        Vijay	  02052015	  - updated the code to support the Internal Device functionality. Based on the Record Type the Device is identified and 
        						Export control waiver approval and rejection mail will be sent to appropriate recipients. For Internal Device case
        						mail will be sent Account Administrator user of Account Team Proxy and GTC Users.
*/
public class ExpConApprovalSendMail {
    
    public static boolean isRun = false;
    
    
    // Validate the Export Control Waiver Flag of Device updation and add errors to the page
    public static void validateExpConWaiver(List<Device__c> devList, Map<Id,Device__c> oldDeviceMap){
        
        List<String> devIdList = new List<String>();
        String roleGTC = EnvironmentVariable.get('GTC_ROLE');
        try{
            UserRole usrRole = [select name from UserRole where id = :UserInfo.getUserRoleId()];
            
            for(Device__c newDevice: devList){
                Device__c oldDevice = oldDeviceMap.get(newDevice.Id);       
                if(oldDevice.Export_Control_Waiver_Flag__c != newDevice.Export_Control_Waiver_Flag__c 
                    && (newDevice.Export_Control_Waiver_Flag__c == 'Yes' || newDevice.Export_Control_Waiver_Flag__c == 'No')){              
                    Error_Codes__c ec = Error_Codes__c.getInstance('DEVICE_EXP_CON_WAIVER_FLAG_ERR');
                    if(usrRole.Name <> roleGTC){
                        newDevice.Export_Control_Waiver_Flag__c.addError(ec.Message__c);
                    }else if(usrRole.Name == roleGTC && newDevice.Export_Control_Waiver_Flag_Request__c == false){
                        newDevice.Export_Control_Waiver_Flag__c.addError(ec.Message__c);
                    }                       
                }           
            }
        }catch(Exception e){}        
    }
    
    // Send Email to GTC user and AM/FE on updation of Export Control Waiver Flag of Device
    public static void sendEmail(List<Device__c> devList, Map<Id,Device__c> oldDeviceMap){
        
        List<String> opptyProgList = new List<String>();
        List<Device__c> devExpConWaiverFlagTrueList = new List<Device__c>();
        List<Device__c> devExpConWaiverFlagFalseList = new List<Device__c>();
        List<Device__c> selDevList = new List<Device__c>();
        
        //Added by Vijay 02052015 -accountIdList variable
        Set<Id> accountIdSet = new Set<Id>();
        
        // Check for devices having changes in Export_Control_Waiver_Flag__c and p
        for(Device__c newDevice: devList){
            Device__c oldDevice = oldDeviceMap.get(newDevice.Id);       
            if(oldDevice.Export_Control_Waiver_Flag__c != newDevice.Export_Control_Waiver_Flag__c 
                && (newDevice.Export_Control_Waiver_Flag__c == 'Yes' || newDevice.Export_Control_Waiver_Flag__c == 'No')
                && newDevice.Export_Control_Waiver_Flag_Request__c == true){
                
                //Added by Vijay - If device is internal Device prepare accountIdSet else oppProgramList
                if(DeviceTriggerHandler.isInternalDevice(newDevice.RecordTypeId) && newDevice.Account__c != null){
                	accountIdSet.add(newDevice.Account__c);
                }else{
                	opptyProgList.add(newDevice.Opportunity_Program__c);
                }
                selDevList.add(newDevice);
                
                if(newDevice.Export_Control_Waiver_Flag__c == 'Yes'){
                    devExpConWaiverFlagTrueList.add(newDevice);
                    
                }else if(newDevice.Export_Control_Waiver_Flag__c == 'No'){
                    devExpConWaiverFlagFalseList.add(newDevice);
                    
                }       
            }           
        }
        
        // Email sent for approval of Export Control Waiver Flag
        EmailTemplate emailTemp1;
        Map<String, List<String>> toAddressMap = new Map<String, List<String>>();
        
       	//Added by Vijay - added Device Record Type check
        if(!accountIdSet.isEmpty()){
        	String accountAdminRole = (EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_AA') != null)? EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_AA') :'Account Administrator';
        	toAddressMap = ExpConWaiverService.getAccountAdminEmailIds(accountIdSet, new List<String>{accountAdminRole});
        }else{
        	toAddressMap = ExpConWaiverService.getAMFEMailIds(opptyProgList);
        }
    	List<String> ccAddressList = ExpConWaiverService.getGTCUserMailIds();
        List<String> toAddressList = new List<String>();
        //System.debug('=======devExpConWaiverFlagTrueList'+devExpConWaiverFlagTrueList);
        if(devExpConWaiverFlagTrueList.size()>0){
            //=======Delete the Device Export Control Junction object to waive the Export Control Form=======//
            List<Device_Export_Control_Junction__c> juncObjList = [select id
                                                                   from   Device_Export_Control_Junction__c
                                                                   where  Device__c = :devExpConWaiverFlagTrueList
                                                                  ];

            if(juncObjList.size()>0 ){                          
               delete juncObjList;              
            }
             
            //===End of Delete the Device Export Control Junction object to waive the Export Control Form====//
            String expConWaiverApproveTemp = EnvironmentVariable.get('DEVICE_EXP_CON_WAIVER_APPROVE_TEMP');
            emailTemp1 = [SELECT id from EmailTemplate where name = :expConWaiverApproveTemp];              
            for(Device__c dev1 : devExpConWaiverFlagTrueList){
            	//Added by Vijay - added Device Record Type check
            	if(DeviceTriggerHandler.isInternalDevice(dev1.RecordTypeId) && dev1.Account__c != null){
            		toAddressList = toAddressMap.get(dev1.Account__c);
            	}else{
                	toAddressList = toAddressMap.get(dev1.Opportunity_Program__c);
            	}
                if(toAddressList <> null && toAddressList.size() > 0){
                    ExpConWaiverService.sendEmail(emailTemp1.Id, dev1.Id, toAddressList, ccAddressList);
                }
                // ZAmbat 10292013
                dev1.Export_Control_Status__c = Environment_Variable__c.getInstance('EXP_CON_STATUS_WAIVED').Value__c;
                dev1.Export_Control_Junction__c='0';
            }

        }
        
        // Email sent for rejection of Export Control Waiver Flag
        EmailTemplate emailTemp2;
        if(devExpConWaiverFlagFalseList.size()>0){
            String expConWaiverRejectTemp = EnvironmentVariable.get('DEVICE_EXP_CON_WAIVER_REJECT_TEMP');
            emailTemp2 = [SELECT id from EmailTemplate where name = :expConWaiverRejectTemp];
            for(Device__c dev2 : devExpConWaiverFlagFalseList){
            	//Added by Vijay - added Device Record Type check
                if(DeviceTriggerHandler.isInternalDevice(dev2.RecordTypeId) && dev2.Account__c != null){
            		toAddressList = toAddressMap.get(dev2.Account__c);
            	}else{
                	toAddressList = toAddressMap.get(dev2.Opportunity_Program__c);
            	}
                if(toAddressList <> null && toAddressList.size() > 0){
                    ExpConWaiverService.sendEmail(emailTemp2.Id, dev2.Id, toAddressList, ccAddressList);
                }
            }
        }
        
        // Sending the email and updating the Export_Control_Waiver_Flag_Request__c to false
        if(ExpConWaiverService.sendMsgs.size() > 0){
            try{
                Messaging.sendEmail(ExpConWaiverService.sendMsgs);
                for(Device__c dev : selDevList){
                    dev.Export_Control_Waiver_Flag_Request__c = false;
                }
            }catch(Exception e){
                system.debug('Error occurred while sending mail and updation====>'+e.getMessage());
            }
        }
        
        isRun = true;
    }
}