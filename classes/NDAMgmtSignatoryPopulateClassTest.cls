@isTest
private class NDAMgmtSignatoryPopulateClassTest
{

   @testsetup  
   public static void TestSetupMethod()
   {
       List<SObject> SobjList=new List<SObject>();
       AgreementTestDataFactory.loaddefaults();
       Account acct=AgreementTestDataFactory.GenerateAccount(NULL,'MYTEST ACCOUNT');
       insert acct;      
       Contact con=AgreementTestDataFactory.GenerateContact(NULL,'test','test',acct);
       SobjList.add(con);
       Test.startTest();
       Apttus__APTS_Agreement__c Agr=AgreementTestDataFactory.GenerateAgreement('GENERAL_2_Party_NDA','Test Agreement',acct);
       SobjList.add(Agr);
       
       //Generating test records on TD GN Business Reviewer Object
       List<String> MgmtNDANotificationTestDataList= new List<String>{'US-FINANCE','us-finance','SGP-FINANCE','DRS-RMS','DRS-Human Resource','US-Human Resource','SGP-IT'};
       for(String s:MgmtNDANotificationTestDataList)
           SobjList.add(AgreementTestDataFactory.GenerateMgmtNDANotification(s));
           
       //Generating test records on GF NDA Signatory Object
       List<String> GFNDASigTestDataList= new List<String>{'US-FINANCE','SGP-FINANCE','sgp-finance','DRS-FINANCE','DRS-Human Resource','DRS-RMS','SGP-IT'};
       for(String s:GFNDASigTestDataList)
           SobjList.add(AgreementTestDataFactory.GenerateGFNDASig(s));

       //creating the custom setting data
        
        NDA_Record_Types__c rec=new NDA_Record_Types__c();
        rec.Name='GENERAL_2_Party_NDA';
        rec.Record_Type_Name__c='GENERAL_2_Party_NDA';
        rec.Record_Type_ID__c=[select id from RecordType where RecordType.DeveloperName='GENERAL_2_Party_NDA' limit 1].id;
        rec.Autofill_GF_NDA_Signatory__c=True;
        rec.Autofill_Mgmt_Notification__c=True;
        system.assertEquals(rec.Name,'GENERAL_2_Party_NDA');
        SobjList.add(rec);
        
       insert SobjList;
       Test.stopTest();
   }
   
   
   public static testmethod void TestMultipleEntriesOnMgmtNDA()
   {
        
        Apttus__APTS_Agreement__c agr=[select id,GF_Signatory_Region__c,TD_GN_Department_Name__c from Apttus__APTS_Agreement__c where name='Test Agreement' limit 1]; 
        
        agr.GF_Signatory_Region__c='US';
        agr.TD_GN_Department_Name__c='Finance';
        test.startTest();
         try
        {
           update agr;
	        system.assertEquals(agr.GF_Signatory_Region__c,'US');
        }catch(Exception e)
       {
        System.Assert(e.getMessage().contains('There are multiple entries for the \'Management NDA notification\' based on your selected Geography and Department. Please select manually.'));
        
       }
       test.stopTest();
    }
    
    
    
    public static testmethod void TestMultipleEntriesOnGFNDASig()
   {
        
        Apttus__APTS_Agreement__c agr=[select id,GF_Signatory_Region__c,TD_GN_Department_Name__c from Apttus__APTS_Agreement__c where name='Test Agreement' limit 1]; 
        
        agr.GF_Signatory_Region__c='SGP';
        agr.TD_GN_Department_Name__c='Finance';
        test.startTest();
        
         try
        {
           update agr;
           system.assertEquals(agr.GF_Signatory_Region__c,'SGP');
        }catch(Exception e)
       {
        
        System.Assert(e.getMessage().contains('There are multiple entries for the \'GF Signatory Type\' based on your selected Geography and Department. Please select manually.'));
       }
       test.stopTest();
    }
    
