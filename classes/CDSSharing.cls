/**
@Author <Mallika Seth>
@name <CDSFormExtension>
@CreateDate <Sept 2017>
@Description <Sharing CDS access with respective opportunity program team members and must be part of owner group zone>
@Version <1.0>
*/
public class CDSSharing {    

   public Static boolean ShareEdit(Id recordId, Set<Id> userOrGroupId){
      // Create new sharing object for the custom object CDS
      
      List<Custom_Design__Share> lstCDSShr = new List<Custom_Design__Share>();
      // Set the ID of record being shared.
      for(ID U1: userOrGroupId){
          Custom_Design__Share CDSShr  = new Custom_Design__Share();
          CDSShr.ParentId = recordId;
          // Set the ID of user or group being granted access.
          CDSShr.UserOrGroupId = U1;
          // Set the access level.
          CDSShr.AccessLevel = 'Edit';
          lstCDSShr.add(CDSShr);
      }
      Database.SaveResult[] saveResultList = Database.insert(lstCDSShr,false);
      // Process the save results.
      for (Database.SaveResult sr : saveResultList) {
        if (!sr.isSuccess()) {
           
            System.debug('Successfully inserted ' + sr.getId());
        }
        else {
            // Operation failed, so get all errors                
            for(Database.Error err : sr.getErrors()) {
                if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  && 
                  err.getMessage().contains('AccessLevel')){
            // Indicates success.
            return true;
            }
             else{
            // Indicates failure.
            return false;
            }
            }
        }
    
      }
           return true;

    }

}