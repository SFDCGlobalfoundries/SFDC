/*
    Author: Cognizant
    Description: Apex test class for EmailSubjectBodyPerPTRF
    History: 
    Saurav      5/2/2015    - Apex code created
    
*/
@istest(SeeAllData=false)
public class EmailSubjectBodyPerPTRFPerMSTTest {
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
    
    /**
        @Method Name: createDevicePT1
        @Return type: Device__c
        @Parameters: Id testAcctId, Id testOpptyProgramId, Id ProcessTechnologyId, Id OpprId
        @Description: Creates device and associates with the acount, opportunity program, process technology and opportunity
    **/
    public static Device__c createDevicePT1(Id testAcctId, Id testOpptyProgramId, Id ProcessTechnologyId, Id OpprId) {
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
        device.Device_Mask_Set_Title__c = 'DVMST12';
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
    }
    
    
    public static Account accountObj;
    /**
        @Method Name: TestReviewerNotificationAccountInsert
        @Return type: null
        @Parameters: null
        @Description: creates account for test class
    **/
    public static  void emailSubjectBodyPerPTRFAccountInsert(){
                SwiftDataUtilityTest.customSystemData();
                accountObj = SwiftDataUtilityTest.createTestAccountForDRT();
                
                System.assertNotEquals(accountObj,null);
                accountObj.stage__c = 'Qualified';
                update accountObj;
                
    }
    
    static{
        emailSubjectBodyPerPTRFAccountInsert();
    }
    /**
        @Method Name: emailSubjectBodyTest
        @Return type: null
        @Parameters: null
        @Description: Test method for EmailSubjectBodyPerPTRF
    **/
    public static void insertTemplate(){
        EmailTemplate temp = [Select Id, Name, Subject, TemplateType, FolderId, Folder.Name,BrandTemplateId,TemplateStyle From EmailTemplate WHERE TemplateType = 'HTML' LIMIT 1];
        EmailTemplate tempObj = new EmailTemplate();
        
        tempObj.Name = 'Test_Template';
        tempObj.DeveloperName = 'Test_Template';
        tempObj.FolderId = temp.FolderId;
        tempObj.TemplateType = 'HTML';
        tempObj.BrandTemplateId = temp.BrandTemplateId;
        tempObj.TemplateStyle = temp.TemplateStyle;
        tempObj.IsActive = true;
        tempObj.Subject = 'Notification: Device '+'MST001'+' : Gating Frame Mockup review for layer(s)'+'RX';
        tempObj.HtmlValue = '<table height="400" width="550" cellpadding="5" border="0" cellspacing="5" >'+'\n'
                            +'<tr height="400" valign="top" >'+'\n'
                            +'<td style=" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;" tEditID="c1r1" locked="0" aEditID="c1r1" >'+'\n'
                            +'<![CDATA[<div><font face="arial">Mask Set Title: {!Mask_Set_Title__c.Name}</font></div><div><font face="arial">Mask Layer: {!MRS_Layer_Association__c.Name}</font></div><div><font face="arial">Chip Name: {!MRS_Chip_Details__c.Name}</font></div><div><font face="arial">PTRF Number: {!PTRF__c.Name}</font></div><div><span style="font-size: 12pt;">Tech Geo : {!MRS_Layer_Chip_Association__c.Name}</span></div><div><span style="font-size: 12pt;">Short Name : {!Account.Name}</span></div><div><font face="arial">PTRF Order Status : </font></div><div><span style="font-size: 12pt;">TECN : {!TECN__c.TECN_No__c}</span></div><div><font face="arial"><br></font></div><div><font face="arial">Dear Sir/Madam,</font></div><div><font face="arial">Please be informed the following updated MEBES data is approved.</font></div><div><font face="arial"><br></font></div><div><font face="arial">#MATRIX#</font></div><div><font face="arial"><br></font></div><div><font face="arial">Jobdeck : #PARAM:Jobdeck#</font></div><div><br></div><div><span style="font-size: 12pt;"><br>[?LINK:LINK1|PARAM[X={MRS_Layer_Chip_Association__c.Id}&Jobview=Customer]?]</br><br>[?LINK:LINK1?]</br><br>[?LINK:LINK1|PAR[X=Customer&Jobview=Customer]?]</br><br>[?LINK:|PARAM[X={MRS_Layer_Chip_Association__c.Id}&Jobview=Customer]?]</br><br>[?LINK:LINK6?]</br><br>#PARAM:JOBDECK#</br>Thank you.</span></div><div><font face="arial"><br></font></div><div><span style="font-size: 12pt;">Best Regards.</span></div>]]></td>'+'\n'
                            +'</tr>'+'\n'
                            +'</table>';
         insert tempObj;
    }
    
