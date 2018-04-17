/**
* Author        :   Ravikiran Nadella
* Description   :  this class has Logic to exceute from Void button and also Submit for Approaval button
                   related to Lot Service request object .
* History       :
        Initials        Date                Description
-----------------------------------------------------------------------------------------
             
        RNadella        31/08/2015          Created the class     
        Rnadella        30/05/2016          Added CSD at submission  		
**/

global class LotApprovalProcessUtil {
   
    
    /* This method has a logic to show a message  
      when lot instructions are assocaited to inActive ML 
       */
    webService static String activeMLonLotinstr(Id lsrId) { 
        string message='';
        string rMessage='';
        List<Lot_Instruction__c>ltList = new List<Lot_Instruction__c>();
        for(Lot_Request__c lsrList  :[select Id,(select id,name, Manufacturing_Lot__r.Active_Flag__c,Manufacturing_Lot__r.name,Manufacturing_Lot__r.Current_Scheduled_Date_CSD__c from Request_to_Lot_Tags__r) from Lot_Request__c 
                                      WHERE id =: lsrId]){
                                          if(!lsrList.Request_to_Lot_Tags__r.isEmpty()){
                                              for(Lot_Instruction__c ltinst : lsrList.Request_to_Lot_Tags__r ){
                                                  ltinst.Current_CSD_ML_at_time_of_Submission__c=ltinst.Manufacturing_Lot__r.Current_Scheduled_Date_CSD__c;
                                                  ltList.add(ltinst);
                                                  if(ltinst.Manufacturing_Lot__r.Active_Flag__c!=true){
                                                      message +=ltinst.name + '-->'+ ltinst.Manufacturing_Lot__r.name +'\r\n';
                                                      
                                                  }
                                              }
                                          }  
                                      }
        update ltList;
        if(message.contains('Lot')){
            rMessage=system.label.LotActiveML +'\r\n'+ message;
            
        }
        
        return rMessage;
    }
    
       /* This method has a logic to send an Emails to the   
        approvers upon recall or closed void.
       */
    Public Static Void sendEmailtoApprovers(list<Lot_Request__c >lrrList){
        set<string> actorIdSet = new set<string>();
        set<id>userIdSet = new set<id>();
        set<id>nonUserIdSet = new set<id>();
        set<id>nonUserIdSet1 = new set<id>();
        set<id>lrSet= (new Map<Id,SObject>(lrrList)).keySet();
        list<Lot_Request__c>lrList =[Select id,Account__r.name,name,Fab__c,Lot_Request_Type__c,New_Customer_Requested_Date_CRD_CSR__c,Assigned_Backup_CSR_CSR__c,Assigned_CSR_CSR__c,
                                      Customer_Requested_Lot_Qty__c,Customer_Requested_Wafer_Qty__c,Customer_Instructions__c,Does_Customer_Accept_Standard_Pricing__c,CSR_Comments__c,
                                      Stage__c,lastModifiedBy.name from Lot_Request__c where id in :lrSet];
      
      for(ProcessInstance pins :[Select Id,(Select originalactorid,actorid,StepStatus  from StepsAndWorkitems) 
                                   from ProcessInstance where targetobjectid in :lrSet]){
                                       //system.debug('ProcessInstance'+pins.StepsAndWorkitems);
                                       if(!pins.StepsAndWorkitems.isEmpty()){
                                           for(ProcessInstanceHistory stwi : pins.StepsAndWorkitems){
                                               actorIdSet.add(stwi.originalactorid);                                               
                                           }                                           
                                       }                                       
                                   }

        
        if(!actorIdSet.isEmpty()){
            for(string userId :actorIdSet){
              
                if(userId.startsWith('005')){
                   
                    userIdSet.add(userId);                    
                }else{
                    nonUserIdSet.add(userId);                  
                }
            } 
          
        }else {
            for(Lot_Request__c lrst : lrList){
                
                userIdSet.add(lrst.Assigned_Backup_CSR_CSR__c);
                userIdSet.add(lrst.Assigned_CSR_CSR__c);
                
            }
            
        }
        
     
        if(!nonUserIdSet.isEmpty()){
            for(GroupMember gm:[select UserOrGroupId From GroupMember where groupId in:nonUserIdSet]){
                string str = string.valueof(gm.UserOrGroupId);
                if(str.startsWith('005')){
                    userIdSet.add(gm.UserOrGroupId);                    
                }else{
                    nonUserIdSet1.add(gm.UserOrGroupId);                    
                }
            }
        }
        

      if(!nonUserIdSet1.isEmpty()){
                  for(GroupMember gm:[select UserOrGroupId From GroupMember where groupId in:nonUserIdSet1]){
                string str = string.valueof(gm.UserOrGroupId);
                if(str.startsWith('005')){
                    userIdSet.add(gm.UserOrGroupId);                    
                }                
            }
        }
     
         list<string> sendTo = new list<string>();
         for(user usr:[select email from user where id in :userIdSet]){
          sendTo.add(usr.email);
         }
         
         String body = 'Dear Lot Request Team'+ ',' + '\r\n'+ '\r\n';
      body += 'This is to inform you that a new Lot Request submission has been recalled. Please do not proceed with the Lot Request.'+ '\r\n'+ '\r\n';
      body += 'Lot Request Number :'+ lrList[0].Name + '\r\n'+ '\r\n';
      body += 'Account : ' + lrList[0].Account__r.name+ '\r\n'+ '\r\n'; 
      body += 'Fab :' +lrList[0].Fab__c + '\r\n'+ '\r\n';
      body += 'Lot Request Type :' + lrList[0].Lot_Request_Type__c+ '\r\n'+ '\r\n'; 
      body += 'Record Last Modified by :' +lrList[0].LastModifiedBy.name + '\r\n'+ '\r\n';
      body += 'Customer Requested Ship Date: ' +lrList[0].New_Customer_Requested_Date_CRD_CSR__c + '\r\n' + '\r\n';
      body += 'Customer Requested Lots :'+ lrList[0].Customer_Requested_Lot_Qty__c+ '\r\n' + '\r\n';
      body += 'Customer Requested Wafers :' + lrList[0].Customer_Requested_Wafer_Qty__c + '\r\n' + '\r\n';
      body += 'Customer Instructions :' + lrList[0].Customer_Instructions__c+ '\r\n'+ '\r\n'; 
      body += 'Customer Accepts Standard Pricing:' +lrList[0].Does_Customer_Accept_Standard_Pricing__c + '\r\n'+ '\r\n';
      body += 'Lot Request Type :' + lrList[0].Lot_Request_Type__c + '\r\n'+ '\r\n';
      body += 'CSR Comments :' +lrList[0].CSR_Comments__c+ '\r\n'+ '\r\n'; 
      body += 'Lot Request Stage :' +lrList[0].Stage__c  + '\r\n'+ '\r\n';
      body +='To access the Lot Request, click the following url below: ' + '\r\n'+ '\r\n';
      body +=URL.getSalesforceBaseUrl().toExternalForm() + '/' + lrList[0].Id+ '\r\n'+ '\r\n';
      body +='Thank You'+ ','+ '\r\n';
      body +='System Admin'+ '\r\n';
        
         if(!userIdSet.isEmpty() && null<>userIdSet ){
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
         mail.setToAddresses(sendTo);
         mail.setSubject('Lot Request Recalled:'+lrList[0].Account__r.name+' ' +'for' +' '+lrList[0].Fab__c);
         mail.setPlainTextBody(body);
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        
         }
    }
    
    public Static string recallCheck(){
      string rMessage='';
    rMessage='Recalled Sucessfully';
     return rMessage;
    
    }

}