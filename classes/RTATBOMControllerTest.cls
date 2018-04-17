@isTest(SeeAllData=false)

public class RTATBOMControllerTest {
      
    @testSetup
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        //DataUtilTest.LoadDeviceEnvVariable();
     
     }
   
    
 
    
    static testMethod void RTATBOMControllerTest() {
       
        test.startTest();
        ERP_Device__c erpDevice = loadERPDevice();
        
        RTATBOMControllerTest.createBOM();
        RTAT_Slot__c slotId =createRtatSlot(erpDevice.id);
        String strId = slotId.id;
        ApexPages.CurrentPage().getParameters().put('Id',strId);
        RTATBOMController a = new RTATBOMController();
        a.addPartToRTATBOM();
        a.save();
        RTATBOMController.toDelIdent=1;
       RTATBOMController.addCount =1;
        a.delWrapper();
         a.addRows();
        //ApexPages.CurrentPage().getParameters().put('Id',strId+'s');
        //RTATBOMController b = new RTATBOMController();
        //b.addPartToRTATBOM();
test.stopTest();
  
    }
    
    public static ERP_Device__c loadERPDevice(){
        ERP_Device__c erpDevice = new ERP_Device__c();
        erpDevice.Technology__c = 'SIGE8WL';
        erpDevice.Fab__c = 'FAB 9';
        erpDevice.Product_Type__c = 'Foundry';
        erpDevice.Deliverable_Type__c = 'MODULE';
        erpDevice.Name = 'MOSIS 910';
        erpDevice.Part_Number__c = '0000000XP704';
        erpDevice.Level__c = '27';
        erpDevice.Option_ID__c = 'OPT043516';
        erpDevice.Opportunity_ID__c = 'OPP029770';
        erpDevice.Business_Unit__c = 'RF';
        erpDevice.Burn_In__c = 'N';
        erpDevice.Test_wafer__c = 'N';
        erpDevice.Back_Side_Grind__c = 'Y';
        erpDevice.Levels_Of_Metal__c = 8;
        erpDevice.Last_Level_of_Metal__c = 'MA';
        erpDevice.Mask_Layer_Count__c = '52';
        erpDevice.Wafer_Diameter__c = 200;
        erpDevice.Chips_per_Wafer__c = 1;
        erpDevice.Module_Test_Flag__c = 'N';
        
        Database.insert(erpDevice);
        return erpDevice;
    }
    static RTAT_Slot__c createRtatSlot(String erpDeviceId){
         Map<String,Object> fieldValueMap = new Map<String,Object>();
        RTAT_Slot__c rslot = new RTAT_Slot__c();
        rslot.Name ='MyTestSlot';
        rslot.Fab__c='FAB 9';
        rslot.ERP_Device_for_Slot__c=erpDeviceId;
        rslot.Slot_Type__c='EUH';
        rslot.Wafer_Size__c='200MM'; 
        rslot.SAP_Order_Number__c='MySlot';
        
        insert rslot;
        return rslot;        
        
    }
    static void createBOM(){
        List<BOM__c> rbom = new List<BOM__c>();
        rbom.add(new BOM__c(Component__c='0000000XP704', Parent__c='20000GOAPR15',  Part_BasicName__c='MODULE',Part_Classification__c='Final Module Asm - Die',Part_Level_Code__c='08',Part_Short_Desc__c='MODULE',Technology__c='SIGE8WL'));
        rbom.add(new BOM__c(Component__c='0000000XP696', Parent__c='0000000XP704',  Part_BasicName__c='CHIP',Part_Classification__c='BEOL Chip Asm',Part_Level_Code__c='20',Part_Short_Desc__c='BEOL CHIP',Technology__c='SIGE8WL'));
        rbom.add(new BOM__c(Component__c='0000000XP684', Parent__c='0000000XP696',  Part_BasicName__c='CHIP',Part_Classification__c='BEOL Master Chip Asm',Part_Level_Code__c='08',Part_Short_Desc__c='BEOL Master CHIP',Technology__c='SIGE8WL'));                 
        rbom.add(new BOM__c(Component__c='0000000XP687', Parent__c='0000000XP684',  Part_BasicName__c='CHIP',Part_Classification__c='BBEOL Wafer Asm',Part_Level_Code__c='08',Part_Short_Desc__c='BBEOL Wafer CHIP',Technology__c='SIGE8WL'));                          
        database.insert(rbom);         
            }
}