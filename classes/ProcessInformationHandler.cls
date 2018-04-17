/********************************************************************************************************
    Class Name:    BX041_Edit 
    Author:        Prosenjit Saha(PS) and Thomas Lai(TL)
    Description:   This Class populates the PIYE and FE comment columns in the BX041 form. 
    Created Date: 
      PS           Code creation.
    Change History: changed 26th Sept. TO add the functionality of validating other process fields to populate data.
      Author: 
      Modified Date: 
      Reason:
 
*********************************************************************************************************/
Public Class ProcessInformationHandler{
    
    /******************************************************************************************************
    @Method Name:    getProcessQuestions
    @Return Type:    MAP<String,string>
    @parameter:      processID from the BX041 (requested process ID/assigned process ID)
    @Reason:         This method returns the question-FE(or PIYE)Comment pair. 
    *******************************************************************************************************/   
    public static Map<String,String> getProcessQuestions(id ProcessId){
        Map<String,String> qstnId2ProcMap  = new Map<String,String>();
        Set<String> validateQuestions = new set<String>();
        
        
        //query on the question metadata to get all process questions.
        List<Question_Metadata__c> listmetadata = [SELECT    id,
                                                             Name,
                                                             API_Name__c,
                                                             Mandatory__c,
                                                             Question__c,
                                                             Question_Metadata_Section__c,
                                                             Question_to_Display__c,
                                                             Record_Type__c,
                                                             Sequence__c,
                                                             Template_Name__c,
                                                             Type__c,
                                                             Process_field_API_name__c,
                                                             Validation_Required__c
                                                   FROM      Question_Metadata__c
                                                   WHERE     Record_Type__c = 'Process Id' 
                                                   AND       (Type__c = 'Picklist' 
                                                   OR         Type__c = 'Text')
                                                   order BY  Sequence__c];
        //generating map between process ID and process record.
        map <id,Process__c> FEnPIYEProcessMap = new map<id,Process__c>(
                               [SELECT      id,
                                            Available_to_Sell__c,
                                            Bias_Table_Spec__c,
                                            Capacitor__c,
                                            Category__c,
                                            Core_Transistors__c,
                                            Core_Voltages__c,
                                            Customer_Affected__c,
                                            Customer_Release__c,
                                            Deep_N_Well__c,
                                            Design_Rule__c,
                                            DRC_RunSet__c,
                                            EPSpec__c,
                                            ETSpec__c,
                                            VT_Options__c,
                                            Frame_Table_Spec__c,
                                            Fuse__c,
                                            Gate_Oxide__c,
                                            Generation_Rule_Spec__c,
                                            High_Poly_Resistor__c,
                                            HV_Voltages__c,
                                            InterConnect_Spec__c,
                                            IO_Voltages__c,
                                            Main_Design_Rule__c,
                                            Main_Generation_Rule_Spec__c,
                                            Metal_Layers__c,
                                            Metal_Stacks__c,
                                            No_Of_Mask_Layer__c,
                                            Org_ID__c,
                                            Passivation__c,
                                            PID_Number__c,
                                            Poly_Gate_Type__c,
                                            Polyimide__c,
                                            Poly_Layers__c,
                                            Process_Flow_RunSheet_Spec__c,
                                            Process_Owner__c,
                                            Process_Technology__c,
                                            Process_Type__c,
                                            Product_Description__c,
                                            Resistor__c,
                                            Sab__c,
                                            Shrink_10__c,
                                            Silicon_Technology_300MM__c,
                                            Spice_Model__c,
                                            Start_Material__c,
                                            Sub_Tech_Type__c,
                                            Technology_Features__c,
                                            Tech_Type__c,
                                            Top_Metal__c,
                                            Top_TM1_Thick_Metal_200MM__c,
                                            Well_Options_300MM__c,
                                            Wirebond_Flipchip__c,
                                            Baseline_Starting_Material__c
                                FROM        Process__c
                                WHERE       ID = :ProcessId ]
                                );
        for(Question_Metadata__c qm : listmetadata ){
            //if the process field API value is process information then it should retrieve process value.
            if(qm.Process_field_API_name__c != NULL && qm.Validation_Required__c != true){ 
                //preparing the map to return 
                qstnId2ProcMap.put(qm.id,String.valueOf(FEnPIYEProcessMap.get(ProcessId).get(qm.Process_field_API_name__c))); 
            } 
            else if(qm.Question__c != NULL && qm.Validation_Required__c == true){
                BX041ValidatePorcessInfo__c  validPID = BX041ValidatePorcessInfo__c.getInstance(qm.Question__c);
                if(validPID != NULL){
                    List<string> validValuesList = validPID.Values_to_check__c.split(',');
                    Set<String> validValues = new set<String>();
                    validValues.addAll(validValuesList) ;
                    if(validPID.Secondary_Question_to_Verify__c == NULL && validValues.contains(String.valueOf(FEnPIYEProcessMap.get(ProcessId).get(validPID.Question_to_verify__c)))){
                        qstnId2ProcMap.put(qm.id,'Yes');
                    }
                    else if(validPID.Secondary_Question_to_Verify__c != NULL){
                        boolean bool = false;
                        List<string> SecondaryValidValuesList = validPID.Secondary_Values_to_check__c.split(',');
                        Set<String> SecondaryValidValues = new set<String>();
                        SecondaryValidValues.addAll(SecondaryValidValuesList) ;
                        if(validValues.contains(String.valueOf(FEnPIYEProcessMap.get(ProcessId).get(validPID.Question_to_verify__c))) ||
                           SecondaryValidValues.contains(String.valueOf(FEnPIYEProcessMap.get(ProcessId).get(validPID.Secondary_Question_to_Verify__c)))){
                            qstnId2ProcMap.put(qm.id,'Yes');       
                        }
                    }
                }
            }  
        }
        return qstnId2ProcMap;  //retunring map     
    }//end of getProcessQuestions method
}//end of class ProcessInformationHandler