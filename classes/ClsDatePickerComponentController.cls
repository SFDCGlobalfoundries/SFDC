/*
Type Name: ClsDatePickerComponentController 
Author: Cognizant
Created Date: 29-May-2013
Reason: This class is used show the date field in Team Room Meeting Edit page.
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

public with sharing class ClsDatePickerComponentController {
    public String currentDate{get; set;}
 
    public ClsDatePickerComponentController() {
        currentDate = Date.Today().format();
    }
}