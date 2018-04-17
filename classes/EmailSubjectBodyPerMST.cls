/**
* This is the Email Configuration utility class for dynamically replacing merge fiels(Subject and Content) for per MST Email requirement
**/
public class EmailSubjectBodyPerMST {
    
    private EmailTemplate emailTemplate; 
    private Set<String> possibleCommaSepValues;
    private String finalToBeQueriedField = '';
    private Map<String, List<String>> allRelationShipFlowMap = new Map<String, List<String>>();
    private Set<String> standAloneObjectList;
    private Set<String> standAloneObjectFieldName;
    private Set<String> relatedTECNNumber;
    private List<TECN__c> allTECNValues;
    
    /**
    * The getDynamicQueries method will be used to generate the dynamic queries(One for Layer Chip Association and Another for TECN) after parsing the template 
    *
    * @method name: getDynamicQuery
    * @param:   String templateName
    * @return : List<String>
    */
    public List<String> getDynamicQueries(String templateName){
        List<String> returnQueries = new List<String>();
        try {
            if(string.isBlank(templateName)) {
                return new List<String>();
            }
            String listOfFields = parseEntireContent(templateName);
            String queryToBeExecuted = 'SELECT '+ listOfFields +' FROM MRS_Layer_Chip_Association__c';
            String tecnQuery = getDynamicQueryForTECN();
            
            returnQueries.add(queryToBeExecuted);
            returnQueries.add(tecnQuery);
        }
        catch(Exception exp){
            EmailHandlerUtility.saveEmailExceptionErrorLog(exp, '','' ,'EmailSubjectBodyPerMST','getDynamicQueries');
        }
        return returnQueries;
    }
    
    /**
    * The replaceSubjectAndContent method will be used to replace the subject anc content of the template with the queries MRS_Layer_Chip_Association__c 
    * and TECN data. The return value will contains a map with the same ID and a list containing replaced subject as the first element and replaced content 
    * as the second element.

    * @method name: replaceSubjectAndContent
    * @param:   Map<Integer, List<MRS_Layer_Chip_Association__c>> queriedLayerChipAssociationData, 
    *           Map<Integer,List<TECN__c>> queriedTECNData,
    *           Map<String,String> nameValuePair
    * @return : Map<Integer, List<String>>
    */
    public Map<Integer, List<String>> replaceSubjectAndContent(Map<Integer, List<MRS_Layer_Chip_Association__c>> queriedLayerChipAssociationData, 
                                                               Map<Integer,List<TECN__c>> queriedTECNData,
                                                               Map<String,String> nameValuePair){
        Map<Integer, List<String>> returnMap = new Map<Integer, List<String>>();
        try {
            for(Integer key : queriedLayerChipAssociationData.keySet()){
                List<String> replacedContent = replaceTemplate(queriedLayerChipAssociationData.get(key), queriedTECNData.get(key),nameValuePair);
                returnMap.put(key, replacedContent);
            }
        }
        catch(Exception exp){
            EmailHandlerUtility.saveEmailExceptionErrorLog(exp, '','' ,'EmailSubjectBodyPerMST','replaceSubjectAndContent');
        }
        return returnMap;
    }
    
    /**
    * The getDynamicQueryForTECN method will be used to generate the dynamic query for TECN after parsing the template 
    *
    * @method name: getDynamicQueryForTECN
    * @param:   
    * @return : String
    */
    private String getDynamicQueryForTECN(){
        List<String> uniqueList = new List<String>();
        String tecnQuery;
        try {
            //Add requied field for TECN
            standAloneObjectFieldName.add('Related_TECN_No__c');
            standAloneObjectFieldName.add('Originator__c');
            
            uniqueList.addAll(standAloneObjectFieldName);
            
            tecnQuery = 'Select ' + String.join(uniqueList, ',') + ' from TECN__c';
        }
        catch(Exception exp){
            EmailHandlerUtility.saveEmailExceptionErrorLog(exp, '','' ,'EmailSubjectBodyPerMST','getDynamicQueryForTECN');
        }
        return tecnQuery;
    }
    
