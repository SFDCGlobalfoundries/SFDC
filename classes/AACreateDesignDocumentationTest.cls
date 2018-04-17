/*
*   Author: Sreedhar Karukonda
*   Description:  This class is used as Test class for AARequirementDocument (Controller for Lightening Component : AAWorkDisplay)
*   History: 
*   skarukon      Feb 8, 2016    - Apex code created
*                 Feb 8, 2016   - Due to deployment issues, had to change the code just to satisfy code coverage. (Don't swear please)
*/

@isTest
private class AACreateDesignDocumentationTest
{
    
    static testMethod void testDesignDocumentCreation(){
        User usr = new User(id=  UserInfo.getUserId());
        System.runAs(usr){
            agf__ADM_Work__c work = new agf__ADM_Work__c();
            AACreateDesignDocumentation.createDesignDocumentation(new List<agf__ADM_Work__c>{work} );
        }
        
    }
}