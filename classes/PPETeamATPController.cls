/*
    Author: Anirban Roy
    Description: This is the controller class for PPE Team to fetch and add data from Account Team Proxy.  
    History:
        ARoy        03192014    - code creation.
*/

public class PPETeamATPController {
    
    public String accId{get;set;}
    public PPE_Team__c pT{get;set;}
    public String gmplBX009Id {get;set;}
    public List<AccountTeamProxyWrapper> atpWrapperList{get; set;}
    public Boolean showSaveButton {get;set;}
      
    /*public String sysAdmin = EnvironmentVariable.get('SYS_ADMIN');
    public String ctsDev = EnvironmentVariable.get('CTS_DEVELOPER');
    public String gfDev = EnvironmentVariable.get('GF_DEVELOPER');
    public String gfSysAdmin = EnvironmentVariable.get('GF_SYSTEM_ADMIN');
    public String gfGlbAdmin = EnvironmentVariable.get('GF_GLOBAL_ADMIN');
    public String gfInt = EnvironmentVariable.get('GF Integration');*/ 
    
    public static String ppeTeamDefaultPerm = EnvironmentVariable.get('PPE_TEAM_DEFAULT_PERM');
    public static String ppeTeamRwPerm = EnvironmentVariable.get('PPE_TEAM_RW_PERM');
    public static String ppeTeamReadPerm = EnvironmentVariable.get('PPE_TEAM_READ_PERM');
    public static String ppeRoleTurnkeyBX009 = EnvironmentVariable.get('PPE_TEAM_ROLE_TKBX009');
    public static String ppeRoleSQEBX009 = EnvironmentVariable.get('PPE_TEAM_ROLE_SQEBX009');
    public static String ppeRoles = EnvironmentVariable.get('PPE_ROLES_LIST');
    public static String accErrorMsg = Error_Codes__c.getInstance('PPE_NO_ATP_SELECT_MSG').Message__c;
    public static String ppeTmRoleErrorMsg = Error_Codes__c.getInstance('PPE_TM_ROLE_ERR_MSG').Message__c; 
    public static String ppeTmAccLvlErrMsg = Error_Codes__c.getInstance('PPE_TM_ACC_LVL_ERR_MSG').Message__c;      
    
