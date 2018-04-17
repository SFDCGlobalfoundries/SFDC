/*
    Author: 
    Description: This class is used for updating the Primary CSR field in account. 
    History:
        ASolito     04122013    - Fire Account Detail Changes to ERP.
        TLai        19032014    - Changed to futrue call
        TLai    11042014  - Changed to logic to populated 3 fields on Account
        Vijay    02032015  - added OnAfterInsert, OnAfterUpdate and OnAfterDelete methods to execute the business after each trigger event.
                    - whenever Account Team Proxy is created, updated and deleted the Internal Device will be shared accordingly.
*/


public class ClsAccountTeamProxyTriggerHandler {
    
    private Boolean isExecuting = false;
    private Integer size = 0;
    public static Boolean isExecuted = false;
    public static final String GLOBALFOUNDRIES_INTERNAL_ACCOUNT_RECTYPE = 'GLOBALFOUNDRIES_Internal';
  
  /**
  This method is used to populate primary csr,Account Admin in account and  Account Manager in contact.
  @method name: populatePrimaryCSR
  @parameter:   List of Account Team Proxy.
  @return :     none
  **/
    @future(callout = false)    
    public static void populatePrimaryCSR(set<id> sAcctId){
        //Tlai 11042014
        final String ACCT_TM_PRXY_TM_RL_PCSR =  Environment_Variable__c.getinstance('ACCT_TM_PRXY_TM_RL_PCSR').value__c;
        final String ACCT_TM_PRXY_TM_RL_PAM =  Environment_Variable__c.getinstance('ACCT_TM_PRXY_TM_RL_PAM').value__c;
        final String ACCT_TM_PRXY_TM_RL_AA =  Environment_Variable__c.getinstance('ACCT_TM_PRXY_TM_RL_AA').value__c;
        final String ACCT_TM_PRXY_TM_RL_PFAE =  Environment_Variable__c.getinstance('ACCT_TM_PRXY_TM_RL_PFAE').value__c;       
        
        Map<Id,Account> updateTotalAccounts = new Map<Id,Account>();   
        Set<Account> sAcct =new Set<Account>();
        list<Account_Team_Proxy__c> atpList = new list<Account_Team_Proxy__c>();
        string tmpId ;
        
        map<id, map<string,id>> mAcct2TeamRole = new map<id, map<string,id>>();
        /*---- fetching the accountId related to the Account team proxy member----*/ 
        for(Account_Team_Proxy__c atp : [select id, account__c,user__c, Team_Role__c,flag_for_delete__c,lastmodifieddate,
                                                account__r.Primary_CSR__c, account__r.Account_Manager__c, account__r.Account_Admin__c,account__r.id, account__r.Primary_FAE__c
                                                from Account_Team_Proxy__c 
                                                where account__c in : sAcctId 
                                                    and (Team_Role__c = :ACCT_TM_PRXY_TM_RL_PCSR or team_role__c = :ACCT_TM_PRXY_TM_RL_PAM or Team_Role__c = :ACCT_TM_PRXY_TM_RL_AA or Team_Role__c = :ACCT_TM_PRXY_TM_RL_PFAE)
                                                    and flag_for_delete__c = false
                                                order by account__c, lastmodifieddate desc ]){
            sAcct.add(atp.Account__r);
            system.debug('user__c :' + atp.user__c + ' ' + atp.team_role__c);           
            if(mAcct2TeamRole.containsKey(atp.account__c)){
                //Tlai 11042014  - used lastmodifed ATP's User for the specific role
                if(!mAcct2TeamRole.get(atp.account__c).containskey(atp.team_role__c))
                    mAcct2TeamRole.get(atp.account__c).put(atp.team_role__c,atp.User__c);
            }else {
                mAcct2TeamRole.put(atp.account__c, new map<string, id>{atp.team_role__c=>atp.user__c});
            }   
            
        }
        system.debug(logginglevel.error, 'mAcct2TeamRole: ' + mAcct2TeamRole);
        list<Account> fnlAcclist = new list<Account>();
       
        if(sAcct.size() > 0){
            for(Account acct : sAcct){
                if(mAcct2TeamRole.containskey(acct.id)){
                    map<string, id> mTeamRole = mAcct2TeamRole.get(acct.id);
                    id pcsrId = mTeamRole.get(ACCT_TM_PRXY_TM_RL_PCSR);
                    id pamId = mTeamRole.get(ACCT_TM_PRXY_TM_RL_PAM);
                    id aaId = mTeamRole.get(ACCT_TM_PRXY_TM_RL_AA);
                    id pfaeId = mTeamRole.get(ACCT_TM_PRXY_TM_RL_PFAE);                    
                    if(acct.Account_Admin__c != aaId || acct.Primary_CSR__c != pcsrId || acct.Account_Manager__c != pamId || acct.Primary_FAE__c != pfaeId ){
                        acct.Account_Admin__c = aaId;
                        acct.Primary_CSR__c = pcsrId;
                        acct.Account_Manager__c = pamId;
                        acct.Primary_FAE__c = pfaeId;                        
                        fnlAcclist.add(acct);
                    }
                }
            }
        }
        system.debug(logginglevel.error, 'fnlAcclist: ' + fnlAcclist);                                              
        if (fnlAcclist.size() > 0 ){
            update fnlAcclist;
        }             
    }
    
