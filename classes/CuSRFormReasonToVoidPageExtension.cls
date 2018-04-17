/*
Author: Shyam Ravindra Nair
Description: Apex class will act as extension for CuSRFormReasonToVoidForm
History:
SNair     11112014     - code creation
SNair     13042015     - modified
PSamal    06122017     - Case-00051184(Changes for new site - Essex Junction, East Fishkill, ASIC)
*/

public class CuSRFormReasonToVoidPageExtension {
    public CuSR_Form__c cusrForm{get;set;}
    public String cusrFormId{get;set;}
    public pageReference pgRef{get;set;}
    public User loggedInUser{get;set;}
    public Profile loggedInProfile{get;set;}
    public boolean fab1CEUser{get;set;}
    public boolean fab2CEUser{get;set;}
    public boolean fab3CEUser{get;set;}
    public boolean fab3eCEUser{get;set;}
    public boolean fab5CEUser{get;set;}
    public boolean fab6CEUser{get;set;}
    public boolean fab7CEUser{get;set;}
    public boolean fab8CEUser{get;set;}
    public boolean fab9CEUser{get;set;}
    public boolean fab10CEUser{get;set;}
    public boolean asicCEUser{get;set;}
    public boolean validateField{get;set;}
    public boolean validateFieldForFab{get;set;}
    public String selectFabs{get;set;}
    public List<selectOption> fabsToVoidList{get;set;}
    public CuSR_Void_History__c cusrVoidForSelectedFab{get;set;}
    public Integer availableFabs{get;set;}
    public boolean showSelectionOptionError{get;set;}
    public List<CuSR_Cost__c> cusrCostList{get;set;}
    public List<CuSR_Cost__c> selectedCostList{get;set;}
    public boolean enableIndividualFabTab{get;set;}
    
    //constructor
    public CuSRFormReasonToVoidPageExtension(){
        enableIndividualFabTab = true;
        cusrFormId = ApexPages.currentPage().getParameters().get('CuSRFormId');
        if(cusrFormId != null){
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String cusrFields = util.getAllFields('CuSR_Form__c');
            String cusrquery = 'select '+cusrFields+' from CuSR_Form__c where Id =\''+cusrFormId+'\'';
            cusrForm = database.query(cusrquery);
        }
        setCurrentUser();
        cusrVoidForSelectedFab = new CuSR_Void_History__c();
        setFabs();
        if(availableFabs == 1){
            enableIndividualFabTab = false;
        }
        selectedCostList = new List<CuSR_Cost__c>();
        cusrCostList = new List<CuSR_Cost__c>();
        cusrCostList = [select Id, Fab__c, Voided__c, CuSR_Form__c from CuSR_Cost__c where CuSR_Form__c =: cusrForm.Id];
        //initializeVoidHistoryRecords();
    }
    
