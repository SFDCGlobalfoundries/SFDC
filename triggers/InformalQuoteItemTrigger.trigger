trigger InformalQuoteItemTrigger on Informal_Quote__c (before insert,before update,after insert,after update) {

    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
    
        for(Informal_Quote__c  obj : Trigger.new){
               
            if(obj.Process_Geometry__c != null && ConstantProcessGeometry__c.getInstance(obj.Process_Geometry__c).Value__c != null){
                
                obj.Process_Geometry_Range__c = ConstantProcessGeometry__c.getInstance(obj.Process_Geometry__c).Value__c;
            }
        }
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){
    
        for(Informal_Quote__c  obj : Trigger.new){

            if(Trigger.oldMap.get(obj.Id).Budgetary_Quote_Status__c == 'Hold'
              && obj.Budgetary_Quote_Status__c != 'Hold'
              && obj.Budgetary_Quote_Status__c != Trigger.oldMap.get(obj.Id).Hold_Stage__c){
                
                obj.addError(Label.Unhold_Error_Msg);
            }
        }
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){
    
        for(Informal_Quote__c  obj : Trigger.new){

            if(obj.Existing_Informal_Quote__c != null
              && obj.Product_Category__c != Trigger.oldMap.get(obj.Id).Product_Category__c){
                
                obj.Product_Category__c.addError(Label.IQ_Requote_Prod_Cat_Change_Val);
            }
            
            if(obj.Existing_Informal_Quote__c != null
              && obj.Account__c != Trigger.oldMap.get(obj.Id).Account__c){
                
                obj.Account__c.addError(Label.IQ_Requote_Account_Change_Val);
            }
            
            if(obj.Existing_Informal_Quote__c != null
              && obj.Opportunity__c != Trigger.oldMap.get(obj.Id).Opportunity__c){
                
                obj.Opportunity__c.addError(Label.IQ_Requote_Opp_Change_Val);
            }
        }
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){
        for(Informal_Quote__c  obj : Trigger.new){
            
            Informal_Quote__c oldInformalQuote = Trigger.oldMap.get(obj.Id);
            
            //Hold time calculation
            if(obj.Budgetary_Quote_Status__c != 'Hold' 
              && oldInformalQuote.Budgetary_Quote_Status__c  == 'Hold'
              && obj.Budgetary_Quote_Status__c == oldInformalQuote.Hold_Stage__c
              && obj.Hold_Time__c != null){
                
                if(obj.Budgetary_Quote_Status__c == 'Pending Approval Primary FAE'){
                    
                    obj.FAE_Hold_Time__c = getTimeDifference(obj.Hold_Time__c, System.now(), obj.FAE_Hold_Time__c);
                    obj.Hold_Time__c = null;
                }
                else if(obj.Budgetary_Quote_Status__c == 'Pending Approval TE'){
                    
                    obj.TE_Hold_Time__c = getTimeDifference(obj.Hold_Time__c, System.now(), obj.TE_Hold_Time__c);
                    obj.Hold_Time__c = null;
                }
                else if(obj.Budgetary_Quote_Status__c == 'Pending Approval Pricing'){
                    
                    obj.Pricing_Hold_Time__c = getTimeDifference(obj.Hold_Time__c, System.now(), obj.Pricing_Hold_Time__c);
                    obj.Hold_Time__c = null;
                }
                else if(obj.Budgetary_Quote_Status__c == 'Pending Approval Director'){
                    
                    obj.Director_Hold_TIme__c = getTimeDifference(obj.Hold_Time__c, System.now(), obj.Director_Hold_TIme__c);
                    obj.Hold_Time__c = null;
                }
                else if(obj.Budgetary_Quote_Status__c == 'Pending Approval Counselling'){
                    
                    obj.Council_Hold_Time__c = getTimeDifference(obj.Hold_Time__c, System.now(), obj.Council_Hold_Time__c);
                    obj.Hold_Time__c = null;
                }
            }
        }
    }
    
