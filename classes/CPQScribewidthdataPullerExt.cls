public class CPQScribewidthdataPullerExt {
    
    private Device__c device;
    public Apttus_Config2__ProductAttributeValue__c attributeVal{get;set;}
    public boolean isPrimaryConfiguration{get;set;}
    public CPQScribewidthdataPullerExt(ApexPages.StandardController controller) {
      device = (Device__c)controller.getRecord();
      list<Apttus_Proposal__Proposal__c> lstConfiguration = [select id from Apttus_Proposal__Proposal__c where Device__c = :device.Id AND APTPS_Primary__c = true];
      isPrimaryConfiguration = !lstConfiguration.isEmpty();
      String ProdConfigID  ; 
      if(!lstConfiguration.isEmpty()) {
        list<Apttus_Proposal__Proposal_Line_Item__c> lstApttusProposalLineItem =  [select  id,Apttus_QPConfig__ConfigurationId__c 
                                                                    from    Apttus_Proposal__Proposal_Line_Item__c 
                                                                    where   Apttus_Proposal__Proposal__c =:lstConfiguration[0].Id limit 1];
        
        if(!lstApttusProposalLineItem.isEmpty()) {
          list<Apttus_Config2__ProductAttributeValue__c> lstAttributeVal = [select  id
                                , Name 
                                , Die_Size_X_mm__c
                                , Die_Size_Y_mm__c
                                , Apttus_Config2__LineItemId__r.Apttus_Config2__ConfigurationId__c 
                        FROM Apttus_Config2__ProductAttributeValue__c  
                        WHERE   Apttus_Config2__LineItemId__r.Apttus_Config2__ConfigurationId__c = :lstApttusProposalLineItem[0].Apttus_QPConfig__ConfigurationId__c ];
          
          if(!lstAttributeVal.isEmpty()) {
            attributeVal = lstAttributeVal[0];
          }              
        }  
        
      }
    }

}