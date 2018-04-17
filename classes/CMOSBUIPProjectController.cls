global class CMOSBUIPProjectController {
	
    webservice static ResultWrapper createNewIPProject(string strIPRequestId) {
      
      if(!isAllowedtoCreateIPProject()){
      	String msg='You do not have the level of access necessary to perform the operation you requested. Please contact your administrator if access is necessary';
      	 return getResponseDetail(true,msg,null);
      }
      
        CMOS_BU_IP_Request__c objCMOSBUIPRequest = database.query(getbaseQuery());

        CMOS_BU_IP_Project__c objCMOSBUIPProject = new CMOS_BU_IP_Project__c();
        
        Map < string, string > mapRecordType = getRecordTypeByName('CMOS_BU_IP_Project__c');
        Map < string, string > mapIpRequestRecordType = getRecordTypeById('CMOS_BU_IP_Request__c');
        
        map < string, string > mapIPRequestobjectField =getObjectFieldsMap('CMOS_BU_IP_Request__c');

        String strIPReqRecordtype = (String)objCMOSBUIPRequest.get('recordtypeId');
        strIPReqRecordtype=mapIpRequestRecordType.get(strIPReqRecordtype);
        
        if (strIPReqRecordtype != null && mapRecordType.get(strIPReqRecordtype.toLowercase()) != null) {
            objCMOSBUIPProject.put('recordtypeId', mapRecordType.get(strIPReqRecordtype.toLowercase()));
        }

        Map < String, Schema.Sobjectfield > fields = Schema.SObjectType.CMOS_BU_IP_Project__c.fields.getMap();
        for (string str: fields.keySet()) {
            Schema.DescribeFieldResult obj = fields.get(str).getDescribe();
            
            Schema.sObjectField controllingObjectField=obj.getController();
            string controllingField=controllingObjectField!=null?controllingObjectField.getDescribe().getName():null;
            
            if (mapIPRequestobjectField.get(str)!=null && !obj.isAutoNumber() && obj.isCustom() && !obj.isNameField() && obj.isUpdateable() ) {
                if (objCMOSBUIPRequest.get(str) != null ) {
                  if(!obj.isRestrictedPicklist()&& controllingField==null){	
                    objCMOSBUIPProject.put(str, objCMOSBUIPRequest.get(str));
                  }else{
                  	Set<string> setPicklist=getPickListValue(obj);
                  	String strPicklistValue=(string)objCMOSBUIPRequest.get(str);
                  	
                  	if(controllingField==null && setPicklist!=null && setPicklist.contains(strPicklistValue)){
                  		objCMOSBUIPProject.put(str, strPicklistValue);
                  	}
                  	
                  	if(controllingField!=null){
                  	   Set<string> setCtrlPicklist=getPickListValue(controllingObjectField.getDescribe());
                  	   String strCtrlFieldPicklistValue=(string)objCMOSBUIPRequest.get(controllingObjectField.getDescribe().getName());
                  	   if(setCtrlPicklist!=null && setCtrlPicklist.contains(strCtrlFieldPicklistValue)){	
                  		 objCMOSBUIPProject.put(str, strPicklistValue);
                  	   }//return JSON.Serialize(setCtrlPicklist)+':'+strCtrlFieldPicklistValue;	
                  	}
                  
                  }
                }
            }
        }
      
      //needs to rollback if IP Request updation is failed due to validation rule 
      Savepoint sp = Database.setSavepoint();
      
      try{
       insert objCMOSBUIPProject;
       
       objCMOSBUIPRequest.IP_Project__c=objCMOSBUIPProject.id;
       update objCMOSBUIPRequest;
      }catch(DmlException ex){
      	Database.rollback(sp);
      	 return getResponseDetail(true,ex.getDmlMessage(0),null);
      }
       // return JSON.Serialize(objCMOSBUIPProject);
       // return objCMOSBUIPProject.id;
       return getResponseDetail(false,null,objCMOSBUIPProject.id);
    }
    
    private static ResultWrapper getResponseDetail(boolean isErrorFound,string strErrorMessage,string strReordId){
    	return new ResultWrapper(isErrorFound,strErrorMessage,strReordId);
    }
    
    public static boolean  isAllowedtoCreateIPProject(){
    	boolean isAllowed=false;
    	try{
    	PermissionSetAssignment obj=[Select PermissionSetId From PermissionSetAssignment 
    	                             where PermissionSet.Name='CMOS_BU_IP_Project_Manager' and AssigneeId=:UserInfo.getUserId()];
    	isAllowed=true;
    	}catch(exception ex){}
    
       if(Test.isRunningTest()){
       	  //We can't assign permssion set in test method because of MIXED_DML_OPERATION
       	  isAllowed=true;
       }	
    		
      return isAllowed;
    }

    public static string getbaseQuery() {
        string strQuery = 'Select recordtype.name , {0} from CMOS_BU_IP_Request__c where id=:strIPRequestId';

        return String.format(strQuery, new List < String > { getObjectFields() });

    }
   
   public static map <string, string >  getObjectFieldsMap(string objectName) {
        map < string, string > mapobjectField = new map < string, string > ();
       
        Schema.SObjectType sot = ((SObject) Type.forName(objectName).newInstance()).getSobjectType();
       
        for (string str: sot.getdescribe().fields.getMap().keySet()) {
            mapobjectField.put(str,str); 
        }
        return mapobjectField;
    }
   
   
    public static string getObjectFields() {
        String fieldnames = '';

        for (string str: Schema.SObjectType.CMOS_BU_IP_Request__c.fields.getMap().keySet()) {
            fieldnames = fieldnames + str + ',';
        }
        return fieldnames.removeEndIgnoreCase(',');
    }

    public static Map < string, string > getRecordTypeByName(string objectName) {
    	
        map < string, string > mapRecordType = new map < string, string > ();
        
        Schema.SObjectType sot = ((SObject) Type.forName(objectName).newInstance()).getSobjectType();

        Map < String, Schema.RecordTypeInfo > rtMapByName = sot.getdescribe().getRecordTypeInfosByName();

        for (string str: rtMapByName.keySet()) {
            mapRecordType.put(str.toLowercase(), rtMapByName.get(str).getRecordTypeId());
        }

        return mapRecordType;
    }
    
      public static Map < string, string > getRecordTypeById(string objectName) {
    	
        map < string, string > mapRecordType = new map < string, string > ();
        
        Schema.SObjectType sot = ((SObject) Type.forName(objectName).newInstance()).getSobjectType();

        Map < String, Schema.RecordTypeInfo > rtMapByName = sot.getdescribe().getRecordTypeInfosByName();

        for (string str: rtMapByName.keySet()) {
            mapRecordType.put(rtMapByName.get(str).getRecordTypeId(),str.toLowercase());
        }

        return mapRecordType;
    }
    
    public static set<string> getPickListValue(Schema.DescribeFieldResult fieldResult){
    	
    	Set<string> setPicklist=new set<string>();
    	 for( Schema.PicklistEntry pickListVal : fieldResult.getPicklistValues()){
    	   setPicklist.add(pickListVal.getLabel());	
    	 }
    	return setPicklist;
    }

 global class ResultWrapper{
	webservice boolean isErrorFound;
	webservice string strErrorMessage;
	webservice string strReordId;
	
	public ResultWrapper(boolean isErrorFound,string strErrorMessage,string strReordId){
		this.isErrorFound=isErrorFound;
		this.strErrorMessage=strErrorMessage;
		this.strReordId=strReordId;
	}
  }

}