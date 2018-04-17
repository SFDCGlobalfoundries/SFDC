@isTest(SeeAllData=false)
private Class FV_DeleteOperationTest{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Has_Valid_NDA__c', true);
        fieldValueMap.put('Tech_Geo_Granted__c','0.11UM;0.13UM;');
        fieldValueMap.put('Valid_Tech_Geos__c','0.11UM; 0.13UM;');
        
        AccountDataFactory.createAccount(fieldValueMap);
    }
    static testMethod void TeamRoomDocDeleteLogTriggerTest(){
        
        Account acc = getAccount('MYTEST ACCOUNT1');
        PDK__c pdk1 = getPdk();
        Package__c pkg = getPackage(acc);
        Sub_PDK__c subPdk = getSubPdk('pdk1','Specific Account Release',pdk1.Id,'Bundle1');
         
        Team_Room__c teamRoom = new Team_Room__c(Name ='TM1',Team_Room_Description__c='Test 1',OpenText_Id__c =111,Primary_Account__c=acc.id);  
        insert teamRoom;   
        
        Design_Spec__c dSpec1 = getDesignSpec('Release To White List','DRC','Spec1',pdk1.Id,1111,'0.1UM');
        List<Team_Room_Doc__c> teamRoomLst = new List<Team_Room_Doc__c>();
        
        Team_Room_Doc__c tDoc1 = getTeamRoomDocs(dSpec1.ID,null,null,teamRoom.Id);
        Team_Room_Doc__c tDoc2 = getTeamRoomDocs(null,subPdk.Id,null,teamRoom.Id);
        Team_Room_Doc__c tDoc3 = getTeamRoomDocs(null,null,pkg.Id,teamRoom.Id);
        Team_Room_Doc__c tDoc4 = getTeamRoomDocs(null,null,null,teamRoom.Id);
        
        teamRoomLst.add(tDoc1);
        teamRoomLst.add(tDoc2);
        teamRoomLst.add(tDoc3);
        teamRoomLst.add(tDoc4);
        
        insert teamRoomLst;
        
        Test.StartTest();
            delete teamRoomLst;
        Test.StopTest();
        
    }
    
    static testMethod void TeamRoomMemberDeleteLogTriggerTest(){
        
        Account acc = getAccount('MYTEST ACCOUNT1');
        Team_Room__c teamRoom = new Team_Room__c(Name ='TM1',Team_Room_Doc_Folder_Id__c=1234,Team_Room_Description__c='Test 1',OpenText_Id__c =111,Primary_Account__c=acc.id);  
        insert teamRoom;   
        
        Team_Room_Member__c TM = new Team_Room_Member__c(Team_Room__c= teamRoom.Id);
        insert TM;
        
        Test.StartTest();
            delete TM;
        Test.stopTest();
    }
    
    static testMethod void TeamRoomDeleteLogTriggerTest(){
    
        Test.StartTest();
        Account acc = getAccount('MYTEST ACCOUNT1');
        Team_Room__c teamRoom = new Team_Room__c(Name ='TM1',Team_Room_Doc_Folder_Id__c=1234,Team_Room_Description__c='Test 1',OpenText_Id__c =111,Primary_Account__c=acc.id);  
     
        insert teamRoom;    
        delete teamRoom;
            
        Test.StopTest();
    }
    
    static testMethod void PackageDeleteLogTriggerTest(){
        Test.StartTest();
             Account acc = getAccount('MYTEST ACCOUNT1');
            Package__c pkg = getPackage(acc);
            delete pkg;
        Test.StopTest();
    }
    
    static testMethod void PackageSpecDeleteLogTriggerTest(){
        
        Test.StartTest();
         Account acc = getAccount('MYTEST ACCOUNT1');
         Package__c pkg = getPackage(acc);
         PDK__c pdk1 = getPdk(); 
         Design_Spec__c dSpec1 = getDesignSpec('Release To White List','DRC','Spec1',pdk1.Id,1111,'0.1UM');
         Package_Spec__c pSpec= new Package_Spec__c(Name='package spec1',Package__c = pkg.Id,Design_Spec__c =dSpec1.Id); 
         insert pSpec;
         delete pSpec;
        Test.StopTest();
    }
    
    static testMethod void SubPDKSpecDeleteLogTriggerTest(){
        Test.StartTest();
            PDK__c pdk1 = getPdk(); 
            Design_Spec__c dSpec1 = getDesignSpec('Release To White List','DRC','Spec1',pdk1.Id,1111,'0.1UM');
            Sub_PDK__c subPdk = getSubPdk('pdk1','Specific Account Release',pdk1.Id,'Bundle1');
              
            Sub_PDK_Spec__c subPdkSpec = new Sub_PDK_Spec__c(Design_Spec__c =dSpec1.Id,Sub_PDK__c=subPdk.Id);
            insert subPdkSpec;
            
            delete subPdkSpec;
            
        Test.StopTest();
    }
    
    static testMethod void SubPDKDeleteLogTriggerTest(){
        Test.StartTest();
            PDK__c pdk1 = getPdk(); 
            Design_Spec__c dSpec1 = getDesignSpec('Release To White List','DRC','Spec1',pdk1.Id,1111,'0.1UM');
            Sub_PDK__c subPdk = getSubPdk('pdk1','Specific Account Release',pdk1.Id,'Bundle1');
            //insert subPdk;
            
            delete subPdk;
        Test.StopTest();
    }
    
    public static Team_Room_Doc__c getTeamRoomDocs(Id dSpec,Id subPdk,Id pkg,Id TMID){
        Team_Room_Doc__c tDoc = new Team_Room_Doc__c();
        
        tDoc.Design_Package__c = pkg;
        tDoc.Sub_PDK__c = subPdk;
        tDoc.Design_Spec__c = dSpec;
        tDoc.Team_Room__c = TMID;
        
        return tDoc;
    }
    
        
    private static Account getAccount(string AccountName){
                
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
    //prepare  Master PDK
    public static PDK__c getPdk(){
        
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421; 
        objPDK.PDK_DocTitle__c = '';
        objPDK.Tech_Geometry__c ='0.11UM;0.13UM;'; 
        insert objPDK;
        
        return objPDK;
    }
    
    // Prepare SubPDK
    public static Sub_PDK__c getSubPdk(String name, String rStatus,Id mPdkId,String bName){
        
        Sub_PDK__c objSubPDK = new Sub_PDK__c(); 
        objSubPDK.Name = name;
        objSubPDK.Release_Status__c = rStatus;
        objSubPDK.PDK__c = mPdkId;
        objSubPDK.Bundle_Name__c = bName+system.Now();
        //objSubPDK.tech_geometry__c = '0.11UM;0.13UM;';                             
        insert objSubPDK;
        
        return objSubPDK;
    }
    
    // Prepare designSpec
    public static Design_Spec__c getDesignSpec(String rStatus,String sType,String name,Id pdkID,Integer otId,String techGeo){
        
        Design_Spec__c objDesignSpec = new Design_Spec__c(); 
              
        objDesignSpec.OpenText_ID__c =otId;
        objDesignSpec.Name =name+system.now();
        objDesignSpec.Document_Title__c = 'Test Title'+system.now();
        objDesignSpec.Old_Revision_ID__c = 12345;
        objDesignSpec.ParentID__c = null;
        objDesignSpec.Document_Number__c = 'Test DocNum'+system.now();       
        objDesignSpec.Revision__c = 'test rev'+system.now();
        objDesignSpec.Lifecycle_Phase__c = 'test phase';
        objDesignSpec.Location_Fab__c = 'test fab';        
        objDesignSpec.Specification_Release_List_Long__c= 'intel;is';
        objDesignSpec.Functional_Ownership__c = 'test func owner';
        objDesignSpec.Specification_Type__c =sType;// 'DRC';White Papers
        objDesignSpec.Technology_Type__c = 'test tech type';
        objDesignSpec.Technology_Geometry__c =techGeo;
        objDesignSpec.Source__c = 'test source';
        objDesignSpec.PDK_Version__c = 'test pdkversion';
        objDesignSpec.DE_Version__c = 'test de version';
        objDesignSpec.Specification_sub_class__c = 'test subclass';
        objDesignSpec.Is_Latest_Revision__c = true;
        objDesignSpec.Specification_Owner__c = 'e13873';       
        objDesignSpec.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec.Release_Status__c = rStatus;
        objDesignSpec.pdk__c = pdkID;    
        
        insert objDesignSpec;
         
        return objDesignSpec;
    }
    
    public static Package__c getPackage(Account accntObj){
        
        Package__c objPck = new Package__c();
        objPck.Name = 'Test Name';
        objPck.Package_Release_Status__c = 'Release To White List';   
        objPck.Accounts_Provisioned_To__c = accntObj.Name;
        objPck.Tech_Geometry__c='0.11UM;0.13UM;';                                  
        insert objPck;
        
        return objPck;
    }
}