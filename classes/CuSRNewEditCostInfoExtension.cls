/*
Author: Shyam Ravindra Nair
Description: Apex class will act as extension to CuSRNewEditCostInfo page.
History:
SNair     17122014     - code creation
SNair     29042015     - modified
PSamal    06122017     - Case-00051184(Changes for new site - Essex Junction, East Fishkill, ASIC)
*/
public class CuSRNewEditCostInfoExtension{
    public String cusrFormId{get;set;}
    public String sourceURL{get;set;}
    public String site{get;set;}
    public CuSR_Form__c cusrForm{get;set;}
    public CuSR_Cost__c cusrCost{get;set;}
    public String singaporeSelectedFab{get;set;}
    public pageReference pgRef{get;set;}
    //Custom setting map for CuSR Labour Cost values
    public Map<String, CuSR_Labour_Cost_Settings__c> cusrLabourCost{get;set;}
    public boolean disableEditDelete{get;set;}
    
    public CuSRNewEditCostInfoExtension(ApexPages.StandardController sc){
        cusrLabourCost = CuSR_Labour_Cost_Settings__c.getAll();
        //sourceURL = ApexPages.currentPage().getParameters().get('ReturnURL'); 
        //cusrFormId = ApexPages.currentPage().getParameters().get('CuSRForm'); 
        //site = ApexPages.currentPage().getParameters().get('Site');
        //pass the current record
        cusrCost=(CuSR_Cost__c)sc.getRecord(); 
        String recID = cusrCost.Id;
        //Instance of UtilClassToGetAllFields class to get all fields
        UtilClassToGetAllFields utilClass = new UtilClassToGetAllFields();
        String costQueryField = utilClass.getAllFields('CuSR_Cost__c');
        String costQuery;
        String cusrQueryField = utilClass.getAllFields('CuSR_Form__c');
        if(recId == null || recId == ''){
            cusrCost = new CuSR_Cost__c();
            cusrFormId = ApexPages.currentPage().getParameters().get('CuSRForm'); 
            site = ApexPages.currentPage().getParameters().get('Site');
            String cusrQuery = 'select '+cusrQueryField+' from Cusr_Form__c where Id =\''+cusrFormId+'\'';  
            cusrForm = Database.query(cusrQuery);
            cusrCost.CuSR_Form__c = cusrFormId;
            if(site == 'Dresden'){
                cusrCost.Site__c = 'Dresden';
                cusrCost.Fab__c = 'FAB 1';
                cusrCost.Labour_Cost__c =  cusrLabourCost.get('Dresden').Labour_Cost__c; 
            }
            if(site == 'Malta'){
                cusrCost.Site__c = 'Malta';
                cusrCost.Fab__c = 'FAB 8';
                cusrCost.Labour_Cost__c =  cusrLabourCost.get('Malta').Labour_Cost__c;
            }
            if(site == 'Essex Junction'){
                cusrCost.Site__c = 'Essex Junction';
                cusrCost.Fab__c = 'FAB 9';
                cusrCost.Labour_Cost__c =  cusrLabourCost.get('Essex Junction').Labour_Cost__c;
            }
            if(site == 'East Fishkill'){
                cusrCost.Site__c = 'East Fishkill';
                cusrCost.Fab__c = 'FAB 10';
                cusrCost.Labour_Cost__c =  cusrLabourCost.get('East Fishkill').Labour_Cost__c;
            }
            if(site == 'ASIC'){
                cusrCost.Site__c = 'ASIC';
                cusrCost.Fab__c = 'ASIC';
                cusrCost.Labour_Cost__c =  cusrLabourCost.get('ASIC').Labour_Cost__c;
            }
            if(site == 'Singapore'){
                cusrCost.Site__c = 'Singapore';
                cusrCost.Labour_Cost__c =  cusrLabourCost.get('Singapore').Labour_Cost__c;
                //cusrCost.Fab__c = singaporeFab;
            }
        }
        else{
            costQuery = 'select '+costQueryField+' from CuSR_Cost__c where Id = \''+recId+'\'';
            cusrCost = Database.query(costQuery);    
            String cusrQuery = 'select '+cusrQueryField+' from Cusr_Form__c where Id =\''+cusrCost.CuSR_Form__c+'\'';  
            cusrForm = Database.query(cusrQuery);
            if(cusrCost.Site__c == 'Singapore'){
                singaporeSelectedFab = cusrCost.Fab__c; 
            }
            disableEditDeleteMethod();
        }
    }
    
