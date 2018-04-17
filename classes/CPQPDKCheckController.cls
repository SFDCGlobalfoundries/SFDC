/***********************************************************************************************************
Class:         CPQPDKCheckController 
-----------------------------------------------------------------------------------------------------------------------------------------------
Author:        Nkhil Bajaj
CPQ case       00069737
Created Date:  23/Aug/2017
Reason:        Controls the PDK version updation notification when user click on configBom button in configuration page.  
***********************************************************************************/

public class CPQPDKCheckController {

    public String msg {get;set;}
    Public Boolean flag{set;get;}
    public Apttus_Proposal__Proposal__c proposal;
    public String oldPDK{set;get;}
    Public String newPDK{Set;get;}
    Public Id CurrentPageId =ApexPages.currentPage().getParameters().get('id');
    Public String Gflow=ApexPages.currentPage().getParameters().get('flow');
    Public String Name=ApexPages.currentPage().getParameters().get('prodscope_1');
   
    //Method checking PDK version 
    public PageReference CheckPDK() {
        proposal = [select PDK_Version__c from Apttus_Proposal__Proposal__c where id=:CurrentPageId];  
        flag= false; 
        
        
                                                            
        for(Apttus_Proposal__Proposal_Line_Item__c lineItem : [select Apttus_Proposal__Product__r.PDK_Version__c
                                                                from    Apttus_Proposal__Proposal_Line_Item__c 
                                                                where   Apttus_QPConfig__ConfigurationId__r.Apttus_QPConfig__Proposald__c = :CurrentPageId 
                                                               AND Apttus_Proposal__Product__c <> '' AND Apttus_Proposal__Product__r.Apttus_Config2__ConfigurationType__c = 'Bundle'
                                                              order by Apttus_QPConfig__PrimaryLineNumber__c Limit 1
                                                               ]){
               
               
            if(lineItem.Apttus_Proposal__Product__r.PDK_Version__c != null && lineItem.Apttus_Proposal__Product__r.PDK_Version__c <> '' && proposal.PDK_Version__c != null &&proposal.PDK_Version__c != '' && proposal.PDK_Version__c <> lineItem.Apttus_Proposal__Product__r.PDK_Version__c){
              
                 msg= 'Please note that,Configuration DM rev is updated from Rev '+proposal.PDK_Version__c+' to Rev '+lineItem.Apttus_Proposal__Product__r.PDK_Version__c;                  
                 
                flag=true;
                break;
             }    
          }
         if(!flag){ 
             PageReference PageRef= RedirectToCart();
             return PageRef;
          }
        return null;
    }
    
     public PageReference RedirectToCart() {
         PageReference pageRef = Page.Apttus_QPConfig__ProposalConfiguration;
         pageRef.getParameters().put('id',proposal.Id);
         pageRef.getParameters().put('flow',Gflow);
         if(Name !=null){
             pageRef.getParameters().put('prodscope_1',Name);
          }
         return PageRef;
      }
}