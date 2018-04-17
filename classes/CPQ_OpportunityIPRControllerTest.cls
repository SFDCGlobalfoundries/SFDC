/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CPQ_OpportunityIPRControllerTest {
 @testSetup static void testdata() {
       // DataUtilTest.loadEnvironmentVariables();
       List<Environment_Variable__c > lst=new List<Environment_Variable__c >();
         Environment_Variable__c objEnvironmentVariable=new Environment_Variable__c(Name = 'AccountProxy', Value__c = '15');
         lst.add(objEnvironmentVariable);
         
         Environment_Variable__c objEnvironmentVariable2=new Environment_Variable__c(Name = 'SIEBEL_OPPTY_ID_SEQUENCE_NO', Value__c = '10851');
         lst.add(objEnvironmentVariable2);
          
         Environment_Variable__c objEnvironmentVariable3=new Environment_Variable__c(Name = 'ExcludeSequenceNumber', Value__c = '98765');
         lst.add(objEnvironmentVariable3);
        
         database.insert(lst, false);
         
       
    }
    
    static Product2 createProduct(String PTnumber){
        Product2 TestProd = new Product2();
            TestProd.ProductCode                         = 'Test_'+PTnumber;
            TestProd.Product_External_ID__c              = 'Test_'+PTnumber;
            TestProd.APTPS_IP_Lifecycle__c               = 'Approved';
            //TestProd.APTPS_IP_Type__c                    = 'AMS';
            //TestProd.APTPS_IP_Vendors__c                 = 'GF';
            TestProd.Family                              = 'PTs';
            TestProd.Name                                = 'Test ' + PTnumber;
            TestProd.IsActive                            = TRUE;
            TestProd.Geometry__c                         = '>0.18UM';
            TestProd.Apttus_Config2__ConfigurationType__c= 'Bundle'; 
            TestProd.PT_Number__c                        = PTnumber; 
            TestProd.Catalog_type__c                     = 'First Source';              
        insert TestProd;
        Return TestProd;
    }
    
    
  static testMethod void testCPQIPMethod(){
         Opportunity opp = new Opportunity( Name = 'Test Opportunity',
            StageName = '4. Decision',
            CloseDate = Date.Today().addDays(10),
            Target_Process_Node__c = '28HPP',
            Market_Segment__c = 'Mobility',
            Process_Platform__c = 'GF Baseline',
            Fab_Split__c = 100,
            Process_Geometry__c = '0.028UM',
            Process_Family__c = 'Generic / Nominal',
            Opportunity_Sourcing_Type__c = 'Second Source',
            Fab_Assignment_1__c = 'FAB 3'

            );
            
          insert opp;  
    
            CMOS_BU_IP_Request__c objCMOSBUIPRequest=(CMOS_BU_IP_Request__c)TestDataFactory.createSObject('CMOS_BU_IP_Request__c');
            //objCMOSBUIPRequest.Platform__c=true;
            objCMOSBUIPRequest.Business_Unit__c=null;//This field doesn't have value in record type settings(on PROD and UAT)
            //objCMOSBUIPRequest.Stage__c='Accepted';
            objCMOSBUIPRequest.Process_Geometry__c=opp.Process_Geometry__c;
            objCMOSBUIPRequest.Target_Process_Node__c='28SLP';
           objCMOSBUIPRequest.Opportunity__c=opp.id;
            insert objCMOSBUIPRequest;
         
       //Setup the Proposal test record for the the page to render
       Product2 ParentProduct = createProduct('PT00XXXX');
       Process_Technology__c pt = new Process_Technology__c(
                                    name        =  'PT00XXXX',
                                    Lifecycle__c    =  'Product',
                                    Tech_Geometry__c=  '>0.18UM',
                                    PT_Number__c    = 'PT00XXXX');
        
        insert pt;
        system.assertNotEquals(null,pt.Name);
        
        Base_Ip__c ip = new Base_Ip__c (
                            name            = 'IP00XXXX',
                            ip_number__c    = 'IP00XXXX',
                            IP_Type__c      = 'AMS',
                            Ip_Vendor__c    = 'GF',
                            description__c  = 'test',
                            LifeCycle__c    = 'Approved');
                           
        insert ip;
        
        
         product2 compProd = new product2(Product_External_ID__c = 'IP00XXXX'
                                             ,ProductCode           = 'IP00XXXY'              
                                             ,Description__c        = 'IP00XXXY'
                                             ,IsActive              =TRUE 
                                             ,Geometry__c           = '>0.18UM'
                                             ,Apttus_Config2__ConfigurationType__c   = 'Option'
                                             ,Apttus_Config2__HasAttributes__c       = FALSE
                                             ,Apttus_Config2__HasDefaults__c         = FALSE
                                             ,Apttus_Config2__HasOptions__c          = FALSE
                                             ,Apttus_Config2__HasSearchAttributes__c = FALSE
                                             ,APTPS_IP_Lifecycle__c = 'Approved'
                                             ,APTPS_IP_Type__c = 'AMS'
                                             ,APTPS_IP_Vendors__c = 'GF'
                                             ,Apttus_Config2__Customizable__c        = FALSE
                                             ,Family                                 = 'IPs'
                                             ,Name                                   = 'test'
                                             ,Apttus_Config2__Uom__c                 = 'Each'
                                             ,IP_Device_List__c                      = 'pn_2p5'
                                             ,APTPS_Metal_Stack__c = 'M1;M2;M3'
                                             ,Description   = 'M1;M2;M3'                        
                                             ,IP_PT_ID__c = ip.id
                                             ,Apttus_Config2__IconId__c              = null
                                             );
             insert compProd;
            
             Apttus_Config2__ProductOptionComponent__c prodOptnComp = new Apttus_Config2__ProductOptionComponent__c(Apttus_Config2__AllowCloning__c = false                                                                                                                   
                                                                                                                   ,Apttus_Config2__ComponentProductId__c = compProd.id
                                                                                                                   ,Apttus_Config2__Default__c = false
                                                                                                                   ,Apttus_Config2__Modifiable__c = false
                                                                                                                   ,Apttus_Config2__ParentProductId__c = ParentProduct.id
                                                                                                                   ,Option_Component_External_ID__c = 'test'
                                                                                                                   ,Apttus_Config2__RelationshipType__c = 'Option'
                                                                                                                   ,Apttus_Config2__Required__c = false
                                                                                                                   ,Apttus_Config2__Sequence__c = 1);
             insert prodOptnComp; 
             
        Apttus_Proposal__Proposal__c proposal =createProposal(opp,pt);
        proposal=[select id,Process_Technology_Lookup__c,Apttus_Proposal__Opportunity__c,Process_Technology_Lookup__r.Name from Apttus_Proposal__Proposal__c where id=:proposal.id];
        
        system.assertNotEquals(null,proposal.Process_Technology_Lookup__c);
        system.assertNotEquals(null,proposal.Process_Technology_Lookup__r.Name);
        
        Test.startTest();
            PageReference pageRef = Page.CPQ_OpportunityIPRPage;
            Test.setCurrentPage(pageRef);
            
            ApexPages.CurrentPage().getParameters().put('Id', proposal.id);
            
            ApexPages.StandardController sc = new ApexPages.standardController(proposal);                
        
            CPQ_OpportunityIPRController CPQController = new CPQ_OpportunityIPRController(sc);  
             CPQController.editAction();  
            
            system.assertNotEquals(0,CPQController.iprMap.size());
            system.assertNotEquals(1,CPQController.lstIPsFromPT.size());
             for(String str:CPQController.iprMap.keySet()){
               CPQController.iprMap.get(str).isChecked=true;
               CPQController.iprMap.get(str).selectedIP=    CPQController.lstIPsFromPT.get(1).getValue();
             }
           CPQController.saveAction();      
           
           CPQController = new CPQ_OpportunityIPRController(sc);  
           
            for(String str:CPQController.iprMap.keySet()){
               CPQController.iprMap.get(str).isChecked=true;
               CPQController.iprMap.get(str).selectedIP=null;
             }
            CPQController.saveAction();      
        Test.stopTest();
    }
    
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposal(Opportunity opp,Process_Technology__c TestPT){
        //Process_Technology__c TestPT = createPT() ; 
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                    Apttus_Proposal__Opportunity__c=opp.id,
                    Process_Technology_Lookup__c = TestPT.id);
                                                     
        
        insert proposal;
        return proposal;
    }
    
}