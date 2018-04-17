/**
@Author < Meghna Ganguly >
@name < BnP_TechReview_Util >
@CreateDate < 12/9/2016 >
@Description < This class is used to give functionality to Tech Review button in Decision/CDS page >
@Version <1.0>
*/
public class BnP_TechReview_Util{

    // method called when clicked on Tech Review button, redirect to Tech Review standard new page
    public PageReference callTechReview(Decision__c dec, String chargeNum, String recTypeId) {
         String prefix = Tech_Review_Summary__c.sObjectType.getDescribe().getKeyPrefix();
        
         List<Tech_Review_Summary__c> techReviewList = [select id from Tech_Review_Summary__c 
                                    where Decision__c = :dec.id and RecordTypeId = : recTypeId];
         PageReference pgref = new PageReference('/' + prefix + '/e?');
         
         if(techReviewList != null && techReviewList.size() > 0) {
             pgref = new PageReference('/'+techReviewList[0].id);
             
         } else {
              // assign values to fields for auto populate
             pgref.getParameters().put(Label.BNP_Technical_Requirement,dec.Technical_Requirement__r.Name);
             pgref.getParameters().put(Label.BNP_Technical_Requirement+'_lkid',dec.Technical_Requirement__c);
             pgref.getParameters().put(Label.BNP_Opportunity,dec.Opportunity__r.Name);
             pgref.getParameters().put(Label.BNP_Opportunity+'_lkid',dec.Opportunity__c);
             pgref.getParameters().put(Label.BNP_Request_Info,dec.Request_Information__r.Name);
             pgref.getParameters().put(Label.BNP_Request_Info+'_lkid',dec.Request_Information__c);
             pgref.getParameters().put(Label.BNP_Device,dec.Device__r.Name);
             pgref.getParameters().put(Label.BNP_Device+'_lkid',dec.Device__c);
             pgref.getParameters().put(Label.BNP_Customer_Decision,dec.Name);
             pgref.getParameters().put(Label.BNP_Customer_Decision+'_lkid',dec.Id);
             pgref.getParameters().put('retURL',dec.id);
             
             // assign record type for Foundries
             pgref.getParameters().put('RecordType', recTypeId); 
             
            // populate number from charge info
             if(chargeNum!= null){
                 pgref.getParameters().put(Label.BnP_Charge_Number,chargeNum);
             }
         }
         // pgref.getParameters().put('nooverride','1');
          pgref.setRedirect(true);
       
         if(pgref != null){  
             return pgref;
         } else
            return null;
    }
}