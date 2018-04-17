/*
Type Name: MRSLayerSummaryExtnTest
Author: Cognizant 
Created Date: 23-May-2014
Change History:
Cognizant            28082014     -      Code comments updated

??..
??..
*/
@istest(SeeAllData=false)
public class MRSLayerSummaryExtnTest{

public static MRS_Chip_Details__c MRSChipDetails;
public static MRS__c MRSObject;
public static Account objAccount;
public static Account objAccount2;
public static Mask_Set_Title__c objMST;
public static ID IDOpportunity;
public static ID IDOpportunityProgram;
public static Process_Technology__c objProcessTechnology;
public static Device__c objDevice;
public static List<PTRF__c> listPTRF;
public static PTRF__c objPTRF;
public static PTRF__c objPTRF2;
public static Mask_Layer__c objLayer;
public static Mask_Layer__c objLayer2;
public static Chip_Detail__c objChip1;
public static Chip_Detail__c objChip11;
public static Chip_Detail__c objChip2;
public static Chip_Detail__c objChip21;
public static Chip_Detail__c objChip3;
public static Chip_Detail__c objChip31;
public static MRS_Layer_Summary_Refresh_Interval__c refreshInterval;
public static Environment_Variable__c env;
public static MRS_Layer_Association__c MRSLAObj1;
public static MRS_Layer_Association__c MRSLAObj2;
public static MRS_Layer_Chip_Association__c MRSLCAObj1;
public static MRS_Layer_Chip_Association__c MRSLCAObj2;
public static User sysAdminUser;{sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);}

/**
    This method is for creating test data : account
    @method name: TestAccountInsert
    @parameter:   None
    @return :     None
**/       
    public static void TestAccountInsert(){
            SwiftDataUtilityTest.customSystemData();
            objAccount = SwiftDataUtilityTest.createTestAccountForDRT();
            System.assertNotEquals(objAccount,null);
                objAccount.stage__c = 'Qualified';
                update objAccount;
                
    }

/**
    This method is for creating test data : account team proxy
    @method name: InsertAccountTeamProxy
    @parameter:   None
    @return :     None
**/     
    public static void InsertAccountTeamProxy(User u1, Account acc){
    Account_Team_Proxy__c atp = new Account_Team_Proxy__c(
                        User__c = u1.id,
                        Account__c=acc.id,
                        Account_Access__c='Read/Write',
                        Opportunity_Access__c='Read/Write',
                        Team_Role__c='Field Application Engineer',
                        Sequence_No__c='1',
                        Account_Role_ID__c='test1239'
                );
      insert atp;
      system.assertNotEquals(atp.Id, null);        
    }

/*
This is the static block
*/    
    static{
        TestAccountInsert();
        CreateData();
    }

/**
    This is the wrapper method is for creating test data
    @method name: CreateData
    @parameter:   None
    @return :     None
**/ 
    public static void CreateData(){
                 createPermissionConfigValues();
                 Customer_Layer_Summary_Permission__c CLSP = createCustomerPermission();
                 System.assertNotEquals(CLSP.Id,null);
                 
                 objMST=SwiftDataUtilityTest.createMST('MPW1001');
                 insert objMST;
                 System.assertNotEquals(objMST.Id,null);

                 listPTRF = new List<PTRF__c>();
                 
                 objPTRF= createPTRF('PTRF 000 1001',objMST,'Device1'); 
                 System.assertNotEquals(objPTRF.Id,null);
                  
                 objPTRF2= createPTRF('PTRF 000 1002',objMST,'Device1');           
                 System.assertNotEquals(objPTRF2.Id,null);
                 
                 objLayer= createMaskLayer(objPTRF,objMST,'MLN001','AZ','01'); 
                 System.assertNotEquals(objLayer.Id,null);
                             
                 objLayer2= createMaskLayer(objPTRF2,objMST,'MLN002','BZ','02');
                 System.assertNotEquals(objLayer2.Id,null);
                 
                 MRSObject = createMRS();
                 System.assertNotEquals(MRSObject.Id,null);
                 
                 MRSChipDetails = createMRSChipDetail(String.valueOf(objMST.Name),String.valueOf(MRSObject.Id));
                 System.assertNotEquals(MRSChipDetails.Id,null);
                                  
                 MRSLAObj1 = createMRSData(String.valueOf(objLayer.Name), String.valueOf(objLayer.Mask_Layer_Rev__c), String.valueOf(objMST.Name), String.valueOf(MRSObject.Id));
                 System.assertNotEquals(MRSLAObj1.Id,null);
                 
                 MRSLAObj2 = createMRSData(String.valueOf(objLayer2.Name), String.valueOf(objLayer2.Mask_Layer_Rev__c), String.valueOf(objMST.Name), String.valueOf(MRSObject.Id));
                 System.assertNotEquals(MRSLAObj2.Id,null);
                 
                 MRSLCAObj1 = createMRSLCAData(String.valueOf(MRSChipDetails.Id), String.valueOf(objPTRF.Id), String.valueOf(objAccount.id), String.valueOf(MRSLAObj1.Id),String.valueOf(objMST.Name));
                 System.assertNotEquals(MRSLCAObj1.Id,null);
                 
                 MRSLCAObj2 = createMRSLCAData(String.valueOf(MRSChipDetails.Id), String.valueOf(objPTRF.Id), String.valueOf(objAccount.id), String.valueOf(MRSLAObj2.Id),String.valueOf(objMST.Name));
                 System.assertNotEquals(MRSLCAObj2.Id,null);
                 
                 refreshInterval= new MRS_Layer_Summary_Refresh_Interval__c();
                 refreshInterval.Page_Refresh_Frequency__c = 50;
                 refreshInterval.Name ='LayerSummaryInterval'; 
                 insert refreshInterval; 
    
     }

/**
    This method is for testing method: SortMaskLayer
    @method name: SortMaskLayerTest
    @parameter:   None
    @return :     None
**/ 
public static testmethod void SortMaskLayerTest(){
        sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);

        System.runAs(sysAdminUser){   
             Test.startTest();                
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 ApexPages.currentPage().getParameters().put('customerid',null);
                 ApexPages.currentPage().getParameters().put('customer',null);
                 ApexPages.currentPage().getParameters().put('mstid',null);                 
                 
                 List<MRS_Layer_Association__c> layerSummaryList= [select Customer_Frame_Mockup_Date__c,Customer_Frame_Mockup__c,Customer_Frame_Remote_Jobview_Setup_Date__c,Customer_Frame_Remote_Jobview_Setup__c,Customer_GDSOUT_Review_Date__c,Customer_GDSOUT_Review__c,Customer_MEBES_Jobview_Date__c,Customer_MEBES_Jobview__c,Customer_Prime_Remote_Jobview_Setup_Date__c,Customer_Prime_Remote_Jobview_Setup__c,Disapprove_Reason_For_Frame_Mockup_Revie__c,DRW_Date__c,DRW__c,Error_Message_Oracle_DB__c,Foundry_Frame_Mockup_Date__c,Foundry_Frame_Mockup__c,Foundry_Frame_Remote_Jobview_Setup_Date__c,Foundry_Frame_Remote_Jobview_Setup__c,Foundry_GDSOUT_Review_Date__c,Foundry_GDSOUT_Review__c,Foundry_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview__c,Foundry_Prime_Remote_Jobview_Setup_Date__c,Foundry_Prime_Remote_Jobview_Setup__c,Frame_MEBES_Received_Date__c,Frame_MEBES_Received__c,Generated_Mask_Title__c,GlobalShuttle_MEBES_Jobview_Date__c,GlobalShuttle_MEBES_Jobview__c,Hold_Warning__c,Id,Layer_Status_Date__c,Layer_Status__c,Mask_Layer_Rev__c,Mask_Set_Title_Name__c,MDP_MEBES_Jobview_Date__c,MDP_MEBES_Jobview__c,MRS_Layer_Unique_Identifier__c,MRS__c,Name,ORC_Date__c,ORC__c,Prime_MEBES_Received_Date__c,Prime_MEBES_Received__c,Reticle_Type__c,ROM_Code__c,Send_Frame_Data_Date__c,Send_Frame_Data__c,Send_Prime_Data_Date__c,Send_Prime_Data__c,Tapeout_Applications_MEBES_Jobview_Date__c,Tapeout_Applications_MEBES_Jobview__c,Tapeout_Centre_MEBES_Jobview_Date__c,Tapeout_Centre_MEBES_Jobview__c,TDTI_MPW_MEBES_Jobview_Date__c,TDTI_MPW_MEBES_Jobview__c,Tech_Geo__c from MRS_Layer_Association__c];
                                                                                                                       
                 Test.setCurrentPage(Page.VFMRSLayerSummary);
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 Cookie account = new Cookie('account', '', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{account});
                 Cookie mst = new Cookie('mst', objMST.Id, null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{mst});
                 Cookie layerStatus = new Cookie('layerStatus', 'In Progress', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{layerStatus});                 
                 MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));             
                 System.assertNotEquals(layerSummaryObj,null);
                 List<MRSLayerSummaryExtn.LayerSummaryWrapper> LSWList = new List<MRSLayerSummaryExtn.LayerSummaryWrapper>();
                 
                 layerSummaryObj.setselectedCustomerName(objAccount.Id);
                 String cust = objAccount.Name.toUpperCase()+' ('+objAccount.Short_Name__c.toUpperCase()+')';
                 System.assertEquals(layerSummaryObj.selectedCustomerName.toUpperCase(),cust);
                 
                 layerSummaryObj.CustomerNameIdMap.put(objAccount.Id,objAccount.Name);
                 layerSummaryObj.isCustomer = false;
                 layerSummaryObj.selectedCustomer = objAccount.Id;
                 layerSummaryObj.MSTIDString = objMST.Id;

                 layerSummaryObj.setselectedmst(objMST.Name);
                 System.assertEquals(layerSummaryObj.selectedmst,objMST.Name);
                 
                 layerSummaryObj.SelectedMaskLayerValue = null;
                 layerSummaryObj.SelectedLayerStatusValue.clear();
                 layerSummaryObj.SelectedDeviceIdValue = null;
                 layerSummaryObj.SelectedTechGeoStatusValue = null;

                 layerSummaryObj.groupMDP = false;
                 layerSummaryObj.groupSwiftAdmin = true;
                 layerSummaryObj.groupTapeoutCentre = false;
                 layerSummaryObj.groupTapeoutApplication = false;
                 layerSummaryObj.groupTapeoutOperation = false;
                 layerSummaryObj.groupRMG = false;
                 layerSummaryObj.groupSwiftSupport = false;
                 layerSummaryObj.groupTapeoutAdmin = false;
                 layerSummaryObj.groupCAD = false;
                 layerSummaryObj.groupFoundryJobviewer = false;
                 layerSummaryObj.groupGlobalShuttle = false;
                 layerSummaryObj.groupTDTIMPW = false;
                 layerSummaryObj.ignoreFlagValues = true;
                 layerSummaryObj.masterMRSObj.addAll(layerSummaryList);
                 system.assertNotEquals(layerSummaryObj.masterMRSObj.size(),0); 
                 layerSummaryObj.listOfPTRFIDs = new List<String>();
                 List<Mask_Layer__c> temp = new List<Mask_Layer__c>();
                 layerSummaryObj.PTRFtoLayerMap = new Map<Id, List<Mask_Layer__c>>();
                 temp.add(objLayer);
                 layerSummaryObj.PTRFtoLayerMap.put(objPTRF.Id, temp);
                 temp.clear();
                 temp.add(objLayer2);
                 layerSummaryObj.PTRFtoLayerMap.put(objPTRF2.Id, temp);
                 layerSummaryObj.listOfPTRFIDs.add(String.valueOf(objPTRF.Id));
                 layerSummaryObj.listOfPTRFIDs.add(String.valueOf(objPTRF2.Id));
                 LSWList = layerSummaryObj.getMasterData();                               
                 System.assertNotEquals(LSWList.size(),0);
             Test.stopTest();
         }
}                 

