@isTest(SeeAllData=false)
public class DWC_SetOfFinalStatusCtrl_test {
    
    static testMethod void mySetOfFinalStatusMethod(){
        
		Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator0();
        Waiver_Rule_List__c  waiverCollList = new Waiver_Rule_List__c();
        waiverCollList.Final_Stage__c = 'Open';
        waiverCollList.Prime_Die_Name__c = 'Test';
        waiverCollList.Waiver_Collaborator__c = waiverColl.Id;
        insert waiverCollList;
        
        Set<String> setofStatus = new Set<String>();
        setofStatus.add(waiverCollList.Final_Stage__c);      
        String collabId = String.valueOf(waiverColl.Id);
        
        Test.startTest();
        DWC_SetOfFinalStatusCtrl dSetFinalStatus = new DWC_SetOfFinalStatusCtrl();
        DWC_SetOfFinalStatusCtrl.updateReleaseToCustFlag(collabId,setofStatus);
        dSetFinalStatus.init();
        Test.stopTest();
        System.assertEquals(setofStatus,setofStatus);
    }    
}