@isTest(SeeAllData=false)
public class DesignWaiverTrigger_Test {
    
    static testMethod void myWaiverTriggerMethod(){
        
        Test.startTest();
        List<Wavier_Collaborator__c> waiverCollList = new List<Wavier_Collaborator__c>();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator0();    
        waiverColl.PTSR_Service_Type__c = 'DFM Service Type';
        waiverColl.isReleaseToCust4MultiDie__c=true;
        waiverColl.CollaboratorClosedMail__c=false;
        waiverColl.Waiver_Status__c = 'Approved';
        waiverColl.PTSR_Status__c = 'Closed';
        update waiverColl;
         
        waiverCollList.add(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Status__c = 'Closed','Closed');
    }
    static testMethod void myWaiverTriggerMethodforClose(){
        
        Test.startTest();
        List<Wavier_Collaborator__c> waiverCollList = new List<Wavier_Collaborator__c>();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator0(); 
        Waiver_Rule_List__c Wlist1= new Waiver_Rule_List__c ();
         Wlist1.Rule_Type__c='1';
         Wlist1.Waiver_Collaborator__c=waiverColl.id;
         insert Wlist1;   
        waiverColl.PTSR_Service_Type__c = 'DFM Service Type';
        waiverColl.Waiver_Status__c = 'Approved';
        waiverColl.PTSR_Status__c = 'Closed';
        
        
        update waiverColl;
        waiverCollList.add(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Status__c = 'Closed','Closed');
    }
    static testMethod void myWaiverTriggerMethodforDFM(){
        
        Test.startTest();
        List<Wavier_Collaborator__c> waiverCollList = new List<Wavier_Collaborator__c>();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator0();    
        waiverColl.PTSR_Service_Type__c = 'DFM Service Type';
        waiverColl.Waiver_Status__c = 'FD';
        waiverColl.PTSR_Status__c = 'Closed';
        update waiverColl;
        waiverCollList.add(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Status__c = 'Closed','Closed');
    }
    static testMethod void myWaiverTriggerMethod11(){
        
        Test.startTest();
        List<Wavier_Collaborator__c> waiverCollList = new List<Wavier_Collaborator__c>();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator0();
        Waiver_Rule_List__c Wlist1= new Waiver_Rule_List__c ();
         Wlist1.Rule_Type__c='1';
         Wlist1.Waiver_Collaborator__c=waiverColl.id;
         insert Wlist1;     
        waiverColl.PTSR_Service_Type__c = 'DRC Service Type';
        waiverColl.Waiver_Status__c = 'PI';
        waiverColl.PTSR_Status__c = 'Closed';
        update waiverColl;
        waiverCollList.add(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Status__c = 'Closed','Closed');
    }
    static testMethod void myWaiverTriggerMethod12(){
        
        Test.startTest();
        List<Wavier_Collaborator__c> waiverCollList = new List<Wavier_Collaborator__c>();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator0();    
        Waiver_Rule_List__c Wlist1= new Waiver_Rule_List__c ();
         Wlist1.Rule_Type__c='1';
         Wlist1.Waiver_Collaborator__c=waiverColl.id;
         insert Wlist1; 
        waiverColl.PTSR_Service_Type__c = 'DRC Service Type';
        waiverColl.Waiver_Status__c = 'FD';
        waiverColl.PTSR_Status__c = 'Closed';
        update waiverColl;
        waiverCollList.add(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Status__c = 'Closed','Closed');
    }
    static testMethod void myWaiverTriggerMethod13(){
        
        Test.startTest();
        List<Wavier_Collaborator__c> waiverCollList = new List<Wavier_Collaborator__c>();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator0();  
        Waiver_Rule_List__c Wlist1= new Waiver_Rule_List__c ();
         Wlist1.Rule_Type__c='1';
         Wlist1.Waiver_Collaborator__c=waiverColl.id;
         insert Wlist1;   
        waiverColl.PTSR_Service_Type__c = 'DRC Service Type';
        waiverColl.Waiver_Status__c = 'FCF';
        waiverColl.PTSR_Status__c = 'Closed';
        update waiverColl;
        waiverCollList.add(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Status__c = 'Closed','Closed');
    }
    static testMethod void myWaiverTriggerMethod14(){
        
        Test.startTest();
        List<Wavier_Collaborator__c> waiverCollList = new List<Wavier_Collaborator__c>();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator0();    
        Waiver_Rule_List__c Wlist1= new Waiver_Rule_List__c ();
         Wlist1.Rule_Type__c='1';
         Wlist1.Waiver_Collaborator__c=waiverColl.id;
         insert Wlist1; 
        waiverColl.PTSR_Service_Type__c = 'DRC Service Type';
        waiverColl.Waiver_Status__c = 'WEA';
        waiverColl.PTSR_Status__c = 'Closed';
        update waiverColl;
        waiverCollList.add(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Status__c = 'Closed','Closed');
    }
    static testMethod void myWaiverTriggerMethod1(){
  
        Mask_Set_Title__c maskSetTitle = new Mask_Set_Title__c();
        maskSetTitle.Name = 'KVALID1';
        maskSetTitle.Reticle_Type__c= 'Single Layer Reticle (SLR)';
        insert maskSetTitle;   
        Test.startTest();
        DfmUtilityCls.initialExecution = true;    
        List<Wavier_Collaborator__c> waiverCollList = new List<Wavier_Collaborator__c>();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator0();
        waiverColl.Prime_Die__c = '1';
        waiverColl.Mask_Set_Title_ID__c = maskSetTitle.Id;
        waiverColl.AcknowledgementMailSent__c = false;    
        waiverColl.PTSR_Service_Type__c = 'DFM Service Type';
        waiverColl.Waiver_Status__c = 'Rejected';
        waiverColl.DFM_Design_Type__c = 'DFM Design';
        waiverColl.DFMServiceOption__c = 'DFM Service Option';   
        waiverColl.isAllPartyApproved__c = false;
        waiverColl.Is_Sync_with_AIA__c = true;
        waiverColl.PTSR_Status__c = 'Cancel';
        waiverColl.Revert_Collaborator__c = true;    
        update waiverColl;
        waiverCollList.add(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Status__c = 'Cancel','Cancel');    
    }
    