/**
    This method is for testing method: RestrictFieldValues
    @method name: restrictTest
    @parameter:   None
    @return :     None
**/ 
public static testmethod void restrictTest(){
        List<String> userList = new List<String>();
        for(GroupMember obj : [SELECT UserOrGroupId FROM GroupMember where GroupId in (SELECT Id FROM Group WHERE Name = 'SWIFT MDP')]){
            userList.add(String.valueOf(obj.UserOrGroupId));
        }
        if(userList.size()>0){ sysAdminUser = [SELECT Id,Name FROM User WHERE isActive = true and Id in:userList].get(0); }
        else { sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0); }

        System.runAs(sysAdminUser){
            Test.startTest();
                 List<MRS_Layer_Association__c> MRSObj = [select name,Layer_Status__c,ID, Tech_Geo__c from MRS_Layer_Association__c];
                 System.assertEquals(MRSObj.size(),2);
                 System.assertNotEquals(MRSObj.get(0).name,MRSObj.get(1).name);
           
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
               
                                   
                 Test.setCurrentPage(Page.VFMRSLayerSummary);
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);

                 Cookie layerStatus = new Cookie('layerStatus', 'In Progress', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{layerStatus});
                MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));             
                     System.assertNotEquals(layerSummaryObj,null);
                     layerSummaryObj.isAll = false;
                     layerSummaryObj.ignoreFlagValues = false;
                     Id FEUserProfileId = FEUserProfileId(new User(Id = UserInfo.getUserId()));
                     System.assertNotEquals(FEUserProfileId,null);
                     Id StandardUserProfileId = StandardUserProfileId(new User(Id = UserInfo.getUserId()));
                     System.assertNotEquals(StandardUserProfileId,null);
                     layerSummaryObj.RestrictFieldValues(UserInfo.getUserId(), false, false, StandardUserProfileId);

            Test.stopTest();
        }    
}

/**
    This method is for testing method: RestrictFieldValues
    @method name: restrict2Test
    @parameter:   None
    @return :     None
**/ 
public static testmethod void restrict2Test(){
        List<String> userList = new List<String>();
        for(GroupMember obj : [SELECT UserOrGroupId FROM GroupMember where GroupId in (SELECT Id FROM Group WHERE Name = 'SWIFT GlobalShuttle')]){
            userList.add(String.valueOf(obj.UserOrGroupId));
        }
        if(userList.size()>0){ sysAdminUser = [SELECT Id,Name FROM User WHERE isActive = true and Id in:userList].get(0); }
        else { sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0); }
        
        System.runAs(sysAdminUser){
            Test.startTest();
                 List<MRS_Layer_Association__c> MRSObj = [select name,Layer_Status__c,ID, Tech_Geo__c from MRS_Layer_Association__c];
                 System.assertEquals(MRSObj.size(),2);
                 System.assertNotEquals(MRSObj.get(0).name,MRSObj.get(1).name);
                 
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 ApexPages.currentPage().getParameters().put('customerid',objAccount.Id);
                 ApexPages.currentPage().getParameters().put('customer',objAccount.Name);
                 ApexPages.currentPage().getParameters().put('mstid',objMST.Name);                 
                 
                                     
                 Test.setCurrentPage(Page.VFMRSLayerSummary);
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 Cookie account = new Cookie('account', null, null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{account});
                 Cookie mst = new Cookie('mst', null, null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{mst});
                 Cookie layerStatus = new Cookie('layerStatus', 'In Progress', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{layerStatus});
                MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));             
                     System.assertNotEquals(layerSummaryObj,null);
                     layerSummaryObj.isAll = false;
                     layerSummaryObj.ignoreFlagValues = false;
                     Id FEUserProfileId = FEUserProfileId(new User(Id = UserInfo.getUserId()));
                     System.assertNotEquals(FEUserProfileId,null);
                     Id StandardUserProfileId = StandardUserProfileId(new User(Id = UserInfo.getUserId()));
                     System.assertNotEquals(StandardUserProfileId,null);
                
                     layerSummaryObj.RestrictFieldValues(UserInfo.getUserId(), false, true, FEUserProfileId);

            Test.stopTest();
        }    
}

/**
    This method is for testing method: RestrictFieldValues
    @method name: restrict3Test
    @parameter:   None
    @return :     None
**/ 
public static testmethod void restrict3Test(){
        sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);

        System.runAs(sysAdminUser){
            Test.startTest();
                 List<MRS_Layer_Association__c> MRSObj = [select name,Layer_Status__c,ID, Tech_Geo__c from MRS_Layer_Association__c];
                 System.assertEquals(MRSObj.size(),2);
                 System.assertNotEquals(MRSObj.get(0).name,MRSObj.get(1).name);

                 
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 Test.setCurrentPage(Page.VFMRSLayerSummary);
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);

                 Cookie layerStatus = new Cookie('layerStatus', 'In Progress', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{layerStatus});
                MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));             
                     System.assertNotEquals(layerSummaryObj,null);
                     layerSummaryObj.isAll = false;
                     layerSummaryObj.ignoreFlagValues = false;
                     Id FEUserProfileId = FEUserProfileId(new User(Id = UserInfo.getUserId()));
                     System.assertNotEquals(FEUserProfileId,null);
                     Id StandardUserProfileId = StandardUserProfileId(new User(Id = UserInfo.getUserId()));
                     System.assertNotEquals(StandardUserProfileId,null);
//=======================                     
                     layerSummaryObj.selectedCustomer = String.valueOf(objAccount.Id);
//=======================
                     layerSummaryObj.RestrictFieldValues(UserInfo.getUserId(), true, false, StandardUserProfileId);

            Test.stopTest();
        }    
}

/**
    This method is for testing method: refreshData
    @method name: refreshDataTest
    @parameter:   None
    @return :     None
**/ 
public static testmethod void refreshDataTest(){
        sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);

        System.runAs(sysAdminUser){
 
                 objPTRF.Status__c = 'Perform Tapeout Options';
                 listPTRF.add(objPTRF);  
                 objPTRF2.Status__c = 'Perform Tapeout Options';
                 listPTRF.add(objPTRF2);   
             Test.startTest(); 
                 Test.setCurrentPage(Page.VFMRSLayerSummary);
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 ApexPages.currentPage().getParameters().put('customerid',objAccount.Id);
                 ApexPages.currentPage().getParameters().put('customer',objAccount.Name);
                 ApexPages.currentPage().getParameters().put('mstid',objMST.Name); 
                 MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));             
                 System.assertNotEquals(layerSummaryObj,null);
                 layerSummaryObj.groupMDP = false;
                 layerSummaryObj.groupSwiftAdmin = false;
                 layerSummaryObj.groupTapeoutCentre = false;
                 layerSummaryObj.groupTapeoutApplication = false;
                 layerSummaryObj.groupTapeoutOperation = false;
                 layerSummaryObj.groupRMG = false;
                 layerSummaryObj.groupSwiftSupport = false;
                 layerSummaryObj.groupTapeoutAdmin = false;
                 layerSummaryObj.groupCAD = false;
                 layerSummaryObj.groupFoundryJobviewer = false;
                 layerSummaryObj.groupGlobalShuttle = true;
                 layerSummaryObj.groupTDTIMPW = true;
                 layerSummaryObj.isCustomer = false;
                 layerSummaryObj.ignoreFlagValues = true;
             layerSummaryObj.refreshData();
                 layerSummaryObj.selectedCustomerName = null;
                 layerSummaryObj.CustomerNameIdMap.clear();
                 layerSummaryObj.CustomerNameIdMap.put(objAccount.Id,objAccount.Name);
                 List<SelectOption> LSO = layerSummaryObj.getCustomerLOV();
                 System.assertNotEquals(LSO,null);
           Test.stopTest(); 
     }        
}

/**
    This method is for testing method: getMaskSetTitleValues
    @method name: getMSTTest1
    @parameter:   None
    @return :     None
**/ 
/*
public static testmethod void getMSTTest1(){

        System.runAs(new User(Id = UserInfo.getUserId())){
            Test.startTest();
               
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 ApexPages.currentPage().getParameters().put('customerid',objAccount.Id);
                 ApexPages.currentPage().getParameters().put('customer',objAccount.Name);
                 ApexPages.currentPage().getParameters().put('mstid',objMST.Name);                 
                 Test.setCurrentPage(Page.VFMRSLayerSummary);
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 Cookie account = new Cookie('account', null, null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{account});
                 Cookie mst = new Cookie('mst', null, null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{mst});
                 Cookie layerStatus = new Cookie('layerStatus', 'In Progress', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{layerStatus});
                MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));             
                 System.assertNotEquals(layerSummaryObj,null);
                 layerSummaryObj.selectedmst = null;
                 layerSummaryObj.isCustomer = true;
                 layerSummaryObj.selectedCustomer = objAccount.Id;
                 layerSummaryObj.getMaskSetTitleValues();
                 System.assertNotEquals(layerSummaryObj.lstmst.size(),0);

            Test.stopTest();
        }    
}
*/
/**
    This method is for testing method: getMaskSetTitleValues
    @method name: getMSTTest2
    @parameter:   None
    @return :     None
**/ 
/*
public static testmethod void getMSTTest2(){

        System.runAs(new User(Id = UserInfo.getUserId())){
            Test.startTest();
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 ApexPages.currentPage().getParameters().put('customerid',objAccount.Id);
                 ApexPages.currentPage().getParameters().put('customer',objAccount.Name);
                 ApexPages.currentPage().getParameters().put('mstid',objMST.Name);                 
                 
                 Test.setCurrentPage(Page.VFMRSLayerSummary);
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 Cookie account = new Cookie('account', null, null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{account});
                 Cookie mst = new Cookie('mst', null, null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{mst});
                 Cookie layerStatus = new Cookie('layerStatus', 'In Progress', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{layerStatus});
                MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));             
                 System.assertNotEquals(layerSummaryObj,null);
                 layerSummaryObj.selectedCustomer = objAccount.Id;
                 layerSummaryObj.getMaskSetTitleValues();
                 layerSummaryObj.selectedCustomer = null;
                 System.assertNotEquals(layerSummaryObj.lstmst.size(),0);
                 layerSummaryObj.getMaskSetTitleValues(); 
            Test.stopTest();
        }    
}      
*/                    
/**
    This method is for testing method: ExportToExcel
    @method name: ExportExcelTest
    @parameter:   None
    @return :     None
**/ 
public static testmethod void ExportExcelTest(){
        sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);

        System.runAs(sysAdminUser){

                 objPTRF.Status__c = 'Perform Tapeout Options';
                 listPTRF.add(objPTRF);  
                 objPTRF2.Status__c = 'Perform Tapeout Options';
                 listPTRF.add(objPTRF2);   
             Test.startTest();
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                                                                                                                       
                 Test.setCurrentPage(Page.VFMRSLayerSummary);
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 Cookie account = new Cookie('account', '', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{account});
                 Cookie mst = new Cookie('mst', '', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{mst});
                 Cookie layerStatus = new Cookie('layerStatus', 'In Progress', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{layerStatus});
                 MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));             
                 System.assertNotEquals(layerSummaryObj,null);
                 List<MRSLayerSummaryExtn.LayerSummaryWrapper> LSWList = new List<MRSLayerSummaryExtn.LayerSummaryWrapper>();
                 
                 layerSummaryObj.setselectedCustomerName(objAccount.Id);
                 String cust = objAccount.Name.toUpperCase()+' ('+objAccount.Short_Name__c.toUpperCase()+')';
                 System.assertEquals(layerSummaryObj.selectedCustomerName.toUpperCase(),cust);
                 
                 layerSummaryObj.CustomerNameIdMap.put(objAccount.Id,objAccount.Name);

                 layerSummaryObj.isFirstFramePTRF = true;
                 layerSummaryObj.listOfPTRFIDs = new List<String>();
                 layerSummaryObj.listOfPTRFIDs.add(objPTRF.Id);
                 layerSummaryObj.listOfPTRFIDs.add(objPTRF2.Id);                 
                 layerSummaryObj.refreshInterval = 30;
                 layerSummaryObj.ignoreFlagValues = true;
                 layerSummaryObj.hasMasterValue = true;
                 layerSummaryObj.MRSId = '';
                 layerSummaryObj.lstCustomerList.add(objAccount);
                 layerSummaryObj.selectedCustomer = String.valueOf(objAccount.Id);
                 layerSummaryObj.showLabel = false;
                 layerSummaryObj.selectedCustomerName = String.valueOf(objAccount.Name);
                 layerSummaryObj.selectedmst = objMST.Name;
                 layerSummaryObj.groupFE = true;
                 layerSummaryObj.groupTapeoutOperation = true;
                 layerSummaryObj.groupMDP = false;
                 layerSummaryObj.groupGlobalShuttle = true;
                 layerSummaryObj.groupTDTIMPW = true;
                 layerSummaryObj.groupFoundryJobviewer = true;
                 layerSummaryObj.groupSwiftAdmin = true;
                 layerSummaryObj.groupSwiftSupport = true;
                 layerSummaryObj.groupTapeoutCentre = true;
                 layerSummaryObj.groupTapeoutApplication = true;
                 layerSummaryObj.groupRMG = true;
                 layerSummaryObj.groupTapeoutAdmin = true;
                 layerSummaryObj.groupCAD = true;
                 layerSummaryObj.TechGeoDisplayFlag = true;
                 layerSummaryObj.MSTIDString = objMST.Id;
                 layerSummaryObj.isAll = false;
                 layerSummaryObj.isGDSOUTReview = true;
                 layerSummaryObj.isFrameMockupReview = true;
                 layerSummaryObj.isSendData = true;
                 layerSummaryObj.isRemoteJobView = true;
                 layerSummaryObj.isORC = true;
                 layerSummaryObj.isDRW = true;
                 layerSummaryObj.isMEBESReceied = true;
                 layerSummaryObj.isMEBESReceived = true;
                 layerSummaryObj.isMEBESJobView = true;
                 layerSummaryObj.GDSOUTReviewFlag = true;
                 layerSummaryObj.FrameMockup = true;
                 layerSummaryObj.SendData = true;
                 layerSummaryObj.MEBESReceived = true;
                 layerSummaryObj.MEBESJobview = true;
                 layerSummaryObj.CustomerRemoteJobview = true;
                 layerSummaryObj.FoundryRemoteJobview = true;
                 layerSummaryObj.GDSOUTReviewCustomerFlag = true;
                 layerSummaryObj.GDSOUTReviewFoundryFlag = true;
                 layerSummaryObj.FrameMockupCustomerFlag = true;
                 layerSummaryObj.FrameMockupFoundryFlag = true;
                 layerSummaryObj.SendDataPrimeFlag = true;
                 layerSummaryObj.SendDataFrameFlag = true;
                 layerSummaryObj.ORCFlag = true;
                 layerSummaryObj.DRWFlag = true;
                 layerSummaryObj.MEBESReceivedPrimeFlag = true;
                 layerSummaryObj.MEBESReceivedFrameFlag = true;
                 layerSummaryObj.MEBESJobviewCustomerFlag = true;
                 layerSummaryObj.MEBESJobviewFoundryFlag = true;
                 layerSummaryObj.MEBESJobviewTapeoutCentreFlag = true;
                 layerSummaryObj.MEBESJobviewTapeoutApplicationsFlag = true;
                 layerSummaryObj.MEBESJobviewGlobalShuttleFlag = true;
                 layerSummaryObj.MEBESJobviewMDPFlag = true;
                 layerSummaryObj.MEBESJobviewTDTIMPWFlag = true;
                 layerSummaryObj.CustomerRemoteJobviewPrimeFlag = true;
                 layerSummaryObj.CustomerRemoteJobviewFrameFlag = true;
                 layerSummaryObj.FoundryRemoteJobviewPrime = true;
                 layerSummaryObj.FoundryRemoteJobviewFrame = true;
                 layerSummaryObj.isCustomer = false;
                 layerSummaryObj.isBreadcrumbActive = true;
                 layerSummaryObj.ignoreFlagValues = false;
                 layerSummaryObj.ValueCatcher = '';
                 PageReference Excel; 
                 PageReference CSV;                                                  

                 layerSummaryObj.hasMasterValue = true;

                 Excel = layerSummaryObj.exportToExcel();
                 System.assertNotEquals(Excel,null);
                 CSV = layerSummaryObj.exportToCSV();
                 System.assertNotEquals(CSV,null);

            Test.stopTest();
        }    
} 

