/**
* Author: Devendra Babu Itraju
* Company: GF
* Project: Standard Foundry Frame Generation 
* Description: 
*  
*  
* History:
*    <Devendra Babu Itraju> 2016-03-10 - Created
*    <Devendra Babu Itraju> 2017-09-19 - fix for duplicate email
**/
public without sharing class SFFG_CreatePrimeDieCtrl {
    String deviceId;
    public SFFG_Standard_Foundry_Frame__c Frame{get;set;}
    public SFFG_Standard_Foundry_Frame__c oldFrame;
    public string specConfigTableId{get;set;}
    public string configType{get;set;}
    public string configOption{get;set;}
    public string revision{get;set;}
    public boolean isEdit{get;set;}
    private string returnUrl;
    public Device__c device{get;set;}
    
    public List<Account_Team_Proxy__c> feList{get;set;}
    public List<Account_Team_Proxy__c> amList{get;set;}
    public List<Account_Team_Proxy__c> csrList{get;set;}
    public boolean showEdit{get;set;}
    
    public Map<string,List<SelectOption>> configTypeMap{get;set;}
    public Map<string,string> configSelectedMap{get;set;}
    
        
    
    private double ptg;
    
    private List<SFFG_Prime_Die__c> pdTempList;
    
    public boolean isGaurdingRequired{get;set;}
    public boolean isCrackStopRequired{get;set;}
    public boolean showLGConfigOptions{get;set;}
    public boolean readonlyMode{get;set;}
    
    
    public SFFG_CreatePrimeDieCtrl(){
        try{
          isGaurdingRequired=false;  
            isCrackStopRequired=false;
            showLGConfigOptions=true;
            readonlyMode=false;
            showEdit=true;
            pdWrapList=new List<primeDieWrapper>();
            deviceId=ApexPages.currentPage().getParameters().get('id');
            returnUrl=ApexPages.currentPage().getParameters().get('retURL');
            if(deviceId!=null || deviceId!=''){
                List<SFFG_Prime_Die__c> pdTempLst=new List<SFFG_Prime_Die__c>();
                 device=[select id,Fab__c,CRMDID__c,lastmodifieddate,MS_SFDC_Synch_Time__c,Current_Forecast_Tapeout_Date__c,Name,Account_Short_Name__c,Account__c,Geometry__c,Assigned_Process_ID__c,
                            Assigned_Process_ID__r.Main_Generation_Rule_Spec__c,reticle_Type__c,Generate_Standard_Frame__c,Stage__c,Tapeout_Type__c,Pre_PTRF_Validation_Status__c,Assigned_Process_ID__r.Generation_Rule_Spec__c,systemmodstamp 
                             from device__c where id=:deviceId limit 1];
                
                if(device.Assigned_Process_ID__c!=null){
                    if(device.Assigned_Process_ID__r.Generation_Rule_Spec__c!=null){
                        specConfigTableId=device.Assigned_Process_ID__r.Generation_Rule_Spec__c;
                    }else{
                        specConfigTableId=device.Assigned_Process_ID__r.Main_Generation_Rule_Spec__c;
                    }
                    
                    Process__c proc=[select Tech_Geometry__c,Tech_Type__c from Process__c where id=:device.Assigned_Process_ID__c];
                    string procGeo=proc.Tech_Geometry__c;
                    techType=proc.Tech_Type__c;
                    procGeo=procGeo.replace('UM','');
                    ptg=double.valueof(procGeo);
                    
                    if(( ptg>0.032 && ptg<=0.09 ) || ( techTypeSet.contains(techtype))){
                      isCrackStopRequired=true;  
                }
                //techType
                if((( ptg>0.090 )&& !techTypeSet.contains(techtype))){
                    
                    isGaurdingRequired=true;
                }
                    
                
                    if(specConfigTableId!=null ){
                        List<SFFG_LG_Configuration__c> lgConfigList=[Select Status__c, Spec_Config_Table_ID__c, Revision__c,
                                             Configuration_Type__c, Configuration_Option__c From SFFG_LG_Configuration__c  
                                             where Spec_Config_Table_ID__c=:specConfigTableId and Status__c='Active'];
                        if(lgConfigList!=null && lgConfigList.size()>0){
                            //select options
                            populatePickLists(lgConfigList);
                        }else{
                            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Lg configuration options not found'));
                            showLGConfigOptions=false;
                            //showEdit=false;GR-000045
                        }
                    }else{
                      showLGConfigOptions=false;
                    }
                    
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Process must be assigned to device before frame generation'));
                    showEdit=false;
                    isEdit=false;
                    showLGConfigOptions=false;
                }
                
                
                List<SFFG_Standard_Foundry_Frame__c> FrameList=[SELECT Backgrind_Thickness__c,CreatedById,CreatedDate,SWIFT_Action__c,Device__c,Fab__c,
                                                                    Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,SWIFT_Response__c,
                                                                    SFFG_Frame_Status__c,LG_Configuration__c,SWIFT_Error__c,SWIFT_Status__c,
                                                                    SystemModstamp,SWIFT_PTRF_ID__c ,ischanged__c ,isNotified__c 
                                                                      FROM SFFG_Standard_Foundry_Frame__c 
                                                                     where  device__c=:deviceId limit 1];
                
                if(FrameList!=null && FrameList.size()>0){
                  isEdit=false;
                    Frame=FrameList.get(0);
                    Frame.Fab__c=device.Fab__c;
                    if(Frame.Fab__c=='FAB 1' || Frame.Fab__c=='FAB 7' || Frame.Fab__c=='FAB 8')Frame.Backgrind_Thickness__c='None';
                    oldFrame=Frame.clone(true,true,true,true);
                    
                    try{
                      if(Frame.LG_Configuration__c!=null){
                          List<string> lgConfigList=Frame.LG_Configuration__c.split(';');
                          for(string s:lgConfigList){
                              if(s!=null && s!='')configSelectedMap.put(s.substringbefore(':'),s.substringafter(':'));
                          }
                      }
                    }catch(Exception ex){
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getmessage()+'LG Config data error'));
                    }
                    
                    resetPrimeDieWrapper();
                }
                else{
                    isEdit=true;
                    Frame=new SFFG_Standard_Foundry_Frame__c(device__c=deviceId,Fab__c=device.Fab__c);
                    if(Frame.Fab__c=='FAB 1' || Frame.Fab__c=='FAB 7' || Frame.Fab__c=='FAB 8')Frame.Backgrind_Thickness__c='None';
                    Frame.SFFG_Frame_Status__c='Draft';
                    oldFrame=Frame.clone(true,true,true,true);
                    pdWrapList = new List<primeDieWrapper>();
                    addNewRow();
                }
                retreiveCustomerInformation();
                
                if(device.Stage__c!='Design In'){
                  showEdit=false;
                  isEdit=false;
                  readonlyMode=true;
                  if(frame.id==null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Frame cannot be generated at this stage of device'));
                  }
                }
            }
        }catch(Exception E){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getmessage()));
            isEdit=false;
        }
    }
    
    public void resetPrimeDieWrapper(){
      pdTempList=[Select SystemModstamp, Standard_Foundry_Frame__c,   Size_X_um__c,Size_Y_um__c,
                    Foundry_to_Add_CrackStop__c,Foundry_to_add_Guardring__c,Die_Anti_clock_wise_Rotation__c,
                    Name, Id, CreatedDate, CreatedById From SFFG_Prime_Die__c
                     where Standard_Foundry_Frame__c=:Frame.id];
        pdWrapList=new List<primeDieWrapper> ();           
        if(pdTempList!=null && pdTempList.size()>0){
            integer i=0;
            for(SFFG_Prime_Die__c pd:pdTempList){
                primeDieWrapper pdw=new primeDieWrapper();
                pdw.index=i;
                pdw.record=pd;
                pdWrapList.add(pdw);
                i++;    
            }
        }else{
            addNewRow();
        }
    }
    
    public PageReference SaveMultiplePrimeDieData() {
        try{
        deviceId=ApexPages.currentPage().getParameters().get('id');
        
        if(validatePrimeDie(pdWrapList)){
            
            if((validateChange() && Frame.SWIFT_PTRF_ID__c!=null)||Frame.SWIFT_Status__c=='Error'){
				Frame.SWIFT_PTRF_ID__c=null;
				Frame.SWIFT_Status__c='New';
				Frame.isChanged__c=true;
            }
            string configString='';
            if(configSelectedMap!=null && !configSelectedMap.isEmpty()){
                for(string s:configSelectedMap.keyset()){
                  configString+=s+':'+configSelectedMap.get(s)+';';
                }
                Frame.LG_Configuration__c=configString.substringbeforelast(';');
            }
            Frame.Revision__c=revision;
            Frame.Spec_Config_Table_ID__c=specConfigTableId;
            
            if(Frame.Backgrind_Thickness__c==null)Frame.Backgrind_Thickness__c='None';
            Frame.Operation_Type__c='create';
            Frame.CRM_Device_ID__c=device.CRMDID__c;
            Frame.CRM_DID_Modified_Timestamp__c=string.valueof(device.MS_SFDC_Synch_Time__c);
            Frame.Customer_Short_Name__c=device.Account_Short_Name__c;
            Frame.Requester_Username__c=userinfo.getUserName();
            if(Frame.id!=null){
                update Frame;
            }else{
              List<SFFG_Standard_Foundry_Frame__c> FrameList=[SELECT id 
                                                                      FROM SFFG_Standard_Foundry_Frame__c 
                                                                     where  device__c=:deviceId limit 1];
              Frame.SWIFT_Status__c='New';
                Frame.SFFG_Frame_Status__c='In Progress';
                if(FrameList!=null && FrameList.isempty())insert Frame;
                else {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Frame has been already saved. Please reopen'));
                  return null;
                }
            }
            SFFGMultiplePrimeDieHelperCtrl.save(pdWrapList,Frame.Id);
            isEdit=false;
        }
        }catch(Exception E){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getmessage()));
        }
        return null;
        
        
    }
    
    public pagereference saveAndFinalize(){
        try{
          if(validateFinalize() ){
            Frame.SFFG_Frame_Status__c='Finalize';
            Frame.SWIFT_Status__c='Send';
            Frame.SWIFT_Response__c='';
              SaveMultiplePrimeDieData();
              SFFGTriggerPTRFCtrl.createPTRF(Frame.id,Userinfo.getsessionId());
          }
        }catch(Exception E){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getmessage()));
        }
        return null;
    }
    
    public pagereference Finalize(){
        try{
          if(validateFinalize() ){
            Frame.SWIFT_Status__c='Send';
            Frame.SFFG_Frame_Status__c='Finalize';
            Frame.SWIFT_Response__c='';
            update Frame;
              SFFGTriggerPTRFCtrl.createPTRF(Frame.id,Userinfo.getsessionId());
          }
        }catch(Exception E){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getmessage()));
        }
        return null;
    }
    
    
    set<string> tapeOutStatusSet=new set<string>{SFFG_Constants.TAPEOUT_READ_INCOMPLETE1,
              SFFG_Constants.TAPEOUT_READ_INCOMPLETE,SFFG_Constants.TAPEOUT_READ_COMPLETE};
    public boolean validateFinalize(){
      
      if(validatePrimeDie(pdWrapList)){
        
        boolean iserror=false;
      string isServiceActive=(Environment_Variable__c.getInstance('IS_SFFG_SERVICE_ACTIVE')!=null)?Environment_Variable__c.getInstance('IS_SFFG_SERVICE_ACTIVE').Value__c:'';
      if(!isServiceActive.equalsignorecase('TRUE')){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Integration/Swift service is down'));
        iserror=true;  
      }
      
      if(!(device.reticle_Type__c!=null && device.reticle_Type__c.contains('SLR'))){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Device Reticle Type should be SLR'));
        iserror=true;
      }
      if(!(device.Tapeout_Type__c!=null && device.Tapeout_Type__c=='Single Product')){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Device Tapeout Type should be \'single product\''));
        iserror=true;
      }
      
      if(!(device.Stage__c!=null && device.Stage__c=='Design In')){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Device stage should be \'Design In\''));
        iserror=true;
      }
      
      if((device.Generate_Standard_Frame__c!=null && device.Generate_Standard_Frame__c!='Yes')){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Device Generate Standard Frame should be \'Yes\''));
        iserror=true;
      }
      //Pre_PTRF_Validation_Status__c,Generate_Standard_Frame__c,Stage__c,Tapeout_Type__c,reticle_Type__c
      
      if(device.Pre_PTRF_Validation_Status__c.equalsIgnoreCase(SFFG_Constants.TAPEOUT_READ_NOT_PRE_PTRF)){
        iserror=true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Tapeout readiness validation status should be "'+
                  SFFG_Constants.TAPEOUT_READ_INCOMPLETE1+ '" or "'+
                  SFFG_Constants.TAPEOUT_READ_INCOMPLETE+'" or "'+
                  SFFG_Constants.TAPEOUT_READ_COMPLETE+'"'));
        
      }
      
      if(!isError){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Frame submitted to SWIFT for PTRF creation'));
        return true;
      }
      }
    return false;
    }
    
    public boolean validatePrimeDie(List<primeDieWrapper> pdList){
        
        set<string> pdNameSet=new set<string>();
        
        for(primeDieWrapper pdw:pdList){
            pdw.record.Standard_Foundry_Frame__c=Frame.id;
            pdNameSet.add(pdw.record.Name.toUpperCase());
        }
        
        //check for name uniqueness
        if(pdNameSet.size()!=pdList.size()){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Duplicate Prime Die name\'s found'));
          return false;
        }
        
        //LGConfig validation
        Boolean isLGError=false;
        if(configSelectedMap!=null && !configSelectedMap.isEmpty()){
                for(string s:configSelectedMap.keyset()){
                    if(String.isNotBlank(configSelectedMap.get(s))&& configSelectedMap.get(s)=='None'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please select LG config options for Configuration Type '+s));
            isLGError=true;
                    }
                }
            }
        
        if(isLGError)return false;
        
        for(primeDieWrapper pdw:pdList){
            
            // First, instantiate a new Pattern object "MyPattern"
            Boolean isError=false;
            Pattern MyPattern = Pattern.compile('^[a-zA-Z0-9_]*$');
            Matcher MyMatcher = MyPattern.matcher(pdw.record.name);
            if(!MyMatcher.matches() || pdw.record.name.equalsignorecase('prime')||pdw.record.name.equalsignorecase('frame')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Prime Die Name can only be alphanumeric (0-9, A-Z and a-z) and “_”.\n Prime Die Name cannot be “Frame” or “Prime”.\n Prime Die Name cannot exceed more than 50 characters'));
                isError=true;
            }
            
            if(!((pdw.record.Size_X_um__c > 0 && pdw.record.Size_X_um__c <=999999.998)&&(pdw.record.Size_Y_um__c > 0 && pdw.record.Size_Y_um__c <=999999.998))){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'PrimeDie size should be in the range of 0 to 999999.998'));
                isError=true;
            }
            //Foundry_to_Add_CrackStop__c,Foundry_to_add_Guardring__c
            if(pdw.record.Foundry_to_Add_CrackStop__c== null &&(( ptg>0.032 && ptg<=0.09 )|| techTypeSet.contains(techtype))){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please select Foundry to add crackstop'));
                isError=true;
            }
            //techType
            if(pdw.record.Foundry_to_add_Guardring__c== null &&(( ptg>0.090 )&& !techTypeSet.contains(techtype))){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please select Foundry to add gaurding'));
                isError=true;
            }
            if(isError)return false;
        }
        
        
        return true;
    }
    
    set<string> techTypeSet=new set<string>{'ANA_I','LOGIC_I','RF_I'};
    
    public PageReference edit() {
        isEdit=true;
        resetPrimeDieWrapper();
        return null;
    }
    
    
    
    public set<string> configTypesSet{get;set;}
    private string techType;
    public void populatePickLists(List<SFFG_LG_Configuration__c> lgConfigList) {
        
        configTypeMap=new Map<string,List<SelectOption>>();
        configTypesSet=new set<string>();
        configSelectedMap=new Map<string,string>();
        for(SFFG_LG_Configuration__c lcon:lgConfigList){
            if(!configTypesSet.contains(lcon.Configuration_Type__c)){
              revision=string.valueof(lcon.Revision__c);
                List<SelectOption> configurationOptions = new List<SelectOption>();
                configurationOptions.add(new SelectOption('None','None'));
                configurationOptions.add(new SelectOption(lcon.Configuration_Option__c,lcon.Configuration_Option__c));
                configTypeMap.put(lcon.Configuration_Type__c,configurationOptions);
                configTypesSet.add(lcon.Configuration_Type__c);
                configSelectedMap.put(lcon.Configuration_Type__c,'');
            }else{
                configTypeMap.get(lcon.Configuration_Type__c).add(new SelectOption(lcon.Configuration_Option__c,lcon.Configuration_Option__c));
            }
            
        }
    }
    
    
    public pagereference cancel(){
      resetPrimeDieWrapper();
      if(returnUrl!=null)return new PageReference(returnUrl);
      if(isEdit){
        isEdit=false;
      }
        else{
          return new PageReference('/'+deviceId);
        }
      return null;
    }
    
    //Method to get customer contacts information
    public void retreiveCustomerInformation(){
        String accountId = '';
        accountId = device.Account__c;
        List<Account_Team_Proxy__c> proxyList = new List<Account_Team_Proxy__c>();
        feList = new List<Account_Team_Proxy__c>();
        amList = new List<Account_Team_Proxy__c>();
        csrList = new List<Account_Team_Proxy__c>();
        
        if(accountId != ''){
        proxyList = [select User__c, User__r.Name, User_Email__c, Team_Role__c, Is_FAE__c from Account_Team_Proxy__c 
          where Account__c =: accountId and Team_Role__c IN 
          (:SFFG_Constants.ACCT_TM_PRXY_TM_RL_PAM, :SFFG_Constants.ACCT_TM_PRXY_TM_RL_AM,
          :SFFG_Constants.ACCT_TM_PRXY_TM_RL_BCSR,:SFFG_Constants.ACCT_TM_PRXY_TM_RL_CSR,
          :SFFG_Constants.ACCT_TM_PRXY_TM_RL_PCSR,:SFFG_Constants.ACCT_TM_PRXY_TM_RL_FAE,
          :SFFG_Constants.ACCT_TM_PRXY_TM_RL_PFTS) 
          order by Team_Role__c desc];
            if(!proxyList.isEmpty()){
                for(Account_Team_Proxy__c p: proxyList){
                    if(p.Team_Role__c == SFFG_Constants.ACCT_TM_PRXY_TM_RL_PAM || p.Team_Role__c == SFFG_Constants.ACCT_TM_PRXY_TM_RL_AM){
                        amList.add(p);
                    }
                    if(p.Team_Role__c == SFFG_Constants.ACCT_TM_PRXY_TM_RL_BCSR || p.Team_Role__c == SFFG_Constants.ACCT_TM_PRXY_TM_RL_CSR|| p.Team_Role__c == SFFG_Constants.ACCT_TM_PRXY_TM_RL_PCSR){
                        csrList.add(p);
                    }
                    if( p.Team_Role__c == SFFG_Constants.ACCT_TM_PRXY_TM_RL_FAE || 
                        p.Team_Role__c == SFFG_Constants.ACCT_TM_PRXY_TM_RL_PFTS ||
                        (p.Team_Role__c == SFFG_Constants.ACCT_TM_PRXY_TM_RL_PAM && p.Is_FAE__c == TRUE) ||
                        (p.Team_Role__c == SFFG_Constants.ACCT_TM_PRXY_TM_RL_AM  && p.Is_FAE__c == TRUE)){
                        feList.add(p);
                    }
                }
            }
        }
            
    }
    
    public List<primeDieWrapper> pdWrapList {get;set;}
    public Integer rowToRemove {get;set;}
    
    
    public void removeRow(){
        pdWrapList = SFFGMultiplePrimeDieHelperCtrl.removeRow(rowToRemove, pdWrapList);
    }
    
    public void addNewRow(){
      if(pdWrapList!=null && pdWrapList.size()>=200){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Only 200 Prime die\'s can be added to each frame.'));
      }else{
        pdWrapList = SFFGMultiplePrimeDieHelperCtrl.addNewRow(pdWrapList);
      }
        
    }
    
    public class primeDieWrapper{
        public Integer index {get;set;}
        public SFFG_Prime_Die__c record {get;set;}
    }
    
    public boolean validateChange(){
      if(Frame.id!=null ){
        if(!validateFrameChange(oldFrame,Frame)){
          return true;
        }
        
        Map<id,SFFG_Prime_Die__c> pdOldMap=new Map<id,SFFG_Prime_Die__c>([Select SystemModstamp, Standard_Foundry_Frame__c,   Size_X_um__c,Size_Y_um__c,
                                                              Foundry_to_Add_CrackStop__c,Foundry_to_add_Guardring__c,Die_Anti_clock_wise_Rotation__c,
                                                              Name, Id, CreatedDate, CreatedById From SFFG_Prime_Die__c
                                                               where Standard_Foundry_Frame__c=:Frame.id]);
        
        
        if(pdWrapList.size()!=pdOldMap.keyset().size()){
          return true;
        }
        for(primeDieWrapper primeDie : pdWrapList ){
                SFFG_Prime_Die__c pdTemp = primeDie.record;
                if(pdTemp.id!=null && !validatePrimeDieChange(pdOldMap.get(pdTemp.id),pdTemp)){
                  return true;
                }
          }
      }
      return false;
    }
    
    public boolean validateFrameChange(SFFG_Standard_Foundry_Frame__c oldFrame,SFFG_Standard_Foundry_Frame__c newFrame){
      //isChanged__c
      if(oldFrame.LG_Configuration__c!=null && !oldFrame.LG_Configuration__c.equalsignorecase(newFrame.LG_Configuration__c))return false;
      if(oldFrame.Backgrind_Thickness__c != newFrame.Backgrind_Thickness__c)return false;
      return true;
    }
    
    public boolean validatePrimeDieChange(SFFG_Prime_Die__c oldPD,SFFG_Prime_Die__c newPD){
      //isChanged__c
      if(oldPD.Die_Anti_clock_wise_Rotation__c != newPD.Die_Anti_clock_wise_Rotation__c)return false;
      if(oldPD.Foundry_to_Add_CrackStop__c != newPD.Foundry_to_Add_CrackStop__c)return false;
      if(oldPD.Foundry_to_add_Guardring__c != newPD.Foundry_to_add_Guardring__c)return false;
      if(oldPD.Size_X_um__c != newPD.Size_X_um__c)return false;
      if(oldPD.Size_Y_um__c != newPD.Size_Y_um__c)return false;
      if(oldPD.Name != newPD.Name)return false;
      return true;
    }
}