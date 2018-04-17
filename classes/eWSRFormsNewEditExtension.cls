/*
    Author: Abhita Bansal
    Description: This Class is used to create the Forms of different Record Type and do all the runtime Calculations and logics
    History: 
    ABansal     11/05/2014 - Code Creation
    Abansal     11/06/2014 - Add the Save Functionality
    ABansal     11/07/2014 - Add the Edit Functionality
    ABansal     11/10/2014 - Add the Function for Mask Layers
    ABansal     11/11/2014 - Add the Function for Requested date
    Abansal     11/12/2014 - Add the Functionality for Notification Group
    ABansal     11/13/2014 - Change the Functionality for Notification Group
    ABansal     11/14/2014 - Change the Functionality for Requested Date
    ABansal     11/17/2014 - Add the Logic for Attachment to attach the Documents in Notes And Attachment
    Abansal     11/18/2014 - Add the Logic of Part Id to override the standard Lookup
    ABansal     11/19/2014 - Add the Requested Date Functionality for All record Types
    ABansal     11/20/2014 - Add the Logic of date fields when Additional Time Cycle Required is yes
    ABansal     11/21/2014 - Update the re rendering issue for Wafer starting Material
    Abansal     11/24/2014 - Update the logic to provide the access to Fab Execution Members
    ABansal     11/25/2014 - Update the logic for Process id from picklist to text Field
    ABansal     11/26/2014 - Change the Requested date logic for Fab 7
    ABansal     11/27/2014 - Add the Logic for Plan Start Date 
    Abansal     11/28/2014 - Revert back the Changes for the Notification Group
    ABansal     12/01/2014 - Add the logic for Part id to show the records on the basis of form Record Type
    ABansal     12/02/2014 - Make All fields Read only when Planner update the record
    ABansal     12/03/2014 - Update the functionality of Plan Start Date for Fab 7
    Abansal     12/04/2014 - Update the issue for the Edit Functionality
    ABansal     12/05/2014 - Put the validation rules if the values is null
    ABansal     12/08/2014 - Put the check on user to avoid the Read Only access error
    ABansal     12/09/2014 - Add the pop up functionality if Lot Quantity is greater than Remaiming Quanitity
    Abansal     12/10/2014 - Update the logic for Various Functionality
    ABansal     12/11/2014 - Revert back the Changes for Requested Date for Fab 7
    ABansal     12/15/2014 - Added the code for Default value of Customer Lot Perfix Id field
    ABansal     12/17/2014 - Update the field from Part Id to Device Id to get the records from PO Lead Time object
    ABansal     01/07/2015 - Revert back the changes from Device Id to Part Id to get the records from eWSR Device object
    ABansal     01/28/2014 - Updating the logic for Equivalent Quantity
    Abansal     01/13/2015 - Updating the code for Enhancement 1 and 2 for Approval process for Department Director and Manager field
    ABansal     01/21/2015 - Updating the code for Enhancement 5 to make the Wafer Starting Material custom picklist
    ABansal     01/28/2015 - Updating the code to provide the access when form is in "Pending with Planner Approval" status.
    Jabee       05/29/2017 - updated by adding the line 1026 to remove fab from string.
*/
public with sharing class eWSRFormsNewEditExtension{

    private ApexPages.StandardController controller{get;set;}
    public String recid {get;set;}
    public String recName {get;set;}
    public pageReference pgRef{get;set;}
    public Boolean reqField {get; set;}
    public Boolean reqField1 {get; set;} 
    public Boolean showSelectField {get;set;}
    public Boolean showSelectField1 {get;set;}
    public boolean showSelectField2 {get;set;}
    public Boolean showSelectField4{get;set;}
    public Boolean show {get; set;}
    public Transient Blob filebody1 {get; set;}
    public String filename1 {get; set;}
    public String Ids {get;set;}
    public List<String> SelectedUsers {get;set;}
    public Boolean othersSection {get;set;}
    public Boolean fabExecutionSection {get;set;}
    public String query{get;set;}
    public Boolean valueBool{get;set;}
    public String notifiedUserId {get;set;}
    public eWSR_Notification_Group__c notifiedUser {get;set;}
    public List<string> leftselected{get;set;}
    public List<string> rightselected{get;set;}
    public String name{get;set;}
    public String wafStaMat{get;set;}
    public Map<String,Id> rightUserMap{get;set;}
    public Map<String,Id> leftUserMap{get;set;}
    public String totalMaskLayers;
    public String maskProLayers;
    public String layers;
    public String lotPriority;
    public String additionalDays;
    public String valueMod;
    public String valueProg;
    public String valueSPSR;
    public String valueSOP;
    public String valShFull;
    public String devStartMat; 
    public String devStartMat1; 
    public String devStartMat2;
    public String devStartMat3;
    public String valueStartMaterial;
    public String valStart;
    public Boolean showError;
    public String QueueName;
    public String OwnerEditId;
    public String userId;
    public String partId;
    public Boolean showErrorWafer;
    public Boolean showErrorReqDate;
    public Boolean queuePresent;
    public Boolean showOtherWaferField{get;set;}
    public List<eWSR_Notification_Group__c> eWSRNotificationList{get;set;}     
    Set<string> leftvalues = new Set<string>();
    Set<string> rightvalues = new Set<string>();
    public boolean MasksetlayerEdit{get;set;}
    public eWSR_Form__c eWSRForm{
        get {
            return (eWSR_Form__c) controller.getRecord();
        }
        set ;
    }
    
    private User userValue(Id Ownerid){
    
        User user = [Select Phone, Dept_Cost_Center_Number__c, Department, HCM_Employee_ID__c, ManagerID, ProfileID from User where Id=:Ownerid];
        return user;
    }
    
    public pageReference masklayers(){
        
        if(eWSRForm.Part_ID__c != null){              
            List<eWSR_Devices__c> ldMask = [SELECT Id, Name, Total_Number_of_Mask_layers__c, Process_ID__c, Start_Material__c FROM eWSR_Devices__c where Id =:eWSRForm.Part_ID__c Limit 1];
            eWSRForm.Total_Number_of_Mask_Layer__c = String.valueOf(ldMask[0].Total_Number_of_Mask_layers__c);
            totalMaskLayers = String.valueOf(ldMask[0].Total_Number_of_Mask_layers__c);
            eWSRForm.Process_ID__c = ldMask[0].Process_ID__c;
            devStartMat = ldMask[0].Start_Material__c;    
        }
        return null;
    }
    
    public pageReference AddDaysValues(){
        String theAddDays = ApexPages.CurrentPage().getParameters().get('site3');
        additionalDays = theAddDays;
        totalOSDDays();
        return null;
    }

    public pageReference Modvalues(){
        String theModule = ApexPages.CurrentPage().getParameters().get('Module');
        valueMod = theModule;
        return null;
    }
    
    public pageReference Progvalues(){
        String theProgram = ApexPages.CurrentPage().getParameters().get('Program');
        valueProg = theProgram;
        return null;
    }

    public pageReference SPSRvalues(){
        String theSPSR = ApexPages.CurrentPage().getParameters().get('site1');
        valueSPSR = theSPSR;
        if(valueSPSR != null){
            totalOSDDays();
        } 
        return null;
    }

    public pageReference SOPvalues(){
        String theSOP = ApexPages.CurrentPage().getParameters().get('site2');
        valueSOP = theSOP;
        if(valueSOP != null){
            totalOSDDays();
        } 
        return null;
    }

    
    public pageReference lotPriority(){
        String theLotPro = ApexPages.CurrentPage().getParameters().get('lPro');
        lotPriority = theLotPro;
        if(lotPriority != null){
            totalOSDDays();
        }
        return null;

    }
    public pageReference valStartMat(){
        String thevalStart = ApexPages.CurrentPage().getParameters().get('valstartMaterial');
        valStart = thevalStart;
        showSelectField1 = true;
        if(valStart == 'Recycle Material'){
            eWSRForm.Wafer_Starting_Material__c = 'Internal';
        }
        else{
            eWSRForm.Wafer_Starting_Material__c = 'External';
        }
        return null;

    }
    
    public List<SelectOption> getwafStaMats()
    {
        List<SelectOption> options = new List<SelectOption>();
        list<String> devStartMatList = new List<String>();
        if(eWSRForm.Id == null){
            if(devStartMat != null){
                devStartMatList = devStartMat.split(';');
                if(devStartMatList.size() != 1){
                    for(Integer i=0;i<devStartMatList.size();i++){
                        options.add(new SelectOption(devStartMatList[i],devStartMatList[i]));                   
                    }
                    options.add(new SelectOption('Others','Others'));
                }
                else{
                    options.add(new SelectOption(devStartMat,devStartMat));
                    options.add(new SelectOption('Others','Others'));
                }
            }
        }
        else{
            if(devStartMat2 != null){
                if(devStartMat2 != 'Others'){
                    options.add(new SelectOption(devStartMat2,devStartMat2)); 
                    devStartMatList = devStartMat3.split(';');
                    if(devStartMatList.size() != 1){
                        for(Integer i=0;i<devStartMatList.size();i++){
                            if(devStartMatList[i] != devStartMat2){
                                options.add(new SelectOption(devStartMatList[i],devStartMatList[i]));                           
                            }
                        }   
                    }
                    else{
                        options.add(new SelectOption(devStartMat2,devStartMat2));
                    }
                    options.add(new SelectOption('Others','Others'));
                }
                else{
                    options.add(new SelectOption(devStartMat2,devStartMat2));
                    devStartMatList = devStartMat3.split(';');
                    if(devStartMatList.size() != 1){    
                        for(Integer i=0;i<devStartMatList.size();i++){
                            options.add(new SelectOption(devStartMatList[i],devStartMatList[i]));   
                        }   
                    }
                    else{
                        options.add(new SelectOption(devStartMat3,devStartMat3));
                    }
                }
            }
            else{
                if(eWSRForm.Part_ID__c != null){              
                    eWSR_Devices__c startMat = [SELECT Id, Start_Material__c FROM eWSR_Devices__c where Id =:eWSRForm.Part_ID__c Limit 1];   
                    devStartMat1 = startMat.Start_Material__c;  
                    if(devStartMat1 != null){
                        devStartMatList = devStartMat1.split(';');
                        if(devStartMatList.size() != 1){
                            for(Integer i=0;i<devStartMatList.size();i++){
                               options.add(new SelectOption(devStartMatList[i],devStartMatList[i]));                   
                            }
                            options.add(new SelectOption('Others','Others'));
                        }
                        else{
                            options.add(new SelectOption(devStartMat1 ,devStartMat1));
                            options.add(new SelectOption('Others','Others'));
                        }
                    }
               }
           }
        }
        return options;
    }
    
    public void waferStartMaterial(){
        
        if(eWSRForm.Part_ID__c != null){               
            eWSR_Devices__c startMat = [SELECT Id, Start_Material__c FROM eWSR_Devices__c where Id =:eWSRForm.Part_ID__c Limit 1];   
            devStartMat1 = startMat.Start_Material__c;  
        }
    }
    
    public pageReference proStartMat(){
        String theStartMaterial = ApexPages.CurrentPage().getParameters().get('startMaterial');
        valueStartMaterial = theStartMaterial ;        
        if(valueStartMaterial == 'Yes'){
            showSelectField = true;
            showSelectField2 = false;
            showOtherWaferField = false;
            if(eWSRForm.Others__c != null){
                eWSRForm.Others__c = '';
            }
        }
        else if(valueStartMaterial == 'No'){
             showSelectField = FALSE;
             showSelectField1 = False;
             showSelectField2 = True;
             showSelectField4 = false;
             waferStartMaterial();
             if(eWSRForm.Value_for_Wafer_Starting_Material__c != null){
                eWSRForm.Value_for_Wafer_Starting_Material__c = '';
            }
        }
        else{
            showSelectField4 = true;
            showSelectField2 = false;
            showOtherWaferField = false;
            if(eWSRForm.Wafer_Starting_Material__c != null){
                eWSRForm.Wafer_Starting_Material__c = '';
            }
            if(eWSRForm.Others__c != null){
                eWSRForm.Others__c = '';
            }
        }          
        return null;
    }
    
    public pageReference valwaStrMaterial(){
        String thevalwaStrMater = ApexPages.CurrentPage().getParameters().get('valwaStrMat');
        if(thevalwaStrMater == 'Others'){
            showOtherWaferField = true;           
        }
        else{
            showOtherWaferField = false;  
            if(thevalwaStrMater != null){
                eWSRForm.Others__c = '';
            }
        }       
        return null;
    }
     
    public pageReference maskPro(){
        showError = False;
        String theMaskPro = ApexPages.CurrentPage().getParameters().get('mPro');
        maskProLayers = theMaskPro;
        if(maskProLayers != null){
            totalOSDDays();
        }
        if(eWSRForm.Lot_Quantity_No_of_Wafers__c != null){
            valueEq();
        }
        return null;
    }
    
    private Decimal calculate(){
        String newLotP;
        Decimal calValue;
        
        if(lotPriority == '1'){
            newLotP = '0.8';
        }
        else if(lotPriority == '2'){
            newLotP = '1.1'; 
        }
        else if(lotPriority == '3'){
            newLotP = '2';
        }
        else if(lotPriority == '4'){
            newLotP = '2.1'; 
        }
        else{
            newLotP = '4'; 
        }             
        if(maskProLayers == null && eWSRForm.Id == null){
            maskProLayers = '0';
            calValue = Decimal.valueof(newLotP)*Integer.valueof(maskProLayers);
        }
        else if(maskProLayers == null && eWSRForm.Id != null){
            maskProLayers = '0';
            calValue = Decimal.valueof(newLotP)*Integer.valueof(maskProLayers);
        }
        else{
            calValue = Decimal.valueof(newLotP)*Integer.valueof(maskProLayers);
        }
        return calValue;
    }
    
    private Decimal calculatePlanDate(){
        String newLotP;
        Decimal calValue;
        
        if(lotPriority == '1'){
            newLotP = '0.8';
        }
        else if(lotPriority == '2'){
            newLotP = '1.1'; 
        }
        else if(lotPriority == '3'){
            newLotP = '2';
        }
        else if(lotPriority == '4'){
            newLotP = '2.1'; 
        }
        else{
            newLotP = '4'; 
        }             
        if(maskProLayers == null && eWSRForm.Id == null){
            calValue = Decimal.valueof(newLotP)*Integer.valueof(totalMaskLayers);
        }
        else if(maskProLayers == null && eWSRForm.Id != null){
            calValue = Decimal.valueof(newLotP)*Integer.valueof(totalMaskLayers);
        }
        else{
            calValue = Decimal.valueof(newLotP)*Integer.valueof(maskProLayers);
        }
        return calValue;
    }
    
    private void totalOSDDays(){
        showError = False;
        
        if(valueSPSR != '' && valueSOP != '' && additionalDays != ''){
            if(valueSPSR != null && valueSOP != null && additionalDays != null){
                Decimal totalValue = (Integer.valueof(valueSPSR) * 0.8) + (Integer.valueof(valueSOP) * 0.6) + Integer.valueof(additionalDays);
                eWSRForm.Total_days_added_to_standard_OSD__c = totalValue;
        
                Decimal calValue = calculate();
                Integer calValue1 = Integer.valueof(calValue); 
                Decimal totalCycleTime = calValue + totalValue;
                eWSRForm.Total_Cycle_Time__c = totalCycleTime;
            }
            //system.debug('valueSPSR:..'+valueSPSR+'valueSOP:...'+'additionalDays:...'+additionalDays+'eWSRForm.Additional_Cycle_Time_required__c:...'+eWSRForm.Additional_Cycle_Time_required__c);
            else if((valueSPSR == null || valueSOP == null || additionalDays == null) && eWSRForm.Additional_Cycle_Time_required__c == 'Yes'){
                showError = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, eWSRConstantsVariablesClass.ERRORMSGREQFLDS));
            }
            else{}
        }
        else if((valueSPSR == '' || valueSOP == '' || additionalDays == '') && eWSRForm.Additional_Cycle_Time_required__c == 'Yes'){
            showError = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, eWSRConstantsVariablesClass.ERRORMSGREQFLDS));
        }
        else{}
    }
    
    public PageReference valueEq(){
        showErrorWafer = FALSE;
        if(eWSRForm.Lot_Quantity_No_of_Wafers__c != null)
        {
            showErrorReqDate = False;
        }
        if(eWSRForm.Lot_Quantity_No_of_Wafers__c <= 500){
			system.debug('showErrorWafer:::'+showErrorWafer);
            if(maskProLayers == null){
               maskProLayers = '0';        
             }   
             if(recName != 'FAB 7'){
                 eWSRForm.Equivalent_Quantity__c = eWSRForm.Lot_Quantity_No_of_Wafers__c;
             }
             else{
                if(eWSRForm.Full_loop_Short_loop__c == 'Full Loop'){
                    eWSRForm.Equivalent_Quantity__c = eWSRForm.Lot_Quantity_No_of_Wafers__c;  
                }
                else if(valShFull == 'Short Loop' && valueMod == 'TD'){
                    String Value = valueProg;
                    String prog = Value.substring(0, Value.length()-2);
                    Integer progNumber = Integer.valueOf(prog);
                    if(progNumber < 45){
                        if(Integer.valueOf(maskProLayers) < 15){
                            eWSRForm.Equivalent_Quantity__c = eWSRForm.Lot_Quantity_No_of_Wafers__c * 0.25;
                        }
                        else if(Integer.valueOf(maskProLayers) >= 15 && Integer.valueOf(maskProLayers) < 30){
                            eWSRForm.Equivalent_Quantity__c = eWSRForm.Lot_Quantity_No_of_Wafers__c * 0.5;
                        }
                        else{
                            eWSRForm.Equivalent_Quantity__c = eWSRForm.Lot_Quantity_No_of_Wafers__c;
                        }
                    }
                    else{
                        if(Integer.valueOf(maskProLayers) < 10){
                            eWSRForm.Equivalent_Quantity__c = eWSRForm.Lot_Quantity_No_of_Wafers__c * 0.25;
                        }
                        else if(Integer.valueOf(maskProLayers) >= 10 && Integer.valueOf(maskProLayers) < 20){
                            eWSRForm.Equivalent_Quantity__c = eWSRForm.Lot_Quantity_No_of_Wafers__c * 0.5;
                        }
                        else{
                            eWSRForm.Equivalent_Quantity__c = eWSRForm.Lot_Quantity_No_of_Wafers__c;
                        }
                    }
                 }
                 else if (valShFull == 'Short Loop'&& valueMod != 'TD'){
                    if(maskProLayers == ''){
                        maskProLayers = '0';               
                    }
                    if(Integer.valueOf(maskProLayers) <= 9){
                        eWSRForm.Equivalent_Quantity__c = eWSRForm.Lot_Quantity_No_of_Wafers__c * 0.25;
                    }
                    else{
                        eWSRForm.Equivalent_Quantity__c = eWSRForm.Lot_Quantity_No_of_Wafers__c * 0.5;
                    }
                }
            }
       }
       else{
           showErrorWafer = TRUE;
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, eWSRConstantsVariablesClass.ERRORMSGWAFERMATERIAL));
       }
       return null;
    }
    
    /*public pageReference dateValue(){
        
        String startDate = ApexPages.CurrentPage().getParameters().get('date');

        Decimal calValue = calculatePlanDate();
        Integer calValue1 = Integer.valueof(calValue);  
        String[] myDateOnly = startDate.split(' '); 
        String[] strDate = myDateOnly[0].split('/');
        Integer myIntDate = integer.valueOf(strDate[1]); 
        Integer myIntMonth = integer.valueOf(strDate[0]);
        Integer myIntYear = integer.valueOf(strDate[2]);
        Datetime d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
        Datetime value = d.addDays(calValue1);
        
        eWSRForm.Plan_Fab_Out_Date__c = Date.valueOf(value);
        
        Datetime value1 = value.addDays(2);
        eWSRForm.Plan_OSD__c = Date.valueOf(value1);

        return null;
    }*/
    
    public pageReference dateValue(){
    
        String startDate = ApexPages.CurrentPage().getParameters().get('date');
        Date theDate = Date.parse(startDate);
                               
        Decimal calValue = calculatePlanDate();
        Integer calValue1 = Integer.valueof(calValue); 
                               
        Datetime value = theDate.addDays(calValue1);
       
        eWSRForm.Plan_Fab_Out_Date__c = Date.valueOf(value);
       
        Datetime value1 = value.addDays(2);
        eWSRForm.Plan_OSD__c = Date.valueOf(value1);
 
        return null;
    }
    
    public PageReference lotOwnValue(){
        User lotOwner = uservalue(eWSRForm.Lot_Owner__c);
        eWSRForm.Lot_Owner_s_Contact_Number__c = lotOwner.Phone;
        eWSRForm.Lot_Owner_s_Department__c = lotOwner.Department;
        eWSRForm.Emp_ID__c = lotOwner.HCM_Employee_ID__c;
        return null;
    }
    
    public PageReference custShort(){
        String Name = eWSRForm.Customer_Name__c;
        Account account = [Select Name, Short_Name__c from Account where Id=:eWSRForm.Customer_Name__c];
        eWSRForm.Customer_Shortname__c = account.Short_Name__c;
        return null;
    } 
    
    public PageReference required(){
         reqField = FALSE;
         valShFull = eWSRForm.Full_loop_Short_loop__c;
         if (eWSRForm.Full_loop_Short_loop__c == 'Short Loop') {
            reqField = TRUE;
         }
         else{
            reqField = FALSE;
            if(eWSRForm.Lot_Quantity_No_of_Wafers__c != null){
                valueEq();
            }
         }
        return null;
    }
    
        
    public PageReference display(){
    
        if(eWSRForm.Additional_Cycle_Time_required__c == 'Yes'){
            show = True;
        }
        else{
            show = FALSE;
        }
        return null;
    }
    
    public PageReference checkDate(){
        showErrorReqDate = False;
        valueBool = false;
        date myDate = date.today();
        
        if(eWSRForm.Requested_Start_Date__c < myDate || eWSRForm.Requested_Start_Date__c == myDate){
            showErrorReqDate = true;
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR, eWSRConstantsVariablesClass.ERRORMSGREQ);
            ApexPages.addMessage(myMsg);
            return null;
        }
        else{
            String monthName;
            
            Integer month = eWSRForm.Requested_Start_Date__c.month();
            
            if(month == 1){
               monthName = 'Jan';
            }else if (month == 2){
                monthName = 'Feb';
            }else if(month == 3){
                monthName = 'Mar';
            }else if(month == 4){
                monthName = 'Apr';
            }else if(month == 5){
                monthName = 'May';
            }else if(month == 6){
                monthName = 'Jun';
            }else if(month == 7){
                monthName = 'Jul';
            }else if(month == 8){
                monthName = 'Aug';
            }else if(month == 9){
                monthName = 'Sep';
            }else if(month == 10){
                monthName = 'Oct';
            }else if(month == 11){
                monthName = 'Nov';
            }else{
                monthName = 'Dec';
            }               
            Integer remDate;
            String year = String.valueof(eWSRForm.Requested_Start_Date__c.year());
            
            query = 'select Id, Fab__c, Month__c, Year__c, Module1__c, Program1__c, Wafer_Quantity_Allocated__c, Remaining_Quantity__c from Wafer_Allocation__c where Fab__c = \''+recName+'\' and Year__c = \''+year+'\' and Month__c = \''+monthName+'\'';    
            if(valueMod != null && (recName == eWSRConstantsVariablesClass.FAB7RECORDTYPE || recName == eWSRConstantsVariablesClass.FAB3ERECORDTYPE)){
                query += ' and Module1__c = \''+valueMod+'\'';
            }
            if(valueProg != null && recName == eWSRConstantsVariablesClass.FAB7RECORDTYPE){
                query += ' and Program1__c = \''+valueProg+'\'';
            }
            
            system.debug('QUERY:...'+query);
            List<Wafer_Allocation__c> waferAlloc = database.query(query); 
			system.debug('Listvalue:...'+waferAlloc);
            if(waferAlloc.isEmpty()){
                showErrorReqDate = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,eWSRConstantsVariablesClass.ERRORMSGCHKDATE));
            }
            else{
                if(waferAlloc[0].Wafer_Quantity_Allocated__c == null){
                    eWSRForm.Forecast_Quantity__c = 0;
                    eWSRForm.Remaining_Quantity__c = 0;
                }
                else{
                    eWSRForm.Forecast_Quantity__c = waferAlloc[0].Wafer_Quantity_Allocated__c;
                    eWSRForm.Remaining_Quantity__c = waferAlloc[0].Remaining_Quantity__c;   
                }  
                if(eWSRForm.Lot_Quantity_No_of_Wafers__c == null){
                    showErrorReqDate = true;
                    eWSRForm.Lot_Quantity_No_of_Wafers__c.addError(eWSRConstantsVariablesClass.ERRORMSGLOTQUAN);
                }
                else{
                    if(waferAlloc[0].Remaining_Quantity__c == null){                    
                        if(eWSRForm.Equivalent_Quantity__c > eWSRForm.Remaining_Quantity__c){
                            valueBool = true;
                        }
                    }
                    else{
                       if(eWSRForm.Equivalent_Quantity__c > waferAlloc[0].Remaining_Quantity__c){
                            valueBool = true;
                       }            
                    }     
                } 
            }
       }        
       return null;
    }

    
    private PageReference upload(Id recordID){
    
            if(filebody1!=null && filename1!=null){
                Attachment attachment = new Attachment();
                attachment.Body=filebody1;
                attachment.Name='attachment'+filename1;
                attachment.ParentId=recordID;            
                insert attachment;
            }
            filebody1=null;                 
            return null;
    }
    
    public PageReference yes() {
        valueBool = false;
        eWSRForm.Message__c ='There is not enough wafer balance to cover this request';
        return null;
        
    }
    
    public PageReference selectclick(){
        rightselected.clear();
        for(String s : leftselected){
            leftvalues.remove(s);
            if(!rightvalues.contains(s)){
                rightvalues.add(s); 
            }
            for(string key : leftUserMap.keySet()){
                if(key == s){
                    rightUserMap.put(key, leftUserMap.get(key));    
                }
            }
            leftUserMap.remove(s);
        }
        return null;
    }
     
    public PageReference unselectclick(){
        leftselected.clear();
        for(String s : rightselected){
            rightvalues.remove(s);
            leftvalues.add(s);          
            for(String key: rightUserMap.keySet()){
                if(key == s){
                    leftUserMap.put(key, rightUserMap.get(key));
                }
            }
            if(!eWSRNotificationList.isEmpty()){
                for(eWSR_Notification_Group__c member: eWSRNotificationList){
                    if(member.UserId__c == rightUserMap.get(s)){
                        delete member;
                    }
                }       
            }
            rightUserMap.remove(s);
        }
        return null;
    }
 
    public List<SelectOption> getunSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftvalues);
        tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
        return options;
    }
 
    public List<SelectOption> getSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightvalues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }
    
    public pagereference search(){
        leftvalues.clear();
        leftUserMap.clear();
        String s = '%' +name+ '%';
        for(User u : [Select Id, Name from User where Name Like :s Limit 100]){
            leftvalues.add(u.Name);
            leftUserMap.put(u.Name, u.Id);
        }
        return null;
        
    }
    
    public Group getQueue(String QueueName){
        Group que = [Select Type, id From Group g where Type=:eWSRConstantsVariablesClass.QUEUE And Name =:QueueName Limit 1];
        return que;
    }
    
    public List<GroupMember> getPublicGroup(String QueueId){
        List<GroupMember> gpList = [Select UserOrGroupId From GroupMember where GroupId =:QueueId];
        return gpList;
    }
        
    public List<Id> getUserIds(String gpId){
        List<Id> userList = new List<Id>();
        for(GroupMember groupMem : [Select UserOrGroupId From GroupMember where GroupId =:gpId]){
            userList.add(groupMem.UserOrGroupId);
        }
        return userList;
    }
    
    public Account getAccount(Id Name){
        Account accName = [Select Id, Short_Name__c from Account where Id =: Name Limit 1];
        return accName;
    }
    
    public void geteWSRNotificationList(){
        UtilClassToGetAllFields utilClass = new UtilClassToGetAllFields();
        String notificationFields = utilClass.getAllFields('eWSR_Notification_Group__c');
        String notificationQuery = 'select '+notificationFields+' from eWSR_Notification_Group__c where eWSR_Form__c = \''+eWSRForm.Id+'\' order by UserId__c ASC ';
        eWSRNotificationList = Database.query(notificationQuery);
        if(eWSRNotificationList.size() > 0){
            for(eWSR_Notification_Group__c tempList: eWSRNotificationList){
                rightvalues.add(tempList.User__c);
                rightUserMap.put(tempList.User__c, tempList.UserId__c);
            }
        }
    }

    public eWSRFormsNewEditExtension(ApexPages.StandardController stdcontroller) {
                
        this.controller = stdcontroller;
        reqField1 = TRUE;
        show = FALSE;
        othersSection = FALSE;
        fabExecutionSection = FALSE;
        showSelectField = FALSE;
        showSelectField1 = FALSE;
        showSelectField2 = FALSE;
        showSelectField4 = FALSE;
        valueBool = FALSE;
        showError = FALSE;
        queuePresent = FALSE;
        showOtherWaferField = FALSE;
        showErrorWafer = FALSE;
        showErrorReqDate =  FALSE;
        MasksetlayerEdit = FALSE;
        
        eWSRNotificationList = new List<eWSR_Notification_Group__c>();        
        rightUserMap = new Map<String,Id>();
        leftUserMap = new Map<String,Id>();
        leftselected = new List<String>();
        rightselected = new List<String>();
      
        User ownerId ;
        userId = Userinfo.getUserId();
        UtilClassToGetAllFields utilClass = new UtilClassToGetAllFields();
        //String approverFields = utilClass.getAllFields('eWSR_Notification_Group__c');
        
        if(eWSRForm.id == null){
            recid =  ApexPages.currentPage().getParameters().get('RecordType');
            eWSRForm.RecordTypeId = recid ;
            eWSRForm.Full_loop_Short_loop__c = 'Full Loop';
        }
        else{   
           eWSR_Form__c forms = [Select Status__c, RecordTypeId, No_of_Mask_Layers_Processing__c, Full_loop_Short_loop__c, Additional_Cycle_Time_required__c, Part_ID__c,
                                Are_you_providing_start_material__c, OwnerId, No_of_SOP_Holds__c, No_of_SPSRs__c, No_of_Additional_days_required__c, Wafer_Starting_Material__c,
                                Lot_Priority__c, Module__c, Program__c, Total_Number_of_Mask_Layer__c from eWSR_Form__c where Id=:eWSRForm.id];
            
            recid = forms.RecordTypeId ;
            maskProLayers = String.valueOf(forms.No_of_Mask_Layers_Processing__c);
            
            if(forms.Additional_Cycle_Time_required__c == 'Yes'){
                show = true;
            }
            if(forms.Are_you_providing_start_material__c == 'Yes'){
                showSelectField = true;
                showSelectField1 = true;
            }
            else if(forms.Are_you_providing_start_material__c == 'No'){
                showSelectField2 = True; 
                eWSR_Devices__c startMat = [SELECT Id, Start_Material__c FROM eWSR_Devices__c where Id =:forms.Part_ID__c];
                devStartMat2 = forms.Wafer_Starting_Material__c;
                devStartMat3 = startMat.Start_Material__c; 
                if(forms.Wafer_Starting_Material__c == 'Others'){
                    showOtherWaferField = true;
                }
            }
            else if(forms.Are_you_providing_start_material__c == eWSRConstantsVariablesClass.STARTMATERIALFIELDVALUE ){
                showSelectField4 = True;
            }
          
            OwnerEditId = forms.OwnerId;
            valShFull = forms.Full_loop_Short_loop__c;
            if(valShFull == 'Short Loop'){
                reqField = true;
            }
            valueSPSR = String.valueOf(forms.No_of_SPSRs__c);
            valueSOP = String.valueOf(forms.No_of_SOP_Holds__c);
            additionalDays = String.valueOf(forms.No_of_Additional_days_required__c);
            totalMaskLayers = forms.Total_Number_of_Mask_Layer__c;
            lotPriority = forms.Lot_Priority__c;
            valueMod = forms.Module__c;
            valueProg = forms.Program__c;
                     
        }
        RecordType rt = [Select Name from RecordType where SobjectType =: eWSRConstantsVariablesClass.EWSRFORMSOBJECT and id =:recid Limit 1];
        recName = rt.Name;
     
        if(recName == eWSRConstantsVariablesClass.FAB3ERECORDTYPE || recName == eWSRConstantsVariablesClass.FAB6RECORDTYPE){
            reqField1 = FALSE;
        }
        if(eWSRForm.id != null){
            geteWSRNotificationList();
        }
        if(eWSRForm.id == null){
            eWSRForm.Ownerid = userId; 
            ownerId = uservalue(eWSRForm.Ownerid);
            eWSRForm.Contact_Number__c = ownerId.Phone;
            eWSRForm.Dept_Cost_Center_Number__c = ownerId.Dept_Cost_Center_Number__c;
            if(ownerId.ManagerID != null){
                eWSRForm.Manager_1__c = ownerId.ManagerID;
            }
            if(recName  == eWSRConstantsVariablesClass.FAB7RECORDTYPE){
                eWSRForm.Customer_Lot_Prefix_or_Full_lot_ID__c = '7XY*';
            }
            List<eWSR_Account_Name__c> accName= eWSR_Account_Name__c.getall().values();
            Account acc = getAccount(accName[0].Name);
            eWSRForm.Customer_Name__c = accName[0].Name;
            eWSRForm.Customer_Shortname__c = acc.Short_Name__c;
        }
        else{
            ownerId = uservalue(userId);
        }
        
        if(recName == eWSRConstantsVariablesClass.FAB2RECORDTYPE){
              QueueName = eWSRConstantsVariablesClass.FAB2QNAME;
        }
        else if(recName == eWSRConstantsVariablesClass.FAB3RECORDTYPE){
              QueueName = eWSRConstantsVariablesClass.FAB3QNAME;
        }
        else if(recName == eWSRConstantsVariablesClass.FAB3ERECORDTYPE){
              QueueName = eWSRConstantsVariablesClass.FAB3EQNAME;
        }
        else if(recName == eWSRConstantsVariablesClass.FAB5RECORDTYPE){
              QueueName = eWSRConstantsVariablesClass.FAB5QNAME;
        }
        else if(recName == eWSRConstantsVariablesClass.FAB5JVRECORDTYPE){
              QueueName = eWSRConstantsVariablesClass.FAB5JVQNAME;
        }
        else if(recName == eWSRConstantsVariablesClass.FAB6RECORDTYPE){
              QueueName = eWSRConstantsVariablesClass.FAB6QNAME;
        }
        else{
              QueueName = eWSRConstantsVariablesClass.FAB7QNAME;
        }
        
        Group que = getQueue(QueueName);
        List<GroupMember> grpList = getPublicGroup(que.Id);
        List<Id> userIds = new List<Id>();
        List<Id> userConId = new List<Id>();
        if(grpList.size() > 1){
            for(Integer i = 0; i<grpList.size(); i++){      
                userConId = getUserIds(grpList[i].UserOrGroupId);  
                for(Id usersId : userConId){
                    userIds.add(usersId);
                }             
            }
        }
        else{
            userIds = getUserIds(grpList[0].UserOrGroupId);
        }
        
        //if(eWSRForm.id != null && (eWSRForm.Status__c.contains(eWSRConstantsVariablesClass.STATUSPLANAPPROVAL) || eWSRForm.Status__c == eWSRConstantsVariablesClass.STATUSAPPROVED)){
          if(eWSRForm.id != null && (eWSRConstantsVariablesClass.STATUSPLANAPPROVAL.contains(eWSRForm.Status__c)) || eWSRForm.Status__c == eWSRConstantsVariablesClass.STATUSAPPROVED){
            for(ID userIdnew : userIds ){
                if(userId == userIdnew){
                    othersSection = TRUE;
                    fabExecutionSection = TRUE;
                    queuePresent = true;
                }
            }
        }
    }
            
    public Boolean validateUser(){
        Boolean chkUser = false;
		system.debug('userId:...'+userId+'OwnerEditId:...'+OwnerEditId+'eWSRForm.Status__c :....'+eWSRForm.Status__c );
		system.debug('queuePresent:...'+queuePresent);
        if((userId == OwnerEditId && eWSRForm.Status__c != eWSRConstantsVariablesClass.STATUSAPPROVED) || queuePresent == true){
            chkUser = true;
        }
        return chkuser;
    }
    
    public Boolean validateFields(){
        Boolean chkFields = FALSE;
        if(eWSRForm.Emp_ID__c == null || eWSRForm.Process_ID__c == null || eWSRForm.Total_Number_of_Mask_Layer__c == null){
            chkFields = TRUE;
        }
        else{
            chkFields = FALSE;
        }
        return chkFields;
    }
    
    public void saveEWSRNotificationList(){
		system.debug('ENTER::::');
        List<eWSR_Notification_Group__c> groupList = new List<eWSR_Notification_Group__c>();
        if(!rightUserMap.isEmpty()){
            for(String key: rightUserMap.keySet()){
                groupList.add(new eWSR_Notification_Group__c(eWSR_Form__c = eWSRForm.Id, UserId__c = rightUserMap.get(key), user__c = key));
            }
        }
        
        Set<Id> existingNotificationSet = new Set<Id>();
        for(eWSR_Notification_Group__c member: eWSRNotificationList){
            existingNotificationSet.add(member.UserId__c);
        }
        if(!groupList.isEmpty()){
            if(!eWSRNotificationList.isEmpty()){                
                for(eWSR_Notification_Group__c member2: groupList){
                    for(eWSR_Notification_Group__c member1: eWSRNotificationList){
                        if(member2.UserId__c == member1.UserId__c){                              
                        }
                        else{
                            if(!existingNotificationSet.contains(member2.UserId__c)){                             
                                insert member2;
                                break;
                            }
                        }
                    }
                }
            }
            else{
                upsert groupList;
            }
        }
    }

    public PageReference Save(){
        Boolean checkUser = FALSE;
        Boolean checkFields = FALSE;
        PageReference result = null;
        if(eWSRForm.Id != null){
            checkUser=validateUser();
        }
        
        if(eWSRForm.Id == null || eWSRForm.Id != null){            
            checkFields = validateFields();
        }
		system.debug('showError:...'+showError);
		system.debug('checkUser:...'+checkUser);
		system.debug('eWSRForm.Id...'+eWSRForm.Id);
		system.debug('eWSRForm.Status__c:..'+eWSRForm.Status__c);
		system.debug('showErrorWafer:...'+showErrorWafer);
		system.debug('showErrorReqDate:...'+showErrorReqDate);
		system.debug('checkFields:...'+checkFields);

        if(showError == FALSE && (checkUser == TRUE || eWSRForm.Id == null) && eWSRForm.Status__c != eWSRConstantsVariablesClass.STATUSVOID && showErrorWafer == FALSE && showErrorReqDate == FALSE && checkFields == FALSE){
            /******Added By Shyam R Nair on 3/17/2015*******/
            //if(eWSRForm.Equivalent_Quantity__c == null){
            if(eWSRForm.Status__c == 'New' || eWSRForm.Status__c == 'Rejected'){
                valueEq();
                lotOwnValue();
                checkDate();
            }
            /*************************************End*******/
            upsert eWSRForm;
            eWSR_Form__c form = [Select id, Name, Remaining_Quantity__c from eWSR_Form__c where Id =:eWSRForm.Id];
            upload(form.Id);
            if(wafStaMat != null){
                form.Wafer_Starting_Material__c = wafStaMat;
            }
            String FabrecNames=recName.right(recName.length()-3);
            form.Request_Number__c = FabrecNames+'-'+ form.Name;           
            update form;
            
            saveEWSRNotificationList();
       
        return new PageReference ('/' + form .Id); 
        }
        
        else if(showError == FALSE && (checkUser == TRUE || eWSRForm.Id == null) && eWSRForm.Status__c != eWSRConstantsVariablesClass.STATUSVOID && showErrorWafer == FALSE && showErrorReqDate == FALSE && checkFields == TRUE){
            MasksetlayerEdit=true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,eWSRConstantsVariablesClass.ERRORMSGCHKFIELDS));
            return null;
        }
        
        else if(eWSRForm.Id != null && eWSRForm.Status__c == eWSRConstantsVariablesClass.STATUSVOID){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,eWSRConstantsVariablesClass.ERRORMSGNOSAVE));
             return null;
        }
        
        else{
            if(eWSRForm.Id != null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, eWSRConstantsVariablesClass.ERRORMSGNOACCESS));
            }       
            return null;
        }   
    }

}