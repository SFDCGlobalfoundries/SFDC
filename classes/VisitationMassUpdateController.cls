public with sharing class VisitationMassUpdateController {
    
    public list<VisitationWrapper> wrappers {get; set;}
    public boolean allSelected{get;set;}
    public Visitation_Record__c dummyVR {get; set;}
    public String searchST {get; set;}
    public String searchExe {get; set;}
    public String searchStage {get; set;}
    public List<SelectOption> executives {get; set;}
    public List<SelectOption> stages {get; set;}
    private ApexPages.StandardSetController stdSetCtrl {get; set;}
    
    public class VisitationWrapper{
        
        public Visitation_Record__c vstRec {get; set;}
        public boolean isChecked {get; set;}
        public map<string, boolean> displayMap {get; set;}
        public VisitationWrapper(Visitation_Record__c rec, map<string, boolean> mapDsp){
            this.vstRec = rec;
            this.isChecked = false;
            this.displayMap = mapDsp;
            system.debug('running here:' + this);
        }
    }
    
    public VisitationMassUpdateController(){
        
        clearSearch();
    }
    
    
    public void queryVisitation(string whereClause){
        vcslist = new list<Visitation_CS__c>([select name, api_name__c, header_label__c, Editable__c,Visible__c,full_name__c,BackgroundColor__c  from Visitation_CS__c order by name]);
        system.debug(vcslist);
        string qFields = '';
        executives = new list<selectOption>{new selectOption('','---Select---')};
        for(Visitation_CS__c vcs : vcslist){
            qFields = qFields +  vcs.api_name__c + ',' ;
            if(!String.isblank(vcs.full_name__c)){
                executives.add(new selectOption(vcs.full_name__c,vcs.full_name__c));
            }
            
        }
        stages = new list<selectOption>{new selectOption('','---Select---')};
        String stageOptions = Visitation_Setting__c.getValues('STAGE_OPTONS').value__c;
        for(string option : stageOptions.split(',')){
            stages.add(new selectOption(option,option));
        }
        
        String soql = 'Select ' + qFields + 'id from Visitation_Record__c ';
        
        if(whereClause == null) {
            soql = soql + 'where Start_Date__c = NEXT_N_DAYS:60';
        }else {
            soql = soql + whereClause;
        }
        
        system.debug(soql);
        stdSetCtrl = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
        stdSetCtrl.setpageNumber(1);
        String dataLoadNo = Visitation_Setting__c.getValues('VISITATION_DATA_LOAD_NUMBER').value__c;
        stdSetCtrl.setPageSize(Integer.valueOf(dataLoadNo));
        allSelected = false;    
        
        wrappers = new list<VisitationWrapper>();        
        for(Visitation_Record__c rec : (list<Visitation_Record__c>)stdSetCtrl.getRecords()){
            
            map<string,boolean> tempMap = new map<string,boolean>();
            for(Visitation_CS__c vcs : vcslist){
                if(vcs.Editable__c ){
                    if( !String.isblank(vcs.Full_Name__c) && !string.isblank(rec.Requested_Executives__c) && rec.Requested_Executives__c.contains(vcs.Full_Name__c)){
                        tempMap.put(vcs.API_Name__c, true);
                    }else {
                        tempMap.put(vcs.API_Name__c, false);
                    }
                }
            }
            wrappers.add(new VisitationWrapper(rec, tempMap));
        }
        
    }
    
    public list<Visitation_CS__c> vcslist {get; set;}
    /* ==============================================Actions===================================================== */
    public void massUpdate(){
        list<Visitation_Record__c> vrList = new list<Visitation_Record__c>();
        system.debug('wrappers:' + wrappers);
        for(VisitationWrapper rec : wrappers){
            if(rec.isChecked){
                vrList.add(rec.vstRec);
            }
        }
        
        if(vrList.size() > 0 ){
            try{
                update vrList;
                searchVisitation();
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Visitation records updated successfully.'));
                
            }catch(exception ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Failed to update visitation records.'));
            }
            
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING, 'Please select at least one visitation record.'));
        }
        
    }
    
    public void clearSearch(){
        dummyVR = new Visitation_Record__c();
        dummyVR.Visit_Type__c = '';
        searchST = '[]';
        searchExe = '[]';
        searchStage = '[]';
        queryVisitation(null);
    }

    public void searchVisitation(){
        if(dummyVR.Account__c != null || !String.isBlank(dummyVR.Visit_Location__c) ||!String.isBlank(dummyVR.Visit_Type__c) || searchExe!= '[]' || searchStage !='[]' || searchST != '[]' || !String.isBlank(dummyVR.Fab__c) ){
        
            String whereClause = 'WHERE ';
            if(dummyVR.Account__c != null){
                whereClause = whereClause + 'AND Account__c =\'' + dummyVR.Account__c +'\' ';
            }
            if(!String.isBlank(dummyVR.Visit_Location__c)){
                whereClause = whereClause + 'AND Visit_Location__c  = \'' + dummyVR.Visit_Location__c + '\' ';
            }
            
            if(!String.isBlank(dummyVR.Visit_Type__c)){
                whereClause = whereClause + 'AND Visit_Type__c  = \'' + dummyVR.Visit_Type__c + '\' ';
            }
            if(searchStage != '[]'){
                String oldSearchStage = searchStage.replace('[','');
                oldSearchStage = oldSearchStage.replace(']','');
                
                string temp = 'AND (';
                for(String st : oldSearchStage.split(',')){
                    temp = temp + 'OR Customer_Status__c = \'' + st.trim() + '\' ';
                }
                temp = temp + ')';
                temp = temp.replace('AND (OR', 'AND (');
                
                whereClause = whereClause + temp ;
            }
            if(searchExe != '[]'){
                String oldSearchExe = searchExe.replace('[','');
                oldSearchExe = oldSearchExe.replace(']','');
                
                String temp = '(\'' + oldSearchExe.replace(',','\',\'') + '\')';
                whereClause = whereClause + 'AND Requested_Executives__c includes ' + temp ;
            }
            
            if(searchST != '[]'){
                String oldSearchST = searchST.replace('[','');
                oldSearchST = oldSearchST.replace(']','');
                
                string temp = 'AND (';
                for(String st : oldSearchST.split(',')){
                    temp = temp + 'OR Account_Sales_Territory__c = \'' + st.trim() + '\' ';
                }
                temp = temp + ')';
                temp = temp.replace('AND (OR', 'AND (');
                
                whereClause = whereClause + temp ;
            }
            
            if(!String.isBlank(dummyVR.Fab__c)){
                string temp = '(\'' + dummyVR.Fab__c.replace(';','\',\'') + '\')';
                whereClause = whereClause + 'AND Fab__c includes ' + temp ;
            }
            
            
            whereClause =  whereClause.replace('WHERE AND','WHERE ');
            queryVisitation(whereClause);
            
        } else {
            queryVisitation(null);
        }
    }
    
    /*===============================================Pagination================================================== */
    public void beginning() {
        stdSetCtrl.first();        
    }
    
    public void previous() {
        stdSetCtrl.previous();        
    }
    
    public void next() {
        stdSetCtrl.next();        
    }
    
    public void end() {
        stdSetCtrl.last();        
    }
    
    public Boolean getDisableNext() { 
       if (stdSetCtrl.getHasNext()) {
           return false; 
       } else {
           return true;
       }
    }
   
    public Boolean getDisablePrevious() { 
      if (stdSetCtrl.getHasPrevious()) {
          return false;
      } else {
          return true;
      }
    }
    
    public Integer getPageNumber() {
        return stdSetCtrl.getPageNumber();
    }
    
    public Integer getTotalPages() {
        return (Integer) Math.ceil(Double.valueOf(stdSetCtrl.getResultSize()) / stdSetCtrl.getPageSize());
    }
    
    public Integer getDisplayRecordStart() {
        return ((stdSetCtrl.getPageNumber() - 1) * stdSetCtrl.getPageSize()) + 1;
    }

    public Integer getDisplayRecordEnd() {
        if ((stdSetCtrl.getResultSize() - ((stdSetCtrl.getPageNumber() - 1) * stdSetCtrl.getPageSize())) < stdSetCtrl.getPageSize()) {
            return stdSetCtrl.getResultSize();
        } else {
            return stdSetCtrl.getPageNumber() * stdSetCtrl.getPageSize();
        }
    }

    public Integer getTotalRecords() {
        return stdSetCtrl.getResultSize();
    }
    
}