/**
    This method is for testing method: ExportToCSV
    @method name: ExportCSVTest
    @parameter:   None
    @return :     None
**/                 
public static testmethod void ExportCSVTest(){
        sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);

        System.runAs(sysAdminUser){
                 objPTRF.Status__c = 'Perform Tapeout Options';
                 listPTRF.add(objPTRF);  
                 objPTRF2.Status__c = 'Perform Tapeout Options';
                 listPTRF.add(objPTRF2);   
             Test.startTest();
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                                                                                                                       
                 Test.setCurrentPage(Page.VFMRSLayerSummary);
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 Cookie account = new Cookie('account', '', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{account});
                 Cookie mst = new Cookie('mst', '', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{mst});
                 Cookie layerStatus = new Cookie('layerStatus', 'In Progress', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{layerStatus});
                 MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));             
                 System.assertNotEquals(layerSummaryObj,null);
                 List<MRSLayerSummaryExtn.LayerSummaryWrapper> LSWList = new List<MRSLayerSummaryExtn.LayerSummaryWrapper>();
                 
                 layerSummaryObj.setselectedCustomerName(objAccount.Id);
                 String cust = objAccount.Name.toUpperCase()+' ('+objAccount.Short_Name__c.toUpperCase()+')';
System.assertEquals(layerSummaryObj.selectedCustomerName.toUpperCase(),cust);
                 
                 layerSummaryObj.CustomerNameIdMap.put(objAccount.Id,objAccount.Name);

                 layerSummaryObj.isFirstFramePTRF = true;
                 layerSummaryObj.listOfPTRFIDs = new List<String>();
                 layerSummaryObj.listOfPTRFIDs.add(objPTRF.Id);
                 layerSummaryObj.listOfPTRFIDs.add(objPTRF2.Id);                 
                 layerSummaryObj.refreshInterval = 30;
                 layerSummaryObj.ignoreFlagValues = true;
                 layerSummaryObj.hasMasterValue = true;
                 layerSummaryObj.MRSId = '';
                 layerSummaryObj.lstCustomerList.add(objAccount);
                 layerSummaryObj.selectedCustomer = String.valueOf(objAccount.Id);
                 layerSummaryObj.showLabel = false;
                 layerSummaryObj.selectedCustomerName = String.valueOf(objAccount.Name);
                 layerSummaryObj.selectedmst = objMST.Name;
                 layerSummaryObj.groupFE = true;
                 layerSummaryObj.groupTapeoutOperation = true;
                 layerSummaryObj.groupMDP = false;
                 layerSummaryObj.groupGlobalShuttle = true;
                 layerSummaryObj.groupTDTIMPW = true;
                 layerSummaryObj.groupFoundryJobviewer = true;
                 layerSummaryObj.groupSwiftAdmin = true;
                 layerSummaryObj.groupSwiftSupport = true;
                 layerSummaryObj.groupTapeoutCentre = true;
                 layerSummaryObj.groupTapeoutApplication = true;
                 layerSummaryObj.groupRMG = true;
                 layerSummaryObj.groupTapeoutAdmin = true;
                 layerSummaryObj.groupCAD = true;
                 layerSummaryObj.TechGeoDisplayFlag = true;
                 layerSummaryObj.MSTIDString = objMST.Id;
                 layerSummaryObj.isAll = false;
                 layerSummaryObj.isGDSOUTReview = true;
                 layerSummaryObj.isFrameMockupReview = true;
                 layerSummaryObj.isSendData = true;
                 layerSummaryObj.isRemoteJobView = true;
                 layerSummaryObj.isORC = true;
                 layerSummaryObj.isDRW = true;
                 layerSummaryObj.isMEBESReceied = true;
                 layerSummaryObj.isMEBESReceived = true;
                 layerSummaryObj.isMEBESJobView = true;
                 layerSummaryObj.GDSOUTReviewFlag = true;
                 layerSummaryObj.FrameMockup = true;
                 layerSummaryObj.SendData = true;
                 layerSummaryObj.MEBESReceived = true;
                 layerSummaryObj.MEBESJobview = true;
                 layerSummaryObj.CustomerRemoteJobview = true;
                 layerSummaryObj.FoundryRemoteJobview = true;
                 layerSummaryObj.GDSOUTReviewCustomerFlag = true;
                 layerSummaryObj.GDSOUTReviewFoundryFlag = true;
                 layerSummaryObj.FrameMockupCustomerFlag = true;
                 layerSummaryObj.FrameMockupFoundryFlag = true;
                 layerSummaryObj.SendDataPrimeFlag = true;
                 layerSummaryObj.SendDataFrameFlag = true;
                 layerSummaryObj.ORCFlag = true;
                 layerSummaryObj.DRWFlag = true;
                 layerSummaryObj.MEBESReceivedPrimeFlag = true;
                 layerSummaryObj.MEBESReceivedFrameFlag = true;
                 layerSummaryObj.MEBESJobviewCustomerFlag = true;
                 layerSummaryObj.MEBESJobviewFoundryFlag = true;
                 layerSummaryObj.MEBESJobviewTapeoutCentreFlag = true;
                 layerSummaryObj.MEBESJobviewTapeoutApplicationsFlag = true;
                 layerSummaryObj.MEBESJobviewGlobalShuttleFlag = true;
                 layerSummaryObj.MEBESJobviewMDPFlag = true;
                 layerSummaryObj.MEBESJobviewTDTIMPWFlag = true;
                 layerSummaryObj.CustomerRemoteJobviewPrimeFlag = true;
                 layerSummaryObj.CustomerRemoteJobviewFrameFlag = true;
                 layerSummaryObj.FoundryRemoteJobviewPrime = true;
                 layerSummaryObj.FoundryRemoteJobviewFrame = true;
                 layerSummaryObj.isCustomer = false;
                 layerSummaryObj.isBreadcrumbActive = true;
                 layerSummaryObj.ignoreFlagValues = false;
                 layerSummaryObj.ValueCatcher = '';
                 PageReference Excel; 
                 PageReference CSV;
                 layerSummaryObj.hasMasterValue = false;
                 Excel = layerSummaryObj.exportToExcel();
                 System.assertEquals(Excel,null);
                 CSV = layerSummaryObj.exportToCSV();
                 System.assertEquals(CSV,null); 
            Test.stopTest();
        }    
}  

/**
    This method is for testing method: SetCustomerValue
    @method name: SetCustomerValueTest
    @parameter:   None
    @return :     None
**/
public static testmethod void SetCustomerValueTest(){
        sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser){
            Test.startTest(); 
                Test.setCurrentPage(Page.VFMRSLayerSummary);
                ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));
                System.assertNotEquals(layerSummaryObj,null);
                layerSummaryObj.setCustomerValue(String.valueOf(objAccount.Id));
            Test.stopTest();
        }
}

