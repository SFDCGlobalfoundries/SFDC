/*****************************************************************************************
@ Class:          DevicePscPsautilcls
@ Version:        1.0
@ Author:         Cognizant
@ Purpose:        This Utility Class has the logic to generate desired PSC / PSA on Device
------------------------------------------------------------------------------------------------
@ Change history: 
    DATE                NAME            Comment
    16-Jan-2018         Poulami Saha    Code optimization.
******************************************************************************************/
public without sharing class DevicePscPsautilcls {

    public map<string,string> eccnmappsa{get;set;}
    public map<string,string> eccnmappsc{get;set;}
    public map<string,string> defaultpsa3d{get;set;}
    public map<string,string> defaultpsc3d{get;set;} 
    public map<string,string> nondefaultpsa3d{get;set;} 
    public map<string,string> nondefaultpsc3d{get;set;} 
    public boolean checkoptioneccn{get;set;} 
    
    public String[] toAddresses{get;set;}
    public String[] ccAddresses{get;set;}
    public Set<Id> userId{get;set;}
    public Contact c{get;set;}
    public EmailTemplate et{get;set;}
    public boolean sendEmailNotification{get;set;}
    public List<id> devIds{get;set;}
    
    public DevicePscPsautilcls(){
        checkoptioneccn = false;
    }
   
    public void updatePsaPsc(Map<Id, Device__c> newDevices, Map<Id,Device__c> oldDevices){
        try{  
            sendEmailNotification = false;
            if(newDevices!= null){
                System.debug('@@Outside 1st Rec');
                // added by Naman : as this method was running twice
                System.debug('@@Inside 1st Rec');
                for(id did: newDevices.keySet()){
                    //converting comma separated Fabcheck custom label into set of string
                    string fabstr = label.fabcheck;
                    list<string> fbcheck = fabstr.split(',');     
                    Set<string> fabcheck1 = new Set<string>(fbcheck);
                    string OptionECCN = label.OptionECCNFabCheck;
                    list<string> OptionECCNfbcheck = OptionECCN.split(',');  
                    Set<string> OptionECCNfabcheck1 = new Set<string>(OptionECCNfbcheck);

                    //converting comma separated Endcustomer custom label into set of string
                    string ecustomer = label.Endcustomer;
                    list<string> Endcustomer = ecustomer.split(',');
                    Set<string> Endcustomerst = new Set<string>(Endcustomer);
                    System.debug('@@@@end'+Endcustomerst);
                    //converting comma separated Endcustomercontract custom label into set of string
                    string ecustomercontract = label.Endcustomercontract;
                    list<string> Endcustomercontract = ecustomercontract.split(',');
                    Set<string> Endcustomerstcontract = new Set<string>(Endcustomercontract); 
                    set<Id> toUpdatedDevicesId = new Set<Id>();
                    devIds = new List<id>();
                    
                    if((newDevices.get(did).Account__c != null) && (newDevices.get(did).Automotive_Device__c != null) && newDevices.get(did).Target_Process_Node_Formula__c != null && newDevices.get(did).ITAR_Flag__c != null && (newDevices.get(did).ECCN_Technology__c != null || (newDevices.get(did).ECCN_Technology__c == null && newDevices.get(did).ITAR_Flag__c == 'Yes')) && newDevices.get(did).is3D_offering__c != null && fabcheck1.contains(newDevices.get(did).Fab__c)){
                        //System.debug('@@Outside 2nd Rec');
                        System.debug('@@Inside 1st loop all');
                            boolean endcustomercheck = false;
                            boolean endcustomercontrcheck= false;
                            System.debug('@@end'+newDevices.get(did).AccountName_formula__c);     

                            if(newDevices.get(did).AccountName_formula__c != null){     
                                endcustomercheck=Endcustomerst.contains(newDevices.get(did).AccountName_formula__c.toUpperCase());    
                                System.debug('@@end'+endcustomercheck);     
                                System.debug('@@@end'+newDevices.get(did).AccountName_formula__c.toUpperCase());
                                System.debug('@@@end'+Endcustomerst.contains(newDevices.get(did).AccountName_formula__c.toUpperCase()));                
                            }
                            if(newDevices.get(did).AccountName_formula__c != null){
                                endcustomercontrcheck=Endcustomerstcontract.contains(newDevices.get(did).AccountName_formula__c.toUpperCase());     
                            }

                            //Check Condition1: If device is associated with FAB 8/9/10.
                            if(fabcheck1.contains(newDevices.get(did).Fab__c)){                    
                                //Check Condition2: Key five fields not equals to null
                                //Updated the condition by Naman - removal of Option_ECCN__c reference          
                                if((newDevices.get(did).Account__c != null) && (newDevices.get(did).Automotive_Device__c != null) && newDevices.get(did).Target_Process_Node_Formula__c != null && newDevices.get(did).ITAR_Flag__c != null && (newDevices.get(did).ECCN_Technology__c != null || (newDevices.get(did).ECCN_Technology__c == null && newDevices.get(did).ITAR_Flag__c == 'Yes')) && newDevices.get(did).is3D_offering__c != null){                                                    
                                    //Check Condition3: Is endcustomer MPO or DMEA      
                                    // condition changed by Naman : Option_ITAR__c reference is removed

                                    if((newDevices.get(did).MPO_system_calculated__c != 'YES') && ((endcustomercheck == true) || (Endcustomerst.contains(newDevices.get(did).AccountName_formula__c.toUpperCase())))){
                                        newDevices.get(did).MPO_system_calculated__c = 'NO';                   
                                        toUpdatedDevicesId.add(did);                                         
                                    }
                                    else{                    
                                        //Check Condition4: Is endcustomer INFINEON or LANTIQ       
                                        if(((endcustomercontrcheck == True ) || (Endcustomerstcontract.contains(newDevices.get(did).AccountName_formula__c.toUpperCase()))) && (newDevices.get(did).Device_Contract_Control_Flag__c != 'No' || newDevices.get(did).Device_Contract_Control_Flag__c == null)){ 
                                            newDevices.get(did).Contract_Control_Flag__c = 'Yes';
                                            toUpdatedDevicesId.add(did);
                                        }
                                        else{  
                                            //added by Naman : condition added so that PSA/PSC logic is only triggered when below condition is fulfilled
                                            if(newDevices.get(did).ITAR_Flag__c == 'TBD' && newDevices.get(did).Criteria_for_PSA_PSC_Calculation__c.contains('No')){
                                            break;
                                            }
                                            else{
                                                //Check Condition5: Checks the Predicted ITAR flag on Device
                                                //Updated the condition by Naman - removal of Is_ITAR__c reference

                                                if(newDevices.get(did).ITAR_Flag__c == 'Yes'){
                                                    //added by Naman : new logic to update Calculated PSA Read and Calculated PSC Read based on Control PSA and Control PSC
                                                    if(newDevices.get(did).PSA__c != null || newDevices.get(did).PSC__c != null){
                                                        newDevices.get(did).New_Read_PSA__c = ((newDevices.get(did).PSA__c != null && (newDevices.get(did).PSA__c).length()>=6)?(newDevices.get(did).PSA__c).substring(5,6):'');
                                                        newDevices.get(did).New_Read_PSC__c = ((newDevices.get(did).PSC__c != null && (newDevices.get(did).PSC__c).length()>=6)?(newDevices.get(did).PSC__c).substring(5,6):'');
                                                    }
                                                    else if(newDevices.get(did).Calculated_PSA__c == null && newDevices.get(did).Calculated_PSC__c  == null){
                                                        newDevices.get(did).New_Read_PSA__c = label.itaryespsax;
                                                        newDevices.get(did).New_Read_PSC__c = label.itaryespsc2; 
                                                    }                           
                                                    newDevices.get(did).Calculated_PSA__c = label.itaryespsax;
                                                    newDevices.get(did).Calculated_PSC__c = label.itaryespsc2;                    
                                                    newDevices.get(did).Set_APC_APA_Based_On__c = 'ITAR - System Calculated';
                                                    toUpdatedDevicesId.add(did);
                                                }
                                                else{
                                                    //getting values for ECCN Technology  
                                                    eccndefaultval(newDevices.get(did).ECCN_Technology__c,newDevices.get(did).Fab__c,newDevices.get(did).Option_ECCN__c);                                                          
                                                    //Added by Naman : PSA/PSC logic will be not be triggered if PSA/PSC value id Project Dependent.
                                                    String pscpsaVal = eccnmappsc.get(newDevices.get(did).ECCN_Technology__c) + ' ' + eccnmappsa.get(newDevices.get(did).ECCN_Technology__c);

                                                    if(pscpsaVal != 'Project Dependent'){
                                                        //Updated the condition by Naman - removal of Option_ECCN__c reference

                                                        if(newDevices.get(did).ECCN_Technology__c != null && eccnmappsa.get(newDevices.get(did).ECCN_Technology__c) != null  && eccnmappsc.get(newDevices.get(did).ECCN_Technology__c) != null && eccnmappsa.get(newDevices.get(did).ECCN_Technology__c) != 'A'  && eccnmappsc.get(newDevices.get(did).ECCN_Technology__c) != '0'){  
                                                            if(checkoptioneccn == false ){  
                                                                //added by Naman : new logic to update Calculated PSA Read and Calculated PSC Read based on Control PSA and Control PSC
                                                                if(newDevices.get(did).PSA__c != null || newDevices.get(did).PSC__c != null){
                                                                    newDevices.get(did).New_Read_PSA__c = ((newDevices.get(did).PSA__c != null && (newDevices.get(did).PSA__c).length()>=6)?(newDevices.get(did).PSA__c).substring(5,6):'');
                                                                    newDevices.get(did).New_Read_PSC__c = ((newDevices.get(did).PSC__c != null && (newDevices.get(did).PSC__c).length()>=6)?(newDevices.get(did).PSC__c).substring(5,6):'');
                                                                }
                                                                else if(newDevices.get(did).Calculated_PSA__c == null && newDevices.get(did).Calculated_PSC__c  == null){
                                                                    newDevices.get(did).New_Read_PSA__c = eccnmappsa.get(newDevices.get(did).ECCN_Technology__c);
                                                                    newDevices.get(did).New_Read_PSC__c = eccnmappsc.get(newDevices.get(did).ECCN_Technology__c); 
                                                                }                       
                                                                newDevices.get(did).Calculated_PSA__c = eccnmappsa.get(newDevices.get(did).ECCN_Technology__c);
                                                                newDevices.get(did).Calculated_PSC__c = eccnmappsc.get(newDevices.get(did).ECCN_Technology__c);
                                                                newDevices.get(did).Set_APC_APA_Based_On__c = 'ECCN had Defaults- System Calculated';
                                                                toUpdatedDevicesId.add(did);     
                                                            }         
                                                            else{
                                                                //added by Naman : new logic to update Calculated PSA Read and Calculated PSC Read based on Control PSA and Control PSC
                                                                if(newDevices.get(did).PSA__c != null || newDevices.get(did).PSC__c != null){
                                                                    newDevices.get(did).New_Read_PSA__c = ((newDevices.get(did).PSA__c != null && (newDevices.get(did).PSA__c).length()>=6)?(newDevices.get(did).PSA__c).substring(5,6):'');
                                                                    newDevices.get(did).New_Read_PSC__c = ((newDevices.get(did).PSC__c != null && (newDevices.get(did).PSC__c).length()>=6)?(newDevices.get(did).PSC__c).substring(5,6):'');
                                                                }
                                                                else if(newDevices.get(did).Calculated_PSA__c == null && newDevices.get(did).Calculated_PSC__c  == null){
                                                                    newDevices.get(did).New_Read_PSA__c = eccnmappsa.get(newDevices.get(did).Option_ECCN__c);
                                                                    newDevices.get(did).New_Read_PSC__c = eccnmappsc.get(newDevices.get(did).Option_ECCN__c); 
                                                                }                       
                                                                newDevices.get(did).Calculated_PSA__c = eccnmappsa.get(newDevices.get(did).Option_ECCN__c);
                                                                newDevices.get(did).Calculated_PSC__c = eccnmappsc.get(newDevices.get(did).Option_ECCN__c);
                                                                newDevices.get(did).Set_APC_APA_Based_On__c = 'ECCN had Defaults- System Calculated';
                                                                toUpdatedDevicesId.add(did);
                                                            }                      
                                                        }
                                                        else{
                                                            //Check Condition5B: Checks the Automotive Device is yes on Device 
                                                            if((newDevices.get(did).Automotive_Device__c != null || newDevices.get(did).Automotive_Device__c != null)&& newDevices.get(did).Automotive_Device__c == 'Yes'){

                                                                if(newDevices.get(did).PSA__c != null || newDevices.get(did).PSC__c != null){
                                                                    newDevices.get(did).New_Read_PSA__c = ((newDevices.get(did).PSA__c != null && (newDevices.get(did).PSA__c).length()>=6)?(newDevices.get(did).PSA__c).substring(5,6):'');
                                                                    newDevices.get(did).New_Read_PSC__c = ((newDevices.get(did).PSC__c != null && (newDevices.get(did).PSC__c).length()>=6)?(newDevices.get(did).PSC__c).substring(5,6):'');
                                                                }
                                                                else if(newDevices.get(did).Calculated_PSA__c == null && newDevices.get(did).Calculated_PSC__c  == null){
                                                                    newDevices.get(did).New_Read_PSA__c = 'V';
                                                                    newDevices.get(did).New_Read_PSC__c = '2';
                                                                }   

                                                                newDevices.get(did).Calculated_PSA__c = 'V';
                                                                newDevices.get(did).Calculated_PSC__c = '2';
                                                                newDevices.get(did).Set_APC_APA_Based_On__c = 'AutomotiveDevice had default - system calculated';
                                                            } 

                                                            else{
                                                                //Check Condition6: Checks the 3D flag on Device  
                                                                //getting values default and non default values for Target Process Node
                                                                tpndefault3dval(newDevices.get(did).Target_Process_Node_Formula__c);
                                                                if(newDevices.get(did).is3D_offering__c == 'Yes'){
                                                                    if(defaultpsa3d.get(newDevices.get(did).Target_Process_Node_Formula__c) != null){
                                                                        //added by Naman : new logic to update Calculated PSA Read and Calculated PSC Read based on Control PSA and Control PSC
                                                                        if(newDevices.get(did).PSA__c != null || newDevices.get(did).PSC__c != null){
                                                                            newDevices.get(did).New_Read_PSA__c = ((newDevices.get(did).PSA__c != null && (newDevices.get(did).PSA__c).length()>=6)?(newDevices.get(did).PSA__c).substring(5,6):'');
                                                                            newDevices.get(did).New_Read_PSC__c = ((newDevices.get(did).PSC__c != null && (newDevices.get(did).PSC__c).length()>=6)?(newDevices.get(did).PSC__c).substring(5,6):'');
                                                                        }
                                                                        else if(newDevices.get(did).Calculated_PSA__c == null && newDevices.get(did).Calculated_PSC__c  == null){
                                                                            newDevices.get(did).New_Read_PSA__c = defaultpsa3d.get(newDevices.get(did).Target_Process_Node_Formula__c);
                                                                            newDevices.get(did).New_Read_PSC__c = defaultpsc3d.get(newDevices.get(did).Target_Process_Node_Formula__c);
                                                                        }   
                                                                        newDevices.get(did).Calculated_PSA__c = defaultpsa3d.get(newDevices.get(did).Target_Process_Node_Formula__c);
                                                                        newDevices.get(did).Calculated_PSC__c = defaultpsc3d.get(newDevices.get(did).Target_Process_Node_Formula__c);
                                                                        newDevices.get(did).Set_APC_APA_Based_On__c = 'Technology had Default - System Calculated';
                                                                    }else{
                                                                        //added by Naman : new logic to update Calculated PSA Read and Calculated PSC Read based on Control PSA and Control PSC
                                                                        if(newDevices.get(did).PSA__c != null || newDevices.get(did).PSC__c != null){
                                                                            newDevices.get(did).New_Read_PSA__c = ((newDevices.get(did).PSA__c != null && (newDevices.get(did).PSA__c).length()>=6)?(newDevices.get(did).PSA__c).substring(5,6):'');
                                                                            newDevices.get(did).New_Read_PSC__c = ((newDevices.get(did).PSC__c != null && (newDevices.get(did).PSC__c).length()>=6)?(newDevices.get(did).PSC__c).substring(5,6):'');
                                                                        }
                                                                        else if(newDevices.get(did).Calculated_PSA__c == null && newDevices.get(did).Calculated_PSC__c  == null){
                                                                            newDevices.get(did).New_Read_PSA__c = label.yesnondefaultpsa3d;
                                                                            newDevices.get(did).New_Read_PSC__c =  label.yesnondefaultpsc3d;
                                                                        }  
                                                                        newDevices.get(did).Calculated_PSA__c = label.yesnondefaultpsa3d;
                                                                        newDevices.get(did).Calculated_PSC__c = label.yesnondefaultpsc3d;
                                                                        newDevices.get(did).Set_APC_APA_Based_On__c = '3D had default – system calculated';           //Non of the special criteria applied- System Calculated';
                                                                    }                                  
                                                                    toUpdatedDevicesId.add(did);                                       
                                                                }else{
                                                                    if(nondefaultpsa3d.get(newDevices.get(did).Target_Process_Node_Formula__c)!= null){
                                                                        //added by Naman : new logic to update Calculated PSA Read and Calculated PSC Read based on Control PSA and Control PSC
                                                                        if(newDevices.get(did).PSA__c != null || newDevices.get(did).PSC__c != null){
                                                                            newDevices.get(did).New_Read_PSA__c = ((newDevices.get(did).PSA__c != null && (newDevices.get(did).PSA__c).length()>=6)?(newDevices.get(did).PSA__c).substring(5,6):'');
                                                                            newDevices.get(did).New_Read_PSC__c = ((newDevices.get(did).PSC__c != null && (newDevices.get(did).PSC__c).length()>=6)?(newDevices.get(did).PSC__c).substring(5,6):'');
                                                                        }
                                                                        else if(newDevices.get(did).Calculated_PSA__c == null && newDevices.get(did).Calculated_PSC__c  == null){
                                                                            newDevices.get(did).New_Read_PSA__c =nondefaultpsa3d.get(newDevices.get(did).Target_Process_Node_Formula__c);
                                                                            newDevices.get(did).New_Read_PSC__c =  nondefaultpsc3d.get(newDevices.get(did).Target_Process_Node_Formula__c);
                                                                        }  
                                                                        newDevices.get(did).Calculated_PSA__c = nondefaultpsa3d.get(newDevices.get(did).Target_Process_Node_Formula__c);
                                                                        newDevices.get(did).Calculated_PSC__c = nondefaultpsc3d.get(newDevices.get(did).Target_Process_Node_Formula__c);
                                                                        newDevices.get(did).Set_APC_APA_Based_On__c = 'Technology had Default - System Calculated';
                                                                    }
                                                                    else{
                                                                        if(newDevices.get(did).Calculated_PSA__c == null && newDevices.get(did).Calculated_PSC__c  == null){
                                                                            newDevices.get(did).New_Read_PSA__c = label.nonondefaultpsa3d;
                                                                            newDevices.get(did).New_Read_PSC__c =  label.nonondefaultpsc3d;
                                                                        }  
                                                                        newDevices.get(did).Calculated_PSA__c = label.nonondefaultpsa3d;
                                                                        newDevices.get(did).Calculated_PSC__c = label.nonondefaultpsc3d;
                                                                        newDevices.get(did).Set_APC_APA_Based_On__c = 'Non of the special criteria applied- System Calculated';
                                                                    }       
                                                                    toUpdatedDevicesId.add(did);                     
                                                                }                     
                                                            }      
                                                        }                           
                                                    }
                                                    else{                                                                   
                                                        /*Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                                                        mail.setTargetObjectId(c.id);
                                                        mail.setToAddresses(toAddresses);
                                                        mail.setTemplateId(et.id);
                                                        mail.setSaveAsActivity(false); 
                                                        mail.setWhatId(did);
                                                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
                                                        //sendEmailNotification = true;
                                                        
                                                        devIds.add(did);
                                                    }
                                                }  
                                            }
                                        }  
                                    }
                                    if(((endcustomercontrcheck== True ) || (Endcustomerstcontract.contains(newDevices.get(did).AccountName_formula__c.toUpperCase())))){
                                        newDevices.get(did).Contract_Control_Flag__c = 'Yes';
                                        toUpdatedDevicesId.add(did);
                                    }else{
                                        newDevices.get(did).Contract_Control_Flag__c = 'No';
                                        newDevices.get(did).Device_Contract_Control_Flag__c = Null;
                                        toUpdatedDevicesId.add(did);
                                    }   
                                }
                                else{
                                //added by Naman : new logic to update Calculated PSA Read and Calculated PSC Read based on Control PSA and Control PSC
                                    if(newDevices.get(did).PSA__c != null || newDevices.get(did).PSC__c != null){
                                        newDevices.get(did).New_Read_PSA__c = ((newDevices.get(did).PSA__c != null && (newDevices.get(did).PSA__c).length()>=6)?(newDevices.get(did).PSA__c).substring(5,6):'');
                                        newDevices.get(did).New_Read_PSC__c = ((newDevices.get(did).PSC__c != null && (newDevices.get(did).PSC__c).length()>=6)?(newDevices.get(did).PSC__c).substring(5,6):'');
                                    }
                                }
                            }      
                            //Updated the condition by Naman - removal of Option_ECCN__c and Is_ITAR__c reference
                            if(newDevices.get(did).Account__c != null && newDevices.get(did).Target_Process_Node_Formula__c != null && newDevices.get(did).ITAR_Flag__c != null && (newDevices.get(did).ECCN_Technology__c != null || (newDevices.get(did).ECCN_Technology__c == null && newDevices.get(did).ITAR_Flag__c == 'Yes'))  && newDevices.get(did).is3D_offering__c != null && fabcheck1.contains(newDevices.get(did).Fab__c)  ){                                   
                                newDevices.get(did).Conditions_Satisfied__c = 'Yes';
                                toUpdatedDevicesId.add(did);
                            }
                            else{
                                newDevices.get(did).Conditions_Satisfied__c = 'No';
                                toUpdatedDevicesId.add(did);
                            }
                    }
                }  
                
                System.debug('@@Email Notification : ' +sendEmailNotification);
                if(!devIds.isEmpty()){ 
                    System.debug('@@Inside 1st Loop');  
                    //c=new Contact();
                    c = [select id, Email from Contact Where email = 'noreply@salesforce.com' limit 1];
                    //et = new EmailTemplate();
                    et= [Select id from EmailTemplate where DeveloperName='EmailTemplateForPSAPSCValueProjectDependent'];
                    toAddresses = new String[]{};
                    ccAddresses = new String[]{};
                    userId = new Set<Id>();
                    for(GroupMember gm:[Select id,userorgroupid From GroupMember where groupid in (Select id from group where developername = 'Product_Quality_Group')]){
                        userId.add(gm.userorgroupid);
                    }

                    for(User usr:[Select email from user where id =: userId]){
                        toAddresses.add(usr.email);
                    }
                    System.debug('@@end'+newDevices); 

                    System.debug('@@toAddresses 2nd Rec' +toAddresses);
                    System.debug('@@userId 2nd Rec' +userId);
                    System.debug('@@Contact 2nd Rec' +c);
                    System.debug('@@EmailTemp 2nd Rec' +et);
                    for(id did: devIds){
                        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                        mail.setTargetObjectId(c.id);
                        mail.setToAddresses(toAddresses);
                        mail.setTemplateId(et.id);
                        mail.setSaveAsActivity(false); 
                        mail.setWhatId(did);
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    }
                }
            }
        }catch(exception e){
          GlobalUtility.logMessage('Error','DevicePscPsautilcls','doUpdate','','Exception while Updating the Device record',String.valueof(e.getMessage()),'','Device Management',e,0);            
        }
    }
    
  //getting values for ECCN Technology
  public void eccndefaultval(string eccnval,string fabval,string faboptionval){
      try{
      //mapping default psc/psa values from ECCN Technology
      eccnmappsa = new  map<string,string>();
      eccnmappsc  = new  map<string,string>();
      string OptionECCN = label.OptionECCNFabCheck;
      list<string> OptionECCNfbcheck = OptionECCN.split(','); 
      Set<string> OptionECCNfabcheck1= new Set<string>(OptionECCNfbcheck);   
      //Commented the code by Naman: so that Option__ECCN__c reference is removed    
      /*if(fabval != null){
          if(OptionECCNfabcheck1.contains(fabval) ){
              if(faboptionval != null){
                  eccnval = faboptionval;
                  checkoptioneccn = true;
              }
          }
      } */     
      list<psa_psc_eccn_default__c> eccndefault = new  list<psa_psc_eccn_default__c>();
     // eccndefault = [select id,name,psa_eccn__c,psc_eccn__c from psa_psc_eccn_default__c where name =:eccnval];
      eccndefault = [select id,name,psa_eccn__c,psc_eccn__c from psa_psc_eccn_default__c where name =:eccnval];
      for(psa_psc_eccn_default__c pi : eccndefault){
          eccnmappsa.put(pi.name , pi.psa_eccn__c);
          eccnmappsc.put(pi.name , pi.psc_eccn__c);
      }
      }catch(exception e){
          GlobalUtility.logMessage('Error','DevicePscPsautilcls','doUpdate','','Exception while Updating the Device record',String.valueof(e.getMessage()),'','Device Management',e,0);       
      }
  }

  //getting values default and non default values for Target Process Node
  public void tpndefault3dval(string tpnval){
      try{
      //mapping default psc/psa values from psa psc target process node default object
      defaultpsa3d = new  map<string,string>();
      defaultpsc3d = new  map<string,string>();
      nondefaultpsa3d = new  map<string,string>();
      nondefaultpsc3d = new  map<string,string>();
      list<PSAPSCTechnologies__c> tpndefault3d = new  list<PSAPSCTechnologies__c>();
          
      tpndefault3d = [select Psa__c,Psc__c,Technology__c from PSAPSCTechnologies__c where name=:tpnval];
      for(PSAPSCTechnologies__c pi: tpndefault3d){
          defaultpsa3d.put(pi.Technology__c,pi.Psa__c);
          defaultpsc3d.put(pi.Technology__c,pi.Psc__c);
          nondefaultpsa3d.put(pi.Technology__c,pi.Psa__c);
          nondefaultpsc3d.put(pi.Technology__c,pi.Psc__c);
      }   
      }catch(exception e){
          GlobalUtility.logMessage('Error','DevicePscPsautilcls','doUpdate','','Exception while Updating the Device record',String.valueof(e.getMessage()),'','Device Management',e,0);            
      }
  }  
}