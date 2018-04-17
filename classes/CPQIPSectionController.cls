/**********************************************************************************************************************************************
Class:         CPQIPSectionController 
-----------------------------------------------------------------------------------------------------------------------------------------------
Author:        Prosenjit Saha
Created Date:  25/08/2014
Reason:        Controls CPQ IP Section in the configuration/Proposal Detail page.
History:       ARoy    11102015    Modified code for IP design kit customization.    
**********************************************************************************************************************************************/
public class CPQIPSectionController {
    
    // variable declaration
    public Map<String,String> MapIPnamesLink {get;set;}
    public Map<String,String> IPValueMap {get;set;}
    public Map<String,Apttus_Proposal__Proposal_Line_Item__c> IPPropLineItemMap {get;set;} 
    transient public Map<String,String> IPApprovalcheckMap ; 
    transient public List<Base_IP__c > BaseIPList; 
    public Map<String,String> ColumnValues {get;set;}
    public List<String> ColumnList {get;set;}
    public list<Apttus_Proposal__Proposal_Line_Item__c> ProposalLineItems {get;set;}
    public boolean royaltyEditMode {get; set;} // Added by Ravi Teja.B Case#00087116
    public boolean isASICIPs {get; set;} // Added by Ravi Teja.B Case#00087116
    public boolean editAccessRoyalty {get; set;} // Added by Ravi Teja.B Case#00087116
    public Map<String,IP_Element__c> IPElementsMap {get;set;}// Added by Ravi Teja.B Case#00087116
    
    public Map<String,String> IPCustomAccptMap;
    public Map<String,String> IPDesignKitMap;
    public Map<String,Boolean> IPDesignKitStatusFlagMap;
    //public Map<String,String> IPDesignKitReviewMap;
    
    //public Map<String,String> IPDesignKitIpsMap;
    public Map<String,String> IPDesignKitDescMap;
    //public Map<String,String> IPDesignKitLBIDMap;
    public Map<String,String> IPDesignKitDevicesMap;
    
    public boolean checkInternalUser {get;set;}   
    public boolean CheckAccess {get;set;}
    public Apttus_Proposal__Proposal__c ConfigurationDetails{get;set;}
    public String GenerateType {get;set;}
    public Apttus_Proposal__Proposal_Line_Item__c MetalStackLineItem;
    public string IPRequestPrefix {get;set;}
    
    // Constructor
    public CPQIPSectionController(ApexPages.StandardController controller) {
        //CheckAccess = setCheckAccess ();
        generateIP();   
        ConfigurationDetails = new Apttus_Proposal__Proposal__c ();
        //Added by Ravi Teja.B Case#00087116
        Map<String, RoyaltEditAccessUserEmails__c> edtAccsCustSet = RoyaltEditAccessUserEmails__c.getAll();
        if(edtAccsCustSet.size() > 0 && !edtAccsCustSet.containsKey(userinfo.getUserEmail())){
            editAccessRoyalty = false;
        }
        else{
            editAccessRoyalty = true;
        }
        if( ApexPages.currentPage().getParameters().get('generate') == 'pdf'){
            this.GenerateType = 'pdf';
        }
        String ConfigQuery = 'SELECT ';
    
        for(Schema.FieldSetMember f : SObjectType.Apttus_Proposal__Proposal__c.FieldSets.Related_List_Column_for_Team_Room.getFields()) {
            ConfigQuery += f.getFieldPath() + ', ';
        }
        ConfigQuery += 'Id,Apttus_Proposal__Account__r.name,Process_Technology__c,Process_Technology_Geometry__c FROM Apttus_Proposal__Proposal__c WHERE ID = \'' + ApexPages.currentPage().getParameters().get('Id')+'\''; 
        ConfigurationDetails = Database.query(ConfigQuery )  ;   
        IPRequestPrefix = IP_Request__c.sObjectType.getDescribe().getKeyPrefix() ; 
    }
    
