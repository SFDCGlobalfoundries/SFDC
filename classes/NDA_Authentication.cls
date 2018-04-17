/**********************************************************************************************************************************
Class:         NDA_Authentication
-----------------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
               Prosenjit Saha
Created Date:  26/09/2013
Reason:        Global class with utility methods to check NDA validity on Process Technologies/ IPs etc.
History:       05022014 PS:   Change in the IP NDA validation code: 
                              To resolve the geometry data format mismatch in agreement and IP record.  
               05152014 PS: - Code has been changed to accommodate new NDA verification logic. NDA goemtery should be
                         verified on the basis of the geomtery granted in the account level rather than the geometry 
                         present in the recent agreement record.
                       - Format modification for the geometry values ending with zeros: such as 0.040UM.                          
***********************************************************************************************************************************/

public class NDA_Authentication {

    public static boolean checkNDAForPTAccess(Process_Technology__c entity, String statusFilter){
        Boolean IsEligible = false;
        User currentUser = [Select Id,
                                   Name,
                                   ContactId
                              From User
                             Where Id =: UserInfo.getUserId()];
        
        If(currentUser.ContactId == Null){
            IsEligible = true;
        } else { 
          /*** Logic has been changed
            Apttus__APTS_Agreement__c currentUserNDA;
            
            List<Apttus__APTS_Agreement__c> lstCurrentUserNDA 
                             = [Select Id,
                                       Geometries__c,
                                       Apttus__Status_Category__c,
                                       Apttus__Account__c
                                  From Apttus__APTS_Agreement__c
                                 Where Apttus__Account__c =: [Select Id,
                                                                     AccountId
                                                                From Contact
                                                               Where Id =: currentUser.ContactId].AccountId AND
                                       Apttus__Status_Category__c =: statusFilter];
            
            currentUserNDA = (lstCurrentUserNDA != Null && lstCurrentUserNDA.size() > 0 ?
                              lstCurrentUserNDA[0]: Null);
            ***Logic has been changed */
            
            //---logic has been changed: the code will verfiy NDA on the basis of the geometry granted in the account level ---
            //---rather than geometry granted in the agreement object (Apttus__APTS_Agreement__c)---
            Account acc = [SELECT  id,
                        name,
                        Tech_Geo_Granted__c,
                        Has_Valid_NDA__c,
                        Valid_Tech_Geos__c
               FROM    account 
               WHERE  Has_Valid_NDA__c = true
               AND    id = :  [Select  Id,
                                                     AccountId
                                             From    Contact
                                             Where    Id =: currentUser.ContactId].AccountId];
            If(acc != Null){             
                IsEligible = (acc.Tech_Geo_Granted__c.contains(entity.Tech_Geometry__c) ? (acc.Valid_Tech_Geos__c.contains(entity.Tech_Geometry__c)? true: false) : false);
            } else {
                IsEligible = false;
            }
            system.debug('DEBUG: PS: Process tech granted'+IsEligible);
        }
        return IsEligible;
    }
    
    public static boolean checkNDAForIPAccess(Base_IP__c entity, String statusFilter){
        Boolean IsEligible = false;
        
        User currentUser = [Select Id,
                                   Name,
                                   ContactId
                              From User
                             Where Id =: UserInfo.getUserId()];
        
        If(currentUser.ContactId == Null){
            IsEligible = true;
        } else {
          /*** Logic has been changed
            Apttus__APTS_Agreement__c currentUserNDA;
            
            List<Apttus__APTS_Agreement__c> lstCurrentUserNDA 
                             = [Select Id,
                                       Geometries__c,
                                       Apttus__Status_Category__c,
                                       Apttus__Account__c
                                  From Apttus__APTS_Agreement__c
                                 Where Apttus__Account__c =: [Select Id,
                                                                     AccountId
                                                                From Contact
                                                               Where Id =: currentUser.ContactId].AccountId AND
                                       Apttus__Status_Category__c =: statusFilter];
            
            currentUserNDA = (lstCurrentUserNDA != Null && lstCurrentUserNDA.size() > 0 ?
                              lstCurrentUserNDA[0]: Null);
            Logic has been changed ***/
            //---logic has been changed: the code will verfiy NDA on the basis of the geometry granted in the account level ---
            //---rather than geometry granted in the agreement object (Apttus__APTS_Agreement__c)---
            Account acc = [SELECT  id,
                        name,
                        Tech_Geo_Granted__c,
                        Has_Valid_NDA__c,
                        Valid_Tech_Geos__c
               FROM    account 
               WHERE  Has_Valid_NDA__c = true
               AND    id = :  [Select  Id,
                                                     AccountId
                                             From    Contact
                                             Where    Id =: currentUser.ContactId].AccountId];
            If(acc != Null){
                //variable to store agreement compatible geometry value. 
                String strGeom; 
                //if the geometry contains nm then change the geomerty value to UM format.
                if(entity.Geometry__c.contains('nm')){
                    Decimal geom = Decimal.valueOf(entity.Geometry__c.replace('nm',''))/1000;
                    system.debug('DEBUG: PS: Length of the string'+String.valueOf(geom).length());
                    String geomValue = String.valueOf(geom); 
                    //to match the format present in the account record. Ending Zeros should be added in the logic.
                    if(geomValue.length() < 5){
                      geomValue = geomValue + '0';    
                    }
                    system.debug('DEBUG: PS: geomvalue string'+ geomValue);
                    strGeom = geomValue + 'UM';
                }
                //else UM value would be considered
                else{
                    strGeom = entity.Geometry__c;
                }
                //Old code: changed 050202014: PS
                //IsEligible = (currentUserNDA.Geometries__c.contains(entity.Geometry__c) ? true : false); 
                IsEligible = (acc.Tech_Geo_Granted__c.contains(strGeom) ? (acc.Valid_Tech_Geos__c.contains(strGeom)? true: false) : false);
            } else {
                IsEligible = false;
            }
        }
        system.debug('ProsenjitTest'+IsEligible);
        return IsEligible;
    }
}