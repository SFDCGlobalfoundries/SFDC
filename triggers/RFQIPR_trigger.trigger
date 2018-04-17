/**
@Author < Nikhil bajaj >
@name < AcceptedIPRequest trigge on object RFQIPR >
@CreateDate < 1/5/2016 >
@Description < Trigge on RFQIPR object>
@Version <1.0>
*/
trigger RFQIPR_trigger  on RFQ_IPR__c(after insert, after delete, after undelete,after update) {
        new RFQIPR_TriggerHandler().run();
  
}