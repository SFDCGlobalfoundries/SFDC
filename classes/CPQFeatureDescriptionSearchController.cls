/**************************************************************
 Class:          CPQFeatureDescriptionSearchController
 -------------------------------------------------------------------------------------------------------------------------------------
 Author:        Amrita Agarwala
 Created Date:  10/17/2016
 Reason:        Controller for feature Description search utility. 
 
 Kanishk Singh:Case#00076421:allow serach in comma separated values(Product Description) 

***************************************************************/
public class CPQFeatureDescriptionSearchController {
      
    public String xmlstring{get;set;}
    public String selectedPT{get;set;}
    public String selectedGeometry{get;set;}
    public String PTName{get;set;}
    string prevPT{get;set;}
    public String bundleProductName{get;set;}
    public List<SelectOption> items{public get;private set;}
    public List<SelectOption> geometries{public get;private set;}

    public String rootElement1{get;set;}
    public  String filename{get;set;}
   
    public transient  blob body{get;set;}
    public String modelNameInput{get;set;}    
    
    public List<pProduct2> searchResult{get;set;}
    public List<pProduct2> selectedSearchResults{get;set;}
    public List<pProduct2> paginationSearchResults{get;set;}
    public boolean renderResultTable{get;set;}
    public boolean disablePT{get;set;}
    public boolean renderExportData{get;set;}
    public boolean selectAllcheckbox{get;set;}
    string originalInputString{get;set;}
        
    
    //variables for pagination
    integer totalRecs = 0;
    integer count= 0;
    integer LimitSize= 20;
    private Set<String> ptNames;
    
          
    //constructor
    public CPQFeatureDescriptionSearchController()
    {           
        searchResult = new List<pProduct2>() ;
        paginationSearchResults = new List<pProduct2>() ;
        selectedSearchResults = new List<pProduct2>() ;
        renderExportData = false;
        disablePT = true;
        geometries = getGeometries();
        this.ptNames = new Set<String>();
       
    }
    
    //code for pagination starts here
    public void Firstbtn() {
        onPageChange();
        count=0;
        getRecords(count);
          
        
    }
      public void prevbtn() {
         onPageChange();
         count=count-limitsize;
         getRecords(count);  
          
    }
   
     public void nextbtn() {
          onPageChange();
          count = count + limitsize;  
          getRecords(count);
            
         
     }
     public void lastbtn() {
         onPageChange(); 
         count = totalrecs - math.mod(totalRecs,LimitSize);
         getRecords(count);
          
     }
     
     private void getRecords(integer count){
           paginationSearchResults.clear();   
           
           for(integer i = count; i< count + limitSize; i++ ){
              
                if(i<searchResult.size()){
                    pProduct2 p = new pProduct2(searchResult[i].p);
                    p.isSelected = searchResult[i].isSelected;
                    paginationSearchResults.add(p);
                }
                       
           }
     
     }
     
    
      public void onPageChange(){
                       
            for(pProduct2 prod1 : paginationSearchResults){
                  for(pProduct2 prod : searchResult){
                      if(prod.p.ProductCode  == prod1.p.ProductCode){ 
                                         
                         prod.isSelected = prod1.isSelected;
                      }
                      
                   }
             }     
     }

    public Boolean getnext() {
     
        if((count + LimitSize) < totalRecs )
               return false;
         else
           return true;
        
    }
    public Boolean getprev() {
          if(count== 0)
              return true;
            else
              return false;
    }
    
  
   //pagination code ends
     public void getSearchResult(){
            
      if(!String.isBlank(filename)){
           Parsexmlfile();
       }
       else  if(!String.isBlank(modelNameInput )){
           getResultForInputText();       
       } else {
          List<string> param = new List<string>();
          getDescription (param );
       }
        
   }
   
//This is for parsing xml file what you selected
  public void Parsexmlfile()
  {    
       searchResult.clear();
       DOM.Document xmlDocument = new DOM.Document();
       xmlstring = body.tostring();   
               
       xmlDocument.load(xmlstring);
       DOM.XMLNode rootElement = xmlDocument.getRootElement();
      
       rootElement1 = rootElement.getName();
       for(DOM.XMLNode xmlnodeobj: xmlDocument.getRootElement().getChildElements())
       {        
          loadChilds(xmlnodeobj); 
       }      
      
    } 
      //loading the child elements
    public void loadChilds(DOM.XMLNode xmlnode)
    {        
       List<String> paramList = new List<string>();
        
        String param = ''; 
        
        for(Dom.XMLNode child : xmlnode.getChildElements())
        {
            
          if(child.getText()!= null)
          {
              param = child.getText();
              paramList.add(param);
                     
          }               
                
        }
        getDescription (paramList);
       
    }
    
     public void getResultForInputText(){
        List<String> modelNameList = new List<String>();
        modelNameList.add(modelNameInput);
        //boolean flag = false;
        
        if(prevPT != selectedPT){
                 getDescription(modelNameList);   
        }else {           
                 getDescription(modelNameList); 
        }
        
            
     }
  
