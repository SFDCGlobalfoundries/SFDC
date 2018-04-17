/**
* Author        :   Ravikiran Nadella
* Description   :  this is used as standard controller extension  for LotRequestEdit page  .
* History       :
        Initials        Date                Description
-----------------------------------------------------------------------------------------
             
        RNadella        31/08/2015          Created the class                                   
**/
public with sharing class LotRequestEditControllerExt {
 public ApexPages.StandardController cont;
 public Lot_Request__c lotREquest{get;set;}
 // this is to re-render pricing fields 
 public boolean pDetails{get;set;}
 public string editable{get;set;}
 public string closedVoid{get;set;}

 

   //Constructor
    public LotRequestEditControllerExt(ApexPages.StandardController controller) {
    cont=controller;
    lotREquest = (Lot_Request__c)controller.getRecord();
    string stdRecId=Schema.SObjectType.Lot_Request__c.getRecordTypeInfosByName().get('Standard Lot Service Request').getRecordTypeId();
    if(apexpages.currentpage().getparameters().get('RecordType')==stdRecId.subString(0,15)){
     pDetails=true;
    }
    
    if(lotREquest.Lot_Request_Type__c=='Standard Expedite'){
       pDetails=true;
    }
     if(lotREquest.stage__c=='Submitted for Review by Expedite Manager' || lotREquest.stage__c== 'Pending Planner Response' || lotREquest.stage__c== 'Closed - Void' ){
       editable='Allow';
       if(lotREquest.stage__c== 'Closed - Void'){
       closedVoid='Closed';
       }
    }
    }
    
    //Custom save and new functionality 
    public pageReference saveandNew(){
    
        cont.save();
        PageReference pageRef = new PageReference('/a5b/e');
        pageRef.setRedirect(true);

        return pageRef; 
     } 
    
}