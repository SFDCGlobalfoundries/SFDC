/*Author: Sujit - Cognizant 
* Description: This class is created to associate a Case record 
                to Bug recod using CaseBugAssociation object. 
* History: Created on 3/14/2014
Change History:
Monalisa Mohapatra. Case no-:52792 
*/

public class CaseBugAssociationController {
    public ApexPages.standardController sController = null;
    public CaseBugAssociation__c objCaseBug;
    private String queryString;

    public CaseBugAssociationController(ApexPages.StandardController controller) {
        if(controller!=null){
            sController = controller;
            objCaseBug = (CaseBugAssociation__c)controller.getRecord();
    
            List < string > pageUrl = ApexPages.currentPage().getUrl().split('\\?');
            queryString = pageUrl[1];
        }
    }

    //Method redirects to new bug creation page.
    public Pagereference SaveAndNew() {
        Pagereference pgRef;
        try {
            // Save the current sObject  
            if(sController!=null){
                //sController.save();
                objCaseBug = (CaseBugAssociation__c)sController.getRecord();
                //Modified by <Monalisa Mohapatra> Case #00052792 � Start
                //insert objcaseBug;
                upsert objcaseBug;
                //Modified by <Monalisa Mohapatra> Case #00052792 � End
                // Get the Meta Data for CaseBugAssociation__c 
                Schema.DescribeSObjectResult describeResult = sController.getRecord().getSObjectType().getDescribe();
                // Create PageReference for creating a new sObject and add any inbound query string parameters.  
                pgRef = new PageReference('/' + describeResult.getKeyPrefix() + '/e?' + queryString);
                // Don't redirect with the viewstate of the current record.  
                pgRef.setRedirect(true);
            }
            return pgRef;
        } catch (Exception e) {
            // Don't redirect if something goes wrong. May be a validation or trigger issue on save.
            if(e.getmessage().contains('duplicate'))
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Bug is already associated to the case'));
            else
                ApexPages.addMessages(e);
            return null;
        }
    }

    //Method associates existing bug to the case and 
    //redirects to the case detail page.
    public Pagereference Save() {
        Pagereference pgRef;
        try {
            // Save the current sObject  
            if(sController!=null){
                //sController.save();
                // Get the Meta Data for CaseBugAssociation__c 
                objCaseBug = (CaseBugAssociation__c)sController.getRecord();
                //Modified by <Monalisa Mohapatra> Case #00052792 � Start
                //insert objcaseBug;
                upsert objCaseBug;
                //Modified by <Monalisa Mohapatra> Case #00052792 � End
                // Create PageReference for creating a new sObject and add any inbound query string parameters.  
                if (ApexPages.currentPage().getParameters().get('saveURL') != null) {
                    pgRef = New Pagereference(ApexPages.currentPage().getParameters().get('saveURL'));
                } else {
                    pgRef = New ApexPages.StandardController(objCaseBug).view();
                }
            }
            return pgRef;
        } catch (Exception e) {
            // Don't redirect if something goes wrong. May be a validation or trigger issue on save.
             if(e.getmessage().contains('duplicate'))
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Bug is already associated to the case'));
            else
                ApexPages.addMessages(e);
            return null;
        }
    }
}