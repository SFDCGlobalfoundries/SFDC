/*
Author: Shyam Ravindra Nair
Description: Trigger for Task for CuSR Implementation.
History:
SNair     30122014     - code creation
PSamal    06122017     - Case-00051184(Changes for new site - Essex Junction, East Fishkill, ASIC)
*/
trigger TriggerOnCuSRImplemenation on CuSR_Implementation__c(after update, after insert) {
    
    boolean success = false;
    CuSR_Implementation__c currentImplementationRecord = new CuSR_Implementation__c();
    
     if (!IntegrationUserUtil.isSkipTrigger()) {
        if(trigger.isAfter && trigger.isUpdate){//Added by Abhita
            for(CuSR_Implementation__c implementation: trigger.new){
                if(implementation.Status__c != 'Pending'){
                    success = true; 
                    currentImplementationRecord = implementation;   
                }
            }    
            if(success){
                integer dresdencount = 0;
                integer singaporecount = 0;
                integer maltacount = 0;
                integer essexjunctioncount = 0;
                integer eastfishkillcount = 0;
                integer asiccount = 0;
                List<CuSR_Implementation__c> implementationList = new List<CuSR_Implementation__c>();
                List<CuSR_Implementation__c> dresdenimplementationList = new List<CuSR_Implementation__c>();
                List<CuSR_Implementation__c> singaporeimplementationList = new List<CuSR_Implementation__c>();
                List<CuSR_Implementation__c> maltaimplementationList = new List<CuSR_Implementation__c>();
                List<CuSR_Implementation__c> essexjunctionimplementationList = new List<CuSR_Implementation__c>();
                List<CuSR_Implementation__c> eastfishkillimplementationList = new List<CuSR_Implementation__c>();
                List<CuSR_Implementation__c> asicimplementationList = new List<CuSR_Implementation__c>();
                UtilClassToGetAllFields util = new UtilClassToGetAllFields();
                String queryFields = util.getAllFields('CuSR_Form__c');
                String query = 'select '+queryFields+' from CuSR_Form__c where Id = \''+currentImplementationRecord.CuSR_Form__c+'\'';
                CuSR_Form__c cusrForm = database.query(query);
                //cusrForm = [select Id, Status__c from CuSR_Form__c where Id =: currentImplementationRecord.CuSR_Form__c];
                implementationList = [select Id, Status__c, Fab__c from CuSR_Implementation__c where CuSR_Form__c =: cusrForm.Id];
                system.debug('Size of Implementation'+implementationList.size());
                if(!implementationList.isEmpty()){
                    for(CuSR_Implementation__c implementation: implementationList){
                        if(implementation.Fab__c == 'FAB 1' && cusrForm.FAB_1_Void__c == false){
                            dresdenimplementationList.add(implementation);
                        }
                        if(implementation.Fab__c == 'FAB 8' && cusrForm.FAB_8_Void__c == false){
                            maltaimplementationList.add(implementation);
                        }
                        if(implementation.Fab__c == 'FAB 9' && cusrForm.FAB_9_Void__c == false){
                            essexjunctionimplementationList.add(implementation);
                        }
                        if(implementation.Fab__c == 'FAB 10' && cusrForm.FAB_10_Void__c == false){
                            eastfishkillimplementationList.add(implementation);
                        }
                        if(implementation.Fab__c == 'ASIC' && cusrForm.ASIC_Void__c == false){
                            asicimplementationList.add(implementation);
                        }
                        if((implementation.Fab__c == 'FAB 2' && cusrForm.FAB_2_Void__c == false) || (implementation.Fab__c == 'FAB 3' && cusrForm.FAB_3_Void__c == false) || (implementation.Fab__c == 'FAB 3E' && cusrForm.FAB_3E_Void__c == false) || (implementation.Fab__c == 'FAB 5' && cusrForm.FAB_5_Void__c == false) || (implementation.Fab__c == 'FAB 6' && cusrForm.FAB_6_Void__c == false) || (implementation.Fab__c == 'FAB 7' && cusrForm.FAB_7_Void__c == false)){
                            singaporeimplementationList.add(implementation);
                        }
                    }
                    system.debug('Size of Dresden'+dresdenimplementationList.size());
                    system.debug('Size of Singapore'+singaporeimplementationList.size());
                    system.debug('Size of Malta'+maltaimplementationList.size());
                    system.debug('Size of Essex Junction'+essexjunctionimplementationList.size());
                    system.debug('Size of East Fishkill'+eastfishkillimplementationList.size());
                    system.debug('Size of ASIC'+asicimplementationList.size());
                    if(cusrForm.FAB_1__c && cusrForm.FAB_1_Void__c == false){
                        system.debug('Dresden selected');
                        List<CuSR_Implementation__c> dresdenSucessList = new List<CuSR_Implementation__c>();
                        if(!dresdenimplementationList.isEmpty()){
                            for(CuSR_Implementation__c dresden: dresdenimplementationList){
                                if(dresden.Status__c != 'Pending'){
                                    dresdenSucessList.add(dresden);
                                }
                            }
                            if(dresdenSucessList.size() == dresdenimplementationList.size()){
                                for(CuSR_Implementation__c dresden: dresdenSucessList){
                                    if(dresden.Status__c == 'Completed'){
                                        system.debug('Completed in Dresden');
                                        dresdencount = 0;
                                        break;
                                    }
                                    else{
                                        dresdencount++;
                                    }
                                }
                            }
                            else{
                                dresdencount++;
                            }
                        }
                        else{
                            dresdencount++;
                        }
                    }
                    if(cusrForm.FAB_8__c && cusrForm.FAB_8_Void__c == false){
                        system.debug('Malta selected');
                        List<CuSR_Implementation__c> maltaSucessList = new List<CuSR_Implementation__c>();
                        if(!maltaimplementationList.isEmpty()){
                            for(CuSR_Implementation__c malta: maltaimplementationList){
                                if(malta.Status__c != 'Pending'){
                                    maltaSucessList.add(malta);
                                }
                            }
                            if(maltaSucessList.size() == maltaimplementationList.size()){
                                for(CuSR_Implementation__c malta: maltaSucessList){
                                    if(malta.Status__c == 'Completed'){
                                        system.debug('Completed in Malta');
                                        maltacount = 0;
                                        break;
                                    }
                                    else{
                                        maltacount++;
                                    }
                                }
                            }
                            else{
                                maltacount++;
                            }
                        }
                        else{
                            maltacount++;
                        }
                    }
                    if(cusrForm.FAB_9__c && cusrForm.FAB_9_Void__c == false){
                        system.debug('Essex Junction selected');
                        List<CuSR_Implementation__c> essexjunctionSucessList = new List<CuSR_Implementation__c>();
                        if(!essexjunctionimplementationList.isEmpty()){
                            for(CuSR_Implementation__c essexjunction: essexjunctionimplementationList){
                                if(essexjunction.Status__c != 'Pending'){
                                    essexjunctionSucessList.add(essexjunction);
                                }
                            }
                            if(essexjunctionSucessList.size() == essexjunctionimplementationList.size()){
                                for(CuSR_Implementation__c essexjunction: essexjunctionSucessList){
                                    if(essexjunction.Status__c == 'Completed'){
                                        system.debug('Completed in Essex Junction');
                                        essexjunctioncount = 0;
                                        break;
                                    }
                                    else{
                                        essexjunctioncount++;
                                    }
                                }
                            }
                            else{
                                essexjunctioncount++;
                            }
                        }
                        else{
                            essexjunctioncount++;
                        }
                    }
                    if(cusrForm.FAB_10__c && cusrForm.FAB_10_Void__c == false){
                        system.debug('East Fishkill selected');
                        List<CuSR_Implementation__c> eastfishkillSucessList = new List<CuSR_Implementation__c>();
                        if(!eastfishkillimplementationList.isEmpty()){
                            for(CuSR_Implementation__c eastfishkill: eastfishkillimplementationList){
                                if(eastfishkill.Status__c != 'Pending'){
                                    eastfishkillSucessList.add(eastfishkill);
                                }
                            }
                            if(eastfishkillSucessList.size() == eastfishkillimplementationList.size()){
                                for(CuSR_Implementation__c eastfishkill: eastfishkillSucessList){
                                    if(eastfishkill.Status__c == 'Completed'){
                                        system.debug('Completed in East Fishkill');
                                        eastfishkillcount = 0;
                                        break;
                                    }
                                    else{
                                        eastfishkillcount++;
                                    }
                                }
                            }
                            else{
                                eastfishkillcount++;
                            }
                        }
                        else{
                            eastfishkillcount++;
                        }
                    }
                    if(cusrForm.ASIC__c && cusrForm.ASIC_Void__c == false){
                        system.debug('ASIC selected');
                        List<CuSR_Implementation__c> asicSucessList = new List<CuSR_Implementation__c>();
                        if(!asicimplementationList.isEmpty()){
                            for(CuSR_Implementation__c asic: asicimplementationList){
                                if(asic.Status__c != 'Pending'){
                                    asicSucessList.add(asic);
                                }
                            }
                            if(asicSucessList.size() == asicimplementationList.size()){
                                for(CuSR_Implementation__c asic: asicSucessList){
                                    if(asic.Status__c == 'Completed'){
                                        system.debug('Completed in ASIC');
                                        asiccount = 0;
                                        break;
                                    }
                                    else{
                                        asiccount++;
                                    }
                                }
                            }
                            else{
                                asiccount++;
                            }
                        }
                        else{
                            asiccount++;
                        }
                    }
                    if((cusrForm.FAB_2__c && !(cusrForm.FAB_2_Void__c)) || (cusrForm.FAB_3__c && !(cusrForm.FAB_3_Void__c)) || (cusrForm.FAB_3E__c && !(cusrForm.FAB_3E_Void__c)) || (cusrForm.FAB_5__c && !(cusrForm.FAB_5_Void__c)) || (cusrForm.FAB_6__c && !(cusrForm.FAB_6_Void__c)) || (cusrForm.FAB_7__c && !(cusrForm.FAB_7_Void__c))){
                        system.debug('Singapore selected');
                        List<CuSR_Implementation__c> singaporeSucessList = new List<CuSR_Implementation__c>();
                        if(!singaporeimplementationList.isEmpty()){
                            for(CuSR_Implementation__c singapore: singaporeimplementationList){
                                if(singapore.Status__c != 'Pending'){
                                    singaporeSucessList.add(singapore);
                                }
                            }
                            if(singaporeSucessList.size() == singaporeimplementationList.size()){
                                for(CuSR_Implementation__c singapore: singaporeSucessList){
                                    if(singapore.Status__c == 'Completed'){
                                        system.debug('Completed in Singapore');
                                        singaporecount = 0;
                                        break;
                                    }
                                    else{
                                        singaporecount++;
                                    }
                                }
                            }
                            else{
                                singaporecount++;
                            }
                        }
                        else{
                            singaporecount++;
                        }
                    }
                    if(dresdencount == 0 && singaporecount == 0 && maltacount == 0 && essexjunctioncount == 0 && eastfishkillcount == 0 && asiccount == 0 && cusrForm.Status__c == 'Pending Implementation'){
                        cusrForm.Status__c = 'Implemented';
                        update cusrForm;
                    }
                }
            }
        }
        
        //Added by Abhita
        if(trigger.isAfter && trigger.isInsert){
            List<CuSR_Form__Share> formShares = new List<CuSR_Form__Share>();
        
            for(CuSR_Implementation__c cusrRecordImp: trigger.new){
                CuSR_Form__Share approvalShare = new CuSR_Form__Share ();
                if(cusrRecordImp.Assignee__c != null){
                    system.debug('Assignee is '+cusrRecordImp.Assignee__c);
                    approvalShare.UserOrGroupId = cusrRecordImp.Assignee__c;    
                    approvalShare.ParentId = cusrRecordImp.CuSR_Form__c;
                    approvalShare.AccessLevel = 'EDIT';
                    approvalShare.RowCause = Schema.CuSR_Form__Share.RowCause.Assignee__c;
                    formShares.add(approvalShare);        
                }
            }
            Database.SaveResult[] formSharesInsertResult = Database.insert(formShares ,false);
            system.debug('Succesfully shared access.'); 
            Integer i=0;
            for(Database.SaveResult sr :formSharesInsertResult ){
                if(!sr.isSuccess()){
                    // Get the first save result error
                    Database.Error err = sr.getErrors()[0];
                    
                    // Check if the error is related to a trivial access level
                    // Access levels equal or more permissive than the object's default 
                    // access level are not allowed. 
                    // These sharing records are not required and thus an insert exception is 
                    // acceptable. 
                    if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  
                                                   &&  err.getMessage().contains('AccessLevel'))){
                        // Throw an error when the error is not related to trivial access level.
                        trigger.newMap.get(formShares[i].ParentId).
                          addError(
                           'Unable to grant sharing access due to following exception: '
                           + err.getMessage());
                    }
                }
                i++;
            }
        }
        
     }
    
    
}