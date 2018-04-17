/**
 * Author: Mallika Seth
 * Description: Test Class for AccountSalesOrgUserUtil
 * 
 */
@isTest
public class AccountSalesOrgUserUtilTest {

    public static testmethod void Test(){
    
    AccountSalesOrgUserUtil ASO = new AccountSalesOrgUserUtil();
    AccountSalesOrgUserUtil.isSkipTrigger();
     User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      System.runAs (thisUser) 
      {        // Insert user
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='test@test.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='sdss123@test.com');
        insert u;
        
        // Insert group
        Group grp = new Group();
        grp.Name = 'AccountSalesORG';
        insert grp;
        
        GroupMember grpm = new GroupMember();
        grpm.GroupId =  grp.ID;
        grpm.UserOrGroupId = u.Id;
        Insert grpm;
        AccountSalesOrgUserUtil.isSkipTrigger();
        
       }
    
    }
 }