/*
    Author: Suvajit Majumder
    Description: Apex class called by the AgreementAfterUpdate Trigger. Uses the Geography and Department Name field to find and populate the Management NDA Notification field
    and GF NDA Signatory Field. This class is controlled by the custom setting 'NDA Record Types'.
    History: 
        
*/



public class NDAMgmtSignatoryPopulateClass 
{

   //Generic Utility that accepts API name of an object and a field in it and if it is picklist then returns String list of active values in it.    
           public static List<String> getPicklistOptions(Schema.SObjectType objType,String FieldAPIName)
            {
                List<SelectOption> options = new list<SelectOption>();
                List<String> StringOptions = new list<String>();
        
                
                
                // Describe the SObject using its object type.
                Schema.DescribeSObjectResult objDescribe = objType.getDescribe();   
        
                // Get a map of fields for the SObject
                Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
                
                
                Schema.DisplayType fielddataType = fieldMap.get(FieldAPIName).getDescribe().getType();
                
                //Determining if field paramter passed is a Picklist or not
                
                if(fielddataType == Schema.DisplayType.Picklist)
                    
                {        // Get the list of picklist values for this field.
                         List<Schema.PicklistEntry> values =
                         fieldMap.get(FieldAPIName).getDescribe().getPickListValues();
                         
                        // Add the values to the selectoption list.
                        for (Schema.PicklistEntry a : values)
                        { 
                        options.add(new SelectOption(a.getLabel(), a.getValue())); 
                        }
                        
                        //Converting SelectOptions to String
                        for(SelectOption s: options)
                        {
                            if(!s.getDisabled())    
                            StringOptions.add(s.getValue());
                        }   
                        
                }        
                return StringOptions;
            }
     
    
    
