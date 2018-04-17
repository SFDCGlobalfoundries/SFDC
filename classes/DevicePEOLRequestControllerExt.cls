/*
*  Author: Sreedhar Karukonda
*  Description: DevicePEOLRequestControllerExt  is controller extension for DevicePEOLRequestPage. 
*                It shows available devices for PEOL ad user can select perticular device and Fab combination for PEOL and Save the PEOL.
* History:
*   Sreedhar Karukonda         15102015    - code creation.
*/

// This class is intentionally made global. submitForApproval method is called from button in details page.
public with sharing class DevicePEOLRequestControllerExt {
    
    public static final Integer PAGE_SIZE = UtilsString.isNotBlank(EnvironmentVariable.get('DEVICE_REQUEST_PEOL_PAGE_SIZE')) ?
                                            Integer.valueOf(EnvironmentVariable.get('DEVICE_REQUEST_PEOL_PAGE_SIZE')) : 20;
    public static final Integer PEOL_CAN_GO_UPTO = UtilsString.isNotBlank(EnvironmentVariable.get('DEVICE_REQUEST_PEOL_CAN_GO_UPTO')) ?
                                            Integer.valueOf(EnvironmentVariable.get('DEVICE_REQUEST_PEOL_CAN_GO_UPTO')) :30;

    public final Device_PEOL_Request__c peolRequest{get; set;}
    public String deviceNameForSearch{get; set;}
    public boolean hasNext{ get; set;}
    public boolean hasPrevious{ get; set;}
    public Map<String, ErpDeviceWrapper> forCustomerItemsReference{get; set;}
    public List<Device_PEOL_Request_Detail__c> deleteTheseRequestDetials{
        get{
            if(deleteTheseRequestDetials == null) deleteTheseRequestDetials = new List<Device_PEOL_Request_Detail__c>();
            return deleteTheseRequestDetials;
        }
        set;
    }
    
    
    public DevicePEOLRequestControllerExt(ApexPages.StandardController stdController) {
        this.peolRequest = (Device_PEOL_Request__c)stdController.getRecord();
    }
    
    private ApexPages.StandardSetController setController{
        get{
            if(setController == null){
                setController = new ApexPages.StandardSetController(Database.getQueryLocator(buildQuery(peolRequest)));
                setController.setPageSize(PAGE_SIZE);
            }
            return setController;
        }
        set;
    }
    
    public PageReference searchDevices(){
        displayDevices = null;
        setController = null;
        forCustomerItemsReference = null;
        return null;
    }

    public Map<String, String> previousStatusMap{get; set;}
    public List<ErpDeviceWrapper> displayDevices{
        get{
            if(displayDevices == null ){
                if( peolRequest.Customer__c != null){
                    forCustomerItemsReference = convertToWrappers(setController.getRecords(), peolRequest.Fab__c);
                    hasNext = setController.getHasNext();
                    hasPrevious = setController.getHasPrevious();
                    
                }else{
                    forCustomerItemsReference = new Map<String, ErpDeviceWrapper>();
                }
            }
            
            for( String deviceFabString :  forCustomerItemsReference.keySet()){
                if(previousStatusMap.get(deviceFabString) != null)
                forCustomerItemsReference.get(deviceFabString).previousStatus = previousStatusMap.get(deviceFabString);
            }
            // Temporary variable to hold the value
            Map<String, ErpDeviceWrapper> tempMap =  forCustomerItemsReference;
            for(Device_PEOL_Request_Detail__c detail : addedDevices){
                tempMap.remove(detail.ERP_Device__c+'-'+detail.Fab__c);
            }
            return tempMap.values();
        }
        set;
    }
    
    public List<Device_PEOL_Request_Detail__c> addedDevices{
        get{
            if(addedDevices == null){
                if(peolRequest.Id == null){
                    addedDevices = new List<Device_PEOL_Request_Detail__c>();
                }else{
                   addedDevices =[SELECT Id, Last_Time_Ship_Date__c, Last_Time_Buy_Date__c, ERP_Device__c, ERP_Device__r.Name, Fab__c, Customer_Item__c
                                    from Device_PEOL_Request_Detail__c where Device_PEOL_Request__c =:peolRequest.Id];
                }
            }
            return addedDevices;
        } 
        set;
    }
     
    //For Delete button click will pass this and using this variable data is deleted from addedDevices
    public String removeThisDevice{get; set;}
    
    public PageReference removeDeviceFromAddredDevices(){

        for(Integer index = 0;  index < addedDevices.size(); index++){
            if(removeThisDevice == (addedDevices[index].ERP_Device__c == null? '': addedDevices[index].ERP_Device__c)+'-'+addedDevices[index].Fab__c){
                Device_PEOL_Request_Detail__c detail = addedDevices.get(index);
                if(detail.Id != null){
                    deleteTheseRequestDetials.add(detail);
                }
                addedDevices.remove(index);
            }
        }
        //Reset remove Device Details 
        removeThisDevice = null;
        return null;
    }
    
    public PageReference savePEOLRequest(){
        Savepoint sp = Database.setSavepoint();
        try{
            // Validation : Last Time Ship Date should be equal or greater than Last Time Buy Date. Otherwise throw an error.
            String dateValidationMessage = '';
            boolean dateValidatingErrorFlag = false;
            
            if(addedDevices.size() == 0){
                ApexPages.addmessage( new ApexPages.Message(ApexPages.Severity.FATAL, 'Please add devices to the request.'));
                return null;
            }

            for(Device_PEOL_Request_Detail__c requestDetails: addedDevices){
                if(requestDetails.Last_Time_Ship_Date__c < requestDetails.Last_Time_Buy_Date__c){
                    dateValidatingErrorFlag = true;
                    dateValidationMessage = 'Device : '+ requestDetails.ERP_Device__r.Name +' and Fab :'+ requestDetails.Fab__c + 
                                                ' Last Time Ship Date can not be greater than Last Time Buy Date \n';
                }
                if( requestDetails.Last_Time_Ship_Date__c < Datetime.now().addDays(-PEOL_CAN_GO_UPTO) ||
                    requestDetails.Last_Time_Buy_Date__c < Datetime.now().addDays(-PEOL_CAN_GO_UPTO) ){
                    dateValidatingErrorFlag = true;
                    dateValidationMessage = 'Device : '+ requestDetails.ERP_Device__r.Name +' and Fab :'+ requestDetails.Fab__c + 
                                                'should not have "Last Time Ship Date" and "Last Time Buy Date" should not go in to the past more than '+PEOL_CAN_GO_UPTO+' days\n';
                }
            }
            if(dateValidatingErrorFlag){
                ApexPages.addmessage( new ApexPages.Message(ApexPages.Severity.FATAL, dateValidationMessage));
                return null;
            }
            
            upsert peolRequest;
            for(Device_PEOL_Request_Detail__c requestDetails: addedDevices){
                if(requestDetails.id == null)
                    requestDetails.Device_PEOL_Request__c = peolRequest.Id;
            }
            if(!deleteTheseRequestDetials.isEmpty()){
                delete deleteTheseRequestDetials;
            }
            upsert addedDevices;
            return new PageReference('/'+ peolRequest.Id);
        }catch(Exception ex){
            Database.rollback(sp);
            ApexPages.addmessage( new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            return null;
        }
    }
    
    public PageReference getNext(){
        setController.next();
        forCustomerItemsReference = convertToWrappers(setController.getRecords(), peolRequest.Fab__c);
        hasNext = setController.getHasNext();
        hasPrevious = setController.getHasPrevious();
        return null;
    }
    
    public PageReference getPrevious(){
        setController.previous();
        forCustomerItemsReference = convertToWrappers(setController.getRecords(), peolRequest.Fab__c);
        hasNext = setController.getHasNext();
        hasPrevious = setController.getHasPrevious();
        return null;
    }
    
    public PageReference getFirst(){
        setController.first();
        forCustomerItemsReference = convertToWrappers(setController.getRecords(), peolRequest.Fab__c);
        hasNext = setController.getHasNext();
        hasPrevious = setController.getHasPrevious();
        return null;
    }
    
    public PageReference getLast(){
        setController.last();
        forCustomerItemsReference = convertToWrappers(setController.getRecords(), peolRequest.Fab__c);
        hasNext = setController.getHasNext();
        hasPrevious = setController.getHasPrevious();
        return null;
    }
    
    // To be added device key String. Used to find out in the forCustomerItemsReference Data
    public String addThisDeviceWithKey{get; set;}
    
    public PageReference addSelectedDeviceToPEOL(){
        if(forCustomerItemsReference.get(addThisDeviceWithKey) != null){
            ErpDeviceWrapper  wrapper = forCustomerItemsReference.get(addThisDeviceWithKey);
            addedDevices.add(new Device_PEOL_Request_Detail__c(ERP_Device__c = wrapper.customerItem.ERP_Device__c, Customer_Item__c = wrapper.customerItem.Id, Fab__c = wrapper.fab, Device_Fab_For_Query__c = wrapper.customerItem.ERP_Device__c+'-'+wrapper.fab));
        }
        addThisDeviceWithKey = null;
        return null;
    }

    public String buildQuery(Device_PEOL_Request__c peolRecord){
        String query = baseQuery;
        if(peolRecord.Customer__c != null ){
            if( query == baseQuery){
                query += ' WHERE Customer__c = \''+ peolRecord.Customer__c+'\'';
            }else{
                query += ' and Customer__c = \''+ peolRecord.Customer__c+'\'';
            }
        }
        if(peolRecord.Geometry__c != null && peolRecord.Geometry__c != ''){
            if( query == baseQuery){
                query += 'WHERE ERP_Device__r.Geometry__c = \''+ peolRecord.Geometry__c+'\'';
            }else{
                query += ' and ERP_Device__r.Geometry__c = \''+ peolRecord.Geometry__c+'\'';
            }
        }
        if(peolRecord.Fab__c != null && peolRecord.Fab__c != ''){
            if( query == baseQuery){
                query += ' WHERE ERP_Device__r.Fab__c includes  (\''+ peolRecord.Fab__c+'\')';
            }else{
                query += ' and ERP_Device__r.Fab__c includes (\''+ peolRecord.Fab__c+'\')';
            }
        }
        if(peolRecord.Process_Id__c != null ){
            if( query == baseQuery){
                query += ' WHERE ERP_Device__r.Process_Id__c = \''+ peolRecord.Process_Id__c+'\'';
            }else{
                query += ' and ERP_Device__r.Process_Id__c = \''+ peolRecord.Process_Id__c+'\'';
            }
        }
        if(deviceNameForSearch != null && deviceNameForSearch != ''){
            if( query == baseQuery){
                query += ' WHERE ERP_Device__r.Name like \'%'+ deviceNameForSearch+'%\'';
            }else{
                query += ' and ERP_Device__r.Name like \'%'+ deviceNameForSearch+'%\'';
            }
        }
        query += ' ORDER BY Erp_Device__r.Name asc';
        return query;
    }

    public Map<String, ErpDeviceWrapper> convertToWrappers(List<Customer_Item__c> items, String fab){
        //Collect PEOL Unique IDs
        Set<String> peolUniqueStrings = new Set<String>();
        Map<String, ErpDeviceWrapper> wrappers = new Map<String, ErpDeviceWrapper>();
        if(fab == null){
            for(Customer_Item__c item: items){
                List<String>fabs = item.ERP_Device__r.Fab__c.split(';');
                for(String fabx :fabs){
                    wrappers.put(item.ERP_Device__c+'-'+ fabx, new ErpDeviceWrapper(item, fabx));
                    peolUniqueStrings.add(item.ERP_Device__c+'-'+ fabx);
                }
            }
        }else{
            for(Customer_Item__c item: items){
                List<String>fabs = item.ERP_Device__r.Fab__c.split(';');
                for(String fabx :fabs){
                    if(fabx == fab){
                        wrappers.put(item.ERP_Device__c+'-'+ fabx, new ErpDeviceWrapper(item, fabx));
                        peolUniqueStrings.add(item.ERP_Device__c+'-'+ fabx);
                    }
                }
            }
        }

        if(!peolUniqueStrings.isEmpty()){
            List<Device_PEOL_Request_Detail__c> previousPEOLDetails = [select Id, Name, Device_Fab_For_Query__c, Device_PEOL_Request__r.Status__c from Device_PEOL_Request_Detail__c
                                                                             where Device_Fab_For_Query__c in : peolUniqueStrings and Device_PEOL_Request__r.Status__c != 'Failed' 
                                                                             order by createddate desc];
            previousStatusMap = new Map<String, String>();
            for(Device_PEOL_Request_Detail__c details: previousPEOLDetails){
                if(previousStatusMap.get(details.Device_Fab_For_Query__c) == null)
                    previousStatusMap.put(details.Device_Fab_For_Query__c, details.Device_PEOL_Request__r.Status__c );
            }
        }
        return wrappers;
    }

    public String baseQuery{
        get{
            if(baseQuery == null){
                baseQuery = 'SELECT ';
                for(Schema.FieldSetMember f : SObjectType.Customer_Item__c.FieldSets.PEOL_Request_Form.getFields()) {
                    baseQuery += f.getFieldPath() +',';
                }
                baseQuery += 'Id, ERP_Device__r.Name from Customer_Item__c ';
            }
            return baseQuery;
        }
        set;
    }

    public class ErpDeviceWrapper{
        public boolean selected{get; set;}
        public String fab{get; set;}
        public String referenceId{get; set;}
        public Customer_Item__c customerItem{get; set;}
        public String previousStatus{get; set;}
        public ErpDeviceWrapper(Customer_Item__c item, String fab){
            this.customerItem = item;
            this.selected = false;
            this.fab = fab;
            this.referenceId = item.ERP_Device__c+'-'+ fab;
        }
    }
}