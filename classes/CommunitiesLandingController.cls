/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CommunitiesLandingController{
    /*
    Commented by Cognizant (FOUNDRYVIEW - Case# 4487)----------------- BEGIN ------------------------------------------------------------ 
    Reason: To modify the landing page of portal users the Terms and Conditions VF page which by OOTB is not supported.     
    Date: 11-MAR-2014
    */
    /* 
    public CommunitiesLandingController(){}
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage(){
        return Network.communitiesLanding();
    }
    */
    /*Commented by Cognizant (FOUNDRYVIEW - Case# 4487)----------------- END ----------------------------------------------------------*/
    
    /*
    Added by Cognizant (FOUNDRYVIEW - Case# 4487)--------------------- BEGIN ------------------------------------------------------------ 
    Reason: To modify the landing page of portal users the Terms and Conditions VF page which by OOTB is not supported.     
    Date: 11-MAR-2014
    */
    
    /*
    Added by Global Foundries(Dinesh)--------------------- BEGIN ------------------------------------------------------------ 
    Reason: Added a method redirecttoHomePage1 for landing to home page for Impersonating user      
    Date: 2-MAR-2017
    */
    /*Global variable  ----- Begin ----------------------------------------------------------------------------------------------------*/
    public             Contact            CurrentGuest        { get; set; }
    public             Community_TC__c    CurrentTNC          { get; set; }
    public             Community_TC__c    InactiveLatestTNC   { get; set; }
    public             String             CommunityURL        { get; set; }
    public             String             TnCBody             { get; set; }
    public             Boolean            IsGuestUser         { get; set; }
    public             Boolean            IsTncAccepted       { get; set; }
    public             Boolean            IsRealUser          { get; set; }
    public             Boolean            IsLatestTNCActive   { get; set; }
    private   static   Boolean            run = true;         //Variable to check recursive trigger execution
    public    static   Boolean            IsInsertEvent =false; //Variable to check Insert event
    /*Global variable  ----- End ------------------------------------------------------------------------------------------------------*/
    
    /*( - By Krishanu)
    public PageReference forwardToStartPage() {
        String communityUrl = URL.getSalesforceBaseUrl().toExternalForm();
        String customHomePage = Label.Custom_Home_Page_Relative_URL;    //    /GlobalfoundryView/apex/VFDisplayCommunityTC
        
        if (UserInfo.getUserType().equals('Guest')){
            return new PageReference(communityUrl + '/login?startURL=' + EncodingUtil.urlEncode(customHomePage, 'UTF-8'));
        } else {
            return new PageReference(communityUrl + customHomePage);
        }
    }
    */
    
    /**
    Constructor.
    
        @Constructor name: CommunitiesLandingController
        @return:   None
    **/
    public CommunitiesLandingController(){
        CommunityURL = URL.getSalesforceBaseUrl().toExternalForm();
        IsGuestUser = !UserInfo.getUserType().equals('Standard');
        
        System.debug('[DEBUG:COGNIZANT] CommunitiesLandingController.CommunitiesLandingController() - CommunityURL :' + CommunityURL);
        System.debug('[DEBUG:COGNIZANT] CommunitiesLandingController.CommunitiesLandingController() - IsGuestUser :' + IsGuestUser);
        
        if(!IsGuestUser){
            return;
        }
        
        User currentUser = [SELECT ContactId
                              FROM User
                             WHERE Id =: UserInfo.getUserId()];
        List<LoginHistory> loginHis = [SELECT LoginTime,LoginType,LoginUrl,UserId FROM LoginHistory where UserId =: UserInfo.getUserId()];
        if(loginHis.size() > 0)
            IsRealUser = true;
        else
            IsRealUser = false; 
        List<Contact> lstCurrentUsers = [SELECT Id,
                                                Name, 
                                                Is_Comm_TC_Accepted__c,
                                                Accepted_TC_Version__c,
                                                Accepted_TC_Version__r.Name,
                                                Accepted_TC_Version__r.IsActive__c,
                                                Accepted_TC_Version__r.TCDetail__c
                                           FROM Contact 
                                          WHERE Id = :currentUser.ContactId];
        
        CurrentGuest = (lstCurrentUsers != Null && lstCurrentUsers.Size() > 0 ? lstCurrentUsers[0] : Null);
                         
        System.debug('[DEBUG:COGNIZANT] CommunitiesLandingController.CommunitiesLandingController() - CurrentGuest :' + CurrentGuest);
        
        IsTncAccepted = (CurrentGuest != Null ? CurrentGuest.Is_Comm_TC_Accepted__c : False);
        
        System.debug('[DEBUG:COGNIZANT] CommunitiesLandingController.CommunitiesLandingController() - IsTncAccepted :' + IsTncAccepted);
        
        List<Community_TC__c> lstCurrentTNCs = [SELECT Id,
                                                       Name,
                                                       TCDetail__c 
                                                  FROM Community_TC__c 
                                                 WHERE IsActive__c =: TRUE 
                                                 LIMIT 1];
        
        CurrentTNC = (lstCurrentTNCs != Null && lstCurrentTNCs.Size() > 0 ? lstCurrentTNCs[0] : Null);
                       
        System.debug('[DEBUG:COGNIZANT] CommunitiesLandingController.CommunitiesLandingController() - CurrentTNC :' + CurrentTNC);
        
        TnCBody = (CurrentTNC != Null ? CurrentTNC.TCDetail__c : '');
                       
        System.debug('[DEBUG:COGNIZANT] CommunitiesLandingController.CommunitiesLandingController() - TnCBody :' + TnCBody);
        
        List<Community_TC__c> lstInactiveLatestTNCs = [SELECT Id,
                                                              Name,
                                                              TCDetail__c 
                                                         FROM Community_TC__c 
                                                        WHERE IsActive__c =: TRUE 
                                                     ORDER BY CreatedDate DESC
                                                        LIMIT 1];
                                                        
        InactiveLatestTNC = (lstInactiveLatestTNCs != Null && lstInactiveLatestTNCs.Size() > 0 ? lstInactiveLatestTNCs[0] : Null);
                              
        System.debug('[DEBUG:COGNIZANT] CommunitiesLandingController.CommunitiesLandingController() - InactiveLatestTNC :' 
                     + InactiveLatestTNC);
        
        IsLatestTNCActive = (InactiveLatestTNC != Null ? True : False);
        
        System.debug('[DEBUG:COGNIZANT] CommunitiesLandingController.CommunitiesLandingController() - IsLatestTNCActive :' 
                     + IsLatestTNCActive);
    }
    
    /**
    This method redirects user to community home page after accepting the community terms and conditions.
    
        @method name: redirectToHomePage
        @parameter:   None
        @return :     PageReference
    **/
    public PageReference redirectToHomePage(){
        System.debug('[DEBUG:COGNIZANT] CommunitiesLandingController.redirectToHomePage() .. ENTERED');
        
        PageReference homePageRef = null;
        
        if(TnCBody != '' && TnCBody != null && !IsTncAccepted){
            System.debug('[DEBUG:COGNIZANT] CommunitiesLandingController.redirectToHomePage() >> ACCEPTED!  = ');
            
            CurrentGuest.Is_Comm_TC_Accepted__c = True;
            CurrentGuest.Accepted_TC_Version__c = (CurrentTNC != Null? CurrentTNC.Id : Null);
            
            Update CurrentGuest;
            
            insert new TC_Acceptance_Log__c(Contact__c = (CurrentGuest != Null? CurrentGuest.Id : Null),
                                            Community_Term_And_Condition__c = (CurrentTNC != Null? CurrentTNC.Id : Null),
                                            Action__c = 'Accepted');
        }
        
        //homePageRef = new PageReference(CommunityURL + '/GlobalfoundryView/home/home.jsp');
        //Code modified by Sunil Arora for case # 10646 to open the default page as per user's profile
        Id userid=Userinfo.getUserId();
        Profile profileObj = [SELECT Name FROM Profile where Id in (SELECT ProfileId FROM User where Id = :userid)];
        String profName = profileObj.Name;
        
        if(profName == System.Label.CustomerPortalAdmin || 
           profName == System.Label.CustomerPortalProfile ||
           profName == System.Label.OverageCustomerPortalAdmin || 
           profName == System.Label.OverageCustomerPortalProfile || 
           profName == System.Label.OverageResellerPortalProfile || 
           profName == System.Label.OverageResellerPortalAdmin || 
           profName == System.Label.OverageEnablementPartnerPortalProfile || 
           profName == System.Label.OverageEnablementPartnerPortalAdmin || 
           profName == System.Label.EnablementPartnerPortalAdmin || 
           profName == System.Label.EnablementPartnerPortalProfile || 
           profName == System.Label.ResellerPortalAdmin || 
           profName == System.Label.ResellerPortalProfile) {
            homePageRef = new PageReference(CommunityURL + '/GlobalfoundryView/GettingStarted');
        } else {
            homePageRef = new PageReference(CommunityURL + '/GlobalfoundryView/home/home.jsp');
        }

        homePageRef.setRedirect(true);
        
        System.debug('[DEBUG:COGNIZANT] CommunitiesLandingController.redirectToHomePage() >> homePageRef = ' + homePageRef);
        
        return homePageRef;
    }
    
    /**
    This method logs out the user from community after declining the community terms and conditions .
    
        @method name: redirectToLogOutPage
        @parameter:   None
        @return :     PageReference .
    **/
    public PageReference redirectToLogInPage(){
        if(CurrentTNC != Null){
            insert new TC_Acceptance_Log__c(Contact__c = (CurrentGuest != Null? CurrentGuest.Id : Null),
                                            Community_Term_And_Condition__c = (CurrentTNC != Null? CurrentTNC.Id : Null),
                                            Action__c = 'Declined');
        }
        System.debug('Inside redirectToLogInPage ---');        
      //PageReference logInPageRef = new PageReference('https://test.foundryview.com/pkmslogout');
        PageReference logInPageRef = new PageReference(System.Label.GFVLogoutURL);
        logInPageRef.setRedirect(true);
        
        return  logInPageRef;
    }
  /**
    This method is used to redirect to Home Page when a Standard internal user Open the GFV View
        @method name: redirecttoHomePage1
        @parameter:   None
        @return :     PageReference .
        Added by Dinesh 02/03/2017
    **/
    
    public PageReference redirecttoHomePage1(){
    
    PageReference homePageRef = new PageReference(CommunityURL + '/GlobalfoundryView/home/home.jsp');
    homePageRef.setRedirect(true);    
    System.debug('[DEBUG:COGNIZANT] CommunitiesLandingController.redirectToHomePage() >> homePageRef = ' + homePageRef);
    return homePageRef;
    }
    
    /**
    This method is a utility static method to check for recursive condition in trigger .
    
        @method name: runOnce
        @parameter:   None
        @return :     boolean.
    **/
    public static boolean runOnce(){
        if(run) {
            run = false;
            return true;
        } else {
            return false;
        }
    }

    /*Added by Cognizant (FOUNDRYVIEW - Case# 4487)--------------------- END ----------------------------------------------------------*/
}