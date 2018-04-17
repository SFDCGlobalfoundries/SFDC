/*
    Author: Anirban Roy
    Description: This is the controller extension class for reference flow open text mashup in Proposal Page.
    History: 
        ARoy      07042014    - Apex code created
*/
public class ProposalRefFlowOTMashupController {
    
    // Reference Flow Url
    public String portalLoginUser;
    public Map<String,String> refFlowUrlMap {get; set;}
    public String OpenTextLoginServerURL {get; set;}
    public List<Apttus_Proposal__Proposal_Line_Item__c> propLineItemList {get; set;}
    User userObj = new User();
    
    //Constructor (Extension)
    public ProposalRefFlowOTMashupController(ApexPages.StandardController controller){
        
        String refFlowName='';        
        propLineItemList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        refFlowUrlMap = new Map<String,String>();
        
        // Query the Proposal Line Item
        for(Apttus_Proposal__Proposal_Line_Item__c propLineItem : [select   Id,
                                                                            Apttus_QPConfig__OptionId__r.Name,
                                                                            Apttus_QPConfig__OptionId__r.Description,
                                                                            Apttus_QPConfig__OptionId__r.Family,
                                                                            Apttus_QPConfig__OptionId__r.ProductCode,
                                                                            Apttus_QPConfig__OptionId__r.IP_PT_ID__c
                                                                    from    Apttus_Proposal__Proposal_Line_Item__c
                                                                    where   Apttus_Proposal__Proposal__c =: ApexPages.currentPage().getParameters().get('Id')]){
        
            // Reference Flow Product Family
            if(propLineItem.Apttus_QPConfig__OptionId__r.Family == 'RF' 
                && propLineItem.Apttus_QPConfig__OptionId__r.IP_PT_ID__c != null){
                //refFlowName += propLineItem.Apttus_QPConfig__OptionId__r.ProductCode + '|';
                if (ApexPages.currentPage().getHeaders().get('host').indexOf('globalfoundryview') != -1) {
                    refFlowUrlMap.put(propLineItem.Id,'/GlobalfoundryView/ReferenceFlowDetail?id='+propLineItem.Apttus_QPConfig__OptionId__r.IP_PT_ID__c);
                }else{
                    refFlowUrlMap.put(propLineItem.Id,'/apex/ReferenceFlowDetail?id='+propLineItem.Apttus_QPConfig__OptionId__r.IP_PT_ID__c);
                }
                
                propLineItemList.add(propLineItem);
            }
        }
        
        // Prepare the Open text Reference URL
        /*if(propLineItemList.size() > 0){
            refFlowName = refFlowName.removeEnd('|');
            refFlowUrl = System.Label.Ref_Flow_OpenText_Url + refFlowName;
            // Getting the portal login user
            userObj = [SELECT accountId,FederationIdentifier,Portal_Login__c,UserType FROM User WHERE Id =:userInfo.getUserId()];
            if(userInfo.getusertype()=='CustomerSuccess' || userInfo.getusertype()=='PowerCustomerSuccess')
                portalLoginUser = userObj.Federationidentifier ;   
            else{ 
                portalLoginUser = null;
            } 
            portalLoginUser = userObj.Federationidentifier ; 
            // Prepare the open text server
            OpenTextLoginServerURL = System.Label.OTLoginServer+portalLoginUser;
        }else if(refFlowName == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Error_Codes__c.getInstance('REF_FLOW_EMPTY_ERR_MSG').Message__c));
        }*/
        if(propLineItemList.size() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Error_Codes__c.getInstance('REF_FLOW_EMPTY_ERR_MSG').Message__c));
        }                   
       
    }                     
}