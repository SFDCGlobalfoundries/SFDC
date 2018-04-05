@isTest(seeAllData=false)
public class GFSConfigurationControllerTest{
    
    @isTest public static void configTest1() {        
        GFSConfigurationController controller = new GFSConfigurationController();   
        controller.selectclick();
        controller.unselectclick();
        controller.getunSelectedValues();
        controller.getSelectedValues();
        controller.userselectclick();
        controller.userunselectclick();
        controller.getunselectedUservalues();
        controller.getSelectedUserValues();             
        controller.fetchUsers();
        controller.srchTxt='ri';
        controller.findUser();
        controller.save();
    }
}