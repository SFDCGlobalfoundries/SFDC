@isTest
private class FV_DocumentProvisioningBatchTest {

    static testMethod void testDocProvisioningBatch(){
       // Create sub pdk
        Id subPdkId = getSubPdkRecords(getPdk());
        // Create Document provisioning record
        List<document_provisioning__c> docProvisioningList = new List<document_provisioning__c>(); 
        for(Integer i = 0 ; i < 60; i++){
            docProvisioningList.add(getDocumentProvisioningRecords(subPdkId));
        }
        insert docProvisioningList;
        System.debug('docProvisioningList----'+docProvisioningList.size());
        FV_DocumentProvisioningBatchCls dProvisioning = new FV_DocumentProvisioningBatchCls();
        Test.startTest();
        Database.executeBatch(dProvisioning);  
        Test.stopTest(); 
    }
    
    static testMethod void testScheduler(){
        Test.StartTest();
        System.schedule('Approval for Document Provisioning'+system.now(), '0 00 00 * * ?', new FV_ScheduleDocumentrProvisioningCls());
        Test.StopTest();
    }  
        
    private static document_provisioning__c getDocumentProvisioningRecords(Id pdkId){
        
        document_provisioning__c dProvObj = new document_provisioning__c(sub_pdk__c = pdkId,
                                                                         status__c='Sent For Approval',
                                                                         isSendForApproval__c=true);
        return dProvObj;   
    }
    
    private static Id getPdk(){
        
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421; 
        objPDK.PDK_DocTitle__c = ''; //added by cognizant
        insert objPDK;
        
        return objPDK.id;
    }
    
    private static Id getSubPdkRecords(Id pdkId){
        
        Sub_PDK__c objSubPDK = new Sub_PDK__c(); 
        objSubPDK.Name = 'TestName';
        objSubPDK.Release_Status__c = 'Release To White List';
        objSubPDK.PDK__c = pdkId;
        objSubPDK.Bundle_Name__c = 'test Bundle Name';                             
        insert objSubPDK;
        return objSubPDK.Id;
    }
   
}