/**
    This method is for testing all getter & setter methods
    @method name: GetterSetterTest
    @parameter:   None
    @return :     None
**/
public static testmethod void GetterSetterTest(){
        sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser){ 
             Test.startTest();
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 List<MRS_Layer_Association__c> layerSummaryList= [select name,Mask_Layer_Rev__c,ROM_Code__c,Layer_Status__c,ID, Tech_Geo__c from MRS_Layer_Association__c];
                                                                                                                       
                 Test.setCurrentPage(Page.VFMRSLayerSummary);
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 Cookie account = new Cookie('account', '', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{account});
                 Cookie mst = new Cookie('mst', '', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{mst});
                 Cookie layerStatus = new Cookie('layerStatus', 'In Progress', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{layerStatus});
                 MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));             
                 System.assertNotEquals(layerSummaryObj,null);
                 List<MRSLayerSummaryExtn.LayerSummaryWrapper> LSWList = new List<MRSLayerSummaryExtn.LayerSummaryWrapper>();
                 layerSummaryObj.selectedCustomer = objAccount.Id;
                 layerSummaryObj.setselectedCustomerName(objAccount.Id);
                 String cust = objAccount.Name.toUpperCase()+' ('+objAccount.Short_Name__c.toUpperCase()+')';
                 System.assertEquals(layerSummaryObj.selectedCustomerName.toUpperCase(),cust);
                 layerSummaryObj.selectedmst = objMST.Name;
                 layerSummaryObj.CustomerNameIdMap.put(objAccount.Id,objAccount.Name);
                 layerSummaryObj.SelectedMaskLayerValue = layerSummaryList.get(0).Name;
                 layerSummaryObj.SelectedLayerStatusValue.add(layerSummaryList.get(0).Layer_Status__c);
                 List<MRS_Layer_Chip_Association__c> MRSLCA = [select Id,Device_Id__c from MRS_Layer_Chip_Association__c where Layer__c =:layerSummaryList.get(0).Id];
                 layerSummaryObj.SelectedDeviceIdValue = MRSLCA.get(0).Device_Id__c;
                 layerSummaryObj.SelectedTechGeoStatusValue = layerSummaryList.get(0).Tech_Geo__c; 
                 
                 layerSummaryObj.isFirstFramePTRF = true;
                 layerSummaryObj.listOfPTRFIDs = new List<String>();
                 layerSummaryObj.listOfPTRFIDs.add(objPTRF.Id);
                 layerSummaryObj.listOfPTRFIDs.add(objPTRF2.Id);                 
                 layerSummaryObj.refreshInterval = 30;
                 layerSummaryObj.ignoreFlagValues = true;
                 layerSummaryObj.hasMasterValue = true;
                 layerSummaryObj.MRSId = '';
                 layerSummaryObj.lstCustomerList.add(objAccount);
                 layerSummaryObj.selectedCustomer = String.valueOf(objAccount.Id);
                 layerSummaryObj.showLabel = false;
                 layerSummaryObj.selectedCustomerName = String.valueOf(objAccount.Name);
                 layerSummaryObj.selectedmst = objMST.Name;
                 layerSummaryObj.groupFE = true;
                 layerSummaryObj.groupTapeoutOperation = true;
                 layerSummaryObj.groupMDP = true;
                 layerSummaryObj.groupGlobalShuttle = true;
                 layerSummaryObj.groupTDTIMPW = true;
                 layerSummaryObj.groupFoundryJobviewer = true;
                 layerSummaryObj.groupSwiftAdmin = true;
                 layerSummaryObj.groupSwiftSupport = true;
                 layerSummaryObj.groupTapeoutCentre = true;
                 layerSummaryObj.groupTapeoutApplication = true;
                 layerSummaryObj.groupRMG = true;
                 layerSummaryObj.groupTapeoutAdmin = true;
                 layerSummaryObj.groupCAD = true;
                 layerSummaryObj.TechGeoDisplayFlag = true;
                 layerSummaryObj.MSTIDString = objMST.Id;
                 layerSummaryObj.isAll = false;
                 layerSummaryObj.isGDSOUTReview = true;
                 layerSummaryObj.isFrameMockupReview = true;
                 layerSummaryObj.isSendData = true;
                 layerSummaryObj.isRemoteJobView = true;
                 layerSummaryObj.isORC = true;
                 layerSummaryObj.isDRW = true;
                 layerSummaryObj.isMEBESReceied = true;
                 layerSummaryObj.isMEBESReceived = true;
                 layerSummaryObj.isMEBESJobView = true;
                 layerSummaryObj.GDSOUTReviewFlag = true;
                 layerSummaryObj.FrameMockup = true;
                 layerSummaryObj.SendData = true;
                 layerSummaryObj.MEBESReceived = true;
                 layerSummaryObj.MEBESJobview = true;
                 layerSummaryObj.CustomerRemoteJobview = true;
                 layerSummaryObj.FoundryRemoteJobview = true;
                 layerSummaryObj.GDSOUTReviewCustomerFlag = true;
                 layerSummaryObj.GDSOUTReviewFoundryFlag = true;
                 layerSummaryObj.FrameMockupCustomerFlag = true;
                 layerSummaryObj.FrameMockupFoundryFlag = true;
                 layerSummaryObj.SendDataPrimeFlag = true;
                 layerSummaryObj.SendDataFrameFlag = true;
                 layerSummaryObj.ORCFlag = true;
                 layerSummaryObj.DRWFlag = true;
                 layerSummaryObj.MEBESReceivedPrimeFlag = true;
                 layerSummaryObj.MEBESReceivedFrameFlag = true;
                 layerSummaryObj.MEBESJobviewCustomerFlag = true;
                 layerSummaryObj.MEBESJobviewFoundryFlag = true;
                 layerSummaryObj.MEBESJobviewTapeoutCentreFlag = true;
                 layerSummaryObj.MEBESJobviewTapeoutApplicationsFlag = true;
                 layerSummaryObj.MEBESJobviewGlobalShuttleFlag = true;
                 layerSummaryObj.MEBESJobviewMDPFlag = true;
                 layerSummaryObj.MEBESJobviewTDTIMPWFlag = true;
                 layerSummaryObj.CustomerRemoteJobviewPrimeFlag = true;
                 layerSummaryObj.CustomerRemoteJobviewFrameFlag = true;
                 layerSummaryObj.FoundryRemoteJobviewPrime = true;
                 layerSummaryObj.FoundryRemoteJobviewFrame = true;
                 layerSummaryObj.isCustomer = false;
                 layerSummaryObj.isBreadcrumbActive = true;
                 
                 Boolean bool = false;
                 bool = layerSummaryObj.getMasterValue();
                 bool = layerSummaryObj.getGDSOUTReviewFlag();          
                 bool = layerSummaryObj.getFrameMockup();
                 bool = layerSummaryObj.getSendData();
                 bool = layerSummaryObj.getMEBESReceived();
                 bool = layerSummaryObj.getMEBESJobview();
                 bool = layerSummaryObj.getCustomerRemoteJobview();
                 bool = layerSummaryObj.getFoundryRemoteJobview();
                 bool = layerSummaryObj.getGDSOUTReviewCustomerFlag();
                 bool = layerSummaryObj.getGDSOUTReviewFoundryFlag();
                 bool = layerSummaryObj.getFrameMockupCustomerFlag();
                 bool = layerSummaryObj.getFrameMockupFoundryFlag();
                 bool = layerSummaryObj.getSendDataPrimeFlag();
                 bool = layerSummaryObj.getSendDataFrameFlag();
                 bool = layerSummaryObj.getORCFlag();
                 bool = layerSummaryObj.getDRWFlag();
                 bool = layerSummaryObj.getMEBESReceivedPrimeFlag();
                 bool = layerSummaryObj.getMEBESReceivedFrameFlag();
                 bool = layerSummaryObj.getMEBESJobviewCustomerFlag();
                 bool = layerSummaryObj.getMEBESJobviewFoundryFlag();
                 bool = layerSummaryObj.getMEBESJobviewTapeoutCentreFlag();
                 bool = layerSummaryObj.getMEBESJobviewTapeoutApplicationsFlag();
                 bool = layerSummaryObj.getMEBESJobviewGlobalShuttleFlag();
                 bool = layerSummaryObj.getMEBESJobviewMDPFlag();
                 bool = layerSummaryObj.getMEBESJobviewTDTIMPWFlag();
                 bool = layerSummaryObj.getCustomerRemoteJobviewPrimeFlag();
                 bool = layerSummaryObj.getCustomerRemoteJobviewFrameFlag();
                 bool = layerSummaryObj.getFoundryRemoteJobviewPrime();
                 bool = layerSummaryObj.getFoundryRemoteJobviewFrame();
                 String str = '';
                 str = layerSummaryObj.getselectedCustomerName();
                 List<SelectOption> ListSO = new List<SelectOption>();
                 ListSO = layerSummaryObj.getCustomerLOV();
                 ListSo.clear();
                 ListSO = layerSummaryObj.getMSTLOV();
                 System.assertNotEquals(ListSO,null);
                 layerSummaryObj.setMSTValue(String.valueOf(objMST.Name));
                 str = layerSummaryObj.getMSTValue();
                 layerSummaryObj.CalculateFieldDisplayValues('SWIFT_MDP'); 
                 layerSummaryObj.resetSingleMSTValue(); 
                 layerSummaryObj.resetMSTCookie();      
             Test.stopTest();
         }
}
/**
    This method is for testing method: setCustomer
    @method name: setCustomertest
    @parameter:   None
    @return :     None
**/
public static testmethod void setCustomertest(){
        sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);

        System.runAs(sysAdminUser){
            Test.startTest();
                 
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 ApexPages.currentPage().getParameters().put('customerid',null);
                 ApexPages.currentPage().getParameters().put('customer',null);
                 ApexPages.currentPage().getParameters().put('mstid',null);                 
                 
                 Test.setCurrentPage(Page.VFMRSLayerSummary);
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 Cookie account = new Cookie('account', null, null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{account});
                 Cookie mst = new Cookie('mst', null, null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{mst});
                 Cookie layerStatus = new Cookie('layerStatus', 'In Progress', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{layerStatus});
                MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));             
                 System.assertNotEquals(layerSummaryObj,null);
                 String str = '';

//==================
                layerSummaryObj.selectedCustomer = String.valueOf(objAccount.Id);
//==================                

                 layerSummaryObj.selectedCustomerName = String.valueOf(objAccount.Name);
                 layerSummaryObj.selectedmst = String.valueOf(objMST.Id);

                 layerSummaryObj.setCustomerID();
                  
                 str = layerSummaryObj.getCustomerValue();
                 System.assertNotEquals(str,null); 
                 str = layerSummaryObj.getselectedmst();
                 
            Test.stopTest();
        }    
} 
                 
/**
    This method is for testing method: Clear
    @method name: ClearTest
    @parameter:   None
    @return :     None
**/
public static testmethod void ClearTest(){
        sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser){
            Test.startTest(); 
                Test.setCurrentPage(Page.VFMRSLayerSummary);
                ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));
                System.assertNotEquals(layerSummaryObj,null);
                layerSummaryObj.selectedCustomer = String.valueOf(objAccount.Id);
                layerSummaryObj.selectedCustomerName = String.valueOf(objAccount.Name);
                layerSummaryObj.selectedmst = String.valueOf(objMST.Id);                
                layerSummaryObj.InitiateDropDowns();
                layerSummaryObj.Clear();
            Test.stopTest();
        }
       
}                 

/**
    This method is for testing method: Constructor
    @method name: Constructor4Test
    @parameter:   None
    @return :     None
**/
public static testmethod void Constructor4Test(){
        sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);

        System.runAs(sysAdminUser){
  
             Test.startTest(); 
          
                 List<MRS_Layer_Association__c> MRSObj = [select name,Layer_Status__c,ID, Tech_Geo__c from MRS_Layer_Association__c];
                 System.assertEquals(MRSObj.size(),2);
                 System.assertNotEquals(MRSObj.get(0).name,MRSObj.get(1).name);
                 Test.setCurrentPage(Page.VFMRSLayerSummary);
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 ApexPages.currentPage().getParameters().put('customerid',objAccount.Id);
                 ApexPages.currentPage().getParameters().put('customer',objAccount.Name);
                 ApexPages.currentPage().getParameters().put('mstid',objMST.Name); 
                 MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));             
                 System.assertNotEquals(layerSummaryObj,null);
                 layerSummaryObj.groupMDP = false;
                 layerSummaryObj.groupSwiftAdmin = false;
                 layerSummaryObj.groupTapeoutCentre = false;
                 layerSummaryObj.groupTapeoutApplication = false;
                 layerSummaryObj.groupTapeoutOperation = false;
                 layerSummaryObj.groupRMG = false;
                 layerSummaryObj.groupSwiftSupport = false;
                 layerSummaryObj.groupTapeoutAdmin = false;
                 layerSummaryObj.groupCAD = false;
                 layerSummaryObj.groupFoundryJobviewer = false;
                 layerSummaryObj.groupGlobalShuttle = true;
                 layerSummaryObj.groupTDTIMPW = true;
                 layerSummaryObj.isCustomer = false;
                 layerSummaryObj.ignoreFlagValues = true;
             layerSummaryObj.getSummary();
                 layerSummaryObj.selectedCustomerName = null;
                 layerSummaryObj.CustomerNameIdMap.clear();
                 layerSummaryObj.CustomerNameIdMap.put(objAccount.Id,objAccount.Name);
                 List<SelectOption> LSO = layerSummaryObj.getCustomerLOV();
                 System.assertNotEquals(LSO,null);
           Test.stopTest(); 
     }        
}

