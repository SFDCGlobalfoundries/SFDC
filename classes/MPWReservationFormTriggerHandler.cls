/*
    Author: Shyam Ravindra Nair
    Description: serves as handler for MPWReservationFormTrigger trigger.
    History: 
        SNair      21072015    - Code creation.
        Ditraju     08122015    - Prod issue changed cancellation deadline email content
        Poulami     06292016    - Prod issue changed from address of Revision Form Reminder For Customer and Internal Users
        Anil Kumar   00070564   - 0.15um Sub-Device Extraction supportability : April 18, 2017
*/ 
public class MPWReservationFormTriggerHandler {
    
    //variables
    public List<MPW_Reservation__c> mpwResfList{get;set;}
    public List<MPW_Prime_Die__c> mpwpdList{get;set;}
    public List<MPW_Change_Request__c> mpwcrList{get;set;}
    public List<MPW_Extra_Die__c> mpwedList{get;set;}
    public UtilClassToGetAllFields util{get;set;}
    public List<Customer_Guideline_Factor__c> cglfList{get;set;}
    public List<Internal_Guideline_Factor__c> iglfList{get;set;}
    public List<MPW_Geometry_Mapping__c> mpwgmList{get;set;}
    List<Messaging.SingleEmailMessage> mails{get;set;}
    public Map<String, Customer_Guideline_Factor__c> cglfMap{get;set;}
    public Map<String, Internal_Guideline_Factor__c> iglfMap{get;set;}
    public Map<String, MPW_Geometry_Mapping__c> mpwgmMap{get;set;}
    public String queryFields = '';
    public String soql = '';
    public Set<Id> groupIds;
    public MPW_Reservation__c mpwResf{get;set;}
    public MPW_Train_Maintenance__c train{get;set;}
    public Set<Id> userId;
    
    public MPWReservationFormTriggerHandler(){
        util = new UtilClassToGetAllFields();
        mails = new List<Messaging.SingleEmailMessage>();
        userId = new Set<Id>();
        groupIds = new Set<Id>();
         
        cglfList = new List<Customer_Guideline_Factor__c>();
        iglfList = new List<Internal_Guideline_Factor__c>();
        cglfMap = new Map<String, Customer_Guideline_Factor__c>();
        iglfMap = new Map<String, Internal_Guideline_Factor__c>();
        
        queryFields = util.getAllFields('Customer_Guideline_Factor__c');
        soql = 'select '+queryFields+' from Customer_Guideline_Factor__c order by Name asc';
        cglfList = database.query(soql);
        if(!cglfList.isEmpty()){
            for(Customer_Guideline_Factor__c  c : cglfList){
                cglfMap.put(c.Tech_ID__c, c);
            }
        }
        
        queryFields = util.getAllFields('Internal_Guideline_Factor__c');
        soql = 'select '+queryFields+' from Internal_Guideline_Factor__c order by Name asc';
        iglfList = database.query(soql);
        if(!iglfList.isEmpty()){
            for(Internal_Guideline_Factor__c  i : iglfList){
                iglfMap.put(i.TechID__c, i);
            }
        }
        
        mpwgmList = new List<MPW_Geometry_Mapping__c>();
        mpwgmMap = new Map<String, MPW_Geometry_Mapping__c>();
        queryFields = util.getAllFields('MPW_Geometry_Mapping__c');
        soql = 'select '+queryFields+' from MPW_Geometry_Mapping__c where Active__c = true and Use_Process_Type__c = true order by Sequence_No__c asc';
        mpwgmList = database.query(soql);
        if(!mpwgmList.isEmpty()){
            for(MPW_Geometry_Mapping__c g: mpwgmList){
                mpwgmMap.put(g.Name, g);
            }
        }
        
        // MPW Tapeout Queues
        
        Group customized = getQueue('MPW Customized MPW Queue');
        Group globalShuttle = getQueue('MPW GlobalShuttle MPW Tapeout Queue');
        Group tdti = getQueue('MPW TDTI MPW Queue');
        
        groupIds.add(customized.Id);
        groupIds.add(globalShuttle.Id);
        groupIds.add(tdti.Id);
        
        for(Id queueId : getUserIds(groupIds)) {
            userId.add(queueId);
        }
        /*for(Id queueId : getUserIds(globalShuttle.Id)) {
            userId.add(queueId);
        }
        for(Id queueId : getUserIds(tdti.Id)) {
            userId.add(queueId);
        }*/
               
    } 
    
    public static Group getQueue(String PName){
        Group gp = [Select Type, id From Group where Type= 'Queue' And Name =:PName Limit 1];
        return gp;
    }
    
    public static Set<Id> getUserIds(Set<Id> gpId){
        Set<Id> userList = new Set<Id>();
        for(GroupMember groupMem : [Select UserOrGroupId From GroupMember where GroupId IN :gpId]){
            userList.add(groupMem.UserOrGroupId);
        }
        return userList;
    }
    
