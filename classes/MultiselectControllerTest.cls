/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Test Class for MultiselectController class.
* History       :   

        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    07-Sep-15      Created the Class
**/
@isTest
private class MultiselectControllerTest {
    static testMethod void testMultiselectController() {
        MultiselectController c = new MultiselectController();
        
        c.leftOptions = new List<SelectOption>();
        c.rightOptions = new List<SelectOption>();

        c.leftOptionsHidden = 'A&a&b&b&C&c';
        c.rightOptionsHidden = '';
        
        System.assertEquals(c.leftOptions.size(), 3);
        System.assertEquals(c.rightOptions.size(), 0);
    }
}