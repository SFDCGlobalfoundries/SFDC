/* 
 Type Name: MDD_Reach_controller
 Author: JKTechnosoft
 Created Date: 13-July-2016
 Reason: Class for fetching static contents from Custom settings for Reach Declaration.
 
 */
public without sharing class MDD_Reach_controller{
    public String str {get; set;}
    public static String getDomain () { 
    String hostname = ApexPages.currentPage().getHeaders().get('Host'); 
    String domain = 'https://' + hostname + '/apex/MDD_Reach'; 
        return domain;
    }
    public MDD_Reach_controller(){
        str = '';
        for(MDD_Static_Contents__c lstStatic : [Select Id,Name, Content__c from MDD_Static_Contents__c order By Name Asc]){
            str+=lstStatic.Content__c;
        }
    }
}