    /**
        @Method Name: emailSubjectBodyTest
        @Return type: null
        @Parameters: null
        @Description: Test method for EmailSubjectBodyPerPTRF
    **/
    public static testMethod void emailSubjectBodyTest(){
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
        System.runAs(sysAdminUser){
            insertTemplate();
            insertSwiftMappingSettingPTRF();
            insertSwiftMappingSettingMST();
            insertSwiftTemplateLink();
            
            Test.startTest();
            
            List<Contact> lstContact   = createTestContact(accountObj,5);
      
            Mask_Set_Title__c objMST = MRSDataUtilityTest.createMST();
          
            List<Mask_Set_Title__c> lstMST =[select name from Mask_Set_Title__c limit 1 ];
            
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
            PTRFobj.Customer__c = accountObj.Id;
            insert PTRFobj;
            System.assertEquals('PTRF 1',PTRFobj.Name);
            
            MRS_Layer_Chip_Association__c objmlca = new MRS_Layer_Chip_Association__c();
            objmlca.Customer_Name__c = accountObj.Id;
            objmlca.PTRF__c = PTRFobj.Id;
            objmlca.Layer__c = mrsLA.Id;
            objmlca.Chip__c = mrsCD.Id;
            insert objmlca; 
            
            List<MRS_Layer_Chip_Association__c> mrsLayerChipList = new List<MRS_Layer_Chip_Association__c>();
            mrsLayerChipList.add(objmlca);
            
            Map<String,String> nameValue = new Map<String,String>();
            nameValue.put('JOBDECK','TEXT');
            
            /**PTRF**/
            EmailSubjectBodyPerPTRF email = new EmailSubjectBodyPerPTRF();
            email.emailSubBodyPerPTRF(mrsLayerChipList,'Test_Template',nameValue,'Y','Field__c');
            //email.emailSubBodyPerPTRF(null,'Test_Template',nameValue,'Y','Field__c');
            /**PTRF**/
            
            /**MST**/
            EmailSubjectBodyPerMST emailMST = new EmailSubjectBodyPerMST();
            List<String> queryList = emailMST.getDynamicQueries('Test_Template');
            String queryString = queryList[0]+' WHERE Id = :objmlca.Id';
            
            List<MRS_Layer_Chip_Association__c> mrslcaList = Database.Query(queryList[0]);
            List<TECN__c> tecnList = Database.query(queryList[1]);
            
            Map<Integer,List<MRS_Layer_Chip_Association__c>> queriedLayerChipAssociationData = new Map<Integer,List<MRS_Layer_Chip_Association__c>>();
            queriedLayerChipAssociationData.put(1,mrslcaList);
            
            Map<Integer,List<TECN__c>> queriedTECNData = new Map<Integer,List<TECN__c>>();
            queriedTECNData.put(1,tecnList);
            
            Map<Integer, List<String>> returnMap = emailMST.replaceSubjectAndContent(queriedLayerChipAssociationData,queriedTECNData,nameValue);
            /**MST**/
            
            Test.stopTest(); 
        }
    }
    
