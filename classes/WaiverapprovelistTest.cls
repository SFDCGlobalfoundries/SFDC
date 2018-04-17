/*
  @ Author :-Mohan Gandhapu 
  @ Details :-Test Class For Waiverapprovelist
  @ History:- Mohan 07/12/2016
 */
@isTest(SeeAllData=True)

public class WaiverapprovelistTest
{
  
  static testMethod void Waiverapprovelist_Test()
  {
        Test.startTest();
        
        Wavier_Collaborator__c waiverColl = new Wavier_Collaborator__c();
        waiverColl.Metal_Stacks__c = 'Test Metal Stack';
        waiverColl.FAB__c = 'FAB 7';
        waiverColl.Account_Short_Name__c = 'testacc';
        waiverColl.PTSR_Service_Type__c = 'DFM Service Request';
        waiverColl.isAllPartyApproved__c = false;
        waiverColl.Is_releasedToCustomer__c = true;
        
        insert waiverColl;
      
        Waiver_Rule_List__c waiverListObj = new Waiver_Rule_List__c();
        waiverListObj.Design_Rule_Name__c = 'DRC Waiver Rule 1';
        waiverListObj.Final_Stage__c = 'FCF';
        //waiverListObj.Final_Status__c= 'All';
        //waiverListObj.GF_Review_Results__c= 'Testing';
        //waiverListObj.Name= 'DRC-0000000';
        waiverListObj.Number_of_Violation__c= 3;
        waiverListObj.Rule_Description__c= 'Testing for iFD';
        waiverListObj.RuleId__c = 5454.012;
        waiverListObj.isAllPartyApproved__c=FALSE;
        waiverListObj.Stage__c= 'FD';
        waiverListObj.Waiver_Collaborator__c= waiverColl.id;
        
        insert waiverListObj;
        
      ProcessInstance pi = [SELECT id FROM ProcessInstance WHERE TargetObject.Name like 'DRC%' and Status = 'Pending'Order By SystemModstamp desc limit 1];
      Waiverapprovelist W = New Waiverapprovelist();
      PageReference pageRef = Page.WaiverItemsToApprove;
      Test.setCurrentPage(pageRef);
      //W.confirmCertificationStatement();
      apexPages.Currentpage().getParameters().put('Id',pi.id);
      w.PI=pi;
      w.WRL=null;
      w.pid ='';
      W.confirmCertificationStatement();      
      Test.Stoptest();
  }
}