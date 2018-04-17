/*
    Author: Ariz Solito
    Description: Apex class controller for the VF ProcessTechnologyIPReport
    History: 
        Asolito     27012014    - Code creation.
        Asolito     11042014    - Added IP Request button
        Asolito     14042014    - Added metal stacks advanced search
        Asolito     02052014    - Added functionality for external customer access
        Asolito     07172014    - Added the ff. features:
                                  1. Removed IP Lifecycle stage column
                                  2. Add new columns: Latest DK status (use IP Design Kit Lifecycle field of the latest DK)
                                  3. Change IP Lifecycle advanced filter logic
                                  4. Filtered out IPs with lifecycle IN (Inactive and EOL)
        Prashant    10212014      Added functionality for external customer so that they can get access for all technology.
        DBiswal     11132014      Added code for displaying extra columns in IPList section.
        ASolito     12182014    - added limit in generateList method to limit heap size  
        Asolito     01142015    - Added select all functionality for view all
                                - Made Release to Customer optional
        Asolito     01272015    - Added filter Display_in_IP_Catalog__c = Yes for IPs 
        Asolito     05182015    - Fix case #40852 (generated IP list mismatch between UI and PDF)                                
        RaviTeja.B  01242017    - Fix for Case#00061044 (Query limited to 1000)
        NJain       01022017    - Fix for Case#00062663 (Removing the 150 Ip limit)
		Ravi Teja B 31052017    - Commented and Added by Ravi Teja for Case#00064724
		Ravi Teja B 08112017    - Added By Ravi Teja for Case#00071844
*/
public class ProcessTechnologyIPReportCntrlr { 
    //Asolito 12182014 - added limit in generateList method to limit heap size
    final private static Integer PT_IP_REPORT_DETAIL_ROW_COUNT_LIMIT = UtilsString.isNotBlank(EnvironmentVariable.get('PT_IP_REPORT_DETAIL_ROW_COUNT_LIMIT')) ?
                                                                       Integer.valueOf(EnvironmentVariable.get('PT_IP_REPORT_DETAIL_ROW_COUNT_LIMIT')) :
                                                                       500;
    
    final private static String IPVENDORGROUP = EnvironmentVariable.get('IP_VENDOR');
    
    //11132014 DBiswal - Added custom setting containing extra columns for sorting    
    //final private static String COLUMNSORT = EnvironmentVariable.get('PT_IP_REPORT_COLUMN_SORT');       
    final private static String COLUMNSORT = EnvironmentVariable.get('PT_IP_REPORT_COLUMN_SORT1')+EnvironmentVariable.get('PT_IP_REPORT_COLUMN_SORT2');               

    //11132014 DBiswal - Added custom setting containing extra optional columns 
    //final private static String OPTIONALCOLUMNS = EnvironmentVariable.get('PT_IP_REPORT_OPTIONAL_COLUMN'); 
    final private static String OPTIONALCOLUMNS = EnvironmentVariable.get('PT_IP_REPORT_OPTIONAL_COLUMN1') + EnvironmentVariable.get('PT_IP_REPORT_OPTIONAL_COLUMN2'); 
    
    final private static Integer OFFSET =  UtilsString.isNotBlank(EnvironmentVariable.get('PT_IP_REPORT_OFFSET_SIZE')) ?
                                           Integer.valueOf(EnvironmentVariable.get('PT_IP_REPORT_OFFSET_SIZE')) :
                                           10;
    
    final private static Integer ROWCOUNT = UtilsString.isNotBlank(EnvironmentVariable.get('PT_IP_REPORT_ROW_COUNT_LIMIT')) ?
                                            Integer.valueOf(EnvironmentVariable.get('PT_IP_REPORT_ROW_COUNT_LIMIT')) :
                                            1000;                                              
             
    final private static List<String> LIFECYCLEFILTER = UtilsString.isNotBlank(EnvironmentVariable.get('PT_IP_REPORT_LIFECYLE_FILTER')) ?
                                                        EnvironmentVariable.get('PT_IP_REPORT_LIFECYLE_FILTER').split('\\,') :
                                                        new List<String>();
    
    final private static String ERROR_MESSAGE = 'You are not authorised! \nYour NDA has expired. \nPlease contact your account manager for new NDA or Extension';
    
    public String genReport {get; set;}
    public IPList ipList {get; set;}
    Public List<String> geos {get; set;}
    public Boolean showList {get; set;}
    public Boolean noPTFilterPicked {get; set;}
    public Boolean isExternalUser {get; set;}
    public Boolean isIPVendor {get; set;}
    public Boolean hasNoAccess {get; set;}
    public String IPID {get; set;}
    public String renderAsPDF {get; set;}
    public String renderAsExcel {get; set;}
    public String ptName {get; set;}        
    public String ptNumber {get; set;}
    public String ipType {get; set;}
    public String ipVendor {get; set;}
    public String ipLifecycle {get; set;}
    public String deviceName {get; set;}
    public String ipName {get; set;}
    public String metalStacks {get; set;}
    public String allColumns {get; set;}
    public String dummyColumns {get; set;}    
    public String addedColumns {get; set;}
    public String sortField {get; set;}
    public String sortType {get; set;}
    public String viewIPDetails {get; set;} 
	public String ipOffering {get; set;}								//Added By Ravi Teja.B for Case#00071844	
    public Integer currPageNumber {get; set;} 
    public Integer totalPages {get; set;}
    public Integer paginationSize{get;set;}
    public Integer addedColumnsCount {get; set;}
    public Integer maxRowCount {get; set;}
    public List<IPRow> currPage {get; set;}
    private Set<String> geometries;
    private Set<String> ptNames;
    private Set<String> ipTypes;
    private Set<String> ipLifecycles; 
    private Set<String> grantedPTs;   
    private Map<String,Set<String>> ipVendors;
    private String vendorPriceBookID;
    private Boolean isVIewDetail;
    
