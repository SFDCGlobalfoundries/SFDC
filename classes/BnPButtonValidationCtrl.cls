/*
Type Name: BnPButtonValidationCtrl
Author: Poulami Saha
Project Name: DIW Step Down Track 2 (BnP) 
Created Date: 06/20/2017
Description: This class is call from 'Deliverable Type Detail' and 'New Request Information' button to check field validation before adding Deliverable Type and RFQ creation respectively..
Test Class: BnPButtonValidationCtrlTest
Change History: 
*/
public class BnPButtonValidationCtrl{
    // variable to hold Option id
    public string optionid { get; set; }
    // variable to hold Button Type id
    public string butType { get; set; }
    // variable to hold Option record
    public Customer_Requirement__c optionRecord { get; set; }
    // variable to hold Wafer record
    public List<Wafer_Data__c> waferRecord { get; set; }
    // variable to hold Design record
    public List<Design__c> designRecord { get; set; }
    // variable to hold Chip record
    public List<Chip_Data__c> chipRecord { get; set; }
    // variable to hold Chip record
    //public Chip_Data__c chipRecord { get; set; }
    // variable to hold Module record
    public List<Module_Data__c> moduleRecord { get; set; }
    // variable to hold Package record
    public List<Package_Data__c> packageRecord { get; set; }
    // variable to hold Service record
    public List<Service__c> serviceRecord { get; set; }
    // variable to hold Device record
    public List<Device__c> deviceRecord { get; set; }
    // variable to hold Opportunity record
    public List<Opportunity> oppRecord { get; set; }
    // variable to hold wrapper list
    public List<myWrapper> wrapList {get; set;}

    /**
    *  Constructor of this Controller 
    *  @name <BnPButtonValidationCtrl>
    *  @param <> 
    *  @return <NA> - <>
    *  @throws exception-<exception description>
    */
    public BnPButtonValidationCtrl(){
        optionid = ApexPages.currentPage().getParameters().get('trId');
        butType = ApexPages.currentPage().getParameters().get('buttonType');
        system.debug('Button Type : ' +butType);
        string optionQuery = getCreatableFieldsSOQL('Customer_Requirement__c');
        string designQuery = getCreatableFieldsSOQL('Design__c');
        string waferQuery = getCreatableFieldsSOQL('Wafer_Data__c');
        string chipQuery = getCreatableFieldsSOQL('Chip_Data__c');
        string moduleQuery = getCreatableFieldsSOQL('Module_Data__c');
        string packageQuery = getCreatableFieldsSOQL('Package_Data__c');
        string serviceQuery = getCreatableFieldsSOQL('Service__c');
        string deviceQuery = getCreatableFieldsSOQL('Device__c');
        string oppQuery = getCreatableFieldsSOQL('Opportunity');
        
        if(optionid != null && optionid != '') {
            //query option records
            optionRecord = (Customer_Requirement__c)Database.query(optionQuery + ' ,ProductOffering__r.Name, Opportunity__r.Account.Name, Opportunity__r.AccountId, Device__r.Name, Opportunity__r.Name, Opportunity__r.Product_Line__c, Opportunity__r.StageName, Opportunity__r.Deal_Grading_Status__c FROM Customer_Requirement__c  WHERE Id =: optionid limit 1');
            //query wafer records
            waferRecord = (List<Wafer_Data__c>)Database.query(waferQuery + ' FROM Wafer_Data__c WHERE Technical_Requirement__c =: optionid limit 1');
            //query design records
            designRecord = (List<Design__c>)Database.query(designQuery + ' FROM Design__c WHERE Customer_Requirement__c =: optionid limit 1');
            //query chip records
            chipRecord = (List<Chip_Data__c>)Database.query(chipQuery + ' FROM Chip_Data__c WHERE Technical_Requirement__c =: optionid limit 1');
            //query module records
            moduleRecord = (List<Module_Data__c>)Database.query(moduleQuery + ' FROM Module_Data__c WHERE Technical_Requirement__c =: optionid limit 1');
            //query package records
            packageRecord = (List<Package_Data__c>)Database.query(packageQuery + ' FROM Package_Data__c WHERE Technical_Requirement__c =: optionid limit 1');
            //query service records
            serviceRecord = (List<Service__c>)Database.query(serviceQuery + ' FROM Service__c WHERE Technical_Requirement__c =: optionid limit 1');
            String devId = optionRecord.Device__c;
            String oppId = optionRecord.Opportunity__c;
            //query device records
            deviceRecord =  (List<Device__c>)Database.query(deviceQuery + ' FROM Device__c WHERE id =: devId limit 1');
            //query opportunity records
            oppRecord =     (List<Opportunity>)Database.query(oppQuery + ' FROM Opportunity WHERE id =: oppId limit 1');
        }
    }

