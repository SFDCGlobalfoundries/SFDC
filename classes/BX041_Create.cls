/*
    Class Name:    BX041_Create 
    Author:        Prosenjit Saha(PS) and Thomas Lai(TL)
    Description:   This Class manages the BX041 create page.
    History: 
      PS           01072013    - Code creation.
      TL           02072013    - Code Modification.
      PS           03072013    - Code Modification.
      PS           04072013    - Code Modification.
      ZAmbat       10172014    - Modified code as per CASE 35430.
      Psamal       26042016    - Modified code as for Case 00049037.
*/

public class BX041_Create {
    private transient String deviceId;    
    private transient List<SObject> sobjList {get; set;}    
    public transient String    templateName {get;set;}    
    public BX_041__c    bx041 {get; set;}    
    public boolean    displayPopup {get; set;}
    public boolean isCustomer {get; set;}
    public boolean isAdmin {get; set;}
    public String accountRegion {get; set;}
    public String iptypevalue{get;set;}
    public boolean addNewIP {get; set;}
    public string baseUrl {get; set;}
    
    public String accountOwnerName {get; set;}
    public String deviceOwnerName {get; set;}
    public String accountOwnerId {get; set;}
    public String deviceOwnerId {get; set;}
    public String accountId {get; set;}
    public String accountName {get; set;}
        
    /*
    Method :        Constructor BX041_Create
    Return Type:    NA
    */
    public BX041_Create(ApexPages.StandardController controller) {
        iptypevalue = '';
        
        displayPopup = false;
        Id pfId = UserInfo.getProfileId();
        String pfName = [select name from profile where id = :pfId].name;
        isAdmin = false;
        if(pfName.contains('Portal') ) {
            isCustomer = true;
        } else{
            isCustomer = false;
            if(pfName.contains('Admin')){
                isAdmin = true;
            } else {
                isAdmin = false;
            }
        }
        if (ApexPages.currentPage().getHeaders().get('host').indexOf('globalfoundryview') == -1) {
            baseUrl = '/apex/CustomLoopUpPage?';
        }else {
            baseUrl = '/GlobalfoundryView/apex/CustomLoopUpPage?';
        }
              
        deviceId = ApexPages.currentPage().getParameters().get('retURL'); 
        if(deviceId.contains('/GlobalfoundryView/')){
            deviceId = deviceId.removeStart('/GlobalfoundryView/');
        }
        if(deviceId.indexOf('/') == -1){
            deviceId =deviceId.substring(0,15);
        }
        else{
            deviceId =deviceId.substring(1,16);
        }

        Device__c device = [SELECT id, 
                            name,
                            Geometry__c,
                            Requested_Process_ID__c,
                            Assigned_Process_ID__c,
                            CRMDID__c,
                            Account__c,
                            Geometry_Filter__c,
                            Account__r.Region__c,
                            Process_Family_Filter__c,
                            Opportunity_Program__c,
                            Owner.Id,
                            Owner.Name,                         
                            Account__r.Owner.Id,
                            Account__r.Owner.Name,
                            Account__r.Name
                 FROM       device__c 
                 WHERE      id =:deviceId];
        accountRegion = device.Account__r.Region__c; 
        bx041 = new BX_041__c (device__c = deviceId, Owner__c = UserInfo.getUserId());
        
        bx041.CRMDID__c = device.CRMDID__c ;
        bx041.Geometry_Filter__c = device.Geometry_Filter__c;
        bx041.Process_Family_Filter__c = device.Process_Family_Filter__c;
        bx041.BX_041_Opportunity_Program__c = device.Opportunity_Program__c;
        templateName = getTemplate(device.Geometry__c);
        
        init();
        
        if(device != null && device.Owner.Id != null){
            
            deviceOwnerId = device.Owner.Id;
        }
        
        if(device != null && device.Owner.Name != null){
            
            deviceOwnerName = device.Owner.Name;
        }
        
        if(device != null && device.Account__c != null && device.Account__r.Owner.Id != null){
            
            accountOwnerId = device.Account__r.Owner.Id;
        }
        
        if(device != null && device.Account__c != null && device.Account__r.Owner.Name != null){
            
            accountOwnerName = device.Account__r.Owner.Name;
        }
        
        if(device != null && device.Account__c != null){
            
            accountId = device.Account__c;
        }
        
        if(device != null && device.Account__c != null && device.Account__r.Name != null){
            
            accountName = device.Account__r.Name;
        }
    }
         
    /* =============================================  Main Methods Start  ============================================= */
    
