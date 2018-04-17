/*
    Author: Anirban Roy
    Description: This is the controller class for config IP Design Kit customization.
    History:
        ARoy    09162015    - code creation.          
*/
public class CPIPDesignCustomController{
    
    //Variable Declaration
    public String entityId {get; set;}
    public String configId {get; set;} 
    public String ptNumber {get; set;}
    public String ptGeometry {get; set;} 
    public List<IPQuestionResponse> configPlusIPResList {get; set;}
    public Base_IP__c baseIp {get; set;}
    public String ipDesKitName {get;set;}
    public Boolean ipCustomAccptd {get;set;}
    public String ipCustomStatus {get;set;}
    public String pageType {get;set;}
    public Apttus_Proposal__Proposal_Line_Item__c pli {get;set;}
    
    public String propLineItemId {get;set;}
    public boolean userChk {get;set;}

    // Constructor
    public CPIPDesignCustomController(){
        entityId = ApexPages.currentPage().getParameters().get('Id');
        ipDesKitName = ApexPages.currentPage().getParameters().get('ipn');
        ptNumber = ApexPages.currentPage().getParameters().get('pnum');
        ptGeometry = ApexPages.currentPage().getParameters().get('ptGeometry');
        pageType = ApexPages.currentPage().getParameters().get('pageType');
        
        propLineItemId = ApexPages.currentPage().getParameters().get('propId');
        configPlusIPResList = new List<IPQuestionResponse>();
        ipCustomStatus = 'Pending';
        ipCustomAccptd = false;
        
        // Querying Proposal Line Item for getting IP information
        pli = [select   Id
                        , Apttus_Proposal__Proposal__c
                        , Apttus_Proposal__Product__c
                        , Apttus_QPConfig__OptionId__c
                        , Apttus_QPConfig__OptionId__r.ProductCode
                        , Apttus_QPConfig__OptionId__r.IP_PT_ID__c
                        , IP_Approval_Status__c
                        , Prev_IP_Design_Kit__c
                        , Customized_IP_Flag__c
                        , Apttus_QPConfig__OptionId__r.family
                        , Apttus_QPConfig__ConfigurationId__c
                        , Apttus_QPConfig__ConfigurationId__r.Apttus_Config2__Status__c
                        ,(select     Name__c
                                     , Configurator_Plus_Question__c
                                     , Configurator_Plus__c
                                     , Question_ID__c
                                     , Response__c
                                     , Response_Type__c     
                        from     Configurator_Plus_Responses__r)
              from      Apttus_Proposal__Proposal_Line_Item__c
              where     id = :propLineItemId limit 1
              ];
        
        configId = pli.Apttus_Proposal__Proposal__c;        

        ipCustomStatus = pli.IP_Approval_Status__c;
        ipCustomAccptd = pli.Customized_IP_Flag__c;
        
        // Querying Base IP object
        baseIp = [select    Ip_Vendor__c
                            , (select name,IP_Device_List__c from IP_Design_Kit__r) 
                            , Ip_Type__c
                            , Lifecycle__c
                  from      Base_IP__c
                  where     id = :entityId
                 ]; 
        
        for(Configurator_Plus_Response__c res : pli.Configurator_Plus_Responses__r){
            IPQuestionResponse ipres = new IPQuestionResponse(res.Configurator_Plus_Question__c, res.Question_ID__c, res.Response__c, res.Name__c);
            configPlusIPResList.add(ipres);
        }
        
        if(pli.Configurator_Plus_Responses__r == null || pli.Configurator_Plus_Responses__r.size() == 0){
            for(Configurator_Plus_Question__c configQues : [select     id
                                                                       , Question_Name__c
                                                                       , Question_Type__c
                                                                       , Data_Type__c
                                                                       , IP_Type__c
                                                            from       Configurator_Plus_Question__c
                                                            where      IP_Type__c = :baseIp.Ip_Type__c
                                                            and        Question_Type__c = 'IP Questions']){
                IPQuestionResponse ipres = new IPQuestionResponse(configQues.id, configQues.Question_Name__c, '', configQues.Question_Name__c);
                configPlusIPResList.add(ipres);
            }
        }
        
        // Check for user if the user is a System Admin or IP Team group member.
        Integer userCount = [select count() from GroupMember where Group.developername = 'IP_Team' and Group.type='Queue' and UserOrGroupId = :UserInfo.getUserId()];
        Integer sysAdmCount = [select count() from Profile where id = :UserInfo.getProfileId() and name = 'System Administrator'];
        userChk = (userCount > 0 || sysAdmCount >0 )?true:false;                                                             
    }
    
