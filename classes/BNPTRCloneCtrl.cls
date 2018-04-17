/*
Type Name: BNPTRCloneCtrl
Author: Poulami Saha
Project Name: DIW Step Down Track 2 (TR) 
Created Date: 9/27/2016
Modified By : Pullarao/Arijit
Description: This class serves controller for BNPTRClone Page and is used for cloning DIW Options, Device, Deliverable Types and RI.
Test Class: 
Change History:
*/
public class BNPTRCloneCtrl {
    
    public List<Wafer_Data__c> newWafers {get; set;}
    public List<Chip_Data__c> newChips {get; set;}
    public List<Module_Data__c> newModules {get; set;}
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
    public Device__c deviceRec {get; set;}
    public Request_Information__c riRec {get; set;}
    public string txtdeviceName {get; set;}
    public Boolean copyRFQRoutings {get; set;}
    public Boolean copyRFQTaskRoutings {get; set;}
    public Boolean copyRFQTaskAssignees {get; set;}
    public Boolean isQuoteRequired {get; set;}
    public List<RFQ_Routing__c> routeList {get; set;}
    private List<RFQ_Tasks_Routing__c> tasks {get; set;}
    public List<RFQ_Task_Assignee__c> taskAssignees {get; set;}
    Map<Id,List<RFQ_Task_Assignee__c>> taskAssigneeMap;
    public Boolean isDisableWafer {get;set;}
    public Boolean isDisableService {get; set;}
    public Boolean isDisableChip {get; set;}
    public Boolean isDisableModule {get; set;}
    public Boolean isDisablePackage {get; set;}
    public Boolean isDisableDesign {get; set;} 
    public Boolean respinSelected {get; set;}
    public Boolean copySelected {get; set;}
    public String  RitType {get;set;}
    public String  TapeoutType {get;set;}



