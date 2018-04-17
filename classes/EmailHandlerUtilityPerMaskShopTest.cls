@istest(SeeAllData=false)
public class EmailHandlerUtilityPerMaskShopTest{
  
    @testSetup static void setup() {
        Test.startTest();
        
        SwiftDataUtilityTest.customSystemData();
        //Environment_Variable__c swift_env = new Environment_Variable__c(Name = 'SWIFT_MDP_EMAIL_TECH_GEO_CUT_OFF', Value__c = '0.00');
        //insert swift_env;
        List<Swift_Email_Template_Links__c> lstLinks = new List<Swift_Email_Template_Links__c>();
        lstLinks.add(new Swift_Email_Template_Links__c(name='LINK1',Label__c='Link',URL__c='https://globalfoundries--swiftvalid--c.cs6.visual.force.com/apex/VFMRSMenu'));
        lstLinks.add(new Swift_Email_Template_Links__c(name='LINK2',Label__c='Link',URL__c='https://globalfoundries--swiftvalid.cs6.my.salesforce.com/apex/MyDevices'));
        lstLinks.add(new Swift_Email_Template_Links__c(name='LINK3',Label__c='https://webview.globalfoundries.com',URL__c='https://webview.globalfoundries.com'));
        lstLinks.add(new Swift_Email_Template_Links__c(name='LINK4',Label__c='LINK4',URL__c='https://www.google.co.in/'));
        insert lstLinks;

        List<Swift_Relationship_Mapping_Per_Maskshop__c> lstRelMap = new List<Swift_Relationship_Mapping_Per_Maskshop__c>();
        lstRelMap.add(new Swift_Relationship_Mapping_Per_Maskshop__c(name='Account',RelationshipFlow__c='PTRF__r-Customer__r',RelationshipName__c='PTRF__r.Customer__r'));
        lstRelMap.add(new Swift_Relationship_Mapping_Per_Maskshop__c(name='DRT__c',RelationshipFlow__c='DRT__r',RelationshipName__c='DRT__r'));
        lstRelMap.add(new Swift_Relationship_Mapping_Per_Maskshop__c(name='Mask_Set_Title__c',RelationshipFlow__c='PTRF__r-MaskSetTitle__r',RelationshipName__c='PTRF__r.MaskSetTitle__r'));
        lstRelMap.add(new Swift_Relationship_Mapping_Per_Maskshop__c(name='MRS_Chip_Details__c',RelationshipFlow__c='Chip__r',RelationshipName__c='Chip__r'));
        lstRelMap.add(new Swift_Relationship_Mapping_Per_Maskshop__c(name='MRS_Layer_Association__c',RelationshipFlow__c='Layer__r',RelationshipName__c='Layer__r'));
        lstRelMap.add(new Swift_Relationship_Mapping_Per_Maskshop__c(name='MRS_Layer_Chip_Association__c',RelationshipFlow__c='',RelationshipName__c=''));
        lstRelMap.add(new Swift_Relationship_Mapping_Per_Maskshop__c(name='MRS__c',RelationshipFlow__c='Layer__r-MRS__r',RelationshipName__c='Layer__r.MRS__r'));
        lstRelMap.add(new Swift_Relationship_Mapping_Per_Maskshop__c(name='PTRF__c',RelationshipFlow__c='PTRF__r',RelationshipName__c='PTRF__r'));
        insert lstRelMap;
        
        Account acc = SwiftDataUtilityTest.createTestAccount();
        
        Maskshop_Configuration__c maskShop = new Maskshop_Configuration__c(Name='testMaskShop');
        insert maskShop;
        
        Released_Mask_Write_Distribution_List__c maskWriteDL = new Released_Mask_Write_Distribution_List__c(Distribution_List__c='ayan.hore@cognizant.com',Maskshop__c=maskShop.Id,isDeleted__c=false);
        insert maskWriteDL;
        
        Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
        insert objMST;
        
        Fab_Distribution_Table__c objFab = new Fab_Distribution_Table__c(Fab_No__c='Fab1',Distribution_List__c='test@yahoo.com;abc@hotmail.com');
        insert objFab;
        
        PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Tech_Geo_Value__c='0.01',Customer_jobview__c='Gating mask release',Fab__c='Fab1',Maskshop__c = maskShop.Id);
        insert objPTRF;
        
