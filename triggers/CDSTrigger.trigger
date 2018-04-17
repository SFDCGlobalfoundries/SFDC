/**
@Author < Varsha Tomar >
@name < CDSTrigger >
@CreateDate < 12/4/2016 >
@Description < Trigger on CDS object >
@Version <1.0>
*/
trigger CDSTrigger on Custom_Design__c (after insert) {
   
    new CDSTriggerHandler().run();  
   
}