    /**
    * The replaceTemplate method will be used to call methods for replacing subject and content and prepare the return value 
    *
    * @method name: replaceTemplate
    * @param:   List<MRS_Layer_Chip_Association__c> mrsLayerChipAssociationListQueried, List<TECN__c> tecnQueried, Map<String,String> nameValuePair
    * @return : List<String>
    */
    private List<String> replaceTemplate(List<MRS_Layer_Chip_Association__c> mrsLayerChipAssociationListQueried, List<TECN__c> tecnQueried, Map<String,String> nameValuePair){
        List<String> replacedContent = new List<String>();
        String replacedSubject;
        String replacedBody;
        //Replace the subject and content
        try {
            replacedSubject = replaceContent(mrsLayerChipAssociationListQueried,tecnQueried,allRelationShipFlowMap,emailTemplate.Subject,nameValuePair);
            replacedBody = replaceContent(mrsLayerChipAssociationListQueried,tecnQueried,allRelationShipFlowMap,emailTemplate.HtmlValue, nameValuePair);
            
            //Prepare the return value
            replacedContent.add(replacedSubject);
            replacedContent.add(replacedBody);
        }
        catch(Exception exp){
            EmailHandlerUtility.saveEmailExceptionErrorLog(exp, '','' ,'EmailSubjectBodyPerMST','replaceTemplate');
        }
        return replacedContent;
    }
    