/**
    This method is for testing method: getSummary()
    @method name: getsummary1Test
    @parameter:   None
    @return :     None
**/
public static testmethod void getsummary1Test(){

        System.runAs(new User(Id = UserInfo.getUserId())){
   
             Test.startTest(); 
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 ApexPages.currentPage().getParameters().put('customerid','');
                 ApexPages.currentPage().getParameters().put('customer','');
                 ApexPages.currentPage().getParameters().put('mstid','');                 
                 
                 List<MRS_Layer_Association__c> layerSummaryList= [select name,Layer_Status__c,ID, Tech_Geo__c from MRS_Layer_Association__c];
                                                                                                                       
                 Test.setCurrentPage(Page.VFMRSLayerSummary);
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 Cookie account = new Cookie('account', '', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{account});
                 Cookie mst = new Cookie('mst', '', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{mst});
                 Cookie layerStatus = new Cookie('layerStatus', 'In Progress', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{layerStatus});
                 MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));             
                 System.assertNotEquals(layerSummaryObj,null);
                 List<MRSLayerSummaryExtn.LayerSummaryWrapper> LSWList = new List<MRSLayerSummaryExtn.LayerSummaryWrapper>();
                 

                 String cust = objAccount.Name.toUpperCase()+' ('+objAccount.Short_Name__c.toUpperCase()+')';

                 
                 layerSummaryObj.CustomerNameIdMap.put(objAccount.Id,objAccount.Name);

                 
                 layerSummaryObj.SelectedMaskLayerValue = layerSummaryList.get(0).Name;
                 layerSummaryObj.SelectedLayerStatusValue.add(layerSummaryList.get(0).Layer_Status__c);
                 List<MRS_Layer_Chip_Association__c> MRSLCA = [select Id,Device_Id__c from MRS_Layer_Chip_Association__c where Layer__c =:layerSummaryList.get(0).Id];
                 layerSummaryObj.SelectedDeviceIdValue = MRSLCA.get(0).Device_Id__c;
                 layerSummaryObj.SelectedTechGeoStatusValue = layerSummaryList.get(0).Tech_Geo__c;

                 layerSummaryObj.ignoreFlagValues = false;

                 layerSummaryObj.selectedmst = objMST.Name;
                 System.assertNotEquals(layerSummaryObj.selectedmst,null); 
                 layerSummaryObj.groupFoundryJobviewer = true;
                 

                 
                 layerSummaryObj.SelectedMaskLayerValue = '';
                 layerSummaryObj.SelectedLayerStatusValue.add('');
                 layerSummaryObj.SelectedTechGeoStatusValue = '';//layerSummaryList.get(0).Tech_Geo__c;
                 layerSummaryObj.SelectedDeviceIdValue = '';
                 layerSummaryObj.isCustomer = true;
                 layerSummaryObj.groupMDP = false;
                 layerSummaryObj.ignoreFlagValues = true;
             layerSummaryObj.getSummary();
             MRSLayerSummaryExtn.PaginatedSelectList pagObj = new MRSLayerSummaryExtn.PaginatedSelectList();
             SelectOption so = pagObj.get(0);  
             List<SelectOption> soList = new List<SelectOption>();
             soList = pagObj.getSelectList();
             soList = pagObj.getSubList(0,1);
             soList = pagObj.getNthSubList(0);
             soList = pagObj.getValueFromList();
             soList = pagObj.get0();
             soList = pagObj.get1();
             soList = pagObj.get2();
             soList = pagObj.get3();
             soList = pagObj.get4();
             soList = pagObj.get5();
             soList = pagObj.get6();
             soList = pagObj.get7();
             soList = pagObj.get8();
             soList = pagObj.get9();
             soList = pagObj.get10();
             soList = pagObj.get11();
             soList = pagObj.get12();
             soList = pagObj.get13();
             soList = pagObj.get14();
             soList = pagObj.get15();
             soList = pagObj.get16();
             soList = pagObj.get17();
             soList = pagObj.get18();
             soList = pagObj.get19();
            Test.stopTest(); 
     }        
}

public static testmethod void getsummary2Test(){

        System.runAs(new User(Id = UserInfo.getUserId())){
   
             Test.startTest(); 
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 ApexPages.currentPage().getParameters().put('customerid','');
                 ApexPages.currentPage().getParameters().put('customer','');
                 ApexPages.currentPage().getParameters().put('mstid','');                 
                 
                 List<MRS_Layer_Association__c> layerSummaryList= [select name,Layer_Status__c,ID, Tech_Geo__c from MRS_Layer_Association__c];
                                                                                                                       
                 Test.setCurrentPage(Page.VFMRSLayerSummary);
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 Cookie account = new Cookie('account', '', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{account});
                 Cookie mst = new Cookie('mst', '', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{mst});
                 Cookie layerStatus = new Cookie('layerStatus', 'In Progress', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{layerStatus});
                 MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));             
                 System.assertNotEquals(layerSummaryObj,null);
                 List<MRSLayerSummaryExtn.LayerSummaryWrapper> LSWList = new List<MRSLayerSummaryExtn.LayerSummaryWrapper>();
                 

                 String cust = objAccount.Name.toUpperCase()+' ('+objAccount.Short_Name__c.toUpperCase()+')';

                 
                 layerSummaryObj.CustomerNameIdMap.put(objAccount.Id,objAccount.Name);

                 
                 //layerSummaryObj.SelectedMaskLayerValue = layerSummaryList.get(0).Name;
                 //layerSummaryObj.SelectedLayerStatusValue.add(layerSummaryList.get(0).Layer_Status__c);
                 //List<MRS_Layer_Chip_Association__c> MRSLCA = [select Id,Device_Id__c from MRS_Layer_Chip_Association__c where Layer__c =:layerSummaryList.get(0).Id];
                 //layerSummaryObj.SelectedDeviceIdValue = MRSLCA.get(0).Device_Id__c;
                 //layerSummaryObj.SelectedTechGeoStatusValue = layerSummaryList.get(0).Tech_Geo__c;

                 layerSummaryObj.ignoreFlagValues = false;

                 layerSummaryObj.selectedmst = objMST.Name;
                 layerSummaryObj.MSTIDString = String.valueOf(objMST.Id);
                 System.assertNotEquals(layerSummaryObj.selectedmst,null); 
                 //layerSummaryObj.groupFoundryJobviewer = true;
                 
                 layerSummaryObj.selectedCustomer = String.valueOf(objAccount.Id);
                 layerSummaryObj.selectedCustomerName = String.valueOf(objAccount.Name);
                 
                 //layerSummaryObj.SelectedMaskLayerValue = objLayer.Id;
                 //layerSummaryObj.SelectedLayerStatusValue.add('In Progress');
                 //layerSummaryObj.SelectedTechGeoStatusValue = layerSummaryList.get(0).Tech_Geo__c;
                 //layerSummaryObj.SelectedDeviceIdValue = '';
                 //layerSummaryObj.isCustomer = true;
                 layerSummaryObj.groupMDP = true;
                 layerSummaryObj.groupSwiftAdmin = false;
                 layerSummaryObj.groupFE = false;
                 layerSummaryObj.groupGlobalShuttle = true;
                 layerSummaryObj.groupTDTIMPW = true;
                 layerSummaryObj.ignoreFlagValues = true;
                 layerSummaryObj.isCustomer = false;
             layerSummaryObj.getSummary();

            Test.stopTest(); 
     }        
}

public static testmethod void getsummary3Test(){

        System.runAs(new User(Id = UserInfo.getUserId())){
   
             Test.startTest(); 
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 ApexPages.currentPage().getParameters().put('customerid','');
                 ApexPages.currentPage().getParameters().put('customer','');
                 ApexPages.currentPage().getParameters().put('mstid','');                 
                 
                 List<MRS_Layer_Association__c> layerSummaryList= [select name,Layer_Status__c,ID, Tech_Geo__c from MRS_Layer_Association__c];
                                                                                                                       
                 Test.setCurrentPage(Page.VFMRSLayerSummary);
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 Cookie account = new Cookie('account', '', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{account});
                 Cookie mst = new Cookie('mst', '', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{mst});
                 Cookie layerStatus = new Cookie('layerStatus', 'In Progress', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{layerStatus});
                 MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));             
                 System.assertNotEquals(layerSummaryObj,null);
                 List<MRSLayerSummaryExtn.LayerSummaryWrapper> LSWList = new List<MRSLayerSummaryExtn.LayerSummaryWrapper>();
                 

                 String cust = objAccount.Name.toUpperCase()+' ('+objAccount.Short_Name__c.toUpperCase()+')';

                 
                 layerSummaryObj.CustomerNameIdMap.put(objAccount.Id,objAccount.Name);

                 
                 //layerSummaryObj.SelectedMaskLayerValue = layerSummaryList.get(0).Name;
                 //layerSummaryObj.SelectedLayerStatusValue.add(layerSummaryList.get(0).Layer_Status__c);
                 //List<MRS_Layer_Chip_Association__c> MRSLCA = [select Id,Device_Id__c from MRS_Layer_Chip_Association__c where Layer__c =:layerSummaryList.get(0).Id];
                 //layerSummaryObj.SelectedDeviceIdValue = MRSLCA.get(0).Device_Id__c;
                 //layerSummaryObj.SelectedTechGeoStatusValue = layerSummaryList.get(0).Tech_Geo__c;

                 layerSummaryObj.ignoreFlagValues = false;

                 layerSummaryObj.selectedmst = objMST.Name;
                 layerSummaryObj.MSTIDString = String.valueOf(objMST.Id);
                 System.assertNotEquals(layerSummaryObj.selectedmst,null); 
                 //layerSummaryObj.groupFoundryJobviewer = true;
                 
                 layerSummaryObj.selectedCustomer = String.valueOf(objAccount.Id);
                 layerSummaryObj.selectedCustomerName = String.valueOf(objAccount.Name);
                 
                 //layerSummaryObj.SelectedMaskLayerValue = objLayer.Id;
                 //layerSummaryObj.SelectedLayerStatusValue.add('In Progress');
                 //layerSummaryObj.SelectedTechGeoStatusValue = layerSummaryList.get(0).Tech_Geo__c;
                 //layerSummaryObj.SelectedDeviceIdValue = '';
                 //layerSummaryObj.isCustomer = true;
                 layerSummaryObj.groupMDP = false;
                 layerSummaryObj.groupSwiftAdmin = false;
                 layerSummaryObj.groupFE = false;
                 layerSummaryObj.groupGlobalShuttle = true;
                 layerSummaryObj.groupTDTIMPW = true;
                 layerSummaryObj.ignoreFlagValues = true;
                 layerSummaryObj.isCustomer = false;
             layerSummaryObj.getSummary();

            Test.stopTest(); 
     }        
}

