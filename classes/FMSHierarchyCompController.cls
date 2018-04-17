/*
*Change History
* 6-Jan-2017   Anil Kumar Reddy L  Modified code to validate parent form.
   06/28/2017      RRai    Modified the code to remove hardcoding.  
*

* 13-Jul-2017   Wrote complete code for form hierarchy 
*
*FMSHierarchyCtrl : controller for fms hierarchy component
* Represents fms forms in structured manner  
*
* Issues fixed - 275,278,318,357,359,360,,361,387
*/
public class FMSHierarchyCompController{
  map<String,Form_Management_System__c> mpAllFormsInHierarchy = new map<String,Form_Management_System__c>();
  public list<Form_Management_System__c> lstFMSQuery{get;set;}
  public list<Form_Management_System__c> lstFMSHierarchy;
  public map<String,list<Form_Management_System__c>> mpParentChildLst{get;set;} 
  public String formObjId{get;set;}
  public transient  Form_Management_System__c fmsTestObj{get;set;}
  public String copyFormParentId{get;set;}
  
  // list of form ids we are gng to use in copyform controller to display 
  // correct sequence of parents in the dropdown list ,as we are already preparing the corrent sequence here
  public static list<String> lstStringFormIds = new list<String>();
  
  public map<String,list<Integer>> mpFormIdDistanceFromMain{get;set;}
  public map<String,Integer> mpFormIdDistance{get;set;}
  public map<String,Boolean> mpFormIdIsLastNode{get;set;}
  public map<String,Boolean> mpFormIdHasChild{get;set;}
  public map<String,String> mpFormIdURL{get;set;}
  
  public final static String FMS_IMC_FORM = EnvironmentVariable.get('FMS_IMC_FORM'); 
  public final static String FMS_RIT_FORM = EnvironmentVariable.get('FMS_RIT_FORM'); 
  public final static String FMS_DDR_FORM = EnvironmentVariable.get('FMS_DDR_FORM'); 
  public final static String FMS_MAIN_FORM = EnvironmentVariable.get('FMS_MAIN_FORM');
  public final static String FMS_SP_FORM = EnvironmentVariable.get('FMS_SP_FORM'); 
  
  public boolean inCopyPage{get;set;}
  //Construtor
  public FMSHierarchyCompController() {
    copyOrAddendum = false;
    copyFormParentId = NULL;
    inCopyPage = false;
    mpFormIdformattedDates = new map<String,string>();
    String currentUrl = URL.getCurrentRequestUrl().toExternalForm();
    if(currentUrl.containsIgnoreCase('FMSCopyForms')){inCopyPage=true;}
    mpFormIdParentFormId = new map<String,map<integer,boolean>> ();
  }
  //Populates and returns list of forms to be represented in hierarchy
  public List<Form_Management_System__c> getlstFMSHierarchy(){             
        if(formObjId == null) {
           formObjId = System.currentPageReference().getParameters().get( 'id' );
        }  
        if(formObjId == null) {
          formObjId = System.currentPageReference().getParameters().get( 'ParentId' );
        }
        createAndPopulateData();        
        return lstFMSHierarchy;
    }
    
