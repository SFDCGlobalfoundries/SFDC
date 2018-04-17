global class ROS_UpdateAWB{

    webService static void UpdateAWBonGEForm(String HAWB, String custPONumber, String SystemDate, String MAWB, String deliveryNum) {
        if(HAWB !=null && custPONumber!=null){
            List<Reticle__c> LReticles=new List<Reticle__c>([SELECT Id
                                                                  , GE__c
                                                                  , AWB_Number__c
                                                                  , Shipment_Delivery_Number__c
                                                                  , Shipping_date__c,MAWB__c 
                                                             FROM Reticle__c
                                                             WHERE Reticle_Workflow_Status__c = 'Pending for Shipment'
                                                                 AND GE__c = :custPONumber]);
            if(!LReticles.isEmpty()){
                for(Reticle__c eachreticle : LReticles){
                    eachreticle.AWB_Number__c = HAWB; 
                    eachreticle.Shipment_Delivery_Number__c = deliveryNum;
                    eachReticle.Shipping_date__c = SystemDate;
                    eachreticle.MAWB__c = MAWB;
                }
            }
            try {
                database.update(LReticles); 
            } catch(Exception e) {
                ROS_Util.InsertException(e,'ROS_UpdateHAWB.UpdateAWBonGEForm','ROS');
            }
        }
    }
}