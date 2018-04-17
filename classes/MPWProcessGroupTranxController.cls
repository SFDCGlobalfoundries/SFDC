/*
    Author: Abhita Bansal
    Description: This serves as the Add, Edit, and View Controller for MPW Process Group.
    History: 
        ABansal     05062015    - Code creation.
*/

public class MPWProcessGroupTranxController {
    
    public MPW_Process_Group__c mpwProcessGps {get;set;}
    public string tranx {get;set;}
    public String returnURL {get;set;} 
    public string geometry{get;set;}
    
    public MPWProcessGroupTranxController (ApexPages.StandardController controller) {
        mpwProcessGps = new MPW_Process_Group__c ();
        
        // Check the transaction (View, Edit, or Add)
        if (ApexPages.currentPage().getParameters().get('tranx') != null) {
            this.tranx = ApexPages.currentPage().getParameters().get('tranx');
        } else {
            this.tranx = 'View';
        }
        
        // Check for record Id
        if (this.tranx == 'View' || this.tranx == 'Edit') {
            this.mpwProcessGps = retrieveRecordDetails(ApexPages.currentPage().getParameters().get('id'));
        } else if (this.tranx == 'Add') {
            this.mpwProcessGps = new MPW_Process_Group__c();
        }
        
        // Get the URL of the previous Tab
        returnURL =  ApexPages.currentPage().getParameters().get('returnURL');
    }
    
    public List<SelectOption> getFab() {
        List<SelectOption> options = new List<SelectOption>();
        for (MPW_Keyword_Config__c m : [SELECT    Id
                                                  , Value__c
                                        FROM      MPW_Keyword_Config__c
                                        WHERE     Active__c = true
                                                  AND Type__c = 'FabListing'
                                        ORDER BY  Sequence_No__c ASC]) {
            options.add(new SelectOption(m.Value__c, m.Value__c));
        }
        
        return options;
    }
    
    public List<SelectOption> getProcess() {
        List<SelectOption> options = new List<SelectOption>();
        for (MPW_Config_Settings__c c : [SELECT   Name
                                        FROM      MPW_Config_Settings__c
                                        WHERE     Active__c = true
                                                  AND Geometry__c = :this.mpwProcessGps.Geometry__c
                                                  AND RecordType.Name = 'Process'
                                        ORDER BY  Name ASC]) {
            options.add(new SelectOption(c.Name, c.Name));
        }
        
        return options;
    }
    
    public List<SelectOption> getGeometryList(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','Select Geometry'));
        for(MPW_Geometry_Mapping__c m: [select Id, Name, Sequence_No__c from MPW_Geometry_Mapping__c where Active__c = true and Use_Process_Type__c = true order by Sequence_No__c asc]){
            options.add(new SelectOption(m.Name,m.Name));
        }
        return options;
    }
    
    public PageReference save() {
        try {
            
            MPW_Geometry_Mapping__c mpwgm = new MPW_Geometry_Mapping__c();
            mpwgm = [select Geometry_ID__c from MPW_Geometry_Mapping__c where Name =: this.mpwProcessGps.Geometry__c];
            if(mpwgm != null){
                this.mpwProcessGps.Geometry_ID__c = mpwgm.Geometry_ID__c;    
            }
        
            // Save record
            upsert this.mpwProcessGps;
            
            // Redirect
            PageReference p = Page.MPWProcessGroupTranxVF;
            p.getParameters().put('tranx', 'View');
            p.getParameters().put('id', this.mpwProcessGps.Id);
            p.getParameters().put('returnURL', returnURL);
            p.setRedirect(true);
            
            return p;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));  
            return null;
        }
    }
    
    public PageReference edit() {
        PageReference p = Page.MPWProcessGroupTranxVF;
        p.getParameters().put('tranx', 'Edit');
        p.getParameters().put('id', this.mpwProcessGps.Id);
        p.getParameters().put('returnURL', returnURL);
        p.setRedirect(true);
        
        return p;
    }
    
    public PageReference cancel() {
        PageReference p;
        if(this.tranx == 'Add') {
            p = new pageReference(returnURL);
        } else if(this.tranx == 'Edit') {
            p = Page.MPWProcessGroupTranxVF;
            p.getParameters().put('tranx', 'View');
            p.getParameters().put('id', this.mpwProcessGps.Id);
            p.getParameters().put('returnURL', returnURL);
        }
        p.setRedirect(true);
        
        return p;
    }
    
    public PageReference backToList() {
        PageReference p = new pageReference(returnURL);
        p.setRedirect(true);
        
        return p;
    }
    
    private MPW_Process_Group__c retrieveRecordDetails(string recordId) {
        string soql = 'SELECT Id, Name, Geometry__c, Active__c, Process__c, Fab__c ' + 
                      'FROM MPW_Process_Group__c ' +
                      'WHERE Id=\'' + recordId + '\' ' +
                      'ORDER BY Name ASC';        
        return Database.query(soql);
    }
    
    public boolean getEditName() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
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
    
    public boolean getEditFab() {
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