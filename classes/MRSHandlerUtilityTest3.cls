@istest(SeeAllData=false)
private class MRSHandlerUtilityTest3 {
	
	/**
	This method initialize data using throughout this test class.
	The create data method are: 
	- SwiftDataUtilityTest.customSystemData();
	
	@author		SWIFT TEAM
	@since		7-April-2015
	*/
	@testSetup static void setup() {
		SwiftDataUtilityTest.customSystemData();
	}
    
    /**
        This test method sets All the Layer Chip values.
        @method name: setLayerChipFlagValues
        @parameter:   MRS_Layer_Chip_Association__c object.
        @return :     MRS_Layer_Chip_Association__c object.
     **/    

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
     
    /**
        This test method tests the email sending methods of MRSHandlerUtility class - Part 7.
        @method name: EmailSendingMethodsTest7
        @parameter:   none.
        @return :     None.
     **/
     
     public static testMethod void EmailSendingMethodsTest7(){
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        Group groupTA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Application'];
        Group groupTC = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Centre'];
        Group groupTMPW = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_TDTI_MPW'];
        Group groupMDP = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_MDP'];
        Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
        Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Admin'];
        List<GroupMember> listGM = new List<GroupMember>(); 
        GroupMember groupMemberTA = new GroupMember(GroupId = groupTA.Id,UserOrGroupId = userSA.Id); 
        GroupMember groupMemberTC = new GroupMember(GroupId = groupTC.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMPW = new GroupMember(GroupId = groupTMPW.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMDP = new GroupMember(GroupId = groupMDP.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);          
        listGM.add(groupMemberTA);
        listGM.add(groupMemberTC);
        listGM.add(groupMemberTMPW);
        listGM.add(groupMemberTMDP);
        listGM.add(groupMemberGS);
        listGM.add(groupMemberSA);
        insert listGM;   
        System.runAs(sysAdminUser){       
        	// comment-out, refactor with testSetup method setup()           
            // SwiftDataUtilityTest.customSystemData();
            // Insert Custom Settings Data---//
            //---------------------------------------------//

            Account acc = SwiftDataUtilityTest.createTestAccount();
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
            Opportunity_Access__c='Read/Write',Team_Role__c='Primary Customer Service Rep',Sequence_No__c='1',Account_Role_ID__c='test1239');       
            insert atp;
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Tech_Geo_Value__c='0.019UM',Customer_jobview__c='Gating mask release');
            insert objPTRF;
            DRT__c objDRT = new DRT__c(Name='DRT1');
            insert objDRT;
            DRT_PTRF_Association__c objDRTPTRF = new DRT_PTRF_Association__c(PTRF__c=objPTRF.Id,DRT__c=objDRT.Id);
            insert objDRTPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            insert listPTRFJVI;
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            insert objMRS;
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
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id);
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
            insert listMRSLCA;
            List<Notes__c> listNotes = new List<Notes__c>();
            Notes__c objNotes1 = new Notes__c(Body__c='Reason1',Category__c='Customer Frame Remote Jobview Setup',ParentId__c=objMRSLCA1.Id);
            Notes__c objNotes2 = new Notes__c(Body__c='Reason2',Category__c='Foundry Frame Remote Jobview Setup',ParentId__c=objMRSLCA2.Id);
            Notes__c objNotes3 = new Notes__c(Body__c='Reason3',Category__c='Customer Prime Remote Jobview Setup',ParentId__c=objMRSLCA3.Id);
            Notes__c objNotes4 = new Notes__c(Body__c='Reason4',Category__c='Foundry Prime Remote Jobview Setup',ParentId__c=objMRSLCA4.Id);
            Notes__c objNotes5 = new Notes__c(Body__c='Reason5',Category__c='Prime MEBES Received',ParentId__c=objMRSLCA5.Id);
            Notes__c objNotes6 = new Notes__c(Body__c='Reason6',Category__c='Frame MEBES Received',ParentId__c=objMRSLCA6.Id);
            listNotes.add(objNotes1);
            listNotes.add(objNotes2);
            listNotes.add(objNotes3);
            listNotes.add(objNotes4);
            listNotes.add(objNotes5);
            listNotes.add(objNotes6);
            insert listNotes;
            system.assertEquals(listNotes.size(), 6);
            Map<Id,MRS_Layer_Chip_Association__c> mapLayerChipsOld = new Map<Id,MRS_Layer_Chip_Association__c>();
            Map<Id,MRS_Layer_Chip_Association__c> mapLayerChipsNew = new Map<Id,MRS_Layer_Chip_Association__c>();
            List<MRS_Layer_Chip_Association__c> listMRSLCANew = new List<MRS_Layer_Chip_Association__c>();  
            set<String> setLayerChipIds = new set<String>();        
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
        test.startTest();
            update listMRSLCANew;
            List<MRS_Layer_Chip_Association__c> listMRSLCANewQueried = new List<MRS_Layer_Chip_Association__c>();
            for(MRS_Layer_Chip_Association__c obj:[SELECT Approved__c,Chip_Hold_Warning__c,Chip_Name__c,Chip__c,CreatedById,CreatedDate,
            Customer_Frame_Mockup_Date__c,Customer_Frame_Mockup__c,Customer_Frame_Remote_Jobview_Setup_Date__c,Customer_Frame_Remote_Jobview_Setup__c,
            Customer_GDSOUT_Review_Date__c,Customer_GDSOUT_Review__c,Customer_MEBES_Jobview_Date__c,Customer_MEBES_Jobview__c,Customer_Name__c,
            Customer_Prime_Remote_Jobview_Setup_Date__c,Customer_Prime_Remote_Jobview_Setup__c,Device_Id__c,DRT_Name__c,DRT__c,DRW_Date__c,DRW__c,
            Error_Message_Oracle_DB__c,Error_Message_PTRF_Layer_SendPrimeFrame__c,Error_Message_Sync_Layer_Status__c,Foundry_Frame_Mockup_Date__c,
            Foundry_Frame_Mockup__c,Foundry_Frame_Remote_Jobview_Setup_Date__c,Foundry_Frame_Remote_Jobview_Setup__c,Foundry_GDSOUT_Review_Date__c,
            Foundry_GDSOUT_Review__c,Foundry_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview__c,Foundry_Prime_Remote_Jobview_Setup_Date__c,
            Foundry_Prime_Remote_Jobview_Setup__c,Frame_MEBES_Received_Date__c,Frame_MEBES_Received__c,Frame_TapeOut__c,Layer__r.Mask_Layer_Rev__c,
            GlobalShuttle_MEBES_Jobview_Date__c,GlobalShuttle_MEBES_Jobview__c,Hold_Mask_Write_Date__c,Hold_Mask_Write__c,Id,IsDeleted,
            Is_Active__c,Is_Customer_Frame_Mockup_Updated__c,Is_Customer_Frame_Remote_Jobview_Updated__c,Is_Customer_GDSOUT_Review_Updated__c,
            Is_Customer_MEBES_Jobview_Updated__c,Is_Customer_Prime_Remote_Jobview_Updated__c,Is_DRW_Updated__c,Is_Foundry_Frame_Mockup_Updated__c,
            Is_Foundry_Frame_Remote_Jobview_Updated__c,Is_Foundry_GDSOUT_Review_Updated__c,Is_Foundry_MEBES_Jobview_Updated__c,PTRF__r.Tech_Geo__c,
            Is_Foundry_Prime_Remote_Jobview_Updated__c,Is_Frame_MEBES_Received_Updated__c,Is_GlobalShuttle_MEBES_Jobview_Updated__c,
            Is_MDP_MEBES_Jobview_Updated__c,Is_ORC_Updated__c,Is_Prime_MEBES_Received_Updated__c,Is_Send_Frame_Data_Updated__c,Chip__r.Name,
            Is_Send_Prime_Data_Updated__c,Is_Tapeout_Apps_MEBES_Jobview_Updated__c,Is_Tapeout_Centre_MEBES_Jobview_Updated__c,
            Is_TDTI_MPW_MEBES_Jobview_Updated__c,LastModifiedById,LastModifiedDate,lastmodifieddate_sgt__c,PTRF__r.Customer_jobview__c,
            Last_Sync_Req_Timestamp_Layer_Gen__c,Last_Sync_Req_Timestamp_ORCN_Job__c,Last_Sync_Req_Timestamp_Receive_MEBES__c,
            Last_Sync_Req_Timestamp_Remote_Jobview__c,Last_Sync_Req_Timestamp_Send_Frame__c,Last_Sync_Req_Timestamp_Send_Prime__c,
            Last_Sync_Req_Timestamp__c,Layer_Chip_Old_Status__c,Layer_Chip_Status_Date__c,Layer_Chip_Status__c,Layer_Name__c,Layer__r.Name,
            Layer_Send_Frame_Data__c,Layer_Send_Prime_Data__c,Layer__c,Lock_Record__c,Mask_Layer_Status__c,Mask_Layer__c,Mask_Set_Title_Name__c,
            MDP_MEBES_Jobview_Date__c,MDP_MEBES_Jobview__c,MRS_ID__c,MST__c,Name,ORC_Date__c,ORC__c,Prime_MEBES_Received_Date__c,
            Prime_MEBES_Received__c,Prime_TapeOut__c,PTRF_Number__c,PTRF_Or_DRT__c,PTRF__c,Rev__c,ROM_Code__c,Send_Frame_Data_Date__c,
            Send_Frame_Data__c,Send_Prime_Data_Date__c,Send_Prime_Data__c,Synced_with_Oracle_DB__c,Sync_Layer_Status__c,PTRF__r.MaskSetTitle__r.Name,
            Sync_PTRF_Layer_SendPrimeFrame_dotNET__c,Sync_PTRF_Layer_to_SWIFT_dotNET__c,SystemModstamp,Tapeout_Applications_MEBES_Jobview_Date__c,
            Tapeout_Applications_MEBES_Jobview__c,Tapeout_Centre_MEBES_Jobview_Date__c,Tapeout_Centre_MEBES_Jobview__c,TDTI_MPW_MEBES_Date__c,
            TDTI_MPW_MEBES_Jobview__c,Tech_Geo__c,Trigger_Sync_Layer_Status__c,Void__c,Layer__r.ROM_Code__c FROM MRS_Layer_Chip_Association__c where Id IN:setLayerChipIds]){
                listMRSLCANewQueried.add(obj);  
                mapLayerChipsNew.put(obj.Id,obj);   
            }
            
            MRSHandlerUtility.sendRedyMailToGDSOUTReviewManualUpdate(listMRSLCANewQueried,'CAD Email Content',true);
            MRSHandlerUtility.sendRedyMailToGDSOUTReviewManualUpdate(listMRSLCANewQueried,'CAD Email Content',false);             
            test.stopTest();
        }   
     }
     
     /**
        This test method tests the email sending methods of MRSHandlerUtility class - Part 8.
        @method name: EmailSendingMethodsTest8
        @parameter:   none.
        @return :     None.
     **/
     
     public static testMethod void EmailSendingMethodsTest8(){
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        Group groupTA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Application'];
        Group groupTC = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Centre'];
        Group groupTMPW = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_TDTI_MPW'];
        Group groupMDP = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_MDP'];
        Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
        Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Admin'];
        List<GroupMember> listGM = new List<GroupMember>(); 
        GroupMember groupMemberTA = new GroupMember(GroupId = groupTA.Id,UserOrGroupId = userSA.Id); 
        GroupMember groupMemberTC = new GroupMember(GroupId = groupTC.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMPW = new GroupMember(GroupId = groupTMPW.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMDP = new GroupMember(GroupId = groupMDP.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);          
        listGM.add(groupMemberTA);
        listGM.add(groupMemberTC);
        listGM.add(groupMemberTMPW);
        listGM.add(groupMemberTMDP);
        listGM.add(groupMemberGS);
        listGM.add(groupMemberSA);
        insert listGM;   
        System.runAs(sysAdminUser){  
        	// comment-out, refactor with testSetup method setup()               
            // SwiftDataUtilityTest.customSystemData();
            // Insert Custom Settings Data---//
            //---------------------------------------------//

            Account acc = SwiftDataUtilityTest.createTestAccount();
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
            Opportunity_Access__c='Read/Write',Team_Role__c='Primary Customer Service Rep',Sequence_No__c='1',Account_Role_ID__c='test1239');       
            insert atp;
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Status__c='Active',Order_Type__c ='New Prototype',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Tech_Geo_Value__c='0.019UM',Customer_jobview__c='Gating mask release',Foundry_jobview__c='Gating mask release',Maskshop__c='Maskshop1',Fab__c='Fab1',Prime_Tapeout__c=true,Frame_Tapeout__c=true,DRW_Start_before_PT__c=true,DRC_DRW_Status__c = 'DRW',DRW_Completed_before_PT__c=true);
            insert objPTRF;
            PTRF__c objPTRF2 = new PTRF__c(Name ='PTRF2',Status__c='Active',Order_Type__c ='Retrofit',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Tech_Geo_Value__c='0.021UM',Customer_jobview__c='Not gating mask release',Foundry_jobview__c='Not gating mask release',Maskshop__c='Maskshop1',Fab__c='Fab1',Prime_Tapeout__c=true,Frame_Tapeout__c=true,DRW_Start_before_PT__c=true,DRC_DRW_Status__c = 'DRW',DRW_Completed_before_PT__c=true);
            insert objPTRF2;
            DRT__c objDRT = new DRT__c(Name='DRT1');
            insert objDRT;
            DRT_PTRF_Association__c objDRTPTRF = new DRT_PTRF_Association__c(PTRF__c=objPTRF.Id,DRT__c=objDRT.Id);
            insert objDRTPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            List<PTRF_JobViewer_Info__c> listPTRFJVIQueried = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVC2 = new PTRF_JobViewer_Info__c(Name='SAC2',PTRF__c=objPTRF2.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF2 = new PTRF_JobViewer_Info__c(Name='SAF2',PTRF__c=objPTRF2.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);            
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            listPTRFJVI.add(objPTRFJVC2);
            listPTRFJVI.add(objPTRFJVF2);
            insert listPTRFJVI;
            for(PTRF_JobViewer_Info__c obj:[select Name,PTRF__c,Jobview__c,Jobview_Type__c,User__c,User__r.email from PTRF_JobViewer_Info__c]){
                listPTRFJVIQueried.add(obj);    
            }
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            insert objMRS;
            List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123',Tech_Geo__c='0.019UM',LogicalOperation__c='TECN001;TECN002');
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c='123',Tech_Geo__c='0.019UM',LogicalOperation__c='TECN003');
            MRS_Layer_Association__c objMRSLA3 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Shipped',Name='RZ',Mask_Layer_Rev__c='AZ',ROM_Code__c='123',Tech_Geo__c='0.019UM',LogicalOperation__c='TECN004');
            listMRSLA.add(objMRSLA1);
            listMRSLA.add(objMRSLA2);
            listMRSLA.add(objMRSLA3);
            test.startTest();
            insert listMRSLA;
            //MRSHandlerUtility.executeInsertMLA(listMRSLA);            
            /*listMRSLA.clear();
            objMRSLA1.Layer_Status__c='Shipped';
            objMRSLA2.Layer_Status__c='Shipped';
            listMRSLA.add(objMRSLA1);
            listMRSLA.add(objMRSLA2);
            MRSHandlerUtility.executeUpdateMLA(listMRSLA);*/            
            Map<String,MRS_Layer_Association__c> mapLayersNew = new Map<String,MRS_Layer_Association__c>();
            set<MRS_Layer_Association__c> setLayersNew = new set<MRS_Layer_Association__c>();
            set<String> setShippedLayerIds = new set<String>();
            for(MRS_Layer_Association__c obj:[select Mask_Set_Title_Name__c,MRS__r.Mask_Set_Title__r.Name,MRS__c,Layer_Status__c,Name,Mask_Layer_Rev__c,ROM_Code__c,Tech_Geo__c,CreatedById,LogicalOperation__c from MRS_Layer_Association__c]){
                mapLayersNew.put(obj.Id,obj);
                setLayersNew.add(obj);
                setShippedLayerIds.add(obj.Id); 
            }  
            List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
            MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip001');
            MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip002');
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            //MRSHandlerUtility.executeInsertMCD(listMRSCD);            
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id,DRT__c=null);
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id,DRT__c=null);
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id,DRT__c=null);
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF2.Id,Tech_Geo__c='0.021UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id,DRT__c=null);
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF2.Id,Tech_Geo__c='0.021UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id,DRT__c=null);
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF2.Id,Tech_Geo__c='0.021UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id,DRT__c=null);
            MRS_Layer_Chip_Association__c objMRSLCA7 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA3.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF2.Id,Tech_Geo__c='0.021UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id,DRT__c=null);
            objMRSLCA1=setLayerChipFlagValues(objMRSLCA1);
            objMRSLCA2=setLayerChipFlagValues(objMRSLCA2);
            objMRSLCA3=setLayerChipFlagValues(objMRSLCA3);
            objMRSLCA4=setLayerChipFlagValues(objMRSLCA4);
            objMRSLCA5=setLayerChipFlagValues(objMRSLCA5);
            objMRSLCA6=setLayerChipFlagValues(objMRSLCA6);
            objMRSLCA7=setLayerChipFlagValues(objMRSLCA7);
            listMRSLCA.add(objMRSLCA1);
            listMRSLCA.add(objMRSLCA2);
            listMRSLCA.add(objMRSLCA3);
            listMRSLCA.add(objMRSLCA4);
            listMRSLCA.add(objMRSLCA5);
            listMRSLCA.add(objMRSLCA6);
            listMRSLCA.add(objMRSLCA7);
            insert listMRSLCA;
            //MRSHandlerUtility.executeInsertMCLA(listMRSLCA);           
            List<Notes__c> listNotes = new List<Notes__c>();
            Notes__c objNotes1 = new Notes__c(Body__c='Reason1',Category__c='Customer Frame Remote Jobview Setup',ParentId__c=objMRSLCA1.Id);
            Notes__c objNotes2 = new Notes__c(Body__c='Reason2',Category__c='Foundry Frame Remote Jobview Setup',ParentId__c=objMRSLCA2.Id);
            Notes__c objNotes3 = new Notes__c(Body__c='Reason3',Category__c='Customer Prime Remote Jobview Setup',ParentId__c=objMRSLCA3.Id);
            Notes__c objNotes4 = new Notes__c(Body__c='Reason4',Category__c='Foundry Prime Remote Jobview Setup',ParentId__c=objMRSLCA4.Id);
            Notes__c objNotes5 = new Notes__c(Body__c='Reason5',Category__c='Prime MEBES Received',ParentId__c=objMRSLCA5.Id);
            Notes__c objNotes6 = new Notes__c(Body__c='Reason6',Category__c='Frame MEBES Received',ParentId__c=objMRSLCA6.Id);
            Notes__c objNotes7 = new Notes__c(Body__c='Reason7',Category__c='Tapeout Centre/MDP MEBES Jobview',ParentId__c=objMRSLCA6.Id);
            Notes__c objNotes8 = new Notes__c(Body__c='Reason8',Category__c='Tapeout Applications MEBES Jobview',ParentId__c=objMRSLCA6.Id);
            Notes__c objNotes9 = new Notes__c(Body__c='Reason9',Category__c='GlobalShuttle/TDTI-MPW MEBES Jobview',ParentId__c=objMRSLCA6.Id);          
            listNotes.add(objNotes1);
            listNotes.add(objNotes2);
            listNotes.add(objNotes3);
            listNotes.add(objNotes4);
            listNotes.add(objNotes5);
            listNotes.add(objNotes6);
            listNotes.add(objNotes7);
            listNotes.add(objNotes8);
            listNotes.add(objNotes9);
            insert listNotes;
            Maskshop_Configuration__c objMC = new Maskshop_Configuration__c(Name='Maskshop1');
            insert objMC;
            Released_Mask_Write_Distribution_List__c objRMWDL = new Released_Mask_Write_Distribution_List__c(Maskshop__c=objMC.Id,Distribution_List__c='test@test.com');
            insert objRMWDL;
            Fab_Distribution_Table__c objFDT = new Fab_Distribution_Table__c(Fab_No__c='Fab1',Distribution_List__c='test2@test2.com');
            insert objFDT;
            List<TECN__c> listTECN = new List<TECN__c>();
            TECN__c objTECN1 = new TECN__c(Name='TECN001',TECN_No__c='TECN001',TECN_Status__c='Active',Related_TECN_No__c='TECN001');
            TECN__c objTECN2 = new TECN__c(Name='TECN002',TECN_No__c='TECN002',TECN_Status__c='Released',Related_TECN_No__c='TECN002');
            TECN__c objTECN3 = new TECN__c(Name='TECN003',TECN_No__c='TECN003',TECN_Status__c='Released',Related_TECN_No__c='TECN003');
            listTECN.add(objTECN1);
            listTECN.add(objTECN2);
            listTECN.add(objTECN3);
            insert listTECN;
            set<String> setTECNNumbers = new set<String>{'TECN001','TECN002','TECN003'};
            Map<Id,MRS_Layer_Chip_Association__c> mapLayerChipsOld = new Map<Id,MRS_Layer_Chip_Association__c>();
            Map<Id,MRS_Layer_Chip_Association__c> mapLayerChipsNew = new Map<Id,MRS_Layer_Chip_Association__c>();            
            List<MRS_Layer_Chip_Association__c> listMRSLCANew = new List<MRS_Layer_Chip_Association__c>();  
            set<String> setLayerChipIds = new set<String>();        
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
            //MRSHandlerUtility.executeUpdateMCLA(listMRSLCANew);            
            List<MRS_Layer_Chip_Association__c> listMRSLCANewQueried = new List<MRS_Layer_Chip_Association__c>();
            map<Id,List<MRS_Layer_Chip_Association__c>> mapLayerIdsToLayerChips = new map<Id,List<MRS_Layer_Chip_Association__c>>();
            for(MRS_Layer_Chip_Association__c obj:[SELECT Approved__c,Chip_Hold_Warning__c,Chip_Name__c,Chip__c,CreatedById,CreatedDate,
            Customer_Frame_Mockup_Date__c,Customer_Frame_Mockup__c,Customer_Frame_Remote_Jobview_Setup_Date__c,Customer_Frame_Remote_Jobview_Setup__c,
            Customer_GDSOUT_Review_Date__c,Customer_GDSOUT_Review__c,Customer_MEBES_Jobview_Date__c,Customer_MEBES_Jobview__c,Customer_Name__c,
            Customer_Prime_Remote_Jobview_Setup_Date__c,Customer_Prime_Remote_Jobview_Setup__c,Device_Id__c,DRT_Name__c,DRT__c,DRW_Date__c,DRW__c,
            Error_Message_Oracle_DB__c,Error_Message_PTRF_Layer_SendPrimeFrame__c,Error_Message_Sync_Layer_Status__c,Foundry_Frame_Mockup_Date__c,
            Foundry_Frame_Mockup__c,Foundry_Frame_Remote_Jobview_Setup_Date__c,Foundry_Frame_Remote_Jobview_Setup__c,Foundry_GDSOUT_Review_Date__c,
            Foundry_GDSOUT_Review__c,Foundry_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview__c,Foundry_Prime_Remote_Jobview_Setup_Date__c,
            Foundry_Prime_Remote_Jobview_Setup__c,Frame_MEBES_Received_Date__c,Frame_MEBES_Received__c,Frame_TapeOut__c,PTRF__r.Foundry_Jobview__c,
            GlobalShuttle_MEBES_Jobview_Date__c,GlobalShuttle_MEBES_Jobview__c,Hold_Mask_Write_Date__c,Hold_Mask_Write__c,Id,IsDeleted,
            Is_Active__c,Is_Customer_Frame_Mockup_Updated__c,Is_Customer_Frame_Remote_Jobview_Updated__c,Is_Customer_GDSOUT_Review_Updated__c,
            Is_Customer_MEBES_Jobview_Updated__c,Is_Customer_Prime_Remote_Jobview_Updated__c,Is_DRW_Updated__c,Is_Foundry_Frame_Mockup_Updated__c,
            Is_Foundry_Frame_Remote_Jobview_Updated__c,Is_Foundry_GDSOUT_Review_Updated__c,Is_Foundry_MEBES_Jobview_Updated__c,PTRF__r.Name,
            Is_Foundry_Prime_Remote_Jobview_Updated__c,Is_Frame_MEBES_Received_Updated__c,Is_GlobalShuttle_MEBES_Jobview_Updated__c,
            Is_MDP_MEBES_Jobview_Updated__c,Is_ORC_Updated__c,Is_Prime_MEBES_Received_Updated__c,Is_Send_Frame_Data_Updated__c,PTRF__r.Tech_Geo__c,
            Is_Send_Prime_Data_Updated__c,Is_Tapeout_Apps_MEBES_Jobview_Updated__c,Is_Tapeout_Centre_MEBES_Jobview_Updated__c,PTRF__r.Order_Type__c,
            Is_TDTI_MPW_MEBES_Jobview_Updated__c,LastModifiedById,LastModifiedDate,lastmodifieddate_sgt__c,PTRF__r.Customer_jobview__c,layer__r.MRS__r.Mask_Set_Title__r.Name,
            Last_Sync_Req_Timestamp_Layer_Gen__c,Last_Sync_Req_Timestamp_ORCN_Job__c,Last_Sync_Req_Timestamp_Receive_MEBES__c,Layer__r.Name,
            Last_Sync_Req_Timestamp_Remote_Jobview__c,Last_Sync_Req_Timestamp_Send_Frame__c,Last_Sync_Req_Timestamp_Send_Prime__c,Layer__r.Mask_Layer_Rev__c,
            Last_Sync_Req_Timestamp__c,Layer_Chip_Old_Status__c,Layer_Chip_Status_Date__c,Layer_Chip_Status__c,Layer_Name__c,Layer__r.ROM_Code__c,
            Layer_Send_Frame_Data__c,Layer_Send_Prime_Data__c,Layer__c,Lock_Record__c,Mask_Layer_Status__c,Mask_Layer__c,Mask_Set_Title_Name__c,
            MDP_MEBES_Jobview_Date__c,MDP_MEBES_Jobview__c,MRS_ID__c,MST__c,Name,ORC_Date__c,ORC__c,Prime_MEBES_Received_Date__c,Chip__r.Name,
            Prime_MEBES_Received__c,Prime_TapeOut__c,PTRF_Number__c,PTRF_Or_DRT__c,PTRF__c,Rev__c,ROM_Code__c,Send_Frame_Data_Date__c,
            Send_Frame_Data__c,Send_Prime_Data_Date__c,Send_Prime_Data__c,Synced_with_Oracle_DB__c,Sync_Layer_Status__c,PTRF__r.MaskSetTitle__r.Name,
            Sync_PTRF_Layer_SendPrimeFrame_dotNET__c,Sync_PTRF_Layer_to_SWIFT_dotNET__c,SystemModstamp,Tapeout_Applications_MEBES_Jobview_Date__c,
            Tapeout_Applications_MEBES_Jobview__c,Tapeout_Centre_MEBES_Jobview_Date__c,Tapeout_Centre_MEBES_Jobview__c,TDTI_MPW_MEBES_Date__c,
            TDTI_MPW_MEBES_Jobview__c,Tech_Geo__c,Trigger_Sync_Layer_Status__c,Void__c FROM MRS_Layer_Chip_Association__c where Id IN:setLayerChipIds]){
                listMRSLCANewQueried.add(obj);  
                mapLayerChipsNew.put(obj.Id,obj);
                List<MRS_Layer_Chip_Association__c> tempList = new List<MRS_Layer_Chip_Association__c>();
                if(mapLayerIdsToLayerChips.containsKey(obj.Layer__c)){
                    tempList.addAll(mapLayerIdsToLayerChips.get(obj.Layer__c)); 
                } 
                tempList.add(obj); 
                mapLayerIdsToLayerChips.put(obj.Layer__c,tempList);
            }
            list<String> lstFieldsToShow = new list<String>();
            lstFieldsToShow.add('Customer_GDSOUT_Review__c');
            lstFieldsToShow.add('Foundry_GDSOUT_Review__c');
            lstFieldsToShow.add('Customer_Frame_Mockup__c');
            lstFieldsToShow.add('Foundry_Frame_Mockup__c');
            lstFieldsToShow.add('Send_Prime_Data__c');
            lstFieldsToShow.add('Send_Frame_Data__c');
            lstFieldsToShow.add('Customer_Prime_Remote_Jobview_Setup__c');
            lstFieldsToShow.add('Customer_Frame_Remote_Jobview_Setup__c');
            lstFieldsToShow.add('Foundry_Prime_Remote_Jobview_Setup__c');
            lstFieldsToShow.add('Foundry_Frame_Remote_Jobview_Setup__c');
            lstFieldsToShow.add('ORC__c');
            lstFieldsToShow.add('DRW__c');
            lstFieldsToShow.add('Prime_MEBES_Received__c');
            lstFieldsToShow.add('Frame_MEBES_Received__c');
            lstFieldsToShow.add('Customer_MEBES_Jobview__c');
            lstFieldsToShow.add('Foundry_MEBES_Jobview__c');
            lstFieldsToShow.add('Tapeout_Centre_MEBES_Jobview__c');
            lstFieldsToShow.add('Tapeout_Applications_MEBES_Jobview__c');
            lstFieldsToShow.add('GlobalShuttle_MEBES_Jobview__c');
            lstFieldsToShow.add('MDP_MEBES_Jobview__c');
            lstFieldsToShow.add('TDTI_MPW_MEBES_Jobview__c');
                                    
            MRSHandlerUtility.verifyTECNForReleasedLayers(mapLayersNew, setTECNNumbers);
            MRSHandlerUtility.closePTRFOnShippedLayers(setShippedLayerIds);            
            test.stopTest();
        }   
     }
     
     /**
        This test method tests the email sending methods of MRSHandlerUtility class - Part 9.
        @method name: EmailSendingMethodsTest9
        @parameter:   none.
        @return :     None.
     **/
     
     public static testMethod void EmailSendingMethodsTest9(){
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
        emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = sysAdminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
        insert userSA;
        Group groupTA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Application'];
        Group groupTC = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Tapeout_Centre'];
        Group groupTMPW = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_TDTI_MPW'];
        Group groupMDP = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_MDP'];
        Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_GlobalShuttle'];
        Group groupSA = [select Id, DeveloperName, Name from Group where DeveloperName = 'Swift_Admin'];
        List<GroupMember> listGM = new List<GroupMember>(); 
        GroupMember groupMemberTA = new GroupMember(GroupId = groupTA.Id,UserOrGroupId = userSA.Id); 
        GroupMember groupMemberTC = new GroupMember(GroupId = groupTC.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMPW = new GroupMember(GroupId = groupTMPW.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberTMDP = new GroupMember(GroupId = groupMDP.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberGS = new GroupMember(GroupId = groupGS.Id,UserOrGroupId = userSA.Id);
        GroupMember groupMemberSA = new GroupMember(GroupId = groupSA.Id,UserOrGroupId = userSA.Id);          
        listGM.add(groupMemberTA);
        listGM.add(groupMemberTC);
        listGM.add(groupMemberTMPW);
        listGM.add(groupMemberTMDP);
        listGM.add(groupMemberGS);
        listGM.add(groupMemberSA);
        insert listGM;   
        System.runAs(sysAdminUser){      
        	// comment-out, refactor with testSetup method setup()           
            // SwiftDataUtilityTest.customSystemData();
            // Insert Custom Settings Data---//
            //---------------------------------------------//

            Account acc = SwiftDataUtilityTest.createTestAccount();
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
            Opportunity_Access__c='Read/Write',Team_Role__c='Primary Customer Service Rep',Sequence_No__c='1',Account_Role_ID__c='test1239');       
            insert atp;
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            insert objMST;
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Status__c='Active',Order_Type__c ='New Prototype',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Tech_Geo_Value__c='0.019UM',Customer_jobview__c='Gating mask release',Foundry_jobview__c='Gating mask release',Maskshop__c='Maskshop1',Fab__c='Fab1',Prime_Tapeout__c=true,Frame_Tapeout__c=true,DRW_Start_before_PT__c=true,DRC_DRW_Status__c = 'DRW',DRW_Completed_before_PT__c=true);
            insert objPTRF;
            PTRF__c objPTRF2 = new PTRF__c(Name ='PTRF2',Status__c='Active',Order_Type__c ='Retrofit',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Tech_Geo_Value__c='0.021UM',Customer_jobview__c='Not gating mask release',Foundry_jobview__c='Not gating mask release',Maskshop__c='Maskshop1',Fab__c='Fab1',Prime_Tapeout__c=true,Frame_Tapeout__c=true,DRW_Start_before_PT__c=true,DRC_DRW_Status__c = 'DRW',DRW_Completed_before_PT__c=true);
            insert objPTRF2;
            DRT__c objDRT = new DRT__c(Name='DRT1');
            insert objDRT;
            DRT_PTRF_Association__c objDRTPTRF = new DRT_PTRF_Association__c(PTRF__c=objPTRF.Id,DRT__c=objDRT.Id);
            insert objDRTPTRF;
            List<PTRF_JobViewer_Info__c> listPTRFJVI = new List<PTRF_JobViewer_Info__c>();
            List<PTRF_JobViewer_Info__c> listPTRFJVIQueried = new List<PTRF_JobViewer_Info__c>();
            PTRF_JobViewer_Info__c objPTRFJVC = new PTRF_JobViewer_Info__c(Name='SAC',PTRF__c=objPTRF.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF = new PTRF_JobViewer_Info__c(Name='SAF',PTRF__c=objPTRF.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVC2 = new PTRF_JobViewer_Info__c(Name='SAC2',PTRF__c=objPTRF2.Id,Jobview__c='Customer',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);
            PTRF_JobViewer_Info__c objPTRFJVF2 = new PTRF_JobViewer_Info__c(Name='SAF2',PTRF__c=objPTRF2.Id,Jobview__c='Foundry',Jobview_Type__c='Frame Mockup;Prime GDSOUT Review;MEBES Jobview',User__c=userSA.Id);            
            listPTRFJVI.add(objPTRFJVC);
            listPTRFJVI.add(objPTRFJVF);
            listPTRFJVI.add(objPTRFJVC2);
            listPTRFJVI.add(objPTRFJVF2);
            insert listPTRFJVI;
            for(PTRF_JobViewer_Info__c obj:[select Name,PTRF__c,Jobview__c,Jobview_Type__c,User__c,User__r.email from PTRF_JobViewer_Info__c]){
                listPTRFJVIQueried.add(obj);    
            }
            MRS__c objMRS = new MRS__c(Mask_Set_Title__c=objMST.Id);
            insert objMRS;
            List<MRS_Layer_Association__c> listMRSLA = new List<MRS_Layer_Association__c>();
            MRS_Layer_Association__c objMRSLA1 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RX',Mask_Layer_Rev__c='AZ',ROM_Code__c='123',Tech_Geo__c='0.019UM',LogicalOperation__c='TECN001;TECN002');
            MRS_Layer_Association__c objMRSLA2 = new MRS_Layer_Association__c(MRS__c=objMRS.Id,Layer_Status__c='Ready',Name='RY',Mask_Layer_Rev__c='AZ',ROM_Code__c='123',Tech_Geo__c='0.019UM',LogicalOperation__c='TECN003');
            listMRSLA.add(objMRSLA1);
            listMRSLA.add(objMRSLA2);
            test.startTest();
            insert listMRSLA;
            //MRSHandlerUtility.executeInsertMLA(listMRSLA);            
            /*listMRSLA.clear();
            objMRSLA1.Layer_Status__c='Shipped';
            objMRSLA2.Layer_Status__c='Shipped';
            listMRSLA.add(objMRSLA1);
            listMRSLA.add(objMRSLA2);
            MRSHandlerUtility.executeUpdateMLA(listMRSLA);*/            
            Map<String,MRS_Layer_Association__c> mapLayersNew = new Map<String,MRS_Layer_Association__c>();
            set<MRS_Layer_Association__c> setLayersNew = new set<MRS_Layer_Association__c>();
            set<String> setShippedLayerIds = new set<String>();
            for(MRS_Layer_Association__c obj:[select Mask_Set_Title_Name__c,MRS__r.Mask_Set_Title__r.Name,MRS__c,Layer_Status__c,Name,Mask_Layer_Rev__c,ROM_Code__c,Tech_Geo__c,CreatedById,LogicalOperation__c from MRS_Layer_Association__c]){
                mapLayersNew.put(obj.Id,obj);
                setLayersNew.add(obj);
                setShippedLayerIds.add(obj.Id); 
            }  
            List<MRS_Chip_Details__c> listMRSCD = new List<MRS_Chip_Details__c>();
            MRS_Chip_Details__c objMRSCD1 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip001');
            MRS_Chip_Details__c objMRSCD2 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Chip002');
            MRS_Chip_Details__c objMRSCD3 = new MRS_Chip_Details__c(MRS__c=objMRS.Id,Name='Frame');
            listMRSCD.add(objMRSCD1);
            listMRSCD.add(objMRSCD2);
            listMRSCD.add(objMRSCD3);
            insert listMRSCD;
            //MRSHandlerUtility.executeInsertMCD(listMRSCD);            
            List<MRS_Layer_Chip_Association__c> listMRSLCA = new List<MRS_Layer_Chip_Association__c>();
            MRS_Layer_Chip_Association__c objMRSLCA1 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id,DRT__c=null);
            MRS_Layer_Chip_Association__c objMRSLCA2 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id,DRT__c=null);
            MRS_Layer_Chip_Association__c objMRSLCA3 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF.Id,Tech_Geo__c='0.019UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id,DRT__c=null);
            MRS_Layer_Chip_Association__c objMRSLCA4 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD2.Id,PTRF__c=objPTRF2.Id,Tech_Geo__c='0.021UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id,DRT__c=null);
            MRS_Layer_Chip_Association__c objMRSLCA5 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA1.Id,Chip__c=objMRSCD1.Id,PTRF__c=objPTRF2.Id,Tech_Geo__c='0.021UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id,DRT__c=null);
            MRS_Layer_Chip_Association__c objMRSLCA6 = new MRS_Layer_Chip_Association__c(Layer__c=objMRSLA2.Id,Chip__c=objMRSCD3.Id,PTRF__c=objPTRF2.Id,Tech_Geo__c='0.021UM',Device_Id__c='1',Layer_Chip_Status__c='In Progress',Customer_Name__c=acc.Id,DRT__c=null);
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
            insert listMRSLCA;
            //MRSHandlerUtility.executeInsertMCLA(listMRSLCA);           
            List<Notes__c> listNotes = new List<Notes__c>();
            Notes__c objNotes1 = new Notes__c(Body__c='Reason1',Category__c='Customer Frame Remote Jobview Setup',ParentId__c=objMRSLCA1.Id);
            Notes__c objNotes2 = new Notes__c(Body__c='Reason2',Category__c='Foundry Frame Remote Jobview Setup',ParentId__c=objMRSLCA2.Id);
            Notes__c objNotes3 = new Notes__c(Body__c='Reason3',Category__c='Customer Prime Remote Jobview Setup',ParentId__c=objMRSLCA3.Id);
            Notes__c objNotes4 = new Notes__c(Body__c='Reason4',Category__c='Foundry Prime Remote Jobview Setup',ParentId__c=objMRSLCA4.Id);
            Notes__c objNotes5 = new Notes__c(Body__c='Reason5',Category__c='Prime MEBES Received',ParentId__c=objMRSLCA5.Id);
            Notes__c objNotes6 = new Notes__c(Body__c='Reason6',Category__c='Frame MEBES Received',ParentId__c=objMRSLCA6.Id);
            Notes__c objNotes7 = new Notes__c(Body__c='Reason7',Category__c='Tapeout Centre/MDP MEBES Jobview',ParentId__c=objMRSLCA6.Id);
            Notes__c objNotes8 = new Notes__c(Body__c='Reason8',Category__c='Tapeout Applications MEBES Jobview',ParentId__c=objMRSLCA6.Id);
            Notes__c objNotes9 = new Notes__c(Body__c='Reason9',Category__c='GlobalShuttle/TDTI-MPW MEBES Jobview',ParentId__c=objMRSLCA6.Id);          
            listNotes.add(objNotes1);
            listNotes.add(objNotes2);
            listNotes.add(objNotes3);
            listNotes.add(objNotes4);
            listNotes.add(objNotes5);
            listNotes.add(objNotes6);
            listNotes.add(objNotes7);
            listNotes.add(objNotes8);
            listNotes.add(objNotes9);
            insert listNotes;
            Maskshop_Configuration__c objMC = new Maskshop_Configuration__c(Name='Maskshop1');
            insert objMC;
            Released_Mask_Write_Distribution_List__c objRMWDL = new Released_Mask_Write_Distribution_List__c(Maskshop__c=objMC.Id,Distribution_List__c='test@test.com');
            insert objRMWDL;
            Fab_Distribution_Table__c objFDT = new Fab_Distribution_Table__c(Fab_No__c='Fab1',Distribution_List__c='test2@test2.com');
            insert objFDT;
            List<TECN__c> listTECN = new List<TECN__c>();
            TECN__c objTECN1 = new TECN__c(Name='TECN001',TECN_No__c='TECN001',TECN_Status__c='Active',Related_TECN_No__c='TECN001');
            TECN__c objTECN2 = new TECN__c(Name='TECN002',TECN_No__c='TECN002',TECN_Status__c='Released',Related_TECN_No__c='TECN002');
            TECN__c objTECN3 = new TECN__c(Name='TECN003',TECN_No__c='TECN003',TECN_Status__c='Released',Related_TECN_No__c='TECN003');
            listTECN.add(objTECN1);
            listTECN.add(objTECN2);
            listTECN.add(objTECN3);
            insert listTECN;
            set<String> setTECNNumbers = new set<String>{'TECN001','TECN002','TECN003'};
            Map<Id,MRS_Layer_Chip_Association__c> mapLayerChipsOld = new Map<Id,MRS_Layer_Chip_Association__c>();
            Map<Id,MRS_Layer_Chip_Association__c> mapLayerChipsNew = new Map<Id,MRS_Layer_Chip_Association__c>();            
            List<MRS_Layer_Chip_Association__c> listMRSLCANew = new List<MRS_Layer_Chip_Association__c>();  
            set<String> setLayerChipIds = new set<String>();        
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
            //MRSHandlerUtility.executeUpdateMCLA(listMRSLCANew);            
            List<MRS_Layer_Chip_Association__c> listMRSLCANewQueried = new List<MRS_Layer_Chip_Association__c>();
            map<Id,List<MRS_Layer_Chip_Association__c>> mapLayerIdsToLayerChips = new map<Id,List<MRS_Layer_Chip_Association__c>>();
            for(MRS_Layer_Chip_Association__c obj:[SELECT Approved__c,Chip_Hold_Warning__c,Chip_Name__c,Chip__c,CreatedById,CreatedDate,
            Customer_Frame_Mockup_Date__c,Customer_Frame_Mockup__c,Customer_Frame_Remote_Jobview_Setup_Date__c,Customer_Frame_Remote_Jobview_Setup__c,
            Customer_GDSOUT_Review_Date__c,Customer_GDSOUT_Review__c,Customer_MEBES_Jobview_Date__c,Customer_MEBES_Jobview__c,Customer_Name__c,
            Customer_Prime_Remote_Jobview_Setup_Date__c,Customer_Prime_Remote_Jobview_Setup__c,Device_Id__c,DRT_Name__c,DRT__c,DRW_Date__c,DRW__c,
            Error_Message_Oracle_DB__c,Error_Message_PTRF_Layer_SendPrimeFrame__c,Error_Message_Sync_Layer_Status__c,Foundry_Frame_Mockup_Date__c,
            Foundry_Frame_Mockup__c,Foundry_Frame_Remote_Jobview_Setup_Date__c,Foundry_Frame_Remote_Jobview_Setup__c,Foundry_GDSOUT_Review_Date__c,
            Foundry_GDSOUT_Review__c,Foundry_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview__c,Foundry_Prime_Remote_Jobview_Setup_Date__c,
            Foundry_Prime_Remote_Jobview_Setup__c,Frame_MEBES_Received_Date__c,Frame_MEBES_Received__c,Frame_TapeOut__c,PTRF__r.Foundry_Jobview__c,
            GlobalShuttle_MEBES_Jobview_Date__c,GlobalShuttle_MEBES_Jobview__c,Hold_Mask_Write_Date__c,Hold_Mask_Write__c,Id,IsDeleted,
            Is_Active__c,Is_Customer_Frame_Mockup_Updated__c,Is_Customer_Frame_Remote_Jobview_Updated__c,Is_Customer_GDSOUT_Review_Updated__c,
            Is_Customer_MEBES_Jobview_Updated__c,Is_Customer_Prime_Remote_Jobview_Updated__c,Is_DRW_Updated__c,Is_Foundry_Frame_Mockup_Updated__c,
            Is_Foundry_Frame_Remote_Jobview_Updated__c,Is_Foundry_GDSOUT_Review_Updated__c,Is_Foundry_MEBES_Jobview_Updated__c,PTRF__r.Name,
            Is_Foundry_Prime_Remote_Jobview_Updated__c,Is_Frame_MEBES_Received_Updated__c,Is_GlobalShuttle_MEBES_Jobview_Updated__c,
            Is_MDP_MEBES_Jobview_Updated__c,Is_ORC_Updated__c,Is_Prime_MEBES_Received_Updated__c,Is_Send_Frame_Data_Updated__c,PTRF__r.Tech_Geo__c,
            Is_Send_Prime_Data_Updated__c,Is_Tapeout_Apps_MEBES_Jobview_Updated__c,Is_Tapeout_Centre_MEBES_Jobview_Updated__c,PTRF__r.Order_Type__c,
            Is_TDTI_MPW_MEBES_Jobview_Updated__c,LastModifiedById,LastModifiedDate,lastmodifieddate_sgt__c,PTRF__r.Customer_jobview__c,layer__r.MRS__r.Mask_Set_Title__r.Name,
            Last_Sync_Req_Timestamp_Layer_Gen__c,Last_Sync_Req_Timestamp_ORCN_Job__c,Last_Sync_Req_Timestamp_Receive_MEBES__c,Layer__r.Name,
            Last_Sync_Req_Timestamp_Remote_Jobview__c,Last_Sync_Req_Timestamp_Send_Frame__c,Last_Sync_Req_Timestamp_Send_Prime__c,Layer__r.Mask_Layer_Rev__c,
            Last_Sync_Req_Timestamp__c,Layer_Chip_Old_Status__c,Layer_Chip_Status_Date__c,Layer_Chip_Status__c,Layer_Name__c,Layer__r.ROM_Code__c,
            Layer_Send_Frame_Data__c,Layer_Send_Prime_Data__c,Layer__c,Lock_Record__c,Mask_Layer_Status__c,Mask_Layer__c,Mask_Set_Title_Name__c,
            MDP_MEBES_Jobview_Date__c,MDP_MEBES_Jobview__c,MRS_ID__c,MST__c,Name,ORC_Date__c,ORC__c,Prime_MEBES_Received_Date__c,Chip__r.Name,
            Prime_MEBES_Received__c,Prime_TapeOut__c,PTRF_Number__c,PTRF_Or_DRT__c,PTRF__c,Rev__c,ROM_Code__c,Send_Frame_Data_Date__c,
            Send_Frame_Data__c,Send_Prime_Data_Date__c,Send_Prime_Data__c,Synced_with_Oracle_DB__c,Sync_Layer_Status__c,PTRF__r.MaskSetTitle__r.Name,
            Sync_PTRF_Layer_SendPrimeFrame_dotNET__c,Sync_PTRF_Layer_to_SWIFT_dotNET__c,SystemModstamp,Tapeout_Applications_MEBES_Jobview_Date__c,
            Tapeout_Applications_MEBES_Jobview__c,Tapeout_Centre_MEBES_Jobview_Date__c,Tapeout_Centre_MEBES_Jobview__c,TDTI_MPW_MEBES_Date__c,
            TDTI_MPW_MEBES_Jobview__c,Tech_Geo__c,Trigger_Sync_Layer_Status__c,Void__c FROM MRS_Layer_Chip_Association__c where Id IN:setLayerChipIds]){
                listMRSLCANewQueried.add(obj);  
                mapLayerChipsNew.put(obj.Id,obj);
                List<MRS_Layer_Chip_Association__c> tempList = new List<MRS_Layer_Chip_Association__c>();
                if(mapLayerIdsToLayerChips.containsKey(obj.Layer__c)){
                    tempList.addAll(mapLayerIdsToLayerChips.get(obj.Layer__c)); 
                } 
                tempList.add(obj); 
                mapLayerIdsToLayerChips.put(obj.Layer__c,tempList);
            }
            list<String> lstFieldsToShow = new list<String>();
            lstFieldsToShow.add('Customer_GDSOUT_Review__c');
            lstFieldsToShow.add('Foundry_GDSOUT_Review__c');
            lstFieldsToShow.add('Customer_Frame_Mockup__c');
            lstFieldsToShow.add('Foundry_Frame_Mockup__c');
            lstFieldsToShow.add('Send_Prime_Data__c');
            lstFieldsToShow.add('Send_Frame_Data__c');
            lstFieldsToShow.add('Customer_Prime_Remote_Jobview_Setup__c');
            lstFieldsToShow.add('Customer_Frame_Remote_Jobview_Setup__c');
            lstFieldsToShow.add('Foundry_Prime_Remote_Jobview_Setup__c');
            lstFieldsToShow.add('Foundry_Frame_Remote_Jobview_Setup__c');
            lstFieldsToShow.add('ORC__c');
            lstFieldsToShow.add('DRW__c');
            lstFieldsToShow.add('Prime_MEBES_Received__c');
            lstFieldsToShow.add('Frame_MEBES_Received__c');
            lstFieldsToShow.add('Customer_MEBES_Jobview__c');
            lstFieldsToShow.add('Foundry_MEBES_Jobview__c');
            lstFieldsToShow.add('Tapeout_Centre_MEBES_Jobview__c');
            lstFieldsToShow.add('Tapeout_Applications_MEBES_Jobview__c');
            lstFieldsToShow.add('GlobalShuttle_MEBES_Jobview__c');
            lstFieldsToShow.add('MDP_MEBES_Jobview__c');
            lstFieldsToShow.add('TDTI_MPW_MEBES_Jobview__c');
                                                   
            objPTRF.Status__c='Cancel';          
            objPTRF.Prime_Tapeout__c=false;          
            objPTRF.Frame_Tapeout__c=false;
            objPTRF.DRC_DRW_Status__c='Cancelled DRC DRW';
            update objPTRF;
            test.stopTest();
        }   
     }
    
     
     public static testmethod void fetchCustomerNameTest(){
        
        // comment-out, refactor with testSetup method setup()      
        // SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccountForDRT();
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        User u1, u2;
        
        System.runAs ( thisUser ) {
            Id sysAdminProfileId,feProfileId;
            for(Profile p: [SELECT Id,Name FROM Profile WHERE Name in ('System Administrator','GF FAE/FTS')]) {
                if(p.Name == 'System Administrator') {
                    sysAdminProfileId = p.Id;
                }
                else {
                    feProfileId = p.Id;
                }
            }
            
            u1 = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = sysAdminProfileId,
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS',FederationIdentifier='Test');   
            
            insert u1;
        }
        
        test.startTest();
        System.runAs(u1) {
            list<Account> accountList = MRSHandlerUtility.fetchCustomerName();
            system.assert(accountList != null);
        }
        test.stopTest();
    }
}