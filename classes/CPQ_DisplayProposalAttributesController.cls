public without sharing class CPQ_DisplayProposalAttributesController {

    private Apttus_Proposal__Proposal__c proposalRecord;
    Public Apttus_Proposal__Proposal__c proposalRecordField{set;get;}
    public Boolean isTechnologyConfigured {get; set;}
    private List<Apttus_Config2__LineItem__c> lstLineItems;
    private Product2 bundleProduct;
    //public Apttus_Config2__ProductAttributeValue__c pavRec {get; set;}
    public List<Apttus_Config2__ProductAttributeValue__c> pavRec1 {get; set;}

    public List<Apttus_Config2__ProductAttributeGroupMember__c> attrbtGrpMemberIDs{get; set;}
    public Map<Id, Apttus_Config2__ProductAttributeGroup__c> mapFieldsByAttributeGroup {get; set;}

    public List<string> ProdGrpSect{get;set;}
    public Map<String,List<allattributeDetails>> attrMap {get;set;}
    
    public CPQ_DisplayProposalAttributesController(ApexPages.StandardController controller) {
       isTechnologyConfigured = false;
        if(controller.getId() == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Proposal Id is missing.'));
            return;
        }
   
       if(!Test.isRunningTest()){
           controller.addFields(new List<String>{'Id','Name'});
        }
      
        proposalRecord = (Apttus_Proposal__Proposal__c) controller.getRecord();
        
       setProposalAttributeDetail();
    } 
    
    public CPQ_DisplayProposalAttributesController(Apttus_Proposal__Proposal__c objproposal){
        proposalRecord=objproposal;
        setProposalAttributeDetail();
    }
    
    public void setProposalAttributeDetail(){  
      
       
        proposalRecordField =[Select id,Device__r.ITAR_Flag__c,Device__r.Is_ITAR__c, Device__r.Secure_Device__c, Device__r.Secure_Device_Level__c from Apttus_Proposal__Proposal__c where id =: proposalRecord.id];
        Id productAttributeValueId = null;
        lstLineItems =[Select Apttus_Config2__AttributeValueId__c, Apttus_Config2__ProductId__c 
        from Apttus_Config2__LineItem__c 
        where Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c = :proposalRecord.Id  AND Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c = 'Finalized'];
        
      
        if(lstLineItems != null && lstLineItems.size() >0 && lstLineItems.get(0).Apttus_Config2__ProductId__c != null){
            bundleProduct = [Select Name, Description, PT_Number__c, Geometry__c, Mask_Sets__c, Product_External_ID__c from Product2 where Id = : lstLineItems.get(0).Apttus_Config2__ProductId__c].get(0); 
            productAttributeValueId = lstLineItems.get(0).Apttus_Config2__AttributeValueId__c;
            
            isTechnologyConfigured = true;
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Technology is not configured or finalised for Configuration '+proposalRecord.Name));
            return;
        }
        Set<Id> setOfAttributeGroupIds = new Set<Id>();
        attrbtGrpMemberIDs = [Select id, Apttus_Config2__AttributeGroupId__c from Apttus_Config2__ProductAttributeGroupMember__c where Apttus_Config2__ProductId__c=:bundleProduct.Id AND Apttus_Config2__AttributeGroupId__r.Apttus_Config2__BusinessObject__c='Apttus_Config2__ProductAttributeValue__c' Order By Apttus_Config2__Sequence__c];
        for(Apttus_Config2__ProductAttributeGroupMember__c attrbtGrpMember : attrbtGrpMemberIDs){
            setOfAttributeGroupIds.add(attrbtGrpMember.Apttus_Config2__AttributeGroupId__c);
        }
        
        mapFieldsByAttributeGroup = new Map<Id, Apttus_Config2__ProductAttributeGroup__c>([Select id, Name, (Select id, Apttus_Config2__Field__c from Apttus_Config2__Attributes__r order by Apttus_Config2__Sequence__c) from Apttus_Config2__ProductAttributeGroup__c where Id IN:setOfAttributeGroupIds]);
        //**Kanishk: check null key to fix VF page map issue
        for(Apttus_Config2__ProductAttributeGroupMember__c attrbtGrpMember:attrbtGrpMemberIDs){
            if(mapFieldsByAttributeGroup.get(attrbtGrpMember.Apttus_Config2__AttributeGroupId__c)==null){
                mapFieldsByAttributeGroup.put(attrbtGrpMember.Apttus_Config2__AttributeGroupId__c,new Apttus_Config2__ProductAttributeGroup__c());
            }
        }
        
        Set<String> setOfFields = new Set<String>();
        Set<String> setOfFieldsAndGroupNames = new Set<String>();
        Map<String,String> initStringStringMap= new Map<String,String>();
                 
        ProdGrpSect = new List<string>();
                
        if(mapFieldsByAttributeGroup != null && mapFieldsByAttributeGroup.size()>0)
        for(Apttus_Config2__ProductAttributeGroup__c pag : mapFieldsByAttributeGroup.values()){
        
            for(Apttus_Config2__ProductAttribute__c pt : pag.Apttus_Config2__Attributes__r){
                setOfFields.add(pt.Apttus_Config2__Field__c);
                setOfFieldsAndGroupNames.add(pag.Name+','+pt.Apttus_Config2__Field__c);
            }
           ProdGrpSect.add(pag.Name);
        }
        
        for(String str : setOfFieldsAndGroupNames){
             string[] GrpAndField = str.split(',');
             initStringStringMap.put(GrpAndField[1],GrpAndField[0]);

        }
       list<CPQ_PDF_Fields__mdt> SectionFields=[Select DeveloperName,MasterLabel, OrderOfFields__c ,Value__c from CPQ_PDF_Fields__mdt];
        Map<Decimal, CPQ_PDF_Fields__mdt> CPMap = new Map<Decimal, CPQ_PDF_Fields__mdt>();
        for(CPQ_PDF_Fields__mdt CPFM:SectionFields){
            CPMap.put(CPFM.OrderOfFields__c, CPFM); 
        }
        
        String type=CPMap.get(9).Value__c;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType prdatrrbuteSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> prdattfieldMap = prdatrrbuteSchema.getDescribe().fields.getMap();


        String type1=CPMap.get(10).Value__c;
        Map<String, Schema.SObjectType> schemaMap1 = Schema.getGlobalDescribe();
        Schema.SObjectType deviceSchema = schemaMap1.get(type1);
        Map<String, Schema.SObjectField> deviceMap = deviceSchema.getDescribe().fields.getMap();
         
        String strQuery = 'Select id,Name';
        for(String str : setOfFields){
            strQuery += ', '+str;
        }
        try{ 
                attrMap= new Map<string,List<allattributeDetails>>();
                string previoisgrpname;
            if(strQuery.indexOf('__c') != -1){
            if(productAttributeValueId !=null){
                strQuery += ' from Apttus_Config2__ProductAttributeValue__c where id = '+'\''+productAttributeValueId +'\'';
                //pavRec = (Apttus_Config2__ProductAttributeValue__c) Database.query(strQuery);
               
                pavRec1 = (List<Apttus_Config2__ProductAttributeValue__c>) Database.query(strQuery);
                }
                if(Test.isRunningTest()){
                strQuery += ' from Apttus_Config2__ProductAttributeValue__c limit 1';
                pavRec1 = (List<Apttus_Config2__ProductAttributeValue__c>) Database.query(strQuery);
                }
  
          list<Apttus_Proposal__Proposal_Line_Item__c> lstTechnologyOptionLineItem = [Select Id,Die_Size_is_Pre_Shrink_Post_Rotation__c,Die_Size_X_mm__c,Die_Size_Y_mm__c,Die_Size_mm2__c  FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c = :proposalRecord.Id AND Apttus_QPConfig__LineType__c = 'Product/Service' limit 1];   
          string diesizeshrinkLabel=CPMap.get(4).Value__c,diesizeshrinkValue;
     
             for(Apttus_Config2__ProductAttributeValue__c ACP: pavRec1){
               for(String str : setOfFields){
                if(diesizeshrinkLabel != prdattfieldMap.get(str).getDescribe().getLabel()){
                if(attrMap.containskey(initStringStringMap.get(str)))attrMap.get(initStringStringMap.get(str)).add( new allattributeDetails(prdattfieldMap.get(str).getDescribe().getLabel(),string.valueof(ACP.get(str))));
                else attrMap.put(initStringStringMap.get(str), new List<allattributeDetails>{ new allattributeDetails(prdattfieldMap.get(str).getDescribe().getLabel(),string.valueof(ACP.get(str)))});
                }else{
                diesizeshrinkLabel = prdattfieldMap.get(str).getDescribe().getLabel();
                diesizeshrinkValue =  string.valueof(ACP.get(str));
                }
                }
                }              
             }
             if(attrMap.containskey(CPMap.get(1).Value__c)){
                attrMap.get(CPMap.get(1).Value__c).add( new allattributeDetails(CPMap.get(8).Value__c,proposalRecordField.Device__r.ITAR_Flag__c));
                attrMap.get(CPMap.get(1).Value__c).add( new allattributeDetails(CPMap.get(7).Value__c,proposalRecordField.Device__r.Is_ITAR__c));
                attrMap.get(CPMap.get(1).Value__c).add( new allattributeDetails(CPMap.get(5).Value__c,proposalRecordField.Device__r.Secure_Device__c));
                attrMap.get(CPMap.get(1).Value__c).add( new allattributeDetails(CPMap.get(6).Value__c,proposalRecordField.Device__r.Secure_Device_Level__c));
               }
                        
        }
        catch(Exception e){
           //GlobalUtility.logMessage('Error', 'CPQ_DisplayProposalAttributesController', 'Constructor', null, null, e.getMessage(), null,null,e, null);
         UtilityCls.saveExceptionLog(CPQ_DisplayProposalAttributesController.class.getName(), 'Constructor', '', 'Bug', '', '', 'Error', e.getTypeName(), 'Apttus CPQ', e, 0);
       }   
    }
    
    public class allattributeDetails{
    
    public string Attvalue{get;set;}
    public string Attlabel{get;set;}
    public allattributeDetails(String Attvalue,String Attlabel){
    this.Attvalue=Attvalue;
    this.Attlabel=Attlabel;

    }
    }
    
    }