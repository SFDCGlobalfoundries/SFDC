/**
* Author: Yash Kumar
* Company: IBM India
* Description: Trigger for Setting Primary Field Engineer
* History:
*     Yash             26102013           Initial Draft
      Yash             22042014           Modify trigger just putting rejected condition
      ZAmbat           09052014           Updated code as per CASE 34013.
      Prashant         08122015           Updated Error message as per Case 00049818.
      Pradosh          24022017           validation for Pricing Approved Price.
      Pradosh          17052017           Case-#00072101.Validation for Pricing Approved Price.
      Pradosh          18082017           Case-#00076696.Remove validation for "Recall Approval Request".
**/
trigger InformalQuote on Informal_Quote__c (before insert, before update) {

 final String ROLE_PRIMARY_FIELD_ENGINEER = Account_Team_Roles__c.getInstance('ROLE_PRIMARY_FIELD_ENGINEER').Role__c;
 
  List<Informal_Quote__c> lInformalQuote;
  List<Account_Team_Proxy__c> lFieldEngineerProxies = new List<Account_Team_Proxy__c>();  
  Set<Id> sAccountIds = new Set<Id>();
  lInformalQuote= Trigger.new; 
 // if (Trigger.isInsert) {  
       
        if (lInformalQuote!= null && !lInformalQuote.isEmpty()) { 
      
            for (Informal_Quote__c eachInformalQuote: lInformalQuote) {
                sAccountIds.add(eachInformalQuote.Account__c);          
            }
            lFieldEngineerProxies = [SELECT Account__c, User__c, Team_Role__c 
                                       FROM Account_Team_Proxy__c 
                                       WHERE Account__c IN: sAccountIds 
                                        AND (    Team_Role__c = :ROLE_PRIMARY_FIELD_ENGINEER
                                            OR ( Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                            OR ( Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE) )
                                        AND Flag_for_Delete__c = false 
                                        AND User__r.isActive = true];
            lFieldEngineerProxies = Utility.getSortedFAE(lFieldEngineerProxies);
            
            // Call Helper method to update Primary Field Engineer
            // if (Trigger.isInsert) {
                QuoteApprovalHelper.updateFieldEngineers(lInformalQuote, lFieldEngineerProxies);
            // }
       } 
 //  }
   if (Trigger.isUpdate) {
       
       try
       {
           list<attachment> lstattachment= new list<attachment>();
           lstattachment=[SELECT id,ParentId from attachment where parentid=:trigger.new];
           if(lstattachment.size()==0)
           {
               for (Informal_Quote__c  IQ: trigger.new)
               {
                   if( (! isApprovalRecalled(IQ.Id)) && IQ.List_Price__c==true && (trigger.newmap.get(IQ.Id).Budgetary_Quote_Status__c !='Draft' && trigger.newmap.get(IQ.Id).Budgetary_Quote_Status__c !='Rejected')) //IQ.Volume_break__c== true && 
                   trigger.new.get(0).addError('If the field "Above List Price" is checked, take a screen shot of the approved price from the pricing calculator and attach the screen shot in the Notes & Attachment section below as evidence.'); //Case # 00049818.
               }
               
           }
        } 
         catch(Exception e)
         {
             System.debug('The following exception has occurred: ' + e.getMessage());
         }
        for (Informal_Quote__c  eachIQ: lInformalQuote) {
          
             if( (! isApprovalRecalled(eachIQ.Id)) && lFieldEngineerProxies.size()==0 && trigger.oldmap.get(eachIQ.Id).Budgetary_Quote_Status__c =='Pending Approval Primary FAE' )
             {
                trigger.new.get(0).addError('Please add Field Application Engineer in account team proxy object');
             }
             if( (! isApprovalRecalled(eachIQ.Id)) && trigger.oldmap.get(eachIQ.Id).Budgetary_Quote_Status__c =='Pending Approval Primary FAE' && eachIQ.Total_Area_of_CPU__c==null && eachIQ.Yield_Commit__c=='YES' && eachIQ.Existing_Device__c=='NO' )
             {
                  lInformalQuote.get(0).addError('All sections fields are Mandatory before Approval');
             }
            
             if(trigger.oldmap.get(eachIQ.Id).Budgetary_Quote_Status__c =='Draft')
             {
                
                
                  checkInformalQuoteValidation(eachIQ.Id,'Draft', eachIQ);
                 
             }
             if(trigger.oldmap.get(eachIQ.Id).Budgetary_Quote_Status__c =='Pending Approval TE')
             {
                
                
                  checkInformalQuoteValidation(eachIQ.Id,'TE', eachIQ);
                 
             }
             if(trigger.oldmap.get(eachIQ.Id).Budgetary_Quote_Status__c =='Pending Approval Pricing')
             {
                
               
                  checkInformalQuoteValidation(eachIQ.Id,'Pricing', eachIQ);
                 
             }
             
        }
        
        
   }
   
    // ZAmbat 09052014
  /*  if (trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) {
        List<Informal_Quote__c> listInformalQuote = new List<Informal_Quote__c>();
        for (Informal_Quote__c i : trigger.new) {
            if ((trigger.isBefore && trigger.isInsert && i.Opportunity__c != null)
                || (trigger.isBefore && trigger.isUpdate && i.Opportunity__c != trigger.oldMap.get(i.id).Opportunity__c)) {
                listInformalQuote.add(i);
            }
        }
        
        if (listInformalQuote.size() > 0) {
            InformalQuoteSetTargetProcessNode.populateTargetProcessNode(listInformalQuote);
        }
    } */
   
    public void checkInformalQuoteValidation(string informalid,string name, Informal_Quote__c informalQuote)
    {
        
        
        List<Budgetary_Quote_Item__c> chkinfo;
       
        chkinfo = [SELECT id,Competitors_1__c,Competitors_2__c,Competitors_1_Volume__c ,Competitors_2_Volume__c , CreatedDate,
                Competitor_1_Complexity__c,Competitor_2_Complexity__c,Competitor_1_Price_US__c,Competitor_2_Price_US__c, name,
                 Sales_Requested_Price__c, Pricing_Approved_Price__c,Box_Score__c,Cost__c, List_Price__c, Start_Date__c, Quarter__c,
                  Quantity__c,Margin__c, Budgetary_Quote__r.Name,Budgetary_Quote__r.id,Budgetary_Quote__r.Competitor1__c,
                  Budgetary_Quote__r.Competitor_2__c,Budgetary_Quote__r.Competitor_1_Complexity__c,Yield_Commit_information_for_customer__c,Yield_Commit_information_for_TE__c,Yield_Commit_information_for_Pricing__c,
                  Budgetary_Quote__r.Competitor_2_Complexity__c,Budgetary_Quote__r.Competitor_1_Price_US__c,Budgetary_Quote__r.Budgetary_Quote_Status__c,
                  Budgetary_Quote__r.Competitor_2_Price_US__c,Budgetary_Quote__r.Competitor_1_Quarter__c,Budgetary_Quote__r.Yield_Commit__c,
                  Budgetary_Quote__r.Competitor_2_Quarter__c,Budgetary_Quote__c from Budgetary_Quote_Item__c where Budgetary_Quote__c =:informalid];
         system.debug('>>>>chkinfo.size()>>>>'+chkinfo.size());
             if(chkinfo.size()>0)
         {  
            Map<Id, Decimal> minPricingApprovedPriceMap = new Map<Id, Decimal>();
            Map<Id, Decimal> minListPriceMap = new Map<Id, Decimal>();
            
             for(integer i=0; i<chkinfo.size();i++)
             {
                 if(name=='Draft')
                 {
                     if( (! isApprovalRecalled(chkinfo[i].Budgetary_Quote__r.Id)) && chkinfo[i].Yield_Commit_information_for_customer__c==null && trigger.newmap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c!='Draft' && chkinfo[i].Budgetary_Quote__r.Yield_Commit__c=='YES' && trigger.newmap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c!='Rejected' )//Pending Approval Marketing
                     {
                         
                          trigger.new.get(0).addError('Please Enter a Yield commit Information from Customer value before approval');
                          break;
                     } 
                     system.debug('>>>>chkinfo[i].Budgetary_Quote__r.Competitor1__c>>>>'+chkinfo[i].Budgetary_Quote__r.Competitor1__c);
                     if(chkinfo[i].Budgetary_Quote__r.Competitor1__c !=null && trigger.newmap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c!='Draft' )
                     {
                         if( (! isApprovalRecalled(chkinfo[i].Budgetary_Quote__r.Id)) && ( chkinfo[i].Competitors_1_Volume__c==null || chkinfo[i].Competitor_1_Complexity__c==null || chkinfo[i].Competitor_1_Price_US__c==null )&& (chkinfo[i].Budgetary_Quote__r.Yield_Commit__c=='YES'|| chkinfo[i].Budgetary_Quote__r.Yield_Commit__c=='NO'))
                         {
                             
                              system.debug('>>>>chkinfo[i].Competitors_1_Volume__c>>>>'+chkinfo[i].Competitors_1_Volume__c);
                              trigger.new.get(0).addError('Please Enter Competitor 1 Volume/Competitor 1 Complexity/Competitor 1 Price US ');
                              break;
                         } 
                     }
                     
                 }
                 if(name=='TE')
                 {
                     //system.debug('>>>>trigger.oldmap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c<<<<<'+trigger.oldmap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c + trigger.newmap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c);
                     if( (! isApprovalRecalled(chkinfo[i].Budgetary_Quote__r.Id))  && chkinfo[i].Yield_Commit_information_for_TE__c==null && chkinfo[i].Budgetary_Quote__r.Yield_Commit__c=='YES' && trigger.newmap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c!='Rejected')
                     {
                         
                          trigger.new.get(0).addError('Please Enter a Yield commit Information from TE value before approval');
                          break;
                     }
                 }
                 if(name=='Pricing')
                 {
                     if( (! isApprovalRecalled(chkinfo[i].Budgetary_Quote__r.Id)) && chkinfo[i].Yield_Commit_information_for_Pricing__c==null && chkinfo[i].Budgetary_Quote__r.Yield_Commit__c=='YES' && trigger.newmap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c!='Rejected')
                     {
                          trigger.new.get(0).addError('Please Enter a Yield commit Information from Pricing value before approval');
                          break;
                     }
                     if( (! isApprovalRecalled(chkinfo[i].Budgetary_Quote__r.Id)) && (chkinfo[i].Pricing_Approved_Price__c==null || chkinfo[i].List_Price__c==null || chkinfo[i].Box_Score__c==null || chkinfo[i].Cost__c==null)&&(chkinfo[i].Budgetary_Quote__r.Yield_Commit__c=='YES'  && trigger.newmap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c!='Rejected') )
                     {
                         
                          trigger.new.get(0).addError('Please Enter a Pricing Approved Price/List Price/Box Score/Cost value before approval');
                          break;
                     }
                     if( (! isApprovalRecalled(chkinfo[i].Budgetary_Quote__r.Id)) && (chkinfo[i].Pricing_Approved_Price__c<=0 )&&(chkinfo[i].Budgetary_Quote__r.Yield_Commit__c=='YES'  && trigger.newmap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c!='Rejected') )
                     {
                         
                          trigger.new.get(0).addError('No ZERO in Pricing Approved Price column before approval');
                          break;
                     }
                     
                     if( (! isApprovalRecalled(chkinfo[i].Budgetary_Quote__r.Id)) && chkinfo[i].Pricing_Approved_Price__c != null && (chkinfo[i].List_Price__c == null || chkinfo[i].List_Price__c == 0) && chkinfo[i].Budgetary_Quote__r.Yield_Commit__c == 'NO'  && trigger.newmap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c != 'Rejected'){
                        
                         trigger.new.get(0).addError(System.Label.Informal_Quote_List_Price_Error_Msg);
                         break;
                    }
                    
                    if(Trigger.newMap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c != 'Hold'
                      && Trigger.oldMap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c != 'Hold'
                      && Trigger.newMap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c != 'Rejected'
                      && Trigger.newMap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c != Trigger.oldMap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c
                      && chkinfo[i].Pricing_Approved_Price__c == null 
                      && chkinfo[i].Budgetary_Quote__r.Yield_Commit__c == 'NO'
                      && (! isApprovalRecalled(chkinfo[i].Budgetary_Quote__r.Id))){
                        
                        Trigger.newMap.get(chkinfo[i].Budgetary_Quote__r.Id).addError(System.Label.IQ_Pricing_Approved_Price_Val_For_Null);
                        break;
                    }
                    
                    if(Trigger.newMap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c != 'Hold'
                      && Trigger.oldMap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c != 'Hold'
                      && Trigger.newMap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c != 'Rejected'
                      && Trigger.newMap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c != Trigger.oldMap.get(chkinfo[i].Budgetary_Quote__r.Id).Budgetary_Quote_Status__c
                      && chkinfo[i].Pricing_Approved_Price__c < 0
                      && chkinfo[i].Budgetary_Quote__r.Yield_Commit__c == 'NO'
                      && (! isApprovalRecalled(chkinfo[i].Budgetary_Quote__r.Id)) ){
                        
                        Trigger.newMap.get(chkinfo[i].Budgetary_Quote__r.Id).addError(System.Label.IQ_Pricing_Approved_Price_Val_For_0_or_less);
                        break;
                    }
                }
                 
                if(minPricingApprovedPriceMap.containsKey(chkinfo[i].Budgetary_Quote__c)){
                
                    if(minPricingApprovedPriceMap.get(chkinfo[i].Budgetary_Quote__c) != null){
                        
                        if(chkinfo[i].Pricing_Approved_Price__c == null){
                        
                            minPricingApprovedPriceMap.put(chkinfo[i].Budgetary_Quote__c, chkinfo[i].Pricing_Approved_Price__c);
                        }
                        else if(chkinfo[i].Pricing_Approved_Price__c < minPricingApprovedPriceMap.get(chkinfo[i].Budgetary_Quote__c)){
                            
                            minPricingApprovedPriceMap.put(chkinfo[i].Budgetary_Quote__c, chkinfo[i].Pricing_Approved_Price__c);
                        }
                    }
                }
                else{
                
                    minPricingApprovedPriceMap.put(chkinfo[i].Budgetary_Quote__c, chkinfo[i].Pricing_Approved_Price__c);
                }
                
                if(minListPriceMap.containsKey(chkinfo[i].Budgetary_Quote__c)){
                
                    if(minListPriceMap.get(chkinfo[i].Budgetary_Quote__c) != null){
                        
                        if(chkinfo[i].List_Price__c == null){
                        
                            minListPriceMap.put(chkinfo[i].Budgetary_Quote__c, chkinfo[i].List_Price__c);
                        }
                        else if(chkinfo[i].List_Price__c < minListPriceMap.get(chkinfo[i].Budgetary_Quote__c)){
                            
                            minListPriceMap.put(chkinfo[i].Budgetary_Quote__c, chkinfo[i].List_Price__c);
                        }
                    }
                }
                else{
                
                    minListPriceMap.put(chkinfo[i].Budgetary_Quote__c, chkinfo[i].List_Price__c);
                }
             }
             
            informalQuote.Min_Pricing_Approved_Price1__c = minPricingApprovedPriceMap.get(informalQuote.Id);
            informalQuote.Min_List_Price1__c = minListPriceMap.get(informalQuote.Id);
         }
    }

    private Boolean isApprovalRecalled(Id informalQuoteId){
        
        if(Trigger.newMap.get(informalQuoteId).Budgetary_Quote_Status__c == 'Draft'
        && Trigger.oldMap.get(informalQuoteId).Budgetary_Quote_Status__c != 'Draft'){
            
            return TRUE;
        }
        else{
            
            return FALSE;
        }
    }
}