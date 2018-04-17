/*Author: Cognizant
* Description: This trigger runs on BugTeam object. Creates the sharing records
                on bug object based on bug team members. 
* History: Created on 3/7/2014
           Modified on 06/21/2014 to add skip logic.            
*/


trigger BugTeamMemberTrigger on Bug_Team__c (after insert,after update,after delete,after undelete) 
{
    
    if(!IntegrationUserUtil.isSkipTrigger())
    {
            Bug__Share  trsBugShare = null;
            String teamRoomId = null;
            List<String> userIds = new List<String>();  
            List<Bug__Share > insertBugShare = new List<Bug__Share >();
            List<Bug__Share > updateBugShare = new List<Bug__Share >();
            List<Bug__Share > deleteBugShare = new List<Bug__Share >();
            List<Bug__Share > existingBugShare = null;
            Map<String,List<Bug__Share  >> existingUserShares = new Map<String,List<Bug__Share  >>();
            List<Bug__Share  > shareList = null;
        
        
            List<Bug_Team__c> bugteamMembers = null;
        
            if(Trigger.isDelete)
            {
                bugteamMembers = trigger.old;
            }else
            {
                bugteamMembers = trigger.new;
            }
        
            //FIRST BUILD COLLECTIONS OF MEMBER USER OR GROUP IDS IN ORDER TO MINIMIZE NUMBER OF QUERIES EXECUTED
            for(Bug_Team__c bgMember: bugteamMembers)
            {
                teamRoomId = bgMember.Bug__c;
                  if(bgMember.User__c != null)
                    {
                        userIds.add(bgMember.User__c);
                    }
                
            }
        
            //QUERY FOR EXISTING SHARE RECORDS
            existingBugShare= [select Id,ParentId,UserOrGroupId,AccessLevel,RowCause from  Bug__Share where ParentId = :teamRoomId and UserOrGroupId in :userIds];
        
           
        
            //POPULATE MAP OF EXISTING SHARES, MAPPED BY USER OR GROUP ID TO LIST OF SHARES
            for(Bug__Share ets :existingBugShare)
                {
                    //LOOKUP SHARE LIST IN MAP
                    shareList = existingUserShares.get(ets.UserOrGroupId);
        
                    //CHECK IF SHARE LIST FOUND
                    if(shareList == null)
                        {
                            //SHARE LIST NOT FOUND SO CREATE AND ADD TO MAP
                            shareList = new List<Bug__Share>();
                            existingUserShares.put(ets.UserOrGroupId,shareList);
                        }
        
                    //ADD TO EXISTING SHARE LIST FOR CURRENT USER OR GROUP
                    shareList.add(ets);
                }
        
        
            //NOW LOOP AND BUILD COLLECTIONS OF SHARE OBJECTS TO BE INSERTED/UPDATED/DELETED 
            for(Bug_Team__c bgMember: bugteamMembers)
                {
                    //member.addError(msg);
                    existingBugShare= null;
                    //LOOKUP EXISTING SHARES FOR CURRENT USER OR GROUP MEMBER
                    if(bgMember.User__c != null)
                        {
                            existingBugShare= existingUserShares.get(bgMember.User__c);
                        }
        
                    if((existingBugShare!= null)&&(existingBugShare.size() > 0))
                        {
                            trsBugShare= existingBugShare.get(0);
                            if(Trigger.isUpdate)
                                {
                                    if(trsBugShare.RowCause != Schema.Bug__Share.RowCause.Owner)
                                        {
                                            //ADD TO UPDATES
                                            updateBugShare.add(trsBugShare);
                                        }
                                }else if(Trigger.isDelete)
                                {
                                    if(trsBugShare.RowCause != Schema.Bug__Share.RowCause.Owner)
                                        {
                                            // ADD TO DELETES
                                            deleteBugShare.add(trsBugShare);
                                        }
                                }
                            }else
                            {
                                if(!Trigger.isDelete)
                                    {
        
                                        //INSERT OR UPDATE OR UNDELETE
                                        trsBugShare= new Bug__Share();
                                        trsBugShare.ParentId = bgMember.Bug__c;
                                        trsBugShare.UserOrGroupId = bgMember.User__c;
                                        trsBugShare.AccessLevel = 'Read';
                                        trsBugShare.RowCause = Schema.bug__Share.RowCause.Manual;
        
                                        //ADD TO INSERTS
                                        insertBugShare.add(trsBugShare);
        
                                    }
                            }
        
                //SET CORRECT ACCESS LEVEL
                if(trsBugShare!= null)
                    { 
                        if(bgMember.Access__c == 'Read/Write')
                            {
                                trsBugShare.AccessLevel = 'Edit';
                            }else
                            {
                                trsBugShare.AccessLevel = 'Read';
                            }
                    }
        
            }//END FOR LOOP
            
            //EXECUTE INSERTS 
            Database.SaveResult[] iresults = Database.insert(insertBugShare,true);
            //EXECUTE UPDATES
            Database.SaveResult[] uresults = Database.update(updateBugShare,true);
            //EXECUTE DELETES
            Database.DeleteResult[] dresults = Database.delete(deleteBugShare,true);
    }
}