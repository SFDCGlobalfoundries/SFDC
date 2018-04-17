/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Extension class for the Disposal Certificate page format.
* History       :   

        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    09-Aug-14     Created the Class
        DBiswal        03/10/2016    Added print layout view.                                 
**/

public class ROS_DisposalCertificateFormatExt{
    
    public ROS_DisposalCertificate.CertificateWrapper pdfCertificate {get;set;}
    public String RefinedCDID{get;set;}
    public String PartNumber{get;set;}
    public String RevNumber{get;set;}
    public String NoOfMasks{get;set;}
    public String MaskMaterial{get;set;}
    public String logoURL{get;set;}
    
    //DBiswal - for opening word file in print layout
    public String getprintView()
    {
        String pview = '<!--[if gte mso 9]>' +
                        '<xml>' +
                        '<w:WordDocument>' +
                        '<w:View>Print</w:View>' +
                        '<w:Zoom>100</w:Zoom>' +
                        '<w:DoNotOptimizeForBrowser/>' +
                        '</w:WordDocument>' +
                        '</xml>' +
                        '<![endif]>';
        return pview;        
    }
    
    public ROS_DisposalCertificateFormatExt(){
        RefinedCDID    = ApexPages.currentPage().getParameters().get('cdid');
        PartNumber     = ApexPages.currentPage().getParameters().get('part');
        RevNumber      = ApexPages.currentPage().getParameters().get('rev');
        NoOfMasks      = ApexPages.currentPage().getParameters().get('count');
        MaskMaterial   = ApexPages.currentPage().getParameters().get('mask');
        //DBiswal 03172016
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        string temp = '';
        if(baseUrl.indexOf('my.salesforce.com') > -1){
            temp = baseUrl.substring(0,baseUrl.indexOf('my.salesforce.com'));
        } else {
            temp = baseUrl.substring(0,baseUrl.indexOf('visual.force.com'));
        }
        String logoid = [SELECT Id,Name FROM Document WHERE Name ='broadcom logo'].Id;
        logoURL = temp + 'content.force.com/servlet/servlet.ImageServer?id=' + logoid + '&oid=' + UserInfo.getOrganizationId();
    }
}