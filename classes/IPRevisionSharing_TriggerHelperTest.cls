@isTest(SeeAllData=false)
Public class IPRevisionSharing_TriggerHelperTest {
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
        
    /*----------------inserting  IPRevision test record without IP Element record-----------------*/    
    static testmethod  void createIPRevision() {
        try{ 
            List<IP_Revision__c> iprevList = new List<IP_Revision__c>();
        
            for (Integer i=0;i<5;i++){
               iprevList.add(new IP_Revision__c(Name='Test'+i));
            }
            Test.starttest();
            Database.insert(iprevList);
            Test.stoptest();
       
            System.assertEquals(iprevList.size(),5);
        
        
            List<IP_Revision__Share> revsharelist =[select id from IP_Revision__Share where ParentID in :iprevList and RowCause = 'Manual' ];
            System.assertEquals(revsharelist.size(),0);// as there is no ipelemnt/grp added in rec
        }catch(Exception excp) {
            GlobalUtility.logMessage('Error','IPRevisionSharing_TriggerHelperTest','createIPRevision','','Exception while inserting IPrevision record in testclass',String.valueof(excp.getMessage()),'','IP Request',excp,0);
            }
        
      }
    /*----------------inserting  IPRevision test record with IP Element record and updating Ipelement-----------------*/  
    static testmethod  void updateIPRevision2() {
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
            
            String grpname =grp.name+';'+grp2.name;
            //element 1st record
            IP_Element__c ipelRec = new IP_Element__c(ip__c='Test'+1,GroupName__c =grpname);
            Database.insert(ipelRec);
            IP_Element__c IPElName = [select Name from IP_Element__c where id =:ipelRec.id];
            
            //element 2nd record
            String grpname2= grp2.name+';'+grp3.name;
            IP_Element__c ipelRec2 = new IP_Element__c(ip__c='Test'+1,GroupName__c =grpname2);
            Database.insert(ipelRec2);
             
            // creating revision record
             Set<ID> ids = new Set<ID>();
             List<IP_Revision__c> iprevList = new List<IP_Revision__c>();
             for (Integer i=0;i<5;i++){
                   iprevList.add(new IP_Revision__c(Name='Test',IP_Element__c=ipelRec.id));
               }
              Database.insert(iprevList);
              
              
             //updating  revision record
             List<IP_Revision__c> updateIPrevList = new List<IP_Revision__c>();
             List<IP_Revision__c> revRec = [Select IP_Element__c from IP_Revision__c where IP_Element__c =:ipelRec.id];
             for(IP_Revision__c itr :revRec){
                  itr.IP_Element__c =ipelRec2.id;
                  updateIPrevList.add(itr);
             }
             Database.update(updateIPrevList);

            
            System.assertEquals(updateIPrevList.size(),5);
            
             for (IP_Revision__c rec : updateIPrevList)
                ids.add(rec.id);
                
                System.assertEquals(ids.size(),5);
            
            List<IP_Revision__Share> shares = [select id from IP_Revision__Share  where ParentID IN :ids and RowCause = 'Manual'];
            System.assertEquals(shares.size(),10);// we have two grp in one rec , total 10 rec inserted
            Test.stoptest();
            
        }catch(Exception excp) {
            GlobalUtility.logMessage('Error','IPRevisionSharing_TriggerHelperTest','updateIPRevision2','','Exception while updating ipelement and iprevision record in testclass',String.valueof(excp.getMessage()),'','IP Request',excp,0);
        }
    }
    /*------removing ipelement(lookupvalue)from iprevision record */
    static testmethod  void updateIPRevision3() {
        try{
            Test.starttest();
            
           IPElementCS__c cs = new IPElementCS__c();
            cs.BccSender__c ='test@gmail.com';
            cs.Name='IPDevCS';
            cs.Template_Name__c='testTemplate';
            Database.insert(cs);
            
            Group grp =[select name from Group where name='Test Brand' limit 1];
            Group grp2 =[select name from Group where name='Test Brand2' limit 1];
            
            //creating ip element record
            List<IP_Element__c> ellist2 = new List<IP_Element__c>();
            String grpname =grp.name+';'+grp2.name;
            IP_Element__c ipelRec = new IP_Element__c(ip__c='Test',GroupName__c =grpname);
            ellist2.add(ipelRec);
            Database.insert(ellist2);
             
            List<IP_Revision__c> iprevList = new List<IP_Revision__c>();
            for (Integer i=0;i<5;i++){
               iprevList.add(new IP_Revision__c(Name='Test'+1,IP_Element__c=ipelRec.id));
            }
            Database.insert(iprevList);
            
            
            List<IP_Revision__c> updateIPrevList = new List<IP_Revision__c>();
             
            List<IP_Revision__c> revRec = [Select IP_Element__c from IP_Revision__c where IP_Element__c =:ipelRec.id];
            System.assertEquals(revRec.size(),5);
            for(IP_Revision__c itr :revRec){
                  itr.IP_Element__c ='';
                  updateIPrevList.add(itr);
            }
            Database.update(updateIPrevList);
            System.assertEquals(updateIPrevList.size(),5);
            
            
            Set<ID> ids = new Set<ID>();
            for (IP_Revision__c rec : updateIPrevList)
                ids.add(rec.id);
            
            System.assertEquals(ids.size(),5);
            List<IP_Revision__Share> shares2 = [select id from IP_Revision__Share  where ParentID IN :ids and RowCause = 'Manual'];
            System.assertEquals(shares2.size(),0);
            Test.stoptest();
            
        }catch(Exception excp) {
            GlobalUtility.logMessage('Error','IPRevisionSharing_TriggerHelperTest','updateIPRevision3','','Exception while updating ipelment and iprevision record in testclass',String.valueof(excp.getMessage()),'','IP Request',excp,0);
           }
    
    
    }
}