    public static void MgmtFieldPopulateMethod(Map<Id,Apttus__APTS_Agreement__c> OldRecords,Map<Id,Apttus__APTS_Agreement__c> NewRecords)
    {
        
        
        Map<Id,NDA_Record_Types__c> CstMap=new Map<Id,NDA_Record_Types__c>();
        
        for(NDA_Record_Types__c cst:NDA_Record_Types__c.getAll().values())
            if(!String.isBlank(cst.Record_Type_ID__c) && Pattern.compile('[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}').matcher(cst.Record_Type_ID__c).matches() &&  ( cst.Autofill_Mgmt_Notification__c || cst.Autofill_GF_NDA_Signatory__c))
                CstMap.put(cst.Record_Type_ID__c,cst);
                  
        Map<Id,Apttus__APTS_Agreement__c> ActualRecordsToProcess=new Map<Id,Apttus__APTS_Agreement__c>();
        
        for(Apttus__APTS_Agreement__c agr:NewRecords.values())
            if(CstMap.containsKey(agr.RecordTypeId))
                if(agr.TD_GN_Department_Name__c<>OldRecords.get(agr.id).TD_GN_Department_Name__c  || agr.GF_Signatory_Region__c<>OldRecords.get(agr.id).GF_Signatory_Region__c ||
                   agr.TD_GN_Management_NDA_notification__c<>OldRecords.get(agr.id).TD_GN_Management_NDA_notification__c ||  agr.GF_Signatory_type__c<>OldRecords.get(agr.id).GF_Signatory_type__c)
                        ActualRecordsToProcess.put(agr.id,agr);
                
        
        
        if(ActualRecordsToProcess.size()>0)
        {
                NDA_CLM_App_Settings__c cs = NDA_CLM_App_Settings__c.getInstance( UserInfo.GetUserID());        
                Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Apttus__APTS_Agreement__c');

                List<String> GeographyPicklist=getPicklistOptions(targetType ,'GF_Signatory_Region__c');
                List<String> DeptNamePicklist =getPicklistOptions(targetType ,'TD_GN_Department_Name__c');

              
             
             
             Set<String> GeoSet=new Set<String>();
             List<String> KeyWordList =new List<String>();
                 
             for(Apttus__APTS_Agreement__c agr: ActualRecordsToProcess.values())
             {
                 if(String.isBlank(agr.GF_Signatory_Region__c) || String.isBlank(agr.TD_GN_Department_Name__c))
                      return;  //if Geography or Department Name is not available then go back,do nothing
                    
                    else
                    {
                        GeoSet.add('%'+Pattern.compile('[^a-zA-Z0-9]').matcher(agr.GF_Signatory_Region__c).replaceAll('').toUpperCase()+'%');
                        KeyWordList.add(Pattern.compile('[^a-zA-Z0-9]').matcher(agr.GF_Signatory_Region__c).replaceAll('').toUpperCase()+Pattern.compile('[^a-zA-Z0-9]').matcher(agr.TD_GN_Department_Name__c).replaceAll('').toUpperCase()); 
                        
                    }
             }

               
            
          

            Map<Id,String> TempMgmtMap=new Map<Id,String>();
            Map<Id,String> TempSigyMap=new Map<Id,String>();
            
            
            
            
            for(TD_GN_Business_Reviewer__c var: [select id,Name from TD_GN_Business_Reviewer__c where Name like :GeoSet])  
                       for(String str: KeyWordList)
                           if(Pattern.compile('[^a-zA-Z0-9]').matcher(var.Name).replaceAll('').toUpperCase().contains(str))
                               TempMgmtMap.put(var.id,Pattern.compile('[^a-zA-Z0-9]').matcher(var.Name).replaceAll('').toUpperCase());
            
            for(GF_NDA_Signatories__c var: [select id,Name from GF_NDA_Signatories__c where Name like :GeoSet])   
                    for(String str: KeyWordList)
                           if(Pattern.compile('[^a-zA-Z0-9]').matcher(var.Name).replaceAll('').toUpperCase().contains(str))
                               TempSigyMap.put(var.id,Pattern.compile('[^a-zA-Z0-9]').matcher(var.Name).replaceAll('').toUpperCase()); 
                   
            
            Map<String,Map<Id,String>> MasterMgmtMap=new Map<String,Map<Id,String>>();
            Map<String,Map<Id,String>> MasterSigMap=new Map<String,Map<Id,String>>();  
            
            Map<Id,String> TmpMap=new Map<Id,String>();
            
            
            //build the maps of keywords and map of corresponding records from the objects
            for(String str:KeyWordList)
            {
                TmpMap=new Map<Id,String>();
                for(Id i:TempMgmtMap.keySet())
                {
                    if(TempMgmtMap.get(i).contains(str))
                        TmpMap.put(i,TempMgmtMap.get(i));
                }
                MasterMgmtMap.put(str,TmpMap);
                
                
                
                TmpMap=new Map<Id,String>();
                for(Id i:TempSigyMap.keySet())
                {
                    if(TempSigyMap.get(i).contains(str))
                        TmpMap.put(i,TempSigyMap.get(i));
                }
                MasterSigMap.put(str,TmpMap);
                
            }   
          
          
                      
                        
            for(Apttus__APTS_Agreement__c agr: ActualRecordsToProcess.values())
            {
                    Map<Id,String> TempMap=new Map<Id,String>();
                    List<ID> TempList=new List<ID>();
                                     
                                      
                   if(CstMap.containsKey(agr.RecordTypeId))
                    {   
                        if(CstMap.get(agr.RecordTypeID).Autofill_Mgmt_Notification__c) 
                            {
                               if(String.isBlank(agr.TD_GN_Management_NDA_notification__c))
                                   {
                                       if(MasterMgmtMap.containsKey(Pattern.compile('[^a-zA-Z0-9]').matcher(agr.GF_Signatory_Region__c).replaceAll('').toUpperCase()+Pattern.compile('[^a-zA-Z0-9]').matcher(agr.TD_GN_Department_Name__c).replaceAll('').toUpperCase()))
                                          {
                                              TempMap=new Map<Id,String>();
                                              TempMap=MasterMgmtMap.get(Pattern.compile('[^a-zA-Z0-9]').matcher(agr.GF_Signatory_Region__c).replaceAll('').toUpperCase()+Pattern.compile('[^a-zA-Z0-9]').matcher(agr.TD_GN_Department_Name__c).replaceAll('').toUpperCase());
                                              if(TempMap.size()==1)
                                                  {                                                 
                                                      TempList.addAll(TempMap.keySet());
                                                      agr.TD_GN_Management_NDA_notification__c=TempList[0];
                                                      TempList.clear();
                                                      
                                                  }
                                               else if(TempMap.size()>1)
                                               {
                                                    if(!cs.Disable_Trigger_Validation__c)
                                                       agr.TD_GN_Management_NDA_notification__c.addError('There are multiple entries for the \'Management NDA notification\' based on your selected Geography and Department. Please select manually.');
                                               }
                                                else if(TempMap.size()==0)
                                                {
                                                    if(!cs.Disable_Trigger_Validation__c)
                                                       agr.TD_GN_Management_NDA_notification__c.addError('No values can be identified for \'Management NDA Notification\' based on your selected Geography and Department.. Please populate manually.');
                                                }       
                                           }
                                                             
                                  }
                                   if(!String.isBlank(agr.TD_GN_Management_NDA_notification__c))
                                   {
                                       if(MasterMgmtMap.containsKey(Pattern.compile('[^a-zA-Z0-9]').matcher(agr.GF_Signatory_Region__c).replaceAll('').toUpperCase()+Pattern.compile('[^a-zA-Z0-9]').matcher(agr.TD_GN_Department_Name__c).replaceAll('').toUpperCase()))
                                          {
                                              TempMap=new Map<Id,String>();
                                              TempMap=MasterMgmtMap.get(Pattern.compile('[^a-zA-Z0-9]').matcher(agr.GF_Signatory_Region__c).replaceAll('').toUpperCase()+Pattern.compile('[^a-zA-Z0-9]').matcher(agr.TD_GN_Department_Name__c).replaceAll('').toUpperCase());
                                              if(TempMap.size()==1 && agr.TD_GN_Management_NDA_notification__c==OldRecords.get(agr.id).TD_GN_Management_NDA_notification__c)
                                                  {                                                 
                                                      TempList.addAll(TempMap.keySet());
                                                      agr.TD_GN_Management_NDA_notification__c=TempList[0];
                                                      TempList.clear();
                                                      
                                                  }
                                               else if(TempMap.size()>1)
                                               {
                                                    if(agr.TD_GN_Management_NDA_notification__c==OldRecords.get(agr.id).TD_GN_Management_NDA_notification__c)
                                                    {
                                                        if(!cs.Disable_Trigger_Validation__c)
                                                            agr.TD_GN_Management_NDA_notification__c.addError('There are multiple entries for the \'Management NDA notification\' based on your selected Geography and Department. Please select manually.');
                                                    }
                                                    else if(agr.TD_GN_Management_NDA_notification__c<>OldRecords.get(agr.id).TD_GN_Management_NDA_notification__c)
                                                    {
                                                        TempMap=new Map<Id,String>();
                                                        TempMap=MasterMgmtMap.get(Pattern.compile('[^a-zA-Z0-9]').matcher(agr.GF_Signatory_Region__c).replaceAll('').toUpperCase()+Pattern.compile('[^a-zA-Z0-9]').matcher(agr.TD_GN_Department_Name__c).replaceAll('').toUpperCase());
                                                        if(!TempMap.containsKey(agr.TD_GN_Management_NDA_notification__c))
                                                            if(!cs.Disable_Trigger_Validation__c)
                                                                agr.TD_GN_Management_NDA_notification__c.addError('Incorrect value is chosen. Please choose correctly based upon the Geography and Department Name and one among the correct values.');
                                                    }       
                                               }
                                                else if(TempMap.size()==0 && agr.TD_GN_Management_NDA_notification__c==OldRecords.get(agr.id).TD_GN_Management_NDA_notification__c)
                                                {
                                                    if(!cs.Disable_Trigger_Validation__c)
                                                       agr.TD_GN_Management_NDA_notification__c.addError('No values can be identified for \'Management NDA Notification\' based on your selected Geography and Department.. Please populate manually.');
                                                }       
                                           }
                                                             
                                  } 




                                  
            
                            }  
                            
                            if(CstMap.get(agr.RecordTypeID).Autofill_GF_NDA_Signatory__c) 
                            {
                               if(String.isBlank(agr.GF_Signatory_type__c))
                                   {
                                       if(MasterSigMap.containsKey(Pattern.compile('[^a-zA-Z0-9]').matcher(agr.GF_Signatory_Region__c).replaceAll('').toUpperCase()+Pattern.compile('[^a-zA-Z0-9]').matcher(agr.TD_GN_Department_Name__c).replaceAll('').toUpperCase()))
                                          {
                                              TempMap=new Map<Id,String>();
                                              TempMap=MasterSigMap.get(Pattern.compile('[^a-zA-Z0-9]').matcher(agr.GF_Signatory_Region__c).replaceAll('').toUpperCase()+Pattern.compile('[^a-zA-Z0-9]').matcher(agr.TD_GN_Department_Name__c).replaceAll('').toUpperCase());
                                              if(TempMap.size()==1)
                                                  {                                                 
                                                      TempList.addAll(TempMap.keySet());
                                                      agr.GF_Signatory_type__c=TempList[0];
                                                      TempList.clear();
                                                  }
                                               else if(TempMap.size()>1)
                                               {
                                                    if(!cs.Disable_Trigger_Validation__c)
                                                       agr.GF_Signatory_type__c.addError('There are multiple entries for the \'GF Signatory Type\' based on your selected Geography and Department. Please select manually.');
                                               }
                                                else if(TempMap.size()==0)
                                                {
                                                    if(!cs.Disable_Trigger_Validation__c)
                                                       agr.GF_Signatory_type__c.addError('No values can be identified for \'GF Signatory Type\' based on your selected Geography and Department.. Please populate manually.');
                                                }       
                                           }
                                                             
                                  }


                                if(!String.isBlank(agr.GF_Signatory_type__c))
                                   {
                                       if(MasterSigMap.containsKey(Pattern.compile('[^a-zA-Z0-9]').matcher(agr.GF_Signatory_Region__c).replaceAll('').toUpperCase()+Pattern.compile('[^a-zA-Z0-9]').matcher(agr.TD_GN_Department_Name__c).replaceAll('').toUpperCase()))
                                          {
                                              TempMap=new Map<Id,String>();
                                              TempMap=MasterSigMap.get(Pattern.compile('[^a-zA-Z0-9]').matcher(agr.GF_Signatory_Region__c).replaceAll('').toUpperCase()+Pattern.compile('[^a-zA-Z0-9]').matcher(agr.TD_GN_Department_Name__c).replaceAll('').toUpperCase());
                                              if(TempMap.size()==1 && agr.GF_Signatory_type__c==OldRecords.get(agr.id).GF_Signatory_type__c)
                                                  {                                                 
                                                      TempList.addAll(TempMap.keySet());
                                                      agr.GF_Signatory_type__c=TempList[0];
                                                      TempList.clear();
                                                      
                                                  }
                                               else if(TempMap.size()>1)
                                               {
                                                    if(agr.GF_Signatory_type__c==OldRecords.get(agr.id).GF_Signatory_type__c)
                                                    {
                                                        if(!cs.Disable_Trigger_Validation__c)
                                                            agr.GF_Signatory_type__c.addError('There are multiple entries for the \'GF Signatory Type\' based on your selected Geography and Department. Please select manually.');
                                                    }
                                                    else if(agr.GF_Signatory_type__c<>OldRecords.get(agr.id).GF_Signatory_type__c)
                                                    {
                                                        TempMap=new Map<Id,String>();
                                                        TempMap=MasterSigMap.get(Pattern.compile('[^a-zA-Z0-9]').matcher(agr.GF_Signatory_Region__c).replaceAll('').toUpperCase()+Pattern.compile('[^a-zA-Z0-9]').matcher(agr.TD_GN_Department_Name__c).replaceAll('').toUpperCase());
                                                        if(!TempMap.containsKey(agr.GF_Signatory_type__c))
                                                            if(!cs.Disable_Trigger_Validation__c)
                                                                agr.GF_Signatory_type__c.addError('Incorrect value is chosen. Please choose correctly based upon the Geography and Department Name and one among the correct values.');
                                                    }       
                                               }
                                                else if(TempMap.size()==0 && agr.GF_Signatory_type__c==OldRecords.get(agr.id).GF_Signatory_type__c)
                                                {
                                                    if(!cs.Disable_Trigger_Validation__c)
                                                       agr.GF_Signatory_type__c.addError('No values can be identified for \'GF Signatory Type\' based on your selected Geography and Department.. Please populate manually.');
                                                }       
                                           }
                                                             
                                  } 




                                  
            
                            }
                            
                     }         
      
                    

        }

    }
}
}