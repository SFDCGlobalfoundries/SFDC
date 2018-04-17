/** This trigger is use to create BurnIn Duration & Yields record after saving MCM parent record.
 * 
 * 
 * */

trigger PcmMcmDetailTrigger on PCM_MCM_Detail__c (after insert) {
    
    
    if(Trigger.isInsert){
        if(Trigger.isAfter)  {
             
           List<MCM_UserDefined_Cost__c> uCost = new List<MCM_UserDefined_Cost__c>();   
           List<MCM_Yields__c> newYld = new List<MCM_Yields__c>();    
           List<MCM_BurnIn_Duration__c> newBIDuration = new List<MCM_BurnIn_Duration__c>();  
            for (PCM_MCM_Detail__c mcm : Trigger.new) {
                MCM_Yields__c obj1 = new MCM_Yields__c();
                MCM_Yields__c obj2 = new MCM_Yields__c();
                MCM_Yields__c obj3 = new MCM_Yields__c();
                
                MCM_BurnIn_Duration__c obj4 = new MCM_BurnIn_Duration__C();
        
                MCM_UserDefined_Cost__c obj5 = new MCM_UserDefined_Cost__c();
                    
                obj1.MCM__c = mcm.Id;
                obj2.MCM__c  = mcm.id ;
                obj3.MCM__c = mcm.id ;
              
                  obj1.RecordTypeId = Schema.SObjectType.MCM_Yields__c.getRecordTypeInfosByName().get('Assembly Yield').getRecordTypeId();
                  obj2.RecordTypeId = Schema.SObjectType.MCM_Yields__c.getRecordTypeInfosByName().get('Burn-In User Defined').getRecordTypeId();
                  obj3.RecordTypeId = Schema.SObjectType.MCM_Yields__c.getRecordTypeInfosByName().get('Test Yield').getRecordTypeId();
                  newYld.add(obj1);
                  newYld.add(obj2);
                  newYld.add(obj3);
                
                  obj4.MCM__c = mcm.id ;
                  obj4.RecordTypeId = Schema.SObjectType.MCM_BurnIn_Duration__c.getRecordTypeInfosByName().get('Burn-In Duration').getRecordTypeId();  
                  newBIDuration.add(obj4);  
               
                obj5.MCM__c= mcm.id;
                obj5.RecordTypeId = Schema.SObjectType.MCM_UserDefined_Cost__c.getRecordTypeInfosByName().get('Assembly & Substrate Cost').getRecordTypeId();  
                uCost.add(obj5);  
                
               
            }
            insert newYld;
            insert newBIDuration;
            insert uCost;
        }
    }
    
}