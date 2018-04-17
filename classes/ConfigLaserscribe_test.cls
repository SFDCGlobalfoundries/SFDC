/**
*   Class:  ConfigLaserscribe_test 
*-----------------------------------------------------------------------------------------------------------------------------------
*   Author: Ashwini Basavaraj
*   Description: Test Class for     ConfigLaserscribe
*
*   History:
*       Ashwini     11262015     - code creation.
   History:
*       Sunita     12142015    - code modified.
*     
**/
@isTest(SeeAlldata = false)
public class ConfigLaserscribe_test {
    @testSetup
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
        frontScribeDataSetup();
     }    
    
    public static testMethod void testMyController1() {
    
        Apttus_Proposal__Proposal__c configplus = [Select id,APTPS_Packaging_Option__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c ='test'];
        Configurator_Plus_Question__c configQueRec1 = [Select id from Configurator_Plus_Question__c where Question_Name__c = 'Frontside Laserscribe needed?' AND Question_Type__c = 'Frontside-Laserscribe' AND  Data_Type__c = 'Picklist'];
        
        Configurator_Plus_Question__c configQueRec2 = [Select id from Configurator_Plus_Question__c where Question_Name__c = 'Text width =' AND Question_Type__c = 'Frontside-Laserscribe' AND  Data_Type__c = 'Picklist'];
        
        Configurator_Plus_Response__c responseRec1 = [Select Id, Response__c, Question_ID__c, Name__c, Configurator_Plus__c, Configurator_Plus_Question__c, Response_Type__c, Additional_Response__c from Configurator_Plus_Response__c where Configurator_Plus__c =: configplus.Id and Response_Type__c='Additional Requirement' and Name__c='Frontside Laserscribe needed?'];
         Configurator_Plus_Response__c responseRec2 = [Select Id, Response__c, Question_ID__c, Name__c, Configurator_Plus__c, Configurator_Plus_Question__c, Response_Type__c, Additional_Response__c from Configurator_Plus_Response__c where Configurator_Plus__c =: configplus.Id and Response_Type__c='Additional Requirement' and Name__c='Text width ='];
         Configurator_Plus_Response__c responseRec3 = [Select Id, Response__c, Question_ID__c, Name__c, Configurator_Plus__c, Configurator_Plus_Question__c, Response_Type__c, Additional_Response__c from Configurator_Plus_Response__c where Configurator_Plus__c =: configplus.Id and Response_Type__c='Additional Requirement' and Name__c='Are below GLOBALFOUNDRIES standard settings to be used?'];
        
         test.starttest();
            PageReference pageRef = new PageReference ('/apex/config_addtional_requirement?Id=' + configplus.id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController abc = new ApexPages.StandardController(configplus);
            ConfigLaserscribe  controlr = new ConfigLaserscribe (abc);
            PageReference pgr = controlr.saveform();
            //system.assert(pgr.getUrl().contains(configplus.id));
            
            ConfigLaserscribe.wrapperlaserscribe wrap = new ConfigLaserscribe.wrapperlaserscribe('Frontside Laserscribe needed?',New List<string>{'Yes','No'},'Yes','','');
           
            ConfigLaserscribe.wrapperlaserscribe_new wrap1 = new ConfigLaserscribe.wrapperlaserscribe_new('Text width =',null,null,'','25');
            ConfigLaserscribe.wrapperlaserscribe_new1 wrap2 = new ConfigLaserscribe.wrapperlaserscribe_new1('Text width =',null,null,'','');
            ConfigLaserscribe.wrapperlaserscribe_new1 wrap3 = new ConfigLaserscribe.wrapperlaserscribe_new1('T7 matrix code required =',New List<string>{'Yes','No'},'Yes','','');
            ConfigLaserscribe.wrapperlaserscribe_new wrap4 = new ConfigLaserscribe.wrapperlaserscribe_new('T7 matrix code required =',New List<string>{'Yes','No'},'Yes','','');
            ConfigLaserscribe.wrapperlaserscribe wrap5 = new ConfigLaserscribe.wrapperlaserscribe('Are below GLOBALFOUNDRIES standard settings to be used?',New List<string>{'Yes','No'},'Yes','','');
            ConfigLaserscribe.wrapperlaserscribe wrap6 = new ConfigLaserscribe.wrapperlaserscribe('Are below GLOBALFOUNDRIES standard settings to be used?',New List<string>{'Yes','No'},'No','','');
          
            ConfigLaserscribe.wrapperlaserscribe_new1 wrap7 = new ConfigLaserscribe.wrapperlaserscribe_new1('Laserscribe field free of PSPI?',New List<string>{'Yes','No'},'Yes','','');
            ConfigLaserscribe.wrapperlaserscribe_new1 wrap8= new ConfigLaserscribe.wrapperlaserscribe_new1('Laserscribe field free of PSPI?',New List<string>{'Yes','No'},'No','','');
                
          
            test.stoptest();

 
 }
     public static testMethod void testMyController2() {
        
            Apttus_Proposal__Proposal__c configplus1 = [Select id,APTPS_Packaging_Option__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c ='test1'];
           // Configurator_Plus_Response__c responseRec4 = [Select Id, Response__c, Question_ID__c, Name__c, Configurator_Plus__c, Configurator_Plus_Question__c, Response_Type__c, Additional_Response__c from Configurator_Plus_Response__c where Configurator_Plus__c =: configplus1.Id and Response_Type__c='Additional Requirement' and Name__c='Are below GLOBALFOUNDRIES standard settings to be used?'];
         //  Configurator_Plus_Question__c configQueRec1 = [Select id from Configurator_Plus_Question__c where Question_Name__c = 'Frontside Laserscribe needed?' AND Question_Type__c = 'Frontside-Laserscribe' AND  Data_Type__c = 'Picklist'];
        //   Configurator_Plus_Response__c responseRec3 = [Select Id, Response__c, Question_ID__c, Name__c, Configurator_Plus__c, Configurator_Plus_Question__c, Response_Type__c, Additional_Response__c from Configurator_Plus_Response__c where Configurator_Plus__c =: configplus1.Id and Response_Type__c='Additional Requirement' and Name__c='Frontside Laserscribe needed?'];
        
            test.starttest();
            
                PageReference pageRef = new PageReference ('/apex/config_addtional_requirement?Id=' + configplus1.id);
                Test.setCurrentPage(pageRef);
                ApexPages.StandardController abc = new ApexPages.StandardController(configplus1);
                ConfigLaserscribe  controlr = new ConfigLaserscribe (abc);
                PageReference pgr = controlr.saveform();
                
               
                
                system.assert(pgr.getUrl().contains(configplus1.id));
                ConfigLaserscribe.wrapperlaserscribe wrap = new ConfigLaserscribe.wrapperlaserscribe('Frontside Laserscribe needed?',New List<string>{'Yes','No'},'No','','');
                ConfigLaserscribe.wrapperlaserscribe_new1 wrap1 = new ConfigLaserscribe.wrapperlaserscribe_new1('Laserscribe field free of PSPI?',New List<string>{'Yes','No'},'Yes','','');
                ConfigLaserscribe.wrapperlaserscribe_new1 wrap2 = new ConfigLaserscribe.wrapperlaserscribe_new1('Laserscribe field free of PSPI?',New List<string>{'Yes','No'},'No','','');
                ConfigLaserscribe.wrapperlaserscribe wrap3 = new ConfigLaserscribe.wrapperlaserscribe('Frontside Laserscribe needed?',New List<string>{'Yes','No'},'Yes','','');
                ConfigLaserscribe.wrapperlaserscribe wrap5 = new ConfigLaserscribe.wrapperlaserscribe('Are below GLOBALFOUNDRIES standard settings to be used?',New List<string>{'Yes','No'},'Yes','','');
                ConfigLaserscribe.wrapperlaserscribe wrap6 = new ConfigLaserscribe.wrapperlaserscribe('Are below GLOBALFOUNDRIES standard settings to be used?',New List<string>{'Yes','No'},'No','','');
                
               Configurator_Plus_Question__c configQueRec1 = [Select id from Configurator_Plus_Question__c where Question_Name__c = 'Frontside Laserscribe needed?' AND Question_Type__c = 'Frontside-Laserscribe' AND  Data_Type__c = 'Picklist'];
               Configurator_Plus_Response__c responseRec3 = [Select Id, Response__c, Question_ID__c, Name__c, Configurator_Plus__c, Configurator_Plus_Question__c, Response_Type__c, Additional_Response__c from Configurator_Plus_Response__c where Configurator_Plus__c =: configplus1.Id and Response_Type__c='Additional Requirement' and Name__c='Frontside Laserscribe needed?'];
        
                responseRec3.Response__c='No';
                Update responseRec3;
                
                pgr = controlr.cancel();
                system.assert(pgr.getUrl().contains(configplus1.id));
                pgr = controlr.setOtherField();
                system.assert(pgr==null);
            test.stoptest();
    }
    
   
    private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        return acct;
    }
    public static void frontScribeDataSetup() {
        try{
            Account testAcct = getAccount('MYTEST ACCOUNT1');
            Apttus_Proposal__Proposal__c configplus =new Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='test', Apttus_Proposal__Account__c=testAcct.id, APTPS_Packaging_Option__c ='Wirebond');
            insert configplus;        
            
            Apttus_Proposal__Proposal__c configplus1 =new Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='test1', Apttus_Proposal__Account__c=testAcct.id, APTPS_Packaging_Option__c ='Flip Chip');
            insert configplus1; 
            
            Apttus_Proposal__Proposal__c configplus2 =new Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='test2', Apttus_Proposal__Account__c=testAcct.id, APTPS_Packaging_Option__c ='Flip Chip');
            insert configplus2; 
            
            Configurator_Plus_Question__c configQueRec1 = new Configurator_Plus_Question__c(Question_Name__c = 'Frontside Laserscribe needed?', Question_Type__c = 'Frontside-Laserscribe',  Data_Type__c = 'Picklist');
            insert configQueRec1;
            Configurator_Plus_Question__c configQueRec1a = new Configurator_Plus_Question__c(Question_Name__c = 'Are below GLOBALFOUNDRIES standard settings to be used?', Question_Type__c = 'Frontside-Laserscribe',  Data_Type__c = 'Picklist');
            insert configQueRec1a;
            Configurator_Plus_Question__c configQueRec2 = new Configurator_Plus_Question__c(Question_Name__c = 'Text width =', Question_Type__c = 'Frontside-Laserscribe',  Data_Type__c = 'Picklist');
            insert configQueRec2;
            
            Configurator_Plus_Question__c configQueRec3 = new Configurator_Plus_Question__c(Question_Name__c = 'T7 matrix code required =', Question_Type__c = 'Frontside-Laserscribe',  Data_Type__c = 'Picklist');
            insert configQueRec3;
            
            Configurator_Plus_Question__c configQueRec4 = new Configurator_Plus_Question__c(Question_Name__c = 'Laserscribe field free of PSPI? =', Question_Type__c = 'Frontside-Laserscribe',  Data_Type__c = 'Picklist');
            insert configQueRec4;
            
            Configurator_Plus_Picklist_Value__c picklistValue1 = new Configurator_Plus_Picklist_Value__c(Configurator_Plus_Question__c = configQueRec1.id,  Picklist_Name__c = 'Test Picklist Value 1',Picklist_Values__c  ='yes');
            insert picklistValue1;
            
            Configurator_Plus_Picklist_Value__c picklistValue2 = new Configurator_Plus_Picklist_Value__c(Configurator_Plus_Question__c = configQueRec1.id,  Picklist_Name__c = 'Test Picklist Value 1',Picklist_Values__c  ='No');
            insert picklistValue2;
            
            Configurator_Plus_Picklist_Value__c picklistValue1a = new Configurator_Plus_Picklist_Value__c(Configurator_Plus_Question__c = configQueRec1a.id,  Picklist_Name__c = 'Test Picklist Value 1',Picklist_Values__c  ='yes');
            insert picklistValue1a;
            
            Configurator_Plus_Picklist_Value__c picklistValue1b = new Configurator_Plus_Picklist_Value__c(Configurator_Plus_Question__c = configQueRec1a.id,  Picklist_Name__c = 'Test Picklist Value 1',Picklist_Values__c  ='No');
            insert picklistValue1b;
            
            Configurator_Plus_Picklist_Value__c picklistValue3 = new Configurator_Plus_Picklist_Value__c(Configurator_Plus_Question__c = configQueRec4.id,  Picklist_Name__c = 'Test Picklist Value 1',Picklist_Values__c  ='yes');
            insert picklistValue3;
            
            
            Configurator_Plus_Picklist_Value__c picklistValue4 = new Configurator_Plus_Picklist_Value__c(Configurator_Plus_Question__c = configQueRec4.id,  Picklist_Name__c = 'Test Picklist Value 1',Picklist_Values__c  ='No');
            insert picklistValue4;
            
            FrontSide_Laserscribe_errors__c fs1=new FrontSide_Laserscribe_errors__c(Name='Text width =',Question_Name__c ='Text width =', Error_Messages__c='Please Select Text width value within range of 0.5mm to 1.0 mm',Higher_range__c=1.00,Lower_range__c=0.50,Default_Value__c='0.75');
            insert fs1;
            
            FrontSide_Laserscribe_errors__c fs2=new FrontSide_Laserscribe_errors__c(Name='T7 matrix code required =',Question_Name__c ='T7 matrix code required =', Error_Messages__c='',Higher_range__c=null,Lower_range__c=null,Default_Value__c='No');
            insert fs2;
            
           
            Configurator_Plus_Response__c configResponse = new Configurator_Plus_Response__c(Configurator_Plus__c = configplus.id, Configurator_Plus_Question__c = configQueRec1.id, Response_Type__c='Additional Requirement');
            configResponse.Response__c = 'yes';
            configResponse.Question_ID__c = configQueRec1.id+'-'+configplus.id;
            configResponse.Name__c='Frontside Laserscribe needed?';
            
            Configurator_Plus_Response__c configResponse1a = new Configurator_Plus_Response__c(Configurator_Plus__c = configplus.id, Configurator_Plus_Question__c = configQueRec1a.id, Response_Type__c='Additional Requirement');
            configResponse1a.Response__c = 'yes';
            configResponse1a.Question_ID__c = configQueRec1a.id+'-'+configplus.id;
            configResponse1a.Name__c='Are below GLOBALFOUNDRIES standard settings to be used?';
            
            Configurator_Plus_Response__c configResponse1b = new Configurator_Plus_Response__c(Configurator_Plus__c = configplus1.id, Configurator_Plus_Question__c = configQueRec1a.id, Response_Type__c='Additional Requirement');
            configResponse1b.Response__c = 'No';
            configResponse1b.Question_ID__c = configQueRec1a.id+'-'+configplus1.id;
            configResponse1b.Name__c='Are below GLOBALFOUNDRIES standard settings to be used?';
            
            Configurator_Plus_Response__c configResponse1 = new Configurator_Plus_Response__c(Configurator_Plus__c = configplus.id, Configurator_Plus_Question__c = configQueRec2.id, Response_Type__c='Additional Requirement');
            configResponse1.Response__c = '2';
            configResponse1.Question_ID__c = configQueRec2.id+'-'+configplus.id;
            configResponse1.Name__c='Text width =';
            
            Configurator_Plus_Response__c configResponse2 = new Configurator_Plus_Response__c(Configurator_Plus__c = configplus1.id, Configurator_Plus_Question__c = configQueRec2.id, Response_Type__c='Additional Requirement');
            configResponse2.Response__c = '';
            configResponse2.Question_ID__c = configQueRec2.id+'-'+configplus1.id;
            configResponse2.Name__c='Text width =';
            
          /*  Configurator_Plus_Response__c configResponse3 = new Configurator_Plus_Response__c(Configurator_Plus__c = configplus1.id, Configurator_Plus_Question__c = configQueRec1.id, Response_Type__c='Additional Requirement');
            configResponse3.Response__c = 'No';
            configResponse3.Question_ID__c = configQueRec1.id+'-'+configplus1.id;
            configResponse3.Name__c='Frontside Laserscribe needed?';*/
            
          
            insert configResponse;
            insert configResponse1;
            insert configResponse1a;
            insert configResponse1b;
            insert configResponse2;
            //insert configResponse3;
            
        }
        catch(Exception ex){
            GlobalUtility.logMessage('Error', 'ConfigLaserscribe_test', 'test Class', null, null, ex.getMessage(), null,null,ex, null);  
        }
    }
}