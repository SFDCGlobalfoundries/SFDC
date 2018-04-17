/*
    Author: Zymark Ambat
    Description: This serves as the Add, Edit, and View Controller for MPW Process and MPW Process DM.
    History: 
        ZAmbat      05062015    - Code creation.
*/

public class MPWConfigSettingsTranxController {
    public string selectedTab {get;set;}
    public string tranx {get;set;}
    public MPW_Config_Settings__c mpwcs {get;set;}
    public String returnURL {get;set;} 
    public String tabId {get;set;} 
    public boolean isClone;
    public boolean isLink;
    
    public MPWConfigSettingsTranxController(ApexPages.StandardController controller) {
    
        isClone = false;
        isLink = false;
        
        // Check if the selected tab is MPW Process or MPW Process DM
        if (ApexPages.currentPage().getParameters().get('from') != null) {
            this.selectedTab = ApexPages.currentPage().getParameters().get('from');
        } else {
            this.selectedTab = 'MPWProcess';
        }
        
        // Check the transaction (View, Edit, or Add)
        if (ApexPages.currentPage().getParameters().get('tranx') != null) {
            this.tranx = ApexPages.currentPage().getParameters().get('tranx');
        } else {
            this.tranx = 'View';
        }
        
        // For Clone Functionality
        String cloneyes = ApexPages.currentPage().getParameters().get('clone');
        if(cloneyes != null && cloneyes.trim() != ''){
            isClone = true;
        }
        
        // Check for record Id
        if (this.tranx == 'View' || this.tranx == 'Edit') {
            this.mpwcs = retrieveRecordDetails(ApexPages.currentPage().getParameters().get('id'));
        } else if (this.tranx == 'Add') {
            this.mpwcs = new MPW_Config_Settings__c();
        }
        
        // Get the URL of the previous Tab
        returnURL =  ApexPages.currentPage().getParameters().get('returnURL');
        tabId = ApexPages.currentPage().getParameters().get('sfdc.tabName');
        
        // Check the parameter link in URL
        String linkURL = ApexPages.currentPage().getParameters().get('link');
        if(linkURL != null && linkURL.trim() != '') {
            isLink = true;
        }
    }
    
