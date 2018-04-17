/*
* Author : Akash
* Purpose : To support CPQScribeWidthOutput page
* Createddate : Sep 20, 2015
*/
public without sharing class CPQScribeWidthOutputExt {
    
    
    public Device__c device{get;set;}
    public CPQScribeWidthOutputExt(ApexPages.StandardController controller) {
      
      Apttus_Proposal__Proposal__c conf = (Apttus_Proposal__Proposal__c)controller.getRecord();
      If(conf.Device__c != NULL) {
        device = [Select Id,Min_scribe_width_X_post_shrink__c,Min_scribe_width_Y_post_shrink__c,Std_scribe_width_X_post_shrink__c,Std_scribe_width_Y_post_shrink__c FROM Device__c where Id = :conf.Device__c];      
      }
      
   
    }

}