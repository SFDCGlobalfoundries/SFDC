@isTest
(seeAllData=false)
public class NWRFormControllerTest{

    @TestSetup static void testdata() 
    {
      DataUtilTest.loadEnvironmentVariables();
    }
    
    static testMethod void testRun1(){
        
        Test.startTest();
        
        Schema.DescribeSObjectResult nfrSchema = Schema.SObjectType.Non_Wafer_Revenue__c; 
        Map<String,Schema.RecordTypeInfo> nfrRecordTypeInfo = nfrSchema.getRecordTypeInfosByName();
        
        Id recordTypeId;
        if(nfrRecordTypeInfo .get('MPW').getRecordTypeId() != null){
            
            recordTypeId = nfrRecordTypeInfo .get('MPW').getRecordTypeId();
        }
        else if(nfrRecordTypeInfo .get('NRE').getRecordTypeId() != null){
            
            recordTypeId = nfrRecordTypeInfo .get('NRE').getRecordTypeId();
        }
        else if(nfrRecordTypeInfo .get('Reticle').getRecordTypeId() != null){
            
            recordTypeId = nfrRecordTypeInfo .get('Reticle').getRecordTypeId();
        }
        
        
        String acccountId = DeviceUtilTest.createAccount();
        String opportunitytyId = DeviceUtilTest.createOpp(acccountId, '0.10UM');
        String opportunitytyProgramId = DeviceUtilTest.createOppProg(acccountId, opportunitytyId);
        
        Device__c deviceObj = new Device__c();
        deviceObj.Name = 'TestDevice' + DateTime.now().getTime();
        deviceObj.Account__c = acccountId;
        deviceObj.Opportunity2__c = opportunitytyId;
        deviceObj.Opportunity_Program__c = opportunitytyProgramId;
        deviceObj.Tapeout_Type__c = 'Customer MPW';
        deviceObj.Device_Sourcing__c = '1st Source';
        deviceObj.End_Application__c = 'Body';
        deviceObj.Market_Segment__c = 'Automotive';
        deviceObj.Confidence_Level_Tapeout__c = '100';
        deviceObj.Fab__c = 'FAB 2';
        deviceObj.Original_Forecasted_Tapeout_Date__c = Date.newInstance(2016,3,20);
        deviceObj.Semiconductor_Device__c = 'Analog Amplifier';
        insert deviceObj;
        
        Non_Wafer_Revenue__c nwrObj = new Non_Wafer_Revenue__c();
        
        if(deviceObj != null && deviceObj.Opportunity2__c  != null){
            
            nwrObj.Opportunity__c = deviceObj.Opportunity2__c;
        }
        //insert nwrObj;
        
        Test.stopTest();
        
        PageReference pageRef = Page.NWRForm;
        Test.setCurrentPage(pageRef);
        Test.setCurrentPageReference(pageRef);
        
        if(deviceObj != null && deviceObj.Id  != null){
        
            pageRef.getParameters().put('Did', String.valueOf(deviceObj.Id));
        }
        
        if(recordTypeId != null){
            
            pageRef.getParameters().put('RecordType', recordTypeId);
        }
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(nwrObj);
        NWRFormController nWRFormController = new NWRFormController(standardController);
        
        PageReference pageReference = nWRFormController.save();
    }
    
    static testMethod void testRun2(){
        
        Test.startTest();
        
        Schema.DescribeSObjectResult nfrSchema = Schema.SObjectType.Non_Wafer_Revenue__c; 
        Map<String,Schema.RecordTypeInfo> nfrRecordTypeInfo = nfrSchema.getRecordTypeInfosByName();
        
        Id recordTypeId;
        if(nfrRecordTypeInfo .get('MPW').getRecordTypeId() != null){
            
            recordTypeId = nfrRecordTypeInfo .get('MPW').getRecordTypeId();
        }
        else if(nfrRecordTypeInfo .get('NRE').getRecordTypeId() != null){
            
            recordTypeId = nfrRecordTypeInfo .get('NRE').getRecordTypeId();
        }
        else if(nfrRecordTypeInfo .get('Reticle').getRecordTypeId() != null){
            
            recordTypeId = nfrRecordTypeInfo .get('Reticle').getRecordTypeId();
        }
        
        
        String acccountId = DeviceUtilTest.createAccount();
        String opportunitytyId = DeviceUtilTest.createOpp(acccountId, '0.10UM');
        String opportunitytyProgramId = DeviceUtilTest.createOppProg(acccountId, opportunitytyId);
        
        Device__c deviceObj = new Device__c();
        deviceObj.Name = 'TestDevice' + DateTime.now().getTime();
        deviceObj.Account__c = acccountId;
        deviceObj.Opportunity2__c = opportunitytyId;
        deviceObj.Opportunity_Program__c = opportunitytyProgramId;
        deviceObj.Tapeout_Type__c = 'Customer MPW';
        deviceObj.Device_Sourcing__c = '1st Source';
        deviceObj.End_Application__c = 'Body';
        deviceObj.Market_Segment__c = 'Automotive';
        deviceObj.Confidence_Level_Tapeout__c = '100';
        deviceObj.Fab__c = 'FAB 2';
        deviceObj.Original_Forecasted_Tapeout_Date__c = Date.newInstance(2016,3,20);
        deviceObj.Semiconductor_Device__c = 'Analog Amplifier';
        insert deviceObj;
        
        Non_Wafer_Revenue__c nwrObj = new Non_Wafer_Revenue__c();
        
        if(deviceObj != null && deviceObj.Opportunity2__c  != null){
            
            nwrObj.Opportunity__c = deviceObj.Opportunity2__c;
        }
        
        insert nwrObj;
        
        Test.stopTest();
        
        PageReference pageRef = Page.NWRForm;
        Test.setCurrentPage(pageRef);
        Test.setCurrentPageReference(pageRef);
        
        if(deviceObj != null && deviceObj.Id  != null){
        
            pageRef.getParameters().put('Did', String.valueOf(deviceObj.Id));
        }
        
        if(recordTypeId != null){
            
            pageRef.getParameters().put('RecordType', recordTypeId);
        }
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(nwrObj);
        NWRFormController nWRFormController = new NWRFormController(standardController);
        
        PageReference pageReference = nWRFormController.save();
    }
    
