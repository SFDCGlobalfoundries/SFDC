/*
* @ Author          :- Navneet Rajput
* @ Organization    :- Cognizant Technology solutions
* @ Project         :- Foundry View 2.0
* @ Description     :- handler class of Design_Spec__c object and it handles all after operation on SpecificationAfterTrigger
                       class has solution for Case #00027678 (send email notifications to owners of pdk and pdk batch bundles once 
                       specification has been updated from General Release status to any other specification status.)
* @ Date            :- 17th June 2014
* @ Change History  :- 
**/

public with sharing class FV_SpecificationAfterOperationHandler {

    private boolean isExecuting;
    public static Boolean isExecuted = false;
    // constructor set runnig context
    public FV_SpecificationAfterOperationHandler(boolean isExecuting){
        this.isExecuting = isExecuting;
    }

    // Method Handle all after update operations
    public void OnAfterUpdate(List<Design_Spec__c> listOfNewRecords, List<Design_Spec__c> listOfOldRecords,
                              Map<Id,Design_Spec__c> mapOfNewRecords,Map<Id,Design_Spec__c> mapOfOldRecords){

        system.debug('OnAfterUpdate Number of Times called !!!!! '+listOfNewRecords);
        system.debug('isExecuted >>>> '+isExecuted);
        if(!isExecuted){
            isExecuted=true;// Avoid multiple time calling of same trigger in same context
            if ((listOfNewRecords!=null && !listOfNewRecords.isEmpty()) && (mapOfOldRecords<>Null && !mapOfOldRecords.isEmpty())){
                // Following method help to notify pdk bundle owners
                FV_SpecificationAfterOperationHandler.validateSpecReleaseStatusForPDK(listOfNewRecords,mapOfOldRecords);
            }
        }
    }

    // Verify if specification status is getting changes from General Release to other status.
    private static void validateSpecReleaseStatusForPDK(List<Design_Spec__c> listOfNewRecords,Map<Id,Design_Spec__c> mapOfOldRecords){
        system.debug('Inside validateSpecReleaseStatusForPDK >>>>>>>>>>>>>>>'+listOfNewRecords);
        Set<ID> setOfSpecs = new Set<Id>();
        Map<ID,List<Sub_PDK_Spec__c>> mapOfPdks = new Map<ID,List<Sub_PDK_Spec__c>>();
        //iterate through all specifications and select only those who meets the criteria
        for (Design_Spec__c spec :listOfNewRecords){
            /*if (mapOfOldRecords.get(spec.Id).Release_Status__c.toUpperCase()=='General Release'.toUpperCase() &&
                spec.Release_Status__c.toUpperCase()!='General Release'.toUpperCase()){
                    //prepare set of specification Ids
                    setOfSpecs.add(spec.Id);
            }*/
            if (mapOfOldRecords.get(spec.Id)!=null && mapOfOldRecords.get(spec.Id).Release_Status__c!=null &&
                mapOfOldRecords.get(spec.Id).Release_Status__c!=''&&
                spec.Release_Status__c!=null && spec.Release_Status__c!=''){
                    
                    if (mapOfOldRecords.get(spec.Id).Release_Status__c.toUpperCase()=='General Release'.toUpperCase() &&
                        spec.Release_Status__c.toUpperCase()!='General Release'.toUpperCase()){
                        //prepare set of specification Ids
                        setOfSpecs.add(spec.Id);
                    }   
            }
        }
        system.debug('setOfSpecs>>>>>>>>>>>>>>'+setOfSpecs);
        
        if (setOfSpecs!=null && !setOfSpecs.isEmpty()){
            
            List<Sub_PDK_Spec__c> designSpec = [SELECT  Sub_PDK__c,
                                                        Sub_PDK__r.Name,
                                                        Sub_PDK__r.createdById,
                                                        Design_Spec__r.Name,
                                                        Design_Spec__r.Id,
                                                        Design_Spec__r.Release_Status__c,
                                                        Design_Spec__c
                                                FROM    Sub_PDK_Spec__c
                                                WHERE   Design_Spec__c IN : setOfSpecs];
    
            if (designSpec<>Null && !designSpec.isEmpty()){
                for(Sub_PDK_Spec__c spec : designSpec){
                    if(spec.Sub_PDK__c <> Null){
                        if(!mapOfPdks.containsKey(spec.Sub_PDK__c) ){
                            mapOfPdks.put(spec.Sub_PDK__c,new List<Sub_PDK_Spec__c>());
                        }
                        mapOfPdks.get(spec.Sub_PDK__c).add(spec);
                    }
                }
            }
        }                                    
        system.debug('mapOfPdks>>>>>>>>>>>>>>>>>>>>>>>>'+mapOfPdks);
        // Send mail to public group who are responsible for create/update of pdk and pdk bundle        
        if (mapOfPdks<>Null && !mapOfPdks.isEmpty()){
            
            List<Messaging.SingleEmailMessage>  emails = new List<Messaging.SingleEmailMessage>();
            Map<ID,User> mapOfUser = new Map<ID,User>([Select Id,Name,Email From User]);
            
            system.debug('mapOfPdks>>>>>>>>>>>>>>>>>>>>>>>>'+mapOfPdks);
            system.debug('mapOfUser>>>>>>>>>>>>>>>>>>'+mapOfUser);
            
            for (ID pdkId : mapOfPdks.keySet()){
                emails.add(FV_SpecificationAfterOperationHandler.sendEmailToPdkOwners(mapOfPdks.get(pdkId),
                                                                                      mapOfUser,mapOfOldRecords));
            }
            if (emails<>Null && !emails.isEmpty()){
                Messaging.sendEmail(emails);
            }
        }
    }    
    
    // method notify pdk owners about specification status change from general to any other release status.
    private static Messaging.SingleEmailMessage sendEmailToPdkOwners(List<Sub_PDK_Spec__c> designSpec,
                                                                     Map<ID,User> mapOfUser,Map<Id,Design_Spec__c> mapOfOldRecords){
        system.debug('Inside sendEmailToPdkOwners >>>>>>> '+designSpec);
        if (designSpec<>Null && !designSpec.isEmpty()){
            // prepare list of send to addresses from public group
            User userObj=null;
            String Email='';
            String bodyText='';
            String Subject = 'Release status of specs in '+designSpec[0].Sub_PDK__r.Name+' changed.\r\n';
            String pdkLink ='PDK Bundle : '+URL.getSalesforceBaseUrl().toExternalForm() +'/' + designSpec[0].Sub_PDK__c+'\r\n';
            String specNames = '';
            String finalBodyText = '';
            String signature='\r\n Thanks,\r\n GFV Admin';
            // In case user dont have any email address then we need to put some administative persons email id.
            List<String> toAddresses = new List<String>();
            if (mapOfUser<>Null){
                system.debug('designSpec[0].Sub_PDK__r.CreatedById>>>>>>>>>>>>>>>>>>>>>'+designSpec[0].Sub_PDK__r.CreatedById);
                userObj = mapOfUser.get(designSpec[0].Sub_PDK__r.CreatedById);
                system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>'+userObj);
                if(userObj<>Null){
                    bodyText='Dear '+userObj.Name+',\r\n'+'\r\n';
                    Email =userObj.Email!=NULL?userObj.Email:'navneet.rajput121@gmail.com';
                }
                bodyText+='FYI, the following Spec(s) from Pdk Bundle :- '+designSpec[0].Sub_PDK__r.Name+' has release status changed and all the previous provisioning are now being de-provisioned.\r\n'+'\r\n';
            }
            
            String orignalStatus;
            String newStatus;
            String finalString='';
            
            for (Sub_PDK_Spec__c spec : designSpec){
                specNames='';
                orignalStatus='';
                newStatus='';
                specNames+= 'Specification Name: '+spec.Design_Spec__r.Name + '\r\n';
                orignalStatus+= 'Original Status: '+ mapOfOldRecords.get(spec.Design_Spec__r.Id).Release_Status__c+'\r\n';
                newStatus+= 'New Status: ' + spec.Design_Spec__r.Release_Status__c + '\r\n'; 
                
                finalString+=specNames+orignalStatus+newStatus;
            }
            
            finalBodyText = bodyText+finalString+'\r\n'+pdkLink+'\r\n'+signature;
            system.debug('finalBodyText >>>>>>>>>>>> '+finalBodyText);
            try {
                // Messaging code
                Messaging.SingleEmailMessage mail = FV_SpecificationAfterOperationHandler.sendEmail(Email,Subject,finalBodyText);
                
                return mail;
                
            } catch (Exception e){
                System.debug('ERROR MESSAGE IS >>>>>>> '+e.getMessage());
                system.debug('Error at line number >>>> '+e.getLineNumber());
                system.debug('Error Cause >>>>>'+e.getCause());
                return null;
            }   
        }
        return null;
    }
    
    // Common methos for sending email to pdk as well as pdk patch owners
    private static Messaging.SingleEmailMessage sendEmail(String emailId,String subject, String emailBody){
        system.debug('Inside sendEmail >>>>>>>>>>>>>>>>>');
        List<String> toAddresses = new List<String>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        toAddresses.add(emailId);
        mail.setToAddresses(toAddresses);
        //mail.setSenderDisplayName('');
        mail.setSubject(subject);
        if(emailBody!=null && emailBody!=''){
            mail.setPlainTextBody(emailBody);
        }
        // Send the email you have created.
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        return mail;
    }
    
}