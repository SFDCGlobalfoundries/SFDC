/*
Type Name: ClsPortalTabAccessTriggerHandler
Author: Cognizant
Created Date: 12-April-2013
Reason: This class is used for assigning Tab access to Portal users
Change History:
Modified Date : Nov-24-2016
Modified by : Sunita char
Reason : For adding and removing permission set on change of GFV fab9/10 checkbox
â€¦â€¦..
Modified By: Abhita Bansal
Modified Date: 14/6/2017
Reason: Added the logic for FMS Project.

Modified By: Anil Kumar Reddy L
Modified Date: 22/6/2017
Reason: Added the logic for Fab 9/10 Reporting.
*/



global class ClsPortalTabAccessTriggerHandler{
    
      /**
        This future method updates the permissionsetAssignment record according to the access provied in the portal tab access record
        for each portal User
        @method name: assignTabAccess
        @parameter:   String of Portal Tab access Ids.
        @return :     none
    **/
     @future
     public static void assignTabAccessFuture(String PTAids){
        assignTabAccess(PTAids);    
     }
     /*static webservice void assignTabAccess(String PTAids)
     {*/
     //Method updated by Sunil for case # 22649, to optimize the code and to make it work for Overage profiles as well 
     public static void assignTabAccess(String PTAids){
        List<String> PortalAccessTabIds = PTAids.split('\\|');
        List<String> permSetNameLst=new List<String>();
        Map<String,Id> permSetMap=new Map<String,Id>();
        Map<String,Id> permSetOverageMap=new Map<String,Id>();
        Map<Id,Portal_Tab_Access__c> portalUserMap=new Map<Id,Portal_Tab_Access__c>();
        Set<Id> permSetIdSet=new Set<Id>();
        Set<Id> overagePermSetIdSet=new Set<Id>();
     
        List<PermissionSetAssignment> permissionsetDeleteList= new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> permissionsetInsertList= new List<PermissionSetAssignment>();
        Set<String> existingPermSetAssignmentSet=new Set<String>();
        
        
        permSetNameLst.add(System.Label.FMS_External_Users);// Added By Abhita for FMS Project
        
        permSetNameLst.add(System.Label.Tab_Access_Permission_Set_for_My_Devices);
        permSetNameLst.add(System.Label.Tab_Access_Permission_Set_for_My_Wafers);
        permSetNameLst.add(System.Label.Tab_Access_Permission_Set_for_PDK_Design_Documents);
        permSetNameLst.add(System.Label.Tab_Access_Permission_Set_for_Product_Services);
        permSetNameLst.add(System.Label.Tab_Access_PermissionSetOnSupplierService);
       // permSetNameLst.add(System.Label.Tab_Access_PermissionSetOnVendorServices);
       // permSetNameLst.add(System.Label.Standard_Tab_access_for_non_vendor_services); 
       
      
		permSetNameLst.add(System.Label.Overage_FMS_External_Users); // Added By Abhita for FMS Project
         
        permSetNameLst.add(System.Label.Overage_Tab_Access_Permission_Set_for_My_Devices);
        permSetNameLst.add(System.Label.Overage_Tab_Access_Permission_Set_for_My_Wafers); 
        permSetNameLst.add(System.Label.Overage_Tab_Access_Permission_Set_for_PDK_Design_Documents);
        permSetNameLst.add(System.Label.Overage_Tab_Access_Permission_Set_for_Product_Services);
        permSetNameLst.add(System.Label.Overage_Tab_Access_PermissionSetOnSupplierService);
        //permSetNameLst.add(System.Label.Overage_Tab_Access_PermissionSetOnVendorServices);
        //permSetNameLst.add(System.Label.Overage_Standard_Tab_access_for_non_vendor_services);
        
        //To fetch 14 permission sets
        
        PermissionSet[] pSetRecordsLst=[Select Id,Name from PermissionSet where Name IN: permSetNameLst];
        for(Integer i=0;i<pSetRecordsLst.size();i++){
            String chkOverage=pSetRecordsLst[i].Name;
           if(chkOverage.contains('Overage'))
            {
                permSetOverageMap.put(pSetRecordsLst[i].Name,pSetRecordsLst[i].Id);
                overagePermSetIdSet.add(pSetRecordsLst[i].Id);
            }
            else if(chkOverage.contains('All_License'))
            {
                permSetOverageMap.put(pSetRecordsLst[i].Name,pSetRecordsLst[i].Id);
                overagePermSetIdSet.add(pSetRecordsLst[i].Id);
                
                permSetMap.put(pSetRecordsLst[i].Name,pSetRecordsLst[i].Id);
                permSetIdSet.add(pSetRecordsLst[i].Id);
            }
            else
            {
                permSetMap.put(pSetRecordsLst[i].Name,pSetRecordsLst[i].Id);
                permSetIdSet.add(pSetRecordsLst[i].Id);
            }
            
        }
        
        
        List<Portal_Tab_Access__c> portalTabAccessList=[SELECT Id,
                                                               Name,
                                                               User__c,Contact__c, Contact__r.User_Profile_Name__c, 
                                                               My_Devices__c,GFV_Fab9_10_Reports__c,//added bu sunita on Nov-24-2016
                                                               My_Wafers__c ,
                                                               PDK_Design_Documents__c,
                                                               Product_Services__c,
                                                               Supplier_Services__c,
                                                               Vendor_Services__c
                                                               FROM Portal_Tab_Access__c 
                                                               WHERE Id in :PortalAccessTabIds];
                                                               
                                                               
      
                                                       
         for(Integer i=0;i<portalTabAccessList.size();i++){
            portalUserMap.put(portalTabAccessList[i].User__c,portalTabAccessList[i]);
         }
/*-----------added by sunita on Nov-24-2016 start--------------------------------------------------------------------------*/
        List<PermissionSetAssignment> permissionsetInsertListforReports= new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> permissionsetdeleteListforReports= new List<PermissionSetAssignment>();
        Map<String,Id> permSetMapforReports=new Map<String,Id>();
		/*L Anil Kumar Reddy - Start - 22-06-2017 - FAb 9/10 Report -Track 3 */
        //PermissionSet pSetobj=[Select Id,Name from PermissionSet where Name =: System.Label.Access_to_Fab_9_10_reports];
		//permSetMapforReports.put(pSetobj.Name,pSetobj.Id);

		List<PermissionSet> pSetobj=[Select Id,Name from PermissionSet where Name =: System.Label.Access_to_Fab_9_10_reports or Name =: System.Label.Access_to_Fab_9_10_reports_Restricted];
        for(PermissionSet psObj:pSetobj){
			permSetMapforReports.put(psObj.Name,psObj.Id);
		}
         
		User[] usrRecordLstforReports=[Select Id,ContactId,Contact.department__c,CreatedDate,LastModifiedDate, ProfileId,Profile.Name,(Select My_Devices__c, My_Wafers__c, PDK_Design_Documents__c,GFV_Fab9_10_Reports__c , Account__r.Customer_Category__c From Portal_Tab_Access__r Limit 1), (Select Id, AssigneeId, PermissionSetId From PermissionSetAssignments where PermissionSetId =:permSetMapforReports.get(System.Label.Access_to_Fab_9_10_reports) or PermissionSetId =:permSetMapforReports.get(System.Label.Access_to_Fab_9_10_reports_Restricted))  from User where ContactId!=null and Id IN:portalUserMap.keySet()];
           for (Integer i=0;i<usrRecordLstforReports.size();i++)
           {
				if(usrRecordLstforReports[i].Portal_Tab_Access__r[0].GFV_Fab9_10_Reports__c==true && (usrRecordLstforReports[i].Portal_Tab_Access__r[0].Account__r.Customer_Category__c != 'TFA')) {
                   permissionsetInsertListforReports.add(new PermissionSetAssignment(AssigneeId=usrRecordLstforReports[i].Id,PermissionSetId=permSetMapforReports.get(System.Label.Access_to_Fab_9_10_reports)));
                } 
				else if(usrRecordLstforReports[i].Portal_Tab_Access__r[0].GFV_Fab9_10_Reports__c==true && (usrRecordLstforReports[i].Portal_Tab_Access__r[0].Account__r.Customer_Category__c == 'TFA')){
                   permissionsetInsertListforReports.add(new PermissionSetAssignment(AssigneeId=usrRecordLstforReports[i].Id,PermissionSetId=permSetMapforReports.get(System.Label.Access_to_Fab_9_10_reports_Restricted)));
                }   
              
               //else if(usrRecordLstforReports[i].Portal_Tab_Access__r[0].GFV_Fab9_10_Reports__c==false)
               //{
					if(usrRecordLstforReports[i].PermissionSetAssignments.size() > 0){
						permissionsetdeleteListforReports.add(usrRecordLstforReports[i].PermissionSetAssignments);
           }                                               
             // }                   
           }                                               
        /*L Anil Kumar Reddy - End - 22-06-2017 - FAb 9/10 Report -Track 3 */                                                   
 /*-----------added by sunita on Nov-24-2016 end--------------------------------------------------------------------------*/
         
         
         
                //To fetch users and related contact records    //Added By Abhita for FMS Project
        User[] usrRecordLst=[Select Id,ContactId,Contact.department__c,Contact.Account.Fab_9_10__c,CreatedDate,LastModifiedDate, ProfileId,Profile.Name,(Select My_Devices__c, My_Wafers__c, PDK_Design_Documents__c, Product_Services__c,Supplier_Services__c,Vendor_Services__c, Tapeout_Fab_9_10__c From Portal_Tab_Access__r Limit 1), (Select Id, AssigneeId, PermissionSetId From PermissionSetAssignments) from User where ContactId!=null and Id IN:portalUserMap.keySet()];
        for (Integer i=0;i<usrRecordLst.size();i++){
            String profileName=usrRecordLst[i].Profile.Name;
            if(usrRecordLst[i].PermissionSetAssignments.size()>0){
                for(Integer j=0;j<usrRecordLst[i].PermissionSetAssignments.size();j++){
                    //To delete unwanted permission sets
                    if((profileName.contains('Overage') && permSetIdSet.contains(usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId)) || (!profileName.contains('Overage') && overagePermSetIdSet.contains(usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId))){
                        permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);                   
                    }else{
                        if(usrRecordLst[i].Portal_Tab_Access__r.size()>0){
                            if(profileName.contains('Overage')){
                                System.debug(usrRecordLst[i].Portal_Tab_Access__r[0].My_Devices__c+':::::test:::::::::'+usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId);
                                if(usrRecordLst[i].Portal_Tab_Access__r[0].My_Devices__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Devices)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].My_Wafers__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Wafers)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].PDK_Design_Documents__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_PDK_Design_Documents)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].Product_Services__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_Product_Services)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].Supplier_Services__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnSupplierService)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Contact.Account.Fab_9_10__c=='No' && usrRecordLst[i].Portal_Tab_Access__r[0].Tapeout_Fab_9_10__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetOverageMap.get(System.Label.Overage_FMS_External_Users)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }// Added By Abhita for FMS Project
                                
                                //code for vendor services as per DWP requirement
                               /* if(usrRecordLst[i].Portal_Tab_Access__r[0].Vendor_Services__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnVendorServices)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].Vendor_Services__c==true && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetOverageMap.get(System.Label.Overage_Standard_Tab_access_for_non_vendor_services)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }*/
                            }else{
                                //Updated map for case # 32409 by Sunil Arora on 1st sep, 2014
                                if(usrRecordLst[i].Portal_Tab_Access__r[0].My_Devices__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Devices)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].My_Wafers__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Wafers)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].PDK_Design_Documents__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetMap.get(System.Label.Tab_Access_Permission_Set_for_PDK_Design_Documents)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].Product_Services__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetMap.get(System.Label.Tab_Access_Permission_Set_for_Product_Services)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].Supplier_Services__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetMap.get(System.Label.Tab_Access_PermissionSetOnSupplierService)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Contact.Account.Fab_9_10__c=='No' && usrRecordLst[i].Portal_Tab_Access__r[0].Tapeout_Fab_9_10__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetMap.get(System.Label.FMS_External_Users)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }//Added By Abhita for FMS Project
                                
                                //code for vendor services as per DWP requirement
                                /* if(usrRecordLst[i].Portal_Tab_Access__r[0].Vendor_Services__c==false && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetMap.get(System.Label.Tab_Access_PermissionSetOnVendorServices)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }if(usrRecordLst[i].Portal_Tab_Access__r[0].Vendor_Services__c==true && usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId==permSetMap.get(System.Label.Standard_Tab_access_for_non_vendor_services)){
                                    permissionsetDeleteList.add(usrRecordLst[i].PermissionSetAssignments[j]);
                                }*/
                            }
                            
                        }
                        
                        existingPermSetAssignmentSet.add(usrRecordLst[i].PermissionSetAssignments[j].AssigneeId+'|'+usrRecordLst[i].PermissionSetAssignments[j].PermissionSetId);
                        
                    }
                }
                

                    if(usrRecordLst[i].Portal_Tab_Access__r.size()>0){
                        if(profileName.contains('Overage')){
                            //My_Devices__c, My_Wafers__c, PDK_Design_Documents__c, Product_Services__c
                            if(usrRecordLst[i].Portal_Tab_Access__r[0].My_Devices__c==true && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Devices))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Devices)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Devices));
                            }if(usrRecordLst[i].Portal_Tab_Access__r[0].My_Wafers__c==true && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Wafers))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Wafers)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_My_Wafers));
                            }if(usrRecordLst[i].Portal_Tab_Access__r[0].PDK_Design_Documents__c==true && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_PDK_Design_Documents))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_PDK_Design_Documents)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_PDK_Design_Documents));
                            }if(usrRecordLst[i].Portal_Tab_Access__r[0].Product_Services__c==true && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_Product_Services))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_Product_Services)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_Permission_Set_for_Product_Services));
                            }if(usrRecordLst[i].Portal_Tab_Access__r[0].Supplier_Services__c==true && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnSupplierService))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnSupplierService)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnSupplierService));
                            }if(usrRecordLst[i].Contact.Account.Fab_9_10__c=='Yes' && usrRecordLst[i].Portal_Tab_Access__r[0].Tapeout_Fab_9_10__c==true && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_FMS_External_Users))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_FMS_External_Users)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_FMS_External_Users));
                            }//Added By Abhita for FMS Project
                            //code for vendor services as per DWP requirement
                           /* if(usrRecordLst[i].Portal_Tab_Access__r[0].Vendor_Services__c==true && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnVendorServices))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnVendorServices)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Tab_Access_PermissionSetOnVendorServices));
                            }if(usrRecordLst[i].Portal_Tab_Access__r[0].Vendor_Services__c==false && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Standard_Tab_access_for_non_vendor_services))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetOverageMap.get(System.Label.Overage_Standard_Tab_access_for_non_vendor_services)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetOverageMap.get(System.Label.Overage_Standard_Tab_access_for_non_vendor_services));
                            }*/
                        }else{
                            if(usrRecordLst[i].Portal_Tab_Access__r[0].My_Devices__c==true && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Devices))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Devices)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Devices));
                            }if(usrRecordLst[i].Portal_Tab_Access__r[0].My_Wafers__c==true && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Wafers))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Wafers)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_My_Wafers));
                            }if(usrRecordLst[i].Portal_Tab_Access__r[0].PDK_Design_Documents__c==true && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_PDK_Design_Documents))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Tab_Access_Permission_Set_for_PDK_Design_Documents)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_PDK_Design_Documents));
                            }if(usrRecordLst[i].Portal_Tab_Access__r[0].Product_Services__c==true && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_Product_Services))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Tab_Access_Permission_Set_for_Product_Services)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_Permission_Set_for_Product_Services));
                            }if(usrRecordLst[i].Portal_Tab_Access__r[0].Supplier_Services__c==true && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_PermissionSetOnSupplierService))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Tab_Access_PermissionSetOnSupplierService)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_PermissionSetOnSupplierService));
                            }if(usrRecordLst[i].Contact.Account.Fab_9_10__c=='Yes' && usrRecordLst[i].Portal_Tab_Access__r[0].Tapeout_Fab_9_10__c==true && !existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.FMS_External_Users))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.FMS_External_Users)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.FMS_External_Users));
                            }// Added By Abhita for FMS Project
                            
                              //code for vendor services as per DWP requirement
                             /* if(usrRecordLst[i].Portal_Tab_Access__r[0].Vendor_Services__c==true && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_PermissionSetOnVendorServices))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Tab_Access_PermissionSetOnVendorServices)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Tab_Access_PermissionSetOnVendorServices));
                            }if(usrRecordLst[i].Portal_Tab_Access__r[0].Vendor_Services__c==false && ! existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Standard_Tab_access_for_non_vendor_services))){
                                permissionsetInsertList.add(new PermissionSetAssignment(AssigneeId=usrRecordLst[i].Id,PermissionSetId=permSetMap.get(System.Label.Standard_Tab_access_for_non_vendor_services)));
                                existingPermSetAssignmentSet.contains(usrRecordLst[i].Id + '|'+permSetMap.get(System.Label.Standard_Tab_access_for_non_vendor_services));
                            }*/
                        }
                        
                    }
                
            }
        }
            
            try{
                
                    if(permissionsetDeleteList.size()>0)
                    {
                delete permissionsetDeleteList;
                    }
                    if (permissionsetInsertList.size()>0)
                    {
                        insert permissionsetInsertList;
               
                }
                if (permissionsetdeleteListforReports.size()>0)
                    {
                        delete permissionsetdeleteListforReports;
               
                }
                if (permissionsetInsertListforReports.size()>0)
                    {
                        insert permissionsetInsertListforReports;
               
                }
                }catch(DMLException ex)
               {
                System.debug(' ** Exception encountered in Inserting Permission Sets is ** ' + ex.getMessage());
                
            }
     }
}