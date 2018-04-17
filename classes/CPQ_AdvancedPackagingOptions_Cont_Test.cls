/*
    Author: Shivam Sharma
    Description: This is the test class for Advanced Packaging Option class.
    History:
        SShar    11182015    - code creation.          
*/
@isTest(SeeAllData=false)
public class CPQ_AdvancedPackagingOptions_Cont_Test{
	@testSetup
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        
     }
    public static Apttus_Proposal__Proposal__c createConfigPlusWithQuestions(String packagingOption, String metalStackOption){
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(APTPS_Packaging_Option__c = packagingOption, APTPS_Metal_Options__c = metalStackOption);        
        try{
            insert proposal;
        }catch(Exception e){
            System.assert(false);
            return null;
        }
        System.assertNotEquals(proposal.Id, null);
        
        List<Configurator_Plus_Question__c> lstOfQuestions = new List<Configurator_Plus_Question__c>();
        Configurator_Plus_Question__c configQueRec = null;
        // Level 1 questions    
                configQueRec = new Configurator_Plus_Question__c(Question_Name__c = 'Test Question 1', Question_Type__c = 'Packaging Option', Criteria__c = packagingOption, Data_Type__c = 'Picklist', Level__c = '1', Required__c = true);
                configQueRec.Unique_Identifier__c = configQueRec.Question_Name__c  + configQueRec.Criteria__c ;
            lstOfQuestions.add(configQueRec);
        
                configQueRec = new Configurator_Plus_Question__c(Question_Name__c = 'Test Question 2', Question_Type__c = 'Packaging Option', Criteria__c = packagingOption, Data_Type__c = 'Text', Level__c = '1');
                configQueRec.Unique_Identifier__c = configQueRec.Question_Name__c  + configQueRec.Criteria__c ;
            lstOfQuestions.add(configQueRec);
        
        //Question of type Packaging options - metal stacks
            configQueRec = new Configurator_Plus_Question__c(Question_Name__c = 'Test Question Metal Stacks', Question_Type__c = 'Packaging Options - Metal Stacks', Criteria__c = packagingOption, Data_Type__c = 'Picklist', Level__c = '1', Required__c = false);
            configQueRec.Unique_Identifier__c = configQueRec.Question_Name__c  + configQueRec.Criteria__c ;
        lstOfQuestions.add(configQueRec);
        
        try{
            insert lstOfQuestions;
            System.assert(true);
        }catch(Exception ex){
            System.assert(false);
            return proposal;
        }
        //Inserting level 2 questions
        List<Configurator_Plus_Question__c> lstOfChildQuestions = new List<Configurator_Plus_Question__c>();
        Configurator_Plus_Question__c configQuestion = lstOfQuestions.get(0);
            configQueRec = new Configurator_Plus_Question__c(Question_Name__c = 'Test Child Question 1', Parent_Question__c = configQuestion.Id, Question_Type__c = 'Packaging Option', Criteria__c = 'Test Picklist Value 1, Test Picklist Value 2', Data_Type__c = 'Picklist', Level__c = '2', Required__c = false);
            configQueRec.Unique_Identifier__c = configQueRec.Question_Name__c + configQuestion.Id + configQueRec.Criteria__c ;
            lstOfChildQuestions.add(configQueRec);
            configQueRec = new Configurator_Plus_Question__c(Question_Name__c = 'Test Child Question 2', Parent_Question__c = configQuestion.Id, Question_Type__c = 'Packaging Option', Criteria__c = 'Test Picklist Value 1, Test Picklist Value 2', Data_Type__c = 'Text', Level__c = '2', Required__c =  true , Required_If__c = 'Test Picklist Value 1');
            configQueRec.Unique_Identifier__c = configQueRec.Question_Name__c + configQuestion.Id + configQueRec.Criteria__c ;
            lstOfChildQuestions.add(configQueRec);
        try{
            insert lstOfChildQuestions;
            System.assert(true);
        }catch(Exception ex){
            System.assert(false);
            return proposal;
        }
        
        insertPicklistValues(lstOfQuestions.get(0), metalStackOption);
        insertPicklistValues(lstOfQuestions.get(2), metalStackOption);
        insertPicklistValues(lstOfChildQuestions.get(0), metalStackOption);
        
        
        List<Configurator_Plus_Response__c> lstOldResponses = new List<Configurator_Plus_Response__c>();
        Configurator_Plus_Response__c configResponse = new Configurator_Plus_Response__c(Configurator_Plus__c = proposal.id, Configurator_Plus_Question__c = lstOfQuestions.get(0).id);
        configResponse.Response__c = 'Test Picklist Value 1' ;
        lstOldResponses.add(configResponse);
        Configurator_Plus_Response__c configResponse2 = new Configurator_Plus_Response__c(Configurator_Plus__c = proposal.id, Configurator_Plus_Question__c = lstOfQuestions.get(1).id);
        configResponse2.Response__c = 'Previously captured test response' ;
        lstOldResponses.add(configResponse2);
        try{
            insert lstOldResponses;
            System.assert(true);
        }catch(Exception ex){
            System.assert(false);
        }
        
        return proposal;
    }
    private static void insertPicklistValues(Configurator_Plus_Question__c configQueRec, String metalStackOption){
        List<Configurator_Plus_Picklist_Value__c> lstPicklist = new List<Configurator_Plus_Picklist_Value__c>();
        String criteria = null;
        if(configQueRec.Question_Type__c == 'Packaging Option')
            criteria = configQueRec.Criteria__c;
        else if(configQueRec.Question_Type__c == 'Packaging Options - Metal Stacks')
            criteria = metalStackOption;
        
        Configurator_Plus_Picklist_Value__c picklistValue = null;
            picklistValue = new Configurator_Plus_Picklist_Value__c(Configurator_Plus_Question__c = configQueRec.id, Criteria__c = criteria, Picklist_Name__c = 'Test Picklist Value 1');
        lstPicklist.add(picklistValue);
            picklistValue = new Configurator_Plus_Picklist_Value__c(Configurator_Plus_Question__c = configQueRec.id, Criteria__c = criteria, Picklist_Name__c = 'Test Picklist Value 2', Contact_GF__c = true);
        lstPicklist.add(picklistValue);
            picklistValue = new Configurator_Plus_Picklist_Value__c(Configurator_Plus_Question__c = configQueRec.id, Criteria__c = criteria, Picklist_Name__c = 'Test Picklist Value 3');
        lstPicklist.add(picklistValue);
    
        try{
            insert lstPicklist;
            System.assert(true);
        }catch(Exception ex){
            System.assert(false);
            return;
        }
    }
    
    public static testMethod void testWirebond(){
        
        PageReference pRef = Page.CPQAdvancedPackagingOptions;
        Test.setCurrentPage(pRef);
        
        CPQ_AdvancedPackagingOptions_Controller controller = new CPQ_AdvancedPackagingOptions_Controller(new ApexPages.StandardController(createConfigPlusWithQuestions('Wirebond', '6LM (5U1x_1T8x_LB)'))); 
        //controller = new CPQ_AdvancedPackagingOptions_Controller(new ApexPages.StandardController(createConfigPlusWithQuestions('Wirebond', '')));
        //controller = new CPQ_AdvancedPackagingOptions_Controller(new ApexPages.StandardController(createConfigPlusWithQuestions('Flip-Chip', '6LM (5U1x_1T8x_LB)')));
        //Mandatory question left blank
        controller.mapOfQuestions.get(controller.questionsByLevel.get(1).get(0)).answer = '';
        controller.getreEvaluatePicklistValuesOfChildQuestions();
        controller.saveAction();
        
        //Selection which requires Contact GF
        controller.mapOfQuestions.get(controller.questionsByLevel.get(1).get(0)).answer = 'Test Picklist Value 2' ;
        controller.getreEvaluatePicklistValuesOfChildQuestions();
        controller.saveAction();
        
        //Deletion of previosly captured response for non mandatory question
        controller.mapOfQuestions.get(controller.questionsByLevel.get(1).get(1)).answer = '';
        controller.mapOfQuestions.get(controller.questionsByLevel.get(1).get(0)).answer = 'Test Picklist Value 3' ;
        controller.mapOfQuestions.get(controller.questionsForMetalStack.get(1).get(0)).answer = 'Test Picklist Value 3' ;
        controller.getreEvaluatePicklistValuesOfChildQuestions();
        controller.saveAction();
        
    }
}