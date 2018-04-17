/*
    Author: Anirban Roy
    Description: This is the controller extension class for GMPL/BX009 for creation of GMPL/BX009.  
    History:
        ARoy        03252014    - code creation.
        ARoy        04302014    - add BX009 variant id in the create url.
        ZAmbat      09112014    - Updated code as per CASE 32029.
        ARoy        10292015    - add configurator plus id and name in GMPL record.
*/

public class GMPLBX009CreateController {
    
    private ApexPages.StandardController controller; 
    
    public GMPLBX009CreateController(ApexPages.StandardController controller){
        this.controller = controller;
    }
    
    
    public PageReference init(){
        
        String sysAdmin = EnvironmentVariable.get('SYS_ADMIN');
        String ctsDev = EnvironmentVariable.get('CTS_DEVELOPER');
        String gfDev = EnvironmentVariable.get('GF_DEVELOPER');
        String gfSysAdmin = EnvironmentVariable.get('GF_SYSTEM_ADMIN');
        String gfGlbAdmin = EnvironmentVariable.get('GF_GLOBAL_ADMIN');
        String gfInt = EnvironmentVariable.get('GF_INTEGRATION');
        String gfFAEFTS = EnvironmentVariable.get('GF_FAE_FTS');
        String gfCE = EnvironmentVariable.get('GF_CE');
        String gfPM = EnvironmentVariable.get('GF_PROD_MARKETING');
        String gfSalesUsr = EnvironmentVariable.get('GF_SALES_USER');
        String ppmTeamGrp = EnvironmentVariable.get('PPM_TEAM_GROUP');
        String ceAdminGrp = EnvironmentVariable.get('CE_ADMIN_GROUP');
        String bx009VariantId = EnvironmentVariable.get('BX009_VARIANT_ID');
        String bx009VariantIdNo = EnvironmentVariable.get('BX009_VARIANT_ID_NO');
        String acctLkp = EnvironmentVariable.get('LEAD_ACCT_GMPL_LKP_ID');
        String configLkp = EnvironmentVariable.get('CONFIG_PLUS_GMPL_LKP_ID');
        
        List<GroupMember> gmList = PPETeamHelper.getUserInGroup(UserInfo.getUserId(),new List<String>{ppmTeamGrp,ceAdminGrp});
        Boolean retErr = false;
        
        if(gmList==null||gmList.size()==0){
            
            Profile prof = [select    Id
                                  ,Name 
                        from      Profile
                        where     Id = :UserInfo.getProfileId()
                       ];
    
            if(!(prof.Name == sysAdmin || prof.Name == ctsDev || prof.Name == gfDev
                || prof.Name == gfSysAdmin || prof.Name == gfGlbAdmin || prof.Name == gfInt
                || prof.Name == gfSalesUsr || prof.Name == gfFAEFTS || prof.Name == gfCE || prof.Name == gfPM)){          
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Error_Codes__c.getInstance('GMPL_CREATE_VALIDATION').Message__c));           
                retErr = true;
            }
        }
        
        if(retErr){
            return null;
        }else{
            String retUrl = ApexPages.currentPage().getParameters().get('retURL');
            system.debug('retUrl***************'+retUrl);

            String tempConfigLkpStr = '';
                        
            //Added ARoy : 10292015 - add configurator plus id and name in GMPL
            String configLkpId = ApexPages.currentPage().getParameters().get(configLkp+'_lkid');
            String configLkpName = ApexPages.currentPage().getParameters().get(configLkp);
            
            
            if(configLkpId != null && configLkpId != ''){
                tempConfigLkpStr = '&'+configLkp+'_lkid='+configLkpId+'&'+configLkp+'='+configLkpName;
            }
            
            String pgurl = (configLkpName!=null)?('&'+tempConfigLkpStr):'';
                                   
            PageReference pr = new PageReference('/'+GMPL_BX009__c.sObjectType.getDescribe().getKeyPrefix()+'/e?retURL='+retUrl+'&nooverride=1'+pgurl);
            //***************************************************************//
            pr.setRedirect(true);
            return pr;
        }                
        
    }
    
    public PageReference cancel(){
        return controller.cancel();
    }
    
}