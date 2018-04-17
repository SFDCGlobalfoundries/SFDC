/*
    Author: Pradosh Samal
    Description: This is the test class for MRSEmailServices class.   
    History:
        Pradosh       14032018    - Code creation.
*/
@isTest(SeeAllData=false)
public class MRSEmailServicesTest3 {
    
    @testSetup 
    static void setup() {
        Test.startTest();
        
        SwiftDataUtilityTest.customSystemData();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT0');            
        fieldValueMap.put('Short_Name__c', 'data00');    
        fieldValueMap.put('Has_Valid_NDA__c', true);      
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Copy_Address__c', true);                             
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Account_Type__c','Customer');
        fieldValueMap.put('Organization_Unit__c','sg;us');
        fieldValueMap.put('New_Organization_Unit_Request__c','gf');
        fieldValueMap.put('Financial_Territory__c','Greater China');
        fieldValueMap.put('stage__c','Unqualified');
        fieldValueMap.put('Siebel_Status__c','SUCCESS');
        fieldValueMap.put('Account_Present_In_OT__c', true);
        fieldValueMap.put('Valid_Tech_Geos__c', '0.007UM');
        fieldValueMap.put('Tech_Geo_Granted__c', '0.010UM');
        fieldValueMap.put('Has_Valid_NDA__c', true);
        
        Account accObj = AccountDataFactory.createAccount(fieldValueMap);
        
        /*
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', accObj.id);
        Opportunity oppObj = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValuepoppProgramMap = new Map<String,Object>();
        fieldValuepoppProgramMap.put('Account__c', accObj.id);
        fieldValuepoppProgramMap.put('Opportunity__c', oppObj.id);
        Opportunity_Program__c oppProgramObj = OpportunityProgramDataFactory.createOpportunityProgram(fieldValuepoppProgramMap);
        
        List<Opportunity_Program_Team_Member__c> optmList = new List<Opportunity_Program_Team_Member__c>();
        
        Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgramObj.Id,Team_Role__c='Primary Account Manager',
                                        User__c=createUser1(),Flag_for_Delete__c=false);
        optmList.add(oppProgTM);
        
        Opportunity_Program_Team_Member__c oppProgTM2 = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgramObj.Id,Team_Role__c='Primary Account Manager',
                                        User__c=createUser2(),Flag_for_Delete__c=false);
        optmList.add(oppProgTM2);
                                        
        insert optmList;
        
        Account_Team_Proxy__c atp = createAccountTeamProxy(accObj.Id);
        */
        
        List<Mask_Set_Title__c> mstList = SwiftDataUtilityTest.maskSetTitleList(1);
        
        PTRF__c p = new PTRF__c();
        p.Name = 'PTRF1';
        //p.Device__c = deviceId;
        p.Customer__c = accObj.Id;
        //p.Device_Id__c = deviceId;
        //p.Transaction_Type__c = 'LIFECYCLE';
        p.Transaction_Date__c = date.today();
        p.Order_Type__c = 'TEST';
        p.Prime_Tapeout__c = true;
        p.Frame_Tapeout__c = true;
        p.Frame_Mockup__c = true;
        p.Mask_Set_Title__c = mstList[0].Id;
        p.MaskSetTitle__c = mstList[0].Id;
        p.Status__c = 'Closed';
        p.Prime_DRT__c = 'Prime';
        p.Frame_DRT__c = 'Frame';
        p.Tech_Geo_Value__c = '0.02UM';
        p.Recticle_Type__c = 'Multi Node Reticle (MNR)';
        insert p;

        Test.stopTest();
    }
    
