/* This trigger is an alternate for the sharing rule that NDA records created by General TD Non Legal users should get shared with all users in that role.
However,with the CLM contract implementation, exception is required that CLM record types cannot get auto shared. Hence the trigger instead of sharing rule.
*/

trigger NDAShareOnNonLegalRoleTrigger on Apttus__APTS_Agreement__c (after insert,after update) 
{
    List<Apttus__APTS_Agreement__Share> NDAShares  = new List<Apttus__APTS_Agreement__Share>();
    List<User> usrlist=[select id from user where UserRole.DeveloperName='General_TD_Non_Legal' and isActive=True];
    List<Apttus__APTS_Agreement__Share> oldNDAShrs = [SELECT Id FROM Apttus__APTS_Agreement__Share WHERE ParentId IN (select id from Apttus__APTS_Agreement__c where id in :Trigger.new and OwnerId in :usrlist) and RowCause not in ('Rule','Owner')];

    
    
    Map<String,String> RT_Map=new Map<String,String>();
    
    
    
    for(CLM_Contract_Record_Types__c cst: CLM_Contract_Record_Types__c.getAll().values())
        RT_Map.put(cst.Record_Type_ID__c,cst.Record_Type_API_Name__c);
        
     
        
       for(Apttus__APTS_Agreement__c agr: trigger.new)
            if (String.isBlank(String.valueOf(RT_Map.get(agr.recordTypeID))))   // indicating it is not a CLM record type but NDA type
                 for(User u: usrlist)
                     if(u.id!=agr.OwnerId)
                         {
                         Apttus__APTS_Agreement__Share NDAshare = new Apttus__APTS_Agreement__Share();
                         NDAshare.ParentId = agr.Id;
                         NDAshare.UserOrGroupId = u.id;
                         NDAshare.AccessLevel = 'Edit';
                         NDAshare.RowCause = Schema.Apttus__APTS_Agreement__Share.RowCause.Share_NDA_records_with_TD_Non_Legal_Role__c;
                         NDAShares.add(NDAshare);
                         }
                 
        
        
     try {
          // Delete the existing sharing records.
          // This allows new sharing records to be written from scratch.     
          Delete oldNDAShrs;
          Database.SaveResult[] lsr = Database.insert(NDAShares,false);
             // Process the save results for insert.
          for(Database.SaveResult sr : lsr)
            {
              if(!sr.isSuccess())
                    {
                   // Get the first save result error.
                       Database.Error err = sr.getErrors()[0];
                        
                   // Check if the error is related to trivial access level.
                   // Access levels equal or more permissive than the object's default
                   // access level are not allowed.
                  // These sharing records are not required and thus an insert exception
                   // is acceptable.
                       if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION &&  err.getMessage().contains('AccessLevel')))
                             System.debug('Error='+err.getMessage());
                            
                   }
               }  
            } catch(DmlException e) 
                { System.debug('Error='+e.getMessage());}
                
                
                }