global class MPWLotAssignmentNotificationBatch implements Database.Batchable<sObject>,Database.Stateful{
    
    global Map<String, Map<String, List<MPW_WIP_Lot__c>>> mapUserAssignments; //Email => Assignment Name => WIP
    
    global MPWLotAssignmentNotificationBatch() {
        mapUserAssignments = new Map<String, Map<String, List<MPW_WIP_Lot__c>>>();
    }
   
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Assignment_Group_Name__c, Saved_User__c, Saved_User__r.Name, Saved_User__r.Email, ' + 
                        'Manufacturing_Lot__c, Manufacturing_Lot_Id__c, MPW_Prime_Die__c, Prime_Die_Name__c, MPW_form__c, MPW_Prime_Die__r.MPW_Form__c, ' +
                        'MPW_Prime_Die__r.MPW_Form__r.Customer_Company_Name__c, MPW_Form_Customer_Account_Name__c, MPW_Train_Name__c, MPW_MES_Part_ID__c, Assignment_Type__c, ' +
                        'Notification_Interval_Days__c, Notification_Start_Date__c, Notification_End_Date__c, Notification_Active__c, ' +
                        'Bare_Die_Shipment_Forecast_Date_BL__c, Bare_Die_Shipment_Forecast_Date_OR__c ' +
                        'FROM MPW_WIP_Lot__c WHERE Notification_Active__c = true AND Notification_Start_Date__c != NULL ' + 
                        'AND Saved_User__c != null ORDER BY Assignment_Group_Name__c'; 
        return Database.getQueryLocator(query); 
    }
    
    global void execute(Database.BatchableContext BC, List<MPW_WIP_Lot__c> scope){
        Date dtToday = date.today();
        
        try {
            for(MPW_WIP_Lot__c oWIP : scope) {
                Integer intDaysDiff = oWIP.Notification_Start_Date__c.daysBetween(dtToday);
                if(math.mod(intDaysDiff, Integer.valueOf(oWIP.Notification_Interval_Days__c)) == 0 && (oWIP.Notification_End_Date__c == null || dtToday <= oWIP.Notification_End_Date__c)) {
                    if(!mapUserAssignments.containsKey(oWIP.Saved_User__r.Email)) {
                        Map<String, List<MPW_WIP_Lot__c>> mapAssignments = new Map<String, List<MPW_WIP_Lot__c>>();
                        mapAssignments.put(oWIP.Assignment_Group_Name__c, new List<MPW_WIP_Lot__c>{oWIP});
                        mapUserAssignments.put(oWIP.Saved_User__r.Email, mapAssignments);
                    }
                    else {
                        Map<String, List<MPW_WIP_Lot__c>> mapAssignments = new Map<String, List<MPW_WIP_Lot__c>>();
                        mapAssignments = mapUserAssignments.get(oWIP.Saved_User__r.Email);
                        
                        if(!mapAssignments.containsKey(oWIP.Assignment_Group_Name__c)) {
                            mapAssignments.put(oWIP.Assignment_Group_Name__c, new List<MPW_WIP_Lot__c>{oWIP});
                            mapUserAssignments.put(oWIP.Saved_User__r.Email, mapAssignments);
                        }
                        else {
                            mapUserAssignments.get(oWIP.Saved_User__r.Email).get(oWIP.Assignment_Group_Name__c).add(oWIP);
                        }
                    }
                }
            }
        }
        catch(Exception ex) {
            MPWExceptionHandler.exceptionHandler(ex, 'MPWLotAssignmentNotificationBatch', 'execute()', '', 'MPW Assignment Notification Batch');
        }
    }
   
    global void finish(Database.BatchableContext BC){
        List<Messaging.SingleEmailMessage> email = new List<Messaging.SingleEmailMessage>();
        try {
            String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
            Map<Integer, String> mapMonth = new Map<Integer, String>{
                1 => 'Jan', 2 => 'Feb', 3 => 'Mar', 4 => 'Apr', 5 => 'May', 6 => 'Jun', 7 => 'Jul', 8 => 'Aug', 9 => 'Sep', 10 => 'Oct', 11 => 'Nov', 12 => 'Dec'
            };
            OrgWideEmailAddress[] owdEmail = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'noreply-salesforce@globalfoundries.com'];
            
            Map<String, User> mapUser = new Map<String, User>();
            for(User u : [SELECT Id, Name, Email FROM User WHERE Email IN: mapUserAssignments.keySet()]) {
                mapUser.put(u.Email, u);
            }
                        
            for(String strKey1 : mapUserAssignments.keySet()) {
                String strBody = 'Hi ' + mapUser.get(strKey1).Name + ',<br/><br/>Please review your MPW Manufacturing Lot Assignments as mentioned below.<br/><br/>';
                
                for(String strKey2 : mapUserAssignments.get(strKey1).keySet()) {
                    String strURL = baseUrl + '/apex/MPWLotAssignmentSummary?name=' + strKey2;
                    strBody +=  '<table border="1" style="border-collapse: collapse;border-color: #d8d8d8;width: 100%;" >' +
                                '<tr style="background-color: #dedede;border-bottom-color: #848484;" >' +
                                '<th colspan="9" style="padding:5px;background-color: rgb(183, 198, 47);" >Assignment Group Name: <a href="' + strURL + '" target="_blank" >' + strKey2 + '</a></th>' +
                                '</tr>';
                    
                    strBody +=  '<tr style="border-bottom-color: #848484;background-color: #e6e6e6;" >' +
                                '<th style="padding:3px;" >Manufacturing Lot</th>' +
                                '<th style="padding:3px;" >MPW Prime Die</th>' +
                                '<th style="padding:3px;" >MPW Form#</th>' +
                                '<th style="padding:3px;" >Company</th>' +
                                '<th style="padding:3px;" >MPW Train</th>' +
                                '<th style="padding:3px;" >MPW MES Part ID</th>' +
                                '<th style="padding:3px;" >Bare Die Shipment <br/>Forecast Date (Baseline)</th>' +
                                '<th style="padding:3px;" >Bare Die Shipment <br/>Forecast Date (Override)</th>' +
                                '<th style="padding:3px;" >Assignment Type</th>' +
                                '</tr>';
                                
                    for(MPW_WIP_Lot__c oWIP : mapUserAssignments.get(strKey1).get(strKey2)) {
                        strBody += '<tr ><td style="padding:3px;" >';
                        if(oWIP.Manufacturing_Lot_Id__c != null){
                            strBody += '<a href="' + baseUrl + '/' + oWIP.Manufacturing_Lot__c + '" target="_blank" >' + oWIP.Manufacturing_Lot_Id__c + '</a>';
                        }
                        strBody += '</td><td style="padding:3px;" >';
                        if(oWIP.Prime_Die_Name__c != null){
                            strBody += '<a href="' + baseUrl + '/' + oWIP.MPW_Prime_Die__c + '" target="_blank" >' + oWIP.Prime_Die_Name__c + '</a>';
                        }
                        strBody += '</td><td style="padding:3px;" >';
                        if(oWIP.MPW_form__c != null){
                            strBody += '<a href="' + baseUrl + '/' + oWIP.MPW_Prime_Die__r.MPW_Form__c + '" target="_blank" >' + oWIP.MPW_form__c + '</a>';
                        }
                        strBody += '</td><td style="padding:3px;" >';
                        if(oWIP.MPW_Form_Customer_Account_Name__c != null){
                            strBody += '<a href="' + baseUrl + '/' + oWIP.MPW_Prime_Die__r.MPW_Form__r.Customer_Company_Name__c + '" target="_blank" >' + oWIP.MPW_Form_Customer_Account_Name__c + '</a>';
                        }
                        strBody += '</td><td style="padding:3px;" >';
                        if(oWIP.MPW_Train_Name__c != null){
                            strBody += oWIP.MPW_Train_Name__c;
                        }
                        strBody += '</td><td style="padding:3px;" >';
                        if(oWIP.MPW_MES_Part_ID__c != null){
                            strBody += oWIP.MPW_MES_Part_ID__c;
                        }
                        strBody += '</td><td style="padding:3px;" >';
                        if(oWIP.Bare_Die_Shipment_Forecast_Date_BL__c != null){
                            Date dtForecastDateBL = oWIP.Bare_Die_Shipment_Forecast_Date_BL__c;
                            strBody += String.valueOf(dtForecastDateBL.day()) + ' ' + mapMonth.get(dtForecastDateBL.month()) + ', ' + String.valueOf(dtForecastDateBL.year());
                        }
                        strBody += '</td><td style="padding:3px;" >';
                        if(oWIP.Bare_Die_Shipment_Forecast_Date_OR__c != null){
                            Date dtForecastDateOR = oWIP.Bare_Die_Shipment_Forecast_Date_OR__c;
                            strBody += String.valueOf(dtForecastDateOR.day()) + ' ' + mapMonth.get(dtForecastDateOR.month()) + ', ' + String.valueOf(dtForecastDateOR.year());
                        }
                        strBody += '</td><td style="padding:3px;" >';
                        if(oWIP.Assignment_Type__c != null){
                            strBody += oWIP.Assignment_Type__c;
                        } 
                        strBody += '</td></tr>';
                    }
                    
                    strBody += '</table><br/>'; 
                }
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddress = new String[]{strKey1};
                mail.setSubject('Reminder : MPW Manufacturing Lot Assignment');
                mail.setSaveAsActivity(false);
                mail.setHtmlBody(strBody); 
                mail.setToAddresses(toAddress);
                if(owdEmail.size() > 0) {
                    mail.setOrgWideEmailAddressId(owdEmail.get(0).Id);
                }
                email.add(mail);
            }
            
            Messaging.sendEmail(email);
        }
        catch(Exception ex) {
            MPWExceptionHandler.exceptionHandler(ex, 'MPWLotAssignmentNotificationBatch', 'finish()', '', 'MPW Assignment Notification Batch');
        }
        
    }
}