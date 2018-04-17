/*
Type Name: FV_EditSubPDK 
Author: Cognizant 
Created Date: 24-Aug-2013
Reason: 
Change History:
Reason: Change for CR # 00014659
Author: Cognizant 
Modified Date:07/04/2014
Modified by :- navneet on 17 nov 2014 realign,commenting and created new methods for auto provisioning/deprovisioning
Description :- To support after update auto document provisioning/de-provisioning  
Modified Date:5/09/2017
Modified By :-Dinesh Suggala (Global Foundries)
Description:- Added the code for pagination 
Modified Date: 14/9/2017
Modified By:- Dinesh Suggala (Global Foundries)
Description:- Added the Custom Setting
Author:Dinesh Suggala(Global Foundries)
Modified Date:3/10/2017
Reason:Added Order By Keyqord in SOQL Line 3/10/2017 
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

public without sharing class FV_EditSubPDK {

    public sub_pdk__c subPDK{get;set;}
    string subpdkid;
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
    public Set<Id> provSpecSet=new Set<Id>();
    private map<id,Sub_PDK_Spec__c> subpdkspecmap;              
    private final Map<String, Schema.SObjectType> globalDescribe=Schema.getGlobalDescribe();
    public Boolean isReadyForProvisioning{get;set;}
 //   public List<SelectOption> RelStatSeloption{get; set;}
 //   Public string selectedGeneralStat{get; set;}
    
    // Added by Dinesh 24/8/2017
    public Integer counter = 0;//TO track the number of records parsed
    public Integer limitSize;//Number of records to be displayed
    public Integer totalSize =0; //To Store the total number of records available
    public integer pageNum{get;set;}
    public list<designSpecWrapper> showPDKDesignSpec{get;set;}
    
    public FV_EditSubPDK(ApexPages.StandardController controller) {

        editpanel = true;
        wlpanel = false;
        isReadyForProvisioning = false;
        searchpanel = false;
        accountSearchList = new list<accountwrapper>();
        accSelectedIds = new set<Id>();
        accountidset = new set<id>();
        String query = createQueryString('sub_pdk__c','InputFields'); 
        subpdkid = controller.getId();
        subPDK = new sub_pdk__c(); 
        subPDK = Database.query(query + ' where id =: subpdkid limit 1');
        if(subPDK.Ready_For_Provisioning__c)
            isReadyForProvisioning = true;
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot modify the PDK bundle until the "Ready For Provisioning" flag is checked. Please see "Time Req To Create Association In OT" for processing time estimation.');
            ApexPages.addMessage(myMsg);                
        }       
        //Added for Patch Spec Start 
        setPatchPDKIds = new set<String>();
        for(PDK_Patch__c objPatch:[Select Id, PDK__c, Patch_PDK_Lifecycle_Phase__c from PDK_Patch__c where PDK__c=:subPDK.PDK__c and Patch_PDK_Lifecycle_Phase__c!='Obsolete']){
            setPatchPDKIds.add(objPatch.Id);            
        }
        subPdkWhiteList = new list<accountwrapper>();
        if(SubPDK.Release_Status__c == 'Release to White list'){
            wlpanel = true;
            //Prepare white list
            getWhiteList();
        }
        
        PDKDesignSpec = new list<designSpecWrapper>();
        //Added for Patch Spec Start
        patchDesignSpec = new list<designSpecWrapper>();
        //Added for Patch Spec End
        findDesignSpec();
        
        //Added by Dinesh 24/8/2017
        totalSize=PDKDesignSpec.size();
        pageNum=1;                                               //Added by Dinesh 26/12/2017 Case #84497
		PDKPagination__c rp= PDKPagination__c.getValues('1');    //Added by Dinesh on 14/9/2017
        String recordsperpage= rp.RecordsPerPage__c;             //Added by Dinesh on 14/9/2017
        limitSize=Integer.ValueOf(recordsperpage);               //Added by Dinesh on 14/9/2017
        
        showPDKDesignSpec= new list<designSpecWrapper>();
        if((counter+limitSize) <= totalSize){
            for(Integer i=0;i<limitSize;i++){
                showPDKDesignSpec.add(PDKDesignSpec.get(i));
            }
        }else{
            for(Integer i=0;i<totalSize;i++){
                showPDKDesignSpec.add(PDKDesignSpec.get(i));
            }
        }
            //*******Release_Status__c logic 
     /*   selectedGeneralStat = subPDK.Release_Status__c;
        RelStatSeloption=new List<SelectOption>();
        List<Sub_PDK_Release_Status_Setting__c>  PDKRelStConfigList= Sub_PDK_Release_Status_Setting__c.getall().values();
        if(subPDK.pdk__r.Master_PDK_ASIC__c ){
            for(Sub_PDK_Release_Status_Setting__c PDKRelStCofigObj: PDKRelStConfigList){
                if(PDKRelStCofigObj.ASIC_Business__c){
                    RelStatSeloption.add(new SelectOption(PDKRelStCofigObj.Release_Status__c,PDKRelStCofigObj.Release_Status__c));
                }
            }
        }else{
            for(Sub_PDK_Release_Status_Setting__c PDKRelStCofigObj:PDKRelStConfigList){
            
               // if(!PDKRelStCofigObj.ASIC_Business__c){
                    RelStatSeloption.add(new SelectOption(PDKRelStCofigObj.Release_Status__c,PDKRelStCofigObj.Release_Status__c));
              //  }
            }
        }
        RelStatSeloption.add(0,new SelectOption('None','--None--')); */
        //******* 
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
            query = query + ',PDK_Patch_Name__c'; 
        }
        //Added for Patch Spec End
        
        if(sObjectName == 'sub_pdk__c')        
            query = query + ',Ready_For_Provisioning__c,pdk__c,PDK_Event__c,pdk__r.Master_PDK_ASIC__c  from ' + sObjectName;
        
        else
            query = query + ' from ' + sObjectName;
            
        return query;            
    }
    
    public void getWhiteList(){
        system.debug('Inside getWhitelist Method >>>>>>>>> ');                                                
        //string subpdkid = subpdk.id;
        List<account> lstOfAcc = new list<account>();
        List<White_List__c> whitelist = new List<White_List__c>();
        mapAccountIdsToWhiteList = new map<Id,White_List__c>();
        
        String query = createQueryString('White_List__c','WhiteListFields');  
        system.debug('query>>>>>>>>>>>>>>>>>>.'+query);
        whitelist = Database.query(query + ' where sub_pdk__c =: subpdkid order by name');
        if (whitelist<>NULL && !whitelist.isEmpty()){
            for(White_List__c wlacc : whitelist){
                accountidset.add(wlacc.account__c);
                mapAccountIdsToWhiteList.put(wlacc.account__c,wlacc);
            }
            String query1 = createQueryString('Account','WhiteListFields');  
            lstOfAcc = Database.query(query1 + ' where id in: accountidset order by name');
            if (lstOfAcc<>NULL && !lstOfAcc.isEmpty()){
                for(account a : lstOfAcc){
                    subPdkWhiteList.add(new accountwrapper(true,a)); 
                    // Prepare list of already existing Account white list
                    accSelectedIds.add(a.Id); 
                }
            }
        }
    }
    
    public void findDesignSpec(){
        system.debug('findDesignSpec >>>>>>>>');    
        string pdkid = subpdk.pdk__c;
        string subpdkid = subpdk.id;
        List<Design_Spec__c> PDKSpec = new List<Design_Spec__c>();
        subpdkspecmap = new map<id,Sub_PDK_Spec__c>();        
        list<Sub_PDK_Spec__c> subPdkSpeclist = new list<Sub_PDK_Spec__c>();

        String query = createQueryString('Design_Spec__c','SelectDesignSpec');
        //AND Lifecycle_Phase__c != '+ '\''+ 'OBSOLETE' + '\'             
        PDKSpec = Database.query(query + ' where pdk__c =: PDKId ' + 'Order By Document_Number__c,Revision__c ASC');              //Order By Keyword Added by Dinesh 3/10/2017
        
        subPdkSpeclist = getSubPdkSpeclist(subpdkid);
                                            
        if(subPdkSpeclist<>NULL && !subPdkSpeclist.isEmpty()){
            for(Sub_PDK_Spec__c x : subPdkSpeclist){
                // This is a map of Spec and Pdk association
                subpdkspecmap.put(x.Design_Spec__c,x);    
            }
        }
        
        if(PDKSpec<>NULL && !PDKSpec.isEmpty()){
            //PDKSpec is list of design specs which are comes under master pdk only
            for(Design_Spec__c ds : PDKSpec){
                //subpdkspecmap is map which is holding key as design spec id and value as subpdkspec association record.
                // This map is for selected sub pdk
                if(subpdkspecmap<>Null && subpdkspecmap.containsKey(ds.id)){ 
                    // Below design specs are available in selected Bundle
                    // Set pdk spec check box as true(checked)
                    PDKDesignSpec.add(new designSpecWrapper(true,ds));
                    // We need to remove below set for Account level provisioning
                    provSpecSet.add(ds.id); // Added by Cognizant for CR # 00014659
                } else {   
                    // Spec which is not currently selected in PDK bundle
                    PDKDesignSpec.add(new designSpecWrapper(false,ds));
                }   
            }
        }
        //Added for Patch Spec Start
        List<Design_Spec__c> patchDesignSpecsList = new List<Design_Spec__c>();
        if(setPatchPDKIds!=null && setPatchPDKIds.size()>0){
            // Patch spec id set is already prepared and it is specific to PDK
            patchDesignSpecsList = Database.query(query + ' where pdk_patch__c IN: setPatchPDKIds');
        }
        
        if(patchDesignSpecsList<>NULL && !patchDesignSpecsList.isEmpty()){
            for(Design_Spec__c ds : patchDesignSpecsList){
                //subpdkspecmap is Association of spec and PDK Association record. It is map of
                // Spec Id and subPDKSpec records which are under subPDK
                if(subpdkspecmap.containsKey(ds.id)){
                    patchDesignSpec.add(new designSpecWrapper(true,ds));
                    // Set of Design Specs which are already available and may be already provisioned
                    provSpecSet.add(ds.id);                     
                }  else {   
                    patchDesignSpec.add(new designSpecWrapper(false,ds));  
                }        
            }
        } 
    }
    
    // Show/Hide Account section and it will be available only bundle is of type White list bundle
    public void showWLAccountSection() {
        
     //   subPDK.Release_Status__c = selectedGeneralStat;
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
    
    public void searchAccount(){
        
        List<account> accountResult = new list<account>();
       
        accountSearchList = new list<accountwrapper>();
        if(searchString != null && searchString != ''){
           /* String query = createQueryString('Account','WhiteListFields');  
            query = query + ' where name like ' + '\'%' + searchString + '%\''; 
            if(accSelectedIds!=null && accSelectedIds.size()>0){
                query = query + ' AND Id NOT IN: accSelectedIds ';      
            } 
            query = query +  ' order by Name';                                     
            accountResult = Database.Query(query);*/
            
/*---------------------------added for case 00038430 start-----------------------------------*/            
            string searchText='%'+searchString.toLowerCase()+'%';
            
            
           /* accountResult= [SELECT name,id,Site_Department__c,Stage__c,Parent_Account_Name__c,Parent_Account_Short_Name__c,Short_Name__c
                            FROM account 
                            WHERE (name like :searchText OR Short_Name__c like :searchText)
                            AND Id NOT IN: accSelectedIds]; */
                            
             accountResult= [SELECT name,id,Site_Department__c,Stage__c,Parent_Account_Name__c,Parent_Account_Short_Name__c,Short_Name__c,ASIC_Business_Flag__c
                            FROM account 
                            WHERE (name like :searchText OR Short_Name__c like :searchText)
							AND (RecordType.Name IN('Customer','Enablement Partner' ,'Reseller','GLOBALFOUNDRIES Internal') OR (RecordType.Name='Suppliers' AND Supplier_Type__c='Manufacturing Vendor'))
							AND Id NOT IN: accSelectedIds order by Short_Name__c]; 
                            
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
                              
        } else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a search string'));
            return;    
        }
        
        if(accountResult<>NULL && !accountResult.isEmpty()){
            for(account a : accountResult){
                accountSearchList.add(new accountwrapper(false,a));        
            }
        }
    }
    
    public void addSelectedAccounts() {
        if(!accountSearchList.isEmpty()) {
            for(accountwrapper a : accountSearchList){
                if(a.isChecked){
                    subPdkWhiteList.add(a);
                    accSelectedIds.add(a.accountFound.Id); 
                }       
            }
        }
        if(subPdkWhiteList.isEmpty()){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select atleast one account'));
            return;
             
        } else {
            accountSearchList.clear();
            searchString = null;
            editpanel = true;
            searchpanel = false;
        }           
    }

    public void cancelAddAccount(){
        searchstring = null;
        accountSearchList.clear();
        editpanel = true;
        searchpanel = false;
    }
    
    // Below method is use to validate if spec added in to bundle is Internal release spec 
    // It will not be provisioned to customers
    public boolean isTrue {get;set;} 
    
    public void validateStatus(){
        isTrue = false;
        // Check for master pdk design spec
        if (showPDKDesignSpec!=null && !showPDKDesignSpec.isEmpty()){
            for(designSpecWrapper pdk : showPDKDesignSpec){
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
    
    // code check if bundle status is changed from any release status to release to white list
    // if bundle is provision to accounts then need to be  get deprovision
    public void statusChangeToWL(Sub_PDK__c SubPdk,Map<Id,Id> accIdMap){
        //if(SubPdk.Release_Status__c.toUpperCase().trim()=='Release to White list'.toUpperCase().trim()){
        system.debug('accIdMap>>>>>>>>>>>'+accIdMap);
        List<ID> accIds = new List<ID>();
        //Boolean isChanged=false;
        List<White_List__c> lstOfWL = new List<White_List__c>();
        if(SubPdk !=null)
            lstOfWL = [SELECT Account__c from White_List__c where Sub_PDK__c =: SubPdk.id];
        if(lstOfWL.size()>0){
            for(White_List__c wL : lstOfWL)
                accIdMap.put(wL.Account__c,wL.Account__c);  
        }
        List<Document_Provisioning__c> listOfDpRecords =[SELECT Id,Status__c,AccountID__c
                                                        FROM Document_Provisioning__c
                                                        WHERE Sub_PDK__c =:subpdkid 
                                                        AND Status__c = 'Provisioned'
                                                        AND AccountID__c NOT IN : accIdMap.values()];
                                                        
        system.debug('listOfDpRecords>>>>>>>>>>'+listOfDpRecords);
                                                        
        if(listOfDpRecords<>NULL && !listOfDpRecords.isEmpty()){                                                
            for(Document_Provisioning__c DP : listOfDpRecords){
                //if(!accIdMap.containsKey(DP.AccountID__c)){
                    accIds.add(DP.AccountID__c);    
                //}
            }
            if(accIds<>NULL && !accIds.isEmpty()){
                FV_DocumentProvisioningUtil.deprovisionPDK(SubPdk.Id,accIds);
            }
        }                                           
    }
    
    // code check if bundle status is changed from any release status to Internal Release
    // if bundle is provision to accounts then need to be  get deprovision
    public boolean statusChangeToInternal(Sub_PDK__c SubPdk){
       // if(SubPdk.Release_Status__c.toUpperCase().trim()=='Internal Use Only'.toUpperCase().trim()){
        Boolean isChanged=false;
        subPdkWhiteList = new list<accountwrapper>();
        List<White_List__c> lstOfWL = new List<White_List__c>();
        if(SubPdk !=null)
            lstOfWL = [SELECT Account__c from White_List__c where Sub_PDK__c =: SubPdk.id];
        if(lstOfWL.size()>0){
            delete lstOfWL;
        }
        List<ID> accIds = new List<ID>();
        List<Document_Provisioning__c> listOfDpRecords =[SELECT Id,Status__c,AccountID__c
                                                        FROM Document_Provisioning__c
                                                        WHERE Sub_PDK__c =:subpdkid]; 
                                                        //Status__c = 'Provisioned'
                                                        //AND AccountID__c IN : accList
        if(listOfDpRecords<>NULL && !listOfDpRecords.isEmpty()){                                                
            for(Document_Provisioning__c DP : listOfDpRecords){
                if(DP.Status__c=='Provisioned'){
                    accIds.add(DP.AccountID__c);
                }
            }
            if(accIds<>NULL && !accIds.isEmpty()){
                FV_DocumentProvisioningUtil.deprovisionPDK(SubPdk.Id,accIds);
            }   
            subPdk.Ready_For_Provisioning__c = false;
            subPdk.Time_Req_To_Create_Association_In_OT__c = null;
            list<Sub_PDK_Spec__c> subPdkSpecs = getSubPdkSpeclist(subPdk.id);
            String PdkSpecs = '';
            if(subPdkSpecs!=null && subPdkSpecs.size()>0){
                for(Sub_PDK_Spec__c PDKSpec: subPdkSpecs){
                        if(PdkSpecs == '' || PdkSpecs == NULL)
                            PdkSpecs = PDKSpec.id+':'+PDKSpec.OTID__c+':'+PDKSpec.Design_Spec_OpenTextId__c;        
                        else
                            PdkSpecs = PdkSpecs+';'+PDKSpec.id+':'+PDKSpec.OTID__c+':'+PDKSpec.Design_Spec_OpenTextId__c;   
                    }
                }
                if(PdkSpecs!='' && PdkSpecs!=null)
                    subPdk.Pdk_Spec_Associations__c = PdkSpecs;
            // update bundle status
            update SubPdk;
            // delete all document provisioning record related to selected pdk bundle
            //delete listOfDpRecords;
            isChanged=true;
        }   
        return isChanged;                                       
       // }
    }
    
    public list<Sub_PDK_Spec__c> getSubPdkSpeclist(String subpdkid){
        return [select id,Design_Spec__c,Design_Spec__r.Name,Sub_PDK__c,OTID__c,Design_Spec__r.Release_Status__c,
                Design_Spec__r.OpenText_ID__c,Design_Spec__r.Specification_Type__c,Design_Spec__r.Document_Title__c,Design_Spec_OpenTextId__c 
                from Sub_PDK_Spec__c 
                where sub_pdk__c =: subpdkid];
    }
    
    // Method used to update sub pdk and responsible of add/remove specs from bundle 
    // as well as responsible for provision/deprovision budle as well as design specs
    public pagereference saveSubPdk(){
        
     //   subPDK.Release_Status__c = selectedGeneralStat; 
        system.debug('Inside saveSubPdk >>>>>>>>>>>');
        Boolean isChanged;
        subPdk.PDK_Event__c =  null;
        
        if(SubPdk.Bundle_Name__c == null || SubPdk.Bundle_Name__c == ''){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please enter the PDK Bundle Name'));
            return null; 
        }
        else if(SubPdk.Bundle_Name__c !=null && SubPdk.Bundle_Name__c.contains(':'))
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please do not use : in Bundle Name'));
            return null; 
        }
        if(SubPdk.Release_Status__c == null || SubPdk.Release_Status__c == ''){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select the Release Status'));
            return null; 
        }
        
        if(SubPdk.Release_Status__c.toUpperCase().trim()=='Internal Use Only'.toUpperCase().trim()){
            isChanged = statusChangeToInternal(SubPdk);
            if(isChanged){
                return new pagereference('/'+SubPDK.id);
            }
        }
        
        /*if(SubPdk.Release_Status__c.toUpperCase().trim()=='Release to White list'.toUpperCase().trim()){
            isChanged = statusChangeToWL(SubPdk);
            if(isChanged){
                return new pagereference('/'+SubPDK.id);
            }
        }*/
        
        List<White_List__c> whiteListToInsert = new list<White_List__c>();
        set<ID> WhiteListIDsInserted = new set<ID>();
        List<White_List__c> whiteListToDelete = new list<White_List__c>();
        list<Sub_PDK_Spec__c> subPdkSpeclistToDelete = new list<Sub_PDK_Spec__c>();
        list<Sub_PDK_Spec__c> subPdkSpeclistToInsert = new list<Sub_PDK_Spec__c>();
        list<Design_Spec__c> subPdkSpecUnchecked = new list<Design_Spec__c>();
        List<ID> accsToDeprovision = new List <ID>();
        Map<String,String> mapOfSpecIdSpecName = new Map<String,String>();
        List<Account> accsToProvision = new List<Account>();
        Map<Id,Id> selectedWlAccs = new Map<Id,Id>();
        Savepoint sp;
        Savepoint savePt;
        system.debug('<<<<<<<!!!1'+subPdkWhiteList);
        if(subPdkWhiteList<>NULL && !subPdkWhiteList.isEmpty()){
            if(SubPDK.Release_Status__c == 'Release to White list'){
                for(accountWrapper wl : subPdkWhiteList){
                    //accountidset is set of whitelist account ids
                    if(!wl.isChecked && wl.accountfound!=null && accountidset<>NULL && accountidset.contains(wl.accountfound.Id)){
                        // Prepare the list of white list accounts to delete it from PDK whilte list related object
                        // and if already provisioned specs for these accounts then need to deprovision those specs as well
                        whiteListToDelete.add(mapAccountIdsToWhiteList.get(wl.accountfound.Id));
                        accsToDeprovision.add(wl.accountfound.Id);
                        
                    } else if(wl.isChecked && accountidset!=null && accountidset<>NULL && !accountidset.contains(wl.accountfound.Id)){
                        // Prepare the new white list accounts which are not present earlier and recently added in to Whitelist of 
                        // PDK bundle
                        White_List__c newWhiteList = new White_List__c();
                        newWhiteList.Account__c = wl.accountfound.Id;
                        newWhiteList.Sub_PDK__c = SubPDK.Id;                      
                        newWhiteList.RecordTypeId = clsIntegrationUtil.fetchAllRecTypeIdsMap('White_List__c').get('PDK');
                        // If PDK bundle is already provisioned then newly account need to be auto provisioned for 
                        // all specs inside PDK bundle
                        whiteListToInsert.add(newWhiteList);
                        //accsToProvision.add(wl.accountfound);
                        selectedWlAccs.put(wl.accountfound.Id,wl.accountfound.Id);
                    }
                } 
                if(selectedWlAccs<>NULL && !selectedWlAccs.isEmpty()){
                    statusChangeToWL(SubPDK,selectedWlAccs);
                }
                   
            } else {
                // If release status is changed from white list to any other release status then all whitelist accounts need to 
                // be deleted and if bundle is already provisioned then need to remove bundle as well as spec level provisioning
                for(accountWrapper wl : subPdkWhiteList) {
                    if(accountidset.contains(wl.accountfound.Id)){   
                        // accounts delte from whitelist as well as deprovision from PDK                 
                        whiteListToDelete.add(mapAccountIdsToWhiteList.get(wl.accountfound.Id));
                        accsToDeprovision.add(wl.accountfound.Id);  
                    }      
                }    
                system.debug('accsToDeprovision>>>>>>>>>>>>>> '+accsToDeprovision);            
            }
        }
        // inforce to select at least one whitelist account if release status is release to whitelist 
        integer subPdkWhiteListSize = subPdkWhiteList.size();
        if(SubPDK.Release_Status__c == 'Release to White list' && whiteListToDelete<>NULL 
            && (subPdkWhiteListSize == whiteListToDelete.size())){
                
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select atleast one Account'));
            return null; 
            
        } else{
            System.debug(' Size of subPdkWhiteList is ' + subPdkWhiteList.size() + ' and list is ' + subPdkWhiteList);  
        } 
        
        if(PDKDesignSpec<>NULL && !PDKDesignSpec.isEmpty()){
            for(designSpecWrapper ds : PDKDesignSpec){
                if(!ds.isChecked){
                    subPdkSpecUnchecked.add(ds.designSpec);
                    if(subpdkspecmap.containsKey(ds.designSpec.id)){
                        // Use this list for deprovisioning specs and delete of subpdkspec association
                        subPdkSpeclistToDelete.add(subpdkspecmap.get(ds.designSpec.id));    
                    }
                } else {   
                    if(!subpdkspecmap.containsKey(ds.designSpec.id)){
                        Sub_PDK_Spec__c subSpec = new Sub_PDK_Spec__c();
                        subSpec.Design_Spec__c = ds.designSpec.id;
                        subSpec.Sub_PDK__c = SubPDK.id;
                        // Use this list of spec for auto provisioninng these are newly added.
                        subPdkSpeclistToInsert.add(subSpec);
                    }
                }              
            }
        }
        
        //Added for Patch Spec Start
        if(patchDesignSpec<>NULL && !patchDesignSpec.isEmpty()){
            for(designSpecWrapper ds : patchDesignSpec){
                if(!ds.isChecked){
                    subPdkSpecUnchecked.add(ds.designSpec);
                    if(subpdkspecmap<>NULL && subpdkspecmap.containsKey(ds.designSpec.id)){
                        subPdkSpeclistToDelete.add(subpdkspecmap.get(ds.designSpec.id));    
                    }
                } else {
                    if(subpdkspecmap<>NULL && !subpdkspecmap.containsKey(ds.designSpec.id)){
                        Sub_PDK_Spec__c subSpec = new Sub_PDK_Spec__c();
                        subSpec.Design_Spec__c = ds.designSpec.id;
                        subSpec.Sub_PDK__c = SubPDK.id;
                        subPdkSpeclistToInsert.add(subSpec);
                    }
                }            
            }
        }
        
        list<designSpecWrapper> allDesignSpec = new list<designSpecWrapper>();
        map<ID,String>  existingWhitelist = new map<ID,String>();
        allDesignSpec.addAll(PDKDesignSpec);
        allDesignSpec.addAll(patchDesignSpec);
        //Added for Patch Spec End
        Integer subPdkSpecUncheckedSize;
        if(subPdkSpecUnchecked<>NULL && !subPdkSpecUnchecked.isEmpty()){
            subPdkSpecUncheckedSize = subPdkSpecUnchecked.size();
        }
        if(allDesignSpec<>NULL && subPdkSpecUncheckedSize == allDesignSpec.size()) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select atleast one Design Spec'));
            return null;
        }
        
        try {
            sp = Database.setSavepoint();
            // Added for General release validation while creation of pdk from master pdk 
            if (subPdk.Release_Status__c.toUpperCase().trim() == 'General Release'.toUpperCase().trim()){
                // Check for master pdk design spec
                if (showPDKDesignSpec!=null && !showPDKDesignSpec.isEmpty()){
                    for(designSpecWrapper pdk : showPDKDesignSpec){
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
                if (showPDKDesignSpec!=null && !showPDKDesignSpec.isEmpty()){
                    for(designSpecWrapper pdk : showPDKDesignSpec){
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
            
        }
        catch(Exception e){
            Database.rollback(sp);
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'You do not have the proper permission to edit this PDK record.'));//commented by cognizant for the Case 00002585
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,''+e));//added by cognizant for the Case 00002585
             return null;
        }
        try{    
            savePt = Database.setSavepoint();
            Boolean isTrue = false;
            Integer cnt  = [SELECT count() FROM Document_Provisioning__c WHERE Sub_PDK__c =: subPdk.Id 
                            AND Status__c IN ('Provisioned','De-Provisioning In Progress','Provisioning In Progress')];
            if(cnt>0){
                system.debug('Specs earlier selected and not selection removed>>> subPdkSpeclistToDelete>>>>>>>>>>>>>>>>>'+subPdkSpeclistToDelete);    
                if(subPdkSpeclistToDelete<>NULL && !subPdkSpeclistToDelete.isEmpty()){
                    Set<Id> setOfPdkIds = new Set<Id>();
                    if(SubPDK.Id!=null)
                        setOfPdkIds.add(SubPDK.Id);
                    isTrue = FV_DocumentProvisioningUtil.deProvisionUpdatePDKforSpecRemove(setOfPdkIds,subPdkSpeclistToDelete);//changed for new design for PLM status change
                    /*if (isTrue){
                        /*Integer start = System.Now().millisecond();
                        while(System.Now().millisecond()< start+1000){ 
                        }*/
                        delete subPdkSpeclistToDelete;
                    /*} else {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,
                                            'Bundle update is not possible because provisioning/de-provisioning is in progress.'));
                        return null;                    
                    }*/
                    //SpecsToSendForDeprovision();
                }    
                system.debug('New Specs need to insert in bundle >>>>>>>>>>'+subPdkSpeclistToInsert);
                if(subPdkSpeclistToInsert<>NULL && !subPdkSpeclistToInsert.isEmpty()){
                    //database.setSavepoint(sp1);
                    insert subPdkSpeclistToInsert;
                    //system.debug('<<<<<<<subPdkSpeclistToInsert'+subPdkSpeclistToInsert);
                    //isTrue = FV_DocumentProvisioningUtil.updatePdkProvisioning(SubPDK,subPdkSpeclistToInsert);
                    //system.debug('<<<<<<<isTrue::'+isTrue);
                    /*if (isTrue){ 
                        //Do nothing
                    } else {
                        database.rollback(savePt);
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,
                                            'Bundle update is not possible because provisioning/de-provisioning is in progress.'));
                        return null;                    
                    }*/
                }
                system.debug('WhiteList to delete from existing >>>>>>>>.'+whiteListToDelete);
                if(whiteListToDelete<>NULL && !whiteListToDelete.isEmpty()) {
                   if(SubPDK!=null && SubPDK.Release_Status__c!='Specific Account Release')
                    isTrue = FV_DocumentProvisioningUtil.deprovisionPDK(SubPDK.id, accsToDeprovision);
                    /*if(isTrue){
                        delete whiteListToDelete;
                    } else {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,
                                            'Cannot remove whitelist account because provisioning/de-provisioning is in progress.'));
                        return null;
                    }*/
                    delete whiteListToDelete;
                }    
                system.debug('New White List Accounts to Insert>>>>>>>>>>'+whiteListToInsert);    
                if(whiteListToInsert<>NULL && !whiteListToInsert.isEmpty()) {
                    insert whiteListToInsert;
                    // Call common PDK provisioning class
                    // As per the new CR we should not auto provision newly added Account in to whitelist

                    //FV_DocumentProvisioningUtil.provisionNewPDK(SubPDK, accsToProvision);                    
                    List< White_List__c> lstWL = [Select ID,Account__c,Account__r.Short_Name__c From White_List__c Where Id IN : whiteListToInsert];                        
                    Map<Id,Id> mapOfIds = new Map<Id,Id>();
                    if(lstWL<>NULL && lstWL.isEmpty()){
                        for (White_List__c accId : lstWL){
                            WhiteListIDsInserted.add(accId.ID);
                            mapOfIds.put(accId.Account__c,accId.Account__c);                            
                        }
                    }
                    if(mapOfIds<>NULL && !mapOfIds.isEmpty()){
                        statusChangeToWL(SubPDK,mapOfIds);
                    }
                }

            }else{
                if(subPdkSpeclistToInsert<>NULL && !subPdkSpeclistToInsert.isEmpty()){
                    insert subPdkSpeclistToInsert;
                } 
                if(subPdkSpeclistToDelete<>NULL && !subPdkSpeclistToDelete.isEmpty()){
                        delete subPdkSpeclistToDelete;
                }
                if(whiteListToDelete<>NULL && !whiteListToDelete.isEmpty()) {
                        delete whiteListToDelete;
                }
                if(whiteListToInsert<>NULL && !whiteListToInsert.isEmpty()) {
                    insert whiteListToInsert;
                }   
            }
            if(!whiteListToInsert.isEmpty()){
            List< White_List__c> lstWL2 = [Select ID,Account__c,Account__r.Short_Name__c From White_List__c Where Id IN : whiteListToInsert];
                for (White_List__c accId : lstWL2){                                               
                    existingWhitelist.put(accId.ID,''+accId.Account__r.Short_Name__c);                                                                        
                }
            }            
                        
            if (subPdk<>NULL){
                subPdk.Ready_For_Provisioning__c = false;
                subPdk.Time_Req_To_Create_Association_In_OT__c = null;
                list<Sub_PDK_Spec__c> subPdkSpecs = getSubPdkSpeclist(subPdk.id);
                String PdkSpecs = '';
                if(subPdkSpecs!=null && subPdkSpecs.size()>0){
                    for(Sub_PDK_Spec__c PDKSpec: subPdkSpecs){
                    mapOfSpecIdSpecName.put(PDKSpec.Design_Spec__c,PDKSpec.Design_Spec__r.Name); 
                        if(PdkSpecs == '' || PdkSpecs == NULL){
                            if(PDKSpec.OTID__c==null)
                                PdkSpecs = PDKSpec.id+':NONE:'+PDKSpec.Design_Spec_OpenTextId__c;
                            else
                                PdkSpecs = PDKSpec.id+':'+PDKSpec.OTID__c+':'+PDKSpec.Design_Spec_OpenTextId__c;    
                        }   
                        else{
                            if(PDKSpec.OTID__c==null)   
                                PdkSpecs = PdkSpecs+';'+PDKSpec.id+':NONE:'+PDKSpec.Design_Spec_OpenTextId__c;
                            else
                                PdkSpecs = PdkSpecs+';'+PDKSpec.id+':'+PDKSpec.OTID__c+':'+PDKSpec.Design_Spec_OpenTextId__c;
                        }   
                    }
                }
                if(PdkSpecs!='' && PdkSpecs!=null)
                    subPdk.Pdk_Spec_Associations__c = PdkSpecs;


                // Audit History tracking
                string s1 = '';
                string s2 = '';
                string s3 = '';
                string s4 = '';
                if(subPdkSpeclistToInsert<>NULL && !subPdkSpeclistToInsert.isEmpty()){                    
                    for(Sub_PDK_Spec__c subPdkSpec : subPdkSpeclistToInsert){
                        if(String.isEmpty(s1))
                            s1= mapOfSpecIdSpecName.get(subPdkSpec.Design_Spec__c);
                        else{
                            s1= s1+','+'\n'+mapOfSpecIdSpecName.get(subPdkSpec.Design_Spec__c);
                            break;
                        }                         
                    }
                   s1 = '['+s1+' added'+']'+'\n';                                     
                }
                else{                                                           
                        s1 = s1+' [No Spec added]'+'\n';                     
                }
                
                if(subPdkSpeclistToDelete<>NULL && !subPdkSpeclistToDelete.isEmpty()){                     
                    for(Sub_PDK_Spec__c subPdkSpec : subPdkSpeclistToDelete){
                         if(String.isEmpty(s2))
                            s2 = subPdkSpec.Design_Spec__r.name;
                        else{
                            s2 = s2+','+'\n'+subPdkSpec.Design_Spec__r.name;
                            break;
                        }                         
                    }
                      s2 = '[' +s2+' removed'+']'+'\n';
                      
                }
                else{                                       
                         s2 = s2+' [No Spec removed]'+'\n';                 
                }
                               
                if(whiteListToInsert<>NULL && !whiteListToInsert.isEmpty()) {                                                      
                    for(White_List__c whiteList : whiteListToInsert){                                                
                         if(String.isEmpty(s3))
                            s3 = ''+existingWhitelist.get(whiteList.ID);
                        else
                            s3 = s3+','+'\n'+existingWhitelist.get(whiteList.ID);                                                                            
                    }                                    

                      s3 = '['+s3+' White List Added '+']'+'\n';                      
                } 
                else{                                             
                           s3 = s3+' [No White List added]'+'\n';                    
                }
                               
                if(whiteListToDelete<>NULL && !whiteListToDelete.isEmpty()) {
                    for(White_List__c whiteList : whiteListToDelete){
                         if(String.isEmpty(s4))
                            s4 = whiteList.Account_Short_Name__c;
                        else
                            s4 = s4+','+whiteList.Account_Short_Name__c;                                                                            
                    }             
                    s4 = '['+s4+ ' White List Removed '+']'+'\n';                                        
                }
                else{                                                                        
                         s4 = s4+' [No White List removed]'+'\n';                         
                }
                subPdk.PDK_Event__c = s1+ ',' +s2+ ','+ s3+ ',' +s4;
                if(subPdk.PDK_Event__c!=null && subPdk.PDK_Event__c.length()>255){                   
                    subPdk.PDK_Event__c = subPdk.PDK_Event__c.substring(0,255);    
                }                 
                update subPdk;
            }  
        }
        catch(Exception e){
            Database.rollback(savePt);
            system.debug('EXCEPTION ------------------ ' + e);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,''+e));
            return null;
        }
       // Audit History tracking        
        return new pagereference('/'+SubPDK.id);
    }
    
   //Added by Dinesh 29/8/2017
   
    public integer getTotalPages(){
        Decimal pages;
        pages = PDKDesignSpec.size()/limitSize==0?1:PDKDesignSpec.size()*1.0/limitSize;                 //Added by Dinesh 26/12/2017 Case#84497
        return (Integer)Math.ceil(pages);
     }
    
    public void beginning(){
   
        showPDKDesignSpec.clear();
        counter=0;
        pageNum=counter+1;                                 //+1 Added by Dinesh 26/12/2017 Case #84497
        if((counter + limitSize) <= totalSize){
       
            for(Integer i=0;i<limitSize;i++){
                showPDKDesignSpec.add(PDKDesignSpec.get(i));
            }   
           
        } else{
       
            for(Integer i=0;i<totalSize;i++){
                showPDKDesignSpec.add(PDKDesignSpec.get(i));
            }       
           
        }
       
     }
   
    public void next(){
   
        showPDKDesignSpec.clear();
        counter=counter+limitSize;
        pageNum++;
        if((counter+limitSize) <= totalSize){
            for(Integer i=counter;i<(counter+limitSize);i++){
                showPDKDesignSpec.add(PDKDesignSpec.get(i));
            }
        } else{
            for(Integer i=counter;i<totalSize;i++){
             showPDKDesignSpec.add(PDKDesignSpec.get(i));
            }
        }
      }
   
    public void previous(){
        
        showPDKDesignSpec.clear();
        pageNum--;
        counter=counter-limitSize;       
       
        for(Integer i=counter;i<(counter+limitSize); i++){      
         showPDKDesignSpec.add(PDKDesignSpec.get(i));
        }
       
      }

    public void last (){
   
        showPDKDesignSpec.clear();
        
        if(math.mod(totalSize , limitSize) == 0){
            counter = limitSize * ((totalSize/limitSize)-1);
        } else if (math.mod(totalSize , limitSize) != 0){
            counter = limitSize * ((totalSize/limitSize));
        }
        pageNum=(Integer)Math.ceil(totalSize*1.0/limitSize);
        for(Integer i=counter;i<totalSize;i++){             
         showPDKDesignSpec.add(PDKDesignSpec.get(i));
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
    // Code End By Dinesh 29/8/2017
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