        static testMethod void myWaiverTriggerMethod3(){
        Mask_Set_Title__c maskSetTitle = new Mask_Set_Title__c();
        maskSetTitle.Name = 'KVALID1';
        maskSetTitle.Reticle_Type__c= 'Single Layer Reticle (SLR)';
        insert maskSetTitle;    
        Test.startTest();
        DfmUtilityCls.initialExecution = true;    
        List<Wavier_Collaborator__c> waiverCollList = new List<Wavier_Collaborator__c>();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator0();
        Waiver_Rule_List__c  Wlist=new Waiver_Rule_List__c ();
        Wlist.Waiver_Collaborator__c=waiverColl.id;
        Wlist.Rule_Type__c='';
        insert Wlist;
        waiverColl.Prime_Die__c = '1';
        waiverColl.Mask_Set_Title_ID__c = maskSetTitle.Id;
        waiverColl.AcknowledgementMailSent__c = false;   
        waiverColl.isNonmatchmailsent__c= false;  
        waiverColl.PTSR_Service_Type__c = 'DRC Service Type';
        waiverColl.Waiver_Status__c ='PI';
        waiverColl.isReleaseToCust4MultiDie__c =true;     
        update waiverColl;
        waiverCollList.add(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Service_Type__c = 'DRC Service Type','DRC Service Type');    
    }
        static testMethod void myWaiverTriggerMethod4(){
        Mask_Set_Title__c maskSetTitle = new Mask_Set_Title__c();
        maskSetTitle.Name = 'KVALID1';
        maskSetTitle.Reticle_Type__c= 'Single Layer Reticle (SLR)';
        insert maskSetTitle;
        Test.startTest();
        DfmUtilityCls.initialExecution = true;    
        List<Wavier_Collaborator__c> waiverCollList = new List<Wavier_Collaborator__c>();
        Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator0();
        waiverColl.Prime_Die__c = '1';
        waiverColl.Mask_Set_Title_ID__c = maskSetTitle.Id;
        waiverColl.AcknowledgementMailSent__c = false;            
        waiverColl.PTSR_Service_Type__c = 'DFM Service Type';
        waiverColl.DFM_Design_Type__c = 'DFM Design';
        waiverColl.DFMServiceOption__c = 'waiver request';    
        update waiverColl;
        waiverCollList.add(waiverColl);
        Test.stopTest();
        System.assertEquals(waiverColl.PTSR_Service_Type__c = 'DFM Service Type','DFM Service Type');     
    }
    
}