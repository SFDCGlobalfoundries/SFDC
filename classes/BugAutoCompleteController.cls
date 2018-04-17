/*
Type Name: BugAutoCompleteController
Author: Cognizant UCM Team
Created Date: 09/01/2015
Reason: Reason: 
Test Class: BugTriggerTest (line no 330, 331)
Change History:
Author: 
Modified Date: 
……..//
……..
--
*/
public class BugAutoCompleteController{

    public String labelField{ get; set; }
    public String valueField{ get; set; }
    public String sObjVal{get;set;}
    public Integer randomJsIden{get;set;}
    public String cacheField{get;set;} 
   
    public BugAutoCompleteController(){
        randomJsIden = getRandomNumber(1000000);
        sObjVal='Bug__c';
        labelField='Bug_Title__c';
        valueField='Id';
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
    public static List<SObject> getData(String sObjVal,String labelField,String valueField,String param){
        param = String.escapeSingleQuotes(param);
        List < List < sObject >> lstListObj = new List < List < sObject >> ();
        String searchQuery = 'FIND \'' + '%'+param+'%' + '\' IN ALL FIELDS RETURNING Bug__c(Id,Bugs_WR_Summary__c Where isbug__c = true limit 200)';
        lstListObj = search.query(searchquery);
        return lstListObj[0];
    }    
}