public class GFSConfigurationController{

    public List<string> leftselected{get;set;}
    public List<string> rightselected{get;set;}
    public list<User> configuredUsers{get; set;}    
    Set<string> leftvalues = new Set<string>();
    Set<string> rightvalues = new Set<string>();
    public List<string> userleftselected{get;set;}
    public List<string> userrightselected{get;set;}
    public string srchTxt{get; set;}
    Set<string> leftUservalues = new Set<string>();
    Set<string> rightUservalues = new Set<string>();
    private map<string, string> stdProfiles;
    private map<string, string> customprofiles;
    private map<string, User> userMap;

    public PageReference selectclick(){
        rightselected.clear();
        for(String s : leftselected){
            leftvalues.remove(s);
            rightvalues.add(s);
        }
        fetchUsers();
        return null;
    }
     
    public PageReference unselectclick(){
        leftselected.clear();
        for(String s : rightselected){
            rightvalues.remove(s);
            leftvalues.add(s);
        }
        fetchUsers();
        return null;
    }
 
    public List<SelectOption> getunSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftvalues);
        tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
        return options;
    }
    
    public List<SelectOption> getSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightvalues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }    
        
    public PageReference userselectclick(){
        userrightselected.clear();
        for(String s : userleftselected){
            leftUservalues.remove(s);
            rightUservalues.add(s);
        }
        return null;
    }
     
    public PageReference userunselectclick(){
        userleftselected.clear();
        for(String s : userrightselected){
            rightUservalues.remove(s);
            leftUservalues.add(s);
        }
        return null;
    }
 
    public List<SelectOption> getunselectedUservalues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftUservalues);
        tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
        return options;
    }
    
    public List<SelectOption> getSelectedUserValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightUservalues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }    

    public GFSConfigurationController(){
        rightselected = new list<string>();
        leftselected = new list<string>();
        userrightselected = new list<string>();
        userleftselected = new list<string>();
        customprofiles = new map<string, string>();
        set<Id> profileIds = new set<Id>();
        list<Profile> profiles = new list<Profile>();
        userMap = new map<string, User>();
        list<PermissionSet> ps = [SELECT Name, ProfileId, (SELECT AssigneeId FROM Assignments) FROM PermissionSet WHERE PermissionsModifyAllData=true];
        for(PermissionSet p: ps)
            profileIds.add(p.profileId);
        profiles = [Select Id, name from Profile where Id in :profileIds];
        //get existing configuration
        map<string, GFS_Configuration__c> configMap = GFS_Configuration__c.getAll();
        set<string> selectedProfiles = new set<string>();
        for(GFS_Configuration__c con: configMap.values())            
            selectedProfiles.add(con.Profile_Name__c);
        
        for(Profile p: profiles){ 
            if(p.Name != 'System Administrator'){   
                if(selectedProfiles.contains(p.Name))
                    rightvalues.add(p.Name);
                else      
                    leftvalues.add(p.Name);
                customprofiles.put(p.Name, p.Id);    
            }    
        }
        fetchUsers(); 
        list<User> extusers = [select Id, name from user where Id in :configMap.keySet()];
        for(User u: extusers){
            rightUservalues.add(u.Name);
            leftUservalues.remove(u.Name);
        }             
        configuredUsers = [Select Id, name, ProfileId, Profile.Name from User where Id IN :configMap.keySet()];
    }
        
    public void fetchUsers(){
        //fetch all users of selected profile
        system.debug('>>>>>>>>>>rightvalues:'+rightvalues);
        set<Id> selectedProfileIds = new set<Id>();
        //userMap = new map<string, User>();
        leftUservalues = new  Set<string>();
        
        map<string, string> selectedUserMap = new map<string, string>();
        for(string r: rightvalues)
            selectedProfileIds.add(customprofiles.get(r)); 
        
        for(string r: rightUservalues)
            selectedUserMap.put(r, r);
        
        if(selectedProfileIds.size() > 0){
            list<User> users = [Select Id, Name, ProfileId, Profile.Name from User where ProfileId IN :selectedProfileIds and IsActive=true limit 1000];
            for(User u: users){
                if(!selectedUserMap.containsKey(u.Name)){
                    userMap.put(u.Name,u);
                    leftUservalues.add(u.Name);
                }
            }
        }
    }
    
    public void findUser(){
        system.debug('>>>>>>>'+srchTxt); 
        if(srchTxt != '' && srchTxt != null){  
            srchTxt = '%'+srchTxt+'%';
            leftUservalues = new set<string>();
            set<Id> selectedProfileIds = new set<Id>();
            for(string r: rightvalues)
                selectedProfileIds.add(customprofiles.get(r)); 
            
            list<User> users = [Select Id, Name from User where Name like :srchTxt and ProfileId In :selectedProfileIds];
            for(User u: users)
                leftUservalues.add(u.Name);
        }else{
            fetchUsers();
        }
    }
    
    public void save(){    
        if(rightUservalues.size() > 0){
            map<string, GFS_Configuration__c> configMap = GFS_Configuration__c.getAll();
            list<GFS_Configuration__c> newConfiglist = new list<GFS_Configuration__c>();
            for(string u: rightUservalues){
                string userId = userMap.get(u).Id;
                if(!configMap.containsKey(userId)){
                    GFS_Configuration__c config = new GFS_Configuration__c(Name=userId, Profile_Name__c = userMap.get(u).Profile.Name); 
                    newConfiglist.add(config);               
                }
            } 
            
            if(newConfiglist.size() > 0){
                insert newConfiglist;
                configMap = GFS_Configuration__c.getAll();
                configuredUsers = new list<User>();
                configuredUsers = [Select Id, name, ProfileId, Profile.Name from User where Id IN :configMap.keySet()];
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'User has been added to Configuration.'));
            }                                                   
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Select User to add Configuration'));
        }               
    }
}