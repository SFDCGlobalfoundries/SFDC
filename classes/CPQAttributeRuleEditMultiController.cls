/**
*   Author: Prosenjit Saha
*   Description: This is the test class for following class:
*                - CPQAttributeRuleCreateMulti
*   History:
*       PSaha          06022015     - code creation.
*     
**/
public class CPQAttributeRuleEditMultiController{
    public List<SelectOption>  PublicAttributeGroupNameList {get; set; }
    public List<SelectOption>  PublicAttributeFieldList {get; set; }
    public string MLGID {get;set;}
    public boolean AttValue {get;set;}
    public boolean PickValue {get;set;}
    public Attribute_Rule__c record {get;set;}
    public List<AttributeWrapper> AttributeWrapList {get;set;}
    
    public class AttributeWrapper{
        public String AttributeGroupName{get; set;}
        public List<SelectOption>  AttributeGroupNameList {get; set; }
        public String AttributeField {get; set;}
        public List<SelectOption>  AttributeFieldList {get; set; }
        public string AttributeFieldValue {get;set;}
        public String MaskLayers {get;set;}
        public String FieldValue {get; set;}
    }
    
    public CPQAttributeRuleEditMultiController(ApexPages.StandardController controller) {
        AttributeWrapList = new List<AttributeWrapper>();
        
        //)controller.getRecord();
        AttValue = false;
        PickValue  = false ; 
        PublicAttributeGroupNameList = new List<SelectOption> ();
        if(ApexPages.currentPage().getParameters().containsKey('retURL')){
            MLGID = ApexPages.currentPage().getParameters().get('retURL');
            system.debug('returl**'+MLGID );
            MLGID = MLGID.contains('/GlobalfoundryView/') ? MLGID.removeStart('/GlobalfoundryView/') : MLGID.indexOf('/') == -1? MLGID.substring(0,15) : MLGID.substring(1,16);
            record = new Attribute_Rule__c(CPQ_MLGPLUS__c = MLGID);
            PublicAttributeGroupNameList.add(new SelectOption('none', '--None--'));
            for(Apttus_Config2__ProductAttributeGroupMember__c grpmem : [select id
                                                                                , name
                                                                                , CPQ_MLGPLUS__c 
                                                                                , Apttus_Config2__AttributeGroupId__c
                                                                         from   Apttus_Config2__ProductAttributeGroupMember__c
                                                                         where  CPQ_MLGPLUS__c = :MLGID ]){
                PublicAttributeGroupNameList.add(new SelectOption(grpmem.Apttus_Config2__AttributeGroupId__c, grpmem.name));
            }
            PublicAttributeFieldList = new List<SelectOption>(); 
            PublicAttributeFieldList.add(new SelectOption('none', '--None--'));
            for(Apttus_Config2__ProductAttribute__c PAtt :  [SELECT    id
                                                                       , Apttus_Config2__AttributeGroupId__c
                                                                       , Apttus_Config2__Field__c
                                                             FROM      Apttus_Config2__ProductAttribute__c]){
                    PublicAttributeFieldList.add(new SelectOption(PAtt.Apttus_Config2__Field__c, PAtt.Apttus_Config2__Field__c));    
            } 
            getNewAttibuteRow(); 
        }
        
    }
    
    public void getNewAttibuteRow(){
        AttributeWrapper tempWrap = new AttributeWrapper();
            tempWrap.AttributeGroupNameList = new List<SelectOption>();
            tempWrap.AttributeFieldList = new List<SelectOption>();
            tempWrap.AttributeGroupNameList.addAll(PublicAttributeGroupNameList) ; 
            tempWrap.AttributeFieldList.addAll(PublicAttributeFieldList);
            tempWrap.AttributeGroupName = '--None--' ;
        AttributeWrapList.add(tempWrap);
    }
        
    public pagereference saveAtt(){
        integer Count  = 1; 
        List<Attribute_Rule__c > listWrap = new List<Attribute_Rule__c >();
        List<Attribute_Rule__c> parentRuleList = [select id from Attribute_Rule__c where name = :record.name 
                                                  and CPQ_MLGPLUS__c = :record.CPQ_MLGPLUS__c
                                                  and HasChildRule__c = true limit 1];
        
        system.debug('###parentRuleList###'+parentRuleList);
        Attribute_Rule__c ParentRule;
        if(parentRuleList != null && parentRuleList.size()>0){
            ParentRule = parentRuleList[0];                   
        }else{
            ParentRule = new Attribute_Rule__c ();
            ParentRule.name = record.name ; 
            ParentRule.CPQ_MLGPLUS__c = record.CPQ_MLGPLUS__c ;
            ParentRule.HasChildRule__c = true; 
            insert ParentRule ;  
        }
        
        for(AttributeWrapper wrap : AttributeWrapList){
            IF(wrap.AttributeField != NULL && wrap.AttributeGroupName != NULL && wrap.FieldValue != NULL && wrap.MaskLayers != NULL){
                Attribute_Rule__c NewAttRule = new Attribute_Rule__c (); 
                    NewAttRule.name = record.name +'Child-'+ count ++ ; 
                    NewAttRule.CPQ_MLGPLUS__c = record.CPQ_MLGPLUS__c ; 
                    NewAttRule.Parent_Rule__c = ParentRule.id; 
                    NewAttRule.HasChildRule__c = false ; 
                    NewAttRule.Attribute_Field_API_Name__c = wrap.AttributeField;
                    NewAttRule.Attribute_Group_Name__c = wrap.AttributeGroupName; 
                    NewAttRule.Attribute_Field_Value__c = wrap.FieldValue ; 
                    NewAttRule.Mask_Layers__c = wrap.MaskLayers ; 
                 listWrap.add(NewAttRule);
            }
        }
        if(listWrap.size() > 0){
            try{
                insert listWrap ; 
            }catch(Exception e){
                if(e.getMessage().contains('duplicate value')){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Duplicate Attribute Rule cannot be created.');
                    ApexPages.addMessage(myMsg);                   
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                }
                return null;
            }
        }
        return new PageReference('/'+MLGID ); 
    }

}