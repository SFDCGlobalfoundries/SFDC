/*
Type Name: BnPButtonValidationCtrl
Author: Yash Bansal
Project Name: DIW Step Down Track 2 (BnP) 
Created Date: 04/10/2017
Description: This class is call from OpportunityReviewComponent
Test Class: OpportunitySendMailClass_Test
Change History: Poulami Saha	06/15/2017	Replaced 'Obstacles' field with 'Opportunity Obstacles' in OpportunityReviewChecklist Email Template
*/
public class OpportunityReviewChecklist {
    public id oppId{get;set;}
    //public string checkpoint{get;set;}
    //public string stageName{get;set;}
    //public Opportunity opp{get;set;}
    public OpportunityReviewChecklist(){
                             
    }
    public Opportunity getopp() {    
        Opportunity opp = [Select id,Product_Line__c,Business_Unit__c,CloseDate,
                                                        Name,StageName,Market_Segment__c,
                                                         Process_Geometry__c,Process_Family__c,
                                                         Obstacles__c,Opportunity_Obstacles__c,Production_Confidence__c,Assigned_PLM__c,Assigned_Segment_Marketing__c,FAE_Head__c,FAE_Head__r.Name
                                                         FROM Opportunity WHERE Id=:oppId limit 1 ];
         return opp;                                  
    }
    public String getcheckpoint(){
        string checkpoint = '';
        Opportunity opty = [Select id,AM_CP1__c,AM_CP2__c,AM_CP3__c,FAE_CP1__c,FAE_CP2__c,FAE_CP3__c,PLM_CP2__c,PLM_CP3__c,MarketSegment_CP2__c,MarketSegment_CP3__c
                                                         FROM Opportunity WHERE Id=:oppId limit 1 ];
        if(opty.AM_CP1__c == true && opty.FAE_CP1__c==false && opty.AM_CP2__c==false && opty.FAE_CP2__c==false && opty.PLM_CP2__c == false && opty.MarketSegment_CP2__c==false && opty.AM_CP3__c==false && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
            checkpoint = '1';
            //stageName = 'Next Stage';
        }else if(opty.AM_CP1__c == true && opty.FAE_CP1__c==true && opty.AM_CP2__c==false && opty.FAE_CP2__c==false && opty.PLM_CP2__c == false && opty.MarketSegment_CP2__c==false && opty.AM_CP3__c==false && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
            checkpoint = '1';
            //stageName = 'Next Stage';
        }          
        else if(opty.AM_CP1__c == true && opty.FAE_CP1__c==true && opty.AM_CP2__c==true && opty.FAE_CP2__c==false && opty.PLM_CP2__c == false && opty.MarketSegment_CP2__c==false && opty.AM_CP3__c==false && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
            checkpoint = '2';
            //stageName = 'Next Stage';
        }
        else if(opty.AM_CP1__c == true && opty.FAE_CP1__c==true && opty.AM_CP2__c==true && opty.FAE_CP2__c==true && opty.PLM_CP2__c == true && opty.MarketSegment_CP2__c==true && opty.AM_CP3__c==false && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
            checkpoint = '2';
            //stageName = 'Next Stage';
        }    
        else if(opty.AM_CP1__c == true && opty.FAE_CP1__c==true && opty.AM_CP2__c==true && opty.FAE_CP2__c==true && opty.PLM_CP2__c == true && opty.MarketSegment_CP2__c==true && opty.AM_CP3__c==true && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
            checkpoint = '3';
            //stageName = 'Design Win';
        }    
        else if(opty.AM_CP2__c==true && opty.FAE_CP2__c==false&& opty.PLM_CP2__c == false && opty.MarketSegment_CP2__c==false && opty.AM_CP3__c==false && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
            checkpoint = '2';
            //stageName = 'Next Stage';
        }
        else if(opty.AM_CP2__c==true && opty.FAE_CP2__c==true && opty.PLM_CP2__c == true && opty.MarketSegment_CP2__c==true && opty.AM_CP3__c==false && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
            checkpoint = '2';
            //stageName = 'Next Stage';
        }    
        else if(opty.AM_CP2__c==true && opty.FAE_CP2__c==true && opty.PLM_CP2__c == true && opty.MarketSegment_CP2__c==true && opty.AM_CP3__c==true && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
            checkpoint = '3';
            //stageName = 'Design Win';
        }
        return checkpoint;
    }
    
    public String getstagename(){
        string stageName = '';
        Opportunity opty = [Select id,AM_CP1__c,AM_CP2__c,AM_CP3__c,FAE_CP1__c,FAE_CP2__c,FAE_CP3__c,PLM_CP2__c,PLM_CP3__c,MarketSegment_CP2__c,MarketSegment_CP3__c
                                                         FROM Opportunity WHERE Id=:oppId limit 1 ];
        if(opty.AM_CP1__c == true && opty.FAE_CP1__c==false && opty.AM_CP2__c==false && opty.FAE_CP2__c==false && opty.PLM_CP2__c == false && opty.MarketSegment_CP2__c==false && opty.AM_CP3__c==false && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
            //checkpoint = '1';
            stageName = 'Next Stage';
        }else if(opty.AM_CP1__c == true && opty.FAE_CP1__c==true && opty.AM_CP2__c==false && opty.FAE_CP2__c==false && opty.PLM_CP2__c == false && opty.MarketSegment_CP2__c==false && opty.AM_CP3__c==false && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
            //checkpoint = '1';
            stageName = 'Next Stage';
        }          
        else if(opty.AM_CP1__c == true && opty.FAE_CP1__c==true && opty.AM_CP2__c==true && opty.FAE_CP2__c==false && opty.PLM_CP2__c == false && opty.MarketSegment_CP2__c==false && opty.AM_CP3__c==false && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
            //checkpoint = '2';
            stageName = 'Next Stage';
        }
        else if(opty.AM_CP1__c == true && opty.FAE_CP1__c==true && opty.AM_CP2__c==true && opty.FAE_CP2__c==true && opty.PLM_CP2__c == true && opty.MarketSegment_CP2__c==true && opty.AM_CP3__c==false && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
            //checkpoint = '2';
            stageName = 'Next Stage';
        }    
        else if(opty.AM_CP1__c == true && opty.FAE_CP1__c==true && opty.AM_CP2__c==true && opty.FAE_CP2__c==true && opty.PLM_CP2__c == true && opty.MarketSegment_CP2__c==true && opty.AM_CP3__c==true && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
            //checkpoint = '3';
            stageName = 'Design Win';
        }    
        else if(opty.AM_CP2__c==true && opty.FAE_CP2__c==false&& opty.PLM_CP2__c == false && opty.MarketSegment_CP2__c==false && opty.AM_CP3__c==false && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
            //checkpoint = '2';
            stageName = 'Next Stage';
        }
        else if(opty.AM_CP2__c==true && opty.FAE_CP2__c==true && opty.PLM_CP2__c == true && opty.MarketSegment_CP2__c==true && opty.AM_CP3__c==false && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
            //checkpoint = '2';
            stageName = 'Next Stage';
        }    
        else if(opty.AM_CP2__c==true && opty.FAE_CP2__c==true && opty.PLM_CP2__c == true && opty.MarketSegment_CP2__c==true && opty.AM_CP3__c==true && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
            //checkpoint = '3';
            stageName = 'Design Win';
        }
        return stageName;
    }
    
}