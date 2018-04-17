/*
    Author: Anirban Roy
    Description: Apex class for Device List Page for FV
    History: 
    Asolito      09/05/2013    - Apex coded created
    Asolito      10/
    Prosenjit    10/08/2013    - BX041 link has been added
    ARoy         11/13/2013    - Modified to add pagination.
    ARoy         12/13/2013    - Modified to sort the device query by createddate descending order.
    Asolito      02/17/2013    - Added sort functionality for columns
    PSaha        05/12/2014    - Added Configuration link related to IP declaration
    Devendra 	 25/04/2016      - to add status of SFFG
*/
public with sharing class DeviceListController{ 
    private static final integer LISTSIZE = Integer.valueOf(EnvironmentVariable.get('DEVICE_LIST_SIZE')); 
    public final static integer OFFSETSIZE = Integer.valueOf(EnvironmentVariable.get('DEVICE_OFFSET_SIZE')); 
   
    public String checkLink {get;set;}
    public String sortCol {get; set;} 
    public String sortType {get; set;}  
    public List<DeviceListWrapper> deviceWrapperList {get; set;}        
    public integer totalSize;
    private DeviceList deviceList;
    private integer counter = 0;
    
    public integer getOFFSETSIZE (){    
        return OFFSETSIZE ;
    }

    public DeviceListController(){        
        checkLink = ApexPages.currentPage().getParameters().get('name');
        this.deviceList = new DeviceList();
        
        if(this.deviceList.pages.size() > 0){
            this.deviceWrapperList = this.deviceList.pages.get(this.counter);
        }
    }
    
    public PageReference sort(){
        this.counter = 0;
        
        if(UtilsString.isNotBlank(this.sortCol) && UtilsString.isNotBlank(this.sortType)){
            this.deviceList.sort(this.sortCol,this.sortType);
            this.deviceWrapperList = this.deviceList.pages.get(this.counter);
        }       
        return null;
    }                     
    
    public PageReference Beginning() { //user clicked beginning
      this.counter = 0;
      this.deviceWrapperList = this.deviceList.pages.get(this.counter);
      return null;
    }
 
    public PageReference Previous() { //user clicked previous button
      counter --;
      this.deviceWrapperList = this.deviceList.pages.get(this.counter);
      return null;
    }
 
    public PageReference Next() { //user clicked next button
      counter ++;
      this.deviceWrapperList = this.deviceList.pages.get(this.counter);
      return null;
    }
 
    public PageReference End() { //user clicked end
      counter = this.deviceList.pages.size()-1;
      this.deviceWrapperList = this.deviceList.pages.get(this.counter);
      return null;
    }
 
    public Boolean getDisablePrevious() { //this will disable the previous and beginning buttons
      if (counter == 0){ 
          return true; 
      }
      return false;
    }
 
    public Boolean getDisableNext() { //this will disable the next and end buttons
        if(counter == this.deviceList.pages.size() - 1){ 
            return true; 
        }
        return false;
    }  
 
    public Integer getPageNumber() {
      return counter+1;
    }
 
    public Integer getTotalPages() {
      return this.deviceList.pages.size();
    }
    
    public class DeviceList {    
        private Map<Integer,List<DeviceListWrapper>> pages;
        private List<Device__c> devices;
        
        public DeviceList(){
            //get the list of devices visible to the user
            this.devices = [select Id, Name, Project_Name__c, Customer_Tapeout_Date__c,  Geometry__c,
                                   ip_declaration_status__c, Process_Family__c, Status__c, Stage__c, Fab__c,  
                                   Pre_PTRF_Validation_Status__c,Actual_Tapeout_Date_GMT__c, Device_Mask_Set_Title__c, 
                                   CreatedDate,Generate_Standard_Frame__c,Tapeout_Type__c, MPW_Train_Number__r.Name,BX041_Status__c, 
                                   (select id, Status__c, Configuration__c, Configuration__r.name, Is_Config_Used__c from IP_Declaration_Form__r limit 1), // PS 12052014: Configuration link added
                                   (SELECT id, name FROM BX_041__r limit 1),
                                   (select device__c,Status__c from device_export_control_junctions__r limit 1),
                                   (Select id,SFFG_Frame_Status__c From SFFG_Standard_Foundry_Frames__r limit 1) 
                              from Device__c where Expose_Device_to_Customer__c = true order by CreatedDate desc
                              limit :LISTSIZE]; 
                              
            generatePages(this.devices);
        }
        
        //Method will generate the pages of the device list
        private void generatePages(List<Device__c> devices){
            this.pages = new Map<Integer,List<DeviceListWrapper>>();
            
            Integer counter = 1;
            Integer pageCount = 0;
            for(Device__c d: devices){
                if(counter <= OFFSETSIZE){
                    if(this.pages.containsKey(pageCount)){
                        this.pages.get(pageCount).add(new DeviceListWrapper(d));
                    } else {
                        DeviceListWrapper temp = new DeviceListWrapper(d);
                        this.pages.put(pageCount,new List<DeviceListWrapper>{temp});
                    }
                    counter++;
                } else {
                    counter = 1;
                    pageCount++;
                    
                    DeviceListWrapper temp = new DeviceListWrapper(d);
                    this.pages.put(pageCount,new List<DeviceListWrapper>{temp});   
                }    
            }                       
        }
        
        //Exposed method to call internal sorting method
        public void sort(String sortCol,String sortType){
            generatePages(doSort(sortCol,sortType));    
        } 
        
        //Method will do sorting of the device list
        private List<Device__c> doSort(String sortCol,String sortType){        
            List<Device__c> result = new List<Device__c>();
            
            Map<String,List<Device__c>> devMap = new Map<String,List<Device__c>>();
            for(Device__c d: this.devices){
                String key;
                if(sortCol == 'mpw'){
                    key = d.mpw_train_number__r.name;
                } else {
                    key = String.valueOf(d.get(sortCol));
                }
                if(devMap.containsKey(key)){
                    devMap.get(key).add(d);    
                } else {                   
                    devMap.put(key,new List<Device__c>{d});
                }
            }
            
            List<String> sortedKey = new List<String>();
            sortedKey.addAll(devMap.keySet());
            sortedKey.sort();
            
            if(sortType == 'asc'){
                for(String s: sortedKey){
                    result.addAll(devMap.get(s));
                }
            } else if(sortType == 'desc'){
                System.debug(sortedKey.size());
                for(Integer i = sortedKey.size()-1; i >= 0; i--){
                    result.addAll(devMap.get(sortedKey[i]));    
                }
            }
            
            return result;
        }               
    } 
    
    public class DeviceListWrapper{
        public Device__c deviceInfo {get;set;}
        public String IpDecId {get;set;}
        public String ExptCntrlId {get;set;}
        public String ExptCntrlStatus {get;set;}//Devendra 15092016 -- to add status of EC
        public String deviceID {get; set;}
        public String custTapeoutDate {get; set;}
        public String geometry {get; set;}
        public String processFamily {get; set;}
        public String status {get; set;}
        public String stage {get; set;}
        public String fab {get; set;}
        public String MPW {get; set;}
        public String tapeoutReadiness {get; set;}
        public String actualTapeoutDate {get; set;}
        public String maskSetTitle {get; set;}
        public String createdDate {get; set;}
        public String IPDecStatus {get; set;}
        public String bx041ID {get;set;}
        public String cdrsStatus {get;set;} //Tlai 03072014
        public String configID {get;set;} // PS 12052014 -- TO add Configuration link: associated with the IP Declaration
        public String ConfigurationName {get;set;} // PS 12052014 -- TO add Configuration link: associated with the IP Declaration
        public String SFFGStatus {get;set;} //Devendra 25042016 -- to add status of SFFG
        public string SFFGId {get;set;} //Devendra 26072016 -- to add status of SFFG
         
        public DeviceListWrapper(Device__c deviceInfo){
            this.deviceInfo = deviceInfo;                     
            
            for(Device_Export_Control_Junction__c d: this.deviceInfo.device_export_control_junctions__r){
                this.ExptCntrlId = d.device__c; this.ExptCntrlStatus = d.Status__c;
            }
            
            //Added by devendra 25/04/2016
            for(SFFG_Standard_Foundry_Frame__c s:this.deviceInfo.SFFG_Standard_Foundry_Frames__r)   {
            	this.SFFGStatus=(s.SFFG_Frame_Status__c!=null)?s.SFFG_Frame_Status__c:'';
            	this.SFFGId=(s.id!=null)?s.id:'';
            }
            
            if(this.deviceInfo.IP_Declaration_Form__r!=null){
                 for(IP_Declaration_Form__c objID : this.deviceInfo.IP_Declaration_Form__r){
                    this.IpDecId  = objID.Id;
                    // PS 12052014 -- TO add Configuration link: associated with the IP Declaration
                    this.configID  = (objID.Is_Config_Used__c == TRUE ? objID.Configuration__c : NULL );
                    ConfigurationName = (objID.Is_Config_Used__c == TRUE ? objID.Configuration__r.name : NULL );
                }
            }
            
            if(this.deviceInfo.BX_041__r !=null){
                 for(BX_041__c objID : this.deviceInfo.BX_041__r )this.bx041ID = objID.Id; }
            
            this.deviceID = deviceInfo.name;
            this.custTapeoutDate = deviceInfo.customer_tapeout_date__c <> null ?
                                   deviceInfo.customer_tapeout_date__c.format() :
                                   null;
            this.geometry = deviceInfo.geometry__c;
            this.processFamily = deviceInfo.process_family__c;
            this.status = deviceInfo.status__c;
            this.stage = deviceInfo.stage__c;
            this.fab = deviceInfo.fab__c;
            this.MPW = deviceInfo.MPW_Train_Number__r.name;
            this.tapeoutReadiness = deviceInfo.pre_PTRF_validation_status__c;
            this.actualTapeoutDate = deviceInfo.actual_tapeout_date_GMT__c <> null ?
                                     deviceInfo.actual_tapeout_date_GMT__c.format() :
                                     '';
            this.maskSetTitle = deviceInfo.device_mask_set_title__c;
            this.createdDate = deviceInfo.createdDate.format(); 
            this.IPDecStatus = deviceInfo.ip_declaration_status__c;   
            this.cdrsStatus = deviceInfo.BX041_Status__c;//Tlai 03072014       
        }
    }
}