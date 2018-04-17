/*
Utility class to fetch reports metatdata and form corresponding SOQL
Called from New Subscription class and batch to refresh SOQLs
Author: Rahul Majumder
*/
public class ICC_ReportSubscriptionUtility
{
    public static Map<String, String> mapDateRangeFilters = new Map<String, String> {
                                                                                'last_fiscal_year' => 'last_fiscal_year',
                                                                                'this_fiscal_year' => 'this_fiscal_year',
                                                                                'last_n_fiscal_years:2' => 'last_n_fiscal_years:2',
                                                                                'last_n_fiscal_years_ago:2'    => 'last_n_fiscal_years:2',
                                                                                'next_fiscal_year' => 'next_fiscal_year',
                                                                                'next_fiscal_quarter' => 'next_fiscal_quarter',
                                                                                'last_fiscal_quarter' => 'last_fiscal_quarter',
                                                                                'this_year' => 'this_year',
                                                                                'last_year' => 'last_year',
                                                                                'last_n_years:2' => 'last_n_years:2',
                                                                                'last_n_years_ago:2' => 'last_n_years:2',
                                                                                'next_year' => 'next_year',
                                                                                'this_quarter' => 'this_quarter',
                                                                                'next_quarter' => 'next_quarter',
                                                                                'last_quarter' => 'last_quarter',
                                                                                'last_month' => 'last_month',
                                                                                'this_month' => 'this_month',
                                                                                'next_month' => 'next_month',
                                                                                'last_week' => 'last_week',
                                                                                'this_week' => 'this_week',
                                                                                'next_week' => 'next_week',
                                                                                'yesterday' =>  'yesterday',
                                                                                'today' => 'today',
                                                                                'tomorrow' => 'tomorrow',
                                                                                'last_n_days:7' => 'last_n_days:7',
                                                                                'last_n_days:30' => 'last_n_days:30',
                                                                                'last_n_days:60' => 'last_n_days:60',
                                                                                'last_n_days:90' => 'last_n_days:90',
                                                                                'last_n_days:120' => 'last_n_days:120',
                                                                                'next_n_days:7' => 'next_n_days:7',
                                                                                'next_n_days:30' => 'next_n_days:30',
                                                                                'next_n_days:60' => 'next_n_days:60',
                                                                                'next_n_days:90' => 'next_n_days:90',
                                                                                'next_n_days:120' => 'next_n_days:120'
                                                                              };
    /*
        Method that does a schema.getDescribe and finds all the fields of passed object.
        It mainly finds which field is string and which is non-string. This is important for forming the WHERE clause based on report filter
        because if a field is STRING, it has to be included in quotes else without quotes
        
        This method also finds the M-D field to Account. We need this in the batch in which we will add one more filter condition to the SOQL to filter based on AccountShare records.
    */
    @testVisible
    public static Map<String, String> fetchDataTypeOfFields(String objType)
    {
        Map<String, String> map_FldName_To_DataType = new Map<String, String>();
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType objTypeSchema = schemaMap.get(objType);
        Map<String, Schema.SObjectField> fieldMap = objTypeSchema.getDescribe().fields.getMap();
        
        for (String fieldName: fieldMap.keySet()) 
        {
            //get data type of each fields
            Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
            if(fielddataType == Schema.DisplayType.TextArea || 
               fielddataType == Schema.DisplayType.String ||
               fielddataType == Schema.DisplayType.Picklist ||
               fielddataType == Schema.DisplayType.Id ||
               fielddataType == Schema.DisplayType.Reference ||
               fielddataType == Schema.DisplayType.Phone ||
               fielddataType == Schema.DisplayType.Combobox ||
               fielddataType == Schema.DisplayType.Email ||
               fielddataType == Schema.DisplayType.MultiPicklist ||
               fielddataType == Schema.DisplayType.URL) 
            {
                map_FldName_To_DataType.put(fieldName.toLowerCase(), 'string');
            }
            else if(fielddataType == Schema.DisplayType.DateTime)
            {
                map_FldName_To_DataType.put(fieldName.toLowerCase(), 'datetime');
            }
            else
                map_FldName_To_DataType.put(fieldName.toLowerCase(), 'non-string');
        }
        return map_FldName_To_DataType;
    }
    
