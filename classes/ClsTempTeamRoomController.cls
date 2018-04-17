/*
Type Name: ClsTempTeamRoomController 
Author: Cognizant
Created Date: 17-May-2013
Reason: This class is used as an extension for accepting Terms and Conditions for Portal users .
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

public class ClsTempTeamRoomController{

    public String retURL {get; set;}
    public String recordType{get; set;}
    public String ent {get; set;}   
    public String keyPrefix {get; set;}
   
    public ClsTempTeamRoomController(ApexPages.StandardController controller) {
    
         retURL=Apexpages.currentPage().getParameters().get(System.Label.retURLTeamRoomController);
         recordType=Apexpages.currentPage().getParameters().get(System.Label.RecordTypeTeamRoomController);
         ent=Apexpages.currentPage().getParameters().get(System.Label.entTeamRoomController);        
         keyPrefix=Apexpages.currentPage().getParameters().get(System.Label.keyPrefixTeamRoomController);        
         
     }

    /**
        This method is used for redirecting the users to Accept page.
        @method name: redirectAcceptPage
        @parameter:   none.
        @return :     PageReference object.
    **/ 
    public PageReference redirectAcceptPage() {
    
      PageReference p = new PageReference(Site.getCurrentSiteUrl()+keyPrefix+'/e?ent='+ent+'&RecordType='+recordType+'&retURL=/'+keyPrefix+'/o');            
      p.getParameters().put('nooverride','1');
      
      return p; 
   }

 }