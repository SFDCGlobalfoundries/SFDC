/*
Type Name: EmailSubjectBodyPerPTRF 
Author: Cognizant 
Created Date: 10-January-2015
Reason: This class queries all the MRS related email templates once. 
Change History:

*/

public class EmailSubjectBodyPerPTRF {
    
    String fieldName;
    String subject;
    String finalMailBody;
    String finalMailSubject;
    
    Set<String> fields = new Set<String>();
    Set<String> childObject = new Set<String>{'MRS_Layer_Chip_Association__c','MRS_Layer_Association__c','MRS_Chip_Details__c','DRT__c'};
    Set<String> childObjFields = new Set<String>();
    Set<String> emailTemplateWithApprovalId = new Set<String>();
    
    Map<String,List<MRS_Layer_Chip_Association__c>> ptrfIdLayerChipMap = new Map<String,List<MRS_Layer_Chip_Association__c>>();
    Map<String,String> fieldMapping = new Map<String,String>();
    Map<String,Set<String>> ptrfIdFieldMap = new Map<String,Set<String>>();
    Map<String,Map<String,String>> outerMap = new Map<String,Map<String,String>>();
    Map<String,Set<String>> chipLayerMap = new Map<String,Set<String>>();
    Map<String,Set<String>> ptrfMRSLCAIdMap = new Map<String,Set<String>>();
    
    Messaging.SingleEmailMessage[] mailList = new Messaging.SingleEmailMessage[]{};
    
    List<String> relationshipFlow = new List<String>();
    List<Approval_Helper__c> approvalListToAdd = new List<Approval_Helper__c>();
    
    
    
