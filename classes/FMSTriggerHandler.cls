/*
* @ Author :- Anil Kumar Reddy L
* @ Description :- Trigger handler class for FMSTrigger 
* @ Date :- 25/08/2016
* @ Change History :-  
*Inshu Misra|26-08-2016|Added email notification functionality on form creation/updation/deletion
*Inshu Misra|6-12-2016|Added exception handling framework code...#IM
*Anil Kumar Reddy L | 7-12-2016 | Added method to Delete FMS subsciptions if FMS record gets deleted.
*Ram | 6-28-2017 | Added for SP form
*Anirban Roy | 6-28-2017 | Modified for code review comments
*Anirban Roy | 7-12-2017 | Modified for SP Search and Subscription
*Inshu Misra | 7-14-2017 | Form History Issue
*Ram Rai |7-15-2017 | Step Plan Reviewers Email Issue #423
*Inshu Misra | 7-17-2017 | Step Plan Reviewers Email Issue against #423 and Form history issue related field label verbage change against issue#446
*Ram Rai |7-20-2017 | Record sharing logic
*Inshu Misra | 7-19-2017 | Step Plan Reviewers Email Issue against #423
*Anirban Roy | 7-21-2017 | modified against Subscription related changes
*Ram Rai |8-11-2017| My Subscription Tab multiple data showing
*Ram Rai |9-1-2017| Modified Code for Subscription Issue 
**/
public class FMSTriggerHandler extends TriggerHandler{     
    public FMSRecordShareClass recShare {get;set;}
    public final String FMS_SELECT_VAL = EnvironmentVariable.get('FMS_SELECT_VALUE');
    public final String FMS_SP_FORM = EnvironmentVariable.get('FMS_SP_FORM');
    public final String FMS_MAIN_FORM = EnvironmentVariable.get('FMS_MAIN_FORM');
    public static Boolean isRunOnce = false;
    public list<Form_Management_System__c> spList = new list<Form_Management_System__c>();
    
    public List<FMS_Subscription__c> fmsSubscibeList ; //Ravindra - Moved from FMSFormSubscription method
    public FMS_My_Subscription__c fmsMySub;  //Ravindra - Moved from FMSFormSubscription method    
    public List<FMS_Subscription__c> fmsUpdateSubscibeList ; //Ravindra -- Add for updating form Id on existing subscription
    public List<FMS_My_Subscription__c> fmsMySubList ;
    public FMSTriggerHandler(){
        recShare = new FMSRecordShareClass();      
    }    
    //Modified by Anirban for sharing issue
    public override void afterInsert(){
        if(!IntegrationUserUtil.isSkipTrigger()){ 
            fmsAfterInsert((Map<Id,Form_Management_System__c>)trigger.newMap);
            recShare.sharePortalRecord(trigger.new);
        }       
    }
    //Modified by Anirban for sharing issue
    public override void afterUpdate(){
        if(!IntegrationUserUtil.isSkipTrigger() && !isRunOnce){ 
            fmsAfterUpdate(trigger.new,(Map<Id,Form_Management_System__c>)trigger.newMap,(Map<Id,Form_Management_System__c>)trigger.oldMap);
        }
    }
    
    
    public override void beforeInsert(){
        if(!IntegrationUserUtil.isSkipTrigger()){ 
			createTimeStampMap(trigger.new);
            fmsBeforeInsert(trigger.new);
        }
    }    
    
    public override void beforeDelete(){
        if(!IntegrationUserUtil.isSkipTrigger()){ 
            fmsAfterDelete((Map<Id,Form_Management_System__c>)trigger.newMap,(Map<Id,Form_Management_System__c>)trigger.oldMap);
        }
    } 
    
    
    public void fmsBeforeInsert(List<Form_Management_System__c> fmsNewRecordList){
        FMSSPParntIdMapping(fmsNewRecordList);
    }
    
    Public void fmsAfterInsert(Map < id, Form_Management_System__c > fmsNewRecordMap){
    // Modified by Anirban on 7/12/2017 for SP Search and Subscription Hierarchy (Issue # 387)
    formSpFormParentUpdate(fmsNewRecordMap.values());
        formSystemInsertHistoryTracker(fmsNewRecordMap.values());
        fmsFormSubscription(fmsNewRecordMap);
        fmsFormSearchSubscription(fmsNewRecordMap);
        if(!IntegrationUserUtil.isSkipNotification()){ // 09072017  Anirban Check added for skipping notification for integration user with skip notification checked   
        sendNotificationToSubscribers(fmsNewRecordMap, null, Label.Form_Create_Email);
    }
        FMSFutureCallClass.updateDeviceFMSID(fmsNewRecordMap.keySet());
        
    }
    
    Public override void beforeUpdate(){
        createTimeStampMap(trigger.new);
    }
    
    public void createTimeStampMap(List<Form_Management_System__c> fmsNewRecordList){
        for(Form_Management_System__c f:fmsNewRecordList){
            f.ExternalHistory_Key__c=UtilityCls.sysUnixTimeStamp;
        }
    }
    
    Public void fmsAfterUpdate(List < Form_Management_System__c > fmsNewList, Map < id, Form_Management_System__c > fmsNewRecordMap, Map < Id, Form_Management_System__c > fmsOldRecordMap){
        
        fmsDevicePTUpdation(fmsNewRecordMap,fmsOldRecordMap);
        formSystemUpdateHistoryTracker(fmsNewRecordMap.values(), fmsOldRecordMap);
        fmsFormSubscription(fmsNewRecordMap);
        UtilityCls.createContent(fmsNewList);
        fmsFormSearchSubscription(fmsNewRecordMap);
    if(!IntegrationUserUtil.isSkipNotification()){ // 09072017  Anirban Check added for skipping notification for integration user with skip notification checked   
            sendNotificationToSubscribers(new Map < Id, Form_Management_System__c > (fmsNewList), fmsOldRecordMap, Label.Form_Edit_Email);   
    }
    }
    
    Public void fmsAfterDelete(Map < id, Form_Management_System__c > fmsNewRecordMap, Map < Id, Form_Management_System__c > fmsOldRecordMap){
    //commented against Issue 423...#IM
        //sendNotificationToSubscribers(fmsNewRecordMap, fmsOldRecordMap, Label.Form_Delete_Email);
        fmsFormDeletedSubscription(fmsOldRecordMap);
    }
    
