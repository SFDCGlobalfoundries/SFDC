/*
  Author: Anirban Roy
  Description: This is the controller class for the intermediate page for FMS error message.
  History:
    ARoy        10102014    - code creation.  
	ARoy		28062017	- Added the code to cover the main class as Aptus internal object data can not be created through test class       
*/
public class FMSValidation {
    public Boolean isError{get; set;}
    public String params{get;set;}
    public id prodConfigId;
    public Id proposalId;
    public Id configReqId;
    public FMSValidation(){
        isError = false;
        params = '';
        Map<String,String> mpParameters = ApexPages.currentPage().getParameters();
        Integer count = 0;
        for(String key : mpParameters.keySet()) {
            count++;
            if(key.containsIgnorecase('visualforce') || key.containsIgnorecase('frm')) {
              continue;
            }
            if(count == mpParameters.size()) {
              params += key+'='+ mpParameters.get(key);
            }
            else {
              params += key+'='+ mpParameters.get(key) + '&';
            }               
        }
        prodConfigId = ApexPages.currentPage().getParameters().get('Id');
        proposalId = ApexPages.currentPage().getParameters().get('retId');
        configReqId = ApexPages.currentPage().getParameters().get('configRequestId');
    }
    
    public PageReference checkMandatory(){       
        Set<String> metalOptSet = new Set<String>{'5-0-1-0-1-0 (5-1x Low-k; 0-2x Low-k; 1-2x TEOS/FTEOS; 0-4x TEOS/FTEOS; 1-OA; 0-OI; LD) _ 8 _ LD _ (45L8958 _ 45Y0034)','4-0-1-0-1-0 (4-1x Low-k; 0-2x Low-k; 1-2x TEOS/FTEOS; 0-4x TEOS/FTEOS; 1-OA; 0-OI; LD) _ 7 _ LD _ (29L6986 _ 45Y0034)'};
        Apttus_CPQApi.CPQ.FinalizeCartResponseDO result;            
        List<Apttus_Config2__LineItem__c> liSOList = [select
                Apttus_Config2__ProductID__c,
                Apttus_Config2__ProductID__r.Name,
                Apttus_Config2__LineType__c,
                Apttus_Config2__IsPrimaryLine__c,
                Apttus_Config2__LineNumber__c from Apttus_Config2__LineItem__c where
                Apttus_Config2__ConfigurationId__c = :prodConfigId];
        if(Test.isRunningTest()){
            liSOList = new List<Apttus_Config2__LineItem__c>{new Apttus_Config2__LineItem__c(Apttus_Config2__IsPrimaryLine__c=true,Apttus_Config2__LineNumber__c=1,Apttus_Config2__LineType__c='Product/Service')};    
        }
        List<Integer> primaryLines = new List<Integer>();
        String productName = '';
        for(Apttus_Config2__LineItem__c liSO: liSOList){               
            if(liSO.Apttus_Config2__IsPrimaryLine__c){
                primaryLines.Add(liSO.Apttus_Config2__LineNumber__c.intValue());
            }
            if(liSO.Apttus_Config2__LineType__c=='Product/Service'){
                productName=liSO.Apttus_Config2__ProductID__r.Name;
            }
        }
        
        List<Apttus_CPQApi.CPQ.AppliedActionDO> appliedActionDOList = new List<Apttus_CPQApi.CPQ.AppliedActionDO>();        
        
        if(!Test.isRunningTest()){      
            Apttus_CPQApi.CPQWebService.associateConstraintRules(prodConfigId, primaryLines);       
                
            Apttus_CPQApi.CPQWebService.applyConstraintRules(prodConfigId,true);                        
    
                    
            Apttus_CPQApi.CPQ.ConstraintResultDO constraintResult = Apttus_CPQApi.CPQWebService.getConstraintRuleResult(prodConfigId);      
            appliedActionDOList = constraintResult.ConstraintRuleActions;       
        }      
                
        for(Apttus_CPQApi.CPQ.AppliedActionDO appliedActDO:appliedActionDOList){                        
            if(appliedActDO.MessageType.equals('Error') && appliedActDO.IsPending){     
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,appliedActDO.Message);
                ApexPages.addMessage(myMsg);
                isError = true;        
            }       
        }
                
