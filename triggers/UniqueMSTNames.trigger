/*
    Author: Mallika Seth
    Description: This Trigger runs logic on mask set title name for duplicate check.
    History: 
        Mseth  28082015    - Creation
*/
trigger UniqueMSTNames on Mask_Set_Title__c (Before Insert,Before Update) {

Map<String, Mask_Set_Title__c> mapMaskSetTitle = new Map<String, Mask_Set_Title__c>();

}