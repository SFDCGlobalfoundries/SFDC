trigger TeamRoomMemberTrigger on Team_Room_Member__c (after insert,after update,after delete,after undelete) 
{
  String msg = null;
  Team_Room__Share trs = null;
  String teamRoomId = null;
  List<String> userIds = new List<String>();
  List<Team_Room__Share> inserts = new List<Team_Room__Share>();
  List<Team_Room__Share> updates = new List<Team_Room__Share>();
  List<Team_Room__Share> deletes = new List<Team_Room__Share>();
  List<Team_Room__Share> existing = null;
  Map<String,List<Team_Room__Share>> existingUserShares = new Map<String,List<Team_Room__Share>>();
  List<Team_Room__Share> shareList = null;
  
  
  List<Team_Room_Member__c> members = null;
  
  if(Trigger.isDelete)
  {
     members = trigger.old;
  }else
  {
     members = trigger.new;
  }
  
  //FIRST BUILD COLLECTIONS OF MEMBER USER OR GROUP IDS IN ORDER TO MINIMIZE NUMBER OF QUERIES EXECUTED
  for(Team_Room_Member__c member: members)
  {
      teamRoomId = member.Team_Room__c;
      if(member.Is_Group__c == true)
      {
          if(member.Group_ID__c != null)
          {
              msg = 'added group to collection';
              userIds.add(member.Group_ID__c);
          }
      }else
      {
          if(member.User__c != null)
          {
              userIds.add(member.User__c);
          }
      }
  }
 
   //QUERY FOR EXISTING SHARE RECORDS
   existing = [select Id,ParentId,UserOrGroupId,AccessLevel,RowCause from Team_Room__Share where ParentId = :teamRoomId and UserOrGroupId in :userIds];
   
   msg += ',found ' + existing.size() + ' existing share records';
   
   //POPULATE MAP OF EXISTING SHARES, MAPPED BY USER OR GROUP ID TO LIST OF SHARES
   for(Team_Room__Share ets :existing)
   {
       //LOOKUP SHARE LIST IN MAP
       shareList = existingUserShares.get(ets.UserOrGroupId);
       
       //CHECK IF SHARE LIST FOUND
       if(shareList == null)
       {
          //SHARE LIST NOT FOUND SO CREATE AND ADD TO MAP
          shareList = new List<Team_Room__Share>();
          existingUserShares.put(ets.UserOrGroupId,shareList);
       }
       
       //ADD TO EXISTING SHARE LIST FOR CURRENT USER OR GROUP
       shareList.add(ets);
   }
   
 
 //NOW LOOP AND BUILD COLLECTIONS OF SHARE OBJECTS TO BE INSERTED/UPDATED/DELETED   
 for(Team_Room_Member__c member: members)
 {
    //member.addError(msg);
    existing = null;
    //LOOKUP EXISTING SHARES FOR CURRENT USER OR GROUP MEMBER
    if(member.Is_Group__c == true)
    {
       if(member.Group_ID__c != null)
       {
         existing = existingUserShares.get(member.Group_ID__c);
       }
    }else
    {
       if(member.User__c != null)
       {
          existing = existingUserShares.get(member.User__c);
       }
    } 
    
    
             
    if((existing != null)&&(existing.size() > 0))
    {
       trs = existing.get(0);
       if(Trigger.isUpdate)
       {
         if(trs.RowCause != Schema.Team_Room__Share.RowCause.Owner)
         {
           //ADD TO UPDATES
           updates.add(trs);
         }
       }else if(Trigger.isDelete)
       {
         if(trs.RowCause != Schema.Team_Room__Share.RowCause.Owner)
         {
            // ADD TO DELETES
            deletes.add(trs);
          }
       }
    }else
    {
      if(!Trigger.isDelete)
      {
         
         //INSERT OR UPDATE OR UNDELETE
         trs = new Team_Room__Share();
         trs.ParentId = member.Team_Room__c;
         if(member.Is_Group__c == true)
         {
             trs.UserOrGroupId = member.Group_ID__c;
         }else
         {
             trs.UserOrGroupId = member.User__c;
         }
         trs.AccessLevel = 'Read';
         trs.RowCause = Schema.Team_Room__Share.RowCause.Manual;
         
         //ADD TO INSERTS
         inserts.add(trs);
        
      }
    }
    
    //SET CORRECT ACCESS LEVEL
    if(trs != null)
    {     
     if(member.Access__c == 'Read/Write')
     {
        trs.AccessLevel = 'Edit';
     }else
     {
       trs.AccessLevel = 'Read';
     }
    }
         
 }//END FOR LOOP

/* Modified by Cognizant on 06052014 for Case-00020275: 3 existing Database methods covered by TRY-CATCH block - START */

try{ 

    //EXECUTE INSERTS  
    Database.SaveResult[] iresults = Database.insert(inserts,true);
    //EXECUTE UPDATES
    Database.SaveResult[] uresults = Database.update(updates,true);
    //EXECUTE DELETES
    Database.DeleteResult[] dresults = Database.delete(deletes,true);

} 
catch(DMLException de){
    System.debug('DMLException='+de) ; 
}
catch(Exception e){
    System.debug('Exception='+e) ; 
}

/* Modified by Cognizant on 06052014 for Case-00020275: 3 existing Database methods covered by TRY-CATCH block - END */

}