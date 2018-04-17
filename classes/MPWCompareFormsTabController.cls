/*
    Author: Abhita Bansal
    Description: This serves as.
    History: 
        ABansal     007082015    - page creation.
*/

public class MPWCompareFormsTabController {
    
    public List<MPW_Process_Information_Question__c> mpwpiqList{get;set;}
    public List<MPW_Process_Information_Question__c> mpwpiqList1{get;set;}
    public List<TechModuleAnswersWrapper> mpwtmawList{get;set;}
    public UtilClassToGetAllFields util{get;set;}
    public List<MPW_Prime_Die__c> mpwpdList{get;set;}
    public List<MPW_Prime_Die__c> mpwpdList1{get;set;}
    public List<MPW_Prime_Die__c> mpwpdList2{get;set;}
    public List<MPWPrimeDieWrapper> mpwpdList3{get;set;}
    public List<MPW_Reservation__c> mpwResfList {get; set;}
    public List<MPW_Reservation__c> mpwResfList1 {get; set;}
    public Boolean compareValue{get; set;}
    public String mpwForm1{get; set;}
    public String mpwForm2{get; set;}
    public String mpwForm1Category{get;set;}
    public String mpwForm2Category{get;set;}
    public Set<String> quesList;
    public String resForm1;
    public Map<String, String> ansList;
    public Map<String, String> ansList1;
    public Map<String, list<String>> mapques;
    
    public MPWCompareFormsTabController (ApexPages.StandardController sc) {
    
        util = new UtilClassToGetAllFields();
        this.mpwtmawList = new List<TechModuleAnswersWrapper>();
        this.mpwpdList3 = new List<MPWPrimeDieWrapper>();
        this.mpwResfList = new List<MPW_Reservation__c>();
        this.mpwResfList1 = new List<MPW_Reservation__c>();
        this.mpwpiqList = new List<MPW_Process_Information_Question__c>();
        this.mpwpiqList1 = new List<MPW_Process_Information_Question__c>();
        this.mpwpdList = new List<MPW_Prime_Die__c>();
        this.mpwpdList1 = new List<MPW_Prime_Die__c>();
        this.mpwpdList2 = new List<MPW_Prime_Die__c>();
        quesList = new Set<String>();
        ansList = new Map<String, String>();
        ansList1 = new Map<String, String>();
        mapques = new Map<String, List<String>>();
         
        this.compareValue = false;
        
        if(ApexPages.currentPage().getParameters().get('Form1') != null) {
            this.mpwForm1 = ApexPages.currentPage().getParameters().get('Form1');
        }
    }
    
