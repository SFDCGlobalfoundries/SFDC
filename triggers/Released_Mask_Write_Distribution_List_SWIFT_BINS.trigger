/*
Type Name: Released_Mask_Write_Distribution_List_SWIFT_BINS
Author: Cognizant 
Created Date:30-May-2014
Author: Cognizant Technology Solutions
Description: Before Insert Trigger on Released Mask Write Distribution List
……..
……..
*/
 /**
        This method populates checks whether the input email address is public email address or not. 
        @parameter:   None.
        @return :     None.
     **/ 
trigger Released_Mask_Write_Distribution_List_SWIFT_BINS on Released_Mask_Write_Distribution_List__c (before insert) {
    
       Map<String, MRS_Invalid_Email_Extension__c> mapMRSIE = MRS_Invalid_Email_Extension__c.getAll();       
       for (Released_Mask_Write_Distribution_List__c objRMWDL : Trigger.new){            
           if (mapMRSIE.keySet().contains(objRMWDL.Distribution_List__c.subStringAfter('@').trim())){
                objRMWDL.addError('Error: Public email address is not allowed');
            }              
       }
}