        Test.stopTest();
    }
    
    @isTest
    public static void Test1(){
    
        system.debug('Enter Method');
          
                   
        Map<string, set<string>> mapReturn=EmailSubjectBodyPerMaskshop.createQueryString(new Set<String>{'Swift_Hold_Mask_Write_for_Layer'});
        system.debug('Exit Method');
        String Body = '<html><body>This is a test message</body></html>';
        String Subject = 'Test subject';
        String TemplateName = 'Swift_Reminder_Notification_GDSOUT_Review';
        User sysAdminUser= [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true AND UserRoleId not in (null,'')].get(0);
        Profile portalProfile = [Select name, id From Profile where Name like 'Customer Portal Admin'].get(0); 
        UserRole RoleId = [SELECT DeveloperName,Id,Name FROM UserRole where Name like '%Global%Admin%'].get(0);
        Group groupTA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Application'];
        Group groupTC = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Centre'];
        Group groupTMPW = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_TDTI_MPW'];
        Group groupMDP = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_MDP'];
        Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
        Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Admin'];
        Group groupRMG = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_RMG'];
        System.runAs(sysAdminUser){         
            // comment-out, refactor with testSetup method setup()   
            // SwiftDataUtilityTest.customSystemData();
            //Account acc = SwiftDataUtilityTest.createTestAccount();
            Account acc = getAccount('Test Account 009');
            //Maskshop_Configuration__c maskShop = new Maskshop_Configuration__c(Name='testMaskShop');
            //insert maskShop;
            Maskshop_Configuration__c maskShop = [SELECT Id, Name FROM Maskshop_Configuration__c LIMIT 1];
            //Released_Mask_Write_Distribution_List__c maskWriteDL = new //Released_Mask_Write_Distribution_List__c(Distribution_List__c='ayan.hore@cognizant.com',Maskshop__c=maskShop.Id,isDeleted__c=false);
            //insert maskWriteDL;
            //Released_Mask_Write_Distribution_List__c maskWriteDL = [SELECT Id, Distribution_List__c, Maskshop__c, isDeleted__c FROM Released_Mask_Write_Distribution_List__c LIMIT 1];
            
            Contact con = new Contact(AccountId=acc.id,DoNotCall=false,Email='contact@globalfoundries.com',FirstName = 'Contact1',LastName = 'GF',FTP__c=false,HasOptedOutOfEmail = false,HasOptedOutOfFax = false,HCM_Record_ID__c = 'a09N0000003r5iVIAQ',Is_Portal_User_Active__c= false,Is_Portal_User_Created__c = false,Opt_Out_Marketing__c = false,Role__c = 'Customers My Device Admin',Status__c = 'Active', Department__c='Design' );
            insert con;

            User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = portalProfile.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS',contactId=con.Id, Portal_Login__c = 'xyz',IsActive = true);
            insert userSA;
                        
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberTA = new GroupMember(GroupId = groupTA.Id,UserOrGroupId = userSA.Id); 
            GroupMember groupMemberTC = new GroupMember(GroupId = groupTC.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberTMPW = new GroupMember(GroupId = groupTMPW.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberTMDP = new GroupMember(GroupId = groupMDP.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);  
            GroupMember groupMemberRMG = new GroupMember(GroupId = groupRMG.Id,UserOrGroupId = userSA.Id);        
            listGM.add(groupMemberTA);
            listGM.add(groupMemberTC);
            listGM.add(groupMemberTMPW);
            listGM.add(groupMemberTMDP);
            listGM.add(groupMemberGS);
            listGM.add(groupMemberSA);
            listGM.add(groupMemberRMG);
            insert listGM;

            //Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
            //Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
            //insert atp;
            
            //Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            //insert objMST;
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            
            //Fab_Distribution_Table__c objFab = new Fab_Distribution_Table__c(Fab_No__c='Fab1',Distribution_List__c='test@yahoo.com;abc@hotmail.com');
            //insert objFab;
            //PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Tech_Geo_Value__c='0.01',Customer_jobview__c='Gating mask release',Fab__c='Fab1',Maskshop__c = maskShop.Id);
            //insert objPTRF;
            PTRF__c objPTRF = [SELECT Id, Name, Order_Type__c, Recticle_Type__c, MaskSetTitle__c, Customer__c, Tech_Geo_Value__c, Customer_jobview__c, Fab__c, Maskshop__c FROM PTRF__c LIMIT 1];
            
            DRT__c objDRT = new DRT__c(Name='DRT1');
            insert objDRT;
            DRT_PTRF_Association__c objDRTPTRF = new DRT_PTRF_Association__c(PTRF__c=objPTRF.Id,DRT__c=objDRT.Id);
            insert objDRTPTRF;
            
            //Portal_Tab_Access__c portalTabAccess = new Portal_Tab_Access__c(Contact__c = con.Id,User__c = userSA.Id,My_Devices__c = true,PTRF__c = //true,Account__c=acc.Id);
            //insert portalTabAccess;
            
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            insert listPTRFJVI;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            insert objMRS;
            List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123',Tech_Geo__c = '0.01 UM');
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c='123',Tech_Geo__c = '0.01 UM');
            listMRSLA.add(objMRSLA1);
            listMRSLA.add(objMRSLA2);
            insert listMRSLA;   
            List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
            MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip001');
            MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip002');
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            List<MRS_Layer_Chip_Association__c> listMRSLCANew = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            objMRSLCA1=setLayerChipFlagValues(objMRSLCA1);
            objMRSLCA2=setLayerChipFlagValues(objMRSLCA2);
            objMRSLCA3=setLayerChipFlagValues(objMRSLCA3);
            objMRSLCA4=setLayerChipFlagValues(objMRSLCA4);
            objMRSLCA5=setLayerChipFlagValues(objMRSLCA5);
            objMRSLCA6=setLayerChipFlagValues(objMRSLCA6);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
  test.startTest();            insert listMRSLCA;
            
            set<String> setLayerChipIds = new set<String>();
            Map<Id,MRS_Layer_Chip_Association__c> mapLayerChipsOld = new Map<Id,MRS_Layer_Chip_Association__c>();
            for(MRS_Layer_Chip_Association__c obj:listMRSLCA){
                mapLayerChipsOld.put(obj.Id,obj);       
            }
            objMRSLCA1.Customer_Frame_Mockup__c='Ready';
            objMRSLCA1.Send_Prime_Data__c='Done';
            objMRSLCA2.Customer_Frame_Mockup__c='Ready';
            objMRSLCA3.Customer_Frame_Mockup__c='Ready';
            objMRSLCA4.Foundry_Frame_Mockup__c='Ready';
            objMRSLCA5.Foundry_Frame_Mockup__c='Ready';
            objMRSLCA6.Foundry_Frame_Mockup__c='Ready';
            objMRSLCA1.Customer_GDSOUT_Review__c='Ready';
            objMRSLCA2.Customer_GDSOUT_Review__c='Ready';
            objMRSLCA3.Customer_GDSOUT_Review__c='Ready';
            objMRSLCA4.Foundry_GDSOUT_Review__c='Ready';
            objMRSLCA5.Foundry_GDSOUT_Review__c='Ready';
            objMRSLCA6.Foundry_GDSOUT_Review__c='Ready';
            listMRSLCANew.add(objMRSLCA1);
            listMRSLCANew.add(objMRSLCA2);
            listMRSLCANew.add(objMRSLCA3);
            listMRSLCANew.add(objMRSLCA4);
            listMRSLCANew.add(objMRSLCA5);
            listMRSLCANew.add(objMRSLCA6);
            setLayerChipIds.add(objMRSLCA1.Id);
            setLayerChipIds.add(objMRSLCA2.Id);
            setLayerChipIds.add(objMRSLCA3.Id);
            setLayerChipIds.add(objMRSLCA4.Id);
            setLayerChipIds.add(objMRSLCA5.Id);
            setLayerChipIds.add(objMRSLCA6.Id);
            
           
                update listMRSLCANew;
  
                Id RecordTypeId = Schema.SObjectType.Email_Config_Settings__c.getRecordTypeInfosByName().get('Maskshop').getRecordTypeId();

                //EmailTemplate tempET = [Select FolderId from EmailTemplate where Name like 'Swift%' LIMIT 1];
                //EmailTemplate et = new EmailTemplate(Name = 'Test Email Template',TemplateType = 'custom',FolderId = tempET.FolderId,Subject='Test Email Template',Body='This is the Body',HtmlValue = '<html><body>This is the HTML Body</body></html>',DeveloperName='Test_Email_Template');
                //insert et;
                EmailTemplate et = insertTemplate();
                
                Email_Config_Settings__c emailCOnfigObj = new Email_Config_Settings__c(Email_Template_Name__c=et.DeveloperName,
                                                                                        RecordTypeId=RecordTypeId,
                                                                                        Available_For_Use__c=true,
                                                                                        Tech_Geo_Value__c='0.01',
                                                                                        Gating_Jobview__c='NA',
                                                                                        Send_Mail_To_Customer__c = true,
                                                                                        MPW_PTRF__c=true,
                                                                                        TO__c='#User : sujoy.mazumder@cognizant.com.swiftvalid,trisha.banerjee@cognizant.com.swiftvalid,steffen.kalisch@globalfoundries.com.swiftvalid #Group:Swift_RMG#Email:test@abc.com #Customer #Fab #ATP',
                                                                                        CC__c='#Email: puneetmalhotra21@gmail.com #fab:test@test.com #ATP #Customer #Fab',
                                                                                        BCC__c='#Email:meenakshmi.goswami@cognizant.com #Customer #ATP #Fab',
                                                                                        Customer_Jobviewer_Type__c='Prime GDSOUT Review',
                                                                                        Foundry_Jobviewer_Type__c='MEBES Jobview;Frame Mockup Review'
                                                                                        );
                insert emailCOnfigObj;      
                
                Map<String,Map<String,String>> inputMap =new Map<String,Map<String,String>>();      
                Map<String,String> innerMap = new Map<String,String>();

                //EmailTemplate et = [Select id,Subject,Body,HtmlValue,DeveloperName from EmailTemplate where DeveloperName=:TemplateName LIMIT 1];
                List<MRS_Layer_Association__c> mrsList = [select Id, Name,Layer_Status__c from MRS_Layer_Association__c];
                List<MRS_Layer_Chip_Association__c> lstMRSLChpAsso = [select Id, Name, PTRF__c,Customer_Name__c,PTRF__r.Maskshop__c,PTRF__r.MaskSetTitle__r.Name,Layer__r.Tech_Geo__c,PTRF__r.Tech_Geo__c,Layer__r.Mask_Set_Title_Name__c,PTRF__r.Fab__c,Layer__r.ROM_Code__c,Layer__r.Name,Layer__r.Mask_Layer_Rev__c,Layer_Identifier__c,PTRF__r.name from MRS_Layer_Chip_Association__c];
                String Comments = 'This is a test comment';
                Map<Id,String> mapLayerAssoToStatus = new Map<Id,String>();
                for(MRS_Layer_Association__c obj : mrsList){
                    if(obj.Layer_Status__c != null && obj.Layer_Status__c != ''){
                        mapLayerAssoToStatus.put(obj.Id, String.valueOf(obj.Layer_Status__c));                      
                    }                   
                }
                Boolean statusCheck = false;

 
                EmailHandlerUtilityPerMaskShop.sendEmailPerMaskshop(et, mrsList,lstMRSLChpAsso, Comments, mapLayerAssoToStatus, statusCheck);
            test.stopTest();                        
        }
    }


    @isTest
    public static void Test11(){
        String Body = '<html><body>This is a test message</body></html>';
        String Subject = 'Test subject';
        String TemplateName = 'Swift_Reminder_Notification_GDSOUT_Review';
        User sysAdminUser= [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true AND UserRoleId not in (null,'')].get(0);
        Profile portalProfile = [Select name, id From Profile where Name like 'Customer Portal Admin'].get(0); 
        UserRole RoleId = [SELECT DeveloperName,Id,Name FROM UserRole where Name like '%Global%Admin%'].get(0);
        Group groupTA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Application'];
        Group groupTC = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Centre'];
        Group groupTMPW = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_TDTI_MPW'];
        Group groupMDP = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_MDP'];
        Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
        Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Admin'];
        Group groupRMG = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_RMG'];
        System.runAs(sysAdminUser){          
            // comment-out, refactor with testSetup method setup()  
            // SwiftDataUtilityTest.customSystemData();
            //Account acc = SwiftDataUtilityTest.createTestAccount();
            Account acc = getAccount('Test Account 009');
            //Maskshop_Configuration__c maskShop = new Maskshop_Configuration__c(Name='testMaskShop');
            //insert maskShop;
            Maskshop_Configuration__c maskShop = [SELECT Id, Name FROM Maskshop_Configuration__c LIMIT 1];
            //Released_Mask_Write_Distribution_List__c maskWriteDL = new //Released_Mask_Write_Distribution_List__c(Distribution_List__c='ayan.hore@cognizant.com',Maskshop__c=maskShop.Id,isDeleted__c=false);
            //insert maskWriteDL;
            //Released_Mask_Write_Distribution_List__c maskWriteDL = [SELECT Id, Distribution_List__c, Maskshop__c, isDeleted__c FROM Released_Mask_Write_Distribution_List__c LIMIT 1];
            
            Contact con = new Contact(AccountId=acc.id,DoNotCall=false,Email='contact@globalfoundries.com',FirstName = 'Contact1',LastName = 'GF',FTP__c=false,HasOptedOutOfEmail = false,HasOptedOutOfFax = false,HCM_Record_ID__c = 'a09N0000003r5iVIAQ',Is_Portal_User_Active__c= false,Is_Portal_User_Created__c = false,Opt_Out_Marketing__c = false,Role__c = 'Customers My Device Admin',Status__c = 'Active', Department__c='Design' );
            insert con;

            User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = portalProfile.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS',contactId=con.Id,Portal_Login__c = 'xyz',IsActive = true);
            insert userSA;
                        
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberTA = new GroupMember(GroupId = groupTA.Id,UserOrGroupId = userSA.Id); 
            GroupMember groupMemberTC = new GroupMember(GroupId = groupTC.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberTMPW = new GroupMember(GroupId = groupTMPW.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberTMDP = new GroupMember(GroupId = groupMDP.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);  
            GroupMember groupMemberRMG = new GroupMember(GroupId = groupRMG.Id,UserOrGroupId = userSA.Id);        
            listGM.add(groupMemberTA);
            listGM.add(groupMemberTC);
            listGM.add(groupMemberTMPW);
            listGM.add(groupMemberTMDP);
            listGM.add(groupMemberGS);
            listGM.add(groupMemberSA);
            listGM.add(groupMemberRMG);
            insert listGM;

            //Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
            //Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
            //insert atp;
            
            //Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            //insert objMST;
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            
            //Fab_Distribution_Table__c objFab = new Fab_Distribution_Table__c(Fab_No__c='Fab1',Distribution_List__c='test@yahoo.com;abc@hotmail.com');
            //insert objFab;
            //PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Tech_Geo_Value__c='0.01',Customer_jobview__c='Gating mask release',Fab__c='Fab1',Maskshop__c = maskShop.Id);
            //insert objPTRF;
            PTRF__c objPTRF = [SELECT Id, Name, Order_Type__c, Recticle_Type__c, MaskSetTitle__c, Customer__c, Tech_Geo_Value__c, Customer_jobview__c, Fab__c, Maskshop__c FROM PTRF__c LIMIT 1];
            
            DRT__c objDRT = new DRT__c(Name='DRT1');
            insert objDRT;
            DRT_PTRF_Association__c objDRTPTRF = new DRT_PTRF_Association__c(PTRF__c=objPTRF.Id,DRT__c=objDRT.Id);
            insert objDRTPTRF;
            
            //Portal_Tab_Access__c portalTabAccess = new Portal_Tab_Access__c(Contact__c = con.Id,User__c = userSA.Id,My_Devices__c = true,PTRF__c = true,Account__c=acc.Id);
            //insert portalTabAccess;
            
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            insert listPTRFJVI;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            insert objMRS;
            List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123',Tech_Geo__c = '0.01 UM');
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c='123',Tech_Geo__c = '0.01 UM');
            listMRSLA.add(objMRSLA1);
            listMRSLA.add(objMRSLA2);
            insert listMRSLA;   
            List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
            MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip001');
            MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip002');
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            List<MRS_Layer_Chip_Association__c> listMRSLCANew = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            objMRSLCA1=setLayerChipFlagValues(objMRSLCA1);
            objMRSLCA2=setLayerChipFlagValues(objMRSLCA2);
            objMRSLCA3=setLayerChipFlagValues(objMRSLCA3);
            objMRSLCA4=setLayerChipFlagValues(objMRSLCA4);
            objMRSLCA5=setLayerChipFlagValues(objMRSLCA5);
            objMRSLCA6=setLayerChipFlagValues(objMRSLCA6);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
    test.startTest();         insert listMRSLCA;
            
            set<String> setLayerChipIds = new set<String>();
            Map<Id,MRS_Layer_Chip_Association__c> mapLayerChipsOld = new Map<Id,MRS_Layer_Chip_Association__c>();
            for(MRS_Layer_Chip_Association__c obj:listMRSLCA){
                mapLayerChipsOld.put(obj.Id,obj);       
            }
            objMRSLCA1.Customer_Frame_Mockup__c='Ready';
            objMRSLCA1.Send_Prime_Data__c='Done';
            objMRSLCA2.Customer_Frame_Mockup__c='Ready';
            objMRSLCA3.Customer_Frame_Mockup__c='Ready';
            objMRSLCA4.Foundry_Frame_Mockup__c='Ready';
            objMRSLCA5.Foundry_Frame_Mockup__c='Ready';
            objMRSLCA6.Foundry_Frame_Mockup__c='Ready';
            objMRSLCA1.Customer_GDSOUT_Review__c='Ready';
            objMRSLCA2.Customer_GDSOUT_Review__c='Ready';
            objMRSLCA3.Customer_GDSOUT_Review__c='Ready';
            objMRSLCA4.Foundry_GDSOUT_Review__c='Ready';
            objMRSLCA5.Foundry_GDSOUT_Review__c='Ready';
            objMRSLCA6.Foundry_GDSOUT_Review__c='Ready';
            listMRSLCANew.add(objMRSLCA1);
            listMRSLCANew.add(objMRSLCA2);
            listMRSLCANew.add(objMRSLCA3);
            listMRSLCANew.add(objMRSLCA4);
            listMRSLCANew.add(objMRSLCA5);
            listMRSLCANew.add(objMRSLCA6);
            setLayerChipIds.add(objMRSLCA1.Id);
            setLayerChipIds.add(objMRSLCA2.Id);
            setLayerChipIds.add(objMRSLCA3.Id);
            setLayerChipIds.add(objMRSLCA4.Id);
            setLayerChipIds.add(objMRSLCA5.Id);
            setLayerChipIds.add(objMRSLCA6.Id);
            
            
                update listMRSLCANew;
    
                Id RecordTypeId = Schema.SObjectType.Email_Config_Settings__c.getRecordTypeInfosByName().get('Maskshop').getRecordTypeId();

                //EmailTemplate tempET = [Select FolderId from EmailTemplate where Name like 'Swift%' LIMIT 1];
                //EmailTemplate et = new EmailTemplate(Name = 'Test Email Template',TemplateType = 'custom',FolderId = tempET.FolderId,Subject='Test Email Template',Body='This is the Body',HtmlValue = '<html><body>This is the HTML Body</body></html>',DeveloperName='Test_Email_Template');
                //insert et;
                EmailTemplate et = insertTemplate();
               
                Email_Config_Settings__c emailCOnfigObj = new Email_Config_Settings__c(Email_Template_Name__c=et.DeveloperName,
                                                                                        RecordTypeId=RecordTypeId,
                                                                                        Available_For_Use__c=true,
                                                                                        Tech_Geo_Value__c='',
                                                                                        Gating_Jobview__c='NA',
                                                                                        Send_Mail_To_Customer__c = true,
                                                                                        MPW_PTRF__c=true,
                                                                                        TO__c='#User : sujoy.mazumder@cognizant.com.swiftvalid,trisha.banerjee@cognizant.com.swiftvalid,steffen.kalisch@globalfoundries.com.swiftvalid #Group:Swift_RMG#Email:test@abc.com #Customer #Fab #ATP',
                                                                                        CC__c='#Email: puneetmalhotra21@gmail.com #fab:test@test.com #ATP #Customer #Fab',
                                                                                        BCC__c='#Email:meenakshmi.goswami@cognizant.com #Customer #ATP #Fab',
                                                                                        Customer_Jobviewer_Type__c='Prime GDSOUT Review',
                                                                                        Foundry_Jobviewer_Type__c='MEBES Jobview;Frame Mockup Review'
                                                                                        );
                insert emailCOnfigObj;      
                
                Map<String,Map<String,String>> inputMap =new Map<String,Map<String,String>>();      
                Map<String,String> innerMap = new Map<String,String>();

                //EmailTemplate et = [Select id,Subject,Body,HtmlValue,DeveloperName from EmailTemplate where DeveloperName=:TemplateName LIMIT 1];
                List<MRS_Layer_Association__c> mrsList = [select Id, Name,Layer_Status__c from MRS_Layer_Association__c];
                List<MRS_Layer_Chip_Association__c> lstMRSLChpAsso = [select Id, Name, PTRF__c,Customer_Name__c,PTRF__r.Maskshop__c,PTRF__r.MaskSetTitle__r.Name,Layer__r.Tech_Geo__c,PTRF__r.Tech_Geo__c,Layer__r.Mask_Set_Title_Name__c,PTRF__r.Fab__c,Layer__r.ROM_Code__c,Layer__r.Name,Layer__r.Mask_Layer_Rev__c,Layer_Identifier__c,PTRF__r.name  from MRS_Layer_Chip_Association__c];
                String Comments = 'This is a test comment';
                Map<Id,String> mapLayerAssoToStatus = new Map<Id,String>();
                for(MRS_Layer_Association__c obj : mrsList){
                    if(obj.Layer_Status__c != null && obj.Layer_Status__c != ''){
                        mapLayerAssoToStatus.put(obj.Id, String.valueOf(obj.Layer_Status__c));                      
                    }                   
                }
                Boolean statusCheck = false;
                 
                EmailHandlerUtilityPerMaskShop.sendEmailPerMaskshop(et, mrsList,  lstMRSLChpAsso, Comments, mapLayerAssoToStatus, statusCheck);
            test.stopTest();                        
        }
    }


    @isTest
    public static void Test2(){
        String Body = '<html><body>This is a test message</body></html>';
        String Subject = 'Test subject';
        String TemplateName = 'Swift_Reminder_Notification_GDSOUT_Review';
        User sysAdminUser= [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true AND UserRoleId not in (null,'')].get(0);
        Profile portalProfile = [Select name, id From Profile where Name like 'Customer Portal Admin'].get(0); 
        UserRole RoleId = [SELECT DeveloperName,Id,Name FROM UserRole where Name like '%Global%Admin%'].get(0);
        Group groupTA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Application'];
        Group groupTC = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Centre'];
        Group groupTMPW = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_TDTI_MPW'];
        Group groupMDP = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_MDP'];
        Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
        Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Admin'];
        Group groupRMG = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_RMG'];
        System.runAs(sysAdminUser){            
            // comment-out, refactor with testSetup method setup()
            // SwiftDataUtilityTest.customSystemData();
            //Account acc = SwiftDataUtilityTest.createTestAccount();
            Account acc = getAccount('Test Account 009');
            //Maskshop_Configuration__c maskShop = new Maskshop_Configuration__c(Name='testMaskShop');
            //insert maskShop;
            Maskshop_Configuration__c maskShop = [SELECT Id, Name FROM Maskshop_Configuration__c LIMIT 1];
            //Released_Mask_Write_Distribution_List__c maskWriteDL = new //Released_Mask_Write_Distribution_List__c(Distribution_List__c='ayan.hore@cognizant.com',Maskshop__c=maskShop.Id,isDeleted__c=false);
            //insert maskWriteDL;
            //Released_Mask_Write_Distribution_List__c maskWriteDL = [SELECT Id, Distribution_List__c, Maskshop__c, isDeleted__c FROM Released_Mask_Write_Distribution_List__c LIMIT 1];
            
            Contact con = new Contact(AccountId=acc.id,DoNotCall=false,Email='contact@globalfoundries.com',FirstName = 'Contact1',LastName = 'GF',FTP__c=false,HasOptedOutOfEmail = false,HasOptedOutOfFax = false,HCM_Record_ID__c = 'a09N0000003r5iVIAQ',Is_Portal_User_Active__c= false,Is_Portal_User_Created__c = false,Opt_Out_Marketing__c = false,Role__c = 'Customers My Device Admin',Status__c = 'Active', Department__c='Design' );
            insert con;

            User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = portalProfile.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS',contactId=con.Id,Portal_Login__c = 'xyz',IsActive = true);
            insert userSA;
                        
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberTA = new GroupMember(GroupId = groupTA.Id,UserOrGroupId = userSA.Id); 
            GroupMember groupMemberTC = new GroupMember(GroupId = groupTC.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberTMPW = new GroupMember(GroupId = groupTMPW.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberTMDP = new GroupMember(GroupId = groupMDP.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);  
            GroupMember groupMemberRMG = new GroupMember(GroupId = groupRMG.Id,UserOrGroupId = userSA.Id);        
            listGM.add(groupMemberTA);
            listGM.add(groupMemberTC);
            listGM.add(groupMemberTMPW);
            listGM.add(groupMemberTMDP);
            listGM.add(groupMemberGS);
            listGM.add(groupMemberSA);
            listGM.add(groupMemberRMG);
            insert listGM;

            //Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
            //Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
            //insert atp;
            
            //Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            //insert objMST;
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            
            //Fab_Distribution_Table__c objFab = new Fab_Distribution_Table__c(Fab_No__c='Fab1',Distribution_List__c='test@yahoo.com;abc@hotmail.com');
            //insert objFab;
            //PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Tech_Geo_Value__c='0.01',Customer_jobview__c='Gating mask release',Fab__c='Fab1',Maskshop__c = maskShop.Id);
            //insert objPTRF;
            PTRF__c objPTRF = [SELECT Id, Name, Order_Type__c, Recticle_Type__c, MaskSetTitle__c, Customer__c, Tech_Geo_Value__c, Customer_jobview__c, Fab__c, Maskshop__c FROM PTRF__c LIMIT 1];
            
            DRT__c objDRT = new DRT__c(Name='DRT1');
            insert objDRT;
            DRT_PTRF_Association__c objDRTPTRF = new DRT_PTRF_Association__c(PTRF__c=objPTRF.Id,DRT__c=objDRT.Id);
            insert objDRTPTRF;
            
            //Portal_Tab_Access__c portalTabAccess = new Portal_Tab_Access__c(Contact__c = con.Id,User__c = userSA.Id,My_Devices__c = true,PTRF__c = true,Account__c=acc.Id);
            //insert portalTabAccess;
            
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            insert listPTRFJVI;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            insert objMRS;
            List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123',Tech_Geo__c = '0.01 UM');
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c='123',Tech_Geo__c = '0.01 UM');
            listMRSLA.add(objMRSLA1);
            listMRSLA.add(objMRSLA2);
            insert listMRSLA;   
            List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
            MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip001');
            MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip002');
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            List<MRS_Layer_Chip_Association__c> listMRSLCANew = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            objMRSLCA1=setLayerChipFlagValues(objMRSLCA1);
            objMRSLCA2=setLayerChipFlagValues(objMRSLCA2);
            objMRSLCA3=setLayerChipFlagValues(objMRSLCA3);
            objMRSLCA4=setLayerChipFlagValues(objMRSLCA4);
            objMRSLCA5=setLayerChipFlagValues(objMRSLCA5);
            objMRSLCA6=setLayerChipFlagValues(objMRSLCA6);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
      test.startTest();      insert listMRSLCA;
            
            set<String> setLayerChipIds = new set<String>();
            Map<Id,MRS_Layer_Chip_Association__c> mapLayerChipsOld = new Map<Id,MRS_Layer_Chip_Association__c>();
            for(MRS_Layer_Chip_Association__c obj:listMRSLCA){
                mapLayerChipsOld.put(obj.Id,obj);       
            }
            objMRSLCA1.Customer_Frame_Mockup__c='Ready';
            objMRSLCA1.Send_Prime_Data__c='Done';
            objMRSLCA2.Customer_Frame_Mockup__c='Ready';
            objMRSLCA3.Customer_Frame_Mockup__c='Ready';
            objMRSLCA4.Foundry_Frame_Mockup__c='Ready';
            objMRSLCA5.Foundry_Frame_Mockup__c='Ready';
            objMRSLCA6.Foundry_Frame_Mockup__c='Ready';
            objMRSLCA1.Customer_GDSOUT_Review__c='Ready';
            objMRSLCA2.Customer_GDSOUT_Review__c='Ready';
            objMRSLCA3.Customer_GDSOUT_Review__c='Ready';
            objMRSLCA4.Foundry_GDSOUT_Review__c='Ready';
            objMRSLCA5.Foundry_GDSOUT_Review__c='Ready';
            objMRSLCA6.Foundry_GDSOUT_Review__c='Ready';
            listMRSLCANew.add(objMRSLCA1);
            listMRSLCANew.add(objMRSLCA2);
            listMRSLCANew.add(objMRSLCA3);
            listMRSLCANew.add(objMRSLCA4);
            listMRSLCANew.add(objMRSLCA5);
            listMRSLCANew.add(objMRSLCA6);
            setLayerChipIds.add(objMRSLCA1.Id);
            setLayerChipIds.add(objMRSLCA2.Id);
            setLayerChipIds.add(objMRSLCA3.Id);
            setLayerChipIds.add(objMRSLCA4.Id);
            setLayerChipIds.add(objMRSLCA5.Id);
            setLayerChipIds.add(objMRSLCA6.Id);
            
            
                update listMRSLCANew;
    
                Id RecordTypeId = Schema.SObjectType.Email_Config_Settings__c.getRecordTypeInfosByName().get('Maskshop').getRecordTypeId();

                //EmailTemplate tempET = [Select FolderId from EmailTemplate where Name like 'Swift%' LIMIT 1];
                //EmailTemplate et = new EmailTemplate(Name = 'Test Email Template',TemplateType = 'custom',FolderId = tempET.FolderId,Subject='Test Email Template',Body='This is the Body',HtmlValue = '<html><body>This is the HTML Body</body></html>',DeveloperName='Test_Email_Template');
                //insert et;
                EmailTemplate et = insertTemplate();
                
                Email_Config_Settings__c emailCOnfigObj = new Email_Config_Settings__c(Email_Template_Name__c=et.DeveloperName,
                                                                                        RecordTypeId=RecordTypeId,
                                                                                        Available_For_Use__c=true,
                                                                                        Tech_Geo_Value__c='0.01',
                                                                                        Gating_Jobview__c='NA',
                                                                                        Send_Mail_To_Customer__c = true,
                                                                                        MPW_PTRF__c=true,
                                                                                        TO__c='#User : sujoy.mazumder@cognizant.com.swiftvalid,trisha.banerjee@cognizant.com.swiftvalid,steffen.kalisch@globalfoundries.com.swiftvalid #Group:Swift_RMG#Email:test@abc.com #Customer #Fab #ATP',
                                                                                        CC__c='#Email: puneetmalhotra21@gmail.com #fab:test@test.com #ATP #Customer #Fab',
                                                                                        BCC__c='#Email:meenakshmi.goswami@cognizant.com #Customer #ATP #Fab',
                                                                                        Customer_Jobviewer_Type__c='Prime GDSOUT Review',
                                                                                        Foundry_Jobviewer_Type__c='MEBES Jobview;Frame Mockup Review'
                                                                                        );
                insert emailCOnfigObj;      
                
                Map<String,Map<String,String>> inputMap =new Map<String,Map<String,String>>();      
                Map<String,String> innerMap = new Map<String,String>();

                //EmailTemplate et = [Select id,Subject,Body,HtmlValue,DeveloperName from EmailTemplate where DeveloperName=:TemplateName LIMIT 1];
                List<MRS_Layer_Association__c> mrsList = [select Id, Name,Layer_Status__c from MRS_Layer_Association__c];
                List<MRS_Layer_Chip_Association__c> lstMRSLChpAsso = [select Id, Name, PTRF__c,Customer_Name__c,PTRF__r.Maskshop__c,PTRF__r.MaskSetTitle__r.Name,Layer__r.Tech_Geo__c,PTRF__r.Tech_Geo__c,Layer__r.Mask_Set_Title_Name__c,PTRF__r.Fab__c,Layer__r.ROM_Code__c,Layer__r.Name,Layer__r.Mask_Layer_Rev__c,Layer_Identifier__c,PTRF__r.name  from MRS_Layer_Chip_Association__c];
                String Comments = 'This is a test comment';
                Map<Id,String> mapLayerAssoToStatus = new Map<Id,String>();
                for(MRS_Layer_Association__c obj : mrsList){
                    if(obj.Layer_Status__c != null && obj.Layer_Status__c != ''){
                        mapLayerAssoToStatus.put(obj.Id, String.valueOf(obj.Layer_Status__c));                      
                    }                   
                }
                Boolean statusCheck = false;
                
                EmailHandlerUtilityPerMaskShop.sendChipEmailPerMaskshop(et, lstMRSLChpAsso, Comments);
            test.stopTest();                        
        }
    }    

    @isTest
    public static void Test21(){
        String Body = '<html><body>This is a test message</body></html>';
        String Subject = 'Test subject';
        String TemplateName = 'Swift_Reminder_Notification_GDSOUT_Review';
        User sysAdminUser= [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true AND UserRoleId not in (null,'')].get(0);
        Profile portalProfile = [Select name, id From Profile where Name like 'Customer Portal Admin'].get(0); 
        UserRole RoleId = [SELECT DeveloperName,Id,Name FROM UserRole where Name like '%Global%Admin%'].get(0);
        Group groupTA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Application'];
        Group groupTC = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Centre'];
        Group groupTMPW = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_TDTI_MPW'];
        Group groupMDP = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_MDP'];
        Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
        Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Admin'];
        Group groupRMG = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_RMG'];
        System.runAs(sysAdminUser){         
            // comment-out, refactor with testSetup method setup()   
            // SwiftDataUtilityTest.customSystemData();
            //Account acc = SwiftDataUtilityTest.createTestAccount();
            Account acc = getAccount('Test Account 009');
            //Maskshop_Configuration__c maskShop = new Maskshop_Configuration__c(Name='testMaskShop');
            //insert maskShop;
            Maskshop_Configuration__c maskShop = [SELECT Id, Name FROM Maskshop_Configuration__c LIMIT 1];
            //Released_Mask_Write_Distribution_List__c maskWriteDL = new //Released_Mask_Write_Distribution_List__c(Distribution_List__c='ayan.hore@cognizant.com',Maskshop__c=maskShop.Id,isDeleted__c=false);
            //insert maskWriteDL;
            //Released_Mask_Write_Distribution_List__c maskWriteDL = [SELECT Id, Distribution_List__c, Maskshop__c, isDeleted__c FROM Released_Mask_Write_Distribution_List__c LIMIT 1];
            
            Contact con = new Contact(AccountId=acc.id,DoNotCall=false,Email='contact@globalfoundries.com',FirstName = 'Contact1',LastName = 'GF',FTP__c=false,HasOptedOutOfEmail = false,HasOptedOutOfFax = false,HCM_Record_ID__c = 'a09N0000003r5iVIAQ',Is_Portal_User_Active__c= false,Is_Portal_User_Created__c = false,Opt_Out_Marketing__c = false,Role__c = 'Customers My Device Admin',Status__c = 'Active', Department__c='Design' );
            insert con;

            User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = portalProfile.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS',contactId=con.Id,Portal_Login__c = 'xyz',IsActive = true);
            insert userSA;
                        
            List<GroupMember> listGM = new List<GroupMember>(); 
            GroupMember groupMemberTA = new GroupMember(GroupId = groupTA.Id,UserOrGroupId = userSA.Id); 
            GroupMember groupMemberTC = new GroupMember(GroupId = groupTC.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberTMPW = new GroupMember(GroupId = groupTMPW.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberTMDP = new GroupMember(GroupId = groupMDP.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);
            GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);  
            GroupMember groupMemberRMG = new GroupMember(GroupId = groupRMG.Id,UserOrGroupId = userSA.Id);        
            listGM.add(groupMemberTA);
            listGM.add(groupMemberTC);
            listGM.add(groupMemberTMPW);
            listGM.add(groupMemberTMDP);
            listGM.add(groupMemberGS);
            listGM.add(groupMemberSA);
            listGM.add(groupMemberRMG);
            insert listGM;

            //Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
            //Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
            //insert atp;
            
            //Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            //insert objMST;
            Mask_Set_Title__c objMST = [SELECT Id, Name FROM Mask_Set_Title__c LIMIT 1];
            
            //Fab_Distribution_Table__c objFab = new Fab_Distribution_Table__c(Fab_No__c='Fab1',Distribution_List__c='test@yahoo.com;abc@hotmail.com');
            //insert objFab;
            //PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Tech_Geo_Value__c='0.01',Customer_jobview__c='Gating mask release',Fab__c='Fab1',Maskshop__c = maskShop.Id);
            //insert objPTRF;
            PTRF__c objPTRF = [SELECT Id, Name, Order_Type__c, Recticle_Type__c, MaskSetTitle__c, Customer__c, Tech_Geo_Value__c, Customer_jobview__c, Fab__c, Maskshop__c FROM PTRF__c LIMIT 1];
            
            DRT__c objDRT = new DRT__c(Name='DRT1');
            insert objDRT;
            DRT_PTRF_Association__c objDRTPTRF = new DRT_PTRF_Association__c(PTRF__c=objPTRF.Id,DRT__c=objDRT.Id);
            insert objDRTPTRF;
            
            //Portal_Tab_Access__c portalTabAccess = new Portal_Tab_Access__c(Contact__c = con.Id,User__c = userSA.Id,My_Devices__c = true,PTRF__c = true,Account__c=acc.Id);
            //insert portalTabAccess;
            
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            insert listPTRFJVI;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            insert objMRS;
            List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123',Tech_Geo__c = '0.01 UM');
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c='123',Tech_Geo__c = '0.01 UM');
            listMRSLA.add(objMRSLA1);
            listMRSLA.add(objMRSLA2);
            insert listMRSLA;   
            List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
            MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip001');
            MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip002');
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            List<MRS_Layer_Chip_Association__c> listMRSLCANew = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.01UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            objMRSLCA1=setLayerChipFlagValues(objMRSLCA1);
            objMRSLCA2=setLayerChipFlagValues(objMRSLCA2);
            objMRSLCA3=setLayerChipFlagValues(objMRSLCA3);
            objMRSLCA4=setLayerChipFlagValues(objMRSLCA4);
            objMRSLCA5=setLayerChipFlagValues(objMRSLCA5);
            objMRSLCA6=setLayerChipFlagValues(objMRSLCA6);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
     test.startTest();        insert listMRSLCA;
            
            set<String> setLayerChipIds = new set<String>();
            Map<Id,MRS_Layer_Chip_Association__c> mapLayerChipsOld = new Map<Id,MRS_Layer_Chip_Association__c>();
            for(MRS_Layer_Chip_Association__c obj:listMRSLCA){
                mapLayerChipsOld.put(obj.Id,obj);       
            }
            objMRSLCA1.Customer_Frame_Mockup__c='Ready';
            objMRSLCA1.Send_Prime_Data__c='Done';
            objMRSLCA2.Customer_Frame_Mockup__c='Ready';
            objMRSLCA3.Customer_Frame_Mockup__c='Ready';
            objMRSLCA4.Foundry_Frame_Mockup__c='Ready';
            objMRSLCA5.Foundry_Frame_Mockup__c='Ready';
            objMRSLCA6.Foundry_Frame_Mockup__c='Ready';
            objMRSLCA1.Customer_GDSOUT_Review__c='Ready';
            objMRSLCA2.Customer_GDSOUT_Review__c='Ready';
            objMRSLCA3.Customer_GDSOUT_Review__c='Ready';
            objMRSLCA4.Foundry_GDSOUT_Review__c='Ready';
            objMRSLCA5.Foundry_GDSOUT_Review__c='Ready';
            objMRSLCA6.Foundry_GDSOUT_Review__c='Ready';
            listMRSLCANew.add(objMRSLCA1);
            listMRSLCANew.add(objMRSLCA2);
            listMRSLCANew.add(objMRSLCA3);
            listMRSLCANew.add(objMRSLCA4);
            listMRSLCANew.add(objMRSLCA5);
            listMRSLCANew.add(objMRSLCA6);
            setLayerChipIds.add(objMRSLCA1.Id);
            setLayerChipIds.add(objMRSLCA2.Id);
            setLayerChipIds.add(objMRSLCA3.Id);
            setLayerChipIds.add(objMRSLCA4.Id);
            setLayerChipIds.add(objMRSLCA5.Id);
            setLayerChipIds.add(objMRSLCA6.Id);
            
               
                update listMRSLCANew;
    
                Id RecordTypeId = Schema.SObjectType.Email_Config_Settings__c.getRecordTypeInfosByName().get('Maskshop').getRecordTypeId();

                //EmailTemplate tempET = [Select FolderId from EmailTemplate where Name like 'Swift%' LIMIT 1];
                //EmailTemplate et = new EmailTemplate(Name = 'Test Email Template',TemplateType = 'custom',FolderId = tempET.FolderId,Subject='Test Email Template',Body='This is the Body',HtmlValue = '<html><body>This is the HTML Body</body></html>',DeveloperName='Test_Email_Template');
                //insert et;
                EmailTemplate et = insertTemplate();
                
                Email_Config_Settings__c emailCOnfigObj = new Email_Config_Settings__c(Email_Template_Name__c=et.DeveloperName,
                                                                                        RecordTypeId=RecordTypeId,
                                                                                        Available_For_Use__c=true,
                                                                                        Tech_Geo_Value__c='',
                                                                                        Gating_Jobview__c='NA',
                                                                                        Send_Mail_To_Customer__c = true,
                                                                                        MPW_PTRF__c=true,
                                                                                        TO__c='#User : sujoy.mazumder@cognizant.com.swiftvalid,trisha.banerjee@cognizant.com.swiftvalid,steffen.kalisch@globalfoundries.com.swiftvalid #Group:Swift_RMG#Email:test@abc.com #Customer #Fab #ATP',
                                                                                        CC__c='#Email: puneetmalhotra21@gmail.com #fab:test@test.com #ATP #Customer #Fab',
                                                                                        BCC__c='#Email:meenakshmi.goswami@cognizant.com #Customer #ATP #Fab',
                                                                                        Customer_Jobviewer_Type__c='Prime GDSOUT Review',
                                                                                        Foundry_Jobviewer_Type__c='MEBES Jobview;Frame Mockup Review'
                                                                                        );
                insert emailCOnfigObj;      
                
                Map<String,Map<String,String>> inputMap =new Map<String,Map<String,String>>();      
                Map<String,String> innerMap = new Map<String,String>();

                //EmailTemplate et = [Select id,Subject,Body,HtmlValue,DeveloperName from EmailTemplate where DeveloperName=:TemplateName LIMIT 1];
                List<MRS_Layer_Association__c> mrsList = [select Id, Name,Layer_Status__c from MRS_Layer_Association__c];
                List<MRS_Layer_Chip_Association__c> lstMRSLChpAsso = [select Id, Name, PTRF__c,Customer_Name__c,PTRF__r.Maskshop__c,PTRF__r.MaskSetTitle__r.Name,Layer__r.Tech_Geo__c,PTRF__r.Tech_Geo__c,Layer__r.Mask_Set_Title_Name__c,PTRF__r.Fab__c,Layer__r.ROM_Code__c,Layer__r.Name,Layer__r.Mask_Layer_Rev__c,Layer_Identifier__c,PTRF__r.name  from MRS_Layer_Chip_Association__c];
                String Comments = 'This is a test comment';
                Map<Id,String> mapLayerAssoToStatus = new Map<Id,String>();
                for(MRS_Layer_Association__c obj : mrsList){
                    if(obj.Layer_Status__c != null && obj.Layer_Status__c != ''){
                        mapLayerAssoToStatus.put(obj.Id, String.valueOf(obj.Layer_Status__c));                      
                    }                   
                }
                Boolean statusCheck = false;
                
                EmailHandlerUtilityPerMaskShop.sendChipEmailPerMaskshop(et, lstMRSLChpAsso, Comments);
            test.stopTest();                        
        }
    } 


      public static MRS_Layer_Chip_Association__c setLayerChipFlagValues(MRS_Layer_Chip_Association__c objLayerChip){
        objLayerChip.Is_Customer_GDSOUT_Review_Updated__c=true;
        objLayerChip.Is_Foundry_GDSOUT_Review_Updated__c=true;
        objLayerChip.Is_Customer_Frame_Mockup_Updated__c=true;
        objLayerChip.Is_Foundry_Frame_Mockup_Updated__c=true;
        objLayerChip.Is_Send_Prime_Data_Updated__c=true;
        objLayerChip.Is_Send_Frame_Data_Updated__c=true;
        objLayerChip.Is_Customer_Prime_Remote_Jobview_Updated__c=true;
        objLayerChip.Is_Customer_Frame_Remote_Jobview_Updated__c=true;
        objLayerChip.Is_Foundry_Prime_Remote_Jobview_Updated__c=true;
        objLayerChip.Is_Foundry_Frame_Remote_Jobview_Updated__c=true;
        objLayerChip.Is_ORC_Updated__c=true;
        objLayerChip.Is_DRW_Updated__c=true;
        objLayerChip.Is_Prime_MEBES_Received_Updated__c=true;
        objLayerChip.Is_Frame_MEBES_Received_Updated__c=true;
        objLayerChip.Is_Customer_MEBES_Jobview_Updated__c=true;
        objLayerChip.Is_Foundry_MEBES_Jobview_Updated__c=true;
        objLayerChip.Is_Tapeout_Centre_MEBES_Jobview_Updated__c=true;
        objLayerChip.Is_Tapeout_Apps_MEBES_Jobview_Updated__c=true;
        objLayerChip.Is_GlobalShuttle_MEBES_Jobview_Updated__c=true;
        objLayerChip.Is_MDP_MEBES_Jobview_Updated__c=true;
        objLayerChip.Is_TDTI_MPW_MEBES_Jobview_Updated__c=true;
        objLayerChip.Customer_MEBES_Jobview__c='Ready';
        objLayerChip.Foundry_MEBES_Jobview__c='Ready';
        objLayerChip.GlobalShuttle_MEBES_Jobview__c='Ready';
        objLayerChip.MDP_MEBES_Jobview__c='Ready';
        objLayerChip.Tapeout_Centre_MEBES_Jobview__c='Ready';
        objLayerChip.Tapeout_Applications_MEBES_Jobview__c='Ready';
        objLayerChip.TDTI_MPW_MEBES_Jobview__c='Ready';
        return objLayerChip;    
     }    
     
      public static EmailTemplate insertTemplate(){
        EmailTemplate temp = [Select Id, Name, Subject, TemplateType, FolderId, Folder.Name,BrandTemplateId,TemplateStyle From EmailTemplate WHERE TemplateType = 'HTML' AND DeveloperName = 'Swift_Hold_Mask_Write_for_Layer' LIMIT 1];
        EmailTemplate tempObj = new EmailTemplate();
        
        tempObj.Name = 'Test_Template';
        tempObj.DeveloperName = 'Test_Template';
        tempObj.FolderId = temp.FolderId;
        tempObj.TemplateType = 'HTML';
        tempObj.BrandTemplateId = temp.BrandTemplateId;
        tempObj.TemplateStyle = temp.TemplateStyle;
        tempObj.IsActive = true;
        tempObj.Subject = 'Notification: {!Mask_Set_Title__c.Name} Hold Mask Write';
        tempObj.HtmlValue = '<table height="400" width="550" cellpadding="5" border="0" cellspacing="5" >'+'\n'
                            +'<tr height="400" valign="top" >'+'\n'
                            +'<td style=" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;" tEditID="c1r1" locked="0" aEditID="c1r1" >'+'\n'
                            +'<![CDATA[<span style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt; background-color: rgb(255, 255, 255);"><font face="Arial, Helvetica, sans-serif"><span style="font-size: 12px;">Mask Set Title:&nbsp;</span></font></span><span style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; background-color: rgb(248, 248, 248);">{!Mask_Set_Title__c.Name}</span><span style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt; background-color: rgb(255, 255, 255);"><font face="Arial, Helvetica, sans-serif"><span style="font-size: 12px;">PTRF:&nbsp;</span></font></span><span style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; background-color: rgb(248, 248, 248);">{!PTRF__c.Name}</span><div><span style="color: rgb(0, 0, 0); font-family: Calibri, sans-serif; font-size: 11pt; line-height: 115%;">Mask Layer(s):&nbsp;</span><font face="Calibri, sans-serif"><span style="font-size: 14.6666669845581px; line-height: 16.8666667938232px; background-color: rgb(255, 255, 255);">{!MRS_Layer_Chip_Association__c.Layer_Identifier__c}</span></font><br style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;"><span style="color: rgb(0, 0, 0); font-family: Arial, Helvetica, sans-serif; font-size: 12px; background-color: rgb(255, 255, 255);">________________________________________&nbsp;</span><br style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;"><br style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;"><p class="MsoNoSpacing"><font face="arial"><span style="font-size: 12pt;">Please note that&nbsp;</span></font><span style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; background-color: rgb(255, 255, 255);">#PARAM:USER_NAME# (#PARAM:USER_ID#)</span><font face="arial" style="font-size: 12pt;"><span style="font-size: 12pt;">&nbsp;has hold mask write for the&nbsp;</span></font><span style="font-size: 12pt;">layer(s)</span></p><p class="MsoNoSpacing"><span style="font-size: 12pt;">{!MRS_Layer_Chip_Association__c.Layer_Identifier__c}</span><span style="font-size: 12pt; color: rgb(0, 0, 255);">.</span></p>'+'\n'
                            +'<p class="MsoNoSpacing" style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;"><o:p>&nbsp;</o:p></p>'+'\n'
                            +'<p class="MsoNoSpacing" style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;">Reason to hold for Mask Write:</p><p class="MsoNoSpacing" style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;"><span style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; background-color: rgb(255, 255, 255);">#PARAM:REASON#</span></p><p class="MsoNoSpacing" style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;"><span style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; background-color: rgb(255, 255, 255);"><br></span></p><p class="MsoNoSpacing" style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;"><font face="Symbol" style="font-size: 13.3333330154419px; text-indent: -24px;">&nbsp;</font><font face="Calibri,sans-serif" size="2" style="text-indent: -24px;"><span style="font-size: 11pt;"><b>[?LINK:LINK2?]</b></span></font><font face="Calibri,sans-serif" size="2" style="text-indent: -24px;"><span style="font-size: 11pt;">&nbsp;</span></font></p><p class="MsoNoSpacing" style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;"><b style="font-family: Calibri, sans-serif; font-size: 14.6666669845581px; text-indent: -24px;">[?LINK:LINK2|PARAM[X={!MRS_Layer_Chip_Association__c.Id}&amp;Jobview=Customer]?]</b></p>'+'\n'
                            +'<p class="MsoNoSpacing" style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;"><o:p>&nbsp;</o:p><b style="font-family: Calibri, sans-serif; font-size: 14.6666669845581px; text-indent: -24px;">[?LINK:LINK2|</b><b style="font-family: Calibri, sans-serif; font-size: 14.6666669845581px; text-indent: -24px;">?]</b></p>'+'\n'
                            +'<p class="MsoNoSpacing" style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;">This is a system generated message, please do not reply. <o:p></o:p></p>'+'\n'
                            +'<span style="color: rgb(0, 0, 0); font-family: Calibri, sans-serif; font-size: 11pt; line-height: 115%;">Best Regards.</span>'+'\n'
                            +'</div>]]>'+'\n'
                            +'</td>'+'\n'
                            +'</tr>'+'\n'
                            +'</table>';
         insert tempObj;
          return tempObj;
    }
    
    private static Account getAccount(string AccountName) {
    
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}