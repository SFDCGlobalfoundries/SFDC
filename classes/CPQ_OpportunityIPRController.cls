public without sharing class CPQ_OpportunityIPRController {
    public Boolean iprFlag { get;set; }
    public Boolean ptFlag { get;set; }
    public Boolean configIpFlag { get;set; }
    public Apttus_Proposal__Proposal__c config { get;set; }
    public Map < Id, IPR_Config_Wrapper > iprMap { get;set; }
    public List < SelectOption > lstIPsFromPT { get;set; }
    public boolean isEdit { get;set; }
    public boolean hasEditPerm { get;set; }
    public boolean viewAll { get;set; }
    public string strOppLookupMetaId{get;set;}
    public string strGeoMetaId{get;set;}
    public string delIPReq{get;set;}

    public class IPR_Config_Wrapper {
        public Boolean isChecked { get;set; }
        public CMOS_BU_IP_Request__c iprRec { get;set; }
        public IPR_Config_List_Item__c objIPRConfig { get;set; }
        public String comments { get;set; }
        public String selectedIP { get;set; }
        public string BaseIpId { get;set; }
        public string BaseIpName { get;set; }

        public IPR_Config_Wrapper(CMOS_BU_IP_Request__c iprRec, IPR_Config_List_Item__c objIPRConfig, String selectedIP) {
            this.isChecked = false;
            this.iprRec = iprRec;
            this.objIPRConfig = objIPRConfig;
            this.selectedIP = selectedIP;
            this.comments = objIPRConfig.comments__c;

        }

    }
    public CPQ_OpportunityIPRController(ApexPages.StandardController controller) {
        this.viewAll = false;
        delIPReq=null;
       
        strOppLookupMetaId=Environment_Variable__c.getInstance('IPROpportunityLookupMetaId')==null?'CF00NN00000021FyG':Environment_Variable__c.getInstance('IPROpportunityLookupMetaId').Value__c;
        strGeoMetaId=Environment_Variable__c.getInstance('ProcessGeometryMetaId')==null?'00NN0000002DtHu':Environment_Variable__c.getInstance('ProcessGeometryMetaId').Value__c;
        
        if (ApexPages.currentPage().getParameters().get('viewAll') != null) {
            this.viewAll = true;
        }
         
        String strConfigId=ApexPages.currentPage().getParameters().get('id');
        config=[Select Name,Apttus_Proposal__Opportunity__c,Apttus_Proposal__Opportunity__r.Process_Geometry__c,Process_Technology_Lookup__r.Name,Apttus_Proposal__Opportunity__r.Name 
              from Apttus_Proposal__Proposal__c where id=:strConfigId];  
        
        if (config.Apttus_Proposal__Opportunity__c == null) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Opportunity is not selected in related configuration.'));
            return;
        }
        setIPRConfigList();

    }
    
    private set<Integer> getExcludeSequenceNumber(){
        set<Integer> setSequence=new set<Integer>{98765};
        
        if(Environment_Variable__c.getInstance('ExcludeSequenceNumber')!=null){
            String str=Environment_Variable__c.getInstance('ExcludeSequenceNumber').Value__c;
            for(string sequence:str.split(',')){
                setSequence.add(Integer.valueOf(sequence));
            }
        }
        
        return setSequence;
    }

    private void setIPRConfigList() {
        iprFlag = false;
        isEdit = false;
        hasEditPerm = Schema.sObjectType.IPR_Config_List_Item__c.isCreateable() || Schema.sObjectType.IPR_Config_List_Item__c.isUpdateable();



        List < CMOS_BU_IP_Request__c > iprList = [Select id, Name, IP_Type__c, IP_Subtype__c, Stage__c, IP_Project__c,
            Additional_Description__c, Owner.Name, OwnerId, Metal_Stack__c,
            Front_End_Design_Kit_Required_Date__c, Existing_IP__c, Preferred_IP_Vendor__c from CMOS_BU_IP_Request__c where Opportunity__c =: config.Apttus_Proposal__Opportunity__c
        ];
       
        iprFlag = true;
        iprMap = new Map < Id, IPR_Config_Wrapper > ();
        for (CMOS_BU_IP_Request__c ipr: iprList) {
            if (!iprMap.containsKey(ipr.Id)) {
                iprMap.put(ipr.Id, new IPR_Config_Wrapper(ipr, new IPR_Config_List_Item__c(IPRD_id__c = ipr.id, Configuration__c = config.id), null));
            }
        }

        Map < string, string > mapIPRList = new Map < string, string > ();

        for (IPR_Config_List_Item__c iprConfigListItem: [Select id, Name, IPRD_id__c, comments__c, Configuration__c, IP__c from IPR_Config_List_Item__c where IPRD_id__c IN: iprMap.keySet() AND Configuration__c =: config.Id]) {
            if (iprMap.containsKey(iprConfigListItem.IPRD_id__c)) {
                IPR_Config_Wrapper iprWrapper = iprMap.get(iprConfigListItem.IPRD_id__c);
                //iprWrapper.isChecked = true;
                iprWrapper.comments = iprConfigListItem.comments__c;
                iprWrapper.selectedIP = iprConfigListItem.IP__c;
                iprWrapper.objIPRConfig = iprConfigListItem;
                if (iprConfigListItem.IP__c != null) {
                    mapIPRList.put(iprConfigListItem.IPRD_id__c, iprConfigListItem.IP__c);
                }
                iprMap.put(iprConfigListItem.IPRD_id__c, iprWrapper);
            }
        }

        //Get selected IP detail
        if (mapIPRList != null && mapIPRList.size() > 0) {
            setIpDetail(mapIPRList);

        }


        ptFlag = true;
        configIpFlag = false;
        lstIPsFromPT = new List < SelectOption > ();
        if (config.Process_Technology_Lookup__c != null && !String.isBlank(config.Process_Technology_Lookup__r.Name))
            fetchIPsFromConfigurationPT(config.Process_Technology_Lookup__r.Name);
        else
            ptFlag = false;
    }
    
    private void setIpDetail(Map < string, string > mapIPRList){
         //Get selected IP detail
      
            Map < string, Base_IP__c > mapIpDetail = new Map < string, Base_IP__c > ();
            for (Base_IP__c obj: [select id, name from Base_IP__c where Name In: mapIPRList.values()]) {
                mapIpDetail.put(obj.Name, obj);
            }
         
            for (string strId: mapIPRList.keySet()) {
                Base_IP__c objIp = mapIpDetail.get(mapIPRList.get(strId));
                if (iprMap.get(strId) != null && objIp != null) {
                    iprMap.get(strId).BaseIpId = objIp.Id;
                    iprMap.get(strId).BaseIpName = objIp.Name;
                }
            }

        
    }
    
    private void fetchIPsFromConfigurationPT(String PTNumber) {set < String > setOfIPs = new Set < String > ();
        lstIPsFromPT.add(new SelectOption('', '--Select--'));
        for (Apttus_Config2__ProductOptionComponent__c ipPOC: [Select Apttus_Config2__ComponentProductId__r.Name, Apttus_Config2__ComponentProductId__r.ProductCode from Apttus_Config2__ProductOptionComponent__c
                                                                where Apttus_Config2__ParentProductId__c != null AND
                                                                Apttus_Config2__ParentProductId__r.PT_Number__c =: PTNumber AND
                                                                Apttus_Config2__ParentProductId__r.Apttus_Config2__ConfigurationType__c = 'Bundle'
                                                                AND
                                                                Apttus_Config2__ComponentProductId__c != null AND
                                                                Apttus_Config2__ComponentProductId__r.isActive = true AND
                                                                Apttus_Config2__ComponentProductId__r.Family LIKE 'IP%'
                                                                AND
                                                                Apttus_Config2__Sequence__c NOT IN : getExcludeSequenceNumber() //for work around in future
                                                                Order by Apttus_Config2__ComponentProductId__r.ProductCode
            ]) {
                 lstIPsFromPT.add(new SelectOption(ipPOC.Apttus_Config2__ComponentProductId__r.ProductCode, ipPOC.Apttus_Config2__ComponentProductId__r.Name));
             }
        
    }

    public PageReference editAction() {
        isEdit = true;
        return null;
    }
    
     public PageReference delIPRequest() {
       try {
	       delete[select id from IPR_Config_List_Item__c where id=:delIPReq];
	       delIPReq=null;
	       setIPRConfigList();
       }catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
            //GlobalUtility.logMessage('Error', 'CPQ_OpportunityIPRController', 'saveAction', null, null, ex.getMessage(), null,null,ex, null);
        }
        return null;
    }
    
    

    public PageReference saveAction() {
        List < IPR_Config_List_Item__c > lstToUpsert = new List < IPR_Config_List_Item__c > ();
        List < IPR_Config_List_Item__c > lstToDelete = new List < IPR_Config_List_Item__c > ();
        Map < string, string > mapIPRList = new Map < string, string > ();
        
        try {
            for (IPR_Config_Wrapper iprWrapper: iprMap.values()) {
                if (iprWrapper.isChecked) {
                    /*if (iprWrapper.objIPRConfig.id != null && (iprWrapper.comments == '' || iprWrapper.comments == null) && (iprWrapper.selectedIP == '' || iprWrapper.selectedIP == null)) {
                        lstToDelete.add(iprWrapper.objIPRConfig);
                    } else if ((iprWrapper.comments != null && iprWrapper.comments != '') || (iprWrapper.selectedIP != null && iprWrapper.selectedIP != '')) {*/
                        iprWrapper.objIPRConfig.comments__c = iprWrapper.comments;
                        iprWrapper.objIPRConfig.IP__c = iprWrapper.selectedIP;
                        lstToUpsert.add(iprWrapper.objIPRConfig);
                       
                        if(iprWrapper.objIPRConfig.IP__c!=null){
                          mapIPRList.put(iprWrapper.objIPRConfig.IPRD_id__c,iprWrapper.objIPRConfig.IP__c);
                        }
                    //}
                }

            }
            if (lstToUpsert.size() > 0) {
                upsert lstToUpsert;
                 if (mapIPRList != null && mapIPRList.size() > 0) {
                    setIpDetail(mapIPRList);

                 }
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm, 'Record Successfully saved.'));
            }

           /* if (lstToDelete.size() > 0) {
                delete lstToDelete;
                setIPRConfigList();
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm, 'Record Successfully saved.'));
            }*/

        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
            //GlobalUtility.logMessage('Error', 'CPQ_OpportunityIPRController', 'saveAction', null, null, ex.getMessage(), null,null,ex, null);
        }
        return null;
    }


}