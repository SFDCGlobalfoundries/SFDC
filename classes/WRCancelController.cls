/*
Type Name: WRCancelController
Author: Cognizant UCM Team
Created Date: 10thMarch2016
Reason: To close the WorkRequest and adding chattercomment. 
Test Class:
Change History:
Author: 
Modified Date: 
Reason: 
…… ..
……..
*/

public with sharing class WRCancelController {
    public string wrId;
    public string chatterComment{get;set;}
    Public Bug__c wrDetails{get;set;}
    public WRCancelController(ApexPages.StandardController controller) {
        if (wrId == null && ApexPages.currentPage().getParameters().get('Id') != null) {
            wrId = apexpages.currentpage().getparameters().get('id');
            wrDetails = [select id,
                                Name,
                                Status__c,
                                Stages__c,
                                Cancel_Reason__c,
                                IsPLMSubmitted__c,
                                IsTransferToProjectManager__c,
                                IsPLMSolutionSubmitted__c,
                                IsQASubmitted__c,
                                IsPLMSatisfied__c,
                                IsReopenSubmitted__c,
                                IsCancelRequest__c,
                                createdBYId,
                                ownerId
                                from Bug__c where id = : wrId];
        }    
    } 
    public PageReference save(){
        PageReference pr;
        pr = new PageReference('/' + wrId );
        pr.setRedirect(true);
        if(wrDetails.Status__c=='Closed' ||  wrDetails.IsCancelRequest__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'PDK Request already Closed. Please check Approval History for more details.'));
            return null;
        }else{
            if(chatterComment == '' || chatterComment == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Enter Chatter Comment'));
                return null;
            }else{
                try{                        
                    //update WorkRequest;
                    wrDetails.IsCancelRequest__c = true;
                    wrDetails.Stages__c=wrDetails.Cancel_Reason__c+'- Closed';
                    wrDetails.Status__c='Closed';
                    update wrDetails;
                    //Insert Chatter Comment
                    FeedItem feeditemVar = new FeedItem();
                    feeditemVar.parentid = wrDetails.id;
                    string strComment = 'PDK Request Canceled\n Reason: ' + wrDetails.Cancel_Reason__c + '\n Comment: ' + chatterComment;
                    feeditemVar.Body = strComment;
                    insert feeditemVar; 
                    return pr;
                }catch(Exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
                    return null;
                }
            } 
        }
    }
    public PageReference cancel(){
        PageReference pr;
        pr = new PageReference('/' + wrId );
        return pr;        
    }  
}