    public void afterApproval(MPW_Reservation__c newMPWReservationForm){
        mpwpdList = new List<MPW_Prime_Die__c>();
        queryFields = util.getAllFields('MPW_Prime_Die__c');
        soql = 'select '+queryFields+' from MPW_Prime_Die__c where MPW_Form__c = \''+newMPWReservationForm.Id+'\' order by Prime_Die_Name__c asc';
        mpwpdList = database.query(soql);
        
        if(!mpwpdList.isEmpty()){
            
            /*** Start : Added By Anil ***/
            Map<String, MPW_Internal_Guideline_Factor__c> mapInternalGuidelineFactorCS = new Map<String, MPW_Internal_Guideline_Factor__c>();
            for(MPW_Internal_Guideline_Factor__c cs: [SELECT Id, Name, Category__c, Geometry__c, NON_SPLIT_Corner_Factor__c, SPLIT_Corner_Factor__c
                                                        FROM MPW_Internal_Guideline_Factor__c]) {
                String strKey = cs.Category__c.trim().toLowerCase() + '-' + cs.Geometry__c.trim().toLowerCase();
                mapInternalGuidelineFactorCS.put(strKey, cs);
            }
            /*** End : Added By Anil ***/
            
            if(newMPWReservationForm.Category__c == 'Customer'){
                boolean hasWaferQuantity = false;
                Integer count = 0;
                for(MPW_Prime_Die__c m: mpwpdList){
                    if(m.Delivery_Qty_Wafer_Form__c != '0'){
                        hasWaferQuantity = true;
                        break;
                    }
                    else{
                        count++;
                    }
                }
                if(hasWaferQuantity){                
                    mpwpdList[count].OPTION_C3__c = cglfMap.get(mpwpdList[0].Geometry__c).Wafer_Form_Delivery__c;
                }
                
                //Added by Anil - April 18, 2017
                Set<String> setSubDeviceExtractionGeometry = new Set<String>(); 
                for(MPW_Sub_Device_Extraction_Geometry__c cs : [SELECT Name, Geometry__c FROM MPW_Sub_Device_Extraction_Geometry__c]) {
                    setSubDeviceExtractionGeometry.add(cs.Geometry__c.toLowerCase());
                }
                
                for(MPW_Prime_Die__c m: mpwpdList){
                    //Modified by Anil Kumar : 00070564 :  April 18, 2017
                    if((m.Geometry__c != null && setSubDeviceExtractionGeometry.contains(m.Geometry__c.toLowerCase())) && Integer.valueOf(m.Sub_Devices_Extraction__c) != 0){
                        m.OPTION_C2__c = (Integer.valueOf(m.Sub_Devices_Extraction__c) - 1) * (cglfMap.get(m.Geometry__c).Sub_Devices_Extraction__c) * (Integer.valueOf(m.Delivery_Qty_Die_Form__c)/50);
                    }
                    else{
                        m.OPTION_C2__c = 0;
                    }
                    m.ADDER_D2__c = (Integer.valueOf(m.Expedite_In_DIE_Form__c) + (Integer.valueOf(m.Expedite_In_WAFER_Form__c)*50))/50 * cglfMap.get(mpwpdList[0].Geometry__c).Expedite__c;
                    m.ADDER_D3__c = Integer.valueof(m.ShortLoop_Wafer__c) *  cglfMap.get(m.Geometry__c).ShortLoop_Wafer__c;
                    m.Extra_Die_B__c = ((Integer.valueOf(m.Delivery_Qty_Die_Form__c) + (Integer.valueOf(m.Delivery_Qty_Wafer_Form__c)*50))-50)/50 * cglfMap.get(m.Geometry__c).ExtraDice_B__c;
                    m.Extra_Die_Qty__c = (Integer.valueOf(m.Delivery_Qty_Die_Form__c) + (Integer.valueOf(m.Delivery_Qty_Wafer_Form__c)*50))-50;
                    m.Extra_Wafer_Qty__c = ((Integer.valueOf(m.Delivery_Qty_Die_Form__c) + (Integer.valueOf(m.Delivery_Qty_Wafer_Form__c)*50))-50)/50;
                    Decimal diexsize = Decimal.valueOf(m.Drawn_Die_Size_X_um__c) * 0.001;
                    Decimal dieysize = Decimal.valueOf(m.Drawn_Die_Size_Y_um__c) * 0.001;
                    if((diexsize * dieysize) <= 9){
                        m.RETICLE_SPACE_A__c =  cglfMap.get(m.Geometry__c).ReticleSpace_Min__c;
                    }
                    else{
                        m.RETICLE_SPACE_A__c = diexsize * dieysize *  cglfMap.get(m.Geometry__c).RecticalSpace_A1__c;
                    }
                    m.Operation_Type__c = 'Insert';
                }
            }
            else{
                for(MPW_Prime_Die__c m: mpwpdList){
                    Decimal diexsize = Decimal.valueOf(m.Drawn_Die_Size_X_um__c) * 0.001;
                    Decimal dieysize = Decimal.valueOf(m.Drawn_Die_Size_Y_um__c) * 0.001;
                    m.RETICLE_SPACE_A__c = diexsize * dieysize * iglfMap.get(m.Geometry__c).Reticle__c;
                    List<String> dietowaferlist = iglfMap.get(m.Geometry__c).DieToWaferConv__c.split('/');
                        
                    /*** Start : Added By Anil ***/
                    Integer intDQDF = Integer.valueOf(m.Delivery_Qty_Die_Form__c); 
                    Integer intDQWF = Integer.valueOf(m.Delivery_Qty_Wafer_Form__c); 
                    if(m.Corner_Split__c != null && m.Corner_Split__c.toLowerCase() == 'yes' && m.Category__c != null && m.Geometry__c != null) {
                        String strKey = m.Category__c.trim().toLowerCase() + '-' + m.Geometry__c.trim().toLowerCase();
                        
                        Integer intSplitFactor = mapInternalGuidelineFactorCS.containsKey(strKey) ? Integer.valueOf(mapInternalGuidelineFactorCS.get(strKey).SPLIT_Corner_Factor__c) : 1;
                    
                        Integer intNonSplitFactor = mapInternalGuidelineFactorCS.containsKey(strKey) ? Integer.valueOf(mapInternalGuidelineFactorCS.get(strKey).NON_SPLIT_Corner_Factor__c) : 1;
                        
                        Integer intPOR = m.POR__c == null ? 0 : Integer.valueOf(m.POR__c); 
                        Integer intFF = m.FF__c == null ? 0 : Integer.valueOf(m.FF__c); 
                        Integer intSS = m.SS__c == null ? 0 : Integer.valueOf(m.SS__c); 
                        Integer intSF = m.SF__c == null ? 0 : Integer.valueOf(m.SF__c); 
                        Integer intFS = m.FS__c == null ? 0 : Integer.valueOf(m.FS__c); 
                        intDQDF = (intDQDF - intPOR - intFF - intSS - intSF - intFS);
                        intDQDF = intDQDF + (intPOR * intNonSplitFactor) + (intFF * intSplitFactor) + (intSS * intSplitFactor) + (intSF * intSplitFactor) + (intFS * intSplitFactor);
                        
                        Integer intWPOR = m.Wafer_POR__c == null ? 0 : Integer.valueOf(m.Wafer_POR__c); 
                        Integer intWFF = m.Wafer_FF__c == null ? 0 : Integer.valueOf(m.Wafer_FF__c); 
                        Integer intWSS = m.Wafer_SS__c == null ? 0 : Integer.valueOf(m.Wafer_SS__c); 
                        Integer intWSF = m.Wafer_SF__c == null ? 0 : Integer.valueOf(m.Wafer_SF__c); 
                        Integer intWFS = m.Wafer_FS__c == null ? 0 : Integer.valueOf(m.Wafer_FS__c); 
                        intDQWF = (intDQWF - intWPOR - intWFF - intWSS - intWSF - intWFS);
                        intDQWF = intDQWF + (intWPOR * intNonSplitFactor) + (intWFF * intSplitFactor) + (intWSS * intSplitFactor) + (intWSF * intSplitFactor) + (intWFS * intSplitFactor);
                    }
                    else if(m.Corner_Split__c != null && m.Corner_Split__c.toLowerCase() == 'no' && m.Category__c != null && m.Geometry__c != null) {
                        String strKey = m.Category__c.trim().toLowerCase() + '-' + m.Geometry__c.trim().toLowerCase();
                        Integer intNonSplitFactor = mapInternalGuidelineFactorCS.containsKey(strKey) ? Integer.valueOf(mapInternalGuidelineFactorCS.get(strKey).NON_SPLIT_Corner_Factor__c) : 1;
                        
                        intDQDF = intDQDF * intNonSplitFactor;
                        intDQWF = intDQWF * intNonSplitFactor;
                    }
                    
                    m.Extra_Die_B__c = ((intDQDF + (intDQWF * 50)) * iglfMap.get(m.Geometry__c).Wafer__c) / Integer.valueOf(dietowaferlist[1]);
                    /*** End : Added By Anil ***/   
                        
                        //m.Extra_Die_B__c = ((Integer.valueOf(m.Delivery_Qty_Die_Form__c) + (Integer.valueOf(m.Delivery_Qty_Wafer_Form__c)*50)) * iglfMap.get(m.Geometry__c).Wafer__c) / Integer.valueOf(dietowaferlist[1]);
                        m.Extra_Die_Qty__c = Integer.valueOf(m.Delivery_Qty_Die_Form__c) + (Integer.valueOf(m.Delivery_Qty_Wafer_Form__c)*50);
                        m.Extra_Wafer_Qty__c = (Integer.valueOf(m.Delivery_Qty_Die_Form__c) + (Integer.valueOf(m.Delivery_Qty_Wafer_Form__c)*50))/50; 
                    m.Operation_Type__c = 'Insert';
                }
                
            }
            update mpwpdList;
        }
    } 
    
