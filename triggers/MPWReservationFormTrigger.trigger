/*
    Author: Shyam Ravindra Nair
    Description: This serves as the trigger for MPW_Reservation__c.
    History: 
        SNair      21072015    - Code creation.
*/ 
trigger MPWReservationFormTrigger on MPW_Reservation__c (after Insert,after update,before update) {
  
  /*  Make comments section mandatory if the form is rejected  */ 
  if(trigger.isUpdate && trigger.isbefore){  
  	 
  	 Map<Id, MPW_Reservation__c> rejectedStatements = new Map<Id, MPW_Reservation__c>{};
  	
  	for(MPW_Reservation__c objMPWReservation: trigger.new){
  		if (Trigger.oldMap.get(objMPWReservation.id).Form_Status__c != 'Draft'  && objMPWReservation.Form_Status__c == 'Draft')
    
      { 
         rejectedStatements.put(objMPWReservation.Id, objMPWReservation);  
       }
  	}
  	
  	if (!rejectedStatements.isEmpty()){
  		MPWApprovalHelper.validateMPWFormRejectionReason(rejectedStatements);
  	}  
  	
  }
  
  if(trigger.isAfter){  
    //handler
    MPWReservationFormTriggerHandler handler = new MPWReservationFormTriggerHandler();
    List<MPW_Reservation__c> mpwResList = new List<MPW_Reservation__c>();
    List<MPW_Reservation__c> mpwRessendReminderForQuotationCloseList = new List<MPW_Reservation__c>();
    List<MPW_Reservation__c> mpwRessendReminderForPurchaseOrderList = new List<MPW_Reservation__c>();
    List<MPW_Reservation__c> mpwRessendReminderForSalesOrderNumberList = new List<MPW_Reservation__c>();
    List<MPW_Reservation__c> mpwRessendReminderForRevisionCustomerList = new List<MPW_Reservation__c>();
    List<MPW_Reservation__c> mpwRessendReminderForRevisionInternalList = new List<MPW_Reservation__c>();
    List<MPW_Reservation__c> mpwResVoidList = new List<MPW_Reservation__c>();
    Map<String, MPW_Reservation__c > MPWTMMap = new Map<String, MPW_Reservation__c >(); 
    List<MSTAccount__c> MSTAccountToInsert = new List<MSTAccount__c>();
    List<MSTAccount__c> MSTAccountToInsert1 = new List<MSTAccount__c>();
    List<MSTAccount__c> MSTAccountToUpdate = new List <MSTAccount__c>();
    List<MSTAccount__c> MSTAccountToDelete = new List <MSTAccount__c>();
    Set<String> setMaskTitle= new Set<String>();
    Boolean Flag =False;
    //After approval of form
    if (!IntegrationUserUtil.isSkipTrigger()) {
        if(trigger.isUpdate && trigger.isAfter){
            
            for(MPW_Reservation__c m: trigger.new){
                MPW_Reservation__c oldMPWResf = trigger.oldMap.get(m.Id);
                if(oldMPWResf.Form_Status__c.startsWith('Pending') &&  m.Form_Status__c == 'Accepted by MPW Tapeout' || m.Form_Status__c == 'Accepted by CE' || m.Form_Status__c == 'Accepted by Turnkey'){
                    mpwResList.add(m);
                } 
                if(oldMPWResf.Form_Status__c == 'Accepted by MPW Tapeout' && m.Form_Status__c == 'Void'){
                    mpwResVoidList.add(m);
                }
                if(oldMPWResf.SendQuotation_Close_CancellationReminder__c == false && m.SendQuotation_Close_CancellationReminder__c == true && m.Form_Status__c == 'Accepted by MPW Tapeout'){
                    //handler.sendReminderForQuotationClose(trigger.new);
                    mpwRessendReminderForQuotationCloseList.add(m);
                }
                
                if(oldMPWResf.SendPurchaseOrderReminder__c == false && m.SendPurchaseOrderReminder__c == true && m.Form_Status__c == 'Accepted by MPW Tapeout' && (m.Sales_Order__c == '' || m.Sales_Order__c == null)){
                    //handler.sendReminderForPurchaseOrder(trigger.new);
                    mpwRessendReminderForPurchaseOrderList.add(m);
                    
                }
                
                if(oldMPWResf.SendSalesOrderNumberReminder__c == false && m.SendSalesOrderNumberReminder__c == true && m.Form_Status__c == 'Accepted by MPW Tapeout' && (m.Sales_Order__c == '' || m.Sales_Order__c == null)){
                    //handler.sendReminderForSalesOrderNumber(trigger.new);
                    mpwRessendReminderForSalesOrderNumberList.add(m);
                }
                
                if(oldMPWResf.SendRevisionEmailCustomerReminder__c == false && m.SendRevisionEmailCustomerReminder__c == true){
                    //handler.sendReminderForRevisionCustomer(trigger.new);
                    mpwRessendReminderForRevisionCustomerList.add(m);
                }
                
                if(oldMPWResf.SendRevisionEmailInternalReminder__c == false && m.SendRevisionEmailInternalReminder__c == true){
                    //handler.sendReminderForRevisionInternal(trigger.new);
                    mpwRessendReminderForRevisionInternalList.add(m);
                }
                /*if(oldMPWResf.Sales_Order__c != m.Sales_Order__c && m.Sales_Order__c != null){
                    handler.sendReminderForSalesOrder(trigger.new);
                }*/
                
            }
            
        if(!mpwRessendReminderForQuotationCloseList.isEmpty()){
            handler.sendReminderForQuotationClose(mpwRessendReminderForQuotationCloseList);
        }
        if(!mpwRessendReminderForPurchaseOrderList.isEmpty()){
            handler.sendReminderForPurchaseOrder(mpwRessendReminderForPurchaseOrderList);
        }
        if(!mpwRessendReminderForSalesOrderNumberList.isEmpty()){
            handler.sendReminderForSalesOrderNumber(mpwRessendReminderForSalesOrderNumberList);
        }
        if(!mpwRessendReminderForRevisionCustomerList.isEmpty()){
            handler.sendReminderForRevisionCustomer(mpwRessendReminderForRevisionCustomerList);
        }
        if(!mpwRessendReminderForRevisionInternalList.isEmpty()){
            handler.sendReminderForRevisionInternal(mpwRessendReminderForRevisionInternalList);
        }
        
        if(!mpwResList.isEmpty()){
            for(MPW_Reservation__c m: mpwResList){
                handler.afterApproval(m);
            }
        }
        
        if(!mpwResVoidList.isEmpty()){
            handler.afterVoid(mpwResVoidList);
        }
    }   
        If(trigger.isUpdate ||trigger.isInsert){
            for (MPW_Reservation__c m : [SELECT   Id
                                                            , Customer_Company_Name__c
                                                            , Form_Status__c
                                                            , MPW_Train_Name__r.Name  
                                                            ,MPW_Train_Name__r.Publish__c 
                                                            ,MPW_Train_Name__r.Active__c
                                                   FROM     MPW_Reservation__c
                                                   WHERE    Id IN :Trigger.new]){
                    MPWTMMap.put(m.MPW_Train_Name__r.Name, m);                                  
                }
                
                List<Mask_Set_Title__c> lstMaskSetTitle = new List<Mask_Set_Title__c>();
                List<MSTAccount__c> lstMSTAccount = new List<MSTAccount__c>();
                for(Mask_Set_Title__c mst: [SELECT Name,Reticle_Type__c FROM Mask_Set_Title__c WHERE Name In: MPWTMMap.KeySet() ]){
                    setMaskTitle.add(mst.name);
                    lstMaskSetTitle.add(mst);
                }
                for(MSTAccount__c mst: [SELECT Account__c,Mask_Set_Title__c,Mask_Set_Title__r.Name FROM MSTAccount__c WHERE Mask_Set_Title__r.Name In: MPWTMMap.KeySet() ]){
                    
                    lstMSTAccount.add(mst);
                }
                For(MPW_Reservation__c m: MPWTMMap.values()){
                    if(m.Customer_Company_Name__c!= Null && (m.Form_Status__c == 'Accepted by MPW Tapeout' || m.Form_Status__c == 'Void' )){
                        If(setMaskTitle != NULL || setMaskTitle.size()>0){ 
                            For(Mask_Set_Title__c mst: lstMaskSetTitle){
                                If (m.MPW_Train_Name__r.Name == lstMaskSetTitle[0].name && m.MPW_Train_Name__r.Publish__c && m.MPW_Train_Name__r.Active__c){
                                    If(!lstMSTAccount.isEmpty() ){
                                        For(MSTAccount__c MSTAccount:lstMSTAccount){
                                            If(MSTAccount.Mask_Set_Title__c == lstMaskSetTitle[0].Id && MSTAccount.Account__c == m.Customer_Company_Name__c &&  m.Form_Status__c != 'Void'){   
                                            Flag = True;
                                            Break;                                       
                                            }
                                            Else if(MSTAccount.Mask_Set_Title__c == lstMaskSetTitle[0].Id && Trigger.IsUpdate && (MSTAccount.Account__c == Trigger.oldMap.get(m.Id).Customer_Company_Name__c &&  m.Form_Status__c != 'Void')){
                                                MSTAccount.Account__c = m.Customer_Company_Name__c;
                                                MSTAccountToUpdate.add(MSTAccount);
                                            }
                                            Else if(MSTAccount.Mask_Set_Title__c == lstMaskSetTitle[0].Id && MSTAccount.Account__c == m.Customer_Company_Name__c  && Trigger.IsUpdate && m.Form_Status__c!= Trigger.oldMap.get(m.Id).Form_Status__c && m.Form_Status__c == 'Void'  ){
                                                MSTAccountToDelete.add(MSTAccount);
                                            }
                                            
                                          
                                        } 
                                        if(!Flag && (Trigger.IsInsert || (Trigger.IsUpdate && m.Form_Status__c!= Trigger.oldMap.get(m.Id).Form_Status__c && m.Form_Status__c == 'Accepted by MPW Tapeout'))){
                                                    MSTAccount__c MSTAcc  = new MSTAccount__c();
                                                    MSTAcc.Account__c = m.Customer_Company_Name__c;
                                                    MSTAcc.Mask_Set_Title__c = lstMaskSetTitle[0].ID;
                                                    MSTAccountToInsert1.add(MSTAcc);
                                                    Flag = True;
                                                
                                        } 
                                        
                                    }
                                    Else if(lstMSTAccount.size()==0) { 
                                   
                                        MSTAccount__c MSTAcc  = new MSTAccount__c();
                                        MSTAcc.Account__c = m.Customer_Company_Name__c;
                                        MSTAcc.Mask_Set_Title__c = lstMaskSetTitle[0].ID;
                                        MSTAccountToInsert.add(MSTAcc);
                                                                            
                                    }
                                
                                }
                            
                            }
                            
                        }
                    }
                 
                }   
            
            if(MSTAccountToInsert1!= Null && MSTAccountToInsert1.size()>0){
                    upsert MSTAccountToInsert1;
            }
            Else {
            if(MSTAccountToInsert!= Null && MSTAccountToInsert.size()>0){
                    upsert MSTAccountToInsert;
            }
            }
            if(MSTAccountToUpdate!= Null && MSTAccountToUpdate.size()>0){
                    Update MSTAccountToUpdate;
            }
            if(MSTAccountToDelete!=Null && MSTAccountToDelete.Size()> 0){
                    Delete MSTAccountToDelete;
            }
        }
    
    }
  }
}