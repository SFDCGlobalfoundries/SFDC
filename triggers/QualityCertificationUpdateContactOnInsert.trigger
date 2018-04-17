/**
 * Author: 
 * Company: Cognizant Technology Solutions Asia Pacific Pte Ltd
 * Description: It is a QualityCertificationUpdateContactOnInsert trigger. It handles trigger events after delete and update.
 *            
 * History:
 * <Vijay>     11032014 - commented code from Line No.64 to Line No.94. Commented Quality Certificate Sharing functionality and modified 
 						  implementation logic and triggered it once the Quality Certficate has been approved. 
 						  
 */

trigger QualityCertificationUpdateContactOnInsert on QC_Access_List__c (before delete,before insert,after insert,before update) 
{
    if(Trigger.isDelete)
    {
        Map<String,String> MQcIdsDel= new Map<String,String>();
        Map<String,String> mapId = new Map<String,String>();
        for(QC_Access_List__c accList : Trigger.old)
        {
            MQcIdsDel.put(accList.Id,accList.Quality_Certificate__c);
            mapId.put(accList.Quality_Certificate__c,accList.Short_Name_WhiteList__c);
            
        }
        Map<Id,Quality_Certificate__c> MQualityCertsdel=new Map<Id,Quality_Certificate__c>([Select Id,Stage__c,(Select Id,Stage__c from UploadQC__r) from Quality_Certificate__c where Id in :(MQcIdsDel.values())]);
        for(QC_Access_List__c eachAssociatedCust : Trigger.old){
                    if(MQualityCertsdel.get(MQcIdsDel.get(eachAssociatedCust.Id)).Stage__c=='Approved'){
                        
                        eachAssociatedCust.adderror('Customers cannot be deleted once the Reports are Approved');
                    }                
            }
     DeleteAssociateCustoer.CreateDeleteObject(mapId,'QC');   
    }
    
    
    
   if(Trigger.isBefore)
   {
        if(Trigger.isInsert)
        {
            for(QC_Access_List__c accList : Trigger.new)
            {
                if(!accList.checkSource__c)
                accList.Customer_White_List__c = accList.Account__c;
            }
        }
        
        if(Trigger.isUpdate){
            Map<Id,Id> MQcIds=new Map<Id,Id>();
            for(QC_Access_List__c accList : Trigger.new)
            {
                MQcIds.put(accList.Id,accList.Quality_Certificate__c);
            }
            Map<Id,Quality_Certificate__c> MQualityCerts=new Map<Id,Quality_Certificate__c>([Select Id,Stage__c,(Select Id,Stage__c from UploadQC__r) from Quality_Certificate__c where Id in :(MQcIds.values())]);
            for(QC_Access_List__c eachAssociatedCust : Trigger.new){
                if(MQualityCerts.get(MQcIds.get(eachAssociatedCust.Id)).Stage__c=='Approved'){
                        System.debug('----->Inside check');
                        eachAssociatedCust.adderror('Customers cannot be edited once the Reports are Approved');
                    }
                
            }
        }
    }
    
    /* Quality Certificate sharing method invocation logic has been commented
     if(Trigger.isAfter)
    {
    Set<Id> userList = new Set<Id>();
    Set<Id> accSet = new Set<Id>();
    Map<ID,Set<Id>> userRecMap = new Map<ID,Set<Id>>();
    ID id;
         if(Trigger.isInsert)
        {
            for(QC_Access_List__c qcObj: Trigger.new)
            
            { 
              System.debug('------->'+qcObj.Customer_Black_List__c);
              if(qcObj.Customer_Black_List__c==null || qcObj.Customer_Black_List__c==''){
              
              accSet.add(qcObj.Account__c);
              
              }
            
            }
          System.debug('------->|||||'+accSet);  
         for(User PUser : [select Id, Contact.AccountId from User where Contact.AccountId IN : accSet])
         {
         userList.add(PUser.Id);
         }
         userRecMap.put(Trigger.new[0].Quality_Certificate__c,userList);
         QCNewRecord qcIns = new QCNewRecord ();
         qcIns.shareToQAandPIDetail(userRecMap);
                 
        }
    }*/
 
}