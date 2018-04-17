/**********************************************************************************************************************************************
Class:         LeadTriggerTest
-----------------------------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  21/05/2014
Reason:        Test class that covers utility class "LeadUtil" and trigger "LeadTrigger"

Change Log:    Created     -     JOYDEV     -     21/05/2014     
Change Log:    Updated     -     JOYDEV     -     13/06/2014  
Change Log:    Updated     -     Pradosh     -     06/04/2016  
               [Reason] Updated code to load environment variables                         
**********************************************************************************************************************************************/

@isTest(SeeAllData=false)
public class LeadTriggerTest{
    public static testMethod void AssignRegionsTest0() {        
        test.startTest();
        Led_Queues__c LeadQues=new Led_Queues__c();
        LeadQues.Queue_Names__c='US Lead Queue,EMEA - ROA Lead Queue';
        Insert LeadQues;
        Environment_Variable__c rf1=new Environment_Variable__c ();
        rf1.Name='Test_1';
        rf1.Value__c = 'US-Majors';
        insert rf1;
        createCustomsettings();
         insert new List<Lead> {createLead('QualcommX', '', '', True, 'Other - Region'),
                               createLead('Ld1', 'USA', 'AL', False, 'Other - Region'),
                               createLead('Ld2', 'USA', 'AZ', False, 'Other - Region'),
                               createLead('Ld3', 'Canada', '', False, 'Other - Region'),
                               createLead('Ld4', 'Korea', '', False, 'Other - Region'),
                               createLead('Ld5', 'China', '', False, 'Other - Region'),
                               createLead('Ld6', 'Afghanistan', '', False, 'Other - Region'),
                               createLead('Ld7', 'Australia', '', False, 'Other - Region'),
                               createLead('Ld8', 'XXX', '', False, 'Other - Region'),
                               createLead('Ld9', 'ZZZ', '', False, 'Other - Region'),
                               
                               createLead('QualcommX', '', '', False, 'Other - Region'),
                               createLead('Ld1', 'USA', 'AL', True, 'Other - Region'),
                               createLead('Ld2', 'USA', 'AZ', True, 'Other - Region'),
                               createLead('Ld3', 'Canada', '', True, 'Other - Region'),
                               createLead('Ld4', 'Korea', '', True, 'Other - Region'),
                               createLead('Ld5', 'China', '', True, 'Other - Region'),
                               createLead('Ld6', 'Afghanistan', '', True, 'Other - Region'),
                               createLead('Ld7', 'Australia', '', True, 'Other - Region'),
                               createLead('Ld8', 'XXX', '', True, 'Other - Region'),
                               createLead('Ld9', 'ZZZ', '', True, 'Other - Region'),
                               
                               createLead('QualcommX', '', '', False, ''),
                               createLead('Ld1', 'USA', 'AL', True, ''),
                               createLead('Ld2', 'USA', 'AZ', True, ''),
                               createLead('Ld3', 'Canada', '', True, ''),
                               createLead('Ld4', 'Korea', '', True, ''),
                               createLead('Ld5', 'China', '', True, ''),
                               createLead('Ld6', 'Afghanistan', '', True, ''),
                               createLead('Ld7', 'Australia', '', True, ''),
                               createLead('Ld8', 'XXX', '', True, ''),
                               createLead('Ld9', 'ZZZ', '', True, ''),
                               
                               createLead('QualcommX', '', '', True, ''),
                               createLead('Ld1', 'USA', 'AL', False, ''),
                               createLead('Ld2', 'USA', 'AZ', False, ''),
                               createLead('Ld3', 'Canada', '', False, ''),
                               createLead('Ld4', 'Korea', '', False, ''),
                               createLead('Ld5', 'China', '', False, ''),
                               createLead('Ld6', 'Afghanistan', '', False, ''),
                               createLead('Ld7', 'Australia', '', False, ''),
                               createLead('Ld8', 'XXX', '', False, ''),
                               createLead('Ld9', 'ZZZ', '', False, '')};
        
        Map<String, String> leadRegions = new Map<String, String> {'QualcommX' => 'US-Qualcomm',
                                                                   'Ld1' => 'US-EAST',
                                                                   'Ld2' => 'US-WEST',
                                                                   'Ld3' => 'Americas',
                                                                   'Ld4' => 'Korea Japan',
                                                                   'Ld5' => 'Greater China',
                                                                   'Ld6' => 'EMEA - ROA',
                                                                   'Ld7' => 'EMEA - ROA',
                                                                   'Ld8' => 'Other – Region',
                                                                   'Ld9' => 'Other – Region'};
                                                                   
        for(Lead ld : [SELECT Name,
                              Region__c
                         FROM Lead
                        WHERE Name IN: leadRegions.keySet()]) {
            System.assertequals(ld.Region__c, leadRegions.get(ld.Name));
        } 
        
        test.stopTest();
    }
    
