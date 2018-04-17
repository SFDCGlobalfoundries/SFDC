/*
 Type Name: ClsMyAccounts
 Author: Cognizant Technology Solutions
 Created Date: 25-April-2013
 Reason: This class is responsible for showing the My Accounts for portal user.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
*/

public with sharing class ClsMyAccounts
{

    /**
    
    Variable Declaration
    
    */
    public String Page {get; set;}
    public String OpenPageURL {get; set;}
    public String OpenTextLoginServerURL {get; set;}
    public String respectiveLevel{get;set;}
    public String portalLoginUser;
    User userObj = new User();
    
    /**
        This method is used to showing the default page from external application.
        
        @method name: ClsMyAccounts
        @return : External Site
     */
    
    public ClsMyAccounts()
    {
        userObj = [SELECT Portal_Login__c FROM User WHERE Id =:userInfo.getUserId()];
        Page = '' ;
        OpenPageURL = '' ;
        portalLoginUser = userObj.Portal_Login__c;        
        OpenTextLoginServerURL = System.Label.OTLoginServer+portalLoginUser;
        respectiveLevel = System.Label.Preferences;
        
    }
    
     /**
        This method is used to redirect the new web page according to the links are specified .
        
        @method name: redirect
        @return : returns the new web site according to the links
         
     */
    public PageReference redirect()
    {
        if(Page == 'preferences')
        {
           respectiveLevel = System.Label.Preferences;
           OpenPageURL = System.Label.Preferences_URL ;
        }
        if(Page == 'subscription')
        {
            
           respectiveLevel = System.Label.Subscription;
           OpenPageURL = System.label.Subscription_URL+'&username='+portalLoginUser;
            
        }
        if(Page == 'subacct')
        {
           respectiveLevel = System.Label.Manage_Sub_Account;
           OpenPageURL = System.Label.Salesforce_Org_URL + System.Label.Manage_Sub_Account_URL;
         }
        if(Page == 'newacctreq')
        {
           respectiveLevel = System.Label.New_Account_Request;
           OpenPageURL = System.Label.New_Account_Request_URL ;
        }
        if(Page == 'nda')
        {
           respectiveLevel = System.Label.NDA;
           OpenPageURL = System.Label.NDA_URL ;
        }
        if(Page == 'contract')
        {
           respectiveLevel = System.Label.Contract;
           OpenPageURL = System.Label.Contract_URL ;
        }
        /*if(Page == 'survey')
        {
           respectiveLevel = System.Label.Survey;
           OpenPageURL = System.Label.Survey_URL ;
        }*/
        if(Page == 'ipdeclare')
        {
           respectiveLevel = System.Label.IP_Declaration;
           OpenPageURL = System.Label.IP_Declaration_Setttings_URL ;
        }
        if(Page == 'exportcntrl')
        {
           respectiveLevel = System.Label.Export_Control;
           OpenPageURL = System.Label.Export_Control_Settings_URL ;
        }
        if(Page == 'companyprofile')
        {
           respectiveLevel = System.Label.Company_Profile;
           OpenPageURL = System.Label.Company_Profile_URL ;
        }
        return null;
    }
}