    // Generating IP List
    public void generateIP(){  
        
        BaseIPList = new List<Base_IP__c >();
        MapIPnamesLink  = new Map<String,String>();
        IPElementsMap = new Map<String,IP_Element__c>();
        IPPropLineItemMap = new Map<String,Apttus_Proposal__Proposal_Line_Item__c>();
        IPApprovalcheckMap = new Map<String,String>();
        ColumnValues = new Map<String,String> ();
        ColumnList  = new List<String>();
        //IPDesignKitReviewMap = new Map<String,String>();
        IPValueMap = new Map<String,String>();
        IPDesignKitMap = new Map<String,string>();
        IPCustomAccptMap = new Map<String,String>();
        IPDesignKitStatusFlagMap = new Map<String,Boolean>();
        
        //IPDesignKitIpsMap = new Map<String,string>();
        IPDesignKitDescMap = new Map<String,String>();
        //IPDesignKitLBIDMap = new Map<String,string>();
        IPDesignKitDevicesMap = new Map<String,string>();
        
        checkInternalUser = false;
        ProposalLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>(); 
        String ipCustomAccpt = '';
        String ipCustomRev = '';
        String IPNameList = '( '; 
        
        // Checking for internal user for 'Customize' button visibility
        if(UserInfo.getUserType() != 'CustomerSuccess' && UserInfo.getUserType() != 'PowerCustomerSuccess'){
            checkInternalUser = true;           
        }
        
        // Checking the Proposal Line Item for IP and Metack Stacks
        for(Apttus_Proposal__Proposal_Line_Item__c IPLineitem :    [SELECT  Id,
                                                                            Name,
                                                                            Apttus_Proposal__Product__c,
                                                                            Apttus_QPConfig__OptionId__c,
                                                                            Apttus_QPConfig__OptionId__r.Name,
                                                                            Apttus_QPConfig__OptionId__r.ProductCode,
                                                                            Apttus_QPConfig__OptionId__r.IP_PT_ID__c,
                                                                            Apttus_QPConfig__OptionId__r.IP_Device_List__c,
                                                                            IP_Approval_Status__c,
                                                                            Customized_IP_Flag__c,
                                                                            Ip_Customization_Reviewed__c,
                                                                            IP_Design_Kit__c,
                                                                            IP_Customization_Accepted__c,
                                                                            Apttus_QPConfig__OptionId__r.family,
                                                                            Apttus_QPConfig__ConfigurationId__c,
                                                                            Apttus_QPConfig__ConfigurationId__r.Apttus_Config2__Status__c,
                                                                            Qty__c,
                                                                            Finance__c
                                                                    FROM    Apttus_Proposal__Proposal_Line_Item__c
                                                                    WHERE   Apttus_Proposal__Proposal__c = :ApexPages.currentPage().getParameters().get('Id')
                                                                    AND     (Apttus_QPConfig__OptionId__r.family  = 'IPs'
                                                                            OR Apttus_QPConfig__OptionId__r.family  = 'Metal Stacks')
                                                                    AND     Apttus_QPConfig__ConfigurationId__c != NULL
                                                                    AND     Apttus_QPConfig__ConfigurationId__r.Apttus_Config2__Status__c = 'Finalized']){

            if(isASICIPs == null)
                isASICIPs = false;
            // Checking for Product Family as 'IPs'
            if(IPLineitem.Apttus_QPConfig__OptionId__r.family  == 'IPs'){
                ProposalLineItems.add(IPLineitem);
                IPNameList += '\'' + IPLineitem.Apttus_QPConfig__OptionId__r.ProductCode + '\',' ; 
                if(IPLineitem.Apttus_QPConfig__OptionId__r.ProductCode.startswith('IPE'))
                    isASICIPs = true;
                if(!IPApprovalcheckMap.keyset().contains(IPLineitem.Apttus_QPConfig__OptionId__r.ProductCode)){
                    MapIPnamesLink.put(IPLineitem.Apttus_QPConfig__OptionId__r.ProductCode,IPLineitem.Apttus_QPConfig__OptionId__r.IP_PT_ID__c);
                    IPApprovalcheckMap.put(IPLineitem.Apttus_QPConfig__OptionId__r.ProductCode,IPLineitem.IP_Approval_Status__c);
                    IPPropLineItemMap.put(IPLineitem.Apttus_QPConfig__OptionId__r.ProductCode,IPLineitem);
                }
                if(IPLineitem.IP_Design_Kit__c != null){
                    IPDesignKitMap.put(IPLineitem.IP_Design_Kit__c.split('-')[0],IPLineitem.IP_Design_Kit__c);
                    
                    //IPDesignKitIpsMap.put(IPLineitem.IP_Design_Kit__c.split('-')[0],IPLineitem.Apttus_QPConfig__OptionId__r.Name);
                    //IPDesignKitLBIDMap.put(IPLineitem.IP_Design_Kit__c.split('-')[0],IPLineitem.Apttus_QPConfig__OptionId__r.ProductCode);
                    IPDesignKitDevicesMap.put(IPLineitem.IP_Design_Kit__c.split('-')[0],IPLineitem.Apttus_QPConfig__OptionId__r.IP_Device_List__c);
                    
                    IPDesignKitStatusFlagMap.put(IPLineitem.IP_Design_Kit__c.split('-')[0],IPLineitem.Customized_IP_Flag__c);
                    IPCustomAccptMap.put(IPLineitem.IP_Design_Kit__c.split('-')[0],IPLineitem.IP_Customization_Accepted__c);
                    //IPDesignKitReviewMap.put(IPLineitem.IP_Design_Kit__c.split('-')[0],IPLineitem.Ip_Customization_Reviewed__c);    
                }else{
                    ipCustomAccpt = IPLineitem.IP_Customization_Accepted__c;
                    //ipCustomRev = IPLineitem.Ip_Customization_Reviewed__c;    
                }              
            }
            // Checking for Product Family as 'Metal Stacks'
            if(IPLineitem.Apttus_QPConfig__OptionId__r.family  == 'Metal Stacks'){
                MetalStackLineItem = new Apttus_Proposal__Proposal_Line_Item__c();
                MetalStackLineItem = IPLineitem;
            }
        }
        //Added By Ravi Teja.B Case#00087116
        Set<String> IPENumbers = new Set<String>();
        for(String s: MapIPnamesLink.keySet()){
            if(s.startsWithIgnoreCase('IPE'))
                IPENumbers.add('IPE-'+s.split('IPE')[1]);
        }
        
        for(IP_Element__c ipe: [Select Id, Name, royalty__c from IP_Element__c where Name in: IPENumbers]){
            if(ipe.Name.contains('-'))
            IPElementsMap.put(ipe.Name.remove('-'),ipe);
        }
        IPNameList = (IPNameList != '(' ? IPNameList.substring(0, IPNameList.length() - 1) + ')' : '');    
        if(ProposalLineItems.size() > 0){
            
            //Set<String> ipNameSet = new Set<String>();
            for(IP__c ipdes : [SELECT id, 
                                      name,
                                      IPNumber__c,
                                      IPNumber__r.name,
                                      Latest_Design_Kit__c,
                                      IP_ID__c,
                                      Device_List__c,
                                      Description__c 
                               FROM   IP__c 
                               WHERE  IPNumber__r.name
                               IN     :MapIPnamesLink.keyset()
                               AND    Latest_Design_Kit__c  = TRUE]){
                IPDesignKitDescMap.put(ipdes.IPNumber__r.name,ipdes.Description__c);
                if(!IPDesignKitMap.containsKey(ipdes.IPNumber__r.name)){
                    IPDesignKitMap.put(ipdes.IPNumber__r.name,ipdes.name);
                    // Added new fields for IP Design Kit customization
                    //**************************************************//
                    //IPDesignKitLBIDMap.put(ipdes.IPNumber__r.name,ipdes.IP_ID__c);                    
                    IPDesignKitDevicesMap.put(ipdes.IPNumber__r.name,ipdes.Device_List__c);
                    IPDesignKitStatusFlagMap.put(ipdes.IPNumber__r.name,false);
                    IPCustomAccptMap.put(ipdes.IPNumber__r.name,ipCustomAccpt);
                    //IPDesignKitReviewMap.put(ipdes.IPNumber__r.name,ipCustomRev);
                    //***************************************************//
                    //ipNameSet.add(ipdes.IPNumber__r.name);
                }
            }
            
            /*for(Product2 p : [select Name, ProductCode from Product2 where ProductCode in :ipNameSet]){
                IPDesignKitIpsMap.put(p.ProductCode, p.Name);
            }*/
            
            BaseIPList = fetchIPDetails(IPNameList);
            for(Base_IP__c IPProduct :   BaseIPList ){
                for(Schema.FieldSetMember f : SObjectType.Base_IP__c.FieldSets.IP_Columns_Detail.getFields()){
                        
                    IPValueMap.put(IPProduct.name + f.getFieldPath() , String.valueOf(IPProduct.get(f.getFieldPath())));
                }
                // Added new fields for IP Design Kit customization
                //**************************************************//
                IPValueMap.put(IPProduct.name +'IP Design Kit', IPDesignKitMap.containsKey(IPProduct.name) ? IPDesignKitMap.get(IPProduct.name): IPProduct.name );
                
                IPValueMap.put(IPProduct.name +'Design Kit Description', IPDesignKitDescMap.containsKey(IPProduct.name) ? formatStringWithSpaces(IPDesignKitDescMap.get(IPProduct.name),20): IPProduct.name );
                //IPValueMap.put(IPProduct.name +'LBID', IPDesignKitLBIDMap.containsKey(IPProduct.name) ? IPDesignKitLBIDMap.get(IPProduct.name): IPProduct.name );
                IPValueMap.put(IPProduct.name +'Device', IPDesignKitDevicesMap.containsKey(IPProduct.name) ? formatStringWithSpaces(IPDesignKitDevicesMap.get(IPProduct.name),20): IPProduct.name );
                                                         
                //Added by Ravi Teja.B Case#00087116
                if(isASICIPs){
                    IPValueMap.put(IPProduct.name +'3rd Prty Srcd', IPElementsMap.containsKey(IPProduct.name) ? (IPElementsMap.get(IPProduct.name).royalty__c!= null ? string.valueof(IPElementsMap.get(IPProduct.name).royalty__c) : 'None') : 'No Value' );
                    IPValueMap.put(IPProduct.name +'Qty', IPPropLineItemMap.containsKey(IPProduct.name) ? (IPPropLineItemMap.get(IPProduct.name).Qty__c != null ? string.valueof(IPPropLineItemMap.get(IPProduct.name).Qty__c) : '1') : 'No Value' );
                    IPValueMap.put(IPProduct.name +'Finance', IPPropLineItemMap.containsKey(IPProduct.name) ? (IPPropLineItemMap.get(IPProduct.name).Finance__c != null && IPPropLineItemMap.get(IPProduct.name).Finance__c != '') ? IPPropLineItemMap.get(IPProduct.name).Finance__c : '' : 'No Value') ;
                }
                                                                                                                                                 
                IPValueMap.put(IPProduct.name +'Customization',IPDesignKitStatusFlagMap.containsKey(IPProduct.name) ? String.valueOf(IPDesignKitStatusFlagMap.get(IPProduct.name)):'false');
                IPValueMap.put(IPProduct.name +'Accepted',IPCustomAccptMap.get(IPProduct.name)!=null?IPCustomAccptMap.get(IPProduct.name):'');
                //IPValueMap.put(IPProduct.name +'Customization Reviewed',IPDesignKitReviewMap.get(IPProduct.name)!=null?IPDesignKitReviewMap.get(IPProduct.name):'');
                //***************************************************//
            }  
                 
        }   
    }
    