    public static Lead createLead(String szCompanyName, String szCompanyCountry, String szCompanyState, 
                                  Boolean blHotLead, String szRegion){
                                  Lead LD=new lead(Company = szCompanyName + Math.Random(),
                        Corporate_Country__c = szCompanyCountry,
                        Corporate_State__c = szCompanyState,
                        Account_Type__c = 'Reseller',
                        Status = 'Unqualified',
                        Region__c = szRegion,
                        LastName = 'lastxname',
                        Email = 'email' + Math.Random() + '@lead.com',
                        Market_Segment__c = 'Automotive',
                        Hot_Lead__c = blHotLead);
                                  system.debug('@@@@@@@'+LD);
        return new Lead(Company = szCompanyName + Math.Random(),
                        Corporate_Country__c = szCompanyCountry,
                        Corporate_State__c = szCompanyState,
                        Account_Type__c = 'Reseller',
                        Status = 'Unqualified',
                        Region__c = szRegion,
                        LastName = 'lastxname',
                        Email = 'email' + Math.Random() + '@lead.com',
                        Market_Segment__c = 'Automotive',
                        Hot_Lead__c = blHotLead);
                        
    }
    
    public static Country_ISO__c createCountryISO(String szName, String szMter, String szReg, 
                                                  String szSter, String szISO) {
        return new Country_ISO__c(Name = szName,
                                  Marketing_Territory__c = szMter,
                                  Region__c = szReg,
                                  Sales_Territory__c = szSter,
                                  ISO__c = szISO);
    }
    
    public static US_States_Codes__c createUSState(String szName, String szZone) {
        return new US_States_Codes__c(Name = szName,
                                      Zone__c = szZone);
    }
    
    public static Majors__c createMajor(String szName, String szMter) {
        return new Majors__c(Name = szName,
                             Marketing_Territory__c = szMter);
    }
    
    public static void createCustomsettings(){
        Map <String, Country_ISO__c> CountryISOMap = Country_ISO__c.getAll();
        
        Map <String, US_States_Codes__c> USStateCodeMap = new Map <String, US_States_Codes__c>();
        for(US_States_Codes__c usStateCode : US_States_Codes__c.getAll().values()) {
            USStateCodeMap.put(usStateCode.Name, usStateCode);
        }
        
        Map <String, Majors__c> MajorMap = Majors__c.getAll();
        
        upsert new List<Country_ISO__c> 
            {(CountryISOMap.containsKey('USA')         ? CountryISOMap.get('USA'):
                                                         createCountryISO('USA', 'USMT', 'USREG', 'USST', 'US')),
             (CountryISOMap.containsKey('Canada')      ? CountryISOMap.get('Canada'):
                                                         createCountryISO('Canada', 'CANMT', 'CANREG', 'CANST', 'CA')),
             (CountryISOMap.containsKey('Korea')       ? CountryISOMap.get('Korea'):
                                                         createCountryISO('Korea', 'KORMT', 'KORREG', 'KORST', 'KP')),
             (CountryISOMap.containsKey('China')       ? CountryISOMap.get('China'):
                                                         createCountryISO('China', 'CHMT', 'CHREG', 'CHST', 'CN')),
             (CountryISOMap.containsKey('Afghanistan') ? CountryISOMap.get('Afghanistan'):
                                                         createCountryISO('Afghanistan', 'AFMT', 'AFREG', 'AFST', 'AF')),
             (CountryISOMap.containsKey('Australia')   ? CountryISOMap.get('Australia'):
                                                         createCountryISO('Australia', 'AUMT', 'AUREG', 'AUST', 'AU')),
             (CountryISOMap.containsKey('ZZZ')         ? CountryISOMap.get('ZZZ'):
                                                         createCountryISO('ZZZ', 'ZZMT', 'ZZREG', 'ZZST', 'ZZ'))};       
        
        upsert new List<US_States_Codes__c>
            {(USStateCodeMap.containsKey('AL')         ? USStateCodeMap.get('AL'):
                                                         createUSState('AL', 'US-East')),
             (USStateCodeMap.containsKey('AZ')         ? USStateCodeMap.get('AZ'):
                                                         createUSState('AZ', 'US-West'))};
                                                         
        upsert new List<Majors__c>
            {(MajorMap.containsKey('Qualcomm')         ? MajorMap.get('Qualcomm'):
                                                         createMajor('Qualcomm', 'US-Major')),
             (MajorMap.containsKey('AMD')              ? MajorMap.get('AMD'):
                                                         createMajor('AMD', 'US-Major'))};
    }
    
