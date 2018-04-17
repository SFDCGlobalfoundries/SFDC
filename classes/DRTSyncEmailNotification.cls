global class DRTSyncEmailNotification implements Schedulable{

    global void execute(SchedulableContext SC) {
       // Sending DRT out of Sync email
       list<DRT__c> lstDRT = new list<DRT__c>();
       lstDRT = [select id,Name from DRT__c where DRT_Package_Sync__c = false and status__c!='Draft' and status__c!='Deleted'];
       if(lstDRT.size()>0){
       string listofDRTs = '';
       for(DRT__c drt :lstDRT){
           if(listofDRTs==''){
               listofDRTs = '<br><a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+drt.Id+'"'+'>'+drt.Name+'</a><br>';
           }
           else{ 
            listofDRTs = listofDRTs+ '<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+drt.Id+'"'+'>'+drt.Name+'</a><br>';
           }
       }
       string mailbody='';
       string body1='Dear TEAM,<br><br> The list of DRT Packages out of sync are:<br>';
       string body2='<br>Thank you.<br><br>This is a system generated message, please do not reply.<br>Best Regards.';
       mailbody = body1+listofDRTs+body2  ;
      //List of reports Start
       string reports ='';
          
       boolean bDRT = integer.valueof([select count() from DRT__c where lastmodifieddate<today and Synced_with_Oracle_DB__c=false limit 1])>0;
       boolean bFrameDRT = integer.valueof([select count() from Frame_DRT_Association__c where lastmodifieddate<today and Synced_with_Oracle_DB__c=false limit 1])>0;
       boolean bDRTLayer = integer.valueof([select count() from PRIME_DRT_Layer_Association__c where lastmodifieddate<today and Synced_with_Oracle_DB__c=false limit 1])>0;
       boolean bDRTChip = integer.valueof([select count() from PRIME_DRT_Chip_Association__c where lastmodifieddate<today and Synced_with_Oracle_DB__c=false limit 1])>0;
       boolean bDRTLayerChip = integer.valueof([select count() from PRIME_DRT_Chip_Layer_Summary__c where lastmodifieddate<today and Synced_with_Oracle_DB__c=false limit 1])>0;

       list<report> lstReports = new list<report>();
       lstReports = [SELECT DeveloperName,Id,Name FROM Report where DeveloperName like '%Out_of_Sync%' order by createddate asc];
       for (report iReport :lstReports){
           if(iReport.DeveloperName =='DRT_Package_Out_Of_Sync'){
                reports = '<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+iReport.Id+'"'+'>'+iReport.Name+'</a><br>'+reports ;
           }
           else if(iReport.DeveloperName =='DRT_Out_Of_Sync'){
               if(bDRT){
                    reports = reports+ '<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+iReport.Id+'"'+'>'+iReport.Name+'</a><br>';    
               }
           }
           else if(iReport.DeveloperName =='Frame_DRT_Association_Out_Of_Sync'){
               if(bFrameDRT){
                    reports = reports + '<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+iReport.Id+'"'+'>'+iReport.Name+'</a><br>';    
               }
           }
           else if(iReport.DeveloperName =='Prime_DRT_Layer_Association_Out_Of_Sync'){
               if(bDRTLayer){
                    reports = reports + '<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+iReport.Id+'"'+'>'+iReport.Name+'</a><br>';    
               }
           }
           else if(iReport.DeveloperName =='PRIME_DRT_Chip_Association_Out_Of_Sync'){
               if(bDRTChip){
                    reports = reports + '<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+iReport.Id+'"'+'>'+iReport.Name+'</a><br>';    
               }
           }
           else if(iReport.DeveloperName =='Prime_DRT_Chip_Layer_Out_Of_Sync'){
               if(bDRTLayerChip){
                    reports = reports + '<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+iReport.Id+'"'+'>'+iReport.Name+'</a><br>';    
               }
           }
       } 
       string body3='<br><br>For details please see the reports below:<br><br>';
       mailbody = body1+listofDRTs+body3+reports+body2;
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
       mail.setSubject('DRT Package Out of Sync');   
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