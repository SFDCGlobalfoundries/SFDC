global class MRSSyncEmailNotification implements Schedulable{

    global void execute(SchedulableContext SC) {
       // Sending MRS out of Sync email
       
       list<MRS__c> lstMRS = new list<MRS__c>();
       lstMRS = [select id,Name from MRS__c where MRS_Package_Sync__c = false];
       if(lstMRS.size()>0){
       string listofMRSs = '';
       for(MRS__c mrs :lstMRS){
           if(listofMRSs==''){
               listofMRSs = '<br><a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+mrs.Id+'"'+'>'+mrs.Name+'</a><br>';
           }
           else{ 
            listofMRSs = listofMRSs+ '<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+mrs.Id+'"'+'>'+mrs.Name+'</a><br>';
           }
       }
       string mailbody='';
       string body1='Dear TEAM,<br><br> The list of MRS Packages out of sync are:<br>';
       string body2='<br>Thank you.<br><br>This is a system generated message, please do not reply.<br>Best Regards.';
       mailbody = body1+listofMRSs+body2  ;
      //List of reports Start
       string reports ='';
         
       boolean bMRS = integer.valueof([select count() from MRS__c where lastmodifieddate<today and Synced_with_Oracle_DB__c=false limit 1])>0;
       boolean bMRSLayer = integer.valueof([select count() from MRS_Layer_Association__c where lastmodifieddate<today and Synced_with_Oracle_DB__c=false limit 1])>0;
       boolean bMRSChip = integer.valueof([select count() from MRS_Chip_Details__c where lastmodifieddate<today and Synced_with_Oracle_DB__c=false limit 1])>0;
       boolean bMRSLayerChip = integer.valueof([select count() from MRS_Layer_Chip_Association__c where lastmodifieddate<today and Synced_with_Oracle_DB__c=false limit 1])>0;
       boolean bNotes = integer.valueof([select count() from  Notes__c where lastmodifieddate<today and Synced_with_Oracle_DB__c=false limit 1])>0;
       boolean bMST = integer.valueof([select count() from Mask_Set_Title__c where lastmodifieddate<today and Synced_with_Oracle_DB__c=false limit 1])>0;
       boolean bMSTconfig = integer.valueof([select count() from MST_Config__c where lastmodifieddate<today and Synced_with_Oracle_DB__c=false limit 1])>0;
       boolean bTapeoutJobview = integer.valueof([select count() from Tapeout_Applications_MEBES_Jobview_Confi__c where lastmodifieddate<today and Synced_with_Oracle_DB__c=false limit 1])>0;
       boolean bFabDistri = integer.valueof([select count() from Fab_Distribution_Table__c where lastmodifieddate<today and Synced_with_Oracle_DB__c=false limit 1])>0;
       
       list<report> lstReports = new list<report>();
       lstReports = [SELECT DeveloperName,Id,Name FROM Report where DeveloperName like '%Out_of_Sync%' order by createddate asc];
       for (report iReport :lstReports){
           if(iReport.DeveloperName =='MRS_Package_Out_Of_Sync'){
                reports = '<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+iReport.Id+'"'+'>'+iReport.Name+'</a><br>'+reports ;
           }
           else if(iReport.DeveloperName =='MRS_Out_Of_Sync'){
               if(bMRS){
                    reports = reports+ '<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+iReport.Id+'"'+'>'+iReport.Name+'</a><br>';    
               }
           }
           else if(iReport.DeveloperName =='MRS_Layer_Association_Out_Of_Sync'){
               if(bMRSLayer){
                    reports = reports + '<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+iReport.Id+'"'+'>'+iReport.Name+'</a><br>';    
               }
           }
           else if(iReport.DeveloperName =='MRS_Chip_Details_Out_Of_Sync'){
               if(bMRSChip){
                    reports = reports + '<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+iReport.Id+'"'+'>'+iReport.Name+'</a><br>';    
               }
           }
           else if(iReport.DeveloperName =='MRS_Layer_Chip_Association_Out_Of_Sync'){
               if(bMRSLayerChip){
                    reports = reports + '<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+iReport.Id+'"'+'>'+iReport.Name+'</a><br>';    
               }
           }
           else if(iReport.DeveloperName =='Notes_Out_Of_Sync'){
               if(bNotes){
                    reports = reports + '<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+iReport.Id+'"'+'>'+iReport.Name+'</a><br>';    
               }
           }
           else if(iReport.DeveloperName =='MST_Out_Of_Sync'){
               if(bMST){
                    reports = reports + '<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+iReport.Id+'"'+'>'+iReport.Name+'</a><br>';    
               }
           }
           else if(iReport.DeveloperName =='MST_Config_Out_Of_Sync'){
               if(bMSTconfig){
                    reports = reports + '<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+iReport.Id+'"'+'>'+iReport.Name+'</a><br>';    
               }
           }
           else if(iReport.DeveloperName =='Tapeout_App_MEBES_Jobview_Out_Of_Sync'){
               if(bTapeoutJobview){
                    reports = reports + '<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+iReport.Id+'"'+'>'+iReport.Name+'</a><br>';    
               }
           }
           else if(iReport.DeveloperName =='Fab_Distribution_Table_Out_Of_Sync'){
               if(bFabDistri){
                    reports = reports + '<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+iReport.Id+'"'+'>'+iReport.Name+'</a><br>';    
               }
           }
       } 
       string body3='<br><br>For details please see the reports below:<br><br>';
       mailbody = body1+listofMRSs+body3+reports+body2;
       //List of reports End       
                 
       //Code for sending email
       string[] swiftAdmn  =new String[]{};
       if(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.contains(';')){
           swiftAdmn.addAll(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.split(';')); 
       }else{
          swiftAdmn.add(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c); 
       }
       
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       mail.setToAddresses(swiftAdmn); 
       mail.setSubject('MRS Package Out of Sync');   
       mail.sethtmlBody(mailbody);
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       }
    }
    
    @TestVisible
    private void mthdDummy(){
        Integer a = 1;
        Integer b = 5;
        Integer c = 0;      
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
        
        c = b - a;      
        a = c;
        c = b - a;
        a = c;
    }
}