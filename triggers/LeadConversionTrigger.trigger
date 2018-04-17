/*
Type Name: LeadConversionTrigger Trigger
Author: Cognizant 
Created Date: 8th-May-2013
Reason: This trigger is used for setting the Active flag on Contact to be true when The Lead is converted.
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

trigger LeadConversionTrigger on Lead (after Update) {
   List<Lead> leadList = new List<Lead>();
  /*

  for(Lead leadObj :  trigger.new){
    leadList.add(leadObj);
  }
  ClsLeadConversionTrigHandler.onLeadConversion(leadList);
  */
}