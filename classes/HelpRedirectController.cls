public class HelpRedirectController 
{
    public PageReference redirect()
    {        
        String gid;
        String id = ApexPages.CurrentPage().getParameters().get('id');
        //String gid = ApexPages.CurrentPage().getParameters().get('gid');        
        if(id != null){
            Map<String, HelpGroups__c> mapHelpGroups= HelpGroups__c.getAll();
            HelpGroups__c hg = mapHelpGroups.get(id);
            gid = hg.Groups__c;        
                   
            if((gid!=null )||(gid!=''))
            {
                      Help_History__c helpHist = New Help_History__c();
                      String url= System.Label.HELP_URL+'?g='+gid;
                      PageReference pageRef = new PageReference(url);
                      system.debug('pageRef######------------- ' + pageRef);
                      helpHist.Help_Name__c = id;
                      helpHist.User__c = UserInfo.getUserId();
                      helpHist.URL__c = gid;
                      insert helpHist;
                      return pageRef;
             } 
         }                        
        return null;
    }

}