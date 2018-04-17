/*
    Author: Ariz Solito
    Description: Apex class controller for the VF ProcessReport
    History: 
        Asolito     14-03-2014    - Code creation.
        Asolito     05-05-2014    - Added IO Voltage advanced filter
        Asolito     27-05-2014    - Added logic for expose to external customers
        Asolito     20-06-2014    - Filter process records by Customer Release = General Release
        Asolito     07-08-2014    - Filter PTs based on Customer Release and Lifecycle if external users
        Asolito     08-19-2014    - Added the ff. advanced filters: Process Family, Category, Poly Gate Type, HV Voltage
                                    Core Voltage, Tech Type
                                  - Added specific release filter for customers
        
*/
public class ProcessReportCntrlr { 
   
    final private static String COLUMNSORT = EnvironmentVariable.get('PROCESS_REPORT_COLUMN_SORT');       
    final private static String OPTIONALCOLUMNS = EnvironmentVariable.get('PROCESS_REPORT_OPTIONAL_COLUMN');
    final private static Integer OFFSET =  UtilsString.isNotBlank(EnvironmentVariable.get('PT_IP_REPORT_OFFSET_SIZE')) ?
                                           Integer.valueOf(EnvironmentVariable.get('PT_IP_REPORT_OFFSET_SIZE')) :
                                           10;
    
    final private static Integer ROWCOUNT = UtilsString.isNotBlank(EnvironmentVariable.get('PT_IP_REPORT_ROW_COUNT_LIMIT')) ?
                                            Integer.valueOf(EnvironmentVariable.get('PT_IP_REPORT_ROW_COUNT_LIMIT')) :
                                            1000; 
                                            
    final private static String ERROR_MESSAGE = 'You are not authorised! \nYour NDA has expired. \nPlease contact your account manager for new NDA or Extension';                                            
    private static String GENERATETYPE;                                                             
    
    public String genReport {get; set;}
    public ProcessList processList {get; set;}
    public Boolean hasNoAccess {get; set;}
    public Boolean showList {get; set;}
    public Boolean noPTFilterPicked {get; set;}
    public Boolean noGeometryFilterPicked {get; set;}
    public Boolean showAvailableToSell {get; set;}
    public Boolean isExternalUser {get; set;}
    public String renderAsPDF {get; set;}
    public String renderAsExcel {get; set;}
    public String ptName {get; set;}        
    public String ptNumber {get; set;}
    public String geometry {get; set;}
    public String pidNumber {get; set;}
    public String processName {get; set;} 
    public String maskLayer {get; set;} 
    public String IOVoltage {get; set;}
    public String family {get; set;}
    public String category {get; set;}
    public String gateType {get; set;}
    public String HVVoltage {get; set;}
    public String coreVoltage {get; set;}
    public String techType {get; set;}
    public String allColumns {get; set;}
    public String dummyColumns {get; set;}    
    public String addedColumns {get; set;}
    public String sortField {get; set;}
    public String sortType {get; set;}
    public String viewProcessDetails {get; set;} 
    public Integer currPageNumber {get; set;} 
    public Integer totalPages {get; set;} 
    public Integer addedColumnsCount {get; set;}
    public List<IPRow> currPage {get; set;}      
    private Set<String> geometries {get; set;}  
    private Map<String,Set<String>> ptNames {get; set;} 
    private String externalUserAccount;
    
