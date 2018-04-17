/*
Type Name: OptionCloneCtrl
Author: Namandeep Singh
Project Name: DIW Step Down
Created Date: 4/10/2017
Description: This class serves controller for BNPTRClone Page and is used for cloning DIW Options, Deliverable Types.
Test Class: 
Change History:
*/
public with sharing class OptionCloneCtrl{
    
    public Customer_Requirement__c techReqRec {get; set;}
    public Customer_Requirement__c dummytechReqRec {get; set;}
    public List<Chip_Data__c> chipList {get; set;}
    public List<Module_Data__c> moduleList {get; set;}
    public List<Package_Data__c> packageList {get; set;}
    public List<Wafer_Data__c> waferList {get; set;}
    public List<Design__c> designList {get; set;}
    public List<Service__c> servisList {get; set;}
    public string deliberableType {get; set;}
    public Boolean serviceCheck {get; set;}
    public Boolean waferCheck {get; set;}
    public Boolean chipCheck {get; set;}
    public Boolean moduleCheck {get; set;}
    public Boolean packageCheck {get; set;}
    public Boolean designCheck {get; set;}        
    public Boolean isDisableWafer {get;set;}
    public Boolean isDisableService {get; set;}
    public Boolean isDisableChip {get; set;}
    public Boolean isDisableModule {get; set;}
    public Boolean isDisablePackage {get; set;}
    public Boolean isDisableDesign {get; set;} 
    
    public OptionCloneCtrl(ApexPages.StandardController stc)
    {    
        serviceCheck=false;
        waferCheck=false;
        chipCheck=false;
        moduleCheck=false;
        packageCheck=false;
        designCheck=false;        
        isDisableWafer = true;
        isDisableService = true;
        isDisableChip = true;
        isDisableModule = true;
        isDisablePackage = true;
        isDisableDesign = true;
        
        string techReqQuery = getCreatableFieldsSOQL('Customer_Requirement__c');       
        string chipQuery = getCreatableFieldsSOQL('Chip_Data__c');
        string moduleQuery = getCreatableFieldsSOQL('Module_Data__c');
        string pckQuery = getCreatableFieldsSOQL('Package_Data__c');
        string waferQuery = getCreatableFieldsSOQL('Wafer_Data__c');
        string designQuery = getCreatableFieldsSOQL('Design__c');
        string serviceQuery = getCreatableFieldsSOQL('Service__c');     
        string deviceQuery = getCreatableFieldsSOQL('Device__c');               
        
        //query Technical Requirement record
        Id reqInforecId = stc.getId();
        techReqRec = (Customer_Requirement__c)Database.query(techReqQuery + ' WHERE Id =: reqInforecId limit 1');
       
        //query Chip records
        chipList = Database.query(chipQuery + ' where Technical_Requirement__c =: reqInforecId and Is_Deliverable_Type__c = \'Yes\' ORDER BY CreatedDate DESC');
        if(chipList.size() > 0)
            isDisableChip = false;
        
        //query Module records                
        moduleList = Database.query(moduleQuery + ' where Technical_Requirement__c =: reqInforecId and Is_Deliverable_Type__c = \'Yes\' ORDER BY CreatedDate DESC');
        if(moduleList.size() > 0)
            isDisableModule = false;
        
        //query Package records                
        packageList = Database.query(pckQuery + ' where Technical_Requirement__c =: reqInforecId and Is_Deliverable_Type__c = \'Yes\' ORDER BY CreatedDate DESC');
        if(packageList.size() > 0)
            isDisablePackage = false;
        
        //query Wafer records                
        waferList = Database.query(waferQuery + ' where Technical_Requirement__c =: reqInforecId and Is_Deliverable_Type__c = \'Yes\' ORDER BY CreatedDate DESC');
        if(waferList.size() > 0)
            isDisableWafer = false;
        //query Design records                
        designList = Database.query(designQuery + ' where Customer_Requirement__c =: reqInforecId and Is_Deliverable_Type__c = \'Yes\' ORDER BY CreatedDate DESC');
        if(designList.size() > 0)
            isDisableDesign = false;
        
        //query Service records                
        servisList = Database.query(serviceQuery + ' where Technical_Requirement__c =: reqInforecId and Is_Deliverable_Type__c = \'Yes\' ORDER BY CreatedDate DESC');
        if(servisList.size() > 0)
            isDisableService = false;
        
        dummytechReqRec = new Customer_Requirement__c();        
        deliberableType = techReqRec.Deliverable_Type__c;
    }
    
     // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
    public static string getCreatableFieldsSOQL(String objectName)
    {       
        String selects = '';        
        
        SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        
        Schema.DescribeSObjectResult objTypeResult = objType.getDescribe();
        
        Map<String, Schema.FieldSet> FsMap =  objTypeResult.fieldSets.getMap();
             
        List<Schema.FieldSetMember> nonCloneFields= FsMap.get('NonCloneFields').getFields();

        set<string> nonClonedFieldSet=new set<string>();
        for(Schema.FieldSetMember f : nonCloneFields) {
            nonClonedFieldSet.add(f.getFieldPath());
        }
                
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values())
            { // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable())
                { // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
        
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                if(!nonClonedFieldSet.contains(s)){
                    selects += s + ',';
                }
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
            
        }
        
        return 'SELECT ' + selects + ' FROM ' + objectName ;
        
    }
    
     /*
     @MethodName: createClone
     @Parameters: 
     @ReturnType: PageReference
     @Author: Namandeep Singh
     @CreatedDate: 4/09/2017
     @Description: Create new Option, Service, Wafer,Chip, Module, Package, Design.     
     
     */
    public PageReference createClone()
    {      
        Savepoint preSave = Database.setSavepoint(); //set savepoint so we can rollback the whole save if there are errors
        PageReference pageReference = null;
        try
        {           
            Customer_Requirement__c newtechReq = techReqRec.clone(false);
           
            newtechReq.OptionParentControlNumber__c = techReqRec.Id; 
            
            newtechReq.FMS_ID__c = '';
            
            if(techReqRec.RIT_Type__c == 'A/B')
            {
                newtechReq.RIT_Type__c = 'A/B R';
            }
            else if(techReqRec.RIT_Type__c == 'B')
            {
                newtechReq.RIT_Type__c = 'B R';
            }
            
            
            newtechReq.Option_Stage__c = 'Try for Fit';
            newtechReq.Deliverable_Part_Number_DPN__c = '';
            newtechReq.Design_Assay_PN__c = '';
            newtechReq.Customer_part_name__c = '';
            newtechReq.Wafer_FAB_sourcing_location_wafer_size__c = '';
            newtechReq.Design_execution_required__c = '';
               
            if(techReqRec.Count__c == null)
            {              
              techReqRec.Count__c = 1;             
              update techReqRec;
              
              newtechReq.Version__c = 1;              
            }
            else
            {
              techReqRec.Count__c = techReqRec.Count__c + 1;
              
              update techReqRec;                  
            
              newtechReq.Version__c = techReqRec.Count__c;
              newtechReq.Count__c = null;
                               
            }
            insert newtechReq;
            
            //insert Chip
            if(chipCheck)
            {
                List<Chip_Data__c> newChips = cloneChipsIntoList(chipList);
                for(Chip_Data__c newChip : newChips)
                {
                    newChip.Technical_Requirement__c = newtechReq.Id;
                }
                insert newChips;            
            }
            //insert Module
            if(moduleCheck)
            {
                List<Module_Data__c> newModules = cloneModulesIntoList(moduleList);
                for(Module_Data__c newModule : newModules)
                {
                    newModule.Technical_Requirement__c = newtechReq.Id;
                }
                insert newModules;
            }
            
            //insert Package
            if(packageCheck)
            {
                List<Package_Data__c> newPcks = clonePacksIntoList(packageList);
                for(Package_Data__c newPack : newPcks)
                {
                    newPack.Technical_Requirement__c = newtechReq.Id;
                }
                insert newPcks;
            }
            
            //insert Wafer
            if(waferCheck)
            {
                List<Wafer_Data__c> newWafers = cloneWafersIntoList(waferList);
                for(Wafer_Data__c newWafer : newWafers)
                {
                    newWafer.Technical_Requirement__c = newtechReq.Id;
                    newWafer.Active_side_interconnect_technology__c = '';
                }
                insert newWafers;
            }
            
            //insert Design
            if(designCheck)
            {
                List<Design__c> newDesigns = cloneDesignsIntoList(designList);
                for(Design__c newDesign : newDesigns)
                {
                    newDesign.Customer_Requirement__c = newtechReq.Id;
                }
                insert newDesigns;
            }
            
            //insert Service
            if(serviceCheck)
            {
                List<Service__c> newServices = cloneServicesIntoList(servisList);
                for(Service__c newService : newServices)
                {
                    newService.Technical_Requirement__c = newtechReq.Id;
                }
                insert newServices;
            }
            
            //direct user to cloned project's detail page
            return new ApexPages.StandardController(newtechReq).view();
         
        }
        catch(Exception e)
        {
            ApexPages.addMessages(e); //show save error(s) on the visualforce page
            GlobalUtility.logMessage('Error','OptionCloneCtrl','createClone','','Exception while cloning option',String.valueof(e.getMessage()),'','BnP',e,0);
            Database.rollback(preSave); //rollback any completed saves if the transaction has errors
        }
        return pageReference;
    }
    
    private static List<Chip_Data__c> cloneChipsIntoList(List<Chip_Data__c> recs){
        List<Chip_Data__c> newRecs = new List<Chip_Data__c>();
        for(Chip_Data__c rec : recs){
            Chip_Data__c newRec = rec.clone(false);
            newRecs.add(newRec);
        }
        return newRecs;
    }
    
    private static List<Module_Data__c> cloneModulesIntoList(List<Module_Data__c> recs)
    {
        List<Module_Data__c> newRecs = new List<Module_Data__c>();
        for(Module_Data__c rec : recs)
        {
            Module_Data__c newRec = rec.clone(false);           
            newRecs.add(newRec);
        }
        return newRecs;
    } 

    private static List<Package_Data__c> clonePacksIntoList(List<Package_Data__c> recs)
    {
        List<Package_Data__c> newRecs = new List<Package_Data__c>();
        for(Package_Data__c rec : recs)
        {
            Package_Data__c newRec = rec.clone(false);            
            newRecs.add(newRec);
        }
        return newRecs;
    }
    
    private static List<Wafer_Data__c> cloneWafersIntoList(List<Wafer_Data__c> recs)
    {
        List<Wafer_Data__c> newRecs = new List<Wafer_Data__c>();
        for(Wafer_Data__c rec : recs)
        {
            Wafer_Data__c newRec = rec.clone(false);            
            newRecs.add(newRec);
        }
        return newRecs;
    }
    
    private static List<Design__c> cloneDesignsIntoList(List<Design__c> recs){
        List<Design__c> newRecs = new List<Design__c>();
        for(Design__c rec : recs){
            Design__c newRec = rec.clone(false);           
            newRecs.add(newRec);
        }
        return newRecs;
    }
    
    private static List<Service__c> cloneServicesIntoList(List<Service__c> recs)
    {
        List<Service__c> newRecs = new List<Service__c>();
        for(Service__c rec : recs)
        {
            Service__c newRec = rec.clone(false);
            newRecs.add(newRec);
        }
        return newRecs;
    }   
}