    public PageReference save() {
        try {
            // Validate
            if (this.selectedTab == 'MPWProcessDM' && (this.tranx == 'Add' || this.tranx == 'Edit' || isClone == true)) {
                string soql = 'SELECT Id, Name, Geometry__c, Rule__c FROM MPW_Config_Settings__c ' +
                              'WHERE Geometry__c = \'' + this.mpwcs.Geometry__c + '\'' +
                              '      AND Name = \'' + this.mpwcs.Name + '\' AND RecordType.DeveloperName = \'Process_DM\' AND Active__c = true ' + 
                              (this.tranx == 'Edit' ? 'AND Id != \'' + this.mpwcs.Id + '\' ' : '');
                List<MPW_Config_Settings__c> listTemp = Database.query(soql);
                if (listTemp.size() > 0) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'A Rule is already existing for the selected Geometry and Process Type.'));
                    return null;
                } else {
                    if (this.tranx == 'Add') {
                        this.mpwcs.RecordTypeId = [
                            SELECT    Id
                            FROM      RecordType
                            WHERE     DeveloperName = 'Process_DM'
                                      AND SobjectType = 'MPW_Config_Settings__c'
                        ].Id;
                    } else if (this.tranx == 'Edit' || this.tranx == 'Clone') {
                        // Check if MPW Process is Active
                        MPW_Config_Settings__c temp = [
                            SELECT    Active__c
                            FROM      MPW_Config_Settings__c 
                            WHERE     RecordType.DeveloperName = 'Process'
                                      AND Name = :this.mpwcs.Name
                                      AND Geometry__c = :this.mpwcs.Geometry__c
                        ];
                        
                        if (!temp.Active__c) {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'The Process Type selected is Inactive.'));
                            return null;
                        }
                    }
                    
                }
            }
            else if (this.selectedTab == 'MPWProcess' && (this.tranx == 'Add' || this.tranx == 'Edit' || isClone == true)) {
                string soql = 'SELECT Id, Name, Geometry__c, Rule__c FROM MPW_Config_Settings__c ' +
                              'WHERE Geometry__c = \'' + this.mpwcs.Geometry__c + '\' AND RecordType.DeveloperName = \'Process\' AND Name = \'' + this.mpwcs.Name + '\' AND Active__c = true ' +
                              (this.tranx == 'Edit' ? 'AND Id != \'' + this.mpwcs.Id + '\' ' : '');
                              
                List<MPW_Config_Settings__c> tempList = Database.query(soql);
                if (tempList.size() > 0 ) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'A Process Name is already existing for the selected Geometry.'));
                    return null;
                } else {
                    if (this.tranx == 'Add') {
                        this.mpwcs.RecordTypeId = [
                            SELECT    Id
                            FROM      RecordType
                            WHERE     DeveloperName = 'Process'
                                      AND SobjectType = 'MPW_Config_Settings__c'
                        ].Id;
                    }
                }
            }
            
            // Check Clone 
            if(isClone == true && selectedTab == 'MPWProcess'){
                this.mpwcs.Id = null;
            }
            
            // Save record
            upsert this.mpwcs;
            
            if (this.tranx == 'Edit'
                && this.selectedTab == 'MPWProcess'
                && !this.mpwcs.Active__c) {
                List<MPW_Config_Settings__c> listMPWCS = new List<MPW_Config_Settings__c>();
                for (MPW_Config_Settings__c m : [SELECT    Id
                                                 FROM      MPW_Config_Settings__c
                                                 WHERE     RecordType.DeveloperName = 'Process_DM'
                                                           AND Name = :this.mpwcs.Name
                                                           AND Geometry__c = :this.mpwcs.Geometry__c
                                                           AND Active__c = true]) {
                    m.Active__c = false;
                    listMPWCS.add(m);
                    
                    if (listMPWCS.size() > 0) {
                        update listMPWCS;
                    }                         
                }
            }
            
            // Redirect
            PageReference p = Page.MPWConfigSettingsTranxVF;
            p.getParameters().put('tranx', 'View');
            p.getParameters().put('from', this.selectedTab);
            p.getParameters().put('id', this.mpwcs.Id);
            p.getParameters().put('returnURL', returnURL);
            p.getParameters().put('sfdc.tabName',tabId);
            p.setRedirect(true);
            
            return p;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));  
            return null;
        }
    }
    
    public PageReference edit() {
        PageReference p = Page.MPWConfigSettingsTranxVF;
        p.getParameters().put('tranx', 'Edit');
        p.getParameters().put('from', this.selectedTab);
        p.getParameters().put('id', this.mpwcs.Id);
        p.getParameters().put('returnURL', returnURL);
        p.setRedirect(true);
        
        return p;
    }
    
    public PageReference cancel() {
        PageReference p;
        if(this.tranx == 'Add' || (this.tranx == 'Edit' && isLink == true) || (isClone == true && isLink == true)) {       
            p = new pageReference(returnURL);
            if(tabId != null) {
                p.getParameters().put('sfdc.tabName',tabId);
            }
        }
        else if(this.tranx == 'Edit' && isLink == false) {
            p = Page.MPWConfigSettingsTranxVF;
            p.getParameters().put('tranx', 'View');
            p.getParameters().put('from', this.selectedTab);
            p.getParameters().put('id', this.mpwcs.Id);
            p.getParameters().put('returnURL', returnURL);
            p.getParameters().put('sfdc.tabName',tabId);
        }
        p.setRedirect(true);
        
        return p;
    }
    
    public PageReference backToList() {
        PageReference p = new pageReference(returnURL);
        if(tabId != null){
            p.getParameters().put('sfdc.tabName',tabId);
        }
        p.setRedirect(true);
        
        return p;
    }
    
    public List<SelectOption> getProcessTypes() {
        List<SelectOption> options = new List<SelectOption>();
        for (MPW_Config_Settings__c m : [SELECT    Name
                                         FROM      MPW_Config_Settings__c
                                         WHERE     Active__c = true
                                                   AND Geometry__c = :this.mpwcs.Geometry__c
                                                   AND RecordType.Name = 'Process'
                                         ORDER BY  Name ASC]) {
            options.add(new SelectOption(m.Name, m.Name));
        }
        
        return options;
    }
    
    private MPW_Config_Settings__c retrieveRecordDetails(string recordId) {
        string soql = 'SELECT Id, Name, Geometry__c, Active__c ' + 
                       (this.selectedTab == 'MPWProcessDM' ? ', Rule__c ' : '') +
                      'FROM MPW_Config_Settings__c ' +
                      'WHERE Id=\'' + recordId + '\' ' +
                       (this.selectedTab == 'MPWProcessDM' ? 'AND Rule__c != null ' : '') + 
                      'ORDER BY Name ASC';        
        return Database.query(soql);
    }
    
    public boolean getEditActive() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    
    public boolean getEditGeometry() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    
    public boolean getEditProcess() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    
    public boolean getEditRule() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    
    public boolean getShowEdit() {
        boolean temp = false;
        if (this.tranx == 'View' ) {
            temp = true;
        }
        
        return temp;
    }
    
    public boolean getShowSave() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    
    public boolean getShowCancel() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit' ) {
            temp = true;
        }
        
        return temp;
    }
}