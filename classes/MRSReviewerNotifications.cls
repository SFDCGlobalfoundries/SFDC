global class MRSReviewerNotifications implements Database.Batchable < sObject > { 
    
    
    Map<Id,MRS_Layer_Chip_Association__c> mrsObjToUpdate = new Map<Id,MRS_Layer_Chip_Association__c>();
    public Integer count = 0;
    public String query ='';
    public DateTime timeAfterInterval = System.now().addHours(-Integer.valueOf(Label.Notification_Interval));
    global Database.QueryLocator start(Database.BatchableContext BC){
        String ready = 'Ready';
        
        List<String> layerChipStatus = new List<String>{'Cancel','Hold','Void'};
        List<String> orderStatus  = new List<String>{'Cancel','Deleted','Closed'};    
         
        query = 'SELECT Chip__c,Chip__r.Name,Layer__r.Name,Layer__r.Mask_Layer_Rev__c,Layer__r.ROM_Code__c,Tech_Geo__c,Customer_Name__c,Customer_Name__r.Id, Customer_Name__r.Name,DRT__c,PTRF__r.Name,\n'+
                       'PTRF__c,PTRF__r.MaskSetTitle__c,PTRF__r.MaskSetTitle__r.Name,Layer__c,Customer_Name__r.Short_Name__c,PTRF__r.Tech_Geo__c,\n'+
                       'Customer_GDSOUT_Review__c,Customer_GDSOUT_Review_Notified_Date__c,Foundry_GDSOUT_Review__c,Foundry_GDSOUT_Review_Notified_Date__c,Customer_Frame_Mockup__c,Customer_Frame_Mockup_Notified_Date__c,Foundry_Frame_Mockup__c,Foundry_Frame_Mockup_Notified_Date__c,Customer_MEBES_Jobview__c,Customer_MEBES_Jobview_Notified_Date__c,\n'+
                       'Foundry_MEBES_Jobview__c,Foundry_MEBES_Jobview_Notified_Date__c,Tapeout_Centre_MEBES_Jobview__c,Tapeout_Centre_MEBES_Notified_Date__c,Tapeout_Applications_MEBES_Jobview__c,Tapeout_App_MEBES_Notified_Date__c,GlobalShuttle_MEBES_Jobview__c,GlobalShuttle_MEBES_Notified_Date__c,\n'+
                       'TDTI_MPW_MEBES_Jobview__c,TDTI_MPW_MEBES_Notified_Date__c,MDP_MEBES_Jobview__c,MDP_MEBES_Notified_Date__c FROM MRS_Layer_Chip_Association__c\n'+
                       ' WHERE ((Customer_GDSOUT_Review__c =: ready AND Customer_GDSOUT_Review_Notified_Date__c <= :timeAfterInterval)  OR (Foundry_GDSOUT_Review__c =: ready AND Foundry_GDSOUT_Review_Notified_Date__c <= :timeAfterInterval) OR (Customer_Frame_Mockup__c =: ready AND Customer_Frame_Mockup_Notified_Date__c <= :timeAfterInterval) OR\n'+
                       ' (Foundry_Frame_Mockup__c =: ready AND Foundry_Frame_Mockup_Notified_Date__c <= :timeAfterInterval) OR (Customer_MEBES_Jobview__c =: ready AND Customer_MEBES_Jobview_Notified_Date__c <= :timeAfterInterval) OR (Foundry_MEBES_Jobview__c =: ready AND Foundry_MEBES_Jobview_Notified_Date__c <= :timeAfterInterval) OR\n'+
                       ' (Tapeout_Centre_MEBES_Jobview__c =: ready AND Tapeout_Centre_MEBES_Notified_Date__c <= :timeAfterInterval) OR (Tapeout_Applications_MEBES_Jobview__c =: ready AND Tapeout_App_MEBES_Notified_Date__c <= :timeAfterInterval) OR (GlobalShuttle_MEBES_Jobview__c =: ready AND GlobalShuttle_MEBES_Notified_Date__c <= :timeAfterInterval) OR\n'+
                       ' (TDTI_MPW_MEBES_Jobview__c =: ready AND TDTI_MPW_MEBES_Notified_Date__c <= :timeAfterInterval) OR (MDP_MEBES_Jobview__c =: ready AND MDP_MEBES_Notified_Date__c <= :timeAfterInterval)) AND PTRF__r.Status__c NOT IN :orderStatus AND Layer_Chip_Status__c NOT IN :layerChipStatus ORDER BY PTRF__r.MaskSetTitle__c';
                          
        return Database.getQueryLocator(query);
    } 
    
    global void execute(Database.BatchableContext BC,List<MRS_Layer_Chip_Association__c> mrsLayerChipList){ 
        Set<Id> ptrfIdSet = new Set<Id>();
        Map<String,List<MRS_Layer_Chip_Association__c>> mapMrsLayerChip = new Map<String,List<MRS_Layer_Chip_Association__c>>();
        String key;
        Map<String,List<MRS_Layer_Chip_Association__c>> mapMrsLayerChipAnother = new Map<String,List<MRS_Layer_Chip_Association__c>>();
        List<MRS_Layer_Chip_Association__c> mrsLayerlst ;
        Set<Id> acctIdSet = new Set<Id>();
        Map<Id,List<User>> acctIdUserListMap = new Map<Id,List<User>>();
        Map<Id,List<Account_Team_Proxy__c>> acctIdAccountProxyListMap = new Map<Id,List<Account_Team_Proxy__c>>();

        
        /*-------------------------USerListOFAllSwiftPublicGroup--------------------------------------*/
        List<EmailTemplate> templateList = [SELECT DeveloperName,Subject,Body,HtmlValue FROM EmailTemplate WHERE DeveloperName IN ('Swift_Reminder_Notification_MEBES_Jobview_with_only_MST','Swift_Reminder_Notification_GDSOUT_Review','Swift_Reminder_Notification_Frame_Mockup','Swift_Reminder_Notification_MEBES_Jobview')];
        /*---------------------------------------------------------------*/
        OrgWideEmailAddress owa = [SELECT Id,DisplayName,Address FROM OrgWideEmailAddress WHERE DisplayName = 'GLOBALFOUNDRIES' LIMIT 1];
        
        /*-----------------------Retrieve Contact List--------------------------*/
        for(MRS_Layer_Chip_Association__c mrslayerChipObj : mrsLayerChipList){
            acctIdSet.add(mrslayerChipObj.Customer_Name__c);
        }
        
       
        List<User> userList = [SELECT AccountId,ContactId,Email FROM User WHERE AccountId IN :acctIdSet AND isActive = true];
        List<User> userIterator;
        Set<Id> contactIdSet = new Set<Id>();
        
        for(User userObj : userList){
            if(acctIdUserListMap.get(userObj.AccountId) != null){
                if(userObj.Email != null){
                    acctIdUserListMap.get(userObj.AccountId).add(userObj);
                }
            }
            else {
                if(userObj.Email != null){
                    userIterator = new List<User>();
                    userIterator.add(userObj);
                    acctIdUserListMap.put(userObj.AccountId,userIterator);
                }
            }
            contactIdSet.add(userObj.ContactId);
        }
        
        List<Portal_Tab_Access__c> portalTabAccessList = [SELECT Contact__c,My_Devices__c,PTRF__c FROM Portal_Tab_Access__c WHERE Contact__c IN :contactIdSet];
        
        Map<Id,Boolean> contactIdTabAccessMap = new Map<Id,Boolean>();
        
        for(Portal_Tab_Access__c pTAObj : portalTabAccessList){
            if(pTAObj.My_Devices__c && pTAObj.PTRF__c){
                if(!contactIdTabAccessMap.containsKey(pTAObj.Contact__c)){
                    contactIdTabAccessMap.put(pTAObj.Contact__c,true);
                }
            }
        }
        
        Map<Id,List<User>> finalAccountUserMap = new Map<Id,List<User>>();
        List<User> finalUserIterator;
        
        for(Id accId : acctIdUserListMap.keySet()){
            for(User usrObj : acctIdUserListMap.get(accId)){
                if(contactIdTabAccessMap.containsKey(usrObj.ContactId)){
                    if(contactIdTabAccessMap.get(usrObj.ContactId)){
                        if(finalAccountUserMap.get(accId) != null){
                            finalAccountUserMap.get(accId).add(usrObj);
                        }
                        else {
                            finalUserIterator = new List<User>();
                            finalUserIterator.add(usrObj);
                            finalAccountUserMap.put(accId,finalUserIterator);
                        }
                    }
                }
            }
        }
        
        List<String> lstTeamRoles = new List<String>();  
        lstTeamRoles = Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');      
        List<Account_Team_Proxy__c> accProxyList = [SELECT Account__c,Name,User_Email__c FROM Account_Team_Proxy__c WHERE Account__c IN :acctIdSet AND Team_Role__c IN :lstTeamRoles AND User__r.isActive = true];
        List<Account_Team_Proxy__c> accProxyIterator;
        for(Account_Team_Proxy__c accProxyObj : accProxyList){
            if(acctIdAccountProxyListMap.get(accProxyObj.Account__c) != null){
                if(accProxyObj.User_Email__c != null){
                    acctIdAccountProxyListMap.get(accProxyObj.Account__c).add(accProxyObj);
                }
            }
            else {
                if(accProxyObj.User_Email__c != null){
                    accProxyIterator = new List<Account_Team_Proxy__c>();
                    accProxyIterator.add(accProxyObj);
                    acctIdAccountProxyListMap.put(accProxyObj.Account__c,accProxyIterator);
                }
            }
        }

        /*---------------------------------------------------------------*/ 

        Messaging.SingleEmailMessage[] allMail = new Messaging.SingleEmailMessage[]{};

        for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipList) {
            if((mrsLayerChipObj.Customer_GDSOUT_Review__c == 'Ready' && mrsLayerChipObj.Customer_GDSOUT_Review_Notified_Date__c!=null && mrsLayerChipObj.Customer_GDSOUT_Review_Notified_Date__c <= timeAfterInterval) || (mrsLayerChipObj.Foundry_GDSOUT_Review__c == 'Ready' && mrsLayerChipObj.Foundry_GDSOUT_Review_Notified_Date__c!=null && mrsLayerChipObj.Foundry_GDSOUT_Review_Notified_Date__c <= timeAfterInterval) || (mrsLayerChipObj.Customer_Frame_Mockup__c == 'Ready' && mrsLayerChipObj.Customer_Frame_Mockup_Notified_Date__c!=null && mrsLayerChipObj.Customer_Frame_Mockup_Notified_Date__c <= timeAfterInterval) 
               || (mrsLayerChipObj.Foundry_Frame_Mockup__c == 'Ready' && mrsLayerChipObj.Foundry_Frame_Mockup_Notified_Date__c!=null && mrsLayerChipObj.Foundry_Frame_Mockup_Notified_Date__c <= timeAfterInterval) || (mrsLayerChipObj.Customer_MEBES_Jobview__c == 'Ready' && mrsLayerChipObj.Customer_MEBES_Jobview_Notified_Date__c!=null && mrsLayerChipObj.Customer_MEBES_Jobview_Notified_Date__c <= timeAfterInterval) || (mrsLayerChipObj.Foundry_MEBES_Jobview__c == 'Ready' && mrsLayerChipObj.Foundry_MEBES_Jobview_Notified_Date__c!=null && mrsLayerChipObj.Foundry_MEBES_Jobview_Notified_Date__c <= timeAfterInterval)) {
                ptrfIdSet.add(mrsLayerChipObj.PTRF__c); 
                if(mrsLayerChipObj.Customer_Name__c != null){
                    if(mrsLayerChipObj.PTRF__r.MaskSetTitle__c != null){
                        key = mrsLayerChipObj.PTRF__r.MaskSetTitle__r.Name+':'+mrsLayerChipObj.Customer_Name__r.Name;
                        if(mapMrsLayerChip.get(key) == null)
                        {
                            mrsLayerlst  = new List<MRS_Layer_Chip_Association__c>();
                            mrsLayerlst.add(mrsLayerChipObj);
                            mapMrsLayerChip.put(key,mrsLayerlst);
                            
                        }else
                        {
                            mapMrsLayerChip.get(key).add(mrsLayerChipObj);
                        }
                    }
                }
                
            }
            if((mrsLayerChipObj.Tapeout_Centre_MEBES_Jobview__c == 'Ready' && mrsLayerChipObj.Tapeout_Centre_MEBES_Notified_Date__c!=null && mrsLayerChipObj.Tapeout_Centre_MEBES_Notified_Date__c <= timeAfterInterval) || (mrsLayerChipObj.Tapeout_Applications_MEBES_Jobview__c == 'Ready' && mrsLayerChipObj.Tapeout_App_MEBES_Notified_Date__c!=null && mrsLayerChipObj.Tapeout_App_MEBES_Notified_Date__c <= timeAfterInterval) 
               || (mrsLayerChipObj.GlobalShuttle_MEBES_Jobview__c == 'Ready' && mrsLayerChipObj.GlobalShuttle_MEBES_Notified_Date__c!=null && mrsLayerChipObj.GlobalShuttle_MEBES_Notified_Date__c <= timeAfterInterval) || (mrsLayerChipObj.TDTI_MPW_MEBES_Jobview__c == 'Ready' && mrsLayerChipObj.TDTI_MPW_MEBES_Notified_Date__c!=null && mrsLayerChipObj.TDTI_MPW_MEBES_Notified_Date__c <= timeAfterInterval) || (mrsLayerChipObj.MDP_MEBES_Jobview__c =='Ready' && mrsLayerChipObj.MDP_MEBES_Notified_Date__c!=null && mrsLayerChipObj.MDP_MEBES_Notified_Date__c <= timeAfterInterval)){
                
                if(mrsLayerChipObj.PTRF__r.MaskSetTitle__r.Name != null){
                    if(mapMrsLayerChipAnother.get(mrsLayerChipObj.PTRF__r.MaskSetTitle__r.Name) == null)
                    {
                        mrsLayerlst  = new List<MRS_Layer_Chip_Association__c>();
                        mrsLayerlst.add(mrsLayerChipObj);
                        mapMrsLayerChipAnother.put(mrsLayerChipObj.PTRF__r.MaskSetTitle__r.Name,mrsLayerlst);
                    }
                    else {
                        mapMrsLayerChipAnother.get(mrsLayerChipObj.PTRF__r.MaskSetTitle__r.Name).add(mrsLayerChipObj);
                    }
                }
            }
        }
        
        
        if(mapMrsLayerChip != null && mapMrsLayerChip.size() > 0){
            if(ptrfIdSet != null){
                List<PTRF_JobViewer_Info__c> ptrfJobviewerList = [SELECT Id,Name,User__c,PTRF__r.Name,Email_Address__c,User__r.Email,Jobview__c,Jobview_Type__c,Last_Notified__c,PTRF__c,PTRF_Number__c
                                                                  FROM PTRF_JobViewer_Info__c
                                                                  WHERE PTRF__c IN :ptrfIdSet AND User__c != null AND User__r.isActive = true];
                
                Map<String,List<PTRF_JobViewer_Info__c>> mapPtrfJobviewer = new Map<String,List<PTRF_JobViewer_Info__c>>();
                List<PTRF_JobViewer_Info__c> ptrfJobList;
                for(PTRF_JobViewer_Info__c ptrfJobObj : ptrfJobviewerList) {
                    if(mapPtrfJobviewer.get(ptrfJobObj.PTRF__r.Name) == null){
                        if(ptrfJobObj.User__c != null){                    
                            ptrfJobList = new List<PTRF_JobViewer_Info__c>();
                            ptrfJobList.add(ptrfJobObj);
                            mapPtrfJobviewer.put(ptrfJobObj.PTRF__r.Name,ptrfJobList);
                        }                            
                    }
                    else {
                        if(ptrfJobObj.User__c != null){
                            mapPtrfJobviewer.get(ptrfJobObj.PTRF__r.Name).add(ptrfJobObj);
                        }                            
                    }
                }
                
                
                Set<MRS_Layer_Chip_Association__c> mrsLayerChipSendEmail = new Set<MRS_Layer_Chip_Association__c>();
                Set<PTRF_JobViewer_Info__c> ptrfJobviewerSendEmail = new  Set<PTRF_JobViewer_Info__c>();
                
                for(String mstCustomerObj : mapMrsLayerChip.keySet()){
                    
                    List<MRS_Layer_Chip_Association__c> mrsChipListIterator = mapMrsLayerChip.get(mstCustomerObj); 
                    List<PTRF_JobViewer_Info__c> ptrfJobviewerIterator ;
                    //Customer GDSOUT Review
                    mrsLayerChipSendEmail.clear();
                    ptrfJobviewerSendEmail.clear();
                    for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsChipListIterator){
                        if(mrsLayerChipObj.Customer_GDSOUT_Review__c == 'Ready' && mrsLayerChipObj.Customer_GDSOUT_Review_Notified_Date__c!=null && mrsLayerChipObj.Customer_GDSOUT_Review_Notified_Date__c <= timeAfterInterval){
                            if(mapPtrfJobviewer.containsKey(mrsLayerChipObj.PTRF__r.Name)){
                                ptrfJobviewerIterator = mapPtrfJobviewer.get(mrsLayerChipObj.PTRF__r.Name);
                                for(PTRF_JobViewer_Info__c ptrfJobObj : ptrfJobviewerIterator){
                                    if(ptrfJobObj.Jobview_Type__c.contains('Prime GDSOUT Review') && ptrfJobObj.Jobview__c == 'Customer')
                                    {
                                        
                                        ptrfJobviewerSendEmail.add(ptrfJobObj);
                                    }
                                }
                                if(ptrfJobviewerSendEmail != null && ptrfJobviewerSendEmail.size() > 0){
                                    mrsLayerChipSendEmail.add(mrsLayerChipObj);
                                    if(mrsObjToUpdate.get(mrsLayerChipObj.Id) != null){
                                        mrsObjToUpdate.get(mrsLayerChipObj.Id).Customer_GDSOUT_Review_Notified_Date__c = System.now();
                                    }
                                    else {
                                        mrsLayerChipObj.Customer_GDSOUT_Review_Notified_Date__c = System.now();
                                        mrsObjToUpdate.put(mrsLayerChipObj.Id,mrsLayerChipObj);
                                    }
                                }
                            }
                        }
                    }
                    
                    if(mrsLayerChipSendEmail != null && ptrfJobviewerSendEmail != null && mrsLayerChipSendEmail.size() > 0 && ptrfJobviewerSendEmail.size() > 0){
                        Messaging.SingleEmailMessage[] mail = checkJobviewerPerPtrf(mrsLayerChipSendEmail,ptrfJobviewerSendEmail,'CustomerGDSOUTReview',templateList,finalAccountUserMap,acctIdAccountProxyListMap,owa);
                        if(mail != null && mail.size() > 0){                   
                            allMail.addAll(mail);
                        } 
                    }
                    
                    //Foundry GDSOUT Review
                    mrsLayerChipSendEmail.clear();
                    ptrfJobviewerSendEmail.clear();
                    for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsChipListIterator){
                        if(mrsLayerChipObj.Foundry_GDSOUT_Review__c == 'Ready' && mrsLayerChipObj.Foundry_GDSOUT_Review_Notified_Date__c!=null && mrsLayerChipObj.Foundry_GDSOUT_Review_Notified_Date__c <= timeAfterInterval){
                            if(mapPtrfJobviewer.containsKey(mrsLayerChipObj.PTRF__r.Name)){
                                ptrfJobviewerIterator = mapPtrfJobviewer.get(mrsLayerChipObj.PTRF__r.Name);
                                for(PTRF_JobViewer_Info__c ptrfJobObj : ptrfJobviewerIterator){
                                    if(ptrfJobObj.Jobview_Type__c.contains('Prime GDSOUT Review') && ptrfJobObj.Jobview__c == 'Foundry')
                                    {
                                        
                                        ptrfJobviewerSendEmail.add(ptrfJobObj);
                                    }
                                }
                                if(ptrfJobviewerSendEmail != null && ptrfJobviewerSendEmail.size() > 0){
                                    mrsLayerChipSendEmail.add(mrsLayerChipObj);
                                    if(mrsObjToUpdate.get(mrsLayerChipObj.Id) != null){
                                        mrsObjToUpdate.get(mrsLayerChipObj.Id).Foundry_GDSOUT_Review_Notified_Date__c = System.now();
                                    }
                                    else {
                                        mrsLayerChipObj.Foundry_GDSOUT_Review_Notified_Date__c = System.now();
                                        mrsObjToUpdate.put(mrsLayerChipObj.Id,mrsLayerChipObj);
                                    }
                                }
                            }
                        }
                    }
                    
                    if(mrsLayerChipSendEmail != null && ptrfJobviewerSendEmail != null && mrsLayerChipSendEmail.size() > 0 && ptrfJobviewerSendEmail.size() > 0){
                        Messaging.SingleEmailMessage[] mail = checkJobviewerPerPtrf(mrsLayerChipSendEmail,ptrfJobviewerSendEmail,'FoundryGDSOUTReview',templateList,finalAccountUserMap,acctIdAccountProxyListMap,owa);
                        if(mail != null && mail.size() > 0){                   
                            allMail.addAll(mail);
                        } 
                    }
                    
                    //Customer Frame Mockup Review
                    mrsLayerChipSendEmail.clear();
                    ptrfJobviewerSendEmail.clear();
                    for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsChipListIterator){
                        if(mrsLayerChipObj.Customer_Frame_Mockup__c == 'Ready' && mrsLayerChipObj.Customer_Frame_Mockup_Notified_Date__c!=null && mrsLayerChipObj.Customer_Frame_Mockup_Notified_Date__c <= timeAfterInterval){
                            if(mapPtrfJobviewer.containsKey(mrsLayerChipObj.PTRF__r.Name)){
                                ptrfJobviewerIterator = mapPtrfJobviewer.get(mrsLayerChipObj.PTRF__r.Name);
                                for(PTRF_JobViewer_Info__c ptrfJobObj : ptrfJobviewerIterator){
                                    if(ptrfJobObj.Jobview_Type__c.contains('Frame Mockup') && ptrfJobObj.Jobview__c == 'Customer')
                                    {
                                       
                                        ptrfJobviewerSendEmail.add(ptrfJobObj);
                                    }
                                }
                                if(ptrfJobviewerSendEmail != null && ptrfJobviewerSendEmail.size() > 0){
                                    mrsLayerChipSendEmail.add(mrsLayerChipObj);
                                    if(mrsObjToUpdate.get(mrsLayerChipObj.Id) != null){
                                        mrsObjToUpdate.get(mrsLayerChipObj.Id).Customer_Frame_Mockup_Notified_Date__c = System.now();
                                    }
                                    else {
                                        mrsLayerChipObj.Customer_Frame_Mockup_Notified_Date__c = System.now();
                                        mrsObjToUpdate.put(mrsLayerChipObj.Id,mrsLayerChipObj);
                                    }
                                }
                            }
                        }
                    }
                    
                    if(mrsLayerChipSendEmail != null && ptrfJobviewerSendEmail != null && mrsLayerChipSendEmail.size() > 0 && ptrfJobviewerSendEmail.size() > 0){
                        Messaging.SingleEmailMessage[] mail = checkJobviewerPerPtrf(mrsLayerChipSendEmail,ptrfJobviewerSendEmail,'CustomerFrameMockup',templateList,finalAccountUserMap,acctIdAccountProxyListMap,owa);
                        if(mail != null && mail.size() > 0){                   
                            allMail.addAll(mail);
                        } 
                    }
                    
                    //Foundry Frame Mockup Review
                    mrsLayerChipSendEmail.clear();
                    ptrfJobviewerSendEmail.clear();
                    for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsChipListIterator){
                        if(mrsLayerChipObj.Foundry_Frame_Mockup__c == 'Ready' && mrsLayerChipObj.Foundry_Frame_Mockup_Notified_Date__c!=null && mrsLayerChipObj.Foundry_Frame_Mockup_Notified_Date__c <= timeAfterInterval){
                            if(mapPtrfJobviewer.containsKey(mrsLayerChipObj.PTRF__r.Name)){
                                ptrfJobviewerIterator = mapPtrfJobviewer.get(mrsLayerChipObj.PTRF__r.Name);
                                for(PTRF_JobViewer_Info__c ptrfJobObj : ptrfJobviewerIterator){
                                    if(ptrfJobObj.Jobview_Type__c.contains('Frame Mockup') && ptrfJobObj.Jobview__c == 'Foundry')
                                    {
                                       
                                        ptrfJobviewerSendEmail.add(ptrfJobObj);
                                    }
                                }
                                if(ptrfJobviewerSendEmail != null && ptrfJobviewerSendEmail.size() > 0){
                                    mrsLayerChipSendEmail.add(mrsLayerChipObj);
                                    if(mrsObjToUpdate.get(mrsLayerChipObj.Id) != null){
                                        mrsObjToUpdate.get(mrsLayerChipObj.Id).Foundry_Frame_Mockup_Notified_Date__c = System.now();
                                    }
                                    else {
                                        mrsLayerChipObj.Foundry_Frame_Mockup_Notified_Date__c = System.now();
                                        mrsObjToUpdate.put(mrsLayerChipObj.Id,mrsLayerChipObj);
                                    }
                                }
                            }
                        }
                    }
                    
                    if(mrsLayerChipSendEmail != null && ptrfJobviewerSendEmail != null && mrsLayerChipSendEmail.size() > 0 && ptrfJobviewerSendEmail.size() > 0){
                        Messaging.SingleEmailMessage[] mail = checkJobviewerPerPtrf(mrsLayerChipSendEmail,ptrfJobviewerSendEmail,'FoundryFrameMockup',templateList,finalAccountUserMap,acctIdAccountProxyListMap,owa);
                        if(mail != null && mail.size() > 0){                   
                            allMail.addAll(mail);
                        } 
                    }
                    
                    //Customer MEBES Jobview
                    mrsLayerChipSendEmail.clear();
                    ptrfJobviewerSendEmail.clear();
                    for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsChipListIterator){
                        if(mrsLayerChipObj.Customer_MEBES_Jobview__c == 'Ready' && mrsLayerChipObj.Customer_MEBES_Jobview_Notified_Date__c!=null && mrsLayerChipObj.Customer_MEBES_Jobview_Notified_Date__c <= timeAfterInterval){
                            if(mapPtrfJobviewer.containsKey(mrsLayerChipObj.PTRF__r.Name)){
                                ptrfJobviewerIterator = mapPtrfJobviewer.get(mrsLayerChipObj.PTRF__r.Name);
                                for(PTRF_JobViewer_Info__c ptrfJobObj : ptrfJobviewerIterator){
                                    if(ptrfJobObj.Jobview_Type__c.contains('MEBES Jobview') && ptrfJobObj.Jobview__c == 'Customer')
                                    {
                                        
                                        ptrfJobviewerSendEmail.add(ptrfJobObj);
                                    }
                                }
                                if(ptrfJobviewerSendEmail != null && ptrfJobviewerSendEmail.size() > 0){
                                    mrsLayerChipSendEmail.add(mrsLayerChipObj);
                                    if(mrsObjToUpdate.get(mrsLayerChipObj.Id) != null){
                                        mrsObjToUpdate.get(mrsLayerChipObj.Id).Customer_MEBES_Jobview_Notified_Date__c = System.now();
                                    }
                                    else {
                                        mrsLayerChipObj.Customer_MEBES_Jobview_Notified_Date__c = System.now();
                                        mrsObjToUpdate.put(mrsLayerChipObj.Id,mrsLayerChipObj);
                                    }
                                }
                            }
                        }
                    }
                    
                    if(mrsLayerChipSendEmail != null && ptrfJobviewerSendEmail != null && mrsLayerChipSendEmail.size() > 0 && ptrfJobviewerSendEmail.size() > 0){
                        Messaging.SingleEmailMessage[] mail = checkJobviewerPerPtrf(mrsLayerChipSendEmail,ptrfJobviewerSendEmail,'CustomerMEBES',templateList,finalAccountUserMap,acctIdAccountProxyListMap,owa);
                        if(mail != null && mail.size() > 0){                   
                            allMail.addAll(mail);
                        } 
                    }
                    
                    //Foundry MEBES Jobview
                    mrsLayerChipSendEmail.clear();
                    ptrfJobviewerSendEmail.clear();
                    for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsChipListIterator){
                        if(mrsLayerChipObj.Foundry_MEBES_Jobview__c == 'Ready' && mrsLayerChipObj.Foundry_MEBES_Jobview_Notified_Date__c!=null && mrsLayerChipObj.Foundry_MEBES_Jobview_Notified_Date__c <= timeAfterInterval){
                            if(mapPtrfJobviewer.containsKey(mrsLayerChipObj.PTRF__r.Name)){
                                ptrfJobviewerIterator = mapPtrfJobviewer.get(mrsLayerChipObj.PTRF__r.Name);
                                for(PTRF_JobViewer_Info__c ptrfJobObj : ptrfJobviewerIterator){
                                    if(ptrfJobObj.Jobview_Type__c.contains('MEBES Jobview') && ptrfJobObj.Jobview__c == 'Foundry')
                                    {
                                        //mrsLayerChipSendEmail.add(mrsLayerChipObj);
                                        ptrfJobviewerSendEmail.add(ptrfJobObj);
                                    }
                                }
                                if(ptrfJobviewerSendEmail != null && ptrfJobviewerSendEmail.size() > 0){
                                    mrsLayerChipSendEmail.add(mrsLayerChipObj);
                                    if(mrsObjToUpdate.get(mrsLayerChipObj.Id) != null){
                                        mrsObjToUpdate.get(mrsLayerChipObj.Id).Foundry_MEBES_Jobview_Notified_Date__c = System.now();
                                    }
                                    else {
                                        mrsLayerChipObj.Foundry_MEBES_Jobview_Notified_Date__c = System.now();
                                        mrsObjToUpdate.put(mrsLayerChipObj.Id,mrsLayerChipObj);
                                    }
                                }
                            }
                        }
                    }
                    if(mrsLayerChipSendEmail != null && ptrfJobviewerSendEmail != null && mrsLayerChipSendEmail.size() > 0 && ptrfJobviewerSendEmail.size() > 0){
                        Messaging.SingleEmailMessage[] mail = checkJobviewerPerPtrf(mrsLayerChipSendEmail,ptrfJobviewerSendEmail,'FoundryMEBES',templateList,finalAccountUserMap,acctIdAccountProxyListMap,owa);
                        if(mail != null && mail.size() > 0){                   
                            allMail.addAll(mail);
                        } 
                    }
                }
                
            }
            
        } 
        Set<String> publicGroupToUpdate = new Set<String>();        
        Map<String,Swift_Public_Group_Notification__c> SwiftPublicGroupNotification = Swift_Public_Group_Notification__c.getAll();
        if(mapMrsLayerChipAnother != null){
            Set<MRS_Layer_Chip_Association__c> mrsLayerChipListAnother = new Set<MRS_Layer_Chip_Association__c>();
            
            for(String mstObj : mapMrsLayerChipAnother.keySet()){
                //Tapeout Centre MEBES Jobview
                mrsLayerChipListAnother.clear();
                for(MRS_Layer_Chip_Association__c mrsObj : mapMrsLayerChipAnother.get(mstObj)){
                    if(mrsObj.Tapeout_Centre_MEBES_Jobview__c == 'Ready' && mrsObj.Tapeout_Centre_MEBES_Notified_Date__c!=null && mrsObj.Tapeout_Centre_MEBES_Notified_Date__c <= timeAfterInterval){
                        mrsLayerChipListAnother.add(mrsObj);
                        if(mrsObjToUpdate.get(mrsObj.Id) != null){
                            mrsObjToUpdate.get(mrsObj.Id).Tapeout_Centre_MEBES_Notified_Date__c = System.now();
                        }
                        else {
                            mrsObj.Tapeout_Centre_MEBES_Notified_Date__c = System.now();
                            mrsObjToUpdate.put(mrsObj.Id,mrsObj);
                        }
                    }
                }
                
                if(mrsLayerChipListAnother != null && mrsLayerChipListAnother.size() > 0){
                    Messaging.SingleEmailMessage[] mail = sendEmailToPublicGroups(mrsLayerChipListAnother,'TapeoutCentre',templateList,owa);
                    if(mail != null && mail.size() > 0){                   
                        
                        allMail.addAll(mail);
                    }                            
                }
                
                //Tapeout Application MEBES Jobview
                mrsLayerChipListAnother.clear();
                for(MRS_Layer_Chip_Association__c mrsObj : mapMrsLayerChipAnother.get(mstObj)){
                    if(mrsObj.Tapeout_Applications_MEBES_Jobview__c == 'Ready' && mrsObj.Tapeout_App_MEBES_Notified_Date__c!=null && mrsObj.Tapeout_App_MEBES_Notified_Date__c <= timeAfterInterval){
                        mrsLayerChipListAnother.add(mrsObj);
                        if(mrsObjToUpdate.get(mrsObj.Id) != null){
                            mrsObjToUpdate.get(mrsObj.Id).Tapeout_App_MEBES_Notified_Date__c = System.now();
                        }
                        else {
                            mrsObj.Tapeout_App_MEBES_Notified_Date__c = System.now();
                            mrsObjToUpdate.put(mrsObj.Id,mrsObj);
                        }
                    }
                }
                if(mrsLayerChipListAnother != null && mrsLayerChipListAnother.size() > 0){
                    Messaging.SingleEmailMessage[] mail = sendEmailToPublicGroups(mrsLayerChipListAnother,'TapeoutApp',templateList,owa);
                    if(mail != null && mail.size() > 0){                   
                        
                        allMail.addAll(mail);
                    } 
                }
                
                //Global Shuttle MEBES Jobview
                mrsLayerChipListAnother.clear();
                for(MRS_Layer_Chip_Association__c mrsObj : mapMrsLayerChipAnother.get(mstObj)){
                    if(mrsObj.GlobalShuttle_MEBES_Jobview__c == 'Ready' && mrsObj.GlobalShuttle_MEBES_Notified_Date__c!=null && mrsObj.GlobalShuttle_MEBES_Notified_Date__c <= timeAfterInterval){
                        mrsLayerChipListAnother.add(mrsObj);
                        if(mrsObjToUpdate.get(mrsObj.Id) != null){
                            mrsObjToUpdate.get(mrsObj.Id).GlobalShuttle_MEBES_Notified_Date__c = System.now();
                        }
                        else {
                            mrsObj.GlobalShuttle_MEBES_Notified_Date__c = System.now();
                            mrsObjToUpdate.put(mrsObj.Id,mrsObj);
                        }
                    }
                }
                if(mrsLayerChipListAnother != null && mrsLayerChipListAnother.size() > 0){
                    Messaging.SingleEmailMessage[] mail = sendEmailToPublicGroups(mrsLayerChipListAnother,'GlobalShuttle',templateList,owa);
                    if(mail != null && mail.size() > 0){                   
                        
                        allMail.addAll(mail);
                    } 
                }
                //TDTI-MPW MEBES Jobview
                mrsLayerChipListAnother.clear();
                for(MRS_Layer_Chip_Association__c mrsObj : mapMrsLayerChipAnother.get(mstObj)){
                    if(mrsObj.TDTI_MPW_MEBES_Jobview__c == 'Ready' && mrsObj.TDTI_MPW_MEBES_Notified_Date__c!=null && mrsObj.TDTI_MPW_MEBES_Notified_Date__c <= timeAfterInterval){
                        mrsLayerChipListAnother.add(mrsObj);
                        if(mrsObjToUpdate.get(mrsObj.Id) != null){
                            mrsObjToUpdate.get(mrsObj.Id).TDTI_MPW_MEBES_Notified_Date__c = System.now();
                        }
                        else {
                            mrsObj.TDTI_MPW_MEBES_Notified_Date__c = System.now();
                            mrsObjToUpdate.put(mrsObj.Id,mrsObj);
                        }
                    }
                }
                if(mrsLayerChipListAnother != null && mrsLayerChipListAnother.size() > 0){
                    Messaging.SingleEmailMessage[] mail = sendEmailToPublicGroups(mrsLayerChipListAnother,'TDTIMPW',templateList,owa);
                    if(mail != null && mail.size() > 0){                   
                        
                        allMail.addAll(mail);
                    } 
                }
                //MDP MEBES Jobview
                mrsLayerChipListAnother.clear();
                for(MRS_Layer_Chip_Association__c mrsObj : mapMrsLayerChipAnother.get(mstObj)){
                    if(mrsObj.MDP_MEBES_Jobview__c =='Ready' && mrsObj.MDP_MEBES_Notified_Date__c!=null && mrsObj.MDP_MEBES_Notified_Date__c <= timeAfterInterval){
                        mrsLayerChipListAnother.add(mrsObj);
                        if(mrsObjToUpdate.get(mrsObj.Id) != null){
                            mrsObjToUpdate.get(mrsObj.Id).MDP_MEBES_Notified_Date__c = System.now();
                        }
                        else {
                            mrsObj.MDP_MEBES_Notified_Date__c = System.now();
                            mrsObjToUpdate.put(mrsObj.Id,mrsObj);
                        }
                    }
                }
                if(mrsLayerChipListAnother != null && mrsLayerChipListAnother.size() > 0){
                    Messaging.SingleEmailMessage[] mail = sendEmailToPublicGroups(mrsLayerChipListAnother,'MDP',templateList,owa);
                    if(mail != null && mail.size() > 0){                   
                        
                        allMail.addAll(mail);
                    } 
                }
                
            }
                     
            try {
                update mrsObjToUpdate.values();
            }
            catch(DMLException ex){
                
            }
            
        }
        
        
        Messaging.SingleEmailMessage[] allMailLimit = new Messaging.SingleEmailMessage[]{};
        
        try{
            
            Messaging.SendEmailResult [] r = Messaging.sendEmail(allMail);
        }catch(Exception ex){
            
        }
        
    }
    /**
        @Method Name: sendEmailToPublicGroups
        @Parameters: Set<MRS_Layer_Chip_Association__c> mrsLayerChipListAnother,String page,Map<Id,Group> groupObj,Map<Id,List<Id>> mapIdAndGroupMember,List<User> usrlst,List<EmailTemplate> templateList,OrgWideEmailAddress owa
        @Return Type: Messaging.SingleEmailMessage[]
        @Description: This method creates the email for public groups
    **/
    public Messaging.SingleEmailMessage[] sendEmailToPublicGroups(Set<MRS_Layer_Chip_Association__c> mrsLayerChipListAnother,String page,List<EmailTemplate> templateList,OrgWideEmailAddress owa){
        EmailTemplate template;
        for(EmailTemplate templateObj : templateList){
            if(templateObj.DeveloperName == 'Swift_Reminder_Notification_MEBES_Jobview_with_only_MST'){
                template = templateObj;
            }
        }
        
        String subject;
        String htmlBody;
        String chipAndLayer = '';
        MRS_Layer_Chip_Association__c mrsLayerChip;
        for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipListAnother){
            subject = template.Subject.replace('<MRS.Mask Set Title>',mrsLayerChipObj.PTRF__r.MaskSetTitle__r.Name);
            htmlBody = template.HtmlValue.replace('#MaskSetTitle#',mrsLayerChipObj.PTRF__r.MaskSetTitle__r.Name);
            mrsLayerChip = mrsLayerChipObj;
            break;
        }
        for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipListAnother){
            if(mrsLayerChipObj.Layer__r.ROM_Code__c != null && mrsLayerChipObj.Layer__r.ROM_Code__c != '####' && mrsLayerChipObj.Layer__r.ROM_Code__c != 'NULL'){
                chipAndLayer = chipAndLayer+'<tr><td>'+'Chip Name: '+mrsLayerChipObj.Chip__r.Name+' layer(s) : '+mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+'('+mrsLayerChipObj.Layer__r.ROM_Code__c+') PTRF: '+mrsLayerChipObj.PTRF__r.Name+'</td></tr>';
            }
            else {
                chipAndLayer = chipAndLayer+'<tr><td>'+'Chip Name: '+mrsLayerChipObj.Chip__r.Name+' layer(s) : '+mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+' PTRF: '+mrsLayerChipObj.PTRF__r.Name+'</td></tr>';
            }
        }
        
        htmlBody = htmlBody.replace('<tr><td>Chip Name: Chip layer(s): Layer Jobdeck </td></tr>',chipAndLayer);
        if(page == 'TapeoutCentre'){
            htmlBody = htmlBody.replace('{!sObject__c.MergeField__c}',System.Label.Internal_URL + 'VFMRSMenu?iframe=VFMRSMEBESJobview?jobview=TapeoutCentre&Customer='+mrsLayerChip.Customer_Name__c+'&mst='+mrsLayerChip.PTRF__r.MaskSetTitle__c);
            htmlBody = htmlBody.replace('{!sObject.Name}','Tapeout Centre MEBES Jobview');
        }
        else if(page == 'TapeoutApp'){
            htmlBody = htmlBody.replace('{!sObject__c.MergeField__c}',System.Label.Internal_URL + 'VFMRSMenu?iframe=VFMRSMEBESJobview?jobview=TapeoutApp&Customer='+mrsLayerChip.Customer_Name__c+'&mst='+mrsLayerChip.PTRF__r.MaskSetTitle__c);
            htmlBody = htmlBody.replace('{!sObject.Name}','Tapeout Application MEBES Jobview'); 
        }
        else if(page == 'GlobalShuttle'){
            htmlBody = htmlBody.replace('{!sObject__c.MergeField__c}',System.Label.Internal_URL + 'VFMRSMenu?iframe=VFMRSMEBESJobview?jobview=GlobalShuttle&Customer='+mrsLayerChip.Customer_Name__c+'&mst='+mrsLayerChip.PTRF__r.MaskSetTitle__c);
            htmlBody = htmlBody.replace('{!sObject.Name}','Global Shuttle MEBES Jobview');  
        }
        else if(page == 'MDP'){
            htmlBody = htmlBody.replace('{!sObject__c.MergeField__c}',System.Label.Internal_URL + 'VFMRSMenu?iframe=VFMRSMEBESJobview?jobview=MDP&Customer='+mrsLayerChip.Customer_Name__c+'&mst='+mrsLayerChip.PTRF__r.MaskSetTitle__c);
            htmlBody = htmlBody.replace('{!sObject.Name}','MDP MEBES Jobview');
        }
        else if(page == 'TDTIMPW'){
            htmlBody = htmlBody.replace('{!sObject__c.MergeField__c}',System.Label.Internal_URL + 'VFMRSMenu?iframe=VFMRSMEBESJobview?jobview=MPWTDTI&Customer='+mrsLayerChip.Customer_Name__c+'&mst='+mrsLayerChip.PTRF__r.MaskSetTitle__c);
            htmlBody = htmlBody.replace('{!sObject.Name}','TDTI-MPW MEBES Jobview');
        }

        Map<String,Swift_Public_Group_Notification__c> SwiftPublicGroupNotification = Swift_Public_Group_Notification__c.getAll();
        

        String[] toAddresses = new String[]{};
        if(page == 'TapeoutCentre'){
            
            if(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c.contains(';')){
                toAddresses.addAll(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c.split(';')); 
            } 
            else {
                toAddresses.add(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c); 
            }

            
        }
        else if(page == 'TapeoutApp'){
            
            if(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_APPLICATION_EMAIL').Value__c.contains(';')){
                toAddresses.addAll(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_APPLICATION_EMAIL').Value__c.split(';')); 
            } 
            else {
                toAddresses.add(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_APPLICATION_EMAIL').Value__c); 
            }

            
        }
        else if(page == 'GlobalShuttle'){
            
            if(Environment_Variable__c.getInstance('SWIFT_GLOBALSHUTTLE_EMAIL').Value__c.contains(';')){
                toAddresses.addAll(Environment_Variable__c.getInstance('SWIFT_GLOBALSHUTTLE_EMAIL').Value__c.split(';')); 
            } 
            else {
                toAddresses.add(Environment_Variable__c.getInstance('SWIFT_GLOBALSHUTTLE_EMAIL').Value__c); 
            }
            Boolean flagForTechGeo = false;
            for(MRS_Layer_Chip_Association__c mrsObj : mrsLayerChipListAnother){
                if(mrsObj.PTRF__r.Tech_Geo__c != null && mrsObj.PTRF__r.Tech_Geo__c.contains('UM')){
                    if((double.valueOf(mrsObj.PTRF__r.Tech_Geo__c.toUpperCase().substringBefore('UM').trim())) <= 0.02){
                        flagForTechGeo = true;
                        break;
                    }
                }   
            }
            if(flagForTechGeo){
                if(Environment_Variable__c.getInstance('SWIFT_TDTI_MPW_EMAIL').Value__c.contains(';')){
                    toAddresses.addAll(Environment_Variable__c.getInstance('SWIFT_TDTI_MPW_EMAIL').Value__c.split(';')); 
                } 
                else {
                    toAddresses.add(Environment_Variable__c.getInstance('SWIFT_TDTI_MPW_EMAIL').Value__c); 
                }
            }

            
        }
        else if(page == 'MDP'){
            
            if(Environment_Variable__c.getInstance('SWIFT_MDP_EMAIL').Value__c.contains(';')){
                toAddresses.addAll(Environment_Variable__c.getInstance('SWIFT_MDP_EMAIL').Value__c.split(';')); 
            } 
            else {
                toAddresses.add(Environment_Variable__c.getInstance('SWIFT_MDP_EMAIL').Value__c); 
            }

            
        }
        else if(page == 'TDTIMPW'){
            
            if(Environment_Variable__c.getInstance('SWIFT_TDTI_MPW_EMAIL').Value__c.contains(';')){
                toAddresses.addAll(Environment_Variable__c.getInstance('SWIFT_TDTI_MPW_EMAIL').Value__c.split(';')); 
            } 
            else {
                toAddresses.add(Environment_Variable__c.getInstance('SWIFT_TDTI_MPW_EMAIL').Value__c); 
            }

           
        }

        Set<String> toAddressUnique = new Set<String>();
        toAddressUnique.addAll(toAddresses);
        toAddresses.clear();
        toAddresses.addAll(toAddressUnique);
       
        String[] CcAddress = new String[]{};
        String[] address = new String[]{};
        CcAddress = findCcAddress(mrsLayerChipListAnother,page,null,null);
        
        Set<String> ccAddressSet = new Set<String>();
        ccAddressSet.addAll(CcAddress);
        CcAddress.clear();
        CcAddress.addAll(ccAddressSet);
        String[] bccAddress = new String[]{}; 
        
        if(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.contains(';')){
            bccAddress.addAll(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.split(';')); 
        } 
        else {
            bccAddress.add(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c); 
        }          
        

        count = count + toAddresses.size();
        count = count + CcAddress.size();
        Messaging.SingleEmailMessage[] mail = MRSHandlerUtility.partingToCCBccAddress(toAddresses,CcAddress,bccAddress,owa,true,subject,htmlBody);
        
        if(mail != null && mail.size() > 0){
            return mail;
        }
        else {
            return null;
        }

    }
    /**
        @Method Name: findCcAddress
        @Parameters: Set<MRS_Layer_Chip_Association__c> mrsLayerChipList,String page,Map<Id,Group> groupObj,Map<Id,List<Id>> mapIdAndGroupMember,List<User> usrlst,Map<Id,List<User>> finalAccountUserMap,Map<Id,List<Account_Team_Proxy__c>> acctIdAccountProxyListMap
        @Return Type: String[]
        @Description: This method finds the cc address for various emails
    **/
    
    public String[] findCcAddress(Set<MRS_Layer_Chip_Association__c> mrsLayerChipList,String page,Map<Id,List<User>> finalAccountUserMap,Map<Id,List<Account_Team_Proxy__c>> acctIdAccountProxyListMap){
        String[] CcAddress = new String[]{};
        
        if(page == 'CustomerGDSOUTReview' || page == 'CustomerFrameMockup' || page == 'CustomerMEBES'){
            Id accountId;
            for(MRS_Layer_Chip_Association__c mrslayerChipObj : mrsLayerChipList){
                accountId = mrslayerChipObj.Customer_Name__c;
                break;
            }
            if(finalAccountUserMap.containsKey(accountId)){
                List<User> userList = finalAccountUserMap.get(accountId);
                if(userList != null && userList.size() > 0){
                    for(User usrObj : userList){
                        CcAddress.add(usrObj.Email);    
                    }
                } 
            }
            if(acctIdAccountProxyListMap.containsKey(accountId)){                   
                List<Account_Team_Proxy__c> accProxyList = acctIdAccountProxyListMap.get(accountId);
                if(accProxyList != null && accProxyList.size() > 0){            
                    for(Account_Team_Proxy__c accObj:accProxyList){
                        CcAddress.add(accObj.User_Email__c);
                    }
                } 
            }                   
        }
        if(page == 'CustomerGDSOUTReview' || page == 'FoundryGDSOUTReview' || page == 'CustomerMEBES' || page == 'FoundryMEBES' || page == 'TapeoutCentre' || page == 'TapeoutApp'){
            String maskSetTitle;
            Boolean flagForTechGeo = false;
            for(MRS_Layer_Chip_Association__c mrslayerChipObj : mrsLayerChipList){
                maskSetTitle = mrslayerChipObj.PTRF__r.MaskSetTitle__r.Name;
                if(mrslayerChipObj.PTRF__r.Tech_Geo__c != null && mrslayerChipObj.PTRF__r.Tech_Geo__c.contains('UM')){
                    if((double.valueOf(mrslayerChipObj.PTRF__r.Tech_Geo__c.toUpperCase().substringBefore('UM').trim())) <= 0.02){
                        flagForTechGeo = true;
                        break;
                    }
                }  
            }
            
            if(maskSetTitle.startsWith('MPW')){
                if(Environment_Variable__c.getInstance('SWIFT_GLOBALSHUTTLE_EMAIL').Value__c.contains(';')){
                    CcAddress.addAll(Environment_Variable__c.getInstance('SWIFT_GLOBALSHUTTLE_EMAIL').Value__c.split(';')); 
                } 
                else {
                    CcAddress.add(Environment_Variable__c.getInstance('SWIFT_GLOBALSHUTTLE_EMAIL').Value__c); 
                }
            }
            
            if(flagForTechGeo){
                if(Environment_Variable__c.getInstance('SWIFT_TDTI_MPW_EMAIL').Value__c.contains(';')){
                    CcAddress.addAll(Environment_Variable__c.getInstance('SWIFT_TDTI_MPW_EMAIL').Value__c.split(';')); 
                } 
                else {
                    CcAddress.add(Environment_Variable__c.getInstance('SWIFT_TDTI_MPW_EMAIL').Value__c); 
                }
            }
            
        }
        if(page == 'MDP'){
            String maskSetTitle;
            for(MRS_Layer_Chip_Association__c mrslayerChipObj : mrsLayerChipList){
                maskSetTitle = mrslayerChipObj.PTRF__r.MaskSetTitle__r.Name;
                break;
            }
            if(maskSetTitle.startsWith('MPW')){
                if(Environment_Variable__c.getInstance('SWIFT_TDTI_MPW_EMAIL').Value__c.contains(';')){
                    CcAddress.addAll(Environment_Variable__c.getInstance('SWIFT_TDTI_MPW_EMAIL').Value__c.split(';')); 
                } 
                else {
                    CcAddress.add(Environment_Variable__c.getInstance('SWIFT_TDTI_MPW_EMAIL').Value__c); 
                }
            }
        }
        if(CcAddress != null){
            return CcAddress;
        }
        else {
            return null;
        }
    }
    
    /**
        @Method Name: checkJobviewerPerPtrf
        @Parameters: Set<MRS_Layer_Chip_Association__c> mrsLayerChipList,Set<PTRF_JobViewer_Info__c> ptrfJobviewerList,String page,Map<Id,Group> groupObj,Map<Id,List<Id>> mapIdAndGroupMember,List<User> usrlst,List<EmailTemplate> templateList,Map<Id,List<User>> finalAccountUserMap,Map<Id,List<Account_Team_Proxy__c>> acctIdAccountProxyListMap,OrgWideEmailAddress owa
        @Return Type: Messaging.SingleEmailMessage[]
        @Description: This method checks for jobviewers per PTRF
    **/
    public Messaging.SingleEmailMessage[] checkJobviewerPerPtrf(Set<MRS_Layer_Chip_Association__c> mrsLayerChipList,Set<PTRF_JobViewer_Info__c> ptrfJobviewerList,String page,List<EmailTemplate> templateList,Map<Id,List<User>> finalAccountUserMap,Map<Id,List<Account_Team_Proxy__c>> acctIdAccountProxyListMap,OrgWideEmailAddress owa){
        Messaging.SingleEmailMessage[] allMail = new Messaging.SingleEmailMessage[]{};
        
        Map<Id,Set<PTRF_JobViewer_Info__c>> userPtrfMap = new Map<Id,Set<PTRF_JobViewer_Info__c>>();
        Set<PTRF_JobViewer_Info__c> ptrfJobviewerSet;
        for(PTRF_JobViewer_Info__c jobObj : ptrfJobviewerList){
            if(jobObj.User__c != null){
                if(userPtrfMap.get(jobObj.User__c) != null){
                    userPtrfMap.get(jobObj.User__c).add(jobObj);    
                }
                else {
                    ptrfJobviewerSet = new Set<PTRF_JobViewer_Info__c>();
                    ptrfJobviewerSet.add(jobObj);
                    userPtrfMap.put(jobObj.User__c,ptrfJobviewerSet);
                }
            }
        }
        
        
        Set<MRS_Layer_Chip_Association__c> mrsLayerChipSetToSendEmail = new Set<MRS_Layer_Chip_Association__c>();
        for(Id userId : userPtrfMap.keySet()){
            mrsLayerChipSetToSendEmail.clear();
            for(PTRF_JobViewer_Info__c ptrfJob : userPtrfMap.get(userId)){
                for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipList){
                    if(ptrfJob.PTRF__c == mrsLayerChipObj.PTRF__c){
                        mrsLayerChipSetToSendEmail.add(mrsLayerChipObj);
                    }
                }
            }
            if(userPtrfMap.get(userId) != null){         
                Messaging.SingleEmailMessage[] mail = sendEmailToJobviewers(mrsLayerChipSetToSendEmail,userPtrfMap.get(userId),page,templateList,finalAccountUserMap,acctIdAccountProxyListMap,owa);
                if(mail != null && mail.size() > 0){
                    allMail.addAll(mail);
                }
            }                
        }
        if(allMail != null && allMail.size() > 0){
            return allMail;
        }
        else {
            return null;
        }
    }
    
    /**
        @Method Name: sendEmailToJobviewers
        @Parameters: Set<MRS_Layer_Chip_Association__c> mrsLayerChipList,Set<PTRF_JobViewer_Info__c> ptrfJobviewerList,String reviewType,Map<Id,Group> groupObj,Map<Id,List<Id>> mapIdAndGroupMember,List<User> usrlst,List<EmailTemplate> templateList,Map<Id,List<User>> finalAccountUserMap,Map<Id,List<Account_Team_Proxy__c>> acctIdAccountProxyListMap,OrgWideEmailAddress owa
        @Return Type: Messaging.SingleEmailMessage[]
        @Description: This method creates emails for GDSOUT, Frame Mockup and MEBES
    **/
    public Messaging.SingleEmailMessage[] sendEmailToJobviewers(Set<MRS_Layer_Chip_Association__c> mrsLayerChipList,Set<PTRF_JobViewer_Info__c> ptrfJobviewerList,String reviewType,List<EmailTemplate> templateList,Map<Id,List<User>> finalAccountUserMap,Map<Id,List<Account_Team_Proxy__c>> acctIdAccountProxyListMap,OrgWideEmailAddress owa) {
        EmailTemplate template;
        
        if(reviewType == 'CustomerGDSOUTReview' || reviewType == 'FoundryGDSOUTReview'){
            for(EmailTemplate templateObj : templateList){
                if(templateObj.DeveloperName == 'Swift_Reminder_Notification_GDSOUT_Review'){
                    template = templateObj;
                }
            }
        }
        else if(reviewType == 'CustomerFrameMockup' || reviewType == 'FoundryFrameMockup'){
            for(EmailTemplate templateObj : templateList){
                if(templateObj.DeveloperName == 'Swift_Reminder_Notification_Frame_Mockup'){
                    template = templateObj;
                }
            } 
        }
        else if(reviewType == 'CustomerMEBES' || reviewType == 'FoundryMEBES'){
            for(EmailTemplate templateObj : templateList){
                if(templateObj.DeveloperName == 'Swift_Reminder_Notification_MEBES_Jobview'){
                    template = templateObj;
                }
            }
        }
        
        
        
        String subject;
        String htmlBody;
        MRS_Layer_Chip_Association__c mrsLayerChip;
        for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipList){
            subject = template.Subject.replace('<MRS.Mask Set Title>',mrsLayerChipObj.PTRF__r.MaskSetTitle__r.Name);
            htmlBody = template.HtmlValue.replace('#CustomerName(ShortName)#',mrsLayerChipObj.Customer_Name__r.Name+'('+mrsLayerChipObj.Customer_Name__r.Short_Name__c+')');
            htmlBody = htmlBody.replace('#MaskSetTitle#',mrsLayerChipObj.PTRF__r.MaskSetTitle__r.Name);
            mrsLayerChip = mrsLayerChipObj;
            break;
        }
        String chipAndLayer='';
        Set<String> ptrfName = new Set<String>();
        String ptrfNameToDisplay ='';
        if(reviewType == 'CustomerGDSOUTReview' || reviewType == 'FoundryGDSOUTReview'){
            for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipList){
                if(mrsLayerChipObj.Layer__r.ROM_Code__c != null && mrsLayerChipObj.Layer__r.ROM_Code__c != '####' && mrsLayerChipObj.Layer__r.ROM_Code__c != 'NULL'){
                    chipAndLayer = chipAndLayer+'<tr><td>'+'Chip Name: '+mrsLayerChipObj.Chip__r.Name+' layer(s) : '+mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+'('+mrsLayerChipObj.Layer__r.ROM_Code__c+') PTRF: '+mrsLayerChipObj.PTRF__r.Name+'</td></tr>';
                }
                else {
                    chipAndLayer = chipAndLayer+'<tr><td>'+'Chip Name: '+mrsLayerChipObj.Chip__r.Name+' layer(s) : '+mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+' PTRF: '+mrsLayerChipObj.PTRF__r.Name+'</td></tr>';
                }
            }
            htmlBody = htmlBody.replace('<tr><td>Chip Name: Chip layer(s) : Layer</td></tr>',chipAndLayer);
            if(reviewType == 'CustomerGDSOUTReview'){
                htmlBody = htmlBody.replace('{!sObject__c.MergeField__c}',System.Label.SWIFT_Community_URL + 'MyDevices?iframe=VFMRSGDSOUTReview?type=Customer&Customer='+mrsLayerChip.Customer_Name__c+'&mst='+mrsLayerChip.PTRF__r.MaskSetTitle__c);
                htmlBody = htmlBody.replace('{!sObject.Name}','Customer GDSOUT Review');
            }
            else if(reviewType == 'FoundryGDSOUTReview'){
                htmlBody = htmlBody.replace('{!sObject__c.MergeField__c}',System.Label.Internal_URL + 'VFMRSMenu?iframe=VFMRSGDSOUTReview?type=Foundry&Customer='+mrsLayerChip.Customer_Name__c+'&mst='+mrsLayerChip.PTRF__r.MaskSetTitle__c);
                htmlBody = htmlBody.replace('{!sObject.Name}','Foundry GDSOUT Review');
            }
        }
        else if(reviewType == 'CustomerFrameMockup' || reviewType == 'FoundryFrameMockup'){
            for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipList){
                ptrfName.add(mrsLayerChipObj.PTRF__r.Name);
            }
            Integer counter = 0;
            for(String strObj : ptrfName){
                if(counter == 0)
                    ptrfNameToDisplay = ptrfNameToDisplay+strObj;
                else
                    ptrfNameToDisplay = ptrfNameToDisplay+','+strObj;
                counter++;
            }
            htmlBody = htmlBody.replace('#ptrf#',ptrfNameToDisplay);
            if(reviewType == 'CustomerFrameMockup'){
                htmlBody = htmlBody.replace('{!sObject__c.MergeField__c}',System.Label.SWIFT_Community_URL + 'MyDevices?iframe=VFMRSFrameMockupReview?type=Customer&Customer='+mrsLayerChip.Customer_Name__c+'&mst='+mrsLayerChip.PTRF__r.MaskSetTitle__c);
                htmlBody = htmlBody.replace('{!sObject.Name}','Customer Frame Mockup Review');
            }
            else if(reviewType == 'FoundryFrameMockup'){
                htmlBody = htmlBody.replace('{!sObject__c.MergeField__c}',System.Label.Internal_URL + 'VFMRSMenu?iframe=VFMRSFrameMockupReview?type=Foundry&Customer='+mrsLayerChip.Customer_Name__c+'&mst='+mrsLayerChip.PTRF__r.MaskSetTitle__c);
                htmlBody = htmlBody.replace('{!sObject.Name}','Foundry Frame Mockup Review');
            }
        }
        else if(reviewType == 'CustomerMEBES' || reviewType == 'FoundryMEBES'){
            for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipList){
                if(mrsLayerChipObj.Layer__r.ROM_Code__c != null && mrsLayerChipObj.Layer__r.ROM_Code__c != '####' && mrsLayerChipObj.Layer__r.ROM_Code__c != 'NULL'){
                    chipAndLayer = chipAndLayer+'<tr><td>'+'Chip Name: '+mrsLayerChipObj.Chip__r.Name+' layer(s) : '+mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+'('+mrsLayerChipObj.Layer__r.ROM_Code__c+') PTRF: '+mrsLayerChipObj.PTRF__r.Name+'</td></tr>';
                }
                else {
                    chipAndLayer = chipAndLayer+'<tr><td>'+'Chip Name: '+mrsLayerChipObj.Chip__r.Name+' layer(s) : '+mrsLayerChipObj.Layer__r.Name+mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+') PTRF: '+mrsLayerChipObj.PTRF__r.Name+'</td></tr>';
                }
            }
                       
            htmlBody = htmlBody.replace('<tr><td>Chip Name: Chip layer(s): Layer Jobdeck </td></tr>',chipAndLayer);
            if(reviewType == 'CustomerMEBES'){
                htmlBody = htmlBody.replace('{!sObject__c.MergeField__c}',System.Label.SWIFT_Community_URL + 'MyDevices?iframe=VFMRSMEBESJobview?jobview=Customer&Customer='+mrsLayerChip.Customer_Name__c+'&mst='+mrsLayerChip.PTRF__r.MaskSetTitle__c);
                htmlBody = htmlBody.replace('{!sObject.Name}','Customer MEBES Jobview');
            }
            else if(reviewType == 'FoundryMEBES'){
                htmlBody = htmlBody.replace('{!sObject__c.MergeField__c}',System.Label.Internal_URL + 'VFMRSMenu?iframe=VFMRSMEBESJobview?jobview=Foundry&Customer='+mrsLayerChip.Customer_Name__c+'&mst='+mrsLayerChip.PTRF__r.MaskSetTitle__c);
                htmlBody = htmlBody.replace('{!sObject.Name}','Foundry MEBES Jobview'); 
            }
        }
        
        
        String[] toAddresses = new String[]{}; 
        String[] ccAddress = new String[]{};
        for(PTRF_JobViewer_Info__c ptrfJobObj : ptrfJobviewerList){
           
            toAddresses.add(ptrfJobObj.User__r.Email);
            break;
            
        }
        
        if(Label.MRS_Send_Email_To_Customer.equalsIgnoreCase('no') && (reviewType == 'CustomerGDSOUTReview' || reviewType == 'CustomerFrameMockup' || reviewType == 'CustomerMEBES')){
            toAddresses.clear();
        }
        
        Set<String> toAddressUnique = new Set<String>();
        toAddressUnique.addAll(toAddresses);
        toAddresses.clear();
        toAddresses.addAll(toAddressUnique);

       
        ccAddress = findCcAddress(mrsLayerChipList,reviewType,finalAccountUserMap,acctIdAccountProxyListMap);
        
        Set<String> ccAddressSet = new Set<String>();
        ccAddressSet.addAll(ccAddress);
        ccAddress.clear();
        ccAddress.addAll(ccAddressSet);
        String[] bccAddress = new String[]{}; 
        
        if(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.contains(';')){
            bccAddress.addAll(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.split(';')); 
        } 
        else {
            bccAddress.add(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c); 
        }
        String[] address = new String[]{};
        count = count + toAddresses.size();
        count = count + ccAddress.size();
        Messaging.SingleEmailMessage[] mail = MRSHandlerUtility.partingToCCBccAddress(toAddresses,ccAddress,bccAddress,owa,true,subject,htmlBody);
        
        if(mail != null && mail.size() > 0){
            return mail;
        }
        else {
            return null;
        }
    }
    global void finish(Database.BatchableContext BC) {  
        
    } 
}