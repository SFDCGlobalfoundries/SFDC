/*
*   Author: KOKA GOPI
*   Description:  Test Class for ERPDeviceSPMBOM
*   History: 
*   GOPI KOKA 3/28/2017    - Class created    
*/
@isTest
Private Class ERPDeviceSPMBOMTest{
    @testSetup
    static void setupData() {
        try{
            DataUtilTest.LoadDeviceEnvVariable();
             List<ERP_Device__c> erpDevices = New List<ERP_Device__c>();
            ERP_Device__c eDevice = New ERP_Device__c();
            eDevice.Part_Number__c = '1230094';
            erpDevices.add(eDevice);
            
            ERP_Device__c eDevice1 = New ERP_Device__c();
            erpDevices.add(eDevice1);
            
            insert erpDevices;
            
            List<ERP_Device_SPDBOM__c> erpBOM = New List<ERP_Device_SPDBOM__c>();
            
            ERP_Device_SPDBOM__c ppjo = New ERP_Device_SPDBOM__c();
            ppjo.ERP_Device__c = eDevice.id;
            ppjo.Parent__c = '1230094';
            ppjo.Parent_Component_Pair__c = '112233';
            erpBOM.add(ppjo);
            
            
            ERP_Device_SPDBOM__c ppjo1 = New ERP_Device_SPDBOM__c();
            ppjo1.ERP_Device__c = eDevice1.id;
            ppjo1.Parent__c = '1230094';
            ppjo1.Parent_Component_Pair__c = '332211';
            erpBOM.add(ppjo1);
            
            insert erpBOM;
        }catch(Exception e){
            GlobalUtility.logMessage('Error','ERPDeviceSPMBOMTest','execute','','Exception : ',String.valueof(e.getMessage()),'','All',e,0);
        }
        
    } 
    static testMethod void ReviewPSCPSAInventoryCon(){
        try{
            ERP_Device__c erpDevice = [SELECT id, Part_Number__c FROM ERP_Device__c WHERE Part_Number__c =: '1230094'];
            Test.setCurrentPageReference(new PageReference('Page.ERPDeviceSPMBOM')); 
            System.currentPageReference().getParameters().put('id', erpDevice.id);
            System.currentPageReference().getParameters().put('Eid', erpDevice.Part_Number__c);
              
            Test.StartTest();
            ERPDeviceSPMBOM rppi = New ERPDeviceSPMBOM();
            rppi.getPSAPSCJuntionObject();
            rppi.refreshPageSize();
            rppi.getAllERPBOMRecords();
            system.assert(rppi.ppjowc.size()==2);
            for(integer i=0;i<rppi.ppjowc.size();i++){
                rppi.ppjowc[i].chkVar = true;
            }
            System.currentPageReference().getParameters().put('myParam', 'replace');
            rppi.logicExecution();
            
            System.currentPageReference().getParameters().put('myParam', 'default');
            rppi.logicExecution();
            
            Test.StopTest();
        }catch(Exception e){
            GlobalUtility.logMessage('Error','ERPDeviceSPMBOMTest','execute','','Exception : ',String.valueof(e.getMessage()),'','All',e,0);
        }
    }
}