  private string getBaseQuery(boolean isFileUploaded, boolean isInputTextFound, boolean isBundleProductName) {

    String strQuery = 'SELECT Description, Name, ProductCode FROM Product2 ';

    if (isBundleProductName) {
        strQuery = strQuery + ' where ProductCode = :processTech and family Like \'PT%\' limit 1';
    } else {
        if (isInputTextFound) {
            if (isFileUploaded) {
                strQuery = strQuery + ' where ProductCode like :processTech ';
            } else {
                strQuery = strQuery + ' where description LIKE :paramString and ProductCode like :processTech ';
            }

        } else {
            strQuery = strQuery + ' where ProductCode like :processTech and family = \'Devices\'';
        }
    }

    return strQuery;
}
  
  private List<Product2> getQueryResult(boolean isFileUploaded,boolean isInputTextFound,boolean isBundleProductName,string processTech,string paramString ){
     return database.query(getBaseQuery(isFileUploaded,isInputTextFound,isBundleProductName));
  }
    //Method to query description
    public PageReference getDescription(List<string> param){
        PTName = selectedPT;
        selectAllcheckbox = false;
        
        string strMessage=(Environment_Variable__c.getInstance('XMLSearchMessage'))!=null?String.valueOf(Environment_Variable__c.getInstance('XMLSearchMessage').value__c)
        :'This model name is not exist in related process technology.';
        
        if(prevPT != selectedPT){
           searchResult.clear();  
           selectAllcheckbox = false;      
           paginationSearchResults.clear();
           totalRecs = count = 0;
         
        }
       
        List<Product2> res = new List<Product2>() ;
        List<pProduct2> tempList= new List<pProduct2>() ;
        
       
        
        try{
                //Query to get search result 
                 string tempPT = '%'+ selectedPT + '%';
                 if(param.Size()>0){  
                 
                    if(!String.isBlank(fileName) ){//search for xml file input
                         Map<String,String> mapDeviceName=new Map<String,String>();
                          for (String str: param) {
                               mapDeviceName.put(str.toLowerCase(), str);
                           }
                        
                           //for (Product2 obj: [SELECT Description, Name, ProductCode FROM Product2 where ProductCode like: tempPT]) 
                             for (Product2 obj: getQueryResult(true,true,false,tempPT,null)) {
                              setModelDescription(obj,mapDeviceName,res);
                           }
                  
                   } else {  //search for input text
                                     originalInputString = param[0];
                         if (modelNameInput.length()>1){//allow minimum 2 characters in search string
                           string paramString ;
                           //special character handling 
                           if(param[0].contains('\\')){
                       
                                param[0] = param[0].replace('\\', '\\\\');
                                paramString = '%' + param[0] + '%';                           
                              
                           }
                           if(param[0].contains('_')){
                                param[0] = param[0].replace('_', '\\_');
                                paramString = '%' + param[0] + '%';                           
                              
                           }if(param[0].contains('%')){
                                param[0] = param[0].replace('%', '\\%');
                                paramString = '%' + param[0] + '%';                           
                              
                           }else
                               paramString = '%' + param[0] + '%';
                           
                     
                           // res = [SELECT Description , Name, ProductCode  FROM Product2 where description LIKE :paramString and ProductCode like :tempPT ];
                          res = getQueryResult(false,true,false,tempPT,paramString);
                         }else{
                           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please provide atleast 2 characters.')); 
                           return null;
                         }
                   }                    
                 
                 }else{ // For no input search all results 
                
                  //res = [SELECT Description , Name, ProductCode  FROM Product2 where ProductCode like :tempPT and family = 'Devices'];
                    res = getQueryResult(false,false,false,tempPT,null);
                 }
                 
                 List<Product2> lstProductName=getQueryResult(false,false,true,tempPT,null);
                 if(lstProductName!=null && lstProductName.size()>0){
                    bundleProductName=lstProductName.get(0).Name;
                 }
                  /*Product2 result2 = [SELECT Name FROM Product2 where ProductCode = :selectedPT and family Like 'PT%' limit 1];
                  bundleProductName = result2.Name;*/
                 
                  if(!res.isEmpty()) { 
                       renderExportData = true;
                       selectAllcheckbox = false; 
                       for(Product2 prod : res ){
                           boolean flag = false ;
                           pProduct2 temp = new pProduct2 (prod);
                           //search for duplicates in searchResult
                           for(pProduct2 prod1 : searchResult ){
                               if(prod1.p.Description==prod.Description){ 
                                     flag = true; break;}
                               
                           }
                           
                           if(flag == false)
                                tempList.add(temp);
                       }
                      
                      if(tempList.size() == 0){
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This model name(s) already exists in search result.')); 
                           return null;
                          
                      }else {
                          tempList.addall(searchResult);  
                          renderResultTable = true;                     
                  
                      }
                     
                  }
                 
                    for(String temp : param){
                              boolean found  = false;
                              for(pProduct2 tempProduct : tempList){ 
                                 if(String.isBlank(filename)){ 
                                     
                                     string description = tempProduct.p.description ;
                                     if(description.containsIgnoreCase(originalInputString)){                                      
                                           found = true;                                           
                                      }   
                                 }else{
                                  
                                      if(tempProduct.p.description == temp){
                                           found = true;
                                      } 
                                 
                                 }
                                 
                              }
                              if(found == false){
                                    
                                     if(String.isBlank(filename)){
                                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no such model name exists.'));
                                          tempList.addAll(searchResult);
                                     }else{
                                             product2 prod = new product2 ();
                                             prod.Description = temp;
                                             prod.Name = ''+strMessage;
                                             pProduct2 tempValue = new pProduct2(prod);
                                            
                                             tempList.add(tempValue);
                                     
                                     }
                              
                              }
                  }                             
                                                  
                  searchResult  = tempList;
            
                  totalRecs = searchResult.size();                 
                  count=0;
                  getRecords(count);
                                                            
                  fileName = ''; prevPT = selectedPT;
                
                 return null;
             }catch(exception e){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueof(e)));
                 return null;
          }
    
    }
    
    
    
    private void setModelDescription(Product2 obj,Map<String,String> mapDeviceName,List<Product2> res){
        //Kanishk: allow serach in comma separated values
       if (obj.Description != null) {
         integer index=0;
         for (String strDesc: obj.Description.split(',')) {
               if (mapDeviceName.get(strDesc.toLowerCase().Trim()) != null) {
                  if(index>0){
                     Product2   objClone=obj.clone(true, true, false, false);
                     objClone.Description=strDesc.Trim();
                     res.add(objClone);
                  }else{
                   obj.Description=strDesc.Trim();
                   res.add(obj);
                  }
                  
                  mapDeviceName.remove(strDesc.toLowerCase().Trim());
                  
                  index++;
               }
           }
       }
    }
    
     public List<SelectOption> getGeometries() { 
   
      
        List<AggregateResult> res = new List<AggregateResult>() ;
        try{
         
               //Query to get search result                 
                 res = [SELECT  geometry__c geometry FROM Product2 where family Like 'PT%' and PT_Number__c !=null GROUP BY geometry__c limit 999 ];
                 if(!res.isEmpty()) {                           
                         
                         List<SelectOption> options = new List<SelectOption>();
                         options.add(new SelectOption('NA', '-----Select---'));
                         for(AggregateResult item : res){
                           String temp = String.valueOf(item.get('geometry'));
                           options.add(new SelectOption(temp, temp));
                         }
                         
                           
                      
                        return options;       
                    
                 }else{
                
                    return null;
                 }
               
              
             }catch(exception e){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueof(e)));
                 return null;
             }            
    
    }

    public PageReference onSelectedGeometry(){
   
      disablePT = false;
      List<Product2> res = new List<Product2>() ;
      items = new List<SelectOption>();
        try{
         
               //Query to get search result                 
                 res = [SELECT Name,PT_Number__c, ProductCode FROM Product2 where family Like 'PT%' and PT_Number__c !=null and geometry__c = :selectedGeometry limit 999 ];
                 if(!res.isEmpty()) { 
                         for(Product2 item : res){                        
                           items.add(new SelectOption(item.ProductCode , item.Name));
                         }
                                
                    return null;
                 }else {
                    return null;
                 }               
              
             }catch(exception e){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueof(e)));
                return null;
             }   
             return null;         
    }
    
   public List<SelectOption> getItems() { 
     
       return items;  
    }
      
  
     
     public void clearData(){
     
         searchResult.clear();
         selectAllcheckbox = false;
         fileName = null;
         xmlstring = null;
         paginationSearchResults.clear();
         totalRecs = count = 0;
         modelNameInput = '';
     
     }
    
     public PageReference generatePDF(){
            onPageChange();
     
            for(pProduct2 prod : searchResult){
                      if(prod.isSelected  == true){                    
                         selectedSearchResults.add(prod);
                      }
                      
                   }
            
            String urlVal = Apexpages.currentPage().getUrl();
            
            if(urlVal.contains('GlobalfoundryView')){
               PageReference page = new PageReference ('/GlobalfoundryView/apex/CPQFeatureDescriptionSearchPDFPage');
               page.setRedirect(false);
                return page ;
            }else{
               PageReference page = new PageReference ('/apex/CPQFeatureDescriptionSearchPDFPage');
               page.setRedirect(false);
                return page ;
            }
             return null;
        
                       
        }  
        public void selectall(){
        
                  for(pProduct2 prod : searchResult){ 
                            if(selectAllcheckbox){
                                 prod.isSelected = true; 
                            } else{
                                  prod.isSelected = false; 
                            }                                       
                         
                   }
                 
        }
         
     //wrapper class  
      public class pProduct2{  
      
         //custom wrapper datatype  
          public product2 p{get;set;}  
          public boolean isSelected{get;set;}
         
          public pProduct2(Product2 prod){
         
             p=prod;
             isselected=false;
           }
    
    }       
}