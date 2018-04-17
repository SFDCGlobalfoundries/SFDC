public class QuaterlyScoreTrendAggregateController{
    private List<VoC_Score__c> vcsList;
    String tempStr;
    List<String> contactStr = new List<String>();
    public List<String> quatersToConsider = new List<String>();
    private Map<String,Map<String,Decimal>> mapQuarterAreaRecCount = new Map<String,Map<String,Decimal>>();
    private Map<String,Map<String,Decimal>> mapQuarterAreaScoreSum = new Map<String,Map<String,Decimal>>();
    private List<LinearData> linearData = new List<LinearData>();    
    private Map<String,Map<String,Decimal>> mapQuarterArea = new Map<String,Map<String,Decimal>>();
    
     public Boolean isSF1 {
        get {                   
            if(String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameHost')) ||
                String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameOrigin')) ||
                ApexPages.currentPage().getParameters().get('isdtp') == 'p1' ||
                (ApexPages.currentPage().getParameters().get('retURL') != null && ApexPages.currentPage().getParameters().get('retURL').contains('projectone') )
            ) {
                return true;
            }else{
                return false;
            }
        }
    }         
    
    public QuaterlyScoreTrendAggregateController(ApexPages.StandardController controller){        
            if(System.today().month()>=1 && System.today().month()<=3){
                quatersToConsider.add('Q1-'+System.today().year());
                quatersToConsider.add('Q4-'+System.today().addYears(-1).year());
                quatersToConsider.add('Q3-'+System.today().addYears(-1).year());
                quatersToConsider.add('Q2-'+System.today().addYears(-1).year());                        
            }
            else if(System.today().month()>3 && System.today().month()<=6){
                quatersToConsider.add('Q2-'+System.today().year());
                quatersToConsider.add('Q1-'+System.today().year());
                quatersToConsider.add('Q4-'+System.today().addYears(-1).year());
                quatersToConsider.add('Q3-'+System.today().addYears(-1).year());            
            }
            else if(System.today().month()>6 && System.today().month()<=9){            
                quatersToConsider.add('Q3-'+System.today().year());
                quatersToConsider.add('Q2-'+System.today().year());
                quatersToConsider.add('Q1-'+System.today().year());
                quatersToConsider.add('Q4-'+System.today().addYears(-1).year());
            }
            else{
                quatersToConsider.add('Q4-'+System.today().year());
                quatersToConsider.add('Q3-'+System.today().year());
                quatersToConsider.add('Q2-'+System.today().year());
                quatersToConsider.add('Q1-'+System.today().year());
            }
                
         for(Contact con:[Select id from Contact where accountId =: controller.getRecord().Id]){            
            tempStr = '' + con.id;
            contactStr.add(tempStr.substring(0,15));                   
        }       
        vcsList = [Select area__c,score__c,Quarter__c,Grade_5_best__c from VoC_Score__c where contact_Id__c in : contactStr and Quarter__c in : quatersToConsider];                               
    }           
    
    public List<LinearData> fetchLinearData(List<VoC_Score__c> vocScoreList){
       
        for(VoC_Score__c vcs : vocScoreList){           
            if(!mapQuarterAreaRecCount.containsKey(vcs.Quarter__c)){
                mapQuarterAreaRecCount.put(vcs.Quarter__c,new map<String,Decimal>());                           
            }            
            if(!mapQuarterAreaRecCount.get(vcs.Quarter__c).containsKey(vcs.Area__c)){
                    mapQuarterAreaRecCount.get(vcs.Quarter__c).put(vcs.Area__c,0);                    
            }
            if(!mapQuarterAreaScoreSum.containsKey(vcs.Quarter__c)){
                mapQuarterAreaScoreSum.put(vcs.Quarter__c,new map<String,Decimal>());                           
            }            
            if(!mapQuarterAreaScoreSum.get(vcs.Quarter__c).containsKey(vcs.Area__c)){
                    mapQuarterAreaScoreSum.get(vcs.Quarter__c).put(vcs.Area__c,0);                    
            }
            mapQuarterAreaRecCount.get(vcs.Quarter__c).put(vcs.Area__c,mapQuarterAreaRecCount.get(vcs.Quarter__c).get(vcs.Area__c) + 1); 
            mapQuarterAreaScoreSum.get(vcs.Quarter__c).put(vcs.Area__c,mapQuarterAreaScoreSum.get(vcs.Quarter__c).get(vcs.Area__c) + Integer.valueof(vcs.Grade_5_best__c));    
        }          
        
        for(String quat: quatersToConsider){
            decimal quatRecCount = 0;
            decimal technologyAvg = 0;
            decimal fabOpAvg = 0;
            decimal supplyAvg = 0;
            decimal enablementAvg = 0;
            decimal capacityAvg = 0;
            decimal attentivenessAvg = 0;
            decimal priceAvg = 0;                
            decimal doingBusinessAvg = 0;
            if(mapQuarterAreaRecCount.containsKey(quat) && mapQuarterAreaScoreSum.containskey(quat)){
                if(mapQuarterAreaRecCount.get(quat).containsKey('Technology Roadmap')){
                    quatRecCount += mapQuarterAreaRecCount.get(quat).get('Technology Roadmap');
                    technologyAvg = (mapQuarterAreaScoreSum.get(quat).get('Technology Roadmap')/mapQuarterAreaRecCount.get(quat).get('Technology Roadmap')).setScale(2);
                }
                if(mapQuarterAreaRecCount.get(quat).containsKey('Fab Operations')){
                    quatRecCount += mapQuarterAreaRecCount.get(quat).get('Fab Operations');
                    fabOpAvg = (mapQuarterAreaScoreSum.get(quat).get('Fab Operations')/mapQuarterAreaRecCount.get(quat).get('Fab Operations')).setScale(2);
                }
                if(mapQuarterAreaRecCount.get(quat).containsKey('Assurance of Supply')){
                    quatRecCount += mapQuarterAreaRecCount.get(quat).get('Assurance of Supply');
                    supplyAvg = (mapQuarterAreaScoreSum.get(quat).get('Assurance of Supply')/mapQuarterAreaRecCount.get(quat).get('Assurance of Supply')).setScale(2);
                }
                if(mapQuarterAreaRecCount.get(quat).containsKey('Design Enablement')){
                    quatRecCount += mapQuarterAreaRecCount.get(quat).get('Design Enablement');
                    enablementAvg = (mapQuarterAreaScoreSum.get(quat).get('Design Enablement')/mapQuarterAreaRecCount.get(quat).get('Design Enablement')).setScale(2);
                }
                if(mapQuarterAreaRecCount.get(quat).containsKey('Capacity')){
                    quatRecCount += mapQuarterAreaRecCount.get(quat).get('Capacity');
                    capacityAvg = (mapQuarterAreaScoreSum.get(quat).get('Capacity')/mapQuarterAreaRecCount.get(quat).get('Capacity')).setScale(2);
                }
                if(mapQuarterAreaRecCount.get(quat).containsKey('Attentiveness')){
                    quatRecCount += mapQuarterAreaRecCount.get(quat).get('Attentiveness');
                    attentivenessAvg = (mapQuarterAreaScoreSum.get(quat).get('Attentiveness')/mapQuarterAreaRecCount.get(quat).get('Attentiveness')).setScale(2);
                }
                if(mapQuarterAreaRecCount.get(quat).containsKey('Price')){
                    quatRecCount += mapQuarterAreaRecCount.get(quat).get('Price');
                    priceAvg = (mapQuarterAreaScoreSum.get(quat).get('Price')/mapQuarterAreaRecCount.get(quat).get('Price')).setScale(2);
                }
                if(mapQuarterAreaRecCount.get(quat).containsKey('Ease of Doing Business')){
                    quatRecCount += mapQuarterAreaRecCount.get(quat).get('Ease of Doing Business');
                    doingBusinessAvg = (mapQuarterAreaScoreSum.get(quat).get('Ease of Doing Business')/mapQuarterAreaRecCount.get(quat).get('Ease of Doing Business')).setScale(2);
                }
                                         
                linearData.add(new LinearData(quat,quatRecCount,mapQuarterAreaRecCount.get(quat).get('Technology Roadmap')!=NULL?mapQuarterAreaRecCount.get(quat).get('Technology Roadmap'):0,mapQuarterAreaRecCount.get(quat).get('Fab Operations')!=NULL?mapQuarterAreaRecCount.get(quat).get('Fab Operations'):0,
                mapQuarterAreaRecCount.get(quat).get('Assurance of Supply')!=NULL?mapQuarterAreaRecCount.get(quat).get('Assurance of Supply'):0,mapQuarterAreaRecCount.get(quat).get('Design Enablement')!=NULL?mapQuarterAreaRecCount.get(quat).get('Design Enablement'):0,
                mapQuarterAreaRecCount.get(quat).get('Capacity')!=NULL?mapQuarterAreaRecCount.get(quat).get('Capacity'):0,mapQuarterAreaRecCount.get(quat).get('Attentiveness')!=NULL?mapQuarterAreaRecCount.get(quat).get('Attentiveness'):0,
                mapQuarterAreaRecCount.get(quat).get('Price')!=NULL?mapQuarterAreaRecCount.get(quat).get('Price'):0,mapQuarterAreaRecCount.get(quat).get('Ease of Doing Business')!=NULL?mapQuarterAreaRecCount.get(quat).get('Ease of Doing Business'):0,
                technologyAvg,fabOpAvg,supplyAvg,enablementAvg,capacityAvg,attentivenessAvg,priceAvg,doingBusinessAvg));
            }
            else{
                linearData.add(new LinearData(quat,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0));
            }
        }          
        return linearData;        
    }
    
    public List<LinearData> getLinearData(){
        return fetchLinearData(vcsList);
    }
        
    public class LinearData{
        public String quarter{get;set;}
        public Decimal totalQuaterRec{get;set;}               
        
        public Decimal areaTechnologyCount{get;set;}
        public Decimal areaFabOpCount{get;set;}
        public Decimal areaSupplyCount{get;set;}
        public Decimal areaEnablementCount{get;set;}
        public Decimal areaCapacityCount{get;set;}
        public Decimal areaAttentivenessCount{get;set;}
        public Decimal areaPriceCount{get;set;}
        public Decimal areaBusinessCount{get;set;}
        
        public Decimal areaTechnologyAvg{get;set;}
        public Decimal areaFabOpAvg{get;set;}
        public Decimal areaSupplyAvg{get;set;}
        public Decimal areaEnablementAvg{get;set;}
        public Decimal areaCapacityAvg{get;set;}
        public Decimal areaAttentivenessAvg{get;set;}
        public Decimal areaPriceAvg{get;set;}
        public Decimal areaBusinessAvg{get;set;}
        
        public LinearData(String quarter,Decimal totalQuaterRec,Decimal areaTechnologyCount,Decimal areaFabOpCount,Decimal areaSupplyCount,Decimal areaEnablementCount,Decimal areaCapacityCount,Decimal areaAttentivenessCount,Decimal areaPriceCount,Decimal areaBusinessCount,
                Decimal areaTechnologyAvg,Decimal areaFabOpAvg,Decimal areaSupplyAvg,Decimal areaEnablementAvg,Decimal areaCapacityAvg,Decimal areaAttentivenessAvg,Decimal areaPriceAvg,Decimal areaBusinessAvg){
            
            this.quarter = quarter;
            this.totalQuaterRec = totalQuaterRec;            
            this.areaTechnologyCount = areaTechnologyCount;
            this.areaFabOpCount = areaFabOpCount;
            this.areaSupplyCount = areaSupplyCount;
            this.areaEnablementCount = areaEnablementCount;
            this.areaCapacityCount = areaCapacityCount;
            this.areaAttentivenessCount = areaAttentivenessCount;
            this.areaPriceCount = areaPriceCount;
            this.areaBusinessCount = areaBusinessCount;
            this.areaTechnologyAvg = areaTechnologyAvg;
            this.areaFabOpAvg = areaFabOpAvg;
            this.areaSupplyAvg = areaSupplyAvg;
            this.areaEnablementAvg = areaEnablementAvg;
            this.areaCapacityAvg = areaCapacityAvg;
            this.areaAttentivenessAvg = areaAttentivenessAvg;
            this.areaPriceAvg = areaPriceAvg;
            this.areaBusinessAvg = areaBusinessAvg;
        }
        
    }               
}