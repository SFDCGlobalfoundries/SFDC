/*
Type Name: MRSVoidChipExtnTest
Author: Cognizant 
Created Date: 30-May-2014
Reason: 
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
��..
��..
*/
@istest(SeeAllData = false)
public class MRSVoidChipExtnTest {
    public static Account accountObj;
    public static void TestFrameMockupAccountInsert() {
        SwiftDataUtilityTest.customSystemData();
        accountObj = SwiftDataUtilityTest.createTestAccountForDRT();
        System.assertNotEquals(accountObj, null);
        accountObj.stage__c = 'Qualified';
        update accountObj;

    }
    static {
        TestFrameMockupAccountInsert();
    }
    /**
 @ method: TestVoidChip
 @ param: null
 @ return: void
 @ description: This method will check Void Chips
**/
    public static testMethod void TestCustomerFrameMockupDataRetreivalExtn() {


        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
        AND isActive = true].get(0);

        Mask_Set_Title__c objMST = MRSDataUtilityTest.createMST();

        List < Mask_Set_Title__c > lstMST = [select name from Mask_Set_Title__c limit 1];

        MRS__c mrs = MRSDataUtilityTest.createTestMRS(objMST.id);
        List < MRS__c > lstMRS = [select id, name from MRS__c limit 1];


        MRS_Layer_Association__c mrsLA = MRSDataUtilityTest.createTestMRSLayerAssociation(mrs.Id);
        List < MRS_Layer_Association__c > lstMLA = [select name from MRS_Layer_Association__c limit 1];


        MRS_Chip_Details__c mrsCD = MRSDataUtilityTest.createTestMRSChipDetails(mrs.Id);

        List < MRS_Chip_Details__c > lstMCD = [select name from MRS_Chip_Details__c limit 1];

        Opportunity oppr = SwiftDataUtilityTest.createOpportunityDRT(accountObj.Id);

        Opportunity_Program__c opprProg = SwiftDataUtilityTest.createOpportunityProgramDRT(accountObj.Id, oppr.Id);
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
        
        Test.startTest();
        
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(accountObj.Id, oppr.Id,opprProg.Id, pt.Id);
        
        PTRF__c PTRFobj = SwiftDataUtilityTest.createPTRFForMRS(objMST.id, testDevice.Id, accountObj.Id);

        List < PTRF__c > lstPTRF = [select name from PTRF__c Limit 1];

        //PTRFobj.Status__c = 'Perform Tapeout Options';
        //update PTRFobj;

        MRS_Layer_Chip_Association__c mrsLCA = MRSDataUtilityTest.createTestMRSLayerChipAssociation(mrsLA.Id, mrsCD.Id, PTRFobj.Id);


        List < MRS_Layer_Chip_Association__c > lstMLCA1 = [select name from MRS_Layer_Chip_Association__c limit 1];


        if (lstMLA != null) {
            for (MRS_Layer_Association__c mrsLayerObj: lstMLA) {
                mrsLayerObj.Layer_Status__c = 'In Progress';
            }
        }
        //update lstMLA ;

        if (mrsLCA != null) {
            for (MRS_Layer_Chip_Association__c mrsLayerchipObj: lstMLCA1) {
                // mrsLayerchipObj.Tech_Geo__c ='In Progress';
                mrsLayerchipObj.Layer_Chip_Status__c = 'In Progress';
                mrsLayerchipObj.Tech_Geo__c = '0.019UM';

            }
        }

        //update mrsLCA;

