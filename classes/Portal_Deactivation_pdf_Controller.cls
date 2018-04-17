public class Portal_Deactivation_pdf_Controller {
    public List<Contact> lstCons {get; set;}
    public string urlStr {get; set;}
    public Portal_Deactivation_pdf_Controller(){
        
        String idstr = ApexPages.CurrentPage().getParameters().get('Ids');
        urlStr = URL.getSalesforceBaseUrl().toExternalForm();
        if(idstr != null){
            string[] ids = idstr.split(';');
            lstCons = [Select Id,Name,Email from Contact where  Id in: ids];
        }
    }
    
}