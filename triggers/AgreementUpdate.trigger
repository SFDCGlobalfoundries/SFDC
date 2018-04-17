/*Code Added by Suvajit:-

1) To check for attachments in Procurement Agreements upon Save when UPC/Commitment is Yes

2) Code to ensure that status category/status remains in 'Request' stage till Activation for Procurement contracts

3) Code to bypass above validation when amendment is done for Procurement records

4) Code to ensure that status category/status remains in 'Request' till Activation for all CLM /NDA types as per request during CLM Phase 1 UAT

5) Code to ensure that amendment records start their cycle at status category/status in 'Request' stage

6) UPC Leasing Validations for Procurement Agreements 

7) All the validations that are for CLM project are handled by this trigger with custom setting exception at one place for data loading issues
https://docs.google.com/spreadsheets/d/18um6AJQ0BJAwZ8SSET-UIg95_zul11CNk2P5G6uN-P8/edit?ts=569f3d67#gid=592558897

Change:-

Added exception for validations not to fire for migrated CLM records using XREF ID as null criteria.
DBiswal    08082017    Added code for default naming of ITAR recordtypes.(line no. 442-449)
DBiswal    09142017    Changed the CLM recordtype name of ITAR.
[20/11/2017 - Ruchi] : Made change in the Applicable Fabs auto-populate condition when Global contract is 'Yes'.

*/



