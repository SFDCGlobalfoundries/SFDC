public class CPQAttributeRuleEditController {
    public String AttributeGroupName{get; set;}
    public List<SelectOption>  AttributeGroupNameList {get; set; }
    public String AttributeField {get; set;}
    public List<SelectOption>  AttributeFieldList {get; set; }
    public string MLGID {get;set;}
    public boolean AttValue {get;set;}
    public boolean PickValue {get;set;}
    public List<SelectOption>  AttributeFieldValueList {get; set; }
    public string AttributeFieldValue {get;set;}
    Attribute_Rule__c record;
    
    public CPQAttributeRuleEditController(ApexPages.StandardController controller) {
        record = (Attribute_Rule__c)controller.getRecord(); 
        AttValue = false;
        PickValue  = false ; 
        AttributeGroupNameList  = new List<SelectOption> ();
        if(ApexPages.currentPage().getParameters().containsKey('ID')){
            onSelectAttributeValuesEdit () ;
            for(Apttus_Config2__ProductAttributeGroupMember__c grpmem : [select id
                                                                                , name
                                                                                , CPQ_MLGPLUS__c 
                                                                                , Apttus_Config2__AttributeGroupId__c
                                                                         from   Apttus_Config2__ProductAttributeGroupMember__c
                                                                         where  CPQ_MLGPLUS__c = :record.CPQ_MLGPLUS__c ]){
                AttributeGroupNameList.add(new SelectOption(grpmem.Apttus_Config2__AttributeGroupId__c, grpmem.name));
            } 
            getFieldValues () ; 
        }
        else{
            MLGID = ApexPages.currentPage().getParameters().get('retURL');
            system.debug('returl**'+MLGID );
            MLGID = MLGID.contains('/GlobalfoundryView/') ? MLGID.removeStart('/GlobalfoundryView/') : MLGID.indexOf('/') == -1? MLGID.substring(0,15) : MLGID.substring(1,16);
            /*
            if(MLGID.contains('/GlobalfoundryView/')){
                MLGID = MLGID.removeStart('/GlobalfoundryView/');
            }
            if(MLGID.indexOf('/') == -1){
                MLGID =MLGID.substring(0,15);
            }
            else{
                MLGID=MLGID.substring(1,16);
            } */
            AttributeGroupName = '--None--' ;
            AttributeGroupNameList.add(new SelectOption('none', '--None--'));
            for(Apttus_Config2__ProductAttributeGroupMember__c grpmem : [select id
                                                                                , name
                                                                                , CPQ_MLGPLUS__c 
                                                                                , Apttus_Config2__AttributeGroupId__c
                                                                         from   Apttus_Config2__ProductAttributeGroupMember__c
                                                                         where  CPQ_MLGPLUS__c = :MLGID ]){
                AttributeGroupNameList.add(new SelectOption(grpmem.Apttus_Config2__AttributeGroupId__c, grpmem.name));
            }
        }
        
    }
    public void onSelectAttributeValues (){
        AttValue = true;
        AttributeFieldList = new List<SelectOption>(); 
        system.debug('[debug: AttributeGroupName ** ]'+AttributeGroupName);
        List<Apttus_Config2__ProductAttribute__c> ProductAttList = New List<Apttus_Config2__ProductAttribute__c>();
        AttributeFieldList.add(new SelectOption('none', '--None--'));
        for(Apttus_Config2__ProductAttribute__c PAtt :  [SELECT    id
                                                                   , Apttus_Config2__AttributeGroupId__c
                                                                   , Apttus_Config2__Field__c
                                                         FROM      Apttus_Config2__ProductAttribute__c
                                                         WHERE     Apttus_Config2__AttributeGroupId__c = :AttributeGroupName]){
            AttributeFieldList.add(new SelectOption(PAtt.Apttus_Config2__Field__c, PAtt.Apttus_Config2__Field__c));    
        } 
    }
    
    public void getFieldValues (){
        PickValue  = false;
        AttributeFieldValueList = new List<SelectOption>(); 
        String objectAPI = 'Apttus_Config2__ProductAttributeValue__c' ; 
        
        Map<String, Schema.SObjectType> gdMap = Schema.getGlobalDescribe();
        Schema.Describesobjectresult dsr = gdMap.get(objectAPI).getDescribe();
        Map<String, Schema.SObjectField> fieldMap = dsr.fields.getMap();

        //Schema.DescribeFieldResult FieldResult = convertType.getDescribe();
        Schema.DescribeFieldResult FieldResult = fieldMap.containskey(record.Attribute_Field_API_Name__c) 
                                                    ? fieldMap.get(record.Attribute_Field_API_Name__c).getDescribe()
                                                    : null;
        system.debug('[debug: &&&&&& FieldResult.getType()'+FieldResult.getType());
        if(FieldResult  != NULL  && FieldResult.getType() == Schema.DisplayType.PICKLIST ){
            //&& FieldResult.getType()
            PickValue  = true ; 
            List<Schema.PicklistEntry> PickValues = FieldResult.getPicklistValues();
            for(Schema.PicklistEntry f : PickValues ){
                AttributeFieldValueList.add(new SelectOption(f.getLabel(), f.getLabel()));
                system.debug('[debug: picklist values-->'+f.getLabel());
            }
        }
    }
    
    public void getFieldValuesCreate (){
        PickValue  = false;
        AttributeFieldValueList = new List<SelectOption>(); 
        String objectAPI = 'Apttus_Config2__ProductAttributeValue__c' ; 
        
        Map<String, Schema.SObjectType> gdMap = Schema.getGlobalDescribe();
        Schema.Describesobjectresult dsr = gdMap.get(objectAPI).getDescribe();
        Map<String, Schema.SObjectField> fieldMap = dsr.fields.getMap();

        //Schema.DescribeFieldResult FieldResult = convertType.getDescribe();
        Schema.DescribeFieldResult FieldResult = fieldMap.containskey(AttributeField) 
                                                    ? fieldMap.get(AttributeField).getDescribe()
                                                    : null;
        //system.debug('[debug: &&&&&& FieldResult.getType()'+FieldResult.getType());
        if(FieldResult  != NULL  && FieldResult.getType() == Schema.DisplayType.PICKLIST ){
            //&& FieldResult.getType()
            PickValue  = true ; 
            List<Schema.PicklistEntry> PickValues = FieldResult.getPicklistValues();
            for(Schema.PicklistEntry f : PickValues ){
                AttributeFieldValueList.add(new SelectOption(f.getLabel(), f.getLabel()));
                system.debug('[debug: picklist values-->'+f.getLabel());
            }
        }
    }
    
    
    public void onSelectAttributeValuesEdit (){
        AttValue = true;
        AttributeFieldList = new List<SelectOption>(); 
        system.debug('[debug: AttributeGroupName ** ]'+record.Attribute_Group_Name__c );
        List<Apttus_Config2__ProductAttribute__c> ProductAttList = New List<Apttus_Config2__ProductAttribute__c>();
        AttributeFieldList.add(new SelectOption('none', '--None--'));
        for(Apttus_Config2__ProductAttribute__c PAtt :  [SELECT    id
                                                                   , Apttus_Config2__AttributeGroupId__c
                                                                   , Apttus_Config2__Field__c
                                                         FROM      Apttus_Config2__ProductAttribute__c
                                                         WHERE     Apttus_Config2__AttributeGroupId__c = :record.Attribute_Group_Name__c ]){
            AttributeFieldList.add(new SelectOption(PAtt.Apttus_Config2__Field__c, PAtt.Apttus_Config2__Field__c));    
            
        } 
        getFieldValues (); 
        
    }
    public pagereference saveAtt(){
        Attribute_Rule__c NewAttRule = new Attribute_Rule__c (); 
            NewAttRule.name =  record.name;
            NewAttRule.CPQ_MLGPLUS__c = record .CPQ_MLGPLUS__c;
            NewAttRule.Attribute_Field_API_Name__c = AttributeField ;
            NewAttRule.Attribute_Group_Name__c = AttributeGroupName ; 
            NewAttRule.Attribute_Field_Value__c = PickValue == TRUE
                                                       ? AttributeFieldValue 
                                                       : record.Attribute_Field_Value__c; 
            NewAttRule.Mask_Layers__c= record.Mask_Layers__c; 
        try{
            insert  NewAttRule  ;
        }catch (Exception e){
            if(e.getMessage().contains('duplicate value')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Duplicate Attribute Rule cannot be created.');
                ApexPages.addMessage(myMsg);               
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            }            
            return null;
        } 
        return new PageReference('/'+MLGID );
    }

}