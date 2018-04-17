/*
    Class Name:    BX041Clone
    Author:        Prosenjit Saha(PS) and Thomas Lai(TL)
    Description:   This Class clones BX041 record with all the child object data and update opportunity program team membet based on PIYE approvers of CDRS
    History: 
      PS        13092013    - Code creation.
      TLai      03042014    - Added logic to copy cdrs FOR PTRF/NPC generated retrofit Device  or Revise Device as per case 6114
      Tlai      09052014    - Reset status to initial stage for copied device as per case ?
      ZAmbat    05152014    - Updated code to make methods static and cloneBX041Method as @future.
      DBiswal   02022015    - Updated code to reset cdrs status when reason for new part of NPC Form is 'Fab to Fab Transfer' or 'Change in PID'.      
	  Vijay		03122015	- updated the code support the Internal Device CDRS clone functionality. added the record type check and shared the Internal Device with PIYE
      						  users.	
*/

public class BX041Clone {
    private map<BX_041__c ,Device__c> mSrcCdrs2TgtDev = new map<BX_041__c ,Device__c>();
    private map<String,Device__c> mSrcDevId2TgtDev = new map<String,Device__c>();
    private map<id,BX_041__c > mSrcCDRS2TgtCDRS = new map<id,BX_041__c>();
    private list<id> lSrcCDRS = new List<id>();
    
