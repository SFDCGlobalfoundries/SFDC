/*
  Author: Ariz Solito
  Description: Controller class for IBMOpportunity
  History:
    ASolito         03172015    - code creation.
*/
public class IBMOpportunityCntrlr {
    public Opportunity oppty {get; set;} 
    public Boolean isEdit {get; set;}   
    
    public IBMOpportunityCntrlr(ApexPages.StandardController stdController) {        
        if(!Test.isRunningTest()){
            stdController.addFields(new List<String>{'accountid'});  
        }
        
        this.oppty = (Opportunity)stdController.getRecord(); 
        this.isEdit = ApexPages.currentPage().getParameters().get('retURL') <> null ? 
                      true :
                      false;                                    
    }

    //Method will check if opportunity's account is IBM or not
    public PageReference redirect(){
        PageReference pageRef;
        
        for(Account a: [SELECT recordtype.name 
                          FROM Account 
                          WHERE id = :this.oppty.accountid]){
            if(a.recordtype.name <> 'IBM Account'){  
                String retUrl = ApexPages.currentPage().getParameters().get('retURL');
                
                if(UtilsString.isNotBlank(retUrl)){
                    pageRef = new PageReference('/' + this.oppty.id + '/e?retURL= '+ retUrl + '&nooverride=1');
                    pageRef.setRedirect(true);
                } else {
                    pageRef = new PageReference('/' + this.oppty.id + '?nooverride=1');
                    pageRef.setRedirect(true);
                }
            }                          
        }                          
        return pageRef;
    }
}