    /**
    * The replaceContent method will be used to replace the HTML content.
    * This method is responsible for dynamically replacing all the merge fields present in the email 
    * template subject/body with the actual values received from the query
    *
    * @method name: replaceContent
    * @param:   List<MRS_Layer_Chip_Association__c> mrsLayerChipAssociationListQueried, List<TECN__c> tecnQueried,Map<String, List<String>> allRelationShipFlowMap, String content, Map<String,String> nameValuePair
    * @return : String
    */
    private String replaceContent(List<MRS_Layer_Chip_Association__c> mrsLayerChipAssociationListQueried, List<TECN__c> tecnQueried,Map<String, List<String>> allRelationShipFlowMap, String content, Map<String,String> nameValuePair){
        String tempContent = content;
        //Replace name value pairs if any
        try {
            if(nameValuePair != null){
                tempContent = replaceNameValuePairs(tempContent,nameValuePair);
            }  
            
            if((content.indexOf('{!'))!=-1){
                do{
                    String objectAndFieldName = content.substring(content.indexOf('{!')+2,content.indexOf('}'));
                    String objectName = objectAndFieldName.substringBefore('.');
                    String fieldName = objectAndFieldName.substringAfter('.');
                    String values = '';
                    Set<Id> LayerAssociationIds = new Set<Id>();
                    //if standalone field needs replacement
                    if(standAloneObjectList.contains(objectName)){
                        //Get TECN Values
                        Set<String> allUniqueValues = new Set<String>();
                        for(TECN__c aTecnValue: tecnQueried){
                            allUniqueValues.add(String.valueOf(aTecnValue.get(fieldName)));
                        }
                        List<String> tempList = new List<String>();
                        tempList.addAll(allUniqueValues);
                        String valuesToBeReplacedWith = String.join(tempList, ',');
                        String replacedContentWithValues = tempContent.replace(String.valueOf('{!'+objectAndFieldName+'}'),valuesToBeReplacedWith);
                        tempContent = replacedContentWithValues;
                    }else{
                        //Check whether comma separated values are required
                        if(possibleCommaSepValues.contains(objectName)){
                            if(allRelationShipFlowMap.get(objectName).size() == 0){
                                List<String> allPossibleValues = new List<String>();
                                for(MRS_Layer_Chip_Association__c m : mrsLayerChipAssociationListQueried){
                                    if(m.get(fieldName) != null){
                                        allPossibleValues.add(String.valueOf(m.get(fieldName)));
                                    }
                                }
                            
                                //Remove duplicate entries from the List
                                if(allPossibleValues.size() > 0){
                                    allPossibleValues = removeDuplicateCommaSeparatedValues(allPossibleValues);
                                    values = String.join(allPossibleValues, ',');
                                    String replacedContentWithValues = tempContent.replace(String.valueOf('{!'+objectAndFieldName+'}'),values);
                                    tempContent = replacedContentWithValues;
                                }
                                else {
                                    tempContent = tempContent.replace(String.valueOf('{!'+objectAndFieldName+'}'),'');
                                }
                            }else if(allRelationShipFlowMap.get(objectName).size() == 1){
                                List<String> relationShipFlows = allRelationShipFlowMap.get(objectName);
                                List<String> allPossibleValues = new List<String>();
                                for(MRS_Layer_Chip_Association__c m : mrsLayerChipAssociationListQueried){
                                    if(m.getSObject(relationShipFlows.get(0)) != null){
                                        if(m.getSObject(relationShipFlows.get(0)).get(fieldName) != null){
                                            allPossibleValues.add(String.valueOf(m.getSObject(relationShipFlows.get(0)).get(fieldName)));
                                        }
                                    }
                                }
                                //Remove duplicate entries from the List
                                if(allPossibleValues.size() > 0){
                                    allPossibleValues = removeDuplicateCommaSeparatedValues(allPossibleValues);
                                    values = String.join(allPossibleValues, ',');
                                    String replacedContentWithValues = tempContent.replace(String.valueOf('{!'+objectAndFieldName+'}'),values);
                                    tempContent = replacedContentWithValues;
                                }
                                else {
                                    tempContent = tempContent.replace(String.valueOf('{!'+objectAndFieldName+'}'),'');
                                }
                            }else if(allRelationShipFlowMap.get(objectName).size()==2){
                                List<String> relationShipFlows = allRelationShipFlowMap.get(objectName);
                                List<String> allPossibleValues = new List<String>();
                                for(MRS_Layer_Chip_Association__c m : mrsLayerChipAssociationListQueried){
                                    if(m.getSObject(relationShipFlows.get(0)) != null){
                                        if(m.getSObject(relationShipFlows.get(0)).getSObject(relationShipFlows.get(1)) != null){
                                            if(m.getSObject(relationShipFlows.get(0)).getSObject(relationShipFlows.get(1)).get(fieldName) != null){
                                                allPossibleValues.add(String.valueOf(m.getSObject(relationShipFlows.get(0)).getSObject(relationShipFlows.get(1)).get(fieldName)));
                                            }
                                        }
                                    }
                                }
                                //Remove duplicate entries from the List
                                if(allPossibleValues.size() > 0){
                                    allPossibleValues = removeDuplicateCommaSeparatedValues(allPossibleValues);
                                    values = String.join(allPossibleValues, ',');
                                    String replacedContentWithValues = tempContent.replace(String.valueOf('{!'+objectAndFieldName+'}'),values);
                                    tempContent = replacedContentWithValues;
                                }
                                else {
                                    tempContent = tempContent.replace(String.valueOf('{!'+objectAndFieldName+'}'),'');
                                }
                            }
                        }else{
                            if(allRelationShipFlowMap.get(objectName).size()==0){
                                if(mrsLayerChipAssociationListQueried.get(0).get(fieldName) != null){
                                    values = String.valueOf(mrsLayerChipAssociationListQueried.get(0).get(fieldName));
                                    String replacedContentWithValues = tempContent.replace(String.valueOf('{!'+objectAndFieldName+'}'),values);
                                    tempContent = replacedContentWithValues;
                                }
                            }else if(allRelationShipFlowMap.get(objectName).size()==1){
                                List<String> relationShipFlows = allRelationShipFlowMap.get(objectName);
                                if(mrsLayerChipAssociationListQueried.get(0).getSObject(relationShipFlows.get(0)) != null){
                                    if(mrsLayerChipAssociationListQueried.get(0).getSObject(relationShipFlows.get(0)).get(fieldName) != null){
                                        values = string.valueOf(mrsLayerChipAssociationListQueried.get(0).getSObject(relationShipFlows.get(0)).get(fieldName));
                                        String replacedContentWithValues = tempContent.replace(String.valueOf('{!'+objectAndFieldName+'}'),values);
                                        tempContent = replacedContentWithValues;
                                    }
                                }
                            }else if(allRelationShipFlowMap.get(objectName).size()==2){
                                List<String> relationShipFlows = allRelationShipFlowMap.get(objectName);
                                if(mrsLayerChipAssociationListQueried.get(0).getSObject(relationShipFlows.get(0)) != null){
                                    if(mrsLayerChipAssociationListQueried.get(0).getSObject(relationShipFlows.get(0)).getSObject(relationShipFlows.get(1)) != null){
                                        if(mrsLayerChipAssociationListQueried.get(0).getSObject(relationShipFlows.get(0)).getSObject(relationShipFlows.get(1)).get(fieldName) != null){
                                            values = String.valueOf(mrsLayerChipAssociationListQueried.get(0).getSObject(relationShipFlows.get(0)).getSObject(relationShipFlows.get(1)).get(fieldName));
                                            String replacedContentWithValues = tempContent.replace(String.valueOf('{!'+objectAndFieldName+'}'),values);
                                            tempContent = replacedContentWithValues;
                                        }
                                    }
                                }
                            }
                            if(tempContent.contains('{!'+objectAndFieldName+'}')){
                                tempContent = tempContent.replace(String.valueOf('{!'+objectAndFieldName+'}'),'');
                            }
                            /*
                            else if(allRelationShipFlowMap.get(objectName).size()==3){
                                List<String> relationShipFlows = allRelationShipFlowMap.get(objectName);
                                values = String.valueOf(mrsLayerChipAssociationListQueried.get(0).getSObject(relationShipFlows.get(0)).getSObject(relationShipFlows.get(1)).getSObject(relationShipFlows.get(2)).get(fieldName));
                                String replacedContentWithValues = tempContent.replace(String.valueOf('{!'+objectAndFieldName+'}'),values);
                                tempContent = replacedContentWithValues;
                            }
                            */
                        }
                    }
                    string temp = content;
                    content = temp.substring(temp.indexOf('}')+1);
                }while(content.indexof('{!')!=-1);
            }
            
            //Replace Links
            tempContent = replaceLinks(tempContent);
        } 
        catch(Exception exp){
            EmailHandlerUtility.saveEmailExceptionErrorLog(exp, '','' ,'EmailSubjectBodyPerMST','replaceContent');
        }      
        return tempContent;
    }
    
