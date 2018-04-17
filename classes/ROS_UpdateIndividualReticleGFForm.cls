public with sharing class ROS_UpdateIndividualReticleGFForm {

    public boolean IsFabUser{get;set;}
    public Reticle__c eachreticle;
    
    public ROS_UpdateIndividualReticleGFForm(ApexPages.StandardController controller) {
        this.eachreticle= (Reticle__c)controller.getRecord();

        List<Fab_User__c> LFabUsers = new List<Fab_User__c>([Select Id from Fab_User__c where User__c=:UserInfo.getUserId() and Is_ROS_User__c =: true]);
        
        if(LFabUsers.isEmpty()) {
            IsFabUser=false;
        } else if(!(LFabUsers.isEmpty())) {
            IsFabUser=true;
        }
    }
    
    public PageReference NavigatetoGEFormfromReticle(){
        PageReference GEFormPage=new Pagereference('/apex/ROS_GEForm?id='+eachreticle.Id);
        return GEFormPage;
    }
}