    /*------------------------------------------------------------------------------------------------------------------------------------------
    @ Method Name : emailSubBodyPerPTRF
    @ Description : This method queries the email template and call another method to parse the subject and body of the template. 
                    Then it queries from the MRSLCA object and creates a per PTRF map. After that it calls another method to replace
                    the actual values in the subject and body of the template.
    --------------------------------------------------------------------------------------------------------------------------------------------*/
    public void emailSubBodyPerPTRF(List<MRS_Layer_Chip_Association__c> mrsLayerChipList,String templateName,Map<String,String> nameValuePair,String gatingNotGatingPerPTRF,String fieldToUpdate){
        
        try {
            MRSEmailTemplateQuery.emailTemplateQuery();
            EmailTemplate et;
            if(MRSEmailTemplateQuery.mapEmailTemplateAndName.containsKey(templateName)){
                et = MRSEmailTemplateQuery.mapEmailTemplateAndName.get(templateName);
            }
            
            
            if(Label.Swift_Email_Template_With_Approval_Id.contains(';')){
                emailTemplateWithApprovalId.addAll(Label.Swift_Email_Template_With_Approval_Id.split(';'));
            }
            else {
                emailTemplateWithApprovalId.add(Label.Swift_Email_Template_With_Approval_Id);
            }
            if(Test.isRunningTest()){
                emailTemplateWithApprovalId.add('Test_Template');
            }
            
            if(et != null){
                fieldName ='';
                fields.clear();
                childObjFields.clear();
                ptrfIdFieldMap.clear();
                ptrfMRSLCAIdMap.clear();
                ptrfIdLayerChipMap.clear();
                fieldMapping.clear();
                approvalListToAdd.clear();
                outerMap.clear();
                
                subject = et.Subject;
                finalMailBody = et.HtmlValue;
                finalMailSubject = et.Subject;
                
                readSubjectBody(et.Subject+'||$||'+et.HtmlValue);
                
                String query ='';
                
                fields.add('Layer_Identifier__c');
                fields.add('Chip__r.Name');
                fields.add('PTRF__c');
                fields.add('PTRF__r.Name');
                fields.add('PTRF__r.MaskSetTitle__r.Name');
                
                List<String> fieldList = new List<String>();
                fieldList.addAll(fields);
                
                String fieldsStr = String.join(fieldList,',');
                
                query = 'SELECT '+fieldsStr+' FROM MRS_Layer_Chip_Association__c WHERE Id IN :mrsLayerChipList';
                
                List<MRS_Layer_Chip_Association__c> mrsLayerChipListQueried = Database.query(query);
                
                for(MRS_Layer_Chip_Association__c mrsObj : mrsLayerChipListQueried){
                    if(!ptrfIdLayerChipMap.containsKey(mrsObj.PTRF__c)){
                        ptrfIdLayerChipMap.put(mrsObj.PTRF__c,new List<MRS_Layer_Chip_Association__c>());
                    }
                    ptrfIdLayerChipMap.get(mrsObj.PTRF__c).add(mrsObj);
                    
                    if(!ptrfMRSLCAIdMap.containsKey(mrsObj.PTRF__c)){
                        ptrfMRSLCAIdMap.put(mrsObj.PTRF__c,new Set<String>());
                    }
                    ptrfMRSLCAIdMap.get(mrsObj.PTRF__c).add(mrsObj.Id);
                    
                    for(String strObj : childObjFields){
                        
                        relationshipFlow.clear();
                        if(Swift_Relationship_Mapping_Per_PTRF__c.getInstance(strObj.substringBetween('{!','}').substringBefore('.')).RelationshipFlow__c != null){
                             if(Swift_Relationship_Mapping_Per_PTRF__c.getInstance(strObj.substringBetween('{!','}').substringBefore('.')).RelationshipFlow__c.contains('-')){
                                 
                                 relationshipFlow.addAll(Swift_Relationship_Mapping_Per_PTRF__c.getInstance(strObj.substringBetween('{!','}').substringBefore('.')).RelationshipFlow__c.split('-'));
                             }
                             else {
                                 relationshipFlow.add(Swift_Relationship_Mapping_Per_PTRF__c.getInstance(strObj.substringBetween('{!','}').substringBefore('.')).RelationshipFlow__c);
                             }
                         }
                        
                         if(!ptrfIdFieldMap.containsKey(mrsObj.PTRF__c+strObj)){
                             ptrfIdFieldMap.put(mrsObj.PTRF__c+strObj,new Set<String>());
                         } 
                         if(relationshipFlow.size() == 0){
                             if(string.valueOf(mrsObj.get(strObj.substringBetween('{!','}').substringAfter('.'))) != null){
                                 ptrfIdFieldMap.get(mrsObj.PTRF__c+strObj).add(string.valueOf(mrsObj.get(strObj.substringBetween('{!','}').substringAfter('.'))));
                             }
                         }
                         else if(relationshipFlow.size() == 1){
                             
                             if(mrsObj.getSObject(relationshipFlow[0]) != null){
                                 if(string.valueOf(mrsObj.getSObject(relationshipFlow[0]).get(strObj.substringBetween('{!','}').substringAfter('.'))) != null){
                                     ptrfIdFieldMap.get(mrsObj.PTRF__c+strObj).add(string.valueOf(mrsObj.getSObject(relationshipFlow[0]).get(strObj.substringBetween('{!','}').substringAfter('.'))));
                                 } 
                             }                   
                         }
                         else if(relationshipFlow.size() == 2){
                             
                             if(mrsObj.getSobject(relationshipFlow[0]) != null){
                                 if(mrsObj.getSobject(relationshipFlow[0]).getSobject(relationshipFlow[1]) != null){
                                     if(string.valueOf(mrsObj.getSobject(relationshipFlow[0]).getSobject(relationshipFlow[1]).get(strObj.substringBetween('{!','}').substringAfter('.'))) != null){
                                         ptrfIdFieldMap.get(mrsObj.PTRF__c+strObj).add(string.valueOf(mrsObj.getSobject(relationshipFlow[0]).getSobject(relationshipFlow[1]).get(strObj.substringBetween('{!','}').substringAfter('.'))));
                                     }
                                 }
                             }
                         }
                         
                    }
                }
                
                Map<String,String> ptrfApprovalIdMap = new Map<String,String>();
                if(emailTemplateWithApprovalId.contains(templateName)){
                    ptrfApprovalIdMap = encryptData(ptrfMRSLCAIdMap,ptrfIdLayerChipMap,fieldToUpdate);
                }
                
                List<String> layerNameList = new List<String>();
                String layerSeparated;
                String chipLayerName = '';
                
                
                for(String ptrfId : ptrfIdLayerChipMap.keySet()){
                    
                    List<MRS_Layer_Chip_Association__c> mrsObj = ptrfIdLayerChipMap.get(ptrfId);
                    chipLayerMap.clear();
                    for(MRS_Layer_Chip_Association__c mrslca : mrsObj){
                        if(!chipLayerMap.containsKey(mrslca.Chip__r.Name)){
                            chipLayerMap.put(mrslca.Chip__r.Name,new Set<String>());
                        }  
                        chipLayerMap.get(mrslca.Chip__r.Name).add(mrslca.Layer_Identifier__c); 
                        
                    }
                    
                    chipLayerName = '';
                    if(chipLayerMap.size() > 0){
                        for(String chipName : chipLayerMap.keySet()){
                            layerNameList.clear();
                            layerSeparated = '';
                            layerNameList.addAll(chipLayerMap.get(chipName));
                            layerSeparated = chipName+' layer(s) '+String.join(layerNameList,',');
                            
                            chipLayerName = chipLayerName+'Chip Name: '+layerSeparated+'<br>';
                        }
                    }
                    
                    String strBodySubject = replaceSubjectBody(finalMailSubject+'||$||'+finalMailBody,mrsObj,ptrfId,nameValuePair);
                    
                    Map<String,String> innerMap = new Map<String,String>();
                    
                    if(emailTemplateWithApprovalId.contains(templateName)){
                        innerMap.put(Label.EmailKeysetForBody,'Approval Id : '+ptrfApprovalIdMap.get(ptrfId)+'#'+strBodySubject.substringAfter('||$||').replace('#LAYERCHIPMATRIX#',chipLayerName).replace(']]>','').replace('<![CDATA[',''));
                    }
                    else {
                        innerMap.put(Label.EmailKeysetForBody,strBodySubject.substringAfter('||$||').replace('#LAYERCHIPMATRIX#',chipLayerName).replace(']]>','').replace('<![CDATA[',''));    //.replace(']]>','')
                    }
                    
                    innerMap.put(Label.EmailKeysetForTemplate,templateName);
                    innerMap.put(Label.EmailKeysetForGatingNotGating,gatingNotGatingPerPTRF);
                    innerMap.put(Label.EmailKeysetForSubject,strBodySubject.substringBefore('||$||'));
                    
                    outerMap.put(ptrfId,innerMap);
                }
                
                EmailHandlerUtility.ptrfEmailMethod(outerMap);
                
            }
            }
            catch(Exception exp){
                EmailHandlerUtility.saveEmailExceptionErrorLog(exp, '','' ,'EmailSubjectBodyPerPTRF','emailSubBodyPerPTRF');
            }
        
        
    }
    
