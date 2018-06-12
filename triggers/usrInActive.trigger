trigger usrInActive on User (before insert) {


    usrInactiveClass ob = new usrInactiveClass();
    
    ob.inactiveUsr(trigger.new);

}