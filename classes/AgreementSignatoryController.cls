public class AgreementSignatoryController {
    //capture the agreement id
    public Id thisAgrementId {get;set;}
    //a list of all the Accounts for the associated Agreement
    public List<Signatory__c> listofAccts = new List<Signatory__c>();
    
    public List<Signatory__c> getListOfAccts() {
        //criteria for signatory
        
        listofAccts  = [Select s.Id, s.Contact__r.Name, 
                            s.Contact__c, s.Agreement__c, s.Agreement_Type__c, 
                            s.Account__r.Name, s.Account__c From Signatory__c s
                            Where s.Agreement__c = :thisAgrementId];
          
        return listofAccts  ;    
    }
    
  
}