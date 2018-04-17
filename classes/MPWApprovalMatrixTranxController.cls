/*
    Author: Abhita Bansal
    Description: This serves as the Add, Edit, and View Controller for MPW Approval Matrix.
    History: 
        ABansal      06232015    - Code creation.
        Poulami      04072016    - Modified code to populate Sub Category based on ASIC R&D, RF_ASIC_A&D Protos categories (MPW-PP87).
                                 - Modified code to add PA Code for IP, DE, ASIC R&D, RF_ASIC_A&D Protos categories (MPW-PP87).
*/

public class MPWApprovalMatrixTranxController{
    
    public string tranx {get;set;}
    public MPW_Approval_Matrix__c mpwApp {get;set;}
    public String returnURL {get;set;} 
    public Boolean isNOTFAB {get; set;}
    
    public MPWApprovalMatrixTranxController(ApexPages.StandardController controller) {
    
        mpwApp = new MPW_Approval_Matrix__c ();
        
        // Check the transaction (View, Edit, or Add)
        if (ApexPages.currentPage().getParameters().get('tranx') != null) {
            this.tranx = ApexPages.currentPage().getParameters().get('tranx');
        } else {
            this.tranx = 'View';
        }
        
        // Check for record Id
        if (this.tranx == 'View' || this.tranx == 'Edit') {
            System.debug(ApexPages.currentPage().getParameters().get('id'));
            this.mpwApp = retrieveRecordDetails(ApexPages.currentPage().getParameters().get('id'));
        } else if (this.tranx == 'Add') {
            this.mpwApp = new MPW_Approval_Matrix__c ();
        }
        
        // Get the URL of the previous Tab
        returnURL =  ApexPages.currentPage().getParameters().get('returnURL');
        
        if(this.tranx == 'View' || this.tranx == 'Edit') {
            MPW_Approval_Matrix__c mpwAppMat = retrieveRecordDetails(ApexPages.currentPage().getParameters().get('id'));
            //04072016 - Modified by Poulami Starts.
            if(mpwAppMat.Category__c == 'DE' || mpwAppMat.Category__c == 'IP' || mpwAppMat.Category__c == 'Lighting' || mpwAppMat.Category__c == 'ASIC R&D' || mpwAppMat.Category__c == 'RF_ASIC_A&D Protos') {
                this.isNOTFAB = true;
            }   
            //04072016 - Modified by Poulami Ends.
        } else {
            this.isNOTFAB = false;
        }
    }
    
    public pageReference back(){
        pageReference pgRef = new pageReference(returnURL);
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public List<SelectOption> getFab() {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('', '--None--'));
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
    
    public List<SelectOption> getGeometry() {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('None','Select Geometry'));
        for(MPW_Geometry_Mapping__c m: [select Id, Name, Sequence_No__c from MPW_Geometry_Mapping__c where Active__c = true and Use_Process_Type__c = true order by Sequence_No__c asc]){
            options.add(new SelectOption(m.Name,m.Name));
        }
        
        return options;
    }
    
    public void getCategory() {
        System.debug('@@@@@@@@@'+mpwApp.Category__c);
        //04072016 - Modified by Poulami Starts.
        if(mpwApp.Category__c == 'DE' || mpwApp.Category__c == 'IP' || mpwApp.Category__c == 'Lighting' || mpwApp.Category__c == 'ASIC R&D' || mpwApp.Category__c == 'RF_ASIC_A&D Protos') {
            this.isNOTFAB = true;
        }
        //04072016 - Modified by Poulami Ends.
        else {
            this.isNOTFAB = false;
        }
    }
    
