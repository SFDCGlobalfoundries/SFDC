/** Author : Ravikiran Nadella 

*  Created Date : 23/09/2017
*  Description : Custom controller class for Customer ScoreCard Visualforce page 
**/
public with sharing class CustSatisfaction_SCardController {
    
    public string Title { get; set; }
    public string quater {get; set;}
    public string year   {get; set;}
    public list<string> qtyrList {get; set;}
    public list<string> qtyr1List {get; set;}
    public map<string,Merit__c> custMap{get;set;}
    public map<string,qtrData>  qtrsMap{get;set;}
    public list<Merit__c> custList{get;set;}
    public string cust{get;set;}
    public list<string> yrList;
    public list<string> qtList;
    public map<string,string> mrtIdMap{get;set;}
    public map<string,string>qtMap;
    public map<string,string>qrtMap;
    public map<string,string>intMap;
    
    public CustSatisfaction_SCardController()
    {
        custMap = new map<string,Merit__c>();
       
        qtrsMap = new map<string,qtrData>();
        custList = new list<Merit__c>();
        yrList = new list<string>();
        qtList = new list<string>();
        qtyrList = new list<string>();
        qtyr1List = new list<string>();
        mrtIdMap = new map<string,string>();
        qtMap = new map<string,string>{'1'=>'Q1','2'=>'Q2','3'=>'Q3','4'=>'Q4'};
        qrtMap = new map<string,string>{'3'=>'Q1','6'=>'Q2','9'=>'Q3','12'=>'Q4'};
        intMap = new map<string,string>{'1'=>'3','2'=>'6','3'=>'9','4'=>'12'};
        Title = CustomerSatisfaction__c.getValues('Title').value__c;
        if(System.currentPageReference().getParameters().get('sfdc.tabName') <> null){
            quater=intMap.get(string.valueOf(((system.today().month()/3)+1)));
            year=string.valueOf(system.today().year());
            cust    = 'Corp';
        }
        else{
            quater=System.currentPageReference().getParameters().get('quater');
            year=System.currentPageReference().getParameters().get('year');
            cust=System.currentPageReference().getParameters().get('site');
            
        }  
        fetchAop();  
    }
    
    public void fetchAop(){
        mrtIdMap.clear();
        for(Approved_Operation_Plan__c aop: [Select AOP_in_M__c,Merit_Index_for_customers__r.name,
                                             Merit_Index_for_customers__r.site__c
                                             from Approved_Operation_Plan__c where AOP_Year__c =:year ]){
                                                 mrtIdMap.put(aop.Merit_Index_for_customers__r.name+aop.Merit_Index_for_customers__r.site__c,string.valueOf(aop.AOP_in_M__c));
                                             } 
    }
    public void getData(){
        fetchAop();
        fetchPastQtr();
        for(Merit__c mrt:[Select id,name,Site__c,SG_Approved_Operation_Plan_M__c,GREEN__c,RED__c,
                          (select id,Q1_Score__c,Q1__c,Merit_Index_for_customers__c,Score_Year__c,Q1_Rank__c,
                           Quarter_New__c,MeritIndex__c from Customer_Satsfaction__r where Score_Year__c in:yrlist
                           and Quarter_New__c in :qtList and Score_Year__c!=null and Quarter_New__c!=null
                           order by Quarter_New__c Desc , Score_Year__c Desc ) from Merit__c 
                          where site__c=:cust and Hide_from_1A_1B__c =false ])
        {
            custList.add(mrt);
            custMap.put(mrt.name+mrt.Site__c,mrt); 
            if(mrtIdMap.get(mrt.name+mrt.Site__c)==null){
                mrtIdMap.put(mrt.name+mrt.Site__c,'--');             
            }
            
            qtrsMap.put(mrt.name+mrt.Site__c, new qtrData(mrt,qtyrList) );
            
        }
        system.debug('data' +qtrsMap);
        system.debug('custList'+custList);
        system.debug('custMap'+custMap);
        system.debug('year' +year);
        
    }
    
    
    public List<SelectOption> getQtrs()
    {
        List<SelectOption> options = new List<SelectOption>();
        for(string st:qrtMap.keyset())
        {
            options.add(new SelectOption(st,qrtMap.get(st)));
        }
        return options;
    }
    
    public List<SelectOption> getyrs()
    {
        List<SelectOption> options = new List<SelectOption>();
        if(CustomerSatisfaction__c.getValues('Displayed Years')<>null)
        {
            CustomerSatisfaction__c yr = CustomerSatisfaction__c.getValues('Displayed Years');
            for(string str: yr.value__c.split(',')){
                options.add(new SelectOption(str,str));
            }
            
        }
        return options;
    }
    
    public List<SelectOption> getCsites()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = Merit__c.site__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }

