public with sharing class GFSSetFieldHistoryController{
    public Map<string,string> objLabelNameMap;
    public List<selectOption> objLabelOptions{get;set;}
    public string selectedObject{get;set;}
    public Map<string,string> fieldLabelMap;
    public List<fieldWrapper> fieldWrapperList{get;set;}
    public Set<string> existingHistoryObj;
    public List<Set_Field_History__c> SFH;
    public GFSMetadataService.MetadataPort service;
    public string baseURL{get;set;}
    public string Host{get; set;}
    public string sfields{get;set;}
    public boolean isAccessible{get;set;}
    public boolean remoteSiteSetupRequired{get; set;}  
    public boolean selectAllFields{get; set;}
    public boolean renderFieldsPanel{get;set;}
    public string objectEndpointURL{get; set;}      
    public boolean selectAllFieldFlag{get;set;}
    public boolean showStdProfiles{get; set;}
    private string namespace;
                
    public List<string> leftselected{get;set;}
    public List<string> rightselected{get;set;}
    Set<string> leftvalues = new Set<string>();
    Set<string> rightvalues = new Set<string>();
    
    public list<Set_Field_History__c> existingRecords{get;set;}
    public class LayoutWrapper{
        public boolean chkVal{get; set;}
        public string layoutName{get; set;}
    }                         
    public list<LayoutWrapper> layoutWrapperlist{get;set;}
    
    public GFSSetFieldHistoryController(){
        selectAllFields = false;
        renderFieldsPanel = false;
        selectAllFieldFlag = false;
        showStdProfiles = false;
        isAccessible = true;
        remoteSiteSetupRequired  = false;
        leftselected = new list<string>();
        rightselected = new list<string>();
        layoutWrapperlist = new list<LayoutWrapper>();
        fetchRemoteSiteUrls();
        list<GFS_Configuration__c> configs = [Select Id, Name from GFS_Configuration__c where Name=:userinfo.getUserId()];
        list<User> userdetails = [Select Id, name, ProfileId, Profile.Name from User where Id=:userinfo.getUserId()];
        if(userdetails.size() > 0 && userdetails[0].Profile.Name == 'System Administrator'){
            isAccessible = true;
        }else if(configs.size() > 0){        
            isAccessible = true;
        }else{
            isAccessible = false;
        }
        
        //Fetch existing records
        existingRecords =  new list<Set_Field_History__c>();
        existingRecords = [select Id,Name,FieldNameList__c,Profiles__c,Layouts__c from Set_Field_History__c];       
        for(Set_Field_History__c f: existingRecords){
            string fieldLabels = '';
            Schema.DescribeSobjectResult[] results = Schema.describeSObjects(new string[]{f.Name});
                for(Schema.SObjectField sfield : results[0].fields.getMap().values()){
                    Schema.describefieldresult fdes = sfield.getDescribe(); 
                    for(string fname: f.FieldNameList__c.split('#')){
                        if(fdes.getName() == fname)
                            fieldLabels += fdes.getLabel()+', ';
                    }                      
                }
                f.FieldNameList__c = fieldLabels;
            }
    }
    
    public void checkNamespace(){
        namespace = Label.GFSFieldHistoryNamespace;          
    }
    
    public void fetchRemoteSiteUrls(){
        if(!GFSSetFieldHistoryHelper.checkMetadataAPIConnection()) remoteSiteSetupRequired = true;
        Host = ApexPages.currentPage().getHeaders().get('Host');
        map<string, string> sandboxMap = GFSSetFieldHistoryHelper.createSandboxMap();      
                  
        Organization org = [select id,IsSandbox,InstanceName from Organization limit 1];   
        objectEndpointURL = 'https://'+Host;
        string sandboxNameold = '',sandboxNameNew = '';
        if(org.IsSandbox){
            sandboxNameold = UserInfo.getUserName().substringAfterLast('.');   
            if(sandboxMap.containsKey(sandboxNameold))
                sandboxNameNew = sandboxMap.get(sandboxNameold);
            else{
                list<GFS_Sandbox_Configuration__c> currentsandbox = [Select id, Name from GFS_Sandbox_Configuration__c limit 1];
                if(currentsandbox.size() > 0)
                   sandboxNameNew = currentsandbox[0].Name;                     
            }
            baseURL = 'https://globalfoundries--'+sandboxNameNew+'.'+org.InstanceName.tolowercase()+'.my.salesforce.com';
        }else{
            baseURL = URL.getSalesforceBaseUrl().toExternalForm().split('visual.force.com')[0];
            if(baseURL.indexOf(namespace+'.') > 0)
                baseURL = 'https://'+baseURL.split(namespace+'.')[1]+'salesforce.com';
            else
                baseURL += 'salesforce.com';
            system.debug('>>>>>>>>baseURL:'+baseURL);
        } 
        system.debug('>>>>>>>>baseURL:'+baseURL);            
        if(!remoteSiteSetupRequired){
            doneClicked();
        }          
    }        
    
    public void doneClicked(){ 
        remoteSiteSetupRequired = false;            
        objLabelNameMap = new Map<string,string>();
        objLabelOptions = new List<selectOption>();
        existingHistoryObj = new Set<String>();
        SFH = new List<Set_Field_History__c>();       
        
        objLabelOptions.add(new SelectOption('','--None--'));
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();
        for(Schema.SObjectType f : gd){
            system.debug('>>>>>>>>>>>>>f.getDescribe():'+f.getDescribe());
             if(!f.getDescribe().isCustomSetting() && f.getDescribe().getRecordTypeInfos().size() > 0 && f.getDescribe().isCreateable() && f.getDescribe().getName() != 'MacroInstruction' &&
            f.getDescribe().getName() != 'Event' && f.getDescribe().getName() != 'Task' && f.getDescribe().getName() != 'CollaborationGroup' && f.getDescribe().getName() != 'AssetRelationship' && f.getDescribe().getName() != 'CollaborationGroupRecord' &&
            f.getDescribe().getName() != 'CampaignMember' && f.getDescribe().getName() != 'ContentVersion' && f.getDescribe().getName() != 'DuplicateRecordSet' && f.getDescribe().getName() != 'DuplicateRecordItem' && f.getDescribe().getName() != 'SearchPromotionRule' &&
        !f.getDescribe().getLabel().contains('History') && !f.getDescribe().getLabel().contains('tag') && !f.getDescribe().getLabel().contains('share') && !f.getDescribe().getLabel().contains('feed')){
                objLabelNameMap.put(f.getDescribe().getLabel(), f.getDescribe().getName());
                objLabelOptions.add(new SelectOption(f.getDescribe().getLabel(),f.getDescribe().getLabel()));
            }
        }
        objLabelOptions.sort();                                
    }
            
    public PageReference selectclick(){
        rightselected.clear();
        for(String s : leftselected){
            leftvalues.remove(s);
            rightvalues.add(s);
        }
        return null;
    }
     
    public PageReference unselectclick(){
        leftselected.clear();
        for(String s : rightselected){
            rightvalues.remove(s);
            leftvalues.add(s);
        }
        return null;
    }
 
    public List<SelectOption> getunSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftvalues);
        tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
        return options;
    }
 
    public void selectAllFieldsOfObject(){
        if(selectAllFieldFlag){
            for(fieldWrapper fw :fieldWrapperList){
                if(fw.fieldType == '')
                    fw.fieldCheck = true;
            }
        }else{
            for(fieldWrapper fw :fieldWrapperList){
                fw.fieldCheck = false;
            }        
        }
    } 
    public List<SelectOption> getSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightvalues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }

    public void FieldList(){
        renderFieldsPanel = true;
        remoteSiteSetupRequired = false;
        fieldLabelMap = new Map<string,string>();
        fieldWrapperList = new List<fieldWrapper>();
        Set<String> existingFieldTrack = new Set<String>();
        Set<String> newFieldTrack = new Set<String>();
        List<String> fieldLabelList = new List<String>();
        Set<string> stdObjStdFieldSet = new Set<String>();
        rightvalues = new set<string>();
        set<Id> profileIds = new set<Id>();
        system.debug('>>>>>>>>>>>selectedObject:'+selectedObject);
        if(selectedObject != null && Schema.SobjectType.Set_Field_History__c.isAccessible()){
            SFH = [select Id,Name,FieldNameList__c,Profiles__c,Layouts__c,All_Layouts__c from Set_Field_History__c where Name=:objLabelNameMap.get(selectedObject) limit 1];
            system.debug('SFH**'+SFH);
            if(SFH.size() != 0){
                if(Schema.SobjectType.Set_Field_History__c.fields.FieldNameList__c.isAccessible()){
                    for(string s : SFH[0].FieldNameList__c.split('#')){
                        existingFieldTrack.add(s);
                    }
                }
                if(Schema.SobjectType.Set_Field_History__c.fields.Layouts__c.isAccessible() && SFH[0].Layouts__c != null)      
                     for(string s : SFH[0].Layouts__c.split('#')){
                        LayoutWrapper wrapper = new LayoutWrapper();
                        wrapper.chkVal = true;
                        wrapper.layoutName = s;
                        layoutWrapperlist.add(wrapper);
                    }            
            }
            
            Schema.DescribeSobjectResult[] results = Schema.describeSObjects(new List<String>{objLabelNameMap.get(selectedObject)});
            system.debug('>>>>>>>results:'+results[0].fields.getMap().values());

            system.debug('SFH**'+SFH);
            for(Schema.SObjectField sfield: results[0].fields.getMap().values()){
                schema.describefieldresult f = sfield.getDescribe();                    
                    system.debug('field Type** '+f.getLabel()+' '+f.getType());
                    if(f.getType() == Schema.DisplayType.ADDRESS || f.getLabel() =='Informal Name' || f.getLabel() =='Middle Name' || f.getLabel() == 'Suffix')
                        continue;
                    if(!(!f.isNillable() && f.isCreateable() && !f.isDefaultedOnCreate())){
                        fieldLabelMap.put(f.getLabel(),f.getName());
                        if(f.getType() == Schema.DisplayType.TEXTAREA && f.getLength() > 255)
                            fieldLabelList.add(f.getLabel()+':TEXTAREA');
                        else
                            fieldLabelList.add(f.getLabel());
                    }
            }
            fieldLabelList.sort();
            for(string s : fieldLabelList){
                if(existingFieldTrack.contains(fieldLabelMap.get(s))){
                    fieldWrapperList.add(new fieldWrapper(s,true,''));
                }
                else{
                    if(s.contains('TEXTAREA'))
                        fieldWrapperList.add(new fieldWrapper(s.split(':')[0],false,'TEXTAREA'));
                    else
                        fieldWrapperList.add(new fieldWrapper(s,false,''));
                }
            }            
        }
    }
    
    public Pagereference saveChanges(){   
        system.debug('>>>>>>>>>>>>>>SFH:'+SFH);   
        system.debug('>>>>>>>>>>>>>>fieldWrapperList:'+fieldWrapperList);         
        list<string> objectFields = new list<string>();
        
        string selectedLayouts = '';
        string allLayouts = '';
        integer layoutCounter = 0;
        for(LayoutWrapper wrapper: layoutWrapperlist){
            if(wrapper.chkVal){
                selectedLayouts += wrapper.layoutName+'#';      
                layoutCounter++;
            }
            allLayouts += wrapper.layoutName+'#';         
        }
        selectedLayouts = selectedLayouts.substring(0, selectedLayouts.length()-1);
        system.debug('>>>>>>>>>>>selectedLayouts :'+selectedLayouts);
        if(layoutCounter == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please select Layout'));
            return null;
        }
        
        if(layoutCounter > 5){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Can not select more than 5 layouts'));
            return null;        
        }      

        SFH = [select Id,Name,FieldNameList__c,Profiles__c,Layouts__c from Set_Field_History__c where Name=:objLabelNameMap.get(selectedObject) limit 1];
        system.debug('>>>>>>>>>>>>SFH:'+SFH);
        if(SFH.size()>0){
            string fSet = SFH[0].FieldNameList__c;
            string newfSet='';
            for(fieldWrapper fw :fieldWrapperList){
                if(fw.fieldCheck){
                    newfSet += fieldLabelMap.get(fw.fieldName)+'#';
                }
            }
            if(Schema.SobjectType.Set_Field_History__c.fields.FieldNameList__c.isUpdateable())
                SFH[0].FieldNameList__c = newfSet;          
            if(Schema.SobjectType.Set_Field_History__c.fields.Layouts__c.isUpdateable())
                SFH[0].Layouts__c = selectedLayouts;
            if(Schema.SobjectType.Set_Field_History__c.fields.All_Layouts__c.isUpdateable())
                SFH[0].All_Layouts__c = allLayouts;
            if(Schema.SobjectType.Set_Field_History__c.isUpdateable())
                update SFH;
            
            GFSFieldHistoryProfileBatch b = new GFSFieldHistoryProfileBatch(objLabelNameMap.get(selectedObject),userinfo.getSessionId(),userinfo.getUserEmail(),SFH[0].Id);
            Database.executeBatch(b,5);                   

        }else{
            string newfSet='';
            for(fieldWrapper fw :fieldWrapperList){
                if(fw.fieldCheck){
                    newfSet += fieldLabelMap.get(fw.fieldName)+'#';
                }
            }

            Set_Field_History__c sfhNew = new Set_Field_History__c();
            sfhNew.Name = objLabelNameMap.get(selectedObject);
            if(Schema.SobjectType.Set_Field_History__c.fields.FieldNameList__c.isCreateable())
                sfhNew.FieldNameList__c = newfSet;           
            if(Schema.SobjectType.Set_Field_History__c.fields.Layouts__c.isCreateable())
                sfhNew.Layouts__c = selectedLayouts;
            if(Schema.SobjectType.Set_Field_History__c.fields.All_Layouts__c.isCreateable())
                sfhNew.All_Layouts__c = allLayouts;    
            
            if(Schema.SobjectType.Set_Field_History__c.isCreateable())
                insert sfhNew; 
                       
            GFSFieldHistoryObjectBatch b = new GFSFieldHistoryObjectBatch(sfhNew.Id,baseURL,userinfo.getSessionId(),userinfo.getUserEmail(),selectedObject);
            Database.executeBatch(b,1);                      
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'The Object history processing is in progress. A status email will be sent to you once process is completed.'));
        PageReference pg = new PageReference('/apex/GFSsetFieldHistory');
        pg.setRedirect(true);
        return pg;
    }
    
    public Pagereference cancel(){
        PageReference pg = new PageReference('/apex/GFSsetFieldHistory');
        pg.setRedirect(true);
        return pg;
    }
    
    public PageReference nextPage(){
        sfields = '';
        if(selectedObject == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please select Object'));    
            return null;
        }
    
        for(fieldWrapper fw :fieldWrapperList){
            if(fw.fieldCheck){
                sfields += fw.fieldName+', ';
            }
        }
        if(sfields == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please select Fields'));    
            return null;
        }

        if(sfields != '')
            sfields = sfields.substring(0, sfields.length()-2);
         
        //Fetch selected object layouts
        list<string> pagelayouts = GFSSetFieldHistoryHelper.retrievePageLayouts(objLabelNameMap.get(selectedObject));
        map<string, LayoutWrapper> layoutWrapperMap = new map<string, LayoutWrapper>();
        for(LayoutWrapper w: layoutWrapperlist)
            layoutWrapperMap.put(w.layoutName, w);
        
        layoutWrapperlist = new list<LayoutWrapper>();
        
        for(string layout: pagelayouts){
            LayoutWrapper wrapper = new LayoutWrapper();
            if(layoutWrapperMap.containsKey(layout)){ 
                wrapper = layoutWrapperMap.get(layout);              
            }else{
                wrapper.chkVal = false;
                wrapper.layoutName = layout;            
            }
            layoutWrapperlist.add(wrapper);            
        }
        system.debug('>>>>>>>>layoutWrapperlist:'+layoutWrapperlist);                    
        PageReference pg = Page.GFSFieldHistoryProfile;
        pg.setRedirect(false);
        return pg;
    }       
    
    public class fieldWrapper{
        public string fieldName{get;set;}
        public boolean fieldCheck{get;set;}
        public string fieldType{get;set;}
        
        public fieldWrapper(string name,boolean check, string ftype){
            fieldName = name;
            fieldCheck = check;
            fieldType = ftype;
        }
    }
}