    //Init
    public ProcessReportCntrlr(){ 
        this.addedColumns = '';     
        this.addedColumnsCount = 0;      
        this.processList = new ProcessList(); 
        this.currPage = new List<IPRow>(); 
        this.showAvailableToSell = true;  
        this.isExternalUser = false;     
        this.hasNoAccess = false;        
        
        this.genReport =  ApexPages.currentPage().getParameters().get('generate');  
        GENERATETYPE = this.genReport;               
        
        //render as PDF or excel
        if(UtilsString.isNotBlank(genReport)){
            this.geometry = UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('geometry')) ?
                            ApexPages.currentPage().getParameters().get('geometry') :
                            null;                          
            this.ptName = UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('ptname')) ?
                          ApexPages.currentPage().getParameters().get('ptname') :
                          null;
            this.ptNumber = UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('ptnumber')) ?
                            ApexPages.currentPage().getParameters().get('ptnumber') :
                            null;               
            this.pidNumber = UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('pidnumber')) ?
                             ApexPages.currentPage().getParameters().get('pidnumber') :
                             null;
            this.processName = UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('processname')) ?
                               ApexPages.currentPage().getParameters().get('processname') :
                               null;
            this.maskLayer =  UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('masklayer')) ?
                              ApexPages.currentPage().getParameters().get('masklayer') :
                              null;                                         
            this.IOVoltage =  UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('iovoltage')) ?
                              ApexPages.currentPage().getParameters().get('iovoltage') :
                              null;                                         
            this.family =  UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('family')) ?
                              ApexPages.currentPage().getParameters().get('family') :
                              null;                                         
            this.category =  UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('category')) ?
                              ApexPages.currentPage().getParameters().get('category') :
                              null;                                         
            this.gateType =  UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('gatetype')) ?
                              ApexPages.currentPage().getParameters().get('gatetype') :
                              null;                                         
            this.HVVoltage =  UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('hvvoltage')) ?
                              ApexPages.currentPage().getParameters().get('hvvoltage') :
                              null;                                         
            this.coreVoltage =  UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('corevoltage')) ?
                              ApexPages.currentPage().getParameters().get('corevoltage') :
                              null;                                         
            this.techType =  UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('techtype')) ?
                              ApexPages.currentPage().getParameters().get('techtype') :
                              null;                                                                                                                                                                                   
            this.viewProcessDetails =  UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('processdetails')) ?
                                 ApexPages.currentPage().getParameters().get('processdetails') :
                                 null;                            
            this.addedColumns =  UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('cols')) ?
                                 ApexPages.currentPage().getParameters().get('cols') :
                                 null;                                                        
                                 
            if(UtilsString.isNotBlank(this.addedColumns)){
                this.addedColumnsCount = this.addedColumns.split('\\;').size();
            }                                                                                            
                                                              
            if(genReport == 'pdf'){
                this.renderAsPDF = 'pdf';
            } else if (genReport == 'excel'){
                this.renderAsExcel = 'application/vnd.ms-excel#ProcessReport.xls';
            }
            query();
        }
        
          
        //store the granted PTs
        Set<String> grantedPTs = new Set<String>();
           
        //check if user is internal or external     
        for(User u :[SELECT contactId,contact.account.has_valid_nda__c,contact.account.tech_geo_granted__c,
                            contact.account.valid_tech_geos__c,contact.account.short_name__c,contact.accountid,
                            contact.account.name
                       FROM User
                       WHERE id = :userInfo.getUserId()]){
            if(UtilsString.isNotBlank(u.contactId)){                       
                this.isExternalUser = true;
                this.externalUserAccount = u.contact.account.name;
                
                if(u.contact.account.has_valid_nda__c && UtilsString.isNotBlank(u.contact.account.valid_tech_geos__c)){
                    grantedPTs.addAll(u.contact.account.valid_tech_geos__c.split('\\;'));
                }                           
            }
        }                                                  
                                       
        //get the process technology and geometry fields filters               
        this.geometries = new Set<String>(); 
        this.ptNames = new Map<String,Set<String>>(); 
        
        String query = 'SELECT count(id),ip_geometry_technology__c,tech_geometry__c '+
                       '  FROM Process_Technology__c ';
        
        //filter PTs for external users                                                
        if(this.isExternalUser){
            query += 'WHERE customer_release__c = \'General Release\' '+
                     'AND lifecycle__c NOT IN (\'Preliminary\',\'EOL\') ';
        }                          
        
        query += 'GROUP BY ip_geometry_technology__c,tech_geometry__c  '+
                 'LIMIT :ROWCOUNT ';
                   
        
        List<AggregateResult> PTs = database.query(query);
        
        for(AggregateResult p: PTs){           
            if(UtilsString.isNotBlank(p.get('tech_geometry__c'))){
                String tempGeo = String.valueOf(p.get('tech_geometry__c'));
                
                //filter the geometry for external users
                if(this.isExternalUser){
                    if(grantedPTs.contains(tempGeo)){
                        this.geometries.add(tempGeo);
                    }   
                //internal users                    
                } else {
                    this.geometries.add(tempGeo);
                }                                
                
                if(UtilsString.isNotBlank(p.get('ip_geometry_technology__c'))){
                    List<String> currPTs = String.valueOf(p.get('ip_geometry_technology__c')).split('\\;');                                               
                    
                    for(String c: currPTs){
                        if(this.ptNames.containsKey(String.valueOf(tempGeo))){
                           this.ptNames.get(tempGeo).add(c); 
                        } else {
                            this.ptNames.put(tempGeo,new Set<String>{c});
                        }  
                    }
                }
            }
        }
                
        if(this.geometries.size() == 0){
            this.hasNoAccess = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ERROR_MESSAGE));
        }                                                                                                                                                                                                                                                                
    }
    
    //Method will go to the first
    public PageReference first(){
        this.currPageNumber = 1;
        
        if(this.processList.pages.containsKey(this.currPageNumber)){
            this.currPage = this.processList.pages.get(this.currPageNumber);
        }
        return null;
    }
    
    //Method will go to the next page
    public PageReference next(){
        this.currPageNumber++;
        
        if(this.processList.pages.containsKey(this.currPageNumber)){
            this.currPage = this.processList.pages.get(this.currPageNumber);
        }
        return null;
    }
    
    //Method will go to the previous page
    public PageReference previous(){
        if(this.currPageNumber > 1){
            this.currPageNumber--;
        }
        
        if(this.processList.pages.containsKey(this.currPageNumber)){
            this.currPage = this.processList.pages.get(this.currPageNumber);
        }
        return null;
    }
    
    //Method will go to the last page
    public PageReference last(){
        this.currPageNumber = this.totalPages;
        
        if(this.processList.pages.containsKey(this.currPageNumber)){
            this.currPage = this.processList.pages.get(this.currPageNumber);
        }
        return null;
    }
    
    //Method will do sorting based on the clicked header
    public PageReference sort(){        
        
        this.processList.sort(this.sortField,this.sortType);
        this.currPageNumber = 1;
        
        if(this.processList.pages.containsKey(1)){
            this.currPage = this.processList.pages.get(1);
        }
        return null;
    }
    
    //Method will add columns to the result table
    public PageReference addColumns(){
        if(UtilsString.isNotBlank(this.addedColumns)){
            this.addedColumnsCount = this.addedColumns.split('\\;').size();            
        } else {
            this.addedColumnsCount = 0;
        }
        
        //set filter text fields to null if blank so it wont render on the page
        if(!UtilsString.isNotBlank(this.pidNumber)){
            this.pidNumber = null;
        }
        
        if(!UtilsString.isNotBlank(this.processName)){
            this.processName = null;
        }
        
        if(!UtilsString.isNotBlank(this.ptNumber)){
            this.ptNumber = null;
        }
        
        if(!UtilsString.isNotBlank(this.maskLayer)){
            this.maskLayer = null;
        }
        
        if(!UtilsString.isNotBlank(this.IOVoltage)){
            this.IOVoltage = null;
        }
        
        if(!UtilsString.isNotBlank(this.IOVoltage)){
            this.IOVoltage = null;
        }
        
        if(!UtilsString.isNotBlank(this.family)){
            this.family = null;
        }
        
        if(!UtilsString.isNotBlank(this.category)){
            this.category = null;
        }
        
        if(!UtilsString.isNotBlank(this.HVVoltage)){
            this.HVVoltage = null;
        }
        
        if(!UtilsString.isNotBlank(this.coreVoltage)){
            this.coreVoltage = null;
        }
        
        if(!UtilsString.isNotBlank(this.gateType)){
            this.gateType = null;
        }
        
        if(!UtilsString.isNotBlank(this.techType)){
            this.techType = null;
        }
        return null;
    }
    
    //Method will refresh pt name picklist
    public PageReference refreshPTname(){             
        return null;        
    }                
    
    //Method will generate the optional columns for the result
    public List<SelectOption> getOptionalColumns(){
        List<SelectOption> result = new List<SelectOption>();
        
        for(String o: OPTIONALCOLUMNS.split('\\,')){
            result.add(new SelectOption(o,o));
        }
        return result;
    }
    
    //Method will generate blank picklist option for selected optional columns
    public List<SelectOption> getAddedOptionalColumns(){
        List<SelectOption> result = new List<SelectOption>(); 
        
        if(UtilsString.isNotBlank(this.addedColumns) && this.addedColumns <> '[]'){
            for(String a: this.addedColumns.split('\\;')){
                result.add(new SelectOption(a,a));
            }
        }
        return result;
    }
    
    //Method will generate PT names picklist
    public List<SelectOption> getPTNameList(){      
        List<SelectOption> result = new List<SelectOption>();
        Set<String> upperCasedValues = new Set<String>();
        
        if(this.ptNames.containsKey(this.geometry)){
            for(String i: this.ptNames.get((this.geometry))){
                upperCasedValues.add(i.toUpperCase());            
            }
        }
               
        return generatePickList(upperCasedValues);
    }
     
    //Method will generate geometry picklist
    public List<SelectOption> getGeometryList(){
        Set<String> parsedValues = new Set<String>();
        for(String p: this.geometries){
            if(UtilsString.isNotBlank(p)){
                parsedValues.addAll(p.split('\\;'));
            }
        }
        
        List<SelectOption> result = generatePickList(parsedValues);
        
        //remove ALL option and change to SELECT
        result.remove(0); 
        result.add(0,new SelectOption('','--SELECT--'));
        return result;
    }
          
    //Generic method to generate the picklist values 
    public List<SelectOption> generatePickList(Set<String> values){
        List<SelectOption> result = new List<SelectOption>();
        result.add(new SelectOption('','ALL'));
        
        List<String> lst = new List<String>();
        lst.addAll(values);
        lst.sort();
        
        for(String l: lst){
            if(UtilsString.isNotBlank(l)){
                result.add(new SelectOption(l,l));
            }
        }
        return result;
    }
    
    //Method will call the IP generate list
    public PageReference query(){        
        if(!UtilsString.isNotBlank(this.geometry)){
            this.noGeometryFilterPicked = true;
        } else {  
            //parse mask layers filters
            if(UtilsString.isNotBlank(this.maskLayer)){
                this.maskLayer = this.maskLayer.replace(' ','').toUpperCase();
            }                     
            this.processList.generateList(this.geometry,
                                          this.ptName,
                                          this.ptNumber,
                                          this.pidNumber,
                                          this.processName,
                                          this.maskLayer,
                                          this.IOVoltage,
                                          this.family,
                                          this.category,
                                          this.gateType,
                                          this.HVVoltage,
                                          this.coreVoltage,
                                          this.techType,
                                          this.externalUserAccount,
                                          this.showAvailableToSell,
                                          UtilsString.isNotBlank(this.genReport) ? true : false,
                                          this.isExternalUser); 
            this.showList = true;            
            this.noGeometryFilterPicked = false; 
            
            this.currPageNumber = 1;            
            this.sortType = '';
            this.totalPages = this.processList.pages.size();
            
            if(!UtilsString.isNotBlank(this.genReport)){
                this.addedColumns = ''; 
                this.addedColumnsCount = 0;
            }
            
            if(this.processList.pages.containsKey(this.currPageNumber)){
                this.currPage = this.processList.pages.get(this.currPageNumber);
            }                 
        }                
        
        //set filter text fields to null if blank so it wont render on the page
        if(!UtilsString.isNotBlank(this.pidNumber)){
            this.pidNumber = null;
        }
        
        if(!UtilsString.isNotBlank(this.processName)){
            this.processName = null;
        }
        
        if(!UtilsString.isNotBlank(this.ptNumber)){
            this.ptNumber = null;
        }
        
        if(!UtilsString.isNotBlank(this.maskLayer)){
            this.maskLayer = null;
        }
        
        if(!UtilsString.isNotBlank(this.IOVoltage)){
            this.IOVoltage = null;
        }
        
        if(!UtilsString.isNotBlank(this.family)){
            this.family = null;
        }
        
        if(!UtilsString.isNotBlank(this.category)){
            this.category = null;
        }
        
        if(!UtilsString.isNotBlank(this.gateType)){
            this.gateType = null;
        }
        
        if(!UtilsString.isNotBlank(this.HVVoltage)){
            this.HVVoltage = null;
        }
        
        if(!UtilsString.isNotBlank(this.coreVoltage)){
            this.coreVoltage = null;
        }
        
        if(!UtilsString.isNotBlank(this.techType)){
            this.techType = null;
        }
        
        return null;   
    }  
    
    //Apex class wrapper to generate the IP list
    public class ProcessList {        
        public List<IPRow> rows {get; set;}
        public Integer processCount {get; set;}
        public List<String> tableColumns {get; set;}
        public String optionalColumnsText {get; set;}
        public Map<String,String> optionalCols {get; set;} 
        public Map<Integer,List<IPRow>> pages {get; set;}        
        public Process_Technology__c pt;
        private List<Schema.FieldSetMember> reportFieldSet;
        
        //Init
        public ProcessList(){
            this.rows = new List<IPRow>();
            this.tableColumns = COLUMNSORT.split('\\,');
            this.optionalCols = new Map<String,String>();
            this.pages = new Map<Integer,List<IPRow>>();
            this.optionalColumnsText = OPTIONALCOLUMNS;
            
            for(String o: OPTIONALCOLUMNS.split('\\,')){
                this.optionalCols.put(o,o);    
            } 
            
            this.reportFieldSet = SObjectType.Process__c.FieldSets.Process_Report.getFields();           
        }
                           
        
        //Method will generate the IP list
        public void generateList(String geometry,
                                 String ptName,
                                 String ptNumber,
                                 String pidNumber,
                                 String processName,
                                 String maskLayer,
                                 String ioVoltage,
                                 String family,
                                 String category,
                                 String gateType,
                                 String HVVoltage,
                                 String coreVoltage,
                                 String techType,
                                 String externalUserAccount,
                                 Boolean showAvailableToSell,
                                 Boolean isGenerateReport,
                                 Boolean isExternalUser){
                                 
            this.rows = new List<IPRow>();       
            Set<String> ptNumbers = new Set<String>(); 
            
            //get the processes under the same geometry
            if(UtilsString.isNotBlank(geometry)){
                String mainQuery = 'SELECT pt_number__c '+
                                   '  FROM Process_Technology__c '+
                                   '  WHERE tech_geometry__C = :geometry ';
                                   
                //add pt name filter
                if(UtilsString.isNotBlank(ptName)){                
                    mainQuery += ' AND ip_geometry_technology__c LIKE \'%'+ ptName +'%\' ';
                }                     
                
                //add pt number filter
                if(UtilsString.isNotBlank(ptNumber)){                
                    mainQuery += ' AND pt_number__c = :ptNumber ';
                } 
                
                List<Process_Technology__c> PTs = database.query(mainQuery);                                   
                                                                       
                for(Process_Technology__c p :PTs){
                    ptNumbers.add(p.pt_number__c);                                                           
                }
            }
            
            //generate the process query
            String query = 'SELECT id,associated_pid__c,';            
                       
            Set<String> uniqueFields = new Set<String>();
            
            //main field set
            for(Schema.FieldSetMember f : this.reportFieldSet) {
                uniqueFields.add(f.getFieldPath());
            }                       
            
            if(isGenerateReport){
                //add the other Process field sets for report generation
                for(Schema.FieldSetMember f : SObjectType.Process__c.FieldSets.Process_Details_Section.getFields()) {
                    uniqueFields.add(f.getFieldPath());
                }
                
                for(Schema.FieldSetMember f : SObjectType.Process__c.FieldSets.Process_Feature_Section.getFields()) {
                    uniqueFields.add(f.getFieldPath());
                }
                
                for(Schema.FieldSetMember f : SObjectType.Process__c.FieldSets.Process_Features_FEOL_and_BEOL_Section.getFields()) {
                    uniqueFields.add(f.getFieldPath());
                }
                
                for(Schema.FieldSetMember f : SObjectType.Process__c.FieldSets.Standard_and_Transistors_Section.getFields()) {
                    uniqueFields.add(f.getFieldPath());
                }
                
                for(Schema.FieldSetMember f : SObjectType.Process__c.FieldSets.Analog_RF_Section.getFields()) {
                    uniqueFields.add(f.getFieldPath());
                }
                
                for(Schema.FieldSetMember f : SObjectType.Process__c.FieldSets.Special_and_Others_Section.getFields()) {
                    uniqueFields.add(f.getFieldPath());
                }
                
                for(Schema.FieldSetMember f : SObjectType.Process__c.FieldSets.Process_Documentation_Section.getFields()) {
                    uniqueFields.add(f.getFieldPath());
                }
            }
            
            for(String u: uniqueFields){
                query += u + ', ';
            }                     
            
            query = query.substring(0,query.lastIndexOf(','));   
            query += ' FROM Process__c '+
                     ' WHERE process_technology__c IN :ptNumbers ';
                     
            //add available to sell filter
            if(showAvailableToSell){                     
                query += ' AND available_to_sell__c NOT IN (\'Cancelled\',\'EOL\',\'Pending EOL\',\'Preliminary\') ';            
            }
                                 
            //add pid number filter
            if(UtilsString.isNotBlank(pidNumber)){                
                query += ' AND pid_number__c LIKE \'%'+ pidNumber +'%\' ';
            }
            
            //add process name filter
            if(UtilsString.isNotBlank(processName)){
                query += ' AND name LIKE \'%'+ processName +'%\' ';
            }
            
            //Asolito 08/27/2014
            //Filter process Customer release = General Release or
            //Specific Release tied to the customer's account
            //for external customers            
            //
            if(isExternalUser){
                query += 'AND (customer_release__c = \'General Release\' ' +
                         'OR (customer_release__c = \'Specific Release\' AND customer_affected__c LIKE \'%' + externalUserAccount + '%\')) ';
            }
            
            //Asolito 08/19/2014
            //add more advanced filters
            
            //add process family filter
            if(UtilsString.isNotBlank(family)){
                query += ' AND process_family__c = \''+ family +'\' ';
            }
            
            //add category filter
            if(UtilsString.isNotBlank(category)){
                query += ' AND category__c = \''+ category +'\' ';
            }
            
            //add poly gate type filter
            if(UtilsString.isNotBlank(gateType)){
                query += ' AND poly_gate_type__c = \''+ gateType +'\' ';
            }
            
            query += ' ORDER BY pid_number__c' +
                     ' LIMIT :ROWCOUNT ';
            
            System.debug(query);

            //create the IP row record                                    
            transient List<Process__c> processes = database.query(query); 
            
            //get the mask layers of Standard and Frontend processes for matching with its Backend counterpart
            Map<String,String> backendMaskMap = new Map<String,String>();
            if(UtilsString.isNotBlank(pidNumber) || UtilsString.isNotBlank(processName)){
                String query2 = 'SELECT associated_pid__c,mask_layers__c '+
                                'FROM Process__c ';
                                
                if(UtilsString.isNotBlank(pidNumber)){
                    query2 += 'WHERE associated_pid__c LIKE \'%'+ pidNumber + '%\' '; 
                }
                
                if(UtilsString.isNotBlank(processName)){
                    String currFilter = '';
                    for(Process__c p: processes){
                        if(query2.contains('WHERE')){
                            query2 += 'OR associated_pid__c LIKE \'%'+ p.pid_number__c + '%\' '; 
                        } else {
                            query2 += 'WHERE associated_pid__c LIKE \'%'+ p.pid_number__c + '%\' '; 
                        }        
                    }                                        
                }
                
                System.debug('query 2: '+query2);
                
                transient List<Process__c> processes2 = database.query(query2);
                
                for(Process__c p: processes2){
                    if(UtilsString.isNotBlank(p.associated_pid__c)){
                        for(String s: p.associated_pid__c.split('\\;')){
                            backendMaskMap.put(s,p.mask_layers__c);    
                        }
                    }
                } 
                
            } else {            
                for(Process__c p: processes){
                    if(UtilsString.isNotBlank(p.associated_pid__c)){
                        for(String s: p.associated_pid__c.split('\\;')){
                            backendMaskMap.put(s,p.mask_layers__c);    
                        }
                    }
                } 
            }                       
            
            Map<String,Schema.FieldSetMember> IPFieldsMap = new Map<String,Schema.FieldSetMember>();
            for(Schema.FieldSetMember r : this.reportFieldSet) {
                IPFieldsMap.put(r.getLabel(),r);
            }
                                     
            //Set the max record to be shown to 350 due to heap size limitation
            Integer counter = 1;                                 
            for(Process__c p :processes){                                   
                if(counter <= 350){
                    String pairedMasks = backendMaskMap.get(p.pid_number__c);
                    
                    IPRow temp = new IPRow(p,IPFieldsMap,this.optionalCols,pairedMasks);
                    
                    Boolean matchedMaskLayer = true;
                    Boolean matchedIOVoltage = true;
                    Boolean matchedHVVoltage = true;
                    Boolean matchedCoreVoltage = true;
                    Boolean matchedTechType = true;
                    
                    if(UtilsString.isNotBlank(maskLayer) || UtilsString.isNotBlank(IOVoltage) ||
                       UtilsString.isNotBlank(HVVoltage) || UtilsString.isNotBlank(coreVoltage) || 
                       UtilsString.isNotBlank(techType)){
                    
                        //filter for mask layers
                        if(UtilsString.isNotBlank(maskLayer)){
                            matchedMaskLayer = temp.matchedMaskLayers(maskLayer);                                                       
                        }    
                        
                        //filter for IO Voltage
                        if(UtilsString.isNotBlank(IOVoltage)){ 
                            matchedIOVoltage = temp.matchedIOVoltage(IOVoltage);                                                      
                        }
                        
                        //filter for HV Voltage
                        if(UtilsString.isNotBlank(HVVoltage)){ 
                            matchedHVVoltage = temp.matchedHVVoltage(HVVoltage);                                                      
                        }
                        
                        //filter for core Voltage
                        if(UtilsString.isNotBlank(coreVoltage)){ 
                            matchedCoreVoltage = temp.matchedCoreVoltage(coreVoltage);                                                      
                        }
                        
                        //filter for tech type
                        if(UtilsString.isNotBlank(techType)){ 
                            matchedTechType = temp.matchedTechType(techType);
                        }
                        
                        if(matchedMaskLayer && matchedIOVoltage && matchedHVVoltage && matchedCoreVoltage &&
                           matchedTechType){
                            this.rows.add(temp);    
                        }
                    } else {
                        this.rows.add(temp);
                    }
                    counter++;
                } else {
                    break;
                }
            }
            this.processCount = this.rows.size();
            paginate(this.rows);                                                                                                                       
        }                      
        
        public void sort(String sortColumn,String sortType){
            Map<Object,List<IPRow>> groups = new Map<Object,List<IPRow>>();
            String numericFields = 'No Of Mask Layer;NO OF RETICLES;Poly Layers;NVALUE';
            
            for(IPRow i: this.rows){
                if(i.fieldsMap.containsKey(sortColumn)){
                    Object key;
                    if(numericFields.contains(sortColumn)){
                        String currVal = i.fieldsMap.get(sortColumn).value;
                        if(UtilsString.isNotBlank(currVal)){
                            key = Double.valueOf(currVal);
                        }                            
                    } else {
                        key = i.fieldsMap.get(sortColumn).value;
                    }
                    
                    if(groups.containsKey(key)){
                        groups.get(key).add(i);
                    } else {
                        groups.put(key,new List<IPRow>{i});
                    }
                }
            } 
            
            List<Object> sortedKey = new List<Object>();
            sortedKey.addAll(groups.keyset());
            sortedKey.sort();
            
            this.rows = new List<IPRow>();
            if(sortType == 'asc'){
                for(Object s: sortedKey){
                    this.rows.addAll(groups.get(s));
                }
            } else {
                for(Integer counter = sortedKey.size()-1; counter >= 0; counter --){
                    this.rows.addAll(groups.get(sortedKey[counter]));
                }
            }
                                 
            paginate(this.rows);
        }
        
        private void paginate(List<IPRow> rows){
            Integer pageCount = 1;
            Integer counter = 1;
            this.pages = new Map<Integer,List<IPRow>>();
            
            for(IPRow i: rows){
                if(counter < OFFSET){
                    
                    if(this.pages.containsKey(pageCount)){
                        this.pages.get(pageCount).add(i);
                    } else {
                        this.pages.put(pageCount, new list<IPRow>{i});
                    }
                    counter++;
                } else {
                    this.pages.get(pageCount).add(i);
                    pageCount++;
                    counter = 1;
                }
            }
        }       
    }
    
    //Apex class wrapper for storing IP details
    public class IPRow {     
        public Process__c process {get; set;}  
        public Boolean isViewDetail {get; set;}
        public List<FieldWrapper> fields {get; set;}        
        public String processId {get; set;}
        public Map<String,FieldWrapper> fieldsMap;
        private String maskLayer; 
        private String IOVoltage;       
        private String HVVoltage;       
        private String coreVoltage;       
        private String techType;       
        
        public IPRow(Process__c process,
                     Map<String,Schema.FieldSetMember> IPFieldsMap,
                     Map<String,String> optionalCols,
                     String pairedMasks){ 
                                           
            this.fields = new List<FieldWrapper>();
            this.fieldsMap = new Map<String,FieldWrapper>();            
            this.processId = process.id;
            
            //Process object record will only be used when generating reports 
            //to minimize heap size limit
            //this record will be used in field sets
            if(UtilsString.isNotBlank(GENERATETYPE)){
                this.process = process;
            }                        
            
            for(String c: COLUMNSORT.split('\\,')){
                
                String value = String.valueOf(process.get(IPFieldsMap.get(c).getFieldPath()));
                
                //concatenate the paired mask layers for backed processes
                if(c == 'Mask Layers' && UtilsString.isNotBlank(pairedMasks)){
                    value = UtilsString.isNotBlank(value) ?
                            value + ', '+ pairedMasks :
                            pairedMasks;
                }
                             
                FieldWrapper temp = new FieldWrapper(
                    c,
                    value,
                    optionalCols
                );
                
                if(c == 'Mask Layers'){
                    this.maskLayer = value;
                }
                
                if(c == 'IO Voltages'){
                    this.IOVoltage = value;    
                }                                
                
                this.fields.add(temp); 
                this.fieldsMap.put(c,temp);                                                             
            }
            
            //Add advanced filters not visible as columns to the search result
            List<String> advancedFilters = new List<String>{
                'HV Voltages',
                'Core Voltages',
                'Tech Type'};

            for(String c: advancedFilters){
                String value = String.valueOf(process.get(IPFieldsMap.get(c).getFieldPath()));
                
                if(c == 'HV Voltages'){
                    this.HVVoltage = value;    
                }
                
                if(c == 'Core Voltages'){
                    this.coreVoltage = value;    
                }
                
                if(c == 'Tech Type'){
                    this.techType = value;    
                }
            }                
        }
                 
        
        public Boolean matchedTechType(String techType){
            List<String> techTypeList = techType.split('\\,');
                     
            if(UtilsString.isNotBlank(this.techType)){                                      
                for(String i: techTypeList){                                                   
                    if(!this.techType.contains(i)){
                        return false;
                    }    
                }
            } else {
                return false;
            }
            return true;
        } 
        
        public Boolean matchedCoreVoltage(String coreVoltage){
            List<String> coreVoltageList = coreVoltage.split('\\,');
                     
            if(UtilsString.isNotBlank(this.coreVoltage)){                                      
                for(String i: coreVoltageList){                                                   
                    if(!this.coreVoltage.contains(i)){
                        return false;
                    }    
                }
            } else {
                return false;
            }
            return true;
        } 
        
        public Boolean matchedHVVoltage(String HVVoltage){
            List<String> HVVoltageList = HVVoltage.split('\\,');
                     
            if(UtilsString.isNotBlank(this.HVVoltage)){                                      
                for(String i: HVVoltageList){                                                   
                    if(!this.HVVoltage.contains(i)){
                        return false;
                    }    
                }
            } else {
                return false;
            }
            return true;
        }   
        
        public Boolean matchedIOVoltage(String IOVoltage){
            List<String> IOVoltageList = IOVoltage.split('\\,');
                     
            if(UtilsString.isNotBlank(this.IOVoltage)){                                      
                for(String i: IOVoltageList){                                                   
                    if(!this.IOVoltage.contains(i)){
                        return false;
                    }    
                }
            } else {
                return false;
            }
            return true;
        }   
        
        public Boolean matchedMaskLayers(String maskFilters){
            List<String> maskList = maskFilters.split('\\,');
            
            if(UtilsString.isNotBlank(this.maskLayer)){
                for(String m: maskList){                                   
                    if(!this.maskLayer.contains(m)){
                        return false;
                    }    
                }
            } else {
                return false;
            }
            return true;
        }                               
    }
    
    public class FieldWrapper {
        public String name {get; set;}
        public String value {get; set;}
        public Boolean isOptional {get; set;}
        
        public FieldWrapper(String name,String value,Map<String,String> optionalCols){
            this.name = name;
            this.value = value;
            this.isOptional = optionalCols.containsKey(name);                                    
        }                
    }
}