    public static testMethod void runTest1() {  
        Test.startTest();
        Led_Queues__c LeadQues=new Led_Queues__c();
        LeadQues.Queue_Names__c='US Lead Queue,EMEA - ROA Lead Queue';
        Insert LeadQues;
        Lead leadObj = new Lead(); 
        leadObj.LastName = 'TestLastName';
        leadObj.Department__c = 'Design';
        leadObj.Market_Segment__c = 'Mobility';
        leadObj.Company = 'TestCompany';
        insert leadObj;
        
        Test.stopTest();
    }
    
    public static testMethod void runTest2() {
        Test.startTest();
        try{
            Led_Queues__c LeadQues=new Led_Queues__c();
            LeadQues.Queue_Names__c='US Lead Queue,EMEA - ROA Lead Queue';
            Insert LeadQues;
        
            Lead leadObj = new Lead(); 
            leadObj.LastName = 'TestLastName';
            leadObj.Department__c = 'Design';
            leadObj.Market_Segment__c = 'Mobility';
            leadObj.Company = 'TestCompany';
            insert leadObj;
            
            leadObj.Status = 'Submitted for Review';
            leadObj.Region__c = 'US-EAST';
            leadObj.LeadSource = 'Test';
            leadObj.Account_Type__c = 'Test';
            leadObj.Process_Tech_Interested__c = 'Test';
            leadObj.How_did_you_hear_about_GLOBALFOUNDRIES__c = 'Test';
            leadObj.Point_of_Contact_at_GLOBALFOUNDRIES__c = 'Test';
            leadObj.Purpose_for_Registration__c = 'Test';
            leadObj.X1st_Product_TO_Date__c = Date.today();
            leadObj.Geometry_Requested_by_Customer__c = 'Test';
            leadObj.Email = 'Test@test.com';
            leadObj.Phone = '12345678';
            
            update leadObj;
            
            leadObj.Status = 'Open';
            update leadObj;
            
            leadObj.Status = 'Submitted for Review';
            leadObj.Region__c = null;
            leadObj.LeadSource = null;
            //leadObj.Company = null;
            leadObj.Account_Type__c = null;
            leadObj.Process_Tech_Interested__c = null;
            leadObj.How_did_you_hear_about_GLOBALFOUNDRIES__c = null;
            leadObj.Point_of_Contact_at_GLOBALFOUNDRIES__c = null;
            leadObj.Purpose_for_Registration__c = null;
            leadObj.X1st_Product_TO_Date__c = null;
            leadObj.Geometry_Requested_by_Customer__c = null;
            leadObj.Email = null;
            leadObj.Phone = null;
            
            update leadObj;
        }
        catch(Exception e){
        
        }
        Test.stopTest();
    }
}