    public void afterVoid(List<MPW_Reservation__c> newReservationFormList){
        Set<Id> recIdList = new Set<Id>();
        for(MPW_Reservation__c m: newReservationFormList){
            recIdList.add(m.Id);
        }
        mpwpdList = new List<MPW_Prime_Die__c>();
        queryFields = util.getAllFields('MPW_Prime_Die__c');
        queryFields += ', MPW_Form__r.BARE_DIE_SHIP_DATE_FLAG__c';
        soql = 'select '+queryFields+' from MPW_Prime_Die__c where MPW_Form__c IN: recIdList order by Prime_Die_Name__c asc';
        mpwpdList = database.query(soql);
        
        if(!mpwpdList.isEmpty()){
            Set<Id> primedieIdList = new Set<Id>();
            for(MPW_Prime_Die__c m: mpwpdList){
                primedieIdList.add(m.Id);
            }
            
            mpwcrList = new List<MPW_Change_Request__c>();
            queryFields = util.getAllFields('MPW_Change_Request__c');
            soql = 'select '+queryFields+' from MPW_Change_Request__c where MPW_Prime_Die__c IN: primedieIdList';
            mpwcrList = database.query(soql);   
            
            mpwedList = new List<MPW_Extra_Die__c>();
            queryFields = util.getAllFields('MPW_Extra_Die__c');
            queryFields += ', MPW_Prime_Die__r.MPW_Form__r.BARE_DIE_SHIP_DATE_FLAG__c, MPW_Prime_Die__r.BARE_DIE_SHIP_DATE_FLAG__c, MPW_Prime_Die__r.Category__c';
            soql = 'select '+queryFields+' from MPW_Extra_Die__c where MPW_Prime_Die__c IN: primedieIdList';
            mpwedList = database.query(soql);
            
            if(!mpwcrList.isEmpty()){
                for(MPW_Change_Request__c m: mpwcrList){
                    if(m.Status__c.contains('Pending')){
                        Approval.ProcessWorkitemRequest PWR = new Approval.ProcessWorkitemRequest();
                        PWR.setComments('Rejected as the Form is Voided');
                        PWR.setAction('Reject');
                        Id workItemId = getWorkItemId(m.Id);
                        system.debug('workitemid'+workItemId);
                        PWR.setWorkitemId(workItemId);
                        Approval.ProcessResult result =  Approval.process(PWR);
                    }
                }
            }
            
            if(!mpwpdList.isEmpty()){
                List<MPW_Prime_Die__c> temppdList = new List<MPW_Prime_Die__c>();
                for(MPW_Prime_Die__c m: mpwpdList){
                    if(m.MPW_Form__r.BARE_DIE_SHIP_DATE_FLAG__c > 0 && (m.Category__c == 'FAB' || m.Category__c == 'TD' || m.Category__c == 'IP' || m.Category__c == 'Lighting' || m.Category__c == 'DE' || m.Category__c == 'ASIC R&D' || m.Category__c == 'RF_ASIC_A&D Protos')){
                        m.RETICLE_SPACE_A_Void_c__c = Decimal.valueOf('-'+String.valueOf(m.RETICLE_SPACE_A__c));
                        m.Extra_Die_B_Void__c = Decimal.valueOf('-'+String.valueOf(m.Extra_Die_B__c));
                        m.Operation_Type__c = 'Void'; 
                    }
                    else if(m.Category__c == 'Customer' || (m.MPW_Form__r.BARE_DIE_SHIP_DATE_FLAG__c == 0 && (m.Category__c == 'FAB' || m.Category__c == 'TD' || m.Category__c == 'IP' || m.Category__c == 'Lighting' || m.Category__c == 'DE' || m.Category__c == 'ASIC R&D' || m.Category__c == 'RF_ASIC_A&D Protos'))){
                        m.Operation_Type__c = 'Delete';
                    }
                    m.isVoided__c = true;
                    temppdList.add(m);
                }
                if(!temppdList.isEmpty()){
                    update temppdList;
                }
            }
            
            if(!mpwedList.isEmpty()){
                List<MPW_Extra_Die__c> tempedList = new List<MPW_Extra_Die__c>();
                for(MPW_Extra_Die__c e: mpwedList){
                    if(e.MPW_Prime_Die__r.MPW_Form__r.BARE_DIE_SHIP_DATE_FLAG__c > 0 && (e.MPW_Prime_Die__r.Category__c == 'FAB' || e.MPW_Prime_Die__r.Category__c == 'TD' || e.MPW_Prime_Die__r.Category__c == 'IP' || e.MPW_Prime_Die__r.Category__c == 'Lighting' || e.MPW_Prime_Die__r.Category__c == 'DE' || e.MPW_Prime_Die__r.Category__c == 'ASIC R&D' || e.MPW_Prime_Die__r.Category__c == 'RF_ASIC_A&D Protos')){
                        e.Operation_Type__c = 'Void';
                        e.Extra_Die_B_Void__c = Decimal.valueOf('-'+String.valueOf(e.Extra_Die_B__c));   
                        tempedList.add(e);
                    }
                    
                }
                if(!tempedList.isEmpty()){
                    update tempedList;
                }
            }
        }
    }
    