  /**
     * This is parametrized constructor
     *
     * @param   isExecuting     boolean variable to check trigger execution context
     * @param   size            size of list processing in trigger execution context
     */    
    public ClsAccountTeamProxyTriggerHandler(Boolean isExecuting, Integer size){
        this.isExecuting = isExecuting;
        this.size = size;
    }
    
     /**
     * This method accepts trigger context variables for on after insert event and call the actual business logic
     *
     * @param   oldATPs           list of old Account Team Proxy records
     * @param   updatedATPs       list of updated Account Team Proxy records
     * @param   oldATPMap     map of old Account Team Proxy records
     * @param   updatedATPMap map of updated Account Team Proxy records
     */ 
    public void OnAfterInsert(Account_Team_Proxy__c[] updatedATPs, Map<ID, Account_Team_Proxy__c>  updatedATPMap){
        List<Account_Team_Proxy__c> atpList = new List<Account_Team_Proxy__c>();
        List<Account_Team_Proxy__c> atpDPList = new List<Account_Team_Proxy__c>();
        for(Account_Team_Proxy__c atp:updatedATPs){
            if(atp.Account_RecType_DeveloperName__c == GLOBALFOUNDRIES_INTERNAL_ACCOUNT_RECTYPE){
                atpList.add(atp);
            }
            atpDPList.add(atp);
        }
        if(!atpList.isEmpty()){
            InternalDeviceSharingHandler internalDeviceSharingHandler = new InternalDeviceSharingHandler();
            internalDeviceSharingHandler.shareInternalDevice(atpList);
        }
        if(!atpDPList.isEmpty()){
            InternalDeviceSharingHandler internalDeviceSharingHandler = new InternalDeviceSharingHandler();
            internalDeviceSharingHandler.shareDesignPartnerDevice(atpDPList);
        }
    }
    
    /**
     * This method accepts trigger context variables for on after update event and call the actual business logic
     *
     * @param   oldATPs           list of old Account Team Proxy records
     * @param   updatedATPs       list of updated Account Team Proxy records
     * @param   oldATPMap     map of old Account Team Proxy records
     * @param   updatedATPMap map of updated Account Team Proxy records
     */ 
    public void OnAfterUpdate(Account_Team_Proxy__c[] oldATPs, Account_Team_Proxy__c[] updatedATPs, 
                              Map<ID, Account_Team_Proxy__c>  oldATPMap, Map<ID, Account_Team_Proxy__c>  updatedATPMap ){
        
        List<Account_Team_Proxy__c> atpList = new List<Account_Team_Proxy__c>();
        List<Account_Team_Proxy__c> atpDPList = new List<Account_Team_Proxy__c>();
        for(Account_Team_Proxy__c atp:updatedATPs){
            if(atp.Account_RecType_DeveloperName__c == GLOBALFOUNDRIES_INTERNAL_ACCOUNT_RECTYPE && !atp.Flag_for_Delete__c && 
                    atp.Account_Access__c != oldATPMap.get(atp.Id).Account_Access__c){
                atpList.add(atp);
            }
            if(!atp.Flag_for_Delete__c && atp.Account_Access__c != oldATPMap.get(atp.Id).Account_Access__c){
                atpDPList.add(atp);
            }
        }
        if(!atpList.isEmpty()){
            InternalDeviceSharingHandler internalDeviceSharingHandler = new InternalDeviceSharingHandler();
            internalDeviceSharingHandler.shareInternalDevice(atpList);
        }
        if(!atpDPList.isEmpty()){
            InternalDeviceSharingHandler internalDeviceSharingHandler = new InternalDeviceSharingHandler();
            internalDeviceSharingHandler.shareDesignPartnerDevice(atpDPList);
        }
    }
    
    /**
     * This method accepts trigger context variables for on after delete event and call the actual business logic
     *
     * @param   updatedATPs       list of updated Account Team Proxy records
     */ 
    public void OnAfterDelete(Account_Team_Proxy__c[] oldATPs){
        List<Account_Team_Proxy__c> atpList = new List<Account_Team_Proxy__c>();
        List<Account_Team_Proxy__c> atpDPList = new List<Account_Team_Proxy__c>();
        for(Account_Team_Proxy__c atp:oldATPs){
            if(atp.Account_RecType_DeveloperName__c == GLOBALFOUNDRIES_INTERNAL_ACCOUNT_RECTYPE){
                atpList.add(atp);
            }
            atpDPList.add(atp);
        }
        if(!atpList.isEmpty()){
            InternalDeviceSharingHandler internalDeviceSharingHandler = new InternalDeviceSharingHandler();
            internalDeviceSharingHandler.removeInternalDeviceAccess(oldATPs);
        }
        if(!atpDPList.isEmpty()){
            InternalDeviceSharingHandler internalDeviceSharingHandler = new InternalDeviceSharingHandler();
            internalDeviceSharingHandler.removeDesignPartnerDeviceAccess(atpDPList);
        }
    }
    
 }