public class ROS_CONTROLLER_COMP_Final_Notification {
    
    public List<Reticle__c> lReticle { public get; public set; }
    public String userId { public get; public set; }
    public String userName {public get; private set;}
    
    public ROS_CONTROLLER_COMP_Final_Notification() {
        Set<String> sReticle = ROS_Util.getUserReticles(userId);
        
        if (sReticle != null && sReticle.size() > 0) {
            lReticle = [ SELECT Id
                              , Name
                              , Account__r.Name
                              , Device_Id__c
                              , GlobalFoundries_Device_ID__c
                              , ROS_Status__c
                         FROM Reticle__c
                         WHERE Id IN :sReticle ];
        }
        //userName = [SELECT Name FROM User WHERE Id = :userId ].get(0).Name;
    }
}