/*
Author:  Yash Kumar
    Description: Creates Opportunity History Class
    History:
        Yashkumar 02052013    - code creation.
*/

public class OppHistory {

    public string oppid{get;set;}
    public Design_Win_Approval_History__c objOppHistory{get;set;}
    public String id= ApexPages.currentPage().getParameters().get('id');
    
    public OppHistory(ApexPages.StandardController controller) {
    
        if(id !=null )
        {
            objOppHistory=[select id,Account__c,Market_Segment__c,Opportunity__c,Opportunity_Name__c,Opportunity_Owner__c,Opportunity_Sourcing_Type__c,Total_Program_Value__c,
            GF_Target_Share_DW__c,GF_Opportunity_Size__c,Sum_of_Quarterly_Revenue__c,Total_Lifetime_Revenue__c,Years_of_Production_DW__c,
            Process_Geometry__c,Process_Platform_Category_DW__c,Target_Process_Node__c,Primary_GF_Fab__c,Is_GF_Committed_to_Process_DW__c,
            Using_GF_PDK_DRC_or_SPICE_Models_DW__c,Date_Design_Win_Approved__c,DW_Quarter_Awarded__c,Design_Win_Revenue__c,Awarded_Amount__c,
            X1st_Product_TO_Date_DW__c,X1st_Product_Production_Date_DW__c,Quote_DW__c,Does_entered_ASP_Align_with_Quote_DW__c
            from Design_Win_Approval_History__c where id=:id limit 1];
            oppid=objOppHistory.Opportunity__c;
        }
    }

    public Pagereference Back()
    {
        pagereference pgref = new pagereference('/'+oppid);
        pgref.setredirect(true);
        return pgref; 
    }
    
    public List<Quarterly_Revenues_History__c> getQuartRevRecords(){
   
        if(id!=null)
        {
            list<Quarterly_Revenues_History__c> lstQuaRevHis = new list<Quarterly_Revenues_History__c>([select id,Name,ASP__c,Fiscal_Quarter__c,Design_Win_Approval_History__c,Opportunity__c,Revenue__c,Volume__c from Quarterly_Revenues_History__c where Design_Win_Approval_History__c=:id ]);
            return lstQuaRevHis;
        }
        else
        {
             return null;
        }
    }
    
    
   
}