    public void setFabs(){
        availableFabs = 0;
        fabsToVoidList = new List<selectOption>();
        if(cusrForm.FAB_1__c && !(cusrForm.FAB_1_Void__c)){
            availableFabs ++;
            if(fab1CEUser)
                fabsToVoidList.add(new selectOption('FAB 1','FAB 1'));
        }
        if(cusrForm.FAB_2__c && !(cusrForm.FAB_2_Void__c)){
            availableFabs ++;
            if(fab2CEUser)
                fabsToVoidList.add(new selectOption('FAB 2','FAB 2'));
        }
        if(cusrForm.FAB_3__c && !(cusrForm.FAB_3_Void__c)){
            availableFabs ++;
            if(fab3CEUser)
                fabsToVoidList.add(new selectOption('FAB 3','FAB 3'));
        }
        if(cusrForm.FAB_3E__c && !(cusrForm.FAB_3E_Void__c)){
            availableFabs ++;
            if(fab3eCEUser)
                fabsToVoidList.add(new selectOption('E','FAB 3E'));
        }
        if(cusrForm.FAB_5__c && !(cusrForm.FAB_5_Void__c)){
            availableFabs ++;
            if(fab5CEUser)
                fabsToVoidList.add(new selectOption('FAB 5','FAB 5'));
        }
        if(cusrForm.FAB_6__c && !(cusrForm.FAB_6_Void__c)){
            availableFabs ++;
            if(fab6CEUser)
                fabsToVoidList.add(new selectOption('FAB 6','FAB 6'));
        }
        if(cusrForm.FAB_7__c && !(cusrForm.FAB_7_Void__c)){
            availableFabs ++;
            if(fab7CEUser)
                fabsToVoidList.add(new selectOption('FAB 7','FAB 7'));
        }
        if(cusrForm.FAB_8__c && !(cusrForm.FAB_8_Void__c)){
            availableFabs ++;
            if(fab8CEUser)
                fabsToVoidList.add(new selectOption('FAB 8','FAB 8'));
        }
        if(cusrForm.FAB_9__c && !(cusrForm.FAB_9_Void__c)){
            availableFabs ++;
            if(fab9CEUser)
                fabsToVoidList.add(new selectOption('FAB 9','FAB 9'));
        }
        if(cusrForm.FAB_10__c && !(cusrForm.FAB_10_Void__c)){
            availableFabs ++;
            if(fab10CEUser)
                fabsToVoidList.add(new selectOption('FAB 10','FAB 10'));
        }
        if(cusrForm.ASIC__c && !(cusrForm.ASIC_Void__c)){
            availableFabs ++;
            if(asicCEUser)
                fabsToVoidList.add(new selectOption('ASIC','ASIC'));
        }
    }
    
