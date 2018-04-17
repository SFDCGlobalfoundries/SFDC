/* 
 Type Name: MDD_XML_DownloadContTest
 Author: JKTechnosoft
 Created Date: 13-July-2016
 Reason: Test Class for MDD_XML_DownloadCont
 
 */
@isTest
public class MDD_XML_DownloadContTest {
    public static testMethod void MDD_XML_DownloadContTestMethod(){
        Part__c p = new Part__c();
        p.Part_Number__c = '0000000001';
        p.Part_Family__c = 'test family';
        p.Part_Type__c = 'FC PBGA';
        insert p;
        List<Homogenous_Information__c> lstHomo = new List<Homogenous_Information__c>();
        Homogenous_Information__c h = new Homogenous_Information__c();
        h.CAS_Number__c = '1111';
        h.Homogenous_material__c = 'test';
        h.Homogenous_Material_Weight__c = 5;
        h.Part__c = p.Id;
        lstHomo.add(h);
        Homogenous_Information__c h1 = new Homogenous_Information__c();
        h1.CAS_Number__c = '1111';
        h1.Homogenous_material__c = 'test';
        h1.Homogenous_Material_Weight__c = 5;
        h1.Part__c = p.Id;
        lstHomo.add(h1);
        insert lstHomo;
        Exemption__c e = new Exemption__c();
        e.Exemption__c = 'name test';
        e.Part__c = p.Id;
        insert e;
        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        system.currentPageReference().getParameters().put('id', p.Id);
        MDD_XML_DownloadCont mdd = new MDD_XML_DownloadCont();
        mdd.XFDFInit();
    }
}