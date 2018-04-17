/**
 *  Class:      ConfigPlusHeaderController 
 *----------------------------------------------------------------------------------------------------------------------------------- 
 * Author:      Prosenjit Saha
 * Description: This Controller class for ConfigPlusHeader
 *
 *
 * History:
 *              PSaha          09212015     - code creation.
 */
public class ConfigPlusHeaderController {
    public String proposalId{get;set;}
    
    public ConfigPlusHeaderController(ApexPages.StandardController controller) {
        proposalId = ApexPages.currentPage().getParameters().get('id');
    }   
}