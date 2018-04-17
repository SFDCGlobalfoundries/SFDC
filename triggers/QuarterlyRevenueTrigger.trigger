/*
    Author: Nino Bustillos
    Description: Marks the related Opportunity for Computation during generation/update of Volume.
    History:
        Nbustillos  02202013    - code creation.
        Nbustillos  02222013    - calls future method to compute adjustments.
        Nbustillos  02272013    - added logic not to rerun async computation.
        Nbustillos  02282013    - added logic to force compute adjustment using Compuate_Adjustment__c field.
        Ram Rai     24012016    -  added to calculate ASP and Volume on QR Object
*/
trigger QuarterlyRevenueTrigger on Quarterly_Revenue_Object__c (after insert, after update , before update) {    
    
    if(!QtrlyRevenueComputeAdjustments.bAdjComputationRunning){
        set<id> oppId = new set<id>(); 
        set<id> opptyIDs = new set<id>();
        // get opportunity Id
        for(Quarterly_Revenue_Object__c oQtrlyRevenue : trigger.new){
           
            oppId.add(oQtrlyRevenue.Opportunity__c);
            if( trigger.isInsert){
                opptyIDs.add(oQtrlyRevenue.Opportunity__c);
                
            }else if((trigger.isUpdate && oQtrlyRevenue.Volume__c!=trigger.oldMap.get(oQtrlyRevenue.id).Volume__c) || (oQtrlyRevenue.Compute_Adjustment__c)){
                opptyIDs.add(oQtrlyRevenue.Opportunity__c);
                
            }
            }            
            List<opportunity> lstOpp = new List<opportunity>();
            lstOpp = [select Deliverable_Type__c, Net_Parts_Per_Wafer__c from opportunity where id = :oppId];
                
           
           if(trigger.isbefore && (trigger.isupdate) ){
           
           for(Quarterly_Revenue_Object__c oQtrlyRevenue : trigger.new){ 
                   
                    
                    if(lstOpp[0].Deliverable_Type__c != 'Wafer' || lstOpp[0].Deliverable_Type__c != null ){   
                    if( lstOpp[0].Net_Parts_Per_Wafer__c ==0)  {
                    if(oQtrlyRevenue.ASP_Module_Chip__c !=null )
                    oQtrlyRevenue.ASP__c = oQtrlyRevenue.ASP_Module_Chip__c ;
                     if(oQtrlyRevenue.Volume_Module_Chip__c !=null )
                    oQtrlyRevenue.Volume__c =  oQtrlyRevenue.Volume_Module_Chip__c ;
                    }
                    else
                    {
                     if(oQtrlyRevenue.Net_Parts_Per_Wafer__c !=null){ 
                     if(oQtrlyRevenue.ASP_Module_Chip__c !=null  )
                    oQtrlyRevenue.ASP__c = (oQtrlyRevenue.ASP_Module_Chip__c * oQtrlyRevenue.Net_Parts_Per_Wafer__c );
                     if(oQtrlyRevenue.Volume_Module_Chip__c !=null )
                    oQtrlyRevenue.Volume__c = ( oQtrlyRevenue.Volume_Module_Chip__c /oQtrlyRevenue.Net_Parts_Per_Wafer__c);
                        }
                    }  
                    }                                           
                 
            }      
        }     
        
        // retrieve the related opportunity the device is tied to and mark for computation
        /*list<Opportunity> lstOpptyToMarkForComputation = new list<Opportunity>();
        for(Opportunity oOppty : [select Compute_Adjustments__c from Opportunity where id in :opptyIDs]){
            oOppty.Compute_Adjustments__c = true;
            lstOpptyToMarkForComputation.add(oOppty);
        }
        
        if(lstOpptyToMarkForComputation.size()>0){
            update lstOpptyToMarkForComputation;
        }*/
        
        if(opptyIDs.size()>0){
            QtrlyRevenueComputeAdjustments.computeAdjustments(opptyIDs);
        }
    }
}