    public BNPTRCloneCtrl (ApexPages.StandardController stc)
    {    
        serviceCheck=false;
        waferCheck=false;
        chipCheck=false;
        moduleCheck=false;
        packageCheck=false;
        designCheck=false;
        copyRFQRoutings = false;
        copyRFQTaskRoutings = false;
        copyRFQTaskAssignees = false;
        isQuoteRequired = false;
        isDisableWafer = true;
        isDisableService = true;
        isDisableChip = true;
        isDisableModule = true;
        isDisablePackage = true;
        isDisableDesign = true;
        respinSelected = false;
        copySelected= false;
        
        //query Technical Requirement record
        Id reqInforecId = stc.getId();
        
        if(apexpages.currentpage().getparameters().get('opt') == 'Respin'){
            respinSelected = true;
            system.debug('respinSelected 1st loop' +respinSelected);
        }else if(apexpages.currentpage().getparameters().get('opt') == 'Copy'){
            respinSelected = true;
            copySelected = true;
            system.debug('respinSelected 2nd loop' +respinSelected);
            system.debug('copySelected 1st loop' +copySelected);
        }
        
        string chipQuery = getCreatableFieldsSOQL('Chip_Data__c');
        string moduleQuery = getCreatableFieldsSOQL('Module_Data__c');
        string pckQuery = getCreatableFieldsSOQL('Package_Data__c');
        string waferQuery = getCreatableFieldsSOQL('Wafer_Data__c');
        string designQuery = getCreatableFieldsSOQL('Design__c');
        string serviceQuery = getCreatableFieldsSOQL('Service__c'); 
        string techReqQuery = getCreatableFieldsSOQL('Customer_Requirement__c');
        
        techReqRec = (Customer_Requirement__c)Database.query(techReqQuery + ' WHERE Id =: reqInforecId limit 1');
        
        if(respinSelected){                               
            string deviceQuery = getCreatableFieldsSOQL('Device__c');       
            string rfqQuery = getCreatableFieldsSOQL('Request_Information__c');
            string routingQuery = getCreatableFieldsSOQL('RFQ_Routing__c');
            string taskQuery = getCreatableFieldsSOQL('RFQ_Tasks_Routing__c');
            string taskAssigneeQuery = getCreatableFieldsSOQL('RFQ_Task_Assignee__c');        
                            
            //query Device record
            Id devicerecId = techReqRec.Device__c;       
            deviceRec = (Device__c)Database.query(deviceQuery + ' where Id =: devicerecId limit 1');
            if(respinSelected && !copySelected){
                txtdeviceName = 'COPYOF_' + deviceRec.Name;
            }
            //Check for last Accepted Quote for this option
            List<Request_Information__c> lstquote = new List<Request_Information__c>();
            lstquote = [Select Id,
                                Customer_Requirement__c,
                                Last_Accepted_Quote__c, RecordType.Name from Request_Information__c 
                                where Customer_Requirement__c =: reqInforecId];
                                                                    
            if(lstquote.size() > 0 && lstquote != null)
            {
                Id quoteId = null;
                for(Request_Information__c RI : lstquote)
                {
                    if(RI.Last_Accepted_Quote__c && techReqRec.RecordType.DeveloperName != 'Contract_Technical_Requirment')
                    {
                        quoteId = RI.Id;
                        isQuoteRequired = true;                 
                    }               
                }
            }
            
            //End
            //Query Request Information Record (RFQ)
            if(isQuoteRequired)
            {        
                riRec = (Request_Information__c)Database.query(rfqQuery + ' where Id =: quoteId limit 1');
                Id riRecordId = riRec.Id;
                    
                //query Routing records
                routeList = Database.query(routingQuery + ' where RFQ__c =: riRecordId ORDER BY CreatedDate DESC LIMIT 1');        
                //query task records                
                tasks = Database.query(taskQuery + ' where Related_RFQ_Routing__c IN: routeList');                
                //query task assignee records                
                taskAssignees = Database.query(taskAssigneeQuery + ' where RFQ_Task_Routing__c IN: tasks');
                
                taskAssigneeMap = new Map<Id,List<RFQ_Task_Assignee__c>>();
                for(RFQ_Task_Assignee__c assignee : taskAssignees)
                {
                    if(!taskAssigneeMap.containsKey(assignee.RFQ_Task_Routing__c))
                    {
                        taskAssigneeMap.put(assignee.RFQ_Task_Routing__c,new List<RFQ_Task_Assignee__c>{assignee});
                    } 
                    else 
                    {
                        taskAssigneeMap.get(assignee.RFQ_Task_Routing__c).add(assignee);
                    }
                }
            } 
        }   
             
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
        if(objectName == 'Customer_Requirement__c'){
            return 'SELECT RecordType.DeveloperName,' + selects + ' FROM ' + objectName ;
        }
        else{
            return 'SELECT ' + selects + ' FROM ' + objectName ;
        }
        
    }
    public List<SelectOption> getRitOptions() {
        List<SelectOption> RitOptions = new List<SelectOption>();
        RitOptions.add(new SelectOption('A/B R','A/B R'));
        RitOptions.add(new SelectOption('B R','B R'));
        return RitOptions;
    }

    
     /*
     @MethodName: createClone
     @Parameters: 
     @ReturnType: PageReference
     @Author: Poulami Saha
     @CreatedDate: 27/09/2016
     @Description: Create new Device, Option, Service, Wafer,Chip, Module, Package, Design , RI, Task Routing, Task Assigne, Routing record.
     @Modifications- Arijit
     
     */
    public PageReference createClone()
    {      
        Savepoint preSave = Database.setSavepoint(); //set savepoint so we can rollback the whole save if there are errors
        PageReference pageReference = null;
        //Device__c newdeviceRec;
        
        //Device__c  newdeviceRec = deviceRec.clone(false,true);
        Device__c  newdeviceRec = new Device__c();
        try
        {        
            //Create a New retrofit Device Record :Added By Arijit
            // Validate Device Id   
            if(respinSelected){         
                system.debug('Hello0oooooo Respin');
                List<Device__c> tempListDevice = new List<Device__c>();
                tempListDevice = [SELECT      Id
                                  FROM        Device__c
                                  WHERE       Name = :txtdeviceName                              
                                 ];            
                if (tempListDevice.size() > 0) 
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('DEVICE_ID_ALREADY_EXIST').Message__c));
                    return null;
                }
                