    public void formSystemUpdateHistoryTracker(List < Form_Management_System__c > fmsNewRecordList, Map < Id, Form_Management_System__c > fmsOldRecordMap){
        
        List < Form_System_History__c > fieldChanges = new List < Form_System_History__c > ();
        List < Form_System_History__c > fieldHistory = new List < Form_System_History__c > ();
//        Map<Id,User> usrMap = new  Map<Id,User>([SELECT Id, Name FROM User]);    
        Set<Id> modifierUserIds = new Set<Id>();
        for(Form_Management_System__c newValue: fmsNewRecordList){
            modifierUserIds.add(newValue.LastModifiedById);
            if(fmsOldRecordMap != null && fmsOldRecordMap.get(newValue.Id) != null){
                modifierUserIds.add(fmsOldRecordMap.get(newValue.Id).LastModifiedById);
            }
        }
        Map<Id,User> usrMap = new  Map<Id,User>([SELECT Id, Name FROM User where Id in: modifierUserIds]);    
        Set < id > formId = new Set < id > ();
        
        
        for (Form_Management_System__c fmsRecordNewValue: fmsNewRecordList){
            final Form_Management_System__c fmsRecordOldValue = fmsOldRecordMap.get(fmsRecordNewValue.Id);
            Map < String, String > fmsFieldsMap = getFMSFields();
            for (String fieldName: fmsFieldsMap.Keyset()){
                //14-7-17 History Issue: Corrected the condition...#IM
                if(FMSFieldNotRequiredTracking__c.getAll().keySet().contains(fieldName)){
                    continue;
                }
                
                String oldValue = String.valueOf(fmsRecordOldValue.get(fieldName));
                String newValue = String.valueOf(fmsRecordNewValue.get(fieldName));
                if(fieldName == 'LastModifiedById'){
                    oldValue = String.valueOf(fmsRecordOldValue.get(fieldName));
                    newValue = String.valueOf(fmsRecordNewValue.get(fieldName));
                    Id olId;
                    Id nwId;
                    if(oldValue !=null)
                        olId = Id.valueOf(oldValue); 
                    if(newValue !=null) 
                        nwId = Id.valueOf(newValue ); 
                    if(olId!=null)   
                        oldValue = String.valueOf(usrMap.get(olId).name);
                    if(nwId !=null) 
                        newValue = String.valueOf(usrMap.get(nwId ).name);   
                }    
                if(fieldName == 'Main_Form_Id__c' || fieldName == 'Parent_Form_Id__c'){
                    formId.add(newValue);
                    formId.add(oldValue);
                }
                
                final Form_System_History__c fmsSystemHistory = new Form_System_History__c();
                
                
                fmsSystemHistory.Field_Name__c = fmsFieldsMap.get(fieldName);
                fmsSystemHistory.Main_Form__c = fmsRecordNewValue.id;
                
                if(oldValue != FMS_SELECT_VAL){
                    fmsSystemHistory.Old_Value__c = oldValue;
                }else{
                    fmsSystemHistory.Old_Value__c = '';
                }
                if(newValue!= FMS_SELECT_VAL){        
                    fmsSystemHistory.New_Value__c = newValue;
                }else{                   
                    fmsSystemHistory.New_Value__c = '';    
                }
                
                fmsSystemHistory.Last_Modified_Date__c = fmsRecordNewValue.LastModifiedDate;
                if(fmsSystemHistory.Old_Value__c == fmsSystemHistory.New_Value__c)
                    continue; 
                else    
                    fieldChanges.add(fmsSystemHistory);
            }
        }
        
        Map < id, Form_Management_System__c > fmsNameMap = new Map < id, Form_Management_System__c > ([SELECT id, Form_Name__c FROM Form_Management_System__c Where id IN: formId]);
        
        for (Form_System_History__c fldhst: fieldChanges){
			fldhst.ExternalHistory_Key__c=UtilityCls.sysUnixTimeStamp;
            if(fldhst.Field_Name__c == 'Parent Form Id' || fldhst.Field_Name__c == 'Main Form Id'){
                if(fmsNameMap.get(fldhst.Old_Value__c) !=null){
                    fldhst.New_Value__c = fmsNameMap.get(fldhst.New_Value__c).Form_Name__c;
                    fldhst.Old_Value__c = fmsNameMap.get(fldhst.Old_Value__c).Form_Name__c;
                    //added against Issue # 446....#IM
                    String fldName = String.valueOf(fldhst.Field_Name__c);
                    fldhst.Field_Name__c = fldName.remove('Id');
                }
            }
            
            fieldHistory.add(fldhst);
        }
        if(!fieldHistory.isEmpty()){
            try{
                if(UtilityCls.saveHistory){
                    insert fieldHistory;
                }
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'formSystemUpdateHistoryTracker(List < Form_Management_System__c > fmsNewRecordList, Map < Id, Form_Management_System__c > fmsOldRecordMap)', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        }
    }
    
  // Modified by Anirban on 7/12/2017 for SP Search and Subscription Hierarchy (Issue # 387)
    public void formSpFormParentUpdate(List<Form_Management_System__c> fmsNewRecordList){
        isRunOnce = true;
        Map<Id,Id> mainFormSPIds = new Map<Id,Id>();
        for (Form_Management_System__c fmsRecordNewValue: fmsNewRecordList){
            if(fmsRecordNewValue.Form_Type__c == FMS_SP_FORM && fmsRecordNewValue.Main_Form_Id__c!=null && fmsRecordNewValue.Parent_Form_Id__c!=null){
                mainFormSPIds.put(fmsRecordNewValue.Main_Form_Id__c,fmsRecordNewValue.Id);
            }
        }
        List<Form_Management_System__c> fmsList = new List<Form_Management_System__c>();
        for(Form_Management_System__c fms : [select    id
                                                       , Main_Form_Id__c
                                                       , Latest_Step_Plan__c 
                                            from       Form_Management_System__c 
                                            where      Main_Form_Id__c in :mainFormSPIds.keySet()
                                            and        Form_Type__c = :FMS_SP_FORM
                                            and        Parent_Form_Id__c = null]){
            fms.Latest_Step_Plan__c = (Id)(mainFormSPIds.get(fms.Main_Form_Id__c));
            fmsList.add(fms);            
        }
        try{
      if(fmsList.size()>0){
        update fmsList;
      }
    } catch(Exception e){
      UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'formSpFormParentUpdate(List<Form_Management_System__c> fmsNewRecordList)', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
    }
    }
    public void formSystemInsertHistoryTracker(List < Form_Management_System__c > fmsNewRecordList){
        
        List < Form_System_History__c > fieldChanges = new List < Form_System_History__c > ();
        List < Form_System_History__c > fieldHistory = new List < Form_System_History__c > ();
        Set < id > formId = new Set < id > ();
        for (Form_Management_System__c fmsRecordNewValue: fmsNewRecordList){
            Map < String, String > fmsFieldsMap = getFMSFields();
            for (String fieldName: fmsFieldsMap.Keyset()){
                //14-7-17 History Issue: Corrected the condition...#IM
                if(FMSFieldNotRequiredTracking__c.getAll().keySet().contains(fieldName)){
                    continue;
                }
                String newValue;
                if(fieldName == 'LastModifiedById')
                    newValue = String.valueOf(fmsRecordNewValue.get('ReviewedBy__c'));
                else    
                    newValue = String.valueOf(fmsRecordNewValue.get(fieldName));
                
                if(fieldName == 'Main_Form_Id__c' || fieldName == 'Parent_Form_Id__c'){
                    formId.add(newValue);
                }
                
                final Form_System_History__c fmsSystemHistory = new Form_System_History__c();
                if(fmsFieldsMap.get(fieldName) == 'Email')
                    fmsSystemHistory.Field_Name__c = 'Contact Email';
                else
                    fmsSystemHistory.Field_Name__c = fmsFieldsMap.get(fieldName);
                fmsSystemHistory.Main_Form__c = fmsRecordNewValue.id;
                
                if(newValue!= FMS_SELECT_VAL){        
                    fmsSystemHistory.New_Value__c = newValue;
                }else{                   
                    fmsSystemHistory.New_Value__c = '';    
                }
                
                if(fmsSystemHistory.Old_Value__c == fmsSystemHistory.New_Value__c)
                    continue; 
                else    
                    fieldChanges.add(fmsSystemHistory);
            }
        }
        
        Map < id, Form_Management_System__c > fmsNameMap = new Map < id, Form_Management_System__c > ([SELECT id, Form_Name__c FROM Form_Management_System__c Where id IN: formId]);
        
        for (Form_System_History__c fldhst: fieldChanges){
			fldhst.ExternalHistory_Key__c=UtilityCls.sysUnixTimeStamp;
            if(fldhst.Field_Name__c == 'Parent Form Id' || fldhst.Field_Name__c == 'Main Form Id'){
                fldhst.New_Value__c = (fmsNameMap!=null && fmsNameMap.containsKey(fldhst.New_Value__c))?fmsNameMap.get(fldhst.New_Value__c).Form_Name__c:'';
                //added agains 446...#IM
                String fldName = String.valueOf(fldhst.Field_Name__c);
                fldhst.Field_Name__c = fldName.remove('Id');
            }
            
            
            fieldHistory.add(fldhst);
        }
        if(!fieldHistory.isEmpty()){
            try{
                insert fieldHistory;
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'formSystemInsertHistoryTracker(List < Form_Management_System__c > fmsNewRecordList)', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        }
    }
    
    Private static Map < String, String > getFMSFields(){
        Map < String, String > fmsFieldsMap = new Map < String, String > ();
        Schema.sObjectType sObjType = Schema.getGlobalDescribe().get('Form_Management_System__c');
        Schema.Describesobjectresult fmsObject = sObjType.getDescribe();
        Map < String, Schema.SObjectField > fieldMap = fmsObject.fields.getMap();
        
        for (String key: fieldMap.keySet()){
            String fieldLabel = fieldMap.get(key).getDescribe().getLabel();
            String fieldname = fieldMap.get(key).getDescribe().getName();
            if(!fieldLabel.equalsIgnorecase('ExternalHistoryKey')){
                fmsFieldsMap.put(fieldname, fieldLabel);
            }
        }
        return fmsFieldsMap;
    }
    //20-7-2017 Ravindra- modified the method for step plan subscription logic
    //21-7-2017 Anirban:modified the method against Subscription related changes
    public void fmsFormSubscription(Map < id, Form_Management_System__c > fmsNewRecordMap){
        
        set < Id > formIdss = fmsNewRecordMap.keySet();
        List<Id> spFormIdList = new List<Id>();
        Id userId;
        Boolean spFormType;
        Boolean subExist = false;
        List < FMS_Subscription__c > subListExt = new List < FMS_Subscription__c >();
        for (Id fmsId: formIdss){
            if(fmsNewRecordMap.get(fmsId).Form_Type__c  != FMS_SP_FORM){
                spFormIdList.add(fmsId);
            } 
        } 
        
        userId = userinfo.getUserId();
        //Multiple data Issue in my subscription
        subListExt = [select id from FMS_Subscription__c  where User_Name__c =: userId and  Form_Id__c in : fmsNewRecordMap.keyset() and saved_search_id__c = null];
        if(subListExt.size()>0){
            subExist = true;
        }
        //End Multiple data Issue in my subscription.
        spFormType = false;        
        
        List <FMS_My_Subscription__c> fmsMySubList = [SELECT id, Name, Subscribed_All__c,UserName__c FROM FMS_My_Subscription__c where UserName__c = : userId];
        List<FMS_My_Subscription__c> fmsNewSubList = new List<FMS_My_Subscription__c>();
        fmsMySub = new FMS_My_Subscription__c();
        for(Id spFmsId : spFormIdList){         
            if(fmsMySubList != null && fmsMySubList.size() > 0){
                fmsMySub = fmsMySubList[0];
            }else{
                fmsMySub = new FMS_My_Subscription__c();
                fmsMySub.Subscribed_All__c = true;
                fmsMySub.Subscribed_Date__c = system.today();
                fmsMySub.UserName__c = userId;
                fmsNewSubList.add(fmsMySub);
            }
        }
        if(fmsNewSubList.size()>0){
            try{
                Insert fmsNewSubList;
                fmsMySub = fmsNewSubList[0];
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'fmsFormSubscription(Map < id, Form_Management_System__c > fmsNewRecordMap)', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        }
            set < Id > formIds = fmsNewRecordMap.keySet();      
            fmsSubscibeList = new List < FMS_Subscription__c > ();
            List<Form_Management_System__c> fmsUnList = new List<Form_Management_System__c>();
            for (Id fmsId: formIds){
                if(fmsNewRecordMap.get(fmsId).Form_Type__c  != FMS_SP_FORM){
                    FMS_Subscription__c fmsSubscribe = new FMS_Subscription__c();
                    fmsSubscribe.Form_Id__c = fmsNewRecordMap.get(fmsId).id;
                    fmsSubscribe.Form_Inserted__c = true;
                    fmsSubscribe.Form_Status_Change__c = true;
                    fmsSubscribe.Form_Updated__c = true;
                    fmsSubscribe.Form_Deleted__c = true;
                    fmsSubscribe.MySubscriptionId__c = fmsMySub.id;
                    fmsSubscribe.User_Name__c = userId;
                    fmsSubscribe.Subscribed_Date__c = Date.valueOf(fmsNewRecordMap.get(fmsId).LastModifiedDate);
                    fmsSubscibeList.add(fmsSubscribe);
                } else {
                    spFormType = true;   
                    fmsUnList.add(fmsNewRecordMap.get(fmsId));                                                         
                }
            }
            if(fmsUnList.size()>0){
                FMSSPSubscriptionCreateUpdate(fmsUnList); // Ravindra -- Add this to update subscription records with latest SP form ID
            }
            
            if(fmsSubscibeList != null && fmsSubscibeList.size() > 0){
                try{
                   //Boolean Check added for my subscription issue.                        
                    If(!subExist){
                    if(fmsSubscibeList.size()>0){
                            Database.insert(fmsSubscibeList,false);
                        }  
                    if(spFormType ){
                        List<FMS_Subscription__Share>  fmsRcdList = new List<FMS_Subscription__Share> ();
                        for(FMS_Subscription__c  fmsSub : fmsSubscibeList){
                            FMS_Subscription__Share fmsRecordShare1 = new FMS_Subscription__Share();
                            fmsRecordShare1.UserOrGroupId = fmsSub.User_Name__c  ;
                            fmsRecordShare1.ParentId = fmsSub.Id;
                            fmsRecordShare1.AccessLevel = 'Edit';
                            fmsRcdList.add(fmsRecordShare1 );
                        }
                        if(fmsRcdList.size()>0)    
                            Database.insert(fmsRcdList,false);
                            
                        List<FMS_My_Subscription__Share>  fmsRcdList2 = new List<FMS_My_Subscription__Share> ();
                        for(FMS_My_Subscription__c fmMySUb : fmsMySubList ){
                            FMS_My_Subscription__Share fmsRecordShare2 = new FMS_My_Subscription__Share();
                            fmsRecordShare2.UserOrGroupId = fmMySUb.UserName__c;
                            fmsRecordShare2.ParentId = fmMySUb.Id;
                            fmsRecordShare2.AccessLevel = 'Edit';
                            fmsRcdList2.add(fmsRecordShare2);
                       }  
                       if(fmsRcdList2.size()>0)    
                            database.Insert(fmsRcdList2,false); 
                    }
                    }
                } catch(Exception e){
                    UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'fmsFormSubscription(Map < id, Form_Management_System__c > fmsNewRecordMap)', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
                }
            }
          //Ravindra - Add Else If block to update subscription records with latest SP form ID (Start)
            else  if(fmsUpdateSubscibeList != null && fmsUpdateSubscibeList.size() > 0 && spFormType){
                
                try{
                      Update fmsUpdateSubscibeList;
                    
                } catch(Exception e){
                    UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'fmsFormSubscription(Map < id, Form_Management_System__c > fmsNewRecordMap)', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
                }
            }  
          //Ravindra - Add Else If block to update subscription records with latest SP form ID (End)   
        }
    
    //Ravindra - Added new method to update subscription records with latest SP form ID (Start)   
    //21-7-2017 Anirban:modified the method against Subscription related changes
    public void FMSSPSubscriptionCreateUpdate(List<Form_Management_System__c> fmsNewList){//fId
        List<Form_Management_System__c> frmList = new List<Form_Management_System__c>();
        Form_Management_System__c currSPId = new Form_Management_System__c();
        Map<Id,Id> conUsrId = new Map<Id,Id>(); 
        fmsMySubList = new List<FMS_My_Subscription__c>();
        List<Form_Management_System__Share>  fmsRcdList2 = new List<Form_Management_System__Share> ();    
        
        List<Id> fmsNewIds = new List<Id>();
        List<Id> fmsNewMainFormIds = new List<Id>();
        Map<String,String> selAppIdMap = new Map<String,String>();
        Map<Id,Id> formMainIdMap = new Map<Id,Id>();
        
        for(Form_Management_System__c frmNew: fmsNewList){
            fmsNewIds.add(frmNew.Id);
            fmsNewMainFormIds.add(frmNew.main_form_id__c);
            selAppIdMap.put(frmNew.Id,frmNew.SelAppId__c);
            formMainIdMap.put(frmNew.main_form_id__c,frmNew.Id);
        }
        
        
        Try{
            frmList =[SELECT id,Latest_Step_Plan__r.State_of_the_Form__c,Latest_Step_Plan__r.lastmodifieddate, name, Form_Name__c, Parent_Form_Id__c, Main_Form_Id__c, State_of_the_Form__c, 
                      Form_Type__c, UniqueWebRDTSId__c, CreatedDate, LastModifiedDate 
                      FROM Form_Management_System__c 
                      where main_form_id__c in :fmsNewMainFormIds
                      and Form_Type__c = :FMS_SP_FORM
                      And id not in :fmsNewIds ORDER BY CreatedDate Desc];
            
            Map<Id,Id> frmMapIds = new Map<Id,Id>();
            for(Form_Management_System__c frm : frmList){
                if(!frmMapIds.containsKey(frm.Main_Form_Id__c)){
                    frmMapIds.put(frm.Main_Form_Id__c,frm.Id);
                }
            }
            
            if(frmMapIds!=null && !frmMapIds.isEmpty()){
                // String str = fmsNewRecordMap.get(fmsId).SelAppId__c;
                fmsUpdateSubscibeList = new List<FMS_Subscription__c>();
                
                
                for(FMS_Subscription__c subs:[Select Id,Form_Id__c,Form_Id__r.Main_Form_Id__c from FMS_Subscription__c Where Form_Id__c in :frmMapIds.values()]){
                    subs.Form_Id__c = (formMainIdMap.containsKey(subs.Form_Id__r.Main_Form_Id__c))?(Id)(formMainIdMap.get(subs.Form_Id__r.Main_Form_Id__c)):subs.Form_Id__c;
                    fmsUpdateSubscibeList.add(subs);
                }
            }
            else{
                Set<String> unqUsrIds = new Set<String>();
                for(String selAppInId : selAppIdMap.values()){                                  
                    String str = selAppInId;
                    if(str !=null){
                        for(String key : str.split(';')){
                            unqUsrIds.add(key);        
                        }
                    }
                }
                for(User usr : [select id,ContactId  from user where ContactId in :unqUsrIds or id in :unqUsrIds]){
                    conUsrId.put(usr.ContactId ,usr.id);    
                }
                List<FMS_My_Subscription__c> fmsNewMySubList = new List<FMS_My_Subscription__c>();
                for(Form_Management_System__c fms : fmsNewList){                                    
                    String str = fms.SelAppId__c;
                    if(str !=null){                       
                        for(String key : str.split(';')){                          
                            FMS_My_Subscription__c  fmsMySub=new  FMS_My_Subscription__c ();                            
                            fmsMySub.Subscribed_All__c = true;
                            fmsMySub.Subscribed_Date__c = system.today();
                            fmsMySub.UserName__c = conUsrId.get(id.valueof(key)) !=null ? conUsrId.get(id.valueof(key)): id.valueof(key);   
                            fmsNewMySubList.add(fmsMySub);                                                                              
                        }
                    }
                }
                Map<Id,Id> fmsMySubUserMap = new Map<Id,Id>();
                if(fmsNewMySubList.size()>0){
                    insert fmsNewMySubList;
                    for(FMS_My_Subscription__c fmsub : fmsNewMySubList){
                        fmsMySubUserMap.put(fmsub.UserName__c,fmsub.Id);
                    }
                    fmsMySubList.addAll(fmsNewMySubList);
                }
                for(Form_Management_System__c fms : fmsNewList){                                    
                    String str = fms.SelAppId__c;
                    if(str !=null){                       
                        for(String key : str.split(';')){       
                            
                            FMS_Subscription__c fmsSubscribe = new FMS_Subscription__c();
                            fmsSubscribe.Form_Id__c = fms.id;
                            fmsSubscribe.Form_Inserted__c = true;
                            fmsSubscribe.Form_Status_Change__c = true;
                            fmsSubscribe.Form_Updated__c = true;
                            fmsSubscribe.Form_Deleted__c = true;                            
                            fmsSubscribe.User_Name__c = conUsrId.get(id.valueof(key)) !=null ? conUsrId.get(id.valueof(key)): id.valueof(key);
                            fmsSubscribe.MySubscriptionId__c = fmsMySubUserMap.containsKey(fmsSubscribe.User_Name__c)?fmsMySubUserMap.get(fmsSubscribe.User_Name__c):null;
                            fmsSubscribe.Subscribed_Date__c = Date.valueOf(fms.LastModifiedDate);
                            fmsSubscibeList.add(fmsSubscribe);
                            
                            Form_Management_System__Share fmsRecordShare1 = new Form_Management_System__Share();
                            fmsRecordShare1.UserOrGroupId = conUsrId.get(id.valueof(key)) !=null ? conUsrId.get(id.valueof(key)): id.valueof(key);
                            fmsRecordShare1.ParentId = fms.id;
                            fmsRecordShare1.AccessLevel = 'Edit';
                            fmsRcdList2.add(fmsRecordShare1 );    
                        
                        }
                    }
                }
            }
            if(fmsRcdList2.size()>0)
                insert fmsRcdList2;
            
        }
        catch(Exception e){
            UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'FMSSPSubscriptionCreateUpdate(Form_Management_System__c fId)', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }
    }
  //Ravindra - Added new method to update subscription records with latest SP form ID (End)     
    
 Private void fmsFormSearchSubscription(Map < id, Form_Management_System__c > fmsNewRecordMap){
        
		Map < Id, Set < Id >> fmsFormAndSearchMap = new Map < Id, Set < Id >> ();
		Map<Id,FMS_Search_Filter__c> fmsSearchMap = new Map<Id, FMS_Search_Filter__c>();
        Set < Id > searchFilterReq = new Set < Id > ();
        Datetime modifiedDateFrom;
        List<String> accList = new List<String>();
       
        Form_Management_System__c fmObj = new Form_Management_System__c();
        fmObj = [select Id, recordtypeid from Form_Management_System__c WHERE id IN: fmsNewRecordMap.keySet()];
        Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName();
        string recordtypename = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosById().get(fmObj.recordtypeid).getname();
        List < FMS_Search_Filter__c > searchFilterList = [SELECT id, Name, OwnerId, Chip_Interconnect__c, Created_Date_From__c, Created_Date_To__c, Customer__c,
                                                          Form_State__c, Design_Submission_Type__c, Package_Type__c, Packaging_Services__c, Form_Type__c, 
                                                          Last_Modified_From__c, Last_Modified_To__c, Package_Requirement__c, PO_Submission__c, Product_Name__c,
                                                          Product_Revision__c, Release_Process__c, Step_Plan_Input_Method__c, Submission_Type__c, 
                                                          Tapeout_Date_Projection__c, Technology__c,ModifiedDateOptions__c , CreationDateOptions__c ,Test_Levels_Desired__c, Test_Services__c, Add_Filter_Value__c, Customer_Names__c, createdbyid 
                                                          FROM FMS_Search_Filter__c];
        for (Form_Management_System__c fmsRecord: fmsNewRecordMap.values()){
            for (FMS_Search_Filter__c fmsSearchRec: searchFilterList){
                set < String > customerSet = new set < String > ();
                set < String > formTypeSet = new set < String > ();
                List < String > customerList = new List < String > ();
                if(fmsSearchRec.Customer__c != null){
                    customerList = (fmsSearchRec.Customer__c).split(';');
                }
                List < String > formTypeList = new List < String > ();
                if(fmsSearchRec.Form_Type__c != null){
                    formTypeList = (fmsSearchRec.Form_Type__c).split(';');
                }
                if(customerList != null && customerList.size() > 0){
                    customerSet.addAll(customerList);
                    if(!customerSet.isEmpty() && customerSet.contains('All') && fmsSearchRec.Customer_Names__c != null){
                        customerSet.clear();
                        customerSet.addAll((fmsSearchRec.Customer_Names__c).split(';'));
                    }
                }
                
                if(formTypeList != null && formTypeList.size() > 0){
                    formTypeSet.addAll(formTypeList);
                }
                
                // code block added by akash starts on nov 8th to fix the logc of relative date saved search based subscription  for created and modified date
                Date varFromCreatedDate;
                Date varToCreatedDate;
                Date varFromModifiedDate;
                Date varToModifiedDate;
                if (fmsSearchRec.CreationDateOptions__c != 'daterange' && fmsSearchRec.CreationDateOptions__c != NULL && fmsSearchRec.CreationDateOptions__c != 'alldates') {                                      
                    varFromCreatedDate = null;
                    if(fmsSearchRec.CreationDateOptions__c == '1day'){
                        varFromCreatedDate = system.today().addDays(-1);                    
                    }                       
                    else if(fmsSearchRec.CreationDateOptions__c == '1week'){
                        varFromCreatedDate = system.today().addDays(-7);                           
                    }
                    else if(fmsSearchRec.CreationDateOptions__c == '2weeks'){
                        varFromCreatedDate = system.today().addDays(-14);
                    }
                    else if(fmsSearchRec.CreationDateOptions__c == '1month'){
                        varFromCreatedDate = system.today().addMonths(-1);
                    }
                    else if(fmsSearchRec.CreationDateOptions__c == '6months'){
                        varFromCreatedDate = system.today().addMonths(-6);
                    }
                    else if(fmsSearchRec.CreationDateOptions__c == '1year'){
                        varFromCreatedDate = system.today().addYears(-1);
                    }
                    varToCreatedDate = system.today();
                   //-- varToCreatedDate = varToCreatedDate.addDays(1);                                          
                 }
                 else if(fmsSearchRec.CreationDateOptions__c == 'daterange'){
                    if(fmsSearchRec.Created_Date_From__c != null){                                      
                      varFromCreatedDate = fmsSearchRec.Created_Date_From__c;                                                         
                    }       
                    
                    if(fmsSearchRec.Created_Date_To__c != null){                                        
                      varToCreatedDate = fmsSearchRec.Created_Date_To__c;
                     //-- varToCreatedDate = varToCreatedDate.addDays(1);                                                         
                    }                                      
                 }
                Datetime createdDateFrom;
                if(varFromCreatedDate != null){
                    createdDateFrom = datetime.newInstance(varFromCreatedDate.year(), varFromCreatedDate.month(), varFromCreatedDate.day(),0,0,0);
                }
                Datetime createdDateTo;
                if(createdDateTo != null){
                    createdDateTo = datetime.newInstance(createdDateTo.year(), createdDateTo.month(), createdDateTo.day(), 11, 59, 59);
                }
                
                if(fmsSearchRec.ModifiedDateOptions__c != 'daterange' && fmsSearchRec.ModifiedDateOptions__c != NULL  && fmsSearchRec.ModifiedDateOptions__c != 'alldates') {
               
                    varFromModifiedDate = null;
                    if(fmsSearchRec.ModifiedDateOptions__c == '1day'){
                        varFromModifiedDate = system.today().addDays(-1);
                    }
                    else if(fmsSearchRec.ModifiedDateOptions__c == '1week'){
                        varFromModifiedDate = system.today().addDays(-7);
                    }
                    else if(fmsSearchRec.ModifiedDateOptions__c == '2weeks'){
                        varFromModifiedDate = system.today().addDays(-14);
                    }
                    else if(fmsSearchRec.ModifiedDateOptions__c == '1month'){
                        varFromModifiedDate = system.today().addMonths(-1);
                    }
                    else if(fmsSearchRec.ModifiedDateOptions__c == '6months'){
                        varFromModifiedDate = system.today().addMonths(-6);
                    }
                    else if(fmsSearchRec.ModifiedDateOptions__c == '1year'){
                        varFromModifiedDate = system.today().addYears(-1);
                    }
                    varToModifiedDate = system.today();
                   //-- varToModifiedDate = varToModifiedDate.addDays(1);   
                }  
                else if(fmsSearchRec.ModifiedDateOptions__c == 'daterange'){
                    if(fmsSearchRec.Last_Modified_From__c != null){                                     
                      varFromModifiedDate = fmsSearchRec.Last_Modified_From__c;                                                       
                    }                           
                    if(fmsSearchRec.Last_Modified_To__c != null){                                       
                      varToModifiedDate = fmsSearchRec.Last_Modified_To__c; 
                      //--varToModifiedDate = varToModifiedDate.addDays(1);                                                       
                    }                                      
                } 
                if(varFromModifiedDate != null){
                    modifiedDateFrom = datetime.newInstance(varFromModifiedDate.year(), varFromModifiedDate.month(), varFromModifiedDate.day(),0,0,0);
                }
                Datetime modifiedDateTo;
                if(varToModifiedDate != null){
                    modifiedDateTo = datetime.newInstance(varToModifiedDate.year(), varToModifiedDate.month(), varToModifiedDate.day(), 11, 59, 59);
                }
                Boolean recordValid = false;
                if(fmsSearchRec.Chip_Interconnect__c != '' && fmsSearchRec.Chip_Interconnect__c != null && fmsRecord.Chip_Interconnect__c != NULL){
                    if(fmsSearchRec.Chip_Interconnect__c.contains(fmsRecord.Chip_Interconnect__c)){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }
                if(!customerSet.isEmpty()){     //&& !customerSet.contains('All')               
                    if(customerSet.contains(fmsRecord.Customer__c)){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }               
                if(fmsSearchRec.Design_Submission_Type__c != null && fmsRecord.DesignSubmission__c != NULL){
                    if(fmsSearchRec.Design_Submission_Type__c.contains(fmsRecord.DesignSubmission__c)){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }
                if(fmsSearchRec.Form_State__c != null && fmsRecord.State_of_the_Form__c != NULL){
                    if(fmsSearchRec.Form_State__c.contains(fmsRecord.State_of_the_Form__c)){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }
                if(fmsSearchRec.Package_Requirement__c != null && fmsRecord.PackageRequirement__c != NULL){
                    if(fmsSearchRec.Package_Requirement__c.contains(fmsRecord.PackageRequirement__c)){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }
                if(fmsSearchRec.Package_Type__c != null && fmsRecord.PackageType__c != NULL){
                    if(fmsSearchRec.Package_Type__c.contains(fmsRecord.PackageType__c)){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }
                if(fmsSearchRec.Packaging_Services__c != null && fmsRecord.Packaging_Services__c != NULL){
                    if(fmsSearchRec.Packaging_Services__c.contains(fmsRecord.Packaging_Services__c)){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }
                if(fmsSearchRec.PO_Submission__c != null && fmsRecord.PurchaseOrder__c != NULL){
                    if(fmsSearchRec.PO_Submission__c.contains(fmsRecord.PurchaseOrder__c)){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }
                if(fmsSearchRec.Product_Name__c != null){
                    if(fmsRecord.ProductName__c == fmsSearchRec.Product_Name__c){
                        recordValid = true;
                    }else{
                        recordValid = false;
                    }
                }
                if(fmsSearchRec.Product_Revision__c != null){
                    if(fmsRecord.ProductRevision__c == fmsSearchRec.Product_Revision__c){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }
                if(fmsSearchRec.Release_Process__c != null && fmsRecord.ReleaseProcessFlow__c != NULL){
                    if(fmsSearchRec.Release_Process__c.contains(fmsRecord.ReleaseProcessFlow__c)){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }
                if(fmsSearchRec.Step_Plan_Input_Method__c != null && fmsRecord.InputMethod__c != NULL){
                    if(fmsSearchRec.Step_Plan_Input_Method__c.contains(fmsRecord.InputMethod__c)){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }
                if(fmsSearchRec.Submission_Type__c != null && fmsRecord.SubmissionType__c != NULL){
                    if(fmsSearchRec.Submission_Type__c.contains(fmsRecord.SubmissionType__c)){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }
                if(fmsSearchRec.Tapeout_Date_Projection__c != null){
                    if(fmsRecord.ProjectedTapeout__c == fmsSearchRec.Tapeout_Date_Projection__c){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }
                if(fmsSearchRec.Technology__c != null && fmsRecord.Technology__c != NULL){
                    if(fmsSearchRec.Technology__c.contains(fmsRecord.Technology__c)){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }
                if(fmsSearchRec.Test_Levels_Desired__c != null && fmsRecord.TestLevels__c != NULL){
                    if(fmsSearchRec.Test_Levels_Desired__c.contains(fmsRecord.TestLevels__c)){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }
                if(fmsSearchRec.Form_State__c != null && fmsRecord.State_of_the_Form__c != NULL){
                    if(fmsSearchRec.Form_State__c.contains(fmsRecord.State_of_the_Form__c)){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }
                if(createdDateFrom != null){
                    if(fmsRecord.CreatedDate >= createdDateFrom){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }
                if(createdDateTo != null){
                    if(fmsRecord.CreatedDate <= createdDateTo){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }
                if(modifiedDateFrom != null){
                    if(fmsRecord.LastModifiedDate >= modifiedDateFrom){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }
                if(modifiedDateTo != null){
                    if(fmsRecord.LastModifiedDate <= modifiedDateTo){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }
                List < String > formtypeLst = new  List < String >();
                if(!formTypeSet.isEmpty() && !formTypeSet.contains('All')){
                    if(formTypeSet.contains(recordtypename )){
                        recordValid = true;
                    }else{
                        recordValid = false;
                        continue;
                    }
                }else if(!formTypeSet.isEmpty() && formTypeSet.contains('All')){
                    formTypeSet = new set < String > ();
                    for(String recordTypeStr : rtMapByName.keySet()){
                        if(!recordTypeStr.contains('Master')){
                            formtypeLst.add(recordTypeStr);
                        }
                     }
                     if(!formtypeLst.isEmpty()){
                        formTypeSet.addAll(formtypeLst);       
                        if(formTypeSet.contains(recordtypename )){
                            recordValid = true;
                        }else{
                            recordValid = false;
                            continue;
                        }
                    }
                }
               
                if(recordValid){
					if(!fmsSearchMap.containsKey(fmsSearchRec.id)){
                        fmsSearchMap.put(fmsSearchRec.id, fmsSearchRec);
                    }
                    if((fmsFormAndSearchMap.keySet()).contains(fmsRecord.id)){
                        Set < Id > searchSet = fmsFormAndSearchMap.get(fmsRecord.id);
                        
                        searchSet.add(fmsSearchRec.id);
                        fmsFormAndSearchMap.put(fmsRecord.id, searchSet);
                        searchFilterReq.add(fmsSearchRec.id);
                    }else{
                        Set < Id > searchNewSet = new Set < Id > ();
                        searchNewSet.add(fmsSearchRec.id);
                        fmsFormAndSearchMap.put(fmsRecord.id, searchNewSet);
                        searchFilterReq.add(fmsSearchRec.id);
                    }
                }
            }
        }
        //get subscription objects for the matching search results,  
        //to assign the notifcation values for new records with the values given when subscribed.
        
        Map<String,String> fmsSavedSearchIdMap = new Map<String,String>();
        for(FMS_Subscription__c fmsSub : [select    id,
                                                    name,
                                                    Saved_Search_Id__c,
                                                    Form_Id__c
                                          from      FMS_Subscription__c
                                          where     Saved_Search_Id__c IN :searchFilterReq
                                          and       Form_Id__c IN :fmsNewRecordMap.keySet()
                                          and       (form_inserted__c = true 
                                                    or form_updated__c = true 
                                                    or form_status_change__c = true 
                                                    or form_deleted__c = true)]){
            fmsSavedSearchIdMap.put(fmsSub.Saved_Search_Id__c,fmsSub.Form_Id__c);
        }
        List<FMS_Subscription__c> fmsSubInsertList = new List<FMS_Subscription__c>();
        List<FMS_Subscription__c> fmSubList = [select    id
                                                         , saved_search_id__c
                                                         , form_inserted__c
                                                         , form_updated__c
                                                         , form_status_change__c
                                                         , form_deleted__c
                                                         , subscribed_date__c 
                                               from      FMS_Subscription__c 
                                               where     saved_search_id__c IN :searchFilterReq 
                                               and       SavedSearchKey__c!=null
                                               and (form_inserted__c = true or form_updated__c = true or form_status_change__c = true or form_deleted__c = true)];
        for(Form_Management_System__c fmsRecord : fmsNewRecordMap.values()){
            for (FMS_Subscription__c fmSub : fmSubList){
                if(!(fmsSavedSearchIdMap.containsKey(fmSub.saved_search_id__c))){
                    FMS_Subscription__c fmsSubInsert = new FMS_Subscription__c();
                    fmsSubInsert.Form_Inserted__c = fmSub.Form_Inserted__c;
                    fmsSubInsert.Form_Status_Change__c = fmSub.Form_Status_Change__c;
                    fmsSubInsert.Form_Updated__c = fmSub.Form_Updated__c;
                    fmsSubInsert.Form_Deleted__c = fmSub.Form_Deleted__c;
                    fmsSubInsert.Subscribed_Date__c = fmSub.Subscribed_Date__c;
                    fmsSubInsert.Form_Id__c = fmsRecord.id;    
                    fmsSubInsert.User_Name__c  = (fmsSearchMap.get(fmSub.saved_search_id__c)!=null)?(fmsSearchMap.get(fmSub.saved_search_id__c)).createdbyid:null ;
                    fmsSubInsert.Saved_Search_Id__c = fmSub.saved_search_id__c;
                    if((fmsSubInsert.Form_Inserted__c || fmsSubInsert.Form_Status_Change__c || fmsSubInsert.Form_Updated__c || fmsSubInsert.Form_Deleted__c)
                        && fmsSubInsert.Subscribed_Date__c != null && fmsSubInsert.User_Name__c != null){                              
                        fmsSubInsertList.add(fmsSubInsert);
                    }        
                }
            }
        }
        
        if(fmsSubInsertList != null && fmsSubInsertList.size() > 0){
            try{
               
                INSERT fmsSubInsertList;  
                List<FMS_Subscription__Share>  fmsRcdList = new List<FMS_Subscription__Share> ();
                List<Id> fmsSubIds = new List<Id>();
                for(FMS_Subscription__c fs : fmsSubInsertList){
                    fmsSubIds.add(fs.Id);
                }
                fmsSubInsertList = [select User_Name__r.UserType,User_Name__c,id from FMS_Subscription__c where id in :fmsSubIds];
  
                for(FMS_Subscription__c  fmsSub : fmsSubInsertList){
                    if(fmsSub.User_Name__r.UserType!='Standard'){
                        FMS_Subscription__Share fmsRecordShare1 = new FMS_Subscription__Share();  
                        fmsRecordShare1.UserOrGroupId = fmsSub.User_Name__c  ;
                        fmsRecordShare1.ParentId = fmsSub.Id;
                        fmsRecordShare1.AccessLevel = 'Edit'; 
                        fmsRcdList.add(fmsRecordShare1 );
                    }
                 }   
               
                if(fmsRcdList.size()>0){    
                    Database.Insert(fmsRcdList,false);
                }                     
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'fmsFormSearchSubscription(Map < id, Form_Management_System__c > fmsNewRecordMap)', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        }		
    }
	
    public void sendNotificationToSubscribers(Map < Id, Form_Management_System__c > fmsNew, Map < Id, Form_Management_System__c > fmsOld, String event){
        List < Messaging.SingleEmailMessage > messages = new List < Messaging.SingleEmailMessage > ();
        //Added against 423...#IM
        Map<Id,Form_Management_System__c> fmMap = new Map<Id,Form_Management_System__c>();
        fmMap = FMSEmailTemplates.getPrimaryStepPlanMap(fmsNew.values());
        if(event == Label.Form_Create_Email){
            FMSEmailTemplates.SendEditEmail = false;
            Map < Id, Set < String >> IdSubMap = FMSEmailTemplates.getSubscribers(fmsNew.keySet(), event);             
            for (Form_Management_System__c fms: fmsNew.values()){
                if(fms.Form_Type__c  == FMS_SP_FORM){
                    Set<string> idSet = FMSEmailTemplates.getStepPlanReviewers(fms);
                    messages.add(FMSEmailTemplates.createTemplate(fmMap.get(fms.Id), null, Label.Form_Create_Email, idSet));
                    if(fms.PrelimOrFinal__c != 'Final'){  
                        messages.add(FMSEmailTemplates.createTemplate(fmMap.get(fms.Id), null, Label.Form_Create_Email_SP, idSet)); 
                    }
                }else{
                    if(IdSubMap.get(fms.Id) != null && !IdSubMap.get(fms.Id).isEmpty() && FMSEmailTemplates.createTemplate(fms, null, Label.Form_Create_Email, IdSubMap.get(fms.Id)) != null){
                        messages.add(FMSEmailTemplates.createTemplate(fms, null, Label.Form_Create_Email, IdSubMap.get(fms.Id)));
                    }
                }
            }
        }
        if(event == Label.Form_Edit_Email){
            Map < Id, Set < String >> IdSubEditMap = FMSEmailTemplates.getSubscribers(fmsNew.keySet(), event); 
            Map < Id, Set < String >> IdSubStatusEditMap = FMSEmailTemplates.getSubscribers(fmsNew.keySet(), Label.Form_State_Edit_Email);
            Map<Id, Form_Management_System__c> fmsNewList = new Map<Id, Form_Management_System__c>([select Selection__c, Mandatory_State_Change_Comments__c, Customer__c,Name__c,Customer_Name__c,Customer_Name__r.Name ,CreatedBy.Name,LastModifiedBy.Name,CreatedBy.Email,LastModifiedBy.Email,CreatedDate,LastModifiedDate,Form_Name__c,Name,Form_Description__c,State_of_the_Form__c, Form_Type__c,ID,Days_left_for_deletion__c,Parent_Form_Id__c,Parent_Form_Id__r.Name from Form_Management_System__c where Id in: fmsNew.keySet()]);
            for (Form_Management_System__c fms: fmsNew.values()){
                Messaging.SingleEmailMessage msg;
                Set<string> idSet = FMSEmailTemplates.getStepPlanReviewers(fms);
                if(fms.State_of_the_Form__c != fmsOld.get(fms.Id).State_of_the_Form__c){ 
                    if(IdSubStatusEditMap.get(fms.Id) != null && !IdSubStatusEditMap.get(fms.Id).isEmpty()){
                        if(fms.Form_Type__c  == FMS_SP_FORM){
                            idSet.addall(IdSubStatusEditMap.get(fms.Id));
                            msg = FMSEmailTemplates.createTemplate(fmsNewList.get(fms.Id), fmsOld.get(fms.Id), Label.Form_State_Edit_Email, idSet);
                        }else {                   
                            msg = FMSEmailTemplates.createTemplate(fms, fmsOld.get(fms.Id), Label.Form_State_Edit_Email, IdSubStatusEditMap.get(fms.Id));
                        }
                    }
                }else{
                    if(FMSEmailTemplates.SendEditEmail && IdSubEditMap.get(fms.Id) != null && !IdSubEditMap.get(fms.Id).isEmpty()){
                        if(fms.Form_Type__c  == FMS_SP_FORM){
                            idSet.addall(IdSubEditMap.get(fms.Id));
                            msg = FMSEmailTemplates.createTemplate(fmsNewList.get(fms.Id), fmsOld.get(fms.Id), event, idSet); 
                        }else{
                            msg = FMSEmailTemplates.createTemplate(fms, fmsOld.get(fms.Id), event, IdSubEditMap.get(fms.Id)); 
                        }
                    }
                }
                if(msg!= null){
                    messages.add(msg);                        
                }
            }
        }
        if(event == Label.Form_Delete_Email){
            Map < Id, Set < String >> IdSubDelMap = FMSEmailTemplates.getSubscribers(fmsOld.keySet(), event);
            for (Form_Management_System__c fms: fmsOld.values()){
                if(IdSubDelMap.get(fms.Id) != null && !IdSubDelMap.get(fms.Id).isEmpty() && FMSEmailTemplates.createTemplate(null, fms, event, IdSubDelMap.get(fms.Id)) != null){
                    messages.add(FMSEmailTemplates.createTemplate(null, fms, event, IdSubDelMap.get(fms.Id)));
                }
            }
        }
        if(!messages.isEmpty()){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages, false); 
            for (Messaging.SendEmailResult res: results){
                if(!res.success){
                    
                }
            }
        }
    }
    
    public void fmsFormDeletedSubscription(Map < id, Form_Management_System__c > fmsoldRecordMap){
        List<FMS_Subscription__c> fmsSubDelete= [SELECT id ,Form_Id__c  FROM FMS_Subscription__c WHERE Form_Id__c IN :fmsoldRecordMap.keySet()];
        try{
            if(!fmsSubDelete.isEmpty()){
                delete fmsSubDelete;                
            }
        }
        Catch(Exception e){
        }
    }
    
    public void fmsDevicePTUpdation(Map<id,Form_Management_System__c> fmsNewRecordMap, map<id,Form_Management_System__c> fmsOldRecordMap){
        List<id> fmsTechModfiedID = new List<id>();
        for(Form_Management_System__c fmsrec : fmsNewRecordMap.values()){
            if(fmsrec.technology__c != fmsOldRecordMap.get(fmsrec.id).technology__c){
                fmsTechModfiedID.add(fmsrec.id);               
            }
        }
        if(!fmsTechModfiedID.isEmpty()){
            FMSFutureCallClass.updatePTNumber(fmsTechModfiedID);  
        }
    }
    
    public void FMSSPParntIdMapping(List<Form_Management_System__c> fmsNewRecordList){
        set<Id> fmsId = new set<Id>();
        List<Form_Management_System__c> fmLst = new List<Form_Management_System__c>();
        List<Form_Management_System__c> maindfmLst = new List<Form_Management_System__c>();
        List<Form_Management_System__c> fmLstupd = new List<Form_Management_System__c>();
        Id devRecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get(FMS_SP_FORM).getRecordTypeId();
        Id maiRecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get(FMS_MAIN_FORM).getRecordTypeId();
        for (Form_Management_System__c fmsRecord: fmsNewRecordList){
            if(fmsRecord.RecordTypeId == devRecordTypeId ){
                fmsId.add(fmsRecord.Main_Form_Id__c);
            }    
        }           
        fmLst = [select id,Customer__c,SelAppId__c,Customer_Name__c  from Form_Management_System__c where Main_Form_Id__c in :fmsId and RecordTypeId =:devRecordTypeId  order by CreatedDate asc];
        maindfmLst = [select id,Customer__c,Customer_Name__c,SelAppId__c,RecordTypeId ,Main_Form_Id__c,Parent_Form_Id__c from Form_Management_System__c where id in :fmsId ] ;         
        Form_Management_System__c  fm = new Form_Management_System__c();
        for(Form_Management_System__c  fms: fmsNewRecordList){
            if(fms.Form_Type__c  == FMS_SP_FORM){
                //Issue#400 Start...#IM 15-7-2017
                if(fms.PrelimOrFinal__c == EnvironmentVariable.get('FMS_StepPlanPrelim')){
                    fms.State_of_the_Form__c = EnvironmentVariable.get('FMS_StepPlanWaitingforReview');
                }else if (fms.PrelimOrFinal__c == EnvironmentVariable.get('FMS_StepPlanFinal')){
                    fms.State_of_the_Form__c = EnvironmentVariable.get('FMS_StepPlanComplete');
                }
                //Issue#400 End...#IM 15-7-2017
                if(fmLst.size()>0)
                    fms.Parent_Form_Id__c = fmLst[0].id;
                fms.Customer__c = maindfmLst[0].Customer__c;
                fms.Customer_Name__c = maindfmLst[0].Customer_Name__c ;
                fms.SelAppId__c  = maindfmLst[0].SelAppId__c;  
            }           
        }  
    }
}