    // Getting IP Design Kit versions
    public List<SelectOption> getIPDesignKitVersions() {
        List<SelectOption> iPDesignKitVersions = new List<SelectOption>();
        for(IP__c ip : baseIp.IP_Design_Kit__r){        
            iPDesignKitVersions.add(new SelectOption(ip.Name,ip.Name));
        }
        return iPDesignKitVersions;
    }
    
    // Populating status for IP Design Kit
    public List<SelectOption> getIPDesignKitStatus() {
        List<SelectOption> ipDesignKitStatus = new List<SelectOption>();               
        ipDesignKitStatus.add(new SelectOption('Pending','Pending'));
        ipDesignKitStatus.add(new SelectOption('Approved','Approved'));
        ipDesignKitStatus.add(new SelectOption('Rejected','Rejected'));        
        return ipDesignKitStatus;
    }
    
    // Save functionality
    public PageReference save(){
        List<Configurator_Plus_Response__c> configResList = new List<Configurator_Plus_Response__c>();      
        
        // Populating the Configurator Plus Response object based on response type = 'IP Questions'
        for(IPQuestionResponse ipRes : configPlusIPResList){
            Configurator_Plus_Response__c cpRes = new Configurator_Plus_Response__c();
            cpRes.Configurator_Plus__c = configId;
            cpRes.Configurator_Plus_Question__c = ipRes.configQues;
            cpRes.Question_ID__c = pli.Id+'-'+ ipRes.configQues;
            cpRes.Name__c = ipRes.configQuesName;
            cpRes.Response__c = ipRes.configRes;
            cpRes.Response_Type__c = 'IP Questions';
            cpRes.Proposal_Line_Item__c = pli.Id;
            configResList.add(cpRes);
        }
        
        // Saving the record in Configurator Plus Response object
        if(configResList.size()>0){
            Database.UpsertResult [] cr = Database.upsert(configResList, Configurator_Plus_Response__c.Fields.Question_ID__c, false);
        }
        
        // Updating the Proposal line item with IP information
        pli.Customized_IP_Flag__c = true;
        pli.IP_Approval_Status__c = ipCustomStatus;
        pli.IP_Design_Kit__c = ipDesKitName;
        if(ipDesKitName != (String)ApexPages.currentPage().getParameters().get('ipn')){
            pli.Prev_IP_Design_Kit__c = (String)ApexPages.currentPage().getParameters().get('ipn');
        }
        update pli;
        
        pli = [select   Id
                        , Apttus_Proposal__Proposal__c
                        , Apttus_Proposal__Product__c
                        , Apttus_QPConfig__OptionId__c
                        , Apttus_QPConfig__OptionId__r.ProductCode
                        , Apttus_QPConfig__OptionId__r.IP_PT_ID__c
                        , IP_Approval_Status__c
                        , IP_Design_Kit__c
                        , Prev_IP_Design_Kit__c
                        , Customized_IP_Flag__c
                        , Apttus_QPConfig__OptionId__r.family
                        , Apttus_QPConfig__ConfigurationId__c
                        , Apttus_QPConfig__ConfigurationId__r.Apttus_Config2__Status__c
                        ,(select     Name__c
                                     , Configurator_Plus_Question__c
                                     , Configurator_Plus__c
                                     , Question_ID__c
                                     , Response__c
                                     , Response_Type__c     
                        from     Configurator_Plus_Responses__r)
              from      Apttus_Proposal__Proposal_Line_Item__c
              where     id = :propLineItemId limit 1
              ];                        
        
        // IP Status information check based on IP Approval status
        String ipStatusVal = '';
        boolean checkFlag = false;
        for(Apttus_Proposal__Proposal_Line_Item__c ipPli : [select    id
                                                                      , IP_Approval_Status__c
                                                                      , Customized_IP_Flag__c
                                                            from      Apttus_Proposal__Proposal_Line_Item__c
                                                            where     Apttus_Proposal__Proposal__c = :configId
                                                            and       Apttus_QPConfig__OptionId__r.family  = 'IPs'
                                                           ]){
            checkFlag = true;
            if(ipPli.Customized_IP_Flag__c){
                if(ipPli.IP_Approval_Status__c == 'Approved' || ipPli.IP_Approval_Status__c == 'Rejected'){
                   ipStatusVal = 'Yes';
                }else{
                   ipStatusVal = 'No'; 
                }
            }
        }
        
        // Updating the Consolidated IP Status Check in the Configurator Plus object 
        if(checkFlag && ipStatusVal != ''){
            Apttus_Proposal__Proposal__c cp = [select    id
                                                         , Consolidated_IP_Status_Check__c 
                                               from      Apttus_Proposal__Proposal__c 
                                               where     Id = :configId limit 1];
            cp.Consolidated_IP_Status_Check__c = ipStatusVal;
            update cp;
        }                                                          
        
        // Logic for checking the change in IP Design Kit version
        if(pli.IP_Design_Kit__c != pli.Prev_IP_Design_Kit__c && ipCustomStatus == 'Approved'){
            String prevIPDev = '';
            String currIPDev = '';

            for(IP__c ip : baseIp.IP_Design_Kit__r){        
                if(ip.name == pli.Prev_IP_Design_Kit__c){
                    prevIPDev = ip.IP_Device_List__c;
                }else if(ip.name == ipDesKitName){
                    currIPDev = ip.IP_Device_List__c;
                }
                 
            }                                   
                        
            // Checking if the IP Design Kit version changes based on device list
            if(prevIPDev != currIPDev){                                
                
                //Product2 p = [select Product_External_ID__c from Product2 where PT_Number__c = :ptNumber];
                ptGeometry = ptGeometry.substring(0,ptGeometry.length()-2);
                String pt_Ext_Id = String.valueOf((Integer)(Decimal.valueOf(ptGeometry)*1000)) + 'nm_' + ptNumber;
                List<String> addDevices = new List<String>();
                List<String> delDevices = new List<String>();
                
                // Checking the current devices and adding it in the list after splitting
                if(currIPDev != null){
                    for(String ipDev : currIPDev.split(',')){
                        if(prevIPDev == null || !prevIPDev.contains(ipDev)){
                            addDevices.add(pt_Ext_Id+'_'+ipDev);
                        }
                    }
                }
                
                List<String> prevDevList = new List<String>();
                Set<String> prevDelDevSet = new Set<String>();
                
                // Checking the previous devices and adding it in the list after splitting
                if(prevIPDev != null){
                    for(String ipDev : prevIPDev.split(',')){
                        prevDevList.add(pt_Ext_Id+'_'+ipDev);
                        prevDelDevSet.add(pt_Ext_Id+'_'+ipDev);
                        if(currIPDev == null || !currIPDev.contains(ipDev)){
                            delDevices.add(pt_Ext_Id+'_'+ipDev);
                            prevDelDevSet.remove(pt_Ext_Id+'_'+ipDev);
                        }
                    }
                }                
                
                String maskAll = '';
                String maskAftDel = '';
                
                //Checking the mask of the devices and preparing the list based on all masks
                Map<String,String> maskSetProdExtMap = new Map<String,String>();
                List<String> allDevList = new List<String>();
                allDevList.addAll(prevDevList);
                allDevList.addAll(new List<String>(prevDelDevSet));
                allDevList.addAll(addDevices);
                for(Product2 prod : [select    Mask_Sets__c
                                               , Product_External_ID__c 
                                    from       Product2 
                                    where      Product_External_ID__c 
                                    in :allDevList]){
                    maskSetProdExtMap.put(prod.Product_External_ID__c,prod.Mask_Sets__c);
                }
                
                for(String prodExtId : prevDevList){
                    if(maskSetProdExtMap.containsKey(prodExtId)){
                        for(String str : ((String)(maskSetProdExtMap.get(prodExtId))).split(',')){
                            maskAll += str + ',';
                        }
                    }
                }
                
                for(String prodExtId : prevDelDevSet){
                    if(maskSetProdExtMap.containsKey(prodExtId)){
                        for(String str : ((String)(maskSetProdExtMap.get(prodExtId))).split(',')){
                            maskAftDel += str + ',';
                        }
                    }
                }
                                
                maskAll = maskAll.removeEnd(',');
                maskAftDel = maskAftDel.removeEnd(',');
                
                //Checking the mask of the devices and preparing the maps based on mask to be added
                // and mask to be deleted
                List<String> maskToBeDel = new List<String>();
                List<String> maskToBeAdded = new List<String>();
                
                for(String mask : maskAll.split(',')){
                    if(!maskAftDel.contains(mask.trim())){
                        maskToBeDel.add(mask.trim());
                    }
                }
                
                for(String prodExtId : addDevices){
                    if(maskSetProdExtMap.containsKey(prodExtId)){
                        for(String str : ((String)(maskSetProdExtMap.get(prodExtId))).split(',')){
                            maskToBeAdded.add(str.trim());
                        }
                    }
                }
                
                // Checking for device, mask to be added or deleted
                if(addDevices.size()>0 || delDevices.size()>0
                    || maskToBeAdded.size()>0 || maskToBeDel.size()>0){
                    Apttus_Config2__ProductConfiguration__c pc = [select    id 
                                                                  from      Apttus_Config2__ProductConfiguration__c 
                                                                  where     Apttus_QPConfig__Proposald__c = :configId
                                                                  order by  createddate desc limit 1];
                    
                    // New masks and devices are being added
                    if(addDevices.size()>0 || maskToBeAdded.size()>0){
                        List<String> addItems = new List<String>();
                        addItems.addAll(addDevices);
                        addItems.addAll(maskToBeAdded);
                        
                        // Querying the Product object for items to be added
                        List<Product2> prodlist = [select   id
                                                            , Name
                                                   from     Product2
                                                   where    Product_External_ID__c in :addItems
                                                  ];                        
                        
                        String whereClause = 'Apttus_Proposal__Proposal__c=\''+configId+'\' order by createddate desc limit 1 ';
                        
                        //Creating the new soql for proposal line item
                        String soql = getCreatableFieldsSOQL('Apttus_Proposal__Proposal_Line_Item__c',whereClause);
                        
                        Apttus_Proposal__Proposal_Line_Item__c pli = (Apttus_Proposal__Proposal_Line_Item__c)Database.query(soql);
                        
                        // Proposal Line Item is being cloned
                        List<Apttus_Proposal__Proposal_Line_Item__c> newpliList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
                        for(Product2 p1 : prodlist){
                            Apttus_Proposal__Proposal_Line_Item__c newpli = pli.clone();
                            newpli.Apttus_QPConfig__OptionId__c = p1.id;
                            newpli.Apttus_Proposal__Description__c = p1.Name;
                            newpliList.add(newpli);
                        }
                        
                        // Adding the Proposal Line Item
                        if(newpliList.size()>0){
                            insert newpliList;
                        }
                    }
                    
                    // Deleting the device list or mask list
                    if(delDevices.size()>0 || maskToBeDel.size()>0){
                        
                        List<String> delItems = new List<String>();
                        delItems.addAll(delDevices);
                        delItems.addAll(maskToBeDel);
                        
                        // Deletion from Proposal Line Item
                        List<Apttus_Proposal__Proposal_Line_Item__c> delpliList = [select   id 
                                                                                   from     Apttus_Proposal__Proposal_Line_Item__c
                                                                                   where    Apttus_Proposal__Proposal__c = :configId
                                                                                   and      Apttus_QPConfig__OptionId__r.Product_External_ID__c in :delItems
                                                                                  ];
                        
                        // Deleting the proposal line item
                        if(delpliList.size()>0){
                            delete delpliList;                      
                        }                                               
                        
                    }
                }
                
                
            }
        }else if(pli.IP_Design_Kit__c != pli.Prev_IP_Design_Kit__c && ipCustomStatus == 'Rejected'){
               // Reverting back the IP Design Kit to previous value on IP status = 'Rejection'
               pli.IP_Design_Kit__c =  pli.Prev_IP_Design_Kit__c;
               update pli;
        }
        PageReference pageRef = new PageReference('/'+configId);
        pageRef.setRedirect(true);
        return pageRef;       
    }
    
    // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
    public static string getCreatableFieldsSOQL(String objectName, String whereClause){
         
        String selects = '';
         
        if (whereClause == null || whereClause == ''){ return null; }
         
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
         
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
         
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
             
        }
         
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
         
    }
    
    // Cancel functionality
    public PageReference cancel(){
        return new PageReference('/'+configId);
    }
    
    // Print page functionality
    public PageReference printPage(){
        PageReference pgr = new PageReference(ApexPages.currentPage().getUrl());
        pgr.getParameters().put('pageType','PDF');
        pgr.setRedirect(true);
        return pgr;
    }
    
    // Wrapper class for IP Question
    class IPQuestionResponse{
        // Declare wrapper variables
        public String configQues {get;set;}
        public String configQuesId {get;set;}
        public String configRes {get;set;}
        public String configQuesName {get;set;}
        
        //Constructor
        public IPQuestionResponse(String configQues, String configQuesId, String configRes, String configQuesName){
            this.configQues = configQues;
            this.configQuesId = configQuesId;
            this.configRes = configRes;
            this.configQuesName = configQuesName;
        }
    }
    
}