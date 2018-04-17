/* This class is used in sending dynamic emails for MRS related flow when the mails are to be segregated as per Maskshops.*/
public class EmailSubjectBodyPerMaskshop {
static Set<String> childObject = new Set<String>{'MRS_Layer_Chip_Association__c','MRS_Layer_Association__c','MRS_Chip_Details__c','DRT__c','PTRF__c'};
static Map<String,Set<String>> maskshopFieldMap = new Map<String,Set<String>>();
static List<String> relationshipFlow = new List<String>();
static map<string,set<String>> mapchildObjFields = new map<string,set<String>>();

/**
@Method Name: createQueryString
@Description: This method creates field sets to be queried for each email templates passed as parameter
**/
public static Map<string, set<string>>  createQueryString(Set <string> setEmailTemplates){

try{
list<EmailTemplate> lstET = new list<EmailTemplate>();
lstET = [SELECT Name,DeveloperName,Body,HtmlValue,Subject FROM EmailTemplate WHERE DeveloperName in :setEmailTemplates AND IsActive = true];
map<string, set<string>> mapEmailTemplateQueryString = new map<string, set<string>>();
if(lstET.size()>0){
for(EmailTemplate et:lstET){
string body= et.Subject+et.HtmlValue;
set<string> setFields = new set<string>();
string fields;
if(body.indexof('{!')!=-1){
    do{
        string fieldName = body.substring(body.indexOf('{!')+2,body.indexOf('}'));
       if(Swift_Relationship_Mapping_Per_Maskshop__c.getInstance(fieldName.substringBefore('.'))!=null){    
        if(Swift_Relationship_Mapping_Per_Maskshop__c.getInstance(fieldName.substringBefore('.')).RelationshipName__c != null){
            setFields.add(Swift_Relationship_Mapping_Per_Maskshop__c.getInstance(fieldName.substringBefore('.')).RelationshipName__c+'.'+fieldName.substringAfter('.'));
        }
        else {
            setFields.add(fieldName.substringAfter('.')) ;   
        }
       } 
        string temp = body;
        body = temp.substring(temp.indexOf('}')+1);
    }while(body.indexof('{!')!=-1);
    setFields.add('Layer__r.Layer_Name__c');
    setFields.add('Chip__r.Name');
    setFields.add('PTRF__r.Maskshop__c');

    mapEmailTemplateQueryString.put(et.DeveloperName,setFields);
    }
   }
  }
  return mapEmailTemplateQueryString;
 }
 catch(Exception ex){
   EmailHandlerUtility.saveEmailExceptionErrorLog(ex, '','' ,'EmailSubjectBodyPerMaskshop','createQueryString');
 }
 return null;
}
/**
@Mathod Name: generateSubBodyPerMaskshop
@Description: This method generates the email Subject/Body for each of the email template and list of MSR layer Chip Association details passed.
**/

public static Map<string,list<string>> generateSubBodyPerMaskshop(Map<string, List<MRS_Layer_Chip_Association__c> > EmailTemplatecounterIntMaskshop,Map<String,String> nameValuePair){
try{
set<string> setemailTemp = new set<string>();
map<string,emailtemplate> mapetemplate = new map<string, emailtemplate>();
map<string,list<string>> mapreplacedBody = new map<string,list<string>>();

if(EmailTemplatecounterIntMaskshop.keyset().size()>0){
    for(string maskshoplc :EmailTemplatecounterIntMaskshop.keyset()){
        if(maskshoplc.indexof('::')!=-1){
            setemailTemp.add(maskshoplc.split('::')[0]);
        }
    }
}
if(setemailTemp.size()>0){
    for(emailtemplate et :[SELECT Name,DeveloperName,Body,HtmlValue,Subject FROM EmailTemplate WHERE DeveloperName in :setemailTemp AND IsActive = true]){
        mapetemplate.put(et.DeveloperName,et);
    }
}
if(mapetemplate.keyset().size()>0){
    for(string temp :mapetemplate.keyset()){
        string etbody= mapetemplate.get(temp).Subject+mapetemplate.get(temp).HtmlValue;
        if(etbody.indexof('{!')!=-1){
            do{ 
               
                string fieldName = etbody.substring(etbody.indexOf('{!')+2,etbody.indexOf('}'));
                
                if(childObject.contains(fieldName.substringBefore('.'))){
                    if(!maskshopFieldMap.containskey(temp)){
                        maskshopFieldMap.put(temp,new set<string>());
                    }
                    maskshopFieldMap.get(temp).add('{!'+fieldName+'}');
                    string tempet = etbody;
                    
                    etbody = tempet.substring(tempet.indexOf('}')+1);
                }
                else{
                    string tempet = etbody;
                   
                    etbody = tempet.substring(tempet.indexOf('}')+1);
                }
            }while(etbody.indexof('{!')!=-1);
        }
    }
}


//Create Child Object Field Maps
if(EmailTemplatecounterIntMaskshop.keyset().size()>0){
    for(string etmaskshop:EmailTemplatecounterIntMaskshop.keyset()){
        for(MRS_Layer_Chip_Association__c mrsObj :EmailTemplatecounterIntMaskshop.get(etmaskshop)){
            if(maskshopFieldMap.containskey(etmaskshop.split('::')[0])){
                if(maskshopFieldMap.get(etmaskshop.split('::')[0]).size()>0){
                    for(String strObj : maskshopFieldMap.get(etmaskshop.split('::')[0])){
                        relationshipFlow.clear();
                      if(Swift_Relationship_Mapping_Per_Maskshop__c.getInstance(strObj.substringBetween('{!','}').substringBefore('.'))!=null) { 
                        if(Swift_Relationship_Mapping_Per_Maskshop__c.getInstance(strObj.substringBetween('{!','}').substringBefore('.')).RelationshipFlow__c != null){
                         if(Swift_Relationship_Mapping_Per_Maskshop__c.getInstance(strObj.substringBetween('{!','}').substringBefore('.')).RelationshipFlow__c.contains('-')){
                             
                             relationshipFlow.addAll(Swift_Relationship_Mapping_Per_Maskshop__c.getInstance(strObj.substringBetween('{!','}').substringBefore('.')).RelationshipFlow__c.split('-'));
                         }
                         else {
                             relationshipFlow.add(Swift_Relationship_Mapping_Per_Maskshop__c.getInstance(strObj.substringBetween('{!','}').substringBefore('.')).RelationshipFlow__c);
                         }
                     }
                    } 
                     if(!mapchildObjFields.containskey(etmaskshop+strObj)){         //TASK-2451
                        mapchildObjFields.put(etmaskshop+strObj,new Set<String>());
                     }
                     if(relationshipFlow.size() == 0){
                     
                         if(string.valueOf(mrsObj.get(strObj.substringBetween('{!','}').substringAfter('.'))) != null){
                             mapchildObjFields.get(etmaskshop+strObj).add(string.valueOf(mrsObj.get(strObj.substringBetween('{!','}').substringAfter('.'))));
                         }
                     }
                     else if(relationshipFlow.size() == 1){
                       if(string.valueOf(mrsObj.getSObject(relationshipFlow[0])) != null){
                         if(string.valueOf(mrsObj.getSObject(relationshipFlow[0]).get(strObj.substringBetween('{!','}').substringAfter('.'))) != null){
                             mapchildObjFields.get(etmaskshop+strObj).add(string.valueOf(mrsObj.getSObject(relationshipFlow[0]).get(strObj.substringBetween('{!','}').substringAfter('.'))));
                         }  
                       }                    
                     }
                     else if(relationshipFlow.size() == 2){
                       if(string.valueOf(mrsObj.getSObject(relationshipFlow[0])) != null){
                        if(string.valueOf(mrsObj.getSObject(relationshipFlow[0]).getSobject(relationshipFlow[1]))!=null){
                         if(string.valueOf(mrsObj.getSobject(relationshipFlow[0]).getSobject(relationshipFlow[1]).get(strObj.substringBetween('{!','}').substringAfter('.'))) != null){
                             mapchildObjFields.get(etmaskshop+strObj).add(string.valueOf(mrsObj.getSobject(relationshipFlow[0]).getSobject(relationshipFlow[1]).get(strObj.substringBetween('{!','}').substringAfter('.'))));
                         }
                        } 
                       }  
                     }
                     
                    }
                }
            }   
        }
    }
}

//Generate Email body with replaced dynamic content
if(EmailTemplatecounterIntMaskshop.keyset().size()>0){
    for(string etmaskshop:EmailTemplatecounterIntMaskshop.keyset()){
        list<string> lstbody = new list<string>();
        lstbody.add(replaceSubjectBody(mapetemplate.get(etmaskshop.split('::')[0]).Subject, EmailTemplatecounterIntMaskshop.get(etmaskshop) , etmaskshop));
        string strBody = replaceSubjectBody(mapetemplate.get(etmaskshop.split('::')[0]).htmlvalue, EmailTemplatecounterIntMaskshop.get(etmaskshop) , etmaskshop);
        //Removing CDATA html tag in order to resolve MS Outlook rendering of the mail body. 
        strBody = strBody.replace('[CDATA[','').replace(']]>','');
        
         if(nameValuePair != null){
            /*
           for(String name : nameValuePair.keySet()){
             if(strBody.contains('#PARAM:'+name+'#')){
                strBody = strBody.replace('#PARAM:'+name+'#',nameValuePair.get(name));
              }
             else {
                strBody = strBody.replace('#PARAM:'+name+'#','');
                  }
                }
               */
               if(strBody.indexOf('#PARAM:') != -1){
                    do{
                        //String param = mailbodyRep.substring(mailbodyRep.indexOf('#PARAM:')+7,mailbodyRep.indexOf('#'));
                        String param = strBody.substringBetween('#PARAM:','#');
                        //System.debug('param::::'+param);
                        if(nameValuePair.containsKey(param.trim())){
                            strBody = strBody.replace('#PARAM:'+param+'#',nameValuePair.get(param.trim()));
                        }
                        else {
                            strBody = strBody.replace('#PARAM:'+param+'#','');
                        }
                    }while(strBody.indexOf('#PARAM:') != -1);
                } 
            }
            
            
          
        lstbody.add(strBody);
        mapreplacedBody.put(etmaskshop,lstbody);
        }
    }


    return mapreplacedBody;
    
    }
    catch(Exception ex){
     EmailHandlerUtility.saveEmailExceptionErrorLog(ex, '','' ,'EmailSubjectBodyPerMaskshop','generateSubBodyPerMaskshop');
    }
    return null;
}

/**
@Method Name:replaceSubjectBody
@Description: This method takes the string parametere and repalces its dynamic content based on the MRS Layer Chip Association records passed.
**/
public static string replaceSubjectBody(String replaceString,List<MRS_Layer_Chip_Association__c> mrsObj, string maskshopcounter){

try{
string mailbody = replaceString;
string mailbodyRep = replaceString;

//Replace dynamic content from MRS Layer Chip Details
if(mailbody.indexof('{!')!=-1){
    do{
        string strField  = mailbody.substring(mailbody.indexOf('{!')+2,mailbody.indexOf('}'));
        string temp = '{!'+strField+'}';
        Boolean checkRepl = false;
        if(!childObject.contains(strField.substringBefore('.'))){
            relationshipFlow.clear();
           if(Swift_Relationship_Mapping_Per_Maskshop__c.getInstance(strField.substringBefore('.'))!=null){ 
            if(Swift_Relationship_Mapping_Per_Maskshop__c.getInstance(strField.substringBefore('.')).RelationshipFlow__c != null){
                if(Swift_Relationship_Mapping_Per_Maskshop__c.getInstance(strField.substringBefore('.')).RelationshipFlow__c.contains('-')){
                    relationshipFlow.addAll(Swift_Relationship_Mapping_Per_Maskshop__c.getInstance(strField.substringBefore('.')).RelationshipFlow__c.split('-'));
                }
                else {
                    relationshipFlow.add(Swift_Relationship_Mapping_Per_Maskshop__c.getInstance(strField.substringBefore('.')).RelationshipFlow__c);
                }
            }
           } 
            if(relationshipFlow.size() == 0){
                if(string.valueOf(mrsObj[0].get(strField.substringAfter('.'))) != null){
                    mailbody = mailbody.replace(temp,string.valueOf(mrsObj[0].get(strField.substringAfter('.'))));
                    mailbodyRep = mailbodyRep.replace(temp,string.valueOf(mrsObj[0].get(strField.substringAfter('.'))));
                    checkRepl=true;
                }

            }
            else if(relationshipFlow.size() == 1){
              if(string.valueOf(mrsObj[0].getSObject(relationshipFlow[0])) != null){
                if(string.valueOf(mrsObj[0].getSObject(relationshipFlow[0]).get(strField.substringAfter('.'))) != null){
                    mailbody = mailbody.replace(temp,string.valueOf(mrsObj[0].getSObject(relationshipFlow[0]).get(strField.substringAfter('.'))));
                    mailbodyRep = mailbodyRep.replace(temp,string.valueOf(mrsObj[0].getSObject(relationshipFlow[0]).get(strField.substringAfter('.'))));
                    checkRepl=true;
                }
               } 
                        
            }

                     else if(relationshipFlow.size() == 2){
                       if(string.valueOf(mrsObj[0].getSObject(relationshipFlow[0])) != null){
                        if(string.valueOf(mrsObj[0].getSObject(relationshipFlow[0]).getSobject(relationshipFlow[1]))!=null){
                         if(string.valueOf(mrsObj[0].getSobject(relationshipFlow[0]).getSobject(relationshipFlow[1]).get(strField.substringAfter('.'))) != null){
                             mailbody = mailbody.replace(temp,string.valueOf(mrsObj[0].getSobject(relationshipFlow[0]).getSobject(relationshipFlow[1]).get(strField.substringAfter('.'))));
                             mailbodyRep = mailbodyRep.replace(temp,string.valueOf(mrsObj[0].getSobject(relationshipFlow[0]).getSobject(relationshipFlow[1]).get(strField.substringAfter('.'))));
                             checkRepl=true;
                         }
                        } 
                       }  

                     }
                     
                     if(!checkRepl){
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
    if(maskshopFieldMap.keyset().size()>0){
        if(maskshopFieldMap.containskey(maskshopcounter.split('::')[0])){
            for(String strObj : maskshopFieldMap.get(maskshopcounter.split('::')[0])){
                strList.clear();
                fieldSeparated = '';
                if(mapchildObjFields.containsKey(maskshopcounter+strObj)){
                    strList.addAll(mapchildObjFields.get(maskshopcounter+strObj));
                    fieldSeparated = String.join(strList,',');
                    mailbodyRep = mailbodyRep.replace(strObj,fieldSeparated);
                }
                else {
                    mailbodyRep = mailbodyRep.replace(strObj,'');
                }
            }
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
    
    return mailbodyRep;
    }
    catch(Exception ex){
     EmailHandlerUtility.saveEmailExceptionErrorLog(ex, '','' ,'EmailSubjectBodyPerMaskshop','replaceSubjectBody');
    }
    return null;
  }
 


}