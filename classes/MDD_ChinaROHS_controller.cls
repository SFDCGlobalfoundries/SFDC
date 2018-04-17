/* 
 Type Name: MDD_ChinaROHS_controller
 Author: JKTechnosoft
 Created Date: 13-July-2016
 Reason: Class for fetching static contents from Custom settings for MDD China RoHS Declaration.
 
 */
public class MDD_ChinaROHS_controller{
    public String str {get; set;}
    public String str1 {get; set;}
    public String str2 {get; set;}
    public String str3 {get; set;}
    public MDD_ChinaROHS_controller(){
        str = '';
        for(MDD_ChinaROHS_Contents__c lstStatic : [Select Id,Name, Content__c from MDD_ChinaROHS_Contents__c where Name Like 'Line%' order By Name Asc ]){
            str+=lstStatic.Content__c;
        }
        str1 = '';
        for(MDD_ChinaROHS_Contents__c lstStatic1 : [Select Id,Name, Content__c from MDD_ChinaROHS_Contents__c where Name Like 'Section1%' order By Name Asc ]){
            str1+=lstStatic1.Content__c;
        }
        str2 = '';
        for(MDD_ChinaROHS_Contents__c lstStatic2 : [Select Id,Name, Content__c from MDD_ChinaROHS_Contents__c where Name Like 'Section2%' order By Name Asc ]){
            str2+=lstStatic2.Content__c;
        }
        str3 = '';
        for(MDD_ChinaROHS_Contents__c lstStatic3 : [Select Id,Name, Content__c from MDD_ChinaROHS_Contents__c where Name Like 'Section3%' order By Name Asc ]){
            str3+=lstStatic3.Content__c;
        }
    }
}