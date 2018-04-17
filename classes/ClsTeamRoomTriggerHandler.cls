/*
Type Name: ClsTeamRoomTriggerHandler 
Author: Cognizant
Created Date: 16-May-2013
Reason: This class is used for updating Team Room Owner. 
Change History:
Author: Cognizant
Modified Date: 
Reason: 
……..
……..
*/


Public class ClsTeamRoomTriggerHandler 
{

 /**
        This method is used to populate Team Room owner with Primary CSr when created by is external user
        @method name: setTeamRoomOwner 
        @parameter:   List of Team Room.
        @return :     none
    **/
     public static void setTeamRoomOwner (List<Team_Room__c> teamroomList)
     {
               List<Team_Room__c> teamroomupdateList=new List<Team_Room__c>();
               List<Id> accountIdList =new  List<Id>();
               List<Team_Room_Member__c> TRmemberList=new List<Team_Room_Member__c>();
               Team_Room__Share teamroomshareObj = new Team_Room__Share() ;
               Team_Room__Share teamroomshareObj1 = new Team_Room__Share() ;
               List<Team_Room__Share> teamroomshareList = new List<Team_Room__Share>();
               List<String> EmailIdList=new  List<String>();
  //fetching the list of account ids of the customer portal users who are creating the team room    
               for(Team_Room__c teamroomObj:teamroomList)
               {
                accountIdList.add(teamroomObj.Createdby.AccountId);
               }
               
   //fetching the list of account related to the customer portal users(created by)            
               List<Account>  accList=[Select id,
                                              Name,
                                              Primary_CSR__c,
                                              OwnerId,
                                              Owner.Isactive
                                              from Account
                                              where Id In:accountIdList ];
                                             
                   for(Team_Room__c teamroomObj:teamroomList)
                   
                   {
                     for(Account accObj:accList)
                     {  
                     
                         if(teamroomObj.Createdby.accountId==accObj.Id)
                         {
                          system.debug('enter if loop');
 //checking if the primary csr of the account is not null and setting the Team room owner to primary csr            
                              if(accObj.Primary_CSR__c !=null)
                              {
                                  teamroomObj.OwnerId = accObj.Primary_CSR__c;
                                  system.debug('teamroomObj.OwnerId'+teamroomObj.OwnerId);
                                  system.debug('accObj.Primary_CSR__c'+accObj.Primary_CSR__c);
                                  teamroomupdateList.add(teamroomObj);
                                  
                              }  
//checking if the primary csr of the account is null and setting the Team room owner to account owner                                          
                              else if(accObj.Primary_CSR__c==null)
                              {
                                  teamroomObj.OwnerId = accObj.OwnerId ;
                                  system.debug('teamroomObj.OwnerId'+teamroomObj.OwnerId);
                                  system.debug('accObj.Primary_CSR__c'+accObj.Primary_CSR__c);
                                  teamroomupdateList.add(teamroomObj);
                                  
                              }   
                         }
                        
                        
     
                      } 
 //adding the creator of the Team room as Team room member with role as moderator                     
                      Team_Room_Member__c CreaterAsTRMember=new Team_Room_Member__c (Team_Room__c=teamroomObj.id,
                                                                            Team_Room_Role__c='Moderator',
                                                                            Access__c='Read/Write',
                                                                            User__c=teamroomObj.CreatedbyId
                                                                            );
                      Team_Room_Member__c OwnerAsTRMember=new Team_Room_Member__c (Team_Room__c=teamroomObj.id,
                                                                            Team_Room_Role__c='Owner',
                                                                            Access__c='Read/Write',
                                                                            User__c=teamroomObj.OwnerId
                                                                            );                                                       
                      system.debug('CreaterAsTRMember'+CreaterAsTRMember);  
                      system.debug('OwnerAsTRMember'+OwnerAsTRMember);                                                        
                      TRmemberList.add(CreaterAsTRMember);
                      if(OwnerAsTRMember.User__c!=CreaterAsTRMember.User__c)
                      {
                      TRmemberList.add(OwnerAsTRMember);
                      }
                      
  //creating Team room share record for the Team room member  added as moderator in the above code                
                   /* if(teamroomObj.Createdby.Isactive==True)
                    {
                      teamroomshareObj=new Team_Room__Share(userorgroupid = CreaterAsTRMember.User__c,
                                                            accessLevel ='Read',
                                                            ParentId =teamroomObj.Id
                                                            );
                      teamroomshareList.add(teamroomshareObj);            
                      }   */ 
                     
                   }
          
              try
              {
    //update team room list             
               if(teamroomupdateList.size()>0)
               {
                update teamroomupdateList;
               
               }
   //insert Team room member list            
               if(TRmemberList.size()>0)
               {
                insert TRmemberList;
               }
     //insert Team room share list                 
              /* if(teamroomshareList.size()>0)
               {
                system.debug('insert share list'+teamroomshareList);
                insert teamroomshareList;
                }*/
              } 
              catch(Exception ex)
              {
               System.debug(ex.getMessage());     
              }
      }
      
  /**
        This method is used to add Team Room Accountto team Room
        @method name: addCorresAccount
        @parameter:   List of Team Room.
        @return :     none
    **/     
      public static void addCorresAccount(List<Team_Room__c> teamroomList,List<Id> profileIdList)
      {
          System.debug('teamroomList-------------->'+ teamroomList +'Size------>'+teamroomList.size());  
          
          List<Team_Room_Account__c> teamroomaccountList=new List<Team_Room_Account__c >();
           Team_Room_Account__c teamroomaccountObj = new Team_Room_Account__c();
          for(Team_Room__c teamroomObj : teamroomList)
          {
              //if(teamroomObj.Num_Associated_Accs__c == 0)
              {
                 teamroomaccountObj = new Team_Room_Account__c();
                 teamroomaccountObj.Team_Room__c=teamroomObj.id;
                 
                 Set<Id> profileIdSet = new Set<Id>(profileIdList);
                 boolean flag = profileIdSet.contains(teamroomObj.CreatedBy.ProfileId);
                 
                 if(flag == true){
                     teamroomaccountObj.Account__c=teamroomObj.Createdby.accountId;
                 } else{
                     teamroomaccountObj.Account__c=teamroomObj.Primary_Account__c;
                 }
                 
                 //teamroomaccountObj.Account__c=teamroomObj.Primary_Account__c;
                 teamroomaccountObj.Association_Type__c='Primary Account';
                 teamroomaccountList.add(teamroomaccountObj);
              }
              
          }
          try
          { 
           insert teamroomaccountList;
          }
          catch(Exception e) 
          {
           System.debug('An exception occurred: ' + e.getMessage());
          } 
          
             
      }
 }