    /**
    * The parseEntireContent method is responsible to identify all the merge fields present in the template 
    *
    * @method name: parseEntireContent
    * @param:   String templateName
    * @return : String
    */
    private String parseEntireContent(String templateName){
        //Fetch the email template if it is an active email template
        try {
            emailTemplate = [SELECT Name,Body,HtmlValue,Subject FROM EmailTemplate 
                                           WHERE DeveloperName = :templateName ];
            
            //Fetch the properties from the email template
            String subject = emailTemplate.Subject;
            String body = emailTemplate.HtmlValue;
            String mailbody = emailTemplate.HtmlValue;
            String finalMailBody = emailTemplate.HtmlValue;
            String mailBodyRep = '';
            String fieldName;
            
            Set<String> allUniqueFields = new Set<String>();
            Map<String, List<String>> allReplacedValuesMap = new Map<String, List<String>>();
            
            //All possible comma separated values
            possibleCommaSepValues = new Set<String>();
            possibleCommaSepValues.add('MRS_Layer_Association__c');
            possibleCommaSepValues.add('MRS_Layer_Chip_Association__c');
            possibleCommaSepValues.add('MRS__c');
            possibleCommaSepValues.add('PTRF__c');
            possibleCommaSepValues.add('MRS_Chip_Details__c');
            
            //All possible standard field
            standAloneObjectList = new Set<String>();
            standAloneObjectList.add('TECN__c');
            
            finalToBeQueriedField = parseSubject(subject,finalToBeQueriedField, allRelationShipFlowMap);
            finalToBeQueriedField = parseBody(body,finalToBeQueriedField, allRelationShipFlowMap);
            
            List<String> fields = finalToBeQueriedField.split(',');
            allUniqueFields.addAll(fields);
            allUniqueFields.add('Customer_Name__c');
            allUniqueFields.add('PTRF__r.MaskSetTitle__c');
            allUniqueFields.add('Layer__c');
            allUniqueFields.add('Layer__r.tech_geo_int__c');
            allUniqueFields.add('Layer__r.LogicalOperation__c');
            allUniqueFields.add('PTRF__c');
            allUniqueFields.add('PTRF__r.Submitter__c');
            allUniqueFields.add('PTRF__r.Submitter__r.isActive');
            allUniqueFields.add('PTRF__r.Submitter__r.Portal_Email__c');
            allUniqueFields.add('PTRF__r.Fab__c');
            allUniqueFields.add('PTRF__r.Customer__c');
            
            if(isThereAnyDuplicates(allUniqueFields,fields)){
                finalToBeQueriedField = removeDuplicateEntriesIfAny(finalToBeQueriedField,allUniqueFields);
            }            
        }
        catch(Exception exp){
            EmailHandlerUtility.saveEmailExceptionErrorLog(exp, '','' ,'EmailSubjectBodyPerMST','parseEntireContent');
        }    
        return finalToBeQueriedField;
    }
    