    public Id getWorkItemId(Id targetObjectId){
        Id retVal = null;
        for(ProcessInstanceWorkitem workItem: [select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: targetObjectId]){
            retVal = workItem.Id;
        }
        return retVal;
    }
    
    public void sendReminderForQuotationClose(List<MPW_Reservation__c> newMPWReservationList){
        Set<Id> recIdList = new Set<Id>();
        Map<Id, List<Id>> mpwResfAccTeamMap = new Map<Id, List<Id>>();
        for(MPW_Reservation__c m: newMPWReservationList){
            recIdList.add(m.Id);
        }
        mpwResfList = new List<MPW_Reservation__c>();
        mpwResfList = [select OwnerId,Id,Customer_Tapeout_Date__c,Prime_Die_Name__c,Customer_Company_Name__c,Customer_Company_Name__r.Name,AM_Name__c,AM_Name__r.Email,CSR_Name__c,CSR_Name__r.Email,FE_Name__c,FE_Name__r.Email,MPW_Train_Name__r.Name,MPW_Train_Name__r.Cancellation_Deadline__c from MPW_Reservation__c where Id IN: recIdList];
        if(!mpwResfList.isEmpty()){
            //Added by Anil : Optimizing the code as it was written inside for loop.
            OrgWideEmailAddress[] owea = [select Id, Address from OrgWideEmailAddress where Address ='noreply-salesforce@globalfoundries.com'];
            
            Set<Id> accountIds = new Set<Id>();
            for(MPW_Reservation__c m: mpwResfList){
                accountIds.add(m.Customer_Company_Name__c);
            }
            if(!accountIds.isEmpty()){
                List<Account_Team_Proxy__c> accTeamProxyList = new List<Account_Team_Proxy__c>();
                accTeamProxyList = [select Id, User__c, User_Email__c,Account__c 
                                    from Account_Team_Proxy__c 
                                    where Team_Role__c IN ('Customer Service Rep','Backup Customer Service Rep') 
                                        and User__r.isActive = true 
                                        and Account__c IN: accountIds];
                
                if(!accTeamProxyList.isEmpty()){
                    for(MPW_Reservation__c m: mpwResfList){
                        List<Id> teamEmailList = new List<Id>();
                        for(Account_Team_Proxy__c a: accTeamProxyList){
                            if(m.Customer_Company_Name__c ==  a.Account__c){
                                teamEmailList.add(a.User__c);
                            }
                        }
                        if(!teamEmailList.isEmpty()){
                            mpwResfAccTeamMap.put(m.Id,teamEmailList);    
                        }
                    }
                }
                
                for(MPW_Reservation__c m: mpwResfList){
                    List<Id> toList = new List<Id>();
                    //owner of the record
                     toList.add(m.OwnerId);
                    if(m.AM_Name__c != null){
                        toList.add(m.AM_Name__c);
                    }
                    if(m.CSR_Name__c != null){
                        toList.add(m.CSR_Name__c);
                    }
                    if(m.FE_Name__c != null){
                        toList.add(m.FE_Name__c);
                    }
                    if(mpwResfAccTeamMap.size() > 0){
                        for(Id cc: mpwResfAccTeamMap.get(m.Id)){
                            toList.add(cc);
                        }
                    }
                    
                   
                    
                    for(Id to: toList){
                        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                        singleMail.setTargetObjectId(to);
                          //added by jabee for the case# 00061988
                        //Commented by Anil : Added this query outside for loop
                        //OrgWideEmailAddress[] owea = [select Id, Address from OrgWideEmailAddress where Address ='noreply-salesforce@globalfoundries.com']; 
                        if ( owea.size() > 0 ) {
                            singleMail.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        singleMail.saveAsActivity = false;
                       // singleMail.setSubject(m.MPW_Train_Name__r.Name+' '+m.Customer_Company_Name__r.Name+' Quotation Close/Cancellation deadline Reminder.');
                        singleMail.setSubject(m.MPW_Train_Name__r.Name+' '+m.Customer_Company_Name__r.Name+' Cancellation deadline Reminder.');
                        String body = 'MPW : '+m.MPW_Train_Name__r.Name;
                        body += '<br/>';
                        body += 'Company Name : '+m.Customer_Company_Name__r.Name;
                        body += '<br/>';
                        body += 'Prime Die Name: '+m.Prime_Die_Name__c;
                        body += '<br/>';
                        String canDeadLineDate = (m.MPW_Train_Name__r.Cancellation_Deadline__c!=null)?m.MPW_Train_Name__r.Cancellation_Deadline__c.format('dd/MMM/yyyy'):'';
                        body += 'Cancellation Deadline: '+canDeadLineDate;
                        body += '<br/>';
                        body += '<br/>';
                        String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.Id;
                        body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.Id+'">'+hyperLink+'</a>';
                        body += '<br/>';
                        body += '<br/>';
                       // body += 'NOTE: ';
                        //body += '<br/>';
                        //body += '1. Quotation must be raised by Account Manager or CSR before Quotation Close date (4 weeks after Reservation Close date).';
                        //body += '<br/>';
                        //body += '2. Cancellation fee (=20% of reserved die size pricing) is chargeable to customer in the event that reservation is cancelled after cancellation deadline (=Quotation Close Date).';
                        singleMail.setHtmlBody(body);
                        mails.add(singleMail);
                    }
                }
            }
        }
        system.debug('mails: '+mails.size());
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }
    }
    
