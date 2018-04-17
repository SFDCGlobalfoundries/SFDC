/*
     Author: Devendra
    Description: 
    History: 
        Devendra      15Mar2017    - Code creation.
*/
@isTest(SeeAllData=true)
private class MPW_ECCNInfoUploaderCtrlTest {
    
    
	static testMethod void runTest2() {
        
         
        test.startTest();

        
        Device__c dev = [select id from device__c limit 1];
        Test.setCurrentPageReference(new PageReference('Page.MPW_ECCNInfoUploader')); 
		System.currentPageReference().getParameters().put('id', dev.id);
        MPW_ECCNInfoUploaderCtrl obj=new MPW_ECCNInfoUploaderCtrl();
        string body='Design/ Chip/ Number,"Design/ Chip Name",Topcell Name,Product ECCN,Design ECCN,Product ITAR,Design ITAR,ITAR Category,Encryption,HTS'+'\n';
		body+='94268,"Charles Stark ,Draper Laboratory",V6BKAA,EAR99,EAR99,no,Y,N/A,no,8542.31.00.00';
        Blob contentFile=blob.valueof(body);
        obj.ReadFile();
        obj.getexportedECCN();
        obj.saveFile();
        List<MPW_ECCN_Info__c> a =obj.getuploadedECCN();
        test.stopTest();
    }
    
   
}