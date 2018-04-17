/*
Type Name: CaseL2L3RoutingTriggerTest
Author: Cognizant Case Management Team
Created Date: 02/26/2015
Reason: This is the Test class for CaseL2L3RoutingTriggerHandler class and CaseL2L3RoutingTrigger trigger. 
Change History:
Author: 
Modified Date: 
Reason: 
…… ..
……..
*/
@isTest(SeeAllData = false)
private class CaseL2L3RoutingTriggerTest{

    /*
    This method is used for Insertion of Cases for All the Record Types when Account Team Proxy Role :Primary Account Manager existed .
    @method name: CaseAssignmentTest1
    */
    
    static testMethod void CaseL2L3RoutingTest1() {
        DataUtilTest.LoadATPEnvVariables();
        CaseDataUtilTest.loadCustomSettingVariables();
        
        Group testGroup1 = new Group(Name='L2 - Customer Test1', Type='Queue');
        insert testGroup1;
        
        Group testGroup2 = new Group(Name='L3 - Customer Test1', Type='Queue');
        insert testGroup2;
        
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue1 = new QueueSObject(QueueID = testGroup1.id, SObjectType = 'Case');
            insert testQueue1;
            
            QueuesObject testQueue2 = new QueueSObject(QueueID = testGroup2.id, SObjectType = 'Case');
            insert testQueue2;
        }
        
        //Test begins
        Test.startTest();
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        Case cx1 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'Design Enablement-Others', SubCategory__c = 'Design Flow',
                           Priority = 'Low',Geometry__c ='0.040UM', Internal_or_external__c = false,OwnerId = testGroup1.Id);
        insert cx1;
        
        Case cx2 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 3', Subject = 'Test 3', Category__c = 'Process Technology', SubCategory__c = 'BEOL',Target_process_node__c = 'Other',
                           Priority = 'Low',Geometry__c ='0.040UM', Internal_or_external__c = false,OwnerId = testGroup1.Id);
        insert cx2;
        
        List < CaseL2L3Routing__c > caseL2L3RoutingList1 = new List < CaseL2L3Routing__c > ();
        List < CaseL2L3Routing__c > caseL2L3RoutingList2 = new List < CaseL2L3Routing__c > ();
        List < CaseL2L3Routing__c > caseL2L3RoutingList3 = new List < CaseL2L3Routing__c > ();
        
        CaseL2L3Routing__c c1 = new CaseL2L3Routing__c(Category__c = 'Design Enablement-Others', SubCategory__c = 'Design Flow', 
            Geometry__c = '0.040UM', Old_Owner__c = 'L2 - Customer Test1',New_Owner__c = 'L3 - Customer Test1',Target_process_node__c = '0.11G',Re_Evaluate__c=true);
        caseL2L3RoutingList1.add(c1);
        
        CaseL2L3Routing__c c5 = new CaseL2L3Routing__c(Category__c = 'Design Enablement-Others', SubCategory__c = 'Design Flow', Geometry__c = '1.20UM', Old_Owner__c = 'L2 - Customer Test1',
                           New_Owner__c = 'Individual', Individual__c = UserInfo.getUserId(), Re_Evaluate__c=true);
        caseL2L3RoutingList1.add(c5);
        
        CaseL2L3Routing__c c6 = new CaseL2L3Routing__c(Category__c = 'Design Enablement-Others', SubCategory__c = 'Design Flow', Geometry__c = '0.040UM', Old_Owner__c = 'L2 - Customer Test1',Target_process_node__c = 'Other',
                                                        New_Owner__c = 'L3 - Customer Test1',Re_Evaluate__c=true);
        caseL2L3RoutingList3.add(c6);
        
                
        insert caseL2L3RoutingList1;
        
        
        
        CaseL2L3Routing__c c2 = new CaseL2L3Routing__c(Category__c = 'Design Enablement-Others', SubCategory__c = 'Design Flow', Geometry__c = '0.040UM', Old_Owner__c = 'L2 - Customer Design Support (US)',
                           New_Owner__c = 'L3 - SPICE Model Group');
        caseL2L3RoutingList2.add(c2);
        
        CaseL2L3Routing__c c3 = new CaseL2L3Routing__c(Category__c = 'Design Enablement-Others', SubCategory__c = 'Design Flow', Geometry__c = '0.040UM', Old_Owner__c = 'L2 - Customer Design Support (US)1',
                           New_Owner__c = 'L3 - SPICE Model Group');
        caseL2L3RoutingList2.add(c3);
        
        CaseL2L3Routing__c c4 = new CaseL2L3Routing__c(Category__c = 'Design Enablement-Others', SubCategory__c = 'Design Flow', Geometry__c = '0.040UM', Old_Owner__c = 'L2 - Customer Design Support (US)',
                           New_Owner__c = 'L3 - SPICE Model Group1');
        caseL2L3RoutingList2.add(c4);
        
        CaseL2L3Routing__c c8 = new CaseL2L3Routing__c(Category__c = 'Process Technology', SubCategory__c = 'BEOL', Geometry__c = '0.040UM', Old_Owner__c = 'L2 - Customer Test1',Target_process_node__c = 'Other',
                                                        New_Owner__c = 'L3 - Customer Test1',Re_Evaluate__c=true);
        caseL2L3RoutingList3.add(c8);
        
        insert caseL2L3RoutingList3;
        
        
        
        try{    
            insert caseL2L3RoutingList2;
        } catch (Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('Not found in the system, please contact administrator') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        c5.Geometry__c = '0.032UM';
        update c5;
         
       
             
        c1.Old_Owner__c = 'L2 – CMOS BU Design Support (APJ,EMEA)';
        c1.New_Owner__c = 'L3 - Matured PDK';
        Update c1;
        
        c1.New_Owner__c = 'Individual';
        c1.Individual__c = UserInfo.getUserId();
        Update c1;
        
        c2.Old_Owner__c = 'L2 – CMOS BU Design Support (APJ,EMEA)';
        try{    
            update c2;
        } catch (Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('Not found in the system, please contact administrator') ? true : false;
            System.AssertEquals(expectedExceptionThrown, false);
        }
        
        c3.New_Owner__c = 'L3 - Matured PDK1';
        try{    
            update c3;
        } catch (Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('Not found in the system, please contact administrator') ? true : false;
            System.AssertEquals(expectedExceptionThrown, false);
        }
        
        Test.stopTest();
        
    }

}