    // Purchase Order Reminder
    public void sendReminderForPurchaseOrder(List<MPW_Reservation__c> newMPWReservationList){
        Set<Id> recIdList = new Set<Id>();
        Map<Id, List<Id>> mpwResfAccTeamMap = new Map<Id, List<Id>>();
        for(MPW_Reservation__c m: newMPWReservationList){
            recIdList.add(m.Id);
        }
        mpwResfList = new List<MPW_Reservation__c>();
        mpwResfList = [select Id,Customer_Tapeout_Date__c,Reservation_Close_Date__c,Prime_Die_Name__c,Customer_Company_Name__c,Customer_Company_Name__r.Name,AM_Name__c,AM_Name__r.Email,CSR_Name__c,CSR_Name__r.Email,FE_Name__c,FE_Name__r.Email,MPW_Train_Name__r.Name from MPW_Reservation__c where Id IN: recIdList];
        if(!mpwResfList.isEmpty()){
            //Added by Anil Dec 26, 2016 - Case : 00060640
            OrgWideEmailAddress[] owea = [select Id, Address from OrgWideEmailAddress where Address ='noreply-salesforce@globalfoundries.com'];
            
            Set<Id> accountIds = new Set<Id>();
            for(MPW_Reservation__c m: mpwResfList){
                accountIds.add(m.Customer_Company_Name__c);
            }
            if(!accountIds.isEmpty()){
                List<Account_Team_Proxy__c> accTeamProxyList = new List<Account_Team_Proxy__c>();
                accTeamProxyList = [select Id, User__c, User_Email__c,Account__c from Account_Team_Proxy__c where Team_Role__c IN ('Customer Service Rep','Backup Customer Service Rep') and User__r.isActive = true and Account__c IN: accountIds];
                
                if(!accTeamProxyList.isEmpty()){
                    for(MPW_Reservation__c m: mpwResfList){
                        List<Id> teamEmailList = new List<Id>();
                        for(Account_Team_Proxy__c a: accTeamProxyList){
                            if(m.Customer_Company_Name__c ==  a.Account__c){
                                teamEmailList.add(a.User__c);
                            }
                        }
                        if(!teamEmailList.isEmpty()){
                            mpwResfAccTeamMap.put(m.Id,teamEmailList);    
                        }
                    }
                }
                
                for(MPW_Reservation__c m: mpwResfList){
                    List<Id> toList = new List<Id>();
                    if(m.AM_Name__c != null){
                        toList.add(m.AM_Name__c);
                    }
                    if(m.CSR_Name__c != null){
                        toList.add(m.CSR_Name__c);
                    }
                    if(mpwResfAccTeamMap.size() > 0){
                        for(Id cc: mpwResfAccTeamMap.get(m.Id)){
                            toList.add(cc);
                        }
                    }
                    for(Id to: toList){
                        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                        
                        //Added by Anil Dec 26, 2016 - Case : 00060640
                        if ( owea.size() > 0 ) {
                            singleMail.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        
                        singleMail.setTargetObjectId(to);
                        singleMail.saveAsActivity = false;
                        singleMail.setSubject(m.MPW_Train_Name__r.Name+' '+m.Customer_Company_Name__r.Name+' Purchase Order Reminder.');
                        String body = 'MPW : '+m.MPW_Train_Name__r.Name;
                        body += '<br/>';
                        body += 'Company Name : '+m.Customer_Company_Name__r.Name;
                        body += '<br/>';
                        body += 'Prime Die Name: '+m.Prime_Die_Name__c;
                        body += '<br/>';
                        Datetime podate = m.Customer_Tapeout_Date__c.addDays(-7);
                        String pod = podate.format('dd/MMM/yyyy');
                        body += 'PO Deadline: '+pod;
                        body += '<br/>';
                        body += '<br/>';
                        String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.Id;
                        body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.Id+'">'+hyperLink+'</a>';
                        body += '<br/>';
                        body += '<br/>';
                        body += 'NOTE: ';
                        body += '<br/>';
                        body += 'Purchase Order (PO) must be issued by Customer latest 1 week before customer tapeout date';
                        body += '<br/>';
                        body += 'CSR to work with customer to issue PO to GLOBALFOUNDRIES if PO is still not received';
                        singleMail.setHtmlBody(body);
                        mails.add(singleMail);
                    }
                }
                
            }
        }
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }
    }
    