    public void retrieveMPWFormData() {
    	
    	quesList = new Set<String>();
        ansList = new Map<String, String>();
        ansList1 = new Map<String, String>();
        mapques = new Map<String, List<String>>();
        this.mpwpdList2 = new List<MPW_Prime_Die__c>();
        this.mpwtmawList = new List<TechModuleAnswersWrapper>();
        this.mpwpdList3 = new List<MPWPrimeDieWrapper>();
        
        String queryFieldsResForm = '';
        String queryFieldsProcessInfo = '';
        String queryRes1 = '';
        String queryRes2 = '';
        String queryProcess1 = '';
        String queryProcess2 = '';
        String queryFieldsPd = '';
        String queryPd = '';
        String queryFieldsPd1 = '';
        String queryPd1 = '';
        
    	if(mpwForm1 == '' || mpwForm2 == ''){
    		this.compareValue = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Form # does not exist.'));
        }
        else{
	        queryFieldsResForm = util.getAllFields('MPW_Reservation__c');
	        queryRes1 = 'select '+queryFieldsResForm+' from MPW_Reservation__c where Name =\''+mpwForm1+'\'';
	        this.mpwResfList = database.query(queryRes1);
	        
	        queryRes2 = 'select '+queryFieldsResForm+' from MPW_Reservation__c where Name =\''+mpwForm2+'\'';
	        this.mpwResfList1 = database.query(queryRes2);
	        
	        if(this.mpwResfList.isEmpty()){
	        	this.compareValue = false;
	        	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Form # '+mpwForm1+' does not exist.'));
	        }
	        else if(this.mpwResfList1.isEmpty()){
	        	this.compareValue = false;
	        	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Form # '+mpwForm2+' does not exist.'));
	        }
	        else{
	        	
	        this.compareValue = true;	
	        	
	        if(!this.mpwResfList.isEmpty()){
	        	this.mpwForm1Category = this.mpwResfList[0].Category__c;
	        	
	        	this.mpwpiqList = new List<MPW_Process_Information_Question__c>();
		        queryFieldsProcessInfo = util.getAllFields('MPW_Process_Information_Question__c');
		        queryFieldsProcessInfo += ', MPW_Maintenance_Details__r.MPW_Tech_Module__r.Question__c, MPW_Maintenance_Details__r.Answers__c';
		        queryProcess1 = 'select '+queryFieldsProcessInfo+' from MPW_Process_Information_Question__c where MPW_Reservation_Form__c =\''+mpwResfList[0].Id+'\' ORDER BY Name ';
		        this.mpwpiqList = database.query(queryProcess1);
		        
		        this.mpwpdList = new List<MPW_Prime_Die__c>();
		        queryFieldsPd = util.getAllFields('MPW_Prime_Die__c');
		        queryFieldsPd += ', MPW_Form__r.Name, GMPL_Project_Name__r.Name';
		        queryPd = 'select '+queryFieldsPd+' from MPW_Prime_Die__c where MPW_Form__c = \''+this.mpwResfList[0].Id+'\' ORDER BY Name';
		        this.mpwpdList = database.query(queryPd);
	        }
	        
	        if(!this.mpwResfList1.isEmpty()){
	        	this.mpwForm2Category = this.mpwResfList1[0].Category__c;
	        	
	        	this.mpwpiqList1 = new List<MPW_Process_Information_Question__c>();
	        	queryFieldsProcessInfo = util.getAllFields('MPW_Process_Information_Question__c');
	        	queryFieldsProcessInfo += ', MPW_Maintenance_Details__r.MPW_Tech_Module__r.Question__c, MPW_Maintenance_Details__r.Answers__c';
		        queryProcess2 = 'select '+queryFieldsProcessInfo+' from MPW_Process_Information_Question__c where MPW_Reservation_Form__c =\''+mpwResfList1[0].Id+'\' ORDER BY Name ';
		        this.mpwpiqList1 = database.query(queryProcess2);
		        
		        this.mpwpdList1 = new List<MPW_Prime_Die__c>();
		        queryFieldsPd1 = util.getAllFields('MPW_Prime_Die__c');
		        queryFieldsPd1 += ', MPW_Form__r.Name, GMPL_Project_Name__r.Name';
		        queryPd1 = 'select '+queryFieldsPd1+' from MPW_Prime_Die__c where MPW_Form__c = \''+this.mpwResfList1[0].Id+'\' ORDER BY Name';
		        this.mpwpdList1 = database.query(queryPd1);
	        }
	        
	        if(this.mpwpdList.size() > this.mpwpdList1.size()) {
	            for(Integer i=0; i<this.mpwpdList.size()-this.mpwpdList1.size();i++) {
	                MPW_Prime_Die__c mpwPdEmpty = new MPW_Prime_Die__c();
	                this.mpwpdList1.add(mpwPdEmpty);
	            }
	        } else {
	            for(Integer i=0; i<this.mpwpdList1.size()-this.mpwpdList.size();i++) {
	                MPW_Prime_Die__c mpwPdEmpty = new MPW_Prime_Die__c();
	                this.mpwpdList.add(mpwPdEmpty);
	            }
	        }
	        
	        
	        Integer list1 = 0;      
	        for(MPW_Prime_Die__c pD1st : this.mpwpdList){            
	            if(list1 < this.mpwpdList.size()) {
	                this.mpwpdList2.add(pD1st);
	                this.mpwpdList2.add(mpwpdList1[list1]);
	            }
	            list1++;
	        }    
	        
	             
	        for(Integer i=0; i<this.mpwpdList2.size()-1; i++){
	            
	            if(math.mod(i,2) == 0){
	                MPWPrimeDieWrapper temp1 = new MPWPrimeDieWrapper();
	                temp1.formName = mpwForm1;
	                temp1.mpwPrimeDieTest = mpwpdList2[i];
	                this.mpwpdList3.add(temp1);
	            }
	            i++;
	            if(math.mod(i,2) == 1){
	                MPWPrimeDieWrapper temp2 = new MPWPrimeDieWrapper();
	                temp2.formName = mpwForm2;
	                if(mpwpdList2[i].Prime_Die_Name__c != mpwpdList2[i-1].Prime_Die_Name__c) {
	                    temp2.isPrimeDieName = true;
	                }
	                if(mpwpdList2[i].Drawn_Die_Size_X_um__c != mpwpdList2[i-1].Drawn_Die_Size_X_um__c) {
	                    temp2.isDrawnX = true;
	                }
	                if(mpwpdList2[i].Drawn_Die_Size_Y_um__c != mpwpdList2[i-1].Drawn_Die_Size_Y_um__c) {
	                    temp2.isDrawnY = true;
	                }
	                if(mpwpdList2[i].Device_Type__c != mpwpdList2[i-1].Device_Type__c) {
	                    temp2.isDeviceType = true;
	                }
	                if(mpwpdList2[i].Delivery_Qty_Die_Form__c != mpwpdList2[i-1].Delivery_Qty_Die_Form__c) {
	                    temp2.isQtyDie = true;
	                }
	                if(mpwpdList2[i].Delivery_Qty_Wafer_Form__c != mpwpdList2[i-1].Delivery_Qty_Wafer_Form__c) {
	                    temp2.isQtyWafer = true;
	                }
	                if(mpwpdList2[i].Drawn_Orientation_Restricted_Structures__c != mpwpdList2[i-1].Drawn_Orientation_Restricted_Structures__c) {
	                    temp2.isDrawnOrient = true;
	                }
	                if(mpwpdList2[i].Metal_Stack__c != mpwpdList2[i-1].Metal_Stack__c) {
	                    temp2.isMetalStack = true;
	                }
	                if(mpwpdList2[i].Corner_Split__c != mpwpdList2[i-1].Corner_Split__c) {
	                    temp2.isCornerSplit = true;
	                }
	                if(mpwpdList2[i].POR__c != mpwpdList2[i-1].POR__c) {
	                    temp2.isPOR = true;
	                } 
	                if(mpwpdList2[i].FF__c != mpwpdList2[i-1].FF__c) {
	                    temp2.isFF = true;
	                } 
	                if(mpwpdList2[i].SS__c != mpwpdList2[i-1].SS__c) {
	                    temp2.isSS = true;
	                } 
	                if(mpwpdList2[i].FS__c != mpwpdList2[i-1].FS__c) {
	                    temp2.isFS = true;
	                } 
	                if(mpwpdList2[i].SF__c != mpwpdList2[i-1].SF__c) {
	                    temp2.isSF = true;
	                } 
	                if(mpwpdList2[i].GMPL_Project_Name__r.Name != mpwpdList2[i-1].GMPL_Project_Name__r.Name) {
	                    temp2.isGMPLProject = true;
	                }
	                if(mpwpdList2[i].GMPL_Purpose__c != mpwpdList2[i-1].GMPL_Purpose__c) {
	                    temp2.isGMPLRemarks = true;
	                }
	                if(mpwpdList2[i].ShortLoop_Wafer__c != mpwpdList2[i-1].ShortLoop_Wafer__c) {
	                    temp2.isShortLoop = true;
	                } 
	                if(mpwpdList2[i].Backgrind__c != mpwpdList2[i-1].Backgrind__c) {
	                    temp2.isBackgrind = true;
	                } 
	                if(mpwpdList2[i].Expedite_In_DIE_Form__c != mpwpdList2[i-1].Expedite_In_DIE_Form__c) {
	                    temp2.isExDie = true;
	                } 
	                if(mpwpdList2[i].Expedite_In_WAFER_Form__c != mpwpdList2[i-1].Expedite_In_WAFER_Form__c) {
	                    temp2.isExWafer = true;
	                } 
	                if(mpwpdList2[i].Turnkey_Service__c != mpwpdList2[i-1].Turnkey_Service__c) {
	                    temp2.isTurnkeySer = true;
	                } 
	                temp2.mpwPrimeDieTest = mpwpdList2[i];
	                this.mpwpdList3.add(temp2);
	            }
	        }
	        
	        
	        if(!mpwpiqList.isEmpty()) {            
	            for(MPW_Process_Information_Question__c m: this.mpwpiqList){
	                quesList.add(m.MPW_Maintenance_Details__r.MPW_Tech_Module__r.Question__c);
	                ansList.put(m.MPW_Maintenance_Details__r.MPW_Tech_Module__r.Question__c, m.Answer__c);
	            }
	        }
	        
	        if(!mpwpiqList1.isEmpty()) {
	            for(MPW_Process_Information_Question__c m: this.mpwpiqList1){
	                quesList.add(m.MPW_Maintenance_Details__r.MPW_Tech_Module__r.Question__c);
	                ansList1.put(m.MPW_Maintenance_Details__r.MPW_Tech_Module__r.Question__c, m.Answer__c);
	            }
	        }
	        
	        
	        if(!quesList.isEmpty()) {
	            for(String s: quesList){           
	                TechModuleAnswersWrapper temp = new TechModuleAnswersWrapper();
	                temp.question = s;
	                temp.answer1 = ansList.get(s);
	                temp.answer2 = ansList1.get(s);    
	                this.mpwtmawList.add(temp);      
	            }   
	        }  
	        }
        }
    }
    
