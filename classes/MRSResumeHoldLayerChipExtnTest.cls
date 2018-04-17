/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@istest(SeeAllData=true)

public without sharing class MRSResumeHoldLayerChipExtnTest {
    /**
        @Method Name: MRSHoldResumeChip
        @Return type: null
        @Parameters: null
        @Description: Test Method for MRSHoldResumeChip
    **/
    public static testMethod void MRSHoldResumeChip() {
         Profile p = [SELECT Id FROM Profile Where Name = 'GF FAE/FTS'];
         User u = [Select Id,Name from User Where ProfileId = :p.Id And IsActive=true limit 1];
         Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
         User thisUser = [SELECT Id FROM User WHERE ProfileId =:sysAdminProfile.Id and isActive=true limit 1];
         
         Map<Id,Group> groupObj = new Map<Id,Group>([SELECT Name,Id FROM Group WHERE Name IN ('Swift Tapeout Centre','Swift Tapeout Application','Swift GlobalShuttle','Swift MDP','Swift TDTI-MPW','SWIFT Admin','Swift RMG')]);
         List<GroupMember> grpMemLst = new List<GroupMember>();
         GroupMember grpMemObj;
         for(Id grpId : groupObj.keySet()){
            grpMemObj = new GroupMember();
            grpMemObj.GroupId = grpId;
            grpMemObj.UserOrGroupId = u.Id;
            grpMemLst.add(grpMemObj);
         }
         //insert grpMemLst;
         
         Account acc;
         
         System.runAs (thisUser) {
             recordtype rt=[select id from recordtype where sobjecttype='Account' and developername='GLOBALFOUNDRIES_Internal'] ;
             //acc = [Select Id,Name from Account limit 1];
             acc = SwiftDataUtilityTest.createTestAccountForDRT();
             acc.stage__c = 'Qualified'; 
             update acc;
         }
        // Account acc = SwiftDataUtilityTest.createTestAccount();
         //System.runAs(u){
             Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('MPWMST');
            insert mst;
            PTRF__c ptrf = new PTRF__c(Name='BCOU',Order_Type__c = 'testOrder',Recticle_Type__c='Multi Layer Reticle (MLR)',Tech_Geo_Value__c='0.02UM',
            Customer_jobview__c='Gating Mask Release',MaskSetTitle__c=mst.Id,Customer__c=acc.Id,Maskshop__c='Mask1',PTRF_External_ID__c='BCOU',Device_Id__c = '7FA2');
            insert ptrf;
            MRS__c mrs = new MRS__c(Full_Sync__c =true,Synced_with_Oracle_DB__c=false,MRS_Package_Sync__c=false,Mask_Set_Title__c=mst.Id);                                   
            insert mrs;
            System.assertEquals('BCOU',ptrf.Name);
            MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='layer001',
                                                                              Synced_with_Oracle_DB__c=false,
                                                                              Mask_Layer_Rev__c = '899',
                                                                              Layer_Name__c = 'testLayer001',
                                                                              Layer_Status__c = 'In Progress',
                                                                              ROM_Code__c='01',
                                                                              mrs__c = mrs.id);
            insert mrslayer1;                                                                                                                                  
            MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip001',
                                                                   Synced_with_Oracle_DB__c=false,
                                                                   mrs__c = mrs.id);
            insert mrsChip1;                                                     
            MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c(Name='layerChip001',
                                                                                         Synced_with_Oracle_DB__c=false,
                                                                                         Send_Prime_Data__c = 'Not Done',
                                                                                         Layer__c=mrsLayer1.Id,
                                                                                         Chip__c=mrsChip1.Id,
                                                                                         PTRF__c=ptrf.Id,
                                                                                         Tech_Geo__c='0.02UM',
                                                                                         Customer_Name__c=acc.Id);
            insert layerChip1;
             Maskshop_Configuration__c objMC= new Maskshop_Configuration__c(Name='Mask1');                                   
            insert objMC;
            
            Released_Mask_Write_Distribution_List__c objRMWDL=new Released_Mask_Write_Distribution_List__c(Maskshop__c=objMC.Id,Distribution_List__c='tripti.bhalkundi@cognizant.com');
            insert objRMWDL;
            Test.StartTest();
            PageReference myVfPage = Page.VFMRSResumeHoldLayerChip;
            Test.setCurrentPage(myVfPage);
            ApexPages.currentPage().getHeaders().put('Host',Label.SWIFT_Community_URL);
            ApexPages.StandardController sc = new ApexPages.StandardController(new MRS__c());
            MRSResumeHoldLayerChipExtn holdResumeChipObj = new MRSResumeHoldLayerChipExtn(sc);
            holdResumeChipObj.selectedCustomerId = acc.Id;
            holdResumeChipObj.selectedMSTId = mst.Id;
            holdResumeChipObj.SelectedMrsLayerId = mrsLayer1.Id;
            //holdResumeChipObj.selectedlayerStatus = 'In Progress';
            holdResumeChipObj.selectedDeviceId = '7FA2';
            holdResumeChipObj.selectedTechGeo = '0.02UM';
            holdResumeChipObj.getMRSLayerChipAssociation();
            apexpages.currentpage().getparameters().put('customerId',acc.Id);
            apexpages.currentpage().getparameters().put('MSTID',mst.Id);
            holdResumeChipObj.getUrlParameters();
            List<MRSResumeHoldLayerChipExtn.MRSLayerChipWrapper> lstmrsChipWrapper = new List<MRSResumeHoldLayerChipExtn.MRSLayerChipWrapper>();
            MRSResumeHoldLayerChipExtn.MRSLayerChipWrapper mrsChipWrapper = new MRSResumeHoldLayerChipExtn.MRSLayerChipWrapper(layerChip1,2,true,true);
            mrsChipWrapper.mrs = layerChip1;
            mrsChipWrapper.layerId = 'testLayerId';
            mrsChipWrapper.layerName='layer001';
            mrsChipWrapper.layerChipStatus='In Progress';
            mrsChipWrapper.count=1;
            mrsChipWrapper.isChecked=true;
            mrsChipWrapper.ptrfOrDRTName='testName';
            lstmrsChipWrapper.add(mrsChipWrapper);
            holdResumeChipObj.mrsWrapperLists=lstmrsChipWrapper;
            holdResumeChipObj.displayChipProceedData();
            holdResumeChipObj.colorOnProceed=false;
            holdResumeChipObj.displayChipProceedData();
            holdResumeChipObj.arrPTRFids=layerChip1.Id;
            holdResumeChipObj.getMRSTblData();
            holdResumeChipObj.getMSTchipLayer();
            holdResumeChipObj.exportToCSV();
            holdResumeChipObj.exportToExcel();
            holdResumeChipObj.anfn_discard();
            holdResumeChipObj.acfn_discardHold();
            holdResumeChipObj.acfn_refreshTableChip();
            holdResumeChipObj.isChecking=false;
            holdResumeChipObj.isCheckBoxTrue();
            holdResumeChipObj.IsCommentBlank();
            holdResumeChipObj.isHold=true;
            holdResumeChipObj.comments = 'testComment';
            holdResumeChipObj.chipLayerUpdateOnProceed();
            List<Id> mstIds = new List<Id>();
            mstIds.add(mst.Id);
            List<MRS_Layer_Chip_Association__c> lstMLCA=[select Name,Synced_with_Oracle_DB__c,Send_Prime_Data__c,Layer__c,Chip__c,PTRF__c,Device_Id__c,Tech_Geo__c,Customer_Name__c,Layer__r.Name,Layer__r.Mask_Layer_Rev__c,Layer__r.ROM_Code__c,Layer__r.Layer_Status__C,PTRF__r.Maskshop__c,Layer__r.MRS__r.Mask_Set_Title__r.Name,Chip__r.Name,PTRF__r.Name from MRS_Layer_Chip_Association__c where Id=:layerChip1.Id];
            holdResumeChipObj.sendEmailOnHoldResume(lstMLCA,userInfo.getUserId(),true,'axus');          
            holdResumeChipObj.clearFilter();
            holdResumeChipObj.oldLayerStatus = 'Released';
            holdResumeChipObj.sendEmailOnHoldResumeToExternalGroup(lstMLCA,mstIds,userInfo.getUserId(),true,'axus');
            Test.StopTest();
        //}
      }         
        
    public static testMethod void testAddIn1() {
        
        PageReference myVfPage = Page.VFMRSResumeHoldLayerChip;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getHeaders().put('Host',Label.SWIFT_Community_URL);
        ApexPages.StandardController sc = new ApexPages.StandardController(new MRS__c());
        MRSResumeHoldLayerChipExtn testIt = new MRSResumeHoldLayerChipExtn(sc);
        
        test.startTest();
        try { testIt.commentIsNull = 'commentIsNull';
        testIt.IsCommentBlank(); } catch(exception e) {}
        
        //====
        
        try {MRSResumeHoldLayerChipExtn.MRSLayerChipWrapper wapp= new MRSResumeHoldLayerChipExtn.MRSLayerChipWrapper(new MRS_Layer_Chip_Association__c(), 1, true, true);
        list<MRSResumeHoldLayerChipExtn.MRSLayerChipWrapper> wappp = new list<MRSResumeHoldLayerChipExtn.MRSLayerChipWrapper>();
        wappp.add(wapp);
        testIt.colorOnProceed = false;
        testIt.mrsWrapperLists = wappp;
        testIt.anfn_discard(); } catch(exception e) {}
        
        testIt.showError = true;
        
        
        test.stopTest();
    }
}