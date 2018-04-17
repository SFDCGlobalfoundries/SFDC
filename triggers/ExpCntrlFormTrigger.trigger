/*
    Author: Anirban Roy
    Description: Trigger on Export Control Form object for validation  
    History:
        ARoy        07062013    - code creation.
        ZAmbat      08282013    - Added functionality to update Device of the Export Control Form's status
        ZAmbat      09252013    - Added functionality to update Device of the Export Control Form's status (upon insert)
        Asolito     09272013    - Added validation wherein On hold export control form cannot be Approved or Reject
        Asolito     10042013    - Added validation for D1 National Access is Allowed field to be populated before its approved
        ARoy        10292013    - Update the D1_National_Access_is_Allowed prior value to Prev_D1_National_Access_is_Allowed field 
                                  in Export Control Form (Task - 424)
        ARoy        10302013    - Commented the validation of Question 4 and Question 5 and added to ExpConFormApprovalController class 
                                  so that the validation gets fired only on submit for approval (Task - 463)
        ARoy        11062013    - Added check for Integration Users to skip trigger run.
        ARoy        11192013    - Removed the section for before insert after introduction of Export Control Junction object.
        ARoy        12052013    - Updation for making comments on rejection mandatory for Export Control Form Approval.
        ARoy        03062014    - Updated as per case 00007479, update Is_D1_Nat_Allowed_Check__c to true. 
        Jabee       26042017      - we have aded two export contol form fields to display on device in line 235 and 246 and 247
*/