    static testMethod void testRun3(){
        
        Test.startTest();
        
        Schema.DescribeSObjectResult nfrSchema = Schema.SObjectType.Non_Wafer_Revenue__c; 
        Map<String,Schema.RecordTypeInfo> nfrRecordTypeInfo = nfrSchema.getRecordTypeInfosByName();
        
        Id recordTypeId;
        if(nfrRecordTypeInfo .get('MPW').getRecordTypeId() != null){
            
            recordTypeId = nfrRecordTypeInfo .get('MPW').getRecordTypeId();
        }
        else if(nfrRecordTypeInfo .get('NRE').getRecordTypeId() != null){
            
            recordTypeId = nfrRecordTypeInfo .get('NRE').getRecordTypeId();
        }
        else if(nfrRecordTypeInfo .get('Reticle').getRecordTypeId() != null){
            
            recordTypeId = nfrRecordTypeInfo .get('Reticle').getRecordTypeId();
        }
        
        
        String acccountId = DeviceUtilTest.createAccount();
        String opportunitytyId = DeviceUtilTest.createOpp(acccountId, '0.10UM');
        String opportunitytyProgramId = DeviceUtilTest.createOppProg(acccountId, opportunitytyId);
        
        Device__c deviceObj = new Device__c();
        deviceObj.Name = 'TestDevice' + DateTime.now().getTime();
        deviceObj.Account__c = acccountId;
        deviceObj.Opportunity2__c = opportunitytyId;
        deviceObj.Opportunity_Program__c = opportunitytyProgramId;
        deviceObj.Tapeout_Type__c = 'Customer MPW';
        deviceObj.Device_Sourcing__c = '1st Source';
        deviceObj.End_Application__c = 'Body';
        deviceObj.Market_Segment__c = 'Automotive';
        deviceObj.Confidence_Level_Tapeout__c = '100';
        deviceObj.Fab__c = 'FAB 2';
        deviceObj.Original_Forecasted_Tapeout_Date__c = Date.newInstance(2016,3,20);
        deviceObj.Semiconductor_Device__c = 'Analog Amplifier';
        insert deviceObj;
        
        Non_Wafer_Revenue__c nwrObj = new Non_Wafer_Revenue__c();
        
        if(deviceObj != null && deviceObj.Opportunity2__c  != null){
            
            nwrObj.Opportunity__c = deviceObj.Opportunity2__c;
        }
        
        if(recordTypeId != null){
            
            nwrObj.RecordTypeId = recordTypeId;
        }
        
        nwrObj.Non_Wafer_Revenue_Type__c = 'MPW';
        
        insert nwrObj;
        
        Blob blobData = Blob.valueOf('Test Data');
        Attachment attachmentObj = new Attachment(Name = 'Test', ParentId = nwrObj.Id, Body = blobData);
        insert attachmentObj;
        
        Note noteObj = new Note(Title = 'Test', ParentId = nwrObj.Id, Body = 'Test');
        insert noteObj;
        
        Test.stopTest();
        
        PageReference pageRef = Page.NWRForm;
        Test.setCurrentPage(pageRef);
        Test.setCurrentPageReference(pageRef);
        
        pageRef.getParameters().put('clone', '1');
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(nwrObj);
        NWRFormController nWRFormController = new NWRFormController(standardController);
        
        PageReference pageReference = nWRFormController.save();
    }
}