@isTest(SeeAllData=false)
public class EmailConfigSettingsCondtnValidationTest {
    @isTest
    public static void ECSConditionValidationTest(){
        
        EmailConfigSettingsUtility.runOnce();
        
        Id ptrfRecordTypeId = EmailConfigSettingsUtility.fetchRecordTypeId('PTRF');
        Id mstRecordTypeId = EmailConfigSettingsUtility.fetchRecordTypeId('MST');
        Id maskshopRecordTypeId = EmailConfigSettingsUtility.fetchRecordTypeId('Maskshop');
        Id mstNoMaskLayerRecordTypeId = EmailConfigSettingsUtility.fetchRecordTypeId('MST-No Mask Layers');
        
        createECSObject(ptrfRecordTypeId);
        createECSObject(mstRecordTypeId);
        createECSObject(maskshopRecordTypeId);
        createECSObject(mstNoMaskLayerRecordTypeId);
        
    }
    
    @isTest
    public static void ECSConditionValidationForUpdateTest(){
        
        Id ptrfRecordTypeId = EmailConfigSettingsUtility.fetchRecordTypeId('PTRF');
        Id mstRecordTypeId = EmailConfigSettingsUtility.fetchRecordTypeId('MST');
        Id maskshopRecordTypeId = EmailConfigSettingsUtility.fetchRecordTypeId('Maskshop');
        Id mstNoMaskLayerRecordTypeId = EmailConfigSettingsUtility.fetchRecordTypeId('MST-No Mask Layers');
        
        updateECSObject(ptrfRecordTypeId);
        updateECSObject(mstRecordTypeId);
        updateECSObject(maskshopRecordTypeId);
        updateECSObject(mstNoMaskLayerRecordTypeId);
    }
    
    
    public static void createECSObject(Id genericRecordTypeId){
        Email_Config_Settings__c ecs1 = new Email_Config_Settings__c(Available_For_Use__c=true,BCC__c='test@test.com',CC__c='test@test.com',
        Customer_Jobviewer_Type__c='Prime GDSOUT Review',Email_Template_Name__c='testTemplate',Foundry_Jobviewer_Type__c='MEBES Jobview',
        Gating_Jobview__c='Y',MPW_PTRF__c=true,RecordTypeId=genericRecordTypeId,TO__c='test@test.com',Tech_Geo_Value__c='0.01');
        
        insert ecs1;
        
        Email_Config_Settings__c fetchECS = [SELECT RecordType.DeveloperName, Email_Template_Name__c ,Gating_Jobview__c,MPW_PTRF__c,Name,RecordTypeId,Tech_Geo_Value__c FROM Email_Config_Settings__c limit 1];
        system.assertEquals(fetchECS.Email_Template_Name__c, ecs1.Email_Template_Name__c);
        system.debug('fetchECS.Email_Template_Name__c='+fetchECS.Email_Template_Name__c);
        
        Email_Config_Settings__c ecs2 = new Email_Config_Settings__c(Available_For_Use__c=true,BCC__c='test@test.com',CC__c='test@test.com',
        Customer_Jobviewer_Type__c='Prime GDSOUT Review',Email_Template_Name__c='testTemplate',Foundry_Jobviewer_Type__c='MEBES Jobview',
        Gating_Jobview__c='Y',MPW_PTRF__c=true,RecordTypeId=genericRecordTypeId,TO__c='test@test.com',Tech_Geo_Value__c='0.01');
        
        try{
        insert ecs2;
        }catch(Exception e){}
        
        
        Email_Config_Settings__c ecs3 = new Email_Config_Settings__c(Available_For_Use__c=true,BCC__c='test@test.com',CC__c='test@test.com',
        Customer_Jobviewer_Type__c='Prime GDSOUT Review',Email_Template_Name__c='testTemplate',Foundry_Jobviewer_Type__c='MEBES Jobview',
        Gating_Jobview__c='Y',MPW_PTRF__c=true,RecordTypeId=genericRecordTypeId,TO__c='test@test.com',Tech_Geo_Value__c='0.01;0.02');
        
        try{
        insert ecs3;
        }catch(Exception e){}
    }
    
    public static void updateECSObject(Id genericRecordTypeId){
        Email_Config_Settings__c ecs1 = new Email_Config_Settings__c(Available_For_Use__c=true,BCC__c='test@test.com',CC__c='test@test.com',
        Customer_Jobviewer_Type__c='Prime GDSOUT Review',Email_Template_Name__c='testTemplate',Foundry_Jobviewer_Type__c='MEBES Jobview',
        Gating_Jobview__c='Y',MPW_PTRF__c=true,RecordTypeId=genericRecordTypeId,TO__c='test@test.com',Tech_Geo_Value__c='0.01');
        
        insert ecs1;
        
        Email_Config_Settings__c ecs2 = new Email_Config_Settings__c(Available_For_Use__c=true,BCC__c='test@test.com',CC__c='test@test.com',
        Customer_Jobviewer_Type__c='Prime GDSOUT Review',Email_Template_Name__c='testTemplate',Foundry_Jobviewer_Type__c='MEBES Jobview',
        Gating_Jobview__c='Y',MPW_PTRF__c=true,RecordTypeId=genericRecordTypeId,TO__c='test@test.com',Tech_Geo_Value__c='0.02;0.03');
        try{
        insert ecs2;
        }
        catch(Exception e){}
        
        Email_Config_Settings__c fetchECS = [SELECT RecordType.DeveloperName, Email_Template_Name__c ,Gating_Jobview__c,MPW_PTRF__c,Name,RecordTypeId,Tech_Geo_Value__c FROM Email_Config_Settings__c limit 1];
        system.assertEquals(fetchECS.Email_Template_Name__c, ecs1.Email_Template_Name__c);
        system.debug('fetchECS.Email_Template_Name__c='+fetchECS.Email_Template_Name__c);
        
        ecs2.Tech_Geo_Value__c='0.01';
        
        try{
        update ecs2;
        }catch(Exception e){}
        
        ecs2.Tech_Geo_Value__c='0.01;0.02';
        
        try{
        update ecs2;
        }catch(Exception e){}
    }
}