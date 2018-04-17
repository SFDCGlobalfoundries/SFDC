/*
    Author: Zymark Ambat
    Description: This Class serves as the controller for the NPCPortalListVF.
    History: 
        ZAmbat      11202013    - Code creation.
        ZAmbat      12122013    - Updated code to match the Export Control List on Portal.
        ZAmbat      12182013    - Updated code to change logic of giving Edit permission to NPC Form.  Only NPC Form owners will be able to edit NPC Forms.
        ZAmbat      12182013    - Update code regarding NPC Form status after 2nd step rejection:  From no change in status ('In Execution') to 'Pending Resubmission'.
        Asolito     03182014    - Added sorting functionality
        ZAmbat      04032014    - Updated code as per CASE 7400.
        ZAmbat      01122015    - Updated code as per CASE 38012.
        DBiswal     03022015    - Updated code to display New Part Id Column.
*/        
   
public without sharing class NPCPortalListController {
    public String sortType {get; set;}
    public String sortField {get; set;}
    public string userId {get;set;}
    public integer rowsPerPage {get;set;}      
    public integer currentPageNo {get;set;}
    public integer totalNoOfPages {get;set;}
    public integer totalNoOfRecords {get;set;}
    public RecordType rtStatusRejected {get;set;}
    public User portalUser {get;set;}
    public Set<Id> accountIds {get;set;}
    public List<NPCWrapper> listNPC {get;set;}
    public List<NPCWrapper> currPage {get; set;}
    public Map<Id, Id> deviceSharingMap {get;set;}
    private Map<Integer,List<NPCWrapper>> pages;
    private Integer listSize;
    
    // Filter section
    public string referenceDevice {get;set;}
    public string npcFormName {get;set;}
    public New_Part_Creation_Form__c npcFilter {get;set;}
    public string searchForNPC {get;set;}
    
    public NPCPortalListController(){
        // Init
        refreshFilters();
        
        // Get User Id
        this.userId = UserInfo.getUserId();
        this.listNPC = new List<NPCWrapper>();
        this.currPage = new List<NPCWrapper>();
        this.pages = new Map<Integer,List<NPCWrapper>>(); 
        
        // Get All related Accounts in the hierarchy
        this.accountIds = new Set<Id>();
        this.deviceSharingMap = new Map<Id, Id>();
        initPagination();
        retrieveAccounts();
        retrieveNPCList();              
    }
    
    public PageReference sort(){
        Map<String,List<NPCWrapper>> sortMap = new Map<String,List<NPCWrapper>>();
        
        for(NPCWrapper l :this.listNPC){
            String key;
            if(this.sortField == 'base_device__c'){
                key = l.npcForm.Originating_Device__r.name; 
            } else {
                key = String.valueOf(l.npcForm.get(this.sortField)); 
            }
            if(sortMap.containsKey(key)){
                sortMap.get(key).add(l);
            } else {
                sortMap.put(key, new List<NPCWrapper>{l});
            }
        }
        
        List<String> sortKey = new List<String>();
        sortKey.addAll(sortMap.keyset());
        sortKey.sort();
        
        this.listNPC = new List<NPCWrapper>();
        if(this.sortType == 'asc'){
            for(String s: sortKey){
                this.listNPC.addAll(sortMap.get(s));    
            }
        } else if(this.sortType == 'desc'){
            for(Integer counter = (sortKey.size()-1); counter >= 0; counter--){
                this.listNPC.addAll(sortMap.get(sortKey[counter]));    
            }
        }
        
        this.paginate();
        this.currentPageNo = 1;
        this.currPage = this.pages.get(1);
        
        return null;        
    }
    
    public void initPagination() {
        this.rowsPerPage = integer.valueOf(Environment_Variable__c.getInstance('RECORDS_PER_PAGE_NPCLIST').Value__c);
        this.listSize = Integer.valueOf(EnvironmentVariable.get('DEVICE_LIST_SIZE'));       
        this.currentPageNo = 1;
        this.totalNoOfPages = 1;
        this.totalNoOfRecords = 0;
    }
    
    public void retrieveAccounts() {
        // Get portal user's account
        this.portalUser = [
            SELECT      Id
                        , AccountId
            FROM        User
            WHERE       Id = :this.userId
        ];
        
        // Get Account Id
        Account a = [
            SELECT      Id
                        , ParentId
            FROM        Account
            WHERE       Id = :portalUser.AccountId
        ];
        
        // Get Accounts in the Account Hierarchy
        if (a.ParentId != null) {
            for (Account_Hierarchy__c ah : [SELECT      Parent_Id__c
                                            FROM        Account_Hierarchy__c
                                            WHERE       Account_Id__c = :a.Id
                                                        AND Parent_Id__c != :a.Id]) { 
                accountIds.add(ah.Parent_Id__c);
            }
        }
        
        // Check for Devices below the Account Hierarchy
        for (Account_Hierarchy__c ah : [SELECT      Account_Id__c
                                        FROM        Account_Hierarchy__c
                                        WHERE       Parent_Id__c = :a.Id
                                                    AND Account_Id__c != :a.Id]) { 
            accountIds.add(ah.Account_Id__c);
        }
        
        // Add User's Account Id
        accountIds.add(a.Id);
        
        // Get NPC StatusRejected Record Type Id
        this.rtStatusRejected = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'New_Part_Creation_Form__c'
                        AND Name =   'StatusRejected'
        ];
        
        // Get all devices under the related accounts
        integer ctr = 0;
        List<Set<Id>> listDeviceIds = new List<Set<Id>>();
        Set<Id> setDeviceIds = new Set<Id>();
        listDeviceIds.add(setDeviceIds);
        for (Device__c d : [SELECT      Id
                            FROM        Device__c
                            WHERE       Account__c IN :this.accountIds
                                        AND Device_Type__c = 'Base']) {
            listDeviceIds[ctr].add(d.Id);
            if (listDeviceIds[ctr].size() == 1000) {
                setDeviceIds = new Set<Id>();
                listDeviceIds.add(setDeviceIds);
                ctr++;
            }
        }
        
        // Get Devices where user has access to
        for (Set<Id> tempSet : listDeviceIds) {
            for (Device__Share ds : [SELECT     ParentID
                                     FROM       Device__Share
                                     WHERE      ParentID IN :tempSet 
                                                AND UserOrGroupId = :this.userId]) {
                this.deviceSharingMap.put(ds.ParentID, ds.ParentID);
            }
        }
        
        // Get Total number of NPC records 
        /*List<New_Part_Creation_Form__c> listNPC1 = [
            SELECT      Id
            FROM        New_Part_Creation_Form__c
            WHERE       Account__c IN :this.accountIds      
        ];
        
        // Set value     
        this.totalNoOfRecords = listNPC1.size();*/
    }
    
    private void paginate(){
        this.pages = new Map<Integer,List<NPCWrapper>>(); 
        Integer counter = 1;
        Integer pageKey = 1;
        
        for(NPCWrapper l: this.listNPC){
            if(counter <= this.rowsPerPage){
                if(this.pages.containsKey(pageKey)){
                    this.pages.get(pageKey).add(l);
                } else {
                    this.pages.put(pageKey, new List<NPCWrapper>{l});
                }
                counter ++;
            } else {               
                counter = 1;
                pageKey++;
            }
        } 
        
        this.totalNoOfPages = this.pages.keyset().size();       
    }
    
    public void retrieveNPCList() {
        this.listNPC = new List<NPCWrapper>();
        
        // create SOQL query
        // Base query
        string soql = 'SELECT        Id ' +
                                    ', Name ' +
                                    ', BASE_Device__c ' +
                                    ', BASE_Device__r.Name ' +
                                    ', Originating_Device__c ' + 
                                    ', Originating_Device__r.Name ' + 
                                    ', Fab__c ' +
                                    ', NPC_Form_Status__c ' +
                                    ', Reason_for_New_Part__c ' +
                                    ', Tapeout_Required__c ' +
                                    ', Owner__c ' +
                                    ', Account__c ' +
                                    ', RecordTypeId ' +
                                    ', New_Part_ID__c ' +
                      'FROM          New_Part_Creation_Form__c ' +
                      'WHERE         Account__c IN :accountIds ';
        
        // Check for filters
        // SFDC Reference Device
        if (this.referenceDevice != null && this.referenceDevice.trim() != '') {
            soql = soql + 'AND Originating_Device__r.Name LIKE \'%' + this.referenceDevice.replace('*', '').replace('%', '') + '%\' ';
        }
        
        // NPC Form ID
        if (this.npcFormName != null && this.npcFormName.trim() != '') {
            soql = soql + 'AND Name LIKE \'%' + this.npcFormName.replace('*', '').replace('%', '') + '%\' ';
        }
        
        // Reason for New Part
        if (this.npcFilter.Reason_for_New_Part__c != null && this.npcFilter.Reason_for_New_Part__c.trim() != '') {
            soql = soql + 'AND Reason_for_New_Part__c = \'' + this.npcFilter.Reason_for_New_Part__c + '\' ';
        }
        
        // PTRF Submission Required
        if (this.npcFilter.Tapeout_Required__c != null && this.npcFilter.Tapeout_Required__c.trim() != '') {
            soql = soql + 'AND Tapeout_Required__c = \'' + this.npcFilter.Tapeout_Required__c + '\' ';
        }
        
        // New Part ID
        if (this.npcFilter.New_Part_ID__c != null && this.npcFilter.New_Part_ID__c.trim() != '') {
            soql = soql + 'AND New_Part_ID__c LIKE \'%' + this.npcFilter.New_Part_ID__c.replace('*', '').replace('%', '') + '%\' ';
        }
        
        // NPC Form Status
        if (this.npcFilter.NPC_Form_Status__c != null && this.npcFilter.NPC_Form_Status__c.trim() != '') {
            soql = soql + 'AND NPC_Form_Status__c = \'' + this.npcFilter.NPC_Form_Status__c + '\' ';
        }
        
        // Fab
        if (this.npcFilter.Fab__c != null && this.npcFilter.Fab__c.trim() != '') {
            soql = soql + 'AND Fab__c = \'' + this.npcFilter.Fab__c + '\' ';
        }
        
        // Search For NPC Filter
        if (this.searchForNPC == 'My NPC') {
            soql = soql + 'AND Owner__c = \'' + UserInfo.getUserId() + '\' ';
        }
        
        soql = soql + 'ORDER BY Name DESC LIMIT ' + this.listSize;
        system.debug('soql ==================> ' + soql);
        
        /*for (New_Part_Creation_Form__c npc : [SELECT        Id
                                                            , Name
                                                            , BASE_Device__c
                                                            , BASE_Device__r.Name
                                                            , Originating_Device__c
                                                            , Originating_Device__r.Name
                                                            , Fab__c
                                                            , NPC_Form_Status__c
                                                            , Reason_for_New_Part__c
                                                            , Tapeout_Required__c
                                                            , Owner__c
                                                            , Account__c
                                                            , RecordTypeId
                                                            , New_Part_ID__c
                                               FROM         New_Part_Creation_Form__c
                                               WHERE        Account__c IN :this.accountIds
                                               ORDER BY     Name DESC
                                               LIMIT        :this.listSize]) {*/
        for (New_Part_Creation_Form__c npc : Database.query(soql)) {                                               
            NPCWrapper n = new NPCWrapper();
            
            // Edit
            // Edit link based on device access.
            // ZAmbat 12/18/2013
            //if (this.deviceSharingMap.containsKey(npc.BASE_Device__c) && (npc.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_PEND_SUBMISSION').Value__c || npc.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_PEND_RESUB').Value__c || (npc.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c && npc.RecordTypeId == this.rtStatusRejected.Id))) {
            //if (UserInfo.getUserId() == npc.Owner__c && (npc.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_PEND_SUBMISSION').Value__c || npc.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_PEND_RESUB').Value__c || (npc.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c && npc.RecordTypeId == this.rtStatusRejected.Id))) {
            // ZAmbat 12182013
            if (UserInfo.getUserId() == npc.Owner__c && (npc.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_PEND_SUBMISSION').Value__c || npc.NPC_Form_Status__c == Environment_Variable__c.getInstance('NPC_STATUS_PEND_RESUB').Value__c)) {            
                n.isEditable = true;
            } else {
                n.isEditable = false;
            }
            
            if (this.deviceSharingMap.containsKey(npc.Originating_Device__c)) {
                n.hasAccessToDevice = true;
            } else {
                n.hasAccessToDevice = false;
            }
            
            n.npcForm = npc;
            this.listNPC.add(n);
        }              
        
        paginate();
        this.currPage = this.pages.get(1);
        this.totalNoOfRecords = this.listNPC.size();
    }
    
    public boolean getHasPrevious() {        
        return (this.currentPageNo > 1 ? true : false);
    }
    
    public boolean getHasNext() {
        return (this.currentPageNo < this.totalNoOfPages ? true : false);
    }
    
    public void previous() {
        this.currentPageNo--;      
        this.currPage = this.pages.get(this.currentPageNo);
    }
    
    public void next() {
        this.currentPageNo++;       
        this.currPage = this.pages.get(this.currentPageNo);
    }
    
    public void first() {
        this.currentPageNo = 1;      
        this.currPage = this.pages.get(1);
    }
    
    public void last() {
        this.currentPageNo = this.totalNoOfPages;       
        this.currPage = this.pages.get(this.currentPageNo);
    }
    
    public List<SelectOption> getFabs() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('FAB 1','FAB 1'));
        options.add(new SelectOption('FAB 2','FAB 2'));
        options.add(new SelectOption('FAB 3','FAB 3'));
        options.add(new SelectOption('FAB 3E','FAB 3E'));
        options.add(new SelectOption('FAB 5','FAB 5'));
        options.add(new SelectOption('FAB 6','FAB 6'));
        options.add(new SelectOption('FAB 7','FAB 7'));
        options.add(new SelectOption('FAB 8','FAB 8'));
        
        return options;
    }
    
    public void refreshFilters() {
        this.referenceDevice = '';
        this.npcFormName = '';
        this.npcFilter = new New_Part_Creation_Form__c();
        this.npcFilter.NPC_Form_Status__c = '';
        this.npcFilter.Reason_for_New_Part__c = '';
        this.npcFilter.Fab__c = '';
        this.npcFilter.Tapeout_Required__c = '';
        this.searchForNPC = 'All NPC';
    }
    
    public void clearAllFilters() {
        refreshFilters();
        retrieveNPCList();
    }
    
    public List<SelectOption> getSearchFor() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All NPC','All NPC'));
        options.add(new SelectOption('My NPC','My NPC'));
        
        return options;
    } 
    
    // Wrapper Class
    public class NPCWrapper {
        public boolean hasAccessToDevice {get;set;}
        public boolean isEditable {get;set;}
        public New_Part_Creation_Form__c npcForm {get;set;}
    }
}