    // Constructor
    public PPETeamATPController(){
        // Getting value from the query params
        accId = ApexPages.currentPage().getParameters().get('accId');
        gmplBX009Id = ApexPages.currentPage().getParameters().get('gmplbx009Id');
        
        atpWrapperList = new List<AccountTeamProxyWrapper>(); 
        showSaveButton = true;
        /*Boolean havePermission = false;
        if(gmplBX009Id!=null){
            
            List<GroupMember> gmList = PPETeamHelper.getUserInGroup(UserInfo.getUserId(),new List<String>{'PPM_Team_Group'});

            if(gmList!=null && gmList.size()>0){
                havePermission = true;
            }
            
            if(!havePermission){
                                            
                List<PPE_Team__c> pTList = PPETeamHelper.getUserInPPETeam(UserInfo.getUserId(),new List<String>{gmplBX009Id});
                
                if(pTList!=null && pTList.size()>0){
                    havePermission = true;
                }
            }
            
            if(!havePermission){
                Profile prof = [select    Id
                                  ,Name 
                        from      Profile
                        where     Id = :UserInfo.getProfileId()
                       ];
        
                if(prof.Name == sysAdmin || prof.Name == ctsDev || prof.Name == gfDev
                    || prof.Name == gfSysAdmin || prof.Name == gfGlbAdmin || prof.Name == gfInt){
                    havePermission = true;  
                }
            }                         
        }*/
        
        
        // Validation if account information is not present
        if(accId==null||accId==''){ // && havePermission
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('GMPL_ACCT_VALIDATION').Message__c));
            showSaveButton = false;
        }else if(accId!=null && accId!=''){ //  && havePermission         
            // Query from the account team proxy
            Map<String,AccountTeamProxyWrapper> atpWrapperUserMap = new Map<String,AccountTeamProxyWrapper>();
            List<String> profileIds = new List<Id>();
            
            for(Account_Team_Proxy__c atp : [select     Id 
                                                        , Name
                                                        , User__c
                                                        , User__r.Name
                                                        , User__r.Profile.Name
                                                        , Team_Role__c
                                             from       Account_Team_Proxy__c 
                                             where      Account__c = :accId
                                             and        User__r.IsActive = true]){
                atpWrapperList.add(new AccountTeamProxyWrapper(atp));
            }           
        }/*else if(!havePermission){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Error_Codes__c.getInstance('GMPL_USER_PPE_TEAM_VALIDATION').Message__c));
            showSaveButton = false; 
        }*/
    }
    
    // Access Level will show 'Read/Write' only for 'Turnkey BX009'/'SQE BX009' PPE Role. 
    public void changeAccessLevel(){    
        for(AccountTeamProxyWrapper atpwrapper : atpWrapperList){
            if(atpwrapper.ppeRoleSelected == ppeRoleTurnkeyBX009 || atpwrapper.ppeRoleSelected == ppeRoleSQEBX009){
                atpwrapper.accessLevelOption.clear();
                atpwrapper.accessLevelOption.add(new SelectOption(ppeTeamDefaultPerm,ppeTeamDefaultPerm));
                atpwrapper.accessLevelOption.add(new SelectOption(ppeTeamRwPerm,ppeTeamRwPerm));
            }else{
                atpwrapper.accessLevelOption.clear();
                atpwrapper.accessLevelOption.add(new SelectOption(ppeTeamDefaultPerm,ppeTeamDefaultPerm));
                atpwrapper.accessLevelOption.add(new SelectOption(ppeTeamRwPerm,ppeTeamRwPerm));
                atpwrapper.accessLevelOption.add(new SelectOption(ppeTeamReadPerm,ppeTeamReadPerm));
            }
        }       
    }
    
    // Save Functionality    
    public PageReference save(){                
        
        List<PPE_Team__c> ppeTeamList = new List<PPE_Team__c>();
        Boolean isSelectedCheck = false;
        Boolean isPPERoleBlank = false;
        Boolean isAccessLevelBlank = false;
        
        // Account Team Proxy records need to be selected and accordingly added to the PPE Team
        for(AccountTeamProxyWrapper atpwrapper : atpWrapperList){
            if(atpwrapper.selected == true){
                PPE_Team__c p = new PPE_Team__c();
                p.User__c = atpwrapper.atp.User__c;
                p.PPE_Role__c = atpwrapper.ppeRoleSelected;
                if(p.PPE_Role__c == ppeTeamDefaultPerm){
                    isPPERoleBlank = true;
                }
                p.Access_Level__c = atpwrapper.accessLevelSelected;
                if(p.Access_Level__c == ppeTeamDefaultPerm){
                    isAccessLevelBlank = true;
                }
                p.GMPL_BX009__c = gmplBX009Id;
                ppeTeamList.add(p);
                isSelectedCheck = true;
            }
        }
        
        if(ppeTeamList.size()>0){
            if(isPPERoleBlank || isAccessLevelBlank){
                if(isPPERoleBlank){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ppeTmRoleErrorMsg));   
                }               
                if(isAccessLevelBlank){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ppeTmAccLvlErrMsg));   
                }
                return null;
            }
            
            try{
                insert ppeTeamList;
            }catch(DMLException e){
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    // Process exception here
                    /*if(e.getDmlMessage(i).contains('INACTIVE_OWNER_OR_USER')){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Inactive user(s) cannot be added to the PPE Team.'));
                    }else{*/
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getDmlMessage(i)));
                    //} 
                }
                return null;
            }
        }
        
        // Error message if Account Team Proxy records is not selected
        if(!isSelectedCheck){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, accErrorMsg));
            return null;
        }
        
        PageReference pgr = new PageReference('/'+gmplBX009Id);
        pgr.setRedirect(true);
        return pgr;
        
    }
    
    // Cancel Functionality
    public PageReference cancel(){
        PageReference pgr = new PageReference('/'+gmplBX009Id);
        pgr.setRedirect(true);
        return pgr;
    }       
    
    // Wrapper class for Account Team Proxy records
    public class AccountTeamProxyWrapper
    {
        public Account_Team_Proxy__c atp{get; set;}
        public Boolean selected {get; set;}
        public List<SelectOption> ppeRoleOption {get;set;}
        public String ppeRoleSelected {get;set;}
        public List<SelectOption> accessLevelOption {get;set;}
        public String accessLevelSelected {get;set;}        
        public List<String> accessLevelList = new List<String>{ppeTeamDefaultPerm,ppeTeamRwPerm,ppeTeamReadPerm};
        
        public AccountTeamProxyWrapper(Account_Team_Proxy__c accTP)
        {
            atp = accTP;
            selected = false;
            ppeRoleOption = new List<SelectOption>{new SelectOption(ppeTeamDefaultPerm,ppeTeamDefaultPerm)};
            String[] ppeRoleArr = ppeRoles.split(',');
            for(String p : ppeRoleArr){
                ppeRoleOption.add(new SelectOption(p,p));
            }
            accessLevelOption = new List<SelectOption>();
            
            for(String accessLevel : accessLevelList){
                accessLevelOption.add(new SelectOption(accessLevel,accessLevel));
            }            
        }
    }
    
}