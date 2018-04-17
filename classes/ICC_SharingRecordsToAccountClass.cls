/*
 * @ Author :- Anil Kumar Reddy L
 * @ Description :- Contains the logic for Sharing access on various Objects to Account related herarchy Users.
 * @ Date :- 19/04/2017
 * @ Change History  :-   
 **/
PUBLIC CLASS ICC_SharingRecordsToAccountClass {
	SET<id> associatedAccountList = NEW SET<Id>();
    SET<Id> setofAccId = NEW SET<Id>();
    MAP<id,Set<id>> accToAccHrcyMap = NEW MAP<id,Set<id>>();
    MAP<id,id> accFrmHrcyToRoleMap = NEW MAP<id,id>();
    MAP<id,id> roleToGroupMap = NEW MAP<id,id>();
	MAP<id,Set<id>> objectValidAccountsMap = NEW MAP<id,Set<id>>();
    List<Sobject> salesOLShareList = NEW List<Sobject>();
    String shareObjectValue ;
    Final String CONSTANT_ACCOUNT_API = 'Account__c';
    Final String CONSTANT_ENDCUSTOMER_ACCOUNT_API = 'End_Customer_Account__c';
    Final String CONSTANT_CONTRACT_SOLDTO_ACCOUNT_API = 'Contract_Sold_To_Account__c';
    Final String CONSTANT_SALES_ORDER_SHARE = 'Sales_Order_Line__Share';
    Final String CONSTANT_SHIPMENT_SHARE = 'Shipment__Share';
	Final String CONSTANT_CONTRACT_SOLDTO = 'Contract_Sold_To__c';
    Final String CONSTANT_LOT_STATUS_SHARE = 'LOT_Status__Share';
    Final String CONSTANT_LOT_HISTORY_SHARE = 'LOT_History__Share';
    Final String CONSTANT_RecordID = 'Id';
	Public Set<String> contractSoldToAccountSet = ICC_ContractSoldToAccounts__c.getall().Keyset();
    
    /** Method takes Trigger new list of Objects and Sharing object name and share each record to 
		its all related account/portal users roles in the hirarchy 
		@param : triggerNewList - Contains Specific objects /Trigger.New  
		@param : shareObjectName - Share object name of the explictly sharing object .
	*/
    public void shareRecordsToAccounts(List<Sobject> triggerNewList, String shareObjectName){
        shareObjectValue = shareObjectName;
		system.debug('triggerNewList$$$$'+triggerNewList);
        for(Sobject sObjectRec : triggerNewList){
			Set<id> validAccountsSet = new Set<id>(); 
            ///Validating for End Customer Rules.
            if((Id)sObjectRec.get(CONSTANT_ENDCUSTOMER_ACCOUNT_API) != null ){
                setofAccId.add((Id)sObjectRec.get(CONSTANT_ENDCUSTOMER_ACCOUNT_API));
                validAccountsSet.add((Id)sObjectRec.get(CONSTANT_ENDCUSTOMER_ACCOUNT_API));
                if(shareObjectName.equalsIgnoreCase(CONSTANT_SALES_ORDER_SHARE) || shareObjectName.equalsIgnoreCase(CONSTANT_SHIPMENT_SHARE)){
                    setofAccId.add((Id)sObjectRec.get(CONSTANT_ACCOUNT_API));
					validAccountsSet.add((Id)sObjectRec.get(CONSTANT_ACCOUNT_API));
                }
            }

            //validating for the contact customer--if DMEA ,do not provide access to Account Field
            if(sObjectRec.get(CONSTANT_CONTRACT_SOLDTO_ACCOUNT_API) != null ){
                setofAccId.add((Id)sObjectRec.get(CONSTANT_CONTRACT_SOLDTO_ACCOUNT_API));
				validAccountsSet.add((Id)sObjectRec.get(CONSTANT_CONTRACT_SOLDTO_ACCOUNT_API));
				//checking for valid accounts to provide access 
                if( (sObjectRec.get(CONSTANT_CONTRACT_SOLDTO) != null && contractSoldToAccountSet.contains(((String)sObjectRec.get(CONSTANT_CONTRACT_SOLDTO)).toUpperCase())) && (shareObjectName.equalsIgnoreCase(CONSTANT_SHIPMENT_SHARE) || shareObjectName.equalsIgnoreCase(CONSTANT_LOT_STATUS_SHARE) || shareObjectName.equalsIgnoreCase(CONSTANT_LOT_HISTORY_SHARE))){
                    setofAccId.add((Id)sObjectRec.get(CONSTANT_ACCOUNT_API));
					validAccountsSet.add((Id)sObjectRec.get(CONSTANT_ACCOUNT_API));
                }
                else if(!(sObjectRec.get(CONSTANT_CONTRACT_SOLDTO) != null && contractSoldToAccountSet.contains(((String)sObjectRec.get(CONSTANT_CONTRACT_SOLDTO)).toUpperCase()))){
                    setofAccId.add((Id)sObjectRec.get(CONSTANT_ACCOUNT_API));
					validAccountsSet.add((Id)sObjectRec.get(CONSTANT_ACCOUNT_API));
                }
            }
            //if no contract or end customer is provided
            if(sObjectRec.get(CONSTANT_CONTRACT_SOLDTO_ACCOUNT_API) == null && sObjectRec.get(CONSTANT_ENDCUSTOMER_ACCOUNT_API) == null) {
                setofAccId.add((Id)sObjectRec.get(CONSTANT_ACCOUNT_API));
				validAccountsSet.add((Id)sObjectRec.get(CONSTANT_ACCOUNT_API));
            }
            
			if(!validAccountsSet.isEmpty()){
				objectValidAccountsMap.put(sObjectRec.id, validAccountsSet);
			}
            
        }
        system.debug('setofAccId&&&'+setofAccId);
        for (Account acctObj : [SELECT Parent.ParentId,ParentId,Name,Id FROM  Account  WHERE  Id IN:setofAccId]) {
            associatedAccountList.add(acctObj.Id);
            Set<id> accParList = new Set<id>();
            if(acctObj.ParentId != null){
                associatedAccountList.add(acctObj.ParentId);
                if(accToAccHrcyMap.containsKey(acctObj.Id)){
                    accParList = accToAccHrcyMap.get(acctObj.Id);
                    accParList.add(acctObj.ParentId);
                }
                else{
                    accParList.add(acctObj.ParentId);
                }
                accToAccHrcyMap.put(acctObj.Id,accParList);
            }
            
            Set<id> accGrndParList = new Set<id>();
            if(acctObj.ParentId != null && acctObj.Parent.ParentId!=null){
                associatedAccountList.add(acctObj.Parent.ParentId);
                if(accToAccHrcyMap.containsKey(acctObj.Id)){
                    accGrndParList = accToAccHrcyMap.get(acctObj.Id);
                    system.debug('testing acc grnd par'+accGrndParList);
                    accGrndParList.add(acctObj.Parent.ParentId);
                }
                else{
                    accGrndParList.add(acctObj.Parent.ParentId);
                }
                accToAccHrcyMap.put(acctObj.Id,accGrndParList);
            }
        }   

        for(Id setofAcc : setofAccId){
            Set<id> accParList = new Set<id>();
            if(accToAccHrcyMap.containsKey(setofAcc)){
                    accParList = accToAccHrcyMap.get(setofAcc);
                    accParList.add(setofAcc);
                    accToAccHrcyMap.put(setofAcc,accParList);
            }
            else{
                accParList.add(setofAcc);
                accToAccHrcyMap.put(setofAcc,accParList);
            }
        }
        
        Set<id> roleId = new Set<id>();
        for(UserRole usrRole : [SELECT DeveloperName,Id,PortalRole,PortalAccountId FROM UserRole WHERE PortalAccountId IN :associatedAccountList AND PortalRole = 'Worker']){
            roleId.add(usrRole.id);
            accFrmHrcyToRoleMap.put(usrRole.PortalAccountId,usrRole.Id);
        }
        List<Group> groupList = [SELECT Id,RelatedId,Type FROM Group WHERE RelatedId IN :roleId AND Type = 'RoleAndSubordinates'];
        
        for(Group grp : groupList){
            
            roleToGroupMap.put(grp.RelatedId,grp.id);
        }
        
        for(Sobject sObjectRec : triggerNewList){
            if(sObjectRec.get(CONSTANT_ACCOUNT_API) != null && accToAccHrcyMap.get((Id)sObjectRec.get(CONSTANT_ACCOUNT_API)) !=null && objectValidAccountsMap.get((Id)sObjectRec.get(CONSTANT_RecordID)) != null && objectValidAccountsMap.get((Id)sObjectRec.get(CONSTANT_RecordID)).Contains((Id)sObjectRec.get(CONSTANT_ACCOUNT_API)) ){
                for(ID accHryId : accToAccHrcyMap.get((Id)sObjectRec.get(CONSTANT_ACCOUNT_API))){
                    if(roleToGroupMap.get(accFrmHrcyToRoleMap.get(accHryId))!=null){
                      shareList(sObjectRec, accHryId);
                    }               
                }
            }
            
            if((Id)sObjectRec.get(CONSTANT_ENDCUSTOMER_ACCOUNT_API) != null && accToAccHrcyMap.get((Id)sObjectRec.get(CONSTANT_ENDCUSTOMER_ACCOUNT_API)) != null && objectValidAccountsMap.get((Id)sObjectRec.get(CONSTANT_RecordID)) != null && objectValidAccountsMap.get((Id)sObjectRec.get(CONSTANT_RecordID)).Contains((Id)sObjectRec.get(CONSTANT_ENDCUSTOMER_ACCOUNT_API)) ){
                for(ID accHryId : accToAccHrcyMap.get((Id)sObjectRec.get(CONSTANT_ENDCUSTOMER_ACCOUNT_API))){
                    if(roleToGroupMap.get(accFrmHrcyToRoleMap.get(accHryId))!=null){
                        shareList(sObjectRec, accHryId);
                    }
            	}
            }
           
            if((Id)sObjectRec.get(CONSTANT_CONTRACT_SOLDTO_ACCOUNT_API) != null && objectValidAccountsMap.get((Id)sObjectRec.get(CONSTANT_RecordID)) != null && objectValidAccountsMap.get((Id)sObjectRec.get(CONSTANT_RecordID)).Contains((Id)sObjectRec.get(CONSTANT_CONTRACT_SOLDTO_ACCOUNT_API))){
                for(ID accHryId : accToAccHrcyMap.get((Id)sObjectRec.get(CONSTANT_CONTRACT_SOLDTO_ACCOUNT_API))){
                    if(roleToGroupMap.get(accFrmHrcyToRoleMap.get(accHryId))!=null){
                    	shareList(sObjectRec, accHryId);
                    }
            	}   
            }
        }
        
        if(!salesOLShareList.isEmpty()){
            try{
            Database.Insert(salesOLShareList);
        }
            catch(Exception ex){
            	ICC_ExceptionHandler.exceptionHandler(ex, ICC_SharingRecordsToAccountClass.class.getName(), 'shareRecordsToAccounts()', '', 'Sharing records to Accounts');   
            }
            
        }
    }
    private void shareList(Sobject sObjectRecord , Id accHryId){
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType st = gd.get( shareObjectValue );
        Sobject objShare = st.newSobject();
        objShare.put('AccessLevel','Read');
        objShare.put('ParentId',(Id)sObjectRecord.get('Id'));
        objShare.put('UserOrGroupId', roleToGroupMap.get(accFrmHrcyToRoleMap.get(accHryId)));
        objShare.put('RowCause', Schema.Sales_Order_Line__Share.RowCause.GFV_Report_Sharing__c); 
        salesOLShareList.add(objShare);  
    }
    
    /** Method takes Trigger new and old instances and Sharing object name and share each record to 
		its all related account/portal users roles in the hirarchy 
		@param : triggerNewMap - Contains Specific new Instance of objects /Trigger.newMap
		@param : triggerOldMap - Contains Specific Old Instance of objects /Trigger.OldMap
		@param : shareObjectName - Share object name of the explictly sharing object..
	*/
    public void sharingToUpdatedAccounts(Map<id,Sobject> triggerNewMap, Map<id,Sobject> triggerOldMap,String shareObjectName){
		Set<Id> setObjId = new set<Id>();
		Map<id,Sobject> validRecordMap = new Map<id,Sobject>();
        for(Sobject sObjectRec : triggerNewMap.values()){
            List<id> accountList = new List<id>();
            if(((Id)sObjectRec.get(CONSTANT_ACCOUNT_API) != triggerOldMap.get((Id)sObjectRec.get('id')).get(CONSTANT_ACCOUNT_API)) || (Label.ICC_Sharing_LegeacyData == 'true' && (Id)sObjectRec.get(CONSTANT_ACCOUNT_API) !=null)){
				setObjId.add((Id)sObjectRec.get('id'));
				validRecordMap.put((Id)sObjectRec.get('id') , sObjectRec);
            }
            
			if(((Id)sObjectRec.get(CONSTANT_ENDCUSTOMER_ACCOUNT_API) != triggerOldMap.get((Id)sObjectRec.get('id')).get(CONSTANT_ENDCUSTOMER_ACCOUNT_API))|| (Label.ICC_Sharing_LegeacyData == 'true' && (Id)sObjectRec.get(CONSTANT_ENDCUSTOMER_ACCOUNT_API) != null)){
                 setObjId.add((id)sObjectRec.get('id'));
				 validRecordMap.put((Id)sObjectRec.get('id') , sObjectRec);
            }
            if(((Id)sObjectRec.get(CONSTANT_CONTRACT_SOLDTO_ACCOUNT_API) != triggerOldMap.get((Id)sObjectRec.get('id')).get(CONSTANT_CONTRACT_SOLDTO_ACCOUNT_API)) || (Label.ICC_Sharing_LegeacyData == 'true' && (Id)sObjectRec.get(CONSTANT_CONTRACT_SOLDTO_ACCOUNT_API) !=null)){
                 setObjId.add((id)sObjectRec.get('id'));
				 validRecordMap.put((Id)sObjectRec.get('id') , sObjectRec);
            }
		}
        
        String queryStr = 'SELECT Id FROM '+shareObjectName+' Where ParentId IN :setObjId and RowCause = \'GFV_Report_Sharing__c\' ';
        system.debug('$$$queryStr###'+queryStr);
        List<Sobject> sObj = Database.query(queryStr);
        try{
        Database.delete(sObj);
        }
        catch(Exception ex){
           	ICC_ExceptionHandler.exceptionHandler(ex, ICC_SharingRecordsToAccountClass.class.getName(), 'sharingToUpdatedAccounts()', '', 'Sharing Updated records to Accounts');   
        }
        if(setObjId.size()>0){
			shareRecordsToAccounts(validRecordMap.values(), shareObjectName);	
		}
        
	}

    
    /** Method provides the access of all objects/records applicable to the new user and its herirchy accounts..
     	This works for only the first portal user of the account. 
		@param : triggerNewUser - Contains Specific new Instance of user /Trigger.new
	*/
    public static void shareAccessToPortalAccounts(Map<id,Contact> newContMap,Map<id,Contact> oldContMap ){
		
        ICC_SharingRecordsToAccountClass sharcls = new ICC_SharingRecordsToAccountClass();
        Set<id> accountIds = new Set<id>();
		 Set<id> validAccountIds = new Set<id>();
        
        for(Contact cont: newContMap.values()){
			if(cont.Is_Portal_User_Created__c != oldContMap.get(cont.id).Is_Portal_User_Created__c && cont.Is_Portal_User_Active__c != oldContMap.get(cont.id).Is_Portal_User_Active__c){ 
                accountIds.add(cont.AccountId);
            }
        }
		system.debug('accountIds***'+accountIds);
		AggregateResult[] aggRel = [select AccountId,count(id) from user group by Accountid , IsPortalEnabled,IsActive having count(id)=1 and Accountid IN :accountIds and IsPortalEnabled = true and IsActive = true];
		system.debug('aggRel***'+aggRel);
		//Set<Id> setofAccId = new set<Id>();
    	Map<id,Set<id>> accountHrcyMap = new Map<id,Set<id>>();
		set<id> assocAccountList = new set<Id>();
		for(AggregateResult agg : aggRel){
			//validAccountIds.add((ID)agg.get('AccountId'));
			Id acctObjId = (ID)agg.get('AccountId');
            system.debug('acctObjId***'+acctObjId);
			assocAccountList.add(acctObjId);
			Set<id> accMainList = new Set<id>();
			/*if(accountHrcyMap.containsKey(acctObjId)){
                    accMainList = accountHrcyMap.get(acctObjId);
                    accMainList.add(acctObjId);
                    accountHrcyMap.put(acctObjId,accMainList);
            }
            else{*/
                accMainList.add(acctObjId);
                accountHrcyMap.put(acctObjId,accMainList);
            //}
			system.debug('accountHrcyMap111&&&'+accountHrcyMap);
		}

        //geting childs
        for(Account acc : [Select Id,ParentId from Account where ParentId in: assocAccountList]) {
            assocAccountList.add(acc.Id);
            Set<id> accParList = new Set<id>();
            if(accountHrcyMap.containsKey(acc.ParentId)){
                    accParList = accountHrcyMap.get(acc.ParentId);
                    accParList.add(acc.id);
                    accountHrcyMap.put(acc.ParentId,accParList);
            }
            /*else{
                //accParList.add(acctObj.Parent.ParentId);
                for(Id accID : accountHrcyMap.keyset()){
                    if(accountHrcyMap.get(accID).contains(acc.ParentId)){
                        accParList = accountHrcyMap.get(accID);
                        accParList.add(acc.id);
                        accountHrcyMap.put(accID,accParList);
                    }
                }
            }*/
        }   
        //getting third level childs if any.
        if(assocAccountList!= null && !(assocAccountList.isEmpty())){
            for(Account acc : [Select Id,ParentId from Account where ParentId in: assocAccountList]) {
                Set<id> accParList = new Set<id>();
                assocAccountList.add(acc.Id);
                if(accountHrcyMap.containsKey(acc.ParentId)){
                    accParList = accountHrcyMap.get(acc.ParentId);
                    accParList.add(acc.id);
                    accountHrcyMap.put(acc.ParentId,accParList);
                }
                else{
                    for(Id accID : accountHrcyMap.keyset()){
                        if(accountHrcyMap.get(accID).contains(acc.ParentId)){
                            accParList = accountHrcyMap.get(accID);
                            accParList.add(acc.id);
                            accountHrcyMap.put(accID,accParList);
                        }
                    }
                }
            }
        }
		system.debug('accountHrcyMap22###'+accountHrcyMap);
        
        Map<id,id> accHrcyToRoleMap = new Map<id,id>();
		Map<id,id> portalRoleToGroupMap = new Map<id,id>();
        Set<id> portalRoleId = new Set<id>();
        
		for(UserRole usrRole : [SELECT DeveloperName,Id,PortalRole,PortalAccountId FROM UserRole WHERE PortalAccountId IN :accountHrcyMap.keyset() AND PortalRole = 'Worker']){
            portalRoleId.add(usrRole.id);
            accHrcyToRoleMap.put(usrRole.PortalAccountId,usrRole.Id);
        }
        system.debug('accHrcyToRoleMap###'+accHrcyToRoleMap);
        List<Group> groupList = [SELECT Id,RelatedId,Type FROM Group WHERE RelatedId IN :portalRoleId AND Type = 'RoleAndSubordinates'];
        system.debug('groupList###'+groupList);
        for(Group grp : groupList){
            portalRoleToGroupMap.put(grp.RelatedId,grp.id);
        }
		Map<String,Map<id,List<id>>> obj2accNObjMap = new Map<String,Map<id,List<id>>>();		
		
        Map<String,String > gnrcObjMap = new Map<String,String> {'Sales_Order_Line__c' => sharcls.CONSTANT_SALES_ORDER_SHARE, 'Shipment__c' => sharcls.CONSTANT_SHIPMENT_SHARE, 'LOT_Status__c' => sharcls.CONSTANT_LOT_STATUS_SHARE , 'LOT_History__c' => sharcls.CONSTANT_LOT_HISTORY_SHARE};
        
		for(String genericObject :gnrcObjMap.keySet()){
			String queryString = 'Select id, Account__c,End_Customer_Account__c,Contract_Sold_To_Account__c ,Contract_Sold_To__c From '+ genericObject+' Where End_Customer_Account__c IN :assocAccountList OR Account__c IN :assocAccountList  OR Contract_Sold_To_Account__c IN :assocAccountList';
			List<sObject>  sObjectList =  Database.query(queryString); 
            system.debug('sObjectList###'+sObjectList);
			obj2accNObjMap.put(genericObject,sharcls.createAccountSalesMap(newContMap.values(), sObjectList , accountHrcyMap , gnrcObjMap.get(genericObject)));
		}
		system.debug('obj2accNObjMap***'+obj2accNObjMap);
		List<Sobject> soShareList = new List<Sobject>();
		for(String genericObject :gnrcObjMap.keySet()){
			for(Id accID : obj2accNObjMap.get(genericObject).keySet()){
				for(id soId : obj2accNObjMap.get(genericObject).get(accID)){
					Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
					Schema.SObjectType st = gd.get( gnrcObjMap.get(genericObject) );
					Sobject objShare = st.newSobject();
					objShare.put('AccessLevel','Read');
					objShare.put('ParentId',soId);
					objShare.put('UserOrGroupId', portalRoleToGroupMap.get(accHrcyToRoleMap.get(accID)));
					objShare.put('RowCause', Schema.Sales_Order_Line__Share.RowCause.GFV_Report_Sharing__c); 
					soShareList.add(objShare);	
				}
			}
		}
		system.debug('soShareList***'+soShareList);
		if(!soShareList.isEmpty()){
            try{
                Database.insert(soShareList);
            }
            catch(Exception ex){
           		ICC_ExceptionHandler.exceptionHandler(ex, ICC_SharingRecordsToAccountClass.class.getName(), 'shareAccessToPortalAccounts()', '', 'Sharing records to New protal user Accounts');   
        	}
		}
    }   
	
	public Map<id,List<id>> createAccountSalesMap (List<contact> triggerNewContact , List<sobject> sObjectList, Map<id,Set<id>> acctHrcyMap, String shareObjName){
		Map<id,List<id>> accNSalesMap = new Map<id,List<id>>();
		for(contact cont : triggerNewContact){
            system.debug('sObjectList***'+sObjectList);
			for(Sobject sObj : sObjectList){
				Boolean validSObjs = false;
                Set<id> accHryIds = new Set<id>();
				accHryIds.addall(acctHrcyMap.get(cont.AccountId));

				//case when contract sold to account has value , and our account is in Account filed, exception applied
				if(accHryIds.contains((Id)sObj.get(CONSTANT_ACCOUNT_API))&& ((String)sObj.get(CONSTANT_CONTRACT_SOLDTO) != null && (contractSoldToAccountSet.contains(((String)sObj.get(CONSTANT_CONTRACT_SOLDTO)).toUpperCase()))) && (Id)sObj.get(CONSTANT_CONTRACT_SOLDTO_ACCOUNT_API) != null && (Id)sObj.get(CONSTANT_ENDCUSTOMER_ACCOUNT_API) == null && (shareObjName.equalsIgnoreCase(CONSTANT_SHIPMENT_SHARE) || shareObjName.equalsIgnoreCase(CONSTANT_LOT_STATUS_SHARE) || shareObjName.equalsIgnoreCase(CONSTANT_LOT_HISTORY_SHARE))){
					validSObjs = true;
				}
				//case when end customer account has value , and our account is in Account filed, exception applied
				else if(accHryIds.contains((Id)sObj.get(CONSTANT_ACCOUNT_API))&& (Id)sObj.get(CONSTANT_CONTRACT_SOLDTO_ACCOUNT_API) == null && (Id)sObj.get(CONSTANT_ENDCUSTOMER_ACCOUNT_API) != null && (shareObjName.equalsIgnoreCase(CONSTANT_SHIPMENT_SHARE) || shareObjName.equalsIgnoreCase(CONSTANT_SALES_ORDER_SHARE))){
					validSObjs = true;
				}
				//case when only our account is in Account filed, and no end customer or contract customer is applied
				else if(accHryIds.contains((Id)sObj.get(CONSTANT_ACCOUNT_API))&& (Id)sObj.get(CONSTANT_CONTRACT_SOLDTO_ACCOUNT_API) == null && (Id)sObj.get(CONSTANT_ENDCUSTOMER_ACCOUNT_API) == null ){
					validSObjs = true;
				}
				//case when our account is in either contract sold to or end customer filed , exception allowed to share
				else if(accHryIds.contains((Id)sObj.get(CONSTANT_CONTRACT_SOLDTO_ACCOUNT_API)) || accHryIds.contains((Id)sObj.get(CONSTANT_ENDCUSTOMER_ACCOUNT_API))){
					validSObjs = true;
				}
				
				if(validSObjs){
					List<id> soList = new List<id>();
					if(accNSalesMap.ContainsKey(cont.AccountId)){
						soList= accNSalesMap.get(cont.AccountId);
						soList.add((Id)sObj.get('id'));
					}
					else {
						soList.add((Id)sObj.get('id'));
					}
					accNSalesMap.put(cont.AccountId , soList);
				}
			}
		}
		return accNSalesMap;
	}
}