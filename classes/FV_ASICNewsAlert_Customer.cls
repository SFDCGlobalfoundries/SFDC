/*------------------------------------------------------------  
Author:        Sameera
Company:       CTS
Description:   A VF page Controller which fetches all News and Alert Which are published and greater than today
History
<Date>      <Authors Name>     <Brief Description of Change>
------------------------------------------------------------*/
public with sharing class  FV_ASICNewsAlert_Customer{

    public List<ASIC_News_Alert__c> ASICNewsAlertList {get; set;}
    
    public FV_ASICNewsAlert_Customer(ApexPages.StandardController controller) {
        ASICNewsAlertList = new List<ASIC_News_Alert__c>();
        ASICNewsAlertList = [SELECT Id,Name,Active__c,RecordType.Name,Title__c,Published_on__c,Type__c from ASIC_News_Alert__c where Active__c=true AND Published_on__c <=:system.now()  ORDER BY Published_on__c DESC];
        
     }
  
   
}