                //End
                if(copySelected){
                    system.debug('Hello0oooooo Copy');
                    List<Device__c> listDevice = [SELECT      Id
                                                , CRMDID__c
                                      FROM        Device__c
                                      WHERE       CRMDID__c = :(deviceRec.CRMDID__c.substringBefore('.') + '.00')];
                    //newdeviceRec = new Device__c();
                    newdeviceRec.OwnerId = UserInfo.getUserId();
                    newdeviceRec.Stage__c = 'Design In';
                    newdeviceRec.Status__c = 'Active';
                    newdeviceRec.Tapeout_Type__c = TapeoutType;
                    newdeviceRec.MPW_Train_Number__c = techReqRec.MPW_Train_Number__c;
                    newdeviceRec.Device_Type__c = 'Base';
                    newdeviceRec.Enabled_via_previous_MPW_1__c = 'No';
                    newdeviceRec.Revision__c = '00';
                    newdeviceRec.Base_Device__c = null;
                    newdeviceRec.BX041_Status__c = 'Pending Submission';
                    newdeviceRec.Copied_Device__c = deviceRec.id;
                    //newdeviceRec.Device_Mask_Set_Title__c = '';
                    //newdeviceRec.Mask_Set_Title_Lookup__c = null;
                    newdeviceRec.Configuration_Status__c = NULL;    
                    newdeviceRec.Configuration__c = NULL;
                    if (listDevice.size() > 0) {
                        newdeviceRec.Base_Device_Device_Id__c = listDevice[0].CRMDID__c.substringBefore('.');
                    }
                    newdeviceRec.process_technology_2__c = deviceRec.process_technology_2__c;
                    newdeviceRec.GSOP_Assignment_Tapeout_Plan__c = deviceRec.GSOP_Assignment_Tapeout_Plan__c;
                    newdeviceRec.Confidence_Level_Tapeout__c = deviceRec.Confidence_Level_Tapeout__c;
                    newdeviceRec.Confidence_Level_Volume__c = deviceRec.Confidence_Level_Volume__c;
                    newdeviceRec.Generate_standard_Frame__c = deviceRec.Generate_standard_Frame__c;
                    newdeviceRec.Device_Sourcing__c = deviceRec.Device_Sourcing__c;
                    newdeviceRec.Opportunity_Program__c = deviceRec.Opportunity_Program__c;
                    newdeviceRec.Opportunity2__c = deviceRec.Opportunity2__c;
                    newdeviceRec.Fab__c = deviceRec.Fab__c;
                    newdeviceRec.Reticle_Type__c = deviceRec.Reticle_Type__c;
                    newdeviceRec.Special_Scribe_Width__c = deviceRec.Special_Scribe_Width__c;
                    newdeviceRec.End_Application__c = deviceRec.End_Application__c;
                    newdeviceRec.End_Customer__c = deviceRec.End_Customer__c;
                    newdeviceRec.Market_Segment__c = deviceRec.Market_Segment__c;
                    newdeviceRec.Semiconductor_Device__c = deviceRec.Semiconductor_Device__c;           
                    newdeviceRec.Requested_Process_ID__c = deviceRec.Requested_Process_ID__c;
                    newdeviceRec.STF_Process_ID__c = deviceRec.STF_Process_ID__c; // Formerly disabled in Copy Device
                    newdeviceRec.Secure_Device__c = deviceRec.Secure_Device__c;
                    newdeviceRec.Automotive_Device__c = deviceRec.Automotive_Device__c;
                    newdeviceRec.Design_Execution_Required__c = deviceRec.Design_Execution_Required__c;
                    newdeviceRec.Automotive_Grade__c = deviceRec.Automotive_Grade__c;
                    //newdeviceRec.IP_Declaration_Submitted_Date__c=deviceRec.IP_Declaration_Submitted_Date__c;
                    newdeviceRec.Account__c = deviceRec.Account__c;
                    newdeviceRec.Design_Partner__c = deviceRec.Design_Partner__c;
                    newdeviceRec.Internal_Device_Geometry__c = deviceRec.Internal_Device_Geometry__c;
                    newdeviceRec.Internal_Device_Process_Family__c = deviceRec.Internal_Device_Process_Family__c;
                    newdeviceRec.RecordTypeId = deviceRec.RecordTypeId;
                    newdeviceRec.Business_Unit__c = deviceRec.Business_Unit__c;
                    newdeviceRec.Product_Line__c = deviceRec.Product_Line__c;
                    newdeviceRec.Device_Purpose__c = deviceRec.Device_Purpose__c;
                    newdeviceRec.Project_Name__c = deviceRec.Project_Name__c;
                    newdeviceRec.Enabled_via_previous_MPW_1__c = deviceRec.Enabled_via_previous_MPW_1__c;
                    newdeviceRec.Previous_Enabling_Devices_MPW__c = deviceRec.Previous_Enabling_Devices_MPW__c;
                    newdeviceRec.Name = txtdeviceName;
                    if(deviceRec.Original_Forecasted_Tapeout_Date__c == null){
                        newdeviceRec.Original_Forecasted_Tapeout_Date__c = system.today();
                    }else{
                        newdeviceRec.Original_Forecasted_Tapeout_Date__c = deviceRec.Original_Forecasted_Tapeout_Date__c;
                    }
                    
                }else{
                    //newdeviceRec = new Device__c();
                    newdeviceRec = UtilityCls.createRetrofitDevice(deviceRec, txtdeviceName);
                    newdeviceRec.Expose_Device_to_Customer__c = false; //SP4: To skip the validation "This retrofit device cannot be exposed to the customer portal"
                }
                newdeviceRec.Is_CDSCreated__c = false;
                newdeviceRec.CDS_Number__c = NULL;                
                Insert newdeviceRec;
            }
            //End
            
            Customer_Requirement__c newtechReq = techReqRec.clone(false);
            //Added By Arijit
            if(respinSelected){
                newtechReq.Device__c = newdeviceRec.Id;
                newtechReq.RIT_Type__c = RitType;

            }
            else{
                newtechReq.Device__c = techReqRec.Device__c;
            }
            //End
            newtechReq.OptionParentControlNumber__c = techReqRec.Id; 
            
            newtechReq.FMS_ID__c = ''; //Arijit: Done for Sprint 3 (FMS ID should not be clone  to new option)
            
            if(techReqRec.Option_Stage__c == 'Customer Engagement'){
                newtechReq.Option_Stage__c = 'Customer Engagement';
            }
            else{
                newtechReq.Option_Stage__c = 'Try for Fit';
            }
            

                newtechReq.Deliverable_Part_Number_DPN__c = '';
                newtechReq.Design_Assay_PN__c = '';
                newtechReq.Customer_part_name__c = '';
                newtechReq.Wafer_FAB_sourcing_location_wafer_size__c = '';
                newtechReq.Design_execution_required__c = '';
                newtechReq.Request_Information__c = null;
                newtechReq.MD_part_name__c = '';
                newtechReq.DIW_Charge_Info__c = null;

            
            if(techReqRec.RIT_Type__c == 'A/B')
            {
                newtechReq.RIT_Type__c = 'A/B R';
            }
            else if(techReqRec.RIT_Type__c == 'B')
            {
                newtechReq.RIT_Type__c = 'B R';
            }
            
            /*if(techReqRec.Deliverable_Type__c != '' && techReqRec.Deliverable_Type__c != null)
            {
                newtechReq.Option_Stage__c = 'Try for Fit';
            }
            else if(techReqRec.Deliverable_Type__c == '' || techReqRec.Deliverable_Type__c == null)
            {
                newtechReq.Option_Stage__c = 'Customer Engagement';
            }*/
               
            /*if(techReqRec.Count__c == null)
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
                               
            }*/
            insert newtechReq;
            
            //insert Wafer
            if(waferCheck)
            {
                newWafers = cloneWafersIntoList(waferList);
                for(Wafer_Data__c newWafer : newWafers)
                {
                    newWafer.Technical_Requirement__c = newtechReq.Id;
                }
                insert newWafers;
                newtechReq.Wafer_Data__c = newWafers[0].id;
            }  
            
            //insert Chip
            if(chipCheck)
            {
                newChips = cloneChipsIntoList(chipList);
                for(Chip_Data__c newChip : newChips)
                {
                    newChip.Technical_Requirement__c = newtechReq.Id;
                    newChip.Wafer_Data__c = newWafers[0].id;
                }
                insert newChips;  
                newtechReq.Chip_Data__c =  newChips[0].id;        
            }
            //insert Module
            if(moduleCheck)
            {
                newModules = cloneModulesIntoList(moduleList);
                for(Module_Data__c newModule : newModules)
                {
                    newModule.Technical_Requirement__c = newtechReq.Id;
                    newModule.Chip_1__c = newChips[0].id;
                }
                insert newModules;
                newtechReq.Modules__c = newModules[0].id;
            }
            
            //insert Package
            if(packageCheck)
            {
                List<Package_Data__c> newPcks = clonePacksIntoList(packageList);
                for(Package_Data__c newPack : newPcks)
                {
                    newPack.Technical_Requirement__c = newtechReq.Id;
                    newPack.Module_Data__c = newModules[0].id;
                }
                insert newPcks;
                newtechReq.Package__c = newPcks[0].id;
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
                newtechReq.Design__c = newDesigns[0].id;
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
                newtechReq.Service__c = newServices[0].id;
            }
            
            update newtechReq;
            
            if(respinSelected){
                //Insert Quote
                if(isQuoteRequired)
                {
                    Request_Information__c newquoterec = riRec.clone(false);
                    //Added By Arijit
                    newquoterec.Name = 'Copy of ' + riRec.Name;
                    newquoterec.Customer_Requirement__c = newtechReq.Id;
                    newquoterec.Skip_Validation__c = true;
                    Insert newquoterec;
                    
                    //insert Routing
                    List<RFQ_Routing__c> newRoutings = new List<RFQ_Routing__c>();
                    if(copyRFQRoutings)
                    {
                        newRoutings = cloneRoutingIntoList(routeList);
                        for(RFQ_Routing__c newRouting : newRoutings)
                        {
                            newRouting.RFQ__c = newquoterec.Id;
                        }
                        insert newRoutings;
                    }           
                    //insert Tasks
                    Map<Id,RFQ_Tasks_Routing__c> newTaskMap = new Map<Id,RFQ_Tasks_Routing__c>();
                    if(copyRFQTaskRoutings)
                    {                    
                        newTaskMap = cloneTasksIntoList(tasks);
                        List<RFQ_Tasks_Routing__c> newTasks = new List<RFQ_Tasks_Routing__c>();
                        for(RFQ_Tasks_Routing__c newTask : newTaskMap.values())
                        {                    
                            newTask.Related_RFQ_Routing__c = newRoutings[0].Id;
                            newTasks.add(newTask);
                        }
                        insert newTasks;
                    }            
                    //insert Task Assignees
                    if(copyRFQTaskAssignees)
                    {
                        List<RFQ_Task_Assignee__c> newTaskAssignees = cloneTaskAssigneesIntoList(taskAssignees);
                        for(RFQ_Task_Assignee__c newTaskAssign : newTaskAssignees)
                        {                    
                            newTaskAssign.RFQ_Task_Routing__c = newTaskMap.get(newTaskAssign.RFQ_Task_Routing__c).Id;
                        }
                        insert newTaskAssignees;
                    }
                }
            }
            //direct user to cloned project's detail page
            return new ApexPages.StandardController(newtechReq).view();
         
        }
        catch(Exception e)
        {
            ApexPages.addMessages(e); //show save error(s) on the visualforce page
            GlobalUtility.logMessage('Error','BNPTRCloneCtrl','createClone','','Exception while respining option',String.valueof(e.getMessage()),'','BnP',e,0);
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
    
    public pageReference reload()
    {
        if(!copyRFQRoutings)
        {
            copyRFQTaskRoutings = false;
            copyRFQTaskAssignees = false;
        }
        if(!copyRFQTaskRoutings)
        {
            copyRFQTaskAssignees = false;
        }
        return null;
    }
    
    private static List<RFQ_Routing__c> cloneRoutingIntoList(List<RFQ_Routing__c> recs)
    {
        List<RFQ_Routing__c> newRecs = new List<RFQ_Routing__c>();
        for(RFQ_Routing__c rec : recs){
            RFQ_Routing__c newRec = rec.clone(false);
            newRecs.add(newRec);
        }
        return newRecs;
    }
    
    private static Map<Id,RFQ_Tasks_Routing__c> cloneTasksIntoList(List<RFQ_Tasks_Routing__c> recs)
    {
        Map<Id,RFQ_Tasks_Routing__c> newRecs = new Map<Id,RFQ_Tasks_Routing__c>();
        for(RFQ_Tasks_Routing__c rec : recs)
        {
            RFQ_Tasks_Routing__c newRec = rec.clone(false);
            newRecs.put(rec.Id,newRec);
        }
        return newRecs;
    }
    
    private static List<RFQ_Task_Assignee__c> cloneTaskAssigneesIntoList(List<RFQ_Task_Assignee__c> recs)
    {
        List<RFQ_Task_Assignee__c> newRecs = new List<RFQ_Task_Assignee__c>();
        for(RFQ_Task_Assignee__c rec : recs)
        {
            RFQ_Task_Assignee__c newRec = rec.clone(false);
            newRecs.add(newRec);
        }
        return newRecs;
    }
}