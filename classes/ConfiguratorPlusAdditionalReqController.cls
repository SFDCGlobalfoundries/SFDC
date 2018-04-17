/**
*   Class:  ConfiguratorPlusAdditionalReqController 
*-----------------------------------------------------------------------------------------------------------------------------------
*   Author: Ashwini Basavaraj
*   Description: This is the controller class for Additional Requirement Page. 
*                 This page is designed to get all the additional Requirements along with custom specific drop in features. 
*
*   History:
*       Ashwini     11122015     - code creation.
*     
**/
public class ConfiguratorPlusAdditionalReqController {
     public Apttus_Proposal__Proposal__c app{get; set;}// Configurator Plus record
     public string DropinFlag {get; set;} //Flag to determine whether Drop in feature is available
     public List<Apttus_Proposal__Proposal__c> addreqretrive {get; set;} //Additional requirement List
     ApexPages.StandardController controller;
     Id appid;
     public ConfiguratorPlusAdditionalReqController(ApexPages.StandardController controller) {
         this.controller = controller;
         app = (Apttus_Proposal__Proposal__c)controller.getRecord();
         // 
         app = [select id
                       , name
                       , Is_there_gap_req_in_Layer_Map_Table__c
                       , Any_other_Special_Requirements__c
                       , DMOS_Type__c
                       , Additional_Scribeline_Dropin_Req__c
                       , Drop_in_Required__c
                       , Other_Special_Requirements__c
                       , Account_Short_Name__c 
                       , Backgrind_Thickness__c
                       , Special_test_structure_placement__c
                       , BEOL_stack_Not_offered_by_DM__c
                       , SRAM_cell_Not_offered_by_DM__c
                       , Speed_push_Not_offered_by_DM__c
                       , Request_for_special_chip_arrangement__c
                       , Metal_Wall_Seal_Ring_NotPartOfCustProd__c
                       , Dicing_dependency__c
                       , Special_illumination_field_usage__c
               From    Apttus_Proposal__Proposal__c 
               Where   id =:app.id];
               
         // Retrive information from the custom settions named Configurator_Plus_account_list__c      
         List<Configurator_Plus_account_list__c> acctlst= [select  id 
                                                                   , Acct_short_name__c 
                                                            from   Configurator_Plus_account_list__c ];
                                                            
         //Determine whether drop in feature is required
         for(Configurator_Plus_account_list__c r:acctlst)
         {
             If(r.Acct_short_name__c ==app.Account_Short_Name__c )
             {
                 DropinFlag ='true';
                 break;
             }
             else
                 DropinFlag ='false';
         }
         system.debug (DropinFlag ); 
     }
             
    public Pagereference saveform(){
        //save Configurator Plus 
        update app;
        PageReference reRend = new PageReference('/' + app.id);//redirecting to the Configurator Plus detail page. 
        reRend.setRedirect(true);
        return reRend;
    }             
}