public static testmethod void getsummary4Test(){

        System.runAs(new User(Id = UserInfo.getUserId())){
   
             Test.startTest(); 
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 ApexPages.currentPage().getParameters().put('customerid','');
                 ApexPages.currentPage().getParameters().put('customer','');
                 ApexPages.currentPage().getParameters().put('mstid','');                 
                 
                 List<MRS_Layer_Association__c> layerSummaryList= [select name,Layer_Status__c,ID, Tech_Geo__c from MRS_Layer_Association__c];
                                                                                                                       
                 Test.setCurrentPage(Page.VFMRSLayerSummary);
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 Cookie account = new Cookie('account', '', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{account});
                 Cookie mst = new Cookie('mst', '', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{mst});
                 Cookie layerStatus = new Cookie('layerStatus', 'In Progress', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{layerStatus});
                 MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));             
                 System.assertNotEquals(layerSummaryObj,null);
                 List<MRSLayerSummaryExtn.LayerSummaryWrapper> LSWList = new List<MRSLayerSummaryExtn.LayerSummaryWrapper>();
                 

                 String cust = objAccount.Name.toUpperCase()+' ('+objAccount.Short_Name__c.toUpperCase()+')';

                 
                 layerSummaryObj.CustomerNameIdMap.put(objAccount.Id,objAccount.Name);

                 
                 //layerSummaryObj.SelectedMaskLayerValue = layerSummaryList.get(0).Name;
                 //layerSummaryObj.SelectedLayerStatusValue.add(layerSummaryList.get(0).Layer_Status__c);
                 //List<MRS_Layer_Chip_Association__c> MRSLCA = [select Id,Device_Id__c from MRS_Layer_Chip_Association__c where Layer__c =:layerSummaryList.get(0).Id];
                 //layerSummaryObj.SelectedDeviceIdValue = MRSLCA.get(0).Device_Id__c;
                 //layerSummaryObj.SelectedTechGeoStatusValue = layerSummaryList.get(0).Tech_Geo__c;

                 layerSummaryObj.ignoreFlagValues = false;

                 layerSummaryObj.selectedmst = objMST.Name;
                 layerSummaryObj.MSTIDString = String.valueOf(objMST.Id);
                 System.assertNotEquals(layerSummaryObj.selectedmst,null); 
                 //layerSummaryObj.groupFoundryJobviewer = true;
                 
                 layerSummaryObj.selectedCustomer = String.valueOf(objAccount.Id);
                 layerSummaryObj.selectedCustomerName = String.valueOf(objAccount.Name);
                 
                 //layerSummaryObj.SelectedMaskLayerValue = objLayer.Id;
                 //layerSummaryObj.SelectedLayerStatusValue.add('In Progress');
                 //layerSummaryObj.SelectedTechGeoStatusValue = layerSummaryList.get(0).Tech_Geo__c;
                 //layerSummaryObj.SelectedDeviceIdValue = '';
                 //layerSummaryObj.isCustomer = true;
                 layerSummaryObj.groupMDP = false;
                 layerSummaryObj.groupSwiftAdmin = true;
                 layerSummaryObj.groupFE = true;
                 layerSummaryObj.groupGlobalShuttle = false;
                 layerSummaryObj.groupTDTIMPW = false;
                 layerSummaryObj.ignoreFlagValues = true;
                 layerSummaryObj.isCustomer = false;
             layerSummaryObj.getSummary();

            Test.stopTest(); 
     }        
}

public static testmethod void SwitchTest(){

        System.runAs(new User(Id = UserInfo.getUserId())){
   
             Test.startTest(); 
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 ApexPages.currentPage().getParameters().put('customerid','');
                 ApexPages.currentPage().getParameters().put('customer','');
                 ApexPages.currentPage().getParameters().put('mstid','');                 
                 
                 List<MRS_Layer_Association__c> layerSummaryList= [select name,Layer_Status__c,ID, Tech_Geo__c from MRS_Layer_Association__c];
                                                                                                                       
                 Test.setCurrentPage(Page.VFMRSLayerSummary);
                 ApexPages.currentPage().getHeaders().put('Host',system.Label.SWIFT_Community_URL);
                 Cookie account = new Cookie('account', '', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{account});
                 Cookie mst = new Cookie('mst', '', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{mst});
                 Cookie layerStatus = new Cookie('layerStatus', 'In Progress', null, -1, false);
                 ApexPages.currentPage().setCookies(new Cookie[]{layerStatus});
                 MRSLayerSummaryExtn layerSummaryObj = new MRSLayerSummaryExtn(new apexpages.StandardController(new MRS_Layer_Association__c()));             
                 System.assertNotEquals(layerSummaryObj,null);
                 List<MRSLayerSummaryExtn.LayerSummaryWrapper> LSWList = new List<MRSLayerSummaryExtn.LayerSummaryWrapper>();
                 LSWList.add(new MRSLayerSummaryExtn.LayerSummaryWrapper(layerSummaryList.get(0),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now()),String.valueOf(System.now())));
                 //new LayerSummaryWrapper(temp,System.now(),System.now(),System.now(),System.now(),System.now(),System.now(),System.now(),System.now(),System.now(),System.now(),System.now(),System.now(),System.now(),System.now(),System.now(),System.now(),System.now(),System.now(),System.now(),System.now(),System.now(),System.now())

                 String cust = objAccount.Name.toUpperCase()+' ('+objAccount.Short_Name__c.toUpperCase()+')';

                 
                 layerSummaryObj.CustomerNameIdMap.put(objAccount.Id,objAccount.Name);

                 
                 //layerSummaryObj.SelectedMaskLayerValue = layerSummaryList.get(0).Name;
                 //layerSummaryObj.SelectedLayerStatusValue.add(layerSummaryList.get(0).Layer_Status__c);
                 //List<MRS_Layer_Chip_Association__c> MRSLCA = [select Id,Device_Id__c from MRS_Layer_Chip_Association__c where Layer__c =:layerSummaryList.get(0).Id];
                 //layerSummaryObj.SelectedDeviceIdValue = MRSLCA.get(0).Device_Id__c;
                 //layerSummaryObj.SelectedTechGeoStatusValue = layerSummaryList.get(0).Tech_Geo__c;

                 layerSummaryObj.ignoreFlagValues = false;

                 layerSummaryObj.selectedmst = objMST.Name;
                 layerSummaryObj.MSTIDString = String.valueOf(objMST.Id);
                 System.assertNotEquals(layerSummaryObj.selectedmst,null); 
                 //layerSummaryObj.groupFoundryJobviewer = true;
                 
                 layerSummaryObj.selectedCustomer = String.valueOf(objAccount.Id);
                 layerSummaryObj.selectedCustomerName = String.valueOf(objAccount.Name);
                 
                 //layerSummaryObj.SelectedMaskLayerValue = objLayer.Id;
                 //layerSummaryObj.SelectedLayerStatusValue.add('In Progress');
                 //layerSummaryObj.SelectedTechGeoStatusValue = layerSummaryList.get(0).Tech_Geo__c;
                 //layerSummaryObj.SelectedDeviceIdValue = '';
                 //layerSummaryObj.isCustomer = true;
                 layerSummaryObj.groupMDP = false;
                 layerSummaryObj.groupSwiftAdmin = true;
                 layerSummaryObj.groupFE = true;
                 layerSummaryObj.groupGlobalShuttle = false;
                 layerSummaryObj.groupTDTIMPW = false;
                 layerSummaryObj.ignoreFlagValues = false;
                 layerSummaryObj.isCustomer = false;
                 layerSummaryObj.requirement4.addAll(LSWList); 
                //layerSummaryObj.switch();

            Test.stopTest(); 
     }        
}

