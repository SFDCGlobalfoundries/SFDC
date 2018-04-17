public class PTRFDetailExtn{
    
    public String ptrfURL {get;set;}
    Boolean isSwiftAdmin = false;
    Boolean isSystemAdmin = false;
    String url;
    Id profileId;
   
    public PTRFDetailExtn(ApexPages.StandardController controller) {
        url = ApexPages.currentPage().getHeaders().get('Host');
        ptrfURL = ApexPages.currentPage().getParameters().get('ptrfURL');
    }
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
            //page = new PageReference(Label.PTRFHostUrl+ptrfObj.Id);
            if(url.contains(Label.Swift_Host_URL)){
                page = new PageReference('/GlobalfoundryView/'+ptrfURL);
            }
            else {
                page = new PageReference('/'+ptrfURL);
            }
        }
        else {
            page = null;
        }
        return page;
    }
}