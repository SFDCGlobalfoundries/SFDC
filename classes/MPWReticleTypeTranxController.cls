/*
    Author: venkat
    Description: This serves as the Add, Edit, and View Controller for MPW Retical type.
    
*/

public class MPWReticleTypeTranxController {
    
    public MPWReticleType mpwReticleType{get;set;}
    public string tranx {get;set;}
    public String returnURL {get;set;} 
    public string techNode{get;set;}
    public UtilClassToGetAllFields util{get;set;}
   
    
    public MPWReticleTypeTranxController (ApexPages.StandardController controller) {
    }
   
    public MPWReticleTypeTranxController () {	
        mpwReticleType = new MPWReticleType (new MPW_Reticle_Type__c());
        util = new UtilClassToGetAllFields();
        
        // Check the transaction (View, Edit, or Add)
        if (ApexPages.currentPage().getParameters().get('tranx') != null) {
            this.tranx = ApexPages.currentPage().getParameters().get('tranx');
        } else {
            this.tranx = 'View';
        }
        
        // Check for record Id
        if (this.tranx == 'View' || this.tranx == 'Edit') {
            this.mpwReticleType = retrieveRecordDetails(ApexPages.currentPage().getParameters().get('id'));
        } else if (this.tranx == 'Add') {
            this.mpwReticleType = new MPWReticleType (new MPW_Reticle_Type__c());
        }
        
        // Get the URL of the previous Tab
        returnURL =  ApexPages.currentPage().getParameters().get('returnURL');
    }
    
      public List<SelectOption> getReticleType(){
      	 List<SelectOption> options = new List<SelectOption>();
      	 options.add(new SelectOption('','Select Reticle type'));
      	
      	Schema.DescribeFieldResult fieldResult = MPW_Train_Maintenance__c.Reticle_Type__c.getDescribe();
        for(Schema.PicklistEntry pickval: fieldResult.getPicklistValues()){
            options.add(new SelectOption(pickval.getLabel(),pickval.getValue()));
        }
        
        return options; 
      }
    
    public List<SelectOption> getTechNodesList(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Select TechNode'));
        for(MPW_Geometry_Mapping__c m: [select Id, Name, Sequence_No__c from MPW_Geometry_Mapping__c where Active__c = true and Use_Process_Type__c = true order by Sequence_No__c asc]){
            options.add(new SelectOption(m.Name,m.Name));
        }
        return options;
    }
    
    public PageReference save() {
        try {
          
           
            if(this.mpwReticleType.Reticle_Type == null){
                this.mpwReticleType.Reticle_Type = null;
            }
        
            // Save record
           // upsert this.mpwReticleType;
           upsertAction(this.mpwReticleType);
            
            // Redirect
            PageReference p = Page.MPWReticleTypeTranxVF;
            p.getParameters().put('tranx', 'View');
            p.getParameters().put('id', this.mpwReticleType.strId);
            p.getParameters().put('returnURL', returnURL);
            p.setRedirect(true);
            
            return p;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));  
            return null;
        }
    }
    
    private void upsertAction(MPWReticleType obj){
    	MPW_Reticle_Type__c objRet=new MPW_Reticle_Type__c(id=obj.strId,Name=obj.strTechIDName,Reticle_Type__c=obj.Reticle_Type);
    	upsert objRet;
    	
    	this.mpwReticleType=new MPWReticleType(objRet);
    }
    
    public PageReference edit() {
        PageReference p = Page.MPWReticleTypeTranxVF;
        p.getParameters().put('tranx', 'Edit');
        p.getParameters().put('id', this.mpwReticleType.strId);
        p.getParameters().put('returnURL', returnURL);
        p.setRedirect(true);
        
        return p;
    }
    
    public PageReference cancel() {
        PageReference p;
        if(this.tranx == 'Add') {
            p = new pageReference(returnURL);
        } else if(this.tranx == 'Edit') {
            p = Page.MPWReticleTypeTranxVF;
            p.getParameters().put('tranx', 'View');
            p.getParameters().put('id', this.mpwReticleType.strId);
            p.getParameters().put('returnURL', returnURL);
        }
        p.setRedirect(true);
        
        return p;
    }
    
    private MPWReticleType retrieveRecordDetails(string recordId) {
    
        String queryFields = util.getAllFields('MPW_Reticle_Type__c');
        String query = 'select '+queryFields+',CreatedBy.Name,LastModifiedBy.Name  from MPW_Reticle_Type__c where Id =\''+recordId+'\'';
       
       MPW_Reticle_Type__c obj=   Database.query(query);   
        return new MPWReticleType(obj);
    }
    
    public boolean getEditId() {
        boolean temp = false;
        if (this.tranx == 'Add' || this.tranx == 'Edit') {
            temp = true;
        }
        
        return temp;
    }
    
    public boolean getEditReticleType() {
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
    
    public class MPWReticleType{
    	public string strId{get;set;}
    	public string strTechIDName{get;set;}
    	public string Reticle_Type{get;set;}
    	public string CreatedByName{get;set;}
    	public string LastmodifyByName{get;set;}
    	
    	public MPWReticleType(MPW_Reticle_Type__c obj){
    		strId=obj.Id;
    		strTechIDName=obj.Name;
    		Reticle_Type=obj.Reticle_Type__c;
    		CreatedByName=obj.CreatedBy.Name;
    		LastmodifyByName=obj.LastModifiedBy.Name;
    	}
    	
    }
}