    /**
    *  Returns a dynamic SOQL statement for the whole object
    *  @name <BNPCreateRouteFromTemplate>
    *  @param <String> 
    *  @return <String>
    *  @throws exception-<>
    */
    public static string getCreatableFieldsSOQL(String objectName){
        String selects = '';        
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                selectFields.add(fd.getName());
            }
        }
        
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
        }
        //return 'SELECT ' + selects + ' FROM ' + objectName ;
        return 'SELECT ' + selects;
    }
    
    /**
    *  The Purpose of this method is to 
    *  @name <checkButtonValidation>
    *  @param <> 
    *  @return <PageReference>
    *  @throws exception-<GlobalUtility.logMessage was called to capture the exception>
    */
    public PageReference checkButtonValidation(){
        Schema.DescribeSObjectResult r = Request_Information__c.sObjectType.getDescribe();
        String ObjectKeyPrefix = r.getKeyPrefix(); 
        String accName = optionRecord.Opportunity__r.Account.Name;
        String accId = optionRecord.Opportunity__r.AccountId;
        String devName = optionRecord.Device__r.Name;
        String devId = optionRecord.Device__c;
        String oppName = optionRecord.Opportunity__r.Name;
        String oppId = optionRecord.Opportunity__c;
        String optionName = optionRecord.Name;
        String reqInfoObjId = System.Label.BnP_ReqInfo_ObjId;
        String reqInfoAccId = System.Label.BnP_ReqInfo_AccId;
        String reqInfoOppId = System.Label.BnP_ReqInfo_OppId;
        String reqInfoOptId = System.Label.BnP_ReqInfo_OptId;
        String reqInfoDevId = System.Label.BnP_ReqInfo_DevId;
        String reqInfoRFIRecTypeId = System.Label.BnP_ReqInfo_RFI_RecTypeId;
        PageReference myVFPage;
        
        Boolean optFieldVal = false;
        Boolean desFieldVal = false;
        Boolean wafFieldVal = false;
        Boolean modFieldVal = false;
        Boolean chipFieldVal = false;
        Boolean packFieldVal = false;
        Boolean serFieldVal = false;
        Boolean devFieldVal = false;
        Boolean oppFieldVal = false;
       
        List<BnPButtonValidationFieldMapping__c> butValCusSettingAllRecordList = new List<BnPButtonValidationFieldMapping__c>();
        List<BnPButtonValidationFieldMapping__c> butValCusSettingSpecDelTypeList = new List<BnPButtonValidationFieldMapping__c>();
        List<BnPButtonValidationFieldMapping__c> butValCusSettingAllDelTypeList = new List<BnPButtonValidationFieldMapping__c>();
        List<BnPButtonValidationFieldMapping__c> butValCusSettingAllandSpecDelTypeList = new List<BnPButtonValidationFieldMapping__c>();
        Map<String,BnPButtonValidationFieldMapping__c> allRecords = BnPButtonValidationFieldMapping__c.getAll();
        system.debug('Cus Set Fields :' +allRecords);
        butValCusSettingAllRecordList = allRecords.values();
        system.debug('Cus Set Fields Values:' +allRecords);
        
        if(butValCusSettingAllRecordList.size() > 0){
            for(BnPButtonValidationFieldMapping__c rec : butValCusSettingAllRecordList){
                Set<String> listofDelType = new Set<String>();
                if(rec.Deliverable_Type_Name__c != '' && rec.Deliverable_Type_Name__c != null){
                    listofDelType.addAll(rec.Deliverable_Type_Name__c.split('[,;]'));
                }
                if(rec.Validation_Type__c == butType && listofDelType.contains(optionRecord.Deliverable_Type__c)){
                    butValCusSettingSpecDelTypeList.add(rec);
                }
                if(rec.Validation_Type__c == butType && (rec.Deliverable_Type_Name__c == 'All' || rec.Deliverable_Type_Name__c == null || rec.Deliverable_Type_Name__c == '')){
                    butValCusSettingAllDelTypeList.add(rec);
                    butValCusSettingAllDelTypeList.sort();
                }
                if(rec.Validation_Type__c == butType && (listofDelType.contains(optionRecord.Deliverable_Type__c) || rec.Deliverable_Type_Name__c == 'All' || rec.Deliverable_Type_Name__c == null || rec.Deliverable_Type_Name__c == '')){
                    butValCusSettingAllandSpecDelTypeList.add(rec);
                    butValCusSettingAllandSpecDelTypeList.sort();
                }
            }
        }
        string validationmessage = '';
        if(butType == 'BidnQuote'){validationmessage = validationmessage + '<b>Please enter value for below fields before RFQ creation. RFI still available after click OK button :</b>';}
        if(butType == 'TryforFit'){ValidationMessage = validationmessage + '<b>Please enter value for below fields before adding Deliverable Type : </b>';}
        string url = '/apex/BnP_OptionDeliverableType?scontrolCaching=1&id='+ optionid + '&DT=' + optionRecord.Deliverable_Type__c;
        wrapList =new list<myWrapper>();
        if(!oppRecord.isEmpty()){
            if(butValCusSettingSpecDelTypeList.size() > 0){
                if(butValCusSettingAllandSpecDelTypeList.size() > 0){
                    for(BnPButtonValidationFieldMapping__c objName : butValCusSettingAllandSpecDelTypeList){
                        Set<String> listofProductLine = new Set<String>();
                        if(objName.Product_Line__c != '' && objName.Product_Line__c != null){
                            listofProductLine.addAll(objName.Product_Line__c.split('[,;]'));
                        }
                        if(objName.Object_Name__c == 'Option'){
                            if(objName.Product_Line__c != 'All' && objName.Product_Line__c != '' && objName.Product_Line__c != null){
                                if(listofProductLine.contains(oppRecord[0].Product_Line__c)){  
                                    if(optionRecord.get(objName.Field_Api__c) == null){
                                        optFieldVal = true;
                                        wrapList.add(new myWrapper(objName.Field_Label__c, optionRecord.id, optionRecord.Name));
                                    }
                                }
                            }else{
                                if(optionRecord.get(objName.Field_Api__c) == null){
                                    optFieldVal = true;
                                    wrapList.add(new myWrapper(objName.Field_Label__c, optionRecord.id, optionRecord.Name));
                                }
                            }
                        }
                        if(objName.Object_Name__c == 'Design'){
                            if(objName.Product_Line__c != 'All' && objName.Product_Line__c != '' && objName.Product_Line__c != null){
                                if(listofProductLine.contains(oppRecord[0].Product_Line__c)){
                                    if(objName.isRecordPresent__c){
                                        if(designRecord.size() > 0){
                                            if(designRecord[0].get(objName.Field_Api__c) == null){
                                                desFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, designRecord[0].id, designRecord[0].Name));
                                            }
                                        }
                                    }else{
                                        if(designRecord.size() > 0){
                                            if(designRecord[0].get(objName.Field_Api__c) == null){
                                                desFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, designRecord[0].id, designRecord[0].Name));
                                            }
                                        }else{
                                            desFieldVal = true;
                                            wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                        }
                                    }
                                }
                            }else{
                                if(objName.isRecordPresent__c){
                                        if(designRecord.size() > 0){
                                            if(designRecord[0].get(objName.Field_Api__c) == null){
                                                desFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, designRecord[0].id, designRecord[0].Name));
                                            }
                                        }
                                }else{
                                    if(designRecord.size() > 0){
                                        if(designRecord[0].get(objName.Field_Api__c) == null){
                                            desFieldVal = true;
                                            wrapList.add(new myWrapper(objName.Field_Label__c, designRecord[0].id, designRecord[0].Name));
                                        }
                                    }else{
                                        desFieldVal = true;
                                        wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                    }
                                }
                            }
                        }
                        if(objName.Object_Name__c == 'Wafer'){
                            if(objName.Product_Line__c != 'All' && objName.Product_Line__c != '' && objName.Product_Line__c != null){
                                if(listofProductLine.contains(oppRecord[0].Product_Line__c)){
                                    if(objName.isRecordPresent__c){
                                        if(waferRecord.size() > 0){
                                            if(waferRecord[0].get(objName.Field_Api__c) == null){
                                                wafFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, waferRecord[0].id, waferRecord[0].Name));
                                            }
                                        }
                                    }else{
                                        if(waferRecord.size() > 0){
                                            if(waferRecord[0].get(objName.Field_Api__c) == null){
                                                wafFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, waferRecord[0].id, waferRecord[0].Name));
                                            }
                                        }else{
                                            wafFieldVal = true;
                                            wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                        }
                                    }
                                }
                            }else{
                                if(objName.isRecordPresent__c){
                                    if(waferRecord.size() > 0){
                                        if(waferRecord[0].get(objName.Field_Api__c) == null){
                                            wafFieldVal = true;
                                            wrapList.add(new myWrapper(objName.Field_Label__c, waferRecord[0].id, waferRecord[0].Name));
                                        }
                                    }
                                }else{
                                    if(waferRecord.size() > 0){
                                        if(waferRecord[0].get(objName.Field_Api__c) == null){
                                            wafFieldVal = true;
                                            wrapList.add(new myWrapper(objName.Field_Label__c, waferRecord[0].id, waferRecord[0].Name));
                                        }
                                    }else{
                                        wafFieldVal = true;
                                        wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                    }
                                }

                            }
                        }
                        if(objName.Object_Name__c == 'Chip'){
                            if(objName.Product_Line__c != 'All' && objName.Product_Line__c != '' && objName.Product_Line__c != null){
                                if(listofProductLine.contains(oppRecord[0].Product_Line__c)){
                                    if(objName.isRecordPresent__c){
                                        if(chipRecord.size() > 0){
                                            if(chipRecord[0].get(objName.Field_Api__c) == null){
                                                chipFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, chipRecord[0].id, chipRecord[0].Name));
                                            }
                                        }
                                    }else{
                                        if(chipRecord.size() > 0){
                                            if(chipRecord[0].get(objName.Field_Api__c) == null){
                                                chipFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, chipRecord[0].id, chipRecord[0].Name));
                                            }
                                        }else{
                                            chipFieldVal = true;
                                            wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                        }
                                    }
                                }
                            }else{
                                if(objName.isRecordPresent__c){
                                    if(chipRecord.size() > 0){
                                        if(chipRecord[0].get(objName.Field_Api__c) == null){
                                            chipFieldVal = true;
                                            wrapList.add(new myWrapper(objName.Field_Label__c, chipRecord[0].id, chipRecord[0].Name));
                                        }
                                    }
                                }else{
                                    if(chipRecord.size() > 0){
                                        if(chipRecord[0].get(objName.Field_Api__c) == null){
                                            chipFieldVal = true;
                                             wrapList.add(new myWrapper(objName.Field_Label__c, chipRecord[0].id, chipRecord[0].Name));
                                        }
                                    }else{
                                        chipFieldVal = true;
                                         wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                    }
                                }
                            }
                        }
                        if(objName.Object_Name__c == 'Package'){
                            if(objName.Product_Line__c != 'All' && objName.Product_Line__c != '' && objName.Product_Line__c != null){
                                if(listofProductLine.contains(oppRecord[0].Product_Line__c)){
                                    if(objName.isRecordPresent__c){
                                        if(packageRecord.size() > 0){
                                            if(packageRecord[0].get(objName.Field_Api__c) == null){
                                                packFieldVal = true;
                                                 wrapList.add(new myWrapper(objName.Field_Label__c, packageRecord[0].id, packageRecord[0].Name));
                                            }
                                        }
                                    }else{
                                        if(packageRecord.size() > 0){
                                            if(packageRecord[0].get(objName.Field_Api__c) == null){
                                                packFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, packageRecord[0].id, packageRecord[0].Name));
                                            }
                                        }else{
                                             wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                            packFieldVal = true;
                                        }
                                    }
                                }
                            }else{
                                if(objName.isRecordPresent__c){
                                        if(packageRecord.size() > 0){
                                            if(packageRecord[0].get(objName.Field_Api__c) == null){
                                                packFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, packageRecord[0].id, packageRecord[0].Name));
                                            }
                                        }
                                }else{
                                    if(packageRecord.size() > 0){
                                        if(packageRecord[0].get(objName.Field_Api__c) == null){
                                            packFieldVal = true;
                                            wrapList.add(new myWrapper(objName.Field_Label__c, packageRecord[0].id, packageRecord[0].Name));
                                        }
                                    }else{
                                        wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                        packFieldVal = true;
                                    }
                                }
                            }
                        }
                        if(objName.Object_Name__c == 'Module'){
                            if(objName.Product_Line__c != 'All' && objName.Product_Line__c != '' && objName.Product_Line__c != null){
                                if(listofProductLine.contains(oppRecord[0].Product_Line__c)){
                                    if(objName.isRecordPresent__c){
                                        if(moduleRecord.size() > 0){
                                            if(moduleRecord[0].get(objName.Field_Api__c) == null){
                                                modFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, moduleRecord[0].id, moduleRecord[0].Name));
                                            }
                                        }
                                    }else{
                                        if(moduleRecord.size() > 0){
                                            if(moduleRecord[0].get(objName.Field_Api__c) == null){
                                                modFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, moduleRecord[0].id, moduleRecord[0].Name));
                                            }
                                        }else{
                                            wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                            modFieldVal = true;
                                        }
                                    }
                                }
                            }else{
                                if(objName.isRecordPresent__c){
                                        if(moduleRecord.size() > 0){
                                            if(moduleRecord[0].get(objName.Field_Api__c) == null){
                                                modFieldVal = true;
                                                 wrapList.add(new myWrapper(objName.Field_Label__c, moduleRecord[0].id, moduleRecord[0].Name));
                                            }
                                        }
                                }else{
                                    if(moduleRecord.size() > 0){
                                        if(moduleRecord[0].get(objName.Field_Api__c) == null){
                                            modFieldVal = true;
                                            wrapList.add(new myWrapper(objName.Field_Label__c, moduleRecord[0].id, moduleRecord[0].Name));
                                        }
                                    }else{
                                        wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                        modFieldVal = true;
                                    }
                                }
                            }
                        }
                        if(objName.Object_Name__c == 'Service'){
                            if(objName.Product_Line__c != 'All' && objName.Product_Line__c != '' && objName.Product_Line__c != null){
                                if(listofProductLine.contains(oppRecord[0].Product_Line__c)){
                                    if(objName.isRecordPresent__c){
                                        if(serviceRecord.size() > 0){
                                            if(serviceRecord[0].get(objName.Field_Api__c) == null){
                                                serFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, serviceRecord[0].id, serviceRecord[0].Name));
                                            }
                                        }
                                    }else{
                                        if(serviceRecord.size() > 0){
                                            if(serviceRecord[0].get(objName.Field_Api__c) == null){
                                                serFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, serviceRecord[0].id, serviceRecord[0].Name));
                                            }
                                        }else{
                                            wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                            serFieldVal = true;
                                        }
                                    }
                                }
                            }else{
                                if(objName.isRecordPresent__c){
                                        if(serviceRecord.size() > 0){
                                            if(serviceRecord[0].get(objName.Field_Api__c) == null){
                                                serFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, serviceRecord[0].id, serviceRecord[0].Name));
                                            }
                                        }
                                }else{
                                    if(serviceRecord.size() > 0){
                                        if(serviceRecord[0].get(objName.Field_Api__c) == null){
                                            serFieldVal = true;
                                            wrapList.add(new myWrapper(objName.Field_Label__c, serviceRecord[0].id, serviceRecord[0].Name));
                                        }
                                    }else{
                                        wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                        serFieldVal = true;
                                    }
                                }
                            }
                        }
                        if(objName.Object_Name__c == 'Device'){
                            if(objName.Product_Line__c != 'All' && objName.Product_Line__c != '' && objName.Product_Line__c != null){
                                if(listofProductLine.contains(oppRecord[0].Product_Line__c)){
                                    if(deviceRecord.size() > 0){
                                        if(deviceRecord[0].get(objName.Field_Api__c) == null){
                                            devFieldVal = true;
                                            wrapList.add(new myWrapper(objName.Field_Label__c, deviceRecord[0].id, deviceRecord[0].Name));
                                        }
                                    }
                                }
                            }else{
                                if(deviceRecord.size() > 0){
                                    if(deviceRecord[0].get(objName.Field_Api__c) == null){
                                        devFieldVal = true;
                                        wrapList.add(new myWrapper(objName.Field_Label__c, deviceRecord[0].id, deviceRecord[0].Name));
                                    }
                                }
                            }
                        }
                        if(objName.Object_Name__c == 'Opportunity'){
                            if(objName.Product_Line__c != 'All' && objName.Product_Line__c != '' && objName.Product_Line__c != null){
                                if(listofProductLine.contains(oppRecord[0].Product_Line__c)){ 
                                    if(oppRecord[0].get(objName.Field_Api__c) == null){
                                        oppFieldVal = true;
                                        wrapList.add(new myWrapper(objName.Field_Label__c, oppRecord[0].id, oppRecord[0].Name));
                                    }
                                }
                            }else{
                                if(oppRecord[0].get(objName.Field_Api__c) == null){
                                    oppFieldVal = true;
                                    wrapList.add(new myWrapper(objName.Field_Label__c, oppRecord[0].id, oppRecord[0].Name));
                                }
                            }
                        }
                    }
                }   
            }else{
                if(butValCusSettingAllDelTypeList.size() > 0){
                    for(BnPButtonValidationFieldMapping__c objName : butValCusSettingAllDelTypeList){
                        Set<String> listofProductLine = new Set<String>();
                        if(objName.Product_Line__c != '' && objName.Product_Line__c != null){
                            listofProductLine.addAll(objName.Product_Line__c.split('[,;]'));
                        }
                        system.debug('Field Label :' +objName);
                        if(objName.Object_Name__c == 'Option'){
                            if(objName.Product_Line__c != 'All' && objName.Product_Line__c != '' && objName.Product_Line__c != null){
                                if(listofProductLine.contains(oppRecord[0].Product_Line__c)){  
                                    if(optionRecord.get(objName.Field_Api__c) == null){
                                        optFieldVal = true;
                                        wrapList.add(new myWrapper(objName.Field_Label__c, optionRecord.id, optionRecord.Name));
                                    }
                                }
                            }else{
                                if(optionRecord.get(objName.Field_Api__c) == null){
                                    optFieldVal = true;
                                    wrapList.add(new myWrapper(objName.Field_Label__c, optionRecord.id, optionRecord.Name));
                                }
                            }
                        }
                        if(objName.Object_Name__c == 'Design'){
                            if(objName.Product_Line__c != 'All' && objName.Product_Line__c != '' && objName.Product_Line__c != null){
                                if(listofProductLine.contains(oppRecord[0].Product_Line__c)){
                                    if(objName.isRecordPresent__c){
                                        if(designRecord.size() > 0){
                                            if(designRecord[0].get(objName.Field_Api__c) == null){
                                                desFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, designRecord[0].id, designRecord[0].Name));
                                            }
                                        }
                                    }else{
                                        if(designRecord.size() > 0){
                                            if(designRecord[0].get(objName.Field_Api__c) == null){
                                                desFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, designRecord[0].id, designRecord[0].Name));
                                            }
                                        }else{
                                            desFieldVal = true;
                                            wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                        }
                                    }
                                }
                            }else{
                                if(objName.isRecordPresent__c){
                                        if(designRecord.size() > 0){
                                            if(designRecord[0].get(objName.Field_Api__c) == null){
                                                desFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, designRecord[0].id, designRecord[0].Name));
                                            }
                                        }
                                }else{
                                    if(designRecord.size() > 0){
                                        if(designRecord[0].get(objName.Field_Api__c) == null){
                                            desFieldVal = true;
                                            wrapList.add(new myWrapper(objName.Field_Label__c, designRecord[0].id, designRecord[0].Name));
                                        }
                                    }else{
                                        desFieldVal = true;
                                        wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                    }
                                }
                            }
                        }
                        if(objName.Object_Name__c == 'Wafer'){
                            if(objName.Product_Line__c != 'All' && objName.Product_Line__c != '' && objName.Product_Line__c != null){
                                if(listofProductLine.contains(oppRecord[0].Product_Line__c)){
                                    if(objName.isRecordPresent__c){
                                        if(waferRecord.size() > 0){
                                            if(waferRecord[0].get(objName.Field_Api__c) == null){
                                                wafFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, waferRecord[0].id, waferRecord[0].Name));
                                            }
                                        }
                                    }else{
                                        if(waferRecord.size() > 0){
                                            if(waferRecord[0].get(objName.Field_Api__c) == null){
                                                wafFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, waferRecord[0].id, waferRecord[0].Name));
                                            }
                                        }else{
                                            wafFieldVal = true;
                                            wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                        }
                                    }
                                }
                            }else{
                                if(objName.isRecordPresent__c){
                                    if(waferRecord.size() > 0){
                                        if(waferRecord[0].get(objName.Field_Api__c) == null){
                                            wafFieldVal = true;
                                            wrapList.add(new myWrapper(objName.Field_Label__c, waferRecord[0].id, waferRecord[0].Name));
                                        }
                                    }
                                }else{
                                    if(waferRecord.size() > 0){
                                        if(waferRecord[0].get(objName.Field_Api__c) == null){
                                            wafFieldVal = true;
                                            wrapList.add(new myWrapper(objName.Field_Label__c, waferRecord[0].id, waferRecord[0].Name));
                                        }
                                    }else{
                                        wafFieldVal = true;
                                        wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                    }
                                }

                            }
                        }
                        if(objName.Object_Name__c == 'Chip'){
                            if(objName.Product_Line__c != 'All' && objName.Product_Line__c != '' && objName.Product_Line__c != null){
                                if(listofProductLine.contains(oppRecord[0].Product_Line__c)){
                                    if(objName.isRecordPresent__c){
                                        if(chipRecord.size() > 0){
                                            if(chipRecord[0].get(objName.Field_Api__c) == null){
                                                chipFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, chipRecord[0].id, chipRecord[0].Name));
                                            }
                                        }
                                    }else{
                                        if(chipRecord.size() > 0){
                                            if(chipRecord[0].get(objName.Field_Api__c) == null){
                                                chipFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, chipRecord[0].id, chipRecord[0].Name));
                                            }
                                        }else{
                                            chipFieldVal = true;
                                            wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                        }
                                    }
                                }
                            }else{
                                if(objName.isRecordPresent__c){
                                    if(chipRecord.size() > 0){
                                        if(chipRecord[0].get(objName.Field_Api__c) == null){
                                            chipFieldVal = true;
                                            wrapList.add(new myWrapper(objName.Field_Label__c, chipRecord[0].id, chipRecord[0].Name));
                                        }
                                    }
                                }else{
                                    if(chipRecord.size() > 0){
                                        if(chipRecord[0].get(objName.Field_Api__c) == null){
                                            chipFieldVal = true;
                                             wrapList.add(new myWrapper(objName.Field_Label__c, chipRecord[0].id, chipRecord[0].Name));
                                        }
                                    }else{
                                        chipFieldVal = true;
                                        wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                    }
                                }
                            }
                        }
                        if(objName.Object_Name__c == 'Package'){
                            if(objName.Product_Line__c != 'All' && objName.Product_Line__c != '' && objName.Product_Line__c != null){
                                if(listofProductLine.contains(oppRecord[0].Product_Line__c)){
                                    if(objName.isRecordPresent__c){
                                        if(packageRecord.size() > 0){
                                            if(packageRecord[0].get(objName.Field_Api__c) == null){
                                                packFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, packageRecord[0].id, packageRecord[0].Name));
                                            }
                                        }
                                    }else{
                                        if(packageRecord.size() > 0){
                                            if(packageRecord[0].get(objName.Field_Api__c) == null){
                                                packFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, packageRecord[0].id, packageRecord[0].Name));
                                            }
                                        }else{
                                            wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                            packFieldVal = true;
                                        }
                                    }
                                }
                            }else{
                                if(objName.isRecordPresent__c){
                                        if(packageRecord.size() > 0){
                                            if(packageRecord[0].get(objName.Field_Api__c) == null){
                                                packFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, packageRecord[0].id, packageRecord[0].Name));
                                            }
                                        }
                                }else{
                                    if(packageRecord.size() > 0){
                                        if(packageRecord[0].get(objName.Field_Api__c) == null){
                                            packFieldVal = true;
                                             wrapList.add(new myWrapper(objName.Field_Label__c, packageRecord[0].id, packageRecord[0].Name));
                                        }
                                    }else{
                                        wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                        packFieldVal = true;
                                    }
                                }
                            }
                        }
                        if(objName.Object_Name__c == 'Module'){
                            if(objName.Product_Line__c != 'All' && objName.Product_Line__c != '' && objName.Product_Line__c != null){
                                if(listofProductLine.contains(oppRecord[0].Product_Line__c)){
                                    if(objName.isRecordPresent__c){
                                        if(moduleRecord.size() > 0){
                                            if(moduleRecord[0].get(objName.Field_Api__c) == null){
                                                modFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, moduleRecord[0].id, moduleRecord[0].Name));
                                            }
                                        }
                                    }else{
                                        if(moduleRecord.size() > 0){
                                            if(moduleRecord[0].get(objName.Field_Api__c) == null){
                                                modFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, moduleRecord[0].id, moduleRecord[0].Name));
                                            }
                                        }else{
                                            wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                            modFieldVal = true;
                                        }
                                    }
                                }
                            }else{
                                if(objName.isRecordPresent__c){
                                        if(moduleRecord.size() > 0){
                                            if(moduleRecord[0].get(objName.Field_Api__c) == null){
                                                modFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, moduleRecord[0].id, moduleRecord[0].Name));
                                            }
                                        }
                                }else{
                                    if(moduleRecord.size() > 0){
                                        if(moduleRecord[0].get(objName.Field_Api__c) == null){
                                            modFieldVal = true;
                                             wrapList.add(new myWrapper(objName.Field_Label__c, moduleRecord[0].id, moduleRecord[0].Name));
                                        }
                                    }else{
                                        wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                        modFieldVal = true;
                                    }
                                }
                            }
                        }
                        if(objName.Object_Name__c == 'Service'){
                            if(objName.Product_Line__c != 'All' && objName.Product_Line__c != '' && objName.Product_Line__c != null){
                                if(listofProductLine.contains(oppRecord[0].Product_Line__c)){
                                    if(objName.isRecordPresent__c){
                                        if(serviceRecord.size() > 0){
                                            if(serviceRecord[0].get(objName.Field_Api__c) == null){
                                                serFieldVal = true;
                                                 wrapList.add(new myWrapper(objName.Field_Label__c, serviceRecord[0].id, serviceRecord[0].Name));
                                            }
                                        }
                                    }else{
                                        if(serviceRecord.size() > 0){
                                            if(serviceRecord[0].get(objName.Field_Api__c) == null){
                                                serFieldVal = true;
                                                 wrapList.add(new myWrapper(objName.Field_Label__c, serviceRecord[0].id, serviceRecord[0].Name));
                                            }
                                        }else{
                                            wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Record Not Present: Create '+objName.Object_Name__c));
                                            serFieldVal = true;
                                        }
                                    }
                                }
                            }else{
                                if(objName.isRecordPresent__c){
                                        if(serviceRecord.size() > 0){
                                            if(serviceRecord[0].get(objName.Field_Api__c) == null){
                                                serFieldVal = true;
                                                wrapList.add(new myWrapper(objName.Field_Label__c, serviceRecord[0].id, serviceRecord[0].Name));
                                            }
                                        }
                                }else{
                                    if(serviceRecord.size() > 0){
                                        if(serviceRecord[0].get(objName.Field_Api__c) == null){
                                            serFieldVal = true;
                                             wrapList.add(new myWrapper(objName.Field_Label__c, serviceRecord[0].id, serviceRecord[0].Name));
                                        }
                                    }else{
                                        wrapList.add(new myWrapper(objName.Field_Label__c, url, 'Create '+objName.Object_Name__c));
                                        serFieldVal = true;
                                    }
                                }
                            }
                        }
                        if(objName.Object_Name__c == 'Device'){
                            if(objName.Product_Line__c != 'All' && objName.Product_Line__c != '' && objName.Product_Line__c != null){
                                if(listofProductLine.contains(oppRecord[0].Product_Line__c)){
                                    if(deviceRecord.size() > 0){
                                        if(deviceRecord[0].get(objName.Field_Api__c) == null){
                                            devFieldVal = true;
                                            wrapList.add(new myWrapper(objName.Field_Label__c, deviceRecord[0].id, deviceRecord[0].Name));
                                        }
                                    }
                                }
                            }else{
                                if(deviceRecord.size() > 0){
                                    if(deviceRecord[0].get(objName.Field_Api__c) == null){
                                        devFieldVal = true;
                                        wrapList.add(new myWrapper(objName.Field_Label__c, deviceRecord[0].id, deviceRecord[0].Name));
                                    }
                                }
                            }
                        }
                        if(objName.Object_Name__c == 'Opportunity'){
                            if(objName.Product_Line__c != 'All' && objName.Product_Line__c != '' && objName.Product_Line__c != null){
                                if(listofProductLine.contains(oppRecord[0].Product_Line__c)){ 
                                    if(oppRecord[0].get(objName.Field_Api__c) == null){
                                        oppFieldVal = true;
                                        wrapList.add(new myWrapper(objName.Field_Label__c, oppRecord[0].id, oppRecord[0].Name));
                                    }
                                }
                            }else{
                                if(oppRecord[0].get(objName.Field_Api__c) == null){
                                    oppFieldVal = true;
                                    wrapList.add(new myWrapper(objName.Field_Label__c, oppRecord[0].id, oppRecord[0].Name));
                                }
                            }
                        }
                    }
                }
            }
        }
        if(butType == 'BidnQuote'){
            if((optionRecord.Opportunity__r.Product_Line__c != 'RF' && (optionRecord.Opportunity__r.StageName != '1. Discovery' && optionRecord.Opportunity__r.StageName != '0.Pre-Discovery') && (optionRecord.Opportunity__r.Deal_Grading_Status__c == 'Complete - Proceed to Quote' || optionRecord.Opportunity__r.Deal_Grading_Status__c == 'Complete - Review Not Required')) || (optionRecord.Opportunity__r.Product_Line__c == 'RF' && (optionRecord.Opportunity__r.StageName != '1. Discovery' && optionRecord.Opportunity__r.StageName != '0.Pre-Discovery'))){
                if(optFieldVal || desFieldVal || wafFieldVal || chipFieldVal || packFieldVal || modFieldVal || serFieldVal || devFieldVal || oppFieldVal){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.warning,+validationmessage);
                    ApexPages.addMessage(myMsg);
                    return null;
                }else{
                    myVFPage = new PageReference('/setup/ui/recordtypeselect.jsp?ent='+reqInfoObjId+'&save_new_url=/'+ObjectKeyPrefix+'/e?retURL=/apex/BnPRequestInfoRelatedList?id='+optionid+'&'+reqInfoAccId+'='+accName+'&'+reqInfoAccId+'_lkid='+accId+'&'+reqInfoOppId+'='+oppName+'&'+reqInfoOppId+'_lkid='+oppId+'&'+reqInfoOptId+'='+optionName+'&'+reqInfoOptId+'_lkid='+optionId+'&'+reqInfoDevId+'='+devName+'&'+reqInfoDevId+'_lkid='+devId+'&retURL=/apex/BnPRequestInfoRelatedList?id='+optionId);
                    return myVFPage;
                }
            }else 
            { 
                myVFPage = new PageReference('/'+ObjectKeyPrefix+'/e?RecordType='+reqInfoRFIRecTypeId+'&nooverride=1&'+reqInfoAccId+'='+accName+'&'+reqInfoAccId+'_lkid='+accId+'&'+reqInfoOppId+'='+oppName+'&'+reqInfoOppId+'_lkid='+oppId+'&'+reqInfoOptId+'='+optionName+'&'+reqInfoOptId+'_lkid='+optionId+'&'+reqInfoDevId+'='+devName+'&'+reqInfoDevId+'_lkid='+devId+'&retURL=/apex/BnPRequestInfoRelatedList?id='+optionId);
                return myVFPage;
            }
        }else if(butType == 'TryforFit'){
            if(optFieldVal || desFieldVal || wafFieldVal || chipFieldVal || packFieldVal || modFieldVal || serFieldVal || devFieldVal || oppFieldVal){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.warning,+validationmessage);
                    ApexPages.addMessage(myMsg);
                    return null;
            }else{
                    myVFPage = new PageReference('/apex/BnP_OptionDeliverableType?scontrolCaching=1&id='+ optionid + '&DT=' + optionRecord.Deliverable_Type__c);
                    return myVFPage;
            }
        }else{
            return null;
        }
    }
    /**
    *  The Purpose of this method is to redirect to RFI creation page.
    *  @name <ok>
    *  @param <> 
    *  @return <PageReference>
    *  @throws exception-<>
    */
    public PageReference rfiPageRedirection(){
        Schema.DescribeSObjectResult r = Request_Information__c.sObjectType.getDescribe();
        String ObjectKeyPrefix = r.getKeyPrefix(); 
        String accName = optionRecord.Opportunity__r.Account.Name;
        String accId = optionRecord.Opportunity__r.AccountId;
        String devName = optionRecord.Device__r.Name;
        String devId = optionRecord.Device__c;
        String oppName = optionRecord.Opportunity__r.Name;
        String oppId = optionRecord.Opportunity__c;
        String optionName = optionRecord.Name;
        String reqInfoObjId = System.Label.BnP_ReqInfo_ObjId;
        String reqInfoAccId = System.Label.BnP_ReqInfo_AccId;
        String reqInfoOppId = System.Label.BnP_ReqInfo_OppId;
        String reqInfoOptId = System.Label.BnP_ReqInfo_OptId;
        String reqInfoDevId = System.Label.BnP_ReqInfo_DevId;
        String reqInfoRFIRecTypeId = System.Label.BnP_ReqInfo_RFI_RecTypeId;
        PageReference myVFPage = new PageReference('/'+ObjectKeyPrefix+'/e?RecordType='+reqInfoRFIRecTypeId+'&nooverride=1&'+reqInfoAccId+'='+accName+'&'+reqInfoAccId+'_lkid='+accId+'&'+reqInfoOppId+'='+oppName+'&'+reqInfoOppId+'_lkid='+oppId+'&'+reqInfoOptId+'='+optionName+'&'+reqInfoOptId+'_lkid='+optionid+'&'+reqInfoDevId+'='+devName+'&'+reqInfoDevId+'_lkid='+devId+'&retURL=/apex/BnPRequestInfoRelatedList?id='+optionid);
        return myVFPage;
    }
    /**
    *  The Purpose of this method is to return back to previous page.
    *  @name <cancel>
    *  @param <> 
    *  @return <PageReference>
    *  @throws exception-<>
    */
    public PageReference cancel(){
        PageReference myVFPage = new PageReference('/apex/BnPRequestInfoRelatedList?id='+optionid);
        myVFPage.setRedirect(true);
        return myVFPage;
    }
    /**
    *  The Purpose of this method is to redirect to option detail page.
    *  @name <ok>
    *  @param <> 
    *  @return <PageReference>
    *  @throws exception-<>
    */
    public PageReference ok(){
        PageReference myVFPage = new PageReference('/'+optionid);
        myVFPage.setRedirect(true);
        return myVFPage;
    }
    /**
    *  This is a wrapper class to store record id, name and field label.
    *  @name <myWrapper>
    *  @param <NA> 
    *  @return <NA>
    *  @throws exception-<>
    */
    public class myWrapper{
        public string fieldlabel {get;set;}
        public string recId {get;set;}
        public string recName {get;set;}
        
        public myWrapper(string fl, string rId, string rName){
            fieldlabel = fl;
            recId = rId;
            recName = rName;
        }
    }
}