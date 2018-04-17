/**
* Author: Yathish NS 
* Project: NPI Report  
* Description: This batch class aggregates device shipping quantity and wafer value and generate NPI Report record based on some condition
**/

global class NPIGenerateReports implements Database.Batchable<Sobject>,Database.Stateful
{
    Set<Integer> Q1 = new Set<Integer>{1,2,3};
    Set<Integer> Q2 = new Set<Integer>{4,5,6};
    Set<Integer> Q3 = new Set<Integer>{7,8,9};
    Set<Integer> Q4 = new Set<Integer>{10,11,12};
    List<Wafer_Value__c> currentWaferValue = Wafer_Value__c.getall().values();
    List<NPINextSHIPFetchTime__c> nextShipFetchTime =  NPINextSHIPFetchTime__c.getall().values();
    List<ShippingReport__c> failedShipRecList = new List<ShippingReport__c>();
    List<NPIReportBatchToEmails__c> toEmailList = NPIReportBatchToEmails__c.getall().values();
    Boolean isCatched = false;
    DateTime LastRunTime;
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query;
        if(!nextShipFetchTime.isempty() && nextShipFetchTime[0].LastShipProcessTime__c != null && nextShipFetchTime[0].LastSuccessfulShipProcessTime__c != null)
        {
            Datetime LastShipProcessTime = nextShipFetchTime[0].LastShipProcessTime__c;
            Datetime LastSuccessfulShipProcessTime = nextShipFetchTime[0].LastSuccessfulShipProcessTime__c;
            query = 'select Id,CHARTERED_PART_NAME__c,Name,IS_ELIGIBLE_TO_NPI__c,ACTUAL_FAB_GROUP__c,SHIP_DATE__c,SHIP_QTY__c from ShippingReport__c where SHIP_DATE__c!=null and ((CreatedDate > :LastShipProcessTime) or (CreatedDate > :LastSuccessfulShipProcessTime and IS_ELIGIBLE_TO_NPI__c = false)) order by SHIP_DATE__c ASC';
        }
        else
        {
            query = 'select Id,CHARTERED_PART_NAME__c,Name,IS_ELIGIBLE_TO_NPI__c,ACTUAL_FAB_GROUP__c,SHIP_DATE__c,SHIP_QTY__c from ShippingReport__c where SHIP_DATE__c!=null order by SHIP_DATE__c ASC';
        }
        Timezone tz = Timezone.getTimeZone('America/Los_Angeles');
        LastRunTime = DateTime.newInstance(System.Now().getTime() + tz.getOffset(System.Now()));
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<ShippingReport__c> Scope)
    {
        if(currentWaferValue.size()==0)
        {
            Wafer_Value__c wafVal = new Wafer_Value__c();
            wafVal.Name = 'Temporary WafVal';
            wafval.Wafer_Quantity__c = 300;
            insert wafVal;
            currentWaferValue.add(wafVal);
        }
        Set<String> partName = new Set<String>();
        for(ShippingReport__c sr :Scope)
        {
            partName.add(sr.CHARTERED_PART_NAME__c);
        }
        List<NPI_Report__c> npiList = [select Id,Device__c,Actual_Fab_Group__c,Device__r.Name,Shipment_Date__c,Shipment_Quantity__c,DaysElapsed__c,Days_to_Hit_300_Wafer__c,Success_Quat_Year__c,Hit_300_Wafer__c,Device__r.PLM_Device_ID__c,Device__r.MES_Device_Id__c from NPI_Report__c  where Device__r.Name In :partName OR Device__r.PLM_Device_ID__c In :partName or Device__r.MES_Device_Id__c In :partName];
        Map<String,NPI_Report__c> npiMap = new Map<String,NPI_Report__c>();
        if(npiList.size()>0)
        {
            for(NPI_Report__c npi:npiList)
            {
                if(partName.contains(npi.Device__r.Name))
                {
                    npiMap.put(npi.Device__r.Name,npi);
                }
                else if(partName.contains(npi.Device__r.PLM_Device_ID__c))
                {
                    npiMap.put(npi.Device__r.PLM_Device_ID__c,npi);
                }
                else if(partName.contains(npi.Device__r.MES_Device_Id__c))
                {
                    npiMap.put(npi.Device__r.MES_Device_Id__c,npi);
                }
            }
        }
        
        List<Device__c> devList= [select Id,Name,Actual_Tapeout_Date_GMT__c,Account__c,PLM_Device_ID__c,MES_Device_Id__c from Device__c where Name In :partName];
        Map<String,Device__c> tdateMap = new Map<String,Device__c>();
        if(devList.size()>0)
        {
        for(Device__c dev : devList)
            {
                tdateMap.put(dev.Name,dev);
            }
        }
        devList.clear();
        devList = [select Id,Name,Actual_Tapeout_Date_GMT__c,Account__c,PLM_Device_ID__c,MES_Device_Id__c from Device__c where PLM_Device_ID__c In :partName Or MES_Device_Id__c In :partName];
        if(devList.size()>0)
        {
        for(Device__c dev : devList)
            {
                If(dev.PLM_Device_ID__c == null)
                {
                    tdateMap.put(dev.MES_Device_Id__c,dev);
                }
                else
                {
                    tdateMap.put(dev.PLM_Device_ID__c,dev);
                }
            }
        }
        Savepoint sp = Database.setSavepoint();
        for(ShippingReport__c sr :Scope)
        {
            if(npiMap.containsKey(sr.CHARTERED_PART_NAME__c))
            {
                if(tdatemap.containsKey(sr.CHARTERED_PART_NAME__c))
                {
                    if(tdatemap.get(sr.CHARTERED_PART_NAME__c).Actual_Tapeout_Date_GMT__c!=null)
                    {    
                        NPI_Report__c nr = npiMap.get(sr.CHARTERED_PART_NAME__c);
                        nr.Shipment_Quantity__c = nr.Shipment_Quantity__c+decimal.valueof(sr.SHIP_QTY__c);
                        if(sr.SHIP_DATE__c > nr.Shipment_Date__c)
                        {    
                            nr.Shipment_Date__c = sr.SHIP_DATE__c;
                        }
                        nr.DaysElapsed__c = tdatemap.get(sr.CHARTERED_PART_NAME__c).Actual_Tapeout_Date_GMT__c.daysBetween(System.today());
                        nr.Tapeout_Date__c = tdatemap.get(sr.CHARTERED_PART_NAME__c).Actual_Tapeout_Date_GMT__c;
                        nr.Account__c = tdatemap.get(sr.CHARTERED_PART_NAME__c).Account__c;
                        nr.Actual_Fab_Group__c = sr.ACTUAL_FAB_GROUP__c;
                        if(nr.Hit_300_Wafer__c !='yes')
                        {
                            if(nr.Shipment_Quantity__c >= currentWaferValue[0].Wafer_Quantity__c)
                            {
                                nr.Days_to_Hit_300_Wafer__c = -(sr.SHIP_DATE__c.daysBetween(tdatemap.get(sr.CHARTERED_PART_NAME__c).Actual_Tapeout_Date_GMT__c));
                                nr.Hit_300_Wafer__c ='yes';
                                Integer cMonth = sr.SHIP_DATE__c.month();
                                Integer cYear = sr.SHIP_DATE__c.year();
                                if(Q1.contains(cMonth)){
                                nr.Success_Quat_Year__c= 'Q1'+''+cYear;}
                                if(Q2.contains(cMonth)){
                                nr.Success_Quat_Year__c= 'Q2'+''+cYear;}
                                if(Q3.contains(cMonth)){
                                nr.Success_Quat_Year__c= 'Q3'+''+cYear;}
                                if(Q4.contains(cMonth)){
                                nr.Success_Quat_Year__c= 'Q4'+''+cYear;}
                            } 
                        }
                    npiMap.put(sr.CHARTERED_PART_NAME__c,nr);
                }
            }
            }
            else
            {
                if(tdatemap.containsKey(sr.CHARTERED_PART_NAME__c))
                {
                    if(tdatemap.get(sr.CHARTERED_PART_NAME__c).Actual_Tapeout_Date_GMT__c!=null)
                    { 
                        NPI_Report__c newNPI = new NPI_Report__c();
                        newNPI.Device__c= tdatemap.get(sr.CHARTERED_PART_NAME__c).Id;
                        newNPI.Shipment_Date__c = sr.SHIP_DATE__c;
                        newNPI.Shipment_Quantity__c = decimal.valueof(sr.SHIP_QTY__c);
                        newNPI.DaysElapsed__c = tdatemap.get(sr.CHARTERED_PART_NAME__c).Actual_Tapeout_Date_GMT__c.daysBetween(System.today());
                        newNPI.Tapeout_Date__c = tdatemap.get(sr.CHARTERED_PART_NAME__c).Actual_Tapeout_Date_GMT__c; 
                        newNPI.Account__c = tdatemap.get(sr.CHARTERED_PART_NAME__c).Account__c;
                        newNPI.Actual_Fab_Group__c = sr.ACTUAL_FAB_GROUP__c;
                        if(decimal.valueof(sr.SHIP_QTY__c) >= currentWaferValue[0].Wafer_Quantity__c)
                        {
                            newNPI.Days_to_Hit_300_Wafer__c = -(sr.SHIP_DATE__c.daysBetween(tdatemap.get(sr.CHARTERED_PART_NAME__c).Actual_Tapeout_Date_GMT__c));
                            newNPI.Hit_300_Wafer__c ='yes';
                            Integer cMonth = sr.SHIP_DATE__c.month();
                            Integer cYear = sr.SHIP_DATE__c.year();
                            if(Q1.contains(cMonth)){
                            newNPI.Success_Quat_Year__c= 'Q1'+''+cYear;}
                            if(Q2.contains(cMonth)){
                            newNPI.Success_Quat_Year__c= 'Q2'+''+cYear;}
                            if(Q3.contains(cMonth)){
                            newNPI.Success_Quat_Year__c= 'Q3'+''+cYear;}
                            if(Q4.contains(cMonth)){
                            newNPI.Success_Quat_Year__c= 'Q4'+''+cYear;}
                        }
                   try{
                           insert newNPI;
                           npiMap.put(sr.CHARTERED_PART_NAME__c,newNPI);
                   }
                   catch(Exception e) {
                       GlobalUtility.logMessage('Error', 'NPIGenerateReports', 'NPIGenerateReports Error','','NPIReport','Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),'','NPI Report',e,2300);
                       isCatched = True;
                   }
             }}
         }
     }
     try{
     update(npiMap.values());
     }
     catch(Exception e){
         GlobalUtility.logMessage('Error', 'NPIGenerateReports', 'NPIGenerateReports Error','','NPIReport','Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),'','NPI Report',e,2300);
         isCatched = true;
     }
     if(isCatched == true)
     {
         Database.RollBack(sp);
         failedShipRecList = new List<ShippingReport__c>();
         for(ShippingReport__c sr :Scope)
         {
             sr.IS_ELIGIBLE_TO_NPI__c = false;
             failedShipRecList.add(sr);
         }
         try
         {
         update failedShipRecList;
         }
         catch(DmlException e){
             GlobalUtility.logMessage('Error', 'NPIGenerateReports', 'ShippingReport update Error','','NPIReport','Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),'','NPI Report',e,2300);
         }
     } 
  }
 
  global void finish(Database.BatchableContext BC)
  {
      AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,  
      TotalJobItems, CreatedBy.Email, ExtendedStatus  
      from AsyncApexJob where Id = :BC.getJobId()];  
      if(nextShipFetchTime.isEmpty())
      {
          NPINextSHIPFetchTime__c nst = new NPINextSHIPFetchTime__c();
          nst.Name = 'NPIBatchProcessInfo';
          insert nst;
          nextShipFetchTime = NPINextSHIPFetchTime__c.getall().values();
      }
      if(a.Status == 'Completed' && a.NumberOfErrors == 0)
      {
          DateTime lastSuccessfullRunTime;
          nextShipFetchTime[0].LastShipProcessTime__c = LastRunTime;
          Timezone tz = Timezone.getTimeZone('America/Los_Angeles');
          lastSuccessfullRunTime= DateTime.newInstance(System.Now().getTime() + tz.getOffset(System.Now()));
          nextShipFetchTime[0].LastSuccessfulShipProcessTime__c = lastSuccessfullRunTime;
      }
      else
      {
          nextShipFetchTime[0].LastShipProcessTime__c = LastRunTime;
      }
      update nextShipFetchTime[0];  
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
      String owdId = [select id, Address, DisplayName from OrgWideEmailAddress where Address='noreply-salesforce@globalfoundries.com' limit 1].Id;
      mail.setOrgWideEmailAddressId(owdId);
      String[] toAddresses = new String[]{};
      if(toEmailList.size() >0)
      {    
          toAddresses =toEmailList[0].ToAddresses__c.split(';'); 
      } 
      mail.setToAddresses(toAddresses);  
      mail.setSubject('NPIGenerateNPIReports Status: ' + a.Status);  
      mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +  
      ' batches with '+ a.NumberOfErrors + ' failures. ');
      try{  
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });       
      } 
      catch(Exception e){
          GlobalUtility.logMessage('Error', 'NPIGenerateReports', 'ShippingReport MailSending Error','','NPIReport','Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(),'','NPI Report',e,2300);
      }          
      }
}