  public Boolean copyOrAddendum{get;set;}
  public String currentFormType{get;set;}
  //Populates the list to be displayed in the page
  public void createAndPopulateData() {
    String mainFormId;
    List<Form_Management_System__c> formObjList = [SELECT id,Latest_Step_Plan__r.State_of_the_Form__c,Latest_Step_Plan__r.lastmodifieddate, name, Form_Name__c, Parent_Form_Id__c,Parent_Form_Id__r.Parent_Form_Id__c,Parent_Form_Id__r.Parent_Form_Id__r.Parent_Form_Id__c,Parent_Form_Id__r.Parent_Form_Id__r.Parent_Form_Id__r.Parent_Form_Id__c, Main_Form_Id__c, State_of_the_Form__c, Form_Type__c, UniqueWebRDTSId__c, CreatedDate, LastModifiedDate FROM Form_Management_System__c WHERE id = :formObjId]; 
    if(!formObjList.isEmpty()){
      currentFormType = formObjList[0].Form_Type__c;
       if(formObjList[0].Main_Form_Id__c == null){
            mainFormId = formObjList[0].id;
        }else if(formObjList[0].Main_Form_Id__c != null){
            mainFormId = formObjList[0].Main_Form_Id__c;
        }
    }
    
    mpParentChildLst = new map<String,list<Form_Management_System__c>>();
    mpFormIdHasChild = new map<String,Boolean>();
    mpFormIdDistance  = new map<String,Integer>();
    mpFormIdIsLastNode = new map<String,Boolean>();
    mpFormIdURL = new map<String,String>();
    lstFMSQuery = [SELECT id,Latest_Step_Plan__r.State_of_the_Form__c,Latest_Step_Plan__r.lastmodifieddate, name, Form_Name__c, Parent_Form_Id__c,Parent_Form_Id__r.Parent_Form_Id__c,Parent_Form_Id__r.Parent_Form_Id__r.Parent_Form_Id__c,Parent_Form_Id__r.Parent_Form_Id__r.Parent_Form_Id__r.Parent_Form_Id__c, Main_Form_Id__c, State_of_the_Form__c, Form_Type__c, UniqueWebRDTSId__c, CreatedDate, LastModifiedDate 
                                       FROM Form_Management_System__c 
                                       WHERE Id =:mainFormId OR Main_Form_Id__c =:mainFormId order by name asc];
    
    Boolean isSPFormAdded = false;  
    list<Form_Management_System__c> lstFMS = new  list<Form_Management_System__c>();
    for(Form_Management_System__c fm : lstFMSQuery) {
      //if 1st steplan is already added to the hierarchy representation then ignore rest of the others
      if(fm.Form_Type__c == 'Step Plan Approval (SP)') {
        if(isSPFormAdded) {
          continue;  
        }
        else {
          isSPFormAdded = true;
        }        
      }      
      if(fm.Form_Type__c != 'Main Product Definition Form') {
        if(fm.Parent_Form_Id__c == NULL) {
          fm.Parent_Form_Id__c = mainFormId;
        }
        if(fm.Main_Form_Id__c == NULL) {
          fm.Main_Form_Id__c = mainFormId;
        }
      } 
      lstFMS.add(fm);
    }
    
    map<String,Form_Management_System__c> mpExstingFMS = new map<String,Form_Management_System__c>(lstFMS);
    // Logic to add copy form to the list
    Schema.DescribeSObjectResult r = Form_Management_System__c.sObjectType.getDescribe();
    String keyPrefix = r.getKeyPrefix();
    if(fmsTestObj != NULL && fmsTestObj.Parent_Form_Id__c !=NULL ) {  
      if(fmsTestObj.id==NULL || mpExstingFMS.containsKey(fmsTestObj.id)) {        
        // Not a hard coded id, its a dummy id , as copy form we are about to show in the hierarchy does not have any id and hierarchy works on ids
        fmsTestObj.id = keyPrefix+'00000000000COPY';  
        fmsTestObj.Main_Form_Id__c = mainFormId;
        if(!fmsTestObj.Form_Name__c.containsIgnoreCase('Copy of ')){
          fmsTestObj.Form_Name__c = 'Copy of '+ fmsTestObj.Form_Name__c;
        }
        copyFormParentId = fmsTestObj.Parent_Form_Id__c;
        copyOrAddendum = true;
      }
      fmsTestObj.State_of_the_Form__c = NULL;
      lstFMS.add(fmsTestObj);
    }
    else {
      String tranx = ApexPages.currentPage().getParameters().get('tranx');
      String parentId = ApexPages.currentPage().getParameters().get('ParentId');
      String formType = ApexPages.currentPage().getParameters().get('Type');  
      String cloneId = ApexPages.currentPage().getParameters().get('id');  
      if(String.isNotBLANK(cloneId)) {
        Form_Management_System__c copyFrom =  [SELECT id,Latest_Step_Plan__r.State_of_the_Form__c,Latest_Step_Plan__r.lastmodifieddate, name, Form_Name__c,  Parent_Form_Id__c,Parent_Form_Id__r.Parent_Form_Id__c,Parent_Form_Id__r.Parent_Form_Id__r.Parent_Form_Id__c,Parent_Form_Id__r.Parent_Form_Id__r.Parent_Form_Id__r.Parent_Form_Id__c, Main_Form_Id__c, State_of_the_Form__c, Form_Type__c, UniqueWebRDTSId__c, CreatedDate, LastModifiedDate 
                                       FROM Form_Management_System__c 
                                       WHERE Id =:cloneId];
        Form_Management_System__c copyObj = copyFrom.clone(true, true, false, false);
        if(String.isNotBLANK(tranx) && String.isNotBLANK(parentId) && String.isNotBLANK(formType) && tranx == 'Copy') {
          copyObj.Main_Form_Id__c = mainFormId;
          // Not a hard coded id, its a dummy id , as copy form we are about to show in the hierarchy does not have any id and hierarchy works on ids
          copyObj.id = keyPrefix+'00000000000COPY';
          if(!copyObj.Form_Name__c.containsIgnoreCase('Copy of ')){
            copyObj.Form_Name__c = 'Copy of '+ copyObj.Form_Name__c;
          }
          copyObj.Parent_Form_Id__c = parentId;
          copyFormParentId = parentId;
          copyOrAddendum = true;
          lstFMS.add(copyObj);
        }                               
      } 
    }
    String tranx = ApexPages.currentPage().getParameters().get('tranx');
    String parentId = ApexPages.currentPage().getParameters().get('ParentId');
    String formType = ApexPages.currentPage().getParameters().get('Type');
    if(String.isNotBLANK(tranx) && String.isNotBLANK(parentId) && String.isNotBLANK(formType) && tranx == 'Create') {
      Form_Management_System__c addendumObj = new Form_Management_System__c(Parent_Form_Id__c =parentId );
      list<Form_Management_System__c> lstParent = [SELECT id,Latest_Step_Plan__r.State_of_the_Form__c,Latest_Step_Plan__r.lastmodifieddate, name, Form_Name__c, Parent_Form_Id__c,Parent_Form_Id__r.Parent_Form_Id__c,Parent_Form_Id__r.Parent_Form_Id__r.Parent_Form_Id__c,Parent_Form_Id__r.Parent_Form_Id__r.Parent_Form_Id__r.Parent_Form_Id__c, Main_Form_Id__c, State_of_the_Form__c, Form_Type__c, UniqueWebRDTSId__c, CreatedDate, LastModifiedDate from Form_Management_System__c where id = :parentId ];
      if(!lstParent.isEmpty()) {
        addendumObj.Main_Form_Id__c  = lstParent[0].Main_Form_Id__c;         
      }
      addendumObj.Form_Name__c = '>> New Addendum Here <<';
      // Not a hard coded id, its a dummy id , as addendum form we are about to show in the hierarchy does not have any id and hierarchy works on ids
      addendumObj.id = keyPrefix+'00000000000COPY';
      copyOrAddendum = true;
      lstFMS.add(addendumObj);
    }
    
    //Store parent and all its children                              
    mpAllFormsInHierarchy = new map<String,Form_Management_System__c>(lstFMS);                                   
    for(Form_Management_System__c fms : lstFMS) {
      if(!mpParentChildLst.containsKey(fms.Parent_Form_Id__c)) {
        mpParentChildLst.put(fms.Parent_Form_Id__c,new list<Form_Management_System__c>());
      }
      mpParentChildLst.get(fms.Parent_Form_Id__c).add(fms);
    }
    
    mpFormIdDistanceFromMain = new map<String,list<Integer>>();
    // Store level of each form from main form
    for(Form_Management_System__c fms : lstFMS) {
      Integer distance = distanceFromMainForm(fms);
      mpFormIdDistance.put(fms.Id,distance);
      list<Integer> lstTemp = new list<Integer>();
      for(Integer i=0;i<distance;i++) {
        lstTemp.add(i);
      }
      mpFormIdDistanceFromMain.put(fms.Id,lstTemp);
    }
    
    lstFMSHierarchy = new list<Form_Management_System__c>();
    set<String> alreadyAddedForms = new set<String>();
    
    
    //Primary logic to arrange the list in the proper order to show in hierarchy
    for(Form_Management_System__c fms : lstFMS) {
      if(!alreadyAddedForms.contains(fms.Id)) {
        lstFMSHierarchy.add(fms);       
        alreadyAddedForms.add(fms.Id);
      }
      integer index = lstFMSHierarchy.size()-1;
      if(alreadyAddedForms.contains(fms.Id)) {        
        for(integer i = 0;i<lstFMSHierarchy.size();i++) {
          if(lstFMSHierarchy[i].Id == fms.Id) {
            index=i;
            break;
          }
        }
      }

      if(mpParentChildLst.containsKey(fms.Id)) {
        list<Form_Management_System__c> lstChildLst = mpParentChildLst.get(fms.Id);
        list<Form_Management_System__c> lstTempHierarchy = new list<Form_Management_System__c>();
        
        for(Integer i=0 ;i<=index; i++) { 
          lstTempHierarchy.add(lstFMSHierarchy[i]);
        }
        
        lstTempHierarchy.addAll(lstChildLst);        
        for(Integer i=index+1 ;i<lstFMSHierarchy.size(); i++) {           
          lstTempHierarchy.add(lstFMSHierarchy[i]);
        }
        
        lstFMSHierarchy = lstTempHierarchy;
        for(Form_Management_System__c fms2 : lstFMSHierarchy) {
          alreadyAddedForms.add(fms2.Id);
        }        
      }
    }
    //Store if an element in the hierarchy has child elements 
    //Store if an element is the last node of its parent
    for(Form_Management_System__c fms : lstFMSHierarchy) {
      mpFormIdHasChild.put(fms.Id,false);
      if(mpParentChildLst.containsKey(fms.Id)) {
        mpFormIdHasChild.put(fms.Id,true);
        list<Form_Management_System__c > lstChild = mpParentChildLst.get(fms.Id);
        mpFormIdIsLastNode.put(lstChild[lstChild.size()-1].Id,true);
      }      
    }
    // To assign URL to each member of the map for navigation
    for(Form_Management_System__c fms : lstFMSHierarchy) {
      if(fms.lastmodifieddate != NULL) {
        mpFormIdformattedDates.put(fms.Id,fms.lastmodifieddate.format('MMMMM dd, yyyy hh:mm:ss a z'));
      }
      else {
        mpFormIdformattedDates.put(fms.Id,'');
      }
      if(fms.Form_Type__c == FMS_SP_FORM && fms.Latest_Step_Plan__c != NULL && fms.Latest_Step_Plan__r.lastmodifieddate != NULL) {
        mpFormIdformattedDates.put(fms.Id,fms.Latest_Step_Plan__r.lastmodifieddate.format('MMMMM dd, yyyy hh:mm:ss a z'));
      }
      
      lstStringFormIds.add(fms.id);     
      if(!mpFormIdIsLastNode.containsKey(fms.Id)) {
        mpFormIdIsLastNode.put(fms.Id,false);
      }
      if(fms.Form_Type__c == FMS_MAIN_FORM){
        mpFormIdURL.put(fms.Id,'/apex/FMSmainFormViewPage?id='+(String.valueOf(fms.id).containsIgnoreCase('copy')?fms.Parent_form_id__c:fms.id));
      }else if(fms.Form_Type__c == FMS_RIT_FORM){
        mpFormIdURL.put(fms.Id,'apex/FMSRITFormViewPage?id='+(String.valueOf(fms.id).containsIgnoreCase('copy')?fms.Parent_form_id__c:fms.id));
      }else if(fms.Form_Type__c == FMS_IMC_FORM){
        mpFormIdURL.put(fms.Id,'/apex/FMSIMCFormViewPage?id='+(String.valueOf(fms.id).containsIgnoreCase('copy')?fms.Parent_form_id__c:fms.id));
      }else if(fms.Form_Type__c == FMS_DDR_FORM){
        mpFormIdURL.put(fms.Id,'/apex/FMSDDRFormViewPage?id='+(String.valueOf(fms.id).containsIgnoreCase('copy')?fms.Parent_form_id__c:fms.id));
      }else if(fms.Form_Type__c == FMS_SP_FORM){
        mpFormIdURL.put(fms.Id,'/apex/FMSStepPlanFormView?id='+(String.valueOf(fms.id).containsIgnoreCase('copy')?fms.Parent_form_id__c:fms.id)+'&uniqueid='+fms.UniqueWebRDTSId__c);
      }else if(fms.Form_Type__c == NULL){
        mpFormIdURL.put(fms.Id,'javascript:void(0);');
      }
    } 
    
    try {
    mpChildToTopParent.put(mainFormId ,new list<string>());
    for(String fid : mpChildToTopParent.keySet()) {
      list<String> lstTemp = mpChildToTopParent.get(fid);  
      system.debug('===lstTemp.size()==> ' + lstTemp.size());    
      list<String> lstTempReverse = new list<String>();      
      integer j = 0;
      for(Integer i = lstTemp.size()-1;i>=0;i--) {
        lstTempReverse.add(lstTemp[i]);
      }
      mpChildToTopParent.put(fid,lstTempReverse);
    }
    
    mpChildToTopParent.put(mainFormId ,new list<string>());
    
   
    for(String fid : mpFormIdDistance.keySet()) {
      mpFormIdParentFormId.put(fid,new map<Integer,boolean>()); 
      for(integer i = 0;i<mpFormIdDistance.get(fid);i++) {
        if(Math.Mod(i,4)==0){
           system.debug('====i=>' +i);
           system.debug('====i/4=>' +i/4);
           system.debug('====mpChildToTopParent=>' + mpChildToTopParent.get(fid));
           system.debug('====mpChildToTopParent=>' + (mpChildToTopParent.get(fid)).size());
          String ithParent = i!=0?(mpChildToTopParent.get(fid))[(i/4)]:null;
          if(ithParent!=null && mpFormIdIsLastNode.get(ithParent) ) {
            mpFormIdParentFormId.get(fid).put(i,false);
          }     
          else {
            mpFormIdParentFormId.get(fid).put(i,true);
          }     
        }
        else {
          mpFormIdParentFormId.get(fid).put(i,true);
        }
      }
     
    }
    }catch(exception e){}
    
  }
  public map<String,map<integer,boolean>> mpFormIdParentFormId{get;set;}
  public map<String,string> mpFormIdformattedDates{get;set;}
  public map<string,list<String>> mpChildToTopParent = new map<string,list<String>>();
  // Calculates the level of each form in the hierarchy from the main form
  private Integer distanceFromMainForm(Form_Management_System__c tempFms) {
    string curntId = tempFms.id;
    Boolean reachedMainForm = false;
    Integer distanceFromMain = 0;
    set<string> alreadyAdded = new set<string>();
    system.debug('---curntId > '+ curntId );
    if(mpChildToTopParent.containsKey(curntId) ) {mpChildToTopParent.remove(curntId);}
    While(!reachedMainForm) {
          
      if(tempFms.Parent_Form_Id__c != NULL) {
      
        if(!mpChildToTopParent.containsKey(curntId) && !alreadyAdded.contains(tempFms.Parent_Form_Id__c)) {
          mpChildToTopParent.put(curntId,new list<String>{tempFms.Parent_Form_Id__c});           
          alreadyAdded.add(tempFms.Parent_Form_Id__c);
          system.debug('---parentsss> '+ tempFms.Parent_Form_Id__c);
        }
        else {
          if(!alreadyAdded.contains(tempFms.Parent_Form_Id__c)) {
            mpChildToTopParent.get(curntId).add(tempFms.Parent_Form_Id__c);           
            system.debug('---parentsss> '+ tempFms.Parent_Form_Id__c);
             alreadyAdded.add(tempFms.Parent_Form_Id__c);
          }
        }
        
        distanceFromMain += 4;
        tempFms = mpAllFormsInHierarchy.get(tempFms.Parent_Form_Id__c);        
      }
      if(tempFms.Parent_Form_Id__c == NULL) {
        reachedMainForm = true;
      }
    }    
    system.debug('---> ' + mpChildToTopParent.get(curntId ));
    return distanceFromMain;
  }
}