/*************************************************************************************************************************************************************
@ Class:          RequestInformationTriggerHelper
@ Version:        1.0
@ Author:         Poulami Saha
@ Purpose:        Helper class which consist of logics used in Request Information Trigger.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 16.12.2016 / Poulami Saha / Created the class.
                  17.05.2017 - Case#00071976 (If option stage already past the Bid Quote. Create new RFQ should not move
                    the stage back to Bid Quote.)
                  28.06.2017 / Poulami Saha / Removed 'Lock Response Sheet' check from Status = 'Complete' validation
                  03.08.2017 / Poulami Saha / 1. Request status = completed validation logic to be updated as dependent on two conditions "Date quote letter 1st sent to sales" is not null and Quote is attatched(i.e in Attach Quote Document)
                                              2. Quote Status = Accepted when Customer accept/reject date is not null and point 1 (i.e above point)
                  14.08.2017 / Poulami Saha / 1. Request status to be populated as "Completed"  when Quote status is "Accepted/Rejected"
                                              2. If Quote status is "Accepted/Rejected" or Request status is "Completed" then Auto complete all the open tasks and open Route with status as "Auto Completed" also record the end date for task when updated to Auto complete
                                              3. Once the Quote is Cancelled then Auto complete all the open tasks and open Route with status as "Auto Cancelled"
**************************************************************************************************************************************************************/
Public Class RequestInformationTriggerHelper{
    public Map<Id,Request_Information__c> triggerOldMap { get; set; }

    /*********************************************************************************************************************************************************
    @ Constructor:    RequestInformationTriggerHelper
    @ Version:        1.0
    @ Author:         Poulami Saha
    @ Purpose:        Initialises the class for controller instance.
    **********************************************************************************************************************************************************/     
    public RequestInformationTriggerHelper(){      
        triggerOldMap = ((Map<Id,Request_Information__c>)Trigger.oldMap);
    }
    
    /**
    *  The Purpose of this method is to check 'Status' validation when set to 'Complete'. Setting 'Account. Opportunity and Device' value 
    *  @name <beforeInsertUpdMethod>
    *  @param <NA> 
    *  @return <Void>
    *  @throws exception-<exception description>
    */
    public void beforeInsertUpdMethod() {
        List<RFQ_Routing__c> rfqRouteLst=[select id,Status__c, RFQ__c from RFQ_Routing__c where RFQ__c in:trigger.new];
        List<BnP_Finance_Quote_Document__c> bnpFinDocLst = [Select id, name, BnP_Finance_Quote_Document__c from BnP_Finance_Quote_Document__c where BnP_Finance_Quote_Document__c in:trigger.new and Is_Financial_Document__c = false and Is_SQT_sheet__c = false and Is_Costing_Document__c = false];
        Map<Id, List<BnP_Finance_Quote_Document__c>> reqInfoIdBnpFinDocMap = new Map<Id, List<BnP_Finance_Quote_Document__c>>();
        
        List<Customer_Requirement__c> parentOptObjList = new List<Customer_Requirement__c>();
        List<Id> listOptionIds = new List<Id>();
        Map<ID,Schema.RecordTypeInfo> rt_Map = Request_Information__c.sObjectType.getDescribe().getRecordTypeInfosById();
        for(Request_Information__c reqInfo : (List<Request_Information__c>)trigger.new){
            if((reqInfo.Request_status__c == 'Complete' || reqInfo.Quote_Status__c == 'Accept') && rt_map.get(reqInfo.recordTypeID).getName().containsIgnoreCase('Request For Quote(RFQ)')){
                if(bnpFinDocLst.size() > 0){
                    for(BnP_Finance_Quote_Document__c rfqfinDoc:bnpFinDocLst){
                        if(rfqfinDoc.BnP_Finance_Quote_Document__c == reqInfo.id){
                            if(reqInfoIdBnpFinDocMap.containsKey(reqInfo.id)){
                                reqInfoIdBnpFinDocMap.get(reqInfo.id).add(rfqfinDoc);
                            }else{
                                reqInfoIdBnpFinDocMap.put(reqInfo.id, new List <BnP_Finance_Quote_Document__c> {
                                                rfqfinDoc
                                });
                            }
                        }
                    }
                }else{
                    if(reqInfo.Request_status__c == 'Complete'){
                        if(trigger.isUpdate){
                            if(triggerOldMap.get(reqInfo.Id).Request_status__c != reqInfo.Request_status__c){
                                reqInfo.addError('User can set Request Status = Completed once Date quote letter 1st sent to sales is populated and Quote is attached in Attach Quote Document section');
                            }
                        }
                        if(trigger.isInsert){
                            reqInfo.addError('User can set Request Status = Completed once Date quote letter 1st sent to sales is populated and Quote is attached in Attach Quote Document section');
                        }
                    }
                    if(reqInfo.Quote_Status__c == 'Accept'){
                        if(trigger.isUpdate){
                            if(triggerOldMap.get(reqInfo.Id).Quote_Status__c != reqInfo.Quote_Status__c){
                                reqInfo.addError('User can set Quote Status = Accept once Date quote letter 1st sent to sales, Customer accept/reject date is populated and Quote is attached in Attach Quote Document section');
                            }
                        }
                        if(trigger.isInsert){
                            reqInfo.addError('User can set Quote Status = Accept once Date quote letter 1st sent to sales, Customer accept/reject date is populated and Quote is attached in Attach Quote Document section');
                        }
                    }
                }
            }
        }

        for(Request_Information__c reqInfo : (List<Request_Information__c>)trigger.new){
            if((reqInfo.Request_status__c == 'Complete' || reqInfo.Quote_Status__c == 'Accept') && rt_map.get(reqInfo.recordTypeID).getName().containsIgnoreCase('Request For Quote(RFQ)')){
                List<BnP_Finance_Quote_Document__c> bnpFinDocList = reqInfoIdBnpFinDocMap.get(reqInfo.id);
                if(reqInfo.Request_status__c == 'Complete' && (reqInfo.Date_quote_letter_1st_sent_to_sales__c == null || bnpFinDocList == null || bnpFinDocList.size() == 0)){
                    if(trigger.isUpdate){
                        if(triggerOldMap.get(reqInfo.Id).Request_status__c != reqInfo.Request_status__c){
                            reqInfo.addError('User can set Request Status = Completed once Date quote letter 1st sent to sales is populated and Quote is attached in Attach Quote Document section');
                        }
                    }
                    if(trigger.isInsert){
                        reqInfo.addError('User can set Request Status = Completed once Date quote letter 1st sent to sales is populated and Quote is attached in Attach Quote Document section');
                    }
                }
                if(reqInfo.Quote_Status__c == 'Accept' && (reqInfo.Customer_accept_reject_date__c == null || reqInfo.Date_quote_letter_1st_sent_to_sales__c == null || bnpFinDocList == null || bnpFinDocList.size() == 0)){
                    if(trigger.isUpdate){
                        if(triggerOldMap.get(reqInfo.Id).Quote_Status__c != reqInfo.Quote_Status__c){
                            reqInfo.addError('User can set Quote Status = Accept once Date quote letter 1st sent to sales, Customer accept/reject date is populated and Quote is attached in Attach Quote Document section');
                        }
                    }
                    if(trigger.isInsert){
                        reqInfo.addError('User can set Quote Status = Accept once Date quote letter 1st sent to sales, Customer accept/reject date is populated and Quote is attached in Attach Quote Document section');
                    }
                }
            }
            listOptionIds.add(reqInfo.Customer_Requirement__c);
        }
        parentOptObjList = [SELECT id,Option_Stage__c, Device__c,Opportunity__c, Opportunity__r.AccountId  FROM Customer_Requirement__c WHERE ID IN :listOptionIds];
        
        for (Customer_Requirement__c option : parentOptObjList){
            for(Request_Information__c reqInfo : (List<Request_Information__c>)trigger.new){
                if(option.id == reqInfo.Customer_Requirement__c){
                    reqInfo.Device__c = option.Device__c;
                    reqInfo.Opportunity__c = option.Opportunity__c;
                    reqInfo.Account__c = option.Opportunity__r.AccountId;
                }
            }
        }
    }
    
    /**
    *  The Purpose of this method is to set owner field when Request Catcher is added. Check 'Last accepted Quote' when quote is accepted. 
    *  @name <beforeInsertMethod>
    *  @param <NA> 
    *  @return <Void>
    *  @throws exception-<exception description>
    */
    public void beforeInsertMethod(){
        Map<ID,Schema.RecordTypeInfo> rt_Map = Request_Information__c.sObjectType.getDescribe().getRecordTypeInfosById();
        for(Request_Information__c reqInfo : (List<Request_Information__c>)trigger.new){
            if(reqInfo.Primary_Request_Catcher__c != null && reqInfo.Primary_Request_Catcher__c != reqInfo.OwnerId){
                    reqInfo.OwnerId = reqInfo.Primary_Request_Catcher__c;
            }
            if(reqInfo.Quote_Status__c == 'Accept' && (rt_map.get(reqInfo.recordTypeID).getName().containsIgnoreCase('Request For Quote(RFQ)') || rt_map.get(reqInfo.recordTypeID).getName().containsIgnoreCase('RFQ Contract'))){
                    reqInfo.Skip_Validation__c = true;
                    reqInfo.Last_Accepted_Quote__c = true;
            }
            if((reqInfo.Quote_Status__c == 'Accept' || reqInfo.Quote_Status__c == 'Reject') && rt_map.get(reqInfo.recordTypeID).getName().containsIgnoreCase('Request For Quote(RFQ)')){
                reqInfo.Skip_Validation__c = true;
                reqInfo.Request_status__c = 'Complete';
            }
        }
    }
    
    /**
    *  The Purpose of this method is to set owner field when Request Catcher is updated. Update 'Last accepted Quote' when Quote Status is updated. 
    *  @name <beforeUpdateMethod>
    *  @param <NA> 
    *  @return <Void>
    *  @throws exception-<exception description>
    */
    public void beforeUpdateMethod(){
        //Map<Id, Id> optionRfqIdMap = new Map<Id, Id>();
        Map<ID,Schema.RecordTypeInfo> rt_Map = Request_Information__c.sObjectType.getDescribe().getRecordTypeInfosById();
        for(Request_Information__c reqInfo : (List<Request_Information__c>)trigger.new){
            if(reqInfo.Primary_Request_Catcher__c != null && (reqInfo.Primary_Request_Catcher__c <> triggerOldMap.get(reqInfo.Id).Primary_Request_Catcher__c))reqInfo.ownerid=reqInfo.Primary_Request_Catcher__c;
            else if(reqInfo.Primary_Request_Catcher__c == null && triggerOldMap.get(reqInfo.Id).Primary_Request_Catcher__c != null && reqInfo.ownerid == triggerOldMap.get(reqInfo.Id).Primary_Request_Catcher__c)reqInfo.ownerid=userinfo.getuserid();
            if(reqInfo.Quote_Status__c == 'Accept' && triggerOldMap.get(reqInfo.id).Quote_Status__c != 'Accept' && (rt_map.get(reqInfo.recordTypeID).getName().containsIgnoreCase('Request For Quote(RFQ)') || rt_map.get(reqInfo.recordTypeID).getName().containsIgnoreCase('RFQ Contract'))){
                    reqInfo.Skip_Validation__c = true;
                    reqInfo.Last_Accepted_Quote__c = true;
                    //optionRfqIdMap.put(reqInfo.Customer_Requirement__c, reqInfo.id);
            }else if(reqInfo.Quote_Status__c != 'Accept' && reqInfo.Last_Accepted_Quote__c == true && (rt_map.get(reqInfo.recordTypeID).getName().containsIgnoreCase('Request For Quote(RFQ)') || rt_map.get(reqInfo.recordTypeID).getName().containsIgnoreCase('RFQ Contract'))){
                    reqInfo.Last_Accepted_Quote__c = false;
            }
            system.debug('reqInfo.Quote_Status__c before upd :' +reqInfo.Quote_Status__c);
            system.debug('triggerOldMap.get(reqInfo.id).Quote_Status__c before upd :' +triggerOldMap.get(reqInfo.id).Quote_Status__c);
            if(((reqInfo.Quote_Status__c == 'Accept' && triggerOldMap.get(reqInfo.id).Quote_Status__c != 'Accept') || (reqInfo.Quote_Status__c == 'Reject' && triggerOldMap.get(reqInfo.id).Quote_Status__c != 'Reject')) && (rt_map.get(reqInfo.recordTypeID).getName().containsIgnoreCase('Request For Quote(RFQ)'))){
                system.debug('reqInfo.Quote_Status__c before upd :' +reqInfo.Quote_Status__c);
                system.debug('triggerOldMap.get(reqInfo.id).Quote_Status__c before upd :' +triggerOldMap.get(reqInfo.id).Quote_Status__c);
                reqInfo.Skip_Validation__c = true;
                reqInfo.Request_status__c = 'Complete';
            }
        }
        
        BnPRequestInfo_RevenueSnapShot.DeleteExistingSnapshot(Trigger.New,triggerOldMap); //Call this method to delete existing snapshots to avoid dulication of records
        BnPRequestInfo_RevenueSnapShot.createSnapshot(trigger.new,triggerOldMap); //call the method to create a snapshot from Quaterly Revenue 
    }
    
    /**
    *  The Purpose of this method is to update Option Stage to "Bid and Quote" on RFQ creation. Update 'Last accepted Quote' to false for previous accepted quote. 
    *  @name <afterInsertMethod>
    *  @param <NA> 
    *  @return <Void>
    *  @throws exception-<exception description>
    */
    public void afterInsertMethod(){
        List<Customer_Requirement__c> parentObjList = new List<Customer_Requirement__c>();
        List<Id> listIds = new List<Id>();
        List<Id> listOptionIdsToUpdate = new List<Id>();
        List<Id> listDeviceIds = new List<Id>();
        Map<ID,Schema.RecordTypeInfo> rt_Map = Request_Information__c.sObjectType.getDescribe().getRecordTypeInfosById();
        
        for (Request_Information__c childObj : (List<Request_Information__c>)trigger.new) {
            if(rt_map.get(childObj.recordTypeID).getName().containsIgnoreCase('Request For Quote(RFQ)') || rt_map.get(childObj.recordTypeID).getName().containsIgnoreCase('RFQ Contract')){
                //listIds.add(childObj.Customer_Requirement__c);
                listDeviceIds.add(childObj.Device__c);
            }
        }
        
        for (Request_Information__c childObj : (List<Request_Information__c>)trigger.new) {
            if(rt_map.get(childObj.recordTypeID).getName().containsIgnoreCase('Request For Quote(RFQ)')){
                listIds.add(childObj.Customer_Requirement__c);
            }
        }
        system.debug('&&&&&&&&&&&&&&&&&&&&&&&&');
        List<Request_Information__c> reqInfoList = [select id, Device__c, Last_Accepted_Quote__c, Skip_Validation__c, recordTypeID from Request_Information__c where Device__c in: listDeviceIds];
        List<Request_Information__c> reqInfoToUpdList = new List<Request_Information__c>();
        
        for (Request_Information__c reqInfo : (List<Request_Information__c>)trigger.new) {
            for(Request_Information__c reqInfoUpd : reqInfoList){
                if ((reqInfoUpd.Device__c == reqInfo.Device__c) && reqInfoUpd.Last_Accepted_Quote__c == true && (reqInfoUpd.Id != reqInfo.Id) && (rt_map.get(reqInfoUpd.recordTypeID).getName().containsIgnoreCase('Request For Quote(RFQ)') || rt_map.get(reqInfoUpd.recordTypeID).getName().containsIgnoreCase('RFQ Contract')) && reqInfo.Quote_Status__c == 'Accept')
                {
                    reqInfoUpd.Skip_Validation__c = true;
                    reqInfoUpd.Last_Accepted_Quote__c = FALSE;
                    reqInfoToUpdList.add(reqInfoUpd);
                }
            }
        }
        
        if (!reqInfoToUpdList.isEmpty()){
            update reqInfoToUpdList;
        }
        
        parentObjList = [SELECT id,Option_Stage__c FROM Customer_Requirement__c WHERE ID IN :listIds];
        for (Customer_Requirement__c option : parentObjList){
        /***** 17.05.2017 - Added for Case#00071976 Starts *****/
            if(option.Option_Stage__c == 'Try for Fit' || option.Option_Stage__c == 'Customer Engagement')
            {
                listOptionIdsToUpdate.add(option.id);
            }
        /***** 17.05.2017 - Added for Case#00071976 Stops *****/
        }
        BnP_OptionUtility genTechReq = new BnP_OptionUtility();
        if(!listOptionIdsToUpdate.isEmpty()){
            genTechReq.updateOptionStages(listOptionIdsToUpdate, 'Bid and Quote');
        }
    }
    
    /**
    *  The Purpose of this method is to Update 'Last accepted Quote' to false for previous accepted quote.
    *  @name <afterUpdateMethod>
    *  @param <NA> 
    *  @return <Void>
    *  @throws exception-<exception description>
    */
    public void afterUpdateMethod(){
    if(BNPStopRecurssion.runOnce()){
        Set<Id> oppProgTeamId = new Set<Id>();   
        Set<Id> devIds = new Set<Id>();
        List<Opportunity_Program_Team_Member__c> oppProgTeamList = new List<Opportunity_Program_Team_Member__c>();
        List<Opportunity_Program_Team_Member__c> oppProgTeamLst = new List<Opportunity_Program_Team_Member__c>();
        Map<Id,id> Mapdevice = new Map<Id,id>();
        Map<ID,Schema.RecordTypeInfo> rt_Map = Request_Information__c.sObjectType.getDescribe().getRecordTypeInfosById();
        List<Id> listDeviceIds = new List<Id>();
        for (Request_Information__c childObj : (List<Request_Information__c>)trigger.new) {
            if((rt_map.get(childObj.recordTypeID).getName().containsIgnoreCase('Request For Quote(RFQ)') || rt_map.get(childObj.recordTypeID).getName().containsIgnoreCase('RFQ Contract'))){
                listDeviceIds.add(childObj.Device__c);
            }
        }
        List<Request_Information__c> reqInfoList = [select id, Device__c, Last_Accepted_Quote__c, Skip_Validation__c, recordTypeID from Request_Information__c where Device__c in: listDeviceIds];
        List<Request_Information__c> reqInfoToUpdList = new List<Request_Information__c>();
        
        for (Request_Information__c reqInfo: (List<Request_Information__c>)trigger.new)
        {   
            for(Request_Information__c reqInfoUpd : reqInfoList){
                if ((reqInfoUpd.Device__c == reqInfo.Device__c) && reqInfoUpd.Last_Accepted_Quote__c == true && (reqInfoUpd.Id != reqInfo.Id) && (rt_map.get(reqInfoUpd.recordTypeID).getName().containsIgnoreCase('Request For Quote(RFQ)') || rt_map.get(reqInfoUpd.recordTypeID).getName().containsIgnoreCase('RFQ Contract')) && reqInfo.Quote_Status__c == 'Accept')
                {
                    if(triggerOldMap.get(reqInfo.id).Quote_Status__c != 'Accept'){
                        reqInfoUpd.Skip_Validation__c = true;
                        reqInfoUpd.Last_Accepted_Quote__c = FALSE;
                        reqInfoToUpdList.add(reqInfoUpd);
                    }
                }
            }
        }
        if (!reqInfoToUpdList.isEmpty()){
            update reqInfoToUpdList;
        }        
        system.debug('Inside Method');
        List<Device__c> deviceLst = [SELECT ID,Last_Accepted_Quote__c,Opportunity_Program__c FROM Device__c WHERE Last_Accepted_Quote__c IN : trigger.new];
        system.debug('deviceLst**:'+deviceLst);
        if(!deviceLst.isEmpty()){
            system.debug('deviceLst****:'+deviceLst);
            for(Device__c dev : deviceLst){
                devIds.add(dev.Opportunity_Program__c);
                Mapdevice.put(dev.Id,dev.Opportunity_Program__c);
            }  
            System.debug('devIds'+devIds);
        }
        if(!devIds.IsEmpty())
            System.debug('devIds**:'+devIds);
        oppProgTeamList = [SELECT ID, User__c,Opportunity_Program__c FROM Opportunity_Program_Team_Member__c where Opportunity_Program__c IN : devIds];
        system.debug('oppProgTeamList:'+oppProgTeamList);
        if(!oppProgTeamList.IsEmpty()){
            system.debug('oppProgTeamList:'+oppProgTeamList);
            for(Opportunity_Program_Team_Member__c oppProgTm : oppProgTeamList){
                oppProgTeamId.add(oppProgTm.User__c);                
            }
            System.debug('oppProgTeamId'+oppProgTeamId);
        }        
            if(!Mapdevice.IsEmpty()){
            try{    
                for(Request_Information__c reqInfo : (List<Request_Information__c>)trigger.new){
                    system.debug('oppProgTeamId**##:'+oppProgTeamId);
                    system.debug('triggerOldMap**##:'+triggerOldMap);
                    if(!oppProgTeamId.contains(reqInfo.Primary_Request_Catcher__c) && reqInfo.Primary_Request_Catcher__c != null && (triggerOldMap.get(reqInfo.Id).Primary_Request_Catcher__c != reqInfo.Primary_Request_Catcher__c  || (triggerOldMap.get(reqInfo.Id).Quote_Status__c != reqInfo.Quote_Status__c && reqInfo.Quote_Status__c == 'Accept'))){
                        Opportunity_Program_Team_Member__c oppProgTeam = new Opportunity_Program_Team_Member__c();
                        oppProgTeam.User__c = reqInfo.Primary_Request_Catcher__c;
                        oppProgTeam.Team_Role__c = 'Product Execution Manager';
                        oppProgTeam.Device_Access__c = 'Read/Write';
                        oppProgTeam.Opportunity_Program_Access__c = 'Read/Write';
                        oppProgTeam.Opportunity_Program__c = Mapdevice.get(reqInfo.Device__c);
                        oppProgTeamLst.add(oppProgTeam);
                        
                    }
                    if(!oppProgTeamId.contains(reqInfo.Backup_Request_Catcher__c) && reqInfo.Backup_Request_Catcher__c != null && (triggerOldMap.get(reqInfo.Id).Backup_Request_Catcher__c != reqInfo.Backup_Request_Catcher__c || (triggerOldMap.get(reqInfo.Id).Quote_Status__c != reqInfo.Quote_Status__c && reqInfo.Quote_Status__c == 'Accept'))){
                        system.debug('backup Catcher');
                        Opportunity_Program_Team_Member__c oppProgTeam = new Opportunity_Program_Team_Member__c();
                        oppProgTeam.User__c = reqInfo.Backup_Request_Catcher__c;
                        oppProgTeam.Team_Role__c = 'Product Execution Manager';
                        oppProgTeam.Device_Access__c = 'Read/Write';
                        oppProgTeam.Opportunity_Program_Access__c = 'Read/Write';
                        oppProgTeam.Opportunity_Program__c = Mapdevice.get(reqInfo.Device__c);
                        oppProgTeamLst.add(oppProgTeam);
                    }            
                }
                system.debug('oppProgTeamLst*:'+oppProgTeamLst);
                if(!oppProgTeamLst.IsEmpty())
                 system.debug('oppProgTeamLst:'+oppProgTeamLst);   
                    insert oppProgTeamLst;
                system.debug('oppProgTeamLst**:'+oppProgTeamLst);
            } catch(Exception e){
                GlobalUtility.logMessage('Error','RequestInformationTriggerHelper','afterUpdateMethod','','Exception is thrown during update of request catcher to Opportunity Program Team Member',String.valueof(e.getMessage()),'','BnP',e,0);      
            }
        }           
    }
        List<RFQ_Tasks_Routing__c> tskRouteToUpdate = new List<RFQ_Tasks_Routing__c>();
        map<id,list<RFQ_Tasks_Routing__c>> taskRouteMapNew = new map<id,list<RFQ_Tasks_Routing__c>>();
        
        list<RFQ_Tasks_Routing__c> tskRouteListNew = [select Id, Related_RFQ_Routing__r.RFQ__c,  Related_RFQ_Routing__r.RFQ__r.Id, Related_RFQ_Routing__r.RFQ__r.Negotiation_Date__c, 
            Related_RFQ_Routing__r.RFQ__r.Date_customer_wants_response__c, Start_Date__c, Actual_End_Date__c, Adjusted_Start_Date__c FROM RFQ_Tasks_Routing__c WHERE Related_RFQ_Routing__r.RFQ__r.Id IN :Trigger.newMap.keySet() AND Complete__c = false AND Task_Status__c <> 'Complete' AND Task_Status__c <> 'Cancel' AND Task_Status__c <> 'Auto Completed' AND Task_Status__c <> 'Auto Cancelled'];
        
        map<id,list<RFQ_Routing__c>> routeMap = new map<id,list<RFQ_Routing__c>>();
        List<RFQ_Routing__c> routeToUpdate = new List<RFQ_Routing__c>();
        
        list<RFQ_Routing__c> routeList = [select Id, RFQ__c, RFQ__r.Id, RFQ__r.Request_status__c, RFQ__r.Quote_Status__c
            FROM RFQ_Routing__c WHERE RFQ__r.Id IN :Trigger.newMap.keySet() AND Status__c <> 'Complete' AND Status__c <> 'Cancel'  AND Status__c <> 'Auto Completed' AND Status__c <> 'Auto Cancelled'];
        
        if(!tskRouteListNew.isEmpty()){
            for(RFQ_Tasks_Routing__c tskRoute : tskRouteListNew){
                System.debug('@TskRouting List ID: ' + tskRoute.Id);
                if(taskRouteMapNew.get(tskRoute.Related_RFQ_Routing__r.RFQ__c)!=null){
                    list<RFQ_Tasks_Routing__c> temp = taskRouteMapNew.get(tskRoute.Related_RFQ_Routing__r.RFQ__c);
                    temp.add(tskRoute);
                    taskRouteMapNew.put(tskRoute.Related_RFQ_Routing__r.RFQ__c,temp);
                }
                else{
                    taskRouteMapNew.put(tskRoute.Related_RFQ_Routing__r.RFQ__c,new list<RFQ_Tasks_Routing__c>{tskRoute});
                }
            }
        }  

        if(!routeList.isEmpty()){
            for(RFQ_Routing__c rut : routeList){
                if(routeMap.get(rut.RFQ__c)!=null){
                    list<RFQ_Routing__c> temp = routeMap.get(rut.RFQ__c);
                    temp.add(rut);
                    routeMap.put(rut.RFQ__c,temp);
                }
                else{
                    routeMap.put(rut.RFQ__c,new list<RFQ_Routing__c>{rut});
                }
            }
        }
                    
        for(Request_Information__c ph : (List<Request_Information__c>)trigger.new){
            list<RFQ_Tasks_Routing__c> tskRoutinglist = new List<RFQ_Tasks_Routing__c>();
            tskRoutinglist = taskRouteMapNew.get(ph.id);
            List<RFQ_Routing__c> routinglist = new List<RFQ_Routing__c>();
            routinglist = routeMap.get(ph.id);
            BNPStopTrigger.bypassTriggerLogic = true;
            boolean rouUpd = false;
            boolean tskUpd = false;
            if(tskRoutinglist != null && tskRoutinglist.size() > 0){
                for(RFQ_Tasks_Routing__c tskRoute : tskRoutinglist){
                    if(ph.Negotiation_Date__c != triggerOldMap.get(ph.id).Negotiation_Date__c || ph.Date_customer_wants_response__c != triggerOldMap.get(ph.id).Date_customer_wants_response__c){
                        if(ph.Negotiation_Date__c!=null && ph.Negotiation_Date__c != triggerOldMap.get(ph.id).Negotiation_Date__c){
                            tskRoute.Negotiation_Date_New1__c = ph.Negotiation_Date__c;
                            tskRoute.Skip_Validation__c = true;
                            tskUpd=true;
                        }
                        if(ph.Date_customer_wants_response__c !=null && ph.Date_customer_wants_response__c != triggerOldMap.get(ph.id).Date_customer_wants_response__c){
                            tskRoute.Customer_response_date_new1__c = ph.Date_customer_wants_response__c;
                            tskRoute.Skip_Validation__c = true;
                            tskUpd=true;
                        }
                    }
                    if((ph.Request_status__c == 'Complete' && ph.Request_status__c != triggerOldMap.get(ph.id).Request_status__c) || (ph.Quote_Status__c =='Accept' && ph.Quote_Status__c != triggerOldMap.get(ph.id).Quote_Status__c) || (ph.Quote_Status__c=='Reject' && ph.Quote_Status__c != triggerOldMap.get(ph.id).Quote_Status__c)){
                        tskRoute.Task_Status__c = 'Auto Completed';
                        tskRoute.End_Date__c = system.now();
                        if(tskRoute.Actual_End_Date__c == null){
                            if(tskRoute.Adjusted_Start_Date__c == null && tskRoute.Start_Date__c == null){
                                tskRoute.Actual_End_Date__c = system.now();
                                tskRoute.Adjusted_Start_Date__c = system.now();
                                tskRoute.Start_Date__c = system.now();
                            }else if(tskRoute.Adjusted_Start_Date__c == null && tskRoute.Start_Date__c != null){
                                tskRoute.Actual_End_Date__c = system.now();
                                tskRoute.Adjusted_Start_Date__c = system.now();
                            }else if(tskRoute.Adjusted_Start_Date__c != null && tskRoute.Start_Date__c != null){
                                tskRoute.Actual_End_Date__c = system.now();
                            }else if(tskRoute.Adjusted_Start_Date__c != null && tskRoute.Start_Date__c == null){
                                tskRoute.Actual_End_Date__c = system.now();
                                tskRoute.Start_Date__c = system.now();
                            }
                        }
                        tskRoute.Skip_Validation__c = true;
                        tskUpd=true;
                    }else if(ph.Request_status__c == 'Cancelled' && ph.Request_status__c != triggerOldMap.get(ph.id).Request_status__c){
                        tskRoute.Task_Status__c = 'Auto Cancelled';
                        tskRoute.End_Date__c = system.now();
                        if(tskRoute.Actual_End_Date__c == null){
                            if(tskRoute.Adjusted_Start_Date__c == null && tskRoute.Start_Date__c == null){
                                tskRoute.Actual_End_Date__c = system.now();
                                tskRoute.Adjusted_Start_Date__c = system.now();
                                tskRoute.Start_Date__c = system.now();
                            }else if(tskRoute.Adjusted_Start_Date__c == null && tskRoute.Start_Date__c != null){
                                tskRoute.Actual_End_Date__c = system.now();
                                tskRoute.Adjusted_Start_Date__c = system.now();
                            }else if(tskRoute.Adjusted_Start_Date__c != null && tskRoute.Start_Date__c != null){
                                tskRoute.Actual_End_Date__c = system.now();
                            }else if(tskRoute.Adjusted_Start_Date__c != null && tskRoute.Start_Date__c == null){
                                tskRoute.Actual_End_Date__c = system.now();
                                tskRoute.Start_Date__c = system.now();
                            }
                        }
                        tskRoute.Skip_Validation__c = true;
                        tskUpd=true;
                    }
                    if(tskUpd==true){tskRouteToUpdate.add(tskRoute);}
                    
                }
            }
            if(routinglist != null && routinglist.size() > 0){
                for(RFQ_Routing__c rut : routinglist){
                    if((ph.Request_status__c == 'Complete' && ph.Request_status__c != triggerOldMap.get(ph.id).Request_status__c) || (ph.Quote_Status__c =='Accept' && ph.Quote_Status__c != triggerOldMap.get(ph.id).Quote_Status__c) || (ph.Quote_Status__c=='Reject' && ph.Quote_Status__c != triggerOldMap.get(ph.id).Quote_Status__c)){
                        rut.Status__c = 'Auto Completed';
                        rouUpd = true;
                        //routeToUpdate.add(rut);
                    }else if(ph.Request_status__c == 'Cancelled' && ph.Request_status__c != triggerOldMap.get(ph.id).Request_status__c){
                        rut.Status__c = 'Auto Cancelled';
                        rouUpd = true;
                        //routeToUpdate.add(rut);
                    }
                    if(rouUpd==true){routeToUpdate.add(rut);}
                }
            }
        }
        if(!tskRouteToUpdate.isEmpty()){
            try{
                update tskRouteToUpdate;
            }catch(DmlException excp){
                for (Integer i = 0; i < excp.getNumDml(); i++) {
                    Trigger.new[0].addError(excp.getDmlMessage(i));
                    //Trigger.new[0].addError('"Negotiation Date" And "Date customer wants response" on Request Information can not be less than "Task Due Date and Time" of any dependent tasks.');
                }
            }
        }
        if(!routeToUpdate.isEmpty()){
            try{
                update routeToUpdate;
            }catch(DmlException excp){
                for (Integer i = 0; i < excp.getNumDml(); i++) {
                    Trigger.new[0].addError(excp.getDmlMessage(i));
                    //Trigger.new[0].addError('"Negotiation Date" And "Date customer wants response" on Request Information can not be less than "Task Due Date and Time" of any dependent tasks.');
                }
            }
        }
    }
    
    /**
    *  The Purpose of this method is to Update Device 'Last accepted Quote' and 'Primary Option' field values when quote is accepted.
    *  @name <afterInsertUpdateMethod>
    *  @param <NA> 
    *  @return <Void>
    *  @throws exception-<exception description>
    */
    public void afterInsertUpdateMethod()
    {
        Set<Id> oppIds = new Set<Id>(); 
        List<Opportunity> oppLst = new List<Opportunity>();
        List<Opportunity> oppupdtLst = new List<Opportunity>(); 
        Map<ID,Schema.RecordTypeInfo> rt_Map = Request_Information__c.sObjectType.getDescribe().getRecordTypeInfosById();
        Map<ID, Device__c> parentDevs = new Map<ID, Device__c>();
        List<Id> listDeviceIds = new List<Id>();
        Boolean isUpdateDevice = false;
        for (Request_Information__c childObj : (List<Request_Information__c>)trigger.new) 
        {
            if((rt_map.get(childObj.recordTypeID).getName().containsIgnoreCase('Request For Quote(RFQ)') || rt_map.get(childObj.recordTypeID).getName().containsIgnoreCase('RFQ Contract')))
            {
                listDeviceIds.add(childObj.Device__c);
            }
        }
        parentDevs = new Map<Id, Device__c>([SELECT id,Last_Accepted_Quote__c,(SELECT ID,Customer_Requirement__c  FROM RFQ__r) FROM Device__c WHERE ID IN :listDeviceIds]);
        
        List<Customer_Requirement__c> lstOptions = new List<Customer_Requirement__c>(); //Added by Arijit: Update The Last Accepted Quote in Associated Option Record
        for (Request_Information__c reqInfo : (List<Request_Information__c>)trigger.new) 
        {
            if(Trigger.isInsert){
                if(reqInfo.Last_Accepted_Quote__c == true)
                {
                    Device__c myParentDev = parentDevs.get(reqInfo.Device__c);
                    myParentDev.Last_Accepted_Quote__c = reqInfo.id;
                    myParentDev.Primary_Option__c = reqInfo.Customer_Requirement__c;
                    isUpdateDevice = true;
                    //Added by Arijit: Update The Last Accepted Quote in Associated Option Record
                    Customer_Requirement__c objOption = new Customer_Requirement__c();
                    objOption.Request_Information__c = reqInfo.Id;
                    objOption.Id = reqInfo.Customer_Requirement__c;
                    lstOptions.add(objOption);
                    //End
                }
            }
            if(Trigger.isUpdate){
                if(reqInfo.Last_Accepted_Quote__c == true && (triggerOldMap.get(reqInfo.id).Last_Accepted_Quote__c != reqInfo.Last_Accepted_Quote__c))
                {
                    Device__c myParentDev = parentDevs.get(reqInfo.Device__c);
                    myParentDev.Last_Accepted_Quote__c = reqInfo.id;
                    myParentDev.Primary_Option__c = reqInfo.Customer_Requirement__c;
                    isUpdateDevice = true;
                    //Added by Arijit: Update The Last Accepted Quote in Associated Option Record
                    Customer_Requirement__c objOption = new Customer_Requirement__c();
                    objOption.Request_Information__c = reqInfo.Id;
                    objOption.Id = reqInfo.Customer_Requirement__c;
                    lstOptions.add(objOption);
                    //End
                }
            }
        }
        if(isUpdateDevice == true)
        {
            try{
                update parentDevs.values();
            }catch(DmlException excp){
                for (Integer i = 0; i < excp.getNumDml(); i++) {
                    Trigger.new[0].addError('Device Validation: ' +excp.getDmlMessage(i) + excp.getDmlFieldNames(i));
                }
                //Trigger.new[0].addError('Please review Device data associated with this Request Information.');
            }
            
            update lstOptions; //Added by Arijit: Update The Last Accepted Quote in Associated Option Record
        }
        
        for(Request_Information__c reqInfo : (List<Request_Information__c>)trigger.new){
            if(reqInfo.Quote_Status__c == 'Accept'){
                oppIds.add(reqInfo.Opportunity__c);
            }    
        }
        if(!oppIds.IsEmpty()){
            if(BNPStopRecurssion.runOnce()){
                oppLst = [Select Id,StageName From Opportunity Where Id In :oppIds];
                for(Opportunity opp : oppLst){
                    if(opp.StageName == '2. Assessment' || opp.StageName == '3. Recommendation'){
                        opp.StageName = '4. Decision';
                        oppupdtLst.add(opp);        
                    }
                }
                if(!oppupdtLst.IsEmpty()){
                    try{
                        Update oppupdtLst;
                    }catch(Exception e){
                        GlobalUtility.logMessage('Error','RequestInformationTriggerHelper','afterInsertUpdateMethod','','Exception is thrown during update of request catcher to Opportunity Program Team Member',String.valueof(e.getMessage()),'','BnP',e,0);      
                    }   
                }
            }   
        }   
    }
    
      /**
    *  The Purpose of this method is to Update 'Primary Request Catcher' and 'Backup Request Catcher' on Option
    *  @name <updateRequestCatcher>
    *  @param <NA> 
    *  @return <Void>
    *  @throws exception-<exception description>
    */
    public void updateRequestCatcher(){
        Map<ID,Schema.RecordTypeInfo> rt_Map = Request_Information__c.sObjectType.getDescribe().getRecordTypeInfosById();
        Customer_Requirement__c optn;
        List<Customer_Requirement__c> optnList = new List<Customer_Requirement__c>();
        List<Request_Information__c> requestInfoList = new List<Request_Information__c>();
        Set<ID> userId = new Set<Id>();
        Map<ID,String> userEmailMap = new Map<Id,String>();
        
        try{
            for(Request_Information__c reqInfo : (List<Request_Information__c>)trigger.new){            
                if(rt_map.get(reqInfo.recordTypeID).getName().containsIgnoreCase('Request For Quote(RFQ)') && reqInfo.Last_Accepted_Quote__c == true){            
                    if(reqInfo.Primary_Request_Catcher__c != null || reqInfo.Backup_Request_Catcher__c != null){                     
                        if(trigger.oldmap != null){                    
                            if(reqInfo.Primary_Request_Catcher__c != triggerOldMap.get(reqInfo.id).Primary_Request_Catcher__c || 
                                        reqInfo.Backup_Request_Catcher__c != triggerOldMap.get(reqInfo.id).Backup_Request_Catcher__c){
                                
                                requestInfoList.add(reqInfo);
                                userId.add(reqInfo.Primary_Request_Catcher__c);
                                userId.add(reqInfo.Backup_Request_Catcher__c);
                                system.debug('catcher change checked1');                            
                            }
                            else{
                                 requestInfoList.add(reqInfo);
                                 userId.add(reqInfo.Primary_Request_Catcher__c);
                                 userId.add(reqInfo.Backup_Request_Catcher__c);                             
                            }
                       } 
                    }                      
                 }                
            }
                    
            for(User usr : [SELECT id, email FROM USER WHERE id in : userId]){
                userEmailMap.put(usr.id,usr.email);            
            }
            
            for(Request_Information__c req : requestInfoList){
                optn = new Customer_Requirement__c(id=req.Customer_Requirement__c);
                optn.Backup_Request_Catcher_Email__c = userEmailMap.get(req.Backup_Request_Catcher__c);
                optn.Primary_Request_Catcher_Email__c = userEmailMap.get(req.Primary_Request_Catcher__c);
                optnList.add(optn);
            }
            
            if(!optnList.isEmpty()){
                database.update(optnList);
            }
        }
        catch(Exception e){
            system.debug('Exception is thrown during update of request catcher email on option for last updated quote' + e.getmessage());
            GlobalUtility.logMessage('Error','RequestInformationTriggerHelper','updateRequestCatcher','','Exception is thrown during update of request catcher email on option for last updated quote',String.valueof(e.getMessage()),'','BnP',e,0);
        }
     }   
 }