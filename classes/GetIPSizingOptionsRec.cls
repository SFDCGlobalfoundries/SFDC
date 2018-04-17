/**
@Author < Nikhil bajaj >
@name < IPSizingOptions vf>
@CreateDate < 1/5/2016 >
@Description < This class is  showing ipsizingoptions records in rfq vf page>
@Version <1.0>*/
public class GetIPSizingOptionsRec {
   Public List<RFQ_IPR__c> IPR_in_rfq_ipr{set;get;}
    Set<String> iprset = new Set<String>();
    Public List<IP_Sizing_Option__c> ipsizingoptions{set;get;}
    Public List<IP_Sizing_Option__c> IPR_in_sizingoptions{set;get;}

    public GetIPSizingOptionsRec(ApexPages.StandardController controller) {
        Id currentpageId =ApexPages.currentPage().getParameters().get('id');
        showIPSizOP(currentpageId);

    }
    
    Public  void showIPSizOP(Id currentpageId){
       //getting iprequest  from rfqipr using rfq id
        IPR_in_rfq_ipr = [select IP_Request__r.Name from RFQ_IPR__c where RFQ__c =:currentpageId] ;
        for(RFQ_IPR__c rfqipr : IPR_in_rfq_ipr){
            if(rfqipr.IP_Request__c!=null && rfqipr.IP_Request__r.Name!=null){
            iprset.add(rfqipr.IP_Request__r.Name);
            }
         }
         
         //getting iprequest from  ip_sizingoption where status is move to development
         IPR_in_sizingoptions=[select IPRequestName__c from IP_Sizing_Option__c where IPRequestName__c in:iprset and Status__c=:'Move to Development'];
         for(IP_Sizing_Option__c option: IPR_in_sizingoptions){
             if(option.IPRequestName__c!=null){
                 iprset.add(option.IPRequestName__c);
                    
              }
          }
             
        ipsizingoptions =[select id,Name,IPRequestName__c ,Evaluator__c, Total_Development_Cost__c,Internal_Development_Cost__c,Internal_Support_Cost__c,Material__c,X3rd_Party_License_Porting_Support_Fees__c,X3rd_Party_Use_Fees__c,X3rd_Party_Royalty__c, Brand_Adjustment__c,Cost_Comments__c from IP_Sizing_Option__c where IPRequestName__c in :iprset and Status__c=:'Move to Development'];
    }
}