public void  fetchPastQtr(){
    yrList.clear();
    qtList.clear();
    qtyrList.clear();
    qtyr1List.clear();
    custList.clear();
    custMap.clear();
    qtrsMap.clear();
    
    
    integer pastQuarters = 4;
    Date startDate = Date.newInstance(integer.valueOf(year),integer.valueOf(quater),1);
    yrList.add(year);
    qtList.add(qrtMap.get(quater));
    qtyr1List.add(qrtMap.get(quater)+' '+year.right(2));
    for (integer i = 0; i < pastQuarters; i++)
    {
        startDate = startDate.addMonths(-3);      
        integer quarter = (startDate.month()/ 3); 
        integer year =startDate.Year();
        yrList.add(string.valueOf(year));
        qtList.add(qtMap.get(string.valueOf(quarter)));
        qtyr1List.add(qtMap.get(string.valueOf(quarter)) +' ' +string.valueOf(year).right(2));
    }
    
    for(Integer i= qtyr1List.size() - 1; i >= 0; i--)
    {
        qtyrList.add(qtyr1List[i]);
    }
    
}

public class qtrData{
    
    public string Qtr1{get;set;}
    public string Qtr2{get;set;}
    public string Qtr3{get;set;}
    public string Qtr4{get;set;}
    public string Qtr5{get;set;}
    public string mrtIdx{get;set;}
    public qtrData(Merit__c mrt,list<string>qtyrList)
    {
        Qtr1='--';
        Qtr2='--';
        Qtr3='--';
        Qtr4='--';
        Qtr5='--';
        mrtIdx='--';
        Merit__c mt =mrt;
        
        if(qtyrList.size()==5){
            if(null<>mrt.Customer_Satsfaction__r){
                for(Customer_Satsfaction__c cst : mrt.Customer_Satsfaction__r){
                    system.debug('cst%%%' +cst);
                    
                    if(qtyrList[4]==cst.Quarter_New__c+' '+string.valueOf(cst.Score_Year__c).right(2)){
                        if(cst.MeritIndex__c!=null){
                            mrtIdx=cst.MeritIndex__c;
                        }
                        system.debug('5%%%'+mrtIdx);
                        system.debug('5%%%'+qtyrList[4]);
                        system.debug('5%%%'+mrt.name+cst.Quarter_New__c+' '+string.valueOf(cst.Score_Year__c).right(2)+mrtIdx);
                        if((string.valueOf(cst.Q1_Score__c)!=null || cst.Q1__c!=null) &&cst.Q1_Rank__c!=null)
                        {
                            string qrt;
                            if(cst.Q1_Score__c!=null)
                            {
                                qrt=String.valueOf(cst.Q1_Score__c);
                            }
                            if(cst.Q1__c!=null)
                            {
                                qrt=cst.Q1__c+'%';
                            }
                            this.Qtr5=qrt+'/'+'<br/>'+cst.Q1_Rank__c;
                        }else{ if(String.valueOf(cst.Q1__c)!=null){this.Qtr5=String.valueOf(cst.Q1__c)+'%';
                        }else if(String.valueOf(cst.Q1_Score__c) !=null){this.Qtr5=String.valueOf(cst.Q1_Score__c);
                        }else if(cst.Q1_Rank__c!=null){ this.Qtr5=cst.Q1_Rank__c;}else{ this.Qtr5='--'; }
                        }
                    }
                    // q3 
                    
                    if(qtyrList[3]==cst.Quarter_New__c+' '+string.valueOf(cst.Score_Year__c).right(2)){
                        if(cst.MeritIndex__c!=null && mrtIdx == '--'){ mrtIdx=cst.MeritIndex__c; }
                        system.debug('4%%%'+mrtIdx);
                        system.debug('4%%%'+qtyrList[3]);
                        system.debug('4%%%'+mrt.name+cst.Quarter_New__c+' '+string.valueOf(cst.Score_Year__c).right(2)+mrtIdx);
                        if((string.valueOf(cst.Q1_Score__c)!=null || cst.Q1__c!=null) &&cst.Q1_Rank__c!=null){
                            string qrt;
                            if(cst.Q1_Score__c!=null){ qrt=String.valueOf(cst.Q1_Score__c);}
                            if(cst.Q1__c!=null){qrt=cst.Q1__c+'%';}
                            this.Qtr4=qrt+'/'+'<br/>'+cst.Q1_Rank__c;
                        }else{
                            if(String.valueOf(cst.Q1__c)!=null){this.Qtr4=String.valueOf(cst.Q1__c)+'%';
                                                               }else if(String.valueOf(cst.Q1_Score__c) !=null){
                                                                   this.Qtr4=String.valueOf(cst.Q1_Score__c); }else if(cst.Q1_Rank__c!=null){this.Qtr4=cst.Q1_Rank__c;
                                                                                                                                                       }else{ this.Qtr4='--'; }}
                    }
                    
                    //q2 
                    if(qtyrList[2]==cst.Quarter_New__c+' '+string.valueOf(cst.Score_Year__c).right(2)){
                        if(cst.MeritIndex__c!=null  && mrtIdx == '--'){
                            mrtIdx=cst.MeritIndex__c;
                        }
                        system.debug('3%%%'+mrtIdx);
                        system.debug('3%%%'+qtyrList[2]);
                        system.debug('3%%%'+mrt.name+cst.Quarter_New__c+' '+string.valueOf(cst.Score_Year__c).right(2)+mrtIdx);
                        if((string.valueOf(cst.Q1_Score__c)!=null || cst.Q1__c!=null) &&cst.Q1_Rank__c!=null){
                            string qrt;if(cst.Q1_Score__c!=null){qrt=String.valueOf(cst.Q1_Score__c); }
                            if(cst.Q1__c!=null){ qrt=cst.Q1__c+'%';
                                               } this.Qtr3=qrt+'/'+'<br/>'+cst.Q1_Rank__c;
                        }else{
                            if(String.valueOf(cst.Q1__c)!=null){
                                this.Qtr3=String.valueOf(cst.Q1__c)+'%';}else if(String.valueOf(cst.Q1_Score__c) !=null){
                                    this.Qtr3=String.valueOf(cst.Q1_Score__c);
                                }else if(cst.Q1_Rank__c!=null){this.Qtr3=cst.Q1_Rank__c;}else{
                                    this.Qtr3='--';
                                }
                        }
                    }
                    
                    //q1
                    if(qtyrList[1]==cst.Quarter_New__c+' '+string.valueOf(cst.Score_Year__c).right(2)){
                        if(cst.MeritIndex__c!=null  && mrtIdx == '--'){mrtIdx=cst.MeritIndex__c;}
                        system.debug('2%%%'+mrtIdx);
                        system.debug('2%%%'+qtyrList[1]);
                        system.debug('2%%%'+mrt.name+cst.Quarter_New__c+' '+string.valueOf(cst.Score_Year__c).right(2)+mrtIdx);
                        if((string.valueOf(cst.Q1_Score__c)!=null || cst.Q1__c!=null) &&cst.Q1_Rank__c!=null){
                            string qrt;
                            if(cst.Q1_Score__c!=null){ qrt=String.valueOf(cst.Q1_Score__c);
                                                     }if(cst.Q1__c!=null){ qrt=cst.Q1__c+'%'; }
                            this.Qtr2=qrt+'/'+'<br/>'+cst.Q1_Rank__c; }else{
                                if(String.valueOf(cst.Q1__c)!=null){this.Qtr2=String.valueOf(cst.Q1__c)+'%';
                                                                   }else if(String.valueOf(cst.Q1_Score__c) !=null){
                                                                       this.Qtr2=String.valueOf(cst.Q1_Score__c);
                                                                   }else if(cst.Q1_Rank__c!=null){
                                                                       this.Qtr2=cst.Q1_Rank__c;
                                                                   }else{ this.Qtr2='--';
                                                                        }
                            }
                        
                    }
                    //q0
                    if(qtyrList[0]==cst.Quarter_New__c+' '+string.valueOf(cst.Score_Year__c).right(2)){
                        if(cst.MeritIndex__c!=null  && mrtIdx == '--'){mrtIdx=cst.MeritIndex__c;
                                                                      }
                        system.debug('1%%%'+mrtIdx);
                        system.debug('1%%%'+qtyrList[0]);
                        system.debug('1%%%'+mrt.name+cst.Quarter_New__c+' '+string.valueOf(cst.Score_Year__c).right(2)+mrtIdx);
                        
                        if((string.valueOf(cst.Q1_Score__c)!=null || cst.Q1__c!=null) &&cst.Q1_Rank__c!=null){
                            string qrt;
                            if(cst.Q1_Score__c!=null){
                                qrt=String.valueOf(cst.Q1_Score__c); }
                            if(cst.Q1__c!=null){ qrt=cst.Q1__c+'%';}
                            this.Qtr1=qrt+'/'+'<br/>'+cst.Q1_Rank__c;
                        }else{
                            if(String.valueOf(cst.Q1__c)!=null){
                                this.Qtr1=String.valueOf(cst.Q1__c)+'%';
                            }else if(String.valueOf(cst.Q1_Score__c) !=null){
                                this.Qtr1=String.valueOf(cst.Q1_Score__c);}else if(cst.Q1_Rank__c!=null){
                                    this.Qtr1=cst.Q1_Rank__c; }else{ this.Qtr1='--';
                                                                   }
                        }
                        System.debug('Qtr1@@@' +Qtr1);
                    }    
                }
            }
        }
    }
}

    
}