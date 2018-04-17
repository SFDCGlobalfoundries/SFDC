/*
    Author: Pradosh Samal
    Description: This is the class for Requote for Informal Quote  
    History:
        Psamal       11112016    - code creation.
*/
public class IQ_RequoteController {
    
    public Id existingIQID {get; set;}
    
    public static Boolean stopProcessIdValidation = false;
    
    public IQ_RequoteController(ApexPages.StandardController controller) {
        
        existingIQID = ApexPages.currentPage().getParameters().get('EIQ');   
        
        stopProcessIdValidation = false;
    }
    
    public PageReference reQuote() {
        try{
            String informalQuoteQuery = 'SELECT ';
            Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get('Informal_Quote__c').getDescribe().fields.getMap();

            Integer i = 1;
            for(String field : objectFields.keySet()) {
                informalQuoteQuery += field;
                if(i != objectFields.size()){
                    informalQuoteQuery += ', ';
                }
                i++;
            }
            informalQuoteQuery += ' FROM Informal_Quote__c WHERE Id = : existingIQID';
            
            List<Informal_Quote__c> existingInformalQuoteList = Database.query(informalQuoteQuery);
            
            Informal_Quote__c parentInformalQuote = existingInformalQuoteList[0];
            
            String iqID = '';
            if(parentInformalQuote.IQ_ID__c != null
               && parentInformalQuote.IQ_ID__c != ''){
                
                String temp = parentInformalQuote.IQ_ID__c.split('\\.')[0];
                temp += '%';
                List<Informal_Quote__c> iqCountList = Database.query('SELECT Id FROM Informal_Quote__c WHERE IQ_ID__c LIKE :temp');
                
                if(iqCountList != null){
                    if(iqCountList.size() < 9){
                        iqID = parentInformalQuote.IQ_ID__c.split('\\.')[0] + '.0' + (iqCountList.size() + 1);
                    }
                    else{
                        iqID = parentInformalQuote.IQ_ID__c.split('\\.')[0] + '.' + (iqCountList.size() + 1);
                    }
                }
            }
            else{
                iqID = parentInformalQuote.Name + '.01';
            }
            
            Informal_Quote__c informalQuote = new Informal_Quote__c();
            
            informalQuote.Existing_Informal_Quote__c = existingIQID;
            informalQuote.Budgetary_Quote_Status__c = 'Draft';
            
            informalQuote.IQ_ID__c = iqID;
            
            informalQuote.Business_Deal_Proposal__c = parentInformalQuote.Business_Deal_Proposal__c;    
            informalQuote.Account__c = parentInformalQuote.Account__c;
            informalQuote.Additional_IP_Requirement__c = parentInformalQuote.Additional_IP_Requirement__c;
            informalQuote.Budgetary_Quote_Approved__c = parentInformalQuote.Budgetary_Quote_Approved__c;
            informalQuote.Budgetary_Quote_Type__c = parentInformalQuote.Budgetary_Quote_Type__c;
            informalQuote.Capacity_Availability__c = parentInformalQuote.Capacity_Availability__c;
            informalQuote.Comment_by_Pricing__c = parentInformalQuote.Comment_by_Pricing__c;
            informalQuote.Comment_by_Product_Marketing__c = parentInformalQuote.Comment_by_Product_Marketing__c;
            informalQuote.Competitor1__c = parentInformalQuote.Competitor1__c;
            informalQuote.Competitor_1_Complexity__c = parentInformalQuote.Competitor_1_Complexity__c;
            informalQuote.Competitor_1_Price_US__c = parentInformalQuote.Competitor_1_Price_US__c;
            informalQuote.Competitor_1_Quarter__c = parentInformalQuote.Competitor_1_Quarter__c;
            informalQuote.Competitor_2_Complexity__c = parentInformalQuote.Competitor_2_Complexity__c;
            informalQuote.Competitor_2_Price_US__c = parentInformalQuote.Competitor_2_Price_US__c;
            informalQuote.Competitor_2_Quarter__c = parentInformalQuote.Competitor_2_Quarter__c;
            informalQuote.Competitor_2__c = parentInformalQuote.Competitor_2__c;
            informalQuote.Competitor_Others_Price_US__c = parentInformalQuote.Competitor_Others_Price_US__c;
            informalQuote.Competitor_Others__c = parentInformalQuote.Competitor_Others__c;
            informalQuote.IP_Payable_Amount__c = parentInformalQuote.IP_Payable_Amount__c;
            informalQuote.IP_Payable_By_GF__c = parentInformalQuote.IP_Payable_By_GF__c;
            informalQuote.Metal_Mask_Count__c = parentInformalQuote.Metal_Mask_Count__c;
            informalQuote.Mockflow__c = parentInformalQuote.Mockflow__c;
            informalQuote.NRE_Payable_Amount__c = parentInformalQuote.NRE_Payable_Amount__c;
            informalQuote.NRE_Payable_by_GF__c = parentInformalQuote.NRE_Payable_by_GF__c;
            informalQuote.Opportunity__c = parentInformalQuote.Opportunity__c;
            informalQuote.Poly_Mask__c = parentInformalQuote.Poly_Mask__c;
            informalQuote.Price_Approval_By__c = parentInformalQuote.Price_Approval_By__c;
            informalQuote.Pricing_Type__c = parentInformalQuote.Pricing_Type__c;
            informalQuote.Process_Geometry__c = parentInformalQuote.Process_Geometry__c;
            informalQuote.Process_ID__c = parentInformalQuote.Process_ID__c;
            informalQuote.Product_Category__c = parentInformalQuote.Product_Category__c;
            informalQuote.Quantity__c = parentInformalQuote.Quantity__c;
            informalQuote.Quote_Description__c = parentInformalQuote.Quote_Description__c;
            informalQuote.Technology_Priority__c = parentInformalQuote.Technology_Priority__c;
            informalQuote.Technology_Readiness__c = parentInformalQuote.Technology_Readiness__c;
            informalQuote.Term_and_Conditions_Requested__c = parentInformalQuote.Term_and_Conditions_Requested__c;
            informalQuote.Total_Number_of_Masks__c = parentInformalQuote.Total_Number_of_Masks__c;
            informalQuote.Disclaimer__c = parentInformalQuote.Disclaimer__c;
            informalQuote.Cache_SRAM__c = parentInformalQuote.Cache_SRAM__c;
            informalQuote.Device__c = parentInformalQuote.Device__c;
            informalQuote.Existing_Device__c = parentInformalQuote.Existing_Device__c;
            informalQuote.How_Many_Cores__c = parentInformalQuote.How_Many_Cores__c;
            informalQuote.If_Yes_Percentage_of_Repairable_Cache__c = parentInformalQuote.If_Yes_Percentage_of_Repairable_Cache__c;
            informalQuote.Is_Cache_Repairable__c = parentInformalQuote.Is_Cache_Repairable__c;
            informalQuote.Non_Repairable_SRAM_in_Cache_Area__c = parentInformalQuote.Non_Repairable_SRAM_in_Cache_Area__c;
            informalQuote.Percent_of_Non_Repairable_Memory_in_CU__c = parentInformalQuote.Percent_of_Non_Repairable_Memory_in_CU__c;
            informalQuote.Percent_of_non_Repairable_Memory_in_CPU__c = parentInformalQuote.Percent_of_non_Repairable_Memory_in_CPU__c;
            informalQuote.Percent_of_non_repairable_SRAM__c = parentInformalQuote.Percent_of_non_repairable_SRAM__c;
            informalQuote.Redundancy_of_CU__c = parentInformalQuote.Redundancy_of_CU__c;
            informalQuote.Redundancyof_CPU__c = parentInformalQuote.Redundancyof_CPU__c;
            informalQuote.Total_Area_of_CPU__c = parentInformalQuote.Total_Area_of_CPU__c;
            informalQuote.Total_Area_of_Compute_Unit__c = parentInformalQuote.Total_Area_of_Compute_Unit__c;
            informalQuote.Total_Cache_SRAM_Area__c = parentInformalQuote.Total_Cache_SRAM_Area__c;
            informalQuote.Total_Chip_Area__c = parentInformalQuote.Total_Chip_Area__c;
            informalQuote.Total_Memory_in_CPU__c = parentInformalQuote.Total_Memory_in_CPU__c;
            informalQuote.Total_Memory_in_CU__c = parentInformalQuote.Total_Memory_in_CU__c;
            informalQuote.Total_Number_of_CU__c = parentInformalQuote.Total_Number_of_CU__c;
            informalQuote.Total_SRAM_Area_in_the_Cache__c = parentInformalQuote.Total_SRAM_Area_in_the_Cache__c;
            informalQuote.Total_SRAM_including_Cache_CU_CPU__c = parentInformalQuote.Total_SRAM_including_Cache_CU_CPU__c;
            informalQuote.User1__c = parentInformalQuote.User1__c;
            informalQuote.User2__c = parentInformalQuote.User2__c;
            informalQuote.Yield_Commit__c = parentInformalQuote.Yield_Commit__c;
            informalQuote.layers__c = parentInformalQuote.layers__c;
            informalQuote.of_layers_based_on_BEOL_stack_and_FET__c = parentInformalQuote.of_layers_based_on_BEOL_stack_and_FET__c;
            informalQuote.X1st_Product_Date__c = parentInformalQuote.X1st_Product_Date__c;
            informalQuote.Years_of_Product__c = parentInformalQuote.Years_of_Product__c;
            informalQuote.List_Price__c = parentInformalQuote.List_Price__c;
            informalQuote.Volume_break__c = parentInformalQuote.Volume_break__c;
            informalQuote.Process_Geometry_Range__c = parentInformalQuote.Process_Geometry_Range__c;
            informalQuote.Owner__c = parentInformalQuote.Owner__c;
            
            stopProcessIdValidation = true;
            insert informalQuote;
            stopProcessIdValidation = false;
            
            String informalQuoteItemsQuery = 'SELECT ';
            objectFields = Schema.getGlobalDescribe().get('Budgetary_Quote_Item__c').getDescribe().fields.getMap();

            i = 1;
            for(String field : objectFields.keySet()) {
                informalQuoteItemsQuery += field;
                if(i != objectFields.size()){
                    informalQuoteItemsQuery += ', ';
                }
                i++;
            }
            Id parentInformalQuoteID = parentInformalQuote.Id;
            informalQuoteItemsQuery += ' FROM Budgetary_Quote_Item__c WHERE Budgetary_Quote__c = : parentInformalQuoteID';
            List<Budgetary_Quote_Item__c> informalQuoteItemList = Database.query(informalQuoteItemsQuery);
            
            List<Budgetary_Quote_Item__c> newInformalQuoteItemList = new List<Budgetary_Quote_Item__c>();
            Budgetary_Quote_Item__c temp;
            
            for(Budgetary_Quote_Item__c obj : informalQuoteItemList){
                
                temp = obj.clone();
                temp.Budgetary_Quote__c = informalQuote.Id;
                
                newInformalQuoteItemList.add(temp);
            }
            
            if(newInformalQuoteItemList.size() > 0){
                stopProcessIdValidation = true;
                insert newInformalQuoteItemList;
                stopProcessIdValidation = false;
            }
            
            PageReference pageRef = new PageReference('/' + informalQuote.Id);
            pageRef.setRedirect(true);
            return pageRef;
        }
        catch(Exception e){
            GlobalUtility.logMessage('Error', 'IQ_RequoteController', 'reQuote', '', '', e.getMessage(), '', 'Informal Quotes', e, 0);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage() + ', ' + e.getStackTraceString()));
        }
        return null;
    }
}