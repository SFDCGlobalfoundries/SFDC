/*
Author: Amrita
Description: Apex test class for DeletePTRecordController
History: 

*/
@isTest(seealldata=false)
public class DeletePTRecordControllerTest {
    
    static Process_Technology__c createPT(){
        
        Process_Technology__c pt = new Process_Technology__c(
            Title__c = 'testPT',
            PT_Number__c = 'abcd'
        );
        insert pt; 
        return pt;                                            
    }
    
    static CPQ_MLGPLUS__c createMLGPLUSwithPT(Process_Technology__c pt){
        
        CPQ_MLGPLUS__c record = new CPQ_MLGPLUS__c(
            Geometry__c = '0.014UM', 
            Process_Technology__c = pt.PT_Number__c 
        );
        
        insert record;
        return record;                                            
    }
    
    //test init
    static testMethod void initTest(){
        
        Process_Technology__c pt = createPT();
        CPQ_MLGPLUS__c rec = createMLGPLUSwithPT(pt);
        Test.startTest();
        
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(rec);
        DeletePTRecordController controller = new DeletePTRecordController(stdcontroller);
        controller.init();
        
        Integer recordCount = [select COUNT() from Process_Technology__c where PT_Number__c = :pt.PT_Number__c];
        System.assertEquals(recordCount , 1);   
        
        Test.stopTest();
        
    }
}