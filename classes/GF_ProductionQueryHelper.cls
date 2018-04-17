/*
*   @ Author        : Cognizant Technology LTD.
*   @ Description   : Class Handles operation related to production query to generate report for production query 
*   @ Date          : 8th July 2013
*   @ Param         :
*   @ Methods       : @getLotTypeList(),@getFabList()
**/

global class GF_ProductionQueryHelper {

        public String   prodQuery_Fab               {get;set;}
        public String   prodQuery_lotId             {get;set;}
        public String   prodQuery_customerPartName  {get;set;}
        public String   prodQuery_InternalPartName  {get;set;}
        public String   prodQuery_po                {get;set;}
        public String   prodQuery_lotType           {get;set;}
        public String   prodQuery_PRF               {get;set;}
        public Boolean  prodQuery_Wip               {get;set;}
        public Boolean  prodQuery_WipAndShipDate    {get;set;}
        public Boolean  prodQuery_lotStartDate      {get;set;}
        //public Date   prodQuery_dateFrom          {get;set;}
        //public Date   prodQuery_dateTo            {get;set;}
        public String   prodQuery_dateFrom          {get;set;}
        public String   prodQuery_dateTo            {get;set;}
        public String   prodQuery_LType             {get;set;}
        
        public GF_ProductionQueryHelper(){
            
        }
        
        public List<SelectOption> getLotTypeList() {
            
            return GF_CommonUtilityCls.getLotTypeList();
        }
        
        public List<SelectOption> getFabList() {

            return GF_CommonUtilityCls.getFabList();
        }
}