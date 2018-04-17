/*
Type Name: FoundryServicePricesController
Author: Cognizant
Created Date: 24-Jan-2017
Reason: This class is used to display Foundry service pricing ppts to customer portal users. 
Change History:
Author: Cognizant
Modified Date: 
Reason: 
……..
……..
*/

public class FoundryServicePricesController {
    public integer next{get; set;}//when next img is clicked
    public integer previous{get; set;}//when previous img is clicked
    public integer current{get; set;} //stores the current Img
    public String pageString{get; Set;}
    public integer totalSlideCount{get; set;}
	public string fmg{get; set;}
    
    /*constuctor to initialise the variable*/
    public FoundryServicePricesController(){
	    fmg='';
        fmg=ApexPages.currentPage().getParameters().get('Foundry');
		if (fmg=='1'){
        pageString='FoundryServicePrices_new/Slide_1.PNG';
        current=1;
        totalSlideCount = Integer.ValueOf(System.Label.Foundry_Service_Prices_Slide_Count);
		}else{
		pageString='ASICServicePrices_new/Slide_1.PNG';
        current=1;
        totalSlideCount =Integer.ValueOf(Environment_Variable__c.getInstance('ASIC_Service_Prices_Slide_Count').Value__c);
		}
    }
    Public pagereference nextImgView(){
	if (fmg=='1'){
        pageString='FoundryServicePrices_new/Slide_';
        current=current+1;
		}else{
		pageString='ASICServicePrices_new/Slide_';
        current=current+1;	
		
		}
      
        string tempCurrentStr=String.valueof(current);
        pageString=pageString+tempCurrentStr;
        pageString=pageString+'.PNG';
        return null;
    }
    Public pagereference previousImg(){
	   if (fmg=='1'){
        pageString='FoundryServicePrices_new/Slide_';
        }else{
        pageString='ASICServicePrices_new/Slide_';
        }
        if(current!=1){
            current=current-1;
            
        }
        string tempCurrentStr=String.valueof(current);
        pageString=pageString+tempCurrentStr;
        pageString=pageString+'.PNG';
        return null;
    }
    Public pagereference goHome(){
        current=1;
		if (fmg=='1'){
        pageString='FoundryServicePrices_new/Slide_1.PNG';
		}else{
		pageString='ASICServicePrices_new/Slide_1.PNG';
		}
        return null;
    }
    
}