/** Author : Sandesh Kumar singh

*  Created Date : 28/08/2017
*  Description : Utility class for Apex managed sharing
**/
public class ApexSharingUtils {
    
    
    /** Method name : createCustomObjectShare
     * Arguments : Id recordId - Record id of the custom object record which needs to be shared
     * Id userOrGroupId - Record id of user or public group with which the custom object record needs to be shared
     * String recordAccessLevel - Record sharing access level - Read, Edit, All
     * Return type : sObject - share object specific to the custom object
     * Description : Creates custom object share record as per the parameters passed to the method
    **/
    public static sObject createCustomObjectShare(Id recordId, Id userOrGroupId,
                                                  String recordAccessLevel,String sObjLabel){
        //String sObjLabel = recordId.getSObjectType().getDescribe().getLabel();
        sObjLabel = sObjLabel.replaceAll( '\\s+', '_');                                              
        sObject sObj = Schema.getGlobalDescribe().get(sObjLabel + '__Share').newSObject();
        sObj.put('ParentId',recordId);
        sObj.put('UserOrGroupId',userOrGroupId);
        sObj.put('AccessLevel',recordAccessLevel);
        return sObj;
    }

}