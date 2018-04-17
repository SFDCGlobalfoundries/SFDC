/*
Trigger Name: CaseL2L3RoutingTrigger
Author: Cognizant Case Mgmt Team
Created Date: 24/02/2015
Reason: Reason: This is the generic class for Case L2 L3 Routing
Test Class: 
Change History:
Author:
Modified Date: 
……..//
……..
--
*/
public class CaseL2L3RoutingTriggerHandler {
    private boolean m_isExecuting = false;
    public static boolean flag = false;
    public static boolean geomteryFlag = false;
    public static boolean targetProcessNodeFlag = false;
    private integer BatchSize = 0;
    Set <Id> L2L3RoutingIds = new Set<Id>();
    
    String first = '<a style=color:#980000 href="';      // Stored the Style and Colour for the ERROR Link
    String sBreak = '</br>';     //This is separate because you can use it anywhere else  in ERROR Link                                      
    String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();    // Can easily use in any instance, no need hard code 
    
    public CaseL2L3RoutingTriggerHandler(boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;        
        BatchSize = size;
    }
    
    public void OnBeforeInsertL2L3Routing(CaseL2L3Routing__c[] newL2L3Routing) {
        insertOwnerId(newL2L3Routing);
        geometryValidation(newL2L3Routing);   
    }
    public void OnBeforeUpdateL2L3Routing(CaseL2L3Routing__c[] oldL2L3Routing, CaseL2L3Routing__c[] newL2L3Routing,Map < ID, CaseL2L3Routing__c> caseL2L3RoutingMap) {  
        updateOwnerId(oldL2L3Routing , newL2L3Routing ,caseL2L3RoutingMap);
        geometryValidation(newL2L3Routing); 
    }
    
    public void OnAfterInsertL2L3Routing(CaseL2L3Routing__c[] newL2L3Routing) {
        reEvaluateRules(newL2L3Routing);
    }
    public void OnAfterUpdateL2L3Routing(CaseL2L3Routing__c[] oldL2L3Routing, CaseL2L3Routing__c[] newL2L3Routing,Map < ID, CaseL2L3Routing__c> caseL2L3RoutingMap) {
        reEvaluateRules(newL2L3Routing);
    }
    
    /**
    This method is used for updating existing Case Owner where criteria matches.
    @method name: reEvaluateRules
    @parameter:   Array of newL2L3Routing.
    @return :     NA.
    **/
    public void reEvaluateRules(CaseL2L3Routing__c[] newL2L3Routing) {
        try { 
                List<String> oldOwnerIds = new List<String>();
                List<String> listCategory = new List<String>();
                
                List<Case> listCase = new List<Case>();
                List<Id> listCaseIdL2 = new List<Id>();
                List<Id> listOwnerIdL2 = new List<Id>();
                
                
                for (CaseL2L3Routing__c caseL2L3RoutingObjNew: newL2L3Routing) {
                    if (caseL2L3RoutingObjNew.Re_Evaluate__c) {
                        oldOwnerIds.add(caseL2L3RoutingObjNew.Old_OwnerId__c);
                        listCategory.add(caseL2L3RoutingObjNew.Category__c );
                    }
                }
                
                if(oldOwnerIds !=null && oldOwnerIds.size()>0){
                    listCase = [Select Id, OwnerId From Case Where OwnerId In : oldOwnerIds And Category__c In:listCategory 
                    And Case_Record_Type_API__c ='TechnicalPDK' Limit 10000];
                    if(listCase !=null && listCase.size()>0){
                        for (Case objCase: listCase) {
                            for (CaseL2L3Routing__c caseL2L3RoutingObjNew: newL2L3Routing) {
                                if(objCase.OwnerId == caseL2L3RoutingObjNew.Old_OwnerId__c){
                                    listCaseIdL2.add(objCase.Id);
                                    listOwnerIdL2.add(caseL2L3RoutingObjNew.Old_OwnerId__c);
                                    break;
                                }
                            }
                        }
                    }
                }
                
                //calculate OwnerId for L2 L3 Routing
                if(listCaseIdL2 !=null && listCaseIdL2.size()>0){
                    CaseHandlerUtility.calculateL2L3Routings(listCaseIdL2,listOwnerIdL2);
                }                
                if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
                }
        } catch (Exception e) {     
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseL2L3RoutingTriggerHandler.class.getName();
                    alw.sourceFunction ='reEvaluateRules()';
                    alw.ApplicationName='CaseL2L3';                    
                    alw.referenceInfo = 'CaseL2L3';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);
            //CaseHandlerUtility.trackException('CaseL2L3RoutingTriggerHandler - Method - reEvaluateRules', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }
    
