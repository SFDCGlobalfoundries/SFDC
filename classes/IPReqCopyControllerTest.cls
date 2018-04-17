@isTest
public class IPReqCopyControllerTest {
    
    public static testMethod void CopyTest(){
        List<CopyIPReqFields__c> custSetToIns = new List<CopyIPReqFields__c>();
        CopyIPReqFields__c custSet1 = new CopyIPReqFields__c();
        custSet1.Name = 'Business_Unit__c';
        custSetToIns.add(custSet1);
        CopyIPReqFields__c custSet2 = new CopyIPReqFields__c();
        custSet2.Name = 'Process_Geometry__c';
        custSetToIns.add(custSet2);
        CopyIPReqFields__c custSet3 = new CopyIPReqFields__c();
        custSet3.Name = 'IPType__c';
        custSetToIns.add(custSet3);
        CopyIPReqFields__c custSet4 = new CopyIPReqFields__c();
        custSet4.Name = 'IP_Subtype__c';
        custSetToIns.add(custSet4);
        CopyIPReqFields__c custSet5 = new CopyIPReqFields__c();
        custSet5.Name = 'Existing_IP__c';
        custSetToIns.add(custSet5);
        CopyIPReqFields__c custSet6 = new CopyIPReqFields__c();
        custSet6.Name = 'Target_Process_Node__c';
        custSetToIns.add(custSet6);
        CopyIPReqFields__c custSet7 = new CopyIPReqFields__c();
        custSet7.Name = 'Platform__c';
        custSetToIns.add(custSet7);
        insert custSetToIns;
        
        
        CMOS_BU_IP_Request__c req = new CMOS_BU_IP_Request__c();
        req.Target_Process_Node__c='14LPP-XL';
        req.Process_Geometry__c='0.014UM';
        req.Platform__c=true;
        req.Preferred_IP_Vendor__c='Test';
        req.Non_Standard_PVT_Support__c='Test';
        req.Target_PDK_Version__c='Current';
        req.Target_PDK_Comments__c='test';
        req.IPType__c = 'AMS';
        req.IP_Subtype__c='Other';
        req.Stage__c='Draft';
        req.Description__c='Test';
        req.Existing_IP__c='No';
        
        insert req;
        CMOS_BU_IP_Request__c ipReqfrmDb = [Select Id, RecordType.Name from CMOS_BU_IP_Request__c where Id=:req.Id];
        system.assertEquals('AMS',ipReqfrmDb.RecordType.Name);
        
        req.IPType__c = null;
        update req;
        ipReqfrmDb = [Select Id, IPType__c from CMOS_BU_IP_Request__c where Id=:req.Id];
        system.assertEquals('AMS',ipReqfrmDb.IPType__c);
        
        IPReqCopyController copyCnt = new IPReqCopyController(new ApexPages.StandardController(req));
        copyCnt.copy();
    }
}