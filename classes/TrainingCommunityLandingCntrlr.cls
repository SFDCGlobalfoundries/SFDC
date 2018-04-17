/*
  Author: Ariz Solito
  Description: Controller class for TrainingCommunityLanding
  History:
    ASolito         02132015    - code creation.
*/
public class TrainingCommunityLandingCntrlr  {
    public String selectedMainCategory {get; set;}
    public String selectedSubCategory {get; set;}
    public Filter filter {get; set;}       

    public TrainingCommunityLandingCntrlr(){
        this.filter = new Filter();
    }    
                    
    public PageReference redirectToInternalView(){ 
                                     
        PageReference pageRef = new PageReference(Label.Base_URL);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public class Filter {        
        public List<Tile> tiles {get; set;}
        
        public Filter(){
            this.tiles = new List<Tile>();       

            List <DataCategoryGroupSobjectTypePair> pairs = new List<DataCategoryGroupSobjectTypePair>();
            
                        
            DataCategoryGroupSobjectTypePair pair = new DataCategoryGroupSobjectTypePair();
            pair.setSobject('KnowledgeArticleVersion');
            pair.setDataCategoryGroupName('New_Employee_Training');
            
            DataCategoryGroupSobjectTypePair pair2 = new DataCategoryGroupSobjectTypePair();
            pair2.setSobject('KnowledgeArticleVersion');
            pair2.setDataCategoryGroupName('Products_and_Services');
            pairs.add(pair);
            pairs.add(pair2);
            
            List<Schema.DescribeDataCategoryGroupStructureResult>results = 
            Schema.describeDataCategoryGroupStructures(pairs, false);
            
            System.debug(results);
            
            Set<String> accessTiles = new Set<String>(); 
            for(Schema.DescribeDataCategoryGroupStructureResult r: results){
                //if All access has been given to Product and Service category
                //set the label to Training Videos
                /*if(r.getName() == 'Products_and_Services'){
                    for(Schema.DataCategory d :r.getTopCategories()){
                        if(d.getLabel().contains('All')){
                            accessTiles.add('Training Videos');    
                        } else {
                            accessTiles.add(d.getLabel());    
                        }
                    }
                } else {
                    for(Schema.DataCategory d :r.getTopCategories()){
                        accessTiles.add(d.getLabel());    
                    }
                }*/
                
                for(Schema.DataCategory d :r.getTopCategories()){
                    accessTiles.add(d.getLabel());
                                       
                    for(Schema.DataCategory e: d.getChildCategories()){
                        System.debug(d.getLabel()+' '+e.getLabel());
                        accessTiles.add(e.getLabel());        
                    }               
                }
            } 
            
            System.debug(accessTiles);
            
            for(EmployeeTraining__c e: [SELECT name,parent_icon__c 
                                   FROM EmployeeTraining__c
                                   WHERE parent_employee_training__c = null
                                   ORDER by order__c]){
                if(accessTiles.size() > 0){
                    if(accessTiles.contains('All')){
                        this.tiles.add(new Tile(e));
                    } else {
                        this.tiles.add(new Tile(e,accessTiles ));
                    }
                }                                       
            }                                                                                                                                                                                         
        }
                
    }
    
    public class Tile {
        public String name {get; set;}
        public String icon {get; set;}
        public Boolean hasAccess {get; set;}
        
        public Tile(EmployeeTraining__c e,Set<String> accessTiles){
            this.name = e.name;
            this.icon = e.parent_icon__c;
            this.hasAccess = accessTiles.contains(this.name);
        }
        
        //For profiles with visibility to All data category
        public Tile(EmployeeTraining__c e){
            this.name = e.name;
            this.icon = e.parent_icon__c;
            this.hasAccess = true;
        }
    }
}