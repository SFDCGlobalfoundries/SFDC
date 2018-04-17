/**
* Description   :   Functionality to show ROS Help Page.                 
* History       :   

        Initials        Date             Description
----------------------------------------------------------------------------
        DBiswal       07162015        Created the Class.
        
**/

public class ROShelppagecontroller { 
    public ROS_Help__c rosHelp {get; set;}
    public String recordId {get; set;}
    public Boolean showEdit {get; set;}
    
    public ROShelppagecontroller(ApexPages.StandardController controller) {
        recordId = ((ROS_Help__c)controller.getRecord()).Id;
        if(recordId != null){
            rosHelp = [SELECT Id, Name, Help_Content__c FROM ROS_Help__c WHERE Id =: recordId];
        } else{
            rosHelp = [SELECT Id, Name, Help_Content__c FROM ROS_Help__c LIMIT 1];
        }
        Set<String> sUsr = new Set<String>();
        if(Environment_Variable__c.getInstance('ROS_HelpPage_User_Access').Value__c != null){
            for(String s : Environment_Variable__c.getInstance('ROS_HelpPage_User_Access').Value__c.split(',')){
                sUsr.add(s);
            }
        }
        List<User> loggedinUserList = [SELECT Id, Name FROM User WHERE Name IN: sUsr AND Id =: UserInfo.getUserId()];
        if(loggedinUserList.size() > 0){
            showEdit = true;
        } else {
            showEdit = false;
        }
    }
    
    public PageReference editHelp(){
        String hostVal = ApexPages.currentPage().getHeaders().get('Host');
        String editURL = 'https://' + hostVal + '/apex/ROSVF_HelpPage?id=' + rosHelp.Id;
        
        PageReference pageRef = new PageReference(editURL);
        return pageRef;
    }
    
    public PageReference saveHelp(){
        String hostVal1 = ApexPages.currentPage().getHeaders().get('Host');
        String fullURL = 'https://' + hostVal1 + '/apex/ROSVF_HelpPage';
        List<ROS_Help__c> lroshelp = new List<ROS_Help__c>();
        lroshelp.add(rosHelp);
        update lroshelp;
        
        PageReference pageRef1 = new PageReference(fullURL);
        return pageRef1;
    }

}