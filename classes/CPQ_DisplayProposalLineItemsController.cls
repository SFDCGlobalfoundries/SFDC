public without sharing class CPQ_DisplayProposalLineItemsController {

    public Apttus_Proposal__Proposal__c proposalRecord {get; set;}
    public Boolean isTechnologyConfigured {get; set;}
    public Product2 bundleProduct {get; set;}
    public Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>> optionsBySection {get; set;}
    public List<String> listofSections {get; set;}
    public CPQ_DisplayProposalLineItemsController(ApexPages.StandardController controller) {
        isTechnologyConfigured = false;
        if(controller.getId() == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Proposal Id is missing.'));
            return;
        }
		if(!Test.isRunningTest()){
			controller.addFields(new List<String>{'Id','Name','Mask_Set_Long__c'});
		}
		proposalRecord = (Apttus_Proposal__Proposal__c) controller.getRecord();
        
        List<Apttus_Proposal__Proposal_Line_Item__c> lstProposalLineItems =[Select Option_Section_Name_Static__c, Option_Name_Static__c, Option_Model_Name_Static__c, Option_Mask_Sets_Static__c, Option_Product_Family_Static__c, Option_Product_ExternalId_Static__c, Option_IP_Device_List_Static__c, Option_IP_DesignKit_Version_Static__c, Apttus_Proposal__Product__c 
        from Apttus_Proposal__Proposal_Line_Item__c 
        where Apttus_Proposal__Proposal__c = :proposalRecord.Id AND Option_Product_Family_Static__c != 'Mask Layers' 
        Order By  Option_Section_Name_Static__c, Option_Name_Static__c];
        
        if(lstProposalLineItems != null && lstProposalLineItems.size() >0 && lstProposalLineItems.get(0).Apttus_Proposal__Product__c != null){
            bundleProduct = [Select Name, Description, PT_Number__c, Geometry__c, Mask_Sets__c, Product_External_ID__c from Product2 where Id = : lstProposalLineItems.get(0).Apttus_Proposal__Product__c ].get(0); 
            isTechnologyConfigured = true;
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Technology is not configured or finalised for Configuration '+proposalRecord.Name));
            return;
        }
        listofSections = new List<String>();
        optionsBySection = new Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>>();
        for(Apttus_Proposal__Proposal_Line_Item__c pli : lstProposalLineItems){
            if(String.isBlank(pli.Option_Section_Name_Static__c)) 
                continue;
            if(pli.Option_Product_Family_Static__c != 'IPs'){
                if(optionsBySection.containsKey(pli.Option_Section_Name_Static__c))
                    optionsBySection.get(pli.Option_Section_Name_Static__c).add(pli); 
                else{
                    optionsBySection.put(pli.Option_Section_Name_Static__c, new List<Apttus_Proposal__Proposal_Line_Item__c>{pli});
                    listofSections.add(pli.Option_Section_Name_Static__c);
                }
            }
        }
    }
}