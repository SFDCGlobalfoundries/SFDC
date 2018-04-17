/*
 * @ Author :- Anil Kumar Reddy L
 * @ Description :- contains the logic for apex sharing .
 * @ Date :- 03/11/2016
 * @ Change History :-  
    DATE            NAME            Comments
    6-Dec-2016      Inshu Misra     Added code for exception framework...#IM
    20-May-2017     Anirban Roy     Modified code for fms sharing logic between account hierarchy.
    28-Jun-2017     Anirban Roy     Modified for Empty Account Hierarchy Issue
    28-Jun-2017     Anirban Roy     Modified for code review comment incorporation
    09-feb-2018     Ram Rai         Modified for code Record Share for New Issue
**/
Public class FMSRecordShareClass {
    
    public final String SAP_ACC_NO = EnvironmentVariable.get('SAP_ACC_NO')+'%';
    
    Public void sharePortalRecord(List < Form_Management_System__c > fmsNewList) {

        List < Form_Management_System__Share > fmsRecordShareList = new List < Form_Management_System__Share > ();
        Map<String,String> roleToGroupMap = new Map<String,String>();
        Map<String,String> accFrmHrcyToRoleMap = new Map<String,String>();
        
        Map <String,String> accMap = new Map <String,String> ();
        Map <String,List<String>> accMapList = new Map <String,List<String>> ();  
        Map < id, id > createdbyMap = new Map < id,id > ();
        Map<String,List<String>> accountHierarchyMap = new Map<String,List<String>>();
        List<String> acctHierIds = new List<String>();
        // New Case implementation
        Set<Id> mainfmId = new Set<Id>();       
        List < Form_Management_System__c > fmsRecordList = new List < Form_Management_System__c> ();
        Map<Id,Id> mainCrbyFmId = new  Map<Id,Id>();
        
        for (Form_Management_System__c fms: fmsNewList) {
            accMap.put(fms.id, fms.Customer_Name__c);
            createdbyMap.put(fms.id, fms.CreatedById);
            // New Case implementation
            mainfmId.add(fms.main_form_id__c);
        }        
        // New Case implementation
        for(Form_Management_System__c fms : [select id,createdbyid,createdby.accountid,main_form_id__c,customer_name__c from Form_Management_System__c where id in :mainfmId]){
        	if(fms.createdby.accountid != null && (fms.createdby.accountid != fms.customer_name__c)){
                mainCrbyFmId.put(fms.id,fms.createdbyid);
            }    
        }    
        for(Account_Hierarchy__c ahc : [select parent_id__c,account_id__c from Account_Hierarchy__c where Account_Id__c IN :accMap.values()]){
            if(accountHierarchyMap.containsKey(ahc.account_id__c)){
                accountHierarchyMap.get(ahc.account_id__c).add(ahc.parent_id__c);
            }else{
                accountHierarchyMap.put(ahc.account_id__c,new List<String>{ahc.parent_id__c});
            }
            acctHierIds.add(ahc.parent_id__c);
        }
        
        if(accountHierarchyMap.isEmpty()){
            for(String accId : accMap.values()){
                accountHierarchyMap.put(accId,new List<String>{accId});
                acctHierIds.add(accId);
            }           
        }
        
        for(Form_Management_System__c fms: fmsNewList){
            if(accMap!=null && !accMap.isEmpty() && accMap.containsKey(fms.id)){
                if(accountHierarchyMap!=null && !accountHierarchyMap.isEmpty() && accountHierarchyMap.containsKey(accMap.get(fms.id))){
                    accMapList.put(fms.id,accountHierarchyMap.get(accMap.get(fms.id)));
                }
            }
        }
        
        Set<id> roleId = new Set<id>();
        for(UserRole usrRole : [SELECT DeveloperName,Id,PortalRole,PortalAccountId FROM UserRole WHERE PortalAccountId IN :acctHierIds AND PortalRole = 'Worker']){
            roleId.add(usrRole.id);
            accFrmHrcyToRoleMap.put(usrRole.PortalAccountId,usrRole.Id);
        }
        
        List<Group> groupList = [SELECT Id,RelatedId,Type FROM Group WHERE RelatedId IN :roleId AND Type = 'RoleAndSubordinates'];
        
        for(Group grp : groupList){
    
            roleToGroupMap.put(grp.RelatedId,grp.id);
        }

        Map < id, boolean > userPort = new Map < id, boolean > ();
        for (User userval: [select id, IsPortalEnabled from user where ID IN: createdbyMap.Values()]) {
            userPort.put(userval.id, userval.IsPortalEnabled);

        }
        
        List<Account> acctTFACC = [Select id from Account where id in :accMap.values() and Customer_Category__c in ('TFA','CC')];     
        List<String> acctTFACCIds = new List<String>();
        for(Account a : acctTFACC){
            acctTFACCIds.add(a.Id);    
        }        
        
        List<Account> acct = [Select id from Account where SAP_Account_Number__c like :SAP_ACC_NO];     
        List<String> acctDMEAIds = new List<String>();
        for(Account a : acct){
            acctDMEAIds.add(a.Id);    
        }

        Map<String,String> roleToGroupDMEAMap = new Map<String,String>();
        Map<String,String> accFrmHrcyToRoleDMEAMap = new Map<String,String>();
        Set<id> roleIdForDMEA = new Set<id>();
        for(UserRole usrRole : [SELECT DeveloperName,Id,PortalRole,PortalAccountId FROM UserRole WHERE PortalAccountId IN :acctDMEAIds AND PortalRole = 'Worker']){
            roleIdForDMEA.add(usrRole.id);
            accFrmHrcyToRoleDMEAMap.put(usrRole.PortalAccountId,usrRole.Id);
        }
        
        List<Group> groupDMEAList = [SELECT Id,RelatedId,Type FROM Group WHERE RelatedId IN :roleIdForDMEA AND Type = 'RoleAndSubordinates'];
        
        for(Group grp : groupDMEAList){
    
            roleToGroupDMEAMap.put(grp.RelatedId,grp.id);
        }
		
		if(fmsNewList !=null && fmsNewList.size() > 0){
			
	        for (Form_Management_System__c fms: fmsNewList) {
	        	
	          // New Case implementation
	            if(!mainCrbyFmId.isempty() && mainCrbyFmId.containsKey(fms.main_form_id__c)){
	                            
	                Form_Management_System__Share fmsRecordShare = new Form_Management_System__Share();
	            
	                fmsRecordShare.ParentId = fms.Id;
	            
	                fmsRecordShare.UserOrGroupId = mainCrbyFmId.get(fms.main_form_id__c);
	             
	                fmsRecordShare.AccessLevel = 'Edit';
	                
	                fmsRecordShare.RowCause = Schema.Form_Management_System__Share.RowCause.Access_to_Associated_portal_Users__c;
	                
	                fmsRecordShareList.add(fmsRecordShare);   
	                                               
	            }
	            	
	            if(!accMapList.isEmpty() && accMapList.containsKey(fms.id)){
	                for(String acctId : accMapList.get(fms.id)){
	
	                    String usrRoleId = (!accFrmHrcyToRoleMap.isEmpty() && accFrmHrcyToRoleMap.containsKey(acctId))?accFrmHrcyToRoleMap.get(acctId):'';
	                    String grpId = (!roleToGroupMap.isEmpty() && roleToGroupMap.containsKey(usrRoleId))?roleToGroupMap.get(usrRoleId):'';
	                    if(grpId!='') {
	                        /** Create a new Test_Share record to be inserted in to the Test_Share table. **/
	                        Form_Management_System__Share fmsRecordShare = new Form_Management_System__Share();
	        
	                        /*User id for which the record to be share with*/
	                        fmsRecordShare.ParentId = fms.Id;
	        
	                        /*Share with set of users*/
	                        fmsRecordShare.UserOrGroupId = grpId;
	        
	                        /** Specify the access for this particular record. **/
	                        fmsRecordShare.AccessLevel = 'Edit';
	        
	                        /* Sharing reason specifed in FMS object */
	                        fmsRecordShare.RowCause = Schema.Form_Management_System__Share.RowCause.Access_to_Associated_portal_Users__c; 
	        
	                        /** Add the new Share record to the list of new Share records. **/
	                        fmsRecordShareList.add(fmsRecordShare);
	                            
	                        
	                    }
	                }
	            }
	            
	            if (acctTFACC!=null && acctTFACC.size()>0) {
	                for(Account a : acct){
	                    String usrRoleDMEAId = (!accFrmHrcyToRoleDMEAMap.isEmpty() && accFrmHrcyToRoleDMEAMap.containsKey(a.Id))?accFrmHrcyToRoleDMEAMap.get(a.Id):'';
	                    String grpDMEAId = (!roleToGroupDMEAMap.isEmpty() && roleToGroupDMEAMap.containsKey(usrRoleDMEAId))?roleToGroupDMEAMap.get(usrRoleDMEAId):'';
	                    if(grpDMEAId!='') {
	                        /** Create a new Test_Share record to be inserted in to the Test_Share table. **/
	                        Form_Management_System__Share fmsRecordShare = new Form_Management_System__Share();
	
	                        /*User id for which the record to be share with*/
	                        fmsRecordShare.ParentId = fms.Id;
	
	                        /*Share with set of users*/
	                        fmsRecordShare.UserOrGroupId = grpDMEAId;
	
	                        /** Specify the access for this particular record. **/
	                        fmsRecordShare.AccessLevel = 'Edit';
	
	                        /* Sharing reason specifed in FMS object */
	                        fmsRecordShare.RowCause = Schema.Form_Management_System__Share.RowCause.Access_to_Associated_portal_Users__c; 
	
	                        /** Add the new Share record to the list of new Share records. **/
	                        fmsRecordShareList.add(fmsRecordShare);
	                    }
	                }
	            }
	        }
		}
        /** Insert all of the newly created Share records and capture save result **/
        Database.SaveResult[] fmsRecordShareResult = Database.insert(fmsRecordShareList, false);
        for(Database.SaveResult sr: fmsRecordShareResult){
            if(!sr.isSuccess()){
                String logMessage = 'Error Message='+sr.getErrors()[0].getStatusCode()+' Stack Trace='+sr.getErrors()[0].getMessage();
                UtilityCls.saveExceptionLog(FMSRecordShareClass.class.getName(), 'sharePortalRecord(List < Form_Management_System__c > fmsNewList)', '', 'Bug', logMessage, '', 'Error', 'DMLException', 'FMS', null, 0);
                break;
            }
        }
    }
}