    /**
    * The isThereAnyStandAloneObject method is responsible to identify whether there is any standalone object present in the email template body 
    *
    * @method name: isThereAnyStandAloneObject
    * @param:   void
    * @return : Boolean
    */
    private Boolean isThereAnyStandAloneObject(){
        return (standAloneObjectFieldName.size() != 0);
    }
        
    /**
    * The replaceLinks method will replace all links present in the email template
    *
    * @method name: replaceLink
    * @param:   String mailbodyRep
    * @return : String
    */
    private String replaceLinks(String mailbodyRep){
        try {
            String linkName;
            String linkTag;
            String changedLinkName;
            
            List<String> urlList = new List<String>();
            String parameters;
            if(mailbodyRep.indexOf('[?') != -1){
                System.debug('INSRT HERE');
                Map<String,Swift_Email_Template_Links__c> linkMap = Swift_Email_Template_Links__c.getAll();
                do{
                    changedLinkName = '';
                    linkName = mailbodyRep.substring(mailbodyRep.indexOf('[?')+2,mailbodyRep.indexOf('?]'));
                    System.debug('linkName:::'+linkName);
                    System.debug('linkName.contains()::::'+linkName.contains('|'));
                    
                    if(linkName.contains('|')){
                        urlList = linkName.split('[|]');
                        System.debug('urlList:::'+urlList);
                        if(urlList[0].contains(':')){
                            linkTag = urlList[0].substringAfter(':');
                            if(urlList[1].contains('PARAM[')){
                                parameters = urlList[1].substring(urlList[1].indexOf('PARAM[')+6,urlList[1].indexOf(']'));
                                if(linkMap.containsKey(linkTag)){
                                    changedLinkName = '<a href=\"'+linkMap.get(linkTag).URL__c+'?'+parameters+'\">'+linkMap.get(linkTag).Label__c+'</a>';
                                }
                                mailbodyRep = mailbodyRep.replace('[?'+linkName+'?]',changedLinkName);
                            }
                            else {
                                if(linkMap.containsKey(linkTag)){
                                    changedLinkName = '<a href=\"'+linkMap.get(linkTag).URL__c+'\">'+linkMap.get(linkTag).Label__c+'</a>';
                                }
                                mailbodyRep = mailbodyRep.replace('[?'+linkName+'?]',changedLinkName);
                            }
                        }
                        else {
                            mailbodyRep = mailbodyRep.replace('[?'+linkName+'?]','');
                        }
                    }
                    else {
                        if(linkName.contains(':')){
                            linkTag = linkName.substringAfter(':');
                            System.debug('linkTag:::'+linkTag);
                            if(linkMap.containsKey(linkTag)){
                                changedLinkName = '<a href=\"'+linkMap.get(linkTag).URL__c+'\">'+linkMap.get(linkTag).Label__c+'</a>';
                            }
                            System.debug('changedLinkName:::'+changedLinkName);
                            mailbodyRep = mailbodyRep.replace('[?'+linkName+'?]',changedLinkName);
                        }
                        else {
                            mailbodyRep = mailbodyRep.replace('[?'+linkName+'?]','');
                        }
                    }
                }while(mailbodyRep.indexOf('[?') != -1);
            }
        }
        catch(Exception exp){
            EmailHandlerUtility.saveEmailExceptionErrorLog(exp, '','' ,'EmailSubjectBodyPerMST','replaceLinks');
        }
        return mailbodyRep;
    }
    