    /*
        This method is used to clone BX041 and its child object data from the existing BX041 source record. 
        
        @method name: cloneBX041Method
        @parameters:  It takes the List of cloned devices
        @return :     void    
    */  
    @future(callout=false)
    public static void cloneBX041Method(Set<Id> setDeviceID){
        /*  
         *  Step 1: 
         *  Identify Copied/Revise/Retrofit Device
         *  preparing map mSrcDevId2TgtDev (source device ID VS target device)
         */
        map<String,Device__c> mSrcDevId2TgtDev = new map<String,Device__c>();
        map<BX_041__c ,Device__c> mSrcCdrs2TgtDev = new map<BX_041__c ,Device__c>();
        map<id,BX_041__c > mSrcCDRS2TgtCDRS = new map<id,BX_041__c>();
        list<id> lSrcCDRS = new List<id>();
        Boolean cloneChild = false;
        
        List<Device__c> listDeviceID = [
            SELECT      Id
                        , Name
                        , Copied_Device__c
                        , device_type__c
                        , NPC_Form_Originating_Device__c
                        , Base_Device__c
                        , CRMDID__c
                        , Geometry_Filter__c
                        , Process_Family_Filter__c
                        , Opportunity_Program__c
                        , RecordType.DeveloperName
            FROM        Device__c
            WHERE       Id IN :setDeviceID
        ];
        
        for(Device__c device : listDeviceID){
            if(device.Copied_Device__c != null && device.device_type__c == 'Base'){
                mSrcDevId2TgtDev.put(device.Copied_Device__c, device);
            }
            //Tlai 03042014 Added logic for PTRF/NPC generated retrofit Device  or Revise Device
            else if(device.Base_Device__c != null && device.device_type__c == 'Revision'){
                mSrcDevId2TgtDev.put(device.Base_Device__c, device);
            }
            else if(!String.isBlank(device.NPC_Form_Originating_Device__c) && device.device_type__c == 'Retrofit'){
                mSrcDevId2TgtDev.put(device.NPC_Form_Originating_Device__c, device);
            }
        }
        
        if(mSrcDevId2TgtDev.size() > 0){
            /*  
             *  Step 2: 
             *  Retrieve source CDRS records of source Devices 
             *  prepare map mSrcCdrs2TgtDev (Source cdrs VS target device)
             *  
             */
            string strQuery = BX041Clone.getAllFieldsSOQL('BX_041__c','where Device__c IN : XXX' );
            set<String> sSrcDevId = mSrcDevId2TgtDev.keySet();
            list<BX_041__c> cdrsList = (list<BX_041__c>)database.query(strQuery.replace('XXX','sSrcDevId'));
            
            if(cdrsList.size()>0){
                for(BX_041__c bx : cdrsList){
                    mSrcCdrs2TgtDev.put(bx,mSrcDevId2TgtDev.get(bx.Device__c)); 
                    lSrcCDRS.add(bx.id);
                }
            }
            
            set<id> sCdrsId2ClearPIYE = new set<id>();
            if(mSrcCdrs2TgtDev.size() > 0 && lSrcCDRS.size() > 0){ //if NO BX041 record is associated
                /*  
                 *  Step 2.1: 
                 *  Loop keyset of map mSrcCdrs2TgtDev
                 *  Clone source CDRS and populate target CDRS
                 *  prepare map mSrcCDRS2TgtCDRS (Source cdrs VS target cdrs)
                 */
                map<id,set<id>> mOppGrm2Piye = new map<id,set<id>>();
                Map<Id, Set<Id>> deviceIdPIYEIdsMap = new Map<Id, Set<Id>>();
                
                for(BX_041__c  srcCDRS : mSrcCdrs2TgtDev.keyset()){
                    BX_041__c newCDRS = new BX_041__c ();   
                    newCDRS = srcCDRS.clone(false,true);  
                    Device__c tgtDev = mSrcCdrs2TgtDev.get(srcCDRS);
                    newCDRS.device__c =   tgtDev.id;
                    newCDRS.CRMDID__c = tgtDev.CRMDID__c ;
                    newCDRS.Geometry_Filter__c = tgtDev.Geometry_Filter__c == null? srcCDRS.Geometry_Filter__c:tgtDev.Geometry_Filter__c ;
                    newCDRS.Process_Family_Filter__c = tgtDev.Process_Family_Filter__c == null? srcCDRS.Process_Family_Filter__c: tgtDev.Process_Family_Filter__c;
                    
                    if((newCDRS.BX_041_Opportunity_Program__c == null && tgtDev.Opportunity_Program__c != null) && 
                    	(tgtDev.RecordType.DeveloperName == 'Device' || tgtDev.RecordType.DeveloperName  == 'Read_Only')){
                    	System.debug('---------In set Opportunity Program loop-----------');	
                        newCDRS.BX_041_Opportunity_Program__c = tgtDev.Opportunity_Program__c;
                    }
                    
                    /*  
                     *  Step 2.2: 
                     *  Clear Assigned Process ID and other info of target CDRS if calling from copyDevice function or CDRS is not closed.
                     */
                    //Tlai: for copied device, keep request PID and reset target CDRS to intiial stage
                    //Tlai: for revise and retrofit device, if Source CDRS is not closed, do the same as copeid device above. else copy all the info of source CDRS
                    if(tgtDev.device_type__c == 'Base' || srcCDRS.BX_041_Status__c != 'Closed' ){
                        BX041Clone.resetCDRS(newCDRS);// Tlai 09052014
                        sCdrsId2ClearPIYE.add(srcCDRS.id);
                    } 
                    /*else if(tgtDev.device_type__c != 'Base' && srcCDRS.BX_041_Status__c != 'Closed'){
                        resetCDRS(newCDRS);
                        newCDRS.Assigned_Process_ID__c = null;
                        sCdrsId2ClearPIYE.add(srcCDRS.id);
                    } */
                    
                    /*  Step 2.3: 
                     *  Retrieve PIYE approver of CDRS if target CDRS is approved by PIYE
                     *  prepare map mOppGrm2Piye (opportunity program vs PIYE approver's userid set)
                    */
                    if(newCDRS.BX_041_Status__c != 'Pending Submission' && newCDRS.BX_041_Status__c != 'Pending Review' && (newCDRS.Approver_1__c != null ||newCDRS.Approver_2__c !=null||newCDRS.Approver_3__c != null)){
                        set<id> sPiye = new set<id>();
                        for(integer i = 1; i <=3; i++){
                            if(newCDRS.get('Approver_'+i+'__c') != null){
                                sPiye.add((Id)newCDRS.get('Approver_'+i+'__c'));
                            }
                        }
                        if(sPiye.size() >0){
                        	//added by Vijay 03052015 - added the Record type check and if it is Internal device, it will be shared with PIYE
                            if(tgtDev.RecordType.DeveloperName == 'Device' || tgtDev.RecordType.DeveloperName  == 'Read_Only'){
	                            if(mOppGrm2Piye.containsKey(newCDRS.BX_041_Opportunity_Program__c)){
	                                mOppGrm2Piye.get(newCDRS.BX_041_Opportunity_Program__c).addAll(sPiye);
	                            }else {
	                                mOppGrm2Piye.put(newCDRS.BX_041_Opportunity_Program__c, sPiye);
	                            }
                            }else{
                            	if(!deviceIdPIYEIdsMap.containsKey(tgtDev.Id)){
                            		deviceIdPIYEIdsMap.put(tgtDev.Id, sPiye);
                            	} 
                            	deviceIdPIYEIdsMap.get(tgtDev.Id).addAll(sPiye);
                            }
                        }
                            
                    }
                    
                    //DBiswal 02022015
                    map<BX_041__c ,Device__c> mapCdrsStatusCheck = new map<BX_041__c ,Device__c>();
                    mapCdrsStatusCheck.put(newCDRS,tgtDev);
                    cloneChild = BX041Clone.CdrsStatusCheck(mapCdrsStatusCheck, cloneChild);                     
                                       
                    mSrcCDRS2TgtCDRS.put(srcCDRS.id,newCDRS);
                }
                
                /*  
                 *  Step 2.4: 
                 *  insert target CDRS
                 *  mSrcCDRS2TgtCDRS.values()
                 */
                //inserting new CDRS records for the target device.
                system.debug('mSrcCDRS2TgtCDRS size =====================> ' + mSrcCDRS2TgtCDRS.size());
                system.debug('mSrcCDRS2TgtCDRS before insert =====================> ' + mSrcCDRS2TgtCDRS);
                if(mSrcCDRS2TgtCDRS.values().size() > 0)
                    insert mSrcCDRS2TgtCDRS.values();
                    system.debug('mSrcCDRS2TgtCDRS after insert =====================> ' + mSrcCDRS2TgtCDRS);
                /*  
                 *  Step 3: 
                 *  create all Child data of source CDRS
                 *  
                 */
                List <String> lSobj = new String[]{'Process_Information__c', 'Gap_Analysis_Form__c', 'MEMS__c', 'PowerMOS__c', 'Turnkey__c', 'RF__c', 'High_Voltage__c', 'eDRAM__c', 'Non_Volatile_Memory__c', 'BX041_IP__c', 'BX041_IP_Merge__c'};
                
                Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
                Map<String , Map<String,Schema.SObjectField> > mapObj_FielMap = new Map<String , Map<String,Schema.SObjectField> >();
                
                for(String objName : lSobj){        
                    Schema.SObjectType sobjType = gd.get(objName);
                    Schema.DescribeSObjectResult r = sobjType.getDescribe();
                    Map<String,Schema.SObjectField> M = r.fields.getMap();
                    mapObj_FielMap.put(objName , M);
                }
                
                List<SObject> sObjectDataList = new List<SObject>();
                for(String objName : lSobj){
                    /*  Step 3.1: 
                     *  retrieve child records of source CDRS based on generic query
                     *  populate list sObjectDataList
                     */
                    Set<String> sFieldName = mapObj_FielMap.get(objName).keyset();
                    List<String> fields = new List<String>(sFieldName);
                    String strFields = String.join (fields, ',');
                    String querystr = 'SELECT ' + strFields +'  FROM  '+ objName + ' WHERE  BX_041__c IN : XXX' ; 
                    list<Sobject> listsobj  = database.query(querystr.replace('XXX','lSrcCDRS'));
                    if(listsobj.size() > 0)
                        sObjectDataList.addAll(listsobj);
                }
                
                List<sObject> finalSobjList1 = new List<sObject>();
                List<sObject> finalSobjList2 = new List<sObject>();//salesforce can insert only 10 object at a time.That's why it has been instantiated. 
                integer objectTypeNo = 0;
                for(integer i=0; i<sObjectDataList.size(); i++ ){
                    Sobject sobj = sObjectDataList[i];
                    
                    /*  Step 3.2: 
                    *   clone child records of source CDRS and populate target child records with target CDRS id
                    *   
                    */
                    sObject tempsobj = Schema.getGlobalDescribe().get(String.valueof(sobj.getsObjectType())).newSObject();
                    //DBiswal 02042015
                    if(cloneChild == true && (sobj.getsObjectType() == Process_Information__c.getsObjectType() || sobj.getsObjectType() == Gap_Analysis_Form__c.getsObjectType())){
                        //tempsobj = tempsobj;
                        tempsobj = sobj.clone(false, true);
                        if (sobj.getsObjectType() == Process_Information__c.getsObjectType()) {
                            tempsobj.put('PIYE__c', null);
                        } else if (sobj.getsObjectType() == Gap_Analysis_Form__c.getsObjectType()) {
                            tempsobj.put('APTS_Status__c', null);
                            tempsobj.put('APTS_Comments__c', null);
                            tempsobj.put('APTS_Resolution__c', null);
                        }
                    } else{
                        tempsobj = sobj.clone(false,true); 
                    }
                    tempsobj.put('BX_041__c',mSrcCDRS2TgtCDRS.get((Id)sobj.get('BX_041__c')).id);
                    
                    /*  Step 3.3: 
                    *   clear PIYE columns of Process Information in target CDRS 
                    *   if it is retrofit or revise device and cdrs status is not closed
                    */
                    if(sobj.getsObjectType() == Process_Information__c.getsObjectType() && sCdrsId2ClearPIYE.contains((Id)sobj.get('BX_041__c')) ){
                        // PIYE comments should be balnk in the process information secton of the new request
                        tempsobj.put('PIYE__c',null);   
                    }
                    /*  Step 3.4: 
                    *   populate list finalSobjList1 and finalSobjList2 for new child record of target CDRS
                    *
                    */
                    if(i == 0 || sobj.getsObjectType() != sObjectDataList[i-1].getsObjectType()){
                        objectTypeNo++;
                    }
                    if(objectTypeNo <= 10){
                        finalSobjList1.add(tempsobj);   //first 10 objectType data have been added in the instance - finalSobjList1
                    }
                    else{
                        finalSobjList2.add(tempsobj);   //rest of the object data have been added in the instance - finalSobjList2
                    }
                    
                    system.debug('objectTypeNo =====================> ' + objectTypeNo);
                }       
                /*  Step 3.5: 
                *   insert new child records of target CDRS
                *
                */  
                system.debug('finalSobjList1 =======================> ' + finalSobjList1.size());
                system.debug('finalSobjList2 =======================> ' + finalSobjList2.size());
                if(finalSobjList1.size() > 0)   
                    insert finalSobjList1; 
                if(finalSobjList2.size() > 0)   
                    insert finalSobjList2;   
                
                /*  Step 4: 
                 *  Create Opportunity Promgram Team Member based on PIYE approvers
                */  
                list<Opportunity_Program_Team_Member__c> lOptm = new list<Opportunity_Program_Team_Member__c>();
                
                if(mOppGrm2Piye.size() > 0){
                    /*  Step 4.1: 
                     *  Retrieve exsiting Opportunity Promgram Team Member of PIYE approvers
                     *  Add team member into list lOptm for update
                    */
                    for(Opportunity_Program_Team_Member__c optm : [select id , User__c, Team_Role__c, Device_Access__c, Opportunity_Program_Access__c,Opportunity_Program__c
                                                                    from Opportunity_Program_Team_Member__c
                                                                    where Opportunity_Program__c in : mOppGrm2Piye.keyset()
                                                                    ]){
                            set<id> sPiye = mOppGrm2Piye.get(optm.Opportunity_Program__c);
                            if(spiye.size() >0 && sPiye.contains(optm.user__c) ){
                                if(optm.Team_Role__c != 'TD PI / YE' || optm.Device_Access__c != 'Read/Write'|| optm.Opportunity_Program_Access__c != 'Read/Write'){
                                    optm.Team_Role__c = 'TD PI / YE';
                                    optm.Device_Access__c = 'Read/Write';
                                    optm.Opportunity_Program_Access__c = 'Read/Write';
                                    lOptm.add(optm);
                                }
                                
                                sPiye.remove(optm.user__c);
                            }                       
                    }
                    /*  Step 4.2: 
                     *  add new team member into list lOptm for insert
                    */
                    for(id optmId : mOppGrm2Piye.keyset()){
                        if(mOppGrm2Piye.get(optmId).size() > 0){
                            for(id usrId : mOppGrm2Piye.get(optmId)){
                                Opportunity_Program_Team_Member__c  newOptm = new Opportunity_Program_Team_Member__c();
                                newOptm.User__c = usrId;
                                newOptm.Team_Role__c = 'TD PI / YE';
                                newOptm.Opportunity_Program__c = optmId;
                                newOptm.Device_Access__c = 'Read/Write';
                                newOptm.Opportunity_Program_Access__c = 'Read/Write';
                                lOptm.add(newOptm);
                            }
                        }
                    }
                    
                    /*  Step 4.3: 
                     *  upsert team member in the list lOptm
                    */
                    if(lOptm.size()>0){
                        upsert lOptm;
                    }
                }
                
                /*
                 *Step 4: for Internal Device
                 *
                 */
                 if(!deviceIdPIYEIdsMap.isEmpty()){
                 	System.debug('------------------'+deviceIdPIYEIdsMap);
                 	List<Device__Share> deviceShareList = new List<Device__Share>();
                 	for(Id deviceId:deviceIdPIYEIdsMap.Keyset()){
                 		Set<Id> piyeSet = deviceIdPIYEIdsMap.get(deviceId);
                 		for(Id piyeId: piyeSet){
                 			deviceShareList.add(new Device__Share(ParentId = deviceId, UserOrGroupId = piyeId, AccessLevel = 'Read'));
                 		}
                 	}
                 	if(!deviceShareList.isEmpty()){
                 		System.debug('-------deviceShareList-----------'+deviceShareList);
                 		insert deviceShareList;
                 	}
                 }
            }             
        }
    } // cloneBX041Method method ends here.
    /*
        This method is used to create dynamic soql string 
        @method name: getAllFieldsSOQL
        @parameters:  String ObjectName, String whereClause
        @return :     String    
    */  
    // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
    public static string getAllFieldsSOQL(String objectName, String whereClause){
         
        String selects = '';
         
        if (whereClause == null || whereClause == ''){ return null; }
         
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
         
        if (fieldMap != null){
            for (Schema.SObjectField sField : fieldMap.values()){ // loop through all field tokens (sField)
                Schema.DescribeFieldResult dfr = sField.getDescribe(); // describe each field (dfr)
                //if (dfr.isCreateable()){ // field is creatable
                    selectFields.add(dfr.getName());
                //}
            }
        }
         
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
             
        }
         
