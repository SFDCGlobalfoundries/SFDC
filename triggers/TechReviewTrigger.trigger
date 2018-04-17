/**
@Author < Varsha Tomar >
@name < TechReviewTrigger >
@CreateDate < 11/21/2016 >
@Description < Trigger on Tech Review object >
@Version <1.0>
*/
trigger TechReviewTrigger on Tech_Review_Summary__c (after insert, after update) {
    
    new TechReviewTriggerHandler().run();  
   
}