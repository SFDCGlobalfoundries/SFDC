/*
* @ Author          :- Navneet Rajput
* @ Organization    :- Cognizant Technology solutions
* @ Project         :- GMPL/RX009
* @ Description     :- handler class of GMPL_BX009 object and it handles all after operation on GMPL_AfterTrigger  
* @ Date            :-18th March 2014
* @ Change History  :- 
**/

public class GMPL_GMPLAfterOperationHandler {

    private boolean isExecuting;
    public static Boolean isExecuted = false;
    public static string GMPLBX009_SHARE = EnvironmentVariable.get('GMPL_BX009_SHARE_REASON');
    // constructor set runnig context
    public GMPL_GMPLAfterOperationHandler(boolean isExecuting){
        
        this.isExecuting = isExecuting;
    }
    
    // Method Handle all after insert operations
    
    public void OnAfterInsert(List<GMPL_BX009__c> listOfNewRecords){
        // method handles future date add logic of RevenueForcasting (after inserting GMPL record)
        if(!isExecuted){
            GMPL_GMPLAfterOperationHandler.setRevenueForcastingDates(listOfNewRecords);
            isExecuted=true;
        }   
    } 
    
    // Method Handle all after update operations
    
    public void OnAfterUpdate(List<GMPL_BX009__c> listOfOldRecords, List<GMPL_BX009__c> listOfUpdatedRecords,
                              Map<Id,GMPL_BX009__c> mapOfUpdatedRecords,Map<Id,GMPL_BX009__c> mapOfOldRecords){
        // method handles future date add logic of RevenueForcasting (after updating GMPL record)
        if(!isExecuted){
            GMPL_GMPLAfterOperationHandler.setUpdatedRevenueForcastingDates(listOfUpdatedRecords,mapOfUpdatedRecords,mapOfOldRecords);
            isExecuted=true;
        }
    }
    
    // return true if class running in trigger context else false 
    public boolean IsTriggerContext{
        get{ return isExecuting;}
    }
    
    // Method use to add future dates in to RevenueForcast object
    private static void setRevenueForcastingDates(List<GMPL_BX009__c> listOfGmplRecords){
        system.debug('Inside setRevenueForcastingDates>>>>>>>');
        List<Revenue_Forecast__c> listOfRevenueForcastRecords = new List<Revenue_Forecast__c>();
        //try {
            
            if (listOfGmplRecords!=null && !listOfGmplRecords.isEmpty()){
                system.debug('listOfGmplRecords>>>>>>>'+listOfGmplRecords);
                for (GMPL_BX009__c gmpl : listOfGmplRecords){
                    if (gmpl.Product_Start_Date__c!=null && gmpl.Product_Start_Date__c!=''){
                        for (Integer i=0;i<8;i++){
                            Revenue_Forecast__c revenueObj = new Revenue_Forecast__c();
                            revenueObj.Year__c = String.valueOf(Integer.valueOf(gmpl.Product_Start_Date__c)+i);
                            revenueObj.GMPL_BX009__c = gmpl.Id;
                            revenueObj.Average_Sales_Price__c=0.0;
                            revenueObj.Quantity__c=0;
                            
                            listOfRevenueForcastRecords.add(revenueObj);
                        }
                    }
                }
                system.debug('listOfRevenueForcastRecords>>>>>>>>>>>>'+listOfRevenueForcastRecords);
                if (listOfRevenueForcastRecords!=null && !listOfRevenueForcastRecords.isEmpty()){
                    insert listOfRevenueForcastRecords;
                }
            }
            
        /*} catch (Exception e){
            system.debug('Exception :: '+e.getMessage());
        }*/   
    }
    
    // Method use to update future dates in to RevenueForcasting object when GMPL date is updated.
    