    //Init
    public ProcessTechnologyIPReportCntrlr(){
        this.isExternalUser = false;   
        this.isIPVendor = false;   
        this.hasNoAccess = false; 
        this.isViewDetail = false;
        this.addedColumns = '';     
        this.addedColumnsCount = 0;
        this.offsetValue = 0;
        this.paginationSize = OFFSET;
        this.lastPageOffset = 0;
        this.maxRowCount = PT_IP_REPORT_DETAIL_ROW_COUNT_LIMIT;       
        this.ipList = new IPList(); 
        this.currPage = new List<IPRow>();        
        
        this.genReport =  ApexPages.currentPage().getParameters().get('generate');
        
        //get the process technology field filters
        this.geometries = new Set<String>();
        this.ptNames = new Set<String>();
        geos=new list<string>();
                 
        //check if user is internal or external          
        User u = [SELECT contactId,contact.account.has_valid_nda__c,contact.account.tech_geo_granted__c,
                         contact.account.short_name__c,contact.accountid
                    FROM User
                    WHERE id = :userInfo.getUserId()];
        
        //store the granted PTs
        this.grantedPTs = new Set<String>();                                
        
        //store the product codes for IP vendor types for filtering the IP geometry tech later
        String productCodes = '';
        if(UtilsString.isNotBlank(u.contactId)){
            //check if it has NDA or not 
            //and has tech geometry granted
            this.isExternalUser = true;
                                    
            //ip vendor 
            if(UtilsString.isNotBlank(u.contact.account.short_name__c) && IPVENDORGROUP.contains(u.contact.account.short_name__c)){ 
                this.isIPVendor = true;                 
                            
                for(Apttus_Config2__PriceListItem__c a: [SELECT apttus_config2__productId__r.pt_number__c,
                                                                apttus_config2__productId__r.productCode,
                                                                apttus_config2__priceListId__c
                                                           FROM Apttus_Config2__priceListItem__c
                                                           WHERE apttus_config2__productId__r.family IN ('PT\'s','PTs')
                                                           AND apttus_config2__priceListId__c IN (
                                                               SELECT apttus_QPConfig__priceListId__c 
                                                                 FROM Apttus_Proposal__Proposal__c 
                                                                 WHERE Apttus_Proposal__Account__c = :u.contact.accountid
                                                                )]){
                    this.grantedPTs.add(a.apttus_config2__productId__r.pt_number__c); 
                    this.vendorPriceBookID = a.apttus_config2__priceListId__c;
                    productCodes += a.apttus_config2__productId__r.productCode.toUpperCase() +';';
                    
                }                      
            } 
            else { 
                if(u.contact.account.has_valid_nda__c && UtilsString.isNotBlank(u.contact.account.tech_geo_granted__c)){
                        geos = u.contact.account.tech_geo_granted__c.split('\\;');                       
                    
                    for(Product2 p: [SELECT pt_number__c
                                       FROM Product2
                                       WHERE geometry__c IN :geos]){
                        this.grantedPTs.add(p.pt_number__c);                                    
                    }                                                                            
                }                                                                               
            }                                         
        } 
        
        String query = 'SELECT count(id),ip_geometry_technology__c '+
                       '  FROM Process_Technology__c ';
        
        if(this.isExternalUser){
            if(this.isIPVendor){
            
              query += 'WHERE pt_number__c IN :grantedPTs ';
            }else{
              query += 'WHERE Tech_Geometry__c IN :geos ';
            
            }
        
            
        }                          
        
        query += 'GROUP BY ip_geometry_technology__c '+
                 'LIMIT :ROWCOUNT';
                                
        List<AggregateResult> PTs = Database.query(query);
                
        for(AggregateResult p: PTs){            
            if(UtilsString.isNotBlank(p.get('ip_geometry_technology__c'))){
                String val = (String.valueOf(p.get('ip_geometry_technology__c')));
                
                if(this.isIPVendor){
                    for(String v: val.split('\\;')){
                        if(v == 'NA'){
                            this.ptNames.add(v);
                        } else {
                            if(productCodes.contains(v.toUpperCase())){
                                this.ptNames.add(v);
                            }
                        }
                        System.debug('======ptNamesIf:'+ptNames);
                    }                   
                } else {
                    this.ptNames.add(val);
                    System.debug('======ptNamesElse:'+ptNames);
                }
            }
        }
        
        if(this.ptNames.size() == 0){
            this.hasNoAccess = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ERROR_MESSAGE));
        }                         
        
        //render as PDF or excel
        if(UtilsString.isNotBlank(genReport)){
            this.IPID = UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('ipid')) ?
                        ApexPages.currentPage().getParameters().get('ipid') :
                        null;
            this.ptName = UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('ptname')) ?
                          ApexPages.currentPage().getParameters().get('ptname') :
                          null;
            this.ptNumber = UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('ptnumber')) ?
                            ApexPages.currentPage().getParameters().get('ptnumber') :
                            null;               
            this.ipType = UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('iptype')) ?
                          ApexPages.currentPage().getParameters().get('iptype') :
                          null;
            this.ipVendor = UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('ipvendor')) ?
                            ApexPages.currentPage().getParameters().get('ipvendor') :
                            null;
            this.ipLifecycle = UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('iplifecycle')) ?
                               ApexPages.currentPage().getParameters().get('iplifecycle') :
                               null;
            this.deviceName = UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('devicename')) ?
                              ApexPages.currentPage().getParameters().get('devicename') :
                              null;                               
            this.ipName = UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('ipname')) ?
                          ApexPages.currentPage().getParameters().get('ipname') :
                          null;
            this.metalStacks = UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('metalstacks')) ?
                               ApexPages.currentPage().getParameters().get('metalstacks') :
                               null;                            
            this.viewIPDetails =  UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('ipdetails')) ?
                                 ApexPages.currentPage().getParameters().get('ipdetails') :
                                 null;                            
            this.addedColumns =  UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('cols')) ?
                                 ApexPages.currentPage().getParameters().get('cols') :
                                 null;
			this.ipOffering = UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('ipoffering')) ?
                          ApexPages.currentPage().getParameters().get('ipoffering') :
                          null;
            
            if(UtilsString.isNotBlank(this.addedColumns)){
                this.addedColumns = EncodingUtil.urlDecode(this.addedColumns,'UTF-8');
                this.addedColumnsCount = this.addedColumns.split('\\;').size();
            }                                                                                            
                                                              
            if(genReport == 'pdf'){
                this.renderAsPDF = 'pdf';
            } else if (genReport == 'excel'){
                this.renderAsExcel = 'application/vnd.ms-excel#IPReport.xls';
            }
            this.offsetValue = UtilsString.isNotBlank(ApexPages.currentPage().getParameters().get('offsetValue')) ?
                               Integer.valueOf(ApexPages.currentPage().getParameters().get('offsetValue')) :
                               0;
            query();
        }                                                                                    
        
        //get the IP field filters
        this.ipTypes = new Set<String>();                                     
        this.ipVendors = new Map<String,Set<String>>();
        this.ipLifecycles = new Set<String>();                
        for(AggregateResult agg : [SELECT ip_type__c type,ip_vendor__c vendor,lifecycle__c life
                                    FROM Base_IP__c GROUP BY ip_type__c,ip_vendor__c,lifecycle__c]){
            if(string.valueof(agg.get('life')) != null)
            this.ipLifecycles.add(string.valueof(agg.get('life')));
            
            if(UtilsString.isNotBlank(string.valueof(agg.get('type')))){
                this.ipTypes.add(string.valueof(agg.get('type')));
                if(this.ipVendors.containsKey(string.valueof(agg.get('type')))){
                    this.ipVendors.get(string.valueof(agg.get('type'))).add(string.valueof(agg.get('vendor')));
                } else {
                    this.ipVendors.put(string.valueof(agg.get('type')),new Set<String>{string.valueof(agg.get('vendor'))});
                }
            }                             
        }                                                                                                                                                                                                
    }
    
    //Method will export the report generated in pdf
    public PageReference exportToPDF(){  
        return export('pdf');             
        return null;
    }
    
    //Method will export the report generated in excel
    public PageReference exportToExcel(){ 
        return export('excel');             
        return null;
    }
    
    private PageReference export(String genReport){        
        PageReference pageRef = new PageReference('/apex/ProcessTechnologyIPReportExport');
        pageRef.getParameters().put('generate',genReport);
        pageRef.getParameters().put('ipid',this.IPID);
        pageRef.getParameters().put('ptname',this.ptName);
        pageRef.getParameters().put('ptnumber',this.ptNumber);
        pageRef.getParameters().put('iptype',this.ipType);
        pageRef.getParameters().put('ipvendor',this.ipVendor);
        pageRef.getParameters().put('iplifecycle',this.ipLifeCycle);
        pageRef.getParameters().put('devicename',this.deviceName);
        pageRef.getParameters().put('ipname',this.ipName);
        pageRef.getParameters().put('metalstacks',this.metalStacks);
        pageRef.getParameters().put('cols',this.addedColumns);
		pageRef.getParameters().put('ipoffering',this.ipoffering);
        pageRef.getParameters().put('offsetValue',string.valueOf(this.offsetValue));
        
        //get the IPs with flagged IP details
        String IPs = '';
        System.debug(IPs);
        for(Integer counter = 0; counter < this.ipList.rows.size(); counter ++){
            if(counter < 50){
                if(this.ipList.rows[counter].isViewDetail){
                    System.debug(IPs);      
                    IPs += this.ipList.rows[counter].ipName + ';';
                }   
            }
        }                
        
        if(IPs.length() > 1){
            IPs = IPs.substring(0,IPs.lastIndexOf(';'));
        }
        pageRef.getParameters().put('ipdetails',IPs);
        pageRef.setRedirect(true);
        
        return pageRef;
    }
    
    //Method will tick/untick the show details of the IP rows
    public PageReference showDetails(){
        this.ipList.showDetails(this.isViewDetail);
        
        if(this.isViewDetail){
            this.isViewDetail = false;
        } else {
            this.isViewDetail = true;
        }
        clearFilters();
        return null;
    }
    
    //++ Nikhil- 16Jan17 - methods for Pagination for fetching the new set of IP records.
    public integer offsetValue{get;set;}
    public integer lastPageOffset{get;set;}
    
    //Method will go to the first page
    public PageReference first(){
        offsetValue =  0;
        query();
        this.currPageNumber = 1;
        if(this.ipList.pages.containsKey(this.currPageNumber)){
            this.currPage = this.ipList.pages.get(this.currPageNumber);
        }        
        return null;
    }
    
    //Method will go to the next page
    public PageReference next(){
        this.currPageNumber++;
        if(currPageNumber > totalPages){
            offsetValue =  offsetValue + PT_IP_REPORT_DETAIL_ROW_COUNT_LIMIT;
            if(offsetValue > ipList.ipCount){
                offsetValue = offsetValue - PT_IP_REPORT_DETAIL_ROW_COUNT_LIMIT;
            }
            query();
        }
        if(this.ipList.pages.containsKey(this.currPageNumber)){
            this.currPage = this.ipList.pages.get(this.currPageNumber);
        }
        return null;
    }
    
    //Method will go to the previous page
    public PageReference previous(){
        if(this.currPageNumber > 1){
            this.currPageNumber--;
        }else{
            offsetValue =  offsetValue - PT_IP_REPORT_DETAIL_ROW_COUNT_LIMIT;
            if(offsetValue<0){
                offsetValue = 0;
            }
            query();
            if(this.ipList.pages.containsKey(this.totalPages)){
                this.currPage = this.ipList.pages.get(this.totalPages);
                this.currPageNumber = this.totalPages;
            }
            return null;
        }
        if(this.ipList.pages.containsKey(this.currPageNumber)){
            this.currPage = this.ipList.pages.get(this.currPageNumber);
        }
        return null;
    }
    
    //Method will go to the last page
    public PageReference last(){
        offsetValue =  integer.valueOf(math.floor(decimal.valueOf(ipList.ipCount!=NULL?ipList.ipCount:0)/ decimal.valueOf(PT_IP_REPORT_DETAIL_ROW_COUNT_LIMIT))*PT_IP_REPORT_DETAIL_ROW_COUNT_LIMIT);
        query();
        this.currPageNumber = this.totalPages;
        
        if(this.ipList.pages.containsKey(this.currPageNumber)){
            this.currPage = this.ipList.pages.get(this.currPageNumber);
        }
        return null;
    }
    //-- Nikhil- 16Jan17 - methods for Pagination for fetching the new set of IP records.
    
    //Method will do sorting based on the clicked header
    public PageReference sort(){        
        
        this.ipList.sort(this.sortField,this.sortType);
        this.currPageNumber = 1;
        
        if(this.ipList.pages.containsKey(1)){
            this.currPage = this.ipList.pages.get(1);
        }
        clearFilters();
        return null;
    }
    
    //Method will add columns to the result table
    public PageReference addColumns(){
        if(UtilsString.isNotBlank(this.addedColumns)){
            this.addedColumnsCount = this.addedColumns.split('\\;').size();            
        } else {
            this.addedColumnsCount = 0;
        }
        clearFilters();        
        return null;
    } 
    
    //Method will clear blank filters in the result header 
    private void clearFilters(){
        //set device Name and ip Name to null if blank
        if(!UtilsString.isNotBlank(this.metalStacks)){
            this.metalStacks = null;
        }
        
        if(!UtilsString.isNotBlank(this.ptNumber)){
            this.ptNumber = null;
        }
                
        if(!UtilsString.isNotBlank(this.deviceName)){
            this.deviceName = null;
        }
        
        if(!UtilsString.isNotBlank(this.ipName)){
            this.ipName = null;
        }
        
        if(!UtilsString.isNotBlank(this.metalStacks)){
            this.metalStacks = null;
        }
        
        if(!UtilsString.isNotBlank(this.IPID)){
            this.IPID = null;
        }
    }        
     
    
    //Method will refresh vendor picklist
    public PageReference refreshVendor(){             
        return null;        
    }      
    
    //Method will generate the optional columns for the result
    public List<SelectOption> getOptionalColumns(){
        List<SelectOption> result = new List<SelectOption>();
        
        //11132014 DBiswal - Exclude columns not to be displayed to external users 
        if(isExternalUser){
            for(String o: OPTIONALCOLUMNS.split('\\,')){
                if((!o.equalsIgnoreCase('Process Owner')) || (!o.equalsIgnoreCase('Process Development Status')) || 
                   (!o.equalsIgnoreCase('Fab'))){
                    result.add(new SelectOption(o,o));
                }                
            }
        }else{
            for(String o: OPTIONALCOLUMNS.split('\\,')){
                result.add(new SelectOption(o,o));
            }
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

    //Method will generate IP Life cycle picklist
    public List<SelectOption> getIPLifecycleList(){
        List<SelectOption> result = new List<SelectOption>();
        result.add(new SelectOption('','ALL'));
        
        //filter lifecycle values to not include LIFECYCLEFILTER values        
        for(String l: LIFECYCLEFILTER){
            if(this.ipLifecycles.contains(l)){
                result.add(new SelectOption(l,l));
            }
        }
        return result;
    }
    
    //Method will generate IP vendor picklist
    public List<SelectOption> getIPVendorList(){      
        List<SelectOption> result = new List<SelectOption>();
        Set<String> upperCasedValues = new Set<String>();
        //Commented and Added by Ravi Teja for Case#00064724
        /*if(this.ipVendors.containsKey(this.ipType)){
            for(String i: this.ipVendors.get((this.ipType))){
                upperCasedValues.add(i.toUpperCase());            
            }
		}*/
		for(String s: ipVendors.keyset()){
            for(String i: this.ipVendors.get(s)){
				 if(i != null && i != '')
                upperCasedValues.add(i.toUpperCase());
            }
        }  
        return generatePickList(upperCasedValues);
    }
            
    //Method will generate IP type picklist
    public List<SelectOption> getIPTypeList(){
        return generatePickList(this.ipTypes);
    }
    
    //Method will generate PT Names picklist
    public List<SelectOption> getPTNameList(){
        Set<String> parsedValues = new Set<String>();
        for(String p: this.ptNames){
            if(UtilsString.isNotBlank(p)){
                parsedValues.addAll(p.split('\\;'));
            }
        }
        
        List<SelectOption> result = generatePickList(parsedValues);
        
        //remove ALL option and change to SELECT
        result.remove(0); 
        if(result.size() > 0){
            result.add(0,new SelectOption('','--SELECT--'));
        } else {
            result.add(new SelectOption('','--SELECT--'));
        }
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
        //select 1 process technology or pt number validation or IP ID
        if(!UtilsString.isNotBlank(this.ptName) && !UtilsString.isNotBlank(this.ptNumber) && !UtilsString.isNotBlank(this.IPID)){
            this.noPTFilterPicked = true;                               
        } else { 
            //parse device filters
            if(UtilsString.isNotBlank(this.deviceName)){
                this.deviceName = this.deviceName.replace(' ','').toLowerCase();
            }  

            this.ipList.generateList(this.IPID,
                                     this.ptName,
                                     this.ptNumber,
                                     this.ipType,
                                     this.ipVendor,
                                     this.ipLifecycle,
                                     this.deviceName,
                                     this.ipName,
                                     this.metalStacks,
									 this.ipOffering,
                                     this.isExternalUser,
                                     this.grantedPTs,
                                     this.vendorPriceBookID,
                                     UtilsString.isNotBlank(this.genReport) ? true : false,
                                     this.offsetValue); 
            this.showList = true;            
            this.noPTFilterPicked = false;
            
            this.currPageNumber = 1;            
            this.sortType = '';
            this.totalPages = this.ipList.pages.size();
            this.lastPageOffset = integer.valueOf(math.floor(decimal.valueOf(ipList.ipCount)/ decimal.valueOf(PT_IP_REPORT_DETAIL_ROW_COUNT_LIMIT))*PT_IP_REPORT_DETAIL_ROW_COUNT_LIMIT);
            
            if(!UtilsString.isNotBlank(this.genReport)){
                this.addedColumns = ''; 
                this.addedColumnsCount = 0;
            }
            
            if(this.ipList.pages.containsKey(this.currPageNumber)){
                this.currPage = this.ipList.pages.get(this.currPageNumber);
            }            
        }
        
        clearFilters();
        
        return null;   
    }  
    
    //Apex class wrapper to generate the IP list
    public class IPList {
        public Process_Technology__c pt;
        public List<IPRow> rows {get; set;}
        public Integer ipCount {get; set;}
        public List<String> tableColumns {get; set;}
        public String optionalColumnsText {get; set;}
        public Map<String,String> optionalCols {get; set;} 
        public Map<Integer,List<IPRow>> pages {get; set;}
        private List<Schema.FieldSetMember> reportFieldSet;
        
        //Init
        public IPList(){
            this.rows = new List<IPRow>();
            this.tableColumns = COLUMNSORT.split('\\,');
            this.optionalCols = new Map<String,String>();
            this.pages = new Map<Integer,List<IPRow>>();
            this.optionalColumnsText = OPTIONALCOLUMNS;
            
            for(String o: OPTIONALCOLUMNS.split('\\,')){
                this.optionalCols.put(o,o);    
            } 
            
            this.reportFieldSet = SObjectType.Base_IP__c.FieldSets.Process_Technology_IP_Report.getFields();           
        }
        
        //Method tick/untick the show details column of the IP row
        public void showDetails(Boolean isViewDetail){
            for(IPRow i: this.rows){
                if(isViewDetail){
                    i.isViewDetail = false;
                } else {
                    i.isViewDetail = true;
                }
            }
        }
        
        //Method will generate the IP list
        public void generateList(String IPID,
                                 String ptName,
                                 String ptNumber,
                                 String ipType,
                                 String ipVendor,
                                 String ipLifecycle,
                                 String deviceName,
                                 String ipName,
                                 String metalStacks,
								 string ipoffering,
                                 Boolean isExternalUser,
                                 Set<String> grantedPTs,
                                 String vendorPriceBookID,
                                 Boolean isGenerateReport,
                                 Integer offsetValue){
                                 
            this.rows = new List<IPRow>();       
            List<String> IPIds = new List<String>();                        
            system.debug('coming in generateLst');
            //get the IP ids from the PT - IP junction object
            String query1 = 'SELECT ipNumber__r.name,ipNumber__c,pt_number__r.ip_geometry_technology__c '+
                            '  FROM IP_PT_Map__c ';
                         
            Map<string,GeometryPTNumberMapping__c> mapCS = GeometryPTNumberMapping__c.getAll();              
            
            //Added for case #00048299 : accessing custom setting
            if(UtilsString.isNotBlank(ptName) && mapCS.get(ptName) != null){
                    system.debug('coming for custom setting');
                    query1 += 'WHERE pt_number__r.pt_number__c = ' + '\'' + mapCS.get(ptName).PT_Number__c + '\'' ;
            }  
            else{ 
             system.debug('coming not for custom setting');             
                //add process technology filter                            
                if(UtilsString.isNotBlank(ptName)){                
                    query1 += 'WHERE pt_number__r.ip_geometry_technology__c LIKE \'%'+ ptName +'%\' '+
                              'AND pt_number__r.ip_geometry_technology__c <> null ';
                }
                
                //add pt number filter                            
                if(UtilsString.isNotBlank(ptNumber)){
                    System.debug('pt number filter '+ptNumber);
                    if(query1.contains('WHERE')){
                        query1 += 'AND pt_number__r.pt_number__c = :ptNumber ';
                    } else {
                        //check if pt filter is granted for external users                                                             
                        if(isExternalUser && !UtilsString.isNotBlank(vendorPriceBookID)){ 
                                             
                            //add the pt filter if its on the granted PTs
                            if(grantedPTs.contains(ptNumber.toUpperCase())){
                                query1 += 'WHERE pt_number__r.pt_number__c = :ptNumber '; 
                                   
                            //throw a null value on the pt filter for 0 result if the pt input
                            //is not on the granted PTs
                            } else {
                                query1 += 'WHERE pt_number__r.pt_number__c = null ';    
                            }               
                        } else {
                            query1 += 'WHERE pt_number__r.pt_number__c = :ptNumber ';
                        }
                    }
                }
            }
            
            //add IP ID filter
            if(UtilsString.isNotBlank(IPID)){
                if(query1.contains('WHERE')){
                    query1 += 'AND ipNumber__r.name = :IPID ';
                } else {
                    query1 += 'WHERE ipNumber__r.name = :IPID ';
                }    
            }
            
            //if external user is IP vendor             
            if(UtilsString.isNotBlank(vendorPriceBookID)){
                String query2 = 'SELECT tech_geometry__c '+
                                ' FROM Process_Technology__c ';
                
                 //Added for case #00048299 : accessing custom setting
                if(UtilsString.isNotBlank(ptName) && mapCS.get(ptName) != null){
                    query2 += 'WHERE pt_number__c = '+ '\'' + mapCS.get(ptName).PT_Number__c + '\'';
                }
                else{                
                    if(UtilsString.isNotBlank(ptName)){
                        query2 += 'WHERE ip_geometry_technology__c LIKE \'%'+ ptName +'%\' ';
                    }
                    
                    if(UtilsString.isNotBlank(ptNumber)){                                                
                        if(query2.contains('WHERE')){
                            query2 += 'AND pt_number__c = :ptNumber ';
                        } else {
                            query2 += 'WHERE pt_number__c = :ptNumber ';
                        }
                    }
                }
                query2 += 'LIMIT 1';                                                       
                
                String geometry;
                for(Process_Technology__c r: database.query(query2)){
                    geometry = r.tech_geometry__c;
                }
                
                //add IP ID filter
                if(UtilsString.isNotBlank(IPID)){
                    if(query1.contains('WHERE')){
                        query1 += 'AND ipNumber__r.ip_number__c = :IPID ';
                    } else {
                        query1 += 'WHERE ipNumber__r.ip_number__c = :IPID ';
                    }    
                } else {
                
                    List<String> IPNumbers = new List<String>();
                    for(Apttus_Config2__PriceListItem__c a: [SELECT apttus_config2__productId__r.productCode
                                                               FROM Apttus_Config2__priceListItem__c
                                                               WHERE apttus_config2__priceListId__c = :vendorPriceBookID
                                                               AND apttus_config2__productId__r.family = 'IPs'
                                                               AND apttus_config2__productId__r.geometry__c = :geometry]){   
                                                                                            
                        IPNumbers.add(a.apttus_config2__productId__r.productCode);                       
                    }
                    

                    //add the available IPs to the main query
                    query1 += 'AND ipNumber__r.ip_number__c IN :IPNumbers ';  
                }              
            } else {
                 if(UtilsString.isNotBlank(IPID)){
                    if(query1.contains('WHERE')){
                        query1 += 'AND ipNumber__r.ip_number__c = :IPID ';
                    } else {
                        query1 += 'WHERE ipNumber__r.ip_number__c = :IPID ';
                    }    
                }
            }
            
            
            System.debug('pt name '+ptName);
            System.debug('query1 '+query1);
                                                                                                                                   
            List<IP_PT_Map__c> PTs = database.query(query1);                
            for(IP_PT_Map__c p :PTs){
                if(UtilsString.isNotBlank(ptName)){
                    if(p.pt_number__r.ip_geometry_technology__c.contains(ptName)){                                              
                        IPIds.add(p.ipNumber__c);
                    }
                } else {
                    IPIds.add(p.ipNumber__c);
                }
            } 
            system.debug('---->IPIDs'+IPIds);
            //If IP ID search filter is filled out, check if the                         
            
            //generate the IP query
            String query3 = 'SELECT id,name,ip_number__c,';
            Set<String> uniqueFields = new Set<String>();

            //for fetching the complete result set count
            String completeResult = 'SELECT id ';
            
            //main field set
            for(Schema.FieldSetMember f : this.reportFieldSet) {
                uniqueFields.add(f.getFieldPath());
            }
           
            if(isGenerateReport){
                //add the other IP field sets for report generation
                for(Schema.FieldSetMember f : SObjectType.Base_IP__c.FieldSets.IP_Type_Specific_Data_Logic.getFields()) {
                    uniqueFields.add(f.getFieldPath());
                }
                
                for(Schema.FieldSetMember f : SObjectType.Base_IP__c.FieldSets.IP_Type_Specific_Data_IO.getFields()) {
                    uniqueFields.add(f.getFieldPath());
                }
                
                for(Schema.FieldSetMember f : SObjectType.Base_IP__c.FieldSets.IP_Type_Specific_Data_Memory.getFields()) {
                    uniqueFields.add(f.getFieldPath());
                }
                
                for(Schema.FieldSetMember f : SObjectType.Base_IP__c.FieldSets.IP_Type_Specific_Data_AMS.getFields()) {
                    uniqueFields.add(f.getFieldPath());
                }
                
                for(Schema.FieldSetMember f : SObjectType.Base_IP__c.FieldSets.IP_Type_Specific_Data_PHYs.getFields()) {
                    uniqueFields.add(f.getFieldPath());
                }
                
                for(Schema.FieldSetMember f : SObjectType.Base_IP__c.FieldSets.IP_Type_Specific_Data_NVM.getFields()) {
                    uniqueFields.add(f.getFieldPath());
                }
                
                for(Schema.FieldSetMember f : SObjectType.Base_IP__c.FieldSets.IP_Type_Specific_Data_Core.getFields()) {
                    uniqueFields.add(f.getFieldPath());
                }
            }
            
            for(String u: uniqueFields){
                query3 += u + ', ';
            }
            
            //get IP design kit fieldset           
            query3 += '(SELECT IPNumber__c,latest_design_kit__c,';
                                                
            for(Schema.FieldSetMember f : SObjectType.IP__c.FieldSets.IP_Design_Kit.getFields()) {
                query3 += f.getFieldPath() + ', ';
            }
            
            //remove last comma
            query3 = query3.substring(0,query3.lastIndexOf(','));            
            query3 += ' FROM IP_Design_Kit__r '+
                      ' ORDER BY latest_design_kit__c DESC,name DESC '+
                      ' LIMIT 1),';
            
            //get only latest IP design kit if not generating report 
            //to minimize viewstate size
            
            //Asolito 05182015 - commented out codes due to mismatch in UI list and PDF
            /*if(!isGenerateReport){
                query3 += 'LIMIT 1),';    
            } else {
                query3 += '),';
            }*/                    
            
            //get IP merge fieldset
           if(isGenerateReport){            
                uniqueFields = new Set<String>();
                
                query3 += '(SELECT id, ';
                
                for(Schema.FieldSetMember f : SObjectType.IP_Merge__c.FieldSets.IP_Silicon_Report.getFields()) {
                    uniqueFields.add(f.getFieldPath());
                }
                
                for(Schema.FieldSetMember f : SObjectType.IP_Merge__c.FieldSets.IP_Merged_Design_Kit.getFields()) {
                    uniqueFields.add(f.getFieldPath());
                }
                
                for(String u: uniqueFields){
                    query3 += u + ', ';
                }
                
                query3 = query3.substring(0,query3.lastIndexOf(','));            
                query3 +=' FROM IP_Merge__r '+
                         ' ORDER BY name), ';
            }
                     
            //get IP PT mapping
            Set<String> uniquePTfields = new Set<String>(); 
            
            for(Schema.FieldSetMember f : SObjectType.Process_Technology__c.FieldSets.PT_Columns.getFields()) { 
                uniquePTfields.add(f.getFieldPath()); 
            } 
            
            for(Schema.FieldSetMember f : SObjectType.Process_Technology__c.FieldSets.IP_PT_Columns.getFields()) {                
                uniquePTfields.add(f.getFieldPath()); 
            }
                       
            query3 += ' (SELECT pt_number__c, ';            
            
            for(String u:uniquePTfields){ 
                query3 += 'pt_number__r.'+ u + ', '; 
            } 
                        
            query3 = query3.substring(0,query3.lastIndexOf(','));              
            query3 += ' FROM IP_PT_Mapping__r '+
                      ' ORDER BY pt_number__r.name) ';
            
            query3 +=' FROM Base_IP__c '+ ' WHERE id IN :IPIds ';
            completeResult +=' FROM Base_IP__c '+ ' WHERE id IN :IPIds ';
            
            //add ip type filter
            if(UtilsString.isNotBlank(ipType)){
                query3 += 'AND ip_type__c = :ipType ';
                completeResult += 'AND ip_type__c = :ipType ';
            }          
            //add ip offering filter
            system.debug('offering==>'+ipOffering);
            if(UtilsString.isNotBlank(ipOffering)){
                if(ipOffering == 'ASIC')
                	query3 += 'AND Is_ASIC_IP__c = true ';
				else
                    query3 += 'AND Is_ASIC_IP__c = false ';
            }
            //add ip vendor filter
            if(UtilsString.isNotBlank(ipVendor)){
                query3 += 'AND ip_vendor__c = :ipVendor ';
                completeResult += 'AND ip_vendor__c = :ipVendor ';
            } 
            
            //add ip lifecycle filter
            if(UtilsString.isNotBlank(ipLifecycle)){
                query3 += 'AND lifecycle__c = :ipLifecycle ';
                completeResult += 'AND lifecycle__c = :ipLifecycle ';
            } else {
                if(LIFECYCLEFILTER.size() > 0){
                    query3 += 'AND lifecycle__c IN (';
                    completeResult += 'AND lifecycle__c IN (';
                    for(String l: LIFECYCLEFILTER){
                        query3 += '\'' + l + '\',';
                        completeResult += '\'' + l + '\',';
                    }                              
                    query3 = query3.substring(0,query3.lastIndexOf(',')) + ') ';
                    completeResult = completeResult.substring(0,completeResult.lastIndexOf(',')) + ') ';
                }
            }
            
            //add release to customer = YES filter for external users          
            if(isExternalUser){
                query3 += 'AND release_to_customer__c = \'Yes\' ';
                completeResult += 'AND release_to_customer__c = \'Yes\' '; 
            } 
            
            //only show IPs with 'Display in IP Catalog' = 'Yes'                      
            query3 += 'AND Display_in_IP_Catalog__c = \'Yes\' ';
            completeResult += 'AND Display_in_IP_Catalog__c = \'Yes\' ';
            
            query3 += 'ORDER BY name,ip_vendor__c,ip_type__c,ip_type_category__c ';
            completeResult += 'ORDER BY name,ip_vendor__c,ip_type__c,ip_type_category__c ';
            
            if(!isGenerateReport){
                query3 += 'LIMIT :PT_IP_REPORT_DETAIL_ROW_COUNT_LIMIT OFFSET ' + offsetValue;
            }
            
            System.debug('query 3 '+query3);
            //create the IP row record                                    
            List<Base_IP__c> IPs = database.query(query3);
            List<Base_IP__c> TotalIPs = database.query(completeResult);
            
            //DBiswal - Get the related Process__c
            List<IP_PT_MAP__c> ippt1 = new List<IP_PT_MAP__c>();
            List<String> processlistName = new List<String>();
            for(IP_PT_Map__c i : ippt1){
                processlistName.add(i.pt_number__r.name);
            }
            
            List<Process__c> processlist1 = new List<Process__c>(); 
            String processQuery = ''; 
            Set<String> uniqueProcessfields = new Set<String>(); 
            for(Schema.FieldSetMember f : SObjectType.Process__c.FieldSets.ProcessTechnology_IP_Section.getFields()) { 
                uniqueProcessfields.add(f.getFieldPath()); 
            }
            
            processQuery = 'SELECT '; 
                for(String u: uniqueProcessfields){ 
                processQuery += u + ', '; 
            } 
            
            //for removing last comma 
            processQuery = processQuery.substring(0,processQuery.lastIndexOf(','));  
            processQuery += '  FROM Process__c WHERE Process_Technology__c IN: processlistName '; 
            processlist1 = database.query(processQuery); 
            
            Map<String,Schema.FieldSetMember> IPFieldsMap = new Map<String,Schema.FieldSetMember>();
            for(Schema.FieldSetMember r : this.reportFieldSet) {
                IPFieldsMap.put(r.getLabel(),r);
            }
                                             
            for(Base_IP__c i :IPs){            
                //do device name or ip name filter if deviceName or ipName param has value 
                if(UtilsString.isNotBlank(deviceName) || UtilsString.isNotBlank(ipName) || UtilsString.isNotBlank(metalStacks)){
                    Boolean deviceNameMatch = true;
                    Boolean ipNameMatch = true; 
                    Boolean metalStacksMatch = true; 
                    IPRow temp = new IPRow(i,IPFieldsMap,this.optionalCols,/*ippt1,*/processlist1,isGenerateReport);
                    
                    if(UtilsString.isNotBlank(metalStacks)){
                        metalStacksMatch = temp.matchedMetalStacks(metalStacks);                    
                    }
                                                                                     
                    if(UtilsString.isNotBlank(deviceName)){
                        deviceNameMatch = temp.matchedDeviceName(deviceName);                    
                    }
                    
                    if(UtilsString.isNotBlank(ipName)){
                        ipNameMatch = temp.matchedIPName(ipName);                    
                    }                                                                       
                                        
                    if(deviceNameMatch && ipNameMatch && metalStacksMatch){
                        this.rows.add(temp);                                         
                    }
                } else {
                    this.rows.add(new IPRow(i,IPFieldsMap,this.optionalCols,/*ippt1,*/processlist1,isGenerateReport));
                }
            }
            this.ipCount = TotalIPs.size();
            paginate(this.rows);                                                                                                                       
        }
        
        public void sort(String sortColumn,String sortType){
            Map<String,List<IPRow>> groups = new Map<String,List<IPRow>>();
            
            for(IPRow i: this.rows){
                if(i.fieldsMap.containsKey(sortColumn)){
                    String key = i.fieldsMap.get(sortColumn).value;
                    if(groups.containsKey(key)){
                        groups.get(key).add(i);
                    } else {
                        groups.put(key,new List<IPRow>{i});
                    }
                }
            } 
            
            List<String> sortedKey = new List<String>();
            sortedKey.addAll(groups.keyset());
            sortedKey.sort();
            
            this.rows = new List<IPRow>();
            if(sortType == 'asc'){
                for(String s: sortedKey){
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
        public Base_IP__c ip {get; set;}        
        public String deviceList {get; set;}
        public String ipID {get; set;} 
        public String latestVersionDesc {get; set;}
        public Boolean isViewDetail {get; set;}
        public List<FieldWrapper> fields {get; set;}
        public String IPName;
        transient Base_IP__c ipRec;
        public Map<String,FieldWrapper> fieldsMap;
        transient Map<String,Schema.FieldSetMember> IPFieldsMap;        
              
        //public List<IP_PT_MAP__c> ippt = new List<IP_PT_MAP__c>();
        public List<Process__c> processlist = new List<Process__c>();        
        
        public IPRow(Base_IP__c ip,
                     Map<String,Schema.FieldSetMember> IPFieldsMap,
                     Map<String,String> optionalCols,
                    /*List<IP_PT_MAP__c> ippt1,*/
                    List<Process__c> processlist1,
                    Boolean isGenerateReport){
            
            //ASOLITO 1/12/2015
            //populate only for export report to minimize viewstate
            if(isGenerateReport){       
                this.ip = ip;        
            }
            
            this.isViewDetail = false;
            this.iPRec = ip;
            this.ipID = ip.id; 
            this.IPName = ip.name;
            this.IPFieldsMap = IPFieldsMap;            
            this.fields = new List<FieldWrapper>();
            this.fieldsMap = new Map<String,FieldWrapper>();
            //this.ippt = ippt1; 
            this.processlist = processlist1;
            
               for(String c: COLUMNSORT.split('\\,')){
                System.debug(c);              
                
                if(c == 'IP Description'){
                    FieldWrapper temp = new FieldWrapper(
                        c,
                        String.valueOf(this.iPRec.get('description__c')),
                        optionalCols
                    );
                    
                    this.fields.add(temp); 
                    this.fieldsMap.put(c,temp);                    
                } else if(c == 'Vendor IP Version') {
                    String val;
                    for(IP__c i: this.iPRec.IP_Design_Kit__r){
                        if(i.latest_design_kit__c){ 
                            val = String.valueOf(i.get('description__c'));                                                                                               
                        }                        
                    }  
                    FieldWrapper temp = new FieldWrapper(
                        c,
                        val,
                        optionalCols
                    );
                            
                    this.fields.add(temp);
                    this.fieldsMap.put(c,temp); 
                } else if(c == 'Latest DK Status'){
                    String val;
                    for(IP__c i: this.iPRec.IP_Design_Kit__r){
                        if(i.latest_design_kit__c){ 
                            val = String.valueOf(i.get('lifecycle__c'));                                                                                               
                        }                        
                    }  
                    FieldWrapper temp = new FieldWrapper(
                        c,
                        val,
                        optionalCols
                    );
                            
                    this.fields.add(temp);
                    this.fieldsMap.put(c,temp);                               
                } 
                 //11132014 DBiswal - Conditions to retrieve Column values from PT
                else if(c=='PT Number' || c=='PT Name' ||
                        c=='Lifecycle Phase' || c=='PT Description' || 
                        c=='PT Long Description' || c=='Technology Geometry' || 
                        c=='Technology Type' || c=='Sub Technology Type'){    
                    String val;
                    
                    
                    for(IP_PT_MAP__c i: this.iPRec.IP_PT_Mapping__r){                        
                  
                        if(c == 'PT Number') {                                                    
                            val= String.valueOf(i.pt_number__r.pt_number__c);                                                                                                                                      
                        } else if(c == 'PT Name') {                                                
                            val= String.valueOf(i.pt_number__r.Name);                                                                                                                                        
                        } else if(c == 'Lifecycle Phase') {                                               
                            val= String.valueOf(i.pt_number__r.Lifecycle__c);                                                                                                                                             
                        } else if(c == 'PT Description') {                                                
                            val = String.valueOf(i.pt_number__r.Description__c);                                                                                               
                        } else if(c == 'PT Long Description') {                                                
                             val = String.valueOf(i.pt_number__r.Long_Description__c);                                                                                                                                             
                        } else if(c == 'Technology Geometry') {                                                
                             val = String.valueOf(i.pt_number__r.Tech_Geometry__c);                                                                                                                                            
                        } else if(c == 'Technology Type') {                                                
                             val = String.valueOf(i.pt_number__r.Tech_Type__c);                                                                                                                                             
                        } else if(c == 'Sub Technology Type') {                                               
                            val = String.valueOf(i.pt_number__r.Sub_Tech_Type__c);                                                                                                                                       
                        }  
                    }
                    FieldWrapper temp = new FieldWrapper(
                            c,
                            val,
                            optionalCols
                        );
                            
                    this.fields.add(temp);
                    this.fieldsMap.put(c,temp);
                    
                }
                //11132014 DBiswal - Conditions to retrieve Column values from Process
                else if(c=='Legacy Process ID' || c=='Process Type' ||
                        c=='Associated Backend Process ID' || c=='Process Owner' || 
                        c=='Process Development Status' || c=='Fab'){
                        String val;
                        
                        for(Process__c p: this.processlist){
                            if(c == 'Legacy Process ID') {
                                val = String.valueOf(p.Name);
                            } else if(c == 'Process Type') { 
                                val = String.valueOf(p.Process_Type__c);                                                                                               
                            } else if(c == 'Associated Backend Process ID') { 
                                val = String.valueOf(p.Associated_PID__c);                                                                                               
                            } else if(c == 'Process Owner') { 
                                val = String.valueOf(p.Process_Owner__c);                                                                                               
                            } else if(c == 'Process Development Status') {
                                val = String.valueOf(p.Process_Dev_Status__c);
                            } else if(c == 'Fab') { 
                                val = String.valueOf(p.Org_ID__c);                                                                                               
                            }
                        }
                                                                                           
                        FieldWrapper temp = new FieldWrapper(
                            c,
                            val,
                            optionalCols
                        );
                            
                    this.fields.add(temp);
                    this.fieldsMap.put(c,temp);
                }
                else {
                    if(this.IPFieldsMap.containsKey(c)){
                        FieldWrapper temp = new FieldWrapper(
                            c,
                            String.valueOf(this.iPRec.get(this.IPFieldsMap.get(c).getFieldPath())),
                            optionalCols
                        );
                        
                        this.fields.add(temp); 
                        this.fieldsMap.put(c,temp);                   
                    }
                }                                
                
            }                                                                    
        } 
        
        //Check if metal stack list has the same metal stack filter
        public Boolean matchedMetalStacks(String metalStacks){
            metalStacks = metalStacks.toUpperCase().deleteWhiteSpace();
            
            List<String> metals = metalStacks.split('\\,');
            
            if(UtilsString.isNotBlank(this.iPRec.metal_layers__c)){ 
                for(String m: metals){ 
                    if(!this.iPRec.metal_layers__c.toUppercase().contains(m)){                        
                        return false;
                    }
                }     
            } else {
                return false;
            }
                                  
            return true;    
        } 
        
        //Check if IP device list has the device name filter
        public Boolean matchedDeviceName(String deviceName){
            deviceName = deviceName.deleteWhiteSpace();
            List<String> devices = deviceName.split('\\,');
            Boolean hasDesignKit= false;
            
            for(IP__c i: this.iPRec.IP_Design_Kit__r){
                hasDesignKit = !hasDesignKit ? true : hasDesignKit;
                if(UtilsString.isNotBlank(i.device_list__c)){ 
                    for(String d: devices){                                        
                        if(!i.device_list__c.contains(d)){                        
                            return false;
                        }
                    }    
                } else {
                    return false;
                }                                
            }
            
            if(!hasDesignKit){
                return false;
            }
            return true;
        }  
        
        //Check if IP device list has the device name filter
        public Boolean matchedIPName(String ipName){          
            if(UtilsString.isNotBlank(this.iPRec.description__c)){    
                String currIPName = this.iPRec.description__c.toUpperCase().deleteWhiteSpace();
                
                if(currIPName.contains(ipName.toUpperCase().deleteWhiteSpace())){
                    return true;
                }
            }
            return false;
        }                     
    }
    
    public class FieldWrapper{
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