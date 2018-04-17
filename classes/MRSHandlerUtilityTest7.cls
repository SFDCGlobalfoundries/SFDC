@isTest(SeeAllData=false)
public class MRSHandlerUtilityTest7 {
    
    @testSetup 
    static void setup() {
        Test.startTest();
        
        SwiftDataUtilityTest.customSystemData();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT0');            
        fieldValueMap.put('Short_Name__c', 'data00');    
        fieldValueMap.put('Has_Valid_NDA__c', true);      
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Copy_Address__c', true);                             
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Account_Type__c','Customer');
        fieldValueMap.put('Organization_Unit__c','sg;us');
        fieldValueMap.put('New_Organization_Unit_Request__c','gf');
        fieldValueMap.put('Financial_Territory__c','Greater China');
        fieldValueMap.put('stage__c','Unqualified');
        fieldValueMap.put('Siebel_Status__c','SUCCESS');
        fieldValueMap.put('Account_Present_In_OT__c', true);
        fieldValueMap.put('Valid_Tech_Geos__c', '0.007UM');
        fieldValueMap.put('Tech_Geo_Granted__c', '0.010UM');
        fieldValueMap.put('Has_Valid_NDA__c', true);
        
        Account accObj = AccountDataFactory.createAccount(fieldValueMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', accObj.id);
        Opportunity oppObj = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValuepoppProgramMap = new Map<String,Object>();
        fieldValuepoppProgramMap.put('Account__c', accObj.id);
        fieldValuepoppProgramMap.put('Opportunity__c', oppObj.id);
        Opportunity_Program__c oppProgramObj = OpportunityProgramDataFactory.createOpportunityProgram(fieldValuepoppProgramMap);
        
        Test.stopTest();
    }
    
    @isTest
    public static void testRun1() {
        Test.startTest();
        
        Account accObj = getAccount('MYTEST ACCOUNT0');
        Opportunity oppObj = [SELECT Id FROM Opportunity LIMIT 1];
        Opportunity_Program__c oppProgObj = [SELECT Id FROM Opportunity_Program__c LIMIT 1];
        
        List<Mask_Set_Title__c> mstList = SwiftDataUtilityTest.maskSetTitleList(2);
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(accObj.Id, oppObj.Id,oppProgObj.Id,pt.Id);
        
        PTRF__c ptrf = SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id, accObj.Id);
        ptrf.Prime_Tapeout__c = TRUE;
        ptrf.Frame_Tapeout__c = TRUE;
        update ptrf;
        
        MRS__c objMRS = SwiftDataUtilityTest.createMrs(mstList[0].Id);
        
        List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
        MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
        listMRSLA.add(objMRSLA1);
        MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
        listMRSLA.add(objMRSLA2);
        insert listMRSLA;   
        
        List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
        MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip001');
        listMRSCD.add(objMRSCD1);
        MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip002');
        listMRSCD.add(objMRSCD2);
        MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
        listMRSCD.add(objMRSCD3);
        insert listMRSCD;
        
        List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
        MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=ptrf.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        listMRSLCA.add(objMRSLCA1);
        MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=ptrf.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        listMRSLCA.add(objMRSLCA2);
        insert listMRSLCA;
        
        MRSHandlerUtility.deselectChipInPTRF(new Set<String>{ptrf.Id} , new Set<String>{objMRSCD1.Name});
        
        Test.stopTest();
    }
    
    @isTest
    public static void testRun2() {
        Test.startTest();
        
        Account accObj = getAccount('MYTEST ACCOUNT0');
        Opportunity oppObj = [SELECT Id FROM Opportunity LIMIT 1];
        Opportunity_Program__c oppProgObj = [SELECT Id FROM Opportunity_Program__c LIMIT 1];
        
        List<Mask_Set_Title__c> mstList = SwiftDataUtilityTest.maskSetTitleList(2);
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(accObj.Id, oppObj.Id,oppProgObj.Id,pt.Id);
        
        PTRF__c ptrf = SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id, accObj.Id);
        ptrf.Prime_Tapeout__c = TRUE;
        ptrf.Frame_Tapeout__c = TRUE;
        update ptrf;
        
        MRS__c objMRS = SwiftDataUtilityTest.createMrs(mstList[0].Id);
        
        List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
        MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
        listMRSLA.add(objMRSLA1);
        MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
        listMRSLA.add(objMRSLA2);
        insert listMRSLA;   
        
        List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
        MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip001');
        listMRSCD.add(objMRSCD1);
        MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip002');
        listMRSCD.add(objMRSCD2);
        MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
        listMRSCD.add(objMRSCD3);
        insert listMRSCD;
        
        List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
        MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=ptrf.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        listMRSLCA.add(objMRSLCA1);
        MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=ptrf.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        listMRSLCA.add(objMRSLCA2);
        insert listMRSLCA;
        
        List<MRS_Layer_Chip_Association__c> mrsLayerChipAssociationList = [SELECT Id, Layer__c, Chip__c, PTRF__c, Tech_Geo__c, Device_Id__c, Layer_Chip_Status__c, Layer__r.MRS_Layer_Unique_Identifier__c FROM MRS_Layer_Chip_Association__c];
        Set<String> mrsLayerUniqueIdentifierSet = new Set<String>();
        for(MRS_Layer_Chip_Association__c mrsLayerChipAssociationObj : mrsLayerChipAssociationList){
            mrsLayerUniqueIdentifierSet.add(mrsLayerChipAssociationObj.Layer__r.MRS_Layer_Unique_Identifier__c);
        }
        
        MRSHandlerUtility.deselectLayerInPTRF(new Set<String>{objMRSLCA1.PTRF__c} , mrsLayerUniqueIdentifierSet);
        
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName) {
    
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }   
    
    static Id createUser1(){
        User usr1 = [select id from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true limit 1];
        return usr1.Id;
    }
    
    static Id createUser2(){
        User usr2 = [select id from User where profileId in (select id from Profile where Name='GF System Admin') and IsActive=true limit 1];
        return usr2.Id;
    }
    
    static Account_Team_Proxy__c createAccountTeamProxy(Id testAcctId) {        
                
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c();       
        atp.Account__c = testAcctId ;      
        //User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');      
        atp.User__c = createUser1();        
        atp.Team_Role__c = 'Account Manager';      
        atp.Account_Access__c = 'Read/Write';      
        atp.Opportunity_Access__c = 'Read/Write';      
                    
        insert atp;        
                
        return atp;        
    }
}