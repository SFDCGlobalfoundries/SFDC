/*-----------------------------------------------------------------------------------------------------------------------------------
Page:          DeviceChecklistProject_Task_Extn
-------------------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  18/07/2014
Reason:        This is an inline visualforce page to setup task dependency on Device or Opportunity
               (*) Streamlines and drived valid data entry to the following task fields:
                   (1) Dependent_Object__c
                   (2) Dependent_Field__c
                   (3) Dependent_Field_Type__c
                   (4) Dependent_Field_Completed_Value__c

Change Log:    Created     -     JOYDEV     -     18/07/2014 
Change Log:    Updated     -     JOYDEV     -     21/07/2014
               [Reason]:   Add textbox to Dependency setup for Tooltip Text (Automatically populated with following format, 
                           if required user can change the text):
                            
                           TEMPLATE:
                           This task "will be"/"is" completed if {{Object}}'s field {{filed lable}} is {{completed value}}
                          
                           Examples:
                           1. This task will be/is completed if Device's filed "Forecasted GDSII Date" is "NOT NULL"
                           2. This task will be/is completed if Device's filed "Market Segment" is "Automobile"
                           3. This task will be/is completed if Device's filed "IP Gap" is "true"
                Updated     -     Sreedhar   -     10/02/2014
                [Reason]   Removed TASKRAY Application Objects Dependency       
-------------------------------------------------------------------------------------------------------------------------------------*/