   public static testmethod void TestNoEntryOnMgmtNDA()
   {
        
        Apttus__APTS_Agreement__c agr=[select id,GF_Signatory_Region__c,TD_GN_Department_Name__c from Apttus__APTS_Agreement__c where name='Test Agreement' limit 1]; 
        
        agr.GF_Signatory_Region__c='DRS';
        agr.TD_GN_Department_Name__c='Finance';
        test.startTest();
        
         try
        {
           update agr;
           system.assertEquals(agr.GF_Signatory_Region__c,'DRS');
        }catch(Exception e)
       {
         System.Assert(e.getMessage().contains('No values can be identified for \'Management NDA Notification\' based on your selected Geography and Department.. Please populate manually.'));
         
       }
       test.stopTest();
    }
    
    
    public static testmethod void TestNoEntryOnGFNDASig()
   {
        
        Apttus__APTS_Agreement__c agr=[select id,GF_Signatory_Region__c,TD_GN_Department_Name__c from Apttus__APTS_Agreement__c where name='Test Agreement' limit 1]; 
        
        agr.GF_Signatory_Region__c='US';
        agr.TD_GN_Department_Name__c='Human Resource';
        test.startTest();
        
         try
        {
           update agr;
           system.assertEquals(agr.GF_Signatory_Region__c,'US');
        }catch(Exception e)
       {
         
         System.Assert(e.getMessage().contains('No values can be identified for \'GF Signatory Type\' based on your selected Geography and Department.. Please populate manually.'));
       }
       test.stopTest();
    }
    
    
   public static testmethod void TestActualValueDetection()
   {
        
        Apttus__APTS_Agreement__c agr=[select id,GF_Signatory_Region__c,TD_GN_Department_Name__c from Apttus__APTS_Agreement__c where name='Test Agreement' limit 1]; 
        
        agr.GF_Signatory_Region__c='DRS';
        agr.TD_GN_Department_Name__c='RMS';
        test.startTest();
        update agr;
        system.assertEquals(agr.GF_Signatory_Region__c,'DRS');
        agr=[select id,GF_Signatory_type__c,TD_GN_Management_NDA_notification__c from Apttus__APTS_Agreement__c where name='Test Agreement' limit 1];
        GF_NDA_Signatories__c gfndasign=[select id from GF_NDA_Signatories__c where Name='DRS-RMS' limit 1];
        TD_GN_Business_Reviewer__c tdgnbsnrvw=[select id from TD_GN_Business_Reviewer__c where Name='DRS-RMS' limit 1];
        test.stopTest();
               
        System.assertEquals(gfndasign.id,agr.GF_Signatory_type__c);
        System.assertEquals(tdgnbsnrvw.id,agr.TD_GN_Management_NDA_notification__c);
        
    }
    
   
    
   public static testmethod void TestMultipleEntryOnValueChangeMgmtNDA()
   {
        
        Apttus__APTS_Agreement__c agr=[select id,GF_Signatory_Region__c,TD_GN_Department_Name__c from Apttus__APTS_Agreement__c where name='Test Agreement' limit 1]; 
        
        agr.GF_Signatory_Region__c='DRS';
        agr.TD_GN_Department_Name__c='RMS';
        test.startTest();
        update agr;
        system.assertEquals(agr.GF_Signatory_Region__c,'DRS');
        TD_GN_Business_Reviewer__c tdgnbsnrwr=AgreementTestDataFactory.GenerateMgmtNDANotification('sgp-it');
        insert tdgnbsnrwr;
        
        agr.GF_Signatory_Region__c='SGP';
        agr.TD_GN_Department_Name__c='IT';
         try
        {
           update agr;
        }catch(Exception e)
       {
         
         System.Assert(e.getMessage().contains('There are multiple entries for the \'Management NDA notification\' based on your selected Geography and Department. Please select manually.'));
       }
       test.stopTest();
        
        
    }
    
    public static testmethod void TestIncorrectValueOnUpdateMgmtNDA()
   {
        
        Apttus__APTS_Agreement__c agr=[select id,GF_Signatory_Region__c,TD_GN_Department_Name__c from Apttus__APTS_Agreement__c where name='Test Agreement' limit 1]; 
        
        agr.GF_Signatory_Region__c='DRS';
        agr.TD_GN_Department_Name__c='RMS';
        test.startTest();
        update agr;
        system.assertEquals(agr.GF_Signatory_Region__c,'DRS');        
        TD_GN_Business_Reviewer__c tdgnbsnrwr=AgreementTestDataFactory.GenerateMgmtNDANotification('sgp-it');
        insert tdgnbsnrwr;
        
        
        agr.GF_Signatory_Region__c='SGP';
        agr.TD_GN_Department_Name__c='IT';
        agr.TD_GN_Management_NDA_notification__c=[select id from TD_GN_Business_Reviewer__c where Name='DRS-Human Resource' limit 1].id;
         try
        {
           update agr;
        }catch(Exception e)
       {
         
         System.Assert(e.getMessage().contains('Incorrect value is chosen. Please choose correctly based upon the Geography and Department Name and one among the correct values.'));
       }
       test.stopTest();
        
        
    }
   
