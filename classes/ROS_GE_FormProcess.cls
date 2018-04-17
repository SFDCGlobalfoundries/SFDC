public class ROS_GE_FormProcess{
    
    public static  ROS_RetreiveGEForm_1.result_element[] GefornProcess(ROS_GEFormModel GEFormModel){
    
        ROS_RetreiveGEForm_1.GEReticleSyncService_pt request=new ROS_RetreiveGEForm_1.GEReticleSyncService_pt();
        ROS_RetreiveGEForm_1.result_element[] resReticle;
        request.timeout_x    = 120000;
        if (!Test.isRunningTest()) {
                if(Environment_Variable__c.getInstance('ROS_GEForm_certificate_enable').value__c != 'false'){
                    request.clientCertName_x = Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE').value__c;
                }
                resReticle = request.process(GEFormModel.getOrgID(),GEFormModel.getRequestNo(),
                                                                           GEFormModel.getRaiseDate(),GEFormModel.getEmployeeID(),
                                                                           GEFormModel.getFab(),GEFormModel.getShipToCompany(),GEFormModel.getGEStatus());
           }             
        
      
        return resReticle;
    }


}