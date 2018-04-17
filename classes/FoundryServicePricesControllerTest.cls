@istest
public class FoundryServicePricesControllerTest{
    static testmethod void test1(){
        Environment_Variable__c ENV=new Environment_Variable__c();
        ENV.name='ASIC_Service_Prices_Slide_Count';
        ENV.Value__c='13';
        Insert env;
        ApexPages.currentPage().getParameters().put('Foundry','1');
        FoundryServicePricesController fspCon = new FoundryServicePricesController();        
        fspCon.nextImgView();
        fspCon.previousImg();
        fspCon.goHome();
        ApexPages.currentPage().getParameters().put('Foundry','2');
        FoundryServicePricesController fspCon1 = new FoundryServicePricesController();        
        fspCon1.nextImgView();
        fspCon1.previousImg();
        fspCon1.goHome();
    }
}