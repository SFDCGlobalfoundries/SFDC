/*************************************************************************************************************************************************************
@ Class:          CustomerSatisfactionBarChartExtention
@ Version:        1.0
@ Author:         Sandesh Singh
@ Purpose:        Helper class which consist of logics used Bar chart from customer satisfaction
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 24.08.2017 / Sandesh Singh / Created the class.
                : 06.03.2018 / Sandesh Singh / Method getPostQBR() added to merge 2B record in 2A reports
                                             / Added by Customer Satisfaction 2.4 enhancment
**************************************************************************************************************************************************************/

public class CustomerSatisfactionBarChartExtention{
    
    Public String customerName{get;set;}
    Public String quarter {get;set;}
    public List <Customer_Satsfaction__c> cSList {get;set;}
    public String ScoreYear {get;set;}
    public Customer_Satsfaction__c custmerSat {get;set;}
    public String nextQBRBarChart {get;set;}
    public String nextQBRBarChart2 {get;set;}
    //Public String CName = CustomerName + '%';
    
    public CustomerSatisfactionBarChartExtention(ApexPages.StandardController controller){
        custmerSat = new Customer_Satsfaction__c();   
        CustomerSatisfactionReport__c custReport = CustomerSatisfactionReport__c.getInstance();
        nextQBRBarChart = custReport.X2A_Next_QBR_Barchart__c;
        nextQBRBarChart2 = custReport.X2A_Next_QBR_Barchart2__c;
    }
    
    // Return a list of data points for a chart
    private String[] stackTitles = new String[] {'New Technology', 'New Product', 'Yield Engineering','Quality','Capacity','Customer Service'};
        public String titles {
            get {
                return String.join(stackTitles, ',');
            }
        }
    
    /**
        * @description getPostQBR method return Post_QBR_Action_Plan__c which need to display on Customer Satisfaction Bar Chart
        * @param none
        * @return List<Post_QBR_Action_Plan__c> : list of POSTQBR which display on UI
        */
    public List<Post_QBR_Action_Plan__c> getPostQBR(){
        CustomerName = ApexPages.currentPage().getParameters().get('CustomerName');
        return [Select Id,Name,Account__c,Assginee__c,Category__c,Completion__c,Merit_Index_for_customers__c,
                Results__c,Site__c,Status_Color__c,Status__c,Status_in_colour__c,Subject__c,Target_Completion_Date__c
                From Post_QBR_Action_Plan__c
                Where Merit_Index_for_customers__r.Name =:CustomerName];
    } 
    
    /**
        * @description getData method return data which need to display on Customer Satisfaction Bar Chart
        * @param none
        * @return List<Data> : list of data which display on UI
        */
    public List<Data> getData() {
        CustomerName = '';
        CustomerName = ApexPages.currentPage().getParameters().get('CustomerName');
        ScoreYear = ApexPages.currentPage().getParameters().get('ScoreYear');
        quarter = ApexPages.currentPage().getParameters().get('Quarter');
        
        List<Data> data = new Data[6];
        Map<String,String> yearquarters = new Map<String,String>();
        Map<String,Set<String>> quarterMap =  new Map<String,Set<String>>{'Q4'=>new Set<String>{'Q4','Q3','Q2','Q1'},
            'Q3'=>new Set<String>{'Q3','Q2','Q1'},
                'Q2'=>new Set<String>{'Q2','Q1'},
                    'Q1'=>new Set<String>{'Q1'}};
                        if(CustomerName!= Null || CustomerName !=''){
                            cSList = [SELECT Name,New_Technology_Color__c,New_Product_Color__c,Yield_Engineering_Color__c,Quality_Color__c,
                                      Capacity_Color__c,Customer_Service_Color__c,Merit_Index_for_customers__r.Account__c,Merit_Index_for_customers__r.Account__r.Name,
                                      Score_Year__c, Quarter_New__c, Focus__c, Highlights__c,Lowlights__c, Customer_Satisfaction_yearly_score__c,
                                      Merit_Index_for_customers__r.Name,Site__c
                                      FROM Customer_Satsfaction__c 
                                      WHERE Merit_Index_for_customers__r.Account__c !=null 
                                      AND Merit_Index_for_customers__r.Name =:CustomerName 
                                      Order By Score_Year__c DESC, Quarter_New__c DESC];
                            
                            Integer count =5;
                            for(Customer_Satsfaction__c cs :cSList){
                                if(Integer.valueOf(cs.Score_Year__c) < Integer.valueOf(ScoreYear)
                                   || ((Integer.valueOf(cs.Score_Year__c) == Integer.valueOf(ScoreYear))
                                       && quarterMap.get(quarter).contains(cs.Quarter_New__c))){                                                
                                           data.add(count,new Data(cs.Name, cs.New_Technology_Color__c, cs.New_Product_Color__c, cs.Yield_Engineering_Color__c,cs.Quality_Color__c,cs.Capacity_Color__c,cs.Customer_Service_Color__c));
                                           if(cs.Name.equalsIgnoreCase(cs.Merit_Index_for_customers__r.Name  + ' ' + ScoreYear + ' ' + quarter))
                                           {   
                                               custmerSat = cs; 
                                           }
                                                
                                           count--;
                                           if(count <0)
                                               break;  
                                       } 
                            }
                        }
        
        if(cSList.isEmpty()){
            CustomerSatisfaction__c envObj = CustomerSatisfaction__c.getValues('Empty_Record_Error');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,envObj.Value__c));
            return null;
        }
        return data;
        
    }
    
    /**
* @description Wrapper class, which define data to display
*/
    public class Data {
        public String name { get; set; }
        public String data1 { get; set; }
        public String data2 { get; set; }
        public String data3 { get; set; }
        public String data4 { get; set; }
        public String data5 { get; set; }
        public String data6 { get; set; }
        
        public Data(String name, String data1, String data2, String data3 ,String data4,String data5,String data6) {
            this.name = name;
            this.data1 = data1;
            this.data2 = data2;
            this.data3 = data3;
            this.data4 = data4;
            this.data5 = data5;
            this.data6 = data6;
        }
    }
    public String getChartFilter() {
        integer pastQuarters = 5;
        map<string,string> qrtMap = new map<string,string>{'Q1'=>'3','Q2'=>'6','Q3'=>'9','Q4'=>'12' };
        map<integer,string> qtMap = new map<integer,string>{1=>'Q1',2=>'Q2',3=>'Q3',4=>'Q4'};
        Date startDate = Date.newInstance(integer.valueOf(ScoreYear),integer.valueOf(qrtMap.get(quarter)),1);
        string qtyr = ScoreYear+quarter+',';
        for (integer i = 0; i < pastQuarters; i++) {
            startDate = startDate.addMonths(-3);      
            integer quarter = (startDate.month()/ 3); 
            integer year =startDate.Year();
            qtyr+=string.valueOf(year)+string.valueOf(qtMap.get(quarter))+',';
        }
        qtyr=qtyr.removeEnd(',');
        system.debug('**qtyr'+qtyr);
        string filter ='[{"column":"Customer_Satsfaction__c.Merit_Index_for_customers__c.Name","operator":"contains","value":"'+CustomerName+'"},{"column":"Customer_Satsfaction__c.YearQuarter__c","operator":"equals","value":"'+qtyr+'"}]';
        return filter;
    }
}