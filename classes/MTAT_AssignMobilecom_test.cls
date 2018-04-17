@isTest
public class MTAT_AssignMobilecom_test{
    static testmethod void insertMobilecom(){
        Test.startTest();
        Assign_a_MobileCom__c amc =new Assign_a_MobileCom__c();
        MobileCom__c mc=new MobileCom__c();
        mc.Location_project__c='Burlington';
        mc.MobileCom_Number__c='888777666';
        mc.Model_Short__c='Test';
        mc.Status__c='Active';
        mc.Activation_Date__c= Date.today();
        Date dt=Date.today();
        mc.Inactivation_Date__c=dt.addDays(20);
        insert mc;
        HCM_Employee__c hcm=new HCM_Employee__c();
        hcm.First_Name__c='Test';
        hcm.Last_Name__c='User';
        hcm.Employee_ID__c='123456';
        hcm.Email_Address__c='Test.User@gf.com';
        hcm.Login_ID__c='123456';
        hcm.Status__c='Active';
        insert hcm;
        
        amc.MobileCom__c=mc.id;
        amc.HCM_Employee__c =hcm.id;
        amc.Activation_Date__c= Date.today();
        Date dte=Date.today();
        amc.Inactivation_Date__c=dte.addDays(20);
        amc.Supervisor_Comments__c='test';
        //insert amc;
        Database.SaveResult dr=Database.Insert(amc,false);
        //forDatabase.SaveResult sr : dr){
            System.assertNotEquals(dr.isSuccess(),false);
       // }
        Test.stopTest();
    }
    
    static testmethod void updatemobilecom(){
        Test.startTest();      
       
       Assign_a_MobileCom__c amc1 =new Assign_a_MobileCom__c();
       Assign_a_MobileCom__c amc2 =new Assign_a_MobileCom__c();

        MobileCom__c mcc=new MobileCom__c();
        mcc.Location_project__c='Burlington';
        mcc.MobileCom_Number__c='888777666';
        mcc.Model_Short__c='Test';
        mcc.Status__c='Active';
        mcc.Activation_Date__c= Date.today();

        Date dt1=Date.today();
        mcc.Inactivation_Date__c=dt1.addDays(20);
        insert mcc;
        MobileCom__c mcc2=new MobileCom__c();
        mcc2.Location_project__c='Burlington';
        mcc2.MobileCom_Number__c='888777668';
        mcc2.Model_Short__c='Test';
        mcc2.Status__c='Active';
        mcc2.Activation_Date__c= Date.today();
        Date dt3=Date.today();
        mcc2.Inactivation_Date__c=dt3.addDays(20);
        insert mcc2;
        HCM_Employee__c hcme=new HCM_Employee__c();
        hcme.First_Name__c='Test2';
        hcme.Last_Name__c='User2';
        hcme.Employee_ID__c='1234555';
        hcme.Email_Address__c='Test2.User@gf.com';
        hcme.Login_ID__c='1234555';
        hcme.Status__c='Active';
        insert hcme;
        
        amc1.MobileCom__c=mcc.id;
        amc1.HCM_Employee__c =hcme.id;
        amc1.Activation_Date__c= Date.today();
        Date dte1=Date.today();
        amc1.Inactivation_Date__c=dte1.addDays(20);
        amc1.Supervisor_Comments__c='test';
        //insert amc1;
        Database.SaveResult drr=Database.Insert(amc1,false);
        amc2.MobileCom__c=mcc2.id;
        amc2.HCM_Employee__c =hcme.id;
        amc2.Activation_Date__c= Date.today();
        Date dte2=Date.today();
        amc2.Inactivation_Date__c=dte2.addDays(20);
        amc2.Supervisor_Comments__c='test';
        //insert amc1;
        Database.SaveResult drrr=Database.Insert(amc2,false);
        
        MobileCom__c mc1=new MobileCom__c();
        mc1.Location_project__c='Burlington';
        mc1.MobileCom_Number__c='888777888';
        mc1.Model_Short__c='Test';
        mc1.Status__c='Active';
        mc1.Activation_Date__c= Date.today();
        Date dt2=Date.today();
        mc1.Inactivation_Date__c=dt2.addDays(20);
        insert mc1;
         HCM_Employee__c hcm1=new HCM_Employee__c();
        hcm1.First_Name__c='Test1';
        hcm1.Last_Name__c='User1';
        hcm1.Employee_ID__c='12345678';
        hcm1.Email_Address__c='Test1.User@gf.com';
        hcm1.Login_ID__c='12345678';
        hcm1.Status__c='Active';
        insert hcm1;
        
                
        amc1.MobileCom__c=mc1.id;
        amc1.HCM_Employee__c=hcm1.id;
       
       Database.SaveResult dr2=Database.update(amc1,false);
        //forDatabase.SaveResult sr : dr){
            System.assertEquals(dr2.isSuccess(),false);
         
         
       // }
       Test.stopTest();
    }
}