   public static testmethod void TestMultipleEntryOnValueChangeGFNDASig()
   {
        
        Apttus__APTS_Agreement__c agr=[select id,GF_Signatory_Region__c,TD_GN_Department_Name__c from Apttus__APTS_Agreement__c where name='Test Agreement' limit 1]; 
        
        agr.GF_Signatory_Region__c='DRS';
        agr.TD_GN_Department_Name__c='RMS';
        test.startTest();
        update agr;
        system.assertEquals(agr.GF_Signatory_Region__c,'DRS');
        GF_NDA_Signatories__c ndasign=AgreementTestDataFactory.GenerateGFNDASig('sgp-it');
        insert ndasign;
        agr.GF_Signatory_Region__c='SGP';
        agr.TD_GN_Department_Name__c='IT';
         try
        {
           update agr;
        }catch(Exception e)
       {
         
         System.Assert(e.getMessage().contains('There are multiple entries for the \'GF Signatory Type\' based on your selected Geography and Department. Please select manually.'));
       }
       test.stopTest();
        
        
    }
    
    public static testmethod void TestIncorrectValueOnUpdateGFNDASig()
   {
        
        Apttus__APTS_Agreement__c agr=[select id,GF_Signatory_Region__c,TD_GN_Department_Name__c from Apttus__APTS_Agreement__c where name='Test Agreement' limit 1]; 
        
        agr.GF_Signatory_Region__c='DRS';
        agr.TD_GN_Department_Name__c='RMS';
        test.startTest();
        update agr;
        system.assertEquals(agr.GF_Signatory_Region__c,'DRS');
        
        GF_NDA_Signatories__c ndasign=AgreementTestDataFactory.GenerateGFNDASig('sgp-it');
        insert ndasign;
        
        agr.GF_Signatory_Region__c='SGP';
        agr.TD_GN_Department_Name__c='IT';
        agr.GF_Signatory_type__c=[select id from GF_NDA_Signatories__c  where Name='DRS-Human Resource' limit 1].id;
         try
        {
           update agr;
        }catch(Exception e)
       {
         
         System.Assert(e.getMessage().contains('Incorrect value is chosen. Please choose correctly based upon the Geography and Department Name and one among the correct values.'));
       }
       test.stopTest();
        
        
    }
    
    
    
   public static testmethod void TestNoValOnTotalNewValues()
   {
        
        Apttus__APTS_Agreement__c agr=[select id,GF_Signatory_Region__c,TD_GN_Department_Name__c from Apttus__APTS_Agreement__c where name='Test Agreement' limit 1]; 
        
        agr.GF_Signatory_Region__c='DRS';
        agr.TD_GN_Department_Name__c='RMS';
        test.startTest();
        update agr;
        system.assertEquals(agr.GF_Signatory_Region__c,'DRS');
        try
        {  agr.TD_GN_Department_Name__c='Tax';
           update agr;
        }catch(Exception e)
       {
         
         System.Assert(e.getMessage().contains('No values can be identified for \'Management NDA Notification\' based on your selected Geography and Department.. Please populate manually.'));
       }
       test.stopTest();
        
    }   
   
   
   public static testmethod void TestExitOnNullGeoOrDept()
   {
        
        Apttus__APTS_Agreement__c agr=[select id,GF_Signatory_Region__c,TD_GN_Department_Name__c from Apttus__APTS_Agreement__c where name='Test Agreement' limit 1]; 
        
        agr.GF_Signatory_Region__c=NULL;
        agr.TD_GN_Department_Name__c=NULL;
        test.startTest();
        update agr;
        test.stopTest();
        agr=[select id,GF_Signatory_Region__c,TD_GN_Department_Name__c,TD_GN_Management_NDA_notification__c,GF_Signatory_type__c from Apttus__APTS_Agreement__c where name='Test Agreement' limit 1]; 
        
        //code will do nothing on null Geography or Department
        System.AssertEquals(NULL,agr.TD_GN_Management_NDA_notification__c);
        System.AssertEquals(NULL,agr.GF_Signatory_type__c);
       
      
        
    }
   
   
}