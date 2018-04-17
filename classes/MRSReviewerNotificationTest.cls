/*
    Author: Cognizant
    Description: Apex test class for Reviewer Notification
    History: 
    Saurav      22/05/2014    - Apex code created
    
*/
@istest(SeeAllData=false)
public class MRSReviewerNotificationTest {
    
    /**
        @Method Name: createTestContact
        @Return type: List<Contact>
        @Parameters: Account acc, integer iNumberOfContact
        @Description: Creates contacts associated withe account passed as parameter.
    **/
    public static List<Contact> createTestContact(Account acc, integer iNumberOfContact){
        Contact con=new Contact();
        List<Contact> newContactList=new List<Contact>();
        
        for (Integer iCount=0;iCount<iNumberOfContact;iCount++){
            con = new Contact(
                firstName = 'test' + String.valueOf(iCount), 
                lastName = 'test' + String.valueOf(iCount),
                Email='con' + String.valueOf(iCount)+'@gf.com', 
                Department__c='Design;Procurement',
                accountId = acc.id,
                Is_Portal_User_Active__c = true,
                Is_Portal_User_Created__c = true
                
            );
            newContactList.add(con);
            
        }
        insert newContactList;
        return newContactList;
    }
    
    
    static Mask_Set_Title__c createMaskSetTitle(){
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        
        fieldValueMap.put('Name', 'MST0010');
        fieldValueMap.put('Description__c', 'Test Description for MST');
        fieldValueMap.put('Synced_with_Oracle_DB__c', false);
        fieldValueMap.put('Status__c', 'Active');
        fieldValueMap.put('Is_Available_For_Use__c', true);
        fieldValueMap.put('Manual_Creation__c', false);
        fieldValueMap.put('Reticle_Type__c', 'Single Layer Reticle (SLR)');
        
        return MaskSetTitleDataFactory.createMaskSetTitle(fieldValueMap);
        
    }
    
    /**
        @Method Name: createDevicePT1
        @Return type: Device__c
        @Parameters: Id testAcctId, Id testOpptyProgramId, Id ProcessTechnologyId, Id OpprId
        @Description: Creates device and associates with the acount, opportunity program, process technology and opportunity
    **/
   /* public static Device__c createDevicePT1(Id testAcctId, Id testOpptyProgramId, Id ProcessTechnologyId, Id OpprId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'Fab 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'DVMST12345';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.PTRF_ID__c = 'PTRF123';
        
        device.Confidence_Level_Tapeout__c = '100';
        device.Device_Sourcing__c = 'First Source';
        device.End_Application__c = 'Body';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Original_Forecasted_Tapeout_Date__c = date.today();
        device.Semiconductor_Device__c = 'Analog - Amplifier';
        device.Process_Technology_2__c = ProcessTechnologyId;
        device.Opportunity2__c=OpprId;
        insert device;
        
        return device;
    }*/
    
    
    public static Account accountObj;
    /**
        @Method Name: TestReviewerNotificationAccountInsert
        @Return type: null
        @Parameters: null
        @Description: creates account for test class
    **/
    public static  void TestReviewerNotificationAccountInsert(){
                SwiftDataUtilityTest.customSystemData();
                accountObj = SwiftDataUtilityTest.createTestAccountForDRT();
                
                System.assertNotEquals(accountObj,null);
                accountObj.stage__c = 'Qualified';
                update accountObj;
                
    }
    static{
        TestReviewerNotificationAccountInsert();
    }
    