    /*
    Method :        Save all sections under BX041
    Paremeter:      Boolean - wherther need form validation
    Return Type:    Boolean - result of save operation
    */
    private Boolean saveAll(Boolean reqValidation){
        
        if(bx041.Process_ID_is_known__c == 'Yes' && bx041.Reference_Process_ID_txt__c == NULL){
            Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR,'Please provide reference Process ID'));
            return false;
        }
        
        
        if(bx041.Reference_Process_ID_txt__c != NULL){
            ID processid ;
            for(process__c  pc:  [SELECT ID, name FROM process__c WHERE name = :bx041.Reference_Process_ID_txt__c AND Process_Family__c = :bx041.Process_Family_Filter__c and Tech_Geometry__c =: bx041.Geometry_Filter__c]){
                processid = pc.id;
            }
            if(processid != NULL){
                bx041.Requested_Process_ID__c = processid;
                onchangePopulateFEComments();
            }
            
        }else if(bx041.Requested_Process_ID__c != null){
            // ZAmbat 10172014
            //list<Process__c> processList =   [SELECT ID, name FROM process__c WHERE id = :bx041.Requested_Process_ID__c AND Process_Family__c = :bx041.Process_Family_Filter__c and Tech_Geometry__c =: bx041.Geometry_Filter__c];
            list<Process__c> processList =   [SELECT ID, name FROM process__c WHERE id = :bx041.Requested_Process_ID__c AND Tech_Geometry__c =: bx041.Geometry_Filter__c];
            if(processList.isEmpty()){
                Apexpages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR,'Requested Process ID does not exist or does not match filter criteria.'));
            }    
            
        }
        
        if(bx041.Die_Size_X_mm__c == 0 ) bx041.Die_Size_X_mm__c = null;
        if(bx041.Die_Size_Y_mm__c == 0 ) bx041.Die_Size_Y_mm__c = null;
        insert bx041;
              
        list<sobject> sobjList = new list<sobject>();               
        
        if(!saveAllSectons(sobjList, reqValidation)){
            return false;
        }
        
        list<sobject> ipKitList = new list<sobject>();
        if(bx041.Need_IP_information__c && (!saveIpKit(ipKitList))){
            return false;
        }
        if(bx041.Need_IP_Merge_information__c && (!saveIpmKit(ipKitList))){
            
            return false;
        }
        
        insert sobjList;
        insert ipKitList;
            
        return true;
    }
    /*
    public pagereference cancel(){
        displayPopUp = false;
        return null;
    }*/
    
     public pagereference saveAndClose(){
        try{
            if(!saveAll(false)){
                return null;
            }
        }catch(exception ex){
            addMessage(ex.getdmlMessage(0));
            return null;
        }
        return new pagereference('/'+bx041.device__c);
    }
    /*
    Action Method : Save the form and related records
    Return Type:    PageReference - return to BX041 detail page
    */
    public pagereference save(){
        try{
            if(!saveAll(false)){
                return null;
            }
        }catch(exception ex){
            addMessage(ex.getdmlMessage(0));
            return null;
        }
       
        
        return new pagereference('/'+bx041.id);
        
    }
    /*
    Action Method : Add new Ip Merge record into ipmList in viewstate
    Return Type:    NA
    */
    public void addIpm(){
        if(ipmList == null){
            ipmList = new List<BX041_IP_Merge__c>();
        }
        
        ipmList.add(new BX041_IP_Merge__c(IP_Master__c = null,remarks__c = ''));
    }
    /*
    Action Method : Remove Ip Merge record from ipmList in viewstate
    Return Type:    NA
    */
    public void remIpm(){
        Integer ipSeq = Integer.valueOf(ApexPages.currentPage().getParameters().get('ipSeq'));
        ipmList.remove(ipSeq);
    }
    /*
    Action Method : Retrieve Process info based on request Process ID and populate FE coloumn in Process Id Section
    Return Type:    NA
    */
    public void onchangePopulateFEComments(){
        Map<String,String> mapFEandPIYE = ProcessInformationHandler.getProcessQuestions(bx041.Requested_Process_ID__c);
        if(bx041.Requested_Process_ID__c != NULL){
            for(TopSectionWrapper tsw : topSecWrapperList ){
               if(tsw.recordType.equals(Label.QM_RT_PI)){               
                   for(SectionWrapper sw : tsw.sectionList  ){
                       for(RowWrapper rw : sw.rowList){
                           if(mapFEandPIYE.get(rw.qmId)!= null){
                               rw.fe = mapFEandPIYE.get(rw.qmId);
                               rw.feEditable = false;
                           } else {
                               //wc.FEInfo = string.valueOf(mapSobjectData.get('Process_Information__c').get(wc.metadataid).get('FE_Requested_Information__c'));
                               rw.feEditable = true;
                           }
                       }
                   }
                   break;
               }
            } 
        } 
        else{//if requested process ID is null
           for(TopSectionWrapper tsw : topSecWrapperList ){
               if(tsw.recordType.equals(Label.QM_RT_PI)){               
                   for(SectionWrapper sw : tsw.sectionList  ){
                       for(RowWrapper rw : sw.rowList){
                           rw.fe = '';
                           rw.feEditable = true;
                       }
                   }
                   break;
               }
            }
        }      
    }
    /*
    Action Method : Remove Ip record from ipList in viewstate
    Return Type:    NA
    */
    public void remIp(){
        Integer ipSeq = Integer.valueOf(ApexPages.currentPage().getParameters().get('ipSeq'));
        currentIp = ipwList[ipSeq];
        ipwList.remove(ipSeq);
        if(currentIp.stepNo != '3'){
                addNewIP = true;
        }
        
        if(ipwList.size() == 0){
            addNewIP = true;
        }
        
        currentIp = null;
    }
    /*
    Action Method : Add new Ip record into ipList in viewstate
    Return Type:    NA
    */
    public void addIp(){
        if(ipwList == null){
            ipwList = new List<Bx041IpWrapper>();
        }
        
        currentIp = new Bx041IpWrapper();
        currentIp.bx041Ip = new BX041_IP__c();
        currentIp.stepNo = '0';
        //currentIp.status = false;
        ipwList.add(currentIp); 
        addNewIP = false;
        iptypevalue = '';
    }
    /*
    Action Method : Popup window for BX041 IP when IP master is selected
    Return Type:    NA
    */
    public void onchangePopulateIP(){
        Integer ipSeq = Integer.valueOf(ApexPages.currentPage().getParameters().get('ipSeq'));
        currentIP = ipwList[ipSeq];
        
        if(currentIP.bx041Ip.IP_Master__c == null){
            return;
        }
        /*
        BX041_IP__c newIP = new BX041_IP__c();
        newIP.IP_Type__c = currentIP.bx041Ip.IP_Type__c;
        newIP.IP_Master__c = currentIP.bx041Ip.IP_Master__c;
        currentIP.bx041Ip = newIP;*/
        
        for( integer i=0; i< ipwList.size();i++){
            if(i == ipSeq){
                continue;
            }
            Bx041IpWrapper ipw  = ipwList[i];
            if(ipw.bx041Ip.IP_Master__c == currentIP.bx041Ip.IP_Master__c){
                addMessage('Duplicate IP Design Kit selected: ' + ipw.ipmaster);
                currentIP.bx041Ip.IP_Master__c = null;
                return;
            }
        }
        
        
        IP__c ipMaster = [select id,name,IP_Type__c,IP_Technology__c,IP_Device_List__c,Lifecycle__c,Latest_Version__c,Library_Name__c,IP_Type_Category__c,IP_Vendor__c from IP__c where id = :currentIP.bx041Ip.IP_Master__c];
        //currentIP.bx041Ip.IP_Type__c = ipMaster.IP_Type__c;
        currentIP.bx041Ip.IP_CATG__c = ipMaster.IP_Type_Category__c;
        currentIP.bx041Ip.Version__c = ipMaster.Latest_Version__c;
        currentIP.bx041Ip.Lib_Nm__c = ipMaster.Library_Name__c;
        currentIP.bx041Ip.Vendor__c  = ipMaster.IP_Vendor__c;
        currentIP.bx041Ip.IP_Device_List__c = ipMaster.IP_Device_List__c;
        currentIP.ipMaster = ipMaster.name;
        /*
        if(String.isEmpty(currentIP.bx041Ip.IP_Type__c)){
            addMessage('IP Type is empty for selected IP Master.');
            return;
        }*/
        displayPopUp = true;
        currentIp.stepNo = '2';
    }
    /******************************************************************************************************
    @Method Name:    getFields
    @Return Type:    List<Schema.FieldSetMember>
    @parameter:      NA
    @Reason:         This method is used to get the API name of the field used in the additional information section
    *******************************************************************************************************/
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.BX_041__c.FieldSets.CDRS_Addition_Information.getFields();
    }
    
    /*
    Action Method : Display different fields when IP Type is changed
    Return Type:    NA
    */
    public void onchangeIPType(){
        Integer ipSeq = Integer.valueOf(ApexPages.currentPage().getParameters().get('ipSeq'));
        currentIP = ipwList[ipSeq];
        currentIp.stepNo = '1';
        iptypevalue = currentIP.bx041Ip.IP_Type__c;
    }
    /*
    Action Method : Popup BX041 window when Edit button on specific IP is clicked
    Return Type:    NA
    */
    public void editIp(){
        
        Integer ipSeq = Integer.valueOf(ApexPages.currentPage().getParameters().get('ipSeq'));
        currentIP = ipwList[ipSeq];
        displayPopup = true;
    }
    
    /*
    Method : Add error message to pages
    Paremeter: String - msg to display
    Return Type:    NA
    */
    private void addMessage(String msg){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, msg);
        ApexPages.addMessage(myMsg);
    }
    /*
    Action Method : Cancel button on BX041 IP popup window, revert all fields
    Return Type:    NA
    */
    public void cancelIpPopup() {
        //reset the value
        displayPopup = false;
        if(currentIp.stepNo == '2'){
            currentIP.bx041Ip.IP_CATG__c = null;
            currentIP.bx041Ip.Version__c = null;
            currentIP.bx041Ip.Lib_Nm__c = null;
            currentIP.bx041Ip.Vendor__c  = null;
            currentIP.bx041Ip.IP_Master__c = null;
            currentIP.bx041Ip.IP_Device_List__c = null;
            currentIP.ipMaster = null;
            currentIp.stepNo = '1';
        }
    }
    /*
    Action Method : Save button on BX041 IP popup window, save values of fields in viewstate
    Return Type:    NA
    */
    public void saveIpPopup() {
        displayPopup = false;
        if(currentIp.stepNo != '3'){
                addNewIP = true;
        }        
        currentIp.stepNo = '3';
    }
    /*
    Action Method : Display dynamic component for BX041 IP popup window
    Return Type:    NA
    */
    public Component.Apex.PageBlock getDynamicComp(){
        Component.Apex.PageBlock pb = new Component.Apex.PageBlock();
        
        if(!displayPopup) {
            pb.rendered = false;
        } else {
            Component.Apex.PageBlockButtons  pbbs = new Component.Apex.PageBlockButtons();
            pbbs.location = 'bottom';
            
            Component.Apex.Commandbutton btn2 = new Component.Apex.Commandbutton();
            btn2.expressions.action = '{!saveIpPopup}';
            btn2.value='Save';
            //btn2.style='center';
            btn2.status = 'blockUI';
            btn2.reRender= new set<string>{'ip_pb'};
            pbbs.childcomponents.add(btn2);
            
            Component.Apex.Commandbutton btn = new Component.Apex.Commandbutton();
            btn.expressions.action = '{!cancelIpPopup}';
            btn.value='Cancel';
            //btn.style='center';
            btn.immediate = true;
            btn.status = 'blockUI';
            btn.reRender= new set<string>{'ip_pb'};
            pbbs.childcomponents.add(btn);
            
            pb.childcomponents.add(pbbs);
            
            Component.Apex.PageBlockSection pbs = new Component.Apex.PageBlockSection();
            pbs.title = currentIP.bx041Ip.IP_Type__c;
            pbs.rendered = true;
            Component.Apex.OutputField ipType = new Component.Apex.OutputField();
            ipType.expressions.value = '{!currentIP.bx041Ip.IP_Type__c}';
            /*
            Component.Apex.ActionSupport ipTypeSpt = new Component.Apex.ActionSupport();
            ipTypeSpt.expressions.action = '{!onchangeIPType}';
            ipTypeSpt.event = 'onchange';
            ipTypeSpt.status = 'blockUI';
            ipTypeSpt.rerender = new set<string>{'ipdetail'};
            ipType.childcomponents.add(ipTypeSpt);*/
            pbs.childcomponents.add(ipType);
            
            
            BX041IP__c dsCommon = BX041IP__c.getInstance('Common');
            String fieldList = dsCommon.Field_List__c;
            
            String ipTypeUpperCase = pbs.title.toUpperCase();
            BX041IP__c spec = BX041IP__c.getInstance(ipTypeUpperCase);
            if(spec != null && !String.isEmpty(spec.Field_List__c)){
                fieldList = fieldList + ','+ spec.Field_List__c;
                if(!String.isEmpty(spec.Field_List2__c)){
                    fieldList = fieldList + ','+ spec.Field_List2__c;
                }
            }
             
            for(String fieldName : fieldList.split(',')){
                    Component.Apex.InputField inf = new Component.Apex.InputField();
                    inf.expressions.value = '{!currentIP.bx041Ip.'+ fieldName.trim() + '}';
                    pbs.childcomponents.add(inf);
            }
            
            pb.childcomponents.add(pbs);
            
        }
        return pb;
    }
    /* =============================================  Main Methods End  ============================================= */
    
    /* =============================================  Helper Methods Start  ============================================= */
    /*
    Method : Save BX041 IP Merge records into DB
    Parameter: List<Sobject> - list to hold IP Merge records
    Return Type:  Boolean - result of Insert operation
    */
    private boolean saveIpmKit(list<sobject> ipKitList){
        boolean result = true;
        set<id> ipMasterSet = new set<id>();
        for(BX041_IP_Merge__c ipm : ipmList){            
            if(ipm.IP_Master__c != null){
                if(ipMasterSet.contains(ipm.IP_Master__c)){
                    result = false;
                    addMessage('Duplicate BX041 IP Merge - ' + ipm.IP_Master__c);
                    continue;
                }
                ipm.BX_041__c = bx041.id;
                ipKitList.add(ipm);
                ipMasterSet.add(ipm.IP_Master__c);
            }else if(!String.isEmpty(ipm.remarks__c)){
                ipm.BX_041__c = bx041.id;
                ipKitList.add(ipm);
            }
        }

        return result;
    }
    /*
    Method : Save BX041 IP records into DB
    Parameter: List<Sobject> - list to hold IP records
    Return Type:  Boolean - result of Insert operation
    */
    private boolean saveIpKit(list<sobject> ipKitList){
        //List<BX041_IP__c> newIpList = new List<BX041_IP__c>();
        boolean result = true;
        set<id> ipMasterSet = new set<id>();
        for(Bx041IpWrapper ipWrapper : ipwList){
                      
            if(ipWrapper.bx041Ip.IP_Master__c != null ){
                if(ipMasterSet.contains(ipWrapper.bx041Ip.IP_Master__c)){
                    result = false;
                    addMessage('Duplicate BX041 IP - ' + ipWrapper.ipMaster);
                    continue;
                }
                
                ipMasterSet.add(ipWrapper.bx041Ip.IP_Master__c);
            }/*else if(!String.isEmpty(ipWrapper.bx041Ip.remarks__c )){
                ipWrapper.bx041Ip.BX_041__c = bx041.id;
                ipKitList.add(ipWrapper.bx041Ip);
            }*/
            
            ipWrapper.bx041Ip.BX_041__c = bx041.id;
            ipKitList.add(ipWrapper.bx041Ip);
        }
        //insert newIpList;
        return result;
    }
    
    /*
    Method : Save all BX041 related records except IP & IP Merge
    Parameter: List<Sobject> - list to hold IP Merge records
               Boolean  - Whether need form validation
    Return Type:  Boolean - result of Insert operation
    */
    private Boolean saveAllSectons(list<sobject> sObjList, boolean reqValidation){
        Boolean result = true;
        for(TopSectionWrapper tsw : topSecWrapperList) {
            if(tsw.recordType.equals(Label.QM_RT_PI)){
                //List<Process_Information__c> newPIList = new List<Process_Information__c>();
                
                for(SectionWrapper sw : tsw.sectionList){
                    for(RowWrapper rw : sw.rowList){
                        /*if(reqValidation ){
                            if(rw.mandatory && String.isBlank(rw.value)){
                                addMessage(Label.QM_RT_PI + '- Customer Request is required for : '+ rw.question2Display);
                                result = false;
                                continue;
                            }
                        }*/
                        
                        Process_Information__c pi = new Process_Information__c();
                        pi.BX_041__c = bx041.id;
                        pi.Question__c = rw.question2Display;
                        pi.Question_to_Display__c = rw.question2Display;
                        pi.FE_Requested_Information__c = rw.fe;
                        //pi.PIYE__c = rw.piye;
                        pi.Customer_Request__c = rw.value;
                        pi.Customer_Comment__c = rw.custCmts;
                        pi.Requirement_Gaps__c = rw.rqmtGap;
                        pi.Comments__c = rw.internalCmts;
                        pi.Question_Metadata__c = rw.qmId; 
                        pi.mandatory__c = rw.mandatory;
                        sobjList.add(pi);                  
                    }
                }
                //insert newPIList;
                
            } else if(tsw.recordType.equals(Label.QM_RT_GA)){
                //List<Gap_Analysis_Form__c> newRecordList = new List<Gap_Analysis_Form__c>();
                
                for(SectionWrapper sw : tsw.sectionList){
                    for(RowWrapper rw : sw.rowList){
                        
                        if(reqValidation ){
                            if(rw.mandatory && String.isBlank(rw.value)){
                                addMessage(Label.QM_RT_GA + '- Answer is required for : '+ rw.question2Display);
                                result = false;
                                continue;
                            }
                            if(rw.value != null && rw.value.equals('Yes')&& String.isBlank(rw.comment)){
                                addMessage(Label.QM_RT_GA + '- Comment is required if Status is Yes for : '+ rw.question2Display);
                                result = false;
                                continue;
                            }
                        }
                        
                        Gap_Analysis_Form__c rec = new Gap_Analysis_Form__c(BX_041__c = bx041.id);
                        rec.Gap_Name__c = rw.question2Display;
                        rec.APTS_Status__c = rw.value;
                        rec.APTS_Comments__c = rw.comment;
                        rec.APTS_Resolution__c = rw.resolution; 
                        rec.Question_Metadata__c = rw.qmId; 
                        
                        if(rw.question2Display == 'IP QA Status' && (rw.value == 'None' || rw.value == 'No Gap/NA') ){
                            rec.APTS_Status__c = 'No Gap/NA';
                            String ipNo = getGapIP(ipwList, ipmList);
                            if(ipNo != null){
                                rec.APTS_Status__c = 'Yes';
                                rec.APTS_Comments__c = ipNo;
                            }
                        }
                        sobjList.add(rec);                  
                    }
                }
                //insert newRecordList;
                
            } else {
                String instanceName = tsw.recordType;
                BX041__c ds = BX041__c.getInstance(instanceName);
                
                //Boolean isChecked = Boolean.valueOf(bx041.get(ds.Need_Name__c));
                
                //List<SObject> newObjList = new List<SObject>();
                
                for(SectionWrapper sw : tsw.sectionList){
                    for(RowWrapper rw : sw.rowList){
                        
                        sObject sObj = Schema.getGlobalDescribe().get(ds.SObject_Type__c).newSObject() ;  
                        sObj.put('BX_041__c' , bx041.id);
                        sObj.put(ds.API_Name__c, rw.question2Display);
                        sObj.put('Question_Metadata__c',rw.qmId);
                        sObj.put('Value__c', rw.value);
                       
                        sobjList.add(sObj);                   
                    }
                }
            }
        }
        
        return result;
    }
    private String getGapIP(List<Bx041IpWrapper> ipList,List<BX041_IP_Merge__c> ipmList){
        String result = '';
        if(bx041.need_ip_information__c ){
            set<id> ipSet  = new set<id>();
            for(Bx041IpWrapper ipw : ipList){
                if(ipw.bx041Ip.IP_Master__c != null){
                    ipSet.add(ipw.bx041Ip.IP_Master__c);
                }
            }
            if(ipSet.size() > 0){
                List<IP__c> ipResult = [select name from IP__c where id in :ipSet and PH1_QA_Status__c = 'NCR' and Showstopper__c = 'Yes'];
                if( !ipResult.isEmpty()) {
                    for(IP__c ip : ipResult){
                        result = result + ip.name+',';
                    }
                }
            }
            
        }
        
        if(bx041.need_ip_merge_information__c){
            set<id> ipSet  = new set<id>();
            for(BX041_IP_Merge__c ipm : ipmList){
                if(ipm.IP_Master__c != null){
                    ipSet.add(ipm.IP_Master__c);
                }
            }
            
            if(ipSet.size() > 0){
                List<IP_Merge__c> ipmResult = [select name from IP_Merge__c where id in :ipSet and PH1_QA_Status__c = 'NCR' and Showstopper__c = 'Yes'];
                if( !ipmResult.isEmpty()) {
                    for(IP_Merge__c ipm : ipmResult){
                        result = result + ipm.name+',';
                    }
                }
            }
            
        }
        
        if(result != ''){
            return result.removeEnd(',');
        }else
            return null;
        
    }
    /*
    Method : Retrieve template name based on geometry of device
    Parameter: String - Geometry of Device
    Return Type:  String - template name
    */
    public String getTemplate(String geometry){
        Decimal GeomValue ;
        String TempName; 
        if(geometry!= null || geometry != ''){
            GeomValue = Decimal.ValueOf(geometry.replace('UM',''));
            if(GeomValue <= 0.032 ){
                TempName = 'Geometry 32nm/28nm & below';
                
            }
            else if(GeomValue >= 0.040 && GeomValue <= 0.045){
                TempName = 'Geometry 45nm - 40nm';
            }
            else if(GeomValue >= 0.055 && GeomValue <= 0.090){
                TempName= 'Geometry 90nm - 55nm';
            }
            else if(GeomValue >= 0.11 && GeomValue <= 0.13){
                TempName= 'Geometry 0.11um - 0.13um';
            }
            else if(GeomValue >= 0.14 && GeomValue <= 0.25){
                TempName= 'Geometry 0.14um - 0.25um';
            }
            else if(GeomValue >= 0.30){
                TempName= 'Geometry 0.30um & Greater';
            }
            else{
                TempName = 'None';
            }
        }
        return TempName;
    }
    /*
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
    }  */ 
    
    /* =============================================  Helper Methods End ============================================= */
    
    /* =============================================  Wrapper Start ================================================== */
    public List<Bx041IpWrapper> ipwList {get; set;}
    public Bx041IpWrapper currentIP {get; set;}
    public List<BX041_IP_Merge__c> ipmList {get; set;}
    
    /*
    Class Name:    Bx041IpWrapper 
    Author:        Thomas Lai(TL)
    Description:   This Class manages the BX041 IP records on create page.
    History: 
      TL           02072013    - Creation.
    */
    public class Bx041IpWrapper {
        public BX041_IP__c bx041Ip {get; set;}
        public String lifecycle {get; set;}
        public String technology {get; set;}
        //public Boolean status {get;set;}
        public String stepNo {get; set;}
        public String ipMaster {get; set;}
        
    }
    
    public List<TopSectionWrapper> topSecWrapperList {get;set;}
    /*
    Class Name:    RowWrapper 
    Author:        Thomas Lai(TL)
    Description:   This Class manages the BX041 related record in different sections on create page.
    History: 
      TL           02072013    - Creation.
    */
    public class RowWrapper{
        public String question2Display {get; set;}
        public String value {get; set;}
        public List<selectOption> optionList {get; set; }
        public String fieldType {get; set;}
        public Boolean  mandatory {get; set;}
        public String custCmts {get; set;} // for customer comment in PI
        public String internalCmts {get; set;} //for comments in PI
    
        public String rqmtGap {get; set;} // for requirement gap in PI
        public String fe {get; set;} // for FE in PI
        public Boolean feEditable {get; set;}
        public String comment {get; set;} // for comment in GA
        public String resolution {get; set;} // for resolution in GA
        public Id qmId{get; set;}
        
    }
    
    /*
    Class Name:    RowWrapper 
    Author:        Thomas Lai(TL)
    Description:   This Class manages sub sections on create page.
    History: 
      TL           02072013    - Creation.
    */
    public class SectionWrapper{
        public List<RowWrapper> rowList {get; set;}
        public String title {get; set;}
        public String recordType {get; set;}

    }
    /*
    Class Name:    RowWrapper 
    Author:        Thomas Lai(TL)
    Description:   This Class manages sections on create page.
    History: 
      TL           02072013    - Creation.
    */
    public class TopSectionWrapper{
        public List<SectionWrapper> sectionList {get; set;}
        public Boolean visible {get; set;}
        public String shortname {get; set;}
        public String title {get; set;}
        public String recordType {get; set;}
        //public String tabStyle {get; set;}
    }
    
    /* =============================================  Wrapper End ==================================================== */
    /*
    Method : Generate wrappers for all sections once page is loaded.
    Return Type:  NA
    */
    private void init(/*List<string> visibileSectionList*/) {
        
        topSecWrapperList = new List<TopSectionWrapper>();
        List<Question_Metadata__c> qmList = [SELECT  id,
                                                           name,
                                                           Record_Type__c,
                                                           Mandatory__c,
                                                           Question__c,
                                                           Question_to_Display__c,
                                                           Sequence__c,                                        
                                                           Type__c,
                                                           Question_Metadata_Section__c,
                                                           Mandatory_for_Templates__c
                                                           
                                               FROM        Question_Metadata__c
                                               WHERE       Sequence__c <> null 
                                               and         ((Record_Type__c = 'Process Id' and template_name__c includes( :templateName)) or Record_Type__c != 'Process Id')
                                               ORDER BY    Record_Type__c,
                                                           Sequence__c
                                            ];
                                            
        Set<String> pkltQstnSet = new Set<String>();  
        List<Question_Metadata__c>  topSecList = new List<Question_Metadata__c>();
        Map<id, List<Question_Metadata__c>>  qmHierachyMap = new  Map<id, List<Question_Metadata__c>>(); 
        for(Question_Metadata__c qm : qmList) {
            
            if(qm.Type__c.equals('Picklist')) {
                // Populate set pkltQstnSet
                pkltQstnSet.add(qm.id);// Populate set pkltQstnSet
            } else if (qm.Type__c.equals(Label.QM_Type_TopSection)){
                // Populate List topSecList
                topSecList.add(qm); 
            } 
            
            if(!String.isBlank(qm.Question_Metadata_Section__c)){ //&& qm.Question_Metadata_Section__r.Type__c.equals(Label.QM_Type_TopSection)
                /** Populate map - qmHierachyMap  **/
                if(qmHierachyMap.containsKey(qm.Question_Metadata_Section__c)){
                    qmHierachyMap.get(qm.Question_Metadata_Section__c).add(qm);
                }else{
                    List<Question_Metadata__c> newList = new List<Question_Metadata__c>();
                    newList.add(qm);
                    qmHierachyMap.put(qm.Question_Metadata_Section__c,newList);
                }
                /** Populate map - qmHierachyMap  **/
            }
         }                                    
        Map<id,List<selectOption>> qm2SelectOptionsMap = new map <id,List<selectOption>>();                                     
        
        list<Question_Metadata_Picklist_Value__c> qmpvList = [SELECT   id,
                                                                 name,
                                                                 Question_Metadata__c,
                                                                 Value__c
                                                                 
                                                          FROM   Question_Metadata_Picklist_Value__c
                                                          WHERE  Question_Metadata__c 
                                                          IN     :pkltQstnSet 
                                                          ORDER BY sequence__c];
        for (Integer i=0;i<qmpvList.size();i++) {
            Question_Metadata_Picklist_Value__c qmpv  = qmpvList[i];
             if(qm2SelectOptionsMap.containsKey(qmpv.Question_Metadata__c)){
                qm2SelectOptionsMap.get(qmpv.Question_Metadata__c).add(new selectOption(qmpv.Value__c,qmpv.Value__c));
             } else {
                List<selectOption> currentlist = new List<selectOption>();
                //currentlist.add(new selectOption('None','None'));
                currentlist.add(new selectOption(qmpv.Value__c,qmpv.Value__c));
                qm2SelectOptionsMap.put(qmpv.Question_Metadata__c,currentlist);
             }                                          
        }
        
        for(Question_Metadata__c topSec: topSecList ){
            TopSectionWrapper tsWrapper = new TopSectionWrapper();
            List<SectionWrapper> sWrapperList = new List<SectionWrapper>();
            //List<RowWrapper> lv2RowWrapperList = new List<RowWrapper>();
            
            for(Question_Metadata__c lv2: qmHierachyMap.get(topSec.id)){
                
                if(lv2.Type__c.equals('Section')){
                    
                    SectionWrapper sWrapper = new SectionWrapper();             
                    List<RowWrapper> lv3RowWrapperList = new List<RowWrapper>();
                    if(!qmHierachyMap.containsKey(lv2.id)){
                        continue;
                    }
                    for(Question_Metadata__c lv3: qmHierachyMap.get(lv2.id)){
                        RowWrapper rWrapper = new RowWrapper();
                        rWrapper.question2Display = lv3.Question__c;
                        //rWrapper.question = lv3.Question__c; 
                        rWrapper.mandatory = false;
                        if (lv3.Type__c.equals('Picklist')){                
                            rWrapper.optionList = qm2SelectOptionsMap.get(lv3.id);
                        }else{
                            rWrapper.value = '';
                        }
                        rWrapper.fieldType = lv3.Type__c;
                        rWrapper.qmId = lv3.id;
                        /*
                        if(lv3.record_type__c.equals(Label.QM_RT_GA)){
                                rWrapper.comment = '';
                                rWrapper.resolution = '';
                        }*/
                        if (lv3.record_type__c.equals(Label.QM_RT_PI)){
                                rWrapper.custCmts = '';
                                //rWrapper.internalCmts = '';
                                if(lv3.Mandatory_for_Templates__c != null ){
                                    if(lv3.mandatory__c  || lv3.Mandatory_for_Templates__c.contains(templateName)){
                                        rWrapper.mandatory = true;
                                    }
                                }
                        }
                        
                        lv3RowWrapperList.add(rWrapper);
                    }
                    
                    sWrapper.rowList = lv3RowWrapperList;
                    //sWrapper.sectionInfo = lv2;
                    sWrapper.title = lv2.Question__c;
                    sWrapper.recordType = lv2.record_type__c;
                    sWrapperList.add(sWrapper);
                } 
            }
            
            tsWrapper.recordType = topSec.record_type__c; //set recordtype for topSectionWrapper
            BX041__c ds = BX041__c.getInstance(tsWrapper.recordType);
            tsWrapper.visible = ds.Visible__c;
            tsWrapper.shortname = ds.Short_Name__c;            
            tsWrapper.title = ds.Section_Name__c;
            tsWrapper.sectionList = sWrapperList;
            //tsWrapper.tabStyle = ds.TabStyle__c;
            
            topSecWrapperList.add(tsWrapper);
        }
        
        addIp(); // initial BX041 IP
        
        addIpm(); // initial BX041 IP Merge
        
    }

}