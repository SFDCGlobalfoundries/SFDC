/*
*@ Class:          CustomerSatisfactionCalculateMerit_TriggerHandler
*@ Version:        1.0
*@ Author:         Mallika Seth
*@ Purpose:        This Handler class is handling the events of CustomerSatisfactionCalculateMerit Trigger.
*--------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
public class CustomerSatisfaction_TriggerHandler{

@Testvisible Set <String> Names = new Set<String>();
Set <ID> IDs = new Set<ID>();
String searchqueryCustomerSatisfaction;

List<Customer_Satsfaction__c> lstCSatNew;  
Map <String,Customer_Satsfaction__c> mNamesToCustomerSatisfaction = new Map<String,Customer_Satsfaction__c>(); 
Map <String,Customer_Satsfaction__c> mQscoreToCustomerSatisfaction = new Map<String,Customer_Satsfaction__c>();
List<Customer_Satsfaction__c> CSat = new List<Customer_Satsfaction__c>();


    public CustomerSatisfaction_TriggerHandler(){
    
    }
    
    public void run() {

    // Dispatch to the correct handler method
    if(Trigger.isBefore && (Trigger.isInsert ||  Trigger.isUpdate)) {
     if(Trigger.isExecuting){
     }
      beforeInsertUpdate();
    } 
    }
   
    public void beforeInsertUpdate(){
     List<Customer_Satsfaction__c> lstCSatNew = Trigger.new;
     
        if(lstCSatNew!= Null){
       
         for (Customer_Satsfaction__c CSNew: lstCSatNew)
            {   
                String[] lName = CSNew.Name.split(' ');
                Names.add(lName[0]);
                IDs.add(CSNew.ID);
                mNamesToCustomerSatisfaction.put(lName[0].toLowerCase(),CSNew);  
            }
            
            searchqueryCustomerSatisfaction = 'FIND '+Names+ ' IN ALL Fields RETURNING Customer_Satsfaction__c(ID,Name,Q1_Score__c,Q1__c,Percentage__c order by Name Desc Limit 4)';
            List<List<sObject>> sCustomerSatisfactionList = search.query(searchqueryCustomerSatisfaction );
            Customer_Satsfaction__c[] sCustomerSatisfaction = (Customer_Satsfaction__c[])sCustomerSatisfactionList[0];
            
            for (Customer_Satsfaction__c CSNew: lstCSatNew)
            {     
                for (Customer_Satsfaction__c CS: sCustomerSatisfaction)
                {
                    String[] Name =  CS.Name.split(' ');
                    
                    if (mNamesToCustomerSatisfaction.containsKey(Name[0].toLowerCase()))
                    {
                        if(CSNew.Percentage__c){
                            if(CSNew.Q1__c >CS.Q1__c){CSNew.X4Q_Perf_Trend_Val__c = 'Green';}
                            else if(CSNew.Q1__c < CS.Q1__c) {CSNew.X4Q_Perf_Trend_Val__c = 'Red';}
                            else if(CSNew.Q1__c == CS.Q1__c){CSNew.X4Q_Perf_Trend_Val__c = 'Orange';}
                        } Else if(!CSNew.Percentage__c){
                            if(CSNew.Q1_Score__c >CS.Q1_Score__c){CSNew.X4Q_Perf_Trend_Val__c = 'Green';}
                            else if(CSNew.Q1_Score__c < CS.Q1_Score__c) {CSNew.X4Q_Perf_Trend_Val__c = 'Red';}
                            else if(CSNew.Q1_Score__c == CS.Q1_Score__c){CSNew.X4Q_Perf_Trend_Val__c = 'Orange';}
                        } 
                    }
                }
        }             
    }
    }
  }