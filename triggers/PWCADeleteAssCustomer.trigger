/**
 * Author: 
 * Company: Cognizant Technology Solutions Asia Pacific Pte Ltd
 * Description: It is a PWCADeleteAssCustomer trigger. It handles trigger events before update, delete and after insert.
 *            
 * History:
 * <Vijay>     04032014 - commented code from Line No.30 to Line No.50.Now PWCA Publication will be shared with portal user once it is published. 
 */
trigger PWCADeleteAssCustomer on PWCAAssociated_Customers__c (before delete,after insert,before update) {

 if(Trigger.isDelete)
    {
        Map<String,String> mapId = new Map<String,String>();
        Map<String,String> MAssoCPWCAId = new Map<String,String>();
        for(PWCAAssociated_Customers__c accList : Trigger.old){
          MAssoCPWCAId.put(accList.Id,accList.PWCA_publication__c);  
          mapId.put(accList.PWCA_publication__c,accList.Short_Name__c);
        }
        Map<Id,PWCA_publication__c> MPWCAPublication=new Map<Id,PWCA_publication__c>([Select Id,Status__c,Document_Status__c from PWCA_publication__c]);
        for(PWCAAssociated_Customers__c accList : Trigger.old){
            if(MPWCAPublication.get(MAssoCPWCAId.get(accList.Id)).Document_Status__c =='Pending' || MPWCAPublication.get(MAssoCPWCAId.get(accList.Id)).Document_Status__c =='Approved'){
            mapId.remove(accList.PWCA_publication__c);
            accList.adderror('Associated Customers cannot be deleted after PWCA is sent for approval/approved');
            }        
        }
        DeleteAssociateCustoer.CreateDeleteObject(mapId,'PWCA');
    
    }
    
        /* Commented sharing logic. Now PWCA Publication will be shared with portal user once it is published.
        if(Trigger.isInsert)
        {
        Set<Id> userList = new Set<Id>();
        Set<Id> accSet = new Set<Id>();
        Map<ID,Set<Id>> userRecMap = new Map<ID,Set<Id>>();
            for(PWCAAssociated_Customers__c pwcObj: Trigger.new)
            {
              accSet.add(pwcObj.Account__c);
            
            }
         for(User PUser : [select Id, Contact.AccountId from User where Contact.AccountId IN : accSet])
         {
         userList.add(PUser.Id);
         }
         userRecMap.put(Trigger.new[0].PWCA_publication__c,userList);
         ClsNewCPKReport clsNewCpkIns = new ClsNewCPKReport();
         clsNewCpkIns.shareToQAandPIDetail(userRecMap);
                 
        }
        */
        if(Trigger.isUpdate){
        
        Map<String,String> MAssoCPWCAId = new Map<String,String>();
        for(PWCAAssociated_Customers__c accList : Trigger.new){
            MAssoCPWCAId.put(accList.Id,accList.PWCA_publication__c);
        }

        Map<Id,PWCA_publication__c> MPWCAPublication=new Map<Id,PWCA_publication__c>([Select Id,Status__c,Document_Status__c from PWCA_publication__c where Id in :(MAssoCPWCAId.values())]);
        for(PWCAAssociated_Customers__c accList : Trigger.new){
            if(MPWCAPublication.get(MAssoCPWCAId.get(accList.Id)).Document_Status__c =='Pending' || MPWCAPublication.get(MAssoCPWCAId.get(accList.Id)).Document_Status__c =='Approved'){
                            accList.adderror('Associated Customers cannot be edited after PWCA is sent for approval/approved');

            }
        
        }
        
        
        
        
        
        
        
        }
    
}