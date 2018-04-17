/*
    Author: Yash Kumar
    Description: Test class for UpdateRiskStartSystemData_Batch
    History:
        Yash 08022014    - Code Creation. This batch class create for update all update all risk start data according to manufacturing lot
                           sales number. This is new functionality( case# 1546  )
        
            
*/

global class UpdateRiskStartSystemDataBatch implements Schedulable , Database.Batchable<sObject>
{
   Map<id,List<Manufacturing_Lot__c>> mfLotMap = new Map<id,List<Manufacturing_Lot__c>>();
    global final String query;
    global UpdateRiskStartSystemDataBatch()
    {
       // query='select id,PIXWIP__c from Risk_Start_System__c';
       string strApproved='Approved & Pending Conversion';
       string strConversion='Conversion in Progress';
       query='select id,PIXWIP__c from Risk_Start_System__c where '+ 
       + 'status__c in (\''+ strApproved+'\',\'' + strConversion + '\')';
       system.debug('@@@@@@@@@@@query@@@@@@@@@@@@'+query);
            
        for(Manufacturing_Lot__c mf : [select id,Risk_Start__c,Current_Wafer_Quantity_In_Lot__c,LST_Wafer_Quantity__c,Sales_Order_Number__c,Active_Flag__c,Step_ID__c  from Manufacturing_Lot__c where Risk_Start__c!=null and Sales_Order_Number__c!=null 
and (Current_Wafer_Quantity_In_Lot__c !=null OR LST_Wafer_Quantity__c !=null) and (Active_Flag__c=true and Step_ID__c !=null)])
        {
            if(mfLotMap.containsKey(mf.Risk_Start__c))
            {
                List<Manufacturing_Lot__c> mfLst = mfLotMap.get(mf.Risk_Start__c);
                mfLst.add(mf);
                mfLotMap.put(mf.Risk_Start__c,mfLst);
            }
            else
            {
                List<Manufacturing_Lot__c> mfLst = new List<Manufacturing_Lot__c>();
                mfLst.add(mf);
                mfLotMap.put(mf.Risk_Start__c,mfLst);
            }
        } 
    }
    global void execute(SchedulableContext ctx) {}
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
         return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Risk_Start_System__c> scope)
    {
        try
        {
            List<Risk_Start_System__c> rssLst = new List<Risk_Start_System__c>();
            System.debug('%%%%%start%%%%%%%%%%%%:  '); 
            for(Risk_Start_System__c LR : scope)
            {
                if(mfLotMap.containsKey(LR.id))
                {
                    double count=0;
                    for(Manufacturing_Lot__c mfL: mfLotMap.get(LR.id))
                    {
                        if(mfL.Step_ID__c =='Chip')
                        {
                            if(mfL.LST_Wafer_Quantity__c !=null)
                            {
                                count = count + double.valueof(mfL.LST_Wafer_Quantity__c); 
                            }
                        }
                        else //if(mfL.Step_ID__c =='Wafer')
                        {
                            if(mfL.Current_Wafer_Quantity_In_Lot__c!=null)
                            {
                                count = count + mfL.Current_Wafer_Quantity_In_Lot__c; 
                            }
                        }
                    }
                    LR.PIXWIP__c = count;
                    rssLst.add(LR);
                }
            }
           System.debug('%%%%%rssLst%%%%%%%%%%%%:  '+rssLst.size());  
            //update rssLst;
            //database.update(rssLst,false);
            
            Database.SaveResult[] srList = Database.update(rssLst, false);

            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Risk Start fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
        catch(Exception e)
        {
            System.debug('%%%%%%%%%%%%%%%%%:  '+e.getMessage());
        } 
    }
    global void finish(Database.BatchableContext BC)
    {
            dateTime dt = dateTime.now();
            dt = dt.addHours(4);
            String s = String.valueOf(dt.second());
            String mi = String.valueOf(dt.minute());
            String h = String.valueOf(dt.hour());
            String d = String.valueOf(dt.day());
            String m = String.valueOf(dt.month());
            String y = String.valueOf(dt.year());
            String scedTime = s+' '+mi+' '+h+' '+d+' '+m+' ? '+y;            
            String scedStr = 'UpdateRiskStartSystemDataBatch'+scedTime;
            UpdateRiskStartSystemDataBatch scedBatch = new UpdateRiskStartSystemDataBatch();
            String schedulid = system.schedule(scedStr, scedTime, scedBatch); 
    } 
}