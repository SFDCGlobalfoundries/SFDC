trigger SFDCProjectMemberAfter on SFDC_Project_Member__c (after insert,after update,after delete,after undelete) 
{
  SFDC_Project__Share trs = null;
  List<SFDC_Project__Share> inserts = new List<SFDC_Project__Share>();
  List<SFDC_Project__Share> updates = new List<SFDC_Project__Share>();
  Map<String,SFDC_Project__Share> umap = new Map<String,SFDC_Project__Share>();
  List<SFDC_Project__Share> deletes = new List<SFDC_Project__Share>();
  List<SFDC_Project__Share> existing = null;
  
  List<SFDC_Project_Member__c> members = null;
  
  if(Trigger.isDelete)
  {
      members = trigger.old;
  }else
  {
     members = trigger.new;
  }
    
 for(SFDC_Project_Member__c member: members)
 {
    //CHECK FOR EXISTING SHARE
    existing = [select Id,ParentId,UserOrGroupId,AccessLevel,RowCause from SFDC_Project__Share where ParentId = :member.SFDC_Project__c and UserOrGroupId = :member.User__c];
         
    if(existing.size() > 0)
    {
       trs = existing.get(0);
       if(Trigger.isUpdate)
       {
         if(trs.RowCause != Schema.SFDC_Project__Share.RowCause.Owner)
         {
            //DUPLICATE CHECK BEFORE ADDING TO UPDATE LIST
            if(umap.get(trs.Id)==null)
            {
                //UPDATE
                updates.add(trs);
                umap.put(trs.Id,trs);
            }
         }
       }else if(Trigger.isDelete)
       {
         if(trs.RowCause != Schema.SFDC_Project__Share.RowCause.Owner)
         {
          //DELETE
          deletes.add(trs);
          }
       }
    }else
    {
      if(!Trigger.isDelete)
      {
         
         //INSERT OR UPDATE OR UNDELETE
         trs = new SFDC_Project__Share();
         trs.ParentId = member.SFDC_Project__c;
         trs.UserOrGroupId = member.User__c;
         trs.AccessLevel = 'Read';
         trs.RowCause = Schema.SFDC_Project__Share.RowCause.Manual;
         inserts.add(trs);
        
      }
    }
    
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
  
Database.SaveResult[] iresults = Database.insert(inserts,true);
Database.SaveResult[] uresults = Database.update(updates,true);
Database.DeleteResult[] dresults = Database.delete(deletes,true);

}