    @isTest
    public static void testRun1() {
        Test.startTest();
        
        Account accObj = getAccount('MYTEST ACCOUNT0');
        
        /*
        Opportunity oppObj = [SELECT Id FROM Opportunity LIMIT 1];
        Opportunity_Program__c oppProgObj = [SELECT Id FROM Opportunity_Program__c LIMIT 1];
        
        //List<Mask_Set_Title__c> mstList = SwiftDataUtilityTest.maskSetTitleList(2);

        //List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList(1,mstList[0]);
        //MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(accObj.Id,mstList[0].Id);
        
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
       
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(accObj.Id, oppObj.Id,oppProgObj.Id,pt.Id);
        PTRF__c objPTRF = SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id, accObj.Id);
        */
        
        List<Mask_Set_Title__c> mstList = [SELECT Id, Name FROM Mask_Set_Title__c];
                
        PTRF__c objPTRF = [SELECT Id, Name FROM PTRF__c];
        
        MRS__c objMRS = SwiftDataUtilityTest.createMrs(mstList[0].Id);
        
        List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
        MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
        MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
        listMRSLA.add(objMRSLA1);
        listMRSLA.add(objMRSLA2);
        insert listMRSLA;   
        
        List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
        MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip001');
        MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip002');
        MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
        listMRSCD.add(objMRSCD1);
        listMRSCD.add(objMRSCD2);
        listMRSCD.add(objMRSCD3);//MRS_Layer_Chip_Association__c Layer_Chip_Status__c
        insert listMRSCD;
        
        List < MRS_Layer_Chip_Association__c > listMRSLCA = new List < MRS_Layer_Chip_Association__c > ();
        MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD1.Id, PTRF__c = objPTRF.Id, Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready', Tech_Geo__c = '0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD2.Id, PTRF__c = objPTRF.Id, Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready', Tech_Geo__c = '0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD1.Id, PTRF__c = objPTRF.Id, Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready', Tech_Geo__c = '0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD2.Id, PTRF__c = objPTRF.Id, Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready', Tech_Geo__c = '0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD3.Id, PTRF__c = objPTRF.Id, Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready', Tech_Geo__c = '0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD3.Id, PTRF__c = objPTRF.Id, Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready', Tech_Geo__c = '0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        listMRSLCA.add(objMRSLCA1);
        listMRSLCA.add(objMRSLCA2);
        listMRSLCA.add(objMRSLCA3);
        listMRSLCA.add(objMRSLCA4);
        listMRSLCA.add(objMRSLCA5);
        listMRSLCA.add(objMRSLCA6);
        insert listMRSLCA;
        
        MRSEmailServices objMRSEmailServices = new MRSEmailServices();
        objMRSEmailServices.sendEmailToResponderWithError(new List<MRS_Layer_Chip_Association__c>{objMRSLCA1} , 'test@gobalfoundries.co', mstList[0].Name, objPTRF.Name);
        
        System.assertEquals(objMRSLA1.MRS__c, objMRSCD1.MRS__c);
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.fromaddress = 'testMRS@test.com';
        email.fromname = 'testMRS';
        MRSEmailServices mrsEmailServicesObj = new MRSEmailServices();
        email.subject = 'Reminder Notification: Device ' + 'MYMST00' + ' : Gating Customer GDSOUT jobview for layer(s)' + 'RX';
        email.plainTextBody = 'Approved Mask Set Title: ' + 'MYMST00' + ' \n' + +'________________________________________ \n' + +' Dear Sir/Madam, \n' + +'Please be informed the following GDSOUT is ready for your gating review \n' + +'Chip Name:' + 'Chip002' + ' layer(s) ' + 'RXAZ' + 'PTRF Number: ' + 'PTRF1' + ' \n' + +'<Email Content from CAD Systems> \n' + +'jobview=Customer&' + +'Please approve in MRS system once the data is good to proceed tapeout. \n' + +'You can also approve by replying to this message with the text ?Approved? \n' + +'Thank you. \n' + +'This is a system generated message, please do not reply. \n' + +'Best Regards. ';
        mrsEmailServicesObj.handleInboundEmail(email, env);
        
        email.plainTextBody = 'Approved Mask Set Title: ' + 'MYMST00' + ' \n' + +' \n' + +' Dear Sir/Madam, \n' + +'Please be informed the following GDSOUT is ready for your gating review \n' + +'Chip Name:' + 'Chip002' + ' layer(s) ' + 'RXAZ' + 'PTRF Number: ' + 'PTRF1' + ' \n' + +'<Email Content from CAD Systems> \n' + +'jobview=Customer&' + +'Please approve in MRS system once the data is good to proceed tapeout. \n' + +'You can also approve by replying to this message with the text ?Approved? \n' + +'Thank you. \n' + +'This is a system generated message, please do not reply. \n' + +'Best Regards. ';
        mrsEmailServicesObj.handleInboundEmail(email, env);
        
        Test.stopTest();
    }
    