        String result =  'SELECT ' + selects + ' FROM ' + objectName + ' '+ whereClause;
        system.debug(logginglevel.error,  result);
        return result;
         
    }
    
    /*
        This method is used to reset CDRS to initial stage 
        @method name: resetCDRS
        @parameters:  BX_041__c cdrs
        @return :     void    
    */  
    private static void resetCDRS(BX_041__c cdrs){
        cdrs.Approver_1__c = null;
        cdrs.Approver_2__c = null;
        cdrs.Approver_3__c = null;
        cdrs.Approver_4__c = null;
        cdrs.Approver_5__c = null;
        cdrs.Approver_6__c = null;
        cdrs.Approver_7__c = null;
        cdrs.Approver_8__c = null;
        cdrs.Approver_9__c = null;
        cdrs.Approver_10__c = null;
        cdrs.Assigned_Process_ID__c = null;
        cdrs.BX_041_Status__c = 'Pending Submission';
        cdrs.Approval_Step__c = null;
        cdrs.Approval_Status__c = null ;
        cdrs.initial_submitter__c = null;
        cdrs.Next_WorkItem_Id__c = null;
}
    
    /*
        This method is used to reset CDRS Status value 
        @method name: CdrsStatusCheck
        @parameters:  map<BX_041__c ,Device__c>
        @return :     void    
    */
    public static Boolean CdrsStatusCheck(map<BX_041__c ,Device__c> mapCdrsStatusCheck,Boolean cloneChild){
        Device__c device = [SELECT Id, NPC_Form__r.Reason_for_New_Part__c FROM Device__c WHERE Id IN: mapCdrsStatusCheck.values()];
        
        for(BX_041__c cdrs : mapCdrsStatusCheck.keyset()){
            if(device.NPC_Form__r.Reason_for_New_Part__c == EnvironmentVariable.get('NPC_REASON_FAB_TRANSFER')
               || device.NPC_Form__r.Reason_for_New_Part__c == EnvironmentVariable.get('NPC_REASON_CHANGE_PID')){
               cloneChild = true;
               BX041Clone.resetCDRS(cdrs);
            }
        }  
        //DBiswal 02042015          
        return cloneChild;
    }
    
} // class ends here