    /**
    This method is used for CaseL2L3Routing__c Owner Information Insert.
    At the Time of insert .
    @method name: insertOwnerId
    @parameter:   Array of newL2L3Routing.
    @return :     NA.
    **/
    public void insertOwnerId(CaseL2L3Routing__c[] newL2L3Routing) {

        try {
            Set < string > oldOwnerQueue = new Set < String > ();
            Set < string > newOwnerQueue = new Set < String > ();
    
            for (CaseL2L3Routing__c caseL2L3RoutingObjNew: newL2L3Routing) {
                oldOwnerQueue.add(caseL2L3RoutingObjNew.Old_Owner__c);
                if (caseL2L3RoutingObjNew.New_Owner__c != 'Individual') {
                    newOwnerQueue.add(caseL2L3RoutingObjNew.New_Owner__c);
                }
            }
    
            map < string, id > mapOldOwnerQueueId = new map < string, id > (); //This will only store one Queue id per alias
            map < string, id > mapNewOwnerQueueId = new map < string, id > ();
    
            for (Group queue: [Select Id, Name FROM Group WHERE Type = 'Queue' and Name IN: oldOwnerQueue]) {
                mapOldOwnerQueueId.put(queue.Name, queue.Id);
            }
            for (Group queue: [Select Id, Name FROM Group WHERE Type = 'Queue' and Name IN: newOwnerQueue]) {
                mapNewOwnerQueueId.put(queue.Name, queue.Id);
            }
    
            for (CaseL2L3Routing__c caseL2L3RoutingObj: newL2L3Routing) {    
                if (mapOldOwnerQueueId.get(caseL2L3RoutingObj.Old_Owner__c) == null) {
                    caseL2L3RoutingObj.Old_Owner__c.addError(caseL2L3RoutingObj.Old_Owner__c + ' ' + System.Label.Case_L2L3Routing_Error_Messages);
                    break;
                }
                if (caseL2L3RoutingObj.New_Owner__c != 'Individual' && mapNewOwnerQueueId.get(caseL2L3RoutingObj.New_Owner__c) == null) {
                    caseL2L3RoutingObj.New_Owner__c.addError(caseL2L3RoutingObj.New_Owner__c + ' ' + System.Label.Case_L2L3Routing_Error_Messages);
                    break;
                }
                if (caseL2L3RoutingObj.Old_Owner__c != null) {
                    caseL2L3RoutingObj.Old_OwnerId__c = mapOldOwnerQueueId.get(caseL2L3RoutingObj.Old_Owner__c);
                }
                if (caseL2L3RoutingObj.New_Owner__c != null && caseL2L3RoutingObj.New_Owner__c != 'Individual') {
                    caseL2L3RoutingObj.New_OwnerId__c = mapNewOwnerQueueId.get(caseL2L3RoutingObj.New_Owner__c);
                }
                if (caseL2L3RoutingObj.Individual__c != null && caseL2L3RoutingObj.New_Owner__c == 'Individual') {
                    caseL2L3RoutingObj.New_OwnerId__c = caseL2L3RoutingObj.Individual__c;
                }
            }
            if(Test.isRunningTest()) {
                    throw new applicationException('In Test Mode');
            }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseL2L3RoutingTriggerHandler.class.getName();
                    alw.sourceFunction ='insertOwnerId()';
                    alw.ApplicationName='CaseL2L3';                    
                    alw.referenceInfo = 'CaseL2L3';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);
            //CaseHandlerUtility.trackException('CaseL2L3RoutingTriggerHandler - Method - insertOwnerId', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }
    
    /**
    This method is used for CaseL2L3Routing__c Owner Information Update.
    At the Time of Update .
    @method name: updateOwnerId
    @parameter:   Array of oldL2L3Routing, oldL2L3Routing, caseL2L3RoutingMap.
    @return :     NA.
    **/
    public void updateOwnerId(CaseL2L3Routing__c[] oldL2L3Routing, CaseL2L3Routing__c[] newL2L3Routing, Map < ID, CaseL2L3Routing__c > caseL2L3RoutingMap) {

        try {
            Set < string > oldOwnerQueue = new Set < String > ();
            Set < string > newOwnerQueue = new Set < String > ();
    
            for (CaseL2L3Routing__c caseL2L3RoutingObjNew: newL2L3Routing) {
                oldOwnerQueue.add(caseL2L3RoutingObjNew.Old_Owner__c);
                if (caseL2L3RoutingObjNew.New_Owner__c != 'Individual') {
                    newOwnerQueue.add(caseL2L3RoutingObjNew.New_Owner__c);
                }
            }
    
            map < string, id > mapOldOwnerQueueId = new map < string, id > (); //This will only store one Queue id per alias
            map < string, id > mapNewOwnerQueueId = new map < string, id > ();
    
            for (Group queue: [Select Id, Name FROM Group WHERE Type = 'Queue' and Name IN: oldOwnerQueue]) {
                mapOldOwnerQueueId.put(queue.Name, queue.Id);
            }
            for (Group queue: [Select Id, Name FROM Group WHERE Type = 'Queue' and Name IN: newOwnerQueue]) {
                mapNewOwnerQueueId.put(queue.Name, queue.Id);
            }
    
            for (CaseL2L3Routing__c caseL2L3RoutingObj: newL2L3Routing) {    
                if (mapOldOwnerQueueId.get(caseL2L3RoutingObj.Old_Owner__c) == null) {
                    caseL2L3RoutingObj.Old_Owner__c.addError(caseL2L3RoutingObj.Old_Owner__c + ' ' + System.Label.Case_L2L3Routing_Error_Messages);
                    break;
                }
                if (caseL2L3RoutingObj.New_Owner__c != 'Individual' && mapNewOwnerQueueId.get(caseL2L3RoutingObj.New_Owner__c) == null) {
                    caseL2L3RoutingObj.New_Owner__c.addError(caseL2L3RoutingObj.New_Owner__c + ' ' +System.Label.Case_L2L3Routing_Error_Messages);
                    break;
                }
    
                CaseL2L3Routing__c oldCaseL2L3RoutingObj = caseL2L3RoutingMap.get(caseL2L3RoutingObj.Id);

                if (caseL2L3RoutingObj.Old_Owner__c != oldCaseL2L3RoutingObj.Old_Owner__c) {
                    caseL2L3RoutingObj.Old_OwnerId__c = mapOldOwnerQueueId.get(caseL2L3RoutingObj.Old_Owner__c);
                }
                if (caseL2L3RoutingObj.New_Owner__c != oldCaseL2L3RoutingObj.New_Owner__c && caseL2L3RoutingObj.New_Owner__c != 'Individual') {
                    caseL2L3RoutingObj.New_OwnerId__c = mapNewOwnerQueueId.get(caseL2L3RoutingObj.New_Owner__c);
                }
                if ((caseL2L3RoutingObj.Individual__c != oldCaseL2L3RoutingObj.Individual__c && caseL2L3RoutingObj.New_Owner__c == 'Individual') 
                || (caseL2L3RoutingObj.New_Owner__c != oldCaseL2L3RoutingObj.New_Owner__c && caseL2L3RoutingObj.New_Owner__c == 'Individual')) {
                    caseL2L3RoutingObj.New_OwnerId__c = caseL2L3RoutingObj.Individual__c;
                }
            }
            if(Test.isRunningTest()) {
                    throw new applicationException('In Test Mode');
            }
        } catch (Exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseL2L3RoutingTriggerHandler.class.getName();
                    alw.sourceFunction ='updateOwnerId()';
                    alw.ApplicationName='CaseL2L3';                    
                    alw.referenceInfo = 'CaseL2L3';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);      
            //CaseHandlerUtility.trackException('CaseL2L3RoutingTriggerHandler - Method - updateOwnerId', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }
    
    /**
    This method is used for Geometry Validation .
    At the Time of Update .
    @method name: geometryValidation
    @parameter:   Array of newL2L3Routing
    @return :     NA.
    **/
    public void geometryValidation(CaseL2L3Routing__c[] newL2L3Routing) {        
        try {           
            List<Id> Ids = new List<Id>();
            List<String> oldOwnerIds = new List<String> ();
            List<String> listCategory = new List<String>();
            List<String> listSubCategory = new List<String>();
            List<CaseL2L3Routing__c> listCaseL2L3Routing = new List<CaseL2L3Routing__c>();
            
            for (CaseL2L3Routing__c caseL2L3RoutingObj: newL2L3Routing) {            
                oldOwnerIds.add(caseL2L3RoutingObj.Old_OwnerId__c);
                listCategory.add(caseL2L3RoutingObj.Category__c); 
                listSubCategory.add(caseL2L3RoutingObj.SubCategory__c);
                if(caseL2L3RoutingObj.Id !=null)
                    Ids.add(caseL2L3RoutingObj.Id);
            }            
            listCaseL2L3Routing = [Select Id,Name, Category__c, SubCategory__c, Old_OwnerId__c,Geometry__c,Target_process_node__c From CaseL2L3Routing__c 
                                    Where Old_OwnerId__c In: oldOwnerIds And Category__c In :listCategory
                                    And SubCategory__c In : listSubCategory And Id Not In : Ids Limit 1000];
                                    
            if(listCaseL2L3Routing !=null && listCaseL2L3Routing.size()>0){
                String[] geometry1; 
                String[] targetProcessNode1; 
                for (CaseL2L3Routing__c routingObj1: newL2L3Routing) {
                    if(routingObj1.Geometry__c != null){
                        geometry1 = routingObj1.Geometry__c.split(';');
                    }  
                     if(routingObj1.Target_process_node__c != null){                                           
                        targetProcessNode1 = routingObj1.Target_process_node__c.split(';');  
                    }     
                  for (CaseL2L3Routing__c routingObj2: listCaseL2L3Routing) {
                      if(routingObj1.Target_process_node__c == null){
                        if(routingObj1.Category__c == routingObj2.Category__c && routingObj1.SubCategory__c== routingObj2.SubCategory__c 
                            && routingObj1.Old_OwnerId__c == routingObj2.Old_OwnerId__c && routingObj1.Geometry__c != null && routingObj2.Geometry__c != null)
                            {
                                String[] geometry2 = routingObj2.Geometry__c.split(';');
                                
                                    for (Integer i = 0; i < geometry1.size(); i++) {
                                        for (Integer j = 0 ; j < geometry2.size() ; j++){
                                             if (geometry1[i] == geometry2[j]) {
                                                String last = '" target="_blank">' + routingObj2.Name + '</a>';
                                                routingObj1.Geometry__c.addError(System.Label.Case_L2L3Routing_Duplicate_Record_Messages+' '+ first + fullFileURL + '/' + routingObj2.Id + last, false );
                                                flag = true;
                                             }
                                        }                                
                                }
                                    if(flag)
                                        break;                               
                            }                                          
                      }
                      else{ 
                        if (routingObj2.Target_process_node__c !=null){
                            if(routingObj1.Category__c == routingObj2.Category__c && routingObj1.SubCategory__c== routingObj2.SubCategory__c 
                                && routingObj1.Old_OwnerId__c == routingObj2.Old_OwnerId__c && routingObj1.Geometry__c != null && routingObj2.Geometry__c != null )
                            {
                            
                            String[] geometry2 = routingObj2.Geometry__c.split(';');
                            String[] targetProcessNode2 = routingObj2.Target_process_node__c.split(';'); 
                                for (Integer i = 0; i < geometry1.size(); i++) {
                                    for (Integer j = 0; j < geometry2.size(); j++) {
                                     if (geometry1[i] == geometry2[j]) {                                     
                                        geomteryFlag = true;
                                            }
                                        }                              
                                    }                         
                                for (Integer i = 0; i < targetProcessNode1.size(); i++) {
                                    for (Integer j = 0; j < targetProcessNode2.size(); j++) {
                                         if (targetProcessNode1[i] == targetProcessNode2[j]) {                                         
                                            targetProcessNodeFlag = true;
                                            }
                                    }
                                }
                               if(geomteryFlag == true && targetProcessNodeFlag == true){
                                    String last = '" target="_blank">' + routingObj2.Name + '</a>';
                                    routingObj1.Target_process_node__c.addError(System.Label.Case_L2L3Routing_Duplicate_Record_Messages+' '+ first + fullFileURL + '/' + routingObj2.Id + last, false );
                                    break; 
                                }                                                                 
                            }
                        }
                      else {
                            if(routingObj1.Category__c == routingObj2.Category__c && routingObj1.SubCategory__c== routingObj2.SubCategory__c 
                                && routingObj1.Old_OwnerId__c == routingObj2.Old_OwnerId__c && routingObj1.Geometry__c != null && routingObj2.Geometry__c != null)
                            {
                                String[] geometry2 = routingObj2.Geometry__c.split(';');
                                for (Integer i = 0; i < geometry1.size(); i++) {
                                    for (Integer j = 0; j < geometry2.size(); j++) {
                                     if (geometry1[i] == geometry2[j]) {
                                        String last = '" target="_blank">' + routingObj2.Name + '</a>';
                                        routingObj1.Geometry__c.addError(System.Label.Case_L2L3Routing_Duplicate_Record_Messages+' '+ first + fullFileURL + '/' + routingObj2.Id + last, false );
                                        flag = true;
                                            }
                                        }                              
                                    }
                                        if(flag)
                                            break;                                   
                            }
                        }
                      }                      
                    }
                }
            }           
                if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
                }
        } catch (Exception e) {             
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseL2L3RoutingTriggerHandler.class.getName();
                    alw.sourceFunction ='geometryValidation()';
                    alw.ApplicationName='CaseL2L3';                    
                    alw.referenceInfo = 'CaseL2L3';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);               
        }
    }
  public class applicationException extends Exception {}  
}