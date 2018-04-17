/**
 * Author: Surendra,Akash
 * Company: GlobalFoundries,India
 * Project: Configurator Plus
 * Description: This class is used to retrieve the post fab services associated to Configuration
 * History:
 *               Initials          Date          Description
-----------------------------------------------------------------------------------------
            Surendranadh Nune    15-Jul-15      Created the class.
**/
public with sharing class CPQ_PostFabServicesReadonlyViewCtrl {
    
    public String proposalId{get;set;}
    public boolean isPrint{get;set;}
    public Config_Post_Fab_Services__c postFab{get;set;}
    public list<Config_Post_Fab_Service_Detail__c> lstWaferTestDetail{get;set;} 
    public String deliverableType{get;set;}
    public String relGrade{get;set;}
    
    public Map<String, Schema.FieldSet> fieldSetMap{get{
                                                    return (fieldSetMap==null) ? SObjectType.Config_Post_Fab_Services__c.FieldSets.getMap() : fieldSetMap;
                                                   }set;}
    public CPQ_PostFabServicesReadonlyViewCtrl(){
        //getPostFabServices();
        //isPrint = false;
        lstWaferTestDetail = new list<Config_Post_Fab_Service_Detail__c>();
        mpPostFabDetail = new map<String,map<String,WrapPostFabDetail>>();
        mpBurinDetail = new map<String,map<String,WrapPostFabDetail>>();
        mpBurinYieldDetail = new map<String,map<String,WrapPostFabDetail>>();
        mpMCMYieldDetail = new map<String,map<String,WrapPostFabDetail>>();
        mpModuleYieldDetail = new map<String,map<String,WrapPostFabDetail>>();
        mpSCBurnInBoardDetail = new map<String,map<String,WrapPostFabDetail>>();
        initializeMap();
        lstpfyields = new list<PFile_Yield__c>();
    }
    
     /**
      * @author Surendranadh Nune
      * @description  This method is used to retrieve the post fab services associated to Configuration.
      * History:
      *               Initials          Date          Description
        -----------------------------------------------------------------------------------------
                   Surendranadh Nune    15-Jul-15      Created the Method.
      **/
    public List<Config_Post_Fab_Services__c> getPostFabServices(){
        List<Config_Post_Fab_Services__c> lstPostFab =  Database.query('SELECT Configuration__r.Product_Type__c,Configuration__r.Relgrade__c,' + new UtilClassToGetAllFields().getAllFields('Config_Post_Fab_Services__c') + ' ' +
                              'FROM Config_Post_Fab_Services__c '+
                              'WHERE Configuration__c =\'' + String.escapeSingleQuotes(proposalId) + '\'' );
        if(!lstPostFab.isEmpty()) {
          postFab = lstPostFab[0];
          deliverableType = lstPostFab[0].Configuration__r.Product_Type__c;
          relGrade = lstPostFab[0].Configuration__r.Relgrade__c;
          lstWaferTestDetail = [Select Id,Circuit_Group__c,Circuit_Type__c,CKT_Unit__c,Count__c,Available_Redundancy__c from Config_Post_Fab_Service_Detail__c 
                                Where Config_Post_Fab_Service__c = :postFab.ID AND RecordType.Name = 'Wafer Test Pass'];
          
          
          for(Config_Post_Fab_Service_Detail__c det : [Select Id,Subst_Cost_by_Time_Period__c,Year__c,Bond_Assembly_Cost_by_Time_Period__c,RecordType.Name,
                                                        Burn_in_duration__c, User_Defined_Yield_BI__c ,User_Defined_Yield_MCM__c,User_Defined_Yield_Module__c,
                                                        Bond_Assembly_Yield_by_Time_Period__c,Package_Option_Cost_by_Time_Period__c,Quarter__c,Burn_in_Board_Cost__c  
                                                        from Config_Post_Fab_Service_Detail__c
                                                        Where Config_Post_Fab_Service__c = :postFab.ID  order by year__c desc]) {
             if(det.recordType.Name == 'Module Build') {
               for(String fieldLabel : mpPstFabField.keySet()) {                            
                  if(!mpPostFabDetail.containsKey(fieldLabel)) {
                    mpPostFabDetail.put(fieldLabel,new map<String,WrapPostFabDetail>());
                  }
                  map<String,WrapPostFabDetail> mpTemp = mpPostFabDetail.get(fieldLabel);
                  if(!mpTemp.containsKey(det.year__c)) {
                    mpTemp.put(det.year__c,new WrapPostFabDetail()); 
                  }           
                  WrapPostFabDetail fabDet =  mpTemp.get(det.year__c);
                  Decimal value = (det.get(mpPstFabField.get(fieldLabel)) != NULL) ? (Decimal.valueOf(String.valueOf(det.get(mpPstFabField.get(fieldLabel))))) : NULL;
                  fabDet.setQuarterValues(det.Quarter__c,value); 
               }
             }
             
             if(det.recordType.Name == 'Burn-in') {
               for(String fieldLabel : mpBurinField.keySet()) {                         
                  if(!mpBurinDetail.containsKey(fieldLabel)) {
                    mpBurinDetail.put(fieldLabel,new map<String,WrapPostFabDetail>());
                  }
                  map<String,WrapPostFabDetail> mpTemp = mpBurinDetail.get(fieldLabel);
                  if(!mpTemp.containsKey(det.year__c)) {
                    mpTemp.put(det.year__c,new WrapPostFabDetail()); 
                  }           
                  WrapPostFabDetail fabDet =  mpTemp.get(det.year__c);
                  Decimal value = (det.get(mpBurinField.get(fieldLabel)) != NULL) ? (Decimal.valueOf(String.valueOf(det.get(mpBurinField.get(fieldLabel))))) : NULL;
                  fabDet.setQuarterValues(det.Quarter__c,value); 
               }
             }
             
             if(det.recordType.Name == 'Burn-in user defined yield') {
               for(String fieldLabel : mpBurinyieldField.keySet()) {                            
                  if(!mpBurinYieldDetail.containsKey(fieldLabel)) {
                    mpBurinYieldDetail.put(fieldLabel,new map<String,WrapPostFabDetail>());
                  }
                  map<String,WrapPostFabDetail> mpTemp = mpBurinYieldDetail.get(fieldLabel);
                  if(!mpTemp.containsKey(det.year__c)) {
                    mpTemp.put(det.year__c,new WrapPostFabDetail()); 
                  }           
                  WrapPostFabDetail fabDet =  mpTemp.get(det.year__c);
                  Decimal value = (det.get(mpBurinyieldField.get(fieldLabel)) != NULL) ? (Decimal.valueOf(String.valueOf(det.get(mpBurinyieldField.get(fieldLabel))))) : NULL;
                  fabDet.setQuarterValues(det.Quarter__c,value); 
               }
             }

             if(det.recordType.Name == 'Module user defined yield') {
               for(String fieldLabel : mpModuleyieldField.keySet()) {                           
                  if(!mpModuleYieldDetail.containsKey(fieldLabel)) {
                    mpModuleYieldDetail.put(fieldLabel,new map<String,WrapPostFabDetail>());
                  }
                  map<String,WrapPostFabDetail> mpTemp = mpModuleYieldDetail.get(fieldLabel);
                  if(!mpTemp.containsKey(det.year__c)) {
                    mpTemp.put(det.year__c,new WrapPostFabDetail()); 
                  }           
                  WrapPostFabDetail fabDet =  mpTemp.get(det.year__c);
                  Decimal value = (det.get(mpModuleyieldField.get(fieldLabel)) != NULL) ? (Decimal.valueOf(String.valueOf(det.get(mpModuleyieldField.get(fieldLabel))))) : NULL;
                  fabDet.setQuarterValues(det.Quarter__c,value); 
               }
             }
             
             if(det.recordType.Name == 'SC Burn in board cost') {
               for(String fieldLabel : mpSCBurnInBoardField.keySet()) {                         
                  if(!mpSCBurnInBoardDetail.containsKey(fieldLabel)) {
                    mpSCBurnInBoardDetail.put(fieldLabel,new map<String,WrapPostFabDetail>());
                  }
                  map<String,WrapPostFabDetail> mpTemp = mpSCBurnInBoardDetail.get(fieldLabel);
                  if(!mpTemp.containsKey(det.year__c)) {
                    mpTemp.put(det.year__c,new WrapPostFabDetail()); 
                  }           
                  WrapPostFabDetail fabDet =  mpTemp.get(det.year__c);
                  Decimal value = (det.get(mpSCBurnInBoardField.get(fieldLabel)) != NULL) ? (Decimal.valueOf(String.valueOf(det.get(mpSCBurnInBoardField.get(fieldLabel))))) : NULL;
                  fabDet.setQuarterValues(det.Quarter__c,value); 
               }
             }
          }                     
          getpfchilds(postFab);
        }
        
        return lstPostFab;                            
    }
    
    
    public map<String,map<String,WrapPostFabDetail>> mpPostFabDetail{get;set;}
    public map<String,map<String,WrapPostFabDetail>> mpBurinDetail{get;set;}
    public map<String,map<String,WrapPostFabDetail>> mpBurinYieldDetail{get;set;}
    public map<String,map<String,WrapPostFabDetail>> mpMCMYieldDetail{get;set;}
    public map<String,map<String,WrapPostFabDetail>> mpModuleYieldDetail{get;set;}
    public map<String,map<String,WrapPostFabDetail>> mpSCBurnInBoardDetail{get;set;}
     
    public class WrapPostFabDetail {
      public Decimal Q1{get;set;}
      public Decimal Q2{get;set;}
      public Decimal Q3{get;set;}
      public Decimal Q4{get;set;}
      
      public void setQuarterValues(String quarter,Decimal value) {
        if(quarter == 'Q1') {
          Q1 = value;
        }
        if(quarter == 'Q2') {
          Q2 = value;
        }
        if(quarter == 'Q3') {
          Q3 = value;
        }
        if(quarter == 'Q4') {
          Q4 = value;
        }
      }
    }
    map<String,String> mpPstFabField = new map<String,String>();
    map<String,String> mpBurinField = new map<String,String>();
    map<String,String> mpBurinyieldField = new map<String,String>();
    map<String,String> mpMCMyieldField = new map<String,String>();
    map<String,String> mpModuleyieldField = new map<String,String>();
    map<String,String> mpSCBurnInBoardField = new map<String,String>();
     
    public void initializeMap() {
      mpPstFabField.put('Subst Cost by Time Period','Subst_Cost_by_Time_Period__c');
      mpPstFabField.put('Package Option Cost by Time Period','Package_Option_Cost_by_Time_Period__c');
      mpPstFabField.put('Bond & Assembly Cost by Time Period','Bond_Assembly_Cost_by_Time_Period__c');
      mpPstFabField.put('Bond & Assembly Yield by Time Period','Bond_Assembly_Yield_by_Time_Period__c');
      
      mpBurinField.put('Burn-in duration','Burn_in_duration__c');
      
      mpBurinyieldField.put('User Defined Yield (BI)','User_Defined_Yield_BI__c');      
      
      mpModuleyieldField.put('User Defined Yield (Module)','User_Defined_Yield_Module__c');
      
      mpSCBurnInBoardField.put('Burn-in Board Cost','Burn_in_Board_Cost__c');
    }
    
     public list<PFile_Yield__c> lstpfyields{get;set;} 
     public PageReference getpfchilds(Config_Post_Fab_Services__c pfs) {
        Decimal numberF = pfs.PF_Number__c != NULL ? Decimal.valueOf(pfs.PF_Number__c) : NULL;
        Decimal revisionF = pfs.Revision__c != NULL ? Decimal.valueOf(pfs.Revision__c) : NULL; 
        list<PFile_Data__c> pflist   = [select PF_Stat__c,PF_Desc__c,Revision__c, PF_Number__c from PFile_Data__c where PF_Stat__c=: pfs.PF_Stat__c and PF_Desc__c=: pfs.PF_Desc__c and PF_Number__c =: numberF   and Revision__c =:revisionF  ];
        
        if(!pflist.isEmpty()) {
          lstpfyields= new list<PFile_Yield__c>([Select Circuit_Group__c,Circuit_Type__c,Circuit_Unit__c,Count__c,PFile__c,QTR1__c,QTR2__c,QTR3__c,QTR4__c,QTR5__c,QTR6__c,QTR7__c,QTR8__c,QTR9__c,QTR10__c,
                                                 QTR11__c,QTR12__c,QTR13__c,QTR14__c,QTR15__c,QTR16__c,QTR17__c,QTR18__c,QTR19__c,QTR20__c,QTR21__c,QTR22__c,QTR23__c,QTR24__c,Redundancy__c,Yield_Type__c From PFile_Yield__c where PFile__c=:pflist[0].id AND Recordtype.name = 'Custom Circuit'] );
        }                                         
          
        return null;
    }
}