     /**
        @Method Name: insertSwiftMappingSetting
        @Return type: null
        @Parameters: null
        @Description: Insert custom Settings value for test data
    **/
    public static void insertSwiftMappingSettingPTRF() {
        List<Swift_Relationship_Mapping_Per_PTRF__c> mappingList = new List<Swift_Relationship_Mapping_Per_PTRF__c>();
        Swift_Relationship_Mapping_Per_PTRF__c mappingObj = new Swift_Relationship_Mapping_Per_PTRF__c(Name='Account',RelationshipFlow__c='PTRF__r-Customer__r',RelationshipName__c='PTRF__r.Customer__r');
        mappingList.add(mappingObj);
        mappingObj = new Swift_Relationship_Mapping_Per_PTRF__c(Name='DRT__c',RelationshipFlow__c='DRT__r',RelationshipName__c='DRT__r');
        mappingList.add(mappingObj);
        mappingObj = new Swift_Relationship_Mapping_Per_PTRF__c(Name='Mask_Set_Title__c',RelationshipFlow__c='PTRF__r-MaskSetTitle__r',RelationshipName__c='PTRF__r.MaskSetTitle__r');
        mappingList.add(mappingObj);
        mappingObj = new Swift_Relationship_Mapping_Per_PTRF__c(Name='MRS_Chip_Details__c',RelationshipFlow__c='Chip__r',RelationshipName__c='Chip__r');
        mappingList.add(mappingObj);
        mappingObj = new Swift_Relationship_Mapping_Per_PTRF__c(Name='MRS_Layer_Association__c',RelationshipFlow__c='Layer__r',RelationshipName__c='Layer__r');
        mappingList.add(mappingObj);
        mappingObj = new Swift_Relationship_Mapping_Per_PTRF__c(Name='MRS_Layer_Chip_Association__c',RelationshipFlow__c=null,RelationshipName__c=null);
        mappingList.add(mappingObj);
        mappingObj = new Swift_Relationship_Mapping_Per_PTRF__c(Name='MRS__c',RelationshipFlow__c='Layer__r-MRS__r',RelationshipName__c='Layer__r.MRS__r');
        mappingList.add(mappingObj);
        mappingObj = new Swift_Relationship_Mapping_Per_PTRF__c(Name='PTRF__c',RelationshipFlow__c='PTRF__r',RelationshipName__c='PTRF__r');
        mappingList.add(mappingObj);
        try{
            insert mappingList;
        }
        catch(Exception exp){}
    }
    
    /**
        @Method Name: insertSwiftMappingSetting
        @Return type: null
        @Parameters: null
        @Description: Insert custom Settings value for test data
    **/
    public static void insertSwiftMappingSettingMST() {
        
        List<Swift_Relationship_Mapping_Per_MST__c> mappingList = new List<Swift_Relationship_Mapping_Per_MST__c>();
        Swift_Relationship_Mapping_Per_MST__c mappingObj = new Swift_Relationship_Mapping_Per_MST__c(Name='Account',RelationshipFlow__c='PTRF__r-Customer__r',RelationshipName__c='PTRF__r.Customer__r');
        mappingList.add(mappingObj);
        mappingObj = new Swift_Relationship_Mapping_Per_MST__c(Name='DRT__c',RelationshipFlow__c='DRT__r',RelationshipName__c='DRT__r');
        mappingList.add(mappingObj);
        mappingObj = new Swift_Relationship_Mapping_Per_MST__c(Name='Mask_Set_Title__c',RelationshipFlow__c='PTRF__r-MaskSetTitle__r',RelationshipName__c='PTRF__r.MaskSetTitle__r');
        mappingList.add(mappingObj);
        mappingObj = new Swift_Relationship_Mapping_Per_MST__c(Name='MRS_Chip_Details__c',RelationshipFlow__c='Chip__r',RelationshipName__c='Chip__r');
        mappingList.add(mappingObj);
        mappingObj = new Swift_Relationship_Mapping_Per_MST__c(Name='MRS_Layer_Association__c',RelationshipFlow__c='Layer__r',RelationshipName__c='Layer__r');
        mappingList.add(mappingObj);
        mappingObj = new Swift_Relationship_Mapping_Per_MST__c(Name='MRS_Layer_Chip_Association__c',RelationshipFlow__c='',RelationshipName__c='');
        mappingList.add(mappingObj);
        mappingObj = new Swift_Relationship_Mapping_Per_MST__c(Name='MRS__c',RelationshipFlow__c='Layer__r-MRS__r',RelationshipName__c='Layer__r.MRS__r');
        mappingList.add(mappingObj);
        mappingObj = new Swift_Relationship_Mapping_Per_MST__c(Name='PTRF__c',RelationshipFlow__c='PTRF__r',RelationshipName__c='PTRF__r');
        mappingList.add(mappingObj);
        try{
            insert mappingList;
        }
        catch(Exception exp){}
        
    }
    
    /**
        @Method Name: insertSwiftTemplateLink
        @Return type: null
        @Parameters: null
        @Description: Insert custom Settings value for test data
    **/
    public static void insertSwiftTemplateLink() {
        Swift_Email_Template_Links__c link = new Swift_Email_Template_Links__c(Name='LINK1',Label__c='Salesforce',URL__c='http://login.salesforce.com');
        insert link;    
    }
}