/**
    This method creates test data : MRS Permission Config (Custom Settings)
    @method name: createPermissionConfigValues
    @parameter:   None
    @return :     None
**/    
    private static void createPermissionConfigValues(){
     List<MRS_Fields_Permission_Config__c> TotalPermissionConfig = new List<MRS_Fields_Permission_Config__c>();
     MRS_Fields_Permission_Config__c GlobalShuttle = new MRS_Fields_Permission_Config__c();
     GlobalShuttle.Name = 'SWIFT_GlobalShuttle';
     GlobalShuttle.CustomerRemoteJobviewFrame__c = true;
     GlobalShuttle.CustomerRemoteJobviewPrime__c = true;
     GlobalShuttle.DRW__c = true;
     GlobalShuttle.FoundryRemoteJobviewFrame__c = true;
     GlobalShuttle.FoundryRemoteJobviewPrime__c = true;
     GlobalShuttle.FrameMockupCustomer__c = true;
     GlobalShuttle.FrameMockupFoundry__c = true;
     GlobalShuttle.GDSOUTReviewCustomer__c = true;
     GlobalShuttle.GDSOUTReviewFoundry__c = true;
     GlobalShuttle.MEBESJobviewCustomer__c = true;
     GlobalShuttle.MEBESJobviewFoundry__c = true;
     GlobalShuttle.MEBESJobviewGlobalShuttle__c = true;
     GlobalShuttle.MEBESJobviewMDP__c = true;
     GlobalShuttle.MEBESJobviewTapeoutAPPLICATIONS__c = true;
     GlobalShuttle.MEBESJobviewTapeoutCenter__c = true;
     GlobalShuttle.MEBESJobviewTDTIMPW__c = true;
     GlobalShuttle.MEBESReceivedFrame__c = true;
     GlobalShuttle.MEBESReceivedPrime__c = true;
     GlobalShuttle.ORC__c = true;
     GlobalShuttle.SendDataFrame__c = true;
     GlobalShuttle.SendDataPrime__c = true;
     
     TotalPermissionConfig.add(GlobalShuttle);
     
     MRS_Fields_Permission_Config__c MDP = new MRS_Fields_Permission_Config__c();
     MDP.Name = 'SWIFT_MDP';
     MDP.CustomerRemoteJobviewFrame__c = true;
     MDP.CustomerRemoteJobviewPrime__c = true;
     MDP.DRW__c = true;
     MDP.FoundryRemoteJobviewFrame__c = true;
     MDP.FoundryRemoteJobviewPrime__c = true;
     MDP.FrameMockupCustomer__c = true;
     MDP.FrameMockupFoundry__c = true;
     MDP.GDSOUTReviewCustomer__c = true;
     MDP.GDSOUTReviewFoundry__c = true;
     MDP.MEBESJobviewCustomer__c = true;
     MDP.MEBESJobviewFoundry__c = true;
     MDP.MEBESJobviewGlobalShuttle__c = true;
     MDP.MEBESJobviewMDP__c = true;
     MDP.MEBESJobviewTapeoutAPPLICATIONS__c = true;
     MDP.MEBESJobviewTapeoutCenter__c = true;
     MDP.MEBESJobviewTDTIMPW__c = true;
     MDP.MEBESReceivedFrame__c = true;
     MDP.MEBESReceivedPrime__c = true;
     MDP.ORC__c = true;
     MDP.SendDataFrame__c = true;
     MDP.SendDataPrime__c = true;
          
     TotalPermissionConfig.add(MDP);  

     MRS_Fields_Permission_Config__c Admin = new MRS_Fields_Permission_Config__c();
     Admin.Name = 'SWIFT_Admin';
     Admin.CustomerRemoteJobviewFrame__c = true;
     Admin.CustomerRemoteJobviewPrime__c = true;
     Admin.DRW__c = true;
     Admin.FoundryRemoteJobviewFrame__c = true;
     Admin.FoundryRemoteJobviewPrime__c = true;
     Admin.FrameMockupCustomer__c = true;
     Admin.FrameMockupFoundry__c = true;
     Admin.GDSOUTReviewCustomer__c = true;
     Admin.GDSOUTReviewFoundry__c = true;
     Admin.MEBESJobviewCustomer__c = true;
     Admin.MEBESJobviewFoundry__c = true;
     Admin.MEBESJobviewGlobalShuttle__c = true;
     Admin.MEBESJobviewMDP__c = true;
     Admin.MEBESJobviewTapeoutAPPLICATIONS__c = true;
     Admin.MEBESJobviewTapeoutCenter__c = true;
     Admin.MEBESJobviewTDTIMPW__c = true;
     Admin.MEBESReceivedFrame__c = true;
     Admin.MEBESReceivedPrime__c = true;
     Admin.ORC__c = true;
     Admin.SendDataFrame__c = true;
     Admin.SendDataPrime__c = true;
          
     TotalPermissionConfig.add(Admin);

     MRS_Fields_Permission_Config__c RMG = new MRS_Fields_Permission_Config__c();
     RMG.Name = 'Swift_RMG';
     RMG.CustomerRemoteJobviewFrame__c = true;
     RMG.CustomerRemoteJobviewPrime__c = true;
     RMG.DRW__c = true;
     RMG.FoundryRemoteJobviewFrame__c = true;
     RMG.FoundryRemoteJobviewPrime__c = true;
     RMG.FrameMockupCustomer__c = true;
     RMG.FrameMockupFoundry__c = true;
     RMG.GDSOUTReviewCustomer__c = true;
     RMG.GDSOUTReviewFoundry__c = true;
     RMG.MEBESJobviewCustomer__c = true;
     RMG.MEBESJobviewFoundry__c = true;
     RMG.MEBESJobviewGlobalShuttle__c = true;
     RMG.MEBESJobviewMDP__c = true;
     RMG.MEBESJobviewTapeoutAPPLICATIONS__c = true;
     RMG.MEBESJobviewTapeoutCenter__c = true;
     RMG.MEBESJobviewTDTIMPW__c = true;
     RMG.MEBESReceivedFrame__c = true;
     RMG.MEBESReceivedPrime__c = true;
     RMG.ORC__c = true;
     RMG.SendDataFrame__c = true;
     RMG.SendDataPrime__c = true;
     
     TotalPermissionConfig.add(RMG);

     MRS_Fields_Permission_Config__c Support = new MRS_Fields_Permission_Config__c();
     Support.Name = 'SWIFT_Support';
     Support.CustomerRemoteJobviewFrame__c = true;
     Support.CustomerRemoteJobviewPrime__c = true;
     Support.DRW__c = true;
     Support.FoundryRemoteJobviewFrame__c = true;
     Support.FoundryRemoteJobviewPrime__c = true;
     Support.FrameMockupCustomer__c = true;
     Support.FrameMockupFoundry__c = true;
     Support.GDSOUTReviewCustomer__c = true;
     Support.GDSOUTReviewFoundry__c = true;
     Support.MEBESJobviewCustomer__c = true;
     Support.MEBESJobviewFoundry__c = true;
     Support.MEBESJobviewGlobalShuttle__c = true;
     Support.MEBESJobviewMDP__c = true;
     Support.MEBESJobviewTapeoutAPPLICATIONS__c = true;
     Support.MEBESJobviewTapeoutCenter__c = true;
     Support.MEBESJobviewTDTIMPW__c = true;
     Support.MEBESReceivedFrame__c = true;
     Support.MEBESReceivedPrime__c = true;
     Support.ORC__c = true;
     Support.SendDataFrame__c = true;
     Support.SendDataPrime__c = true;
     
     TotalPermissionConfig.add(Support);

     MRS_Fields_Permission_Config__c TapeoutApplication = new MRS_Fields_Permission_Config__c();
     TapeoutApplication.Name = 'Swift_Tapeout_Application';
     TapeoutApplication.CustomerRemoteJobviewFrame__c = true;
     TapeoutApplication.CustomerRemoteJobviewPrime__c = true;
     TapeoutApplication.DRW__c = true;
     TapeoutApplication.FoundryRemoteJobviewFrame__c = true;
     TapeoutApplication.FoundryRemoteJobviewPrime__c = true;
     TapeoutApplication.FrameMockupCustomer__c = true;
     TapeoutApplication.FrameMockupFoundry__c = true;
     TapeoutApplication.GDSOUTReviewCustomer__c = true;
     TapeoutApplication.GDSOUTReviewFoundry__c = true;
     TapeoutApplication.MEBESJobviewCustomer__c = true;
     TapeoutApplication.MEBESJobviewFoundry__c = true;
     TapeoutApplication.MEBESJobviewGlobalShuttle__c = true;
     TapeoutApplication.MEBESJobviewMDP__c = true;
     TapeoutApplication.MEBESJobviewTapeoutAPPLICATIONS__c = true;
     TapeoutApplication.MEBESJobviewTapeoutCenter__c = true;
     TapeoutApplication.MEBESJobviewTDTIMPW__c = true;
     TapeoutApplication.MEBESReceivedFrame__c = true;
     TapeoutApplication.MEBESReceivedPrime__c = true;
     TapeoutApplication.ORC__c = true;
     TapeoutApplication.SendDataFrame__c = true;
     TapeoutApplication.SendDataPrime__c = true;
     
     TotalPermissionConfig.add(TapeoutApplication);

     MRS_Fields_Permission_Config__c TapeoutCentre = new MRS_Fields_Permission_Config__c();
     TapeoutCentre.Name = 'SWIFT_Tapeout_Centre';
     TapeoutCentre.CustomerRemoteJobviewFrame__c = true;
     TapeoutCentre.CustomerRemoteJobviewPrime__c = true;
     TapeoutCentre.DRW__c = true;
     TapeoutCentre.FoundryRemoteJobviewFrame__c = true;
     TapeoutCentre.FoundryRemoteJobviewPrime__c = true;
     TapeoutCentre.FrameMockupCustomer__c = true;
     TapeoutCentre.FrameMockupFoundry__c = true;
     TapeoutCentre.GDSOUTReviewCustomer__c = true;
     TapeoutCentre.GDSOUTReviewFoundry__c = true;
     TapeoutCentre.MEBESJobviewCustomer__c = true;
     TapeoutCentre.MEBESJobviewFoundry__c = true;
     TapeoutCentre.MEBESJobviewGlobalShuttle__c = true;
     TapeoutCentre.MEBESJobviewMDP__c = true;
     TapeoutCentre.MEBESJobviewTapeoutAPPLICATIONS__c = true;
     TapeoutCentre.MEBESJobviewTapeoutCenter__c = true;
     TapeoutCentre.MEBESJobviewTDTIMPW__c = true;
     TapeoutCentre.MEBESReceivedFrame__c = true;
     TapeoutCentre.MEBESReceivedPrime__c = true;
     TapeoutCentre.ORC__c = true;
     TapeoutCentre.SendDataFrame__c = true;
     TapeoutCentre.SendDataPrime__c = true;
     
     TotalPermissionConfig.add(TapeoutCentre);

     MRS_Fields_Permission_Config__c TapeoutOperations = new MRS_Fields_Permission_Config__c();
     TapeoutOperations.Name = 'SWIFT_Tapeout_Operations';
     TapeoutOperations.CustomerRemoteJobviewFrame__c = true;
     TapeoutOperations.CustomerRemoteJobviewPrime__c = true;
     TapeoutOperations.DRW__c = true;
     TapeoutOperations.FoundryRemoteJobviewFrame__c = true;
     TapeoutOperations.FoundryRemoteJobviewPrime__c = true;
     TapeoutOperations.FrameMockupCustomer__c = true;
     TapeoutOperations.FrameMockupFoundry__c = true;
     TapeoutOperations.GDSOUTReviewCustomer__c = true;
     TapeoutOperations.GDSOUTReviewFoundry__c = true;
     TapeoutOperations.MEBESJobviewCustomer__c = true;
     TapeoutOperations.MEBESJobviewFoundry__c = true;
     TapeoutOperations.MEBESJobviewGlobalShuttle__c = true;
     TapeoutOperations.MEBESJobviewMDP__c = true;
     TapeoutOperations.MEBESJobviewTapeoutAPPLICATIONS__c = true;
     TapeoutOperations.MEBESJobviewTapeoutCenter__c = true;
     TapeoutOperations.MEBESJobviewTDTIMPW__c = true;
     TapeoutOperations.MEBESReceivedFrame__c = true;
     TapeoutOperations.MEBESReceivedPrime__c = true;
     TapeoutOperations.ORC__c = true;
     TapeoutOperations.SendDataFrame__c = true;
     TapeoutOperations.SendDataPrime__c = true;
     
     TotalPermissionConfig.add(TapeoutOperations);

     MRS_Fields_Permission_Config__c TDTIMPW = new MRS_Fields_Permission_Config__c();
     TDTIMPW.Name = 'SWIFT_TDTI-MPW';
     TDTIMPW.CustomerRemoteJobviewFrame__c = true;
     TDTIMPW.CustomerRemoteJobviewPrime__c = true;
     TDTIMPW.DRW__c = true;
     TDTIMPW.FoundryRemoteJobviewFrame__c = true;
     TDTIMPW.FoundryRemoteJobviewPrime__c = true;
     TDTIMPW.FrameMockupCustomer__c = true;
     TDTIMPW.FrameMockupFoundry__c = true;
     TDTIMPW.GDSOUTReviewCustomer__c = true;
     TDTIMPW.GDSOUTReviewFoundry__c = true;
     TDTIMPW.MEBESJobviewCustomer__c = true;
     TDTIMPW.MEBESJobviewFoundry__c = true;
     TDTIMPW.MEBESJobviewGlobalShuttle__c = true;
     TDTIMPW.MEBESJobviewMDP__c = true;
     TDTIMPW.MEBESJobviewTapeoutAPPLICATIONS__c = true;
     TDTIMPW.MEBESJobviewTapeoutCenter__c = true;
     TDTIMPW.MEBESJobviewTDTIMPW__c = true;
     TDTIMPW.MEBESReceivedFrame__c = true;
     TDTIMPW.MEBESReceivedPrime__c = true;
     TDTIMPW.ORC__c = true;
     TDTIMPW.SendDataFrame__c = true;
     TDTIMPW.SendDataPrime__c = true;
     
     TotalPermissionConfig.add(TDTIMPW);
     
     insert TotalPermissionConfig; 
     for(MRS_Fields_Permission_Config__c obj : TotalPermissionConfig){
         System.assertNotEquals(obj.Id,null);
     } 
     
    }

/**
    This method creates test data : MRS Layer Chip Association
    @method name: createMRSLCAData
    @parameter:   
                1) MRS Chip Details Id
                2) PTRF Id
                3) Account Id
                4) MRS Layer Association Id
                5) Mask Set Title Name
    @return :   MRS Layer Chip Association Object
**/   
    public static MRS_Layer_Chip_Association__c createMRSLCAData(String MRSChipDetailsId, String PTRFId, String AccountId, String MRSLCAId,String MaskSetTitleName){
        MRS_Layer_Chip_Association__c obj = new MRS_Layer_Chip_Association__c();
        obj.Chip__c = MRSChipDetailsId;
        obj.PTRF__c = PTRFId;
        obj.Name = 'ChipName1';
        obj.Chip_Hold_Warning__c = 'Hold Warning Waive';
        obj.Customer_Name__c = AccountId;
        obj.Device_Id__c = 'Device1';
        obj.Layer__c = MRSLCAId;

        insert obj;
        System.assertNotEquals(obj.Id,null);
        return obj;
    }
    
/**
    This method creates test data : MRS Chip Details
    @method name: createMRSChipDetail
    @parameter:   
                1) Mask Set Title Name
                2) MRS Object Id
    @return :   MRS Chip Details Object
**/
    public static MRS_Chip_Details__c createMRSChipDetail(String MaskSetTitleName,String MRSId){
        MRS_Chip_Details__c obj = new MRS_Chip_Details__c();
        obj.MRS__c = MRSId;
        obj.Name = 'TestChip';
        insert obj;
        System.assertNotEquals(obj.Id,null);
        return obj;
    }
  
