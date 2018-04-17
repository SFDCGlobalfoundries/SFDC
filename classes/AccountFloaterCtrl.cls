/* **
* Author: Devendra Babu Itraju
* Company: GF
* Project: 
* Description: 
*  
*  
* History:
*    <Devendra Babu Itraju> 2017-10-25 - Created
**/
public  without sharing class AccountFloaterCtrl {
    public string accName{get;set;}
    public string accShortName{get;set;}
    public AccountFloaterCtrl(){
        user u=[SELECT id,contact.account.name,contact.account.short_name__c from user where id =:userinfo.getUserId() limit 1];
        accName=u.contact.account.name;
        accShortName=u.contact.account.short_name__c;
    }
}