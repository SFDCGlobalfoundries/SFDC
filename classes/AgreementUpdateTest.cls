@isTest
public class AgreementUpdateTest
{
   Apttus__APTS_Agreement__c nda;
    
    @testSetup
    public static void testSetupMethod() 
    {
       List<SObject> SobjList=new List<SObject>();
       AgreementTestDataFactory.loaddefaults();
       Account acct=AgreementTestDataFactory.GenerateAccount(NULL,'MYTEST ACCOUNT');
       insert acct;      
       Contact con=AgreementTestDataFactory.GenerateContact(NULL,'test','test',acct);
       SobjList.add(con);
       Apttus__APTS_Agreement__c Agr=AgreementTestDataFactory.GenerateAgreement('Procurement_Agreements','NDATESTREC1',acct);
       Agr.CLM_XREF_ID__c=NULL;
       SobjList.add(Agr);
       
       NDA_CLM_App_Settings__c obj=new NDA_CLM_App_Settings__c(SetupOwnerId=Userinfo.getUserId(),Disable_Trigger_Validation__c=False);
       SobjList.add(obj);
       
       insert SobjList;
                       
    }
    
    
    
          
          public static testmethod void CLMTest1()
          {
          
                      
               Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
               
               agr.CLM_Total_UPC_Leasing_Commitment_Amt__c=2;
               agr.CLM_Total_Contract_Amount_USD__c=1;
               agr.CLM_UPC_Leasing_Commitment__c='Yes';
               try
               {
               update agr;
               }catch(Exception e){System.Assert(e.getMessage().contains('The Total UPC/Leasing Amount can not be greater than the Total Contract Amount. Please revise'));}
               
        
          }
          
          public static testmethod void CLMTest2()
          {
          
                       
               Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
               
               agr.CLM_Total_Contract_Amount_USD__c=10000001;
               agr.CLM_Procurement_Base_Agreement_type__c='Non-Standard';
               agr.CLM_Corporate_Accounting_Approval_Req__c='No';
               agr.CLM_Corp_Acct_Approval_Exception_Reason__c=NULL;
               try
               {
               update agr;
               }catch(Exception e){System.Assert(e.getMessage().contains('If the Base Type is Non-Standard and Corporate Acct.Approval Required is NO and Total Contact Amount is greater than or equal to 10Million USD, enter an exception reason.'));}
               
        
          }
          
          public static testmethod void CLMTest3()
          {
          
                     
               Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
               
               agr.CLM_Confirm__c=True;
               agr.CLM_Execution_Date__c=NULL;
               try
               {
               update agr;
               }catch(Exception e){System.Assert(e.getMessage().contains('An Execution date must be entered prior to \'Activation\''));}
               
        
          }
          
          public static testmethod void CLMTest4()
          {
          
                     
               Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
               
               agr.CLM_Corporate_Accounting_Approval_Req__c='Yes';
               agr.CLM_Corporate_Accounting_Reviewer__c=NULL;
               try
               {
               update agr;
               }catch(Exception e){System.Assert(e.getMessage().contains('If the Corporate Accounting Approval is Required, select a Corporate Accounting Reviewer'));}
               
        
          }
          
