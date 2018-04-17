/*************************************************************************************************************************************************************
@ Class:         MTATAssignMobileComHelper
@ Version:        1.0
@ Author:         Sridhar Gopireddy (Sridhar.gopireddy@globalfoundries.com)
@ Purpose:        This Handler class is handling the events of Assign a MobileCom.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 29.12.2016/Sridhar Gopireddy  / Created the class.
**************************************************************************************************************************************************************/
 public class MTATAssignMobileComHelper{
  /*********************************************************************************************************************************************************
    @ Method:         beforeAssignMobileComInsert
    @ Version:        1.0
    @ Author:         Sridhar Gopireddy (Sridhar.gopireddy@globalfoundries.com)
    @ Purpose:        This method will check device assign to another user and before insert event.
    **********************************************************************************************************************************************************/    
    public void beforeAssignMobileComInsert(List<Assign_a_MobileCom__c> newMobileList){
      if(!IntegrationUserUtil.isSkipTrigger()){
        Boolean isIntegrationUser = false;
        IntegrationUsers__c setting = IntegrationUsers__c.getValues(userInfo.getUserId());   
        if(setting <> null && setting.Is_Integration_User__c) isIntegrationUser = true;
       
        List<Assign_a_MobileCom__c > listassignmobles=[SELECT id,Activation_Date__c,Inactivation_Date__c,MobileCom__c,MobileCom__r.Id,HCM_Employee__c,HCM_Employee__r.Email_Address__c,HCM_Employee__r.id,HCM_Employee__r.Status__c,MobileCom__r.Name,HCM_Employee__r.Name FROM Assign_a_MobileCom__c];
         for(Assign_a_MobileCom__c  newmc :  newMobileList){
            if(newmc!=null){
             //when new records inserts it chechecks is device assign to one user and active
                for(Assign_a_MobileCom__c mc : listassignmobles){ 
                    if(mc.MobileCom__c==newmc.MobileCom__c){
                        if(date.today() <= mc.Inactivation_Date__c && mc.HCM_Employee__r.Status__c=='Active'){
                            newmc.MobileCom__c.addError('Mobile already  assigned to '+mc.HCM_Employee__r.Email_Address__c);
                        }
                        //if(newmc.HCM_Employee__r.Status__c=='Inactive'){
                        //newmc.HCM_Employee__c.addError(newmc.HCM_Employee__r.Email_Address__c+' -- is Inactive so you cannot assign for this user');
                       // }
                    }
                    if(mc.HCM_Employee__c==newmc.HCM_Employee__c){
                        if(newmc.HCM_Employee__r.Status__c!='Inactive'){
                            newmc.HCM_Employee__c.addError(mc.HCM_Employee__r.Name+'--'+mc.HCM_Employee__r.Email_Address__c+'-- already assigned for  '+mc.MobileCom__r.Name);
                        }
                    }
                }
            }    
        }
        }
    }
    /*********************************************************************************************************************************************************
    @ Method:         beforeAssignMobileComupdate
    @ Version:        1.0
    @ Author:         Sridhar Gopireddy (Sridhar.gopireddy@globalfoundries.com)
    @ Purpose:        This method will call if existing values change when before update event.
    **********************************************************************************************************************************************************/ 
    public void beforeAssignMobileComupdate(List<Assign_a_MobileCom__c> newMobileList){
        if(!IntegrationUserUtil.isSkipTrigger()){
        Boolean isIntegrationUser = false;
        IntegrationUsers__c setting = IntegrationUsers__c.getValues(userInfo.getUserId());   
        if(setting <> null && setting.Is_Integration_User__c) isIntegrationUser = true;
            for(Assign_a_MobileCom__c  newmc :  newMobileList){
        
            if(newmc!=null){
                Assign_a_MobileCom__c  oldmc=(Assign_a_MobileCom__c)Trigger.oldMap.get(newmc.Id);
                if(oldmc.MobileCom__c!=newmc.MobileCom__c){
                    newmc.MobileCom__c.addError('You cannot change this MobileCom value');
                }
                if(oldmc.HCM_Employee__c!=newmc.HCM_Employee__c){
                    newmc.HCM_Employee__c.addError('You cannot change this HCM Employee value');
                }
                }
        }
                 
    }

    }
}