trigger AgreementUpdate on Apttus__APTS_Agreement__c (before update,after update) 
{
    List<String> ids = new List<String>();
    Map<String,List<Signatory__c>> agreementSignatories = new Map<String,List<Signatory__c>>();
    List<sObject> DelAttachAndAgrDocProcAmend= new List<sObject>();
    List<Signatory__c> sigList = null;
    Date endDate = null;    
    Date startDate = null;


NDA_CLM_App_Settings__c cs = NDA_CLM_App_Settings__c.getInstance( UserInfo.GetUserID());


Map<ID,RecordType> RT_Map = New Map<ID,RecordType>([Select ID, Name,DeveloperName From RecordType Where sObjectType = 'Apttus__APTS_Agreement__c' and isActive=true]);    

Map<Id,Apttus__APTS_Agreement__c > accountsMap = New Map<Id,Apttus__APTS_Agreement__c >([select id, Apttus__Account__r.Short_Name__c from Apttus__APTS_Agreement__c where Apttus__Account__c!=NULL and Apttus__Account__r.Short_Name__c!=NULL and id IN: Trigger.new]);


    if(Trigger.isBefore)
        
        {       
        
              //Delegating to handler class to autopopulate Management NDA Notification and GF Signatory Type depending on Geography/Department currently implemented for the record types defined in the custom setting NDA Record Types         
              NDAMgmtSignatoryPopulateClass.MgmtFieldPopulateMethod(Trigger.OldMap,Trigger.newMap);   
              
              
              
              List<Attachment> attch = new List<Attachment>([SELECT id,ParentId,Name from Attachment where ParentID IN: Trigger.new]);
              Map<Id,List<Attachment>> ParentRecAttchmentMap=new Map<Id,List<Attachment>>();
              
              
              List<Apttus__Agreement_Document__c> AgrDocList= new List<Apttus__Agreement_Document__c>([SELECT id,Apttus__Agreement__c from Apttus__Agreement_Document__c where Apttus__Agreement__c IN: Trigger.new]);
              Map<Id,List<Apttus__Agreement_Document__c>> AgrToAgrDocMap=new Map<Id,List<Apttus__Agreement_Document__c>>();
              
              for(Apttus__APTS_Agreement__c agr : Trigger.new)
                {
                        List<Attachment> AttchInternal=new List<Attachment>();
                            for(Attachment a: attch)
                                if(a.parentId==agr.id)
                                    AttchInternal.add(a);
                                    
                        if(AttchInternal.size()>0)ParentRecAttchmentMap.put(agr.id,AttchInternal);      
                        
                        
                        List<Apttus__Agreement_Document__c> AgrDocInternal=new List<Apttus__Agreement_Document__c>();
                            for(Apttus__Agreement_Document__c agrdoc: AgrDocList)
                                if(agrdoc.Apttus__Agreement__c==agr.id)
                                    AgrDocInternal.add(agrdoc);
                                    
                        if(AgrDocInternal.size()>0)AgrToAgrDocMap.put(agr.id,AgrDocInternal);   
                }
            
            //[23/10/2018 - Ruchi]: Adding this two line code to fetch values(RecordTypes) from a Custom Setting      
            Set<String> values = new Set<String>();
            values.addAll(Environment_Variable__c.getInstance('NDA_ExpirationDate_recordTypes').Value__c.split(','));
           
                       
            for(Apttus__APTS_Agreement__c agr : Trigger.new)
             {
              
               //Code to keep Status/Status Category to Request when Status Category is Request and Status is not populated sometimes due to version differences in Apttus package.               
               if((agr.Apttus__Status_Category__c=='Request' || String.isBlank(agr.Apttus__Status_Category__c)) && (agr.Apttus__Status__c=='Request' || String.isBlank(agr.Apttus__Status__c)))
                   {
                       agr.Apttus__Status__c='Request';
                       agr.Apttus__Status_Category__c='Request';
                   }    
               
               
               if(RT_Map.get(agr.recordTypeID).DeveloperName.containsIgnoreCase('Procurement_Agreements') ) 
                 {
                 
                     if(agr.Apttus__Version_Number__c>0 && (agr.Apttus__Status_Category__c=='Amended' && agr.Apttus__Status__c=='In Amendment') && !agr.CLM_Confirm__c)
                           {
                               if(ParentRecAttchmentMap.containsKey(agr.id))
                                  { 
                                   DelAttachAndAgrDocProcAmend.addAll((List<sObject>)ParentRecAttchmentMap.get(agr.id));
                                   agr.Apttus__Status__c='Request';
                                   agr.Apttus__Status_Category__c='Request';
                                  } 
                               if(AgrToAgrDocMap.containsKey(agr.id))
                                  { 
                                   DelAttachAndAgrDocProcAmend.addAll((List<sObject>)AgrToAgrDocMap.get(agr.id));
                                   agr.Apttus__Status__c='Request';
                                   agr.Apttus__Status_Category__c='Request';
                                  }   
                               if( !ParentRecAttchmentMap.containsKey(agr.id)  && !AgrToAgrDocMap.containsKey(agr.id))
                                  {
                                      agr.Apttus__Status__c='Request';
                                      agr.Apttus__Status_Category__c='Request';
                                  }     
                           } 
                 
                   if(!String.isBlank(String.valueOf(agr.CLM_Total_Contract_Amount_USD__c)) && !String.isBlank(String.valueOf(agr.CLM_Total_UPC_Leasing_Commitment_Amt__c)))
                             if(agr.CLM_Total_UPC_Leasing_Commitment_Amt__c>agr.CLM_Total_Contract_Amount_USD__c && agr.CLM_UPC_Leasing_Commitment__c.containsIgnoreCase('Yes'))
                                     if(!cs.Disable_Trigger_Validation__c && String.isBlank(agr.CLM_XREF_ID__c))
                                             agr.addError('The Total UPC/Leasing Amount can not be greater than the Total Contract Amount. Please revise.');
                 
                 
                    if(!String.isBlank(String.valueOF(agr.CLM_Total_Contract_Amount_USD__c)) && !String.isBlank(agr.CLM_Corporate_Accounting_Approval_Req__c))
                        if(agr.CLM_Total_Contract_Amount_USD__c>=10000000.00 && agr.CLM_Procurement_Base_Agreement_type__c=='Non-Standard' && agr.CLM_Corporate_Accounting_Approval_Req__c=='No' && String.isBlank(agr.CLM_Corporate_Accounting_Reviewer__c) && String.isBlank(agr.CLM_Corp_Acct_Approval_Exception_Reason__c))
                            if(!cs.Disable_Trigger_Validation__c && String.isBlank(agr.CLM_XREF_ID__c))
                                agr.CLM_Corp_Acct_Approval_Exception_Reason__c.addError('If the Base Type is Non-Standard and Corporate Acct.Approval Required is NO and Total Contact Amount is greater than or equal to 10Million USD, enter an exception reason.');
                        
                     
                    if(agr.CLM_Confirm__c==True && String.isBlank(String.valueOf(agr.CLM_Execution_Date__c)))
                             if(!cs.Disable_Trigger_Validation__c && String.isBlank(agr.CLM_XREF_ID__c))
                                 agr.CLM_Execution_Date__c.addError('An Execution date must be entered prior to \'Activation\'');
                 
                 
                    if(!String.isBlank(agr.CLM_Corporate_Accounting_Approval_Req__c))
                     if(agr.CLM_Corporate_Accounting_Approval_Req__c=='Yes' && String.isBlank(agr.CLM_Corporate_Accounting_Reviewer__c))
                             if(!cs.Disable_Trigger_Validation__c && String.isBlank(agr.CLM_XREF_ID__c))
                                 agr.CLM_Corporate_Accounting_Reviewer__c.addError('If the Corporate Accounting Approval is Required, select a Corporate Accounting Reviewer.');
                     
                 
                     //code to copy value of procurement contract type to contract type field for data integrity.
                     
                    if(!String.isBlank(agr.CLM_Contract_Type__c) && String.isBlank(agr.CLM_Procurement_Contract_Type__c)) agr.CLM_Procurement_Contract_Type__c=agr.CLM_Contract_Type__c;
                    
                    if(!String.isBlank(agr.CLM_Procurement_Contract_Type__c) && String.isBlank(agr.CLM_Contract_Type__c)) agr.CLM_Contract_Type__c=agr.CLM_Procurement_Contract_Type__c;
                 
                    if(!String.isEmpty(agr.CLM_Procurement_Base_Agreement_type__c))
                    {
                        if(agr.CLM_Procurement_Base_Agreement_type__c=='Non-Standard')
                        {
                            if(!String.isBlank(agr.CLM_Legal_Approval_Required__c))
                                if(agr.CLM_Legal_Approval_Required__c=='No' && String.isBlank(agr.CLM_Legal_Approval_Exception_Reason__c))
                                    if(!cs.Disable_Trigger_Validation__c && String.isBlank(agr.CLM_XREF_ID__c)) 
                                        agr.CLM_Legal_Approval_Exception_Reason__c.addError('If the Base Type is Non-Standard and Legal Approval Required is NO, enter an exception reason.');
                        }
                        
                        if(agr.CLM_Legal_Approval_Required__c=='Yes' && String.isBlank(agr.CLM_Legal_Reviewer__c))
                             if(!cs.Disable_Trigger_Validation__c && String.isBlank(agr.CLM_XREF_ID__c))
                                 agr.CLM_Legal_Reviewer__c.addError('If the Legal Approval is Required, select a Legal Reviewer.');
                        
                    }
                     
                    List<String> options = new List<String>();
                    for( Schema.PicklistEntry f : Apttus__APTS_Agreement__c.CLM_Applicable_Fabs__c.getDescribe().getPicklistValues())
                               if(String.valueOF(f.getLabel()).toUpperCase()<>'ALL FABS')
                                   options.add(String.valueOf(new SelectOption(f.getLabel(), f.getValue()).getValue()));
                       
                       
                    if( !String.isEmpty(agr.Apttus__Status_Category__c) && !String.isEmpty(agr.Apttus__Status__c) && !String.isEmpty(agr.CLM_UPC_Leasing_Commitment__c))
                       {
                        if((
                            (agr.CLM_Confirm__c ==TRUE && Trigger.oldmap.get(agr.Id).CLM_Confirm__c==FALSE  && agr.Apttus__Status__c=='Fully Signed') 
                            ||
                            (agr.CLM_Confirm__c ==FALSE && agr.Apttus__Status__c=='In Amendment')   // this if block bypasses this validation for amend process        
                            )
                          )                                   
                            
                                    if(!cs.Disable_Trigger_Validation__c && String.isBlank(agr.CLM_XREF_ID__c))
                                    {
                                       if (!ParentRecAttchmentMap.containsKey(agr.id) && agr.CLM_Confirm__c==True)
                                              agr.addError('Please ensure system cover sheet is generated and a copy of the signed contract is uploaded prior to activating the agreement.');
                                        
                                       if (ParentRecAttchmentMap.containsKey(agr.id) && agr.CLM_Confirm__c==True)
                                        {
                                            if(ParentRecAttchmentMap.get(agr.id).size()==1 && ParentRecAttchmentMap.get(agr.id)[0].Name.contains('Procurement Cover Sheet'))
                                              agr.addError('Please ensure system cover sheet is generated and a copy of the signed contract is uploaded prior to activating the agreement.');
                                                 
                                            if(ParentRecAttchmentMap.get(agr.id).size()==1 && !ParentRecAttchmentMap.get(agr.id)[0].Name.contains('Procurement Cover Sheet'))
                                                 agr.addError('Please ensure system cover sheet is generated and a copy of the signed contract is uploaded prior to activating the agreement.');         
                                        }
                                           
                                       if(agr.CLM_Total_UPC_Leasing_Commitment_Amt__c==NULL && agr.CLM_UPC_Leasing_Commitment__c.containsIgnoreCase('Yes'))
                                           agr.CLM_Total_UPC_Leasing_Commitment_Amt__c.addError('A value must be entered if the UPC/Leasing Commitment field is YES.');                                   
                                    
                                    }
                                
                            if(agr.CLM_UPC_Leasing_Commitment__c.containsIgnoreCase('No')) 
                                if(!cs.Disable_Trigger_Validation__c && String.isBlank(agr.CLM_XREF_ID__c))    
                                  if(!(agr.CLM_Total_UPC_Leasing_Commitment_Amt__c==NULL || agr.CLM_Total_UPC_Leasing_Commitment_Amt__c==0))
                                    agr.CLM_Total_UPC_Leasing_Commitment_Amt__c.addError('A value is not required if the UPC/Leasing Commitment field is NO. Please remove.');
                                   
                       } 
                      
                     
                      
                     
                     // this code ensures that status category remains in 'Request' stage till Activation for Procurement contracts
                   
                     if(agr.Apttus__Status_Category__c=='In Authoring' || (agr.Apttus__Status_Category__c=='In Signatures' && agr.Apttus__Status__c<>'Fully Signed') || agr.Apttus__Status_Category__c=='In Filing')
                       
                             {
                             agr.Apttus__Status_Category__c='Request';
                             agr.Apttus__Status__c='Request';
                             agr.CLM_Confirm__c =FALSE;
                             agr.CLM_confirm_BX050_is_executed_uploaded__c=FALSE;
                             }
                            
                            
                            
                     // this code gets all values from Applicable Fabs and populates them if Global Contract is 'Yes' 
                            
                      if(agr.CLM_Global_Contract__c=='Yes' && agr.CLM_Legal_Entity__c != Environment_Variable__c.getInstance('Legal_Entity_FAB_11').Value__c)
                        agr.CLM_Applicable_Fabs__c=String.join(options,';');  
                            
                        
                        
                        if(agr.CLM_Global_Contract__c=='No')
                        {
                            if(!cs.Disable_Trigger_Validation__c && String.isBlank(agr.CLM_XREF_ID__c))
                            {
                                if(!String.isBlank(agr.CLM_Applicable_Fabs__c))
                                     if((agr.CLM_Applicable_Fabs__c.split(';',options.size())).size()==options.size())
                                          agr.CLM_Applicable_Fabs__c.addError('If No is selected for Global Contract, select at least one Fab.Note: All Fabs cannot be selected as well, if ‘NO’ is selected.');
                                if(String.isBlank(agr.CLM_Applicable_Fabs__c))
                                          agr.CLM_Applicable_Fabs__c.addError('If No is selected for Global Contract, select at least one Fab.Note: All Fabs cannot be selected as well, if ‘NO’ is selected.');   
                            }
                        }
                        
                   
                        /*After contract is Activated,it can only be Terminated/Expired/Cancelled 
                          After contract is Terminated/Expired/Cancelled,it can only be Terminated/Expired/Cancelled 
                        */
         
                      if(((Trigger.oldmap.get(agr.id).Apttus__Status_Category__c=='In Effect' && Trigger.oldmap.get(agr.id).Apttus__Status__c=='Activated') || 
                          (Trigger.oldmap.get(agr.id).Apttus__Status_Category__c=='Terminated' || Trigger.oldmap.get(agr.id).Apttus__Status__c=='Terminated') ||
                          (Trigger.oldmap.get(agr.id).Apttus__Status_Category__c=='Expired' || Trigger.oldmap.get(agr.id).Apttus__Status__c=='Expired')        ||
                          (Trigger.oldmap.get(agr.id).Apttus__Status_Category__c=='Cancelled' || Trigger.oldmap.get(agr.id).Apttus__Status__c=='Cancelled'))
                      &&  !(agr.Apttus__Status_Category__c=='Expired' || agr.Apttus__Status_Category__c=='Terminated' || agr.Apttus__Status_Category__c=='Cancelled' || agr.Apttus__Status__c=='In Amendment'))
                         {
                                 agr.Apttus__Status_Category__c=Trigger.oldmap.get(agr.id).Apttus__Status_Category__c==NULL && agr.Apttus__Status__c=='In Amendment'?agr.Apttus__Status_Category__c: Trigger.oldmap.get(agr.id).Apttus__Status_Category__c;
                                 agr.Apttus__Status__c=Trigger.oldmap.get(agr.id).Apttus__Status__c==NULL && agr.Apttus__Status__c=='In Amendment'?agr.Apttus__Status__c: Trigger.oldmap.get(agr.id).Apttus__Status__c;

                         }
                        
                  }
                  
                  
                  
                  if(RT_Map.get(agr.recordTypeID).DeveloperName.containsIgnoreCase('TD_Agreements'))
                     {
                         if(agr.CLM_Confirm__c==True && agr.CLM_confirm_BX050_is_executed_uploaded__c==True && String.isBlank(String.valueOf(agr.CLM_Execution_Date__c)))
                             if(!cs.Disable_Trigger_Validation__c && String.isBlank(agr.CLM_XREF_ID__c))
                                 agr.CLM_Execution_Date__c.addError('An Execution date must be entered prior to \'Activation\'');
                     }
                  
                   if(RT_Map.get(agr.recordTypeID).DeveloperName.containsIgnoreCase('Sales_Agreements') ) 
                    {  
                       List<String> options=new List<String>();  
                       for(Schema.PicklistEntry f : Apttus__APTS_Agreement__c.CLM_Applicable_Fabs__c.getDescribe().getPicklistValues())
                              if(String.valueOF(f.getLabel()).toUpperCase()<>'ALL FABS')
                                   options.add(String.valueOf(new SelectOption(f.getLabel(), f.getValue()).getValue()));

                               
                       if(agr.CLM_Global_Contract__c=='Yes')
                          {
                           if(!String.isBlank(agr.CLM_Applicable_Fabs__c)) 
                                 if(String.valueOF(agr.CLM_Applicable_Fabs__c).toUpperCase()<>'ALL FABS')
                                    agr.CLM_Applicable_Fabs__c=String.join(options,';');  
                           if(String.isBlank(agr.CLM_Applicable_Fabs__c))     
                                agr.CLM_Applicable_Fabs__c=String.join(options,';');  
                           }
                        
                        else if(agr.CLM_Global_Contract__c=='No')
                        {
                            if(!cs.Disable_Trigger_Validation__c && String.isBlank(agr.CLM_XREF_ID__c))
                            {
                                if(!String.isBlank(agr.CLM_Applicable_Fabs__c))
                                     if((agr.CLM_Applicable_Fabs__c.split(';',options.size())).size()==options.size()  || String.valueOF(agr.CLM_Applicable_Fabs__c).toUpperCase().contains('ALL FABS'))
                                          agr.CLM_Applicable_Fabs__c.addError('If Global Contract is NO, there must be at least 1 FAB selected. And/Or, you cannot select ALL FABs either');
                                if(String.isBlank(agr.CLM_Applicable_Fabs__c))
                                          agr.CLM_Applicable_Fabs__c.addError('If Global Contract is NO, there must be at least 1 FAB selected. And/Or, you cannot select ALL FABs either');   
                            }
                        }
                    }  
                  
                  
     // this code ensures that status category/status remains in 'Request' stage after Amendment is initiated for both NDA and CLM
     
     
     
     If((RT_Map.get(agr.recordTypeID).DeveloperName.containsIgnoreCase('TD_Agreements') 
        && agr.CLM_Confirm__c ==FALSE
        && agr.CLM_confirm_BX050_is_executed_uploaded__c==FALSE
        && agr.Apttus__Status__c=='In Amendment')
        ||
        (RT_Map.get(agr.recordTypeID).DeveloperName.containsIgnoreCase('TD_Agreements')
        && agr.CLM_Confirm__c ==TRUE 
        && Trigger.oldmap.get(agr.Id).CLM_Confirm__c==TRUE
        && agr.CLM_confirm_BX050_is_executed_uploaded__c==TRUE
        && Trigger.oldmap.get(agr.Id).CLM_confirm_BX050_is_executed_uploaded__c==TRUE 
        && ((agr.SystemModStamp>Trigger.oldmap.get(agr.Id).SystemModStamp && Trigger.oldmap.get(agr.Id).SystemModStamp!=NULL)
        ||   Trigger.oldmap.get(agr.Id).SystemModStamp==NULL) 
        && agr.Apttus__Status__c=='Fully Signed')
        ||
        (!RT_Map.get(agr.recordTypeID).DeveloperName.containsIgnoreCase('TD_Agreements') 
        && agr.CLM_Confirm__c ==FALSE 
        && agr.Apttus__Status__c=='In Amendment')
        ||
        (!RT_Map.get(agr.recordTypeID).DeveloperName.containsIgnoreCase('TD_Agreements') 
        && agr.CLM_Confirm__c ==TRUE 
        && Trigger.oldmap.get(agr.Id).CLM_Confirm__c==TRUE
        && ((agr.SystemModStamp>Trigger.oldmap.get(agr.Id).SystemModStamp && Trigger.oldmap.get(agr.Id).SystemModStamp!=NULL)
        ||   Trigger.oldmap.get(agr.Id).SystemModStamp==NULL)      
        && agr.Apttus__Status__c=='Fully Signed')
        ||
        (agr.Confirm__c ==FALSE 
        && agr.Apttus__Status__c=='In Amendment')
        ||
        (agr.Confirm__c ==FALSE
        && Trigger.oldmap.get(agr.Id).Confirm__c ==TRUE    
        && ((agr.SystemModStamp>Trigger.oldmap.get(agr.Id).SystemModStamp && Trigger.oldmap.get(agr.Id).SystemModStamp!=NULL)
        ||   Trigger.oldmap.get(agr.Id).SystemModStamp==NULL)                                                                    //For NDA the confirm field is reset to NULL hence the reverse criteria
        && agr.Apttus__Status__c=='Fully Signed'))
                            {
                                
                            // resetting certain fields for Amendment records as per requirements from George   
                            if(!RT_Map.get(agr.recordTypeID).DeveloperName.containsIgnoreCase('Procurement_Agreements')) agr.Apttus__Status_Category__c='Request';
                            if(!RT_Map.get(agr.recordTypeID).DeveloperName.containsIgnoreCase('Procurement_Agreements')) agr.Apttus__Status__c='Request';
                            if(RT_Map.get(agr.recordTypeID).DeveloperName.containsIgnoreCase('Procurement_Agreements')) agr.Apttus__Status_Category__c='Amended';
                            if(RT_Map.get(agr.recordTypeID).DeveloperName.containsIgnoreCase('Procurement_Agreements')) agr.Apttus__Status__c='In Amendment';
                            
                            agr.CLM_Other_Notes__c=NULL;
                            agr.CLM_Confirm__c =FALSE;
                            agr.CLM_confirm_BX050_is_executed_uploaded__c=FALSE;
                            agr.Confirm__c =FALSE;
                            agr.GF_Contract_End_Date__c=Trigger.oldmap.get(agr.id).GF_Contract_End_Date__c;   
                            agr.CLM_Execution_Date__c=NULL;
                            agr.Apttus__Activated_Date__c=NULL;
                            agr.GF_Contract_Start_Date__c=Date.today(); 

                            //code to reset the xref id fields for Procurement amendment records                                
                            agr.CLM_XREF_ID__c=NULL;
                            }
      
      
      
      // code for the parent agreement to retain its status category/status value after Amendment record is created.
      
      
          if(agr.Apttus__Status__c=='Being Amended'|| agr.Apttus__Status__c=='Being Renewed' || agr.Apttus__Status__c=='Being Terminated'|| agr.Apttus__Status__c=='Superseded')
                  {
                  
                  agr.Apttus__Status_Category__c=Trigger.oldmap.get(agr.id).Apttus__Status_Category__c;  
                  agr.Apttus__Status__c=Trigger.oldmap.get(agr.id).Apttus__Status__c; 

                  
                  }    
                  
    
                     
  
  //Naming convention for the different record types.
 
 If((agr.Name==NULL || agr.Name==RT_Map.get(agr.recordTypeID).Name || agr.Name==String.valueOf(agr.Id) || agr.Name==String.valueOf(agr.Id).left(15)))
 {
        
  If((!String.isBlank(String.valueOf(accountsMap.get(agr.id)))))
   {
     If(RT_Map.get(agr.recordTypeID).DeveloperName.containsIgnoreCase('Procurement_Agreements'))
      {
             if(Date.Today().month()>9) 
                 agr.Name='PROC'+' '+String.valueOf(accountsMap.get(agr.id).Apttus__Account__r.Short_Name__c).capitalize()+' '+Date.Today().year()+' '+Date.Today().month();
             else
                 agr.Name='PROC'+' '+String.valueOf(accountsMap.get(agr.id).Apttus__Account__r.Short_Name__c).capitalize()+' '+Date.Today().year()+' '+'0'+Date.Today().month();         
         
         
      }
      else if(RT_Map.get(agr.recordTypeID).DeveloperName.containsIgnoreCase('Finance_Treasury_Agreements'))   
      {
         
             if(Date.Today().month()>9) 
                 agr.Name='FIN'+' '+String.valueOf(accountsMap.get(agr.id).Apttus__Account__r.Short_Name__c).capitalize()+' '+Date.Today().year()+' '+Date.Today().month();
             else
                 agr.Name='FIN'+' '+String.valueOf(accountsMap.get(agr.id).Apttus__Account__r.Short_Name__c).capitalize()+' '+Date.Today().year()+' '+'0'+Date.Today().month();         
         
         
      } 
      
      else if(RT_Map.get(agr.recordTypeID).DeveloperName.containsIgnoreCase('Legal_Agreements'))   
      {
         
             if(Date.Today().month()>9) 
                 agr.Name='LEGAL'+' '+String.valueOf(accountsMap.get(agr.id).Apttus__Account__r.Short_Name__c).capitalize()+' '+Date.Today().year()+' '+Date.Today().month();
             else
                 agr.Name='LEGAL'+' '+String.valueOf(accountsMap.get(agr.id).Apttus__Account__r.Short_Name__c).capitalize()+' '+Date.Today().year()+' '+'0'+Date.Today().month();         
         
         
      }
      
      else if(RT_Map.get(agr.recordTypeID).DeveloperName.containsIgnoreCase('Sales_Agreements'))   
      {
         
             if(Date.Today().month()>9) 
                 agr.Name='SALES'+' '+String.valueOf(accountsMap.get(agr.id).Apttus__Account__r.Short_Name__c).capitalize()+' '+Date.Today().year()+' '+Date.Today().month();
             else
                 agr.Name='SALES'+' '+String.valueOf(accountsMap.get(agr.id).Apttus__Account__r.Short_Name__c).capitalize()+' '+Date.Today().year()+' '+'0'+Date.Today().month();         
         
         
      }
      
      else if(RT_Map.get(agr.recordTypeID).DeveloperName.containsIgnoreCase('TD_Agreements'))   
      {
        
             if(Date.Today().month()>9) 
                 agr.Name='TD'+' '+String.valueOf(accountsMap.get(agr.id).Apttus__Account__r.Short_Name__c).capitalize()+' '+Date.Today().year()+' '+Date.Today().month();
             else
                 agr.Name='TD'+' '+String.valueOf(accountsMap.get(agr.id).Apttus__Account__r.Short_Name__c).capitalize()+' '+Date.Today().year()+' '+'0'+Date.Today().month();         
         
         
      }
      //Defaulting Name for ITAR Agreements - Ruchi 10012018
      else if(RT_Map.get(agr.recordTypeID).DeveloperName.containsIgnoreCase('IP_Agreements'))   
      {
         
             if(Date.Today().month()>9) 
                 agr.Name='IP'+' '+String.valueOf(accountsMap.get(agr.id).Apttus__Account__r.Short_Name__c).capitalize()+' '+Date.Today().year()+' '+Date.Today().month();
             else
                 agr.Name='IP'+' '+String.valueOf(accountsMap.get(agr.id).Apttus__Account__r.Short_Name__c).capitalize()+' '+Date.Today().year()+' '+'0'+Date.Today().month();         
         
         
      }
      //Defaulting Name for ITAR Agreements - Ruchi 10012018
      else if(RT_Map.get(agr.recordTypeID).DeveloperName.containsIgnoreCase('EDA_Agreements'))   
      {
         
             if(Date.Today().month()>9) 
                 agr.Name='EDA'+' '+String.valueOf(accountsMap.get(agr.id).Apttus__Account__r.Short_Name__c).capitalize()+' '+Date.Today().year()+' '+Date.Today().month();
             else
                 agr.Name='EDA'+' '+String.valueOf(accountsMap.get(agr.id).Apttus__Account__r.Short_Name__c).capitalize()+' '+Date.Today().year()+' '+'0'+Date.Today().month();         
         
         
      }
      //Defaulting Name for ITAR Agreements - DBiswal 05252017
      else if(RT_Map.get(agr.recordTypeID).DeveloperName.containsIgnoreCase(Environment_Variable__c.getInstance('CLM_RTYPE_SAMS_FEDS_AGR').Value__c))   
      {
          if(Date.Today().month()>9) 
              agr.Name='SALES'+' '+String.valueOf(accountsMap.get(agr.id).Apttus__Account__r.Short_Name__c).capitalize()+' '+Date.Today().year()+' '+Date.Today().month();
          else
              agr.Name='SALES'+' '+String.valueOf(accountsMap.get(agr.id).Apttus__Account__r.Short_Name__c).capitalize()+' '+Date.Today().year()+' '+'0'+Date.Today().month();
      }
      else
         {
             
             if(Date.Today().month()>9) 
                 agr.Name='NDA'+' '+String.valueOf(accountsMap.get(agr.id).Apttus__Account__r.Short_Name__c).capitalize()+' '+Date.Today().year()+' '+Date.Today().month();
             else
                 agr.Name='NDA'+' '+String.valueOf(accountsMap.get(agr.id).Apttus__Account__r.Short_Name__c).capitalize()+' '+Date.Today().year()+' '+'0'+Date.Today().month();         
             
         }
     } 
     else
         agr.Name=RT_Map.get(agr.recordTypeID).Name;
         
 }
 
If(values.contains(RT_Map.get(agr.recordTypeID).DeveloperName))
   {      
       continue;
   }    
else
{                
      If(agr.GF_Contract_Start_Date__c==NULL)
      {
          If(agr.GF_Contract_End_Date__c==NULL)
            agr.GF_Contract_End_Date__c=Date.today().addYears(3).addDays(-1);                       
      }      
      else
      { 
          If(agr.GF_Contract_End_Date__c==NULL || 
          (Trigger.oldmap.get(agr.id).GF_Contract_Start_Date__c<>Trigger.newmap.get(agr.id).GF_Contract_Start_Date__c  &&
           Trigger.oldmap.get(agr.id).GF_Contract_End_Date__c==Trigger.newmap.get(agr.id).GF_Contract_End_Date__c)) 
             agr.GF_Contract_End_Date__c=agr.GF_Contract_Start_Date__c.addYears(3).addDays(-1);           
      } 
 }  
   
 } 
    
  
  
  delete DelAttachAndAgrDocProcAmend;
 
       
} 
  
  
        
   if(Trigger.isAfter)
   { 
       
    //POPULATE LIST WITH AGREEMENT IDS BEING INSERTED/UPDATED    
    for(Apttus__APTS_Agreement__c agreement:Trigger.NEW)
    {
              
            //only when there is change of status are the records processed.
            if((Trigger.oldmap.get(agreement.id).Apttus__Status_Category__c <> Trigger.newmap.get(agreement.id).Apttus__Status_Category__c) ||
               (Trigger.oldmap.get(agreement.id).Apttus__Status__c<> Trigger.newmap.get(agreement.id).Apttus__Status__c))       
                ids.add(agreement.Id);
    }
    
    
    
    //GRAB AGREEMENT INFORMATION
    List<Apttus__APTS_Agreement__c> full = [select id, Apttus__Account__r.Short_Name__c,Apttus__Status_Category__c,Apttus__Status__c,
    Purpose__c, Apttus__FF_Agreement_Number__c, Type__c, Geometries__c,
    Apttus__Contract_Start_Date__c,Apttus__Contract_End_Date__c,
    GF_Contract_Start_Date__c,GF_Contract_End_Date__c,
    Apttus__Requestor__r.FirstName, Apttus__Requestor__r.LastName, Apttus__Requestor__r.HCM_Login_ID__c,
    Reviewer__r.FirstName, Reviewer__r.LastName, Reviewer__r.HCM_Login_ID__c   
    from Apttus__APTS_Agreement__c where id in :ids];
    
    
    
    //GRAB ALL THE RELATED SIGNATORIES
    List<Signatory__c> existingSigs = [select id, Account__c, Agreement__c, Account__r.Short_Name__c, Account__r.Name,
    Account_Street__c,Account_Street_2__c,Account_Street_3__c,Account_Street_4__c,
    Account_City__c, Account_State__c, Account_Country__c
    from Signatory__c 
    where agreement__c in :ids];

    //POPULATE MAP OF ALL RELATED SIGNATORIES   
    for(Signatory__c s: existingSigs)
    {
         sigList = agreementSignatories.get(s.Agreement__c);
         if(sigList == null)
         {
             sigList = new List<Signatory__c>();
             agreementSignatories.put(s.Agreement__c,sigList);
         }
         sigList.add(s);
    }
    
   
     
     
     
    NDA_NDA nda = null;
    
    Set<Apttus__APTS_Agreement__c> ToSkipVoidAgr=new Set<Apttus__APTS_Agreement__c>();
    
    for(Apttus__APTS_Agreement__c agreement:full)
    {
       if(!((agreement.Type__c == 'Technical NDA')||(agreement.Type__c == 'Non Technical NDA')))
        {
            //SKIP, ONLY PROCESS NDAs
            continue;
        }
        
        sigList = agreementSignatories.get(agreement.Id);
        if(sigList == null)
            continue;
                 
        for(Signatory__c sig:sigList)
        {
            
            
            nda = new NDA_NDA();
            nda.CompanyShortName = sig.Account__r.Short_Name__c;
            nda.AmsCompanyName = sig.Account__r.name;
            nda.TechGeometries = agreement.Geometries__c;
            nda.NdaCompanyName = sig.Account__r.name;
            nda.CompanyAddress = sig.Account_Street__c;
            if(sig.Account_Street_2__c != null){ nda.CompanyAddress += sig.Account_Street_2__c; }
            if(sig.Account_Street_3__c != null){ nda.CompanyAddress += sig.Account_Street_3__c; }
            if(sig.Account_Street_4__c != null){ nda.CompanyAddress += sig.Account_Street_4__c; }
            nda.CompanyAddress += ' ' + sig.Account_City__c + ', ';
            nda.CompanyAddress += sig.Account_State__c + ', ';
            nda.CompanyAddress += sig.Account_Country__c;
            nda.Purpose = agreement.Purpose__c;
            nda.NdaNumber = agreement.Apttus__FF_Agreement_Number__c;
            nda.NdaType = agreement.Type__c;
            
            if(agreement.Apttus__Requestor__r.HCM_Login_ID__c != null){
            
            nda.Originator =  agreement.Apttus__Requestor__r.FirstName + ' ' + agreement.Apttus__Requestor__r.LastName + ' (' + agreement.Apttus__Requestor__r.HCM_Login_ID__c.toLowerCase() + ')';
            nda.Approver = agreement.Reviewer__r.FirstName  + ' ' + agreement.Reviewer__r.LastName + ' (' + agreement.Apttus__Requestor__r.HCM_Login_ID__c.toLowerCase() + ')';
            }
            else{
            nda.Originator =  agreement.Apttus__Requestor__r.FirstName + ' ' + agreement.Apttus__Requestor__r.LastName;
            // + ' (' + agreement.Apttus__Requestor__r.HCM_Login_ID__c.toLowerCase() + ')';
            nda.Approver = agreement.Reviewer__r.FirstName  + ' ' + agreement.Reviewer__r.LastName;
            // + ' (' + agreement.Apttus__Requestor__r.HCM_Login_ID__c.toLowerCase() + ')';
 
            }
            startDate = agreement.GF_Contract_Start_Date__c;
            endDate = agreement.GF_Contract_End_Date__c;
            if(startDate == null)
            {
                startDate = agreement.Apttus__Contract_Start_Date__c;
            }
            if(endDate == null)
            {
               endDate = agreement.Apttus__Contract_End_Date__c;
            }  
              
                  
            nda.ExpiryDate = endDate;
            nda.AgreementDate = startDate;
            nda.ConfidentialityDate = endDate;
        
            try
            {
                if(agreement.Apttus__Status__c == 'Activated')
                {
                    NDA_NDAService.activateNDA(nda.CompanyShortName,nda.AmsCompanyName,nda.TechGeometries,nda.NdaCompanyName,
                    nda.CompanyAddress,nda.Purpose, nda.NdaNumber,nda.NdaType,nda.Originator,
                    nda.Approver,nda.AgreementDate,nda.ExpiryDate,nda.ConfidentialityDate);
                    ToSkipVoidAgr.add(agreement);
                    
                    
                }else if(agreement.Apttus__Status_Category__c=='Expired' || agreement.Apttus__Status__c == 'Expired')
                {
                    NDA_NDAService.expireNDA(nda.NdaNumber);
                    ToSkipVoidAgr.add(agreement);
                    
                    
                }
        
           
            }catch(Exception ex)
            {
                List<ApplicationLogWrapper> alwList=new List<ApplicationLogWrapper>();
            for(Apttus__APTS_Agreement__c a : full )    
            {      
                ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source =GFAgreementActivateController.class.getName();
                alw.sourceFunction ='doActivate()';
                alw.ApplicationName='NDA Management';
                alw.referenceId =a.id;
                alw.referenceInfo='Agreement';
                alw.logMessage ='Error Message='+ex.getMessage()+' At Line Number='+ex.getLineNumber()+' Stack Trace='+ex.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =ex.getTypeName();
                alw.ex=ex.getCause();
                alwList.add(alw);
                  
            }  
            GlobalUtility.logMessage(alwList); 
            }
        
        }
        
        
        
    }
    
    
    
    for(Apttus__APTS_Agreement__c voidAgreement: full)
        {        
              if(ToSkipVoidAgr.contains(voidAgreement)) continue;  
              NDA_NDAService.voidNDA(voidAgreement.Apttus__FF_Agreement_Number__c);
        }
    
    
   

    
    
    }
              

}