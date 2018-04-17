/*Author: Karthick D
* Description: This trigger runs on Batch object to set the default owner, 
               Default bug team, Validate user on bug delete, send mails on bug Update.
* History: Created on 03/26/2014
           Modified on 08/22/2014 to add skip logic and bulkify the email send functionality.

        Last Modified By    : Kali
        Last MOdified Date  : 22 - Sep - 2016
        Description         : Updated the method names to use the SubType_A, SubType_B, SubType_C and SubType_D instead of 
                              Using the existed Product component and Sub Component.
*/
trigger BugTrigger on Bug__c(before insert, after insert, before update, after update) {
    BugTriggerHandler bugtriggerhandlerVar = new BugTriggerHandler();
    ASICBugTriggerHandler asicBugtriggerhandlerVar = new ASICBugTriggerHandler();
    IPDEVBugTriggerHandler ipdevBughandlerVar  = new IPDEVBugTriggerHandler();
    if (!IntegrationUserUtil.isSkipTrigger()) {
        list < bug__c > bugNew = new list < bug__c > ();
        Map < id, bug__c > bugMapNew = new Map < id, bug__c > ();
        list < bug__c > bugOld = new list < bug__c > ();
        Map < id, bug__c > bugMapOld = new Map < id, bug__c > ();
        
        List<Bug__c> asicBugNew =   new List<Bug__c>();
        List<Bug__c> asicBugOld =   new List<Bug__c>();
        Map <id, Bug__c> asicbugMapNew = new Map <id, bug__c> ();
        Map <id, Bug__c> asicbugMapOld = new Map <id, bug__c> ();

        List<Bug__c> ipdevBugNew =   new List<Bug__c>();
        List<Bug__c> ipdevBugOld =   new List<Bug__c>();
        Map <id, Bug__c> ipdevbugMapNew = new Map <id, bug__c> ();
        Map <id, Bug__c> ipdevbugMapOld = new Map <id, bug__c> ();
        
        if (trigger.isinsert) {       
            for (bug__c b: trigger.new) {
                if (b.isbug__c) {
                    bugNew.add(b);
                    bugMapNew.put(b.id, b);
                }
                if (b.IsASICBug__c) {
                    asicBugNew.add(b);
                    asicbugMapNew.put(b.id, b);
                }

                if (b.IsIPDEV__c) {
                    ipdevBugNew.add(b);
                    ipdevbugMapNew.put(b.id, b);
                }
            }
            if (bugNew.size() > 0 || asicBugNew.size() > 0 || ipdevBugNew.size() > 0) {
                bugtriggerhandlervar.buglistNew = bugNew;
                bugtriggerhandlerVar.bugmapNew = bugMapNew;
                if(bugNew.size() > 0) {
                    bugtriggerhandlerVar.mapCreation();
                }
                
                /*******************************/
                // Added by Kali for new functionality
                asicBugtriggerhandlerVar.buglistNew = asicBugNew;
                asicBugtriggerhandlerVar.bugmapNew = asicbugMapNew;
                if(asicBugNew.size()>0) {
                    asicBugtriggerhandlerVar.mapCreation();
                }
                /*******************************/

                ipdevBughandlerVar.buglistNew = ipdevBugNew;
                ipdevBughandlerVar.bugmapNew = ipdevbugMapNew;
                if(ipdevBugNew.size()>0) {
                    ipdevBughandlerVar.mapCreation();
                }
                
                if (trigger.isbefore) {
                    if(bugNew.size()>0){
                        //bugtriggerhandlervar.validateFixedInPlannedInVersion();
                        bugtriggerhandlerVar.SetDefaultOwner();    
                    } if(asicBugNew.size()>0){
                        asicBugtriggerhandlerVar.SetDefaultOwner();
                    } 
                    if(ipdevBugNew.size()>0){
                        ipdevBughandlerVar.SetDefaultOwner();
                    }
                }
                if (trigger.isafter) {
                    if(bugNew.size()>0){
                        bugtriggerhandlerVar.SetDefaultBugTeam();
                        bugtriggerhandlerVar.setDefaultAddBugTeam(); //Modified by Manikumar against Case #00049649
                        bugtriggerhandlerVar.BugOrginfromcaseandbug();
                    }
                    /*Code added By Kali for new funcitonality*/
                    if(asicBugNew.size()>0){
                        asicBugtriggerhandlerVar.SetDefaultBugTeam();
                        asicBugtriggerhandlerVar.PostBugDescription();
                        asicBugtriggerhandlerVar.BugOrginfromcaseandbug();
                        ASICBugEmailTemplateHandler.sendEmailOnBugCreation(asicBugNew,false); 
                    }
                    /*Code ended*/

                    if(ipdevBugNew.size()>0){
                        ipdevBughandlerVar.SetDefaultBugTeam(); 
						ipdevBughandlerVar.PostBugDescription(); 
                    }
                }
            }
        }
        if (trigger.isupdate) {        
            for (bug__c b: trigger.New) {
                if (b.isbug__c) {
                    bugNew.add(b);
                    bugMapNew.put(b.id, b);
                    bugOld.add(trigger.oldMap.get(b.id));
                    bugMapOld.put(b.id, trigger.oldMap.get(b.id));
                }
                if (b.IsASICBug__c) {
                    asicbugNew.add(b);
                    asicbugMapNew.put(b.id, b);
                    asicbugOld.add(trigger.oldMap.get(b.id));
                    asicbugMapOld.put(b.id, trigger.oldMap.get(b.id));
                }

                if (b.IsIPDEV__c) {
                    ipdevbugNew.add(b);
                    ipdevbugMapNew.put(b.id, b);
                    ipdevbugOld.add(trigger.oldMap.get(b.id));
                    ipdevbugMapOld.put(b.id, trigger.oldMap.get(b.id));
                }
            }
            
            if (bugNew.size() > 0 || asicBugNew.size() > 0 || ipdevBugNew.size() > 0) {
                bugtriggerhandlerVar.buglistNew = bugNew;
                bugtriggerhandlerVar.bugmapNew = bugMapNew;
                bugtriggerhandlerVar.bugmapOld = bugMapOld;
                bugtriggerhandlerVar.buglistOld = bugOld;
                
                asicBugtriggerhandlerVar.buglistNew = asicbugNew;
                asicBugtriggerhandlerVar.bugmapNew = asicbugMapNew;
                asicBugtriggerhandlerVar.bugmapOld = asicbugMapOld;
                asicBugtriggerhandlerVar.buglistOld = asicbugOld;

                ipdevBughandlerVar.buglistNew = ipdevbugNew;
                ipdevBughandlerVar.bugmapNew = ipdevbugMapNew;
                ipdevBughandlerVar.bugmapOld = ipdevbugMapOld;
                ipdevBughandlerVar.buglistOld = ipdevbugOld;
                
                
                if (trigger.isbefore) {
                    if(bugNew.size() > 0){
                        bugtriggerhandlervar.setOldProductandComponent();
                        bugtriggerhandlerVar.ValidateBugUpdateforHoldStatus();
                        bugtriggerhandlervar.updateBugStatusDate();
                        //bugtriggerhandlervar.validateFixedInPlannedInVersion();                     
                    }
                    
                    if(asicbugNew.size() > 0){
                    // By Kali                     
                        asicBugtriggerhandlerVar.setOldProductandComponentBasedonSubTypes();
                        asicBugtriggerhandlerVar.updateBugStatusDate();
                        asicBugtriggerhandlerVar.setAsicbugApprovalProcess();
                    }
                    // Ended by kali

                    if(ipdevbugNew.size() > 0) {
                        ipdevBughandlerVar.setOldProductandComponent();
                        ipdevBughandlerVar.updateBugStatusDate();
                    }
                    
                } else if (trigger.isafter) {
                    if(bugNew.size() > 0){
                        if (BugTriggerHandler.runOnce()){
                            bugtriggerhandlervar.feedTrackingforFieldUpdate();                       
                            bugtriggerhandlervar.emailNotificationforBugUpdate();
                            bugtriggerhandlervar.updateBugTeamOnOwnerChange();
                        }
                    }
                    if(asicbugNew.size() > 0){                    
                        //asicBugtriggerhandlerVar.emailNotificationforBugUpdate();
                        asicBugtriggerhandlerVar.updateBugTeamOnOwnerChange();
                        asicBugtriggerhandlerVar.updateBugTeamOnCstProjectChange();
                        ASICBugEmailTemplateHandler.sendEmailToAssignedToOwner(asicbugNew,asicbugMapOld);                                                 
                        ASICBugEmailTemplateHandler.sendEmailOnEveryFieldChange(asicbugMapNew,asicbugOld);
                        ASICBugEmailTemplateHandler.sendEmailOnDevComplete(asicbugNew,asicbugMapOld);
                    }

                    if(ipdevbugNew.size() > 0){                    
                        ipdevBughandlerVar.updateBugTeamOnOwnerChange();
                        ipdevBughandlerVar.feedTrackingforFieldUpdate();
                        
                            
                    }
                }
            }
        }
    }
}