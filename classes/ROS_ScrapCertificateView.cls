/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Functionality to display Scrap Certificates records based on the ROS Cycle
* History       :   

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        Shuchismita   10/11/2014  Created and added functionality to the Class
        Rnadella      01/26/2017  Modified as per new functionality
**/
public with Sharing class ROS_ScrapCertificateView {
public string accountName {get;set;}
public string retName {get;set;}
public String rosCycle{get;set;}
public string searchQuery ;
public string WhereClause ;
public set<id>set_ParentId ;
public String AccountId;
public string wClause {get ;set;}
public Map<id,attachment>attMap {get;set;}
public list<reticle__c>list_DisplayRet{get;set;}
public Boolean showHeaderSidebar{get;set;}


public List<Selectoption> getrosCycles(){
    
        List<Selectoption> AllrosCycles = new List<Selectoption>();
        AllrosCycles.add(new selectOption('none','- None -'));
        for(ROS_Cycle__c eachAllrosCycle : [select id,name from ROS_Cycle__c limit 50]) {
            AllrosCycles.add(new selectOption(eachAllrosCycle.Name,eachAllrosCycle.Name));
        }
        return AllrosCycles;    
    }
    
    public ROS_ScrapCertificateView() {
        list_DisplayRet = new list<reticle__c>();
        attMap= new Map<id,attachment>();
        set_ParentId = new set<id>();
        List<User> usrList = [SELECT u.Contact.AccountId
                                FROM User u WHERE u.Id =: UserInfo.getUserId()];        
        if(!usrList.isEmpty()){
            AccountId = usrList[0].Contact.AccountId;
        } 
        if(AccountId != null && AccountId != ''){
            showHeaderSidebar = false;
        }else{
            showHeaderSidebar = true;
        }
        }
    
        public void Search (){
      whereClause='';
      searchQuery ='Select id,name,Account__r.name,Disposal_Certificate__r.name,ROS_Cycle__r.name,Disposal_Certificate__c,Disposal_Certificate__r.Scrap_Date__c  from reticle__c';
      wClause = ' WHERE Disposal_Certificate__r.Name != NULL AND Disposal_Certificate__r.PDF_Generated__c != FALSE';
      whereClause=wClause;
      
      list_DisplayRet.clear();
             
        if(AccountId != null && AccountId != ''){
            whereClause += ' AND Account__c =\'' + AccountId+ '\'';
          }
        
        if(accountName !='' && accountName != null){
            whereClause +=' AND Account__r.name like';
            String val='\'%' + String.escapeSingleQuotes(accountName.trim()) + '%\'';
            whereClause +=val;
        }
        
        if(retName !='' && retName != null){
            whereClause +=' AND name like';
            String val='\'%' + String.escapeSingleQuotes(retName.trim()) + '%\'';
            whereClause +=val;
        }
        
        
        if(!rosCycle.equalsIgnoreCase('none')){
            ROS_Cycle__c rosCycleTemp = [select Cycle_End_Date__c,Cycle_Start_Date__c from ROS_Cycle__c where name =: rosCycle];
             
            if(rosCycleTemp.Cycle_End_Date__c != NULL){
                whereClause += ' AND Disposal_Certificate__r.Scrap_Date__c <=' + DateTime.newInstanceGmt(rosCycleTemp.Cycle_End_Date__c  ,Time.newInstance(23,59,59,000)).format('yyyy-MM-dd\'T\'hh:mm:ss\'z\''); 
            }
            if(rosCycleTemp.Cycle_Start_Date__c != NULL){
                whereClause += ' AND Disposal_Certificate__r.Scrap_Date__c >=' + DateTime.newInstanceGmt(rosCycleTemp.Cycle_Start_Date__c,Time.newInstance(23,59,59,000)).format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'');
            }
        }
        
        if(rosCycle.equalsIgnoreCase('none') && retName ==''  && accountName =='' ) {
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Select Atleast one filter and try again.'));
        } else{
         whereClause += ' ORDER BY Account__r.name,CreatedDate DESC limit 100  ';
        system.debug('####Final Search Query####'+searchQuery + whereClause);
        list_DisplayRet= database.query(searchQuery +whereClause);
        for(Reticle__c rt:list_DisplayRet){
        set_ParentId.add(rt.Disposal_Certificate__c);
     }
    for(Attachment att:[Select id,parentId,Name from Attachment where parentId in :set_ParentId ]){
        attMap.put(att.parentId,att);
    }
      
        if(list_DisplayRet.isEmpty()){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No results found. Please change the filters and try again.'));
            }
        }
}
    
    public PageReference ViewRosVF() {        
        return new pageReference('/apex/ROSVF_SearchReticlesGFForm').setRedirect(true);
    } 

}