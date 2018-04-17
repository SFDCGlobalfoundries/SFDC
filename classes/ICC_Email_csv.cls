/*
Class to execite the SOQL of Report_Subscription
It fetches the Account Share records of current subscriber and adds it to the WHERE clause 
so that only the legitimate records list are sent to the subscriber

Also, it forms the CSV to be fed into the VF page which will be sent to the subscriber as a CSV report.

Author: Rahul Majumder
Version 1.0
 Modified Date : Apr-26-2017
 Modified by   : Anil Kumar Reddy L
 Reason 	   : Modified the coloum header creation logic to show only field name.
 Modified Date : Apr-28-2017
 Modified by   : Anil Kumar Reddy L
 Reason 	   : Removed the additional date filter for Early warning.
 Modified Date : May-10-2017
 Modified by   : Anil Kumar Reddy L
 Reason 	   : Modified the logic to handle the Account to Object relationship change for External user.
 Modified Date : Sept-1-2017
 Modified by   : Amit Kumar Ojha
 Reason 	   : Modified the logic not to send mails to Subscribers who are able to see any records as part of the Sharing. 
*/
public without sharing class ICC_Email_csv 
{
    public static transient String lstColHeaders{get; private set;}  // Column Headers
    
    public static transient Map<Integer, List<String>> mapCSV{get;set;}
    public static transient List<Integer> lstInt {get;set;}
    
    public Integer totalRecords {get;set;}
    
    public ICC_Email_csv(){
		mapCSV = new Map<Integer, List<String>>();
		lstInt = new List<Integer>();

		lstColHeaders = '';
		String strFetchQueryString =  System.currentPageReference().getParameters().containsKey('query') ? System.currentPageReference().getParameters().get('query') : '';
		String strSubscriberID = System.currentPageReference().getParameters().containsKey('subscriber') ? System.currentPageReference().getParameters().get('subscriber') : '';
		String strMDFieldName = System.currentPageReference().getParameters().containsKey('mdField') ? System.currentPageReference().getParameters().get('mdField') : '';
		Set<Id> setAccIdsVisibleToSubscriber = new Set<Id>();
        // Query Account share records of current subscriber
		/** Start - L Anil Kumar Reddy - 10-5-2017 - External user shared records filter logic.*/
		strFetchQueryString = strFetchQueryString.toLowerCase();
		strFetchQueryString += ' ';
		String strObjectName = strFetchQueryString.toLowerCase().substringBetween('from ', ' ');

		Id grupId;
		List<user> usr = [SELECT AccountId,IsPortalEnabled,Name FROM USER WHERE ID = :strSubscriberID LIMIT 1];

		if(!usr.isEmpty() && usr.get(0).AccountId!=null){
			List<UserRole> usrRoleLst = [SELECT DeveloperName,Id,PortalRole,PortalAccountId FROM UserRole WHERE PortalAccountId = :usr.get(0).AccountId AND PortalRole = 'Worker'];
			if(!usrRoleLst.isEmpty()){
				List<Group> grpLst =  [SELECT Id,RelatedId,Type FROM Group WHERE RelatedId = :usrRoleLst.get(0).id AND Type = 'RoleAndSubordinates'];
				if(!grpLst.isEmpty()){
					grupId = grpLst.get(0).id;
				}
			}
		}
		String baseParentObj ;
		List<id> solObjLst = new List<id>();
		List<sObject> sObjResults = new List<sObject>();
		Map<String,ICC_Base_Master_Object_Field__c> iccBaseMasterCSMap = ICC_Base_Master_Object_Field__c.getAll();

		if(iccBaseMasterCSMap.containsKey(strObjectName) && !usr.isEmpty() && usr.get(0).AccountId != null && usr.get(0).IsPortalEnabled == true){
			String queryShare = 'SELECT ParentId FROM '+iccBaseMasterCSMap.get(strObjectName).ShareObject__c+' WHERE ';
			if(grupId!=null){
				queryShare += ' UserOrGroupId = :grupId OR ';
			}
			queryShare += ' UserOrGroupId = :strSubscriberID ';
			// Added by Amit
			
			if(queryShare != null && queryShare != '') {
				sObjResults = Database.query(queryShare);
			}
			
			if(!sObjResults.isEmpty()) {
	            for(Sobject shareObjRec : sObjResults){
	                solObjLst.add((id)shareObjRec.get('ParentId'));
				}
			}
			if(!solObjLst.isEmpty()) {
				if(strFetchQueryString.contains('where ')){
					strFetchQueryString += ' and '+iccBaseMasterCSMap.get(strObjectName).BaseMasterObjectIdField__c+' IN :solObjLst';
				}
				else{
					strFetchQueryString += ' where '+iccBaseMasterCSMap.get(strObjectName).BaseMasterObjectIdField__c+' IN :solObjLst';	
				}
			}
		} 
		else if(usr.get(0).IsPortalEnabled == false){
			/** End - L Anil Kumar Reddy - 10-5-2017 - External user shared records filter logic.*/
			for(AccountShare accShare : [SELECT AccountId FROM AccountShare 
										 WHERE UserOrGroupId =: strSubscriberID])
			{
				setAccIdsVisibleToSubscriber.add(accShare.AccountId); 
			}
			strFetchQueryString = strFetchQueryString.toLowerCase();
			// Add WHERE clause to filter only those records that should be visible to the current subscriber
			if(strMDFieldName != null && strMDFieldName != '')
			{
				if(strFetchQueryString.contains('where '))
					strFetchQueryString += ' and ' + strMDFieldName + ' IN :setAccIdsVisibleToSubscriber';
				else
					strFetchQueryString += ' where ' + strMDFieldName + ' IN :setAccIdsVisibleToSubscriber';
			}
		}
		// If the Report has an alert on it, the query will have another filter condition with those records which were created in the last 24 hours
		/** Start - L Anil Kumar Reddy - 28-4-2017 - Removed additional filter logic.*/
		// Check kept for early morning report (an additional condition must be added for this report)
		/** End - L Anil Kumar Reddy - 28-4-2017 - Removed additional filter logic.*/
		strFetchQueryString += ' LIMIT 50000';  // Add a limit to the SOQL. Since this SOQL will be called from a batch, limit kept is large
		strFetchQueryString = strFetchQueryString.toLowerCase();
		String strFieldNames =  strFetchQueryString.split('select ')[1].split('from ')[0]; // Get the field names to be included in report first row
		lstColHeaders = strFieldNames.trim().replaceAll('(\\s+)', ''); // Remove all spaces from the string

		List<String> lstTempString = new List<String>();
		Integer i = 1;
		List<sObject> sObjectResults = new List<sObject>();
		if(!sObjResults.isEmpty() && usr.get(0).IsPortalEnabled == true) {
			if(strFetchQueryString != null && strFetchQueryString != '') {
				sObjectResults = Database.query(strFetchQueryString);
			}
		} else if(usr.get(0).IsPortalEnabled == false) {
			if(strFetchQueryString != null && strFetchQueryString != '') {
				sObjectResults = Database.query(strFetchQueryString);
			}
		}
		// Execute the SOQL to fetch the actual report content
		if(!sObjectResults.isEmpty() && sObjectResults != null) {
			for(sObject s : sObjectResults){
	            /** Start - L Anil Kumar Reddy - 10-5-2017 - Modified CSV addition logic.*/
				// Get each row of the report as comma seprated values
				String strRow = '';
				for(String str_FldName : lstColHeaders.split(',')){
					List<String> lstFieldHierarchy = new List<String>();
					lstFieldHierarchy = str_FldName.split('\\.');
					
					if(lstFieldHierarchy.size() == 1){
						if(str_FldName.equalsIgnoreCase('Shipment_ID__c')) {
							strRow += (s.get(str_FldName.trim()) != null ? '"\'' + s.get(str_FldName.trim()) + '"\'' : '') + ',';
						} else {
							strRow += (s.get(str_FldName.trim()) != null ? '"' + s.get(str_FldName.trim()) + '"' : '') + ','; 
						}  
					}
					else if(lstFieldHierarchy.size() == 2){
						String Firstparent = lstFieldHierarchy[0].trim();
						String FirstParentField = lstFieldHierarchy[1].trim();
						if(str_FldName.equalsIgnoreCase('Shipment_ID__c')) {
							strRow += (s.getsObject(Firstparent).get(FirstParentField) != null ? '"\'' + s.getSobject(Firstparent).get(FirstParentField) + '"\'' : '') + ','; 
						} else {
							strRow += (s.getsObject(Firstparent).get(FirstParentField) != null ? '"' + s.getSobject(Firstparent).get(FirstParentField) + '"' : '') + ',';   
						}
					}
					else if(lstFieldHierarchy.size() == 3){
						String FirstParent = lstFieldHierarchy[0].trim();
						String SecondParent = lstFieldHierarchy[1].trim();
						String SecondParentField = lstFieldHierarchy[2].trim();
						if(str_FldName.equalsIgnoreCase('Shipment_ID__c')) {
							strRow += (s.getsObject(Firstparent).getSobject(SecondParent).get(SecondParentField) != null ? '"\'' +s.getSobject(Firstparent).getSobject(SecondParent).get(SecondParentField)+ '"\'' : '')+',';
						} else {
							strRow += (s.getsObject(Firstparent).getSobject(SecondParent).get(SecondParentField) != null ? '"'+s.getSobject(Firstparent).getSobject(SecondParent).get(SecondParentField)+ '"' : '')+','; 
						}
					}
					else if(lstFieldHierarchy.size() == 4){
						String FirstParent = lstFieldHierarchy[0].trim();
						String SecondParent = lstFieldHierarchy[1].trim();
						String ThirdParent = lstFieldHierarchy[2].trim();
						String ThirdParentField = lstFieldHierarchy[3].trim();
						if(str_FldName.equalsIgnoreCase('Shipment_ID__c')) {
							strRow += (s.getsObject(Firstparent).getSobject(SecondParent).getSobject(ThirdParent).get(ThirdParentField) != null ? '"\'' +s.getSobject(Firstparent).getSobject(SecondParent).getSobject(ThirdParent).get(ThirdParentField)+ '"\'' :'') + ',';
						} else {
							strRow += (s.getsObject(Firstparent).getSobject(SecondParent).getSobject(ThirdParent).get(ThirdParentField) != null ? '"'+s.getSobject(Firstparent).getSobject(SecondParent).getSobject(ThirdParent).get(ThirdParentField)+'"':'') + ','; 
						}
					}      
					else if(lstFieldHierarchy.size() == 5){
						String FirstParent = lstFieldHierarchy[0].trim();
						String SecondParent = lstFieldHierarchy[1].trim();
						String ThirdParent = lstFieldHierarchy[2].trim();
						String FourthParent = lstFieldHierarchy[3].trim();
						String FourthParentField = lstFieldHierarchy[4].trim();
						if(str_FldName.equalsIgnoreCase('Shipment_ID__c')) {
							strRow += (s.getsObject(Firstparent).getSobject(SecondParent).getSobject(ThirdParent).getSobject(FourthParent).get(FourthParentField) != null ? '"\'' + s.getSobject(Firstparent).getSobject(SecondParent).getSobject(ThirdParent).getSobject(FourthParent).get(FourthParentField) + '"\'' :'') +  ',';
						} else {
							strRow += (s.getsObject(Firstparent).getSobject(SecondParent).getSobject(ThirdParent).getSobject(FourthParent).get(FourthParentField) != null ? '"' + s.getSobject(Firstparent).getSobject(SecondParent).getSobject(ThirdParent).getSobject(FourthParent).get(FourthParentField) + '"':'') +  ','; 
						}
					}
				}      
				// Put 10000 records each into a map (map is used to prevent VF limit of only 10k records in a page. A map can by pass that limit)
				if(Math.mod(i, 10000) == 0){
					mapCSV.put(i, lstTempString);
					lstTempString = new List<String>();
				}
				strRow +='\n';
				/** End - L Anil Kumar Reddy - 10-5-2017 - Modified CSV addition logic.*/
				lstTempString.add(strRow);
				i++;
			}
			if(!lstTempString.isEmpty())
			{
				mapCSV.put(i, lstTempString);
			}
	        
			lstInt.addAll(mapCSV.keyset()); 
			/** Start - L Anil Kumar Reddy - 26-4-2017 - Modified the column header to retrive only the last/column name*/
			String lstColHeadersTemp= ''; //Temporary variable to hold the logic
			for(String col : lstColHeaders.split(',')){
				if(col!=null){
					List<String> column = col.split('\\.');
					lstColHeadersTemp+=(column[column.size()-1]).touppercase()+',';
				}
			}
	
			lstColHeaders = lstColHeadersTemp;
			lstColHeaders = lstColHeaders.trim();
			lstColHeaders = lstColHeaders.removeEnd(',');
			/** End  - L Anil Kumar Reddy - 26-4-2017 - Modified the column header to retrive only the last/column name*/
			lstColHeaders = lstColHeaders.replace('__c', '');  // Remove all __c to make the column headers a little more meaningful
			lstColHeaders = lstColHeaders.replace('__r.', '.');
			lstColHeaders = lstColHeaders.replace('_', ' ');
			/** Start - L Anil Kumar Reddy - 26-4-2017 - added new line charcter*/
			lstColHeaders += '\n';
			
			/** End - L Anil Kumar Reddy - 26-4-2017 - added new line charcter*/
		}
	}
	
	/*
	 * @Method Name : getSize
	 * @Parameters : String, String, String
	 * @Return Type : Integer
	 * @Description : Creating a Static Method if any records being shared with the current Subscriber
	 * @Created By : Amit Kumar Ojha
	 * @Created Date : 01-Sept-2017
	 */
	public static Integer getSize(String strFetchQueryString, String strSubscriberID, String strMDFieldName){
		mapCSV = new Map<Integer, List<String>>();
		lstInt = new List<Integer>();

		lstColHeaders = '';
		Set<Id> setAccIdsVisibleToSubscriber = new Set<Id>();
        // Query Account share records of current subscriber
		/** Start - L Anil Kumar Reddy - 10-5-2017 - External user shared records filter logic.*/
		strFetchQueryString = strFetchQueryString.toLowerCase();
		strFetchQueryString += ' ';
		String strObjectName = strFetchQueryString.toLowerCase().substringBetween('from ', ' ');

		Id grupId;
		List<user> usr = [SELECT AccountId,IsPortalEnabled,Name FROM USER WHERE ID = :strSubscriberID LIMIT 1];

		if(!usr.isEmpty() && usr.get(0).AccountId!=null){
			List<UserRole> usrRoleLst = [SELECT DeveloperName,Id,PortalRole,PortalAccountId FROM UserRole WHERE PortalAccountId = :usr.get(0).AccountId AND PortalRole = 'Worker'];
			if(!usrRoleLst.isEmpty()){
				List<Group> grpLst =  [SELECT Id,RelatedId,Type FROM Group WHERE RelatedId = :usrRoleLst.get(0).id AND Type = 'RoleAndSubordinates'];
				if(!grpLst.isEmpty()){
					grupId = grpLst.get(0).id;
				}
			}
		}
		String baseParentObj ;
		List<id> solObjLst = new List<id>();
		List<sObject> sObjResults = new List<sObject>();
		Map<String,ICC_Base_Master_Object_Field__c> iccBaseMasterCSMap = ICC_Base_Master_Object_Field__c.getAll();

		if(iccBaseMasterCSMap.containsKey(strObjectName) && !usr.isEmpty() && usr.get(0).AccountId != null && usr.get(0).IsPortalEnabled == true){
			String queryShare = 'SELECT ParentId FROM '+iccBaseMasterCSMap.get(strObjectName).ShareObject__c+' WHERE ';
			if(grupId!=null){
				queryShare += ' UserOrGroupId = :grupId OR ';
			}
			queryShare += ' UserOrGroupId = :strSubscriberID ';
			// Added by Amit
			
			if(queryShare != null && queryShare != '') {
				sObjResults = Database.query(queryShare);
			}
			
			if(!sObjResults.isEmpty()) {
	            for(Sobject shareObjRec : sObjResults){
	                solObjLst.add((id)shareObjRec.get('ParentId'));
				}
			}
			if(!solObjLst.isEmpty()) {
				if(strFetchQueryString.contains('where ')){
					strFetchQueryString += ' and '+iccBaseMasterCSMap.get(strObjectName).BaseMasterObjectIdField__c+' IN :solObjLst';
				}
				else{
					strFetchQueryString += ' where '+iccBaseMasterCSMap.get(strObjectName).BaseMasterObjectIdField__c+' IN :solObjLst';	
				}
			}
		} 
		else if(usr.get(0).IsPortalEnabled == false){
			/** End - L Anil Kumar Reddy - 10-5-2017 - External user shared records filter logic.*/
			for(AccountShare accShare : [SELECT AccountId FROM AccountShare 
										 WHERE UserOrGroupId =: strSubscriberID])
			{
				setAccIdsVisibleToSubscriber.add(accShare.AccountId); 
			}
			strFetchQueryString = strFetchQueryString.toLowerCase();
			// Add WHERE clause to filter only those records that should be visible to the current subscriber
			if(strMDFieldName != null && strMDFieldName != '')
			{
				if(strFetchQueryString.contains('where '))
					strFetchQueryString += ' and ' + strMDFieldName + ' IN :setAccIdsVisibleToSubscriber';
				else
					strFetchQueryString += ' where ' + strMDFieldName + ' IN :setAccIdsVisibleToSubscriber';
			}
		}
		// If the Report has an alert on it, the query will have another filter condition with those records which were created in the last 24 hours
		/** Start - L Anil Kumar Reddy - 28-4-2017 - Removed additional filter logic.*/
		// Check kept for early morning report (an additional condition must be added for this report)
		/** End - L Anil Kumar Reddy - 28-4-2017 - Removed additional filter logic.*/
		strFetchQueryString += ' LIMIT 50000';  // Add a limit to the SOQL. Since this SOQL will be called from a batch, limit kept is large
		strFetchQueryString = strFetchQueryString.toLowerCase();
		String strFieldNames =  strFetchQueryString.split('select ')[1].split('from ')[0]; // Get the field names to be included in report first row
		lstColHeaders = strFieldNames.trim().replaceAll('(\\s+)', ''); // Remove all spaces from the string

		List<String> lstTempString = new List<String>();
		Integer i = 1;
		List<sObject> sObjectResults = new List<sObject>();
		if(!sObjResults.isEmpty() && usr.get(0).IsPortalEnabled == true) {
			if(strFetchQueryString != null && strFetchQueryString != '') {
				sObjectResults = Database.query(strFetchQueryString);
			}
		} else if(usr.get(0).IsPortalEnabled == false) {
			if(strFetchQueryString != null && strFetchQueryString != '') {
				sObjectResults = Database.query(strFetchQueryString);
			}
		}
		return sObjectResults.size();
	}
}