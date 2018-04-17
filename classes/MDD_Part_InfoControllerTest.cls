/* 
 Type Name: MDD_Part_InfoControllerTest
 Author: JKTechnosoft
 Created Date: 13-July-2016
 Reason: Test Class for MDD_Part_InfoController
 
 */
@isTest
public class MDD_Part_InfoControllerTest {
    public static testMethod void MDD_Part_InfoControllerTestMethod(){
        MDD_ERP_Update__c md = MDD_ERP_Update__c.getInstance('ERP Updates');
        if(md == null){
        	MDD_ERP_Update__c mdERP = new MDD_ERP_Update__c();
            mdERP.Name = 'ERP Updates';
            mdERP.Is_Active__c = true;
            insert mdERP;
        }
        Part__c p = new Part__c();
        p.Part_Number__c = '0000000001';
        p.Part_Family__c = 'test family';
        p.Part_Type__c = 'FC PBGA';
        insert p;
        Part__c p1 = new Part__c();
        p1.Part_Number__c = '0000000002';
        p1.Part_Family__c = 'test family2';
        p1.Part_Type__c = 'FC PBGA';
        insert p1;
        Part_Family__c f = new Part_Family__c();
        f.Name = 'test family';
        insert f;
        List<Homogenous_Information__c> lsthomo = new List<Homogenous_Information__c>();
        Homogenous_Information__c h = new Homogenous_Information__c();
        h.CAS_Number__c = '1111';
        h.Homogenous_material__c = 'test';
        h.Homogenous_Material_Weight__c = 5;
        h.Part__c = p.Id;
        h.IsActive__c = true;
        h.PPM_of_substance__c = 10.00;
        h.Homogenous_Material_Weight__c = 20.00;
        lsthomo.add(h);
        Homogenous_Information__c h1 = new Homogenous_Information__c();
        h1.CAS_Number__c = '1111';
        h1.Homogenous_material__c = 'test';
        h1.Homogenous_Material_Weight__c = 5;
        h1.Part__c = p.Id;
        h1.PPM_of_substance__c = 10.00;
        h1.Homogenous_Material_Weight__c = 20.00;
        h1.IsActive__c = true;
        lsthomo.add(h1);
        Homogenous_Information__c h2 = new Homogenous_Information__c();
        h2.CAS_Number__c = '1111';
        h2.Homogenous_material__c = 'ink';
        h2.Homogenous_Material_Weight__c = 5;
        h2.Part__c = p1.Id;
        h2.IsActive__c = true;
        h2.PPM_of_substance__c = 10.00;
        h2.Homogenous_Material_Weight__c = 20.00;
        lsthomo.add(h2);
        insert lsthomo;
        Exemption__c e = new Exemption__c();
        e.Exemption__c = 'Test';
        e.Part__c = p.Id;
        insert e;
        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        system.currentPageReference().getParameters().put('partId', p.Id);
        MDD_Part_InfoController mdd = new MDD_Part_InfoController();
        mdd.familyId = f.Id;
        mdd.callPartFamily();
        mdd.ExportWord();
        mdd.DownloadXML();
    }
}