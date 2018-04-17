/**
   @Author <Cognizant Technology Solutions>
   @name <BNP_PromoteToCustomerDecisionCtrl>
   @CreateDate <6/2/2017>
   @Description <Option Stage Moved to Customer Decision>
   @Version <>
   @reference <>
   @Modified by <Arijit : 17/04/2017>
   @Modification Purpose <1. To Stop the Option Stage to go Backward direction>
 */
public class BNP_PromoteToCustomerDecisionCtrl 
{
    
    Tech_Review_Summary__c tr;
    
    public BNP_PromoteToCustomerDecisionCtrl() {
        
    }
    
    public PageReference goToDecision() 
    {
        String trId = ApexPages.currentPage().getParameters().get('trId');
        tr = [select Approval_to_proceed_to_RTM__c, RIT_outlook__c , RTM_outlook__c, Decision__c,
                                                Option__c from Tech_Review_Summary__c where id = :trId];
        if(!tr.Approval_to_proceed_to_RTM__c || tr.RIT_outlook__c == null || tr.RTM_outlook__c == null) 
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'RTM is not approved yet and RTM dates are not filled.');
            ApexPages.addMessage(myMsg);
            return null;
        } 
        else 
        {
            BnP_OptionUtility ctrl = new BnP_OptionUtility();
            //Find Option stage : Condition applied to Stop the Option Stage to go Backward : Arijit - 17/04/2017
            Customer_Requirement__c objoption = new Customer_Requirement__c();
            objoption = [Select Option_Stage__c From Customer_Requirement__c where Id =: tr.Option__c];
            if(objoption.Option_Stage__c == 'Prototype Fulfillment')
            {
                // call generic method to update option stage
                ctrl.updateOptionStages(new List<Id> { tr.Option__c }, 'Customer Decision');
            }
        }
        return new PageReference('/' + tr.Decision__c).setRedirect(true);
    }
    
    public PageReference goToTR() 
    {
        return new PageReference('/' + tr.id).setRedirect(true);
    }
}