public without sharing class DeviceChecklistProject_Task_Extn {
    
    /*edit mode flag*/
    public Boolean EditMode { get; set; }
    
    /*Dependent_Field_Completed_Value__c placeholce with variable datatypes*/
    public String SValue { get; set; }
    
    /*__NOTNULL condition place holder*/
    public Boolean NOTNULLValue { get; set; }
    public Static final String NotNullVal = '__NOTNULL';
    public Static final String NotNullLabel = 'NOT-NULL';
    
    /*current task record passed in as url parameter (?id=)*/
    public Checklist_Task__c CurrentTask { get; set; }
    
    /*dependent object select options*/
    public Map<String, SelectOption> DependentObjects { 
        get {
            Map<String, SelectOption> options = new Map<String, SelectOption>();
            
            for(Schema.FieldSetMember f : 
                    Schema.SObjectType.Checklist_Container__c.fieldSets.DeviceChecklistSyncTaskFieldSet.getFields()) {
                options.put(f.getFieldPath(), new SelectOption(f.getFieldPath(), f.getLabel()));
            }
            
            return options;
        }
    }
    
    /*dependent object select options values*/
    public List<SelectOption> DependentObjectValues { 
        get {
            return DependentObjects.Values();
        }
    }

    /*get object select option label*/
    public String DependentObjectLabel { 
        get {
            String szLabel = '--None--';
            if(DependentObjects.containsKey(CurrentTask.Dependent_Object__c)) {
                szLabel = DependentObjects.get(CurrentTask.Dependent_Object__c).getLabel();
            }        
            return szLabel;
        }
    }    
        
    /*dependent object fields select options*/
    public Map<String, SelectOption> DependentFields { 
        get {
            Map<String, SelectOption> options = new Map<String, SelectOption>();
            
            if(CurrentTask.Dependent_Object__c != Null && CurrentTask.Dependent_Object__c != '--None--') {
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                String objName = CurrentTask.Dependent_Object__c;
                Schema.SObjectType objSchema = schemaMap.get((Schema.getGlobalDescribe().containsKey(objName) ? 
                                                              objName : objName.replace('__c', '')));
                Schema.DescribeSObjectResult objDesc = objSchema.getDescribe();
                Map<String, Schema.SObjectField> fieldMap = objDesc.fields.getMap();
                
                for (String f: fieldMap.keySet()) {
                    Schema.DescribeFieldResult fRslt = fieldMap.get(f).getDescribe();
                    options.put(f, new SelectOption(f, fRslt.getLabel()));  
                } 
            }
            
            return options;
        }
    }
    
    /*dependent object fields select options values*/
    public List<SelectOption> DependentFieldValues { 
        get {
            return DependentFields.Values();
        }
    }
    
    /*get object field select option label*/
    public String DependentFieldLabel { 
        get {
            String szLabel = '--None--';
            if(DependentFields.containsKey(CurrentTask.Dependent_Field__c)) {
                szLabel = DependentFields.get(CurrentTask.Dependent_Field__c).getLabel();
            }        
            return szLabel;
        }
    }
        
    /*dependent object fields select options*/
    public List<SelectOption> DependentPicklistFieldOptions { 
        get {
            List<SelectOption> options = new List<SelectOption>();
            
            if(CurrentTask.Dependent_Object__c != Null && CurrentTask.Dependent_Object__c != '--None--' &&
               CurrentTask.Dependent_Field__c != Null && CurrentTask.Dependent_Field__c != '--None--' &&
               (CurrentTask.Dependent_Field_Type__c == 'Picklist' || CurrentTask.Dependent_Field_Type__c == 'MultiPicklist')) {
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                String objName = CurrentTask.Dependent_Object__c;
                Schema.SObjectType objSchema = schemaMap.get((Schema.getGlobalDescribe().containsKey(objName) ? 
                                                              objName : objName.replace('__c', '')));
                Schema.DescribeSObjectResult objDesc = objSchema.getDescribe();
                Map<String, Schema.SObjectField> fieldMap = objDesc.fields.getMap();
                Schema.DescribeFieldResult fRslt = fieldMap.get(CurrentTask.Dependent_Field__c).getDescribe();
                
                List<Schema.PicklistEntry> ple = fRslt.getPicklistValues();
                    
                for( Schema.PicklistEntry f : ple) {
                    options.add(new SelectOption(f.getLabel(), f.getValue()));
                } 
            }
            
            return options;
        }
    }
    
    /** 
    *  Constructor:    DeviceChecklistProject_Task_Extn
    *  args:           controller
    *  purpose:        this constructor initializes the following: 
    *                      (1) CurrentTask 
    **/
    public DeviceChecklistProject_Task_Extn(ApexPages.StandardController controller) {
        resetTask(ApexPages.currentPage().getParameters().get('id'));
    }
    
    /** 
    *  method:         resetTask
    *  args:           none
    *  return type:    none
    *  purpose:        this method resets the current task values;
    **/
    public void resetTask(Id tskId) {
        EditMode = False;
        
        CurrentTask = [Select Id, 
                              Name, 
                              Dependent_Object__c,
                              Dependent_Field__c,
                              Dependent_Field_Type__c,
                              Dependent_Field_Completed_Value__c,
                              DateTime_Place_Holder__c,
                              Date_Place_Holder__c,
                              Text_Place_Holder__c,
                              TextArea_Place_Holder__c,
                              Dependency_Tootip__c
                         From Checklist_Task__c
                        WHERE Id =:tskId];
        
        /*initiale completed value place holder with Dependent_Field_Completed_Value__c 
         field of current task record*/
        SValue = CurrentTask.Dependent_Field_Completed_Value__c;
        
        NOTNULLValue = (CurrentTask.Dependent_Field_Completed_Value__c == NotNullVal ? True : False);       
    } 
    
    /** 
    *  method:         cancel_Extn
    *  args:           none
    *  return type:    PageReference
    *  purpose:        this method cancels the updates and reverts back to yhe last saved values
    **/
    public PageReference cancel_Extn() {
        resetTask(CurrentTask.Id);
        return Null;       
    }   
    
    /** 
    *  method:         save_Extn
    *  args:           none
    *  return type:    PageReference
    *  purpose:        this method updates the task with selected values in dependency setup fields
    **/
    public PageReference save_Extn() {
        if(EditMode) {
            EditMode = False;        
            if(CurrentTask.Dependent_Object__c != Null && CurrentTask.Dependent_Object__c != '--None--' &&
                CurrentTask.Dependent_Field__c != Null && CurrentTask.Dependent_Field__c != '--None--') {
                if(CurrentTask.Dependency_Tootip__c == '' || CurrentTask.Dependency_Tootip__c == Null || NOTNULLValue) {
                    PopulateCompletedValueAndTooltip();
                }
                
                /*reset all placeholders on object change */
                CurrentTask.DateTime_Place_Holder__c = (CurrentTask.Dependent_Field_Type__c == 'DateTime' ?
                                                        CurrentTask.DateTime_Place_Holder__c : Null);
                CurrentTask.Date_Place_Holder__c = (CurrentTask.Dependent_Field_Type__c == 'Date' ?
                                                    CurrentTask.Date_Place_Holder__c : Null);
                CurrentTask.Text_Place_Holder__c = (CurrentTask.Dependent_Field_Type__c == 'anytype' ||
                                                    CurrentTask.Dependent_Field_Type__c == 'base64' ||
                                                    CurrentTask.Dependent_Field_Type__c == 'Combobox' ||
                                                    CurrentTask.Dependent_Field_Type__c == 'DataCategoryGroupReference' ||
                                                    CurrentTask.Dependent_Field_Type__c == 'Email' ||
                                                    CurrentTask.Dependent_Field_Type__c == 'EncryptedString' ||
                                                    CurrentTask.Dependent_Field_Type__c == 'ID' ||
                                                    CurrentTask.Dependent_Field_Type__c == 'Reference' ||
                                                    CurrentTask.Dependent_Field_Type__c == 'String' ||
                                                    CurrentTask.Dependent_Field_Type__c == 'URL' ||
                                                    CurrentTask.Dependent_Field_Type__c == 'Currency' ||
                                                    CurrentTask.Dependent_Field_Type__c == 'Integer' ||
                                                    CurrentTask.Dependent_Field_Type__c == 'Phone' ||
                                                    CurrentTask.Dependent_Field_Type__c == 'Percent' ||
                                                    CurrentTask.Dependent_Field_Type__c == 'Double' ?
                                                    CurrentTask.Text_Place_Holder__c : Null);
                CurrentTask.TextArea_Place_Holder__c = (CurrentTask.Dependent_Field_Type__c == 'TextArea' ?
                                                        CurrentTask.TextArea_Place_Holder__c : Null);
            
                update CurrentTask;
                
                /*initiale completed value place holder with Dependent_Field_Completed_Value__c 
                 field of current task record*/
                SValue = CurrentTask.Dependent_Field_Completed_Value__c;
                
                NOTNULLValue = (CurrentTask.Dependent_Field_Completed_Value__c == NotNullVal ? True : False);
            }
        } else {
            EditMode = True;
        }          
            
        return null;
    }
    
    /** 
    *  method:         PopulateDependentFieldType
    *  args:           none
    *  return type:    PageReference
    *  purpose:        this is a utility method that builds field options based on the object selected in UI
    **/
    public PageReference PopulateDependentFieldType() {
        SValue = CurrentTask.Dependent_Field_Completed_Value__c = '';
        CurrentTask.Dependency_Tootip__c = '';
        CurrentTask.DateTime_Place_Holder__c = Null;
        CurrentTask.Date_Place_Holder__c = Null;
        CurrentTask.Text_Place_Holder__c = Null;
        CurrentTask.TextArea_Place_Holder__c = Null;
        
        NOTNULLValue=false;
        
        if(CurrentTask.Dependent_Field__c != Null && CurrentTask.Dependent_Field__c != '--None--') {
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            String objName = CurrentTask.Dependent_Object__c;
            Schema.SObjectType objSchema = schemaMap.get((Schema.getGlobalDescribe().containsKey(objName) ? 
                                                          objName : objName.replace('__c', '')));
            
            System.Debug('[DEBUG:JOYDEV] PopulateDependentFieldType > schemaMap = ' + schemaMap);
            System.Debug('[DEBUG:JOYDEV] PopulateDependentFieldType > CurrentTask.Dependent_Object__c = ' + 
                         CurrentTask.Dependent_Object__c);
            System.Debug('[DEBUG:JOYDEV] PopulateDependentFieldType > objSchema = ' + objSchema);
            
            Schema.DescribeSObjectResult objDesc = objSchema.getDescribe();
            Map<String, Schema.SObjectField> fieldMap = objDesc.fields.getMap();
            Schema.DescribeFieldResult fRslt = fieldMap.get(CurrentTask.Dependent_Field__c).getDescribe();
            Schema.DisplayType fielddataType = fRslt.getType();
            
            /*set the dependent field type of the task from the selected dependent field in UI*/
            CurrentTask.Dependent_Field_Type__c = 
                  (fielddataType == Schema.DisplayType.anytype ? 'anytype' : /*text*/
                   (fielddataType == Schema.DisplayType.base64 ? 'base64' : /*text*/
                    (fielddataType == Schema.DisplayType.Boolean ? 'Boolean' : /*----***----*/
                     (fielddataType == Schema.DisplayType.Combobox ? 'Combobox' : /*text*/
                      (fielddataType == Schema.DisplayType.Currency ? 'Currency' : /*number*/
                       (fielddataType == Schema.DisplayType.DataCategoryGroupReference ? 'DataCategoryGroupReference' : /*text*/
                        (fielddataType == Schema.DisplayType.Date ? 'Date' : /*date*/
                         (fielddataType == Schema.DisplayType.DateTime ? 'DateTime' : /*date-time*/
                          (fielddataType == Schema.DisplayType.Double ? 'Double' : /*number*/ 
                           (fielddataType == Schema.DisplayType.Email ? 'Email' : /*text*/
                            (fielddataType == Schema.DisplayType.EncryptedString ? 'EncryptedString' : /*text*/
                             (fielddataType == Schema.DisplayType.ID ? 'ID' : /*text*/
                              (fielddataType == Schema.DisplayType.Integer ? 'Integer' : /*number*/ 
                               (fielddataType == Schema.DisplayType.MultiPicklist ? 'MultiPicklist' : /*----***----*/
                                (fielddataType == Schema.DisplayType.Percent ? 'Percent' : /*number*/ 
                                 (fielddataType == Schema.DisplayType.Phone ? 'Phone' : /*number*/
                                  (fielddataType == Schema.DisplayType.Picklist ? 'Picklist' : /*----***----*/
                                   (fielddataType == Schema.DisplayType.Reference ? 'Reference' : /*text*/ 
                                    (fielddataType == Schema.DisplayType.String ? 'String' : /*text*/
                                     (fielddataType == Schema.DisplayType.TextArea ? 'TextArea' : /*text*/
                                      (fielddataType == Schema.DisplayType.Time ? 'Time' : /*datetime-local*/
                                       (fielddataType == Schema.DisplayType.URL ? 'URL' : /*text*/
                                        ''))))))))))))))))))))));
        }
                
        return Null;
    }
    
    /** 
    *  method:         ResetOnObjectChange
    *  args:           none
    *  return type:    PageReference
    *  purpose:        this method resets the Dependent_Field__c and Dependency_Tootip__c and 
    *                  DateTime_Place_Holder__c and Date_Place_Holder__c
    **/
    public PageReference ResetOnObjectChange() {
        CurrentTask.Dependent_Field__c = '--None--';
        CurrentTask.Dependency_Tootip__c = '';
        CurrentTask.DateTime_Place_Holder__c = Null;
        CurrentTask.Date_Place_Holder__c = Null;
        CurrentTask.Text_Place_Holder__c = Null;
        CurrentTask.TextArea_Place_Holder__c = Null;
        
        NOTNULLValue=false;
        
        return Null;
    }
    
    /** 
    *  method:         PopulateCompletedValueAndTooltip
    *  args:           none
    *  return type:    PageReference
    *  purpose:        this method constructs the tooltip text and populates the completed value
    **/
    public PageReference PopulateCompletedValueAndTooltip() {
        if(NOTNULLValue) {
            CurrentTask.Dependent_Field_Completed_Value__c = NotNullVal;
        } else {
            SValue = (SValue == NotNullVal ? '' : SValue);
            if(CurrentTask.Dependent_Field_Type__c == 'Date') {
                if(CurrentTask.Date_Place_Holder__c != Null) {
                    CurrentTask.Dependent_Field_Completed_Value__c = String.valueOf(CurrentTask.Date_Place_Holder__c).split(' ')[0];
                } else {
                    CurrentTask.Dependent_Field_Completed_Value__c = NotNullVal;
                }
            } else if(CurrentTask.Dependent_Field_Type__c == 'DateTime') {
                if(CurrentTask.DateTime_Place_Holder__c != Null) {
                    CurrentTask.Dependent_Field_Completed_Value__c = String.valueOf(CurrentTask.DateTime_Place_Holder__c).split(' ')[0];
                } else {
                    CurrentTask.Dependent_Field_Completed_Value__c = NotNullVal;
                }
            } else if(CurrentTask.Dependent_Field_Type__c == 'anytype' ||
                      CurrentTask.Dependent_Field_Type__c == 'base64' ||
                      CurrentTask.Dependent_Field_Type__c == 'Combobox' ||
                      CurrentTask.Dependent_Field_Type__c == 'DataCategoryGroupReference' ||
                      CurrentTask.Dependent_Field_Type__c == 'Email' ||
                      CurrentTask.Dependent_Field_Type__c == 'EncryptedString' ||
                      CurrentTask.Dependent_Field_Type__c == 'ID' ||
                      CurrentTask.Dependent_Field_Type__c == 'Reference' ||
                      CurrentTask.Dependent_Field_Type__c == 'String' ||
                      CurrentTask.Dependent_Field_Type__c == 'URL' ||
                      CurrentTask.Dependent_Field_Type__c == 'Currency' ||
                      CurrentTask.Dependent_Field_Type__c == 'Integer' ||
                      CurrentTask.Dependent_Field_Type__c == 'Phone' ||
                      CurrentTask.Dependent_Field_Type__c == 'Percent' ||
                      CurrentTask.Dependent_Field_Type__c == 'Double') {
                if(CurrentTask.Text_Place_Holder__c != Null && CurrentTask.Text_Place_Holder__c != '') {
                    CurrentTask.Dependent_Field_Completed_Value__c = String.valueOf(CurrentTask.Text_Place_Holder__c);
                } else {
                    CurrentTask.Dependent_Field_Completed_Value__c = NotNullVal;
                }
            } else if(CurrentTask.Dependent_Field_Type__c == 'TextArea') {
                if(CurrentTask.TextArea_Place_Holder__c != Null && CurrentTask.TextArea_Place_Holder__c != '') {
                    CurrentTask.Dependent_Field_Completed_Value__c = String.valueOf(CurrentTask.TextArea_Place_Holder__c );
                } else {
                    CurrentTask.Dependent_Field_Completed_Value__c = NotNullVal;
                }
            } else {
                CurrentTask.Dependent_Field_Completed_Value__c = SValue;
            }
        }
        
        CurrentTask.Dependent_Field_Completed_Value__c = 
            CurrentTask.Dependent_Field_Completed_Value__c.replace('--None--, ', '').replace('--None--', '');
        
        if(CurrentTask.Dependent_Field__c != Null && CurrentTask.Dependent_Field__c != '--None--' &&
           CurrentTask.Dependent_Object__c != Null && CurrentTask.Dependent_Object__c != '--None--') {
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            String objName = CurrentTask.Dependent_Object__c;
                Schema.SObjectType objSchema = schemaMap.get((Schema.getGlobalDescribe().containsKey(objName) ? 
                                                              objName : objName.replace('__c', '')));
            Schema.DescribeSObjectResult objDesc = objSchema.getDescribe();
            Map<String, Schema.SObjectField> fieldMap = objDesc.fields.getMap();
            Schema.DescribeFieldResult fRslt = fieldMap.get(CurrentTask.Dependent_Field__c).getDescribe();
        
            CurrentTask.Dependency_Tootip__c = 'This task "will be"/"is" completed if '
                                             + objDesc.getLabel() + '\'s field '
                                             + fRslt.getLabel() + ' is '
                                             + (NOTNULLValue || CurrentTask.Dependent_Field_Completed_Value__c == NotNullVal? 
                                                NotNullLabel : 
                                                CurrentTask.Dependent_Field_Completed_Value__c);
        } else {
            CurrentTask.Dependency_Tootip__c = '';
        }
        
        return Null;
    }
}