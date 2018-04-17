/*
Type Name: ClsCreateSubPDK 
Author: Cognizant 
Created Date: 30-05-2013
Reason: This class is used as the controller to the VF Page VFSubPDKCreation to create a sub PDK from the master PDK detail page.
Change History:
Author: Global Foundries(Dinesh Suggala)
Modified Date: 25/9/2017
Reason: Added the Code for Pagination
Author :Global Foundries(Dinesh Suggala)
Modified Date:3/10/2017
Reason:Added Order BY Keyword 
Author:Dinesh Suggala(Global Foundries)
Modified Date:2/11/2017
Reason:Fixed the bug for the Case 00081640
Author:Dinesh Suggala(Global Foundries)
Modified Date:29/11/2017
Reason: Updated the SOQL query in SearchAccount() method for the Case#83210
Author:Dinesh Suggala(Global Foundries)
Modified Date:26/12/2017
Reason: For Case #84497 (Page number is wrong)
Author:Dinesh Suggala(Global Foundries)
Modified Date:25/1/2018
Reason: Updated the SOQL query in SearchAccount() method with this record type "GLOBALFOUNDRIES Internal"
??..
??..
*/

public without sharing class ClsCreateSubPDK {
    public boolean pageLoadShow{get;set;}
    private string masterPDKId;
    //Added for Patch Spec Start
    public set<String> setPatchPDKIds; 
    //Added for Patch Spec End
    public PDK__c masterPDK {get;set;}
    private final Map<String, Schema.SObjectType> globalDescribe=Schema.getGlobalDescribe();
    
    public list<designSpecWrapper> masterDesignSpec{get;set;}
    //Added for Patch Spec Start
    public list<designSpecWrapper> patchDesignSpec{get;set;}
    //Added for Patch Spec End
    public Sub_PDK__c newSubPDK{get;set;}            
    public string searchString{get;set;}
    public list<accountwrapper> accountSearchList{get;set;}
    public list<accountwrapper> WLAccounts{get;set;}
    public boolean showWLAccountsSection{get;set;}
    public boolean editpanel{get;set;}
    public boolean searchpanel{get;set;}
    /** Restrict from Creating Sub PDKs when PDK is Obsolete - Start **/           
    public boolean isNotObsoletePDK{get;set;}
    /** Restrict from Creating Sub PDKs when PDK is Obsolete - End **/ 
    public set<Id> accSelectedIds;      
    public Boolean displayPage{get; set;}  
    public String errorMsg{get; set;}
    public Boolean nonAsicFlag;
    public Boolean asicFlag;
	
	//Added by Dinesh 25/9/2017
    public Integer counter = 0;//TO track the number of records parsed
    public Integer limitSize;//Number of records to be displayed
    public Integer totalSize =0; //To Store the total number of records available
    public integer pageNum{get;set;}
    public list<designSpecWrapper> showmasterDesignSpec{get;set;}
	public Boolean selectAll{get;set;}
    //****
    
    /**
        This constructor sets the PDK sobject details into the sObject. It also instantiates the class for accessing from the page
        
        @method name: ClsVFSubPDKCreation
        @parameter:   Set the standard controller sObject record details in to the controller.
        @return :     none
    **/
    public ClsCreateSubPDK(ApexPages.StandardController controller) 
    {
        displayPage = true;
        //searchString = '';
        /** Restrict from Creating Sub PDKs when PDK is Obsolete - Start **/       
        isNotObsoletePDK = false;
        /** Restrict from Creating Sub PDKs when PDK is Obsolete - End **/       
        showWLAccountsSection = false;
        editpanel = true;
        searchpanel = false;
        accSelectedIds = new set<Id>();
        accountSearchList = new list<accountwrapper>();
        WLAccounts = new list<accountwrapper>();
        masterDesignSpec = new list<designSpecWrapper>();
        //Added for Patch Spec Start
        patchDesignSpec = new list<designSpecWrapper>();
        //Added for Patch Spec End
        masterPDKId = ((PDK__c)controller.getRecord()).Id;
        //Added for Patch Spec Start
        setPatchPDKIds = new set<String>();
        for(PDK_Patch__c objPatch:[Select Id, PDK__c,Patch_PDK_Lifecycle_Phase__c  from PDK_Patch__c where PDK__c=:masterPDKId and Patch_PDK_Lifecycle_Phase__c!='Obsolete']){
            setPatchPDKIds.add(objPatch.Id);            
        }         
        //Added for Patch Spec End     
        
        masterPDK = [select id,
                            name,
                            Master_PDK_ASIC__c,
                            Tech_Geometry__c,
                            Technology__c, PDK_Lifecycle_Phase__c
                       from pdk__c 
                      where id =:((PDK__c)controller.getRecord()).Id];  
        
        /** Restrict from Creating Sub PDKs when PDK is Obsolete - Start **/       
        if(masterPDK.PDK_Lifecycle_Phase__c!=null && masterPDK.PDK_Lifecycle_Phase__c=='Obsolete'){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot create PDK for an Obsolete Master PDK');
            ApexPages.addMessage(myMsg);        
        }
        /** Restrict from Creating Sub PDKs when PDK is Obsolete - End **/       
        else{ 
            /** Restrict from Creating Sub PDKs when PDK is Obsolete - Start **/
            isNotObsoletePDK = true;
            /** Restrict from Creating Sub PDKs when PDK is Obsolete - End **/                             
            newSubPDK = new Sub_PDK__c();
            newSubPDK.PDK__c = ((PDK__c)controller.getRecord()).Id;
            //newSubPDK.Tech_Geometry__c = masterPDK.Tech_Geometry__c;
            //newSubPDK.Technology__c = masterPDK.Technology__c;
                 
            findParentDesignSpecs();
        }  
        //***added for ASIC/non-Asic permission set-START
        nonAsicFlag = NonasicLoginUser();
        asicFlag =  asicLoginUser();
       if(!masterPDK.Master_PDK_ASIC__c && asicFlag){
         displayPage = false;
         errorMsg = 'A';
       }
       if(masterPDK.Master_PDK_ASIC__c && nonAsicFlag){
          displayPage = false;
          errorMsg = 'B';
       }
       if(asicFlag && nonAsicFlag){
           displayPage = true;
       }
       if(errorMsg =='A' && !displayPage){
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You are not allowed to proceed, Access for PDK Admin (All licenses ) is required.');
          ApexPages.addMessage(myMsg);      
       }
       if(errorMsg =='B' && !displayPage){
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You are not allowed to proceed, Access for ASIC PDK Admin (All licenses ) is required.');
          ApexPages.addMessage(myMsg);  
       }
       
        //Added by Dinesh 25/9/2017
        totalSize=masterDesignSpec.size();
        pageNum=1;                                                           //Added by Dinesh 26/12/2017 Case #84497
        PDKPagination__c rp= PDKPagination__c.getValues('1');                //Custom Setting 
        String recordsperpage= rp.RecordsPerPage__c;             
        limitSize=Integer.ValueOf(recordsperpage);                       
        showmasterDesignSpec= new list<designSpecWrapper>();
        if((counter+limitSize) <= totalSize){
            for(Integer i=0;i<limitSize;i++){
                showmasterDesignSpec.add(masterDesignSpec.get(i));
            }
        }else{
            for(Integer i=0;i<totalSize;i++){
                showmasterDesignSpec.add(masterDesignSpec.get(i));
            }
        }  
        //Code Ended By Dinesh 25/9/2017

        
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
        //Added for Patch Spec Start
        if(setPatchPDKIds!=null && setPatchPDKIds.size()>0 && sObjectName=='Design_Spec__c'){
            query = query + ',PDK_Patch_Name__c'  ; 
        }
        //Added for Patch Spec End         
        
        query = query + ' from ' + sObjectName;
        
        return query;            
    }
    
    public void findParentDesignSpecs()
    {                   
        String query = createQueryString('Design_Spec__c','SelectDesignSpec');  
        
        List<Design_Spec__c> PDK_designSpecsList = Database.query(query + ' where pdk__c =: masterPDKId' + ' Order By Document_Number__c,Revision__c ASC');        //Order By Keyword Added by Dinesh 3/10/2017
        
        if(!PDK_designSpecsList.isEmpty())
        {        
            for(Design_Spec__c x : PDK_designSpecsList)
            {
                masterDesignSpec.add(new designSpecWrapper(false,x));        
            }
        } 
        
        //Added for Patch Spec Start
        List<Design_Spec__c> patchDesignSpecsList = new List<Design_Spec__c>();
        if(setPatchPDKIds!=null && setPatchPDKIds.size()>0){
            patchDesignSpecsList = Database.query(query + ' where pdk_patch__c IN: setPatchPDKIds');
        }
            system.debug('****patchDesignSpecsList'+ patchDesignSpecsList);
        if(!patchDesignSpecsList.isEmpty())
        {        
            for(Design_Spec__c x : patchDesignSpecsList)
            {
                patchDesignSpec.add(new designSpecWrapper(false,x));  
                system.debug('****x'+ x);               
            }
        } 
        //Added for Patch Spec End 
    }              
    
    public void showWLAccountSection()
    {


        WLAccounts.clear();
        
        if(newSubPDK.Release_Status__c == 'Release to White list')        
            showWLAccountsSection = true;    
                
        else
            showWLAccountsSection = false;
    }
       
    public boolean isTrue {get;set;} 
    
    public void validateStatus(){
        isTrue = false;
        // Check for master pdk design spec
        if (showmasterDesignSpec!=null && !showmasterDesignSpec.isEmpty()){
            for(designSpecWrapper pdk : showmasterDesignSpec){
                // Added for CR 2590
                if(pdk.isSelected && pdk.designSpec.Release_Status__c.toUpperCase().trim()=='Internal Use Only'.toUpperCase().trim()){
                    isTrue = true;
                    //return null;
                }                
            }
        }
        //Check for patch design spec
        if (patchDesignSpec!=null && !patchDesignSpec.isEmpty()){
            for(designSpecWrapper pdk : patchDesignSpec){
                // Added for CR 2590
                if(pdk.isSelected && pdk.designSpec.Release_Status__c.toUpperCase().trim()=='Internal Use Only'.toUpperCase().trim()){
                    isTrue = true;
                    //return null;
                }                
            } 
        }            
    }
    
    /* method to create sub PDK and sub PDK specs */
    public pagereference saveNewSubPDK()
    {
        try
        {                                               
            if(newSubPdk.Bundle_Name__c == null || newSubPdk.Bundle_Name__c == '')
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the PDK Bundle Name'));
                return null; 
            }
            else if(newSubPdk.Bundle_Name__c !=null && newSubPdk.Bundle_Name__c.contains(':'))
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please do not use : in Bundle Name'));
                return null; 
            }
            if(newSubPdk.Release_Status__c == null || newSubPdk.Release_Status__c == '')
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select a Release Status'));
                return null; 
            }
            List<Sub_PDK_Spec__c> subPDKSpec = new List<Sub_PDK_Spec__c>();
            List<White_List__c> whiteList = new List<White_List__c>();
            integer designSpecCount = 0;
            integer accountCount = 0;
            //Added for Patch Spec Start
            list<designSpecWrapper> allDesignSpec = new list<designSpecWrapper>();
            allDesignSpec.addAll(masterDesignSpec);
            allDesignSpec.addAll(patchDesignSpec);
            //Added for Patch Spec End

            
            for(designSpecWrapper mds : allDesignSpec)
            {
                if(mds.isSelected)
                {                                                           
                    designSpecCount++;  
                } 
            }
            
            if(designSpecCount == 0)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select atleast one Design Spec'));
                return null;
            }
            
            if(newSubPDK.Release_Status__c == 'Release to White list')
            {
                for(accountWrapper a : WLAccounts)
                {
                    if(a.isChecked)
                    {
                        accountCount++;    
                    }    
                }
                
                if(accountCount == 0)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select atleast one Account'));
                    return null; 
                }
            }
             // Added for General release validation while creation of pdk from master pdk 
            if (newSubPDK.Release_Status__c.toUpperCase().trim() == 'General Release'.toUpperCase().trim()){
                // Check for master pdk design spec
                if (showmasterDesignSpec!=null && !showmasterDesignSpec.isEmpty()){
                    for(designSpecWrapper pdk : showmasterDesignSpec){
                        if(pdk.isSelected && pdk.designSpec.Release_Status__c.toUpperCase().trim()!='General Release'.toUpperCase().trim()){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'General Release PDK can contain only General Release Specs.'));
                            return null;
                        }                
                    }
                }
                //Check for patch design spec
                if (patchDesignSpec!=null && !patchDesignSpec.isEmpty()){
                    for(designSpecWrapper pdk : patchDesignSpec){
                        if(pdk.isSelected && pdk.designSpec.Release_Status__c.toUpperCase().trim()!='General Release'.toUpperCase().trim()){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'General Release PDK can contain only General Release Specs.'));
                            return null;
                        }                
                    } 
                }            
            }
            
            // Mandatory check for secific account release with owner approval required for spec
             // Added for General release validation while creation of pdk from master pdk 
            if (!newSubPDK.Release_Status__c.equalsIgnoreCase('Specific Account Release with Spec owner Approval') && 
                !newSubPDK.Release_Status__c.equalsIgnoreCase('Release to White list')){
                // Check for master pdk design spec
                if (showmasterDesignSpec!=null && !showmasterDesignSpec.isEmpty()){
                    for(designSpecWrapper pdk : showmasterDesignSpec){
                        if(pdk.isSelected && pdk.designSpec.Release_Status__c.equalsIgnoreCase('Specific Account Release with Spec owner Approval')){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,
                            'Specific Account Release with Spec owner Approval spec can only be included in bundle with release status Specific Account Release with Spec owner Approval or Release to White list.'));
                            return null;
                        }                
                    }
                }
                //Check for patch design spec
                if (patchDesignSpec!=null && !patchDesignSpec.isEmpty()){
                    for(designSpecWrapper pdk : patchDesignSpec){
                        if(pdk.isSelected && pdk.designSpec.Release_Status__c.equalsIgnoreCase('Specific Account Release with Spec owner Approval')){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,
                            'Specific Account Release with Spec owner Approval spec can only be included in bundle with release status Specific Account Release with Spec owner Approval or Release to White list.'));
                            return null;
                        }                
                    } 
                }            
            }            
            insert newSubPDK;
                                    
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
            
            //Added for Patch Spec Start
            for(designSpecWrapper pds : patchDesignSpec)
            {
                if(pds.isSelected)
                {
                    Sub_PDK_Spec__c subSpec = new Sub_PDK_Spec__c();
                    subSpec.Design_Spec__c = pds.designSpec.id;
                    subSpec.Sub_PDK__c = newSubPDK.id;
                    subPDKSpec.add(subSpec);    
                }    
            }
            //Added for Patch Spec End
            
            if(newSubPDK.Release_Status__c == 'Release to White list')
            {
                for(accountWrapper a : WLAccounts)
                {
                    if(a.isChecked)
                    {
                        White_List__c wl = new White_List__c();
                        wl.Account__c = a.accountFound.id;                    
                        wl.Sub_PDK__c = newSubPDK.id;
                        wl.RecordTypeId = clsIntegrationUtil.fetchAllRecTypeIdsMap('White_List__c').get('PDK');
                        whiteList.add(wl);    
                    }    
                }                                      
            }
            
            if(!subPDKSpec.isEmpty())
            {
                insert subPDKSpec;
                List<Sub_PDK_Spec__c> lstSubPDKSpec = [SELECT id,Design_Spec_OpenTextId__c from Sub_PDK_Spec__c where Id IN:subPDKSpec];
                String PdkSpecs = '';
                if(lstSubPDKSpec!=null && lstSubPDKSpec.size()>0){
                    for(Sub_PDK_Spec__c PDKSpec: lstSubPDKSpec){
                        if(PdkSpecs == '' || PdkSpecs == NULL)
                            PdkSpecs = PDKSpec.id+':NONE:'+PDKSpec.Design_Spec_OpenTextId__c;
                        else    
                            PdkSpecs = PdkSpecs+';'+PDKSpec.id+':NONE:'+PDKSpec.Design_Spec_OpenTextId__c;
                    }
                    if(PdkSpecs!='' && PdkSpecs!=null){
                        newSubPDK.Pdk_Spec_Associations__c = PdkSpecs;
                        update newSubPDK;
                    }   
                }
            }
            if(!whiteList.isEmpty())
            {
                insert whiteList;            
            }    
        system.debug('*****newSubPDK.id****'+newSubPDK.id);
        }
        
        catch(Exception e)
        {
            system.debug('Exception ------------------------- ' + e);
            return null;
        }
        
        return new pagereference('/'+newSubPDK.id);
    }
    
    public void searchAccount(){
        List<account> accountResult = new list<account>();
        accountSearchList = new list<accountwrapper>();        
     
        if(searchString != null && searchString != ''){
          string searchText='%'+searchString.toLowerCase()+'%';

           /* accountResult= [SELECT name,id,Site_Department__c,Stage__c,Parent_Account_Name__c,Parent_Account_Short_Name__c,Short_Name__c
                            FROM account 
                            WHERE (name like :searchText OR Short_Name__c like :searchText)
                            AND Id NOT IN: accSelectedIds];*/
            
            accountResult= [SELECT name,id,Site_Department__c,Stage__c,Parent_Account_Name__c,Parent_Account_Short_Name__c,Short_Name__c,ASIC_Business_Flag__c 
                            FROM account 
                            WHERE (name like :searchText OR Short_Name__c like :searchText)
							AND (RecordType.Name IN('Customer','Enablement Partner' ,'Reseller','GLOBALFOUNDRIES Internal') OR (RecordType.Name='Suppliers' AND Supplier_Type__c='Manufacturing Vendor'))
							AND Id NOT IN: accSelectedIds order by Short_Name__c];   //added for Case 42841                     
            //String query = createQueryString('Account','WhiteListFields');  
            //query = query + ' where name like ' + '\'%' + searchString.toLowerCase() + '%\'';
           /* 
            if(accSelectedIds!=null && accSelectedIds.size()>0){
                query = query + ' AND Id NOT IN: accSelectedIds ';      
            } 
            query = query +  ' order by Name';                                  
            //string queryString = 'SELECT Id,Name,Stage__c FROM account where name like ' + '\'%' + searchString + '%\'' + ' order by Name';               
            accountResult = Database.Query(query);  */   
            system.debug('***accountResult'+accountResult);			
        }
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a search string'));
            return;    
        }
        if(!accountResult.isEmpty()){
            for(account a : accountResult){
                accountSearchList.add(new accountwrapper(false,a));        
            }
        }
    }
    
    public void addSelectedAccounts()
    {
        //WLAccounts = new list<accountwrapper>();
        integer accountCount = 0;
        
        if(!accountSearchList.isEmpty()) 
        {
            for(accountwrapper a : accountSearchList)
            {
                if(a.isChecked)
                {
                    WLAccounts.add(a);
                    accSelectedIds.add(a.accountFound.Id); 
                    accountCount ++;   
                }
            }
        }
        
        //if(WLAccounts.isEmpty())
        if(accountCount == 0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select atleast one account'));
            return; 
        }
        
        else
        {
            accountSearchList.clear();
            searchString = null;
            editpanel = true;
            searchpanel = false;
        }           
    }
    
    public void clearSearch()
    {        
        searchString = null;
        accountSearchList.clear(); 
        editpanel = false;
        searchpanel = true;   
    }
    
    public void cancelAddAccount()
    {
        searchstring = null;
        accountSearchList.clear();
        editpanel = true;
        searchpanel = false;
    }
	
	//Added by Dinesh 25/9/2017
     Public integer getTotalPages(){
        Decimal pages;
        pages = masterDesignSpec.size()/limitSize==0?1:masterDesignSpec.size()*1.0/limitSize;         //Added by Dinesh 26/12/2017 Case #84497
        return (Integer)Math.Ceil(pages);
    }
    
    public void beginning(){
        selectAll=false;
        showmasterDesignSpec.clear();
        counter=0;
        pageNum=counter+1;                    // +1 Added by Dinesh 26/12/2017 Case #84497
        if((counter + limitSize) <= totalSize){
       
            for(Integer i=0;i<limitSize;i++){
                showmasterDesignSpec.add(masterDesignSpec.get(i));
            }   
           
        } else{
       
            for(Integer i=0;i<totalSize;i++){
                showmasterDesignSpec.add(masterDesignSpec.get(i));
            }       
           
        }
       
    }
   
    public void next(){
        selectAll=false;
        showmasterDesignSpec.clear();
        counter=counter+limitSize;
        pageNum++;
        if((counter+limitSize) <= totalSize){
            for(Integer i=counter;i<(counter+limitSize);i++){
                showmasterDesignSpec.add(masterDesignSpec.get(i));
                
            }
        } 
        else{
            for(Integer i=counter;i<totalSize;i++){
             showmasterDesignSpec.add(masterDesignSpec.get(i));
            }
        }
    }
   
    public void previous(){
        selectAll=false;
        showmasterDesignSpec.clear();
        pageNum--;
        counter=counter-limitSize;       
       
        for(Integer i=counter;i<(counter+limitSize); i++){      
         showmasterDesignSpec.add(masterDesignSpec.get(i));
        }
       
    }

    public void last (){
        selectAll=false;
        showmasterDesignSpec.clear();
        
        if(math.mod(totalSize , limitSize) == 0){
            counter = limitSize * ((totalSize/limitSize)-1);
        } else if (math.mod(totalSize , limitSize) != 0){
            counter = limitSize * ((totalSize/limitSize));
        }
        pageNum=(Integer)Math.ceil(totalSize*1.0/limitSize);
        for(Integer i=counter;i<totalSize;i++){             
         showmasterDesignSpec.add(masterDesignSpec.get(i));
        }
       
    }
   
    public Boolean getDisableNext(){
   
        if((counter + limitSize) >= totalSize )
            return true ;
        else
            return false ;
    }
   
    public Boolean getDisablePrevious(){
   
        if(counter == 0)
            return true ;
        else
            return false ;
    } 
    // Code End By Dinesh 25/9/2017
      
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
    //***added for ASIC/non-Asic permission set-START
       
    public boolean asicLoginUser() {
       List<PermissionSetAssignment> asicPermission  = [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Access_ASIC_PDK_Admin' AND AssigneeId=:UserInfo.getUserId() LIMIT 1];
        if(!asicPermission.isEmpty() ){
             return true;       
         }else{
             return false;
         }

    }
    public boolean NonasicLoginUser() {
        List<PermissionSetAssignment> NonasicPermission = [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Access_PDK_Admin' AND AssigneeId=:UserInfo.getUserId() LIMIT 1];
        if(!NonasicPermission.isEmpty()){
           return true;
        }else{
            return false;
        }   
    }  
    //***added for ASIC/non-Asic permission set-END
}