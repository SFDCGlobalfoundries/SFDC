public class BNP_TechReviewMessageCtrl {
    
    public String message {get; set;}
    String optionId;
    String retURL;
    
    public BNP_TechReviewMessageCtrl() {
        optionId = ApexPages.currentPage().getParameters().get('optionId');
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        message = 'Decision record missing, please create decision from Last Accepted Quote of Option. Click on below button to go to Last Accepted Quote.';
    }
    
    public PageReference goToRFQ() {
        List<Request_Information__c> rfqList = [select id from Request_Information__c where Last_Accepted_Quote__c = true
                            and Quote_Status__c = 'Accept' and Customer_Requirement__c = :optionId limit 1];
        
        if(rfqList != null && rfqList.size() > 0) {
            return new PageReference('/' + rfqList[0].id).setRedirect(true);
        } else {
            message = 'Looks like there is no Quote Accepted yet. Please click Back buton to go back to previous page.';
        }
        return null;
    }
    
    public PageReference goBack() {
        return new PageReference(retURL).setRedirect(true);
    }
}