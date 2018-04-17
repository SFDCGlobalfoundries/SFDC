/* 
 Type Name: MDD_ChinaRohs_controllerTest
 Author: JKTechnosoft
 Created Date: 13-July-2016
 Reason: Test class for MDD_ChinaRohs_controller controller
 
 */
@isTest
public class MDD_ChinaRohs_controllerTest {
    public static testMethod void MDDChinaROHSMethod(){
        List<MDD_ChinaROHS_Contents__c> lstM = new List<MDD_ChinaROHS_Contents__c>();
        MDD_ChinaROHS_Contents__c m = new MDD_ChinaROHS_Contents__c();
        m.Name = 'Line1';
        m.Content__c = 'Test';
        lstM.add(m);
        MDD_ChinaROHS_Contents__c m1 = new MDD_ChinaROHS_Contents__c();
        m1.Name = 'Section11';
        m1.Content__c = 'Test';
        lstM.add(m1);
        MDD_ChinaROHS_Contents__c m2 = new MDD_ChinaROHS_Contents__c();
        m2.Name = 'Section22';
        m2.Content__c = 'Test';
        lstM.add(m2);
        MDD_ChinaROHS_Contents__c m3 = new MDD_ChinaROHS_Contents__c();
        m3.Name = 'Section33';
        m3.Content__c = 'Test';
        lstM.add(m3);
        insert lstM;
        MDD_ChinaROHS_controller c = new MDD_ChinaROHS_controller();
        c.str = '';
        c.str1 = '';
        c.str2 = '';
        c.str3 = '';
    }
}