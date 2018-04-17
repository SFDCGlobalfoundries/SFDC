/*
    Author: Ariz Solito
    Description: Apex class for retrofit devices
    History: 
    Asolito     09062013    - Apex coded created.
    ZAmbat      09192013    - Modified Device_Export_Control_Junction__c record creation (Point the new record(s) to the existing Export Control record(s)).
    ARoy        10022013    - Removed the Form_Completed__c field from the query (Task - 361)
    ARoy        10082013    - Removed the Form_Waived__c field from the query (Task - 415)
    Asolito     10102013    - Added fix for Task 439
*/
public with sharing class DeviceRetrofit {
    
    //Method will generate cloned IP declaration and Export control form from the retrofit device's base device
    public static void cloneIPDecAndExpCon(Map<String,List<String>> deviceIDMap){
    
        List<IPDeclarationRecord> IPs = new List<IPDeclarationRecord>();
        List<String> newDeviceIDs = new List<String>();
                        
        for(IP_Declaration_Form__c ip:  [SELECT Account__c,CRM_Device_ID__c,Customer_Contact__c,Customer_Name__c,Device__c,
                                                Email_Address__c,Form_Completed__c,Form_Submitted_Date__c,Job_Title__c,
                                                Last_Assigned_Customer_User__c,Matching_Status__c,Notes_to_New_Owner__c,
                                                Nothing_to_Declare__c,Other_3rd_Party_IP__c,OwnerId__c,Phone__c,
                                                Reset_Record_Type__c,Status__c,Step_1_Approver_1__c,Step_1_Approver_2__c,
                                                Step_1_Approver_3__c,Step_1_Approver_4__c,Step_1_Approver_5__c,Step_1_Approver_6__c,
                                                Step_1_Approver_7__c,Step_1_Approver_8__c,Step_1_Approver_9__c,Step_1_Approver_10__c,
                                                device__r.npc_form__r.tapeout_required__c,
                                                (SELECT Design_ID__c,FV_IP_Type__c,FV_Vendor__c,Geometry__c,Id,IP_Component__c,
                                                        IP_Type_Desc__c,IP_Type__c,Master_IP_Component__c,OIC_IP_Component__c,
                                                        Tech_Geometry__c,Tech_Type__c,Vendor__c,X5V_Only__c 
                                                   FROM IP_Declaration_Component__r),
                                                (SELECT Account_ShortName__c,CRM_DID__c,Customer__c,Design_ID__c,Form_Owner__c,
                                                        IP_Declaration_Form__c,IP_Decl_Flag__c,IP_Decl_Form_ID__c,IP_Library_Type__c,
                                                        IP_Type_Desc__c,IP_Vendor__c,Matching_Result__c,Name,OIC_IP_Component_ID__c,
                                                        Other_Party_IP__c,Program__c,Source__c,Technical_Geometry__c,Technical_Type__c,
                                                        VCID_Flag__c 
                                                   FROM IP_Form_Matching_Result__r)
                                           FROM IP_Declaration_Form__c
                                           WHERE device__c IN :deviceIDMap.keyset()]){
            if(deviceIDMap.containsKey(ip.device__c)){                                          
                for(String deviceID: deviceIDMap.get(ip.device__c)){                                                                
                    IPs.add(new IPDeclarationRecord(ip,deviceID));
                    newDeviceIDs.add(deviceID);
                }
            }                                                                           
        } 
               
        Map<String,Export_Control_Form__c> expMap = new Map<String,Export_Control_Form__c>();
        for(Device_Export_Control_Junction__c d: [SELECT export_control_form__r.D1_National_Access_is_Allowed__c,
                                                         export_control_form__r.Daily_Reminder__c,export_control_form__r.Email_Address__c,
                                                         export_control_form__r.ITAR_Product_Details__c,export_control_form__r.ITAR_Product__c,
                                                         export_control_form__r.Last_Assigned_Customer_User__c,export_control_form__r.Military_App_Product_Details__c,
                                                         export_control_form__r.Military_App_Product__c,export_control_form__r.Non_US_EAR_Product_Details__c,
                                                         export_control_form__r.Non_US_EAR_Product__c,export_control_form__r.Notes_to_New_Owner__c,
                                                         export_control_form__r.Other_Harmonized_System__c,export_control_form__r.OwnerId__c,
                                                         export_control_form__r.Phone__c,export_control_form__r.Product_Description__c,
                                                         export_control_form__r.Status__c,export_control_form__r.Submitted_Date__c,
                                                         export_control_form__r.US_EAR_Product_Details__c,export_control_form__r.US_EAR_Product__c,
                                                         export_control_form__r.Weapon_Product__c,export_control_form__r.Weekly_Reminder__c,
                                                         export_control_form__r.Harmonized_System__c,device__c
                                                    FROM Device_Export_Control_Junction__c
                                                    WHERE device__c IN :deviceIDMap.keyset()]){
            expMap.put(d.device__c,d.export_control_form__r);
        }  
                       
        List<JunctionRecord> junctions = new List<JunctionRecord>();
        
        for(String e : expMap.keyset()){
            if(deviceIDMap.containsKey(e)){ 
                for(String deviceID: deviceIDMap.get(e)){                                                               
                    junctions.add(new JunctionRecord(deviceID, expMap.get(e)));
                }
            }    
        }
        
        try {
            List<IP_Declaration_Form__c> newIPs = new List<IP_Declaration_Form__c>();
            List<IP_Declaration_Component__c> newIPComps = new List<IP_Declaration_Component__c>();
            List<IP_Declaration_Component__c> tapeoutReqIPComps = new List<IP_Declaration_Component__c>();
            List<IP_Form_Matching_Result__c> newMatches = new List<IP_Form_Matching_Result__c>();                        
                
            Set<String> NPCTapeoutRequired = new Set<String>();
                        
            for(Device__c d :[SELECT id,npc_form__r.tapeout_required__c
                                FROM Device__c
                                WHERE id IN :newDeviceIDs]){
                if(d.npc_form__r.tapeout_required__c == 'Yes'){  
                    NPCTapeoutRequired.add(d.id);
                } 
            }                                            
            
            //stop ip matching from firing when the IP declaration forms are inserted                    
            IPDeclarationMatching.hasMatchingRun = true;                
            
            for(IPDeclarationRecord i: IPs){
                if(NPCTapeoutRequired.contains(i.ip.device__c)){
                    i.ip.status__c = 'Submitted';
                }
                newIPs.add(i.ip);
            }
            insert newIPs;
                                                                 
            for(IPDeclarationRecord i: IPs){
                //Device is tapeout required
                if(NPCTapeoutRequired.contains(i.ip.device__c)){
                    tapeoutReqIPComps.addAll(i.setIPDecIDForComp());    
                } else {            
                    newIPComps.addAll(i.setIPDecIDForComp());
                    newMatches.addAll(i.setIPDecIDForMatch());                                                                                                         
                }
            } 
            
            if(tapeoutReqIPComps.size() > 0){
                //fire the matching process
                IPDeclarationMatching.hasMatchingRun = false;   
                insert tapeoutReqIPComps;  
            }
                        
            insert newIPComps;
            insert newMatches;            
            
            List<Device_Export_Control_Junction__c> newJunctions = new List<Device_Export_Control_Junction__c>();
            
            for(JunctionRecord j: junctions){
                Device_Export_Control_Junction__c rec = new Device_Export_Control_Junction__c(
                    device__c = j.deviceID,
                    export_control_form__c = j.exp.id
                );
                newJunctions.add(rec);
            }
            
            insert newJunctions;
   
       } catch(Exception e){
           System.debug(e);
       }
    }
    
    public class IPDeclarationRecord {
        public IP_Declaration_Form__c ip;
        public List<IP_Declaration_Component__c> comps;
        public List<IP_Form_Matching_Result__c> matches;
        
        public IPDeclarationRecord(IP_Declaration_Form__c ip,String deviceID){                      
            this.IP = ip.clone(false,true,false,false);
            this.ip.device__c = deviceID; 
            
            this.comps = new List<IP_Declaration_Component__c>(); 
            for(IP_Declaration_Component__c c: this.ip.IP_Declaration_Component__r){                            
                IP_Declaration_Component__c temp = c.clone(false,true,false,false);
                temp.ip_declaration_form__c = null;             
                this.comps.add(temp);
            }
            
            this.matches = new List<IP_Form_Matching_Result__c>();
            for(IP_Form_Matching_Result__c i: this.ip.IP_Form_Matching_Result__r){
                IP_Form_Matching_Result__c temp = i.clone(false,true,false,false);
                temp.ip_declaration_form__c = null;
                this.matches.add(temp);
            }
        } 
        
        public List<IP_Declaration_Component__c> setIPDecIDForComp(){
            for(IP_Declaration_Component__c c :this.comps){
                c.ip_declaration_form__c = this.IP.id;
            }           
            return this.comps;
        }   
        
        public List<IP_Form_Matching_Result__c> setIPDecIDForMatch(){
            for(IP_Form_Matching_Result__c i :this.matches){
                i.ip_declaration_form__c = this.IP.id;
            }           
            return this.matches;
        }           
    }
    
    public class JunctionRecord {
        public String deviceID;
        public Export_Control_Form__c exp;
        
        public JunctionRecord(String deviceID,Export_Control_Form__c exp){
            this.deviceID = deviceID;
            this.exp = exp;
        }
    }            
}