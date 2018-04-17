/*
Type Name: ClsEditSubPDK 
Author: Cognizant 
Created Date: 24-Aug-2013
Reason: 
Change History:
Reason: Change for CR # 00014659
Author: Cognizant 
Modified Date:07/04/2014
â€¦â€¦..
â€¦â€¦..
*/

public with sharing class ClsEditSubPDK {

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
    public set<id> accountidset;
    public map<id,White_List__c> mapAccountIdsToWhiteList; 
    public set<Id> accSelectedIds; 
    /**Added by Cognizant for CR # 00014659 starts**/  
    public Set<Id> provSpecSet=new Set<Id>();
    /**Added by Cognizant for CR # 00014659 ends**/  

    private map<id,Sub_PDK_Spec__c> subpdkspecmap;              
    private final Map<String, Schema.SObjectType> globalDescribe=Schema.getGlobalDescribe();
    
    public ClsEditSubPDK(ApexPages.StandardController controller) 
    {                    
        editpanel = true;
        wlpanel = false;
        searchpanel = false;
        accountSearchList = new list<accountwrapper>();
        accSelectedIds = new set<Id>();
        accountidset = new set<id>();
        
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
                if(subpdkspecmap.containsKey(ds.id)){ // Added by Cognizant for CR # 00014659
                    PDKDesignSpec.add(new designSpecWrapper(true,ds));
                    provSpecSet.add(ds.id); // Added by Cognizant for CR # 00014659
                }   // Added by Cognizant for CR # 00014659
                    
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
                    {// Added by Cognizant for CR # 00023420 
                    patchDesignSpec.add(new designSpecWrapper(true,ds));
                    provSpecSet.add(ds.id); // Added by Cognizant for CR # 00023420                    
                    }  // Added by Cognizant for CR # 00023420 
                    
                else    
                    patchDesignSpec.add(new designSpecWrapper(false,ds));        
            }
        } 
        //Added for Patch Spec End
    }
    
    public void showWLAccountSection()
    {
        //WLAccounts.clear();
        
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
        if(SubPdk.Bundle_Name__c == null || SubPdk.Bundle_Name__c == '')
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the PDK Bundle Name'));
            return null; 
        }
        
        if(SubPdk.Release_Status__c == null || SubPdk.Release_Status__c == '')
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select the Release Status'));
            return null; 
        }
        
        List<White_List__c> whiteListToInsert = new list<White_List__c>();
        List<White_List__c> whiteListToDelete = new list<White_List__c>();
        list<Sub_PDK_Spec__c> subPdkSpeclistToDelete = new list<Sub_PDK_Spec__c>();
        list<Sub_PDK_Spec__c> subPdkSpeclistToInsert = new list<Sub_PDK_Spec__c>();
        
        if(!subPdkWhiteList.isEmpty())
        {
            if(SubPDK.Release_Status__c == 'Release to White list')
            {
                for(accountWrapper wl : subPdkWhiteList)
                {
                    if(!wl.isChecked && wl.accountfound!=null && accountidset.contains(wl.accountfound.Id))
                        whiteListToDelete.add(mapAccountIdsToWhiteList.get(wl.accountfound.Id));
                        
                    else if(wl.isChecked && accountidset!=null && !accountidset.contains(wl.accountfound.Id)){
                        White_List__c newWhiteList = new White_List__c();
                        newWhiteList.Account__c = wl.accountfound.Id;
                        newWhiteList.Sub_PDK__c = SubPDK.Id;
                        newWhiteList.RecordTypeId = clsIntegrationUtil.fetchAllRecTypeIdsMap('White_List__c').get('PDK');
                        whiteListToInsert.add(newWhiteList);
                    }
                            
                }    
            }
            
            else
            {
                for(accountWrapper wl : subPdkWhiteList)
                {
                    if(accountidset.contains(wl.accountfound.Id))                   
                        whiteListToDelete.add(mapAccountIdsToWhiteList.get(wl.accountfound.Id));    
                }                
            }
        }
        
        integer subPdkWhiteListSize = subPdkWhiteList.size();
        
        
        if(SubPDK.Release_Status__c == 'Release to White list' && (subPdkWhiteListSize == whiteListToDelete.size()))
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select atleast one Account'));
            return null; 
        }
        else{
            System.debug(' Size of subPdkWhiteList is ' + subPdkWhiteList.size() + ' and list is ' + subPdkWhiteList);  
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
        
        //Added for Patch Spec Start
        if(!patchDesignSpec.isEmpty())
        {
            for(designSpecWrapper ds : patchDesignSpec)
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
        
        list<designSpecWrapper> allDesignSpec = new list<designSpecWrapper>();
        allDesignSpec.addAll(PDKDesignSpec);
        allDesignSpec.addAll(patchDesignSpec);
        //Added for Patch Spec End
        
        integer subPdkSpecUncheckedSize = subPdkSpecUnchecked.size();
        
        if(subPdkSpecUncheckedSize == allDesignSpec.size())
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select atleast one Design Spec'));
            return null;
        }
        
        try
        {
            // Added for General release validation while creation of pdk from master pdk 
            if (subPdk.Release_Status__c.toUpperCase().trim() == 'General Release'.toUpperCase().trim()){
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
            update subPdk;
        }
        catch(Exception e)
        {
        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'You do not have the proper permission to edit this PDK record.'));//commented by cognizant for the Case 00002585
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,''+e));//added by cognizant for the Case 00002585
         return null;
         
        }
        try{    
            if(!whiteListToDelete.isEmpty())
                delete whiteListToDelete;
                
            if(!whiteListToInsert.isEmpty())
                insert whiteListToInsert;
                
            if(!subPdkSpeclistToDelete.isEmpty())
                delete subPdkSpeclistToDelete;
            
            if(!subPdkSpeclistToInsert.isEmpty())
                insert subPdkSpeclistToInsert; 
                
            provisionHandlerForSelectedSpecs(); // Added by Cognizant for CR # 00014659
            // Added for deprovisioning of specs from bundle afeter editing bundle and desecting already provisioned specs 
            //Modified on 9th August 2014 by Navneet Rajput
            //deProvisionDesignSpecs();

        }
        
        catch(Exception e)
        {
            system.debug('EXCEPTION ------------------ ' + e);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,''+e));
            return null;
        }
        
        return new pagereference('/'+SubPDK.id);
    }
    
    public void searchAccount()
    {                
        List<account> accountResult = new list<account>();
        accountSearchList = new list<accountwrapper>();
     
        if(searchString != null && searchString != '')
        {     
            String query = createQueryString('Account','WhiteListFields');  
            query = query + ' where name like ' + '\'%' + searchString + '%\''; 
            if(accSelectedIds!=null && accSelectedIds.size()>0){
                query = query + ' AND Id NOT IN: accSelectedIds ';      
            } 
            query = query +  ' order by Name';                                     
            //string queryString = 'SELECT Id,Name,Stage__c FROM account where name like ' + '\'%' + searchString + '%\'' + ' order by Name';               
            accountResult = Database.Query(query);                  
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
     // Deprovisioning specs after edit pdk bundle.Addeded on 9th sept 2014 
/*
    public void deProvisionDesignSpecs(){
        system.debug('deProvisionDesignSpecs Called !!!!!!!!!!!!!');    
        Map<Id,List<Id>> dSpecUserLstMap = new Map<Id,List<Id>>();
        Set<Id> setOfUnCheckedDspecs = new Set<Id>();
        List<Document_Provisioning__c> pdkSpecsProvisioningList;
        // prepare set of unchecked design specs for deprovisioning
        if(PDKDesignSpec<>Null && !PDKDesignSpec.isEmpty()){
            for(designSpecWrapper  wrapObj : PDKDesignSpec){
                if(!wrapObj.isChecked){
                    setOfUnCheckedDspecs.add(wrapObj.designSpec.Id);
                }    
            }
        }
        system.debug('setOfUnCheckedDspecs>>>>>>>>>>>>>>>>>'+setOfUnCheckedDspecs);
        // prepare set of unchecked design specs for pdk patch specs 
        if(patchDesignSpec<>Null && !patchDesignSpec.isEmpty()){
            for(designSpecWrapper  wrapObj : patchDesignSpec){
                if(!wrapObj.isChecked){
                    setOfUnCheckedDspecs.add(wrapObj.designSpec.Id);
                }
            }
        }
    
        if(setOfUnCheckedDspecs<>Null && !setOfUnCheckedDspecs.isEmpty()){
            pdkSpecsProvisioningList = [Select User__c,
                                                Team_Rooms_Provisioned_for__c,
                                                Sub_PDK_Provisioned_for__c,
                                                Sub_PDK__c, 
                                                Status__c,
                                                Spec_Level_Provisioning__c,
                                                Packages_Provisioned_for__c,
                                                Package_OpenText_Id__c, 
                                                PDK_OpenText_Id__c,
                                                Name,
                                                Id, 
                                                Design_Spec__c,
                                                Last_Provisioned_By__c,
                                                Design_Spec_OpenText_Id__c, 
                                                Design_Package__c, 
                                                Contact__c, 
                                                Account__c
                                        from    Document_Provisioning__c 
                                        where   Design_Spec__c IN : setOfUnCheckedDspecs];
                                                    
        }
        
        if (pdkSpecsProvisioningList<>Null && !pdkSpecsProvisioningList.isEmpty()){
            for (Document_Provisioning__c docProv : pdkSpecsProvisioningList){
                if(docProv.Design_Spec__c<>Null){
                    if(!dSpecUserLstMap.containsKey(docProv.Design_Spec__c)){
                        dSpecUserLstMap.put(docProv.Design_Spec__c,new List<Id>());
                    }
                       dSpecUserLstMap.get(docProv.Design_Spec__c).add(docProv.User__c);
                }   
            }
        }   
        system.debug('dSpecUserLstMap>>>>>>>>>>>>>>>>>>>'+dSpecUserLstMap);
        // Call deprovisioning method for Specs  
        if (dSpecUserLstMap<>Null && !dSpecUserLstMap.isEmpty()){
            deProvisioningDesignSpecDP(dSpecUserLstMap,SubPDK.Id);
        }
    }
    
    // Method send deprovisioning request to OT
    public void deProvisioningDesignSpecDP(Map<Id,List<Id>> dSpecUserLstMap,Id bundleId){
        try{            
            List<Id> userIds = new List<Id>();
            List<Document_Provisioning__c> listOfDPRecords = new List<Document_Provisioning__c>();
            List<Document_Provisioning__c> listOfDPRecordsToUpdate = new List<Document_Provisioning__c>();
            
            List<String> listOfSubPdkIds = new List<String>();
            String updatedPdkIds='';
            
            for(Id uId : dSpecUserLstMap.keySet()){            
                //userIds = mapInputProvReq.get(recId);
                userIds.addAll(dSpecUserLstMap.get(uId));        
            }
            //if( ProvType.contains('Spec')){
            listOfDPRecords = [ SELECT id,
                                        name,
                                        User__c,
                                        Design_Spec__c,
                                        Team_Rooms_Provisioned_for__c, 
                                        Sub_PDK_Provisioned_for__c, 
                                        Packages_Provisioned_for__c
                                FROM    Document_Provisioning__c 
                                WHERE   User__c IN : userIds 
                                AND     Design_Spec__c IN : dSpecUserLstMap.keySet()];
                                
            System.debug('listOfDPRecords list ---'+ listOfDPRecords);
            if(listOfDPRecords<>Null && !listOfDPRecords.isEmpty()){
                for(Document_Provisioning__c dp : listOfDPRecords){
                    dp.Status__c = 'De-Provisioned';
                    dp.Spec_Level_Provisioning__c = false;
                    
                    if(dp.Sub_PDK_Provisioned_for__c<>Null && dp.Sub_PDK_Provisioned_for__c.contains(';')){
                        listOfSubPdkIds.addAll(dp.Sub_PDK_Provisioned_for__c.split(';'));
                        if (listOfSubPdkIds<>Null && !listOfSubPdkIds.isEmpty()){
                            for(Id sPdkId : listOfSubPdkIds){
                                if(sPdkId != bundleId){
                                    if(updatedPdkIds==''){
                                        updatedPdkIds = sPdkId;
                                    } else {
                                        updatedPdkIds = updatedPdkIds+';'+sPdkId;
                                    }
                                }
                            }
                            system.debug('sub pdk ids >>>>>>>>>>>>>>>>>>'+updatedPdkIds);
                        }
                    }
                    if (updatedPdkIds<>Null && updatedPdkIds!=''){
                        dp.Sub_PDK_Provisioned_for__c = updatedPdkIds;
                        //dp.Status__c = 'Provisioned';
                    }
                    listOfDPRecordsToUpdate.add(dp); 
                }
                System.debug('listOfDPRecords list ---'+ listOfDPRecords.size());
                system.debug('listOfDPRecordsToUpdate>>>>>>>>>>>>>>>>>'+listOfDPRecordsToUpdate);
                
                if(listOfDPRecordsToUpdate<>Null && !listOfDPRecordsToUpdate.isEmpty()){
                    update listOfDPRecordsToUpdate;
                }   
            }
            
        } catch (Exception e){
            system.debug('Exception :: '+e.getMessage());
        }    
    } 
 */   
    /* Added by Cognizant for CR # 00014659 starts*/

public void provisionHandlerForSelectedSpecs(){

Map<Id,List<Id>> provSpecUsrMap=new Map<Id,List<Id>>(); //Map of pdk and users who need to be provisioned
Map<Id,List<Id>> updProvSpecUsrMap=new Map<Id,List<Id>>();//Map of pdk and provisioned users 

List<Id> provUsrList =new List<Id>(); // List to hold user ids to be provisioned
List<Id> updProvUsrList =new List<Id>(); // List to hold provisioned user ids 
Set<Id> userIdSet=new Set<Id>(); // Set to hold user ids 
Set<Id> specIdSet=new Set<Id>(); // Set to hold spec ids 

// Code to check for design specs that need to be removed from PDK

/*Modified by Cognizant for  # 00023420 starts*/

for(designSpecWrapper  wrapObj : PDKDesignSpec)
{

if((!wrapObj.isChecked && provSpecSet.contains(wrapObj.designSpec.Id)) || (!provSpecSet.contains(wrapObj.designSpec.Id) && wrapObj.isChecked))
    specIdSet.add(wrapObj.designSpec.Id);
}


for(designSpecWrapper  wrapObj : patchDesignSpec)
{

if((!wrapObj.isChecked && provSpecSet.contains(wrapObj.designSpec.Id)) || (!provSpecSet.contains(wrapObj.designSpec.Id) && wrapObj.isChecked))
    specIdSet.add(wrapObj.designSpec.Id);
}



 // Code to populate list of users for provisioning the specs

List<Document_Provisioning__c> docProvList=[Select User__c, Team_Rooms_Provisioned_for__c,
                                            Sub_PDK_Provisioned_for__c, Sub_PDK__c, Status__c, Spec_Level_Provisioning__c,
                                            Packages_Provisioned_for__c, Package_OpenText_Id__c, 
                                            PDK_OpenText_Id__c, Name,
                                            Id, Design_Spec__c,Last_Provisioned_By__c,
                                            Design_Spec_OpenText_Id__c, Design_Package__c, 
                                            Contact__c, Account__c
                                            from Document_Provisioning__c where Sub_PDK__c =: subPDK.Id];

/*Modified by Cognizant for  CR # 00023420 ends*/

 for(Document_Provisioning__c dp:docProvList){ // Modified by Cognizant for  CR# 00023420
            if(dp.Status__c!='Provisioned' && dp.Status__c!='Sent For Approval'){
                provUsrList.add(dp.User__c);
            }
            else{
                updProvUsrList.add(dp.User__c);
            }
        }

            /* Code to eliminate duplicates in list starts*/
             userIdSet.addAll(provUsrList);
             provUsrList=new List<Id>(); //Modified for Case 18598
             provUsrList.addAll(userIdSet);
             
             //userIdSet.clear();//Commented for Case 18598
             userIdSet = new Set<Id>();  // Modified for Issue 18598 
             userIdSet.addAll(updProvUsrList);
             
         updProvUsrList=new List<Id>(); //Modified for Case 18598
             updProvUsrList.addAll(userIdSet);
             /* Code to eliminate duplicates in list ends*/

             
             /* Code to populate pdk and user list map starts*/
             
            if(!provUsrList.isEmpty())
            {

            
             provSpecUsrMap.put(subPDK.Id,provUsrList);
            }
            if(!updProvUsrList.isEmpty())               
            {
            
                        
                        updProvSpecUsrMap.put(subPDK.Id,updProvUsrList);

            }
             /* Code to populate pdk and user list map ends*/

                /* Code to provision specs starts*/

                    if(!provSpecUsrMap.isEmpty()){
                        ClsProvisioningHandler controller = new ClsProvisioningHandler();
                        controller.handleProvisioningForEditPdk(provSpecUsrMap,'EditSubPDK',specIdSet,docProvList);//Modified by Cognizant for  CR # 00023420 
                    }

                if(!updProvSpecUsrMap.isEmpty()){
                        ClsProvisioningHandler controller = new ClsProvisioningHandler();
                        controller.handleProvisioningForEditPdk(updProvSpecUsrMap,'EditSubPDK',specIdSet,docProvList);//Modified by Cognizant for  CR # 00023420 
                    }
                    
                /* Code to provision specs ends*/

}
      /* Added by Cognizant for CR # 00014659 ends*/
  
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