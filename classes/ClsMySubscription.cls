/*
 Type Name: ClsMySubscription 
 Author: Cognizant Technology Solutions
 Created Date: 26-Aug-2013
 Reason: This class is responsible for showing the My Subscription for internal as well as portal user.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
*/

public class ClsMySubscription 
{
    
    /**
    
    Variable Declaration
    
    */
    
    public String OpenPageURL {get; set;}
    public String OpenTextLoginServerURL {get; set;}
    public String respectiveLevel{get;set;}
    public String portalLoginUser;
    User userObj = new User();
    
    /**
        This method is used to set the My Subscription URL.
        
        @method name: ClsMySubscription
        @return : External Site
     */
    public ClsMySubscription ()
    {
        userObj = [SELECT Portal_Login__c FROM User WHERE Id =:userInfo.getUserId()];
        portalLoginUser = userObj.Portal_Login__c;    
        OpenTextLoginServerURL = System.Label.OTLoginServer+portalLoginUser;    
        respectiveLevel = System.Label.Subscription;
        OpenPageURL = System.label.Subscription_URL+'&username='+portalLoginUser;
    }
}