    // Fetching details for columns to be displayed
    public List<Base_IP__c> fetchIPDetails(String IPNameList ){
        String szIPQuery = 'SELECT ';
        
        for(Schema.FieldSetMember f : SObjectType.Base_IP__c.FieldSets.IP_Columns_Detail.getFields()) {
            szIPQuery += f.getFieldPath() + ', ';
            ColumnList.add(f.getLabel() == 'IP Name'? 'IP Design Kit' : f.getLabel());
            ColumnValues.put(f.getLabel() == 'IP Name'? 'IP Design Kit' : f.getLabel(),f.getFieldPath());  
        }
        
        // Adding the new fields to be displayed
        //***************************************//
        ColumnList.add('Design Kit Description');
        ColumnValues.put('Design Kit Description','Design Kit Description');
        //ColumnList.add('LBID');
        //ColumnValues.put('LBID','LBID');
        ColumnList.add('Device');
        ColumnValues.put('Device','Device');
        //Added By Ravi Teja.B Case#00087116
        if(isASICIPs){
            ColumnList.add('3rd Prty Srcd');
            ColumnValues.put('3rd Prty Srcd','3rd Prty Srcd');
            ColumnList.add('Qty');
            ColumnValues.put('Qty','Qty');
            ColumnList.add('Finance');
            ColumnValues.put('Finance','Finance');
        }
        ColumnList.add('Customization');
        ColumnValues.put('Customization','Customization');
        ColumnList.add('Accepted');
        ColumnValues.put('Accepted','Accepted');
        /*ColumnList.add('Customization Reviewed');
        ColumnValues.put('Customization Reviewed','Customization Reviewed');*/
        if(ApexPages.currentPage().getParameters().get('generate')!='excel'){
            ColumnList.add('Change IP DK Ver');
            ColumnValues.put('Change IP DK Ver','Change IP DK Ver');
        } 
        //**************************************//               
        szIPQuery += 'Id FROM Base_IP__c WHERE Name IN ' + (IPNameList != '' ? IPNameList  : '(\'\')') +
                       'ORDER BY Name desc';
        return(Database.query(szIPQuery))  ;                   
    }
    
