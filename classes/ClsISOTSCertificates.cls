/*
 Type Name: ClsISOTSCertificates
 Author: Cognizant Technology Solutions
 Created Date:09-Sept-2013
 Reason: This class is responsible for showing the ISO/TS Certficates for internal as well as portal user.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
*/

public class ClsISOTSCertificates
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
        
        @method name: ClsISOTSCertificates
        @return : External Site
     */
    public ClsISOTSCertificates()
    {
        userObj = [SELECT Portal_Login__c FROM User WHERE Id =:userInfo.getUserId()];
        portalLoginUser = userObj.Portal_Login__c;    
        OpenTextLoginServerURL = System.Label.OTLoginServer+portalLoginUser;    
        respectiveLevel = System.Label.ISOTSCertificates_Label;
        OpenPageURL = System.label.ISOTSCertificates_URL+'&username='+portalLoginUser;
    }
}