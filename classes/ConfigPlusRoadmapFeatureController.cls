/**
*   Class:  ConfigPlusRoadmapFeatureController
*-----------------------------------------------------------------------------------------------------------------------------------
*   Author: Prosenjit Saha
*   Description: This is the controller class for class ConfigPlusRoadmapFeature page. 
*                This page is designed to showcase roadmap features specific to the configured Process technology to the end user
*                                 Following sections will be presented in this page: 
*                                        1. Devices in development 
*                                        2. Roadmap IP design Kits
*                                        3. Roadmap Packaging Options
*                                        4. Roadmap Metal Stacks. 
*                                  These Options will be brought from the Configurator Plus Questions table. 
*                                  Saved in Configurator Plus resposes table.
*
*   History:
*       PSaha          09142015     - code creation.
*     
**/
public class ConfigPlusRoadmapFeatureController {
    // is it List of TabHeaders  
    public List<String> TabHeader {get;set;}
    
    //Current Configurtor Plus
    public Apttus_Proposal__Proposal__c CurrentConfiguratorPlus { get; set; }
    
    //this variable stores Questions along with the section header. 
    // e.g. {Key= Roadmap Packaging Options , Value = Questions wrapper related to this section}
    public map<String, List<QuestionNResponseWrapper>> QuestionMap {get;set;}
    
    //This variable stores number for questions along with the roadmap section Header. 
    // e,g. {Key= Roadmap Packaging Options , Value = number of Questions related to this section}
    public map<String, Integer> QuestionNumberMap {get;set;}
    
    /*
            * Method Name:     ConfigPlusRoadmapFeatureController
            * Return Type:     NA
            * Parameter  :     NA
            * Reason     :     this is the constructor
    */
    public ConfigPlusRoadmapFeatureController(ApexPages.StandardController controller) {
        
        //retrieve Configurator plus ID
        CurrentConfiguratorPlus = [Select Id,
                                          Name,
                                          Free_Devices__c,
                                          /*Mask_Set__c, changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463*/
                                          Mask_Set_Long__c,
                                          Process_Technology__c
                                     From Apttus_Proposal__Proposal__c
                                    Where Id =: ApexPages.currentPage().getParameters().get('Id')];
        
        TabHeader = new List<String>();
        QuestionMap = new map<String, List<QuestionNResponseWrapper>>();
        QuestionNumberMap = new map<String, Integer>();
        TabHeader.add('Roadmap Devices');
        QuestionNumberMap.put('Roadmap Devices', 0); 
        TabHeader.add('Roadmap IP Design Kits');      
        QuestionNumberMap.put('Roadmap IP Design Kits', 0);  
        TabHeader.add('Roadmap Packaging options');
        QuestionNumberMap.put('Roadmap Packaging options', 0);
        TabHeader.add('Roadmap Metal Stacks');
        QuestionNumberMap.put('Roadmap Metal Stacks', 0);
        
        //get saved response
        Map<String,Configurator_Plus_Response__c> ConfigPlusResponses = new map<String,Configurator_Plus_Response__c>();
        for(Configurator_Plus_Response__c resp : [SELECT    Name
                                                            , Configurator_Plus__c
                                                            , Configurator_Plus_Question__c
                                                            , Configurator_Plus__r.id
                                                            , Name__c
                                                            , Proposal_Line_Item__c
                                                            , Question_ID__c
                                                            , Response__c
                                                            , Response_Type__c
                                                 FROM       Configurator_Plus_Response__c
                                                 WHERE      Response_Type__c = 'Roadmap Features'
                                                 AND        Configurator_Plus__c = :CurrentConfiguratorPlus.id]){
            ConfigPlusResponses.put(resp.Question_ID__c , resp);    
        }
        
        //get all the configurator plus questions : Active = TRUE and Question type contains "Roadmap"
        for(Configurator_Plus_Question__c Qstn : [SELECT Active__c
                                                         , Data_Type__c
                                                         , Parent_Validation_Field_1__c
                                                         , Parent_Validation_Value_1__c
                                                         , Process_Technology__c
                                                         , Process_Technology__r.name
                                                         , Product_Option_Component__c
                                                         , Question_Name__c
                                                         , Question_Type__c
                                                         , Metal_Options__c
                                                         , Expected_Release_date__c
                                                 FROM   Configurator_Plus_Question__c
                                                 WHERE  Question_Type__c LIKE 'Roadmap%'
                                                 AND    Active__c = TRUE
                                                 AND    Process_Technology__r.name = :CurrentConfiguratorPlus.Process_Technology__c]){
            if(!QuestionMap.containsKey(Qstn.Question_Type__c)){
                List<QuestionNResponseWrapper> TempList = new List<QuestionNResponseWrapper>();                
                QuestionNResponseWrapper tempWrapper = new QuestionNResponseWrapper(Qstn,ConfigPlusResponses.containskey(CurrentConfiguratorPlus.id +'-' +Qstn.id)? (ConfigPlusResponses.get(CurrentConfiguratorPlus.id +'-' +Qstn.id).response__c == 'TRUE'? TRUE: FALSE) : FALSE);
                TempList.add(tempWrapper);
                QuestionMap.put(Qstn.Question_Type__c, TempList);
                
            }
            else{
                QuestionMap.get(Qstn.Question_Type__c).add(new QuestionNResponseWrapper(Qstn,ConfigPlusResponses.containskey(CurrentConfiguratorPlus.id +'-' +Qstn.id)? (ConfigPlusResponses.get(CurrentConfiguratorPlus.id +'-' +Qstn.id).response__c == 'TRUE'? TRUE: FALSE) : FALSE));
            }
            integer countQs = QuestionNumberMap.containsKey(Qstn.Question_Type__c) ?  QuestionNumberMap.get(Qstn.Question_Type__c)+ 1 : 0 ; 
            QuestionNumberMap.put(Qstn.Question_Type__c, countQs );
        }
        
    } 
    
