/*
 Type Name: ClsR_NewRTeamRoomController
 Author: Global Foundries(Dinesh Suggala)
 Created Date: 8/10/2017
 Reason: This is the Class created to write validation message if the user is ITAR not certified.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..

*/

public with sharing class ClsR_NewRTeamRomController {

    public Restricted_Team_Room__c rteam{get;set;}
    public String RecTypeName{get;set;}
    private String RteamRecordTypeID;
    private String recordid;
    
    public ClsR_NewRTeamRomController(ApexPages.StandardController controller) {
        String custRecordTypeName = ApexPages.currentPage().getParameters().get('RecordType');   
        recordid=ApexPages.currentpage().getparameters().get('Id');
        RteamRecordTypeID=custRecordTypeName ;
        
        if(recordid!=null){
         rteam=[Select Name,R_Primary_Account__c,R_Team_Room_Description__c,RecordType.Name,OwnerId from Restricted_Team_Room__c where id=:recordid];
         set<Id> recset=new set<Id>();
         for(Restricted_Team_Room__c rt:[Select Id,RecordTypeId from Restricted_Team_Room__c  where Id=:recordid]){
          recset.add(rt.RecordTypeId);
         }
         if(recset!=null){
          RecTypeName=[Select Name from RecordType where Id=:recset limit 1].Name;
         }
        }
        else{
         rteam=new Restricted_Team_Room__c();        
         rteam.OwnerId=Userinfo.getUserid();
         RecTypeName= [Select Name from RecordType where Id=:custRecordTypeName limit 1].Name;
         
        }
    }
    
    //Save button
    public pagereference save(){
     system.debug('Enter Save method');
      set<Id> userset=new set<Id>();
      set<Id> hcmset=new set<Id>();
      boolean counter=false;
      
      for(User u:[Select HCM_Record_ID__c from User where Id=:rteam.OwnerId]){
       hcmset.add(u.HCM_Record_ID__c );
      }
      
       for(HCM_Employee__c hcmemp:[Select Id,ITARCertified__c,ITAR_End_Date_Formula__c from HCM_Employee__c where Id=:hcmset]){
        if(hcmemp.ITARCertified__c!=true && hcmemp.ITAR_End_Date_Formula__c!=true){        
           counter=true;
          } 
        }
     
      if(counter==false){
          rteam.RecordTypeId=RteamRecordTypeID;
          if(recordid!=null){
           try{
           Database.SaveResult result = Database.update(rteam, false);
           }
           Catch(DMLException e){
           }
          }
          else{
           try{
           if(rteam.R_Primary_Account__c==null){
            if(RecTypeName =='GLOBALFOUNDRIES with Single party'|| RecTypeName =='GLOBALFOUNDRIES with Multi-Party'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Primary account cannot be blank'));  
            return null;
            }
            else{
            Database.SaveResult result = Database.insert(rteam, false);
            }
           } 
           else{
            Database.SaveResult result = Database.insert(rteam, false);
            }
           }
           Catch(Exception e){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please Contact your System Administrator'));  
           return null;
           }
          }
          PageReference TRPage=new PageReference('/'+'apex/VFR_TeamRoomDetail'+'?id='+rteam.id);
          TRPage.setRedirect(true);
          return TRPage; 
      }
      else{
          ITARTRoomErrorMessages__c dp=ITARTRoomErrorMessages__c.getValues('NewButtonMessage');
          String ErrorMessage=dp.NewErrorMessage__c;
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,ErrorMessage));  
          return null;
      }
      
    }
    
    public pagereference cancel(){
    
    PageReference TRPage=new PageReference('/'+'apex/VFR_RTeamRoomHomePage');
    return TRPage;
    }


}