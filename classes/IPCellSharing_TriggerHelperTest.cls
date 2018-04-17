@isTest(SeeAllData=false)
Public class IPCellSharing_TriggerHelperTest {
        @testSetup static void testdata() 
        {   Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            String uEmail='standarduserIPdev'+ DateTime.now().getTime()+'@testorg.com';
            String uEmail2='standarduserIPdev2'+ DateTime.now().getTime()+'@testorg.com';
            String uEmail3='standarduserIPdev3'+ DateTime.now().getTime()+'@testorg.com';
            
            // creating  User 1
            User usr1 = new User(Alias = 'IPDev1', Email='pranavshyam.marathe@globalfoundries.com', 
            EmailEncodingKey='UTF-8', LastName='IPDevTesting', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName=uEmail);
            Database.insert(usr1);
            System.assert(usr1.id != null);
            
            // creating  User 2
            User usr2 = new User(Alias = 'IPDev2', Email='nikhil.bajaj@globalfoundries.com', 
            EmailEncodingKey='UTF-8', LastName='IPDevTesting2', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName=uEmail2);
            Database.insert(usr2);
            System.assert(usr2.id != null);
            
            
            // creating  User 3
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
        
    /*----------------inserting  IPCell test record without IP Element record-----------------*/    
    static testmethod  void createIPCell() {
        try{ 
        
        List<IP_Cell__c> ipCellList = new List<IP_Cell__c>();
        
        for (Integer i=0;i<5;i++){
               ipCellList.add(new IP_Cell__c(Name='Test'+i));
           }
           Test.starttest();
            Database.insert(ipCellList);
           Test.stoptest();
       
        System.assertEquals(ipCellList.size(),5);
        }catch(Exception excp) {
            GlobalUtility.logMessage('Error','IPCellSharing_TriggerHelperTest','createIPCell','','Exception while inserting IPCell record in testclass',String.valueof(excp.getMessage()),'','IP Request',excp,0);
            }
        
      }
    /*----------------inserting  IPCell test record with IP Element record and updating Ipelement-----------------*/  
    static testmethod  void updateIPCell2() {
     try{
        Test.starttest();
        
        IPElementCS__c cs = new IPElementCS__c();
        cs.BccSender__c ='test@gmail.com';
        cs.Name='IPDevCS';
        cs.Template_Name__c='testTemplate';
        Database.insert(cs);

        
        Group grp =[select name from Group where name='Test Brand' limit 1];
        Group grp2 =[select name from Group where name='Test Brand2' limit 1];
        Group grp3 =[select name from Group where name='Test Brand3' limit 1];
        
        //ipel 1st rec
        String grpname =grp.name+';'+grp2.name;
        IP_Element__c ipelRec = new IP_Element__c(ip__c='Test'+1,GroupName__c =grpname);
        Database.insert(ipelRec);
        
        
        //ipel 2nd rec
        String grpname2= grp3.name;
        IP_Element__c ipelRec2 = new IP_Element__c(ip__c='Test'+1,GroupName__c =grpname2);
        Database.insert(ipelRec2);
         
        //ipcell  rec insert
        Set<ID> ids = new Set<ID>();
        List<IP_Cell__c> ipCellList = new List<IP_Cell__c>();
        for (Integer i=0;i<5;i++){
            ipCellList.add(new IP_Cell__c(Name='Test',IPElement__c=ipelRec.id));
        }
        Database.insert(ipCellList);
         
        //ipcell rec update      
        List<IP_Cell__c> updateIPCellList = new List<IP_Cell__c>();
        List<IP_Cell__c> cellRec = [Select IPElement__c from IP_Cell__c where IPElement__c =:ipelRec.id];
        for(IP_Cell__c itr :cellRec){
              itr.IPElement__c =ipelRec2.id;
              updateIPCellList.add(itr);
        }
        Database.update(updateIPCellList);
        
        System.assertEquals(updateIPCellList.size(),5);
        
        Test.stoptest();
        
        }catch(Exception excp) {
            GlobalUtility.logMessage('Error','IPCellSharing_TriggerHelperTest','updateIPCell2','','Exception while updating ipel and ipcell record in testclass',String.valueof(excp.getMessage()),'','IP Request',excp,0);
           }
    }
    
    static testmethod  void updateIPCell3() {
        try{
        Test.starttest();
        IPElementCS__c cs = new IPElementCS__c();
        cs.BccSender__c ='test@gmail.com';
        cs.Name='IPDevCS';
        cs.Template_Name__c='testTemplate';
        Database.insert(cs);

        
        Group grp =[select name from Group where name='Test Brand' limit 1];
        IP_Element__c ipelRec = new IP_Element__c(ip__c='Test',GroupName__c =grp.name);
        Database.insert(ipelRec);
         
        List<IP_Cell__c> ipCellList = new List<IP_Cell__c>();
        for (Integer i=0;i<5;i++){
            ipCellList.add(new IP_Cell__c(Name='Test'+1,IPElement__c=ipelRec.id));
        }
        Database.insert(ipCellList);
        List<IP_Cell__c> updateIPCellList = new List<IP_Cell__c>();
        List<IP_Cell__c> cellRec = [Select IPElement__c from IP_Cell__c where IPElement__c =:ipelRec.id];
        System.assertEquals(cellRec.size(),5);
        for(IP_Cell__c itr :cellRec){
            itr.IPElement__c ='';
            updateIPCellList.add(itr);
        }
        Database.update(updateIPCellList);
        System.assertEquals(updateIPCellList.size(),5);
        
        Set<ID> ids = new Set<ID>();
        for (IP_Cell__c rec : updateIPCellList){
            ids.add(rec.id);
        }
        System.assertEquals(ids.size(),5);
        System.assertEquals(ids.size(),5);
        List<IP_Cell__Share> shares2 = [select id from IP_Cell__Share  where ParentID IN :ids and RowCause = 'Manual'];
        System.assertEquals(shares2.size(),0);
        Test.stoptest();
        
        }catch(Exception excp) {
            GlobalUtility.logMessage('Error','IPCellSharing_TriggerHelperTest','updateIPCell3','','Exception while updating ipel and ipcell record in testclass',String.valueof(excp.getMessage()),'','IP Request',excp,0);
        }
    }
}