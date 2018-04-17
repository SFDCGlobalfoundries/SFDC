/*
Author: Shyam Ravindra Nair
Description: Apex class will act as handler for TriggerOnCuSRForm.
History:
SNair     24112014     - code creation
SNair     31122014     - updated logic for AM Approval
SNair     14012015     - updated logic for Additional fabs.
PSamal    06122017     - Case-00051184(Changes for new site - Essex Junction, East Fishkill, ASIC)
*/
public without sharing class TriggerOnCuSRApprovalProcessHandler{
    
//public CuSR_Form__c cusrForm{get;set;}
    public List<CuSR_Approval_Process__c> cusrApprovalList{get;set;}
    public List<CuSR_Form__c> cusrFormList{get;set;}
    public CuSR_Form__c cusrForm{get;set;}
    
    
    public void updateStatusOfCuSRFormOnUpdate(List<CuSR_Approval_Process__c> newCuSRApprovalList){
        system.debug('Size of CUSR Approval : '+newCuSRApprovalList.size());
        boolean rejected = false;
        boolean approved = false;
        boolean pendingAMApproval = false;
        boolean AMApproved = false;
        boolean removeFab = false;
        boolean amrejected = false;
        String cusrFormId;
        for(CuSR_Approval_Process__c newCuSRApproval: newCuSRApprovalList){
            cusrFormId = newCuSRApproval.CuSR_Form__c;
        }
        UtilClassToGetAllFields utilClass = new UtilClassToGetAllFields();
        String cusrFormFields = utilClass.getAllFields('CuSR_Form__c');
        //String cusrFormQuery = 'select '+cusrFormFields+' from CuSR_Form__c where Id = \''+newCuSRApprovalList[0].CuSR_Form__c+'\'';
        String cusrFormQuery = 'select '+cusrFormFields+' from CuSR_Form__c where Id = \''+cusrFormId+'\'';
        cusrForm = new CuSR_Form__c();
        cusrForm = database.query(cusrFormQuery);
        system.debug('CUSR FORM IS: '+cusrForm);
        String cusrApprovalFields = utilClass.getAllFields('CuSR_Approval_Process__c');
        String cusrApprovalQuery = 'select '+cusrApprovalFields+' from CuSR_Approval_Process__c where CuSR_Form__c = \''+cusrForm.Id+'\'';
        cusrApprovalList = new List<CuSR_Approval_Process__c>();
        cusrApprovalList = Database.query(cusrApprovalQuery);
        system.debug('CUSR APPROVAL SIZE IS: '+cusrApprovalList.size());
        Account acnt = new Account();
        acnt = [select Id, Name from Account where Id =: cusrForm.Customer_Name__c];
        List<User> ccRejectionUsers = new List<User>();
        List<User> ceList = new List<User>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(CuSR_Approval_Process__c newCuSRApproval: newCuSRApprovalList){
            if(newCuSRApproval.Type_of_Approver__c!='AM' && newCuSRApproval.Status__c == 'Rejected' && cusrForm.Status__c == 'Pending Stakeholder Review'){
                ccRejectionUsers = getCCUsersForRejectionMethod(newCuSRApproval);
                ceList = getCEUsersFromAccount(cusrForm);
                Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                singleMail.setTargetObjectId(cusrForm.OwnerId);
                singleMail.saveAsActivity = false;
                List<String> ccList = new List<String>();
                for(User u: ccRejectionUsers){
                    ccList.add(u.Email);
                }
                if(!ccList.isEmpty()){
                    for(User u: ceList){
                        ccList.add(u.Email);
                    }   
                }
                //ccList.add('lilli-ann.bobadilla@globalfoundries.com');
                singleMail.setCcAddresses(ccList);
                singleMail.setSubject('Customer Specific Request '+cusrForm.Name+' for Account '+acnt.Name+' is Rejected');
                String body = 'Dear User,';
                body += '<br/>';
                body += '<br/>';
                body += 'Customer Specific Request '+cusrForm.Name+' for Account '+acnt.Name+' is Rejected.';
                body += '<br/>';
                body += 'Please click the below link to access the record.';
                body += '<br/>';
                body += '<br/>';
                String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id;
                body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+hyperLink+'</a>';
                //body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+cusrForm.Name+'</a>';
                body += '<br/>';
                body += '<br/>';
                body += 'Thank you,';
                body += '<br/>';
                body += 'For further clarification/queries, please contact the Initiator of the CuSR.';
                body += '<br/>';
                body += 'This is a system generated auto email. Please do not reply.';
                singleMail.setHtmlBody(body);
                mails.add(singleMail);
                rejected = true;
            }
            if(newCuSRApproval.Type_of_Approver__c!='AM' && newCuSRApproval.Status__c == 'Approved' && newCuSRApproval.Approved__c && cusrForm.Status__c == 'Pending Stakeholder Review'){
                system.debug('Its Approved');
                approved = true;
                system.debug('approved: '+approved);
            }
            if(newCuSRApproval.Type_of_Approver__c == 'AM' && newCuSRApproval.Status__c == 'Pending Approval'){
                pendingAMApproval = true;
            }
            if(newCuSRApproval.Type_of_Approver__c == 'AM' && newCuSRApproval.Status__c == 'Approved'){
                AMApproved= true;
            }
            if(newCuSRApproval.Status__c == 'Rejected' && cusrForm.Status__c == 'Implemented'){
                removeFab = true;
            }
            if(newCuSRApproval.Type_of_Approver__c=='AM' && newCuSRApproval.Status__c == 'Rejected' && cusrForm.Status__c == 'Pending AM Review'){
                amrejected = true;
            }
        }
        if(mails.size() > 0){
            Messaging.sendEmail(mails);
        }
        
        
        if(amrejected){
            //cusrApprovalList = new List<CuSR_Approval_Process__c>();
            //cusrApprovalList = [select Id, Status__c, CuSR_Form__c, Type_of_Approver__c from CuSR_Approval_Process__c where CuSR_Form__c =: cusrForm.Id];
            List<CuSR_Approval_Process__c> deleteCusrApprovalProcess = new List<CuSR_Approval_Process__c>();
            List<CuSR_Approval_Process__c> updateCusrApprovalProcess = new List<CuSR_Approval_Process__c>();
            for(CuSR_Approval_Process__c cusrApprovalProcess: cusrApprovalList){
                if(cusrApprovalProcess.Type_of_Approver__c == 'AM'){
                    //delete cusrApprovalProcess;
                    deleteCusrApprovalProcess.add(cusrApprovalProcess);
                }
                else{
                    //cusrApprovalProcess.Status__c = 'New';
                    cusrApprovalProcess.Approved__c = false;
                    //update cusrApprovalProcess;
                    updateCusrApprovalProcess.add(cusrApprovalProcess);
                }
            }
            
            if(deleteCusrApprovalProcess.size() > 0){
                delete deleteCusrApprovalProcess;
            }
            if(updateCusrApprovalProcess.size() > 0){
                update updateCusrApprovalProcess;
            }
            cusrForm.PM_Approved__c = false;
            cusrForm.PM_Comments__c = '';
            //cusrForm.Cost_Impact__c = '';
            cusrForm.Any_Cost_Impact__c = 'No'; 
            cusrForm.Dresden_Ready_for_Approval__c = false;
            cusrForm.Singapore_Ready_for_Approval__c = false;
            cusrForm.Malta_Ready_for_Approval__c = false;
            cusrForm.Essex_Junction_Ready_for_Approval__c = false;
            cusrForm.East_Fishkill_Ready_for_Approval__c = false;
            cusrForm.ASIC_Ready_for_Approval__c = false;
            cusrForm.Stakeholder_Approval_Completed__c = false;
            cusrForm.Status__c = 'Rejected';
            cusrForm.Fifth_Day_Reminder__c = false;
            cusrForm.Ninth_Day_Reminder__c = false;
            update cusrForm;
        }
        
        if(removeFab){
            //cusrApprovalList = new List<CuSR_Approval_Process__c>();
            //cusrApprovalList = [select Id, Status__c, CuSR_Form__c from CuSR_Approval_Process__c where CuSR_Form__c =: cusrForm.Id];
            system.debug('No of Approvals to reject: '+cusrApprovalList.size());
            if(cusrApprovalList.size()>0){
                for(CuSR_Approval_Process__c cusrApproval: cusrApprovalList){
                    if(cusrApproval.Status__c == 'Pending Approval'){
                        Approval.ProcessWorkItemRequest req = new Approval.ProcessWorkItemRequest();
                        req.setComments('Recalled as another approval request is rejected.');
                        req.setAction('Removed');
                        Id workItemId = getWorkItemId(cusrApproval.Id);
                        req.setWorkitemId(workItemId);
                        Approval.ProcessResult result =  Approval.process(req);
                    }
                    
                }
            }
            for(CuSR_Approval_Process__c newCuSRApproval: newCuSRApprovalList){
                String addedFab = cusrForm.Additional_Fab_Added__c; 
                if(newCuSRApproval.Fab__c == 'FAB 1' || (newCuSRApproval.Site__c == 'Dresden' && newCuSRApproval.Type_of_Approver__c == 'System Owner')){
                    cusrForm.FAB_1__c = false;
                    cusrForm.Additional_FAB_1__c = false;
                    cusrForm.Dresden_Ready_For_Approval__c = false;
                }
                if(newCuSRApproval.Fab__c == 'FAB 2' || (newCuSRApproval.Site__c == 'Singapore' && newCuSRApproval.Type_of_Approver__c == 'System Owner') || newCuSRApproval.Type_of_Approver__c == 'FAB Owner'){
                    cusrForm.FAB_2__c = false;
                    cusrForm.Additional_FAB_2__c = false;
                    cusrForm.Singapore_Ready_For_Approval__c = false;
                }
                if(newCuSRApproval.Fab__c == 'FAB 3' || (newCuSRApproval.Site__c == 'Singapore' && newCuSRApproval.Type_of_Approver__c == 'System Owner') || newCuSRApproval.Type_of_Approver__c == 'FAB Owner'){
                    cusrForm.FAB_3__c = false;
                    cusrForm.Additional_FAB_3__c = false;
                    cusrForm.Singapore_Ready_For_Approval__c = false;
                }
                if(newCuSRApproval.Fab__c == 'FAB 3E' || (newCuSRApproval.Site__c == 'Singapore' && newCuSRApproval.Type_of_Approver__c == 'System Owner') || newCuSRApproval.Type_of_Approver__c == 'FAB Owner'){
                    cusrForm.FAB_3E__c = false;
                    cusrForm.Additional_FAB_3E__c = false;
                    cusrForm.Singapore_Ready_For_Approval__c = false;
                }
                if(newCuSRApproval.Fab__c == 'FAB 5' || (newCuSRApproval.Site__c == 'Singapore' && newCuSRApproval.Type_of_Approver__c == 'System Owner') || newCuSRApproval.Type_of_Approver__c == 'FAB Owner'){
                    cusrForm.FAB_5__c = false;
                    cusrForm.Additional_FAB_5__c = false;
                    cusrForm.Singapore_Ready_For_Approval__c = false;
                }
                if(newCuSRApproval.Fab__c == 'FAB 6' || (newCuSRApproval.Site__c == 'Singapore' && newCuSRApproval.Type_of_Approver__c == 'System Owner') || newCuSRApproval.Type_of_Approver__c == 'FAB Owner'){
                    cusrForm.FAB_6__c = false;
                    cusrForm.Additional_FAB_6__c = false;
                    cusrForm.Singapore_Ready_For_Approval__c = false;
                }
                if(newCuSRApproval.Fab__c == 'FAB 7' || (newCuSRApproval.Site__c == 'Singapore' && newCuSRApproval.Type_of_Approver__c == 'System Owner') || newCuSRApproval.Type_of_Approver__c == 'FAB Owner'){
                    cusrForm.FAB_7__c = false;
                    cusrForm.Additional_FAB_7__c = false;
                    cusrForm.Singapore_Ready_For_Approval__c = false;
                }
                if(newCuSRApproval.Fab__c == 'FAB 8' || (newCuSRApproval.Site__c == 'Malta' && newCuSRApproval.Type_of_Approver__c == 'System Owner')){
                    cusrForm.FAB_8__c = false;
                    cusrForm.Additional_FAB_8__c = false;
                    cusrForm.Malta_Ready_For_Approval__c = false;
                }
                if(newCuSRApproval.Fab__c == 'FAB 9' || (newCuSRApproval.Site__c == 'Essex Junction' && newCuSRApproval.Type_of_Approver__c == 'System Owner')){
                    cusrForm.FAB_9__c = false;
                    cusrForm.Additional_FAB_9__c = false;
                    cusrForm.Essex_Junction_Ready_for_Approval__c = false;
                }
                if(newCuSRApproval.Fab__c == 'FAB 10' || (newCuSRApproval.Site__c == 'East Fishkill' && newCuSRApproval.Type_of_Approver__c == 'System Owner')){
                    cusrForm.FAB_10__c = false;
                    cusrForm.Additional_FAB_10__c = false;
                    cusrForm.East_Fishkill_Ready_for_Approval__c = false;
                }
                if(newCuSRApproval.Fab__c == 'ASIC' || (newCuSRApproval.Site__c == 'ASIC' && newCuSRApproval.Type_of_Approver__c == 'System Owner')){
                    cusrForm.ASIC__c = false;
                    cusrForm.Additional_ASIC__c = false;
                    cusrForm.ASIC_Ready_for_Approval__c = false;
                }
                //update cusrForm;
            }
            update cusrForm;
        }
        
        if(pendingAMApproval){
            cusrForm.Status__c  = 'Pending AM Review';
            cusrForm.Fifth_Day_Reminder__c = false;
            cusrForm.Ninth_Day_Reminder__c = false;
            update cusrForm;
        }
        
        if(AMApproved){
            cusrForm.AM_Approved__c = true;
            List<CuSR_Implementation__c> cusrImplementationList = [select Id, Fab__c, Status__c from CuSR_Implementation__c where CuSR_Form__c =: cusrForm.Id];
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
            if(!cusrImplementationList.isEmpty()){
                for(CuSR_Implementation__c implementation: cusrImplementationList){
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
                            List<CuSR_Implementation__c> essexJunctionSucessList = new List<CuSR_Implementation__c>();
                            if(!essexjunctionimplementationList.isEmpty()){
                                for(CuSR_Implementation__c essexjunction: essexjunctionimplementationList){
                                    if(essexjunction.Status__c != 'Pending'){
                                        essexJunctionSucessList.add(essexjunction);
                                    }
                                }
                                if(essexJunctionSucessList.size() == essexjunctionimplementationList.size()){
                                    for(CuSR_Implementation__c essexjunction: essexJunctionSucessList){
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
                            List<CuSR_Implementation__c> eastFishkillSucessList = new List<CuSR_Implementation__c>();
                            if(!eastfishkillimplementationList.isEmpty()){
                                for(CuSR_Implementation__c eastfishkill: eastfishkillimplementationList){
                                    if(eastfishkill.Status__c != 'Pending'){
                                        eastFishkillSucessList.add(eastfishkill);
                                    }
                                }
                                if(eastFishkillSucessList.size() == eastfishkillimplementationList.size()){
                                    for(CuSR_Implementation__c eastfishkill: eastFishkillSucessList){
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
            }
            else{
                dresdencount++;
                singaporecount++;
                maltacount++;
                essexjunctioncount++;
                eastfishkillcount++;
                asiccount++;
            }
            if(dresdencount == 0 && singaporecount == 0 && maltacount == 0 && essexjunctioncount == 0 && eastfishkillcount == 0 && asiccount == 0){
                cusrForm.Status__c = 'Implemented';
            }
            else{
                cusrForm.Status__c  = 'Pending Implementation'; 
                cusrForm.Fifth_Day_Reminder__c = false;
                cusrForm.Ninth_Day_Reminder__c = false;
            }
            update cusrForm;
        }
        
        if(approved){
            integer successCount = 0;
            system.debug('Size of approval: '+cusrApprovalList.size());
            if(cusrApprovalList.size() > 0){
               for(CuSR_Approval_Process__c cusrApproval: cusrApprovalList){
                   if(cusrApproval.Status__c != 'Approved' && !(cusrApproval.Approved__c)){
                       successCount++;
                   }
               } 
               if(successCount == 0){
                   cusrForm.Stakeholder_Approval_Completed__c = true;
                   update cusrForm;
               }
            }
        }
        
        if(rejected){
            system.debug('No of Approvals to reject: '+cusrApprovalList.size());
            if(cusrApprovalList.size()>0){
                List<CuSR_Approval_Process__c> updateCuSRApprovalProcess = new List<CuSR_Approval_Process__c>();
                for(CuSR_Approval_Process__c cusrApproval: cusrApprovalList){
                    if(cusrApproval.Status__c == 'Approved' && cusrApproval.Approved__c){
                        //cusrApproval.Status__c = 'New';
                        cusrApproval.Approved__c = false;
                        //update cusrApproval;
                        updateCuSRApprovalProcess.add(cusrApproval);
                    }
                    else if(cusrApproval.Status__c == 'Pending Approval'){
                        Approval.ProcessWorkItemRequest req = new Approval.ProcessWorkItemRequest();
                        req.setComments('Recalled as another approval request is rejected.');
                        req.setAction('Removed');
                        Id workItemId = getWorkItemId(cusrApproval.Id);
                        req.setWorkitemId(workItemId);
                        Approval.ProcessResult result =  Approval.process(req);
                    }
                }
                if(updateCuSRApprovalProcess.size() > 0){
                    update updateCuSRApprovalProcess;
                }
                cusrForm.Status__c = 'Rejected';
                cusrForm.Dresden_Ready_for_Approval__c = false;
                cusrForm.Malta_Ready_for_Approval__c = false;
                cusrForm.Essex_Junction_Ready_for_Approval__c = false;
                cusrForm.East_Fishkill_Ready_for_Approval__c = false;
                cusrForm.ASIC_Ready_for_Approval__c = false;
                cusrForm.Singapore_Ready_for_Approval__c = false;
                cusrForm.Fifth_Day_Reminder__c = false;
                cusrForm.Ninth_Day_Reminder__c = false;
                update cusrForm;
            }
        }
    }
    
    public Id getWorkItemId(Id targetObjectId){
        Id retVal = null;
        for(ProcessInstanceWorkitem workItem: [select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: targetObjectId]){
            retVal = workItem.Id;
        }
        return retVal;
    }
    
    public void sendReminder(List<CuSR_Approval_Process__c> newCuSRApprovalList){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        boolean checkApproval = false;
        cusrForm = new CuSR_Form__c();
        cusrForm = [select Id, Name, Status__c from CuSR_Form__c where Id =: newCuSRApprovalList[0].CuSR_Form__c];
        List<User> ceList = new List<User>();
        /*for(CuSR_Approval_Process__c newCuSRApproval: newCuSRApprovalList){
            if(newCuSRApproval.Status__c == 'Pending Approval' && (newCuSRApproval.Remind_On_3rd_Day__c || newCuSRApproval.Remind_On_7th_Day__c)){
                checkApproval = true;
            }
        }*/
        //if(checkApproval){
            ProcessInstance processInst = new ProcessInstance();
            processInst = [SELECT Id, Status, TargetObjectId FROM ProcessInstance WHERE TargetObjectId IN : newCuSRApprovalList AND Status =: 'Pending'];
            if(processInst.Id != null){
                List<ProcessInstanceWorkitem> processWorkItemList = new List<ProcessInstanceWorkitem>();
                processWorkItemList = [select Id, ActorId, ProcessInstanceId from ProcessInstanceWorkitem where ProcessInstanceId =: processInst.Id];
                if(!processWorkItemList.isEmpty()){
                    List<Id> approverList = new List<Id>();
                    for(ProcessInstanceWorkitem workItem: processWorkItemList){
                        approverList.add(workItem.ActorId);
                    }
                    List<User> approverUserList = new List<User>();
                    approverUserList = [select Id, Name, Email from User where Id IN: approverList];
                    for(User approverUser: approverUserList){
                        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                        singleMail.setTargetObjectId(approverUser.Id);
                        List<String> ccList = new List<String>();
                        ceList = getCEUsersFromAccount(cusrForm);
                        if(!ceList.isEmpty()){
                            for(User u: ceList){
                                ccList.add(u.Email);
                            }
                            singleMail.setCcAddresses(ccList);
                        }
                        singleMail.saveAsActivity = false;
                        singleMail.setSubject('Customer Specific Request '+cusrForm.Name+' is '+cusrForm.Status__c);
                        String body = 'Dear User,'; 
                        body += '<br/>';
                        body += '<br/>';
                        body += 'Customer Specific Request '+cusrForm.Name+'is '+cusrForm.Status__c+'.';
                        body += '<br/>';
                        body += '<br/>';
                        body += 'Please click the below link to access the record.';
                        body += '<br/>';
                        body += '<br/>';
                        String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id;
                        body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+hyperLink+'</a>';
                        //body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+cusrForm.Name+'</a>';
                        body += '<br/>';
                        body += '<br/>';
                        body += 'Thank you,';
                        body += '<br/>';
                        body += 'For futher clarification/queries, please contact the Initiator of the CuSR.';
                        body += '<br/>';
                        body += 'This is a system generated auto email. Please do not reply.';
                        singleMail.setHtmlBody(body);
                        mails.add(singleMail);
                    }
                    if(mails.size() > 0){
                        Messaging.sendEmail(mails);
                    }
                }
            }   
        //}
    }
    
    public List<User> getCCUsersForRejectionMethod(CuSR_Approval_Process__c approver){
        List<Id> ccUsersForRejectionIds = new List<Id>();
        CuSR_Form__c form = new CuSR_Form__c();
        form = [select Id from CuSR_Form__c where Id =: approver.CuSR_Form__c];
        List<CuSR_Approval_Process__c> approvalList = new List<CuSR_Approval_Process__c>();
        UtilClassToGetAllFields util = new UtilClassToGetAllFields();
        String queryFields = util.getAllFields('CuSR_Approval_Process__c');
        String query = 'select '+queryFields+' from CuSR_Approval_Process__c where CuSR_Form__c =\''+form.Id+'\' and Type_of_Approver__c IN (\'System Owner\',\'FAB Owner\',\'FAB 1 Owner\',\'FAB 2 Owner\',\'FAB 3 Owner\',\'FAB 3e Owner\',\'FAB 5 Owner\',\'FAB 6 Owner\',\'FAB 7 Owner\',\'FAB 8 Owner\')';
        approvalList = Database.query(query);
        for(CuSR_Approval_Process__c approval: approvalList){
            if(approval.Approver1__c != null){
                ccUsersForRejectionIds.add(approval.Approver1__c);
            }
            if(approval.Approver2__c != null){
                ccUsersForRejectionIds.add(approval.Approver2__c);
            }
            if(approval.Approver3__c != null){
                ccUsersForRejectionIds.add(approval.Approver3__c);
            }
            if(approval.Approver4__c != null){
                ccUsersForRejectionIds.add(approval.Approver4__c);
            }
            if(approval.Approver5__c != null){
                ccUsersForRejectionIds.add(approval.Approver5__c);
            }
        }
        return [select Id, Email from User where Id IN: ccUsersForRejectionIds];
    }
    
    public void sendEmailToAMForApproval(List<CuSR_Approval_Process__c> oldCuSRApprovalList, List<CuSR_Approval_Process__c> newCuSRApprovalList){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Set<Id> amUserIds = new Set<Id>();
        List<User> amUserList = new List<User>();
        //boolean isAMApproval = false;
        for(CuSR_Approval_Process__c newCuSRApproval: newCuSRApprovalList){
            //isAMApproval = true;
            //if(newCuSRApproval.Type_of_Approver__c == 'AM'){
                //isAMApproval = true;
                if(newCuSRApproval.Approver1__c != null){
                    amUserIds.add(newCuSRApproval.Approver1__c);
                }
                if(newCuSRApproval.Approver2__c != null){
                    amUserIds.add(newCuSRApproval.Approver2__c);
                }
                if(newCuSRApproval.Approver3__c != null){
                    amUserIds.add(newCuSRApproval.Approver3__c);
                }
                if(newCuSRApproval.Approver4__c != null){
                    amUserIds.add(newCuSRApproval.Approver4__c);
                }
                if(newCuSRApproval.Approver5__c != null){
                    amUserIds.add(newCuSRApproval.Approver5__c);
                }   
            //}
        }
        //if(isAMApproval){
            String cusrApprovalId;
            for(CuSR_Approval_Process__c newCuSRApproval: newCuSRApprovalList){
                cusrApprovalId = newCuSRApproval.CuSR_Form__c;
            }
            cusrForm = new CuSR_Form__c();
            //cusrForm = [select Id, Status__c, Name, Customer_Name__c, OwnerId from CuSR_Form__c where Id =:newCuSRApprovalList[0].CuSR_Form__c];
            cusrForm = [select Id, Status__c, Name, Customer_Name__c, OwnerId from CuSR_Form__c where Id =: cusrApprovalId];
            Account acc = [select Id, Name from Account where Id =: cusrForm.Customer_Name__c];
            User initiator = [select Id, Email from User where Id =: cusrForm.OwnerId];
            List<User> ceList = getCEUsersFromAccount(cusrForm);
            if(!amUserIds.isEmpty()){
                amUserList = [select Id, Email from User where Id IN: amUserIds];
            }
            for(CuSR_Approval_Process__c oldCuSRApproval: oldCuSRApprovalList){
                for(CuSR_Approval_Process__c newCuSRApproval: newCuSRApprovalList){
                    if(oldCuSRApproval.Status__c == 'New' && newCuSRApproval.Status__c == 'Pending Approval' && newCuSRApproval.Type_of_Approver__c == 'AM'){
                        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                        List<String> toList = new List<String>();
                        if(!amUserList.isEmpty()){
                            for(User amUser: amUserList){
                                toList.add(amUser.Email);
                            }   
                            singleMail.setToAddresses(toList);
                        }
                        List<String> ccList = new List<String>();
                        ccList.add(initiator.Email);
                        if(!ceList.isEmpty()){
                            for(User ce: ceList){
                                ccList.add(ce.Email);
                            }
                        }
                        singleMail.setCcAddresses(ccList);
                        singleMail.saveAsActivity = false;
                        singleMail.setSubject('Customer Specific Request '+cusrForm.Name+' for '+acc.Name+' is '+cusrForm.Status__c);
                        String body = 'Dear Account Managers,';
                        body += '<br/>';
                        body += '<br/>';
                        body += 'Customer Specific Request '+cusrForm.Name+' for '+acc.Name+' is '+cusrForm.Status__c+'.';
                        body += '<br/>';
                        body += '<br/>';
                        body += 'You can access the CuSR using the following link: ';
                        body += '<br/>';
                        body += '<br/>';
                        String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id;
                        body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+hyperLink+'</a>';
                        //body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+cusrForm.Id+'">'+cusrForm.Name+'</a>';
                        body += '<br/>';
                        body += '<br/>';
                        body += 'Thank You.';
                        body += '<br/>';
                        body += '<br/>';
                        body += 'For further clarification / queries, please contact the Initiator of the CUSR.';
                        body += '<br/>';
                        body += 'This is a system generated auto email. Please do not reply';
                        singleMail.setHtmlBody(body);
                        mails.add(singleMail);
                    }
                }
            }
            if(!mails.isEmpty()){
                Messaging.sendEmail(mails);
            }
        //}
    }
    
    public List<User> getCEUsersFromAccount(CuSR_Form__c tempCusrForm){
        Set<Id> ceUserIds = new Set<Id>();
        UtilClassToGetAllFields util = new UtilClassToGetAllFields();
        String queryFields = util.getAllFields('CuSR_Form__c');
        String query = 'select '+queryFields+' from CuSR_Form__c where Id = \''+tempCusrForm.Id+'\'';
        CuSR_Form__c cusrForm = database.query(query);
        List<Account_Team_Proxy__c> tempProxyList = [select Id, User__c, Team_Role__c, Account__c, Fab_Assignment__c, User__r.isActive from Account_Team_Proxy__c where Account__c =:cusrForm.Customer_Name__c and Team_Role__c = 'Customer Engineer' and User__r.isActive = true];
        if(!tempProxyList.isEmpty()){
            for(Account_Team_Proxy__c teamProxy: tempProxyList){
                if(teamProxy.Fab_Assignment__c.contains('FAB 1') && cusrForm.FAB_1__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
                if(teamProxy.Fab_Assignment__c.contains('FAB 2') && cusrForm.FAB_2__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
                if(teamProxy.Fab_Assignment__c.contains('FAB 3') && cusrForm.FAB_3__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
                if(teamProxy.Fab_Assignment__c.contains('E') && cusrForm.FAB_3E__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
                if(teamProxy.Fab_Assignment__c.contains('FAB 5') && cusrForm.FAB_5__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
                if(teamProxy.Fab_Assignment__c.contains('FAB 6') && cusrForm.FAB_6__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
                if(teamProxy.Fab_Assignment__c.contains('FAB 7') && cusrForm.FAB_7__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
                if(teamProxy.Fab_Assignment__c.contains('FAB 8') && cusrForm.FAB_8__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
                if(teamProxy.Fab_Assignment__c.contains('FAB 9') && cusrForm.FAB_9__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
                if(teamProxy.Fab_Assignment__c.contains('FAB 10') && cusrForm.FAB_10__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
                if(teamProxy.Fab_Assignment__c.contains('ASIC') && cusrForm.ASIC__c == true){
                    ceUserIds.add(teamProxy.User__c);
                }
            }
        }
        return [select Id, Email from User where Id IN: ceUserIds];
    }
    
    //method to add additionally added FAB to Scope__c field when the FAB is approved
    public void setFabOnScopeFieldOnApproval(List<CuSR_Approval_Process__c> newCuSRApprovalList){
        cusrForm = [select Id, Status__c from CuSR_Form__c where Id =: newCuSRApprovalList[0].CuSR_Form__c];
        String site = newCuSRApprovalList[0].Site__c;
        integer count = 0;
        if(cusrForm.Status__c == 'Implemented'){
            List<CuSR_Approval_Process__c> approvalList = [select Id, Status__c, Site__c, Type_of_Approver__c, Approved__c from CuSR_Approval_Process__c where Site__c =: site and CuSR_Form__c =: cusrForm.Id];
            if(!approvalList.isEmpty()){
                for(CuSR_Approval_Process__c approval: approvalList){
                    if(approval.Status__c != 'Approved' && !(approval.Approved__c)){
                        count ++;
                    }
                }
            }
            if(count == 0){
                cusrForm.Scope__c = saveSelectedScope(cusrForm);
                update cusrForm;
            }
        }
    }
    
    //method to save selected Scope to Scope__c field
    public String saveSelectedScope(CuSR_Form__c cusr){
        UtilClassToGetAllFields util = new UtilClassToGetAllFields();
        String queryFields = util.getAllFields('CuSR_Form__c');
        String query = 'select '+queryFields+' from CuSR_Form__c where Id = \''+cusr.Id+'\'';
        CuSR_Form__c cusrForm = database.query(query);
        String selectedScope = '';
        if(cusrForm.FAB_1__c && !(cusrForm.FAB_1_Void__c))
            selectedScope += '; FAB 1';
        if(cusrForm.FAB_2__c && !(cusrForm.FAB_2_Void__c))
            selectedScope += '; FAB 2';
        if(cusrForm.FAB_3__c && !(cusrForm.FAB_3_Void__c))
            selectedScope += '; FAB 3';
        if(cusrForm.FAB_3E__c && !(cusrForm.FAB_3E_Void__c))
            selectedScope += '; FAB 3E';
        if(cusrForm.FAB_5__c && !(cusrForm.FAB_5_Void__c))
            selectedScope += '; FAB 5';
        if(cusrForm.FAB_6__c && !(cusrForm.FAB_6_Void__c))
            selectedScope += '; FAB 6';
        if(cusrForm.FAB_7__c && !(cusrForm.FAB_7_Void__c))
            selectedScope += '; FAB 7';
        if(cusrForm.FAB_8__c && !(cusrForm.FAB_8_Void__c))
            selectedScope += '; FAB 8';
        if(cusrForm.FAB_9__c && !(cusrForm.FAB_9_Void__c))
            selectedScope += '; FAB 9';
        if(cusrForm.FAB_10__c && !(cusrForm.FAB_10_Void__c))
            selectedScope += '; FAB 10';
        if(cusrForm.ASIC__c && !(cusrForm.ASIC_Void__c))
            selectedScope += '; ASIC';
        if(selectedScope != ''){
            selectedScope = selectedScope.subString(2);
            system.debug('Scope string is '+selectedScope);
            //cusrForm.Scope__c = selectedScope;
        }  
        return selectedScope;      
    }
    
    //Added By Abhita
    public void provideAccessApproval(List<CuSR_Approval_Process__c> newCuSRAccessApprovalList){
        List<CuSR_Form__Share> formShares = new List<CuSR_Form__Share>();
    
        for(CuSR_Approval_Process__c cusrRecord: newCuSRAccessApprovalList){
            CuSR_Form__Share approvalShare = new CuSR_Form__Share ();
            if(cusrRecord.Approver1__c != null){
                approvalShare.UserOrGroupId = cusrRecord.Approver1__c;
            }
            if(cusrRecord.Approver2__c != null){
                approvalShare.UserOrGroupId = cusrRecord.Approver2__c;
            }
            if(cusrRecord.Approver3__c != null){
                approvalShare.UserOrGroupId = cusrRecord.Approver3__c;
            }
            if(cusrRecord.Approver4__c != null){
                approvalShare.UserOrGroupId = cusrRecord.Approver4__c;
            }
            if(cusrRecord.Approver5__c != null){
                approvalShare.UserOrGroupId = cusrRecord.Approver5__c;
            }
            approvalShare.ParentId = cusrRecord.Id;
            approvalShare.AccessLevel = 'EDIT';
            approvalShare.RowCause = Schema.CuSR_Form__Share.RowCause.Sharing_Access__c;
            formShares.add(approvalShare);        
       }
       Database.SaveResult[] formSharesInsertResult = Database.insert(formShares ,false);
    }
}