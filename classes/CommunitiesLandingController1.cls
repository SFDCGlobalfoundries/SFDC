/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CommunitiesLandingController1{
    
    
    /*Global variable  ----- Begin ----------------------------------------------------------------------------------------------------*/
    public             Contact            CurrentGuest        { get; set; }
    public             Community_TC__c    CurrentTNC          { get; set; }
    public             Community_TC__c    InactiveLatestTNC   { get; set; }
    public             String             CommunityURL        { get; set; }
    public             String             TnCBody             { get; set; }
    public             Boolean            IsGuestUser         { get; set; }
    public             Boolean            IsTncAccepted       { get; set; }
    public             Boolean            IsLatestTNCActive   { get; set; }
    private   static   Boolean            run = true;         //Variable to check recursive trigger execution
    public    static   Boolean            IsInsertEvent =false; //Variable to check Insert event
    /*Global variable  ----- End ------------------------------------------------------------------------------------------------------*/
    
  
    public CommunitiesLandingController1(){
        CommunityURL = URL.getSalesforceBaseUrl().toExternalForm();
        IsGuestUser = !UserInfo.getUserType().equals('Standard');
        
        
        if(!IsGuestUser){
            return;
        }
        
        User currentUser = [SELECT ContactId
                              FROM User
                             WHERE Id =: UserInfo.getUserId()];
                                       
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
                         
        
        IsTncAccepted = (CurrentGuest != Null ? CurrentGuest.Is_Comm_TC_Accepted__c : False);
        
        
        List<Community_TC__c> lstCurrentTNCs = [SELECT Id,
                                                       Name,
                                                       TCDetail__c 
                                                  FROM Community_TC__c 
                                                 WHERE IsActive__c =: TRUE 
                                                 LIMIT 1];
        
        CurrentTNC = (lstCurrentTNCs != Null && lstCurrentTNCs.Size() > 0 ? lstCurrentTNCs[0] : Null);
                       
        
        TnCBody = (CurrentTNC != Null ? CurrentTNC.TCDetail__c : '');
                       
        
        List<Community_TC__c> lstInactiveLatestTNCs = [SELECT Id,
                                                              Name,
                                                              TCDetail__c 
                                                         FROM Community_TC__c 
                                                        WHERE IsActive__c =: TRUE 
                                                     ORDER BY CreatedDate DESC
                                                        LIMIT 1];
                                                        
        InactiveLatestTNC = (lstInactiveLatestTNCs != Null && lstInactiveLatestTNCs.Size() > 0 ? lstInactiveLatestTNCs[0] : Null);
                              
       
        
        IsLatestTNCActive = (InactiveLatestTNC != Null ? True : False);
        
        
    }
    
    /**
    This method redirects user to community home page after accepting the community terms and conditions.
    
        @method name: redirectToHomePage
        @parameter:   None
        @return :     PageReference
    **/
    public PageReference redirectToHomePage(){
        
        PageReference homePageRef = null;
        
        if(TnCBody != '' && TnCBody != null && !IsTncAccepted){
            
            CurrentGuest.Is_Comm_TC_Accepted__c = True;
            CurrentGuest.Accepted_TC_Version__c = (CurrentTNC != Null? CurrentTNC.Id : Null);
            
            Update CurrentGuest;
            
            insert new TC_Acceptance_Log__c(Contact__c = (CurrentGuest != Null? CurrentGuest.Id : Null),
                                            Community_Term_And_Condition__c = (CurrentTNC != Null? CurrentTNC.Id : Null),
                                            Action__c = 'Accepted');
        }
        
        
        Id userid=Userinfo.getUserId();
        Profile profileObj = [SELECT Name FROM Profile where Id in (SELECT ProfileId FROM User where Id = :userid)];
        String profName = profileObj.Name;
        homePageRef = new PageReference(CommunityURL + '/OneGFCommunity/s');
        homePageRef.setRedirect(true);
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
    
        PageReference logInPageRef = new PageReference(System.Label.GFVLogoutURL);
        logInPageRef.setRedirect(true);
        
        return  logInPageRef;
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

   }