    @isTest
    public static void testRun2() {
        Test.startTest();
        
        Account accObj = getAccount('MYTEST ACCOUNT0');
        
        /*
        Opportunity oppObj = [SELECT Id FROM Opportunity LIMIT 1];
        Opportunity_Program__c oppProgObj = [SELECT Id FROM Opportunity_Program__c LIMIT 1];
        
        //List<Mask_Set_Title__c> mstList = SwiftDataUtilityTest.maskSetTitleList(2);
        
        //List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList(1,mstList[0]);
        //MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(accObj.Id,mstList[0].Id);
        
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
       
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(accObj.Id, oppObj.Id,oppProgObj.Id,pt.Id);
        PTRF__c ptrf = SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id, accObj.Id);
        */
        
        List<Mask_Set_Title__c> mstList = [SELECT Id, Name FROM Mask_Set_Title__c];
                
        PTRF__c ptrf = [SELECT Id, Name FROM PTRF__c];
        
        MRS__c objMRS = SwiftDataUtilityTest.createMrs(mstList[0].Id);
        
        List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
        MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
        MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
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
        
        MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=ptrf.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        insert objMRSLCA1;
        
        MRSEmailServices objMRSEmailServices = new MRSEmailServices();
        objMRSEmailServices.sendEmailToResponderWithError(new List<MRS_Layer_Chip_Association__c>{objMRSLCA1} , 'test@gobalfoundries.co', mstList[0].Name, ptrf.Name);
        
        System.assertEquals(objMRSLA1.MRS__c, objMRSCD1.MRS__c);
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.fromaddress = 'testMRS@test.com';
        email.fromname = 'testMRS';
        MRSEmailServices mrsEmailServicesObj = new MRSEmailServices();
        email.subject = 'Reminder Notification: Device ' + 'MYMST00' + ' : Gating Customer MEBES jobview for layer(s)' + 'RX';
        email.plainTextBody = 'Approved Mask Set Title: ' + 'MYMST00' + ' \n' + +'________________________________________ \n' + +' Dear Sir/Madam, \n' + +'Please be informed the following MEBES is ready for your gating review \n' + +'Chip Name:' + 'Chip002' + ' layer(s) ' + 'RXAZ' + 'PTRF Number: ' + 'PTRF1' + ' \n' + +'<Email Content from CAD Systems> \n' + +'jobview=Customer&' + +'Please approve in MRS system once the data is good to proceed tapeout. \n' + +'You can also approve by replying to this message with the text ?Approved? \n' + +'Thank you. \n' + +'This is a system generated message, please do not reply. \n' + +'Best Regards. ';
        mrsEmailServicesObj.handleInboundEmail(email, env);
        
        email.plainTextBody = 'Approved Mask Set Title: ' + 'MYMST00' + ' \n' + +'\n' + +' Dear Sir/Madam, \n' + +'Please be informed the following MEBES is ready for your gating review \n' + +'Chip Name:' + 'Chip002' + ' layer(s) ' + 'RXAZ' + 'PTRF Number: ' + 'PTRF1' + ' \n' + +'<Email Content from CAD Systems> \n' + +'jobview=Customer&' + +'Please approve in MRS system once the data is good to proceed tapeout. \n' + +'You can also approve by replying to this message with the text ?Approved? \n' + +'Thank you. \n' + +'This is a system generated message, please do not reply. \n' + +'Best Regards. ';
        mrsEmailServicesObj.handleInboundEmail(email, env);
        Test.stopTest();
    }
    