    /*-------------------------------------------------------------------------------------------------------------------------------
    @ Method Name : readSubjectBody
    @ Description : This method parse the email subject and body to find all the fields that needs to be replaced.
    
    --------------------------------------------------------------------------------------------------------------------------------*/
        
    public void readSubjectBody(String body){
        try {
            if(body.indexof('{!')!=-1){
                do{
                    fieldName = body.substring(body.indexOf('{!')+2,body.indexOf('}'));
                    if(Swift_Relationship_Mapping_Per_PTRF__c.getInstance(fieldName.substringBefore('.')) != null){
                        if(childObject.contains(fieldName.substringBefore('.'))){
                            childObjFields.add('{!'+fieldName+'}');
                        }
                        if(Swift_Relationship_Mapping_Per_PTRF__c.getInstance(fieldName.substringBefore('.')).RelationshipName__c != null){
                            
                            fields.add(Swift_Relationship_Mapping_Per_PTRF__c.getInstance(fieldName.substringBefore('.')).RelationshipName__c+'.'+fieldName.substringAfter('.')); 
                            
                        }
                        else {
                            fields.add(fieldName.substringAfter('.')); 
                        }
                        
                        string temp = body;
                        body = temp.substring(temp.indexOf('}')+1);
                        
                    }
                    else {
                        string temp = body;
                        body = temp.substring(temp.indexOf('}')+1);
                        
                        finalMailBody = finalMailBody.replace('{!'+fieldName+'}','');
                        finalMailSubject = finalMailSubject.replace('{!'+fieldName+'}','');
                    }
                }while(body.indexof('{!')!=-1);
                
            }
            
        }
        catch(Exception exp){
            EmailHandlerUtility.saveEmailExceptionErrorLog(exp, '','' ,'EmailSubjectBodyPerPTRF','readSubjectBody');
        }
    }
    
    /*-------------------------------------------------------------------------------------------------------------------------------
    @ Method Name : replaceSubjectBody
    @ Description : This method replaces the actual values in the subject and body of the template along with the links and name value 
                    pair.
    --------------------------------------------------------------------------------------------------------------------------------*/
    
