/**  
   Class:  CPQ_AdvancedPackagingOptions_Controller2 
*-----------------------------------------------------------------------------------------------------------------------------------

  Author: Shivam Sharma 
          email : shivam.sharma@globalfoundries.com
  Description: This is the controller class associated with the "CPQAdvancedPackagingOptions2" Visualforce page,
               for capturing the Advanced packaging options for Configurator plus records 
                          Following sections will be presented in this page: 
*                                        1. Packaging Options 
*                                        2. Advanced Packaging Options
*                                        3. Stack Options Available 
*                         These Question labels will be brought from the Configurator Plus Questions table and their pickist values from the Configurator Plus Picklist table. 
*                         Saved in Configurator Plus resposes table.
  
  History:
    sShar        03202016    - code creation.
*/
public class CPQ_AdvancedPackagingOptions_Controller2 {

    public Apttus_Proposal__Proposal__c rec {get; set;}
    private Map<Id, Configurator_Plus_Response__c> responsesByQuestions;    
    public Map<Id, Question> mapOfQuestions {get; set;}
    public Map<Integer, List<String>> questionsByLevel {get; set;}
    public Map<Integer, List<String>> questionsForMetalStack {get; set;}
    public String metalStackValue {get; set;}
    public Boolean hasMetalOptions {get; set;}
    public Boolean hasPackagingOption {get; set;}
    public Boolean readOnlyModeEnabled {get; set;}
    private Boolean isSaved;
    public class Question {
        public String parentId {get; set;}
        public String criteria {get; set;}
        public String queId {get; set;}
        public String queName {get; set;}
        public Integer level {get; set;}
        public String dataType {get; set;}
        public String queType {get; set;}
        public String answer {get; set;}
        public Boolean isMandatory {get; set;}
        public String requiredIf {get; set;}
        public List<SelectOption> picklistValues {get; set;}
        public Map<Id, Configurator_Plus_Picklist_Value__c> mapPicklistValuesRecords{get; set;}
        public String errorMessage {get; set;}
        public Boolean isEnabled {get; set;}
    }
    public String purpose {get; set;} // Product OR MPW/ Test Vehicle - depends on the Device type of the configurator
    private Device__c device;
    /*
            * Method Name:     CPQ_AdvancedPackagingOptions_Controller
            * Return Type:     NA
            * Parameter  :     NA
            * Reason     :     this is the constructor
    */
    public CPQ_AdvancedPackagingOptions_Controller2(ApexPages.StandardController controller) {
        isSaved = false;
        rec = (Apttus_Proposal__Proposal__c)controller.getRecord();
        if(rec.Id != null){
            rec = [select Id, Name, APTPS_Metal_Options__c, Polymide_Opening__c ,Polyimide_Application_Location__c, Passivation_Nitride_Opening__c, Crackstop_Seal_Ring_Die_Seal__c, APTPS_Packaging_Option__c, Bump_for_FC__c, Bumping_for_FC__c, Device__c, Packaging_Disclaimer_Message__c  FROM Apttus_Proposal__Proposal__c where ID =:rec.Id ];
            if(String.isBlank(rec.Crackstop_Seal_Ring_Die_Seal__c)){
                rec.Crackstop_Seal_Ring_Die_Seal__c = '--None--';
            }
            if(rec.Device__c != null){
                device = [select Id, Tapeout_Type__c, Device_Purpose__c from Device__c where Id =:rec.Device__c].get(0);
                if(device.Tapeout_Type__c == 'Single Product' || device.Device_Purpose__c == 'Product'){
                    purpose = 'Product';
                }else{
                    purpose = 'MPW or Test Vehicle';
                }            
            }else{
                purpose = 'Device not selected for the Configurator Plus record.';
                rec.Packaging_Disclaimer_Message__c = purpose;
            }
        }
        mapOfQuestions = new Map<Id, Question>();
        questionsByLevel = new Map<Integer, List<String>>();
        questionsForMetalStack = new Map<Integer, List<String>>();
        hasMetalOptions = false;
        hasPackagingOption = false;
        readOnlyModeEnabled = false;
        String recordTypeOfConfigurator = rec.RecordTypeId;
        List<RecordType> recTypeList = [Select DeveloperName from RecordType where Id =: recordTypeOfConfigurator];
        if(recTypeList != null && recTypeList.size() != 0)
            readOnlyModeEnabled = recTypeList.get(0).DeveloperName.contains('_Read_Only');
            
        if(String.isBlank(rec.APTPS_Packaging_Option__c)){
            return;
        }
        if(String.isBlank(rec.APTPS_Metal_Options__c) || rec.APTPS_Metal_Options__c == 'Not Applicable'){
            metalStackValue = 'Not Defined';
        }else{
            metalStackValue = rec.APTPS_Metal_Options__c;
            hasMetalOptions = true;
        }
        Set<String> criteriaSet = new Set<String>();
        if(rec.APTPS_Packaging_Option__c == 'Flip Chip' || rec.APTPS_Packaging_Option__c == 'Wirebond'){
            hasPackagingOption = true;
            criteriaSet.add(rec.APTPS_Packaging_Option__c);
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Packaging Option value not acceptable. Acceptable values "Wirebond" and "Flip Chip".'));
        }   
        for(Integer levelCounter = 1; levelCounter <= 7; levelCounter++){
        List<String> tempList = new List<String>();
        List<String> tempMetalList = new List<String>();
            for(Configurator_Plus_Question__c cpQue : [SELECT Name
                                                              , Question_Name__c
                                                              , Criteria__c
                                                              , Required__c
                                                              , Required_if__c
                                                              , Data_Type__c
                                                              , Level__c
                                                              , Parent_Question__c
                                                              , Question_Type__c
                                                      FROM   Configurator_Plus_Question__c 
                                                      WHERE  Active__c = true
                                                             AND (((Parent_Question__c IN : mapOfQuestions.keySet()) OR (Level__c = '1')) 
                                                             AND Level__c = : (levelCounter+'') AND Geometry__c = '0.014UM')
                                                        ORDER BY Sequence__c
                                                      ]){
                for(String criteria1 : cpQue.Criteria__c.split(',')){
                    if(criteriaSet.contains(criteria1)){
                
                        Question que = new Question();
                        que.queId = cpQue.Id;
                        que.queName = cpQue.Question_Name__c;
                        que.criteria = cpQue.Criteria__c;
                        que.isMandatory = cpQue.Required__c;
                        que.requiredIf = cpQue.Required_if__c;
                        que.dataType = cpQue.Data_Type__c;
                        que.level = Integer.valueOf(cpQue.Level__c);
                        que.parentId = cpQue.Parent_Question__c;
                        que.queType = cpQue.Question_Type__c;
                        que.answer = '';
                        if(levelCounter == 1)
                            que.isEnabled = true;
                        else
                            que.isEnabled = false;
                      mapOfQuestions.put(cpQue.Id, que);
                      if(que.queType == 'Packaging Options - Metal Stacks')
                          tempMetalList.add(que.queId);
                      else
                        tempList.add(que.queId);
                      break;
                    }
                }
            }
            
            for(Configurator_Plus_Picklist_Value__c val : [SELECT Configurator_Plus_Question__c, Picklist_Name__c, Contact_GF__c, Contact_OSAT__c, Criteria__c, Disclaimer__c
                                                           FROM Configurator_Plus_Picklist_Value__c 
                                                           WHERE Configurator_Plus_Question__c IN : mapOfQuestions.keySet()
                                                                 AND Configurator_Plus_Question__r.Level__c =: (levelCounter+'')
                                                           ]){
                Question que = mapOfQuestions.get(val.Configurator_Plus_Question__c);
                if(que.dataType.equals('Picklist')){
                    if(que.picklistValues == null){ 
                        que.picklistValues = new List<SelectOption>{new SelectOption('','---Select---',false)};
                        que.mapPicklistValuesRecords = new Map<Id, Configurator_Plus_Picklist_Value__c>();
                    }
                    que.picklistValues.add(new SelectOption(val.Picklist_Name__c, val.Picklist_Name__c, false));
                    que.mapPicklistValuesRecords.put(val.Id, val);
                mapOfQuestions.put(val.Configurator_Plus_Question__c, que);
                }
                criteriaSet.add(val.Picklist_Name__c);
            }
            
            questionsByLevel.put(levelCounter, tempList);
            questionsForMetalStack.put(levelCounter, tempMetalList);
        }
        fetchPreviousState();
        getreEvaluatePicklistValuesOfChildQuestions();
    }
    /*
            * Method Name:     getreEvaluatePicklistValuesOfChildQuestions
            * Scope      :     public
            * Return Type:     void
            * Parameter  :     NA
            * Reason     :     this method is called on the "onChange" event on the picklist values and from the constructor to initialize the picklist values
                               it reinitializes all the picklist values once any picklist value is changed
                               Level by level it re evaluates the questions' characteristics(eg. enabled or required etc.) and their available picklist values depending upon the responses captured at their above levels  
    */
    public void getreEvaluatePicklistValuesOfChildQuestions(){
        for(Integer level = 0; level<=7; level++){        
            for(Id queId : mapOfQuestions.keySet()){
                
                Question que = mapOfQuestions.get(queId);
                
                if(que.level != level){    continue; }
                
                //que.errorMessage = '';
                Question parent = null;
                
                if(que.level == 1 && que.queType == 'Packaging Options - Metal Stacks'){
                    Boolean oldAnswerIsNotAcceptable = true;
                    List<SelectOption> temp = new List<SelectOption>{new SelectOption('','---Select---',false)};
                    if(que.mapPicklistValuesRecords != null)
                    for(Id plValueId : que.mapPicklistValuesRecords.keySet()){
                            Configurator_Plus_Picklist_Value__c cppv = que.mapPicklistValuesRecords.get(plValueId);
                            if(cppv.Criteria__c.contains(metalStackValue)){
                                if(cppv.Picklist_Name__c == que.answer){
                                    oldAnswerIsNotAcceptable = false;
                                }
                                temp.add(new SelectOption(cppv.Picklist_Name__c, cppv.Picklist_Name__c, false));
                            }
                        }
                    que.picklistValues = temp;
                    if(oldAnswerIsNotAcceptable){ que.answer = '';} 
                }
                if(que.level > 1 && mapOfQuestions.containsKey(que.parentId)){
                    parent = mapOfQuestions.get(que.parentId); 
                    Boolean toIncludeQuestion = false;
                    for(String criterion : que.criteria.split(', ')){ // To remove the "Round" and "Non-Round" conflict [issue : Round  makes the Non-Round also get enabled]
                        if(criterion.equals(parent.answer)){
                            toIncludeQuestion = true;
                            break;
                        }
                    }
                    if(!String.isBlank(parent.answer) && toIncludeQuestion && parent.isEnabled){
                        
                        //Start: For questions having multi level criteria dependencies
                            if(!String.isBlank(que.requiredIf) && !que.criteria.contains(que.requiredIf)){
                                if(parent.ParentId != null && mapOfQuestions.containsKey(parent.ParentId)){
                                    String grandParentAnswer = mapOfQuestions.get(parent.parentId).answer;
                                    if(!que.requiredIf.contains(grandParentAnswer)){    
                                        //exclude its picklist values
                                        que.picklistValues = new List<SelectOption>{new SelectOption('','---Select---',false)};
                                        que.answer = '';
                                        que.isEnabled = false;
                                        mapOfQuestions.put(queId, que);
                                        continue;
                                    }    
                                }
                            }
                        //End : For questions having multi level criteria dependencies
                        
                        if(que.dataType == 'Picklist'){
                            //Re filterring the picklist values
                            Boolean oldAnswerIsNotAcceptable = true;
                            List<SelectOption> temp = new List<SelectOption>{new SelectOption('','---Select---',false)};
                            if(que.mapPicklistValuesRecords != null)
                                for(Id plValueId : que.mapPicklistValuesRecords.keySet()){
                                    Configurator_Plus_Picklist_Value__c cppv = que.mapPicklistValuesRecords.get(plValueId);
                                    if((que.queType == 'Packaging Options - Metal Stacks' && cppv.Criteria__c.contains(metalStackValue)) 
                                    || (que.queType != 'Packaging Options - Metal Stacks' && cppv.Criteria__c.contains(parent.answer))){
                                        temp.add(new SelectOption(cppv.Picklist_Name__c, cppv.Picklist_Name__c, false));
                                        if(cppv.Picklist_Name__c == que.answer){
                                            oldAnswerIsNotAcceptable = false;
                                        }
                                    }
                                }
                            que.picklistValues = temp;
                            if(oldAnswerIsNotAcceptable){ que.answer = '';} 
                        }
                        que.isEnabled = true;
                        mapOfQuestions.put(queId, que);
                            
                    }else{
                        que.picklistValues = new List<SelectOption>{new SelectOption('','---Select---',false)};
                        que.answer = '';
                        que.isEnabled = false;
                        mapOfQuestions.put(queId, que);
                    }
                }
            }
        }
        checkContactGF();
        putDisclaimerMessage();
    }
    /*
            * Method Name:     saveAction
            * Scope      :     public
            * Return Type:     PageReference
            * Parameter  :     NA
            * Reason     :     this method is called on the click event on the Save button
                               it validates the captured responses and
                               a. if it contains error
                                  then displays the error messages next to the questions
                               b. else if it is error free
                                  then saves the new responses and deletes the old responses if any.
                                  And redirects to the Configurator Plus detail page  
    */
    public PageReference saveAction(){
        List<Configurator_Plus_Response__c> lstOfResponsesCaptured = new List<Configurator_Plus_Response__c>();
        List<Configurator_Plus_Response__c> lstOfResponsesToBeDeleted = new List<Configurator_Plus_Response__c>();
        List<Configurator_Plus_Response__c> lstOfResponsesToBeUpserted = new List<Configurator_Plus_Response__c>();
        Boolean hasError = false;
        for(Id queId : mapOfQuestions.keySet()){
            Question que = mapOfQuestions.get(queId);
            que.errorMessage = '';
            
            //If an enabled mandatory field is left blank then don't allow saving
            if(que.isEnabled && que.isMandatory && String.isBlank(que.answer)){
                //If there are no set of values available for selection in a mandatory picklist then don't interupt in saving the others' values
                if(que.dataType.equals('Picklist') && (que.picklistValues == null || que.picklistValues.size() == 1)){continue;}
                //For optionally mandatory questions
                if(que.isMandatory && !String.isBlank(que.requiredIf)){
                    if(que.ParentId != null && mapOfQuestions.containsKey(que.ParentId)){
                        String parentAnswer = mapOfQuestions.get(que.parentId).answer;
                        if(parentAnswer != null && !que.requiredIf.contains(parentAnswer))
                            continue;
                    }
                }
                que.errorMessage = 'Field is required';
                hasError = true;
            }
            mapOfQuestions.put(queId, que);
        }
        if(hasError){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Required fields left blank '));
            return null;
        }else{
            //Deleting responses of unnecessary questions if any
            if(responsesToDelete.size() > 0){
                try{
                    delete responsesToDelete;
                    responsesToDelete = new List<Configurator_Plus_Response__c >();
                }catch(Exception ex){
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error occured while trying to delete the old entries.'));
                }
            }    
            for(Id queId : mapOfQuestions.keySet()){    
                Question que = mapOfQuestions.get(queId);
                Configurator_Plus_Response__c response = new Configurator_Plus_Response__c();
                response.Configurator_Plus__c = rec.Id;
                response.Configurator_Plus_Question__c = queId; //response.Question_ID__c = queId;    //response.Proposal_Line_Item__c = 
                response.Response__c = que.answer;
                response.Response_Type__c = que.queType; //'Packaging Options';
                response.Error_Message__c = que.errorMessage;
                lstOfResponsesCaptured.add(response);
            }
            
            if(lstOfResponsesCaptured.size() > 0){
                for(Configurator_Plus_Response__c resp : lstOfResponsesCaptured){
                    if(responsesByQuestions.containsKey(resp.Configurator_Plus_Question__c )){
                        if(!String.isBlank(resp.Response__c) && responsesByQuestions.get(resp.Configurator_Plus_Question__c ).Response__c != resp.Response__c){
                           resp.Id = responsesByQuestions.get(resp.Configurator_Plus_Question__c ).Id;
                           // Updating the existing responses
                           lstOfResponsesToBeUpserted.add(resp);
                        }else if(String.isBlank(resp.Response__c)){
                           // Deleting the unchosen selections
                           lstOfResponsesToBeDeleted.add(responsesByQuestions.get(resp.Configurator_Plus_Question__c));    
                        }
                    }else{
                        // Inserting the newly captured responses
                        if(!String.isBlank(resp.Response__c))
                            lstOfResponsesToBeUpserted.add(resp);
                    }
                }
                
                try{
                    //Start :Adding Responses for Polyimide Application Location and Disclaimer Message
                    if(!isSaved)
                    for(Configurator_Plus_Question__c cpQue : [SELECT Question_Name__c FROM   Configurator_Plus_Question__c WHERE  Active__c = true AND Level__c = '0' AND Geometry__c = '0.014UM' AND Question_Type__c = 'Packaging Options - Field Type' AND Unique_Identifier__c <> null Order By Sequence__c]){
                        Configurator_Plus_Response__c response = new Configurator_Plus_Response__c(Configurator_Plus__c = rec.Id, Configurator_Plus_Question__c = cpQue.Id);
                        if(cpQue.Question_Name__c == 'Polyimide Application Location'){ response.Response__c = rec.Polyimide_Application_Location__c;}
                        if(cpQue.Question_Name__c == 'Packaging Disclaimer Message'){ response.Response__c = rec.Packaging_Disclaimer_Message__c ;}
                        lstOfResponsesToBeUpserted.add(response);
                    }
                    //End :Adding Responses for Polyimide Application Location and Disclaimer Message
                    upsert lstOfResponsesToBeUpserted;
                    lstOfResponsesToBeUpserted = new List<Configurator_Plus_Response__c >();
                    isSaved = true;
                }
                catch(Exception ex){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception encounterred in upsert operation '+ex.getMessage()));
                    return null;
                }
                if(lstOfResponsesToBeDeleted.size()>0){
                    try{
                        delete lstOfResponsesToBeDeleted;
                        lstOfResponsesToBeDeleted = new List<Configurator_Plus_Response__c >();
                    }
                    catch(Exception ex){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception encounterred in deletion operation '+ex.getMessage()));
                        return null;
                    }
                }
            }
            PageReference pf = new PageReference('/'+rec.Id);
        }
        try{
            update rec;
        }
        catch(Exception ex){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Proposal Update failed '+ex.getMessage()));
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Changes saved successfully.'));
    return null;
    }
    /*
            * Method Name:     fetchPreviousState
            * Scope      :     private
            * Return Type:     void
            * Parameter  :     NA
            * Reason     :     this method is called from the constructor and it resumes the Advanced Packaging Options selected by the user
                               it fetches the previously captured responses
    */
    private List<Configurator_Plus_Response__c> responsesToDelete;
    private void fetchPreviousState(){
        responsesToDelete = new List<Configurator_Plus_Response__c>();
        responsesByQuestions = new Map<Id, Configurator_Plus_Response__c>();
        for(Configurator_Plus_Response__c res : [Select Id, Response__c, Configurator_Plus_Question__c, Error_Message__c from Configurator_Plus_Response__c where Configurator_Plus__c =:rec.Id AND Configurator_Plus_Question__r.Unique_Identifier__c <> null]){ // AND Configurator_Plus_Question__r.Unique_Identifier__c LIKE '% : %']){
            if(responsesByQuestions.containsKey(res.Configurator_Plus_Question__c)){
                responsesToDelete.add(res);
            }else{ 
                responsesByQuestions.put(res.Configurator_Plus_Question__c , res);
            }
        }
        for(Id queId : responsesByQuestions.keySet()){
            if(mapOfQuestions.containsKey(queId)){
                Question que = mapOfQuestions.get(queId);
                que.answer = responsesByQuestions.get(queId).Response__c;
                que.errorMessage = responsesByQuestions.get(queId).Error_Message__c;
            }else{
                responsesToDelete.add(responsesByQuestions.get(queId));
            }
        }
    }
    /*
            * Method Name:     checkContactGF
            * Scope      :     private (being used internally to make the code reusable)
            * Return Type:     Boolean
            * Parameter  :     NA
            * Reason     :     this method tells whether GF needs to be contacted for the captured selection
    */
    private Boolean checkContactGF(){
        Boolean contactGF = false;
        for(Id queId : mapOfQuestions.keySet()){
            Question que = mapOfQuestions.get(queId);
            que.errorMessage = '';
            if(que.mapPicklistValuesRecords != null){
                for(Id picklistId : que.mapPicklistValuesRecords.keySet()){
                    Configurator_Plus_Picklist_Value__c tempPLValue = que.mapPicklistValuesRecords.get(picklistId);
                    if((tempPLValue.Picklist_Name__c == que.answer) && (tempPLValue.Contact_GF__c || tempPLValue.Contact_OSAT__c)){
                        que.errorMessage = 'Contact GF for this selection';
                        contactGF = true;
                    }
                }
                mapOfQuestions.put(queId, que);
            }    
        }
        return contactGF;
    }
    public void putDisclaimerMessage(){
        rec.Packaging_Disclaimer_Message__c = '';
        if(rec.Crackstop_Seal_Ring_Die_Seal__c == 'Other')
            rec.Packaging_Disclaimer_Message__c = ' Contact GF for "Crackstop Type" selection <br/>' ;
        if(rec.Device__c == null)
            rec.Packaging_Disclaimer_Message__c += 'Device is not selected for the Configurator Plus record.<br/>';
        else{
            if((rec.APTPS_Packaging_Option__c == 'Wirebond') && (device.Tapeout_Type__c == 'Single Product' || device.Device_Purpose__c == 'Product')){
                rec.Packaging_Disclaimer_Message__c += 'Wirebond is allowed only for MPW or Test Vehicle devices. <br/>';
            }
        }    
        for(Id queId : mapOfQuestions.keySet()){
            Question que = mapOfQuestions.get(queId);
            if(que.mapPicklistValuesRecords != null){
                for(Id picklistId : que.mapPicklistValuesRecords.keySet()){
                    Configurator_Plus_Picklist_Value__c tempPLValue = que.mapPicklistValuesRecords.get(picklistId);
                    if(tempPLValue.Picklist_Name__c == que.answer){
                        if(!String.isBlank(tempPLValue.Disclaimer__c)){
                            rec.Packaging_Disclaimer_Message__c += tempPLValue.Disclaimer__c + ' for "'+mapOfQuestions.get(queId).queName + '" selection.<br/>';
                        }
                    }
                }
            }    
        }
        if(String.isBlank(rec.Packaging_Disclaimer_Message__c))
            rec.Packaging_Disclaimer_Message__c = 'Not Applicable';
    }
}