/*Author: Karthick D
* Description: This class redirects the bug record to the standard or 
                custom VF page based on the record type
* History: Created on 03/31/2014
*/
public with sharing class BugRedirect {
    public List<RecordType> bugRecordTypeList {set; get;}
    public String selectedRecordType{get;set;}
    public List<SelectOption> bugRecordTypes {set; get;}
    public Bug__c bugVar;
    public BugRedirect(ApexPages.StandardController controller) {
        ApexPages.StandardController stdCtrl = controller;
        bugVar = (bug__c) stdCtrl.getRecord();
        bugRecordTypes = new List<SelectOption>();
        bugRecordTypeList = new List<RecordType>();
        bugRecordTypes.add(new SelectOption(Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get(System.Label.BugPDKRecordTypeName).getRecordTypeId(),System.Label.BugPDKRecordTypeName));
        for(RecordType rt: [select id, name, DeveloperName, description from recordtype where IsActive = true and sobjecttype='Bug__c' and DeveloperName != 'PDK_Request2' 
            and DeveloperName !='PDK_Request3']) {
            bugRecordTypeList.add(rt);
        }
        for(RecordType bugRT : bugRecordTypeList) {
            if(bugRT.name == System.Label.PDKRequestRecordTypeName){             
                bugRecordTypes.add(new SelectOption(bugRT.id,System.Label.PDKWorkRequestRecordTypeName));         
            }
          else{       
            bugRecordTypes.add(new SelectOption(bugRT.id,bugRT.name));
        }
        }      
        Integer index;
        for(Integer i=1;i<bugRecordTypes.size();i++) {
            if(bugRecordTypes.get(i).getLabel()==System.Label.BugPDKRecordTypeName) {
                index=i;
                break;
            }
        }        
        if(index!=NULL) {      
            bugRecordTypes.remove(index);
        }
    }

    public PageReference redirectToPage() {
        PageReference pgRef;
        recordtype rcType;
        //String selectedRecordType;
        String strType = ApexPages.currentPage().getParameters().get('type');
        String strObjPrefix = Bug__c.sObjectType.getDescribe().getKeyPrefix();
        try{
            // Rediect to page when the bug is cloned.
            if (strType == 'clone') 
            {
                //selectedRecordType = ApexPages.currentPage().getParameters().get('RecordType');
                rcType = [Select id, name, DeveloperName, description from recordtype where Id=:selectedRecordType AND IsActive = true and sobjecttype='Bug__c'];
                if (rcType.Name == Label.BugPDKRecordTypeName) {
                     pgRef = new PageReference('/apex/loadbugFieldsPage?rid=' + selectedRecordType + '&id=' + bugVar.id + '&type=clone' + '&' +   label.bugOriginId + '=' + bugVar.id) ;
                } 
                //MM-Start 8thSept2015
                else if(rcType.Name == Label.BugCDTRecordTypeName){
                    pgRef = new PageReference('/apex/BugCDTCreate?rid=' + selectedRecordType + '&id=' + bugVar.id + '&type=clone' + '&' +   label.bugOriginId + '=' + bugVar.id) ;
                }
                //MM-End 8thSept2015
                //MM-Start 9thSept2015
                else if(rcType.Name == Label.BugCADRecordTypeName){
                    pgRef = new PageReference('/apex/BugCADCreate?rid=' + selectedRecordType + '&id=' + bugVar.id + '&type=clone' + '&' +   label.bugOriginId + '=' + bugVar.id) ;
                }
                //MM-End 9thSept2015
                else {
                     pgRef = new PageReference('/' + bugVar.id + '/e?clone=1' + '&RecordType=' + selectedRecordType + '&' + label.bugOriginId + '=' + bugVar.id + '&' +
                        label.bugStatusId + '=' + 'New' + '&' + label.bugResolutionId + '=' + '' +
                        '&' + label.BugResolutionDetailId + '=' + '' + '&' + label.BugDescriptionId + '=' + '' + '&' + label.BugDuplicateId + '=' +
                        +'&' + label.BugDuplicateId + '_lkid=' + '' +
                        +'&retURL=' + bugVar.id);
                }
            } 
            else 
            {
                    //selectedRecordType = ApexPages.currentPage().getParameters().get('RecordType');
                    string caseId = ApexPages.currentPage().getParameters().get('caseid');
                    rcType = [Select id, name, DeveloperName, description from recordtype where Id=:selectedRecordType AND IsActive = true and sobjecttype='Bug__c'];
    
                    if (rcType.Name == Label.BugPDKRecordTypeName) 
                    {
                        if (caseId != '' && caseId != null)
                            pgRef = new PageReference('/apex/loadbugFieldsPage?rid=' + selectedRecordType + '&caseid=' + caseId);
                        else
                            pgRef = new PageReference('/apex/loadbugFieldsPage?rid=' + selectedRecordType);
                        pgRef.getParameters().put('nooverride', '1');
                    } 
                    //MM-Start 8thSept2015
                    else if(rcType.Name == 'CDT Bug'){
                        System.debug('CDT Bug');
                        if (caseId != '' && caseId != null)
                            pgRef = new PageReference('/apex/BugCDTCreate?rid=' + selectedRecordType + '&caseid=' + caseId);
                        else
                            pgRef = new PageReference('/apex/BugCDTCreate?rid=' + selectedRecordType);
                        pgRef.getParameters().put('nooverride', '1');
                    }
                    //MM-End 8thSept2015
                    //MM-Start 9thSept2015
                    else if(rcType.Name == 'CAD Bug'){
                        System.debug('CAD Bug');
                        if (caseId != '' && caseId != null)
                            pgRef = new PageReference('/apex/BugCADCreate?rid=' + selectedRecordType + '&caseid=' + caseId);
                        else
                            pgRef = new PageReference('/apex/BugCADCreate?rid=' + selectedRecordType);
                        pgRef.getParameters().put('nooverride', '1');
                    }
                    //MM-End 9thSept2015
                    else if(rcType.Name == 'ASIC Bug'){
                        System.debug('CAD Bug');
                        if (caseId != '' && caseId != null)
                            pgRef = new PageReference('/apex/ASICBugDetailPage?rid=' + selectedRecordType + '&caseid=' + caseId);
                        else
                            pgRef = new PageReference('/apex/ASICBugDetailPage?rid=' + selectedRecordType);
                        pgRef.getParameters().put('nooverride', '1');
                    }
                    else
                    {
                        if (caseid != '' && caseid != null)
                            pgRef = new PageReference('/' + strObjPrefix + '/e?RecordType=' + selectedRecordType + '&saveURL=' + caseId + '&' + label.bugOriginId + '=' + caseid);
    
                        else
                            pgRef = new PageReference('/' + strObjPrefix + '/e?RecordType=' + selectedRecordType);
                        pgRef.getParameters().put('nooverride', '1');
                    }
            }
        } catch (exception e) {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getmessage()));
        }
        return pgRef;
    }
     //cancelling return to home page
    public PageReference cancelOrder() {
        Schema.DescribeSObjectResult SchResBug = Schema.SObjectType.Bug__c;
        PageReference bugPage = new PageReference('/' + SchResBug.getKeyPrefix() + '/o');
        bugPage.setRedirect(true);
        return bugPage;
    } 
}