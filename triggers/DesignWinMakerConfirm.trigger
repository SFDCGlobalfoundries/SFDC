trigger DesignWinMakerConfirm on Attachment (after insert) {
/***************************************************************************
Trigger: Design Win Maker Confirm 
Object: Opportunity

Description:
When an attachment is added to Opportunity,
Set “Customer Decision Maker Confirmed DW via email” to Yes.


Date                 Author
05-10-2012           gauravkhare@deliotte.com

******************************************************************************/
 
 // check attachement record and Update the Field
       List<Opportunity> opp = [select id, Customer_Decision_Maker_Confirmed_DW_via__c from Opportunity where id =: Trigger.New[0].ParentId];
       if(opp.size()>0)
       {
             opp[0].Customer_Decision_Maker_Confirmed_DW_via__c = 'Yes';
             update opp;
       }                    
}