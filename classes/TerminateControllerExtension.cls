/*
Type Name: TerminateControllerExtension
Author: Suvajit Majumder

Test Class: TerminateControllerExtensionTest
Change History: Adding a method - 'Expire' which will be called on click of Expire button on Agreement object for Procurement Record Type.
Author: Ruchi Talwaria
Modified Date: 26th May, 2016.
……..
……..//
--
*/

global class TerminateControllerExtension
    {
        @TestVisible
        private final String MSG_ERROR = 'Enter Reason for Terminating this Agreement.';
        private final String MSG_ERROR1 = 'Enter Reason for Expiration of this Agreement.';


        public Apttus__APTS_Agreement__c objAgr{get;set;}
        public String check{get;set;}
        public Boolean exp{get;set;}
        public Boolean term{get;set;}
        

        public TerminateControllerExtension(ApexPages.StandardController stdController) 
          {
              this.objAgr= (Apttus__APTS_Agreement__c )stdController.getRecord();
              check = ApexPages.currentPage().getParameters().get('check');

              
              if(check == 'terminate'){
                  term = true;
                  exp = false;
              }
              else{
                  exp = true;
                  term = false;
              }
          }
        
        public PageReference Terminate()
        {
        try
          {
            if(String.isBlank(String.valueOf(objAgr.CLM_Termination_Reason__c)))
                  {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,MSG_ERROR));
                    return NULL;
                  }                        
             else
                {
                objAgr.Apttus__Status__c='Terminated';
                objAgr.Apttus__Status_Category__c='Terminated';
                update objAgr;
                
                //Audit task in activity log                              
                Task AuditTask=new Task(OwnerId=UserInfo.getUserID(),Subject='Terminated Agreement',Description='Terminated Agreement '+objAgr.Apttus__FF_Agreement_Number__c , ActivityDate=Date.today(),WhatId=objAgr.id,Status='Completed',Priority='Normal');
                insert AuditTask;
                }
                               
         }catch(Exception e)
             {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Failure to perform operation due to following reason:-\n'+e));
                 return null;
             }
                                
            PageReference pr=new PageReference('/'+objAgr.id); 
            pr.setRedirect(true);   
            return pr;
            
          } 
        
        public PageReference Expire()
        {
        try
          {
            if(String.isBlank(String.valueOf(objAgr.Expiration_Reason__c)))
                  {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,MSG_ERROR1));
                    return NULL;
                  }                     
             else
                {
                objAgr.Apttus__Status__c='Expired';
                objAgr.Apttus__Status_Category__c='Expired';
                update objAgr;
                
                //Audit task in activity log                              
                Task AuditTask=new Task(OwnerId=UserInfo.getUserID(),Subject='Expired Agreement',Description='Expired Agreement'+objAgr.Apttus__FF_Agreement_Number__c , ActivityDate=Date.today(),WhatId=objAgr.id,Status='Completed',Priority='Normal');
                insert AuditTask;
                }                
               
         }catch(Exception e)
             {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Failure to perform operation due to following reason:-\n'+e));
                 return null;
             }                
                
            PageReference pr=new PageReference('/'+objAgr.id); 
            pr.setRedirect(true);   
            return pr;
            
          } 
        
    }