/*
    Author: Ariz Solito
    Description: Apex class for reassigning Export Control Forms to a Device
    History: 
    Asolito      09/13/2013    - Apex code created
    Asolito      10/03/2013    - changed code design based on new enhancement
    Vijay        02202015      - updated the code to support the Internal Device functionality. Added the Device Record type check and for Internal device the 
                                 approval/rejection mails will sent to Account administrator rol ATP members
    Jabee       26042017      - we have aded two export contol form fields to display on device in line 175 and 221-223                             
                                 
*/ 
public class ReassignExportControl {  
    public static Boolean hasRun = false;   
    private static final String APPROVED = 'Export Control Reassign Approved';
    private static final String REJECTED = 'Export Control Reassign Rejected';        
    private static final String OPPTY_PROG_TM_ROLE_FTS = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_FTS');
    private static final String OPPTY_PROG_TM_ROLE_FAE = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_FAE');
    
    //Method will get the FAE and FTS under the device
    private static Map<String,List<String>> getEmails(Set<String> opptyProgIDs){
        Map<String,List<String>> expMails = new Map<String,List<String>>();
        
        for(Opportunity_Program__c rec :[SELECT id,(SELECT user__r.email
                                            FROM Opportunity_Program_Team_Members__r
                                            WHERE (Team_role__c IN (:OPPTY_PROG_TM_ROLE_FTS,:OPPTY_PROG_TM_ROLE_FAE)
                                                   OR (Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                                   OR (Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE)))
                                         FROM Opportunity_Program__c
                                         WHERE id IN : opptyProgIDs]){
            for(Opportunity_Program_Team_Member__c o :rec.Opportunity_Program_Team_Members__r){
                if(UtilsString.isNotBlank(o.user__r.email)){
                    if(expMails.containsKey(rec.id)){
                        expMails.get(rec.id).add(o.user__r.email);
                    } else {
                        expMails.put(rec.id,new List<String>{o.user__r.email});
                    }
                }
            }                    
        } 
        return expMails;                                                    
    }        
    
    //Method will send rejected emails to owners
    public static void sendRejectedReassign(List<String> deviceIDs){
        ReassignExportControl.hasRun = true;                   
                                
        Map<String,List<String>> expOpptyProgMap = new Map<String,List<String>>();
        //Map of Account and Export Controls
        Map<Id,List<String>> exportCtrlAccountMap = new Map<Id,List<String>>();
        
        for(Device__C d :[SELECT opportunity_program__c,
                                 (SELECT id 
                                    FROM Device_Export_Control_Junctions__r), Account__c, RecordType.DeveloperName
                            FROM Device__c
                            WHERE id IN:deviceIDs]){ 
            if(d.RecordType.DeveloperName != null && (d.RecordType.DeveloperName == 'Device' || d.RecordType.DeveloperName == 'Read_Only')){
                for(Device_Export_Control_Junction__c j: d.device_export_control_junctions__r){
                    if(expOpptyProgMap.containsKey(d.opportunity_program__c)){
                        expOpptyProgMap.get(d.opportunity_program__c).add(j.id);
                    } else {
                        expOpptyProgMap.put(d.opportunity_program__c,new List<String>{j.id});
                    }                           
                }
            }else{
                for(Device_Export_Control_Junction__c j: d.device_export_control_junctions__r){
                    if(exportCtrlAccountMap.containsKey(d.Account__c)){
                        exportCtrlAccountMap.get(d.Account__c).add(j.id);
                    } else {
                        exportCtrlAccountMap.put(d.Account__c,new List<String>{j.id});
                    }                           
                }
            }  
                                          
        }    
              
        //updated by Vijay 02102015 - updated below code to get email Ids based on Device type
        Map<String,List<String>> expEmails = new Map<String,List<String>>();
        Map<String,List<String>> finalEmailMaps = new Map<String,List<String>>();
        
        if(!expOpptyProgMap.isEmpty()){ 
            expEmails = getEmails(expOpptyProgMap.keySet());
            for(String e: expOpptyProgMap.keyset()){
                if(expEmails!= null && expEmails.containsKey(e)){
                    List<String> emails = expEmails.get(e);        
                    for(String r: expOpptyProgMap.get(e)){
                        finalEmailMaps.put(r,emails);
                    }
                }
            }
        }else if(!exportCtrlAccountMap.isEmpty()){
            String accountAdminRole = (EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_AA') != null)? EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_AA') :'Account Administrator';
            expEmails = ExpConWaiverService.getAccountAdminEmailIds(exportCtrlAccountMap.Keyset(), new List<String>{accountAdminRole});
            for(String e: exportCtrlAccountMap.keyset()){
                if(expEmails != null && expEmails.containsKey(e)){
                    List<String> emails = expEmails.get(e);        
                    for(String r: exportCtrlAccountMap.get(e)){
                        finalEmailMaps.put(r,emails);
                    }
                }
            }
        } 
        
        if(!finalEmailMaps.isEmpty()){                                 
            sendEmail(REJECTED,finalEmailMaps);
        }                                     
    }        
    
    //Method will be called from the VF Reassign Export Control        
    public static void processReassign(Device__c dev){
        processReassign(new Map<Id,Device__c>{dev.id=>dev},new List<String>{dev.id});
    }
        
    //Method will associate the inputted export control record    
    //called by trigger
    public static String processReassign(Map<Id,Device__c> deviceMap, List<String> deviceIDs){ 
        ReassignExportControl.hasRun = true;                   
        List<Device__c> updateDevices = new List<Device__c>([SELECT id, reassigned_export_control__c,opportunity_program__c,
                                                                    approve_reassign_export_control_number__c,D1_national_access_allowed__c,                                                                    
                                                                   (SELECT id,export_control_form__c,export_control_form__r.id                                                                             
                                                                      FROM Device_Export_Control_Junctions__r), Account__c, RecordType.DeveloperName
                                                               FROM Device__c
                                                               WHERE id IN :deviceIDs]);

        List<String> expIDs = new List<String>();
        Map<Id,Export_Control_Form__c> unrelateExpMap = new Map<Id,Export_Control_Form__c>();                
        Map<String,List<String>> expOpptyProgMap = new Map<String,List<String>>();
        //Map of Account and Export Controls
        Map<Id,List<String>> exportCtrlAccountMap = new Map<Id,List<String>>();
        
        for(Device__c u: updateDevices){
            //get the export control numbers for querying its SFDC id later
            //remove the base url
            expIDs.add(u.reassigned_export_control__c);
            
            if(u.RecordType.DeveloperName != null && (u.RecordType.DeveloperName == 'Device' || u.RecordType.DeveloperName == 'Read_Only')){
                //get the export control IDs which will be replaced
                for(Device_Export_Control_Junction__c j: u.Device_Export_Control_Junctions__r){
                    unrelateExpMap.put(j.export_control_form__c,j.export_control_form__r);
                    
                    if(expOpptyProgMap.containsKey(u.opportunity_program__c)){
                        expOpptyProgMap.get(u.opportunity_program__c).add(j.id);
                    } else {
                        expOpptyProgMap.put(u.opportunity_program__c,new List<String>{j.id});                                
                    }            
                }
            }else{
                System.debug('In Internal Device---'+u);
                System.debug('In Internal Device---'+u.Device_Export_Control_Junctions__r);
                //get the export control IDs which will be replaced
                for(Device_Export_Control_Junction__c j: u.Device_Export_Control_Junctions__r){
                    unrelateExpMap.put(j.export_control_form__c,j.export_control_form__r);
                    if(exportCtrlAccountMap.containsKey(u.Account__c)){
                        exportCtrlAccountMap.get(u.Account__c).add(j.id);
                    } else {
                        exportCtrlAccountMap.put(u.Account__c,new List<String>{j.id});                                
                    }   
                }
                
            }
        }
        
        //updated by Vijay 02102015 - updated below code to get email Ids based on Device type
        Map<String,List<String>> expEmails = new Map<String,List<String>>();
        if(!expOpptyProgMap.isEmpty()){ 
            expEmails = getEmails(expOpptyProgMap.keySet());
        }else if(!exportCtrlAccountMap.isEmpty()){
            System.debug('In Internal Device exportCtrlAccountMap---'+exportCtrlAccountMap);
            String accountAdminRole = (EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_AA') != null)? EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_AA') :'Account Administrator';
            expEmails = ExpConWaiverService.getAccountAdminEmailIds(exportCtrlAccountMap.Keyset(), new List<String>{accountAdminRole});
            System.debug('In Internal Device expEmails---'+expEmails);
        }              
        
        //Create the name,ID map of the export control forms to be related
        Map<String,Export_Control_Form__c> relateExpMap = new Map<String,Export_Control_Form__c>();
        for(Export_Control_Form__c e: [SELECT name,id,status__c,owner.email,D1_national_access_is_allowed__c,ECCN_Wafer__c,ECCN_Technology__c,ITAR_Product__c,ECCN_Color__c,Export_Control_Template__c
                                         FROM Export_Control_Form__c
                                         WHERE id IN :expIDs]){
            relateExpMap.put(e.id,e);
        }
          
        List<Device_Export_Control_Junction__c> updateJunctions = new List<Device_Export_Control_Junction__c>();                               
        Map<String,List<String>> finalEmailMaps = new Map<String,List<String>>();
        
        //Update the junction record with the new export control id
        //and set the device's 2 fields for reassigning export control to blank
        
        List <Device__c> devListToUpd = new List<Device__c>();
        for(Device__c d: updateDevices){
            for(Device_Export_Control_Junction__c j :d.Device_Export_Control_Junctions__r){
                if(relateExpMap.containsKey(d.reassigned_export_control__c)){
                    Export_Control_Form__c exp = relateExpMap.get(d.reassigned_export_control__c);
                    j.export_control_form__c = exp.id;
                    
                    if(d.RecordType.DeveloperName != null && (d.RecordType.DeveloperName == 'Device' || d.RecordType.DeveloperName == 'Read_Only')){
                        //get the emails of FAE and FTS for reach export control record
                        if(expOpptyProgMap.containsKey(d.opportunity_program__c)){                       
                            if(expEmails.containsKey(d.opportunity_program__c)){        
                                List<String> emails = expEmails.get(d.opportunity_program__c);        
                                for(String r: expOpptyProgMap.get(d.opportunity_program__c)){
                                    finalEmailMaps.put(r,emails);
                                }
                            }
                        } 
                    }else{
                        System.debug('In Internal Device ---'+expEmails);
                        if(exportCtrlAccountMap.containsKey(d.Account__c)){                       
                            if(expEmails.containsKey(d.Account__c)){        
                                List<String> emails = expEmails.get(d.Account__c);        
                                for(String r: exportCtrlAccountMap.get(d.Account__c)){
                                    finalEmailMaps.put(r,emails);
                                }
                            }
                        } 
                    }                                              
                                                                              
                    updateJunctions.add(j);                                        
                    
                    //set the fields to null
                    if(deviceMap.containsKey(d.id)){
                        Device__c dev = deviceMap.get(d.id);
                        dev.reassigned_export_control__c = null;
                        dev.approve_reassign_export_control_number__c = null;
                        dev.D1_national_access_allowed__c = exp.D1_national_access_is_allowed__c;
                        dev.ECCN_Wafer__c=exp.ECCN_Wafer__c;
                        dev.ECCN_Technology__c=exp.ECCN_Technology__c;
                        dev.export_control_status__c = exp.status__c;
                        dev.ECCN_Color__c = exp.ECCN_Color__c;
                        dev.Export_Control_Template__c = exp.Export_Control_Template__c;
                        
                        //CDS_Color_zone__c color = new CDS_Color_zone__c();                                
                        DeviceITAR__c myCS1 = new DeviceITAR__c();
                        /*if(exp.ECCN_Technology__c != null){
                            color = CDS_Color_zone__c.getInstance(exp.ECCN_Technology__c);                                    
                        }*/

                        if(exp.ITAR_Product__c == 'Yes' || (exp.ECCN_Color__c != null && exp.ECCN_Color__c != '' && exp.ECCN_Color__c == 'RED')){
                            myCS1 = DeviceITAR__c.getValues('Yes');                                    
                        }
                        else{
                            myCS1 = DeviceITAR__c.getValues('No');
                        }

                        dev.Is_ITAR__c = myCS1.ITAR_Classification_Status__c;

                        if(myCS1.ITAR_Classification_Status__c == DeviceITAR__c.getValues('Yes').ITAR_Classification_Status__c && exp.ITAR_Product__c == 'Yes'){                                    
                             dev.ITAR_Flag__c = 'Yes';                                    
                        }                                
                        else if(myCS1.ITAR_Classification_Status__c == DeviceITAR__c.getValues('No').ITAR_Classification_Status__c ||
                                (myCS1.ITAR_Classification_Status__c == DeviceITAR__c.getValues('Yes').ITAR_Classification_Status__c && exp.ITAR_Product__c == 'No')){
                            dev.ITAR_Flag__c = 'No';
                        }
                        devListToUpd.add(dev);
                    }                       
                }
            }
        } 
        
        //this will be fired via the VF Reassign Export Control only
        if(!system.trigger.isExecuting){
            if(!devListToUpd.isEmpty()){
                update devListToUpd;
            }
        }
        
        //remove the diassociated export control record from the delete list if its being associated to another 
        //export control
        for(Device_Export_Control_Junction__c e: [SELECT id,export_control_form__c
                                                    FROM Device_Export_Control_Junction__c
                                                    WHERE export_control_form__c IN :unrelateExpMap.keySet()]){
            unrelateExpMap.remove(e.export_control_form__c);                                                                 
        }                                                                                                                                                                       

        try {
            System.debug('In updateJunctions ---'+updateJunctions);
            update updateJunctions;         
            
            List<Export_Control_Form__c> delExps = new List<Export_Control_Form__c>();
            delExps.addAll(unrelateExpMap.values());
            
            System.debug('In delExps ---'+delExps);
            delete delExps; 
            
                       
            System.debug('In finalEmailMaps ---'+finalEmailMaps);
            sendEmail(APPROVED,finalEmailMaps);
        } catch(Exception e){
            return 'Error reassigning the Export Control record. Please contact the administrator.';
        }
        return 'The Export Control was reassigned successfully';
    } 
    
    //Method will send email notification to the GTC and FE thru custom button Reassign Export Control in Device
    private static void sendEmail(String emailTemplateName,Map<String,List<String>> emails){             
            
        List<Messaging.SingleEmailMessage> msgs = new List<Messaging.SingleEmailMessage>();
        EmailTemplate temp1 = [SELECT id FROM EmailTemplate WHERE name = :emailTemplateName]; 
        
        if(emails.size() > 0){      
            for(String e: emails.keySet()){  
                Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(temp1.id,
                                                                                   e,
                                                                                   null,
                                                                                   emails.get(e),
                                                                                   new list<string>{Userinfo.getuseremail()},
                                                                                   null);
                if(msg <> null){                                                                                   
                    msgs.add(msg);                                                                                   
                }
            }                                                                               
            try {
                Messaging.sendEmail(msgs);
            } catch(Exception e){
                System.debug(e);
            }
        }                  
    }                                                                                                                                                                 
}