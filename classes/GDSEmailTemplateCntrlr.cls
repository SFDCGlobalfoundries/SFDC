/*
    Author: Ariz Solito
    Description: Apex class controller for the GDSEmailTemplate
    History: 
        Asolito     17112014    - Code creation.
*/

public class GDSEmailTemplateCntrlr {
    public String recID {
        get{
             if(!UtilsString.isNotBlank(this.recID)){
                    return 'blank';
             }    
            return this.recID;             
        }
        set;
    }
    public Boolean showInternalURL {get; set;}
    public Boolean showExternalURL {get; set;}
    
    public String sfdcURL {
        get {
            return EnvironmentVariable.get('SFDC_INSTANCE') + '/' + this.recID;
        }
        set;
    }
    
    public String portalURL {
        get {
            return EnvironmentVariable.get('SFDC_CUSTOMER_PORTAL')+ '/' + this.recID;
        }
        set;
    }              
}