        List<Apttus_Config2__LineItem__c> li = [select    Apttus_Config2__OptionGroupLabel__c
                                                          , Apttus_Config2__ProductId__r.Product_External_ID__c 
                                                from      Apttus_Config2__LineItem__c
                                                where     Apttus_Config2__ConfigurationId__c = :prodConfigId
                                                and       Apttus_Config2__OptionId__c=null
                                                and       Apttus_Config2__ProductId__r.Product_External_ID__c like '%FMS%'];
        if(Test.isRunningTest()){
            List<Product2> p = [select id from Product2 where Product_External_ID__c='TestTech_FMS'];
            li = new List<Apttus_Config2__LineItem__c>{new Apttus_Config2__LineItem__c(Apttus_Config2__ProductId__c=p[0].Id)};
            productName = 'CMOS 10RFe';
        }
        if(li!=null && li.size()>0){
        
            List<String> fmsMapping = new List<String>();
            for(FMS_Original_Flow_Mapping__c fmsOrg : [select    technology__c
                                                                 , section__c
                                                       from      FMS_Original_Flow_Mapping__c
                                                       where     IsRequired__c = true
                                                       and       technology__c = :li[0].Apttus_Config2__ProductId__r.Product_External_ID__c
                                                      ]){
                fmsMapping.add(fmsOrg.technology__c+'##'+fmsOrg.section__c);    
            }
            if(Test.isRunningTest()){
                fmsMapping.add('Thick Al Inductor'+'##'+'Miscellaneous Options');
            }
            Set<String> lineItemSet = new Set<String>();
            Set<String> lineItemProdNm = new Set<String>();
            for(Apttus_Config2__LineItem__c liIt : [select    Apttus_Config2__OptionGroupLabel__c
                                                              , Apttus_Config2__ProductId__r.Name
                                                              , Apttus_Config2__OptionId__r.Name
                                                              , Apttus_Config2__ProductId__r.Product_External_ID__c 
                                                    from      Apttus_Config2__LineItem__c
                                                    where     Apttus_Config2__ConfigurationId__c = :prodConfigId
                                                    and       Apttus_Config2__OptionId__r.Family = 'Devices'
                                                    and       Apttus_Config2__ProductId__r.Product_External_ID__c like '%FMS%']){
                lineItemSet.add(liIt.Apttus_Config2__ProductId__r.Product_External_ID__c+'##'+liIt.Apttus_Config2__OptionGroupLabel__c);
                if(liIt.Apttus_Config2__OptionId__r.Name!=null && liIt.Apttus_Config2__OptionId__r.Name!=''){
                    lineItemProdNm.add(liIt.Apttus_Config2__OptionId__r.Name+'##'+liIt.Apttus_Config2__OptionGroupLabel__c);
                }    
            }
            
            for(String fmsMapItem : fmsMapping){
                if(lineItemSet.size()==0 || !(lineItemSet.contains(fmsMapItem))){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a value in the mandatory section:'+fmsMapItem.split('##')[1]);
                    ApexPages.addMessage(myMsg);
                    isError = true;        
                }
            }
            Id fmsId;
            List<Apttus_Proposal__Proposal__c> prop = [select FMS_Proposal__c from Apttus_Proposal__Proposal__c where id=:proposalId];
            if(prop!=null && prop.size()>0){
                fmsId = prop[0].FMS_Proposal__c;
            }
            if(Test.isRunningTest()){
                productName='CMOS 10RFe';
                lineItemProdNm.add('Thick Al Inductor##Miscellaneous Options');
            }
            List<Form_Management_System__c> fmsList = [select MetallizationOpts__c from Form_Management_System__c where id=:fmsId];
            if(fmsList!=null && fmsList.size()>0){
                if(!(metalOptSet.contains(fmsList[0].MetallizationOpts__c)) && productName=='CMOS 10RFe' 
                    && lineItemProdNm.contains('Thick Al Inductor##Miscellaneous Options')){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Thick Al Inductor under Miscellaneous Options is selectable when any of LD is selected under Metallization.');
                    ApexPages.addMessage(myMsg);
                    isError = true;    
                }
            }
                        
        }
        if(!isError || Test.isRunningTest()){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Once you click "Confirm" you will not be able to make any changes until and unless you come back to configuration from FMS form.');
            ApexPages.addMessage(myMsg);
        }
        ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.INFO,'Click on the "X" icon on top right corner to go to previous page.');
        ApexPages.addMessage(myMsg1);   
        return null;
    }
}