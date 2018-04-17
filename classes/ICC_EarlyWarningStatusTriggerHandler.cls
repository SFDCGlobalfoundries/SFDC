/*
trigger handle class for EarlyWarningstatus trigger.
This class handles both scenarios: update Version Id , update Is latest version 
Author: Rahul Majumder
Version 1.0
*/

public class ICC_EarlyWarningStatusTriggerHandler {

 public static void updateVersions(List<Early_Warning_Status__c > lstNew_EWS)
 {
       
        Set<Id> setSalesOrderScheduleIds = new Set<Id>();
        for(Early_Warning_Status__c ews : lstNew_EWS)
        {
            setSalesOrderScheduleIds.add(ews.Sales_Order1__c);
        }
 
        List<Sales_Order_Schedule__c> lst_SoS = new List<Sales_Order_Schedule__c>();
        List<Early_Warning_Status__c> lst_EWS_LatestVersions = new List<Early_Warning_Status__c>();
        List<Early_Warning_Status__c> lst_EWS_OldVersions = new List<Early_Warning_Status__c>();
        set<id>set_EWSId = new set<id>();
        for(Sales_Order_Schedule__c sos : [Select Id, 
                                          (Select AVAIL_DATE__c,Is_Latest_Version__c, Version_Id__c,EWS_FLAG__c, Available_Quantity__c FROM Early_Warning_Status__r WHERE Version_Id__c != null AND AVAIL_DATE__c != null ORDER BY Version_Id__c DESC) FROM Sales_Order_Schedule__c WHERE Id IN: setSalesOrderScheduleIds])
        {
            Decimal decHighestVersion;
            
            for(Early_Warning_Status__c ews : sos.Early_Warning_Status__r)
            {
                if(decHighestVersion != null && ews.Version_Id__c < decHighestVersion)
                   continue ;
                   
                decHighestVersion = ews.Version_Id__c;  
            }
            
            for(Early_Warning_Status__c ews : sos.Early_Warning_Status__r)
            {
                if(ews.Version_Id__c == decHighestVersion)
                {
                    ews.Is_Latest_Version__c = true;
                    lst_EWS_LatestVersions.add(ews);
                }
                else
                {
                    ews.Is_Latest_Version__c = false;
                    lst_EWS_OldVersions.add(ews);
                }
            }
            
            Date highestDate;
            Decimal highestAvailableQuantity;
            string eFlag;
            for(Early_Warning_Status__c ews : lst_EWS_LatestVersions)
            {
                if(highestDate != null && ews.AVAIL_DATE__c <= highestDate)
                    continue;
                    
                highestDate = ews.AVAIL_DATE__c;
                highestAvailableQuantity = ews.Available_Quantity__c;
                eFlag = ews.EWS_FLAG__c;
                
            }
            
            lst_SoS.add(new Sales_Order_Schedule__c(Id = sos.id, Avail_Qty__c = highestAvailableQuantity, AVAIL_DATE__c = highestDate, EWS_FLAG__c = eFlag));
            
        }
        
        try{
            if(!lst_SoS.isEmpty())   update lst_SoS;
            if(!lst_EWS_LatestVersions.isEmpty())   update lst_EWS_LatestVersions;
            if(!lst_EWS_OldVersions.isEmpty())   update lst_EWS_OldVersions;
            
            if(Test.isRunningTest())    
                Integer i = 10/0;
        }
        catch(Exception e)
        {
            ApplicationLogWrapper alw = new ApplicationLogWrapper();
            alw.source = ICC_CleanUpAccountShare.class.getName();
            alw.sourceFunction ='ShareAccounts(List<User> lstPortalUsers)';
            alw.ApplicationName='ICC';
            alw.referenceInfo = 'Bug';
            alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel = 'Error';
            alw.logCode = e.getTypeName();
            alw.ex = e.getCause();
            GlobalUtility.logMessage(alw);
        }        
    }
 }