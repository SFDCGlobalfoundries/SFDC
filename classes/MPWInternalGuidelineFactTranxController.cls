/*
    Author: Abhita Bansal
    Description: This serves as the Add, Edit, and View Controller for Internal Guideline Factor.
    History: 
        ABansal     05062015    - Code creation.
*/

public class MPWInternalGuidelineFactTranxController {
    
    public Internal_Guideline_Factor__c mpwInternalGuide {get;set;}
    public string tranx {get;set;}
    public String returnURL {get;set;} 
    public string techNode{get;set;}
    public UtilClassToGetAllFields util{get;set;}
    
    public MPWInternalGuidelineFactTranxController (ApexPages.StandardController controller) {
        mpwInternalGuide = new Internal_Guideline_Factor__c();
        util = new UtilClassToGetAllFields();
        
        // Check the transaction (View, Edit, or Add)
        if (ApexPages.currentPage().getParameters().get('tranx') != null) {
            this.tranx = ApexPages.currentPage().getParameters().get('tranx');
        } else {
            this.tranx = 'View';
        }
        
        // Check for record Id
        if (this.tranx == 'View' || this.tranx == 'Edit') {
            this.mpwInternalGuide = retrieveRecordDetails(ApexPages.currentPage().getParameters().get('id'));
        } else if (this.tranx == 'Add') {
            this.mpwInternalGuide = new Internal_Guideline_Factor__c();
        }
        
        // Get the URL of the previous Tab
        returnURL =  ApexPages.currentPage().getParameters().get('returnURL');
    }
    
    public List<SelectOption> getTechNodesList(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','Select TechNode'));
        for(MPW_Geometry_Mapping__c m: [select Id, Name, Sequence_No__c from MPW_Geometry_Mapping__c where Active__c = true and Use_Process_Type__c = true order by Sequence_No__c asc]){
            options.add(new SelectOption(m.Name,m.Name));
        }
        return options;
    }
    
    public PageReference save() {
        try {
            
            MPW_Geometry_Mapping__c mpwgm = new MPW_Geometry_Mapping__c();
            mpwgm = [select Geometry_ID__c from MPW_Geometry_Mapping__c where Name =: this.mpwInternalGuide.Tech_Node__c];
            if(mpwgm != null){
                this.mpwInternalGuide.TechID__c = mpwgm.Geometry_ID__c;    
            }
            if(this.mpwInternalGuide.DieToWaferConv__c == null){
                this.mpwInternalGuide.DieToWaferConv__c = '0';
            }
            if(this.mpwInternalGuide.Reticle__c == null){
                this.mpwInternalGuide.Reticle__c = 0;
            }
            if(this.mpwInternalGuide.Wafer__c == null){
                this.mpwInternalGuide.Wafer__c = 0;
            }
        
            // Save record
            upsert this.mpwInternalGuide;
            
            // Redirect
            PageReference p = Page.MPWInternalGuidelineFactTranxVF;
            p.getParameters().put('tranx', 'View');
            p.getParameters().put('id', this.mpwInternalGuide.Id);
            p.getParameters().put('returnURL', returnURL);
            p.setRedirect(true);
            
            return p;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));  
            return null;
        }
    }
    
    public PageReference edit() {
        PageReference p = Page.MPWInternalGuidelineFactTranxVF;
        p.getParameters().put('tranx', 'Edit');
        p.getParameters().put('id', this.mpwInternalGuide.Id);
        p.getParameters().put('returnURL', returnURL);
        p.setRedirect(true);
        
        return p;
    }
    
    public PageReference cancel() {
        PageReference p;
        if(this.tranx == 'Add') {
            p = new pageReference(returnURL);
        } else if(this.tranx == 'Edit') {
            p = Page.MPWInternalGuidelineFactTranxVF;
            p.getParameters().put('tranx', 'View');
            p.getParameters().put('id', this.mpwInternalGuide.Id);
            p.getParameters().put('returnURL', returnURL);
        }
        p.setRedirect(true);
        
        return p;
    }
    
    private Internal_Guideline_Factor__c retrieveRecordDetails(string recordId) {
    
        String queryFields = util.getAllFields('Internal_Guideline_Factor__c');
        String query = 'select '+queryFields+' from Internal_Guideline_Factor__c where Id =\''+recordId+'\'';
             
        return Database.query(query);
    }
    
    public boolean getEditId() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    
    public boolean getEditReticle() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    
    public boolean getEditTechNode() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    
    public boolean getEditWafer() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    
    public boolean getEditDieToWafer() {
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