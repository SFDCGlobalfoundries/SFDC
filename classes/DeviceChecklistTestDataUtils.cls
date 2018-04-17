/*
Author: Sreedhar Karukonda
Description: THis class used as utility class for unit test classes of Device Checklist Code
History:
   18052014 - Initial code
Change Log:    Updated     -     Sreedhar   -     10/02/2014
                [Reason]   Removed TASKRAY Application Objects Dependency 
                Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields. 
*/

public with sharing class DeviceChecklistTestDataUtils {
    public static Account createAccount(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                           
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');               
        fieldValueMap.put('Fab_9_10__c','No');

        return AccountDataFactory.createAccount(fieldValueMap);
        
    }
    
    public static Opportunity createOppty(Account acc){
        Opportunity o = new Opportunity(        
            Name = 'Test Opportunity', AccountId = acc.Id, StageName = '4. Decision', CloseDate = Date.Today().addDays(10), Production_Confidence__c = '30%',
            Target_Process_Node__c = '28HPP', Market_Segment__c = 'Mobility', Process_Platform__c = 'GF Baseline', Fab_Split__c = 100, Process_Geometry__c = '0.028UM',
            Process_Family__c = 'Generic / Nominal', Opportunity_Sourcing_Type__c = 'Second Source', Fab_Assignment_1__c = 'FAB 3' );
            insert o;
        System.assertNotEquals(null, o.id, 'Opportunity is not created');
        return o;
    }

    public static User createUser(String profileName ){
        Profile p = [SELECT Id FROM Profile WHERE Name=:profileName]; 
        String uEmail='standarduser'+ DateTime.now().getTime()+'@testorg.com';
        User u = new User(Alias = 'standt', Email=uEmail, 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName=uEmail);
        insert u;
        System.assert(u.id != null);
        return u;

    }
    
    public static PermissionSet deviceChecklistPermissionSet{
        get{
            if(deviceChecklistPermissionSet == null) {
                List<PermissionSet> PersmissionsTemp = [SELECT Id,
                                                       Name, 
                                                       Label, 
                                                       ProfileId, 
                                                       Profile.Name 
                                                  FROM PermissionSet
                                                 WHERE Name = 'DeviceChecklist_Access'];
               if(PersmissionsTemp.size() < 1){
                   System.assert(false, 'DeviceChecklist_Access permission set is required');
               }
               deviceChecklistPermissionSet = PersmissionsTemp[0];
            }
            return deviceChecklistPermissionSet;
        }
        set;
    }
    
    public static User createUserWithDCAdmin(String profileName ){
        Profile p = [SELECT Id FROM Profile WHERE Name=:profileName]; 
        String uEmail='standarduser'+ DateTime.now().getTime()+'@testorg.com';
        User u = new User(Alias = 'standt', Email=uEmail, 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName=uEmail);
        insert u;
        System.assert(u.id != null);
        System.runAs(u){
            PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = deviceChecklistPermissionSet.Id);
            insert psa;
            
            GF_TaskRay_Project_NPI_Editors__c custSet = new GF_TaskRay_Project_NPI_Editors__c(SetupOwnerId = u.id, NPI_Project_Template_Editable__c = true);
            insert custSet;
        }
        return u;
    }
    
    public static User createUserWithDCUser(String profileName ){
        Profile p = [SELECT Id FROM Profile WHERE Name=:profileName]; 
        String uEmail='standarduser'+ DateTime.now().getTime()+'@testorg.com';
        User u = new User(Alias = 'standt', Email=uEmail, 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName=uEmail);
        insert u;
        System.assert(u.id != null);
        System.runAs(u){
            PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = deviceChecklistPermissionSet.Id);
            insert psa;
        }
        return u;
    }
    
    public static Opportunity_Program__c createOpptyProgram(Account a, Opportunity opty){
        Opportunity_Program__c op = new Opportunity_Program__c(Name='Test Opp',Account__c=a.Id,Opportunity__c = opty.id);
        insert op;
        System.assertNotEquals(null, op.id, 'Opportunity Program is not created');
        return op;
    }
    
    public static Checklist_Container__c createDeviceProgram(Account acc, Opportunity opty, Opportunity_Program__c optyPrgm){
        Checklist_Container__c project = new Checklist_Container__c(Name= ''+DateTime.now(), Account__c= acc!=null?acc.id:null, Opportunity__c= opty!=null?opty.id:null, 
                                                              Opportunity_Program__c = optyPrgm != null?optyPrgm.id:null);
        insert project;
        System.assertNotEquals(null, project.id, 'Program Creation is not created');
        return project;
    }

    public static Checklist_Container__c createProgramWithDevice(Account acc, Opportunity opty, Opportunity_Program__c optyPrgm, Device__c dev){
        Checklist_Container__c project = new Checklist_Container__c(Name= ''+DateTime.now(), Account__c= acc!=null?acc.id:null, Opportunity__c= opty!=null?opty.id:null, 
                                                              Opportunity_Program__c = optyPrgm != null?optyPrgm.id:null,
                                                              Device__c = dev!=null?dev.id:null);
        insert project;
        System.assertNotEquals(null, project.id, 'Program Creation is not created');
        return project;
    }
    
    public static List<Checklist_Container__c> createSubProject(Checklist_Container__c parent, Integer numberOfChildren){
        List<Checklist_Container__c> projects = new List<Checklist_Container__c>();
        for(Integer idx = 0; idx < numberOfChildren; idx++){
            projects.add(new Checklist_Container__c(Name= 'Child '+idx+' '+parent.Name,  Parent__c= parent.id));
        }
        insert projects;
        return projects;
    }
    
    public static List<Checklist_Task__c> createTasks(List<Checklist_Container__c> parentProjects, Integer numberOfTasks){
        List<Checklist_Task__c> tasks = new List<Checklist_Task__c>();
        for(Integer pidx = 0; pidx < parentProjects.size(); pidx++){   
            for(Integer idx = 0; idx < numberOfTasks; idx++){
                tasks.add(new Checklist_Task__c(Name = parentProjects[pidx].Name+' Task '+pidx + ' '+ idx, 
                                                  Container__c= parentProjects[pidx].id, Status__c='Open',
                                                  Days_Due_Before_TO__c = -20,
                                                  Deadline__c = Date.today() + 20
                                                ));
            }
        }
        insert tasks;
        return tasks;
    }
    
    public static Process__c createProcess(){
        Process__c p = new Process__c();
        p.Name = 'TestProcess';
        p.Available_to_Sell__c = 'Available';
        insert p;
        return p;  
    }
    
    public static Device__c createDevice(Id accId, Id oppId, Id oppProgId, Id processId){
        Device__c dev = deviceutiltest.createDevicePM(accId,oppId,oppProgId);
        dev.Confidence_Level_Tapeout__c = '100';
        dev.Expose_Device_to_Customer__c = false ; 
        dev.Fab__c = 'Fab 3';
        dev.Assigned_Process_ID__c = processId;
        dev.Enabled_via_previous_MPW_1__c='No';
        insert dev;
        return dev; 
    }

    public static Device__c createDevice(Id accId, Id oppId, Id oppProgId, Id processId, String dName){
        Device__c dev = deviceutiltest.createDevicePM(accId,oppId,oppProgId);
        dev.Name=dName;
        dev.Confidence_Level_Tapeout__c = '100';
        dev.Expose_Device_to_Customer__c = false ; 
        dev.Fab__c = 'Fab 3';
        dev.Assigned_Process_ID__c = processId;
        dev.BX041_Status__c = 'Closed';
        dev.IP_Gap__c = false;
        dev.Enabled_via_previous_MPW_1__c='No';
        insert dev;
        return dev; 
    }

    public  static Checklist_Container__c createProgramWithNPIProgramType(Id accId, Id oppId,Id oppProgId, Id devId){
        Checklist_Container__c project = new Checklist_Container__c(Account__c= accid, Opportunity__c= oppId, 
                                                              Opportunity_Program__c = oppProgId,Type__c ='NPI Checklist',
                                                              Device__c = devId,Subtype__c='Checklist Template');
        insert project;
        System.assertNotEquals(null, project.id, 'Program Creation is not created');
        return project;
    }

    public  static Checklist_Container__c createDeviceProgramTemplate(Account acc, Opportunity opty, Opportunity_Program__c optyPrgm,Device__c device){
        Checklist_Container__c project = new Checklist_Container__c(Account__c= acc!=null?acc.id:null, Opportunity__c= opty!=null?opty.id:null, 
                                                              Opportunity_Program__c = optyPrgm != null?optyPrgm.id:null,
                                                              Template_Lock__c = true,type__c = 'NPI Checklist',
                                                              subtype__c = 'Checklist Template',Device__c = device!= null?device.id:null);
        insert project;
        System.assertNotEquals(null, project.id, 'Program Creation is not created');
        return project;
    }

    public static List<Checklist_Task__c> createTasks(List<Checklist_Container__c> parentProjects, Integer numberOfTasks, String taskStatus){
        List<Checklist_Task__c> tasks = new List<Checklist_Task__c>();
        for(Integer pidx = 0; pidx < parentProjects.size(); pidx++){   
            for(Integer idx = 0; idx < numberOfTasks; idx++){
                tasks.add(new Checklist_Task__c(Name = parentProjects[pidx].Name+' Task '+pidx + ' '+ idx, 
                Container__c= parentProjects[pidx].id, Status__c= taskStatus,Days_Due_Before_TO__c = 10));
            }
        }
        insert tasks;
        return tasks;
    }

    public static Device__c createDevice(Account a, Opportunity o, Opportunity_Program__c oppProg){
         Device__c dev = deviceutiltest.createDevicePM(a.id,o.id,oppProg.id);
        dev.Opportunity2__c = o.id;
        dev.Confidence_Level_Tapeout__c = '100';
        dev.Expose_Device_to_Customer__c = false ; 
        dev.Fab__c = 'Fab 3';
        dev.BX041_Status__c = 'Closed';
        dev.IP_Gap__c = false;
        insert dev;
        
        System.assertNotEquals(null, dev.id, 'Device is not created'); 
        return dev;        
      }

      public static Checklist_Container__c createDeviceProgramTemplateProject(Account acc, Opportunity opty, Opportunity_Program__c optyPrgm){
        Checklist_Container__c project = new Checklist_Container__c(Account__c= acc!=null?acc.id:null, Opportunity__c= opty!=null?opty.id:null, 
                                                              Opportunity_Program__c = optyPrgm != null?optyPrgm.id:null,
                                                              Template_Lock__c = true,type__c = 'NPI Checklist',
                                                              subtype__c = 'Checklist Template');
        insert project;
        System.assertNotEquals(null, project.id, 'Program Creation is not created');
        return project;
    }

    public static User createUser(){
        User usr1 = [select id,name,email from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true limit 1];
        return usr1;
    }

    public static Id createAccountId(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT');                           
        fieldValueMap.put('sub_type__c', 'Indirect');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India'); 
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'India');              
        fieldValueMap.put('Fab_9_10__c','No');

        return AccountDataFactory.createAccount(fieldValueMap).id;                
    }

    // Creation of an opportunity for Test
    public static Id createOpp(Id acctId){
        Opportunity opp = new Opportunity(Name='Test Opportunity'+Math.random(),AccountId=acctId,StageName='1. Discovery',Market_Segment__c='Automotive',
                                        Target_Process_Node__c='14XM',Process_Platform__c='GF Baseline',Opportunity_Sourcing_Type__c='First Source',
                                        Process_Geometry__c = '0.09UM',Process_Family__c = 'Generic / Nominal',
                                        Fab_Split__c=100,CloseDate = date.newinstance(2012, 12, 21));
        
        insert opp;
        return opp.Id;
    }

    // Creation of an opportunity program for Test
    public static Id createOppProg(Id acctId,Id oppId){
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acctId,Opportunity__c=oppId);
        insert opProg;
        return opProg.Id;
    }
    
    public static Checklist_Container__c createDeviceProgram(Id accId, Id oppId,Id oppProgId, Id devId){
        Checklist_Container__c project = new Checklist_Container__c(Account__c= accid, Opportunity__c= oppId, 
                                                              Opportunity_Program__c = oppProgId,
                                                              Device__c = devId);
        insert project;
        System.assertNotEquals(null, project.id, 'Program Creation is not created');
        return project;
    }
    
    
}