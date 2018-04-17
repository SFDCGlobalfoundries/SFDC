/*
Type Name: ClsTeamRoomController 
Author: Cognizant
Created Date: 17-May-2013
Reason: This class is used for overriding New button for Team Room for displaying Terms and Conditions for Portal users.
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

public class ClsTeamRoomController {

  public String termsCondtions {get; set;}    
 
  private Team_Room__c objContact;
  public String termsandConditions {get; set;}
  public String profileName {get; set;}
  public String communityPath {get; set;}
  public String profileFlag {get; set;}
  public String correctAccount {get; set;}  
  
  public String retURL {get; set;}
  public String recordType{get; set;}
  public String recordTypeName{get; set;}
  public String ent {get; set;}
  public String keyPrefix {get; set;}
  private final Map<String, Schema.SObjectType> globalDescribe=Schema.getGlobalDescribe();

  public ClsTeamRoomController(ApexPages.StandardController controller) {

      profileFlag = getRedirectionPath(UserInfo.getUserId());
      
      Team_Room__c teamRoomObj = (Team_Room__c)controller.getRecord();
      Id accId = teamRoomObj.Primary_Account__c;
      correctAccount = getCorrectAccount(UserInfo.getUserId(),accId);
      
      retURL=Apexpages.currentPage().getParameters().get(System.Label.retURLTeamRoomController);
      recordType=Apexpages.currentPage().getParameters().get(System.Label.RecordTypeTeamRoomController);
      ent=Apexpages.currentPage().getParameters().get(System.Label.entTeamRoomController);
      
      //System.debug('***************recordType****************'+recordType);
      RecordType recordTypeObj = [SELECT Name FROM RecordType where id = :recordType];
      recordTypeName = recordTypeObj.Name;
      
      //describe the provided sObject
      Schema.DescribeSObjectResult res=globalDescribe.get(System.Label.TeamRoomObjName).getDescribe();
      keyPrefix = res.getKeyPrefix();
         
      termsandConditions = getTermsConditions();
      termsandConditions = termsandConditions.normalizeSpace();
      communityPath = Site.getCurrentSiteUrl();

    }
    
    /**
        This method is used for getting the Terms and Conditions from file saved in Salesforce Document.
        @method name: getTermsConditions
        @parameter:   none.
        @return :     String
    **/ 
    public String getTermsConditions(){
            final String docid = System.Label.TermsDocId;
            Document doc= [Select d.Body, d.Id from Document d where d.Id= :docid];
            return doc.Body.toString();
    }
       
    /**
        This method is used for getting the Profile and then finally the path in which the url will be redirected.
        @method name: getRedirectionPath
        @parameter:   String
        @return :     String
    **/ 
    public String getRedirectionPath(String userId){
       
        Profile profileObj = [SELECT Name FROM Profile where Id in (SELECT ProfileId FROM User where Id = :userId)];
        String profName = profileObj.Name;
        String flag;
        //Modified by Sunil Arora for Case # 10023 to add Overage Portal profiles in the list
        if(profName == System.Label.CustomerPortalAdmin || 
           profName == System.Label.CustomerPortalProfile ||
           profName == System.Label.OverageCustomerPortalAdmin || 
           profName == System.Label.OverageCustomerPortalProfile || 
           profName == System.Label.OverageSupplierPortalProfile || 
           profName == System.Label.OverageSupplierPortalAdmin || 
           profName == System.Label.OverageResellerPortalProfile || 
           profName == System.Label.OverageResellerPortalAdmin || 
           profName == System.Label.OverageEnablementPartnerPortalProfile || 
           profName == System.Label.OverageEnablementPartnerPortalAdmin || 
           profName == System.Label.EnablementPartnerPortalAdmin || 
           profName == System.Label.EnablementPartnerPortalProfile || 
           profName == System.Label.ResellerPortalAdmin || 
           profName == System.Label.ResellerPortalProfile || 
           profName == System.Label.SupplierPortalAdmin || 
           profName == System.Label.SupplierPortalProfile) {
            flag = System.Label.CustomerPortalProfileTrue;
        } else {
            flag = System.Label.CustomerPortalProfileFalse;
        }
        return flag;
    }       

    /**
        This method is used for redirecting to the New Page without Terms and Conditions for non Portal profiles.
        @method name: redirectSystemAdminPage
        @parameter:   none
        @return :     PageReference
    **/ 
        public Pagereference redirectSystemAdminPage() {
            
          retURL = retURL.Substring(1,retURL.length());
          String urlString;

          /*
          if(recordTypeName.equalsIgnoreCase('Internal Private') || recordTypeName.equalsIgnoreCase('Internal Public')){
              urlString = '/'+keyPrefix+'/e?&retURL='+retURL+'&RecordType='+RecordType+'&ent='+ent;
          } else {
          */
              if(retURL.length() == 15){
                Account accountObj = [SELECT Name FROM Account where Id = :retURL];
                urlString = '/'+keyPrefix+'/e?CF'+System.Label.PrimaryAccountSFDCId+'='+accountObj.Name+'&CF'+System.Label.PrimaryAccountSFDCId+'_lkid='+retURL+'&retURL='+retURL+'&RecordType='+RecordType+'&ent='+ent;          
              } else {
                urlString = '/'+keyPrefix+'/e?&retURL='+retURL+'&RecordType='+RecordType+'&ent='+ent;
              }
          //}

          PageReference p = new PageReference(urlString);
          p.getParameters().put('nooverride','1');
          return p; 
       }  
       
    /**
        This method is used for getting the Profile and then finally the path in which the url will be redirected.
        @method name: getCorrectAccount
        @parameter:   String,String
        @return :     String
    **/ 
    public String getCorrectAccount(String userId,Id accId){
        
        Id accountId;
        List<Contact> conList = [SELECT AccountId FROM Contact where Id in (SELECT ContactId FROM User where Id = :userId)];
        for(Contact conObj : conList){
            accountId = conObj.AccountId;
        }        
        
        String flag;
        if(accId == null){
            flag = System.Label.CustomerPortalProfileTrue;
        } else {
            if(accountId == accId) {
                flag = System.Label.CustomerPortalProfileTrue;
            } else {
                flag = System.Label.CustomerPortalProfileFalse;
            }        
        }
        return flag;
    }              

}