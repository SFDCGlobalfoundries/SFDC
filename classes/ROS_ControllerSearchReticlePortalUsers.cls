/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Class to return the reticles in system mode for Portal Users
* History       :   

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        Nikhil Jain     31/03/2014          Created the Class
**/

public without sharing class ROS_ControllerSearchReticlePortalUsers{ 
    
    public static List<Reticle__c> queryReticlesSystemMode(String query){
        return database.Query(query);
    }
    
    public static Database.QueryLocator queryReticlesSystemMode2(String query){
        return database.getQueryLocator(query);
    }
    
    public static boolean returnDispositionType(List<Reticle__c> LselectedReticles){
        boolean isSuccess = true;
        try{
            update LselectedReticles;
        }catch(Exception e){
            isSuccess = false;
            ROS_Util.InsertException(e,'ROS_ControllerSearchReticlePortalUsers.returnScrap','ROS');
        }
        return isSuccess;
    }
    
    
    //for displaying Reticles to Portal User
    public String UserType{get;set;}
    public Reticle__c reticleRecord{get;set;}
    public ROS_ControllerSearchReticlePortalUsers(ApexPages.StandardController controller){
        UserType =  ROS_Util.UserType();
    }
    public void displayReticle(){
        Id reticleId = ApexPages.currentPage().getParameters().get('id');
        reticleRecord = new Reticle__c();
        if(UserType == 'Customer'){
            List<Reticle__c> lstReticle = [SELECT id,name,Account__c,GlobalFoundries_Device_ID__c,Device_ID__c,Region__c,
                                                  Status__c,Reticle_Type__c,Day_Inactive_Formula__c,FabStr__c,Reticle_workflow_Status__c,
                                                  ROS_Status__c,Disposition_Date__c,ROS_Cycle__c
                                            FROM Reticle__c 
                                            WHERE id =:reticleId];
            if(lstReticle != NULL && lstReticle.size()>0){
                reticleRecord = lstReticle[0];
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Reticle not found.'));
            }
        }
    }
}