    //Save RoadMap features 
    public pageReference saveResponse (){
        List<Configurator_Plus_Response__c> FinalResponse = new List<Configurator_Plus_Response__c>();
        for(List<QuestionNResponseWrapper> QuestionWrapList : QuestionMap.values()){
            for(QuestionNResponseWrapper QuestionWrap : QuestionWrapList){
                Configurator_Plus_Response__c TempResponse = new Configurator_Plus_Response__c();
                    TempResponse.Configurator_Plus__c           = CurrentConfiguratorPlus.id ; 
                    TempResponse.Configurator_Plus_Question__c  = QuestionWrap.Qstn.id; 
                    TempResponse.Name__c                        = QuestionWrap.Qstn.Question_Name__c ; 
                    TempResponse.Proposal_Line_Item__c          = null;
                    TempResponse.Response__c                    = QuestionWrap.selected == true ? 'TRUE' : 'FALSE'; 
                    TempResponse.Response_Type__c               = 'Roadmap Features';
                    TempResponse.Question_ID__c                 = CurrentConfiguratorPlus.id +'-' +QuestionWrap.Qstn.id;
                FinalResponse.add(TempResponse);
            }
        }
        upsert  FinalResponse Question_ID__c ; 
        return (new pagereference('/'+CurrentConfiguratorPlus.id ));//Upon save return to the Detail page.
    }
    
    //Cancel the form  
    public pageReference cancelResponse(){
        return (new pagereference('/'+CurrentConfiguratorPlus.id ));
    } 
    
    //Wrapper class defination 
    public class QuestionNResponseWrapper
    {
        //Configurator Plus record
        public Configurator_Plus_Question__c Qstn{get; set;}
        public Boolean selected {get; set;} //Selected Roadmap Feature
        public QuestionNResponseWrapper(Configurator_Plus_Question__c Questions, boolean resposevalue)
        {
            Qstn = Questions;
            selected = resposevalue;
        }
    } 
}