    // Format String with intermediate spaces
    private static String formatStringWithSpaces(String s,Integer interval){
        if(s!=null){
            Double arrayLength = Math.ceil((decimal)(s.length()) / (decimal)(interval));
    
            String str = '';
            Integer j = 0;
    
            for (Integer i = 0; i < arrayLength ; i++) {
                Integer endPoint = ((j + interval)>(s.length()))?s.length():(j + interval);
                str += s.substring(j, endPoint)+' ';
                j += interval;
            }
            return str.trim();
        }
        return null;
    }
    //This will let users to edit royalty
    public void royaltyEditModeOn(){
        royaltyEditMode = true;
    }
    //This will let users to cancel the changes made on royalty
    public PageReference royaltyCancel(){
        return new PageReference('/apex/CPQ_OpportunityIPRPage?id='+ConfigurationDetails.Id);
    }
    //This will let users to save the changes made on royalty
    public PageReference saveRoyalty(){
        
        list<Apttus_Proposal__Proposal_Line_Item__c> udpatePLI = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        for(String str: IPPropLineItemMap.keySet()){
            Boolean isUpdate = false;
            if(IPValueMap.containsKey(str+'Qty')){
                IPPropLineItemMap.get(str).Qty__c = (IPValueMap.get(str+'Qty') != null && IPValueMap.get(str+'Qty') != '') ? integer.valueof(IPValueMap.get(str+'Qty')):null;
                isUpdate = true;
            }
            if(IPValueMap.containsKey(str+'Finance')){
                IPPropLineItemMap.get(str).Finance__c = (IPValueMap.get(str+'Finance') != null && IPValueMap.get(str+'Finance') != '') ? IPValueMap.get(str+'Finance'):null;
                isUpdate = true;
            }
            if(isUpdate)
            udpatePLI.add(IPPropLineItemMap.get(str));
        }
        royaltyEditMode = false;
        try{
            if(udpatePLI.size() > 0)
            database.update(udpatePLI,false);
            return new PageReference('/apex/CPQ_OpportunityIPRPage?id='+ConfigurationDetails.Id);    
        }
        catch(exception e){
            GlobalUtility.logMessage('Error','CPQConfigurationApprovalHelper','submitForApproval','','Exception while while saving royalty',e.getMessage(),'','Apttus CPQ',null,0);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
        }
        return null;    
    }
   
}