    // Sales Order Number Reminder
    public void sendReminderForSalesOrderNumber(List<MPW_Reservation__c> newMPWReservationList){
        Set<Id> recIdList = new Set<Id>();
        Map<Id, List<Id>> mpwResfAccTeamMap = new Map<Id, List<Id>>();
        for(MPW_Reservation__c m: newMPWReservationList){
            recIdList.add(m.Id);
        }
        mpwResfList = new List<MPW_Reservation__c>();
        mpwResfList = [select Id,Customer_Tapeout_Date__c,Reservation_Close_Date__c,Prime_Die_Name__c,Customer_Company_Name__c,Customer_Company_Name__r.Name,AM_Name__c,AM_Name__r.Email,CSR_Name__c,CSR_Name__r.Email,FE_Name__c,FE_Name__r.Email,MPW_Train_Name__r.Name from MPW_Reservation__c where Id IN: recIdList];
        if(!mpwResfList.isEmpty()){
            //Added by Anil April 4, 2017 - Case : 00069668
            OrgWideEmailAddress[] owea = [select Id, Address from OrgWideEmailAddress where Address ='noreply-salesforce@globalfoundries.com'];
            
            Set<Id> accountIds = new Set<Id>();
            for(MPW_Reservation__c m: mpwResfList){
                accountIds.add(m.Customer_Company_Name__c);
            }
            if(!accountIds.isEmpty()){
                List<Account_Team_Proxy__c> accTeamProxyList = new List<Account_Team_Proxy__c>();
                accTeamProxyList = [select Id, User__c, User_Email__c,Account__c from Account_Team_Proxy__c where Team_Role__c IN ('Customer Service Rep','Backup Customer Service Rep') and User__r.isActive = true and Account__c IN: accountIds];
                
                if(!accTeamProxyList.isEmpty()){
                    for(MPW_Reservation__c m: mpwResfList){
                        List<Id> teamEmailList = new List<Id>();
                        for(Account_Team_Proxy__c a: accTeamProxyList){
                            if(m.Customer_Company_Name__c ==  a.Account__c){
                                teamEmailList.add(a.User__c);
                            }
                        }
                        if(!teamEmailList.isEmpty()){
                            mpwResfAccTeamMap.put(m.Id,teamEmailList);    
                        }
                    }
                }
                
                for(MPW_Reservation__c m: mpwResfList){
                    List<Id> toList = new List<Id>();
                    if(m.AM_Name__c != null){
                        toList.add(m.AM_Name__c);
                    }
                    if(m.CSR_Name__c != null){
                        toList.add(m.CSR_Name__c);
                    }
                    if(mpwResfAccTeamMap.size() > 0){
                        for(Id cc: mpwResfAccTeamMap.get(m.Id)){
                            toList.add(cc);
                        }
                    }
                    for(Id to: toList){
                        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                        
                        //Added by Anil April 4, 2017 - Case : 00069668
                        if ( owea.size() > 0 ) {
                            singleMail.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        
                        singleMail.setTargetObjectId(to);
                        singleMail.saveAsActivity = false;
                        singleMail.setSubject(m.MPW_Train_Name__r.Name+' '+m.Customer_Company_Name__r.Name+' Sales Order Number Reminder.');
                        String body = 'MPW : '+m.MPW_Train_Name__r.Name;
                        body += '<br/>';
                        body += 'Company Name : '+m.Customer_Company_Name__r.Name;
                        body += '<br/>';
                        body += 'Prime Die Name: '+m.Prime_Die_Name__c;
                        body += '<br/>';
                        Datetime sonum = m.Customer_Tapeout_Date__c;
                        String snum = sonum.format('dd/MMM/yyyy');
                        body += 'SO Number Deadline: '+snum;
                        body += '<br/>';
                        body += '<br/>';
                        String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.Id;
                        body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.Id+'">'+hyperLink+'</a>';
                        body += '<br/>';
                        body += '<br/>';
                        body += 'NOTE: ';
                        body += '<br/>';
                        body += 'CSR to accept the respective quotation in order to generate Sales Order number (SO#) by Customer Tapeout date to initiate wafer start';
                        singleMail.setHtmlBody(body);
                        mails.add(singleMail);
                    }
                }
                
            }
        }
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }
    }
    
