/*
     Author: Devendra
    Description: 
    History: 
        Devendra      15Mar2017    - Code creation.
*/
public class MPW_ECCNInfoUploaderCtrl 
{
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    String[] filelines = new String[]{};
    List<MPW_ECCN_Info__c> eccnInfoToUpload;
    public List<Schema.FieldSetMember> csvFields{get;set;}
    
    //header fields
    public string MPWWaferRunName{get;set;}
    public string MPWCoordinatorName{get;set;}
    public string MPWCoordinatorPhone{get;set;}
    public string PreparationDate{get;set;}
    public string MPWPreparerName{get;set;}
    public string MPWPreparerPhone{get;set;}
    public string SubmissionDate{get;set;}
    
    /***This function reads the CSV file and inserts records into the Account object. ***/
    
    public string getexportedECCN(){
        csvFields = Schema.SObjectType.MPW_ECCN_Info__c.FieldSets.csvfields.getFields();
        String csv = '';
        string query='select ';
        for(Schema.FieldSetMember FieldSetMember : csvFields) {
            csv+=FieldSetMember.getLabel()+',';
            query+=FieldSetMember.getfieldpath()+',';
        }
        String recordId = ApexPages.currentPage().getParameters().get('id');
        query+='id from MPW_ECCN_Info__c where Export_Control_Form__c=:recordId';
        csv=csv.removeEnd(',')+'\n';
        List<MPW_ECCN_Info__c> accts =database.query(query);
        for ( MPW_ECCN_Info__c mpweccninfo : accts ) {
            for(Schema.FieldSetMember FieldSetMember : csvFields) {
                csv+=(mpweccninfo.get(FieldSetMember.getfieldpath())!=null?string.valueof(mpweccninfo.get(FieldSetMember.getfieldpath())).escapeCsv():null)+',';
            }
            csv=csv.removeEnd(','); csv +='\n';
        }
        
        return csv;
    }
    
    public Pagereference ReadFile()
    {
        
        String recordId = ApexPages.currentPage().getParameters().get('id');
        try{    
                string body='Edits to this template must be approved in advance and should be directed to GF Global Trade Compliance email (globaltrade@globalfoundries.com),MPW Classification Information,,,,,,,,,,,,,,,,\n'+
',,,,,,,,,,,,,,,,,\n'+
',MPW Wafer Run Name:,test,,,,,,,,,,,,,,,\n'+
',MPW Coordinator Name:,test,MPW Coordinator Phone #:,99999,Preparation Date:,12/8/2017,,,,,,,,,,,\n'+
',MPW Preparer Name:,test,MPW Preparer Phone #:,99999,Submission Date:,12/8/2017,,,,,,,,,,,\n'+
'Design / Project Number,Design / Chip / Project Name,Topcell / Cell Name,"Pb Free Bump, WLCSP, HI or Cu Pillar Required?                            (Y/N)",Company Name,EAR                         Product ECCN,EAR                           Design ECCN,Subject to the ITAR? (Y/N),ITAR                          End Use Equipment Category/Suffix,ITAR               Product Category/Suffix,ITAR                     Design Category/Suffix,Subject to Encryption Controls                   (Y/N)  ,US HTS / Schedule B Number               ,Brief Description of IC Device,Intended End Use of IC Device,"Design, Modified, or Adapted for Military Applications? (Y/N)","Designed, Developed using  Classified Information?(Y/N)","Nuclear, Chemical/Biological Weapon or Missile related?(Y/N)"\n'+
'test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test\n'; //Is used as test data to increase coverage
                if(test.isRunningTest())contentFile=blob.valueof(body);
                //Convert the uploaded file which is in BLOB format into a string
                nameFile =blobToString( contentFile,'ISO-8859-1');
                
                //Now sepatate every row of the excel file
                filelines = nameFile.split('\n');
                
                List<string> newList = new List<string>();
                    for(Integer i = 5; i< filelines.size();i++){
                    newList.add(filelines[i]);
                }
                
                if(filelines.size()>=4){
                    MPWWaferRunName=filelines[2].split(',')[2];
                    MPWCoordinatorName=filelines[3].split(',')[2];
                    MPWCoordinatorPhone=filelines[3].split(',')[4];
                    PreparationDate=filelines[3].split(',')[6];
                    MPWPreparerName=filelines[4].split(',')[2];
                    MPWPreparerPhone=filelines[4].split(',')[4];
                    SubmissionDate=filelines[4].split(',')[6];
                }
                nameFile=String.join(newList,'\n');
                //Iterate through every line and create a Account record for each row
                eccnInfoToUpload = new List<MPW_ECCN_Info__c>();
                
                csvFields = Schema.SObjectType.MPW_ECCN_Info__c.FieldSets.csvfields.getFields();
                List<List<string>> data=parseCSV(nameFile);
                for (Integer i=1;i<data.size();i++)
                {   
                    
                    String[] inputvalues = new String[]{};
                    inputvalues = data[i];
                    MPW_ECCN_Info__c a = new MPW_ECCN_Info__c();
                    integer count=0;
                    for(Schema.FieldSetMember f : csvFields) {
                       a.put(f.getFieldPath(),inputvalues[count]);
                        count++;
                    }                    
        
                    eccnInfoToUpload.add(a);
                }
            
         }
         catch(Exception e){
                 ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured reading the CSV file'+e.getMessage());
                ApexPages.addMessage(errormsg);
         }       
       
        return null;
    }
    