    //method to set current user
    public void setCurrentUser(){
        fab1CEUser = false;
        fab2CEUser = false;
        fab3CEUser = false;
        fab3eCEUser = false;
        fab5CEUser = false;
        fab6CEUser = false;
        fab7CEUser = false;
        fab8CEUser = false;
        fab9CEUser = false;
        fab10CEUser = false;
        asicCEUser = false;
        loggedInUser = [select Id, Name from User where Id =: userInfo.getUserId()];
        system.debug('Logged in user'+loggedInUser.Name);
        loggedInProfile = [select Id, Name from Profile where Id =: userInfo.getProfileId()];
        Account acc = new Account();
        List<Account_Team_Proxy__c> accProxy = new List<Account_Team_Proxy__c>();
        if(cusrForm.Customer_Name__c != null){
            acc = [select Id from Account where Id =: cusrForm.Customer_Name__c];
            accProxy = [select Id, User__c, Account__c, Team_Role__c, Fab_Assignment__c from Account_Team_Proxy__c where Account__c =: acc.Id and Team_Role__c =: 'Customer Engineer'];
        }
        if(!accProxy.isEmpty()){
            for(Account_Team_Proxy__c member: accProxy){
                    if((member.Fab_Assignment__c.contains('FAB 1') && member.User__c == loggedInUser.Id) || cusrForm.OwnerId == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab1CEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('FAB 2') && member.User__c == loggedInUser.Id) || cusrForm.OwnerId == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab2CEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('FAB 3') && member.User__c == loggedInUser.Id) || cusrForm.OwnerId == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab3CEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('E') && member.User__c == loggedInUser.Id) || cusrForm.OwnerId == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab3eCEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('FAB 5') && member.User__c == loggedInUser.Id) || cusrForm.OwnerId == loggedInUser.Id || cusrForm.OwnerId == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab5CEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('FAB 6') && member.User__c == loggedInUser.Id) || cusrForm.OwnerId == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab6CEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('FAB 7') && member.User__c == loggedInUser.Id) || cusrForm.OwnerId == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab7CEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('FAB 8') && member.User__c == loggedInUser.Id) || cusrForm.OwnerId == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab8CEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('FAB 9') && member.User__c == loggedInUser.Id) || cusrForm.OwnerId == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab9CEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('FAB 10') && member.User__c == loggedInUser.Id) || cusrForm.OwnerId == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            fab10CEUser = true;
                    }
                    if((member.Fab_Assignment__c.contains('ASIC') && member.User__c == loggedInUser.Id) || cusrForm.OwnerId == loggedInUser.Id || loggedInProfile.Name == 'System Administrator' || loggedInProfile.Name == 'GF System Admin' || loggedInProfile.Name == 'GF Integration' || loggedInProfile.Name == 'CTS Developers'){
                            asicCEUser = true;
                    }
            }
        }
    }
    
    public void validateFieldMethod(){
        validateField = true;
        if(cusrForm.Reason_to_Void__c == null){
            validateField = false;
            cusrForm.Reason_to_Void__c.addError('Please mention the reason.');
        }
    }
    
    //method to submit the CuSR Form to void
    public pageReference submitToVoidForm(){
        pgRef = new pageReference('/'+cusrForm.Id);
        validateFieldMethod();
        if(!validateField){
            return null;
        }
        else{
            createVoidHistoryForForm();
            pgRef.setRedirect(true);
            return pgRef;       
        }
    }
    
    //method to create CuSR Void History record for Void CUSR Form
    public void createVoidHistoryForForm(){
        CuSR_Void_History__c cusrVoidHistory = new CuSR_Void_History__c();
        String selectedFab = '';
        /*String scope = '; ';
        scope += cusrForm.Scope__c;*/
        if(cusrForm.FAB_1__c && cusrForm.FAB_1_Void__c == false){
            selectedFab += '; FAB 1';
            cusrForm.FAB_1_Void__c = true;
            cusrForm.FAB_1__c = false;
            cusrForm.Additional_FAB_1__c = false;
            //scope.remove('; FAB 1');
        }
        if(cusrForm.FAB_2__c && cusrForm.FAB_2_Void__c == false){
            selectedFab += '; FAB 2';
            cusrForm.FAB_2_Void__c = true;
            cusrForm.FAB_2__c = false;
            cusrForm.Additional_FAB_2__c = false;
            //scope.remove('; FAB 2');
        }
        if(cusrForm.FAB_3__c && cusrForm.FAB_3_Void__c == false){
            selectedFab += '; FAB 3';
            cusrForm.FAB_3_Void__c = true;
            cusrForm.FAB_3__c = false;
            cusrForm.Additional_FAB_3__c = false;
            //scope.remove('; FAB 3');
        }
        if(cusrForm.FAB_3E__c && cusrForm.FAB_3E_Void__c == false){
            selectedFab += '; FAB 3E';
            cusrForm.FAB_3E_Void__c = true;
            cusrForm.FAB_3E__c = false;
            cusrForm.Additional_FAB_3E__c = false;
            //scope.remove('; FAB 3E');
        }
        if(cusrForm.FAB_5__c && cusrForm.FAB_5_Void__c == false){
            selectedFab += '; FAB 5';
            cusrForm.FAB_5_Void__c = true;
            cusrForm.FAB_5__c = false;
            cusrForm.Additional_FAB_5__c = false;
            //scope.remove('; FAB 5');
        }
        if(cusrForm.FAB_6__c && cusrForm.FAB_6_Void__c == false){
            selectedFab += '; FAB 6';
            cusrForm.FAB_6_Void__c = true;
            cusrForm.FAB_6__c = false;
            cusrForm.Additional_FAB_6__c = false;
            //scope.remove('; FAB 6');
        }
        if(cusrForm.FAB_7__c && cusrForm.FAB_7_Void__c == false){
            selectedFab += '; FAB 7';
            cusrForm.FAB_7_Void__c = true;
            cusrForm.FAB_7__c = false;
            cusrForm.Additional_FAB_7__c = false;
            //scope.remove('; FAB 7');
        }
        if(cusrForm.FAB_8__c && cusrForm.FAB_8_Void__c == false){
            selectedFab += '; FAB 8';
            cusrForm.FAB_8_Void__c = true;
            cusrForm.FAB_8__c = false;
            cusrForm.Additional_FAB_8__c = false;
            //scope.remove('; FAB 8');
        }
        if(cusrForm.FAB_9__c && cusrForm.FAB_9_Void__c == false){
            selectedFab += '; FAB 9';
            cusrForm.FAB_9_Void__c = true;
            cusrForm.FAB_9__c = false;
            cusrForm.Additional_FAB_9__c = false;
            //scope.remove('; FAB 9');
        }
        if(cusrForm.FAB_10__c && cusrForm.FAB_10_Void__c == false){
            selectedFab += '; FAB 10';
            cusrForm.FAB_10_Void__c = true;
            cusrForm.FAB_10__c = false;
            cusrForm.Additional_FAB_10__c = false;
            //scope.remove('; FAB 10');
        }
        if(cusrForm.ASIC__c && cusrForm.ASIC_Void__c == false){
            selectedFab += '; ASIC';
            cusrForm.ASIC_Void__c = true;
            cusrForm.ASIC__c = false;
            cusrForm.Additional_ASIC__c = false;
            //scope.remove('; ASIC');
        }
        if(cusrCostList.size() > 0){
            for(CuSR_Cost__c cusrCost: cusrCostList){
                if(selectedFab.contains('; FAB 1') && cusrCost.Fab__c == 'FAB 1'){
                    cusrCost.Voided__c = true;
                    selectedCostList.add(cusrCost);
                }
                if(selectedFab.contains('; FAB 2') && cusrCost.Fab__c == 'FAB 2'){
                    cusrCost.Voided__c = true;
                    selectedCostList.add(cusrCost);
                }
                if(selectedFab.contains('; FAB 3') && cusrCost.Fab__c == 'FAB 3'){
                    cusrCost.Voided__c = true;
                    selectedCostList.add(cusrCost);
                }
                if(selectedFab.contains('E') && cusrCost.Fab__c == 'FAB 3E'){
                    cusrCost.Voided__c = true;
                    selectedCostList.add(cusrCost);
                }
                if(selectedFab.contains('; FAB 5') && cusrCost.Fab__c == 'FAB 5'){
                    cusrCost.Voided__c = true;
                    selectedCostList.add(cusrCost);
                }
                if(selectedFab.contains('; FAB 6') && cusrCost.Fab__c == 'FAB 6'){
                    cusrCost.Voided__c = true;
                    selectedCostList.add(cusrCost);
                }
                if(selectedFab.contains('; FAB 7') && cusrCost.Fab__c == 'FAB 7'){
                    cusrCost.Voided__c = true;
                    selectedCostList.add(cusrCost);
                }
                if(selectedFab.contains('; FAB 8') && cusrCost.Fab__c == 'FAB 8'){
                    cusrCost.Voided__c = true;
                    selectedCostList.add(cusrCost);
                }
                if(selectedFab.contains('; FAB 9') && cusrCost.Fab__c == 'FAB 9'){
                    cusrCost.Voided__c = true;
                    selectedCostList.add(cusrCost);
                }
                if(selectedFab.contains('; FAB 10') && cusrCost.Fab__c == 'FAB 10'){
                    cusrCost.Voided__c = true;
                    selectedCostList.add(cusrCost);
                }
                if(selectedFab.contains('; ASIC') && cusrCost.Fab__c == 'ASIC'){
                    cusrCost.Voided__c = true;
                    selectedCostList.add(cusrCost);
                }
            }
            
            if(!selectedCostList.isEmpty()){
                update selectedCostList;
            }
        }
        selectedFab = selectedFab.substring(2);
        cusrVoidHistory.Name = 'CuSR_Void_AllFab_'+cusrForm.Name;
        cusrVoidHistory.Fab__c = selectedFab;
        cusrVoidHistory.Reason_to_Void__c = cusrForm.Reason_to_Void__c;
        cusrVoidHistory.Void_All__c = true;
        cusrVoidHistory.CuSR_Form__c = cusrForm.Id;
        cusrVoidHistory.Voided_By__c = loggedInUser.Id;
        cusrVoidHistory.Voided_On__c = datetime.now();
        insert cusrVoidHistory;
        /*scope = scope.substring(2);
        cusrForm.Scope__c = scope;*/
        cusrForm.Status__c = 'Void';
        update cusrForm;
        setFabFields();
    }
    
    public void validateFieldMethodForSelectedFab(){
        validateFieldForFab = true;
        showSelectionOptionError = false;
        if(cusrVoidForSelectedFab.Reason_To_Void__c == null){
            validateFieldForFab = false;
            cusrVoidForSelectedFab.Reason_To_Void__c.addError('Please mention the reason.');
        }
        if(selectFabs == '[]'){
            validateFieldForFab = false;
            showSelectionOptionError = true;
            //selectFabs.addError('Please select a FAB.');
        }
    }
    
    //method to submit selected Fabs to void
    public pageReference submitSelectedFabsToVoid(){
        pgRef = new pageReference('/'+cusrForm.Id); 
        validateFieldMethodForSelectedFab();
        if(!validateFieldForFab){
            return null;
        }
        else{
            system.debug('Selected Fabs are: '+selectFabs);
            String fabs = '';
            if(selectFabs.contains('FAB 1') && cusrForm.FAB_1_Void__c == false){
                cusrForm.FAB_1_Void__c = true;
                cusrForm.FAB_1__c = false;
                cusrForm.Additional_FAB_1__c = false;
                fabs += '; FAB 1';
            }
            if(selectFabs.contains('FAB 2') && cusrForm.FAB_2_Void__c == false){
                cusrForm.FAB_2_Void__c = true;
                cusrForm.FAB_2__c = false;
                cusrForm.Additional_FAB_2__c = false;
                fabs += '; FAB 2';
            }
            if(selectFabs.contains('FAB 3') && cusrForm.FAB_3_Void__c == false){
                cusrForm.FAB_3_Void__c = true;
                cusrForm.FAB_3__c = false;
                cusrForm.Additional_FAB_3__c = false;
                fabs += '; FAB 3';
            }
            if(selectFabs.contains('E') && cusrForm.FAB_3E_Void__c == false){
                cusrForm.FAB_3E_Void__c = true;
                cusrForm.FAB_3E__c = false;
                cusrForm.Additional_FAB_3E__c = false;
                fabs += '; FAB 3E';
            }
            if(selectFabs.contains('FAB 5') && cusrForm.FAB_5_Void__c == false){
                cusrForm.FAB_5_Void__c = true;
                cusrForm.FAB_5__c = false;
                cusrForm.Additional_FAB_5__c = false;
                fabs += '; FAB 5';
            }
            if(selectFabs.contains('FAB 6') && cusrForm.FAB_6_Void__c == false){
                cusrForm.FAB_6_Void__c = true;
                cusrForm.FAB_6__c = false;
                cusrForm.Additional_FAB_6__c = false;
                fabs += '; FAB 6';
            }
            if(selectFabs.contains('FAB 7') && cusrForm.FAB_7_Void__c == false){
                cusrForm.FAB_7_Void__c = true;
                cusrForm.FAB_7__c = false;
                cusrForm.Additional_FAB_7__c = false;
                fabs += '; FAB 7';
            }
            if(selectFabs.contains('FAB 8') && cusrForm.FAB_8_Void__c == false){
                cusrForm.FAB_8_Void__c = true;
                cusrForm.FAB_8__c = false;
                cusrForm.Additional_FAB_8__c = false;
                fabs += '; FAB 8';
            }
            if(selectFabs.contains('FAB 9') && cusrForm.FAB_9_Void__c == false){
                cusrForm.FAB_9_Void__c = true;
                cusrForm.FAB_9__c = false;
                cusrForm.Additional_FAB_9__c = false;
                fabs += '; FAB 9';
            }
            if(selectFabs.contains('FAB 10') && cusrForm.FAB_10_Void__c == false){
                cusrForm.FAB_10_Void__c = true;
                cusrForm.FAB_10__c = false;
                cusrForm.Additional_FAB_10__c = false;
                fabs += '; FAB 10';
            }
            if(selectFabs.contains('ASIC') && cusrForm.ASIC_Void__c == false){
                cusrForm.ASIC_Void__c = true;
                cusrForm.ASIC__c = false;
                cusrForm.Additional_ASIC__c = false;
                fabs += '; ASIC';
            }
            update cusrForm;
            if(cusrCostList.size() > 0){
                for(CuSR_Cost__c cusrCost: cusrCostList){
                    if(fabs.contains('; FAB 1') && cusrCost.Fab__c == 'FAB 1'){
                        cusrCost.Voided__c = true;
                        selectedCostList.add(cusrCost);
                    }
                    if(fabs.contains('; FAB 2') && cusrCost.Fab__c == 'FAB 2'){
                        cusrCost.Voided__c = true;
                        selectedCostList.add(cusrCost);
                    }
                    if(fabs.contains('; FAB 3') && cusrCost.Fab__c == 'FAB 3'){
                        cusrCost.Voided__c = true;
                        selectedCostList.add(cusrCost);
                    }
                    if(fabs.contains('; FAB 3E') && cusrCost.Fab__c == 'FAB 3E'){
                        cusrCost.Voided__c = true;
                        selectedCostList.add(cusrCost);
                    }
                    if(fabs.contains('; FAB 5') && cusrCost.Fab__c == 'FAB 5'){
                        cusrCost.Voided__c = true;
                        selectedCostList.add(cusrCost);
                    }
                    if(fabs.contains('; FAB 6') && cusrCost.Fab__c == 'FAB 6'){
                        cusrCost.Voided__c = true;
                        selectedCostList.add(cusrCost);
                    }
                    if(fabs.contains('; FAB 7') && cusrCost.Fab__c == 'FAB 7'){
                        cusrCost.Voided__c = true;
                        selectedCostList.add(cusrCost);
                    }
                    if(fabs.contains('; FAB 8') && cusrCost.Fab__c == 'FAB 8'){
                        cusrCost.Voided__c = true;
                        selectedCostList.add(cusrCost);
                    }
                    if(fabs.contains('; FAB 9') && cusrCost.Fab__c == 'FAB 9'){
                        cusrCost.Voided__c = true;
                        selectedCostList.add(cusrCost);
                    }
                    if(fabs.contains('; FAB 10') && cusrCost.Fab__c == 'FAB 10'){
                        cusrCost.Voided__c = true;
                        selectedCostList.add(cusrCost);
                    }
                    if(fabs.contains('; ASIC') && cusrCost.Fab__c == 'ASIC'){
                        cusrCost.Voided__c = true;
                        selectedCostList.add(cusrCost);
                    }
                }
                if(!selectedCostList.isEmpty()){
                    update selectedCostList;
                }
            }
            fabs = fabs.substring(2);
            cusrVoidForSelectedFab.Name = 'CuSR_Void_'+fabs+'_'+cusrForm.Name;
            cusrVoidForSelectedFab.Fab__c = fabs;
            cusrVoidForSelectedFab.CuSR_Form__c = cusrForm.Id;
            cusrVoidForSelectedFab.Void_All__c = false;
            cusrVoidForSelectedFab.Voided_By__c = loggedInUser.Id;
            cusrVoidForSelectedFab.Voided_On__c = datetime.now();
            insert cusrVoidForSelectedFab;
            setFabs();
            if(availableFabs == 0){
                cusrForm.Status__c = 'Void';
            }
            update cusrForm;
            setFabFields();
            pgRef.setRedirect(true);
            return pgRef;
        }
    }
    
    //method to set Fab and Voided Fab
    public void setFabFields(){
        String selectFab = '';
        String voidedFab = '';
        if(cusrForm.FAB_1__c || cusrForm.Additional_FAB_1__c){
            if(cusrForm.FAB_1_Void__c==false){
                selectFab += '; FAB 1';
            }
            else if(cusrForm.FAB_1_Void__c){
                voidedFab += '; FAB 1';
            }
        }
        if(cusrForm.FAB_2__c || cusrForm.Additional_FAB_2__c){
            if(cusrForm.FAB_2_Void__c==false){
                selectFab += '; FAB 2';
            }
            else if(cusrForm.FAB_2_Void__c){
                voidedFab += '; FAB 2';
            }
        }
        if(cusrForm.FAB_3__c || cusrForm.Additional_FAB_3__c){
            if(cusrForm.FAB_3_Void__c==false){
                selectFab += '; FAB 3';
            }
            else if(cusrForm.FAB_3_Void__c){
                voidedFab += '; FAB 3';
            }
        }
        if(cusrForm.FAB_3E__c || cusrForm.Additional_FAB_3E__c){
            if(cusrForm.FAB_3E_Void__c==false){
                selectFab += '; FAB 3E';
            }
            else if(cusrForm.FAB_3E_Void__c){
                voidedFab += '; FAB 3E';
            }
        }
        if(cusrForm.FAB_5__c || cusrForm.Additional_FAB_5__c){
            if(cusrForm.FAB_5_Void__c==false){
                selectFab += '; FAB 5';
            }
            else if(cusrForm.FAB_5_Void__c){
                voidedFab += '; FAB 5';
            }
        }
        if(cusrForm.FAB_6__c || cusrForm.Additional_FAB_6__c){
            if(cusrForm.FAB_6_Void__c==false){
                selectFab += '; FAB 6';
            }
            else if(cusrForm.FAB_6_Void__c){
                voidedFab += '; FAB 6';
            }
        }
        if(cusrForm.FAB_7__c || cusrForm.Additional_FAB_7__c){
            if(cusrForm.FAB_7_Void__c==false){
                selectFab += '; FAB 7';
            }
            else if(cusrForm.FAB_7_Void__c){
                voidedFab += '; FAB 7';
            }
        }
        if(cusrForm.FAB_8__c || cusrForm.Additional_FAB_8__c){
            if(cusrForm.FAB_8_Void__c==false){
                selectFab += '; FAB 8';
            }
            else if(cusrForm.FAB_8_Void__c){
                voidedFab += '; FAB 8';
            }
        }
        if(cusrForm.FAB_9__c || cusrForm.Additional_FAB_9__c){
            if(cusrForm.FAB_9_Void__c==false){
                selectFab += '; FAB 9';
            }
            else if(cusrForm.FAB_9_Void__c){
                voidedFab += '; FAB 9';
            }
        }
        if(cusrForm.FAB_10__c || cusrForm.Additional_FAB_10__c){
            if(cusrForm.FAB_10_Void__c==false){
                selectFab += '; FAB 10';
            }
            else if(cusrForm.FAB_10_Void__c){
                voidedFab += '; FAB 10';
            }
        }
        if(cusrForm.ASIC__c || cusrForm.Additional_ASIC__c){
            if(cusrForm.ASIC_Void__c==false){
                selectFab += '; ASIC';
            }
            else if(cusrForm.ASIC_Void__c){
                voidedFab += '; ASIC';
            }
        }
        if(selectFab != '')
            selectFab = selectFab.substring(2);
        cusrForm.Scope__c = selectFab;
        if(voidedFab != '') 
            voidedFab = voidedFab.substring(2);
        cusrForm.Voided_Fabs__c = voidedFab;
        update cusrForm;
    }
    
    //Method to cancel Edit
    public pageReference CancelAction(){
        pgRef = new pageReference('/'+cusrForm.Id);
        pgRef.setRedirect(true);
        return pgRef;
    }
}