trigger ExpCntrlFormTrigger on Export_Control_Form__c (before insert, before update, after update) {
    
    if(!IntegrationUserUtil.isSkipTrigger()){
        //Custom Validation for the Standard Edit Page but skipped for VF page.
        if(((Trigger.isBefore && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate)) && !ExportControlEditController.hasRun){
                    
            if(trigger.isBefore && trigger.isUpdate){
                for(Export_Control_Form__c e: trigger.new){
                    //Added Asolito 09272013 - Added validation wherein On hold export control form cannot be Approved or Reject
                    if(trigger.oldMap.get(e.id).status__c == 'On-hold' && (e.status__c == 'Approved' || e.status__c == 'Pending Resubmission')){
                        e.addError('Export Control Form cannot be Approved or Rejected if its On Hold');
                        break;
                    }
                    
                    //Added Asolito 10042013 - Added validation for D1 National Access is Allowed field to be populated before its approved
                    if(e.status__c == 'Approved' && !UtilsString.isNotBlank(e.D1_national_access_is_allowed__c)){
                        e.addError('D1 National Access is Allowed must not be blank before approving this export control form');
                        break;
                    }

                    //Added Devendra 15/10/2016 - 
                    if(e.status__c == 'Approved' && !UtilsString.isNotBlank(e.ECCN_Technology__c) && e.ITAR_Product__c != 'Yes'){
                        e.addError('ECCN Technology must not be blank before approving this export control form');
                        break;
                    }
                    
                    //Added Devendra 15/10/2016 - 
                    if(e.status__c == 'Approved' && !UtilsString.isNotBlank(e.ECCN_Wafer__c)&& e.ITAR_Product__c != 'Yes'){
                        e.addError('ECCN Wafer must not be blank before approving this export control form');
                        break;
                    }

                 
            }
        }
            /*List<Id> idList = new List<Id>();
            boolean isAtt1Chk = false;
            boolean isAtt2Chk = false;
            boolean isError = false;
            String errStr = '';
            String q4Desc = EnvironmentVariable.get('EXP_CON_FORM_Q4_DESC');
            String q5Desc = EnvironmentVariable.get('EXP_CON_FORM_Q5_DESC');
            String q4Name = EnvironmentVariable.get('QUES_4_STARTSWITH');
            String q5Name = EnvironmentVariable.get('QUES_5_STARTSWITH');
            
            for(Export_Control_Form__c ecf : Trigger.new){
                if((ecf.ITAR_Product__c=='Yes' && ecf.ITAR_Product_Details__c==null)
                    ||(ecf.US_EAR_Product__c=='Yes' && ecf.US_EAR_Product_Details__c==null)){
                        idList.add(ecf.Id);
                    }
            }
            
            Map<Id,Export_Control_Form__c> expCFMap 
                    = new Map<Id,Export_Control_Form__c>([select Id,
                                                          Name,(select id,
                                                          name 
                                                          from Attachments where name like 'Q4_%' or name like 'Q5_%')
                                                          from Export_Control_Form__c where Id = :idList]);
                                        
            // Validations for Questions Q4 and Q5
            for(Export_Control_Form__c ecf : Trigger.new){
                errStr = '';
                if((ecf.ITAR_Product__c=='Yes' && ecf.ITAR_Product_Details__c==null)
                    ||(ecf.US_EAR_Product__c=='Yes' && ecf.US_EAR_Product_Details__c==null)){                 
                     Export_Control_Form__c ecf1 = expCFMap.get(ecf.Id);
                     if(ecf1!=null){
                         for(Attachment att : ecf1.Attachments){
                             if(att.name.startsWith(q4Name)){
                                 isAtt1Chk = true;
                             }
                             if(att.name.startsWith(q5Name)){
                                 isAtt2Chk = true;
                             }
                         }
                     }
                     if((!isAtt1Chk) && ecf.ITAR_Product__c=='Yes' && ecf.ITAR_Product_Details__c==null){
                         isError = true;
                         errStr = q4Desc;
                     }
                     if((!isAtt2Chk) && ecf.US_EAR_Product__c=='Yes' && ecf.US_EAR_Product_Details__c==null){
                         isError = true;
                         if(errStr!=''){
                            String linebreak = '\n';
                            errStr = errStr + linebreak + q5Desc; 
                         }else{
                            errStr = q5Desc;
                         }
                     }
                     if(isError){
                         ecf.addError(errStr,true);
                     }   
                }
            }*/
        }
        
        
        /*if(Trigger.isBefore && Trigger.isUpdate){
            
            // retrieve the internal lock record type for Export Control Form
            RecordType oRecType = [select id from RecordType where SObjectType = :Schema.SObjectType.Export_Control_Form__c.getName()
                                   and name = 'GF Internal - � Lock' limit 1];
            
            for(Export_Control_Form__c expConForm: trigger.new){
                
                // set submitted date
                if(expConForm.Set_Submitted_Date__c){
                    expConForm.Submitted_Date__c = Date.today();
                    expConForm.Set_Submitted_Date__c = false;
                }
                
                // update record type to read only
                if(expConForm.Set_To_Read_Only__c){
                    expConForm.RecordTypeId = oRecType.Id;
                    expConForm.Set_To_Read_Only__c = false;
                }           
            } 
            
        }*/
        
        // Assigning the Last_Assigned Customer_User__c and Owner__c as the Owner Id on record creation
        if(Trigger.isBefore && Trigger.isInsert){
            for(Export_Control_Form__c expConForm: trigger.new){
                if(expConForm.OwnerId__c==null){
                    expConForm.OwnerId__c = UserInfo.getUserId();
                }
                if(expConForm.Last_Assigned_Customer_User__c==null){
                    expConForm.Last_Assigned_Customer_User__c = UserInfo.getUserId();
                }
            }       
        }
        
        // 08282013 ZAmbat - Added functionality to update Device of the Export Control Form's status
        // 11192013 ARoy - Removed the section for before insert after introduction of Export Control Junction object
        if (trigger.isAfter && trigger.isUpdate) {
            Set<Id> expConFormIds = new Set<Id>();
            Map<Id, Export_Control_Form__c> mapECF = new Map<Id, Export_Control_Form__c>(); 
            for (Export_Control_Form__c ecf : trigger.New) {
                if (ecf.Status__c != trigger.oldMap.get(ecf.Id).Status__c 
                        || ecf.Submitted_Date__c != trigger.oldMap.get(ecf.Id).Submitted_Date__c
                            || ecf.D1_National_Access_is_Allowed__c != trigger.oldMap.get(ecf.Id).D1_National_Access_is_Allowed__c) { 
                    expConFormIds.add(ecf.Id);
                    mapECF.put(ecf.Id,ecf);
                }
            }
    
            if (expConFormIds.size() > 0) {
                 List<Device_Export_Control_Junction__c> devExpConJunList 
                                =  [SELECT      Device__c, 
                                                Device__r.Is_ITAR__c,
                                                Export_Control_Form__c,
                                                Export_Control_Form__r.Status__c,
                                                Export_Control_Form__r.ITAR_Product__c
                                    FROM        Device_Export_Control_Junction__c
                                    WHERE       Export_Control_Form__c IN :expConFormIds];
                
                Map<String, String> devExpConJunMap = new Map<String, String>();
                Map<id,Device_Export_Control_Junction__c> deviceITARFAE = New Map<id,Device_Export_Control_Junction__c>();    
                if(devExpConJunList.size()>0){
                    for(Device_Export_Control_Junction__c devExpConJunc : devExpConJunList){
                        devExpConJunMap.put(devExpConJunc.Device__c, devExpConJunc.Export_Control_Form__c);
                        deviceITARFAE.put(devExpConJunc.Device__c,devExpConJunc);
                    }
                }
                
                List<Device__c> devList = [SELECT   Export_Control_Status__c,
                                                    Export_Control_Form_Submitted_Date__c,
                                                    D1_National_Access_Allowed__c,
                                                    ECCN_Wafer__c,ECCN_Technology__c
                                           FROM     Device__c
                                           WHERE    Id = :devExpConJunMap.keySet()];
                
                if (devList.size() > 0) {
                    for (Device__c d : devList) {
                        if(!devExpConJunMap.isEmpty() && devExpConJunMap.containsKey(d.Id)){
                            if(!mapECF.isEmpty() && mapECF.containsKey(devExpConJunMap.get(d.Id))){
                                d.Export_Control_Status__c = mapECF.get(devExpConJunMap.get(d.Id)).Status__c;
                                d.Is_D1_Nat_Allowed_Check__c = true;
                                d.D1_National_Access_Allowed__c = mapECF.get(devExpConJunMap.get(d.Id)).D1_National_Access_is_Allowed__c;  
                                //commented by Naman : as these values will be populated once ECCN Form is approved
								//d.ECCN_Wafer__c=mapECF.get(devExpConJunMap.get(d.Id)).ECCN_Wafer__c;
                                //d.ECCN_Technology__c=mapECF.get(devExpConJunMap.get(d.Id)).ECCN_Technology__c;
                                d.Export_Control_Form_Submitted_Date__c = mapECF.get(devExpConJunMap.get(d.Id)).Submitted_Date__c;                                
                            }
                        }
                        /*Commented by gopi,But in future this code need to be enabled.*/
						//Uncommented by Naman
                        if(deviceITARFAE.containsKey(d.id)){
                            if(deviceITARFAE.get(d.id).Export_Control_Form__r.Status__c == 'Approved'){
                                d.Dup_ITAR_GTC__c = deviceITARFAE.get(d.id).Export_Control_Form__r.ITAR_Product__c;
								/*Added by Naman : Classification status will be set based on Q4 on Export Control form and set ECCN Technology and ECCN Wafer value from 
                                Export Control form to Device*/
                                d.ECCN_Technology__c = mapECF.get(deviceITARFAE.get(d.id).Export_Control_Form__c).ECCN_Technology__c;
                                d.ECCN_Wafer__c = mapECF.get(deviceITARFAE.get(d.id).Export_Control_Form__c).ECCN_Wafer__c;
                                d.D1_National_Access_Allowed__c = mapECF.get(deviceITARFAE.get(d.id).Export_Control_Form__c).D1_National_Access_is_Allowed__c;
                                d.ECCN_Color__c = mapECF.get(deviceITARFAE.get(d.id).Export_Control_Form__c).ECCN_Color__c;
                                d.ITAR_Flag_Old_Value__c = d.ITAR_Flag__c;
                                
                                //CDS_Color_zone__c color = new CDS_Color_zone__c();                                
                                DeviceITAR__c myCS1 = new DeviceITAR__c();
                                /*if(mapECF.get(deviceITARFAE.get(d.id).Export_Control_Form__c).ECCN_Technology__c != null){
                                    color = CDS_Color_zone__c.getInstance(mapECF.get(deviceITARFAE.get(d.id).Export_Control_Form__c).ECCN_Technology__c);                                    
                                }*/
                                
                                if(mapECF.get(deviceITARFAE.get(d.id).Export_Control_Form__c).ITAR_Product__c == 'Yes' || (mapECF.get(deviceITARFAE.get(d.id).Export_Control_Form__c).ECCN_Color__c != null && mapECF.get(deviceITARFAE.get(d.id).Export_Control_Form__c).ECCN_Color__c != '' && mapECF.get(deviceITARFAE.get(d.id).Export_Control_Form__c).ECCN_Color__c == 'RED')){
                                    myCS1 = DeviceITAR__c.getValues('Yes');                                    
                                }
                                else{
                                    myCS1 = DeviceITAR__c.getValues('No');
                                }
                                
                                d.Is_ITAR__c = myCS1.ITAR_Classification_Status__c;
                                
                                if(myCS1.ITAR_Classification_Status__c == DeviceITAR__c.getValues('Yes').ITAR_Classification_Status__c && mapECF.get(deviceITARFAE.get(d.id).Export_Control_Form__c).ITAR_Product__c == 'Yes'){
                                     d.ITAR_Flag__c = 'Yes';  
                                }
                                else if(myCS1.ITAR_Classification_Status__c == DeviceITAR__c.getValues('No').ITAR_Classification_Status__c  ||
                                        (myCS1.ITAR_Classification_Status__c == DeviceITAR__c.getValues('Yes').ITAR_Classification_Status__c && mapECF.get(deviceITARFAE.get(d.id).Export_Control_Form__c).ITAR_Product__c == 'No')){
                                    d.ITAR_Flag__c = 'No';
                                }
                                
                                /*if(mapECF.get(deviceITARFAE.get(d.id).Export_Control_Form__c).ITAR_Product__c == 'Yes'){
                                    d.Is_ITAR__c = 'ITAR/RED Zone Confirmed by GTC';                                    
                                    d.ITAR_Flag__c = 'Yes';
                                }
                                else if(mapECF.get(deviceITARFAE.get(d.id).Export_Control_Form__c).ITAR_Product__c == 'No'){
                                    d.Is_ITAR__c = 'NON-ITAR/NON-RED Zone Confirmed by GTC';
                                    d.ITAR_Flag__c = 'No';
                                }*/
                            }/*else{
                                d.Dup_ITAR_GTC__c = deviceITARFAE.get(d.id).Device__r.Is_ITAR__c;
                            }*/
                        }
                    }               
                    Skip_Validation__c skipval = new Skip_Validation__c();
                    if(!devList.isEmpty()){  
                        skipval.name=userinfo.getUserRoleId();
                        skipval.skip__c=true;
                        insert skipval;           
                        update devList;                    
                    }
                    
                    if(skipval != null){
                        delete skipval;
                    }
                }
            }
        }
        
        // Update the D1_National_Access_is_Allowed prior value to Prev_D1_National_Access_is_Allowed field in Export Control Form.
        // 12052013 ARoy - Updation for making comments on rejection mandatory for Export Control Form Approval.
        if(Trigger.isBefore && Trigger.isUpdate){
            Map<Id,Export_Control_Form__c> expConFormMap = new Map<Id,Export_Control_Form__c>();
            for(Export_Control_Form__c expConForm : trigger.new){
                if(expConForm.Status__c == Environment_Variable__c.getInstance('EXP_CON_STATUS_APPROVED').Value__c  
                        && expConForm.D1_National_Access_is_Allowed__c != trigger.oldMap.get(expConForm.id).D1_National_Access_is_Allowed__c){
                    expConForm.Prev_D1_National_Access_is_Allowed__c = trigger.oldMap.get(expConForm.id).D1_National_Access_is_Allowed__c;
                }
                
                // Check with old object record to find if the Status__c field has been updated to Pending Resubmission
                if(trigger.oldMap.get(expConForm.id).Status__c <> Environment_Variable__c.getInstance('EXP_CON_STATUS_PENDING_RESUBMISSION').Value__c 
                    && expConForm.Status__c == Environment_Variable__c.getInstance('EXP_CON_STATUS_PENDING_RESUBMISSION').Value__c){           
                    expConFormMap.put(expConForm.id,expConForm);
                }
            }
            
            if(!expConFormMap.isEmpty()){
                Map<Id,ProcessInstance> processInstanceMap = new Map<Id,ProcessInstance>(); 
                
                //Get the last approval process for the rejected approvals and check the comments.  
                List<ProcessInstance>  processInstanceList= [SELECT TargetObjectId, 
                                                              (  
                                                                 SELECT Id, StepStatus, Comments 
                                                                 FROM Steps
                                                                 WHERE StepStatus = 'Rejected'
                                                                 ORDER BY CreatedDate DESC
                                                                 LIMIT 1 
                                                              )
                                                               FROM ProcessInstance
                                                               WHERE TargetObjectId In 
                                                                 :expConFormMap.keySet()
                                                                 and Status = 'Rejected'
                                                               ORDER BY CreatedDate DESC
                                                              ];
                
                // Getting the unique process instance into a Map                                                
                for(ProcessInstance pi : processInstanceList){
                    if(!processInstanceMap.containsKey(pi.TargetObjectId)){
                        processInstanceMap.put(pi.TargetObjectId,pi);
                    }
                }
                
                //Add error message for making comments mandatory on approval process rejection    
                for (ProcessInstance pi : processInstanceMap.values())
                {                 
                    if ((pi.Steps[0].Comments == null || pi.Steps[0].Comments.trim().length() == 0)
                            &&(pi.Steps[0].StepStatus =='Rejected'))
                    {
                        expConFormMap.get(pi.TargetObjectId).addError('Please provide comments on rejection.');               
                    }
                }
                                    
            }
        }   
    }
}