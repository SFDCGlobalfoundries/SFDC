public without sharing class ClsCloneSubPDK {

    public sub_pdk__c subPDK{get;set;}
    //Added for Patch Spec Start
    public set<String> setPatchPDKIds; 
    //Added for Patch Spec End
    //public list<whiteListWrapper> subPdkWhiteList{get;set;} 
    public list<accountWrapper> subPdkWhiteList{get;set;} 
    public list<designSpecWrapper> PDKDesignSpec{get;set;}
    //Added for Patch Spec Start
    public list<designSpecWrapper> patchDesignSpec{get;set;}
    //Added for Patch Spec End 
    public boolean editpanel{get;set;}
    public boolean searchpanel{get;set;}
    public boolean wlpanel{get;set;}
    public string searchString{get;set;}
    public list<accountwrapper> accountSearchList{get;set;}
    public list<accountwrapper> WLAccounts{get;set;}
    public set<id> accountidset;
    public map<id,White_List__c> mapAccountIdsToWhiteList; 
    public set<Id> accSelectedIds; 
    
    private map<id,Sub_PDK_Spec__c> subpdkspecmap;              
    private final Map<String, Schema.SObjectType> globalDescribe=Schema.getGlobalDescribe();
    
    public ClsCloneSubPDK (ApexPages.StandardController controller) 
    {                    
        editpanel = true;
        wlpanel = false;
        searchpanel = false;
        accountSearchList = new list<accountwrapper>();
        accSelectedIds = new set<Id>();
        accountidset = new set<id>();
        WLAccounts = new list<accountwrapper>();
        
        String query = createQueryString('sub_pdk__c','InputFields'); 
        
        string subpdkid = ((sub_pdk__c)controller.getRecord()).Id;
        
        subPDK = new sub_pdk__c();       
        subPDK = Database.query(query + ' where id =: subpdkid limit 1');
        //Added for Patch Spec Start 
        setPatchPDKIds = new set<String>();
        for(PDK_Patch__c objPatch:[Select Id, PDK__c, Patch_PDK_Lifecycle_Phase__c from PDK_Patch__c where PDK__c=:subPDK.PDK__c and Patch_PDK_Lifecycle_Phase__c!='Obsolete']){
            setPatchPDKIds.add(objPatch.Id);            
        }
        //Added for Patch Spec End
                        
        //subPdkWhiteList = new list<whiteListWrapper>();
        
        subPdkWhiteList = new list<accountwrapper>();
        if(SubPDK.Release_Status__c == 'Release to White list')
        { 
            wlpanel = true;
            findWhiteList();
        }
        
        PDKDesignSpec = new list<designSpecWrapper>();
        //Added for Patch Spec Start
        patchDesignSpec = new list<designSpecWrapper>();
        //Added for Patch Spec End
        findDesignSpec();
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
        
        if(sObjectName == 'sub_pdk__c')        
            query = query + ',pdk__c from ' + sObjectName;
        
        else
            query = query + ' from ' + sObjectName;
            
        return query;            
    }
    
    public void findWhiteList()
    {                                                 
        string subpdkid = subpdk.id;
        String query = createQueryString('White_List__c','WhiteListFields');  
        List<White_List__c> whitelist = new List<White_List__c>();
        whitelist = Database.query(query + ' where sub_pdk__c =: subpdkid order by name');
        
        mapAccountIdsToWhiteList = new map<Id,White_List__c>();
        
        for(White_List__c wlacc : whitelist)
        {
            accountidset.add(wlacc.account__c);
            mapAccountIdsToWhiteList.put(wlacc.account__c,wlacc);
        }
        
        List<account> acc = new list<account>();
        String query1 = createQueryString('Account','WhiteListFields');  
        acc = Database.query(query1 + ' where id in: accountidset order by name');
        
        if(!whiteList.isEmpty())
        {
            for(account a : acc)
            {
                //subPdkWhiteList.add(new whiteListWrapper(true,wl)); 
                subPdkWhiteList.add(new accountwrapper(true,a)); 
                accSelectedIds.add(a.Id);  
            }
        }        
    }
    
    public void findDesignSpec()
    {
        string pdkid = subpdk.pdk__c;
        string subpdkid = subpdk.id;
        String query = createQueryString('Design_Spec__c','SelectDesignSpec');             
        List<Design_Spec__c> PDKSpec = new List<Design_Spec__c>();
        PDKSpec = Database.query(query + ' where pdk__c =: PDKId');
        
        subpdkspecmap = new map<id,Sub_PDK_Spec__c>();        
        list<Sub_PDK_Spec__c> subPdkSpeclist = new list<Sub_PDK_Spec__c>();
        subPdkSpeclist = [select id,Design_Spec__c from Sub_PDK_Spec__c where sub_pdk__c =: subpdkid];                
        
        if(!subPdkSpeclist.isEmpty())
        {
            for(Sub_PDK_Spec__c x : subPdkSpeclist)
            {
                subpdkspecmap.put(x.Design_Spec__c,x);    
            }
        }
        
        if(!PDKSpec.isEmpty())
        {
            for(Design_Spec__c ds : PDKSpec)
            {
                if(subpdkspecmap.containsKey(ds.id))
                    PDKDesignSpec.add(new designSpecWrapper(true,ds));   
                    
                else    
                    PDKDesignSpec.add(new designSpecWrapper(false,ds));   
            }
        }
        
        //Added for Patch Spec Start
        List<Design_Spec__c> patchDesignSpecsList = new List<Design_Spec__c>();
        if(setPatchPDKIds!=null && setPatchPDKIds.size()>0){
            patchDesignSpecsList = Database.query(query + ' where pdk_patch__c IN: setPatchPDKIds');
        }
        
        if(!patchDesignSpecsList.isEmpty())
        {        
            for(Design_Spec__c ds : patchDesignSpecsList)
            {
                if(subpdkspecmap.containsKey(ds.id))
                    patchDesignSpec.add(new designSpecWrapper(true,ds));   
                    
                else    
                    patchDesignSpec.add(new designSpecWrapper(false,ds));        
            }
        } 
        //Added for Patch Spec End 
    }
    
    public void showWLAccountSection()
    {
        WLAccounts.clear();
        
        if(SubPDK.Release_Status__c == 'Release to White list')        
            wlpanel = true;    
                
        else        
            wlpanel = false;
    }
    
    public void clearSearch()
    {        
        searchString = null;
        accountSearchList.clear(); 
        editpanel = false;
        searchpanel = true;   
    }
    
    public boolean isTrue {get;set;} 
    
    public void validateStatus(){
        isTrue = false;
        // Check for master pdk design spec
        if (PDKDesignSpec!=null && !PDKDesignSpec.isEmpty()){
            for(designSpecWrapper pdk : PDKDesignSpec){
                // Added for CR 2590
                if(pdk.isChecked && pdk.designSpec.Release_Status__c.toUpperCase().trim()=='Internal Use Only'.toUpperCase().trim()){
                    isTrue = true;
                    //return null;
                }                
            }
        }
        //Check for patch design spec
        if (patchDesignSpec!=null && !patchDesignSpec.isEmpty()){
            for(designSpecWrapper pdk : patchDesignSpec){
                // Added for CR 2590
                if(pdk.isChecked && pdk.designSpec.Release_Status__c.toUpperCase().trim()=='Internal Use Only'.toUpperCase().trim()){
                    isTrue = true;
                    //return null;
                }                
            } 
        }            
    }
    
    public pagereference saveSubPdk()
    {
         try
        {
            if(SubPdk.Bundle_Name__c == null || SubPdk.Bundle_Name__c == '')
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the PDK Bundle Name'));
                return null; 
            }
            else if(SubPdk.Bundle_Name__c !=null && SubPdk.Bundle_Name__c.contains(':'))
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please do not use : in Bundle Name'));
                return null; 
            }
            if(SubPdk.Release_Status__c == null || SubPdk.Release_Status__c == '')
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select the Release Status'));
                return null; 
            }
            
            /*List<account> whiteListToDelete = new list<account>();
            list<Sub_PDK_Spec__c> subPdkSpeclistToDelete = new list<Sub_PDK_Spec__c>();
            list<Sub_PDK_Spec__c> subPdkSpeclistToInsert = new list<Sub_PDK_Spec__c>();*/
            
            List<Sub_PDK_Spec__c> subPDKSpec = new List<Sub_PDK_Spec__c>();
            List<White_List__c> whiteList = new List<White_List__c>();
            integer designSpecCount = 0;
            integer accountCount = 0;
            //Added for Patch Spec Start
            list<designSpecWrapper> allDesignSpec = new list<designSpecWrapper>();
            allDesignSpec.addAll(PDKDesignSpec);
            allDesignSpec.addAll(patchDesignSpec);
            //Added for Patch Spec End
            
            for(designSpecWrapper mds : allDesignSpec)
            {
                if(mds.isChecked)
                {
                    designSpecCount++;  
                } 
            }
            
            if(designSpecCount == 0)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select atleast one Design Spec'));
                return null;
            }
                
            if(SubPdk.Release_Status__c == 'Release to White list')
            {
                for(accountWrapper a : subPdkWhiteList)
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
            if (SubPdk.Release_Status__c.toUpperCase().trim() == 'General Release'.toUpperCase().trim()){
                // Check for master pdk design spec
                if (PDKDesignSpec!=null && !PDKDesignSpec.isEmpty()){
                    for(designSpecWrapper pdk : PDKDesignSpec){
                        if(pdk.isChecked && pdk.designSpec.Release_Status__c.toUpperCase().trim()!='General Release'.toUpperCase().trim()){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'General Release PDK can contain only General Release Specs.'));
                            return null;
                        }                
                    }
                }
                //Check for patch design spec
                if (patchDesignSpec!=null && !patchDesignSpec.isEmpty()){
                    for(designSpecWrapper pdk : patchDesignSpec){
                        if(pdk.isChecked && pdk.designSpec.Release_Status__c.toUpperCase().trim()!='General Release'.toUpperCase().trim()){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'General Release PDK can contain only General Release Specs.'));
                            return null;
                        }                
                    } 
                }            
            }
            
            // Mandatory check for secific account release with owner approval required for spec
             // Added for General release validation while creation of pdk from master pdk 
            if (!subPdk.Release_Status__c.equalsIgnoreCase('Specific Account Release with Spec owner Approval') && 
                !subPdk.Release_Status__c.equalsIgnoreCase('Release to White list')){
                // Check for master pdk design spec
                if (PDKDesignSpec!=null && !PDKDesignSpec.isEmpty()){
                    for(designSpecWrapper pdk : PDKDesignSpec){
                        if(pdk.isChecked && pdk.designSpec.Release_Status__c.equalsIgnoreCase('Specific Account Release with Spec owner Approval')){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,
                            'Specific Account Release with Spec owner Approval spec can only be included in bundle with release status Specific Account Release with Spec owner Approval or Release to White list.'));
                            return null;
                        }                
                    }
                }
                //Check for patch design spec
                if (patchDesignSpec!=null && !patchDesignSpec.isEmpty()){
                    for(designSpecWrapper pdk : patchDesignSpec){
                        if(pdk.isChecked && pdk.designSpec.Release_Status__c.equalsIgnoreCase('Specific Account Release with Spec owner Approval')){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,
                            'Specific Account Release with Spec owner Approval spec can only be included in bundle with release status Specific Account Release with Spec owner Approval or Release to White list.'));
                            return null;
                        }                
                    } 
                }            
            }
            
            SubPdk.Id=null;    
            SubPdk.Ready_For_Provisioning__c = false;
            SubPdk.Time_Req_To_Create_Association_In_OT__c = null;
            SubPdk.PDK_Failure_Specs__c = '';    
            insert SubPdk;
                                    
            for(designSpecWrapper mds : PDKDesignSpec)
            {
                if(mds.isChecked)
                {
                    Sub_PDK_Spec__c subSpec = new Sub_PDK_Spec__c();
                    subSpec.Design_Spec__c = mds.designSpec.id;
                    subSpec.Sub_PDK__c = SubPdk.id;
                    subPDKSpec.add(subSpec);    
                }    
            }
            
            //Added for Patch Spec Start
            for(designSpecWrapper pds : patchDesignSpec)
            {
                if(pds.isChecked)
                {
                    Sub_PDK_Spec__c subSpec = new Sub_PDK_Spec__c();
                    subSpec.Design_Spec__c = pds.designSpec.id;
                    subSpec.Sub_PDK__c = SubPdk.id;
                    subPDKSpec.add(subSpec);    
                }    
            }
            //Added for Patch Spec End
            
            if(SubPdk.Release_Status__c == 'Release to White list')
            {
                for(accountWrapper a : subPdkWhiteList)
                {
                    if(a.isChecked)
                    {
                        //accountCount++;   
                        White_List__c wl = new White_List__c();
                        wl.Account__c = a.accountFound.id;                    
                        wl.Sub_PDK__c = SubPdk.id;
                        wl.RecordTypeId = clsIntegrationUtil.fetchAllRecTypeIdsMap('White_List__c').get('PDK');
                        whiteList.add(wl);    
                    }    
                }
                /*if(accountCount == 0)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select atleast one Account'));
                    return null; 
                }*/                                      
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
                		SubPdk.Pdk_Spec_Associations__c = PdkSpecs;
                		update SubPdk;
                	}	
            	}
            }
            
            if(!whiteList.isEmpty())
            {
                insert whiteList;            
            } 
        }
        
        catch(Exception e)
        {
            system.debug('Exception ------------------------- ' + e);
            return null;
        }
        /*if(!subPdkWhiteList.isEmpty())
        {
            if(SubPDK.Release_Status__c == 'Release to White list')
            {
                for(accountWrapper wl : subPdkWhiteList)
                {
                    if(!wl.isChecked)
                        whiteListToDelete.add(wl.accountfound);    
                }    
            }
            
            else
            {
                for(accountWrapper wl : subPdkWhiteList)
                {                    
                    whiteListToDelete.add(wl.accountfound);    
                }                
            }
        }
        
        integer subPdkWhiteListSize = subPdkWhiteList.size();
        
        if(SubPDK.Release_Status__c == 'Release to White list' && (subPdkWhiteListSize == whiteListToDelete.size()))
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select atleast one Account'));
            return null; 
        } 
        
        list<Design_Spec__c> subPdkSpecUnchecked = new list<Design_Spec__c>();
        
        if(!PDKDesignSpec.isEmpty())
        {
            for(designSpecWrapper ds : PDKDesignSpec)
            {
                if(!ds.isChecked)
                    subPdkSpecUnchecked.add(ds.designSpec);
                
                if(ds.isChecked == false && subpdkspecmap.containsKey(ds.designSpec.id))
                    subPdkSpeclistToDelete.add(subpdkspecmap.get(ds.designSpec.id));    
            
                if(ds.isChecked == true && (!subpdkspecmap.containsKey(ds.designSpec.id)))
                {
                    Sub_PDK_Spec__c subSpec = new Sub_PDK_Spec__c();
                    subSpec.Design_Spec__c = ds.designSpec.id;
                    subSpec.Sub_PDK__c = SubPDK.id;
                    subPdkSpeclistToInsert.add(subSpec);
                }        
            }
        }
        
        integer subPdkSpecUncheckedSize = subPdkSpecUnchecked.size();
        
        if(subPdkSpecUncheckedSize == PDKDesignSpec.size())
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select atleast one Design Spec'));
            return null;
        }
        
        try
        {
            subPdk.Id=null;
            insert subPdk;
            
            if(!whiteListToDelete.isEmpty())
                delete whiteListToDelete;
                
            if(!subPdkSpeclistToDelete.isEmpty())
                delete subPdkSpeclistToDelete;
            
            if(!subPdkSpeclistToInsert.isEmpty())
                insert subPdkSpeclistToInsert;            
        }
        
        catch(Exception e)
        {
            system.debug('EXCEPTION ------------------ ' + e);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,''+e));
            return null;
        }*/
        
        return new pagereference('/'+SubPDK.id);
    }
    
    public void searchAccount()
    {                
        List<account> accountResult = new list<account>();
        
        accountSearchList = new list<accountwrapper>();
     
        if(searchString != null && searchString != '')
        {     
           /* String query = createQueryString('Account','WhiteListFields');  
            query = query + ' where name like ' + '\'%' + searchString + '%\'';
            if(accSelectedIds!=null && accSelectedIds.size()>0){
                query = query + ' AND Id NOT IN: accSelectedIds ';      
            } 
            query = query +  ' order by Name';                                     
            //string queryString = 'SELECT Id,Name,Stage__c FROM account where name like ' + '\'%' + searchString + '%\'' + ' order by Name';               
            accountResult = Database.Query(query);   */
/*---------------------------added for case 00038430 start-----------------------------------*/            
            string searchText='%'+searchString.toLowerCase()+'%';
           
           /* accountResult= [SELECT name,id,Site_Department__c,Stage__c,Parent_Account_Name__c,Parent_Account_Short_Name__c,Short_Name__c
                            FROM account 
                            WHERE (name like :searchText OR Short_Name__c like :searchText)
                            AND Id NOT IN: accSelectedIds]; */
                            
            accountResult= [SELECT name,id,Site_Department__c,Stage__c,Parent_Account_Name__c,Parent_Account_Short_Name__c,Short_Name__c
                            FROM account 
                            WHERE (name like :searchText OR Short_Name__c like :searchText)
                            AND Id NOT IN: accSelectedIds order by Short_Name__c ];//added for Case 42841  
                            
           if(accountResult.isEmpty())
            {
            
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Already added'));
             return;
            }  
            else
            {
            //do nothing
            }
           
/*---------------------------added for case 00038430 end-----------------------------------*/                        
        }
        
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a search string'));
            return;    
        }
        
        if(!accountResult.isEmpty())
        {
            for(account a : accountResult)
            {
                accountSearchList.add(new accountwrapper(false,a));        
            }
        }
    }
    
    public void addSelectedAccounts()
    {
        //subPdkWhiteList = new list<accountwrapper>();
        
        if(!accountSearchList.isEmpty()) 
        {
            for(accountwrapper a : accountSearchList)
            {
                if(a.isChecked)
                    subPdkWhiteList.add(a);
                    accSelectedIds.add(a.accountFound.Id);     
            }
        }
        
        if(subPdkWhiteList.isEmpty())
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

    public void cancelAddAccount()
    {
        searchstring = null;
        accountSearchList.clear();
        editpanel = true;
        searchpanel = false;
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
    
    public class designSpecWrapper
    {       
        public boolean isChecked{get;set;}
        public Design_Spec__c designSpec{get;set;}
        
        public designSpecWrapper(boolean x,Design_Spec__c y)
        {
            isChecked = x;
            designSpec = y;
        }
    }     
}