    @isTest
    public static void testRun3() {
        //Test.startTest();
        
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User userSA = new User(alias = 'testMRS', email = 'testMRS@test.com',
        emailencodingkey = 'UTF-8', lastname = 'testMRSLast', firstname = 'testMRSFirst', languagelocalekey = 'en_US',
        localesidkey = 'en_US', profileid = sysAdminProfile.Id,
        timezonesidkey = 'America/Los_Angeles', username = 'testMRS@test.com', communitynickname = 'testMRS', isActive = true);
        insert userSA;
        
        Account accObj = getAccount('MYTEST ACCOUNT0');
        Test.startTest();
        /*
        Opportunity oppObj = [SELECT Id FROM Opportunity LIMIT 1];
        Opportunity_Program__c oppProgObj = [SELECT Id FROM Opportunity_Program__c LIMIT 1];
        Test.startTest();
        //List<Mask_Set_Title__c> mstList = SwiftDataUtilityTest.maskSetTitleList(2);
        
        //List<DRT__c> drtList=SwiftDataUtilityTest.createDRTList(1,mstList[0]);
        //MST_Config__c mstConfig = SwiftDataUtilityTest.createMSTconfig(accObj.Id,mstList[0].Id);
        
        Process_Technology__c pt = SwiftDataUtilityTest.createProcessTechnologyForDRT();
       
        Device__c testDevice = SwiftDataUtilityTest.createDeviceWithPT(accObj.Id, oppObj.Id,oppProgObj.Id,pt.Id);
        PTRF__c objPTRF = SwiftDataUtilityTest.createPTRF_ForDRT(mstList[0].Id, testDevice.Id, accObj.Id);
        */

        List<Mask_Set_Title__c> mstList = [SELECT Id, Name FROM Mask_Set_Title__c];
                
        PTRF__c objPTRF = [SELECT Id FROM PTRF__c];
        
        List < PTRF_JobViewer_Info__c > listPTRFJVI = new List < PTRF_JobViewer_Info__c > ();
        PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name = 'SAC', PTRF__c = objPTRF.Id, Jobview__c = 'Customer', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
        PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name = 'SAF', PTRF__c = objPTRF.Id, Jobview__c = 'Foundry', Jobview_Type__c = 'Frame Mockup;Prime GDSOUT Review;MEBES Jobview', User__c = userSA.Id);
        listPTRFJVI.add(objPTRFJVC);
        listPTRFJVI.add(objPTRFJVF);
        insert listPTRFJVI; 
        
        MRS__c objMRS = SwiftDataUtilityTest.createMrs(mstList[0].Id);
        