    /**
    * The replaceNameValuePairs method will be replace all name value pairs present in the email template
    *
    * @method name: replaceNameValuePairs
    * @param:   String mailbodyRep, Map<String,String> nameValuePair
    * @return : String
    */
    private String replaceNameValuePairs(String mailbodyRep, Map<String,String> nameValuePair){
        try {
            if(nameValuePair != null){
                /*
                for(String name : nameValuePair.keySet()){
                    if(mailbodyRep.contains('#PARAM:'+name+'#')){
                        mailbodyRep = mailbodyRep.replace('#PARAM:'+name+'#',nameValuePair.get(name));
                    }
                    else {
                        mailbodyRep = mailbodyRep.replace('#PARAM:'+name+'#','');
                    }
                }
                */
                if(mailbodyRep.indexOf('#PARAM:') != -1){
                    do{
                        //String param = mailbodyRep.substring(mailbodyRep.indexOf('#PARAM:')+7,mailbodyRep.indexOf('#'));
                        String param = mailbodyRep.substringBetween('#PARAM:','#');
                        //System.debug('param::::'+param);
                        if(nameValuePair.containsKey(param.trim())){
                            mailbodyRep = mailbodyRep.replace('#PARAM:'+param+'#',nameValuePair.get(param.trim()));
                        }
                        else {
                            mailbodyRep = mailbodyRep.replace('#PARAM:'+param+'#','');
                        }
                    }while(mailbodyRep.indexOf('#PARAM:') != -1);
                }
            }
        }
        catch(Exception exp){
            EmailHandlerUtility.saveEmailExceptionErrorLog(exp, '','' ,'EmailSubjectBodyPerMST','replaceNameValuePairs');
        }
        return mailbodyRep;
    }
    
    /**
    * The removeDuplicateCommaSeparatedValues method will be used to remove duplicate entries from list
    *
    * @method name: removeDuplicateCommaSeparatedValues
    * @param:   List<String> originalValues
    * @return : List<String>
    */
    private List<String> removeDuplicateCommaSeparatedValues(List<String> originalValues){
        Set<String> tempSet = new Set<String>();
        List<String> result = new List<String>();
        try {
            tempSet.addAll(originalValues);
            result.addAll(tempSet);
        }
        catch(Exception exp){
            EmailHandlerUtility.saveEmailExceptionErrorLog(exp, '','' ,'EmailSubjectBodyPerMST','removeDuplicateCommaSeparatedValues');
        }
        return result;
    }
    
    /**
    * The isThereAnyDuplicates method will be used to identify whether there is any duplicate field present
    *
    * @method name: isThereAnyDuplicates
    * @param:   Set<String> allUniqueFields,List<String> fields
    * @return : Boolean
    */
    private Boolean isThereAnyDuplicates(Set<String> allUniqueFields,List<String> fields){
        if(allUniqueFields.size() == fields.size()){
            return false;
        }else{
            return true;
        }
    }
    
    /**
    * The removeDuplicateEntriesIfAny method will be used to remove any duplicate fields to make the final query optimized
    *
    * @method name: removeDuplicateEntriesIfAny
    * @param:   String finalToBeQueriedField, Set<String> allUniqueFields
    * @return : String
    */
    private String removeDuplicateEntriesIfAny(String finalToBeQueriedField, Set<String> allUniqueFields){
        String tempString = '';
        try {
            for(String aField:allUniqueFields){
                if(String.isEmpty(tempString)){
                    tempString = aField;
                }else{
                    tempString = tempString + ',' + aField;
                }
            }
        } 
        catch(Exception exp){
            EmailHandlerUtility.saveEmailExceptionErrorLog(exp, '','' ,'EmailSubjectBodyPerMST','removeDuplicateEntriesIfAny');
        }
        return tempString;
    }
    
