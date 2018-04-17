/*
    Author: Abhita Bansal
    Description: This class is Used for following pages:
                    1) WaferAllocationHome - which is the Home Page for afer Allocation Where user can Select fab and year
                    2) WaferAllocationViewPage - Which view the record already saved
                    3) WaferAllocationNewEditFormPage - to Edit the Record to update the value 
    History:
    ABansal     11/11/2014 - code creation
    ABansal     23/11/2014 - Add the Code for the Search and Save Functionality
    ABansal     25/11/2014 - Add the code for Inline Editing
    ABansal     28/11/2014 - Update the Code on Edit Functionality for Inline Editing
    SNair       29/11/2014 - updated logic for search and save.
    SNair       01/12/2014 - updated logic for search and save.
    ABansal     08/12/2014 - update the Code for Fab 5JV
    ABansal     11/12/2014 - Change the Picklist values for F7 and TD Module
    ABansal     12/12/2014 - Change the Logic for the permission Set
    Abansal     15/12/2014 - Change the logic for error message for Module
    Abansal     09/02/2015 - Update the logic for Back Button
*/

public with sharing class WaferAllocationExtension {

    public Wafer_Allocation__c waferAllocation{get;set;}
    public List<Wafer_Allocation__c> waferAllocationList{get;set;}
    public boolean showProgramField{get;set;}
    public boolean showModuleField{get;set;}
    public boolean showResult{get; set;}
    public boolean showCreateButton{get;set;}
    public String recID{get;set;}
    public String currentURL{get;set;}
    public String SourcePage{get;set;}    
    public String waferAllocationId{get;set;}
    public pageReference pgRef{get;set;}
    public String query{get;set;}
    public boolean validate{get;set;}
    public String module{get;set;}
    public String program{get;set;}
    public User currentUser{get;set;}
    public Profile gfPlanningProfileId{get;set;}
    public Profile gfPlanningStandardProfileId{get;set;}
    public Profile systemAdminProfileId{get;set;}
    public boolean validUser{get;set;}
    public List<Id> userId;
    public boolean gpYes;
    private List<Wafer_Allocation__History> waferHistoryList = new List<Wafer_Allocation__History>();
    //List<Wafer_Allocation__c> wfList = new List<Wafer_Allocation__c>();

    public WaferAllocationExtension(ApexPages.StandardController controller) {
        showProgramField = false;
        showModuleField = false;
        showCreateButton = false;
        validUser = false;
        showResult = false;
        gpYes = false;
        String publicGroup = eWSRConstantsVariablesClass.FAB5JVPUBLICGP ;          
        Group grp = getPublicGp(publicGroup);
        userId = getUserIds(grp.Id);
        gfPlanningProfileId = [select Id from Profile where Name =: eWSRConstantsVariablesClass.GFPLANPROFILE];
        gfPlanningStandardProfileId = [select Id from Profile where Name =: eWSRConstantsVariablesClass.GFPLANSTDPROFILE];
        systemAdminProfileId = [select Id from Profile where Name =: eWSRConstantsVariablesClass.SYSADMINPROFILE];
        UtilClassToGetAllFields utilClass = new UtilClassToGetAllFields();
        String userFields = utilClass.getAllFields('User');
        String queryCurrentUser = 'select '+userFields+' from User where Id = \''+UserInfo.getUserId()+'\'';
        currentUser = Database.query(queryCurrentUser);
        for(Id users1 : userId ){
            if(currentUser.Id == users1){
               gpYes = true;
            }
        }
        currentURL = ApexPages.currentPage().getURL();
        SourcePage = ApexPages.currentPage().getParameters().get('ReturnURL');
        this.waferAllocation = (Wafer_Allocation__c)controller.getRecord();
        recID = this.waferAllocation.Id;
        if(recID!=null  && this.waferAllocation!=null){
            waferAllocation = [select Id, Name, Fab__c, Month__c, Year__c, Module1__c, Program1__c, Remaining_Quantity__c, Wafer_Quantity_Allocated__c from Wafer_Allocation__c where Id=:recID];
            displayProgramAndModuleField();
            module = waferAllocation.Module1__c;
            program = waferAllocation.Program1__c;
            showResult = true;
            Search();
            System.debug('Old Value:'+waferAllocation);
        }
        else{
            waferAllocation = new Wafer_Allocation__c();   
        }
        checkCurrentUser();
    }
    
    public static Group getPublicGp(String PName){
        Group gp = [Select Type, id From Group where Type=: eWSRConstantsVariablesClass.PUBLICGP And Name =:PName Limit 1];
        return gp;
    }
    
    public static List<Id> getUserIds(String gpId){
        List<Id> userList = new List<Id>();
        for(GroupMember groupMem : [Select UserOrGroupId From GroupMember where GroupId =:gpId]){
            userList.add(groupMem.UserOrGroupId);
        }
        return userList;
    }
      
    public List<SelectOption> getmoduleVal(){
        List<SelectOption> options = new List<SelectOption>();
            if(this.waferAllocation.Fab__c == eWSRConstantsVariablesClass.FAB7RECORDTYPE){
                options.add(new SelectOption('--None--','--None--'));
                options.add(new SelectOption('F7','F7'));
                options.add(new SelectOption('TD','TD'));
            }
            
            if(this.waferAllocation.Fab__c == eWSRConstantsVariablesClass.FAB3ERECORDTYPE){
                options.add(new SelectOption('--None--','--None--'));
                options.add(new SelectOption('CleanTech','CleanTech'));
                options.add(new SelectOption('CMP','CMP'));
                options.add(new SelectOption('CVD (Thin Film)','CVD (Thin Film)'));
                options.add(new SelectOption('Diffusion','Diffusion'));
                options.add(new SelectOption('Etest/Backgrind','Etest/Backgrind'));
                options.add(new SelectOption('Implant','Implant'));
                options.add(new SelectOption('Industrial Engineering','Industrial Engineering'));
                options.add(new SelectOption('Litho','Litho'));
                options.add(new SelectOption('Manufacturing','Manufacturing'));
                options.add(new SelectOption('MEMS','MEMS'));
                options.add(new SelectOption('Metal (Etch)','Metal (Etch)'));
                options.add(new SelectOption('Metrology','Metrology'));
                options.add(new SelectOption('Oxide (Etch)','Oxide (Etch)'));
                options.add(new SelectOption('Planning/Sales Admin','Planning/Sales Admin')); 
                options.add(new SelectOption('Process Integration','Process Integration'));
                options.add(new SelectOption('Production Control','Production Control'));
                options.add(new SelectOption('PVD (Thin Film)','PVD (Thin Film)'));
                options.add(new SelectOption('Turnkey','Turnkey'));
                options.add(new SelectOption('Yield Defect Density','Yield Defect Density'));
                options.add(new SelectOption('Yield Enhancement','Yield Enhancement'));
                
            }
            
        return options;
    } 
    
    public List<SelectOption> getprogramVal(){
        List<SelectOption> options = new List<SelectOption>();
            if(module == 'F7'){
                options.add(new SelectOption('PI 1','PI 1'));
                options.add(new SelectOption('PI 2','PI 2'));
                options.add(new SelectOption('PI 3','PI 3')); 
                options.add(new SelectOption('PI 4','PI 4'));
                options.add(new SelectOption('F7G','F7G'));
                options.add(new SelectOption('UMD','UMD')); 
                options.add(new SelectOption('PRM','PRM'));
                options.add(new SelectOption('Minesweeper','Minesweeper'));
                       
            }
            if(module == 'TD'){
                options.add(new SelectOption('40nm','40nm'));
                options.add(new SelectOption('55nm','55nm'));
                options.add(new SelectOption('65nm','65nm')); 
                options.add(new SelectOption('90nm','90nm'));
                options.add(new SelectOption('130nm','130nm'));
                            
            }           
        return options;
    } 
    
    public void validateFields(){
        validate = false;
        if(waferAllocation.Fab__c == null ){
            validate = true;
            waferAllocation.Fab__c.addError(eWSRConstantsVariablesClass.ERRORMSGFAB);
        }
        if(waferAllocation.Year__c == null ){
            validate = true;
            waferAllocation.Year__c.addError(eWSRConstantsVariablesClass.ERRORMSGYEAR);
        }
        if(waferAllocation.Fab__c == eWSRConstantsVariablesClass.FAB3ERECORDTYPE && waferAllocation.Module1__c == '--None--'){
            validate = true;
            waferAllocation.Module1__c.addError(eWSRConstantsVariablesClass.ERRORMSGMOD);
        }
        if(waferAllocation.Fab__c == eWSRConstantsVariablesClass.FAB7RECORDTYPE){
            if(waferAllocation.Module1__c == '--None--'){
                validate = true;
                waferAllocation.Module1__c.addError(eWSRConstantsVariablesClass.ERRORMSGMOD);
            }
            if(waferAllocation.Program1__c == null){
                validate = true;
                waferAllocation.Program1__c.addError(eWSRConstantsVariablesClass.ERRORMSGPROG);
            }
        }
    }
       
    public void displayProgramAndModuleField(){
        showProgramField = false;
        showModuleField = false;

        if(this.waferAllocation.Fab__c == eWSRConstantsVariablesClass.FAB3ERECORDTYPE){
            showProgramField = false;
            showModuleField = true;
        }
        if(this.waferAllocation.Fab__c == eWSRConstantsVariablesClass.FAB7RECORDTYPE){
            showProgramField = true;
            showModuleField = true;
        }
    }
    
    public void Search(){       
        waferAllocation.Module1__c = module;
        waferAllocation.Program1__c = program;
        validateFields();
        if(validate == true){
            
        }
        else{
            query = 'select Id, Fab__c, Month__c, Year__c, Module1__c, Program1__c, Wafer_Quantity_Allocated__c, Remaining_Quantity__c, LastModifiedById, CreatedById from Wafer_Allocation__c where Fab__c = \''+waferAllocation.Fab__c+'\' and Year__c = \''+waferAllocation.Year__c+'\'';    
            if(waferAllocation.Module1__c != null){
                query += ' and Module1__c = \''+waferAllocation.Module1__c+'\'';
            }
            if(waferAllocation.Program1__c != null){
                query += ' and Program1__c = \''+waferAllocation.Program1__c+'\'';
            }
            query += ' order by Name';
            System.debug('Query'+query );
            runQuery();
        }
    }
     
    public void runQuery(){
        
        List<Wafer_Allocation__c> wfList = new List<Wafer_Allocation__c>();
        waferAllocation.Module1__c = module;
        waferAllocation.Program1__c = program;
        wfList = database.query(query);       
        System.debug('WF Values:'+wfList );  
        if(wfList.size() > 0){
            waferAllocationList = wfList;
            showResult = true;
            showCreateButton = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, eWSRConstantsVariablesClass.ERRORMSGUPDATE));
        }
        else{
            showResult = false;
            showCreateButton = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, eWSRConstantsVariablesClass.ERRORMSGNORESULTS));
        }      
        
    }
    
    public void Create(){
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, eWSRConstantsVariablesClass.ERRORMSGUPDATE));        
        if(currentUser.Fab_Assigned__c != null){
            if((currentUser.ProfileId != systemAdminProfileId.Id && currentUser.Fab_Assigned__c.contains(waferAllocation.Fab__c)) || currentUser.ProfileId == systemAdminProfileId.Id){
                List<Wafer_Allocation__c> wfList = new List<Wafer_Allocation__c>();
                //if(wfList.size()==0){  
                    for(Integer i=0;i<12;i++){
                        Wafer_Allocation__c wf = new Wafer_Allocation__c();               
                        wf.Year__c = waferAllocation.Year__c;
                        wf.Fab__c = waferAllocation.Fab__c;
                        if(waferAllocation.Module1__c != null){
                            wf.Module1__c = waferAllocation.Module1__c ;
                        }
                        if(waferAllocation.Program1__c != null){
                            wf.Program1__c = waferAllocation.Program1__c;
                        }
                        if(i==0){
                            wf.Month__c = 'Jan';
                        }
                        if(i==1){
                            wf.Month__c = 'Feb';
                        }
                        if(i==2){
                            wf.Month__c = 'Mar';
                        }
                        if(i==3){
                            wf.Month__c = 'Apr';
                        }
                        if(i==4){
                            wf.Month__c = 'May';
                        }
                        if(i==5){
                            wf.Month__c = 'Jun';
                        }
                        if(i==6){
                            wf.Month__c = 'Jul';
                        }
                        if(i==7){
                            wf.Month__c = 'Aug';
                        }
                        if(i==8){
                            wf.Month__c = 'Sep';
                        }
                        if(i==9){
                            wf.Month__c = 'Oct';
                        }
                        if(i==10){
                            wf.Month__c = 'Nov';
                        }
                        if(i==11){
                            wf.Month__c = 'Dec';
                        }                   
                        wfList.add(wf);
                    }            
                    insert wfList;
                //}
                waferAllocationList = wfList;
                showResult = true; 
            }
            else if(waferAllocation.Fab__c == eWSRConstantsVariablesClass.FAB5JVRECORDTYPE && gpYes == true){
                List<Wafer_Allocation__c> wfList = new List<Wafer_Allocation__c>();
                //if(wfList.size()==0){  
                    for(Integer i=0;i<12;i++){
                        Wafer_Allocation__c wf = new Wafer_Allocation__c();               
                        wf.Year__c = waferAllocation.Year__c;
                        wf.Fab__c = waferAllocation.Fab__c;
                        if(waferAllocation.Module1__c != null){
                            wf.Module1__c = waferAllocation.Module1__c ;
                        }
                        if(waferAllocation.Program1__c != null){
                            wf.Program1__c = waferAllocation.Program1__c;
                        }
                        if(i==0){
                            wf.Month__c = 'Jan';
                        }
                        if(i==1){
                            wf.Month__c = 'Feb';
                        }
                        if(i==2){
                            wf.Month__c = 'Mar';
                        }
                        if(i==3){
                            wf.Month__c = 'Apr';
                        }
                        if(i==4){
                            wf.Month__c = 'May';
                        }
                        if(i==5){
                            wf.Month__c = 'Jun';
                        }
                        if(i==6){
                            wf.Month__c = 'Jul';
                        }
                        if(i==7){
                            wf.Month__c = 'Aug';
                        }
                        if(i==8){
                            wf.Month__c = 'Sep';
                        }
                        if(i==9){
                            wf.Month__c = 'Oct';
                        }
                        if(i==10){
                            wf.Month__c = 'Nov';
                        }
                        if(i==11){
                            wf.Month__c = 'Dec';
                        }                    
                        wfList.add(wf);
                    }               
                    insert wfList;
                //}
                waferAllocationList = wfList;
                showResult = true; 
            }
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, eWSRConstantsVariablesClass.ERRORMSGNOWAFERS));
                showResult = false;  
            }  
        }
        else if((currentUser.ProfileId != systemAdminProfileId.Id && waferAllocation.Fab__c == eWSRConstantsVariablesClass.FAB5JVRECORDTYPE && gpYes == true) || currentUser.ProfileId == systemAdminProfileId.Id){
            List<Wafer_Allocation__c> wfList = new List<Wafer_Allocation__c>();
            //if(wfList.size()==0){  
                for(Integer i=0;i<12;i++){
                     Wafer_Allocation__c wf = new Wafer_Allocation__c();                
                     wf.Year__c = waferAllocation.Year__c;
                     wf.Fab__c = waferAllocation.Fab__c;
                     //wf.Remaining_Quantity__c = waferAllocation.Wafer_Quantity_Allocated__c;
                     if(waferAllocation.Module1__c != null){
                         wf.Module1__c = waferAllocation.Module1__c ;
                     }
                     if(waferAllocation.Program1__c != null){
                         wf.Program1__c = waferAllocation.Program1__c;
                     }
                     if(i==0){
                         wf.Month__c = 'Jan';
                     }
                     if(i==1){
                         wf.Month__c = 'Feb';
                     }
                     if(i==2){
                         wf.Month__c = 'Mar';
                     }
                     if(i==3){
                         wf.Month__c = 'Apr';
                     }
                     if(i==4){
                         wf.Month__c = 'May';
                     }
                     if(i==5){
                         wf.Month__c = 'Jun';
                     }
                     if(i==6){
                         wf.Month__c = 'Jul';
                     }
                     if(i==7){
                         wf.Month__c = 'Aug';
                     }
                     if(i==8){
                         wf.Month__c = 'Sep';
                     }
                     if(i==9){
                         wf.Month__c = 'Oct';
                     }
                     if(i==10){
                         wf.Month__c = 'Nov';
                     }
                     if(i==11){
                         wf.Month__c = 'Dec';
                     }                    
                     wfList.add(wf);
                }            
                insert wfList;
            //}
            waferAllocationList = wfList;
            showResult = true; 
        }
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,eWSRConstantsVariablesClass.ERRORMSGNOWAFERS));
            showResult = false;  
        }       
    }
   
   public pageReference EditPage(){
        
        pgRef = new pageReference('/apex/WaferAllocationNewEditFormPage?id='+waferAllocationId);
        pgRef.getParameters().put('ReturnURL',currentURL);
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public pageReference ViewPage(){
        pgRef = new pageReference('/apex/WaferAllocationViewPage?id='+waferAllocationId);
        pgRef.getParameters().put('ReturnURL',currentURL);
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public pageReference Save(){
    if(currentUser.Fab_Assigned__c != null){
        if((currentUser.ProfileId != systemAdminProfileId.Id && currentUser.Fab_Assigned__c.contains(waferAllocation.Fab__c)) || currentUser.ProfileId == systemAdminProfileId.Id){
        validateFields();
        if(validate == true){
            return null;
        }
        else{
            if(waferAllocation.Wafer_Quantity_Allocated__c != null){
                System.debug('Wafer Quan Allo:'+ waferAllocation.Wafer_Quantity_Allocated__c);
                waferAllocation.Remaining_Quantity__c = waferAllocation.Wafer_Quantity_Allocated__c;
            } 
            upsert waferAllocation;
            pgRef = new pageReference('/apex/WaferAllocationViewPage?id='+waferAllocation.Id);
            pgRef.setRedirect(true);
            return pgRef;
        }
        }
        else if(waferAllocation.Fab__c == eWSRConstantsVariablesClass.FAB5JVRECORDTYPE && gpYes == true){
            if(waferAllocation.Wafer_Quantity_Allocated__c != null){
                System.debug('Wafer Quan Allo:'+ waferAllocation.Wafer_Quantity_Allocated__c);
                waferAllocation.Remaining_Quantity__c = waferAllocation.Wafer_Quantity_Allocated__c;
            } 
            upsert waferAllocation;
            pgRef = new pageReference('/apex/WaferAllocationViewPage?id='+waferAllocation.Id);
            pgRef.setRedirect(true);
            return pgRef;
        }
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, eWSRConstantsVariablesClass.ERRORMSGNOWAFERS));
            return null;
        } 
        }
        else if((currentUser.ProfileId != systemAdminProfileId.Id && waferAllocation.Fab__c == eWSRConstantsVariablesClass.FAB5JVRECORDTYPE && gpYes == true) || currentUser.ProfileId == systemAdminProfileId.Id){
            validateFields();
        if(validate == true){
            return null;
        }
        else{
            if(waferAllocation.Wafer_Quantity_Allocated__c != null){
                System.debug('Wafer Quan Allo:'+ waferAllocation.Wafer_Quantity_Allocated__c);
                waferAllocation.Remaining_Quantity__c = waferAllocation.Wafer_Quantity_Allocated__c;
            } 
            upsert waferAllocation;
            pgRef = new pageReference('/apex/WaferAllocationViewPage?id='+waferAllocation.Id);
            pgRef.setRedirect(true);
            return pgRef;
        }
        }
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, eWSRConstantsVariablesClass.ERRORMSGNOWAFERS));
            return null;
        }        
    }
    
    public pageReference SaveButton(){
    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, eWSRConstantsVariablesClass.ERRORMSGUPDATE));
    if(currentUser.Fab_Assigned__c != null){
    if((currentUser.ProfileId != systemAdminProfileId.Id && currentUser.Fab_Assigned__c.contains(waferAllocation.Fab__c)) || currentUser.ProfileId == systemAdminProfileId.Id){
        //System.debug('waferAllocationList'+gpYes);
        
        for(Wafer_Allocation__c wafer: waferAllocationList){
            if(wafer.Remaining_Quantity__c == null){
               wafer.Remaining_Quantity__c = wafer.Wafer_Quantity_Allocated__c;
            }
            //waferAllocationList.add(wafer);
        }        
        update waferAllocationList;
      }
      else if(waferAllocation.Fab__c == eWSRConstantsVariablesClass.FAB5JVRECORDTYPE && gpYes == true){
            for(Wafer_Allocation__c wafer: waferAllocationList){
            if(wafer.Remaining_Quantity__c == null){
                wafer.Remaining_Quantity__c = wafer.Wafer_Quantity_Allocated__c;
            }
            //waferAllocationList.add(wafer);
        }        
        update waferAllocationList;
        }  
      else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,eWSRConstantsVariablesClass.ERRORMSGNOWAFERS));
            return null;
        } 
      }
      else if((currentUser.ProfileId != systemAdminProfileId.Id && waferAllocation.Fab__c == eWSRConstantsVariablesClass.FAB5JVRECORDTYPE && gpYes == true) || currentUser.ProfileId == systemAdminProfileId.Id){
          for(Wafer_Allocation__c wafer: waferAllocationList){
          if(wafer.Remaining_Quantity__c == null){
            wafer.Remaining_Quantity__c = wafer.Wafer_Quantity_Allocated__c;
          }
            //waferAllocationList.add(wafer);
          
        }        
        update waferAllocationList;
      }
         else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,eWSRConstantsVariablesClass.ERRORMSGNOWAFERS));
            return null;
        }  
        return null;
    }

     public pageReference Back(){
        System.debug('Back Option');
        pgRef = new pageReference('/apex/WaferAllocationHomePage?id='+waferAllocation.Id);
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public pageReference Reset(){
        pgRef = new pageReference('/apex/WaferAllocationHomePage');
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public pageReference EditOnViewPage(){
        pgRef = new pageReference('/apex/WaferAllocationNewEditFormPage?id='+waferAllocation.Id);
        pgRef.getParameters().put('ReturnURL',currentURL);
        pgRef.setRedirect(true);
        return pgRef;
    }

    public pageReference cancel(){
        pgRef = new pageReference('/apex/WaferAllocationViewPage?id='+waferAllocation.Id);
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public void checkCurrentUser(){
        validUser = false;
        PermissionSet permissionSetRecord = new PermissionSet();
        permissionSetRecord = [select id, Label from PermissionSet where Label =: 'Access for planners to maintain eWSR wafer allocation and devices'];
        List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
        permissionSetList = [select AssigneeId from PermissionSetAssignment where PermissionSetId =: permissionSetRecord.Id];
        if(currentUser.ProfileId == gfPlanningProfileId.Id || currentUser.ProfileId == gfPlanningStandardProfileId.Id || currentUser.ProfileId == systemAdminProfileId.Id){
            validUser = true;
        }
        else{
            for(PermissionSetAssignment p : permissionSetList){
                System.debug('p.AssigneeId'+p.AssigneeId);
                System.debug('currentUser.Id'+currentUser.Id);
                if(currentUser.Id == p.AssigneeId){
                    System.debug('Valid User'+validUser);
                    validUser = true;
                    break;
                }
                else{
                System.debug('Valid User False'+validUser);
                    validUser = false;
                }
            }
        }    
    }
    
    public List<Wafer_Allocation__History> gethistoryList() {
      try{
          if(waferAllocation.Id!=null){
                waferHistoryList = [SELECT CreatedById, CreatedDate, Field, Id, IsDeleted, NewValue, OldValue, ParentId FROM Wafer_Allocation__History where ParentId = :waferAllocation.Id];
          }
      }
      catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, eWSRConstantsVariablesClass.ERRORMSGNORECORD));
        }     
        return waferHistoryList ;
    }
}