Boolean UpdateCond= false;  
list <Budgetary_Quote_Item__c> listInsertInformalQuoteItem = new list <Budgetary_Quote_Item__c> (); 
for(Informal_Quote__c  Info: trigger.new){
    
    //if (trigger.isafter){
    if (trigger.isafter && !(Trigger.isInsert && Info.Existing_Informal_Quote__c != null)){
         
            if(Trigger.IsUpdate){
                // Start CreateInformalQuoteItemRecords Trigger Code 
                if(Info.X1st_Product_Date__c != Trigger.OldMap.get(Info.id).X1st_Product_Date__c || Info.Years_of_Product__c !=Trigger.OldMap.get(Info.id).Years_of_Product__c){
                    List<Budgetary_Quote_Item__c> Old_QRR = new list<Budgetary_Quote_Item__c>();
                    for(Budgetary_Quote_Item__c oQuarterlyRev : [select Id from Budgetary_Quote_Item__c where Budgetary_Quote__c=:Info.Id]){
                         Old_QRR.add(oQuarterlyRev);
                        
                                                 
                    }
                    
                    delete Old_QRR;  
                    UpdateCond= true;
                }
                // End CreateInformalQuoteItemRecords Trigger Code
                
              
            }    
                    
            // Start CreateInformalQuoteItemRecords Trigger Code
            
            if(Info.X1st_Product_Date__c != null && Info.Years_of_Product__c !=null && Info.X1st_Product_Date__c < date.newInstance(2025,12,30)){
                if(Trigger.IsInsert || UpdateCond == true){
                    system.debug('X1st_Product_Date__c: ' + Info.X1st_Product_Date__c);
                    //Find out how many records are to be created based on Years of Production
                    decimal RecordsCreatedCount= Info.Years_of_Product__c*4;
                        
                    //Initiate the Date
                    Date dateInserted;
                    string sFiscalQtr = FiscalYearHelper.getFiscalQuarter(Info.X1st_Product_Date__c);
                    integer intFQ_Year = integer.valueof(sFiscalQtr.mid(0,4));
                    integer intFQ_Quarter = integer.valueof(sFiscalQtr.mid(6,1)); 
                        
                    //loop through the number of Quarterly Informal Quote Item records to be created
                    for(integer i=0; i<RecordsCreatedCount; i++){
                        //setup the Date
                        if(i==0){
                            
                            if(intFQ_Quarter==1){
                               
                                dateInserted=date.newInstance(intFQ_Year, 1, 15);
                            }else if(intFQ_Quarter==2){
                                
                                dateInserted=date.newInstance(intFQ_Year, 4, 15);
                            }else if(intFQ_Quarter==3){
                               
                                dateInserted=date.newInstance(intFQ_Year, 7, 15);
                            }else{
                                
                                dateInserted=date.newInstance(intFQ_Year, 10, 15);
                            }
                            
                        }else{
                            date tempDate = dateInserted;
                            dateInserted=tempDate.addMonths(3);
                        }

                        //setup the Quarter
                        string strFiscal_Quarter = intFQ_Year + '-Q' + intFQ_Quarter;
                        
                        listInsertInformalQuoteItem.add(new Budgetary_Quote_Item__c(Budgetary_Quote__c=Info.id,Quarter__c = strFiscal_Quarter));
                            
                        //increment the Quarter
                        if (intFQ_Quarter == 4){
                            intFQ_Quarter = 1;
                            intFQ_Year = intFQ_Year + 1;
                        }else{
                            intFQ_Quarter = intFQ_Quarter + 1;
                        }
                    }
                        
                }
            }else if(Info.X1st_Product_Date__c != null && Info.Years_of_Product__c !=null && Info.X1st_Product_Date__c > date.newInstance(2025,12,30)){
              Info.addError('First Product Production Date should be between 2009-12-27 to 2025-12-30.');
            }
            
            // End CreateInformalQuoteItemRecords Trigger Code   
        }


}

insert listInsertInformalQuoteItem;

    private String getTimeDifference(DateTime startDate, DateTime endDate, String workAroundTime){
        
        Decimal days = 0;
        Decimal hours = 0;
        Decimal minutes = 0;

        if(!startDate.isSameDay(endDate)){
            
            if( !(startDate.format('EEEE').equalsIgnoreCase('Saturday') || startDate.format('EEEE').equalsIgnoreCase('Sunday')) ){
                hours += Math.mod(Integer.valueOf((DateTime.newInstance(startDate.year(), startDate.month(), startDate.day() + 1, 0, 0, 0).getTime() - startDate.getTime()) / (1000*60*60)), 24);
                minutes += Math.mod(Integer.valueOf((DateTime.newInstance(startDate.year(), startDate.month(), startDate.day() + 1, 0, 0, 0).getTime() - startDate.getTime()) / (1000*60)), 60);
            }
            
            if( !(endDate.format('EEEE').equalsIgnoreCase('Saturday') || endDate.format('EEEE').equalsIgnoreCase('Sunday')) ){
                hours += endDate.hour();
                minutes += endDate.minute();
            }
            
            DateTime tempStartDate = startDate;
            while(tempStartDate < endDate){
                if( !(tempStartDate.format('EEEE').equalsIgnoreCase('Saturday') || tempStartDate.format('EEEE').equalsIgnoreCase('Sunday')) ){
                    
                    if(! (tempStartDate.isSameDay(startDate) || tempStartDate.isSameDay(endDate))){
                        days++;
                    }
                }
                
                tempStartDate = tempStartDate.addDays(1);
            }
        }
        else if( !(startDate.format('EEEE').equalsIgnoreCase('Saturday') || startDate.format('EEEE').equalsIgnoreCase('Sunday')) ){
            hours += Math.mod(Integer.valueOf((endDate.getTime() - startDate.getTime()) / (1000*60*60)), 24);
            minutes += Math.mod(Integer.valueOf((endDate.getTime() - startDate.getTime()) / (1000*60)), 60);
        }
        /*
        if(minutes >= 60 ){
            hours += (minutes / 60);
            minutes = Math.mod(minutes, 60);
        }

        if(hours >= 24 ){
            days += (hours / 24);
            hours = Math.mod(hours, 24);
        }
        */
        
        days += ( (hours * 60) + minutes ) / (24 * 60);
        
        if(workAroundTime != null && workAroundTime.trim().length() > 0){
            /*
            List<String> tempList = workAroundTime.split('\\.');
            if(tempList[0].isNumeric()){
                days += Integer.valueOf(tempList[0]);
            }
            
            if(tempList.size() > 1 && tempList[1] != NULL && tempList[1].isNumeric()){
                hours += Integer.valueOf(tempList[1]);
            }
            
            if(hours >= 24){
                days += (hours / 24);
                hours = Math.mod(hours, 24);
            }
            */
            try{
                days += Decimal.valueOf(workAroundTime.trim());
            }
            catch(Exception e){
            
            }
        }
        
        days = days.setScale(2);
        
        return String.valueOf(days);
    }
}