    /**
    * The parseBody method will be used to parse the body of the email template
    *
    * @method name: parseBody
    * @param:   String body,String finalToBeQueriedField, Map<String, List<String>> allRelationShipFlowMap
    * @return : String
    */
    private String parseBody(String body,String finalToBeQueriedField, Map<String, List<String>> allRelationShipFlowMap){
        String toBeQueriedField = parseContent(body, allRelationShipFlowMap);
        return createFinalQueriedListOfFields(finalToBeQueriedField,toBeQueriedField);
    }
    
    /**
    * The parseSubject method will be used to parse the subject of the email template
    *
    * @method name: parseSubject
    * @param:   String subject,String finalToBeQueriedField, Map<String, List<String>> allRelationShipFlowMap
    * @return : String
    */
    private String parseSubject(String subject,String finalToBeQueriedField, Map<String, List<String>> allRelationShipFlowMap){
        String toBeQueriedField = parseContent(subject, allRelationShipFlowMap);
        return createFinalQueriedListOfFields(finalToBeQueriedField,toBeQueriedField);
    }
    
    /**
    * The createFinalQueriedListOfFields method will be create the final query fields.
    *
    * @method name: createFinalQueriedListOfFields
    * @param:   String finalToBeQueriedField, String toBeQueriedField
    * @return : String
    */
    private String createFinalQueriedListOfFields(String finalToBeQueriedField, String toBeQueriedField){
        if(String.isEmpty(finalToBeQueriedField)){
            return toBeQueriedField;
        }else{
            return finalToBeQueriedField + ',' + toBeQueriedField;
        }
    }
    
    /**
    * The parseContent method will be used to parse the HTML content.
    * This method is responsible for dynamically identifying all the merge fields present in the email 
    * template subject/body.
    *
    * @method name: parseContent
    * @param:   String content, Map<String, List<String>> allRelationShipFlowMap
    * @return : String
    */
    
    private String parseContent(String content, Map<String, List<String>> allRelationShipFlowMap){
        String finalToBeQueriedField='';
        try {
            String toBeQueriedField = '';
            standAloneObjectFieldName = new Set<String>();
            if((content.indexOf('{!'))!=-1){
                do{
                    List<String> relationshipFlow = new List<String>();
                    String objectAndFieldName = content.substring(content.indexOf('{!')+2,content.indexOf('}'));
                    String objectName = objectAndFieldName.substringBefore('.');
                    String fieldName = objectAndFieldName.substringAfter('.');
                    
                    //Check whether the object is a standalone object or not
                    if(standAloneObjectList.contains(objectName)){
                        standAloneObjectFieldName.add(fieldName);
                    }else{
                        if((Swift_Relationship_Mapping_Per_MST__c.getInstance(objectName).RelationshipName__c) != null){
                            toBeQueriedField = Swift_Relationship_Mapping_Per_MST__c.getInstance(objectName).RelationshipName__c+'.'+fieldName; 
                            relationshipFlow.addAll(Swift_Relationship_Mapping_Per_MST__c.getInstance(objectName).RelationshipFlow__c.split('-'));
                            allRelationShipFlowMap.put(objectName, relationshipFlow);
                        }else {
                            toBeQueriedField= fieldName; 
                            allRelationShipFlowMap.put(objectName, relationshipFlow);
                        }
                        if(String.isEmpty(finalToBeQueriedField)){
                            finalToBeQueriedField = toBeQueriedField;
                        }else{
                            finalToBeQueriedField = finalToBeQueriedField + ',' + toBeQueriedField;
                        }
                    }
                    String temp = content;
                    content = temp.substring(temp.indexOf('}')+1);
                }while(content.indexof('{!')!=-1);
            }
        }
        catch(Exception exp){
            EmailHandlerUtility.saveEmailExceptionErrorLog(exp, '','' ,'EmailSubjectBodyPerMST','parseContent');
        }
        return finalToBeQueriedField;
    }

}