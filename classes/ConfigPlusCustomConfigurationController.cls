/**
* Class:         ConfigPlusCustomConfigurationController 
* -----------------------------------------------------------------------------------------------------------------------------------------------
* Author:        Prosenjit Saha
* Created Date:  27/11/2014
* Reason:        Custom Configurator Plus Controller.
*
**/

public class ConfigPlusCustomConfigurationController {
    public Apttus_Proposal__Proposal__c ConfiguratorPlus {get;set;} //Configurator Plus record
    public String processTechSel {get;set;} //selected PT
    public Boolean processTechChk {get;set;} // Process Technology Check: TRUE All the fields will be open text fields. 
    
    // Constructor
    public ConfigPlusCustomConfigurationController(ApexPages.StandardController controller) {
        this.ConfiguratorPlus = new Apttus_Proposal__Proposal__c();
        processTechChk = false; //Process Technology Default
        String ConfigID = System.currentPagereference().getParameters().get('id');//get ID
        ConfiguratorPlus = [SELECT     id
                                       , name
                                       , Process_Technology_Name_1__c
                                       , Process_Technology_Name_Edit__c
                                       , Devices_1__c
                                       , Devices_Edit__c
                                       , IPs_Edit__c
                                       , Mask_layers_1__c
                                       , Mask_layers_Edit__c
                                       , Metal_Stacks_1__c
                                       , Metal_Stacks_Edit__c
                                       , IS_Manually_Configured__c
                                       , Packaging_Option_1__c
                                       , Package_Type_1__c
                                       , Wire_Material_for_WB_1__c
                                       , Bump_for_FC_1__c
                                       , Circuit_Under_Bond_Pad_for_WB_1__c
                                       , Package_Substrate_Type_for_FC_1__c
                                       , Pad_Opening_for_WB__c
                                       , Die_Thickness_in_package__c
                                       , Pinout_Number_of_Pad_rows__c          
                                       , Bumping_for_FC_1__c
                                       , Package_Substrate_layer_count_for_FC__c
                                       , Minimum_Bump_In_Line_pad_pitch__c
                                       , Wire_Diameter_for_WB__c
                                       , Package_Body_Size__c
                                       , Package_Substrate_Thickness__c
                                       , Other_Package_Type_1__c
                                       , Packaging_Customisation_Details__c
                                       , Die_Size_is_Pre_Shrink_Post_Rotation__c
                                       , IPs__c
                                       , Process_Technology__c
                                       , Devices__c
                                       /*, Mask_Set__c changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463*/
                                       , Mask_Set_Long__c
                                       , APTPS_Metal_Options__c
                                       , APTPS_Packaging_Option__c
                            FROM       Apttus_Proposal__Proposal__c
                            WHERE      id = :ConfigID];
        if(ConfiguratorPlus.Process_Technology_Name_1__c == 'Others'){//If PT is Others then Make the variable true
            processTechChk = true;
        }
        
    }
    
    //Set Field visibiltiy on the basis of the PT selection. If Others then all the fields should be text field. Otherwise picklist.
    public PageReference setFieldVisibility(){
        if(ConfiguratorPlus.Process_Technology_Name_1__c == 'Others'){
            processTechChk = true;
        }else{
            processTechChk = false;
        }
        return null;
    }
    
    //Save configurator Plus Custom Values 
    public pagereference saveValue(){
        ConfiguratorPlus.IS_Manually_Configured__c = True ; 
        ConfiguratorPlus.Process_Technology__c = ConfiguratorPlus.Process_Technology_Name_1__c; // picklist
        ConfiguratorPlus.Devices__c = processTechChk?ConfiguratorPlus.Devices_Edit__c:ConfiguratorPlus.Devices_1__c; // multi-select
        ConfiguratorPlus.IPs__c = ConfiguratorPlus.IPs_Edit__c;// textbox
        ConfiguratorPlus.APTPS_Metal_Options__c = processTechChk?ConfiguratorPlus.Metal_Stacks_Edit__c:ConfiguratorPlus.Metal_Stacks_1__c;  // picklist        
        //ConfiguratorPlus.Mask_Set__c = processTechChk?ConfiguratorPlus.Mask_layers_Edit__c:ConfiguratorPlus.Mask_layers_1__c; //multi-select
        //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
        ConfiguratorPlus.Mask_Set_Long__c = processTechChk?ConfiguratorPlus.Mask_layers_Edit__c:ConfiguratorPlus.Mask_layers_1__c; //multi-select
        ConfiguratorPlus.APTPS_Packaging_Option__c = ConfiguratorPlus.Packaging_Option_1__c;
        update ConfiguratorPlus ; 
        return (new pagereference('/'+ConfiguratorPlus.id));
    }

}