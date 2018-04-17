public with sharing class TechReview_ChargeOrderDetailUtility
{
    public Id OptionId {get; set;}
    public TechReview_ChargeOrderDetailUtility()
    {
        
    }
    
    public WrapperCls getDetailInformation()
    {
        WrapperCls objwrapperCls = new WrapperCls();
        if(OptionId != null)
        {
            Tech_Review_Summary__c TRS = new Tech_Review_Summary__c();
            TRS = [Select Option__c, Id from Tech_Review_Summary__c where Id =: OptionId];          
            //Get charge info related to option
            List<Charge_Info__c> chargeInfoList = [select Charge_Number__c, Charge_Type__c, Option__c, SAP_Mask_Order__c
                      from Charge_Info__c where Option__c = : TRS.Option__c Limit 1];
            
            if(chargeInfoList != null && chargeInfoList.size() > 0)
            {
                objwrapperCls.objChargeInfo = chargeInfoList[0];    
                // query sap order details related to charge info
                List<SAP_Order_Detail__c> SapOrderList = new List<SAP_Order_Detail__c>();
                SapOrderList = [Select Id,Name, Charge_Info__c, Order_Type__c, SAP_Order_Number__c, SAP_SoldTo__c, Yield_Mngmnt_Data_Deliveryto__c 
                             from SAP_Order_Detail__c where Charge_Info__c = :chargeInfoList[0].id];
                if(SapOrderList != null && SapOrderList.size() > 0)
                {
                    objwrapperCls.objOrderDetails = SapOrderList;
                }
            }
        }
        return objwrapperCls;
    }
   /**
   @name <WrapperCls>
   @Description <This class is handle mutliple object instances>
   @Version <>
   @reference <>
  */
    public class WrapperCls
    {
        public Charge_Info__c objChargeInfo{private set;get;}
        public List<SAP_Order_Detail__c> objOrderDetails{private set;get;}
    }
}