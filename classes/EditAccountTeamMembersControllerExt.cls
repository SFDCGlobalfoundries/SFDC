/*
    Author:
    Description: This is a controller extension class for EditAccountTeamMembers page. 
    History:
        ARoy        04292013    - code modified for addition of Fab Assignment column.
        ASolito     05162013    - Add fab assignment required validation for Customer Engineer and Fab Planner
        Nbustillos  08142013    - Updated code to use Environment Variable/Error Codes for hardcoded values.
*/

public class EditAccountTeamMembersControllerExt{
     
     public List<AccountTeamProxyModel> AccountTeamProxyList{get;set;}
     public string contentIds{get;set;}
     public string AccountName{get;set;}
     Map<String, Account_Team_Proxy__c> atpMap = new Map<String, Account_Team_Proxy__c>();
     public class AccountTeamProxyModel{
       public Account_Team_Proxy__c ATP {get;set;}
       public boolean Fabassign {get;set;}
     }
     
    public final ID AcctTeamProxyMemberID;
    public final ID AcctID;
    
    public EditAccountTeamMembersControllerExt(ApexPages.StandardController stdController) {
        
        this.AcctTeamProxyMemberID = stdController.getId();  
        Account_Team_Proxy__c myAcctProxy = [Select id, Account__c from Account_Team_Proxy__c  where id =:AcctTeamProxyMemberID limit 1];
        contentIds = myAcctProxy.Account__c;
        
        
        
        
        AccountTeamProxyList=new List<AccountTeamProxyModel>();
        atpMap = new Map<String, Account_Team_Proxy__c>();
        if(contentIds !=null)
        {
            Account account= [select name from Account where id=:contentIds];
            AccountName=account.name;
             for(Account_Team_Proxy__c acc : [select id,User__c,User__r.Name,User__r.fab_assigned__c,Account__c,Account_Access__c,Opportunity_Access__c,Sequence_No__c,Team_Role__c,Account_Role_ID__c,Flag_for_Delete__c,Fab_Assignment__c from Account_Team_Proxy__c where Account__c =:contentIds]){
                 AccountTeamProxyModel atpMod=new AccountTeamProxyModel();
                    atpMod.ATP=acc;
                    atpMod.Fabassign=true;
                    AccountTeamProxyList.add(atpMod);
             }
         }    
         addNewRow();
   }
    
    public PageReference addNewRow(){
        Account_Team_Proxy__c atpTemp = new Account_Team_Proxy__c();
        AccountTeamProxyModel atpMod=new AccountTeamProxyModel();
        atpMod.ATP=atpTemp;
        atpmod.Fabassign=false;
        AccountTeamProxyList.add(atpMod);
        return null;
    }
    
    public PageReference Save(){
        
       try{
            atpMap = new Map<String, Account_Team_Proxy__c>();
            PageReference acctPage = new PageReference('/'+ contentIds);
            List<Account_Team_Proxy__c> atps = new List<Account_Team_Proxy__c>();
            List<String> currTPIds = new List<String>();
            Map<String,String> userFabs = new Map<String,String>();
            
            //get the user Ids
            for(AccountTeamProxyModel atpl :AccountTeamProxyList){
                currTPIds.add(atpl.ATP.user__c);
            }
            
            //create a map of user and fab assignment
            for(User u: [SELECT id, fab_assigned__c FROM User WHERE id IN: currTPIds]){
                userFabs.put(u.id,u.fab_assigned__c);
            }
            
            for(AccountTeamProxyModel atpl :AccountTeamProxyList)
            {
                if(atpl.ATP.User__c !=null)
                {
                        //validation will show all errors
                        Boolean hasError = false;                       
                         if (atpl.ATP.Account_Access__c==null )
                        {
                            atpl.ATP.addError(Error_Codes__c.getInstance('ACCT_TM_NO_ACCESS_ERROR').Message__c);
                            hasError = true;
                        }
                        
                         if (atpl.ATP.Opportunity_Access__c==null )
                        {
                            atpl.ATP.addError(Error_Codes__c.getInstance('ACCT_TM_NO_OPPTY_ACCESS_ERROR').Message__c);
                            hasError = true;                            
                        }
                         if (atpl.ATP.Team_Role__c==null )
                        {
                            atpl.ATP.addError(Error_Codes__c.getInstance('ACCT_TM_NO_ROLE_ERROR').Message__c);
                            hasError = true;
                        }
                        
                        //added ASOLITO 05/16/2013
                        //check if fab assignment is not null for Customer Engineer and Fab Planner
                        System.debug('test: '+atpl.ATP.user__c+' '+userFabs.get(atpl.ATP.User__c)+' '+(atpl.ATP.Team_Role__c == 'Customer Engineer' || atpl.ATP.Team_Role__c == 'Fab Planner'));
                        if(!UtilsString.isNotBlank(userFabs.get(atpl.ATP.User__c)) &&  (atpl.ATP.Team_Role__c == EnvironmentVariable.get('ACT_TM_PRXY_TM_RL_CE') || atpl.ATP.Team_Role__c == EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_FP'))){
                            atpl.ATP.addError(Error_Codes__c.getInstance('FAB ASSIGNMENT IS REQUIRED').message__c);
                            hasError = true;
                        }                        
                        
                   if(atpl.ATP.Account__c ==null)
                   atpl.ATP.Account__c=contentIds;
                   
                 if(atpl.ATP.Team_Role__c == EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_PAM') || atpl.ATP.Team_Role__c == EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_PCSR') || atpl.ATP.Team_Role__c == EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_BCSR') || atpl.ATP.Team_Role__c == EnvironmentVariable.get('ACCT_TM_PRXY_TM_RL_PFTS')){
                        if (atpMap.containsKey(atpl.ATP.Team_Role__c+atpl.ATP.Account__C))
                        {
                            atpl.ATP.addError('Role and Seq duplicates.');
                            //atpMap = new Map<String, Account_Team_Proxy__c>();
                            hasError = true;
                        } 
                        else
                        {
                            atpMap.put(atpl.ATP.Team_Role__c+atpl.ATP.Account__C, atpl.ATP);
                        }
                 } 
                 
                 //fire validation errors
                 if(hasError){
                     return null;
                 }    
                          
                    atps.add(atpl.ATP);
                }      
            }
            upsert atps;
            return acctPage;
        }catch(Exception e){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());  
           ApexPages.addMessage(myMsg);
        }
        return null;
    }
}