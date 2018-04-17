/*
* @ Author :- Mohan Gandhapu
* @ Company:- Global Foundries
* @ Description :- Test class for DWC_SuperUserCtrl 
* @ Date :-23/01/2017   
**/
@isTest(SeeAllData=false)
public class DWC_SuperUserCtrlTest {
    
    static testMethod void Superuser_Test() {
             
             
            Test.StartTest();
            List<GroupMember > GroupMemberLsit = New List<GroupMember >();
            
             
                     
 
            DWC_SuperUserCtrl  ctrl= new DWC_SuperUserCtrl();
           
          	Wavier_Collaborator__c wc =new Wavier_Collaborator__c();
              wc.DFM_Design_Type__c='DRC';
              wc.PTSR_Status__c ='Approved';
              wc.Progressbar_staus__c='Pending For FAE';
              wc.CollaboratorClosedMail__c=false;
              wc.PTSR_Service_Type__c='DRC Service Request';
              wc.Waiver_Status__c='FCF';
              wc.FAB__c='Fab7';
			 insert wc;
        
        	pageReference p = new pageReference('/apex/DWC_SuperUser');
        	test.setCurrentPage(p);
         	ApexPages.currentPage().getParameters().put('id',wc.id);
        
            GroupMemberLsit =[select GroupId from groupmember where group.name = 'Fab10 CollaboratorReader'];
            ctrl.addMember();  
            ctrl.removeMember();
            ctrl.getgroups();
            ctrl.sendMail();     
                    
                    
            Test.stopTest();
            System.assertEquals(GroupMemberLsit,GroupMemberLsit);
        
    }
    
  
}