    public void disableEditDeleteMethod(){
        disableEditDelete = false;
        if(cusrForm.Status__c == 'Implemented'){
            if(cusrForm.FAB_1__c || cusrForm.Additional_FAB_1__c){
                disableEditDelete = true;
            }
            if(cusrForm.FAB_2__c || cusrForm.Additional_FAB_2__c){
                disableEditDelete = true;
            }
            if(cusrForm.FAB_3__c || cusrForm.Additional_FAB_3__c){
                disableEditDelete = true;
            }
            if(cusrForm.FAB_3E__c || cusrForm.Additional_FAB_3E__c){
                disableEditDelete = true;
            }
            if(cusrForm.FAB_5__c || cusrForm.Additional_FAB_5__c){
                disableEditDelete = true;
            }
            if(cusrForm.FAB_6__c || cusrForm.Additional_FAB_6__c){
                disableEditDelete = true;
            }
            if(cusrForm.FAB_7__c || cusrForm.Additional_FAB_7__c){
                disableEditDelete = true;
            }
            if(cusrForm.FAB_8__c || cusrForm.Additional_FAB_8__c){
                disableEditDelete = true;
            }
            if(cusrForm.FAB_9__c || cusrForm.Additional_FAB_9__c){
                disableEditDelete = true;
            }
            if(cusrForm.FAB_10__c || cusrForm.Additional_FAB_10__c){
                disableEditDelete = true;
            }
            if(cusrForm.ASIC__c || cusrForm.Additional_ASIC__c){
                disableEditDelete = true;
            }
            if(cusrCost.Fab__c == ''){
                disableEditDelete = true;
            }
        }
    }
    
    public pageReference Save(){
        pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrForm.Id);
        if(cusrCost.Site__c == 'Singapore'){
            cusrCost.Fab__c = singaporeSelectedFab;
            pgRef.getParameters().put('tabname','singapore');
            pgRef.getParameters().put('singaporesubtabname','singaporecost');
        }
        if(cusrCost.Site__c == 'Dresden'){
            pgRef.getParameters().put('tabname','dresden');
            pgRef.getParameters().put('dresdensubtabname','dresdencost');
        }
        if(cusrCost.Site__c == 'Malta'){
            pgRef.getParameters().put('tabname','malta');
            pgRef.getParameters().put('maltasubtabname','maltacost');
        }
        if(cusrCost.Site__c == 'Essex Junction'){
            pgRef.getParameters().put('tabname','essexjunction');
            pgRef.getParameters().put('essexjunctionsubtabname','essexjunctioncost');
        }
        if(cusrCost.Site__c == 'East Fishkill'){
            pgRef.getParameters().put('tabname','eastfishkill');
            pgRef.getParameters().put('eastfishkillsubtabname','eastfishkillcost');
        }
        if(cusrCost.Site__c == 'ASIC'){
            pgRef.getParameters().put('tabname','asic');
            pgRef.getParameters().put('asicsubtabname','asiccost');
        }
        upsert cusrCost;
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public pageReference Cancel(){
        pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrForm.Id);
        if(cusrCost.Site__c == 'Singapore'){
            pgRef.getParameters().put('tabname','singapore');
            pgRef.getParameters().put('singaporesubtabname','singaporecost');
        }
        if(cusrCost.Site__c == 'Dresden'){
            pgRef.getParameters().put('tabname','dresden');
            pgRef.getParameters().put('dresdensubtabname','dresdencost');
        }
        if(cusrCost.Site__c == 'Malta'){
            pgRef.getParameters().put('tabname','malta');
            pgRef.getParameters().put('maltasubtabname','maltacost');
        }
        if(cusrCost.Site__c == 'Essex Junction'){
            pgRef.getParameters().put('tabname','essexjunction');
            pgRef.getParameters().put('essexjunctionsubtabname','essexjunctioncost');
        }
        if(cusrCost.Site__c == 'East Fishkill'){
            pgRef.getParameters().put('tabname','eastfishkill');
            pgRef.getParameters().put('eastfishkillsubtabname','eastfishkillcost');
        }
        if(cusrCost.Site__c == 'ASIC'){
            pgRef.getParameters().put('tabname','asic');
            pgRef.getParameters().put('asicsubtabname','asiccost');
        }
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public pageReference DeleteCost(){
        pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrForm.Id);
        String site = cusrCost.Site__c;
        delete cusrCost;
        if(site == 'Singapore'){
            pgRef.getParameters().put('tabname','singapore');
            pgRef.getParameters().put('singaporesubtabname','singaporecost');
        }
        if(site == 'Dresden'){
            pgRef.getParameters().put('tabname','dresden');
            pgRef.getParameters().put('dresdensubtabname','dresdencost');
        }
        if(site == 'Malta'){
            pgRef.getParameters().put('tabname','malta');
            pgRef.getParameters().put('maltasubtabname','maltacost');
        }
        if(site == 'Essex Junction'){
            pgRef.getParameters().put('tabname','essexjunction');
            pgRef.getParameters().put('essexjunctionsubtabname','essexjunctioncost');
        }
        if(site == 'East Fishkill'){
            pgRef.getParameters().put('tabname','eastfishkill');
            pgRef.getParameters().put('eastfishkillsubtabname','eastfishkillcost');
        }
        if(site == 'ASIC'){
            pgRef.getParameters().put('tabname','asic');
            pgRef.getParameters().put('asicsubtabname','asiccost');
        }
        pgRef.setRedirect(true);
        return pgRef;
    }
}