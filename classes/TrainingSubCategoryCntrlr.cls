/*
  Author: Ariz Solito
  Description: Controller class for TrainingSubCategoryCntrlr
  History:
    ASolito         02162015    - code creation.
*/
public class TrainingSubCategoryCntrlr  {
    public static final Integer PAGE_SIZE = UtilsString.isNotBlank(EnvironmentVariable.get('TRAINING_COMMUNITY_LIST_SIZE')) ?
                                            Integer.valueOf(EnvironmentVariable.get('TRAINING_COMMUNITY_LIST_SIZE')) :
                                            5;
                                            
    public String mainCategory {get; set;}
    public ArticleList articleList {get; set;}
    public TopCategoryList categoryTreeMenu {get; set;}
    public String selectedArticle {get; set;}
    public String selectedArticleVideo {get; set;}
    public String selectedArticleId {get; set;}
    public List<String> categoryTree {get; set;}    
    public Integer currPage {get; set;}


    public TrainingSubCategoryCntrlr(){
        this.mainCategory = ApexPages.currentPage().getParameters().get('category');                           
        this.categoryTree = new List<String>();
        this.articleList = new ArticleList(this.mainCategory);
        this.currPage = this.articleList.currPage;        
        this.categoryTreeMenu = new TopCategoryList();                                                             
    }
    
    //Method will redirect to the next page
    public PageReference getPage(){
        system.debug(this.currPage);
        this.articleList.getPage(this.currPage);
        return null;    
    }
    
