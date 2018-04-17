/*
    Author: Abhita Bansal
    Description: This Class is used to Update the Remaining Quantity in Wafer Allocation Object on Submit For Approval, 
                On Rejection of Form and on Final Approval
    History: 
    ABansal     11/22/2014 - Code Creation
    ABansal     11/25/2014 - Added the logic for the Remaining Quantity on Final Approval
    ABansal     11/28/2014 - Update the code for the Remaining Quantity for Fab7
    ABansal     12/09/2014 - Revert Back the changes for Fab 7
    ABansal     12/10/2014 - Correct the Code on Approval And Rejection
    ABansal     15/10/2014 - Update the code for Remaining Quantity for other Fab
*/
public class eWSRUpdateRemQuanClass{

    public static String getRecordTypeName(Id recordTypeId){
        RecordType rec = [Select Name from RecordType where Id =: recordTypeId LIMIT 1];
        return rec.name;
    }
    
    public static void updateRemQuanAfterSubmission(List<eWSR_Form__c> formsList){
        UtilClassToGetAllFields util = new UtilClassToGetAllFields();
        String formId;
        for(eWSR_Form__c ewsr: formsList){
            formId = ewsr.Id;
        }
        
        String formFields = util.getAllFields('eWSR_Form__c');
        String formQuery = 'select '+formFields+' from eWSR_Form__c where Id = \''+formId+'\'';
        eWSR_Form__c forms = new eWSR_Form__c();
        forms = database.query(formQuery);
        
        String monthName;
        Integer month = forms.Requested_Start_Date__c.month();
        if(month == 1){
            monthName = 'Jan';
        }else if (month == 2){
            monthName = 'Feb';
        }else if(month == 3){
            monthName = 'Mar';
        }else if(month == 4){
            monthName = 'Apr';
        }else if(month == 5){
            monthName = 'May';
        }else if(month == 6){
            monthName = 'Jun';
        }else if(month == 7){
            monthName = 'Jul';
        }else if(month == 8){
            monthName = 'Aug';
        }else if(month == 9){
            monthName = 'Sep';
        }else if(month == 10){
            monthName = 'Oct';
        }else if(month == 11){
            monthName = 'Nov';
        }else{
            monthName = 'Dec';
        }               
        Integer remDate;
        String year = String.valueof(forms.Requested_Start_Date__c.year());
        String recordTypeName = getRecordTypeName(forms.RecordTypeId);  
        String query = 'select Id, Fab__c, Month__c, Year__c, Module1__c, Program1__c, Wafer_Quantity_Allocated__c, Remaining_Quantity__c from Wafer_Allocation__c where Fab__c = \''+recordTypeName+'\' and Year__c = \''+year+'\' and Month__c = \''+monthName+'\'';
        String valueMod = forms.Module__c;
        String valueProg = forms.Program__c;   
        if(valueMod != null && (recordTypeName == eWSRConstantsVariablesClass.FAB7RECORDTYPE || recordTypeName == eWSRConstantsVariablesClass.FAB3ERECORDTYPE)){
            query += ' and Module1__c = \''+valueMod+'\'';
        }
        if(valueProg != null && recordTypeName == eWSRConstantsVariablesClass.FAB7RECORDTYPE){
            query += ' and Program1__c = \''+valueProg+'\'';
        }
        List<Wafer_Allocation__c> waferAlloc = database.query(query); 
        if(!waferAlloc.isEmpty()){
            if(waferAlloc[0].Wafer_Quantity_Allocated__c == null){
                forms.Forecast_Quantity__c = 0;
                forms.Remaining_Quantity__c = 0;
            }
            else{
                forms.Previous_Forecast_Quantity__c = forms.Forecast_Quantity__c;
                forms.Previous_Remaining_Quantity__c = forms.Remaining_Quantity__c;
                forms.Forecast_Quantity__c = waferAlloc[0].Wafer_Quantity_Allocated__c;
                forms.Remaining_Quantity__c = waferAlloc[0].Remaining_Quantity__c;
                if(forms.Equivalent_Quantity__c > waferAlloc[0].Remaining_Quantity__c){
                    forms.Message__c ='There is not enough wafer balance to cover this request'; 
                }
            } 
            update forms;                   
        } 
    }
    
    
    public static void updateRemQuan(List<eWSR_Form__c> formsList){
        List<Wafer_Allocation__c> WaferListAppr = new List<Wafer_Allocation__c>();
        List<Wafer_Allocation__c> WaferListRej = new List<Wafer_Allocation__c>();
        List<Wafer_Allocation__c> WaferListApprv = new List<Wafer_Allocation__c>();
        Wafer_Allocation__c results;
        Wafer_Allocation__c[] results1;
        String monthName;
        String year;
        String monthNamePlan;
        String yearPlan;
        String recordTypeName;
        String module;
        String program;
        
        eWSR_Form__c forms = new eWSR_Form__c();
        
        for(eWSR_Form__c tempforms: formsList){
            forms = tempforms;
        }
           
                       
            Integer month = forms.Requested_Start_Date__c.month();
            System.debug('Month:'+ month);          
            if(month == 1){
               monthName = 'Jan';
            }else if (month == 2){
                monthName = 'Feb';
            }else if(month == 3){
                monthName = 'Mar';
            }else if(month == 4){
                monthName = 'Apr';
            }else if(month == 5){
                monthName = 'May';
            }else if(month == 6){
                monthName = 'Jun';
            }else if(month == 7){
                monthName = 'Jul';
            }else if(month == 8){
                monthName = 'Aug';
            }else if(month == 9){
                monthName = 'Sep';
            }else if(month == 10){
                monthName = 'Oct';
            }else if(month == 11){
                monthName = 'Nov';
            }else{
                monthName = 'Dec';
            }              
 
            year = String.valueof(forms.Requested_Start_Date__c.year());
            recordTypeName = getRecordTypeName(forms.RecordTypeId);     
            System.debug('RecordTypeName:'+recordTypeName);
            
            
            String soql = 'select remaining_quantity__c, Wafer_Quantity_Allocated__c, fab__c, program1__c, month__c, module1__c, Year__c from Wafer_Allocation__c';         
            soql = soql + ' where fab__c = \'' + recordTypeName +'\'' + ' AND month__c = \'' + monthName +'\'' + ' AND Year__c = \'' + year +'\'';
            if(recordTypeName == eWSRConstantsVariablesClass.FAB3ERECORDTYPE){
                soql = soql + ' AND module1__c = \'' + forms.Module__c +'\'';
            }
            if(recordTypeName == eWSRConstantsVariablesClass.FAB7RECORDTYPE){
                soql = soql + ' AND module1__c = \'' + forms.Module__c +'\'';
            }
            if(recordTypeName == eWSRConstantsVariablesClass.FAB7RECORDTYPE && forms.Program__c != null){
                soql = soql + ' AND program1__c =\'' + forms.Program__c+'\'';
            }
            soql = soql + ' order by Name LIMIT 1';
            System.debug(soql);
            
            if(forms.UpdateRemQuanOnApproval__c){
            
            results = new Wafer_Allocation__c(); 
            results = database.query(soql); 

            System.debug('Query:'+results);
            
            
            if(results.Remaining_Quantity__c == null){
                results.Remaining_Quantity__c = results.Wafer_Quantity_Allocated__c;
            }
            
            if(results.Wafer_Quantity_Allocated__c == null){
                results.Wafer_Quantity_Allocated__c = 0;
            }
            if(results.Remaining_Quantity__c == null){
                results.Remaining_Quantity__c = 0;
            }
            if(forms.Equivalent_Quantity__c == null){
                //forms.Equivalent_Quantity__c = 0;
                forms.Equivalent_Quantity__c.addError(eWSRConstantsVariablesClass.ERRORMSGEQ);
            }
            else{
              if(recordTypeName == eWSRConstantsVariablesClass.FAB7RECORDTYPE){
                if(forms.Full_loop_Short_loop__c == 'Short Loop'){
                    results.Remaining_Quantity__c = results.Remaining_Quantity__c - forms.Equivalent_Quantity__c;
                }
                else{
                  results.Remaining_Quantity__c = results.Remaining_Quantity__c - forms.Lot_Quantity_No_of_Wafers__c;
                }                  
              }
              else{
                 results.Remaining_Quantity__c = results.Remaining_Quantity__c - forms.Lot_Quantity_No_of_Wafers__c;
              }
              update results;
              }
              
              
            }
            
            if(forms.UpdateRemQuanOnRejection__c){
            results = new Wafer_Allocation__c();
            
            results = database.query(soql); 

            System.debug('Query:'+results);
            
            if(results.remaining_quantity__c == null){
                results.Remaining_Quantity__c = results.Wafer_Quantity_Allocated__c;
            }
            
            if(results.Wafer_Quantity_Allocated__c == null){
                results.Wafer_Quantity_Allocated__c = 0;
            }
            if(results.Remaining_Quantity__c == null){
                results.Remaining_Quantity__c = 0;
            }
            if(forms.Equivalent_Quantity__c == null){
                //forms.Equivalent_Quantity__c = 0;
                 forms.Equivalent_Quantity__c.addError(eWSRConstantsVariablesClass.ERRORMSGEQ);
            }
            else{
               if(recordTypeName == eWSRConstantsVariablesClass.FAB7RECORDTYPE){
                if(forms.Full_loop_Short_loop__c == 'Short Loop'){
                    results.Remaining_Quantity__c = results.Remaining_Quantity__c + forms.Equivalent_Quantity__c;
                }
                else{
                  results.Remaining_Quantity__c = results.Remaining_Quantity__c + forms.Lot_Quantity_No_of_Wafers__c;
                }                  
              }
              else{
                 results.Remaining_Quantity__c = results.Remaining_Quantity__c + forms.Lot_Quantity_No_of_Wafers__c;
              }
              update results; 
                } 
            }
                       
            if(forms.Status__c == eWSRConstantsVariablesClass.STATUSAPPROVED){
                results = new Wafer_Allocation__c();
            
            results = database.query(soql); 

            System.debug('Query:'+results);
            
            if(results.remaining_quantity__c == null){
                results.Remaining_Quantity__c = results.Wafer_Quantity_Allocated__c;
            }
            
            if(results.Wafer_Quantity_Allocated__c == null){
                results.Wafer_Quantity_Allocated__c = 0;
            }
            if(results.Remaining_Quantity__c == null){
                results.Remaining_Quantity__c = 0;
            }
            Integer monthPlan = forms.Plan_Start_Date__c.month();
                
            if(monthPlan == 1){
               monthNamePlan = 'Jan';
            }else if (monthPlan == 2){
                monthNamePlan = 'Feb';
            }else if(monthPlan == 3){
                monthNamePlan = 'Mar';
            }else if(monthPlan == 4){
                monthNamePlan = 'Apr';
            }else if(monthPlan == 5){
                monthNamePlan = 'May';
            }else if(monthPlan == 6){
                monthNamePlan = 'Jun';
            }else if(monthPlan == 7){
                monthNamePlan = 'Jul';
            }else if(monthPlan == 8){
                monthNamePlan = 'Aug';
            }else if(monthPlan == 9){
                monthNamePlan = 'Sep';
            }else if(monthPlan == 10){
                monthNamePlan = 'Oct';
            }else if(monthPlan == 11){
                monthNamePlan = 'Nov';
            }else{
                monthNamePlan = 'Dec';
            }              
 
            yearPlan = String.valueof(forms.Plan_Start_Date__c.year());
                 System.debug('RecordTypeName:'+recordTypeName);
                if((monthPlan != month && yearPlan == year) || (monthPlan == month && yearPlan != year) || (monthPlan != month && yearPlan != year)){
                    String soql1 = 'select remaining_quantity__c, Wafer_Quantity_Allocated__c, fab__c, program1__c, month__c, module1__c, Year__c from Wafer_Allocation__c';         
                    soql1 = soql1 + ' where fab__c = \'' + recordTypeName +'\'' + 'AND month__c = \'' + monthNamePlan +'\'' + 'AND Year__c = \'' + yearPlan+'\'';
                    if(recordTypeName == eWSRConstantsVariablesClass.FAB3ERECORDTYPE){
                        soql1 = soql1 + 'AND module1__c = \'' + forms.Module__c +'\'';
                    }
                    else if(recordTypeName == eWSRConstantsVariablesClass.FAB7RECORDTYPE){
                        soql1 = soql1 + 'AND module1__c = \'' + forms.Module__c +'\'';
                    }
                    if(recordTypeName == eWSRConstantsVariablesClass.FAB7RECORDTYPE && forms.Program__c != null){
                        soql1 = soql1 + 'AND program1__c =\'' + forms.Program__c+'\'';
                    }
                    soql1 = soql1 + ' order by Name LIMIT 1';
                    System.debug(soql1);
                    results1 = database.query(soql1); 

                    System.debug('Query:'+results1);
                    
                    if(results1.size() > 0){
                    if(results1[0].Wafer_Quantity_Allocated__c == null){
                        results1[0].Wafer_Quantity_Allocated__c = 0;
                    }
                    if(results1[0].Remaining_Quantity__c == null){
                        results1[0].Remaining_Quantity__c = 0;
                    }
                    
                    if(recordTypeName == eWSRConstantsVariablesClass.FAB7RECORDTYPE){
                        if(forms.Full_loop_Short_loop__c == 'Short Loop'){
                            results.Remaining_Quantity__c = results.Remaining_Quantity__c + forms.Equivalent_Quantity__c;
                            
                            results1[0].Remaining_Quantity__c = results1[0].Remaining_Quantity__c - forms.Equivalent_Quantity__c;
                        }
                        else{
                          results.Remaining_Quantity__c = results.Remaining_Quantity__c + forms.Lot_Quantity_No_of_Wafers__c;
                          results1[0].Remaining_Quantity__c = results1[0].Remaining_Quantity__c - forms.Lot_Quantity_No_of_Wafers__c;
                        }                  
                     }
                     else{
                         results.Remaining_Quantity__c = results.Remaining_Quantity__c + forms.Lot_Quantity_No_of_Wafers__c;
                         results1[0].Remaining_Quantity__c = results1[0].Remaining_Quantity__c - forms.Lot_Quantity_No_of_Wafers__c;
                     }
                     update results1[0];
                     update results; 
                     }
                     else{
                          forms.addError(eWSRConstantsVariablesClass.ERRORMSGNORECORD);
                      } 
                 }
                
            }

      }
    
}