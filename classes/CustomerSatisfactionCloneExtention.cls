/*************************************************************************************************************************************************************
@ Class:          CustomerSatisfactionBarChartExtention
@ Version:        1.0
@ Author:         Sandesh Singh
@ Purpose:        Helper class to clone parent and its children sObjects
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 24.08.2017 / Sandesh Singh / Created the class.
                : 06.02.2018 / Sandesh Singh / Line 80 To display Merit Index in clone section where user can have flexiblity to chnage Merit Index 
                                             /Added by Customer Satisfaction 2.4 enhancment
**************************************************************************************************************************************************************/

public without sharing class CustomerSatisfactionCloneExtention {
    public String sObjectId {get;set;}
    public Customer_Satsfaction__c customerSat {get;set;}
    
    public CustomerSatisfactionCloneExtention(ApexPages.StandardController controller){
        customerSat = new Customer_Satsfaction__c();
        if (!Test.isRunningTest())
        	controller.addFields(new List<String>{'Merit_Index_for_customers__c','Customer_Satisfaction_yearly_score__c','Quarter_New__c','Score_Year__c'});
        sObjectId = controller.getId();
        customerSat = (Customer_Satsfaction__c)controller.getRecord();
        
        //customerSat.id = sObjectId;
    }
   
    private Boolean isRecordDuplicate(){
        Set<String> setUniqueCheck = new Set<String>();
        for(Customer_Satsfaction__c cs : [Select Id, Name, Quarter_New__c,Score_Year__c, Merit_Index_for_customers__r.Account__r.Name,
                                          Customer_Satisfaction_yearly_score__c
                                          From Customer_Satsfaction__c
                                          Where Merit_Index_for_customers__c =:customerSat.Merit_Index_for_customers__c])
        {
            if(setUniqueCheck.contains(cs.Merit_Index_for_customers__r.Account__r.Name  + ' ' + customerSat.Quarter_New__c + ' ' + customerSat.Score_Year__c)){
            	return true;
            }
            else{
            	setUniqueCheck.add(cs.Merit_Index_for_customers__r.Account__r.Name + ' ' + cs.Quarter_New__c + ' ' + cs.Score_Year__c);
            }
        }
        return false;
    }
    
    /**
    * @description Clone parent and its children
    * @param id of the parent sObject
    * @return String Serialized result
    */
    public PageReference cloneRecord () {
        List<Customer_Satsfaction__c> parentSObjects;
        Customer_Satsfaction__c parent;
        CustomerSatisfaction__c envObj;
        List<Next_QBR__c> children = new List<Next_QBR__c>();
        
		// Parent query
        String query = String.format(
            'SELECT {0} FROM {1} WHERE Id = \'\'{2}\'\'',
            new String[] {
                String.join(
                    new List<String>(
                        Customer_Satsfaction__c.SObjectType.getDescribe().fields.getMap().keySet()
                    ),
                    ','
                ),
                String.valueOf(Customer_Satsfaction__c.SObjectType),
                sObjectId
           }
        );
        try {
            // Query and gets results
            parentSObjects = Database.query(query); 
            
            // Clone the original object. Here you can change anything without affecting the original sObject
            parent = parentSObjects[0].clone(false, true, false, false);
            String s1 = parent.Name;
			String s2 = s1.substringBefore(' ');
            
            system.debug('--isRecordDuplicate--' + isRecordDuplicate());
            if(isRecordDuplicate()){
                envObj = CustomerSatisfaction__c.getValues('Customer_Satisfaction_Clone_Error');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, envObj.Value__c));
                PageReference page = new PageReference('/apex/CustomerSatisfactionClone?id='+ sObjectId);
                return page;                                                                              
             }
            
            //To display Merit Index in clone section where user can have flexiblity to chnage Merit Index 
            //Added by Customer Satisfaction 2.4 enhancment
            parent.Merit_Index_for_customers__c = customerSat.Merit_Index_for_customers__c;
            parent.Quarter_New__c = customerSat.Quarter_New__c;
            parent.Score_Year__c = customerSat.Score_Year__c;
            parent.Name = s2 + ' ' + customerSat.Score_Year__c + ' ' + customerSat.Quarter_New__c;
            parent.Customer_Satisfaction_Unique_Check__c = '';
            parent.Dissatisfaction_Report_Date__c = Date.Today();
            Database.insert(parent);
       
        } catch (DmlException error) {
            envObj = CustomerSatisfaction__c.getValues('Customer_Satisfaction_Clone_Error');
            GlobalUtility.logMessage('Error','CustomerSatisfactionCloneExtention','cloneRecord','',envObj.Value__c,String.valueof(error.getMessage()),'','Customer Satisfaction',error,0);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, envObj.Value__c));
            ApexPages.addMessages(error);
            PageReference page = new PageReference('/apex/CustomerSatisfactionClone?id='+ sObjectId);
            return page; 
        }
        // Children query  
        query = String.format(
            'SELECT {0} FROM {1} WHERE Customer_Satisfaction__c = \'\'{2}\'\'',
            new String[] {
                String.join(
                    new List<String>(
                        Next_QBR__c.SObjectType.getDescribe().fields.getMap().keySet()
                    ),
                    ','
                ),
                String.valueOf(Next_QBR__c.SObjectType),
                sObjectId
           }
        );
        
        try {
            
            // Query and clone the children. Here you can change anything without affecting the original sObject
            for (Next_QBR__c child:(List<Next_QBR__c>)Database.query(query)) {
                children.add(child.clone(false,true,false,false));
            }
			// Set the parent's Id
            for (Next_QBR__c child : children) {
                child.Customer_Satisfaction__c = parent.Id;
                child.Order__c = child.Order__c;
            }
            Database.insert(children);
            
        }  catch(DMLException error) {
            envObj = CustomerSatisfaction__c.getValues('Customer_Satisfaction_Child_Error'); 
            GlobalUtility.logMessage('Error','CustomerSatisfactionCloneExtention','cloneRecord','',envObj.Value__c,String.valueof(error.getMessage()),'','Customer Satisfaction',error,0);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, envObj.Value__c));
            ApexPages.addMessages(error);
            PageReference page = new PageReference('/apex/CustomerSatisfactionClone?id='+ sObjectId);
            return page; 
        }
        PageReference page = new PageReference('/'+ parent.Id + '/e?retURL=%2F'+ parent.Id);
        return page;
    }
}