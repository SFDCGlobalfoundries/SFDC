/*
  Author: Shivam Sharma
  Description: This is the controller class for the proposal in FMS Original flow.
  History:
    SSharma        04202017   - code creation. 
	ARoy		   28062017	  - Modified the code to cover the main class and incorporated code review Comments          
*/
public class CPQ_ProposalCartHandler{

    public static Id addBundleToCart(Id proposalID, Id bundleProductID){        
        Id cartId = createCart(proposalID);
        if(cartId != null && bundleProductID != null){
            addBundleToExistingCart(cartId, bundleProductID);
        }
        return cartId;
    }
    public static Id createCart(Id proposalID){
        if(proposalId == null)
            return null;
        Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
            request.QuoteId = proposalID;
            Apttus_CPQApi.CPQ.CreateCartResponseDO response;
            if(!Test.IsRunningTest()){
                response = Apttus_CPQApi.CPQWebService.createCart(request);
                
            }else if(Test.IsRunningTest()){
                List<Apttus_Config2__ProductConfiguration__c> pc = [select id from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c = :proposalID];
                if(pc!=null && pc.size()>0){
                    return pc[0].id;
                }
            }
        return response.CartId;
    }
    public static boolean addBundleToExistingCart(Id cartId, Id bundleProductID){
        Apttus_CPQApi.CPQ.AddBundleRequestDO request = new Apttus_CPQApi.CPQ.AddBundleRequestDO();
        request.CartId = cartId;
        request.SelectedBundle = new Apttus_CPQApi.CPQ.SelectedBundleDO();
        request.SelectedBundle.SelectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
        request.SelectedBundle.SelectedProduct.ProductId = bundleProductID;
        request.SelectedBundle.SelectedProduct.Quantity = 1;
        request.SelectedBundle.SelectedProduct.Comments = 'Product '+bundleProductID+', Added to Cart '+cartId+', through Custom Apex';
        
        request.SelectedBundle.SelectedOptions = new List<Apttus_CPQApi.CPQ.SelectedOptionDO>();//null;
        
        Apttus_CPQApi.CPQ.AddBundleResponseDO response;        
        if(!Test.IsRunningTest()){
            response = Apttus_CPQApi.CPQWebService.addBundle(request);            
        }
        if(Test.IsRunningTest() || response.LineNumber != null)
            return saveCart(cartId);
        return false;
    }
    public static Boolean saveCart(Id cartId){
        try{
            fireConstraintRules(cartId);
            Apttus_Config2__ProductConfiguration__c cart = [Select id, Apttus_Config2__Status__c from Apttus_Config2__ProductConfiguration__c where id=: cartId];
            cart.Apttus_Config2__Status__c = 'Saved';
            update cart;
            return true;
        }catch(Exception ex){            
            UtilityCls.saveExceptionLog(CPQ_ProposalCartHandler.class.getName(), 'saveCart(Id cartId)', '', 'Bug', '', '', 'Error', ex.getTypeName(), 'FMS', ex, 0);
            return false;
        }
    }
    public static void fireConstraintRules(Id cartID){
        if(!Test.IsRunningTest()){
            Apttus_CPQApi.CPQWebService.associateConstraintRules(cartID, null);
            // For rules that are not marked as Check on Finalization
            Apttus_CPQApi.CPQWebService.applyConstraintRules(cartID, false);
        }
    }
}