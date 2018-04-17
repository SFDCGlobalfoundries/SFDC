public with sharing class SFDCProjectManageMembersController
{

    public SFDCProjectManageMembersController() {
          
         String id = apexpages.currentpage().getparameters().get('id');
         List<SFDC_Project__c> spList = [select Id,name, IT_Owner__c, Business_Owner__c, IT_Project_Manager__c, WWMS_System_Solution_Owner__c from SFDC_Project__c where id = :id];
         if(spList.size() == 1)
         {
            SFDCProject = spList.get(0);
         }
         if(SFDCProject != null)
         {
            SFDCProjectName = SFDCProject.name;
            Members = [select Id, User__c,User__r.Name, Access__c, Role__c from SFDC_Project_Member__c where SFDC_Project__c = :SFDCProject.id order by User__r.Name];
            SFDC_Project_Member__c newMember = new SFDC_Project_Member__c(SFDC_Project__c = SFDCProject.id, Access__c = null);
            Members.add(newMember);
         }
    }

    public SFDC_Project__c SFDCProject{get;set;}
    public List<SFDC_Project_Member__c> Members{get;set;}
    public string SFDCProjectName{get;set;}
    SFDC_Project_Member__c businessOwner = null;     //must be unique
    SFDC_Project_Member__c itOwner = null;           //must be unique
    SFDC_Project_Member__c itProjectManager = null;  //must be unique
    SFDC_Project_Member__c wwmsOwner = null;         //must be unique
    SFDC_Project_Member__c businessOwnerBack = null;     //must be unique
    SFDC_Project_Member__c itOwnerBack = null;           //must be unique
    SFDC_Project_Member__c itProjectManagerBack = null;  //must be unique
    SFDC_Project_Member__c wwmsOwnerBack = null;         //must be unique
     
    /*private boolean checkKeyRole(SFDC_Project_Member__c member, User curUser){
        if((member.Role__c != 'Business Owner') && businessOwner != null && (businessOwner.User__c == member.User__c)){ 
            addingError('Business Owner', member, curUser);
            return true; 
        }else if((member.Role__c != 'IT Owner') && itOwner != null && (itOwner.User__c == member.User__c)){ 
            addingError('IT Owner', member, curUser);
            return true; 
        }else if((member.Role__c != 'IT Project Manager') && itProjectManager != null && (itProjectManager.User__c == member.User__c)){ 
            addingError('IT Project Manager', member, curUser);
            return true; 
        }else if((member.Role__c != 'WWMS System & Solution Owner') && wwmsOwner != null && (wwmsOwner.User__c == member.User__c)){ 
            addingError('WWMS System & Solution Owner', member, curUser);
            return true; 
        }else if((member.Role__c != 'Business Owner(backup)') && businessOwnerBack != null && (businessOwnerBack.User__c == member.User__c)){ 
            addingError('Business Owner(backup)', member, curUser);
            return true; 
        }else if((member.Role__c != 'IT Owner(backup)') && itOwnerBack != null && (itOwnerBack.User__c == member.User__c)){ 
            addingError('IT Owner(backup)', member, curUser);
            return true; 
        }else if((member.Role__c != 'IT Project Manager(backup)') && itProjectManagerBack != null && (itProjectManagerBack.User__c == member.User__c)){ 
            addingError('IT Project Manager(backup)', member, curUser);
            return true; 
        }else if((member.Role__c != 'WWMS Systems & Soluton Owner(backup)') && wwmsOwnerBack != null && (wwmsOwnerBack.User__c == member.User__c)){ 
            addingError('WWMS Systems & Soluton Owner(backup)', member, curUser);
            return true; 
        }
        return false;
    }*/
    
    private void addingError(String roleName, SFDC_Project_Member__c member, User curUser){
        member.addError('Key roles (\''+roleName+'\' and \''+member.Role__c+'\') cannot be assigned to \''+curUser.Name+'\' at the same time. Please change to other user.');
    }
    
    
    
     
     public PageReference addNewRow(){
        SFDC_Project_Member__c newMember = new SFDC_Project_Member__c();
        if(SFDCProject != null)
        {
            newMember.SFDC_Project__c = SFDCProject.id;
        }
        Members.add(newMember);
        return null;
    }
    
    public PageReference Save(){
        
       try{
            PageReference spPage = null;
            if(SFDCProject != null)
            {
               spPage = new PageReference('/'+SFDCProject.Id);
            }
            //reset each time it's saved
            businessOwner = null; 
            itOwner = null;
            itProjectManager = null;
            wwmsOwner = null;
            businessOwnerBack = null; 
            itOwnerBack = null;
            itProjectManagerBack = null;
            wwmsOwnerBack = null;
            Map<String,SFDC_Project_Member__c> userMap = new Map<String,SFDC_Project_Member__c>();
            
            List<SFDC_Project_Member__c> umembers = new List<SFDC_Project_Member__c>();
            for(SFDC_Project_Member__c member :Members)
            {
                if(member.User__c == null)
                {
                   continue;
                }
                User curUser = null;
                List<User> userList = [Select Id, Name from User where id = :member.User__c];
                if(userList.size() == 1){
                    curUser = userList.get(0);
                }
                if(curUser == null){
                    continue;
                }
                /* remove this as user can have multiple roles except the 4 main roles must be uniqued. */
                /*if(userMap.get(member.User__c)!= null)
                {
                   List<User> userList = [Select Id, Name from User where id = :member.User__c];
                   if(userList.size() == 1)
                   {
                      User dupUser = userList.get(0);
                      member.addError('User ' + dupUser.Name + ' can only be added to project once');
                   }else
                   {
                       member.addError('User ' + member.User__c + ' can only be added to project once');
                   }
                   return null;
                }*/
                
                if (member.Access__c == null )
                {
                   member.addError('Please specify Access for New Team Members');
                   return null;
                }
                if (member.Role__c == null )
                {
                   member.addError('Please specify Role for New Team Members');
                   return null;
                }else
                {
                    if (member.Role__c == 'IT Owner' )
                    {
                        if(itOwner != null){
                            member.addError('User with role \'' + member.Role__c + '\' already existed. This role must be unique.');
                            return null;
                        }
                        //if(checkKeyRole(member, curUser)){ return null; }
                        itOwner = member;
                    }else if (member.Role__c == 'Business Owner' )
                    {
                        if(businessOwner != null){
                            member.addError('User with role \'' + member.Role__c + '\' already existed. This role must be unique.');
                            return null;
                        }
                        businessOwner = member;
                    }else if (member.Role__c == 'IT Project Manager' )
                    {
                       if(itProjectManager != null){
                            member.addError('User with role \'' + member.Role__c + '\' already existed. This role must be unique.');
                            return null;
                        }
                        itProjectManager = member;
                    }else if (member.Role__c == 'WWMS System & Solution Owner' )
                    {
                       if(wwmsOwner != null){
                            member.addError('User with role \'' + member.Role__c + '\' already existed. This role must be unique.');
                            return null;
                        }
                        wwmsOwner = member;
                    }else if (member.Role__c == 'IT Owner(backup)' )
                    {
                        if(itOwnerBack != null){
                            member.addError('User with role \'' + member.Role__c + '\' already existed. This role must be unique.');
                            return null;
                        }
                        itOwnerBack = member;
                    }else if (member.Role__c == 'Business Owner(backup)' )
                    {
                        if(businessOwnerBack != null){
                            member.addError('User with role \'' + member.Role__c + '\' already existed. This role must be unique.');
                            return null;
                        }
                        businessOwnerBack = member;
                    }else if (member.Role__c == 'IT Project Manager(backup)' )
                    {
                       if(itProjectManagerBack != null){
                            member.addError('User with role \'' + member.Role__c + '\' already existed. This role must be unique.');
                            return null;
                        }
                        itProjectManagerBack = member;
                    }else if (member.Role__c == 'WWMS Systems & Soluton Owner(backup)' )
                    {
                       if(wwmsOwnerBack != null){
                            member.addError('User with role \'' + member.Role__c + '\' already existed. This role must be unique.');
                            return null;
                        }
                        wwmsOwnerBack = member;
                    }
                }
                       
                umembers.add(member); 
                userMap.put(member.User__c, member);      
            }
            upsert umembers;
            
            if(SFDCProject != null)
            {
                SFDCProject.IT_Owner__c = itOwner!=null?itOwner.User__c:null;
                SFDCProject.Business_Owner__c = businessOwner!=null?businessOwner.User__c:null;
                SFDCProject.IT_Project_Manager__c = itProjectManager!=null?itProjectManager.User__c:null;
                SFDCProject.WWMS_System_Solution_Owner__c = wwmsOwner != null?wwmsOwner.User__c:null;
                update SFDCProject;
            }
            return spPage;
        }catch(Exception e){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getdmlMessage(0));  
           ApexPages.addMessage(myMsg);
        }
        return null;
    }
    
    
    
    
}