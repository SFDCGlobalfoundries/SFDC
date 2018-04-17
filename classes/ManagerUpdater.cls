public class ManagerUpdater{
public static Boolean executed=false;


@future
public static void process(Map<Id,ID> userManagerMap)
    {
       if(!ManagerUpdater.executed)
       {
       List<User> userstoUpdate = new list<User>();
        for(user u :  [Select Id,ManagerId from user where Id in: userManagerMap.keySet()])
        {
            u.ManagerId=userManagerMap.get(u.id);
            userstoUpdate.add(u);
            
        }
        if(userstoUpdate.size()>0)
            {
            executed=true;
            update userstoUpdate ;
            }
           } 
        }
}