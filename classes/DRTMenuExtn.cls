/*
Author: Cognizant Technology Solutions
Company: 
Description:    This will be the controller class behind the Visualforce Page VFDRTSearch. 
                This will also call the handler class DRTHandlerUtility which will contain all 
                the business logic regarding the DRT Search process. 
History:
    Cognizant     15042014     - Initial Version
*/

public class DRTMenuExtn {
    
    public Boolean showdetailsection {get;set;}
    public String  Page{get; set;}
    public String  respectiveLevel {get;set;}
    public String  OpenPageURL {get; set;}
    public boolean showCreateDRTLink {get;set;}
    public boolean showSearchDRTLink {get;set;}
    public boolean showDRTLink {get;set;}
    public string iframeParam {get; set;}
    
    /**
    * @description: This is the constructor.
    * @param: none
    * @return: none
    **/
    public DRTMenuExtn() {
        showCreateDRTLink = true;
        showCreateDRTLink = DRTHandlerUtility.isCreateDRTApplicable(); 
       
        showSearchDRTLink = true;
        showSearchDRTLink = DRTHandlerUtility.isViewDRTApplicable(); 
       
        showDRTLink = true;
        if(!showCreateDRTLink && !showSearchDRTLink) {
            showDRTLink = false;
        }
    }
    
    /**
    * @description: This method is used to refresh the iframe for DRT Create/Search/Detail pages.
    * @param: none
    * @return: PageReference
    **/
    public PageReference redirect(){
        if(Page == 'CreateDRT')
        {
            showdetailsection = true;
            respectiveLevel = 'Device Revision Table';
            OpenPageURL = System.Label.Internal_URL + 'VFDRTCreate';
            
        }
        if(Page == 'SearchDRT')
        {
            showdetailsection = true;
            respectiveLevel = 'Device Revision Table';
            OpenPageURL = System.Label.Internal_URL + 'VFDRTSearch';
            if(!string.isBlank(iframeParam)) {
                OpenPageURL += '?'+iframeParam;
            }
        }
        if(Page == 'DetailDRT')
        {
            showdetailsection = true;
            respectiveLevel = 'Device Revision Table';
            OpenPageURL = System.Label.Internal_URL+ 'VFDRTDetail';
            
            if(!string.isBlank(iframeParam)) {
                OpenPageURL += '?'+iframeParam;
            }
        }
        return null;
    }
}