    public List<SelectOption> getsubCategory() {
        List<SelectOption> options = new List<SelectOption>();
        if(mpwApp.Category__c == 'IP') {
            for (MPW_Keyword_Config__c m : [SELECT    Id
                                                      , Value__c
                                            FROM      MPW_Keyword_Config__c
                                            WHERE     Active__c = true
                                                      AND Type__c = 'IPSubCategory'
                                            ORDER BY  Sequence_No__c ASC]) {
                options.add(new SelectOption(m.Value__c, m.Value__c));
            } 
        }
         else if(mpwApp.Category__c == 'DE') {
            for (MPW_Keyword_Config__c m : [SELECT    Id
                                                      , Value__c
                                            FROM      MPW_Keyword_Config__c
                                            WHERE     Active__c = true
                                                      AND Type__c = 'DESubCategory'
                                            ORDER BY  Sequence_No__c ASC]) {
                    options.add(new SelectOption(m.Value__c, m.Value__c));
                }
        } 
        //04072016 - Added by Poulami Starts.
        else if(mpwApp.Category__c == 'ASIC R&D') {
            for (MPW_Keyword_Config__c m : [SELECT    Id
                                                      , Value__c
                                            FROM      MPW_Keyword_Config__c
                                            WHERE     Active__c = true
                                                      AND Type__c = 'ASIC_R&DSubCategory'
                                            ORDER BY  Sequence_No__c ASC]) {
                    options.add(new SelectOption(m.Value__c, m.Value__c));
                }
        } else if(mpwApp.Category__c == 'RF_ASIC_A&D Protos') {
            for (MPW_Keyword_Config__c m : [SELECT    Id
                                                      , Value__c
                                            FROM      MPW_Keyword_Config__c
                                            WHERE     Active__c = true
                                                      AND Type__c = 'RF_ASIC_A&D_ProtosSubCategory'
                                            ORDER BY  Sequence_No__c ASC]) {
                    options.add(new SelectOption(m.Value__c, m.Value__c));
                }
        } 
        //04072016 - Added by Poulami Ends.
        else {
            options.add(new SelectOption('All', 'All'));
        }
                  
        return options;
    }
    
   
    public PageReference save() {
        try {
            
            // Save record
            if(mpwApp.Category__c == 'FAB' || mpwApp.Category__c == 'TD'){
                MPW_Geometry_Mapping__c mpwgm = new MPW_Geometry_Mapping__c();
                mpwgm = [select Geometry_ID__c from MPW_Geometry_Mapping__c where Name =: this.mpwApp.Geometry__c];
                if(mpwgm != null){
                    this.mpwApp.Geometry_ID__c = mpwgm.Geometry_ID__c;    
                }
            }
            
            upsert this.mpwApp;
            
            // Redirect
            PageReference p = Page.MPWApprovalMatrixTranxVF;
            p.getParameters().put('tranx', 'View');
            p.getParameters().put('id', this.mpwApp.Id);
            p.getParameters().put('returnURL', returnURL);
            p.setRedirect(true);
            
            return p;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage())); 
            return null;
        }
    }
    
    public PageReference edit() {
        PageReference p = Page.MPWApprovalMatrixTranxVF;
        p.getParameters().put('tranx', 'Edit');
        p.getParameters().put('id', this.mpwApp.Id);
        p.getParameters().put('returnURL', returnURL);
        p.setRedirect(true);
        
        return p;
    }
    
    public PageReference cancel() {
        PageReference p;
        if(this.tranx == 'Add') {
            p = new pageReference(returnURL);
        } else if(this.tranx == 'Edit') {
            p = Page.MPWApprovalMatrixTranxVF;
            p.getParameters().put('tranx', 'View');
            p.getParameters().put('id', this.mpwApp.Id);
            p.getParameters().put('returnURL', returnURL);
        }
        p.setRedirect(true);
        
        return p;
    }
    
    private MPW_Approval_Matrix__c retrieveRecordDetails(string recordId) {
        //04072016 - Modified by Poulami Starts.
        string soql = 'SELECT Id, Step_1_Approver_1__c, Geometry__c, Category__c, Sub_Category__c, Fab__c, Step_1_Approver_2__c, Step_1_Approver_3__c, PA_Code__c ' + 
                      'FROM MPW_Approval_Matrix__c ' +
                      'WHERE Id=\'' + recordId + '\' ' +
                      'ORDER BY Name ASC';    
        //04072016 - Modified by Poulami Ends.
        return Database.query(soql);
    }
    
    public boolean getEditCategory() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    
    public boolean getEditApprover1() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    
    public boolean getEditApprover2() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    
    public boolean getEditSubCategory() {
        boolean temp = false;
        if (mpwApp.Category__c != 'Lighting' && (this.tranx == 'Add' || this.tranx == 'Edit')) {
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
    
    public boolean getEditGeometry() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    
    //04072016 - Added by Poulami Starts.
    public boolean getEditPACode() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    //04072016 - Added by Poulami Ends.
    
    public boolean getEditApprover3() {
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