    public List<TechModuleAnswersWrapper> getMPWTrainMaintenanceDetailList() {
        return this.mpwtmawList;
    }
    
    public List<MPWPrimeDieWrapper> getMPWPrimeDieList() {
        return this.mpwpdList3;
    }
  
    public class TechModuleAnswersWrapper {
        public String question{get;set;}
        public String answer1{get;set;}
        public String answer2{get;set;}
        
        public TechModuleAnswersWrapper() {
            question = '';
            answer1 = '';
            answer2 = '';
        }
    }
    
    public class MPWPrimeDieWrapper {
        public boolean isPrimeDieName {get;set;}
        public boolean isDrawnX {get;set;}
        public boolean isDrawnY {get;set;}
        public boolean isDeviceType {get;set;}
        public boolean isQtyDie {get;set;}
        public boolean isQtyWafer {get;set;}
        public boolean isDrawnOrient {get;set;}
        public boolean isMetalStack {get;set;}
        public boolean isCornerSplit {get;set;}
        public boolean isPOR {get;set;}
        public boolean isFF {get;set;}
        public boolean isSS {get;set;}
        public boolean isFS {get;set;}
        public boolean isSF {get;set;}
        public boolean isGMPLProject {get;set;}
        public boolean isGMPLRemarks {get;set;}
        public boolean isShortLoop {get;set;}
        public boolean isBackgrind {get;set;}
        public boolean isExDie {get;set;}
        public boolean isExWafer {get;set;}
        public boolean isTurnkeySer {get;set;}
        public String formName {get;set;}
        public MPW_Prime_Die__c mpwPrimeDieTest {get;set;}
    }       
}