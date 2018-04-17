/**
* Author: Dilip Jha
* Company: IBM India pvt. Ltd 
* Project: Sandbox Refresh Automation  
* Description: This Apex class will be used for automation of post sandbox refresh activities
**/

global class SandboxRefreshScript implements SandboxPostCopy
{

    /*Variable declaration*/
    public string SandboxName = URL.getSalesforceBaseUrl().getHost().substringBetween('--','.');
    public string ApptusURL = URL.getSalesforceBaseUrl().getHost(); 
    
    global void runApexClass(SandboxContext context) {
        
    updateContact();
    updateFabDistributionTable();
    updateNDAVariable();
    updateMpwSalesforceUrl();
    updateGFDQEndpoints();
    updateEnvVariable();
    updateEnvironmentVariable();
    updateHcmEmployee();
    updateEnvVariableFalse();
    updateEnvVariableNull(); 
    updateApttusSettings();
    updateApttusProposalSettings();
    updateApptusXapps();
    updateApptusInstanceUrl();  
    AbortScheduledJobs(); 
    updateAiaToErpFlag();
      
    }
    
        /* This function will be used to append .sandboxname to Email records on Contact Object */
        public void updateContact()
            {
              List<Contact> lstContact = new List<Contact>();
                    for(Contact Con : [Select Id,firstName,lastName,Email From Contact])
                        {
                            Con.Email = Con.Email+'.'+SandboxName;
                            con.firstname=con.firstname;
                            lstContact.add(Con);
                        }
 
                    update lstContact;
    
             }
             
             
        /* This function will be used to append .sandboxname to Email records on Hcm Employee Object */
        public void updateHcmEmployee()
            {
              List<HCM_Employee__c> lstHcmEmp = new List<HCM_Employee__c>();
                    for(HCM_Employee__c hcmemp: [Select Id,Email_Address__c From HCM_Employee__c])
                        {
                            hcmemp.Email_Address__c= hcmemp.Email_Address__c+'.'+SandboxName;
                            
                            lstHcmEmp.add(hcmemp);
                        }
 
                    update lstHcmEmp;
    
             }
        /* This function will be used to append .sandboxname to Distribution_List__c records on Fab_Distribution_Table__c Object*/
             
        public void updateFabDistributionTable()
            {
               List<Fab_Distribution_Table__c> lstFab = new List<Fab_Distribution_Table__c>();
                     for(Fab_Distribution_Table__c Fab : [Select Id, Distribution_List__c From Fab_Distribution_Table__c])
                        {
                          Fab.Distribution_List__c = Fab.Distribution_List__c +'.'+SandboxName;
                          lstFab.add(Fab);
                        }
 
                     update lstFab;
              
              
              }
              
           /* updation of custom setting url start*/
              
       public void updateNDAVariable()
            {
                    List<NDA_Variable__c> lstValues = new List<NDA_Variable__c>();
                    for(NDA_Variable__c ndaValues: [SELECT Name,Value__c FROM NDA_Variable__c WHERE Name = 'NDA_IntegrationService_Endpoint'])
                        {            
                            ndaValues.Value__c = 'https://'+ SandboxName + '.'+ ndaValues.Value__c.substringAfter('.');

                            lstValues .add(ndaValues);
                        }
 
                update lstValues;
            
            
            }
            
        public void updateMpwSalesforceUrl()
            {
                    List<MPW_Salesforce_URL__c> lstValues = new List<MPW_Salesforce_URL__c>();
                    for(MPW_Salesforce_URL__c Values: [SELECT Name,URL__c FROM MPW_Salesforce_URL__c ])
                        {            
                            Values.URL__c= 'https://globalfoundries--'+ SandboxName + '.'+ Values.URL__c.substringAfter('.');
                            lstValues .add(Values);
                        }
 
                update lstValues;
            
            
            }
            
          public void updateGFDQEndpoints()
            {
                    List<GF_DQ_Settings__c> lstValues = new List<GF_DQ_Settings__c>();
                    for(GF_DQ_Settings__c Values: [SELECT Name, Datawarehouse_wsdl__c FROM GF_DQ_Settings__c])
                        {            
                            Values.Datawarehouse_wsdl__c= 'https://'+ SandboxName + '.'+ Values.Datawarehouse_wsdl__c.substringAfter('.');
                            lstValues .add(Values);
                        }
 
                update lstValues;
            
            
            }
            
            public void updateEnvironmentVariable()
            {
                    List<Environment_Variable__c> lstValues = new List<Environment_Variable__c>();
                    for(Environment_Variable__c Values: [SELECT Name, Value__c FROM Environment_Variable__c WHERE Name IN('AIA_TO_ERP_ENDPOINT','PROCESS_OPENTEXT_MASHUP_URL','Quality Endpoint Url','MES_Endpoint','SFDC_CUSTOMER_PORTAL','SFDC_INSTANCE','BPM_Endpoint','ORDER_REPORT_END_POINT','PRODUCTION_REPORT_END_POINT','SHIPPING_REPORT_END_POINT','Quality Endpoint Url','ROS_GEForm_Endpoint_URL','SWIFT_MRS_CAD_EndPoint','SWIFTdotNET_EndPoint','PROCESS_OPENTEXT_MASHUP_URL')])
                        {            
                            Values.Value__c= 'https://'+ SandboxName + '.'+ Values.Value__c.substringAfter('.');
                            lstValues.add(Values);
                        }
 
                update lstValues;
            
            
            }
            
            public void updateEnvVariable()
            {
                    List<Environment_Variable__c> lstValues = new List<Environment_Variable__c>();
                    for(Environment_Variable__c Values: [SELECT Name, Value__c FROM Environment_Variable__c WHERE Name IN('DEVICE_TA','ROS_TriggerDatawareHouse','SWIFT_CAD_EMAIL','SWIFT_ADMIN_EMAIL','SWIFT_TDTI-MPW_EMAIL','SWIFT_TAPEOUT_APPLICATIN_EMAIL','SWIFT_TAPEOUT_CENTRE_EMAIL','SWIFT_GLOBALSHUTTLE_EMAIL','SWIFT_RMG_EMAIL','SWIFT_MDP_EMAIL')])
                        {            
                            Values.Value__c= Values.Value__c+'.'+SandboxName;
                            lstValues.add(Values);
                        }
 
                update lstValues;
            
            
            }
            
            public void updateEnvVariableNull()
            {
                    List<Environment_Variable__c> lstValues = new List<Environment_Variable__c>();
                    for(Environment_Variable__c Values: [SELECT Name, Value__c FROM Environment_Variable__c WHERE Name IN('SELF_SIGNED_CERTIFICATE','GF_DISTRIBUTION_LIST','NPC_CE_SYSTEMS_SOLUTIONS_TEAM','BPM_SIGNED_CERTIFICATE')])
                        {            
                            Values.Value__c='null';
                            lstValues.add(Values);
                        }
 
                update lstValues;
            
            
            }
            
            public void updateEnvVariableFalse()
            {
                    List<Environment_Variable__c> lstValues = new List<Environment_Variable__c>();
                    for(Environment_Variable__c Values: [SELECT Name, Value__c FROM Environment_Variable__c WHERE Name IN('BPM_isActive','ROS_GEForm_certificate_enable')])
                        {            
                            Values.Value__c='False';
                            lstValues.add(Values);
                        }
 
                update lstValues;
            
            
            }
            
            public void updateAiaToErpFlag()
            {
                    List<Environment_Variable__c> lstValues = new List<Environment_Variable__c>();
                    for(Environment_Variable__c Values: [SELECT Name, Value__c FROM Environment_Variable__c WHERE Name='AIA_TO_ERP_ENDPOINT_FLAG'])
                        {            
                            Values.Value__c='off';
                            lstValues.add(Values);
                        }
 
                update lstValues;
            
            
            }
            
            public void updateApttusSettings()
                {
                                     
                    List<Apttus_Config2__ConfigSystemProperties__c> lstValues = new List<Apttus_Config2__ConfigSystemProperties__c>();
                    for(Apttus_Config2__ConfigSystemProperties__c Values: [SELECT Name,Apttus_Config2__InstanceUrl__c FROM Apttus_Config2__ConfigSystemProperties__c])
                        {            
                            Values.Apttus_Config2__InstanceUrl__c= ApptusURL ;
                            lstValues .add(Values);
                        }
 
                update lstValues;

                }
                
             public void updateApttusProposalSettings()
                {
                                     
                    List<Apttus_Proposal__ProposalSystemProperties__c> lstValues = new List<Apttus_Proposal__ProposalSystemProperties__c>();
                    for(Apttus_Proposal__ProposalSystemProperties__c Values: [SELECT Name,Apttus_Proposal__InstanceUrl__c FROM Apttus_Proposal__ProposalSystemProperties__c])
                        {            
                            Values.Apttus_Proposal__InstanceUrl__c = ApptusURL ;
                            lstValues .add(Values);
                            
                        }
 
                update lstValues;

                }
                
               public void updateApptusXapps()
                   {
                       List<Apttus_XApps__XAuthorForExcelSystemProperties__c> lstValues = new List<Apttus_XApps__XAuthorForExcelSystemProperties__c>();
                    for(Apttus_XApps__XAuthorForExcelSystemProperties__c Values: [SELECT Name,Apttus_XApps__InstanceUrl__c FROM Apttus_XApps__XAuthorForExcelSystemProperties__c])
                        {            
                            Values.Apttus_XApps__InstanceUrl__c = ApptusURL ;
                            lstValues .add(Values);
                            
                        }
 
                update lstValues;
                   }
                   
             public void updateApptusInstanceUrl()
                 {
                     List<Apttus__ComplySystemProperties__c> lstValues = new List<Apttus__ComplySystemProperties__c>();
                    for(Apttus__ComplySystemProperties__c Values: [SELECT Name,Apttus__InstanceUrl__c FROM Apttus__ComplySystemProperties__c])
                        {            
                            Values.Apttus__InstanceUrl__c = ApptusURL ;
                            lstValues .add(Values);
                            system.debug('dd'+Values.Apttus__InstanceUrl__c );
                        }
 
                update lstValues;
                 
                 }
           /* updation of custom setting url ends */
           
           
           /*This code is used to abort all the scheduled jobs which are queued*/
            public void AbortScheduledJobs()
                {
                List<CronTrigger> cronstoAbort = [Select Id from CronTrigger Limit 100];
                    for(CronTrigger CT: cronstoAbort ){
                    System.abortjob(CT.Id);        
                    }
    
                 }


}