/**
    This method creates test data : MRS Layer Association
    @method name: createMRSData
    @parameter:   
                1) Layer Name
                2) Mask Layer Revision
                3) Mask Set Title Name
                4) MRS Object Id
    @return :   MRS Layer Association Object
**/ 
    public static MRS_Layer_Association__c createMRSData(String LayerName, String MaskLayerRev, String MaskSetTitleName,String MRSObjId){
        MRS_Layer_Association__c MRSObj = new MRS_Layer_Association__c();
        MRSObj.Customer_Frame_Mockup_Date__c = System.now();
        MRSObj.Customer_Frame_Mockup__c = 'Not Ready';
        MRSObj.Customer_Frame_Remote_Jobview_Setup_Date__c = System.now();
        MRSObj.Customer_Frame_Remote_Jobview_Setup__c = 'Done';
        MRSObj.Customer_GDSOUT_Review_Date__c = System.now();
        MRSObj.Customer_GDSOUT_Review__c = 'In Progress';
        MRSObj.Customer_MEBES_Jobview_Date__c = System.now();  
        MRSObj.Customer_MEBES_Jobview__c = 'In Progress';
        MRSObj.Customer_Prime_Remote_Jobview_Setup_Date__c = System.now(); 
        MRSObj.Customer_Prime_Remote_Jobview_Setup__c = 'Done';
        MRSObj.Disapprove_Reason_For_Frame_Mockup_Revie__c = 'Disaproved';
        MRSObj.DRW_Date__c = System.now();
        MRSObj.DRW__c = 'Not Ready';
        MRSObj.Error_Message_Oracle_DB__c = '';
        MRSObj.First_Sync_with_Oracle__c = false;
        MRSObj.Foundry_Frame_Mockup_Date__c = System.now();
        MRSObj.Foundry_Frame_Mockup__c = 'In Progress';
        MRSObj.Foundry_Frame_Remote_Jobview_Setup_Date__c = System.now();  
        MRSObj.Foundry_Frame_Remote_Jobview_Setup__c = 'Done';
        MRSObj.Foundry_GDSOUT_Review_Date__c = System.now();
        MRSObj.Foundry_GDSOUT_Review__c = 'In Progress';
        MRSObj.Foundry_MEBES_Jobview_Date__c = System.now();
        MRSObj.Foundry_MEBES_Jobview__c = 'Ready';
        MRSObj.Foundry_Prime_Remote_Jobview_Setup_Date__c = System.now();
        MRSObj.Foundry_Prime_Remote_Jobview_Setup__c = 'Done';
        MRSObj.Frame_MEBES_Received_Date__c = System.now();
        MRSObj.Frame_MEBES_Received__c = 'Not Done';
        MRSObj.Generated_Mask_Title__c = '';
        MRSObj.GlobalShuttle_MEBES_Jobview_Date__c = System.now();
        MRSObj.GlobalShuttle_MEBES_Jobview__c = 'Not Ready';
        MRSObj.Hold_Warning__c = '';
        MRSObj.Layer_Name__c = LayerName;
        MRSObj.Layer_Status_Date__c = System.now();
        MRSObj.Layer_Status__c = 'In Progress';
        MRSObj.Mask_Layer_Rev__c = MaskLayerRev;
        MRSObj.MDP_MEBES_Jobview_Date__c = System.now();
        MRSObj.MDP_MEBES_Jobview__c = 'In Progress';
        MRSObj.MRS__c = MRSObjId;
        MRSObj.Name = LayerName;
        MRSObj.ORC_Date__c = System.now();
        MRSObj.ORC__c = 'Done';
        MRSObj.Prime_MEBES_Received_Date__c = System.now();
        MRSObj.Prime_MEBES_Received__c = 'Not Done';
        MRSObj.Reticle_Type__c = 'Multi Node Reticle (MNR)';
        MRSObj.ROM_Code__c = '123';
        MRSObj.Send_Frame_Data_Date__c = System.now();
        MRSObj.Send_Frame_Data__c = 'Not Done';
        MRSObj.Send_Prime_Data_Date__c = System.now();
        MRSObj.Send_Prime_Data__c = 'Not Done';
        MRSObj.Tapeout_Applications_MEBES_Jobview_Date__c = System.now();
        MRSObj.Tapeout_Applications_MEBES_Jobview__c = 'Not Ready';
        MRSObj.Tapeout_Centre_MEBES_Jobview_Date__c = System.now();
        MRSObj.Tapeout_Centre_MEBES_Jobview__c = 'In Progress';
        MRSObj.TDTI_MPW_MEBES_Jobview_Date__c = System.now();  
        MRSObj.TDTI_MPW_MEBES_Jobview__c = 'Not Ready';
        MRSObj.Tech_Geo__c = '0.018UM';
        insert MRSObj;
        System.assertNotEquals(MRSObj.Id,null);
        return MRSObj;
    }
    
/**
    This method creates test data : MRS Object
    @method name: createMRS
    @parameter:   None
    @return :     MRS Object
**/
    public static MRS__c createMRS(){
        MRS__c obj = new MRS__c();
        obj.Associated_PTRF__c = objPTRF.Id;
        obj.Mask_Set_Title__c = objMST.Id;
        obj.MRS_Package_Sync__c = false;
        insert obj;
        System.assertNotEquals(obj.Id,null);
        return obj;
    }

/**
    This method creates test data : Mask Layer
    @method name: createMaskLayer
    @parameter:   
                1) PTRF Object
                2) Mask Set Title Object
                3) Layer Name
                4) ROM Code
                5) Layer Revision
    @return :     Mask Layer Object
**/     
    private static Mask_Layer__c createMaskLayer(PTRF__c ptrf,Mask_Set_Title__c  MSTObj,string Layername,string RomCode, string LayerRev ){
        
        Mask_Layer__c maskLayer = new Mask_Layer__c();
        maskLayer.Tapeout__c = true;
        maskLayer.Name = Layername; 
        maskLayer.Mask_Layer_Number__c = Layername;
        maskLayer.Mask_Set_Title__c  =MSTObj.id;
        maskLayer.PTRF__c = ptrf.Id;
        maskLayer.ROM_Code__c = RomCode;
        maskLayer.Mask_Layer_Rev__c =LayerRev ; 
        maskLayer.LogicalOperation__c = 'Foundry Std'; 
        maskLayer.LogicalOperationType__c = 'Foundry Std.';
        maskLayer.Sort_Order__c = 1;
        insert maskLayer;
        System.assertNotEquals(maskLayer.Id,null);
        return maskLayer;
    }

/**
    This method creates test data : PTRF
    @method name: createPTRF
    @parameter:   
                1) PTRF Name
                2) Mask Set Title Object
                3) Device Id
    @return :     PTRF Object
**/      
     private static PTRF__c createPTRF(string ptrfname,Mask_Set_Title__c  MSTObj,String DeviceId){
        
        PTRF__c ptrf = new PTRF__c();
        
        ptrf.Status__c = 'Active';
        ptrf.Mask_Set_Title__c=MSTObj.id;
        ptrf.MaskSetTitle__c=MSTObj.id;
        ptrf.Device_Id__c=DeviceId;
        ptrf.Transaction_Date__c = Date.today();
        ptrf.Process_ID__c='';
        ptrf.Prime_Tapeout__c = true;
        ptrf.Prime_Status__c = '';
        ptrf.Prime_DRT__c =''; 
        ptrf.Name = ptrfname;
        ptrf.Customer__c = objAccount.Id;
        ptrf.Order_Type__c ='Retrofit';
        ptrf.Frame_Status__c = '';
        ptrf.Frame_Mockup__c = true;
        ptrf.Frame_GDSOUT_Review__c = false;
        ptrf.Frame_DRT__c = ''; 
        ptrf.Frame_Tapeout__c = true;
        ptrf.DRC_Only__c = false;
        ptrf.Prime_GDSOUT_Review__c = true;
        ptrf.Device__c = null;
        ptrf.Recticle_Type__c = 'Multi Layer Reticle (MLR)';
        insert ptrf;
        System.assertNotEquals(ptrf.Id,null);
        return ptrf;
    } 
   
/**
    This method creates test data : Account
    @method name: createTestAccount
    @parameter:   None
    @return :     None
**/     
     public static Account createTestAccount(){
          Account acc;
           
            acc = new Account(
            name = 'TEST rec',
            Account_Type__c='Customer',
            stage__c = 'Unqualified',
            short_name__c = 'TESTrec',
            sub_type__c= 'Direct',
            site_department__c = 'test dept',
            transaction_type__c = 'transactional',
            account_profile__c = 'Fabless - Emerging',
            Process_Tech_Interested__c = 'Mature (> 0.11um)',
            region__c = 'APJ',
            Market_Segment__c = 'Mobility',
            Sales_Territory__c = 'APJ-Japan',
            FE_Territory__c = 'APJ-FE-JAPAN',
            financial_territory__c = 'APJ-Japan',
            Corporate_Address_1__c = '50 water st',
             Bill_To_Address_1__c= '50 water st',
            Corporate_City__c = 'Lee',
            Bill_To_City__c='Lee',
            Corporate_Country__c = 'Japan',
             Bill_To_Country__c='Japan',
            Organization_Unit__c = 'GF Investment LLC OU',
            bill_to_location__c = 'YES',
            total_employee__c = 100,
            end_customer__c = 'people',
            Revenue_Potential__c = 'High Potential',
            Customer_Number__c='',
            Target_Account__c = 'Yes',
            siebel_account_id__c='1111'
        );
        insert acc;
        System.assertNotEquals(acc.Id,null);
        return acc;
    } 
    
/**
    This method creates test data : Opportunity
    @method name: createOpportunity
    @parameter:   AccountId
    @return :     None
**/     
     private static Id createOpportunity(Id testAcctId) {
       Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','MRSLayerSummary');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }

/**
    This method fetches the profile Id of with profile name = GF FAE/FTS
    @method name: FEUserProfileId
    @parameter:   User object
    @return :     Id of the profile
**/ 
    public static Id FEUserProfileId(User u){
        Profile FEUserProfile = new Profile();
        System.runAs(u){
            FEUserProfile = [SELECT Id FROM Profile WHERE Name='GF FAE/FTS'];
        }
        System.assertNotEquals(FEUserProfile.Id,null);
        return FEUserProfile.Id;
    }

/**
    This method fetches the profile Id of with profile name = GF Sales User
    @method name: StandardUserProfileId
    @parameter:   User object
    @return :     Id of the profile
**/     
    public static Id StandardUserProfileId(User u){
        Profile StandardUserProfile = new Profile();
        System.runAs(u){
            StandardUserProfile = [SELECT Id FROM Profile WHERE Name='GF Sales User'];
        }
        System.assertNotEquals(StandardUserProfile.Id,null);
        return StandardUserProfile.Id;
    }    

/**
    This method is for creating test data : User
    @method name: createSysAdminUser
    @parameter:   User object
    @return :     None
**/    
     public static void createSysAdminUser(User u){
            
            List<String> MRSPermName = new List<String>();
            List<MRS_Fields_Permission_Config__c> FPC = [SELECT Name FROM MRS_Fields_Permission_Config__c];
            for(MRS_Fields_Permission_Config__c obj : FPC){
                MRSPermName.add(String.valueOf(obj.Name));
            }
            List<Group> ListOfGroups = [select Id, DeveloperName, Name from Group where Name in:MRSPermName];
            
            List<GroupMember> GM = new List<GroupMember>();
            for(Group g : ListOfGroups){
                if(g.Name.equalsIgnoreCase('Swift GlobalShuttle')||g.Name.equalsIgnoreCase('Swift MDP')||g.Name.equalsIgnoreCase('SWIFT Support')||g.Name.equalsIgnoreCase('Swift Tapeout Application')||g.Name.equalsIgnoreCase('Swift Tapeout Operations')||g.Name.equalsIgnoreCase('Swift Tapeout Centre')||g.Name.equalsIgnoreCase('Swift TDTI-MPW')){
                    GroupMember singleGroupMemberObj = new GroupMember();
                    singleGroupMemberObj.GroupId = g.Id;
                    singleGroupMemberObj.UserOrGroupId = u.Id;
                    GM.add(singleGroupMemberObj);
                }
            }
            insert GM;                    
            System.assertNotEquals(GM.size(),0);         
    }    

/**
    This method is for creating test data : Groups
    @method name: createGroups
    @parameter:   None
    @return :     List of Group objects
**/     
    public static List<Group> createGroups(){
        List<Group> groupList = new List<Group>();
        Group MDP = new Group();
        Group SwiftAdmin = new Group();
        Group SwiftGlobalShuttle = new Group();
        
        MDP.DeveloperName = 'Swift_MDP';
        MDP.DoesIncludeBosses = true;
        MDP.DoesSendEmailToMembers = false;
        MDP.Name = 'Swift MDP';
        MDP.Type = 'Regular';

        SwiftAdmin.DeveloperName = 'SWIFT_Admin';
        SwiftAdmin.DoesIncludeBosses = true;
        SwiftAdmin.DoesSendEmailToMembers = false;
        SwiftAdmin.Name = 'SWIFT Admin';
        SwiftAdmin.Type = 'Regular';
        
        SwiftGlobalShuttle.DeveloperName = 'Swift_GlobalShuttle';
        SwiftGlobalShuttle.DoesIncludeBosses = true;
        SwiftGlobalShuttle.DoesSendEmailToMembers = false;
        SwiftGlobalShuttle.Name = 'Swift GlobalShuttle';
        SwiftGlobalShuttle.Type = 'Regular';   
        
        groupList.add(MDP);     
        groupList.add(SwiftGlobalShuttle);
        
        insert groupList; 
        System.assertNotEquals(groupList.size(),0);
        return groupList;               
    }

/**
    This method is for creating test data : Customer Layer Summary Permission
    @method name: createCustomerPermission
    @parameter:   None
    @return :     Object of Customer_Layer_Summary_Permission__c
**/     
   public static Customer_Layer_Summary_Permission__c createCustomerPermission(){

       Customer_Layer_Summary_Permission__c customerPermission = new Customer_Layer_Summary_Permission__c();
       customerPermission.Customer__c = objAccount.Id;
       customerPermission.Customer_Remote_Jobview__c = true;
       customerPermission.Frame_Mockup__c = true;
       customerPermission.GDSOUT_Review__c = true;
       customerPermission.MEBES_Jobview__c = true;
       insert customerPermission;
       System.assertNotEquals(customerPermission.Id,null);
       return customerPermission;
   }
}