    // Revision Form Reminder For Customer
    public void sendReminderForRevisionCustomer(List<MPW_Reservation__c> newMPWReservationList){
        Set<Id> recIdList = new Set<Id>();
        Map<Id, List<String>> mpwResfAccTeamMap = new Map<Id, List<String>>();
        for(MPW_Reservation__c m: newMPWReservationList){
            recIdList.add(m.Id);
        }
        mpwResfList = new List<MPW_Reservation__c>();
        mpwResfList = [select Id, OwnerId, Name, Owner.Email,Customer_Company_Name__c,Customer_Company_Name__r.Name,Step_1_Approver_1__c,Step_1_Approver_1__r.Email,
                              Step_1_Approver_2__c, Step_1_Approver_2__r.Email, Step_1_Approver_3__c, Step_1_Approver_3__r.Email, 
                              Step_1_Approver_4__c, Step_1_Approver_4__r.Email, Step_1_Approver_5__c, Step_1_Approver_5__r.Email,
                              Step_1_Approver_6__c, Step_1_Approver_6__r.Email, Step_1_Approver_7__c, Step_1_Approver_7__r.Email,
                              Step_1_Approver_9__c, Step_1_Approver_9__r.Email, Step_1_Approver_8__c, Step_1_Approver_8__r.Email,
                              Step_1_Approver_10__c, Step_1_Approver_10__r.Email, MPW_Train_Name__r.Name from MPW_Reservation__c where Id IN: recIdList];
        if(!mpwResfList.isEmpty()){
            Set<Id> accountIds = new Set<Id>();
            for(MPW_Reservation__c m: mpwResfList){
                accountIds.add(m.Customer_Company_Name__c);
            }
            if(!accountIds.isEmpty()){
                List<Account_Team_Proxy__c> faeList = new List<Account_Team_Proxy__c>();
                faeList = [SELECT Id, Account__c, User__c, Team_Role__c 
                            FROM Account_Team_Proxy__c 
                            WHERE User__r.isActive = true 
                                AND Account__c IN: accountIds 
                                AND ( Team_Role__c = 'Field Application Engineer' 
                                   OR Team_Role__c = 'Primary Field Application Engineer' 
                                   OR ( Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                   OR ( Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE) )
                            ORDER BY Team_Role__c desc];
                
                //added by Venkat for case#00071742 Removed UserInfo.getUsername()
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='noreply-salesforce@globalfoundries.com'];   //:UserInfo.getUsername()];
                
                for(MPW_Reservation__c m: mpwResfList){
                    Set<Id> faeId = new Set<Id>();
                    if(!faeList.isEmpty()){
                        for(Account_Team_Proxy__c acc: faeList){
                            if(acc.Account__c == m.Customer_Company_Name__c){
                                faeId.add(acc.User__c);
                            }
                        }
                    }
                    List<Id> toList = new List<Id>();
                    if(!faeId.isEmpty()){
                        for(Id f: faeId){
                            toList.add(f);
                        }
                    }
                    toList.add(m.OwnerId); 
                    //06292016 - Added by Poulami for Case#00056795 Starts.
                     //added by jabeee for case#00059822 UserInfo.getUsername()
                     
                    //06292016 - Added by Poulami for Case#00056795 Ends.
                    for(Id to: toList){
                        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                        singleMail.setTargetObjectId(to);
                        //06292016 - Added by Poulami for Case#00056795 Starts.
                        if ( owea.size() > 0 ) {
                            singleMail.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        //06292016 - Added by Poulami for Case#00056795 Ends.
                        singleMail.saveAsActivity = false;
                        singleMail.setSubject(m.MPW_Train_Name__r.Name+' : Final Die Size Update for reservation '+m.Name);
                        String body = m.Name + ' for ' + m.MPW_Train_Name__r.Name + ' has been accepted.';
                        body += '<br/>';
                        body += 'Please update final prime die size if there is any discrepancy with the reserved prime die.';
                        body += '<br/>';
                        body += '<br/>';
                        String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.Id;
                        body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.Id+'">'+hyperLink+'</a>';
                        singleMail.setHtmlBody(body);
                        mails.add(singleMail);
                    }
                 }
            }
        }
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }
    }
    
