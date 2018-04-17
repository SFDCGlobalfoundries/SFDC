/*
Type Name: EmailHandlerUtilityTest
Author: Cognizant 
Created Date: 2-December-2014
Reason: 
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
……..
……..
*/
@istest(SeeAllData=false)
public class EmailHandlerUtilityTest {
    @isTest
    public static void EmailSendingMethodsTest(){
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
            SwiftDataUtilityTest.customSystemData();
            Account acc = SwiftDataUtilityTest.createTestAccount();
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSA.id,Account__c=acc.id,Account_Access__c='Read/Write',
            Opportunity_Access__c='Read/Write',Team_Role__c='Primary Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
            insert atp;
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MPW001');
            insert objMST;
            Fab_Distribution_Table__c objFab = new Fab_Distribution_Table__c(Fab_No__c='Fab1',Distribution_List__c='test@yahoo.com');
            insert objFab;
            PTRF__c objPTRF = new PTRF__c(Name ='PTRF1',Order_Type__c ='Test Order Type',Recticle_Type__c ='Single Layer Reticle (SLR)',MaskSetTitle__c=objMST.Id,Customer__c=acc.id,Tech_Geo_Value__c='0.01',Customer_jobview__c='Gating mask release',Fab__c='Fab1');
            insert objPTRF;
            DRT__c objDRT = new DRT__c(Name='DRT1');
            insert objDRT;
            DRT_PTRF_Association__c objDRTPTRF = new DRT_PTRF_Association__c(PTRF__c=objPTRF.Id,DRT__c=objDRT.Id);
            insert objDRTPTRF;
            test.startTest();
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
            
            update listMRSLCANew;
            //List<MRS_Layer_Chip_Association__c> listMRSLCANewQueried = new List<MRS_Layer_Chip_Association__c>();
            Map<Id,List<MRS_Layer_Chip_Association__c>> mapPTRFIdandlstmrsLayerChip = new Map<Id,List<MRS_Layer_Chip_Association__c>>();
            for(MRS_Layer_Chip_Association__c mrsLayerChipObj:[SELECT Approved__c,Chip_Hold_Warning__c,Chip_Name__c,Chip__c,CreatedById,CreatedDate,
            Customer_Frame_Mockup_Date__c,Customer_Frame_Mockup__c,Customer_Frame_Remote_Jobview_Setup_Date__c,Customer_Frame_Remote_Jobview_Setup__c,
            Customer_GDSOUT_Review_Date__c,Customer_GDSOUT_Review__c,Customer_MEBES_Jobview_Date__c,Customer_MEBES_Jobview__c,Customer_Name__c,
            Customer_Prime_Remote_Jobview_Setup_Date__c,Customer_Prime_Remote_Jobview_Setup__c,Device_Id__c,DRT_Name__c,DRT__c,DRW_Date__c,DRW__c,
            Error_Message_Oracle_DB__c,Error_Message_PTRF_Layer_SendPrimeFrame__c,Error_Message_Sync_Layer_Status__c,Foundry_Frame_Mockup_Date__c,
            Foundry_Frame_Mockup__c,Foundry_Frame_Remote_Jobview_Setup_Date__c,Foundry_Frame_Remote_Jobview_Setup__c,Foundry_GDSOUT_Review_Date__c,
            Foundry_GDSOUT_Review__c,Foundry_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview__c,Foundry_Prime_Remote_Jobview_Setup_Date__c,
            Foundry_Prime_Remote_Jobview_Setup__c,Frame_MEBES_Received_Date__c,Frame_MEBES_Received__c,Frame_TapeOut__c,PTRF__r.Name,
            GlobalShuttle_MEBES_Jobview_Date__c,GlobalShuttle_MEBES_Jobview__c,Hold_Mask_Write_Date__c,Hold_Mask_Write__c,Id,IsDeleted,
            Is_Active__c,Is_Customer_Frame_Mockup_Updated__c,Is_Customer_Frame_Remote_Jobview_Updated__c,Is_Customer_GDSOUT_Review_Updated__c,
            Is_Customer_MEBES_Jobview_Updated__c,Is_Customer_Prime_Remote_Jobview_Updated__c,Is_DRW_Updated__c,Is_Foundry_Frame_Mockup_Updated__c,
            Is_Foundry_Frame_Remote_Jobview_Updated__c,Is_Foundry_GDSOUT_Review_Updated__c,Is_Foundry_MEBES_Jobview_Updated__c,PTRF__r.Foundry_jobview__c,
            Is_Foundry_Prime_Remote_Jobview_Updated__c,Is_Frame_MEBES_Received_Updated__c,Is_GlobalShuttle_MEBES_Jobview_Updated__c,
            Is_MDP_MEBES_Jobview_Updated__c,Is_ORC_Updated__c,Is_Prime_MEBES_Received_Updated__c,Is_Send_Frame_Data_Updated__c,
            Is_Send_Prime_Data_Updated__c,Is_Tapeout_Apps_MEBES_Jobview_Updated__c,Is_Tapeout_Centre_MEBES_Jobview_Updated__c,
            Is_TDTI_MPW_MEBES_Jobview_Updated__c,LastModifiedById,LastModifiedDate,lastmodifieddate_sgt__c,PTRF__r.Customer_jobview__c,
            Last_Sync_Req_Timestamp_Layer_Gen__c,Last_Sync_Req_Timestamp_ORCN_Job__c,Last_Sync_Req_Timestamp_Receive_MEBES__c,Layer__r.ROM_Code__c,Layer__r.Name,Layer__r.Mask_Layer_Rev__c,
            Last_Sync_Req_Timestamp_Remote_Jobview__c,Last_Sync_Req_Timestamp_Send_Frame__c,Last_Sync_Req_Timestamp_Send_Prime__c,
            Last_Sync_Req_Timestamp__c,Layer_Chip_Old_Status__c,Layer_Chip_Status_Date__c,Layer_Chip_Status__c,Layer_Name__c,
            Layer_Send_Frame_Data__c,Layer_Send_Prime_Data__c,Layer__c,Lock_Record__c,Mask_Layer_Status__c,Mask_Layer__c,Mask_Set_Title_Name__c,
            MDP_MEBES_Jobview_Date__c,MDP_MEBES_Jobview__c,MRS_ID__c,MST__c,Name,ORC_Date__c,ORC__c,Prime_MEBES_Received_Date__c,
            Prime_MEBES_Received__c,Prime_TapeOut__c,PTRF_Number__c,PTRF_Or_DRT__c,PTRF__c,Rev__c,ROM_Code__c,Send_Frame_Data_Date__c,
            Send_Frame_Data__c,Send_Prime_Data_Date__c,Send_Prime_Data__c,Synced_with_Oracle_DB__c,Sync_Layer_Status__c,PTRF__r.MaskSetTitle__r.Name,
            Sync_PTRF_Layer_SendPrimeFrame_dotNET__c,Sync_PTRF_Layer_to_SWIFT_dotNET__c,SystemModstamp,Tapeout_Applications_MEBES_Jobview_Date__c,
            Tapeout_Applications_MEBES_Jobview__c,Tapeout_Centre_MEBES_Jobview_Date__c,Tapeout_Centre_MEBES_Jobview__c,TDTI_MPW_MEBES_Date__c,
            TDTI_MPW_MEBES_Jobview__c,Tech_Geo__c,Trigger_Sync_Layer_Status__c,Void__c,PTRF__r.Tech_Geo__c,Chip__r.Name FROM MRS_Layer_Chip_Association__c where Id IN:setLayerChipIds]){
                //listMRSLCANewQueried.add(obj);  
                //mapLayerChipsNew.put(obj.Id,obj);
                if(mapPTRFIdandlstmrsLayerChip.containsKey(mrsLayerChipObj.PTRF__c)){
                    mapPTRFIdandlstmrsLayerChip.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                }else{
                    List<MRS_Layer_Chip_Association__c> mrsLayerChiplst = new List<MRS_Layer_Chip_Association__c>();
                    mrsLayerChiplst.add(mrsLayerChipObj);
                    mapPTRFIdandlstmrsLayerChip.put(mrsLayerChipObj.PTRF__c,mrsLayerChiplst);
                }   
            }
            
            Id ptrfRecordTypeId = Schema.SObjectType.Email_Config_Settings__c.getRecordTypeInfosByName().get('PTRF').getRecordTypeId();
            String emailAddress='#User:krishanu.mukherjee@cognizant.com.gf.swiftsit1,Santanu.Pal@cognizant.com.swiftsit1, sumit.chowdhury@swiftsit1,soumen.roychowdhury@cognizant.com,meenakshmi.goswami@cognizant.com.swiftsit1,sujoy.mazumder@cognizant.com.swiftsit1,#Group:SWIFT_Admin,Tapeout_Centre,Tapeout_Application,#CJV#ATP#FJV#Fab#Email:mbrabbit06.com';
            Email_Config_Settings__c emailCOnfigObj = new Email_Config_Settings__c(Email_Template_Name__c='Swift_Device_Prime_GDSOUT_Review_is_Approved_Custom',
                                                                                    RecordTypeId=ptrfRecordTypeId,
                                                                                    Available_For_Use__c=true,
                                                                                    Tech_Geo_Value__c='0.01',
                                                                                    Gating_Jobview__c='NA',
                                                                                    MPW_PTRF__c=true,
                                                                                    TO__c=emailAddress,
                                                                                    CC__c=emailAddress,
                                                                                    BCC__c=emailAddress,
                                                                                    Customer_Jobviewer_Type__c='Prime GDSOUT Review',
                                                                                    Foundry_Jobviewer_Type__c='MEBES Jobview;Frame Mockup Review'
                                                                                    );
            insert emailCOnfigObj;      
            
            Map<String,Map<String,String>> inputMap =new Map<String,Map<String,String>>();      
            Map<String,String> innerMap = new Map<String,String>();
            EmailTemplate etgating = [Select id,Subject,Body,HtmlValue,DeveloperName from EmailTemplate where DeveloperName=:'Swift_Device_Prime_GDSOUT_Review_is_Approved_Custom'];
            innermap.put(Label.EmailKeysetForTemplate,etgating.DeveloperName);
            innermap.put(Label.EmailKeysetForGatingNotGating,'NA');
            innermap.put(Label.EmailKeysetForBody,etgating.HtmlValue);
            innermap.put(Label.EmailKeysetForSubject,etgating.subject);
            for(Id ptrfIdIterator : mapPTRFIdandlstmrsLayerChip.keySet()){
                inputMap.put(ptrfIdIterator,innerMap);
            }
            EmailHandlerUtility.ptrfEmailMethod(inputMap);                  
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
}