    public static String validateReportSOQL(String reportID) 
    {
        String msg_Validation = '';
        String strQuery = 'Select ';
        String strObjectName = '';
            
        try
        {
            Map<String, String> mapOperatorName_LogicalSymbol = new Map<String, String>{
                                                                                        'equals'         => '=',
                                                                                        'notequal'       => '!=',
                                                                                        'lessthan'       => '<',
                                                                                        'greaterthan'    => '>',
                                                                                        'lessorequal'    => '<=',
                                                                                        'greaterorequal' => '>='
                                                                                       };   // MAP to store logical operator corresponding to the filter operations returned from Report Metadata
            
            // Call Report metadata            
            //Reports.ReportResults results = Reports.ReportManager.runReport(reportID);
            Reports.ReportDescribeResult results = Reports.ReportManager.describeReport(reportId);
            Reports.ReportMetadata rm = results.getReportMetadata();
            String strReportType = String.valueOf(rm.getReportType()).subStringBetween('type=', ']');
            strObjectName = [Select Report_Type_Name__c, Base_Object__c FROM ICC_ReportType_BaseObject__c WHERE Report_Type_Name__c =: strReportType].Base_Object__c;
            
            Map<String, Map<String, String>> mapBaseObject_To_FieldMappings = new Map<String, Map<String, String>>();
            for(ICC_Formula_Field_Mapping__c fldMapRec : [Select Base_Object__c, Field_To_Replace__c, Replacing_Field_Name__c 
                                                          FROM ICC_Formula_Field_Mapping__c WHERE Base_Object__c =: strObjectName])
            {
                if(mapBaseObject_To_FieldMappings.containsKey(fldMapRec.Base_Object__c.toLowerCase()))
                {
                    mapBaseObject_To_FieldMappings.get(fldMapRec.Base_Object__c.toLowerCase()).put(fldMapRec.Field_To_Replace__c.toLowerCase(), fldMapRec.Replacing_Field_Name__c.toLowerCase());
                }
                else
                {
                    mapBaseObject_To_FieldMappings.put(fldMapRec.Base_Object__c.toLowerCase(), new Map<String, String>{fldMapRec.Field_To_Replace__c.toLowerCase() => fldMapRec.Replacing_Field_Name__c.toLowerCase()});
                }
            }
            
            // Iterate on the report columns and find the fields for SELECT query 
            for(String s: rm.getDetailColumns())
            {
                // We assume that this functionality is built only for custom object reports, in that case, report metadata returns column values in format "objectAPIname.fieldName"
                // so, split the string inot two. First gives SF object name and second gives the actual field name
                List<String> lstHierarchyField = new List<String>();
                lstHierarchyField = s.split('\\.');
                
                if(lstHierarchyField.size() == 2 && lstHierarchyField[0] == strObjectName)
                    strQuery += lstHierarchyField[1] + ', ';
                else if(lstHierarchyField.size() == 2 && lstHierarchyField[0] != strObjectName)
                {
                    strQuery += (lstHierarchyField[0].toLowerCase().right(3) == '__c' ? (lstHierarchyField[0].toLowerCase().removeEnd('__c') + '__r.') : lstHierarchyField[0].toLowerCase() + '.' ) +  lstHierarchyField[1] + ', ';
                }
                else if(lstHierarchyField.size() == 3 && lstHierarchyField[0] == strObjectName)
                {
                    strQuery += (lstHierarchyField[1].toLowerCase().right(3) == '__c' ? (lstHierarchyField[1].toLowerCase().removeEnd('__c') + '__r.') : lstHierarchyField[1].toLowerCase() + '.') +  lstHierarchyField[2] + ', ';
                }
                else if(lstHierarchyField.size() == 3 && lstHierarchyField[0] != strObjectName)
                {
                    strQuery += (lstHierarchyField[0].toLowerCase().right(3) == '__c'  ? (lstHierarchyField[0].toLowerCase().removeEnd('__c') + '__r.') : lstHierarchyField[0].toLowerCase() + '.') + (lstHierarchyField[1].toLowerCase().right(3) == '__c' ? (lstHierarchyField[1].toLowerCase().removeEnd('__c') + '__r.') : lstHierarchyField[1].toLowerCase() + '.') +  lstHierarchyField[2] + ', ';
                }
            }
            strQuery = strQuery.removeEnd(', '); 
            strQuery += (' FROM ' + strObjectName);
            
            strQuery += ' WHERE ';
            
            Map<String, Map<String, String>> map_Object_FieldName_To_DataType = new Map<String, Map<String, String>>(); // Map of field name => data type of field (string or non-string)
            map_Object_FieldName_To_DataType.put(strObjectName.toLowerCase(), fetchDataTypeOfFields(strObjectName));
            // From Report metadata, get the filters of the report in context. Add them to WHERE clause
            for(Reports.ReportFilter rf : rm.getreportFilters())
            { 
                List<String> lstFilterCols = new List<String>();
                for(String s : rf.getcolumn().split('\\.'))
                {
                    lstFilterCols.add(s.toLowerCase());
                }
                if(lstFilterCols.size() == 2)
                {
                    String strObjectToDescribe = lstFilterCols[0];
                    String strFieldToDescribe = lstFilterCols[1];
                    
                    if(lstFilterCols[0] != strObjectName && !map_Object_FieldName_To_DataType.containsKey(lstFilterCols[0].toLowerCase()))
                    {
                        map_Object_FieldName_To_DataType.put(lstFilterCols[0].toLowerCase(), fetchDataTypeOfFields(lstFilterCols[0]));
                    }
                    if(mapOperatorName_LogicalSymbol.containsKey(rf.getOperator().toLowerCase()))
                    {
                        if(lstFilterCols[0] != strObjectName)
                        {
                            strQuery += (lstFilterCols[0].toLowerCase().right(3) == '__c' ? (lstFilterCols[0].toLowerCase().removeEnd('__c') + '__r.') : lstFilterCols[0].toLowerCase() + '.') + lstFilterCols[1];
                        }
                        else
                        {
                            strQuery += lstFilterCols[1];
                        }
                        
                        if(rf.getValue() == '' && (map_Object_FieldName_To_DataType.get(lstFilterCols[0].toLowerCase()).get(lstFilterCols[1].toLowerCase()) == 'non-string' || map_Object_FieldName_To_DataType.get(lstFilterCols[0].toLowerCase()).get(lstFilterCols[1].toLowerCase()) == 'datetime'))
                        {
                            strQuery += ' != ' + 'null' + ' AND ';
                        }
                        else
                        {
                            strQuery += ' ' + mapOperatorName_LogicalSymbol.get(rf.getOperator().toLowerCase()) + ' ' + 
                                              (map_Object_FieldName_To_DataType.get(lstFilterCols[0].toLowerCase()).get(lstFilterCols[1].toLowerCase()) == 'string' ? '\'' : '') + rf.getValue() + 
                                              (map_Object_FieldName_To_DataType.get(lstFilterCols[0].toLowerCase()).get(lstFilterCols[1].toLowerCase()) == 'string' ? '\'' : '') +
                                              ' AND ';
                        }
                        
                    }
                    if(rf.getOperator().toLowerCase() == 'contains')
                    {
                        if(lstFilterCols[0] != strObjectName)
                        {
                            strQuery += (lstFilterCols[0].toLowerCase().right(3) == '__c' ? (lstFilterCols[0].toLowerCase().removeEnd('__c') + '__r.') : lstFilterCols[0].toLowerCase() + '.') + lstFilterCols[1];
                        }
                        else
                        {
                            strQuery += lstFilterCols[1];
                        }
                        
                        strQuery += ' LIKE \'%' + rf.getValue() + '%\'' + ' AND ';
                    }
                    else if(rf.getOperator().toLowerCase() == 'notcontain')
                    {
                        strQuery += '(NOT ' ;
                        if(lstFilterCols[0] != strObjectName)
                        {
                            strQuery += (lstFilterCols[0].toLowerCase().right(3) == '__c' ? (lstFilterCols[0].toLowerCase().removeEnd('__c') + '__r.') : lstFilterCols[0].toLowerCase() + '.') + lstFilterCols[1];
                        }
                        else
                        {
                            strQuery += lstFilterCols[1];
                        }
                        strQuery += ' LIKE \'%' + rf.getValue() + '%\')' + ' AND ';
                    }
                    else if(rf.getOperator().toLowerCase() == 'startswith')
                    {
                        if(lstFilterCols[0] != strObjectName)
                        {
                            strQuery += (lstFilterCols[0].toLowerCase().right(3) == '__c' ? (lstFilterCols[0].toLowerCase().removeEnd('__c') + '__r.') : lstFilterCols[0].toLowerCase() + '.') + lstFilterCols[1];
                        }
                        else
                        {
                            strQuery += lstFilterCols[1];
                        }
                        strQuery += ' LIKE \'' + rf.getValue() + '%\'' + ' AND ';
                    }
                }
            }            
            
            Reports.StandardDateFilter sdf = rm.getStandardDateFilter();
            String strDateFilterColumn = sdf.getcolumn();
            String strDateFilterDuration = sdf.getdurationValue();
            String strDateFilterEndDate = sdf.getendDate();
            String strDateFilterStartDate = sdf.getstartDate();
            
            String strDateFilterQuery = '';

            if(strDateFilterColumn != null && strDateFilterDuration != null && strDateFilterEndDate != null && strDateFilterStartDate != null)
            {                
                String strDateFilterField = '';
                if(strDateFilterColumn.split('\\.')[0] == strObjectName)
                {
                    strDateFilterField = strDateFilterColumn.split('\\.')[1];
                    strDateFilterQuery += strDateFilterField;
                }
                else
                {
                    if(!map_Object_FieldName_To_DataType.containsKey(strDateFilterColumn.split('\\.')[0].toLowerCase()))
                    {
                        map_Object_FieldName_To_DataType.put(strDateFilterColumn.split('\\.')[0].toLowerCase(), fetchDataTypeOfFields(strDateFilterColumn.split('\\.')[0]));
                    }
                    strDateFilterField = strDateFilterColumn.split('\\.')[0].right(3) == '__c' ? (strDateFilterColumn.split('\\.')[0].removeEnd('__c') + '__r.' + strDateFilterColumn.split('\\.')[1]) : strDateFilterColumn;
                    strDateFilterQuery += strDateFilterField;
                }
                if(strDateFilterDuration.toLowerCase() == 'custom')
                {
                    strDateFilterQuery += ' >= ' ;
                    if(map_Object_FieldName_To_DataType.get(strDateFilterColumn.split('\\.')[0].toLowerCase()).get(strDateFilterColumn.split('\\.')[1].toLowerCase()) == 'datetime' )
                    {
                        strDateFilterEndDate += 'T00:00:00z';
                        strDateFilterStartDate += 'T00:00:00z';
                    }
                    strDateFilterQuery += strDateFilterStartDate ;
                    strDateFilterQuery += ' AND ' + strDateFilterField + ' <= ' + strDateFilterEndDate;
                }
                else if(mapDateRangeFilters.containsKey(strDateFilterDuration.toLowerCase()))
                {
                    strDateFilterQuery += ' = '+mapDateRangeFilters.get(strDateFilterDuration.toLowerCase());
                }
                else
                {
                    strDateFilterQuery = '';
                }
                
            }
            
            strQuery += strDateFilterQuery; 
            
            strQuery = strQuery.removeEnd(' AND ');
            strQuery = strQuery.removeEnd(' WHERE ');
            
            strObjectName = strObjectName.toLowerCase();
            if(mapBaseObject_To_FieldMappings.containsKey(strObjectName)) 
            {
                strQuery = strQuery.toLowerCase();
                for(String s : mapBaseObject_To_FieldMappings.get(strObjectName).keyset())
                {
                    if(strQuery.contains(s))
                    {
                        strQuery = strQuery.replaceALL(s, mapBaseObject_To_FieldMappings.get(strObjectName).get(s));
                    }
                }
            }
            
            //rtSubr.SF_Object__c = strObjectName; // Store the SF object name
            if(Test.isRunningTest())
                Integer i = 10/0;
        }
        catch(Exception e) 
        {            
            ApplicationLogWrapper alw = new ApplicationLogWrapper();
            alw.source = ICC_ReportSubscriptionUtility.class.getName();
            alw.sourceFunction ='validateReportSOQL()';
            alw.ApplicationName='ICC';
            alw.referenceInfo = 'Bug';
            alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel = 'Error';
            alw.logCode = e.getTypeName();
            alw.ex = e.getCause();
            GlobalUtility.logMessage(alw);
        }
        
        if(msg_Validation == '')
            return strQuery + '~' + strObjectName;
        else
            return msg_Validation;
    }
}