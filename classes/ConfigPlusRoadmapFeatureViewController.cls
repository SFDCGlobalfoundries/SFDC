/**
 *      Class:         ConfigPlusRoadmapFeatureViewController
 *-----------------------------------------------------------------------------------------------------------------------------------
 *      Author:        Prosenjit Saha
 *      Description:   Controller for ConfigPlusRoadmapFeatureView Page. 
 *                     Displayes the selected roadmap features in the inline VF added in the configurator plus detail page layout.
 *      History:           
 *                                 PSaha          09162015     - code creation.
 *             
 **/

public class ConfigPlusRoadmapFeatureViewController{    
    
    //Current Configurtor Plus
    public string CurrentConfiguratorPlusID { get; set; }
    
    //Configurator Plus responses 
    public List<Configurator_Plus_Response__c> LstConfigPlusResponses { get; set; }
    
    //Constructor (Extension)
    public ConfigPlusRoadmapFeatureViewController(ApexPages.StandardController controller){
        
        CurrentConfiguratorPlusID  = ApexPages.currentPage().getParameters().get('Id');
        
        //Query to Configurator plus response table
        LstConfigPlusResponses  = [ SELECT    ID
                                              , Configurator_Plus_Question__c
                                              , Configurator_Plus_Question__r.Question_Name__c
                                              , Configurator_Plus__c
                                              , Name__c
                                              , Proposal_Line_Item__c
                                              , Question_ID__c
                                              , Response__c
                                              , Response_Type__c
                                              , Configurator_Plus_Question__r.Metal_Options__c
                                   FROM       Configurator_Plus_Response__c
                                   WHERE      Response__c = 'TRUE'
                                   AND        Configurator_Plus__c = :CurrentConfiguratorPlusID
                                   AND        Response_Type__c = 'Roadmap Features'] ;                
                
        LstConfigPlusResponses = (LstConfigPlusResponses.size() == 0 ? Null : LstConfigPlusResponses);
    }
    
    
}