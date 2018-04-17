/*
    Author: Abhita Bansal
    Description: This serves as the Add, Edit, and View Controller for Customer Guideline Factor.
    History: 
        ABansal     05062015    - Code creation.
*/

public class MPWCustomerGuidelineFactTranxController {
    
    public Customer_Guideline_Factor__c mpwCustomerGuide {get;set;}
    public string tranx {get;set;}
    public String returnURL {get;set;} 
    public string techNode{get;set;}
    public UtilClassToGetAllFields util{get;set;}
    
    public MPWCustomerGuidelineFactTranxController (ApexPages.StandardController controller) {
        mpwCustomerGuide = new Customer_Guideline_Factor__c();
        util = new UtilClassToGetAllFields();
        
        // Check the transaction (View, Edit, or Add)
        if (ApexPages.currentPage().getParameters().get('tranx') != null) {
            this.tranx = ApexPages.currentPage().getParameters().get('tranx');
        } else {
            this.tranx = 'View';
        }
        
        // Check for record Id
        if (this.tranx == 'View' || this.tranx == 'Edit') {
            this.mpwCustomerGuide = retrieveRecordDetails(ApexPages.currentPage().getParameters().get('id'));
        } else if (this.tranx == 'Add') {
            this.mpwCustomerGuide = new Customer_Guideline_Factor__c();
        }
        
        // Get the URL of the previous Tab
        returnURL =  ApexPages.currentPage().getParameters().get('returnURL');
    }
    
    public List<SelectOption> getTechIdList(){
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
            mpwgm = [select Geometry_ID__c from MPW_Geometry_Mapping__c where Name =: this.mpwCustomerGuide.TechNodes__c];
            if(mpwgm != null){
                this.mpwCustomerGuide.Tech_ID__c = mpwgm.Geometry_ID__c;    
            }
            
            if(this.mpwCustomerGuide.Sub_Devices_Extraction__c == null){
                this.mpwCustomerGuide.Sub_Devices_Extraction__c = 0;
            }
            if(this.mpwCustomerGuide.Option2__c == null){
                this.mpwCustomerGuide.Option2__c = 0;
            }
            if(this.mpwCustomerGuide.Wafer_Form_Delivery__c == null){
                this.mpwCustomerGuide.Wafer_Form_Delivery__c = 0;
            }
            if(this.mpwCustomerGuide.Expedite__c == null){
                this.mpwCustomerGuide.Expedite__c = 0;
            }
            if(this.mpwCustomerGuide.ShortLoop_Wafer__c == null){
                this.mpwCustomerGuide.ShortLoop_Wafer__c = 0;
            }
            if(this.mpwCustomerGuide.Adder3__c == null){
                this.mpwCustomerGuide.Adder3__c = 0;
            }
            if(this.mpwCustomerGuide.ExtraDice_B__c == null){
                this.mpwCustomerGuide.ExtraDice_B__c = 0;
            }
            if(this.mpwCustomerGuide.RecticalSpace_A1__c == null){
                this.mpwCustomerGuide.RecticalSpace_A1__c = 0;
            }
            if(this.mpwCustomerGuide.ReticleSpace_Min__c == null){
                this.mpwCustomerGuide.ReticleSpace_Min__c = 0;
            }
        
            // Save record
            upsert this.mpwCustomerGuide;
            
            // Redirect
            PageReference p = Page.MPWCustomerGuidelineFactTranxVF;
            p.getParameters().put('tranx', 'View');
            p.getParameters().put('id', this.mpwCustomerGuide.Id);
            p.getParameters().put('returnURL', returnURL);
            p.setRedirect(true);
            
            return p;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));  
            return null;
        }
    }
    
    public PageReference edit() {
        PageReference p = Page.MPWCustomerGuidelineFactTranxVF;
        p.getParameters().put('tranx', 'Edit');
        p.getParameters().put('id', this.mpwCustomerGuide.Id);
        p.getParameters().put('returnURL', returnURL);
        p.setRedirect(true);
        
        return p;
    }
    
    public PageReference cancel() {
        PageReference p;
        if(this.tranx == 'Add') {
            p = new pageReference(returnURL);
        } else if(this.tranx == 'Edit') {
            p = Page.MPWCustomerGuidelineFactTranxVF;
            p.getParameters().put('tranx', 'View');
            p.getParameters().put('id', this.mpwCustomerGuide.Id);
            p.getParameters().put('returnURL', returnURL);
        }
        p.setRedirect(true);
        
        return p;
    }
    
    private Customer_Guideline_Factor__c retrieveRecordDetails(string recordId) {
    
        String queryFields = util.getAllFields('Customer_Guideline_Factor__c');
        String query = 'select '+queryFields+' from Customer_Guideline_Factor__c where Id =\''+recordId+'\'';
             
        return Database.query(query);
    }
    
    public boolean getEditSubDevice() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    
    public boolean getEditOption() {
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
    
    public boolean getEditExpedite() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    
    public boolean getEditShort() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    
    public boolean getEditAdder3() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    public boolean getEditExtraDice() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    public boolean getEditReticleSpaceA1() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    public boolean getEditReticleSpaceMin() {
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