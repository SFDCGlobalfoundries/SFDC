global class MPWPrimeDieBatchScheduler implements schedulable {
    public static String strCronExp = '0 00 01 * * ?';  //Every Day at 1 AM 
    public static Integer intSize = 200;
    public static String strStartDate = 'LAST_N_DAYS:30';
    public static String strEndDate = 'NEXT_N_DAYS:30';

    global static String startSchedule(String strCronExpTemp, Integer intSizeTemp, String strStartDateTemp, String strEndDateTemp) {
        if(strCronExpTemp != null && strCronExpTemp.trim() != '') {
            strCronExp = strCronExpTemp;
        }
        
        if(intSizeTemp != null) {
            intSize = intSizeTemp;
        }
        
        if(strStartDateTemp != null && strStartDateTemp.trim() != '') {
            strStartDate = strStartDateTemp;
        }
        
        if(strEndDateTemp != null && strEndDateTemp.trim() != '') {
            strEndDate = strEndDateTemp;
        }
        
        MPWPrimeDieBatchScheduler oClass = new MPWPrimeDieBatchScheduler(); 
        if(!Test.isRunningTest()) {
            return System.schedule('MPW Prime Die Batch', strCronExp, oClass);
        }
        else {
            return null;
        }
    }

    global void execute(SchedulableContext sc) {
        String strQueryDefault = 'SELECT Id, Name, Prime_Die_Name__c, MPW_Train__c, Design_Package_Accepted_Date__c, ';
        strQueryDefault += ' Final_GDS_PTRF_Submitted_Date__c, Final_PTSR_Submitted_Date__c, MPW_Form_Status__c, Customer_Tapeout_Date__c, ';
        strQueryDefault += ' Initial_Design_Package_Accepted_Date__c, Initial_GDS_PTRF_Submitted_Date__c, ';
        strQueryDefault += ' MPW_Form__r.Customer_Company_Name__c, LastModifiedDate FROM MPW_Prime_Die__c ';
        strQueryDefault += ' WHERE Prime_Die_Name__c != NULL AND MPW_Form__r.Customer_Company_Name__c != NULL AND ';
        strQueryDefault += ' MPW_Form_Status__c LIKE \'%Accepted%\' AND MPW_Train__c LIKE \'MPW%\' '; 
        strQueryDefault += ' AND Customer_Tapeout_Date__c >= ' + strStartDate + ' AND Customer_Tapeout_Date__c <= ' + strEndDate;
        strQueryDefault += ' ORDER BY CreatedDate DESC';
        
        MPWPrimeDieBatch b = new MPWPrimeDieBatch(strQueryDefault); 
        database.executebatch(b, intSize);
    }
}