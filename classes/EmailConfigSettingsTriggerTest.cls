/*
Type Name: EmailCinfigSettingsTriggerTest
Author: Cognizant
Created Date: 27-Nov-2014
Reason: Test class for Email_Config_Settings_CheckDuplicateTemplateName  trigger
Change History:
Author:
Modified Date:
Reason:
Author: Cognizant Technology Solutions
Modified Date:
……..
……..
*/


@istest(SeeAllData=false)
public class EmailConfigSettingsTriggerTest
{
    public static testMethod void TestMethod1()
    {
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser){
        
        RecordType   RTPTRF = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType where SobjectType  = 'Email_Config_Settings__c' AND DeveloperName = 'PTRF'];
        
        RecordType   RTMST = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType where SobjectType  = 'Email_Config_Settings__c' AND DeveloperName = 'MST'];
           
        RecordType   RTMaskShop = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType where SobjectType  = 'Email_Config_Settings__c' AND DeveloperName = 'Maskshop'];
                                  
        RecordType   RTNoLayer = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType where SobjectType  = 'Email_Config_Settings__c' AND DeveloperName = 'MST_No_Mask_Layers'];                                         
       
        
                                   
        Email_Config_Settings__c objConfig1 = null;
        Email_Config_Settings__c objConfig2 = null;
        Email_Config_Settings__c objConfig3 = null;
        Email_Config_Settings__c objConfig4 = null;
        
         objConfig1 = new Email_Config_Settings__c();                    
         objConfig1.Email_Template_Name__c= 'Temp1';
         objConfig1.RecordTypeId = RTPTRF.ID;
         objConfig1.Available_For_Use__c = true;
         objConfig1.Tech_Geo_Value__c = '0.01';
         objConfig1.Gating_Jobview__c = 'Y';
         objConfig1.MPW_PTRF__c = true;
         insert  objConfig1; 
         
         objConfig1.Gating_Jobview__c = 'NA'; 
         update objConfig1;
         
         objConfig2 = new Email_Config_Settings__c(); 
         objConfig2.Email_Template_Name__c= 'Temp2';
         objConfig2.RecordTypeId = RTMST.ID;
         objConfig2.Available_For_Use__c = true;
         objConfig2.Tech_Geo_Value__c = '0.01';
         objConfig2.Gating_Jobview__c = 'Y';
         objConfig2.MPW_PTRF__c = true;
         insert  objConfig2;
         
         objConfig2.MPW_PTRF__c = false; 
         
         update objConfig2;
         
          objConfig3 = new Email_Config_Settings__c(); 
         objConfig3.Email_Template_Name__c= 'Temp3';
         objConfig3.RecordTypeId = RTMaskShop.ID;
         objConfig3.Available_For_Use__c = true;
         objConfig3.Tech_Geo_Value__c = '0.01';
         objConfig3.Gating_Jobview__c = 'Y';
         objConfig3.MPW_PTRF__c = true;
         insert  objConfig3; 
         
         objConfig3.Gating_Jobview__c = 'N';
         update objConfig3;
         
         
          objConfig4 = new Email_Config_Settings__c(); 
         objConfig4.Email_Template_Name__c= 'Temp4';
         objConfig4.RecordTypeId = RTNoLayer.ID;
         objConfig4.Available_For_Use__c = true;
         objConfig4.Tech_Geo_Value__c = '0.01';
         objConfig4.Gating_Jobview__c = 'Y';
         objConfig4.MPW_PTRF__c = true;
         insert  objConfig4; 
         
         objConfig4.Gating_Jobview__c = 'N';
         update objConfig4;
         
         
         
        }
        
           
    }
}