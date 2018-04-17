/*
Type Name:    MRSPTRFDetailExtn 
Author:       Cognizant 
Created Date: 10-May-2014
Reason: This is the controller class for displaying the PTRF Detail Page in non-editable format . 
Change History:
Cognizant            10052014     -      Apex code created
Cognizant            05062014     -      Apex code modified for displaying the PTRF record depending on the Read access of the logged-in User 
Cognizant            09062014     -      Incorporated the Code Review Comments
*/

public class MRSPTRFDetailExtn{
    
    /** Public Variables Declaration **/
    Boolean isSwiftAdmin = false;
    public String ptrfURL {get;set;}
    public Boolean isPTRFAccess {get;set;}  
    String url;
    Boolean isSystemAdmin = false;
    Id profileId;
    
    /** The constructor populates the PTRF record after validating whether the logged-in user has read access to the PTRF **/
    
    public MRSPTRFDetailExtn(ApexPages.StandardController controller) {
        url = ApexPages.currentPage().getHeaders().get('Host');      
        ptrfURL = ApexPages.currentPage().getParameters().get('ptrfURL');
        /** If the current logged-in User has no Read access to the PTRF record, displaying the error message, else displaying the PTRF detail page. **/ 
        list<UserRecordAccess > usr = new list<UserRecordAccess >();
        usr = [select RecordId,HasReadAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId = :ptrfURL];
        if(usr.size()>0 &&  usr[0].HasReadAccess){
            isPTRFAccess=true;      
        }else{
            isPTRFAccess=false; 
        }       
        if(!isPTRFAccess){
            ApexPages.Message  myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot view this PTRF record because you do not have any access');
            ApexPages.addMessage(myMsg);        
        }       
    }
    
    /**
        This method redirects the Swift Admin User to the detail page. 
        @method name: redirectToPage
        @parameter:   None.
        @return :     PTRF Detail page.
    **/ 
    
    public PageReference redirectToPage(){
        PageReference page;
        Id userId = UserInfo.getUserId();
        set<String> setLoggedInUserGroups = new set<String>(); 
        setLoggedInUserGroups.addAll(MRSHandlerUtility.fetchCurrentUserGroup(userId));
        if(setLoggedInUserGroups.size()>0){
            for(String userGroup:setLoggedInUserGroups){
                if(userGroup.equalsIgnoreCase('SWIFT_Admin')){
                    isSwiftAdmin = true;
                }
            }
        }
        profileId = UserInfo.getProfileId();
        Profile p = [SELECT Name FROM Profile WHERE Id = :profileId];
        if(p.Name == 'System Administrator'){
            isSystemAdmin = true;
        }        
        if(isSwiftAdmin || isSystemAdmin){   
            if(url.contains(Label.Swift_Host_URL)){
                page = new PageReference('/GlobalfoundryView/'+ptrfURL);
            }else {
                page = new PageReference('/'+ptrfURL);
            }
        }else {
            page = null;
        }
        return page;
    }
}