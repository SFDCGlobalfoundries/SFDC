global class MRSPatchJobviewersSchedulable implements Schedulable  {

    global void execute(SchedulableContext ctx) {
        Set<String> jvTypeSet     = new Set<String>{'Customer'};
        Set<String> ptrfStatusSet   = new Set<String>{'Open','Perform Tapeout Options'};
        
        patchJobviewers(jvTypeSet, ptrfStatusSet);
        //Schedule next run
        Datetime sysTime = System.now().addDays( 1 );
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();

        MRSPatchJobviewersSchedulable scheduler = new MRSPatchJobviewersSchedulable();
        System.schedule( 'PatchJobviewers ' + sysTime, chronExpression, scheduler );
    }
    
    /*
    * @description link the jobviewers with existing users, matching by email - username
    * @param Set<String> jvTypeSet: Jobviewer type - Customer/Foundry
    *        Set<String> ptrfStatusSet: Open/Perform Tapeout Options
    * @return 
    */
    public static void patchJobviewers(Set<String> jvTypeSet,Set<String> ptrfStatusSet){
        try{
            List<PTRF_JobViewer_Info__c> jvList = [SELECT Id,Email_Address__c, User__c FROM PTRF_JobViewer_Info__c 
                                                WHERE User__c=null AND Email_Address__c!=null
                                                AND Jobview__c IN :jvTypeSet
                                                AND PTRF__r.Status__c IN :ptrfStatusSet 
                                                AND (PTRF__r.Prime_Tapeout__c = true OR PTRF__r.Frame_Tapeout__c = true)
                                                limit 9999
                                              ];
            Set<String> existingEmailSet = new Set<String>();
            for(PTRF_JobViewer_Info__c jv : jvList){
                existingEmailSet.add(jv.Email_Address__c.toLowerCase());
            }
            
            Set<String> userNameSet = new Set<String>();
            //Get users with PTRF & My Device is true in Access Setup, matching Email with Username
            for(Portal_Tab_Access__c pta : [Select User__r.Username from Portal_Tab_Access__c where PTRF__c=true and My_Devices__c=true and User__r.Username in :existingEmailSet]){
                userNameSet.add(pta.User__r.Username);
            }
            
            Map<String,ID> userNameAndIdMap = new Map<String,ID>();
            for(User u : [select Id,UserName from User where UserName  in :userNameSet]){
                userNameAndIdMap.put(u.UserName, u.ID );
            }
            
            List<PTRF_JobViewer_Info__c> jvToUpdate = new List<PTRF_JobViewer_Info__c>();
            for(PTRF_JobViewer_Info__c jv : jvList){
                if(jv.User__c==null && jv.Email_Address__c!=null && userNameAndIdMap.containsKey(jv.Email_Address__c.toLowerCase())){
                    jv.User__c = userNameAndIdMap.get(jv.Email_Address__c.toLowerCase());
                    jvToUpdate.add(jv);
                }
            }
            update jvToUpdate;
            //Send email to Swift Admin
            notifySwiftAdmin(jvToUpdate);
            //delete completed job
            List<CronTrigger> jobs = [select cronexpression, state, cronjobdetail.name, cronjobdetail.jobtype from crontrigger where cronjobdetail.name like 'PatchJobviewers%' and state='DELETED'];
            for(CronTrigger job : jobs){
                System.abortJob(job.id);
            }
        }catch(Exception ex){   handleJobviewerPatchError(ex);  }
    }
    
    /*
    * @description notify Swift Admin of updated Jobviewers
    * @param List<PTRF_JobViewer_Info__c> jvToUpdate
    * @return 
    */
    public static void notifySwiftAdmin(List<PTRF_JobViewer_Info__c> jvToUpdate){
        List<PTRF_JobViewer_Info__c> jvList = [SELECT Id, Jobview__c, Jobview_Type__c, PTRF_Number__c, User__r.Name, Email_Address__c FROM PTRF_JobViewer_Info__c 
                                                WHERE ID IN :jvToUpdate
                                              ];
        if( !jvList.isEmpty() ){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] swiftAdmn ;
            swiftAdmn  =new String[]{};
            
            OrgWideEmailAddress orgWideAddr = [SELECT Id,DisplayName,Address FROM OrgWideEmailAddress WHERE DisplayName = 'GLOBALFOUNDRIES' LIMIT 1];
            
            if(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL')==null) return;
            
            if(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.contains(';')){
               swiftAdmn.addAll(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.split(';')); 
            }else{
              swiftAdmn.add(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c); 
            }
            
            if( swiftAdmn.isEmpty() )   return;
            
            mail.setToAddresses(swiftAdmn);
            
            mail.setSubject('Patched Jobviewers - ' + System.today().format());
            String body = '<br /><br />Dear Sir/Madam,  ';
              body += '<br /><br /> The following jobviewers have been patched :' ;
              body += '<br /><br /> ' ;
              body += '<table style="width:100%;border: 1px solid;">';
              
              body += '<tr style="font-weight:bold;">' + '<td> Jobview</td>' + '<td> Jobview type</td>' + '<td> PTRF Number</td>' + '<td> User</td>' + '<td> Email</td>' + '</tr>';
              
              for(PTRF_JobViewer_Info__c jv : jvList){
                    body += '<tr style="border-top: 1px solid;">' + '<td> ' + jv.Jobview__c + '</td>' + '<td> ' + jv.Jobview_Type__c + '</td>' + '<td>' + jv.PTRF_Number__c + '</td>' + '<td>' + jv.User__r.Name + '</td>' + '<td>' + jv.Email_Address__c + '</td>' + '</tr>';
              }
              
              body += '</table>';
              body += '<br /><br />This is a system generated message, please do not reply. ';
              body += '<br />Best Regards. <br />';
              mail.setHtmlBody(body);
              mail.setOrgWideEmailAddressId(orgWideAddr.Id);
             
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    /*
    * @description handle unexpected exception
    * @param Exception ex
    * @return 
    */
    public static void handleJobviewerPatchError(Exception ex){
        insert new SWIFT_Application_Log__c(
                                    Debug_Level__c            = 'ERROR',
                                    Apex_Component_Name__c    = 'MRSPatchJobviewersSchedulable',
                                    Method__c                 = 'patchJobviewers',
                                    Message_ID__c             = '',
                                    Error_Message__c          = ex.getMessage(),
                                    Stack_Trace__c            = ex.getStackTraceString()
                                );
    }
}