    //Method will redirect to the main Tile menu
    public PageReference redirectToTileMenu(){                                      
        PageReference pageRef = new PageReference('/training/apex/TrainingCommunityLanding');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    //Method will redirect to the selected category
    public PageReference selectCategory(){
        PageReference pageRef = new PageReference('/apex/TrainingSubCategory');
        pageRef.getParameters().put('category',this.mainCategory);   
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    //Method will open the selected article in a new page
    public PageReference openArticle(){
        PageReference pageRef;
        
        //show video VF            
        if(UtilsString.isNotBlank(this.selectedArticleVideo)){
            pageRef = new PageReference('/apex/VideoArticle?id='+this.selectedArticleId);                    
        //show standard article detail
        } else {            
            pageRef = new PageReference('/articles/Employee_Training/'+this.selectedArticle);
        }
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    //Wrapper class for generating the left side Category menu 
    public class TopCategoryList {
        public List<TopCategory> topCategories {get; set;}
        
        public TopCategoryList(){
            this.topCategories  = new List<TopCategory>();
            List <DataCategoryGroupSobjectTypePair> pairs = new List<DataCategoryGroupSobjectTypePair>();
            
            //get the categories from the New Employee Training and Product and Services (training videos)            
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
            
            Set<String> accessCategories = new Set<String>(); 
            for(Schema.DescribeDataCategoryGroupStructureResult r: results){
                //if All access has been given to Product and Service category
                //set the label to Training Videos
                /*if(r.getName() == 'Products_and_Services'){
                    for(Schema.DataCategory d :r.getTopCategories()){
                        if(d.getLabel().contains('All')){
                            accessCategories.add('Training Videos');    
                        } else {
                            accessCategories.add(d.getLabel());    
                        }
                    }
                } else {
                    for(Schema.DataCategory d :r.getTopCategories()){
                        accessCategories.add(d.getLabel());    
                    }
                }*/
                
                for(Schema.DataCategory d :r.getTopCategories()){
                    accessCategories.add(d.getLabel());
                                       
                    for(Schema.DataCategory e: d.getChildCategories()){
                        System.debug(d.getLabel()+' '+e.getLabel());
                        accessCategories.add(e.getLabel());        
                    }               
                }
            }                        
            
            //Map the visibles categories to the parent_employee_training__c navigation object
            for(EmployeeTraining__c e: [SELECT name,parent_icon__c 
                                          FROM EmployeeTraining__c
                                          WHERE parent_employee_training__c = null
                                          ORDER by order__c]){
                if(accessCategories.size() > 0){
                    //profiles with access to All categories
                    if(accessCategories.contains('All')){
                        this.topCategories.add(new TopCategory(e));
                    //profiles with restricted access
                    } else {
                        this.topCategories.add(new TopCategory(e,accessCategories));
                    }
                }                                       
            }              
        }
    }    
    
     //Wrapper class for the article list
    public class ArticleList {
        public List<ArticleWrapper> articleList {get; set;}
        public List<ArticleWrapper> currPageList {get; set;}        
        public List<Integer> pages {get; set;}
        public Map<Integer,List<ArticleWrapper>> pagesMap {get; set;}
        public Integer currPage;
        private String category;
        private Map<Id,ArticleWrapper> articleMap;
    
        public ArticleList(String currCategory){            
            this.pages = new List<Integer>();            
            this.category = currCategory;
            this.articleList = new List<ArticleWrapper>(); 
            this.currPageList = new List<ArticleWrapper>(); 
            this.articleMap = new Map<Id,ArticleWrapper>();                                    
                                               
            String category = this.category.replace(' ','_').replace('&','').replace('__','_') + '__c';                    
            Set<String> articleID = new Set<String>();   
                   
            if(this.category == 'Training Videos'){                
                String query = 'SELECT id,title,summary,urlName,video__c,knowledgeArticleId,lastPublishedDate '+
                               '  FROM Training_Video__kav '+
                               '  WHERE publishstatus = \'Online\' '+
                               '  AND language =\'en_US\' '+
                               '  WITH DATA CATEGORY Products_and_Services__c AT '+ category +
                               '  ORDER BY sort_order__c,title ';  
                
                List<Training_Video__kav> trainings = Database.query(query); 
                
                for(Training_Video__kav e: trainings){
                    ArticleWrapper temp = new ArticleWrapper(e);
                    this.articleList.add(temp);
                    this.articleMap.put(e.knowledgeArticleId,temp); 
                    articleID.add(e.knowledgeArticleId);
                }
                                                                      
            } else {                                                                                  
                String query  = 'SELECT id,title,summary,urlName,knowledgeArticleId,lastPublishedDate '+
                                '  FROM Product_Collateral__kav'+
                                '  WHERE publishstatus = \'Online\' '+
                                '  AND language =\'en_US\' '+
                                '  WITH DATA CATEGORY New_Employee_Training__c AT '+ category +
                                '  ORDER BY sort_order__c,title ';
                                
                String query2  = 'SELECT id,title,summary,urlName,knowledgeArticleId,lastPublishedDate '+
                                 '  FROM Employee_Training__kav'+
                                 '  WHERE publishstatus = \'Online\' '+
                                 '  AND language =\'en_US\' '+
                                 '  WITH DATA CATEGORY New_Employee_Training__c AT '+ category +
                                 '  ORDER BY sort_order__c,title ';  
                                 
                List<Product_Collateral__kav> products = Database.query(query);  
                
                for(Product_Collateral__kav k: products){                    
                    ArticleWrapper temp = new ArticleWrapper(k);
                    this.articleList.add(temp);
                    this.articleMap.put(k.knowledgeArticleId,temp); 
                    articleID.add(k.knowledgeArticleId);              
                } 
                
                List<Employee_Training__kav> trainings = Database.query(query2);  
                
                for(Employee_Training__kav k: trainings){                    
                    ArticleWrapper temp = new ArticleWrapper(k);
                    this.articleList.add(temp);
                    this.articleMap.put(k.knowledgeArticleId,temp); 
                    articleID.add(k.knowledgeArticleId);              
                }                                                                        
            }                                
            
            for(KnowledgeArticle k: [SELECT id,
                                            (SELECT id,viewCount,normalizedScore
                                               FROM ViewStats)
                                       FROM KnowledgeArticle 
                                       WHERE id IN :articleID]){
                for(KnowledgeArticleViewStat v: k.viewStats){
                    if(this.articleMap.containsKey(k.id)){
                        if(this.articleMap.get(k.id).viewCount < v.viewCount){
                            this.articleMap.get(k.id).viewCount = v.viewCount;  
                        }   
                    }  
                }                                       
            }
            
            paginate();
            
            //set to page 1
            if(this.pagesMap.size() > 0){
                getPage(1);  
            }
        }
        
        public void getPage(Integer currPage){
            this.currPage = currPage;
            this.currPageList = this.pagesMap.get(currPage);
            
        }
        
        public void paginate(){            
            Integer pageCount = 1;
            Integer counter = 1;
            this.pagesMap = new Map<Integer,List<ArticleWrapper>>();
            this.pages = new List<Integer>();                       
            
            for(Integer count = 0; count < this.articleList.size(); count++){
                if(counter < PAGE_SIZE ){                                            
                    if(this.pagesMap.containsKey(pageCount)){
                        this.pagesMap.get(pageCount).add(this.articleList[count]);                                                
                    } else {
                        this.pagesMap.put(pageCount, new list<ArticleWrapper>{this.articleList[count]});
                    }                                                
                    
                    //last page
                    if(count == this.articleList.size()-1){
                        this.pages.add(pageCount);
                    }
                    counter++;
                } else {
                    this.pagesMap.get(pageCount).add(this.articleList[count]);                   
                    this.pages.add(pageCount);                    
                    pageCount++;
                    counter = 1;
                }                
            }                      
        }                                                                                                                         
    } 
    
    public class ArticleWrapper {
        public String urlName {get; set;}
        public String articleID {get; set;}
        public String title {get; set;}
        public Date lastPublishedDate {get; set;} 
        public String summary {get; set;}  
        public String videoID {get; set;} 
        public Integer viewCount {get; set;}    
        
        public ArticleWrapper(Training_Video__kav e){
            this.urlName = e.urlName;
            this.articleID = e.knowledgeArticleId;
            this.title = e.title;
            this.lastPublishedDate = Date.valueOf(e.lastPublishedDate);
            this.summary = e.summary;
            this.viewCount = 0;
            this.videoID = e.video__c;
                                
        }
        
        public ArticleWrapper(Product_Collateral__kav f){
            this.urlName = f.urlName;
            this.articleID = f.knowledgeArticleId;
            this.title = f.title;
            this.lastPublishedDate = Date.valueOf(f.lastPublishedDate);
            this.summary = f.summary;
            this.viewCount = 0;            
        } 
        
        public ArticleWrapper(Employee_Training__kav f){
            this.urlName = f.urlName;
            this.articleID = f.knowledgeArticleId;
            this.title = f.title;
            this.lastPublishedDate = Date.valueOf(f.lastPublishedDate);
            this.summary = f.summary;
            this.viewCount = 0;            
        }                     
    }      
    
    //Wrapper class for theh side Category Menu
    public class TopCategory {
        public String name {get; set;}
        public String icon {get; set;}
        public Boolean hasAccess {get; set;}
        
        //For profiles with visibility restrictions
        public TopCategory(EmployeeTraining__c e,Set<String> accessTiles){
            this.name = e.name;
            this.icon = e.parent_icon__c;
            this.hasAccess = accessTiles.contains(this.name);
        }
        
        //For profiles with visibility to All data category
        public TopCategory(EmployeeTraining__c e){
            this.name = e.name;
            this.icon = e.parent_icon__c;
            this.hasAccess = true;
        }
    }     
}