    // Revision Form Reminder For Internal
    public void sendReminderForRevisionInternal(List<MPW_Reservation__c> newMPWReservationList){
        Set<Id> recIdList = new Set<Id>();
        Map<Id, List<String>> mpwResfAccTeamMap = new Map<Id, List<String>>();
        for(MPW_Reservation__c m: newMPWReservationList){
            recIdList.add(m.Id);
        }
        mpwResfList = new List<MPW_Reservation__c>();
        mpwResfList = [select Id, OwnerId, Name, Owner.Email, Owner.Name, MPW_Train_Name__r.Name from MPW_Reservation__c where Id IN: recIdList];
        //06292016 - Added by Poulami for Case#00056795 Starts.
        //added by jabeee for case#00059822 UserInfo.getUsername()
        //added by Venkat for case#00071742 Removed UserInfo.getUsername()        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='noreply-salesforce@globalfoundries.com'];  //':UserInfo.getUsername()];
        //06292016 - Added by Poulami for Case#00056795 Ends.
        if(!mpwResfList.isEmpty()){
            for(MPW_Reservation__c m: mpwResfList){
                    Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                    singleMail.setTargetObjectId(m.OwnerId);
                    //06292016 - Added by Poulami for Case#00056795 Starts.
                    if ( owea.size() > 0 ) {
                        singleMail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    //06292016 - Added by Poulami for Case#00056795 Ends.
                    singleMail.saveAsActivity = false;
                    singleMail.setSubject(m.MPW_Train_Name__r.Name+' : Final Die Size Update for reservation '+m.Name);
                    String body = m.Name + ' for ' + m.MPW_Train_Name__r.Name + ' has been accepted.';
                    body += '<br/>';
                    body += 'Please update final prime die size if there is any discrepancy with the reserved prime die.';
                    body += '<br/>';
                    body += '<br/>';
                    String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.Id;
                    body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.Id+'">'+hyperLink+'</a>';
                    singleMail.setHtmlBody(body);
                    mails.add(singleMail);
                }
                
        }
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }
    }
    
           
    //Reminder for Sales Order Number
    /*public void sendReminderForSalesOrder(List<MPW_Reservation__c> newMPWReservationList){
        
        Set<Id> recIdList = new Set<Id>();
        Map<Id, List<String>> mpwResfAccTeamMap = new Map<Id, List<String>>();
        for(MPW_Reservation__c m: newMPWReservationList){
            recIdList.add(m.Id);
        }
        mpwResfList = new List<MPW_Reservation__c>();
        mpwResfList = [select Id,Name,Sales_Order__c,Prime_Die_Name__c,AM_Name__c,AM_Name__r.Email,CSR_Name__c,CSR_Name__r.Email,FE_Name__c,FE_Name__r.Email,MPW_Train_Name__r.Name from MPW_Reservation__c where Id IN: recIdList];
        if(!mpwResfList.isEmpty()){
            for(MPW_Reservation__c m: mpwResfList){
                    List<Id> toList = new List<Id>();
                    if(m.AM_Name__c != null){
                        toList.add(m.AM_Name__c);
                    }
                    if(m.CSR_Name__c != null){
                        toList.add(m.CSR_Name__c);
                    }
                    if(m.FE_Name__c != null){
                        toList.add(m.FE_Name__c);
                    }
                    for(Id cc: userId){
                        toList.add(cc);
                    }
                    for(Id to: toList){
                        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                        singleMail.setTargetObjectId(to);
                        singleMail.saveAsActivity = false;
                        singleMail.setSubject(m.MPW_Train_Name__r.Name+' '+' Sales Order updation mail Reminder.');
                        String body = 'MPW : '+m.MPW_Train_Name__r.Name;
                        body += '<br/>';
                        body += 'Form Number : '+m.Name;
                        body += '<br/>';
                        body += 'Prime Die Name: '+m.Prime_Die_Name__c;
                        body += '<br/>';
                        body += 'Sales Order Number: '+m.Sales_Order__c;
                        body += '<br/>';
                        body += '<br/>';
                        body += '<br/>';
                        body += 'Sales Order Number has been updated.';
                        body += '<br/>';
                        body += '<br/>';
                        String hyperLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.Id;
                        body += '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+m.Id+'">'+hyperLink+'</a>';
                        singleMail.setHtmlBody(body);
                        mails.add(singleMail);
                    }
                }
                
        }
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);
        }
    }*/
    
}