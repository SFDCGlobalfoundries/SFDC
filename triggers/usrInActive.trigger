trigger usrInActive on User (before update) {


    usrInactiveClass ob = new usrInactiveClass();    
    ob.inactiveUsr(trigger.new,trigger.old);
}