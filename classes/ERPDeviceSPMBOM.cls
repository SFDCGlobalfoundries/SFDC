/*
*   Author: KOKA GOPI
*   Description:  Class used to show list of ERP_Device_SPDBOM__c data.
*   History: 
*   GOPI KOKA 3/28/2017    - Class created    
*/
public class ERPDeviceSPMBOM{
    
    Public Integer size{get;set;} 
    Public Integer noOfRecords{get; set;} 
    public List<SelectOption> paginationSizeOptions{get;set;}
    Public List<PSAPSCJuntionObjectWC> ppjowc{get;set;}    
    public integer totalCountRecords{get;set;}
    public String deviceName{get;set;}
    public String parentPartName{get;set;}
    public List<ERP_Device_SPDBOM__c> allJO{get;set;}
    Public ID ERPid{get;set;}
    
    //Custom Setting values
    Public String defaultAlert{get;set;}
    Public String syncAlert{get;set;}
    
    String ERPEid;
    String query;
    ERP_Device__c erpDevice;
    
    public ERPDeviceSPMBOM(){
        size=20;
        defaultAlert = Error_Codes__c.getValues('ERPDeviceSPMBOM-DefaultVFAlert').Message__c;
        syncAlert    = Error_Codes__c.getValues('ERPDeviceSPMBOM-ReplaceVFAlert').Message__c;
        ID currentLoginUserID = Userinfo.getUserId();
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('100','100'));
    }
    /******************************************************************************************************
    @Method Name:    QueryLocator Method
    @Return Type:    ApexPages.StandardSetController
    @parameter:      NA
    @Reason:         return based on size mentioned in constroctor.
    *******************************************************************************************************/ 
    public ApexPages.StandardSetController setCon {
        get {
            ERPid = apexpages.currentpage().getparameters().get('id');
            ERPEid = apexpages.currentpage().getparameters().get('Eid');
            erpDevice = [SELECT id,PSANew__c,PSCNew__c FROM ERP_Device__c WHERE id=:ERPid];
            if(setCon == null) {        
                List<Schema.FieldSetMember> fs = SObjectType.ERP_Device_SPDBOM__c.FieldSets.PSAPSC.getFields();
                query = 'SELECT ';
                for(Schema.FieldSetMember f : fs) {
                    query += f.getFieldPath() + ', ';
                }
                query += 'Id, Name, ERP_Device__r.Name , Parent__c ,ERP_Device__r.Part_Number__c FROM ERP_Device_SPDBOM__c WHERE (Parent__c =:ERPEid)';
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
                setCon.setPageSize(size);  
                noOfRecords = setCon.getResultSize();
            }            
            return setCon;
        }
        set;
    }
    /******************************************************************************************************
    @Method Name:    refreshPageSize
    @Return Type:    NA
    @parameter:      NA
    @Reason:         used to refresh list from intial load
    *******************************************************************************************************/
    public PageReference refreshPageSize() {
        setCon.setPageSize(size);
        return null;
    }
    
    /******************************************************************************************************
    @Method Name:    getPSAPSCJuntionObject
    @Return Type:    List<PSAPSCJuntionObjectWC>
    @parameter:      NA
    @Reason:         return list of wrapper data based on page size updated
    *******************************************************************************************************/
    public List<PSAPSCJuntionObjectWC> getPSAPSCJuntionObject() {
        ppjowc= new List<PSAPSCJuntionObjectWC>();
        for (ERP_Device_SPDBOM__c jo: (List<ERP_Device_SPDBOM__c>)setCon.getRecords()){
            ppjowc.add(new PSAPSCJuntionObjectWC(jo));
        }
        totalCountRecords = ppjowc.size();
        if(ppjowc.size()>0){
            deviceName     = ppjowc[0].ppjo.ERP_Device__r.Name;
            parentPartName = ppjowc[0].ppjo.ERP_Device__r.Part_Number__c;
        } 
        return ppjowc;
    }
    /******************************************************************************************************
    @Method Name:    getAllERPBOMRecords
    @Return Type:    List<ERP_Device_SPDBOM__c>
    @parameter:      NA
    @Reason:         return list of download all excel data
    *******************************************************************************************************/
    public List<ERP_Device_SPDBOM__c> getAllERPBOMRecords(){
        List<Schema.FieldSetMember> fs = SObjectType.ERP_Device_SPDBOM__c.FieldSets.PSAPSC.getFields();
        String queryAll = 'SELECT ';
        for(Schema.FieldSetMember f : fs) {
            queryAll += f.getFieldPath() + ', ';
        }
        queryAll += 'Id, Name, ERP_Device__r.Name , Parent__c ,ERP_Device__r.Part_Number__c FROM ERP_Device_SPDBOM__c WHERE (Parent__c =:ERPEid)';
        List<ERP_Device_SPDBOM__c> dBom = Database.Query(queryAll);   
        return dBom;
    }
    
    /******************************************************************************************************
    @Method Name:    logicExecution
    @Return Type:    NA
    @parameter:      NA
    @Reason:         logic execution for sync and default buttons
    *******************************************************************************************************/
    public void logicExecution(){
        try{
            string fromPage = Apexpages.currentPage().getParameters().get('myParam');
            if(fromPage == 'replace'){
                replacePSAPSC();
            } else if(fromPage == 'default'){
                defaultPSAPSC();
            }
            erpDevice.Integration_Status__c = 'ReadytoSend';
            DataBase.update(erpDevice,False);
            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        }catch(Exception e){
            GlobalUtility.logMessage('Error','ERPDeviceSPMBOM','execute','','Exception : ',String.valueof(e.getMessage()),'','All',e,0);
        }
    }
    /******************************************************************************************************
    @Method Name:    defaultPSAPSC
    @Return Type:    NA
    @parameter:      NA
    @Reason:         logic execution for update default values for APA,APC,PSA,PSA Fields
    *******************************************************************************************************/
    public void defaultPSAPSC(){
        try{
            List<ERP_Device_SPDBOM__c> ppj = New List<ERP_Device_SPDBOM__c>();
            for(PSAPSCJuntionObjectWC rv:ppjowc){
                if(rv.chkVar){
                    rv.ppjo.PSA__c = Error_Codes__c.getValues('ERPDeviceSPMBOM-PSADefault').Message__c;
                    rv.ppjo.PSC__c = Error_Codes__c.getValues('ERPDeviceSPMBOM-PSCDefault').Message__c;
                    rv.ppjo.APA__c = Error_Codes__c.getValues('ERPDeviceSPMBOM-PSADefault').Message__c;
                    rv.ppjo.APC__c = Error_Codes__c.getValues('ERPDeviceSPMBOM-PSCDefault').Message__c;
                    rv.ppjo.Integration_Status__c = 'ReadytoSend';
                }
                ppj.add(rv.ppjo);
            }
            DataBase.update(ppj,false);
        }catch(Exception e){
            GlobalUtility.logMessage('Error','ERPDeviceSPMBOM','execute','','Exception : ',String.valueof(e.getMessage()),'','All',e,0);
        }
    }
    /******************************************************************************************************
    @Method Name:    ReplacePSAPSC
    @Return Type:    NA
    @parameter:      NA
    @Reason:         logic execution for update APA,APC,PSA,PSA Fields
    *******************************************************************************************************/
    public void replacePSAPSC(){
        try{
            List<ERP_Device_SPDBOM__c> ppj = New List<ERP_Device_SPDBOM__c>();
            for(PSAPSCJuntionObjectWC rv:ppjowc){
                if(rv.chkVar){
                    rv.ppjo.APA__c = erpDevice.PSANew__c;
                    rv.ppjo.APC__c = erpDevice.PSCNew__c;
                    rv.ppjo.PSA__c = erpDevice.PSANew__c;
                    rv.ppjo.PSC__c = erpDevice.PSCNew__c;
                    rv.ppjo.Integration_Status__c = 'ReadytoSend';
                }
                ppj.add(rv.ppjo);
            }
            DataBase.update(ppj,false);
        }catch(Exception e){
            GlobalUtility.logMessage('Error','ERPDeviceSPMBOM','execute','','Exception : ',String.valueof(e.getMessage()),'','All',e,0);
        }
    }
    /******************************************************************************************************
    @Class Name:    PSAPSCJuntionObjectWC
    @parameter:      NA
    @Reason:         Wrapper Class
    *******************************************************************************************************/
    public Class PSAPSCJuntionObjectWC{
        public Boolean chkVar{get;set;}
        public ERP_Device_SPDBOM__c ppjo{get;set;}
        public PSAPSCJuntionObjectWC(ERP_Device_SPDBOM__c ppj){
            ppjo = ppj;
            chkVar = false;
        }
    }
}