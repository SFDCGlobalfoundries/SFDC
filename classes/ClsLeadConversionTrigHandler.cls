/*
Type Name: ClsLeadConversionTrigHandler
Author: Cognizant
Created Date: 8th-May-2013
Reason: This class is used for is used for setting the Active flag on Contact to be true when The Lead is converted.
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/


global class ClsLeadConversionTrigHandler {
    
    /** Modified By Cognizant on 25042013 Start
     **/
    /**
        This method is used for deactivating the user record for accounts which has been deactivated.
        @method name: onLeadConversion
        @parameter:   List of Leads.
        @return :     none
    **/ 

    static public void onLeadConversion(List<Lead> leadList)
    { 
      List<Contact> contactList = new List<Contact>();
      Set<Id> ConvertedContactIdsSet = new Set<Id>();
      
    
      for(Lead leadObj :  leadList)
      {
        if(leadObj.IsConverted)
            ConvertedContactIdsSet.add(leadObj.ConvertedContactId);
      }
      
      if(ConvertedContactIdsSet!= null && !(ConvertedContactIdsSet.isEmpty())) {
          contactList = [SELECT Id,Status__c FROM Contact WHERE Contact.Id in : ConvertedContactIdsSet];
      }      

      for(Contact contactObj : contactList )
      {
        contactObj.Status__c = 'Active';
      }

       try{
           if(contactList.size()>0){
               update contactList;
           }
       }catch(DMLException de){
            System.debug(de.getMessage());
       }
    
    }
    
}