/*
Type Name: AgreementUnRelateController
Author: Suvajit Majumder

Test Class: 
Change History:
Author: 
Modified Date: 
……..
……..//
--
*/

public with sharing class AgreementUnRelateController{

private final Id agrid;
public final Apttus__APTS_Agreement__c objAgr{get; set;}
public list<NDAWrapper> AgrLinkedList {get;set;}

    public AgreementUnRelateController() 
    {
        AgrLinkedList  = new list<NDAWrapper>();
        if(isNotBlank(ApexPages.currentPage().getParameters().get('Id'))) 
        {
            if(agrid==null)
                if(validateId(ApexPages.currentPage().getParameters().get('Id'))!=null)
                    agrid = ApexPages.currentPage().getParameters().get('Id');
            
            if(agrid!=null)
            {
                    if(objAgr ==null)
                        objAgr = [Select Id, Apttus__FF_Agreement_Number__c,Name,RecordTypeId from Apttus__APTS_Agreement__c where Id =: agrid];   
                    getAgrList();
                            
            }
        }     
    }
    
    
    public void getAgrList() 
    {
               
            transient list < Apttus__APTS_Agreement__c > listAgr = new list < Apttus__APTS_Agreement__c > ();
            if(AgrLinkedList !=null)
                AgrLinkedList.clear();
            
            listAgr = [SELECT Id,Name,Apttus__FF_Agreement_Number__c,GF_Department_Name__c,CLM_Contract_Type__c,Apttus__Status_Category__c, Apttus__Status__c ,CreatedBy.Id ,Apttus__Account__r.Name, Apttus__Account__c, GF_Contract_Start_Date__c,GF_Contract_End_Date__c,RecordTypeId,RecordType.Name,Owner.Name,CreatedDate,CreatedBy.Name,LastModifiedDate FROM Apttus__APTS_Agreement__c where id in (select Child_Level_Agreement__c from Linked_and_Associated_Contract__c where Top_Level_Agreement__c =:objAgr.id)];
            if(listAgr != null && listAgr.size()>0)
            {
                for(Apttus__APTS_Agreement__c agr : listAgr)
                {
                     AgrLinkedList.add(new NDAWrapper(false,agr));               
                }
            }
        else
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning, 'No Contract Records to Unlink from Parent.'));
                 
    }
    
    /**
    This method is used for Adding & Validating Agreement records
    @method name: add
    @parameter:   NA.
    @return :     NA.
    **/
    
    
    public PageReference remove() {
        
        Set<String> setTempIds = new Set<String>();
        transient List<Linked_and_Associated_Contract__c>      delinkerlist=new List<Linked_and_Associated_Contract__c>();
        
        transient List<Id> FirstSideListAgr = new List<Id>();
        transient List<Id> SecondSideListAgr= new List<Id>();
        
        PageReference pr = null; 
        integer agrCount = 0;
        try{
            if(!AgrLinkedList.isEmpty()) 
            {
                for(NDAWrapper agr : AgrLinkedList)
                {
                    if(agr.isChecked)
                    {
                        FirstSideListAgr.add(objAgr.id);
                        SecondSideListAgr.add(agr.objAgr.id);
                        agrCount ++;   
                    }
                }
            }
            
            
            if(agrCount == 0)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'No records were selected, please select at least one record to unlink.'));
            }
            else if(agrCount > 0)
            {      
                try
                {
                 delinkerlist=[select id from Linked_and_Associated_Contract__c where (Top_Level_Agreement__c  in :FirstSideListAgr and Child_Level_Agreement__c in :SecondSideListAgr) or (Top_Level_Agreement__c in :SecondSideListAgr and Child_Level_Agreement__c in :FirstSideListAgr)];          
                }
                catch(Exception e)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'No records could be found for unlinking. Contact your administrator for more information.'));
                } 
                    if(delinkerlist!=null && delinkerlist.size()>0)
                    {
                        delete delinkerlist;
                        pr = new PageReference('/'+agrid);                   
                    }
            }
        }Catch(Exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Error Occurred ' + e.getMessage()));}
         return pr;
    }
    
      /**
    This method is used for validating Agreement Ids & users Ids
    @method name: validateId
    @parameter:   String Agreement Id.
    @return :     String Agreement Id.
    **/
    static public String validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id)) {
            return id;
        }
        return null;
    }
    
    
    /***
    * isNotBlank- check the string null or blank
    ***/
    public static Boolean isNotBlank(String val){
        if(val <> null && val <> '' && val <> 'null'){
            return true;
        }
        return false;
    }
    
    public PageReference closeEvent() {        
        PageReference pr = new PageReference('/'+agrid);
        return pr;
    }
       
     /**
    This class is used for creating mapping between isChecked & Agreement Records.
    @Class name: NDAWrapper
    @parameter:   NA.
    @return :     NA.
    **/
    public class NDAWrapper
    {
        public boolean isChecked{get;set;}
        public Apttus__APTS_Agreement__c objAgr{get;set;}

        public NDAWrapper(boolean x,Apttus__APTS_Agreement__c y)
        {
            isChecked = x;
            objAgr = y;
        }
    }
}