/**
@Author < Meghna Ganguly >
@name < PackageDataTrigger >
@CreateDate < 12/05/2016 >
@Description < Trigger on Package Data object to manage its sharing >
@Version <1.0>
*/
trigger PackageDataTrigger on Package_Data__c (after insert) {

   new PackageDataTriggerHandler().run();

}