    /**
        @Method Name: reviewerNotificationTest
        @Return type: null
        @Parameters: null
        @Description: Test method for Reviewer Notification
    **/
    public static testMethod void reviewerNotificationTest(){
       
       
        
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser){
        list<User> listUser = new list<User>();       
        Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
        UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
        
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id, UserRoleId = usrRole.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        
        User userSU = new User(alias = 'testMRS2', email='testMRS2@test.com',
        emailencodingkey='UTF-8', lastname='testMRS2Last', firstname='testMRS2First', languagelocalekey='en_US',
        localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS2@test.com',communitynickname='testMRS2'); 
        
        User userSUFE = new User(alias = 'testMRS3', email='testMRS3@test.com',
        emailencodingkey='UTF-8', lastname='testMRS3Last', firstname='testMRS3First', languagelocalekey='en_US',
        localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS3@test.com',communitynickname='testMRS3');   
        
        listUser.add(userSA);
        listUser.add(userSU);
        listUser.add(userSUFE); 
        insert listUser; 
        
        List<GroupMember> groupMemberList = new List<GroupMember>();  
        List<Group> groupList = [select Id, DeveloperName, Name from Group where DeveloperName IN ('SWIFT_Admin','Swift_GlobalShuttle','Swift_MDP','Swift_Tapeout_Application','Swift_Tapeout_Centre','Swift_TDTI_MPW')]; 
        for(Group grpObj : groupList){
            GroupMember groupMember = new GroupMember();           
            groupMember.GroupId = grpObj.Id;
            groupMember.UserOrGroupId = sysAdminUser.Id;
            groupMemberList.add(groupMember);
        }
        insert groupMemberList;
       
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSUFE.id,Account__c=accountObj.id,Account_Access__c='Read/Write',
        Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
        insert atp;
                    
    
    
    
        insertSwiftPublicGroupNotification();
        
       
      Test.startTest();
       
      List<Contact> lstContact   = createTestContact(accountObj,5);
      
      
      
      Mask_Set_Title__c objMST = MRSReviewerNotificationTest.createMaskSetTitle();
      //insert objMST;
      
     // List<Mask_Set_Title__c> lstMST =[select name from Mask_Set_Title__c limit 1 ];
      
      
             
      MRS__c mrs= MRSDataUtilityTest.createTestMRS(objMST.id);
      List<MRS__c> lstMRS = [select id,name from MRS__c limit 1 ];
     
      
      MRS_Layer_Association__c mrsLA=MRSDataUtilityTest.createTestMRSLayerAssociation(mrs.Id);
      List<MRS_Layer_Association__c> lstMLA = [select name from MRS_Layer_Association__c limit 1 ];
     
      
      MRS_Chip_Details__c mrsCD=MRSDataUtilityTest.createTestMRSChipDetails(mrs.Id);
      
      List<MRS_Chip_Details__c> lstMCD = [select name from MRS_Chip_Details__c limit  1];
      
      
      
       
        PTRF__c PTRFobj = new PTRF__c();
        PTRFobj.Name = 'PTRF 1';
        PTRFobj.Order_Type__c = 'Test Order Type';
        PTRFobj.Recticle_Type__c = 'Single Layer Reticle (SLR)';
        PTRFobj.MaskSetTitle__c = objMST.Id;
        PTRFobj.tech_Geo_Value__c = '0.019UM';
        insert PTRFobj;
        
        List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
        PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=PTRFobj.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id,Last_Notified__c=null);
        PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=PTRFobj.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id,Last_Notified__c=null);
        listPTRFJVI.add(objPTRFJVC);
        listPTRFJVI.add(objPTRFJVF);
        insert listPTRFJVI;
     
        System.assertEquals('PTRF 1',PTRFobj.Name);
      
      

    
      List<MRS_Layer_Chip_Association__c> mrsLayerChipAssolst = new List<MRS_Layer_Chip_Association__c>();
          
        
        MRS_Layer_Chip_Association__c objmlca = new MRS_Layer_Chip_Association__c();
        objmlca.Customer_Name__c = accountObj.Id;
        objmlca.PTRF__c = PTRFobj.Id;
        objmlca.Layer__c = mrsLA.Id;
        objmlca.Chip__c = mrsCD.Id;
        objmlca.Customer_GDSOUT_Review__c = 'Ready';
        objmlca.Foundry_GDSOUT_Review__c = 'Ready';
        objmlca.Customer_Frame_Mockup__c = 'Ready';
        objmlca.Foundry_Frame_Mockup__c = 'Ready';
        objmlca.Customer_MEBES_Jobview__c = 'Ready';
        objmlca.Foundry_MEBES_Jobview__c = 'Ready';
        objmlca.Tapeout_Centre_MEBES_Jobview__c = 'Ready';
        objmlca.Tapeout_Applications_MEBES_Jobview__c = 'Ready';
        objmlca.GlobalShuttle_MEBES_Jobview__c = 'Ready';
        objmlca.TDTI_MPW_MEBES_Jobview__c = 'Ready';
        objmlca.MDP_MEBES_Jobview__c = 'Ready';
        objmlca.Customer_Frame_Mockup_Notified_Date__c = System.now().addHours(-(Integer.valueOf(Label.Notification_Interval)+1));
        objmlca.Customer_GDSOUT_Review_Notified_Date__c = System.now().addHours(-(Integer.valueOf(Label.Notification_Interval)+1));
        objmlca.Customer_MEBES_Jobview_Notified_Date__c = System.now().addHours(-(Integer.valueOf(Label.Notification_Interval)+1));
        objmlca.Foundry_Frame_Mockup_Notified_Date__c = System.now().addHours(-(Integer.valueOf(Label.Notification_Interval)+1));
        objmlca.Foundry_GDSOUT_Review_Notified_Date__c = System.now().addHours(-(Integer.valueOf(Label.Notification_Interval)+1));
        objmlca.Foundry_MEBES_Jobview_Notified_Date__c = System.now().addHours(-(Integer.valueOf(Label.Notification_Interval)+1));
        objmlca.GlobalShuttle_MEBES_Notified_Date__c = System.now().addHours(-(Integer.valueOf(Label.Notification_Interval)+1));
        objmlca.MDP_MEBES_Notified_Date__c = System.now().addHours(-(Integer.valueOf(Label.Notification_Interval)+1));
        objmlca.Tapeout_App_MEBES_Notified_Date__c = System.now().addHours(-(Integer.valueOf(Label.Notification_Interval)+1));
        objmlca.Tapeout_Centre_MEBES_Notified_Date__c = System.now().addHours(-(Integer.valueOf(Label.Notification_Interval)+1));
        objmlca.TDTI_MPW_MEBES_Notified_Date__c = System.now().addHours(-(Integer.valueOf(Label.Notification_Interval)+1));
        insert objmlca; 
         
        
        MRS_Layer_Chip_Association__c objmlcafetch = [Select Customer_Name__c from MRS_Layer_Chip_Association__c where Id=:objmlca.Id];
            
        
        mrsLayerChipAssolst.add(objmlca);
        String ready = 'Ready';
        List<String> layerChipStatus = new List<String>{'Cancel','Hold','Void'};
        List<String> orderStatus  = new List<String>{'Cancel','Deleted','Closed'};
        DateTime timeAfterInterval = System.now().addHours(-Integer.valueOf(Label.Notification_Interval));
           
        String query = 'SELECT Chip__c,Chip__r.Name,Layer__r.Name,Layer__r.Mask_Layer_Rev__c,Layer__r.ROM_Code__c,Tech_Geo__c,Customer_Name__c,Customer_Name__r.Id, Customer_Name__r.Name,DRT__c,PTRF__r.Name,\n'+
                       'PTRF__c,PTRF__r.MaskSetTitle__c,PTRF__r.MaskSetTitle__r.Name,Layer__c,Customer_Name__r.Short_Name__c,PTRF__r.Tech_Geo__c,\n'+
                       'Customer_GDSOUT_Review__c,Customer_GDSOUT_Review_Notified_Date__c,Foundry_GDSOUT_Review__c,Foundry_GDSOUT_Review_Notified_Date__c,Customer_Frame_Mockup__c,Customer_Frame_Mockup_Notified_Date__c,Foundry_Frame_Mockup__c,Foundry_Frame_Mockup_Notified_Date__c,Customer_MEBES_Jobview__c,Customer_MEBES_Jobview_Notified_Date__c,\n'+
                       'Foundry_MEBES_Jobview__c,Foundry_MEBES_Jobview_Notified_Date__c,Tapeout_Centre_MEBES_Jobview__c,Tapeout_Centre_MEBES_Notified_Date__c,Tapeout_Applications_MEBES_Jobview__c,Tapeout_App_MEBES_Notified_Date__c,GlobalShuttle_MEBES_Jobview__c,GlobalShuttle_MEBES_Notified_Date__c,\n'+
                       'TDTI_MPW_MEBES_Jobview__c,TDTI_MPW_MEBES_Notified_Date__c,MDP_MEBES_Jobview__c,MDP_MEBES_Notified_Date__c FROM MRS_Layer_Chip_Association__c\n'+
                       ' WHERE ((Customer_GDSOUT_Review__c =: ready AND Customer_GDSOUT_Review_Notified_Date__c <= :timeAfterInterval)  OR (Foundry_GDSOUT_Review__c =: ready AND Foundry_GDSOUT_Review_Notified_Date__c <= :timeAfterInterval) OR (Customer_Frame_Mockup__c =: ready AND Customer_Frame_Mockup_Notified_Date__c <= :timeAfterInterval) OR\n'+
                       ' (Foundry_Frame_Mockup__c =: ready AND Foundry_Frame_Mockup_Notified_Date__c <= :timeAfterInterval) OR (Customer_MEBES_Jobview__c =: ready AND Customer_MEBES_Jobview_Notified_Date__c <= :timeAfterInterval) OR (Foundry_MEBES_Jobview__c =: ready AND Foundry_MEBES_Jobview_Notified_Date__c <= :timeAfterInterval) OR\n'+
                       ' (Tapeout_Centre_MEBES_Jobview__c =: ready AND Tapeout_Centre_MEBES_Notified_Date__c <= :timeAfterInterval) OR (Tapeout_Applications_MEBES_Jobview__c =: ready AND Tapeout_App_MEBES_Notified_Date__c <= :timeAfterInterval) OR (GlobalShuttle_MEBES_Jobview__c =: ready AND GlobalShuttle_MEBES_Notified_Date__c <= :timeAfterInterval) OR\n'+
                       ' (TDTI_MPW_MEBES_Jobview__c =: ready AND TDTI_MPW_MEBES_Notified_Date__c <= :timeAfterInterval) OR (MDP_MEBES_Jobview__c =: ready AND MDP_MEBES_Notified_Date__c <= :timeAfterInterval)) AND Customer_Name__c =:' +  accountObj.Id+ 'AND PTRF__r.MaskSetTitle__c = :' + objMST.Id +' AND PTRF__r.Status__c NOT IN :orderStatus AND Layer_Chip_Status__c NOT IN :layerChipStatus ORDER BY PTRF__r.MaskSetTitle__c';
            
                  
            SchedulableContext SC= null;
            MRSReviewerNotifications noti = new MRSReviewerNotifications();
           
            
            Set<Id> acctIdSet = new Set<Id>();
            
                    acctIdSet.add(objmlcafetch.Customer_Name__c);
           
           
            
          
            
            List<String> lstTeamRoles = new List<String>();  
            lstTeamRoles = Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');      
            List<Account_Team_Proxy__c> accProxyList = [SELECT Account__c,Name,User_Email__c FROM Account_Team_Proxy__c WHERE Account__c =:accountObj.Id AND Team_Role__c IN :lstTeamRoles];
            List<Account_Team_Proxy__c> accProxyIterator;
            
            ID batchprocessid = Database.executeBatch(noti); 
            
            noti.start(null);            
            noti.execute(null,mrsLayerChipAssolst);
            noti.finish(null); 
                    
            MRSReviewerNotificationSchedular reviewer = new MRSReviewerNotificationSchedular();
            
            
            
            reviewer.execute(SC);
            Test.stopTest(); 
        }                                                          
    }
    /**
        @Method Name: insertSwiftPublicGroupNotification
        @Return type: null
        @Parameters: null
        @Description: Insert custom Settings value for test data
    **/
    public static void insertSwiftPublicGroupNotification() {
        List<Swift_Public_Group_Notification__c> swiftPublicGroupList = new List<Swift_Public_Group_Notification__c>();
        Swift_Public_Group_Notification__c swiftObj = new Swift_Public_Group_Notification__c(Name='Swift GlobalShuttle',Last_Notified__c=System.now());
        swiftPublicGroupList.add(swiftObj);
        swiftObj = new Swift_Public_Group_Notification__c(Name='Swift MDP',Last_Notified__c=System.now());
        swiftPublicGroupList.add(swiftObj);
        swiftObj = new Swift_Public_Group_Notification__c(Name='Swift Tapeout Application',Last_Notified__c=System.now());
        swiftPublicGroupList.add(swiftObj);
        swiftObj = new Swift_Public_Group_Notification__c(Name='Swift Tapeout Centre',Last_Notified__c=System.now());
        swiftPublicGroupList.add(swiftObj);
        swiftObj = new Swift_Public_Group_Notification__c(Name='Swift TDTI-MPW',Last_Notified__c=System.now());
        swiftPublicGroupList.add(swiftObj);
        
        try{
            insert swiftPublicGroupList;
        }
        catch(DMLException ex){
            
        }
    }
}