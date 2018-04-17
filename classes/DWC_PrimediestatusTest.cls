@isTest(SeeAllData=false)
private class DWC_PrimediestatusTest{    

    static testMethod void DWC_Primediestatus_Test() { 
          Wavier_Collaborator__c wc =new Wavier_Collaborator__c();
          wc.DFM_Design_Type__c='DRC';
          wc.PTSR_Status__c ='Closed';
          wc.Progressbar_staus__c='Pending For Customer';
          wc.CollaboratorClosedMail__c=false;
          wc.PTSR_Service_Type__c='DRC';
          wc.Waiver_Status__c='FCF';
          //wc.FAB__c='1';
          insert wc;
     
         Waiver_Rule_List__c ruleListCount= new Waiver_Rule_List__c();
            ruleListCount.Rule_Type__c='1';
            ruleListCount.Waiver_Collaborator__c=wc.id;
           insert ruleListCount;
         Chip__c chip = new  Chip__c ();
         chip.Chip_Name__c='test123';
         chip.Wavier_Collaborator__c=wc.id;
         insert chip ;
         
         PageReference pageRef = Page.DWC_CollaboratorHelper; // Add your VF page Name here
            pageRef.getParameters().put('waiverid',wc.id);
            pageRef.getParameters().put('ruleList',json.serialize(new List<chip__c>{chip} ));

            Test.setCurrentPage(pageRef);
         
        
            DWC_Primediestatus primeDie=new DWC_Primediestatus();
            primeDie.init();
        }
        
    static testMethod void DWC_Primediestatus_Test2() { 
          Wavier_Collaborator__c wc =new Wavier_Collaborator__c();
          wc.DFM_Design_Type__c='DRC';
          wc.PTSR_Status__c ='Closed';
          wc.Progressbar_staus__c='Pending For Customer';
          wc.CollaboratorClosedMail__c=false;
          wc.PTSR_Service_Type__c='DRC';
          wc.Waiver_Status__c='PI';
          //wc.FAB__c='1';
          insert wc;
     
         Waiver_Rule_List__c ruleListCount= new Waiver_Rule_List__c();
            ruleListCount.Rule_Type__c='1';
            ruleListCount.Waiver_Collaborator__c=wc.id;
           insert ruleListCount;
         Chip__c chip = new  Chip__c ();
         chip.Chip_Name__c='test123';
         chip.Wavier_Collaborator__c=wc.id;
         insert chip ;
         
         PageReference pageRef = Page.DWC_CollaboratorHelper; // Add your VF page Name here
            pageRef.getParameters().put('waiverid',wc.id);
            pageRef.getParameters().put('ruleList',json.serialize(new List<chip__c>{chip} ));

            Test.setCurrentPage(pageRef);
         
        
            DWC_Primediestatus primeDie=new DWC_Primediestatus();
            primeDie.init();
        }
    
    static testMethod void DWC_Primediestatus_Test1() { 
          Wavier_Collaborator__c wc =new Wavier_Collaborator__c();
          wc.DFM_Design_Type__c='DRC';
          wc.PTSR_Status__c ='Closed';
          wc.Progressbar_staus__c='Pending For Customer';
          wc.CollaboratorClosedMail__c=false;
          wc.PTSR_Service_Type__c='DFM';
          //wc.Waiver_Status__c='PI';
          insert wc;
     
         Waiver_Rule_List__c ruleListCount= new Waiver_Rule_List__c();
        	ruleListCount.Rule_Type__c='1';
        	ruleListCount.Waiver_Collaborator__c=wc.id;
           insert ruleListCount;
         Chip__c chip = new  Chip__c ();
         chip.Chip_Name__c='test123';
         chip.Wavier_Collaborator__c=wc.id;
         insert chip ;
         
         PageReference pageRef = Page.DWC_CollaboratorHelper; // Add your VF page Name here
			pageRef.getParameters().put('waiverid',wc.id);
            pageRef.getParameters().put('ruleList',json.serialize(new List<chip__c>{chip} ));

            Test.setCurrentPage(pageRef);
         
        
            DWC_Primediestatus primeDie=new DWC_Primediestatus();
            primeDie.init();
        }
    
}