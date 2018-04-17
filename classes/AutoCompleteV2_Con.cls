/**************************************************************************************************************************
Class:         AutoCompleteV2_Con
---------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  09/05/2014
Reason:        Controller class for component "AutoCompleteV2"

Change Log:    Created     -     JOYDEV     -     09/05/2014  
Change Log:    Updated     -     JOYDEV     -     04/07/2014  
               Reason: (*) New Property 'InitcacheField' needs to be added to initialize cache values if targetFieldVar 
                           is initialized to avoid too many SOQL on load.
                       (*) Setter method for property 'setTargetFieldVar' need to be updated to block SOQL on load only.          
**************************************************************************************************************************/

public class AutoCompleteV2_Con {

    public String labelField{ get; set; }
    public String valueField{ get; set; }
    public String opFilter { get; set; }
    public String sObjVal{get;set;}
    public String sObjLabel{get;set;}
    public Integer randomJsIden{get;set;}
    public Object cacheField{get;private set;} 
    /*Change Log:    Updated     -     JOYDEV     -     04/07/2014
      Property 'InitcacheField' to initialize cache values if targetFieldVar is initialized 
      to avoid too many SOQL on load*/
    public Object InitcacheField{ get; set;}
    private Object targetFieldVar;
    
    public AutoCompleteV2_Con(){
        randomJsIden = getRandomNumber(1000000);
        sObjVal='Account';
        labelField='Name';
        valueField='Id';
        opFilter='';
    }
    
    /*Dummy setter Method*/
    public void setCacheField(Object cacheField){}
    
    public void setTargetFieldVar(Object targetFieldVar){
        if(targetFieldVar != this.targetFieldVar){
            /*Change Log:    Updated     -     JOYDEV     -     04/07/2014
              Updated to block SOQL on load only*/
            cacheField = (InitcacheField != cacheField? InitcacheField : getCacheFieldValue(targetFieldVar));
            this.targetFieldVar = targetFieldVar;
            
            /*Change Log:    Updated     -     JOYDEV     -     04/07/2014
              Unblock SOQL after on load*/
            InitcacheField = cacheField;
        }
    }
    
    public Object getTargetFieldVar(){
        return targetFieldVar;
    }
    
    private Object getCacheFieldValue(Object targetFieldVar){
        Object retVal = targetFieldVar;
        if(targetFieldVar!=null){
            for(sObject sObj : Database.query('SELECT '+valueField+','+labelField+' FROM '+sObjVal+' WHERE '+valueField+' =:targetFieldVar')){
                retVal = sObj.get(labelField);
                break;
            }
        }
        
        return retVal;
    }

    
    /*
    *Random number generator to change the js function name if multiple components us
    ***/
    private Integer getRandomNumber(Integer size){
        Double d = Math.random() * size;
        return d.intValue();
    }
    
    /*
    *This method queries data according to the passed parameters
    ***/
    @RemoteAction
    public static List<AutoCompleteData> getData(String sObjVal,String labelField,String valueField,String param, String opFil){
       
        List<AutoCompleteData> AutoCompleteDatas = new List<AutoCompleteData>();
        param = String.escapeSingleQuotes(param);
        for( Sobject sObj : Database.query('SELECT '+valueField+','+labelField+' FROM '+sObjVal+' WHERE '+labelField+' LIKE \'%'+param+'%\' ' 
                                           + opFil.replace('"','\''))){
            AutoCompleteDatas.add(new AutoCompleteData(sObj.get(valueField),sObj.get(labelField)));
        }
        
        return AutoCompleteDatas;
        
    }
    
    public class AutoCompleteData{
        public String id;
        public String text;
        
        public AutoCompleteData(Object id, Object text){
            this.id = String.valueOf(id);
            this.text = String.valueOf(text);
        }
    }
}