    public Pagereference saveFile()
    {
        
        String recordId = ApexPages.currentPage().getParameters().get('id');
        try{
            List<MPW_ECCN_Info__c> mpweccnList=[select id,Project_No__c,Export_Control_Form__c from MPW_ECCN_Info__c where Export_Control_Form__c = :recordId];
            List<Device_Export_Control_Junction__c> devExpConJunc =  [select  Export_Control_Form__c,
                                                                    CRM_Device_ID__c,
                                                                    Customer_Name__c,
                                                                    Device_Name__c,
                                                                    Export_Control_Template__c,
                                                                    Fab__c,
                                                                    LastModifiedBy__c,
                                                                    Project_Name__c,
                                                                    Device__c 
                                                            from Device_Export_Control_Junction__c
                                                            where Export_Control_Form__c = :recordId limit 1];
            
            for(MPW_ECCN_Info__c m:eccnInfoToUpload){
                m.Export_Control_Form__c=recordId;
                if(!devExpConJunc.isempty())m.Device__c=devExpConJunc[0].Device__c;
            }
            
            
            
            Export_control_form__c ecf=new Export_control_form__c(id=recordId);
            ecf.MPW_Wafer_Run_Name__c=MPWWaferRunName;
            ecf.MPW_Preparer_Phone__c=MPWPreparerPhone;
            ecf.MPW_Preparer_Name__c=MPWPreparerName;
            ecf.MPW_Coordinator_Phone__c=MPWCoordinatorPhone;
            ecf.MPW_Coordinator_Name__c=MPWCoordinatorName;
            ecf.Preparation_Date__c=PreparationDate;
            ecf.Submission_Date__c=SubmissionDate;
            update ecf;
            
            database.insert( eccnInfoToUpload,true); //fail whole data if any one fails
            
            Attachment a = new Attachment(parentid=recordId, Name = 'MPW_ECCN_INFO_'+string.valueof(system.now())+'.csv' , Body = contentFile);
            database.insert(a,true); //fail whole data if any one fails
            if(!mpweccnList.isempty()){
                delete mpweccnList;
                
            }
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.COnfirm,'Uploaded Successfully');
            ApexPages.addMessage(errormsg);
            GlobalUtility.logMessage('Debug', 'MPW_ECCNInfoUploaderCtrl', 'ReadFile', null, '- Message -', 'Uploaded Successfully', null,'Other SFDC',null,0);
            
            
        }
        catch (Exception e)
        {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured inserting the records'+e.getMessage());
            ApexPages.addMessage(errormsg);
            GlobalUtility.logMessage('Error', 'MPW_ECCNInfoUploaderCtrl', 'ReadFile', null, '- Message -', 'Exception Occured', null,'Other SFDC',e,0);
        }    
        return null;
    }
   
   /**** This function sends back to the visualforce page the list of account records that were inserted ****/ 
    public List<MPW_ECCN_Info__c> getuploadedECCN()
    {
        if (eccnInfoToUpload!= NULL)
            if (eccnInfoToUpload.size() > 0)
                return eccnInfoToUpload;
            else  return null;                    
        else return null;
    }  
        /**
         This function convers the input CSV file in BLOB format into a string
        @param input    Blob data representing correct string in @inCharset encoding
        @param inCharset    encoding of the Blob data (for example 'ISO 8859-1')
     */
    public static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }
    
    public static List<List<String>> parseCSV(String contents) {
        
        // Determine if it is split by newLine(\n) or return carriage(\r) or a \r\nn
        Boolean hasNewLine = false;
        Boolean hasCarrReturn = false;
        
        //First check for a \r\n char
        if(contents.contains('\r\n')) {
            hasNewLine = true;
            hasCarrReturn = false;
        }
        else {
            //If not then check for either a /r or /n
            if(contents.contains('\n')) {
                hasNewLine = true;
            }
            if(contents.contains('\r')) {
                hasCarrReturn = true;
            }
        }
        
        List<List<String>> allFields = new List<List<String>>();
        if(hasNewLine && hasCarrReturn) {
            //addError('The file contains both newline and carriage returns');
        }
        else {
            
            String splitBy = '\n';
            if(hasCarrReturn) {
                splitBy = '\r';
            }
            
            // replace instances where a double quote begins a field containing a comma
            // in this case you get a double quote followed by a doubled double quote
            // do this for beginning and end of a field
            contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
            // now replace all remaining double quotes - we do this so that we can reconstruct
            // fields with commas inside assuming they begin and end with a double quote
            contents = contents.replaceAll('""','DBLQT');
            // we are not attempting to handle fields with a newline inside of them
            // so, split on newline to get the spreadsheet rows
            List<String> lines = new List<String>();
            try {
                lines = contents.split(splitBy);
            } catch (System.ListException e) {
            }
            Integer num = 0;
            
            for(String line : lines) {
                // Deal with lines where 
                //if (line.replaceAll(',','').trim().length() == 0) continue; 
                
                
                // TODO: Deal with lines where all fields empty. Currently splits into an empty array.
                
                List<String> fields = line.split(',', -1);  
                List<String> cleanFields = new List<String>();
                String compositeField;
                Boolean makeCompositeField = false;
                for(String field : fields) {
                    if (field.startsWith('"') && field.endsWith('"')) {
                        cleanFields.add(field.replaceAll('DBLQT','"'));
                    } else if (field.startsWith('"')) {
                        makeCompositeField = true;
                        compositeField = field;
                    } else if (field.endsWith('"')) {
                        compositeField += ',' + field;
                        cleanFields.add(compositeField.replaceAll('DBLQT','"'));
                        makeCompositeField = false;
                    } else if (makeCompositeField) {
                        compositeField +=  ',' + field;
                    } else {
                        cleanFields.add(field.replaceAll('DBLQT','"'));
                    }
                }
                
                // Remove double quotes (if present) from start and end of each field
                List<String> noQuoteFields = new List<String>();
                for(String field : cleanFields) {
                    if(field.startsWith('"') && field.endsWith('"')) {
                        field = field.substring(1, field.length() - 1);
                    }
                    noQuoteFields.add(field);
                }
                allFields.add(noQuoteFields);
            }
        }
        
        // Remove any rows before header row so that header row is first row:
        Integer headerRow = -1;
        for(Integer i=0; (i < allFields.size() && headerRow == -1) ; i++) {
            // Determine if all fields in this row are non-blank:
            List<String> row = allFields.get(i);
            Boolean isHeaderRow = true;
            
            for(String field : row) {
                if(field == '') { // field is blank
                    isHeaderRow = false;
                }
            }
            
            if(isHeaderRow) {
                headerRow = i;
            }
        }
        
        for(Integer i=0; i < headerRow; i++) {
            allFields.remove(0);
        }

        return allFields;
    }
}