    public String replaceSubjectBody(String replaceString,List<MRS_Layer_Chip_Association__c> mrsObj,String ptrfId,Map<String,String> nameValuePair){
        
        String mailbody = replaceString;
        String mailbodyRep = replaceString;
        try {
            if(mailbody.indexof('{!')!=-1){
               do{
                     string strField  = mailbody.substring(mailbody.indexOf('{!')+2,mailbody.indexOf('}'));
                     
                     string temp = '{!'+strField+'}';
                     
                     if(!childObject.contains(strField.substringBefore('.'))){
                         relationshipFlow.clear();
                         
                         
                         if(Swift_Relationship_Mapping_Per_PTRF__c.getInstance(strField.substringBefore('.')).RelationshipFlow__c != null){
                             if(Swift_Relationship_Mapping_Per_PTRF__c.getInstance(strField.substringBefore('.')).RelationshipFlow__c.contains('-')){
                                
                                 relationshipFlow.addAll(Swift_Relationship_Mapping_Per_PTRF__c.getInstance(strField.substringBefore('.')).RelationshipFlow__c.split('-'));
                             }
                             else {
                                 relationshipFlow.add(Swift_Relationship_Mapping_Per_PTRF__c.getInstance(strField.substringBefore('.')).RelationshipFlow__c);
                             }
                         }
                         
                         
                         if(relationshipFlow.size() == 0){
                             if(string.valueOf(mrsObj[0].get(strField.substringAfter('.'))) != null){
                                 mailbody = mailbody.replace(temp,string.valueOf(mrsObj[0].get(strField.substringAfter('.'))));
                                 mailbodyRep = mailbodyRep.replace(temp,string.valueOf(mrsObj[0].get(strField.substringAfter('.'))));
                             }
                             
                         }
                         else if(relationshipFlow.size() == 1){
                             if(mrsObj[0].getSObject(relationshipFlow[0]) != null){
                                 if(string.valueOf(mrsObj[0].getSObject(relationshipFlow[0]).get(strField.substringAfter('.'))) != null){
                                     mailbody = mailbody.replace(temp,string.valueOf(mrsObj[0].getSObject(relationshipFlow[0]).get(strField.substringAfter('.'))));
                                     mailbodyRep = mailbodyRep.replace(temp,string.valueOf(mrsObj[0].getSObject(relationshipFlow[0]).get(strField.substringAfter('.'))));
                                 }
                             }
                                                  
                         }
                         else if(relationshipFlow.size() == 2){
                             if(mrsObj[0].getSobject(relationshipFlow[0]) != null){
                                 if(mrsObj[0].getSobject(relationshipFlow[0]).getSobject(relationshipFlow[1]) != null){
                                     if(string.valueOf(mrsObj[0].getSobject(relationshipFlow[0]).getSobject(relationshipFlow[1]).get(strField.substringAfter('.'))) != null){
                                         mailbody = mailbody.replace(temp,string.valueOf(mrsObj[0].getSobject(relationshipFlow[0]).getSobject(relationshipFlow[1]).get(strField.substringAfter('.'))));
                                         mailbodyRep = mailbodyRep.replace(temp,string.valueOf(mrsObj[0].getSobject(relationshipFlow[0]).getSobject(relationshipFlow[1]).get(strField.substringAfter('.'))));
                                     }
                                 }
                             }
                             
                         }
                         if(mailbodyRep.contains(temp)){
                             mailbody = mailbody.replace(temp,'');
                             mailbodyRep = mailbodyRep.replace(temp,'');
                         }
                         
                     }
                     else{
                         
                         mailbody = mailbody.replace(temp,'');
                     }
                     
                     
                        
                 }while(mailbody.indexof('{!')!=-1);  
            }
            
            /*-----------------Comma Separated Field Replacement-----------------------*/
            List<String> strList = new List<String>();
            String fieldSeparated;
            for(String strObj : childObjFields){
                strList.clear();
                fieldSeparated = '';
                
                if(ptrfIdFieldMap.containsKey(ptrfId+strObj)){
                    strList.addAll(ptrfIdFieldMap.get(ptrfId+strObj));
                    fieldSeparated = String.join(strList,',');
                    mailbodyRep = mailbodyRep.replace(strObj,fieldSeparated);
                }
                else {
                    mailbodyRep = mailbodyRep.replace(strObj,'');
                }
                  
            }
            
            /*-----------------Link Replacement-----------------------*/
            String linkName;
            String linkTag;
            String changedLinkName;
            
            List<String> urlList = new List<String>();
            String parameters;
            if(mailbodyRep.indexOf('[?') != -1){
            
                Map<String,Swift_Email_Template_Links__c> linkMap = Swift_Email_Template_Links__c.getAll();
                do{
                    changedLinkName = '';
                    linkName = mailbodyRep.substring(mailbodyRep.indexOf('[?')+2,mailbodyRep.indexOf('?]'));
                    
                    
                    if(linkName.contains('|')){
                        urlList = linkName.split('[|]');
                        
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
                            
                            if(linkMap.containsKey(linkTag)){
                                changedLinkName = '<a href=\"'+linkMap.get(linkTag).URL__c+'\">'+linkMap.get(linkTag).Label__c+'</a>';
                            }
                            
                            mailbodyRep = mailbodyRep.replace('[?'+linkName+'?]',changedLinkName);
                        }
                        else {
                            mailbodyRep = mailbodyRep.replace('[?'+linkName+'?]','');
                        }
                    }
                }while(mailbodyRep.indexOf('[?') != -1);
            }
            
            /*-----------------Name-Value Pair Replacement-----------------------*/
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
                        System.debug('param::::'+param);
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
            EmailHandlerUtility.saveEmailExceptionErrorLog(exp, '','' ,'EmailSubjectBodyPerPTRF','replaceSubjectBody');
        }
        return mailbodyRep;
    }
    
    /*-------------------------------------------------------------------------------------------------------------------------------
    @ Method Name : encryptData
    @ Description : This method creates records in Approval Helper object per mail sent. The records store the MRSLCA id needed for 
                    approvals and it also includes the field to update. The salesforce id generated after insertion is encrypted and 
                    the encrypted data is passes with the email.  
    --------------------------------------------------------------------------------------------------------------------------------*/
    
    public Map<String,String> encryptData(Map<String,Set<String>> ptrfMRSLCAIdMap,Map<String,List<MRS_Layer_Chip_Association__c>> ptrfIdLayerChipMap,String fieldToUpdate){
        
        Map<String,String> ptrfApprovalIdMap = new Map<String,String>();
        List<String> mrslcaIdList = new List<String>();
        try {
            for(String ptrfId : ptrfMRSLCAIdMap.keySet()){
                mrslcaIdList.clear();
                mrslcaIdList.addAll(ptrfMRSLCAIdMap.get(ptrfId));
                Approval_Helper__c appHelperObj = new Approval_Helper__c();
                if(mrslcaIdList.size() == 1){
                    appHelperObj.MRSLCA_Id_to_approve__c = mrslcaIdList[0];
                } 
                else {
                    appHelperObj.MRSLCA_Id_to_approve__c = String.join(mrslcaIdList,';');
                }
                if(fieldToUpdate != null){
                    appHelperObj.Field_to_Update__c = fieldToUpdate;
                }
                if(ptrfIdLayerChipMap != null){
                    if(ptrfIdLayerChipMap.containsKey(ptrfId)){
                        appHelperObj.PTRF_Number__c = ptrfIdLayerChipMap.get(ptrfId).get(0).PTRF__r.Name;
                        appHelperObj.Mask_Set_Title__c = ptrfIdLayerChipMap.get(ptrfId).get(0).PTRF__r.MaskSetTitle__r.Name;
                    }
                }
                appHelperObj.PTRF_Id__c = ptrfId;
                approvalListToAdd.add(appHelperObj);
            }
            
            
            insert approvalListToAdd;
            
            
            
            Blob cryptoKey = EncodingUtil.base64Decode(Label.Swift_Email_Encryption_Decryption_Key);
            for(Approval_Helper__c appHelp : approvalListToAdd){
                Blob data = Blob.valueOf(String.valueOf(appHelp.Id));
                Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey , data );
                
                ptrfApprovalIdMap.put(appHelp.PTRF_Id__c,EncodingUtil.urlEncode(EncodingUtil.base64Encode(encryptedData),'UTF-8'));
                
            }
            
            
        }
        catch(Exception exp){
            EmailHandlerUtility.saveEmailExceptionErrorLog(exp, '','' ,'EmailSubjectBodyPerPTRF','encryptData');
        }
        return ptrfApprovalIdMap;
        
        
    }
}