    private static void setUpdatedRevenueForcastingDates(List<GMPL_BX009__c> listOfUpdatedRecords,
                                                        Map<Id,GMPL_BX009__c> mapOfUpdatedRecords,
                                                        Map<Id,GMPL_BX009__c> mapOfOldRecords){
        
        List<Revenue_Forecast__c> updateRevenueForcasts = new List<Revenue_Forecast__c>();
        Map<Id,List<Revenue_Forecast__c>> mapOfGmplAndRevenueForcastingRecords;  
        mapOfGmplAndRevenueForcastingRecords = GMPL_GMPLAfterOperationHandler.prepareMapOfGmplAndRevenueForcastingRecords(listOfUpdatedRecords);    
        if (listOfUpdatedRecords!=null && !listOfUpdatedRecords.isEmpty()){
            for (GMPL_BX009__c gmplRecord : listOfUpdatedRecords){
                if (gmplRecord.Product_Start_Date__c != mapOfOldRecords.get(gmplRecord.Id).Product_Start_Date__c){
                    List<Revenue_Forecast__c> revenueForcasts = mapOfGmplAndRevenueForcastingRecords.get(gmplRecord.Id);
                    if (revenueForcasts!=null && !revenueForcasts.isEmpty()){
                        revenueForcasts.sort();
                        for (Integer i=0;i<revenueForcasts.size();i++){
                            revenueForcasts[i].year__c = String.valueOf(Integer.valueOf(gmplRecord.Product_Start_Date__c)+i);
                        }
                        updateRevenueForcasts.addAll(revenueForcasts);
                    }// Added to generate blank 8 years if initial start year was blank
                    //*******************************************************************//
                    else if(revenueForcasts == null || revenueForcasts.isEmpty()){
                    	for (Integer i=0;i<8;i++){
                            Revenue_Forecast__c revenueObj = new Revenue_Forecast__c();
                            revenueObj.Year__c = String.valueOf(Integer.valueOf(gmplRecord.Product_Start_Date__c)+i);
                            revenueObj.GMPL_BX009__c = gmplRecord.Id;
                            revenueObj.Average_Sales_Price__c=0.0;
                            revenueObj.Quantity__c=0;
                            updateRevenueForcasts.add(revenueObj);
                    	}
                    }
                    //*******************************************************************//
                }
            }
        }
        
        if (updateRevenueForcasts!=null && !updateRevenueForcasts.isEmpty()){
            upsert updateRevenueForcasts;
        }
    }   

    // Method prepares map of <ID,List<Sobject>>, holding key as Gmpl Id and value as List of RevenueForcasting object 
    private static Map<Id,List<Revenue_Forecast__c>> prepareMapOfGmplAndRevenueForcastingRecords(List<GMPL_BX009__c> listOfUpdatedRecords){
        
        Map<Id,List<Revenue_Forecast__c>> mapOfGmplAndRevenueForcastingRecords = new Map<Id,List<Revenue_Forecast__c>>();
        
        if (listOfUpdatedRecords!=null && !listOfUpdatedRecords.isEmpty()){
            List<Revenue_Forecast__c> listOfRevenueForcastRecords = [SELECT Id,
                                                                            year__c,
                                                                            GMPL_BX009__c
                                                                     FROM   Revenue_Forecast__c
                                                                     WHERE  GMPL_BX009__c IN : listOfUpdatedRecords];
                                                                    
            if (listOfRevenueForcastRecords!=null && !listOfRevenueForcastRecords.isEmpty()){                                                       
                for (Revenue_Forecast__c revenueRecord : listOfRevenueForcastRecords){
                    if(!mapOfGmplAndRevenueForcastingRecords.containsKey(revenueRecord.GMPL_BX009__c)){
                        mapOfGmplAndRevenueForcastingRecords.put(revenueRecord.GMPL_BX009__c, new List<Revenue_Forecast__c>());                         
                    }
                    mapOfGmplAndRevenueForcastingRecords.get(revenueRecord.GMPL_BX009__c).add(revenueRecord);
                }
            }
        }
        return mapOfGmplAndRevenueForcastingRecords;                                                        
    }   // End of prepareMapOfGmplAndRevenueForcastingRecords Method
    
    // Adding to the GMPL/BX009 share with Read/Edit permission
    public static void addtoGMPLShare(Map<Id,Set<Id>> gmplRegHeadIdMap){
        List<GMPL_BX009__Share> gmplBx009ShareList = new List<GMPL_BX009__Share>();
        for(Id gmplId : gmplRegHeadIdMap.keySet()){
            for(Id userId : gmplRegHeadIdMap.get(gmplId)){
                GMPL_BX009__Share gmplBx009Share = new GMPL_BX009__Share();
                gmplBx009Share.AccessLevel = 'Edit';
                gmplBx009Share.ParentId = gmplId;
                gmplBx009Share.RowCause = GMPLBX009_SHARE;
                gmplBx009Share.UserOrGroupId = userId;
                gmplBx009ShareList.add(gmplBx009Share);
            }
        }
        
        if(gmplBx009ShareList.size()>0){
            insert gmplBx009ShareList;
        }
    }
    
    // Remove the user from the GMPL/BX009 share
    public static void removeFromGMPLShare(Set<Id> gmplIds, Set<Id> userIds){
        
        List<GMPL_BX009__Share> gmplList =  [   SELECT  id 
                                                FROM    GMPL_BX009__Share 
                                                WHERE   ParentId in :gmplIds 
                                                AND     UserOrGroupId in :userIds
                                                AND     RowCause = :GMPLBX009_SHARE
                                            ];


        if(gmplList!=null && gmplList.size()>0){
            delete gmplList;
        }
    }
    
}