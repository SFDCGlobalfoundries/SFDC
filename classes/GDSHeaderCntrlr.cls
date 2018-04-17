/*
    Author: Ariz Solito
    Description: Apex class controller for the GDSUpload component
    History: 
        Asolito     17102014    - Code creation.
*/

public class GDSHeaderCntrlr {

    public String configID {get; set;}   
    public String id2 {get; set;}
    public String id3 {get; set;}
    public String id4 {get; set;}    
    public String translatedRowCount {get; set;}
    public Boolean isPortalUser {get; set;}
        
    private Apttus_Proposal__Proposal__c config;
    private Integer GDScount; 
           
    public String GDSRowCount {                
        get {                        
                if(!UtilsString.isNotBlank(this.GDSRowCount)){
                return String.valueOf(this.GDSCount);
            }                              
            return this.GDSRowCount;   
        }                  
        set;
    }  
    
    public String productRevision {
        get {return this.config.product_revision__c;}        
        set;
    }
    
    public String productName {
        get {return this.config.product_name__c;}        
        set;
    }
    
    public String status {                
        get {            
            for(GDS__c g: this.config.GDS__r){
                if(!UtilsString.isNotBlank(this.status)){
                    return g.status__c;
                }                              
            } 
            return this.status;   
        }
        set;
    }
    
    public String fileName {                
        get {            
            for(GDS__c g: this.config.GDS__r){
                if(!UtilsString.isNotBlank(this.fileName)){
                    return g.file_name__c;
                }                              
            } 
            return this.fileName;   
        }
        set;
    }
    
    public String topCellName {        
        get {            
            for(GDS__c g: this.config.GDS__r){                               
                if(!UtilsString.isNotBlank(this.topCellName)){
                    return g.top_cell_name__c;
                }
            }
            return this.topCellName;    
        }
        set;
    }
    
    public String GDSUploadStep {
        get {
            
            Boolean hasGDS = false;
                        
            for(GDS__c g: this.config.GDS__r){                               
                if(g.status__c == 'Draft' || g.status__c == 'Rejected' || !UtilsString.isNotBlank(g.status__c)){                    
                    return 'active';
                } else {
                    return 'visited';
                }
                hasGDS = true;
            } 
            
            if(!hasGDS){
                return 'active';
            }
            
            return 'visited';           
        }
        set;
    }
    
    public String GDSTranslateStep {
        get {
                      
            for(GDS__c g: this.config.GDS__r){                               
                if(g.status__c == 'Translating'){                    
                    return 'active';
                } else if (g.status__c == 'Approved'){
                    return 'visited';
                }
            } 
            return 'next';
                                         
        }
        set;
    }
    
    public String GDSApproveStep {
        get {
                      
            for(GDS__c g: this.config.GDS__r){                               
                if(g.status__c == 'Approved'){                    
                    return 'visited';
                } 
            } 
            return 'next';
                                         
        }
        set;
    }
    
    public GDSHeaderCntrlr(){  
        this.config = new Apttus_Proposal__Proposal__c();
        
        String GDSId;  
        for(Apttus_Proposal__Proposal__c rec: [SELECT product_name__c,product_revision__c,
                                                      (SELECT id,file_name__c,top_cell_name__c,status__c
                                                              FROM GDS__r
                                                              ORDER BY createdDate DESC
                                                              LIMIT 1)
                                                 FROM Apttus_Proposal__Proposal__c
                                                 WHERE id = :ApexPages.currentPage().getParameters().get('id')]){
            this.config = rec; 
            for(GDS__c g: rec.GDS__r){            
                GDSId = g.id;         
            }
        } 
        
        //get the GDS row count if any
        this.GDSCount = [SELECT count() 
                           FROM GDS_Layer__c 
                           WHERE gds__c = :GDSId]; 
                        
        //check if current user is internal or portal user
        this.isPortalUser = false;
        for(User u: [SELECT contactid 
                       FROM User 
                       WHERE id = :userinfo.getUserId()]){
            if(UtilsString.isNotBlank(u.contactId)){                       
                this.isPortalUser = true;                               
            }
        }                       
                                                      
    }  
    
    public PageReference back(){
        PageReference pageRef = new PageReference('/apex/ProposalSummary?retId=' + this.configId +
                                                  '&id='+ this.id2 + '&businessObjectId=' + this.id3 +
                                                  '&configRequestId='+ this.id4);
        pageRef.setRedirect(true);
        return pageRef;
    } 
    
    public PageReference backtoGDS(){   
        String url = '/apex/GDSUPLOAD?id=' + this.configId +
                     '&id2='+ this.id2 + '&id3=' + this.id3 +
                     '&id4='+ this.id4;
                     
        //add override = true if translation stage is active             
        if(this.GDSTranslateStep == 'active'){
            url += '&override=true';    
        }                      
        PageReference pageRef = new PageReference(url);
                                                         
        pageRef.setRedirect(true);
        return pageRef;
    } 
    
    public PageReference backtoTranslate(){   
        String url = '/apex/CPQTranslateMaskLayerPage?id=' + this.configId +
                     '&id2='+ this.id2 + '&id3=' + this.id3 +
                     '&id4='+ this.id4;
                                               
        PageReference pageRef = new PageReference(url);
                                                         
        pageRef.setRedirect(true);
        return pageRef;
    }                          
}