          public static testmethod void CLMTest5()
          {
          
               test.startTest();      
               Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
               
               agr.CLM_Legal_Approval_Required__c='No';
               agr.CLM_Legal_Approval_Exception_Reason__c=NULL;
               try
               {
               update agr;
               }catch(Exception e){System.Assert(e.getMessage().contains('If the Base Type is Non-Standard and Legal Approval Required is NO, enter an exception reason'));}
               
        
               agr.CLM_Legal_Approval_Required__c='Yes';
               agr.CLM_Legal_Approval_Exception_Reason__c=NULL;
               test.stopTest();
               try
               {
               update agr;
               }catch(Exception e){System.Assert(e.getMessage().containsNone('If the Base Type is Non-Standard and Legal Approval Required is NO, enter an exception reason'));}
          }
          
          
          public static testmethod void CLMTest6()
          {
          
                     
               Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
               Integer c=[select count() from Attachment where ParentId=:agr.id];
               System.assertEquals(c,0);
               agr.CLM_UPC_Leasing_Commitment__c='Yes';
               agr.CLM_Confirm__c=True;
               agr.CLM_Total_UPC_Leasing_Commitment_Amt__c=1;
               agr.CLM_Total_Contract_Amount_USD__c=2;
               agr.CLM_Execution_Date__c=System.today();
               try
               {
               update agr;
               }catch(Exception e){
               System.Assert(e.getMessage().contains('Please ensure system cover sheet is generated and a copy of the signed contract is uploaded prior to activating the agreement.'));}
               
               
               
               agr.CLM_UPC_Leasing_Commitment__c='No';
               agr.CLM_Total_UPC_Leasing_Commitment_Amt__c=1;
               agr.CLM_Total_Contract_Amount_USD__c=2;
               try
               {
               update agr;
               }catch(Exception e){
               System.Assert(e.getMessage().contains('A value is not required if the UPC/Leasing Commitment field is NO. Please remove'));}
          }
          
          
          public static testmethod void CLMTest7()
          {
          
                     
               Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
               agr.CLM_UPC_Leasing_Commitment__c='Yes';
               try
               {
               update agr;
               }catch(Exception e){
               System.Assert(e.getMessage().contains('A value must be entered if the UPC/Leasing Commitment field is YES.'));}
               
               
               
               
          }
          
          
          public static testmethod void CLMTest8()
          {
          
                     
               Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
               agr.Apttus__Status_Category__c='In Authoring';
               update agr;
               
               
               agr=[select id,Apttus__Status_Category__c,Apttus__Status__c from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
               System.assertEquals(agr.Apttus__Status_Category__c,'Request');
               System.assertEquals(agr.Apttus__Status__c,'Request');
               
               
          }
          
          
          public static testmethod void CLMTest9()
          {
          
                     
               Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
               agr.CLM_Global_Contract__c='Yes';
               agr.CLM_Legal_Entity__c='GLOBALFOUNDRIES China (Beijing) Co., Limited';
               update agr;
               
               List<String> options = new List<String>();
                    Schema.DescribeFieldResult fieldResult = Apttus__APTS_Agreement__c.CLM_Applicable_Fabs__c.getDescribe();
                    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();      
                  
                          for( Schema.PicklistEntry f : ple)
                               if(f.getLabel()<>'All Fabs')
                                   options.add(String.valueOf(new SelectOption(f.getLabel(), f.getValue()).getValue()));
                               
                               
               agr=[select id,CLM_Applicable_Fabs__c from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
               List<String> option1 = new List<String>();
               option1.addAll(agr.CLM_Applicable_Fabs__c.split(';'));
               option1.sort();
               options.sort();
               System.assertEquals(String.join(option1,';'),String.join(options,';'));
               
               
               
          }
          
          
          public static testmethod void CLMTest10()
          {
          
                     
               Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
               agr.CLM_Global_Contract__c='No';
               agr.CLM_Applicable_Fabs__c=NULL;
                              
               try
               {
               update agr;
               }catch(Exception e){
               System.Assert(e.getMessage().contains('If No is selected for Global Contract, select at least one Fab.Note: All Fabs cannot be selected as well, if ‘NO’ is selected.'));}
               
               
               
               
               List<String> options = new List<String>();
                    Schema.DescribeFieldResult fieldResult = Apttus__APTS_Agreement__c.CLM_Applicable_Fabs__c.getDescribe();
                    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();      
                  
                          for( Schema.PicklistEntry f : ple)
                               options.add(String.valueOf(new SelectOption(f.getLabel(), f.getValue()).getValue()));
                               
                
                
               agr.CLM_Global_Contract__c='No';
               agr.CLM_Applicable_Fabs__c=String.join(options,';');
                              
               try
               {
               update agr;                
               }catch(Exception e){
               System.Assert(e.getMessage().contains('If No is selected for Global Contract, select at least one Fab.Note: All Fabs cannot be selected as well, if ‘NO’ is selected.'));}
               
               
               
          }
          
          
          
          
          public static testmethod void CLMTest11()
          {
          
                     
               Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
               List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'TD_Agreements' and SobjectType = 'Apttus__APTS_Agreement__c'];
               agr.RecordTypeId=recrdTypes[0].id;
               agr.CLM_Confirm__c=True;
               agr.CLM_confirm_BX050_is_executed_uploaded__c=True;
               agr.CLM_Execution_Date__c=NULL;               
               try
               {
               update agr;
               }catch(Exception e){
               System.Assert(e.getMessage().contains('An Execution date must be entered prior to \'Activation\''));}
             
               
          }
          
          
           public static testmethod void CLMTest12()
          {
          
                     
               Apttus__APTS_Agreement__c agr=[select id from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
               List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'TD_Agreements' and SobjectType = 'Apttus__APTS_Agreement__c'];
               agr.RecordTypeId=recrdTypes[0].id;
               agr.CLM_Confirm__c =False;
               agr.CLM_confirm_BX050_is_executed_uploaded__c=False;
               agr.Apttus__Status__c='In Amendment';               
               
               update agr;
               
               
             
               
          }
          
           public static testmethod void CLMTest13()
          {
          
               test.startTest();      
               Apttus__APTS_Agreement__c agr=[select id,Apttus__Status_Category__c,Apttus__Status__c from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
            
               List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'TD_Agreements' and SobjectType = 'Apttus__APTS_Agreement__c'];
               
               
               agr.RecordTypeId=recrdTypes[0].id;
               agr.Apttus__Status__c='Being Amended';               
               
               update agr;
               
               Apttus__APTS_Agreement__c newagr=[select id,Apttus__Status_Category__c,Apttus__Status__c from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
             
               System.assertEquals(newagr.Apttus__Status_Category__c,'Request');
               System.assertEquals(newagr.Apttus__Status__c ,'Request');
               test.stopTest();
          }
          
          
          
          public static testmethod void CLMTest14()
          {
          
               test.startTest();      
               Apttus__APTS_Agreement__c agr=[select id,Name from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
            
               List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'TD_Agreements' and SobjectType = 'Apttus__APTS_Agreement__c'];
               
               agr.RecordTypeId=recrdTypes[0].id;
               agr.Name=NULL;              
               
               update agr;
               
               agr=[select id,Name from Apttus__APTS_Agreement__c where id=:agr.id limit 1 ];
               
               if(Date.Today().month()>9) 
                 System.assertEquals(agr.Name,'TD'+' '+'Testacc'+' '+Date.Today().year()+' '+Date.Today().month());
               else
                 System.assertEquals(agr.Name,'TD'+' '+'Testacc'+' '+Date.Today().year()+' '+'0'+Date.Today().month());
                 test.stopTest();       
               
          } 


 public static testmethod void CLMTest15()
          {
          
               test.startTest();      
               Apttus__APTS_Agreement__c agr=[select id,Name from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
            
               List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'Procurement_Agreements' and SobjectType = 'Apttus__APTS_Agreement__c'];
               
               agr.RecordTypeId=recrdTypes[0].id;
               agr.Name=NULL;              
               
               update agr;
               
               agr=[select id,Name from Apttus__APTS_Agreement__c where id=:agr.id limit 1 ];
               
               if(Date.Today().month()>9) 
                 System.assertEquals(agr.Name,'PROC'+' '+'Testacc'+' '+Date.Today().year()+' '+Date.Today().month());
               else
                 System.assertEquals(agr.Name,'PROC'+' '+'Testacc'+' '+Date.Today().year()+' '+'0'+Date.Today().month());
                 test.stopTest();       
               
          } 
          
          public static testmethod void CLMTest16()
          {
          
               test.startTest();      
               Apttus__APTS_Agreement__c agr=[select id,Name from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
            
               List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'Finance_Treasury_Agreements' and SobjectType = 'Apttus__APTS_Agreement__c'];
               
               agr.RecordTypeId=recrdTypes[0].id;
               agr.Name=NULL;              
               
               update agr;
               
               agr=[select id,Name from Apttus__APTS_Agreement__c where id=:agr.id limit 1 ];
               
               if(Date.Today().month()>9) 
                 System.assertEquals(agr.Name,'FIN'+' '+'Testacc'+' '+Date.Today().year()+' '+Date.Today().month());
               else
                 System.assertEquals(agr.Name,'FIN'+' '+'Testacc'+' '+Date.Today().year()+' '+'0'+Date.Today().month());
                 test.stopTest();       
               
          }
          
          public static testmethod void CLMTest17()
          {
          
               test.startTest();      
               Apttus__APTS_Agreement__c agr=[select id,Name from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
            
               List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'Legal_Agreements' and SobjectType = 'Apttus__APTS_Agreement__c'];
               
               agr.RecordTypeId=recrdTypes[0].id;
               agr.Name=NULL;              
               
               update agr;
               
               agr=[select id,Name from Apttus__APTS_Agreement__c where id=:agr.id limit 1 ];
               
               if(Date.Today().month()>9) 
                 System.assertEquals(agr.Name,'LEGAL'+' '+'Testacc'+' '+Date.Today().year()+' '+Date.Today().month());
               else
                 System.assertEquals(agr.Name,'LEGAL'+' '+'Testacc'+' '+Date.Today().year()+' '+'0'+Date.Today().month());       
               test.stopTest();
          }
          
           public static testmethod void CLMTest18()
          {
          
               test.startTest();      
               Apttus__APTS_Agreement__c agr=[select id,Name from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
            
               List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'Sales_Agreements' and SobjectType = 'Apttus__APTS_Agreement__c'];
               
               agr.RecordTypeId=recrdTypes[0].id;
               agr.Name=NULL;              
               
               update agr;
               
               agr=[select id,Name from Apttus__APTS_Agreement__c where id=:agr.id limit 1 ];
               
               if(Date.Today().month()>9) 
                 System.assertEquals(agr.Name,'SALES'+' '+'Testacc'+' '+Date.Today().year()+' '+Date.Today().month());
               else
                 System.assertEquals(agr.Name,'SALES'+' '+'Testacc'+' '+Date.Today().year()+' '+'0'+Date.Today().month());       
               test.stopTest();
          }
          
          
          
          public static testmethod void CLMTest19()
          {
          
               test.startTest();      
               Apttus__APTS_Agreement__c agr=[select id,Name from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
            
               List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'GENERAL_2_Party_NDA' and SobjectType = 'Apttus__APTS_Agreement__c'];
               
               agr.RecordTypeId=recrdTypes[0].id;
               agr.Name=NULL;              
               
               update agr;
               
               agr=[select id,Name from Apttus__APTS_Agreement__c where id=:agr.id limit 1 ];
               
               if(Date.Today().month()>9) 
                 System.assertEquals(agr.Name,'NDA'+' '+'Testacc'+' '+Date.Today().year()+' '+Date.Today().month());
               else
                 System.assertEquals(agr.Name,'NDA'+' '+'Testacc'+' '+Date.Today().year()+' '+'0'+Date.Today().month());       
               test.stopTest();
          }
          
          
          
          public static testmethod void CLMTest20()
          {
          
                     
               Apttus__APTS_Agreement__c agr=[select id,Name from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
            
               List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'Procurement_Agreements' and SobjectType = 'Apttus__APTS_Agreement__c'];
               
               agr.RecordTypeId=recrdTypes[0].id;
               agr.CLM_Procurement_Base_Agreement_type__c='Non-Standard';
               agr.CLM_Legal_Approval_Required__c='No';              
               agr.CLM_Legal_Approval_Exception_Reason__c=NULL;
               
               try
               {
               update agr;
               }catch(Exception e){
               System.Assert(e.getMessage().contains('If the Base Type is Non-Standard and Legal Approval Required is NO, enter an exception reason.'));}
                   
               
          }
          
          
          public static testmethod void CLMTest21()
          {
          
                     
               Apttus__APTS_Agreement__c agr=[select id,Name from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
            
               List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'Procurement_Agreements' and SobjectType = 'Apttus__APTS_Agreement__c'];
               
               agr.RecordTypeId=recrdTypes[0].id;
               agr.CLM_Procurement_Base_Agreement_type__c='Non-Standard';
               agr.CLM_Legal_Approval_Required__c='Yes';              
               agr.CLM_Legal_Reviewer__c=NULL;
               
               try
               {
               update agr;
               }catch(Exception e){
               System.Assert(e.getMessage().contains('If the Legal Approval is Required, select a Legal Reviewer.'));}
                   
               
          }
          
          
          public static testmethod void CLMTest22()
          {
              Apttus__APTS_Agreement__c agr=[select id,Name from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
              List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'Procurement_Agreements' and SobjectType = 'Apttus__APTS_Agreement__c'];
              agr.RecordTypeId=recrdTypes[0].id;
              agr.Apttus__Status_Category__c='Request';
              agr.Apttus__Status__c='Request';
              agr.CLM_UPC_Leasing_Commitment__c='Yes-UPC';
              agr.CLM_Confirm__c=True;
              agr.CLM_XREF_ID__c=NULL;
              agr.CLM_Execution_Date__c=System.today();
              try
              {
              update agr;
              }catch(Exception e)
              {
              System.Assert(e.getMessage().contains('Please ensure system cover sheet is generated and a copy of the signed contract is uploaded prior to activating the agreement.'));
              }
              
          }
          
          
           public static testmethod void CLMTest23()
          {
              Apttus__APTS_Agreement__c agr=[select id,Name from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
              List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'Procurement_Agreements' and SobjectType = 'Apttus__APTS_Agreement__c'];
              agr.RecordTypeId=recrdTypes[0].id;
              agr.Apttus__Status_Category__c='Request';
              agr.Apttus__Status__c='Request';
              agr.CLM_UPC_Leasing_Commitment__c='Yes-UPC';
              agr.CLM_Confirm__c=True;
              agr.CLM_XREF_ID__c=NULL;
              agr.CLM_Execution_Date__c=System.today();
              
              //Create an attachment of type Cover Sheet
              
              Attachment a=AgreementTestDataFactory.GenerateAttachment(1,'Test Procurement Cover Sheet Test',agr.id);
              insert a;
              
              try
              {
              update agr;
              }catch(Exception e)
              {
              System.Assert(e.getMessage().contains('Please ensure system cover sheet is generated and a copy of the signed contract is uploaded prior to activating the agreement.'));
              }
              
          }
          
          
          public static testmethod void CLMTest24()
          {
              Apttus__APTS_Agreement__c agr=[select id,Name from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
              List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'Procurement_Agreements' and SobjectType = 'Apttus__APTS_Agreement__c'];
              agr.RecordTypeId=recrdTypes[0].id;
              agr.Apttus__Status_Category__c='Request';
              agr.Apttus__Status__c='Request';
              agr.CLM_UPC_Leasing_Commitment__c='Yes-UPC';
              agr.CLM_Confirm__c=True;
              agr.CLM_XREF_ID__c=NULL;
              agr.CLM_Execution_Date__c=System.today();
              
              //Create an attachment which is not a cover sheet
              
              Attachment a=AgreementTestDataFactory.GenerateAttachment(1,'TestAttachment',agr.id);
              insert a;
              
              try
              {
              update agr;
              }catch(Exception e)
              {
              System.Assert(e.getMessage().contains('Please ensure system cover sheet is generated and a copy of the signed contract is uploaded prior to activating the agreement'));
              }
              
          }
          
          
          public static testmethod void CLMTest25()
          {
              Apttus__APTS_Agreement__c agr=[select id,Name from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
              List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'Procurement_Agreements' and SobjectType = 'Apttus__APTS_Agreement__c'];
              agr.RecordTypeId=recrdTypes[0].id;
              agr.Apttus__Status_Category__c='Request';
              agr.Apttus__Status__c='Request';
              agr.CLM_UPC_Leasing_Commitment__c='Yes-UPC';
              agr.CLM_Total_UPC_Leasing_Commitment_Amt__c=23;
              agr.CLM_Total_UPC_Leasing_Commitment_Amt__c=50;
              agr.CLM_Confirm__c=True;
              agr.CLM_XREF_ID__c=NULL;
              agr.CLM_Execution_Date__c=System.today();
              
            
              List<Attachment> attchList=new List<Attachment>();
                            
              Attachment a=AgreementTestDataFactory.GenerateAttachment(1,'TestAttachment',agr.id);
              attchList.add(a);
              
              
              Attachment b=AgreementTestDataFactory.GenerateAttachment(1,'Test Procurement Cover Sheet Test',agr.id);
              attchList.add(b);
              
              
              insert attchList;
              
              test.startTest();
              update agr;
              test.stopTest();
              agr=[select id,Apttus__Status_Category__c,Apttus__Status__c from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
              
              //aserting that the attachment validation passed 
              System.assertEquals('In Signatures',agr.Apttus__Status_Category__c);
              System.assertEquals('Fully Signed',agr.Apttus__Status__c );
              
             
              
              
          }
          
          public static testmethod void CLMTest26()
          {
              Apttus__APTS_Agreement__c agr=[select id,Name from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
              List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'Procurement_Agreements' and SobjectType = 'Apttus__APTS_Agreement__c'];
              agr.RecordTypeId=recrdTypes[0].id;
              agr.Apttus__Status_Category__c='In Effect';
              agr.Apttus__Status__c='Activated';
              
              update agr;
              
              test.startTest();
              agr.Apttus__Status_Category__c='Request';
              agr.Apttus__Status__c='Request';
              update agr;
              test.stopTest();
              agr=[select id,Apttus__Status_Category__c,Apttus__Status__c from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
              
              //assert status is not changed once procurement is activated
              
              System.assertEquals('In Effect',agr.Apttus__Status_Category__c);
              System.assertEquals('Activated',agr.Apttus__Status__c);
              
              
              
          }
          
          
          public static testmethod void CLMTest27()
          {
              Apttus__APTS_Agreement__c agr=[select id,Name from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
              List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'GENERAL_2_Party_NDA' and SobjectType = 'Apttus__APTS_Agreement__c'];
              agr.RecordTypeId=recrdTypes[0].id;
              agr.Apttus__Status_Category__c='In Effect';
              agr.Apttus__Status__c='Activated';
              update agr;
              
              test.startTest();
              agr.Apttus__Status_Category__c='Request';
              agr.Apttus__Status__c='Request';
              update agr;
              test.stopTest();
              //assert the procurement status code does not impact ndas
              
              agr=[select id,Apttus__Status_Category__c,Apttus__Status__c from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
              System.assertEquals('Request',agr.Apttus__Status_Category__c);
              System.assertEquals('Request',agr.Apttus__Status__c);
              
              
              
          }
          
          
          
           public static testmethod void CLMTest28()
          {
              
              List<SObject> Sobjlist=new List<SOBject>(); 
              test.startTest();   
              Apttus__APTS_Agreement__c agr=[select id,Name from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
              List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'Procurement_Agreements' and SobjectType = 'Apttus__APTS_Agreement__c'];
              agr.RecordTypeId=recrdTypes[0].id;
              agr.Apttus__Status_Category__c='In Effect';
              agr.Apttus__Status__c='Being Amended';
              
              update agr;

              
              Attachment a=AgreementTestDataFactory.GenerateAttachment(1,'Test Procurement Cover Sheet Test',agr.id);
              Sobjlist.add(a);
              Attachment b=AgreementTestDataFactory.GenerateAttachment(1,'Test File',agr.id);
              Sobjlist.add(b);

              
             
              
              Apttus__APTS_Agreement__c AmendAgr=agr.clone(false,true,true,true);
              
              Sobjlist.add(AmendAgr);
              
              insert Sobjlist;
               
               
              System.assert(AmendAgr.id!=NULL);
                            
              Attachment x=AgreementTestDataFactory.GenerateAttachment(1,'Test Procurement Cover Sheet Test',AmendAgr.id);
              insert x;   
              
              
     
              AmendAgr.Apttus__Version_Number__c=1;
              AmendAgr.Apttus__Status_Category__c='Request';
              AmendAgr.Apttus__Status__c='In Amendment';   //simulating amendment of agreement
              update AmendAgr;
              
              
              //assert the procurement status is Request
                           
              AmendAgr=[select id,Apttus__Status_Category__c,Apttus__Status__c from Apttus__APTS_Agreement__c where id= :AmendAgr.id ];
              System.assertEquals('Request',AmendAgr.Apttus__Status_Category__c);
              System.assertEquals('Request',AmendAgr.Apttus__Status__c);
              
              Integer c=[select count() from Attachment where Parentid= :AmendAgr.id];
              
              //assert the attachment is deleted
              System.assertEquals(0,c);
              
              test.stopTest();
              
          }
          
          
             public static testmethod void CLMTest29()
          {
              Apttus__APTS_Agreement__c agr=[select id,Name from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
              List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'Procurement_Agreements' and SobjectType = 'Apttus__APTS_Agreement__c'];
              agr.RecordTypeId=recrdTypes[0].id;
              
              agr.CLM_XREF_ID__c=NULL;
              agr.CLM_Execution_Date__c=System.today();
              
              //Create an attachment of type Cover Sheet
              List<sObject> ObjList=new List<sObject>();
              Attachment a=AgreementTestDataFactory.GenerateAttachment(1,'Test Procurement Cover Sheet Test',agr.id);
              ObjList.add(a);
              Attachment b=AgreementTestDataFactory.GenerateAttachment(1,'Contract File',agr.id);
              ObjList.add(b);
              Document d=AgreementTestDataFactory.GenerateDocument('Test Document');
              ObjList.add(d);
              
              Test.startTest();
              
              insert ObjList;
              Apttus__Agreement_Document__c  agrDoc=AgreementTestDataFactory.GenerateAgrDocRecord(d,agr);
              insert agrDoc;
              
              Integer p=[select count() from Attachment where ParentID= :agr.id];
              System.assertEquals(2,p);
              Integer q=[select count() from Apttus__Agreement_Document__c where Apttus__Agreement__c= :agr.id];
              System.assertEquals(1,q);
              
              try{
                  agr.Apttus__Version_Number__c=1;
                  agr.Apttus__Status_Category__c='Amended';
                  agr.Apttus__Status__c='In Amendment';   //simulating amendment of agreement
                  agr.CLM_Confirm__c=False;
                  update agr;
                  
                  agr=[select id,Apttus__Status_Category__c,Apttus__Status__c,CLM_Confirm__c from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
                  System.assertEquals(False,agr.CLM_Confirm__c);
                  System.assertEquals('Request',agr.Apttus__Status__c);
                  System.assertEquals('Request',agr.Apttus__Status_Category__c);
                  Integer x=[select count() from Attachment where ParentID= :agr.id];
                  System.assertEquals(0,x);
                  Integer y=[select count() from Apttus__Agreement_Document__c where Apttus__Agreement__c= :agr.id];
                  System.assertEquals(0,y);
              } catch(Exception e){
                  GlobalUtility.logMessage('Error', 'AgreementUpdateTest', 'CLMTest29','', 'Exception while updating Agreement record', String.valueof(e.getMessage()),'','NDA Management',e,0);
              }
              Test.stopTest();
          }  
          
          public static testmethod void MartinisyncTest1()
          {
          
               Test.startTest();      
               Apttus__APTS_Agreement__c agr=[select id,Name,Apttus__Account__c  from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
            
               List<RecordType> SigType= [select Id, Name, DeveloperName from RecordType where DeveloperName = 'Agreement_Signatory' and SobjectType = 'Signatory__c'];
               Signatory__c SigRec=new Signatory__c (Agreement__c=agr.id,Account__c=agr.Apttus__Account__c);
               insert SigRec;
               
               List<RecordType> recrdTypes = [select Id,Name,DeveloperName from RecordType where DeveloperName = 'GENERAL_2_Party_NDA' and SobjectType = 'Apttus__APTS_Agreement__c'];
               
               agr.RecordTypeId=recrdTypes[0].id;
               agr.Type__c='Technical NDA';
               agr.Apttus__Status_Category__c='In Effect';
               agr.Apttus__Status__c='Activated';
                              
               
               update agr; 
               
               Test.stopTest();
               
                                               
          }
          
          
          public static testmethod void MartinisyncTest2()
          {
          
               Test.startTest();      
               Apttus__APTS_Agreement__c agr=[select id,Name,Apttus__Account__c  from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
            
               List<RecordType> SigType= [select Id, Name, DeveloperName from RecordType where DeveloperName = 'Agreement_Signatory' and SobjectType = 'Signatory__c'];
                Signatory__c SigRec=new Signatory__c (Agreement__c=agr.id,Account__c=agr.Apttus__Account__c );
                insert SigRec;
               
               List<RecordType> recrdTypes = [select Id,Name,DeveloperName from RecordType where DeveloperName = 'GENERAL_2_Party_NDA' and SobjectType = 'Apttus__APTS_Agreement__c'];
               
               
               agr.RecordTypeId=recrdTypes[0].id;
               agr.Type__c='Technical NDA';
               agr.Apttus__Status_Category__c='Request';
               agr.Apttus__Status__c='Request';
             
               
               update agr; 
               
               Test.stopTest();
                                              
          }
          
          
          public static testmethod void MartinisyncTest3()
          {
          
               Test.startTest();      
               Apttus__APTS_Agreement__c agr=[select id,Name,Apttus__Account__c  from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
            
            
               List<RecordType> SigType= [select Id, Name, DeveloperName from RecordType where DeveloperName = 'Agreement_Signatory' and SobjectType = 'Signatory__c'];
               Signatory__c SigRec=new Signatory__c (Agreement__c=agr.id,Account__c=agr.Apttus__Account__c );
               insert SigRec;
               
               
               List<RecordType> recrdTypes = [select Id,Name,DeveloperName from RecordType where DeveloperName = 'GENERAL_2_Party_NDA' and SobjectType = 'Apttus__APTS_Agreement__c'];
               
               agr.RecordTypeId=recrdTypes[0].id;
               agr.Type__c='Technical NDA';
               agr.Apttus__Status_Category__c='Expired';
               agr.Apttus__Status__c='Expired';
                           
                                          
               update agr; 
               Test.stopTest();
               
               
                                             
          }
          
          
          
          
          public static testmethod void NDATest1()
          {
          
               test.startTest();      
               Apttus__APTS_Agreement__c agr=[select id,Name,GF_Contract_End_Date__c,GF_Contract_Start_Date__c from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
            
               List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'DS_2_Party_NDA' and SobjectType = 'Apttus__APTS_Agreement__c'];
                                           
               agr.RecordTypeId=recrdTypes[0].id;
               update agr;
               
               agr=[select id,Name,GF_Contract_End_Date__c,GF_Contract_Start_Date__c  from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
               
               System.assertNotEquals(agr.GF_Contract_End_Date__c,NULL);
               test.stopTest();
          }
          
          public static testmethod void NDATest2()
          {
          
               test.startTest();      
               Apttus__APTS_Agreement__c agr=[select id,Name,GF_Contract_End_Date__c,GF_Contract_Start_Date__c  from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
            
               List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'GENERAL_2_Party_NDA' and SobjectType = 'Apttus__APTS_Agreement__c'];
               
               agr.RecordTypeId=recrdTypes [0].id;
               agr.GF_Contract_Start_Date__c = date.today()+1;
               agr.GF_Contract_End_Date__c = NULL;             
               
               update agr;
               
               agr=[select id,Name,GF_Contract_End_Date__c,GF_Contract_Start_Date__c  from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
               
               System.assertEquals(agr.GF_Contract_End_Date__c,agr.GF_Contract_Start_Date__c.addYears(3).addDays(-1));
               test.stopTest();
          }
          
          public static testmethod void NDATest3()
          {
          
               test.startTest();      
               Apttus__APTS_Agreement__c agr=[select id,Name,GF_Contract_End_Date__c,GF_Contract_Start_Date__c  from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
            
               List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'GENERAL_2_Party_NDA' and SobjectType = 'Apttus__APTS_Agreement__c'];
               
               agr.RecordTypeId=recrdTypes [0].id;
               agr.GF_Contract_Start_Date__c = date.today()+1;
               agr.GF_Contract_End_Date__c = date.today()+13;             
               
               update agr;
               
               agr=[select id,Name,GF_Contract_End_Date__c,GF_Contract_Start_Date__c  from Apttus__APTS_Agreement__c where Name='NDATESTREC1' limit 1 ];
               
               System.assertEquals(agr.GF_Contract_End_Date__c,date.today()+13);
               test.stopTest();
          }
          
          
          
          }