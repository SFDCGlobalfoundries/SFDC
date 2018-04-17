public class VoCController{
    
    public Boolean editMode{get;set;}
    public Boolean editVoCScore{get;set;}    
    public String recordId;   
    public VoC__c voc{get;set;}    
    public String vocName{get;set;}
    
    public List<VoCScoreWrapper> wrappers {get; set;}
    public static Integer toDelIdent {get; set;}
    public static Integer addCount {get; set;}
    private Integer nextIdent=0;
    
    public Boolean isSF1 {
        get {                   
            if(String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameHost')) ||
                String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameOrigin')) ||
                ApexPages.currentPage().getParameters().get('isdtp') == 'p1' ||
                (ApexPages.currentPage().getParameters().get('retURL') != null && ApexPages.currentPage().getParameters().get('retURL').contains('projectone') )
            ) {
                return true;
            }else{
                return false;
            }
        }
    }   
    
    public VoCController(ApexPages.StandardController controller) {        
        voc = (VOC__c)controller.getRecord();
        wrappers = new List<VoCScoreWrapper>(); 
             
        if(voc.Id != NULL && !URL.getCurrentRequestUrl().toExternalForm().contains('retURL')){
            editMode = false;
            editVoCScore = true;             
            fetchVoCScoreRecord();            
        }
        else if(voc.Id != NULL && URL.getCurrentRequestUrl().toExternalForm().contains('retURL')){
            editMode = true;             
        }
        else{
            editMode = true;             
            if(voc.contact__c != null){
                Contact con = [Select accountid from contact where id=:voc.contact__c];
                voc.account__c = con.accountid;
            }           
        }                             
    }
    
    public void fetchVoCScoreRecord(){
        String recQuery = 'SELECT ';
        
        recQuery += describeObjectFields('VoC_Score__c');
        recQuery += ' FROM VoC_Score__c WHERE VoC__c = ' + '\'' + voc.id + '\'' ;
        List<VoC_Score__c> vcsList = database.query(recQuery);
        
        if(!vcsList.isEmpty()){
            for(VoC_Score__c vcs : vcsList){                
                wrappers.add(new VoCScoreWrapper(nextIdent++,vcs,voc.id));
            }
        }        
    }
    
    public String describeObjectFields(String objctName){
        String fieldNameStr = '';
        
        Map<String,Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objctName);
        Map<String,Schema.SObjectField> SObjectFieldMap = SObjectTypeObj.getDescribe().fields.getMap();
        
        for(Schema.SObjectField fld : SObjectFieldMap.values()){
            Schema.DescribeFieldResult dfLst = fld.getDescribe();
            fieldNameStr += dfLst.getName() + ' ,';
        }
        
        return fieldNameStr.substring(0,fieldNameStr.length()-1);
    }
    
    public PageReference saveRec(){     
        try{           
            upsert voc;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
        }
        
        PageReference pg = new PageReference('/apex/VoC?id='+voc.id);
        pg.setRedirect(true);
        return pg;       
    }
    
    public PageReference cancelRec(){        
        editMode = false; 
        PageReference pg;
                 
        if(voc.contact__c != null && ApexPages.currentPage().getParameters().get('id') == null){            
            pg = new PageReference('/'+voc.contact__c);                        
        }                
        else if(ApexPages.currentPage().getParameters().get('id') != null){
            pg = new PageReference('/apex/VoC?id='+voc.id);
        }   
        else{
            pg = new PageReference('/aB0/o');
        }
        pg.setRedirect(true);
        return pg;
    }
    
    public void editRec(){
        editMode = true;
    }
    
    public void delWrapper(){
        Integer toDelPos=-1;
        List<VoC_Score__c> listToDelete = new List<VoC_Score__c>();
        
        for (Integer idx=0; idx<wrappers.size(); idx++){
            if (wrappers[idx].ident==toDelIdent){
                toDelPos=idx;
            }
        }
       
        if (-1!=toDelPos){
            VoC_Score__c recToDel = new VoC_Score__c();            
            recToDel = wrappers.get(toDelPos).vocScore;
            wrappers.remove(toDelPos);             
            if(recToDel.id != null){
                listToDelete.add(recToDel);
            }                                
        }
        
        if(!listToDelete.isEmpty()){
            try{           
                delete listToDelete;
            }
            catch(Exception e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            }            
        }
    }
  
    public void addRows(){
        for (Integer idx=0; idx<addCount; idx++){
            wrappers.add(new VoCScoreWrapper(nextIdent++,null,voc.id));
        }
    }
  
    public PageReference save(){
        List<VoC_Score__c> vcs=new List<VoC_Score__c>();
        Map<String,Decimal> areaCountMap = new Map<String,Decimal>();
        String duplicateAreaScore = '';
                    
        for (VoCScoreWrapper wrap : wrappers){
            vcs.add(wrap.vocScore);
            if(areaCountMap.get(wrap.vocScore.area__c)==null){
                areaCountMap.put(wrap.vocScore.area__c,0);
            }
            areaCountMap.put(wrap.vocScore.area__c,areaCountMap.get(wrap.vocScore.area__c)+1);
            
            if(areaCountMap.get(wrap.vocScore.area__c)>1){
                duplicateAreaScore = Label.VoC_Duplicate_Error;  
                break;              
            }            
        }
        if(duplicateAreaScore != null & duplicateAreaScore != ''){            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,duplicateAreaScore));
            return null;
        }
        else{         
            if(!vcs.isEmpty()){                  
                try{           
                    upsert vcs;
                }
                catch(Exception e){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
                }                      
            }             
            PageReference pg = new PageReference('/apex/VoC?id='+voc.id);
            pg.setRedirect(true);       
            return pg;  
        }  
          
    }
    
    public void addUpdateScore(){        
        editVoCScore = false;
    }
    
    public PageReference cancelVoCScore(){        
        PageReference pg = new PageReference('/apex/VoC?id='+voc.id);
        pg.setRedirect(true);
        return pg;      
    }
    
    public class VoCScoreWrapper{
        public VoC_Score__c vocScore {get; private set;}
        public Integer ident {get; private set;}        
        
        public VoCScoreWrapper(Integer inIdent, VoC_Score__c vcsRec, Id vocId){
            ident = inIdent;
            if(vcsRec != null){
                vocScore = vcsRec;
            }
            else{
                vocScore = new VoC_Score__c(VoC__c = vocId);   
            }
        }
   }
   
}