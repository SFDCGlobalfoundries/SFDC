/**
@Author < Meghna Ganguly >
@name < ASICSSpecificationsTrigger >
@CreateDate < 01/05/2016 >
@Description < Trigger on ASICS Specifications object to manage its sharing >
@Version <1.0>
*/
trigger ASICSSpecificationsTrigger on ASICS_Specification__c (after insert) {

   new ASICSSpecificationsTriggerHandler().run();

}