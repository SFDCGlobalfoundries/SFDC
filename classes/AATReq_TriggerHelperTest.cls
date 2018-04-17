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
@IsTest
public class AATReq_TriggerHelperTest {
    
    @testSetup static void setup() {
        PDT_Approvers__c pdtCustSet = new PDT_Approvers__c();
        pdtCustSet.Name = '7nm/FX7';
        pdtCustSet.Email__c = userInfo.getUserEmail();
        insert pdtCustSet;
        
        Map<String,Boolean> recordsMap = new Map<String,Boolean>();
        recordsMap.put('test1',false);
        recordsMap.put('test2',false);
        recordsMap.put('test3',false);
        aatInsert(recordsMap);
    }
    private static testmethod void AATReqTest() {
        
        AAT_Request__c aat = [Select Id, Stage__c, Ready_for_CIA_Technical_Approval__c from AAT_Request__c where Title__c = 'test1'];
        aat.Ready_for_CIA_Technical_Approval__c = true;
        update aat;
        
        test.startTest();
        List<ProcessInstanceWorkItem> piw = [SELECT ProcessInstance.TargetObjectId FROM ProcessInstanceWorkItem WHERE ProcessInstance.Status = 'Pending'];
        system.assert(piw.size() > 0);
        
        Approval.ProcessWorkitemRequest prWkItem = new Approval.ProcessWorkitemRequest();
        prWkItem.setWorkItemID(piw[0].id);
        prWkItem.setComments('Approved');
        prWkItem.setAction('Approve');
        Approval.ProcessResult appResult = Approval.process(prWkItem);
        aat.Is_CIA_Approved__c = true;
        update aat;
        system.assertEquals(true, aat.Is_CIA_Approved__c);
        Approval.ProcessSubmitRequest oRequest1 = new Approval.ProcessSubmitRequest();
        oRequest1.setObjectId(aat.Id);
        Approval.ProcessResult oResult = Approval.process(oRequest1);
        
        List<ProcessInstanceWorkItem> piwTech = [SELECT ProcessInstance.TargetObjectId FROM ProcessInstanceWorkItem WHERE ProcessInstance.Status = 'Pending'];
        system.assert(piwTech.size() > 0);
        Approval.ProcessWorkitemRequest prWkItem2 = new Approval.ProcessWorkitemRequest();
        prWkItem2.setWorkItemID(piwTech[0].id);
        prWkItem2.setComments('Approved');
        prWkItem2.setAction('Approve');
        Approval.ProcessResult appResult2 = Approval.process(prWkItem2);
        
        test.stopTest();
    }
    private static testMethod void AATReqTest2(){
        AAT_Request__c aat2 = [Select Id, Stage__c, Ready_for_CIA_Technical_Approval__c,AAT_Technical_Team_Meeting_Minutes__c from AAT_Request__c where Title__c = 'test2'];
        test.startTest();
        aat2.Stage__c = 'Under Review';
        aat2.Ready_for_CIA_Technical_Approval__c = true;
        update aat2;
        
        aat2.AAT_CIA_Team_Meeting_Minutes__c = 'Test';
        aat2.AAT_Technical_Team_Meeting_Minutes__c = 'Test';
        update aat2;
        test.stopTest();
    }
    private static testMethod void AATReqTest3(){
        
        AAT_Request__c aat3 = [Select Id, Stage__c, Ready_for_CIA_Technical_Approval__c,AAT_Technical_Team_Meeting_Minutes__c from AAT_Request__c where Title__c = 'test3'];
        aat3.Ready_for_CIA_Technical_Approval__c = true;
        update aat3;
        test.startTest();
        aat3.Next_AAT_Meeting__c = system.now() + 1;
        aat3.Stage__c = 'Under Review';
        update aat3;
        aat3.Next_AAT_Meeting__c = system.now() +2;
        update aat3;
        test.stopTest();
    }
    static void aatInsert(Map<String,Boolean> aatMaptoInsert){
        List<AAT_Request__c> insertList = new List<AAT_Request__c>();
        for(String title: aatMaptoInsert.keySet()){
            AAT_Request__c aat = new AAT_Request__c();
            aat.Title__c = title;
            aat.Request_Description__c = 'Test Des';
            aat.Next_AAT_Meeting__c = system.now()+1;
            aat.Meeting_Span__c = '15 min';
            aat.Ready_for_CIA_Technical_Approval__c = aatMaptoInsert.get(title);
            aat.RequestTechnology__c = '7nm/FX7';
            insertList.add(aat);
        }
        insert insertList;
    }
}