        System.runAs(sysAdminUser) {

            /** Test started  **/

            Test.setCurrentPageReference(new PageReference(Label.SWIFT_Community_URL + 'VFMRSVoidChip'));
            System.currentPageReference().getParameters().put('id', mrsLCA.Id);
            ApexPages.currentPage().getHeaders().put('Host', 'Others');
            MRSVoidChipExtn mrsVoidChipExtn0 = new MRSVoidChipExtn(new apexpages.StandardController(mrsLCA));
            mrsVoidChipExtn0.discard();
            ApexPages.currentPage().getHeaders().put('Host', Label.Swift_Host_URL);
            MRSVoidChipExtn mrsVoidChipExtn = new MRSVoidChipExtn(new apexpages.StandardController(mrsLCA));
            mrsVoidChipExtn.voidReason = '';
            mrsVoidChipExtn.proceed();
            mrsVoidChipExtn.voidReason = 'Void';
            mrsVoidChipExtn.proceed();
            /** System asserts **/


            List < MRS_Layer_Chip_Association__c > lstMRSLCA = new List < MRS_Layer_Chip_Association__c > ();
            lstMRSLCA = [select Id, Name, Layer_Chip_Status__c, PTRF__r.Tech_Geo__c from MRS_Layer_Chip_Association__c where Id = : mrsLCA.Id and Layer_Chip_Status__c = : 'Void'];
            system.assert(lstMRSLCA.size() != null);

            mrsVoidChipExtn.discard();
            mrsVoidChipExtn.exportToCSV();
            mrsVoidChipExtn.exportToExcel();
            mrsVoidChipExtn.retreiveTableAfterSave();
            mrsVoidChipExtn.sendEmail();
            /** System asserts **/
            System.assertEquals(mrsVoidChipExtn.voidReason, 'Void');
            Test.stopTest();
            /** Test Eneded **/
        }
    }

    /**
 @ method: TestVoidChip
 @ param: null
 @ return: void
 @ description: This method will check Void Chips
**/
    public static testMethod void TestCustomerFrameMockupDataRetreivalExtn2() {
        User sysAdminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'
        AND isActive = true].get(0);

        Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
        insert objMST;

        List < Mask_Set_Title__c > lstMST = [select name from Mask_Set_Title__c limit 1];

        MRS__c mrs = MRSDataUtilityTest.createTestMRS(objMST.id);
        List < MRS__c > lstMRS = [select id, name from MRS__c limit 1];

        MRS_Layer_Association__c mrsLA = MRSDataUtilityTest.createTestMRSLayerAssociation(mrs.Id);
        List < MRS_Layer_Association__c > lstMLA = [select name from MRS_Layer_Association__c limit 1];

        MRS_Chip_Details__c mrsCD = MRSDataUtilityTest.createTestMRSChipDetails(mrs.Id);

        List < MRS_Chip_Details__c > lstMCD = [select name from MRS_Chip_Details__c limit 1];


        Opportunity oppr = SwiftDataUtilityTest.createOpportunityDRT(accountObj.Id);

        Opportunity_Program__c opprProg = SwiftDataUtilityTest.createOpportunityProgramDRT(accountObj.Id, oppr.Id);
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
        
        Test.startTest();
        
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(accountObj.Id, oppr.Id,opprProg.Id, pt.Id);

        PTRF__c PTRFobj = createPTRFForMRS(objMST.id, testDevice.Id, accountObj.Id);

        List < PTRF__c > lstPTRF = [select name from PTRF__c Limit 1];

        //PTRFobj.Status__c = 'Perform Tapeout Options';
        //update PTRFobj;

        MRS_Layer_Chip_Association__c mrsLCA = MRSDataUtilityTest.createTestMRSLayerChipAssociation(mrsLA.Id, mrsCD.Id, PTRFobj.Id);


        List < MRS_Layer_Chip_Association__c > lstMLCA1 = [select name from MRS_Layer_Chip_Association__c limit 1];


        if (lstMLA != null) {
            for (MRS_Layer_Association__c mrsLayerObj: lstMLA) {
                mrsLayerObj.Layer_Status__c = 'In Progress';
            }
        }
        //update lstMLA ;

        if (mrsLCA != null) {
            for (MRS_Layer_Chip_Association__c mrsLayerchipObj: lstMLCA1) {
                // mrsLayerchipObj.Tech_Geo__c ='In Progress';
                mrsLayerchipObj.Layer_Chip_Status__c = 'In Progress';
                mrsLayerchipObj.Tech_Geo__c = '0.019UM';

            }
        }

        //update mrsLCA;

        System.runAs(sysAdminUser) {

            /** Test started  **/

            // List<MRS_Layer_Association__c> mrsLayerAssolst =SwiftDataUtilityTest.getMRSLayerAsso(); 

            //mrsLayerChipAssolst.get(0).Tech_Geo__c = '0.019UM';
            //update mrsLayerChipAssolst.get(0);

            Test.setCurrentPageReference(new PageReference(Label.SWIFT_Community_URL + 'VFMRSVoidChip'));
            System.currentPageReference().getParameters().put('id', mrsLCA.Id);
            ApexPages.currentPage().getHeaders().put('Host', 'Others');
            MRSVoidChipExtn mrsVoidChipExtn0 = new MRSVoidChipExtn(new apexpages.StandardController(mrsLCA));
            mrsVoidChipExtn0.discard();
            ApexPages.currentPage().getHeaders().put('Host', Label.Swift_Host_URL);
            MRSVoidChipExtn mrsVoidChipExtn = new MRSVoidChipExtn(new apexpages.StandardController(mrsLCA));
            //            mrsVoidChipExtn.voidReason ='';
            //          mrsVoidChipExtn.proceed();
            mrsVoidChipExtn.voidReason = 'Void';
            mrsVoidChipExtn.proceed();
            /** System asserts **/


            List < MRS_Layer_Chip_Association__c > lstMRSLCA = new List < MRS_Layer_Chip_Association__c > ();
            lstMRSLCA = [select Id, Name, Layer_Chip_Status__c, PTRF__r.Tech_Geo__c from MRS_Layer_Chip_Association__c where Id = : mrsLCA.Id and Layer_Chip_Status__c = : 'Void'];
            system.assert(lstMRSLCA.size() != null);

            mrsVoidChipExtn.discard();
            mrsVoidChipExtn.exportToCSV();
            mrsVoidChipExtn.exportToExcel();
            mrsVoidChipExtn.retreiveTableAfterSave();
            mrsVoidChipExtn.sendEmail();
            /** System asserts **/
            System.assertEquals(mrsVoidChipExtn.voidReason, 'Void');
            Test.stopTest();
            /** Test Eneded **/
        }
    }


    public static PTRF__c createPTRFForMRS(Id mstId, Id deviceId, Id accId) {
        PTRF__c p = new PTRF__c();
        p.Name = 'PTRF1';
        p.Device__c = deviceId;
        p.Customer__c = accId;
        p.Device_Id__c = deviceId;
        //p.Transaction_Type__c = 'LIFECYCLE';
        p.Transaction_Date__c = date.today();
        p.Order_Type__c = 'TEST';
        p.Prime_Tapeout__c = true;
        p.Frame_Tapeout__c = true;
        p.Frame_Mockup__c = true;
        p.Prime_GDSOUT_Review__c = true;
        p.Mask_Set_Title__c = mstId;
        p.MaskSetTitle__c = mstId;
        p.Status__c = 'Active';
        p.Recticle_Type__c = 'Multi Node Reticle (MNR)';
        p.Tech_Geo_Value__c = '0.01UM';
        insert p;

        return p;
    }

}