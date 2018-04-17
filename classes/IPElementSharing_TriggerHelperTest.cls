/*
@Author <Nikhil>
@name <IPElementSharing_TriggerHelperTest>
@CreateDate < 5/16/2017 >
@Description < test class for ipelement sharing object record insert functionality>
@Version <1.0>
*/

@isTest(SeeAllData=false)
Public  Class IPElementSharing_TriggerHelperTest{ 
    
    @testSetup static void testdata() 
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        String uEmail='standarduserIPdev'+ DateTime.now().getTime()+'@testorg.com';
        String uEmail2='standarduserIPdev2'+ DateTime.now().getTime()+'@testorg.com';
        String uEmail3='standarduserIPdev3'+ DateTime.now().getTime()+'@testorg.com';
        
        // creating  User1
        User usr1 = new User(Alias = 'IPDev1', Email='pranavshyam.marathe@globalfoundries.com', 
                             EmailEncodingKey='UTF-8', LastName='IPDevTesting', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = p.Id, 
                             TimeZoneSidKey='America/Los_Angeles', UserName=uEmail);
        Database.insert(usr1);
        System.assert(usr1.id != null);
        
        // creating  User2
        User usr2 = new User(Alias = 'IPDev2', Email='nikhil.bajaj@globalfoundries.com', 
                             EmailEncodingKey='UTF-8', LastName='IPDevTesting2', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = p.Id, 
                             TimeZoneSidKey='America/Los_Angeles', UserName=uEmail2);
        Database.insert(usr2);
        System.assert(usr2.id != null);
        
        // creating  User3
        User usr3 = new User(Alias = 'IPDev3', Email='nikhil.bajaj@cognizant.com', 
                             EmailEncodingKey='UTF-8', LastName='IPDevTesting2', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = p.Id, 
                             TimeZoneSidKey='America/Los_Angeles', UserName=uEmail3);
        Database.insert(usr3);
        System.assert(usr3.id != null);
        
        //creating grp1
        Group grp = new Group();
        grp.name = 'Test Brand';
        Database.insert(grp);
        System.assert(grp.id != null);
        
        //creating grp2
        Group grp2 = new Group();
        grp2.name = 'Test Brand2';
        Database.insert(grp2);
        System.assert(grp2.id != null);
        
        //creating grp3
        Group grp3 = new Group();
        grp3.name = 'Test Brand3';
        Database.insert(grp3);
        System.assert(grp3.id != null);
        
        //creating grpmember1
        GroupMember gm = new GroupMember();
        gm.UserOrGroupId =usr1.id;
        gm.GroupId = grp.Id;
        Database.insert(gm);
        System.assert(gm.id != null);
        
        //creating grpmember2
        GroupMember gm2 = new GroupMember();
        gm2.UserOrGroupId = usr2.id;
        gm2.GroupId = grp2.Id;
        Database.insert(gm2);
        System.assert(gm2.id != null);
        
        //creating grpmember3
        GroupMember gm3 = new GroupMember();
        gm3.UserOrGroupId = usr3.id;
        gm3.GroupId = grp3.Id;
        Database.insert(gm3);
        System.assert(gm3.id != null);
        
        //creating Email Template
        EmailTemplate et = new EmailTemplate();  
        et.isActive = true;  
        et.Name = 'testTemplate';  
        et.DeveloperName = 'testTemplate' + System.now().getTime();  
        et.TemplateType = 'text';  
        et.FolderId = usr3.id; 
        et.Body = 'test'; 
        Database.insert(et);
        
        
    }
    
    public testmethod static void IPElementTest() {
        
        IPElementLifecycleStage__c omittedLifeCycleCS = new IPElementLifecycleStage__c();
        omittedLifeCycleCS.Name = 'obsolete';
        Database.insert(omittedLifeCycleCS);
        
        List<IPE_IPDK_FieldMapping__c> ipdkList = new List<IPE_IPDK_FieldMapping__c>();
        IPE_IPDK_FieldMapping__c ipdkCS1 = new IPE_IPDK_FieldMapping__c();
        ipdkCS1.Name = 'DESCRIPTION__C';
        ipdkCS1.IP_Field_API_Name__c = 'DESCRIPTION__C';
        ipdkList.add(ipdkCS1);
        IPE_IPDK_FieldMapping__c ipdkCS2 = new IPE_IPDK_FieldMapping__c();
        ipdkCS2.Name = 'provider3p__c';
        ipdkCS2.IP_Field_API_Name__c = 'IP_Vendor__c';
        ipdkList.add(ipdkCS2);
        IPE_IPDK_FieldMapping__c ipdkCS3 = new IPE_IPDK_FieldMapping__c();
        ipdkCS3.Name = 'TECHFEATNAMEID__C';
        ipdkCS3.IP_Field_API_Name__c = 'IP_Device_List__c';
        ipdkList.add(ipdkCS3);
        Database.insert(ipdkList);
        
        List<IPE_IP_FieldMapping__c> ipList = new List<IPE_IP_FieldMapping__c>();
        IPE_IP_FieldMapping__c ipCS1 = new IPE_IP_FieldMapping__c();
        ipCS1.Name = 'devstatus__c';
        ipCS1.IP_Field_API_Name__c = 'Lifecycle__c';
        ipList.add(ipCS1);
        IPE_IP_FieldMapping__c ipCS2 = new IPE_IP_FieldMapping__c();
        ipCS2.Name = 'IP__c';
        ipCS2.IP_Field_API_Name__c = 'Description__c';
        ipList.add(ipCS2);
        IPE_IP_FieldMapping__c ipCS3 = new IPE_IP_FieldMapping__c();
        ipCS3.Name = 'PROCESS_VALIDTECH__C';
        ipCS3.IP_Field_API_Name__c = 'PT_s_Description__c';
        ipList.add(ipCS3);
        IPE_IP_FieldMapping__c ipCS4 = new IPE_IP_FieldMapping__c();
        ipCS4.Name = 'provider3p__c';
        ipCS4.IP_Field_API_Name__c = 'Ip_Vendor__c';
        ipList.add(ipCS4);
        Database.insert(ipList);
        
        IPElementCS__c cs = new IPElementCS__c();
        cs.BccSender__c ='test@gmail.com';
        cs.Name='IPDevCS';
        cs.Template_Name__c='testTemplate';
        
        Database.insert(cs);
        List<Process_Technology__c> ptList = new List<Process_Technology__c>();
        Process_Technology__c pt1 = new Process_Technology__c(Title__c = 'testPT1',PT_Number__c = 'abcd1',IP_Technology_Name__c ='22FDX');
        ptList.add(pt1);
        Process_Technology__c pt2 = new Process_Technology__c(Title__c = 'testPT2',PT_Number__c = 'abcd2',IP_Technology_Name__c ='CMOS17RF');
        ptList.add(pt2);
        Process_Technology__c pt3 = new Process_Technology__c(Title__c = 'testPT3',PT_Number__c = 'abcd3',IP_Technology_Name__c ='CMOS17RF');
        ptList.add(pt3);
        
        Database.insert(ptList);
        system.debug('pt2==>'+pt2.Id);
        system.debug('pt3==>'+pt3.Id);
        IP_Element__c ipe = new IP_Element__c();
        ipe.ip__c = 'Test Description';
        ipe.devstatus__c = 'in plan';
        ipe.iptype__c = 'Soft';
        ipe.PROVIDER3P__C = 'Test Vendor';
        ipe.DESCRIPTION__C = 'Test Description';
        ipe.Process_Technology__c = '22FDX';
        ipe.PROCESS_VALIDTECH__C = 'CMOS5S6FFD';
        ipe.techfeatnameid__c = 'Dev1,Dev2,Dev3';
        insert ipe;
        IP_Element__c ipedb = [Select id, Name from IP_Element__c where Id=:ipe.Id];
        string ipeNum = ipedb.Name.remove('-');
        List<Base_IP__c> ip = [Select Id, Name from Base_IP__c where Name=:ipeNum];
        system.assert(ip.size() == 1);
        system.assertEquals(ipeNum, Ip[0].Name);
        
        ipe.Process_Technology__c = 'CMOS17RF';
        update ipe;
        
        IPE_PT_SelectionController ippt = new IPE_PT_SelectionController(new ApexPages.StandardController(ipe));
        ippt.PTWrapperList[1].isSelected = true;
        ippt.add_IP_PTMap();
        ippt.PTWrapperList[1].isSelected = false;
        ippt.add_IP_PTMap();
        
        ipe.Process_Technology__c = '22FDX';
        update ipe;
    }
    /*--------------------------creating ip element without group name------------------------------*/
    static testmethod  void createIPElement() {
        IPElementLifecycleStage__c omittedLifeCycleCS = new IPElementLifecycleStage__c();
        omittedLifeCycleCS.Name = 'obsolete';
        Database.insert(omittedLifeCycleCS);
        
        List<IPE_IPDK_FieldMapping__c> ipdkList = new List<IPE_IPDK_FieldMapping__c>();
        IPE_IPDK_FieldMapping__c ipdkCS1 = new IPE_IPDK_FieldMapping__c();
        ipdkCS1.Name = 'DESCRIPTION__C';
        ipdkCS1.IP_Field_API_Name__c = 'DESCRIPTION__C';
        ipdkList.add(ipdkCS1);
        IPE_IPDK_FieldMapping__c ipdkCS2 = new IPE_IPDK_FieldMapping__c();
        ipdkCS2.Name = 'provider3p__c';
        ipdkCS2.IP_Field_API_Name__c = 'IP_Vendor__c';
        ipdkList.add(ipdkCS2);
        IPE_IPDK_FieldMapping__c ipdkCS3 = new IPE_IPDK_FieldMapping__c();
        ipdkCS3.Name = 'TECHFEATNAMEID__C';
        ipdkCS3.IP_Field_API_Name__c = 'IP_Device_List__c';
        ipdkList.add(ipdkCS3);
        Database.insert(ipdkList);
        
        List<IPE_IP_FieldMapping__c> ipList = new List<IPE_IP_FieldMapping__c>();
        IPE_IP_FieldMapping__c ipCS1 = new IPE_IP_FieldMapping__c();
        ipCS1.Name = 'devstatus__c';
        ipCS1.IP_Field_API_Name__c = 'Lifecycle__c';
        ipList.add(ipCS1);
        IPE_IP_FieldMapping__c ipCS2 = new IPE_IP_FieldMapping__c();
        ipCS2.Name = 'IP__c';
        ipCS2.IP_Field_API_Name__c = 'Description__c';
        ipList.add(ipCS2);
        IPE_IP_FieldMapping__c ipCS3 = new IPE_IP_FieldMapping__c();
        ipCS3.Name = 'PROCESS_VALIDTECH__C';
        ipCS3.IP_Field_API_Name__c = 'PT_s_Description__c';
        ipList.add(ipCS3);
        IPE_IP_FieldMapping__c ipCS4 = new IPE_IP_FieldMapping__c();
        ipCS4.Name = 'provider3p__c';
        ipCS4.IP_Field_API_Name__c = 'Ip_Vendor__c';
        ipList.add(ipCS4);
        Database.insert(ipList); 
        
        List<Process_Technology__c> ptList = new List<Process_Technology__c>();
        Process_Technology__c pt1 = new Process_Technology__c(Title__c = 'testPT1',PT_Number__c = 'abcd1',IP_Technology_Name__c ='22FDX');
        ptList.add(pt1);
        Process_Technology__c pt2 = new Process_Technology__c(Title__c = 'testPT2',PT_Number__c = 'abcd2',IP_Technology_Name__c ='CMOS17RF');
        ptList.add(pt2);
        Process_Technology__c pt3 = new Process_Technology__c(Title__c = 'testPT3',PT_Number__c = 'abcd3',IP_Technology_Name__c ='CMOS17RF');
        ptList.add(pt3);
        
        Database.insert(ptList);
        try{
            
            //creating custom setting   
            IPElementCS__c cs = new IPElementCS__c();
            cs.BccSender__c ='test@gmail.com';
            cs.Name='IPDevCS';
            cs.Template_Name__c='testTemplate';
            
            Database.insert(cs);
            
            
            Group grp =[select name from Group where name='Test Brand' limit 1];
            Group grp2 =[select name from Group where name='Test Brand2' limit 1];
            
            Set<ID> ids = new Set<ID>();
            List<IP_Element__c> ipelList = new List<IP_Element__c>();
            String grpname =grp.name+';'+grp2.name;
            
            //creating ip element without group name
            for(Integer i=0;i<5;i++){
                ipelList.add(new IP_Element__c(ip__c='Test'+i,devstatus__c = 'in plan',iptype__c = 'Soft',PROVIDER3P__C = 'Test Vendor',DESCRIPTION__C = 'Test Description',Process_Technology__c = '22FDX',techfeatnameid__c = 'Dev1,Dev2,Dev3'));
            }
           
        
            Test.starttest(); 
            Database.insert(ipelList);
            
            
            System.assertEquals(ipelList.size(),5);
            Set<ID> elIds = new Set<ID>();
            for (IP_Element__c rec : ipelList){
                elIds.add(rec.id);
            }
            
            List<IP_Element__Share> shares = [select id from IP_Element__Share where ParentID IN :elIds and RowCause = 'Manual'];
            System.assertEquals(shares.size(),0);
            Test.stoptest();
        }catch(Exception excp) {
            GlobalUtility.logMessage('Error','IPElementSharing_TriggerHelperTest','createIPElement','','Exception while inserting IPElement record in testclass',String.valueof(excp.getMessage()),'','IP Request',excp,0);
        }
    }
    
    
    
    
    /*--------------------------creating ip element without group  and updating with new group ------------------------------*/
    static testmethod  void updateIPElement() {
        IPElementLifecycleStage__c omittedLifeCycleCS = new IPElementLifecycleStage__c();
        omittedLifeCycleCS.Name = 'obsolete';
        Database.insert(omittedLifeCycleCS);
        
        List<IPE_IPDK_FieldMapping__c> ipdkList = new List<IPE_IPDK_FieldMapping__c>();
        IPE_IPDK_FieldMapping__c ipdkCS1 = new IPE_IPDK_FieldMapping__c();
        ipdkCS1.Name = 'DESCRIPTION__C';
        ipdkCS1.IP_Field_API_Name__c = 'DESCRIPTION__C';
        ipdkList.add(ipdkCS1);
        IPE_IPDK_FieldMapping__c ipdkCS2 = new IPE_IPDK_FieldMapping__c();
        ipdkCS2.Name = 'provider3p__c';
        ipdkCS2.IP_Field_API_Name__c = 'IP_Vendor__c';
        ipdkList.add(ipdkCS2);
        IPE_IPDK_FieldMapping__c ipdkCS3 = new IPE_IPDK_FieldMapping__c();
        ipdkCS3.Name = 'TECHFEATNAMEID__C';
        ipdkCS3.IP_Field_API_Name__c = 'IP_Device_List__c';
        ipdkList.add(ipdkCS3);
        Database.insert(ipdkList);
        
        List<IPE_IP_FieldMapping__c> ipList = new List<IPE_IP_FieldMapping__c>();
        IPE_IP_FieldMapping__c ipCS1 = new IPE_IP_FieldMapping__c();
        ipCS1.Name = 'devstatus__c';
        ipCS1.IP_Field_API_Name__c = 'Lifecycle__c';
        ipList.add(ipCS1);
        IPE_IP_FieldMapping__c ipCS2 = new IPE_IP_FieldMapping__c();
        ipCS2.Name = 'IP__c';
        ipCS2.IP_Field_API_Name__c = 'Description__c';
        ipList.add(ipCS2);
        IPE_IP_FieldMapping__c ipCS3 = new IPE_IP_FieldMapping__c();
        ipCS3.Name = 'PROCESS_VALIDTECH__C';
        ipCS3.IP_Field_API_Name__c = 'PT_s_Description__c';
        ipList.add(ipCS3);
        IPE_IP_FieldMapping__c ipCS4 = new IPE_IP_FieldMapping__c();
        ipCS4.Name = 'provider3p__c';
        ipCS4.IP_Field_API_Name__c = 'Ip_Vendor__c';
        ipList.add(ipCS4);
        Database.insert(ipList);
        List<Process_Technology__c> ptList = new List<Process_Technology__c>();
        Process_Technology__c pt1 = new Process_Technology__c(Title__c = 'testPT1',PT_Number__c = 'abcd1',IP_Technology_Name__c ='22FDX');
        ptList.add(pt1);
        Process_Technology__c pt2 = new Process_Technology__c(Title__c = 'testPT2',PT_Number__c = 'abcd2',IP_Technology_Name__c ='CMOS17RF');
        ptList.add(pt2);
        Process_Technology__c pt3 = new Process_Technology__c(Title__c = 'testPT3',PT_Number__c = 'abcd3',IP_Technology_Name__c ='CMOS17RF');
        ptList.add(pt3);
        
        Database.insert(ptList);
        try{
            Test.starttest();
            
            IPElementCS__c cs2 = new IPElementCS__c();
            cs2.BccSender__c ='test2@gmail.com';
            cs2.Name='IPDevCS';
            cs2.Template_Name__c='testTemplate';
            Database.insert(cs2);
            
            Group grp =[select name from Group where name='Test Brand' limit 1];
            Group grp2 =[select name from Group where name='Test Brand2' limit 1];
            Group grp3 =[select name from Group where name='Test Brand3' limit 1];
            
            Set<ID> ids = new Set<ID>();
            List<IP_Element__c> ipelList = new List<IP_Element__c>();
            List<IP_Element__c> updateipelList = new List<IP_Element__c>();
            
            String grpname =grp.name+';'+grp2.name;
            
            /*-------------------creating first record of ipelement with grp Test Brand1 and Test Brand2-----------*/
            for (Integer i=0;i<5;i++){
                ipelList.add(new IP_Element__c(ip__c='Test'+i,GroupName__c=grpname,devstatus__c = 'in plan',iptype__c = 'Soft',PROVIDER3P__C = 'Test Vendor',DESCRIPTION__C = 'Test Description',Process_Technology__c = '22FDX',techfeatnameid__c = 'Dev1,Dev2,Dev3'));
            }
            Database.insert(ipelList);
            System.assertEquals(ipelList.size(),5);
            
            /*---------------------------inserting cell rec----------------------------------------------------------*/
            
            List<IP_Cell__c> cellids = new List<IP_Cell__c>();
            for(IP_Element__c el:ipelList){
                IP_Cell__c c= new IP_Cell__c(IPElement__c=el.id);
                cellids.add(c);
            }
            Database.insert(cellids);
            System.assertEquals(cellids.size(),5);
            
            /*----------------checking in cell share --------------------------------------------------------*/
            List<IP_Cell__Share> cellsharelist =[select id from IP_Cell__Share where ParentID in :cellids and  RowCause = 'Manual' ];
            System.assertEquals(cellsharelist.size(),10);
            
            
            
            /*-----------------inserting rev rec------------------------------------------------------------*/
            List<IP_Revision__c> revids = new List<IP_Revision__c>();
            for(IP_Element__c el:ipelList){
                IP_Revision__c c= new IP_Revision__c(IP_Element__c=el.id);
                revids.add(c);
            }
            
            Database.insert(revids);
            System.assertEquals(revids.size(),5);
            
            /*-----------------------checking in revision share -----------------------------------------*/
            
            List<IP_Revision__Share> revsharelist =[select id from IP_Revision__Share where ParentID in :revids and RowCause = 'Manual' ];
            System.assertEquals(revsharelist.size(),10);
            
            String grpname2 =grp3.name;
            
            /*-------------- updating  Ipelement record with grp  new group-------------------------------*/
            
            for(IP_Element__c itr :ipelList){
                itr.GroupName__c =grpname2;
                updateipelList.add(itr);
            }
            Database.update(updateipelList);
            System.assertEquals(updateipelList.size(),5);
            
            Set<Id> ids2 = new Set<Id>();
            for(IP_Element__c el:updateipelList){
                ids2.add(el.id);
            }
            
            /*-----------------------checking in element/revision/cell share after updating group -----------------------------------------*/               
            List<IP_Cell__c> ipcelList2 =[ select id from IP_Cell__c where IPElement__c in:ids2 ];
            List<IP_Revision__c> iprevList2 =[ select id from IP_Revision__c where IP_Element__c in:ids2 ];
            
            List<IP_Element__Share> elsharelist2 =[select id from IP_Element__Share where ParentID in :updateipelList and  RowCause = 'Manual' ];
            System.assertEquals(updateipelList.size(),5);
            
            List<IP_Cell__Share> cellsharelist2 =[select id from IP_Cell__Share where ParentID in :ipcelList2 and  RowCause = 'Manual' ];
            System.assertEquals(cellsharelist2.size(),5);
            
            List<IP_Revision__Share> revsharelist2 =[select id from IP_Revision__Share where ParentID in :iprevList2 and RowCause = 'Manual' ];
            System.assertEquals(revsharelist2.size(),5);
            
            
            Set<ID> elId = new Set<ID>();
            for (IP_Element__c rec : updateipelList){
                elId.add(rec.id);
            }
            List<IP_Element__Share> shares = [select id from IP_Element__Share where ParentID IN :elId and RowCause = 'Manual'];
            System.assertEquals(shares.size(),5); 
            Test.stoptest();
        }catch(Exception excp) {
            GlobalUtility.logMessage('Error','IPElementSharing_TriggerHelperTest','updateIPElement','','Exception while updating IPElement record in testclass',String.valueof(excp.getMessage()),'','IP Request',excp,0);
        }
        
    }
    
    
    
    /*------------- IPElement test record when deleting group from record-----------------*/
    static testmethod  void DeleteGroupTest() {
        IPElementLifecycleStage__c omittedLifeCycleCS = new IPElementLifecycleStage__c();
        omittedLifeCycleCS.Name = 'obsolete';
        Database.insert(omittedLifeCycleCS);
        
        List<IPE_IPDK_FieldMapping__c> ipdkList = new List<IPE_IPDK_FieldMapping__c>();
        IPE_IPDK_FieldMapping__c ipdkCS1 = new IPE_IPDK_FieldMapping__c();
        ipdkCS1.Name = 'DESCRIPTION__C';
        ipdkCS1.IP_Field_API_Name__c = 'DESCRIPTION__C';
        ipdkList.add(ipdkCS1);
        IPE_IPDK_FieldMapping__c ipdkCS2 = new IPE_IPDK_FieldMapping__c();
        ipdkCS2.Name = 'provider3p__c';
        ipdkCS2.IP_Field_API_Name__c = 'IP_Vendor__c';
        ipdkList.add(ipdkCS2);
        IPE_IPDK_FieldMapping__c ipdkCS3 = new IPE_IPDK_FieldMapping__c();
        ipdkCS3.Name = 'TECHFEATNAMEID__C';
        ipdkCS3.IP_Field_API_Name__c = 'IP_Device_List__c';
        ipdkList.add(ipdkCS3);
        Database.insert(ipdkList);
        
        List<IPE_IP_FieldMapping__c> ipList = new List<IPE_IP_FieldMapping__c>();
        IPE_IP_FieldMapping__c ipCS1 = new IPE_IP_FieldMapping__c();
        ipCS1.Name = 'devstatus__c';
        ipCS1.IP_Field_API_Name__c = 'Lifecycle__c';
        ipList.add(ipCS1);
        IPE_IP_FieldMapping__c ipCS2 = new IPE_IP_FieldMapping__c();
        ipCS2.Name = 'IP__c';
        ipCS2.IP_Field_API_Name__c = 'Description__c';
        ipList.add(ipCS2);
        IPE_IP_FieldMapping__c ipCS3 = new IPE_IP_FieldMapping__c();
        ipCS3.Name = 'PROCESS_VALIDTECH__C';
        ipCS3.IP_Field_API_Name__c = 'PT_s_Description__c';
        ipList.add(ipCS3);
        IPE_IP_FieldMapping__c ipCS4 = new IPE_IP_FieldMapping__c();
        ipCS4.Name = 'provider3p__c';
        ipCS4.IP_Field_API_Name__c = 'Ip_Vendor__c';
        ipList.add(ipCS4);
        Database.insert(ipList); 
        
        List<Process_Technology__c> ptList = new List<Process_Technology__c>();
        Process_Technology__c pt1 = new Process_Technology__c(Title__c = 'testPT1',PT_Number__c = 'abcd1',IP_Technology_Name__c ='22FDX');
        ptList.add(pt1);
        Process_Technology__c pt2 = new Process_Technology__c(Title__c = 'testPT2',PT_Number__c = 'abcd2',IP_Technology_Name__c ='CMOS17RF');
        ptList.add(pt2);
        Process_Technology__c pt3 = new Process_Technology__c(Title__c = 'testPT3',PT_Number__c = 'abcd3',IP_Technology_Name__c ='CMOS17RF');
        ptList.add(pt3);
        
        Database.insert(ptList);
        try{
            Test.starttest();
            IPElementCS__c cs2 = new IPElementCS__c();
            cs2.BccSender__c ='test2@gmail.com';
            cs2.Name='IPDevCS';
            cs2.Template_Name__c='testTemplate';
            Database.insert(cs2);
            
            Group grp =[select name from Group where name='Test Brand' limit 1];
            Group grp2 =[select name from Group where name='Test Brand2' limit 1];
            Group grp3 =[select name from Group where name='Test Brand3' limit 1];
            
            Set<ID> ids = new Set<ID>();
            List<IP_Element__c> ipelList = new List<IP_Element__c>();
            
            /*-------------------creating ipelement record with grp-------------------------*/
            String grpname= grp.name+';'+grp2.name;
            for(Integer i=0;i<5;i++){
                ipelList.add(new IP_Element__c(ip__c='Test'+i,GroupName__c=grpname,devstatus__c = 'in plan',iptype__c = 'Soft',PROVIDER3P__C = 'Test Vendor',DESCRIPTION__C = 'Test Description',Process_Technology__c = '22FDX',techfeatnameid__c = 'Dev1,Dev2,Dev3'));
            }
            
            Database.insert(ipelList);
            
            
            List<IP_Element__c> updateipelList = new List<IP_Element__c>();
            /*--------------------deleting grp from record---------------------------------*/
            for(IP_Element__c itr :ipelList){
                itr.GroupName__c ='';
                updateipelList.add(itr);
            }
            Database.update(updateipelList);
            System.assertEquals(updateipelList.size(),5);
            
            Set<ID> elIds = new Set<ID>();
            for (IP_Element__c rec : updateipelList){
                elIds.add(rec.id);
            }
            
            List<IP_Element__Share> shares = [select id from IP_Element__Share where ParentID IN :elIds and RowCause = 'Manual'];
            System.assertEquals(shares.size(),0); 
            Test.stoptest();
        }catch(Exception excp) {
            GlobalUtility.logMessage('Error','IPElementSharing_TriggerHelperTest','DeleteGroupTest','','Exception while Deleting group from record in testclass',String.valueof(excp.getMessage()),'','IP Request',excp,0);
        }
    }
    
    
    /*--------------------if someone has deleted the ipelement record---------------------*/
    static testmethod  void DeleteIPElementRecord() {
        IPElementLifecycleStage__c omittedLifeCycleCS = new IPElementLifecycleStage__c();
        omittedLifeCycleCS.Name = 'obsolete';
        Database.insert(omittedLifeCycleCS);
        
        List<IPE_IPDK_FieldMapping__c> ipdkList = new List<IPE_IPDK_FieldMapping__c>();
        IPE_IPDK_FieldMapping__c ipdkCS1 = new IPE_IPDK_FieldMapping__c();
        ipdkCS1.Name = 'DESCRIPTION__C';
        ipdkCS1.IP_Field_API_Name__c = 'DESCRIPTION__C';
        ipdkList.add(ipdkCS1);
        IPE_IPDK_FieldMapping__c ipdkCS2 = new IPE_IPDK_FieldMapping__c();
        ipdkCS2.Name = 'provider3p__c';
        ipdkCS2.IP_Field_API_Name__c = 'IP_Vendor__c';
        ipdkList.add(ipdkCS2);
        IPE_IPDK_FieldMapping__c ipdkCS3 = new IPE_IPDK_FieldMapping__c();
        ipdkCS3.Name = 'TECHFEATNAMEID__C';
        ipdkCS3.IP_Field_API_Name__c = 'IP_Device_List__c';
        ipdkList.add(ipdkCS3);
        Database.insert(ipdkList);
        
        List<IPE_IP_FieldMapping__c> ipList = new List<IPE_IP_FieldMapping__c>();
        IPE_IP_FieldMapping__c ipCS1 = new IPE_IP_FieldMapping__c();
        ipCS1.Name = 'devstatus__c';
        ipCS1.IP_Field_API_Name__c = 'Lifecycle__c';
        ipList.add(ipCS1);
        IPE_IP_FieldMapping__c ipCS2 = new IPE_IP_FieldMapping__c();
        ipCS2.Name = 'IP__c';
        ipCS2.IP_Field_API_Name__c = 'Description__c';
        ipList.add(ipCS2);
        IPE_IP_FieldMapping__c ipCS3 = new IPE_IP_FieldMapping__c();
        ipCS3.Name = 'PROCESS_VALIDTECH__C';
        ipCS3.IP_Field_API_Name__c = 'PT_s_Description__c';
        ipList.add(ipCS3);
        IPE_IP_FieldMapping__c ipCS4 = new IPE_IP_FieldMapping__c();
        ipCS4.Name = 'provider3p__c';
        ipCS4.IP_Field_API_Name__c = 'Ip_Vendor__c';
        ipList.add(ipCS4);
        Database.insert(ipList);
        
        List<Process_Technology__c> ptList = new List<Process_Technology__c>();
        Process_Technology__c pt1 = new Process_Technology__c(Title__c = 'testPT1',PT_Number__c = 'abcd1',IP_Technology_Name__c ='22FDX');
        ptList.add(pt1);
        Process_Technology__c pt2 = new Process_Technology__c(Title__c = 'testPT2',PT_Number__c = 'abcd2',IP_Technology_Name__c ='CMOS17RF');
        ptList.add(pt2);
        Process_Technology__c pt3 = new Process_Technology__c(Title__c = 'testPT3',PT_Number__c = 'abcd3',IP_Technology_Name__c ='CMOS17RF');
        ptList.add(pt3);
        
        Database.insert(ptList);
        try{
            Test.starttest();
            IPElementCS__c cs2 = new IPElementCS__c();
            cs2.BccSender__c ='test2@gmail.com';
            cs2.Name='IPDevCS';
            cs2.Template_Name__c='testTemplate';
            Database.insert(cs2);
            
            Group grp =[select name from Group where name='Test Brand' limit 1];
            Group grp2 =[select name from Group where name='Test Brand2' limit 1];
            Group grp3 =[select name from Group where name='Test Brand3' limit 1];
            
            Set<ID> ids = new Set<ID>();
            List<IP_Element__c> ipelList = new List<IP_Element__c>();
            
            /*----------------------creating ipelement record with grp------------------------------*/
            String grpname= grp.name+';'+grp2.name;
            for(Integer i=0;i<5;i++){
                ipelList.add(new IP_Element__c(ip__c='Test'+i,GroupName__c=grpname,devstatus__c = 'in plan',iptype__c = 'Soft',PROVIDER3P__C = 'Test Vendor',DESCRIPTION__C = 'Test Description',Process_Technology__c = '22FDX',techfeatnameid__c = 'Dev1,Dev2,Dev3'));
            }
            Database.insert(ipelList);
            /*-------------------deleting record -------------------------------------------*/
            List<IP_Element__c> updateipelList = new List<IP_Element__c>();
            for(IP_Element__c itr :ipelList){
                updateipelList.add(itr);
            }
            Database.delete(updateipelList);
            System.assertEquals(updateipelList.size(),5);
            Set<ID> elIds = new Set<ID>();
            for (IP_Element__c rec : updateipelList){
                elIds.add(rec.id);
            }
            
            List<IP_Element__Share> shares = [select id from IP_Element__Share where ParentID IN :elIds and RowCause = 'Manual'];
            System.assertEquals(shares.size(),0);
            Test.stoptest();
        }catch(Exception excp) {
            GlobalUtility.logMessage('Error','IPElementSharing_TriggerHelperTest','DeleteIPElementRecord','','Exception while Deleting IPElement record in testclass',String.valueof(excp.getMessage()),'','IP Request',excp,0);
        }
    }
}