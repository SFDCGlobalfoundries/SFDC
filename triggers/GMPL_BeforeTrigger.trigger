/*
    Author: Anirban Roy        
    Description: Trigger on GMPL/BX009 object for all before operations.
    History: 
      ARoy  03202014    - Code Creation
      ARoy  05292014    - modified code to update BX009 Status as 'BCCB Approved' when BCCB Disposition = 'Approved to BX009'
*/

trigger GMPL_BeforeTrigger on GMPL_BX009__c (before delete, before insert, before update) {
        
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
        
        for(GMPL_BX009__c gmpl : trigger.new){
            
            // Constructing the Project field from Geometry, Family, Variant and Option.
            //********************************************************************************//
            if(gmpl.Project__c == null){                
                
                String tempProject = '';
                
                if(gmpl.Geometry__c != null){
                    tempProject = gmpl.Geometry__c + '-';
                }
                
                if(gmpl.Family__c != null){
                    if(tempProject != ''){
                        tempProject += gmpl.Family__c + '-';
                    }else{
                        tempProject = gmpl.Family__c + '-';
                    }
                }
                
                if(gmpl.Variant__c != null){
                    if(tempProject != ''){
                        tempProject += gmpl.Variant__c + '-';
                    }else{
                        tempProject = gmpl.Variant__c + '-';
                    }
                }
                
                if(gmpl.Option__c != null){
                    if(tempProject != ''){
                        tempProject += gmpl.Option__c;
                    }else{
                        tempProject = gmpl.Option__c;
                    }
                }
                
                if(tempProject != ''){
                    tempProject = tempProject.removeEnd('-');
                    gmpl.Project__c = tempProject;  
                }
                                                                
            }
            //***********************************************************************************//
            
            // Constructing the Program Name from Project and Fab
            //***********************************************************************************//
            if(gmpl.Program_Name__c == null){
                String tempProgramName = '';
                if(gmpl.Project__c != null){
                    tempProgramName = gmpl.Project__c + '-';        
                }
                if(gmpl.Fab__c != null){
                    tempProgramName += gmpl.Fab__c;
                }
                
                if(tempProgramName != ''){
                    tempProgramName = tempProgramName.removeEnd('-');
                    gmpl.Program_Name__c = tempProgramName; 
                }   
            }                       
            //***********************************************************************************//
            
            // Populating the Region Head and Region Head Backup from Account on insert/update
            //**********************************************************************************//
            if(gmpl.Account__c != null){
                gmpl.Region_Head__c = gmpl.Region_Head_ID__c;
                gmpl.Region_Head_Backup__c = gmpl.Region_Head_Backup_ID__c;
            }else if(gmpl.Account__c == null){
                gmpl.Region_Head__c = null;
                gmpl.Region_Head_Backup__c = null;
            }
            //**********************************************************************************//
            
                        
        }
        
        // Calling the GMPL_BeforeTriggerHandler helper class to refresh lifetime revenue
        //**************************************************************************************//
        if(!GMPL_BeforeTriggerHandler.hasRun){
            GMPL_BeforeTriggerHandler.refreshLifetimeRevenue(trigger.new);
        }   
        //**************************************************************************************//
        
    }   
    
    
    if(trigger.isBefore && trigger.isUpdate){
        //Set<Id> gmplStatusCheckSet = new Set<Id>();
        for(GMPL_BX009__c gmplBx009: trigger.new){
        
            // Auto-Update the BX009 status to ‘Project Kick Off’ when PA Code and Process ID are present
            //**********************************************************************************//           
            if(gmplBx009.Project_Code__c != null && gmplBx009.New_Process_ID__c != null 
                && (gmplBx009.Project_Code__c != trigger.oldMap.get(gmplBx009.Id).Project_Code__c || 
                gmplBx009.New_Process_ID__c != trigger.oldMap.get(gmplBx009.Id).New_Process_ID__c)
                && gmplBx009.BX009_Status__c == trigger.oldMap.get(gmplBx009.Id).BX009_Status__c){
                gmplBx009.BX009_Status__c = EnvironmentVariable.get('GMPL_BX009_STATUS_PROJ_KICK_OFF');
                //gmplStatusCheckSet.add(gmplBx009.Id);
            }
            //**********************************************************************************//
            
            // Update BX009 status to ‘Completed’ when CE Admin Complete checkbox is checked
            //*******************************************************************************//
            if(gmplBx009.CE_Admin_Complete__c != trigger.oldMap.get(gmplBx009.Id).CE_Admin_Complete__c 
                && gmplBx009.CE_Admin_Complete__c
                && (gmplBx009.BX009_Status__c == trigger.oldMap.get(gmplBx009.Id).BX009_Status__c
                || gmplBx009.BX009_Status__c == EnvironmentVariable.get('GMPL_BX009_STATUS_PROJ_KICK_OFF'))){
                gmplBx009.BX009_Status__c = EnvironmentVariable.get('BX009_STATUS_COMPLETE');
            }
            //*******************************************************************************//
            
            //Update BX009 Status as 'BCCB Approved' when BCCB Disposition = 'Approved to BX009'
            //*******************************************************************************//
            if(gmplBx009.BCCB_Disposition__c != trigger.oldMap.get(gmplBx009.Id).BCCB_Disposition__c 
                && gmplBx009.BCCB_Disposition__c == EnvironmentVariable.get('BX009_G0_DISP_APPROVED_STATUS')){
                gmplBx009.BX009_Status__c = EnvironmentVariable.get('BX009_STATUS_G0_APPROVED');                    
            }
            //*******************************************************************************//
        }
        /*for(GMPL_BX009__c gmplBx009: trigger.new){
            if(gmplBx009.BX009_Status__c != trigger.oldMap.get(gmplBx009.Id).BX009_Status__c 
                    && gmplBx009.BX009_Status__c == EnvironmentVariable.get('GMPL_BX009_STATUS_PROJ_KICK_OFF') 
                    && !gmplStatusCheckSet.contains(gmplBx009.Id)){
                gmplBx009.addError(Error_Codes__c.getInstance('GMPL_BX009_STATUS_PROJ_KICK_OFF_VLDTN').Message__c);
            }
        }*/
    }
    //**********************************************************************************//
    
    
    // Update BX009 status to ‘Completed’ when CE Admin Complete checkbox is checked 
    // and make default BX009 Status as 'PC0 Approved' when G0 Disposition Status = 'Approved to BX009'
    //**********************************************************************************//
    /*if(trigger.isBefore && trigger.isUpdate){
        for(GMPL_BX009__c gmplBx009: trigger.new){
            if(gmplBx009.CE_Admin_Complete__c != trigger.oldMap.get(gmplBx009.Id).CE_Admin_Complete__c 
                && gmplBx009.CE_Admin_Complete__c
                && (gmplBx009.BX009_Status__c == trigger.oldMap.get(gmplBx009.Id).BX009_Status__c
                || gmplBx009.BX009_Status__c == EnvironmentVariable.get('GMPL_BX009_STATUS_PROJ_KICK_OFF'))){
                gmplBx009.BX009_Status__c = EnvironmentVariable.get('BX009_STATUS_COMPLETE');
            }
            if(gmplBx009.G0_Disposition__c != trigger.oldMap.get(gmplBx009.Id).G0_Disposition__c 
                && gmplBx009.G0_Disposition__c == EnvironmentVariable.get('BX009_G0_DISP_APPROVED_STATUS')){
                gmplBx009.BX009_Status__c = EnvironmentVariable.get('BX009_STATUS_G0_APPROVED');                    
            }
        }
    }*/
    //**********************************************************************************//
    
    // Validation of BX009 Status with respect to PL/PM/AM/CE Admin/PPM Team users
    //**********************************************************************************//
    if(trigger.isBefore && trigger.isUpdate){
        
        String sysAdmin = EnvironmentVariable.get('SYS_ADMIN');
        String ctsDev = EnvironmentVariable.get('CTS_DEVELOPER');
        String gfDev = EnvironmentVariable.get('GF_DEVELOPER');
        String gfSysAdmin = EnvironmentVariable.get('GF_SYSTEM_ADMIN');
        String gfGlbAdmin = EnvironmentVariable.get('GF_GLOBAL_ADMIN');
        String gfInt = EnvironmentVariable.get('GF_INTEGRATION');
        String ceAdminGrp = EnvironmentVariable.get('CE_ADMIN_GROUP');
        String bx009StatusComplete = EnvironmentVariable.get('BX009_STATUS_COMPLETE');               
        String ppmTeamGrp = EnvironmentVariable.get('PPM_TEAM_GROUP');
        String gfProdMrktg = EnvironmentVariable.get('GF_PROD_MARKETING');
        
        /*List<String> gmplIds = new List<String>();
        List<GMPL_BX009__c> gmplBX009Objs = new List<GMPL_BX009__c>();
        Set<String> ppeRoleAllowed = new Set<String>{EnvironmentVariable.get('PPE_TEAM_ROLE_PLBX009'),EnvironmentVariable.get('PPE_TEAM_ROLE_PMBX009'),EnvironmentVariable.get('PPE_TEAM_ROLE_AMBX009')};        
        Boolean havePermission = false;*/
        
        List<String> gmplStatusCompIds = new List<String>();
        List<GMPL_BX009__c> gmplBX009CompObjs = new List<GMPL_BX009__c>();
        
        for(GMPL_BX009__c gmplBx009: trigger.new){
            /*if(gmplBx009.BX009_Status__c != null && gmplBx009.BX009_Status__c != bx009StatusComplete 
                && gmplBx009.BX009_Status__c != EnvironmentVariable.get('GMPL_BX009_STATUS_PROJ_KICK_OFF')
                && gmplBx009.Region_Head__c != UserInfo.getUserId()
                && gmplBx009.Region_Head_Backup__c != UserInfo.getUserId()
                && gmplBx009.BX009_Status__c != trigger.oldMap.get(gmplBx009.Id).BX009_Status__c){
                gmplIds.add(gmplBx009.Id);
                gmplBX009Objs.add(gmplBx009);
            }else*/ 
            if(gmplBx009.BX009_Status__c != null && gmplBx009.BX009_Status__c == bx009StatusComplete 
                    && gmplBx009.BX009_Status__c != trigger.oldMap.get(gmplBx009.Id).BX009_Status__c){
                gmplStatusCompIds.add(gmplBx009.Id);
                gmplBX009CompObjs.add(gmplBx009);
            }
        }
                
        /*if(gmplIds.size()>0 || gmplStatusCompIds.size()>0){
            // Query and check for the current user profile among System Admins 
            Profile prof = [select    Id
                                      ,Name 
                            from      Profile
                            where     Id = :UserInfo.getProfileId()
                           ];                                   
        
            if(!(prof.Name == sysAdmin || prof.Name == ctsDev || prof.Name == gfDev
                || prof.Name == gfSysAdmin || prof.Name == gfGlbAdmin || prof.Name == gfInt)){
                
                List<GroupMember> gmList;
                List<GroupMember> gmStatusCompList;
                
                // Check if the current user exists in the PPM/CE Admin Group for BX009 Status Update other than 'Completed'
                if(gmplIds.size()>0){
                    gmList = PPETeamHelper.getUserInGroup(UserInfo.getUserId(),new List<String>{ppmTeamGrp,ceAdminGrp,'Marketing_VP_Team'});
                }
                
                // Check if the current user exists in the CE Admin Group for BX009 Status Update to 'Completed'
                if(gmplStatusCompIds.size()>0){
                    gmStatusCompList = PPETeamHelper.getUserInGroup(UserInfo.getUserId(),new List<String>{ceAdminGrp});
                }        
                
                if(gmList==null || gmList.size()==0){               
                   
                   // Check for the User in the PPE Team for PM/PL/AM                  
                   Set<Id> gmplSet = new Set<Id>();
                   for(PPE_Team__c pt : PPETeamHelper.getUserInPPETeam(UserInfo.getUserId(),gmplIds)){
                        if(ppeRoleAllowed.contains(pt.PPE_Role__c)){
                            gmplSet.add(pt.GMPL_BX009__c);
                        }   
                   }
                   
                   
                   
                   // Validation error message for BX009 Status other than 'Completed'
                   for(GMPL_BX009__c gb : gmplBX009Objs){
                        if(!gmplSet.contains(gb.Id)){
                            gb.addError(Error_Codes__c.getInstance('GMPL_BX009_STATUS_VALIDATION').Message__c);
                        }   
                   }
                }*/
        if(gmplStatusCompIds.size()>0){
            Profile prof = [select    Id
                                      ,Name 
                            from      Profile
                            where     Id = :UserInfo.getProfileId()
                           ];                                   
        
            if(!(prof.Name == sysAdmin || prof.Name == ctsDev || prof.Name == gfDev
                || prof.Name == gfSysAdmin || prof.Name == gfGlbAdmin || prof.Name == gfInt || prof.Name == gfProdMrktg)){
                
                // Check if the current user exists in the CE Admin Group for BX009 Status Update to 'Completed'
                List<GroupMember> gmStatusCompList = PPETeamHelper.getUserInGroup(UserInfo.getUserId(),new List<String>{ppmTeamGrp,ceAdminGrp});
                
                // Validation error message for BX009 'Completed' Status
                if(gmStatusCompList==null || gmStatusCompList.size()==0){
                    for(GMPL_BX009__c gb : gmplBX009CompObjs){
                        gb.addError(Error_Codes__c.getInstance('GMPL_BX009_STATUS_COMPLETE_VALIDATION').Message__c);
                   }
                }               
            }
        }      
                
    }
    //**********************************************************************************//
    
}