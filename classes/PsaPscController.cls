/*****************************************************************************************
@ Class:          PsaPscController
@ Version:        1.0
@ Author:         Cognizant
@ Purpose:        This Class is for PsapscVF page used as part of calculating PSC/PSA on Device.
------------------------------------------------------------------------------------------------
@ Change history: 
******************************************************************************************/



public class PsaPscController {

    public list<selectoption> psclist{get; set;}
    public list<selectoption>  psapicklistfalg{get; set;}
    public string deviceid{get;set;}
    public string selectedValue{get;set;}
    public string selectedValuepsc{get;set;}
    public string selectedValuepsa{get;set;}
    public boolean setboolmpo{get;set;}
    public boolean setconflag{get;set;}
    public boolean showerr {get;set;}
    
    public PsaPscController(){
        deviceid = ApexPages.currentPage().getParaMeters().get('deviceId');
        Device__c dccond = new Device__c();
        showerr = false;
        dccond = [select id,name,End_Customer__c,MPO_system_calculated__c,Calculated_PSA__c,Contract_Control_Flag__c,Calculated_PSC__c,New_Read_PSA__c,New_Read_PSC__c  from Device__c where id=:deviceid];
        if(dccond.Contract_Control_Flag__c == 'Yes'){
            setconflag = true;    // to show Lantiq/Infineon output panel
            setboolmpo = false;
        }
        else{
            setconflag = false;
            setboolmpo = true;     // to show Mpo/Dmea output panel
        }
        psapicklistfalg = new List<selectoption>();
        psapicklistfalg.add(new selectoption('Select', 'Select')); 
        string psacontract = label.psavfcontract;
        list<string> psacontractlis = psacontract.split(',');
        Set<string> psacontractlisse = new Set<string>(psacontractlis);
        for(string si: psacontractlisse){
            psapicklistfalg.add(new selectoption(si, si));
        }
     }
        
     public list<selectoption> getpscpicklist(){
         list<selectoption>  psclist = new List<selectoption>();
         string pscvfmpostr= label.pscvfmpo;
         list<string> pscvfmpostrlis = pscvfmpostr.split(',');
         Set<string> pscvfmpostrlisse = new Set<string>(pscvfmpostrlis);
         psclist.add(new selectoption('Select', 'Select')); 
         for(string si: pscvfmpostrlisse ){
             psclist.add(new selectoption(si, si));
         }
        return psclist;
     }
        
     public list<selectoption> getpscpicklistflag() {
         list<selectoption>  psclist = new List<selectoption>();
         string pscvfcontractstr= label.pscvfcontract;
         list<string> pscvfcontractstrlis = pscvfcontractstr.split(',');
         Set<string> pscvfcontractstrlisse = new Set<string>(pscvfcontractstrlis);
         psclist.add(new selectoption('Select', 'Select')); 
         for(string si: pscvfcontractstrlisse){   
             psclist.add(new selectoption(si, si));
         }
        return psclist;
     }
     //Submit function for INFINEON/LANTIQ output panel 
     public Pagereference Submitflag(){
        Device__c dc = new Device__c();
        if( selectedValuepsc == 'Select' || selectedValuepsa == 'Select' ){
            showerr = true;
            return null;
        }else{
            dc = [select id,name,Calculated_PSA__c,Calculated_PSC__c,New_Read_PSA__c,New_Read_PSC__c  from Device__c where id=:deviceid];
            if(dc.Calculated_PSC__c == null && dc.Calculated_PSA__c == null){
                dc.New_Read_PSC__c  = selectedValuepsc; 
                dc.New_Read_PSA__c = selectedValuepsa;
            }
            dc.Calculated_PSC__c = selectedValuepsc; 
            dc.Calculated_PSA__c = selectedValuepsa; 
            dc.Set_APC_APA_Based_On__c = 'End Customer had Unique Contractually Driven Controls and protection- User Specified';
            update dc;
            Pagereference pg = new pagereference('/'+deviceid);
            return pg; 
        }    
    }
    //Submit function for MPO/DMEA output panel
    public PageReference Submit(){
        Device__c dc = new Device__c();
        if( selectedValue  == 'Select' ){
            showerr = true;
            return null;
        }
        else{
            dc = [select id,name,Calculated_PSA__c,Calculated_PSC__c,New_Read_PSA__c,New_Read_PSC__c  from Device__c where id=:deviceid];
            if(selectedValue == '4'){ 
                if(dc.Calculated_PSC__c == null && dc.Calculated_PSA__c == null){
                    dc.New_Read_PSC__c  = selectedValue ; 
                    dc.New_Read_PSA__c = label.psavfformpopsc24; 
                }
                dc.Calculated_PSC__c = selectedValue ; 
                dc.Calculated_PSA__c = label.psavfformpopsc24; 
                dc.MPO_system_calculated__c    = 'NO' ;
                dc.Set_APC_APA_Based_On__c ='End Customer is MPO- user specified';
                update dc;     
        } else 
            if(selectedValue == '0' || selectedValue == '2'){ 
                dc.MPO_system_calculated__c    = 'YES' ;
                update dc;
            }
            Pagereference pg = new pagereference('/'+deviceid);
            return pg;  
        }  
    } 
    public Pagereference cancelbu(){
         Pagereference pg = new pagereference('/'+deviceid);
         return pg; 
    } 
}