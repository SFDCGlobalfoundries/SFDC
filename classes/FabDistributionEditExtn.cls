/*
Type Name: MRSLayerSummaryExtn
Author: Cognizant Technology Solutions
Created Date: 11-April-2014
Reason: This is a controller class for VFMRSFabDistributionEdit page
Change History:
Cognizant            27082014     -      Code comments updated
Cognizant            23082014     -      UAT Defect fixing
……..
……..
*/
public class FabDistributionEditExtn {
    
    public Fab_Distribution_Table__c FabEditObject {get;set;} {FabEditObject = new Fab_Distribution_Table__c();}
    public Fab_Distribution_Table__c LeftColumn {get;set;} {LeftColumn = new Fab_Distribution_Table__c();}
    public Fab_Distribution_Table__c RightColumn {get;set;} {RightColumn = new Fab_Distribution_Table__c();}
    
    public String FabId {get;set;}{FabId = '';}

    public Boolean isEdit {get;set;}{isEdit = true;}

/*
This is the constructor for this controller. 
The main purpose of this constructor is to detect any Fab object Id in the parameter and fetch the object information if present.
*/ 
    public FabDistributionEditExtn(ApexPages.StandardController controller) {
        Fab_Distribution_Table__c OrigObj = (Fab_Distribution_Table__c)controller.getRecord();
        FabId = String.valueOf(OrigObj.Id);
        if(FabId != null && FabId != ''){ 
            FabEditObject = [select Id,Fab_No__c,Distribution_List__c,Name,OwnerId from Fab_Distribution_Table__c where Id =:FabId limit 1]; 
            initilizeData();
        }
        else{
            FabEditObject.OwnerId = UserInfo.getUserId();
            isEdit = false;
        }
    }

/**
    This method is for going back to the earlier page on clicking cancel button
    @method name: CancelValues
    @parameter:   None
    @return :     Reference of the earlier Visualforce page
**/ 
    public pagereference CancelValues(){
        if(isEdit){
            return new pagereference('/'+FabId);        
        }
        else{
            Schema.DescribeSObjectResult r = Fab_Distribution_Table__c.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();
            return new pagereference('/'+keyPrefix+'/o');
        }
    }

/**
    This method is for inserting values on objects on clicking save button in the create fab distribution page
    @method name: InsertValues
    @parameter:   None
    @return :     Reference of the earlier Visualforce page
**/
    public pagereference InsertValues(){
        try{
            Fab_Distribution_Table__c obj = new Fab_Distribution_Table__c();
            obj.Distribution_List__c = RightColumn.Distribution_List__c;
            obj.Fab_No__c = LeftColumn.Fab_No__c;
            obj.OwnerId = UserInfo.getUserId();
            String retURL = null;
            if(LeftColumn.Fab_No__c == 'All'){
                List<Fab_Distribution_Table__c> totalFabList = new List<Fab_Distribution_Table__c>();
                for(Fab_Distribution_Table__c objLoop : [select Id,Distribution_List__c from Fab_Distribution_Table__c where IsDeleted = false]){
                    objLoop.Distribution_List__c = RightColumn.Distribution_List__c;
                    totalFabList.add(objLoop);
                }
                update totalFabList;   
                Schema.DescribeSObjectResult r = Fab_Distribution_Table__c.sObjectType.getDescribe();
                String keyPrefix = r.getKeyPrefix();  
                retURL = '/'+keyPrefix+'/o';      
                return new pagereference(retURL);
            }
            else{
                if([select Id,Distribution_List__c from Fab_Distribution_Table__c where IsDeleted = false and Fab_No__c =:LeftColumn.Fab_No__c].size()>0){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Fab exists in Fab Distribution List Table. Please re-specify');
                    ApexPages.addMessage(myMsg);
                    pagereference pg = new pagereference('/apex/VFMRSFabDistributionEdit');
                    retURL = null;  
                    return null;      
                }
                else{
                    insert obj;
                    FabId = String.valueOf(obj.Id);
                    retURL = '/'+FabId; 
                    return new pagereference(retURL);       
                }
            }
            return new pagereference(retURL);
        }
        catch(Exception e){
            return null;
        }
    }
    
/**
    This method is for saving values on objects on clicking save button in the edit fab distribution page
    @method name: SaveValues
    @parameter:   None
    @return :     Reference of the earlier Visualforce page
**/
    public pagereference SaveValues(){
        try{        
                    FabEditObject.Distribution_List__c = RightColumn.Distribution_List__c;
                    upsert FabEditObject;        
            return new pagereference('/'+FabId);
        }
        catch(Exception e){  
                return null;      
        }         
    }
/**
    This method is for retrieving the fieldset members of the left column of the page
    @method name: getLeftColumnFields
    @parameter:   None
    @return :     List of fieldset members
**/    
    public List<Schema.FieldSetMember> getLeftColumnFields() {
        if(isEdit){
            return SObjectType.Fab_Distribution_Table__c.FieldSets.Left_Column_FieldSets.getFields();
        }
        else{
            return SObjectType.Fab_Distribution_Table__c.FieldSets.Left_Column_FieldSet_New.getFields();
        }
    } 
/**
    This method is for retrieving the Fab Distribution object based on the selection
    @method name: getLeftColumnValues
    @parameter:   None
    @return :     Fab Distribution object
**/        
    private Fab_Distribution_Table__c getLeftColumnValues() {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getLeftColumnFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id FROM Fab_Distribution_Table__c where Id=:FabId';
        return Database.query(query);
    }    

/**
    This method is for retrieving the fieldset members of the right column of the page
    @method name: getRightColumnFields
    @parameter:   None
    @return :     List of fieldset members
**/ 
    public List<Schema.FieldSetMember> getRightColumnFields() {
        return SObjectType.Fab_Distribution_Table__c.FieldSets.Right_Column_FieldSets.getFields();
    }    

/**
    This method is for retrieving the Fab Distribution object based on the selection
    @method name: getRightColumnValues
    @parameter:   None
    @return :     Fab Distribution object
**/ 
    private Fab_Distribution_Table__c getRightColumnValues() {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getRightColumnFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id FROM Fab_Distribution_Table__c where Id=:FabId';
        return Database.query(query);
    } 

/**
    This method is for retrieving the Fab Distribution object based on page load
    @method name: initilizeData
    @parameter:   None
    @return :     None
**/
    private void initilizeData(){
        this.LeftColumn = getLeftColumnValues();
        this.RightColumn = getRightColumnValues();
    }             
    
}