        List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
        MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
        MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c='123');
        listMRSLA.add(objMRSLA1);
        listMRSLA.add(objMRSLA2);
        insert listMRSLA;   
        
        List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
        MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip001');
        MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip002');
        MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
        listMRSCD.add(objMRSCD1);
        listMRSCD.add(objMRSCD2);
        listMRSCD.add(objMRSCD3);//MRS_Layer_Chip_Association__c Layer_Chip_Status__c
        insert listMRSCD;
        
        List < MRS_Layer_Chip_Association__c > listMRSLCA = new List < MRS_Layer_Chip_Association__c > ();
        MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD1.Id, PTRF__c = objPTRF.Id, Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready', Tech_Geo__c = '0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD2.Id, PTRF__c = objPTRF.Id, Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready', Tech_Geo__c = '0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD1.Id, PTRF__c = objPTRF.Id, Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready', Tech_Geo__c = '0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD2.Id, PTRF__c = objPTRF.Id, Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready', Tech_Geo__c = '0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA1.Id, Chip__c = objMRSCD3.Id, PTRF__c = objPTRF.Id, Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready', Tech_Geo__c = '0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c = objMRSLA2.Id, Chip__c = objMRSCD3.Id, PTRF__c = objPTRF.Id, Foundry_Frame_Mockup__c = 'Ready', Customer_Frame_Mockup__c = 'Ready', Tech_Geo__c = '0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress');
        listMRSLCA.add(objMRSLCA1);
        listMRSLCA.add(objMRSLCA2);
        listMRSLCA.add(objMRSLCA3);
        listMRSLCA.add(objMRSLCA4);
        listMRSLCA.add(objMRSLCA5);
        listMRSLCA.add(objMRSLCA6);
        insert listMRSLCA;
        
        System.assertEquals(objMRSLA1.MRS__c, objMRSCD1.MRS__c);
        
        List < String > mrslcaIdList = new List < String > ();
        for (MRS_Layer_Chip_Association__c mrsObj: listMRSLCA) {
            mrslcaIdList.add(mrsObj.Id);
        }
        
        List<Approval_Helper__c> approvalHelperList = new List<Approval_Helper__c>();
        Approval_Helper__c app1 = insertApprovalHelper(mrslcaIdList, 'Customer_Frame_Mockup__c');
        approvalHelperList.add(app1);
        Approval_Helper__c app2 = insertApprovalHelper(mrslcaIdList, 'Foundry_Frame_Mockup__c');
        approvalHelperList.add(app2);
        insert approvalHelperList;
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.fromaddress = 'testMRS@test.com';
        email.fromname = 'testMRS';
        MRSEmailServices mrsEmailServicesObj = new MRSEmailServices();
        email.subject = 'Notification: Device ' + 'MYMST00' + ' : Gating Frame Mockup review for layer(s)' + 'RX';
        email.plainTextBody = 'Disapprove' + '\n' + +'Approval Id :' + app1.Id + '#' + '\n' + +'Mask Set Title:' + 'MYMST00' + ' \n' + +'Mask Layer: ' + 'RX-AZ-123' + '  \n' + +'PTRF Number: ' + 'PTRF1' + ' \n' + +'________________________________________ \n' + +' Dear Sir/Madam, \n' + +'Please be informed the following frame mockup is ready for your gating review \n' + +'Chip Name:' + 'Frame' + ' layer(s) ' + 'RXAZ' + ' \n' + +'<Email Content from CAD Systems> \n' + +'type=Customer&' + +'Please approve in MRS system once the data is good to proceed tapeout. \n' + +'You can also approve by replying to this message with the text ?Disapprove? \n' + +'Thank you. \n' + +'This is a system generated message, please do not reply. \n' + +'Best Regards. ';
        mrsEmailServicesObj.handleInboundEmail(email, env);
        
        email.subject = 'Notification: Device ' + 'MYMST00' + ' : Gating Frame Mockup review for layer(s)' + 'RX';
        email.plainTextBody = 'Disapprove' + '\n' + +'Approval Id :' + app2.Id + '#' + '\n' + +'Mask Set Title:' + 'MYMST00' + ' \n' + +'Mask Layer: ' + 'RX-AZ-123' + '  \n' + +'PTRF Number: ' + 'PTRF1' + ' \n' + +'________________________________________ \n' + +' Dear Sir/Madam, \n' + +'Please be informed the following frame mockup is ready for your gating review \n' + +'Chip Name:' + 'Frame' + ' layer(s) ' + 'RXAZ' + ' \n' + +'<Email Content from CAD Systems> \n' + +'type=Customer&' + +'Please approve in MRS system once the data is good to proceed tapeout. \n' + +'You can also approve by replying to this message with the text ?Disapprove? \n' + +'Thank you. \n' + +'This is a system generated message, please do not reply. \n' + +'Best Regards. ';
        mrsEmailServicesObj.handleInboundEmail(email, env);
        
        Test.stopTest();
    }
    
    public static Approval_Helper__c insertApprovalHelper(List < String > mrslcaIdList, String field) {

        Approval_Helper__c appHelperObj = new Approval_Helper__c();
        appHelperObj.MRSLCA_Id_to_approve__c = String.join(mrslcaIdList, ';');
        appHelperObj.Field_to_Update__c = field;
        appHelperObj.PTRF_Number__c = 'PTRF1';
        appHelperObj.Mask_Set_Title__c = 'MST001';

        //insert appHelperObj;
        return appHelperObj;
    }
    
    private static Account getAccount(string AccountName) {
    
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }   
    
    static Id createUser1(){
        User usr1 = [select id from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true limit 1];
        return usr1.Id;
    }
    
    static Id createUser2(){
        User usr2 = [select id from User where profileId in (select id from Profile where Name='GF System Admin') and IsActive=true limit 1];
        return usr2.Id;
    }
    
    static Account_Team_Proxy__c createAccountTeamProxy(Id testAcctId) {        
                
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c();       
        atp.Account__c = testAcctId ;      
        //User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');      
        atp.User__c = createUser1();        
        atp.Team_Role__c = 'Account Manager';      
        atp.Account_Access__c = 'Read/Write';      
        atp.Opportunity_Access__c = 'Read/Write';      
                    
        insert atp;        
                
        return atp;        
    }
}