public class ROS_ShippingAddressProcess{

    public static boolean saveNewAddress(Shipping_Address__c newAddressObj){
        system.debug('######newAddressObj######'+newAddressObj);
        Database.SaveResult insertResult = database.insert(newAddressObj);
        if(insertResult.isSuccess()){
            return true;
        }else{
            return false;
        }
    }
    
    public static boolean saveNewFwdInfo(Forwarder_Information__c newFwdInfoObj){
        system.debug('######newFwdInfoObj######'+newFwdInfoObj);
        Database.SaveResult insertResult = database.insert(newFwdInfoObj);
        if(insertResult.isSuccess()){
            return true;
        }else{
            return false;
        }
    }
}