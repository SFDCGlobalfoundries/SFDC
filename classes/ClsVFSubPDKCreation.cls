/*
Type Name: ClsVFSubPDKCreation 
Author: Cognizant 
Created Date: 30-05-2013
Reason: This class is used as the controller to the VF Page VFSubPDKCreation to create a sub PDK from the master PDK detail page.
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

public with sharing class ClsVFSubPDKCreation {
    
    private string masterPDKId;
    private PDK__c masterPDK;
    private final Map<String, Schema.SObjectType> globalDescribe=Schema.getGlobalDescribe();
    
    public list<designSpecWrapper> masterDesignSpec{get;set;}
    public Sub_PDK__c newSubPDK{get;set;}            
    public string searchString{get;set;}
    public list<accountwrapper> accountSearchList{get;set;}
    public boolean showWhiteListedAccountsSection{get;set;}
    public list<account> accountResult{get;set;}
    public Boolean isEmpty{get;set;}  
    
    /**
        This constructor sets the PDK sobject details into the sObject. It also instantiates the class for accessing from the page
        
        @method name: ClsVFSubPDKCreation
        @parameter:   Set the standard controller sObject record details in to the controller.
        @return :     none
    **/
    public ClsVFSubPDKCreation(ApexPages.StandardController controller) 
    {
        //searchString = '';
        showWhiteListedAccountsSection = false;        
        masterDesignSpec = new list<designSpecWrapper>();
        masterPDKId = ((PDK__c)controller.getRecord()).Id;
        //accountSearchList = new list<accountwrapper>();
        accountResult = new list<account>();
        
        masterPDK = [select id,
                            name,
                            Tech_Geometry__c,
                            Technology__c 
                       from pdk__c 
                      where id =:((PDK__c)controller.getRecord()).Id];  
                                      
        newSubPDK = new Sub_PDK__c();
        newSubPDK.PDK__c = ((PDK__c)controller.getRecord()).Id;
        //newSubPDK.Tech_Geometry__c = masterPDK.Tech_Geometry__c;
        //newSubPDK.Technology__c = masterPDK.Technology__c;
       
        findParentDesignSpecs();             
    }
    
    public string createQueryString(string sObjectName,string fieldSetName)
    {
        String query = 'SELECT Id';
        Schema.DescribeSObjectResult res=globalDescribe.get(sObjectName).getDescribe();
        Map<String, Schema.FieldSet> fieldSetMap= res.fieldSets.getMap(); 
        Schema.FieldSet fs = fieldSetMap.get(fieldSetName);                        
        
        for(Schema.FieldSetMember fsm : fs.getFields() ) 
        {                                    
            query = query + ',' + fsm.getFieldPath();                                                                  
        }          
        
        query = query + ' from ' + sObjectName;
        
        return query;            
    }
    
    public void findParentDesignSpecs()
    {       
        String query = createQueryString('Design_Spec__c','SelectDesignSpec');             
        
        List<Design_Spec__c> PDK_designSpecsList = Database.query(query + ' where pdk__c =: masterPDKId');
        
        if(!PDK_designSpecsList.isEmpty())
        {        
            for(Design_Spec__c x : PDK_designSpecsList)
            {
                masterDesignSpec.add(new designSpecWrapper(false,x));        
            }
        }  
    }              
     
    public void showWLAccountSection()
    {
        if(newSubPDK.Release_Status__c == 'Release to White list')
        {        
            showWhiteListedAccountsSection = true; 
            isempty = true;   
        }  
              
        else
        {
            showWhiteListedAccountsSection = false;                                   
        }
    }
       
    /* method to create sub PDK and sub PDK specs */
    public pagereference saveNewSubPDK()
    {   
        try
        {            
            if(newSubPDK.name == '' || newSubPDK.name == null || newSubPDK.Description__c == '' || newSubPDK.Description__c == null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the Sub PDK Name'));
                return null;    
            }
            
            insert newSubPDK;
            
            List<Sub_PDK_Spec__c> subPDKSpec = new List<Sub_PDK_Spec__c>();
            List<White_List__c> whiteList = new List<White_List__c>();
            
            if(!masterDesignSpec.isEmpty())
            {
                for(designSpecWrapper mds : masterDesignSpec)
                {
                    if(mds.isSelected)
                    {
                        Sub_PDK_Spec__c subSpec = new Sub_PDK_Spec__c();
                        subSpec.Design_Spec__c = mds.designSpec.id;
                        subSpec.Sub_PDK__c = newSubPDK.id;
                        subPDKSpec.add(subSpec);    
                    }    
                }
            }
                      
            if(!accountSearchList.isEmpty())
            {
                for(accountWrapper a : accountSearchList)
                {
                    if(a.isChecked)
                    {
                        White_List__c wl = new White_List__c();
                        wl.Account__c = a.accountFound.id;                    
                        wl.Sub_PDK__c = newSubPDK.id;
                        whiteList.add(wl);    
                    }    
                }
            }
          
            if(!subPDKSpec.isEmpty())
                insert subPDKSpec;
                
            if(!whiteList.isEmpty())
                insert whiteList;        
        }
        
        catch(Exception e)
        {
            system.debug('Exception ------------------------- ' + e);
            return null;
        }
      
        return new pagereference('/'+newSubPDK.id);
    }
       
    public void searchAccount()
    {               
        accountResult = new list<account>();
        accountSearchList = new list<accountwrapper>();
        
        if(searchString != null || searchString != '')
        {                          
            string queryString = 'SELECT Id,Name,Stage__c FROM account where name like ' + '\'%' + searchString + '%\'' + ' order by Name limit 10';               
            accountResult = Database.Query(queryString);                  
        }
        
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please provide a search string'));
            return;
        }
        
        if(!accountResult.isEmpty())
        {
            isEmpty = false;
            
            for(account a : accountResult)
            {
                accountSearchList.add(new accountwrapper(false,a));        
            }            
        }
                
        else
        {
            isEmpty = true;
        }                     
    }
    
    public void addSelectedAccounts()
    {        
        /*
        if(!accountSearchList.isEmpty()) 
        {
            for(Integer i=0 ; i<accountSearchList.size(); i++)
            {
                if(!accountSearchList[i].isChecked)
                    accountSearchList.remove(i);        
            }
        } 
        */
        system.debug(' $$$$$$$$$$$$$$$$$$$$$$$$$$$$$  accountSearchList '+accountSearchList);            
    }
      
    /* Wrapper class to display the design specs of the parent PDK for selection */
    public class designSpecWrapper
    {       
        public boolean isSelected{get;set;}
        public Design_Spec__c designSpec{get;set;}
        
        public designSpecWrapper(boolean x,Design_Spec__c y)
        {
            isSelected = x;
            designSpec = y;
        }
    }
    
    public class accountWrapper
    {
        public boolean isChecked{get;set;}
        public account accountFound{get;set;}
        
        public accountWrapper(boolean x,account y)
        {
            isChecked = x;
            accountFound = y;
        }
    }
}