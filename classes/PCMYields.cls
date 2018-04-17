/*
    Author: Shiva Karna
    Description: Apex controller PCM Yield Administration
    History: 
        SKarna     09/19/2016    - Code creation.                                   
*/
public class PCMYields{
    
    public String catalog,version;
    
    public String getCatalog() {
        return Catalog;
    }
    public String getVersion () {
        return version;
    }
    
    public void setCatalog(String catalog) {
        this.catalog = catalog;
    }
    
    public void setVersion(String version ) {
        this.version = version ;
    }
    
    public List<SelectOption> getCatalogid(){
        
        String DupCatalog;
        List<SelectOption> Catalogid = new List<SelectOption>();
        
        List<PCM_Yield__c> PCMYields =  [Select id, Catalog_ID__c From PCM_Yield__c order by Catalog_ID__c];
        
        for(PCM_Yield__c PY : PCMYields){
            
            if(PY.Catalog_ID__c <> DupCatalog){
                Catalogid.add(new  SelectOption(PY.Catalog_ID__c, PY.Catalog_ID__c));
                DupCatalog=PY.Catalog_ID__c;
            }
            
        }
        return Catalogid;
    }
    
    public List<SelectOption> getVersions(){
        String DupVer;
        
        List<SelectOption> Versions = new List<SelectOption>();
        
        List<PCM_Yield__c> PCMYields =  [Select id, Version__c From PCM_Yield__c order by Version__c];
        
        for(PCM_Yield__c PY : PCMYields){
            if(PY.Version__c != DupVer){
                Versions.add(new  SelectOption(PY.Version__c, PY.Version__c));
                DupVer = PY.Version__c;
            }
        }
        return Versions;
    }
    public PageReference Save(){
        
        pagereference p = apexpages.Currentpage();
        
        PCM_Administration__c[] PCMYields =  [Select id, Catalog_ID__c,Version_ID__c From PCM_Administration__c limit 1];
        
        try{ 
            
            PCM_Administration__c pd = new PCM_Administration__c ();
            
            
            pd.Name = 'CURRENT_SETTING';
            pd.Catalog_ID__c= catalog;
            pd.Version_ID__c=version;
            
            if(PCMYields.size() > 0){
                pd.id = PCMYields[0].id;
                
            }
            upsert pd;
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,'PCM Record has been updated successfully.');
            apexpages.addmessage(msg);
        }
        catch(DMLException ce){
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.error,'Error : '+ce); 
            apexpages.addmessage(msg);
            GlobalUtility.logMessage('Error', 'PCMYields class in PCM', 'Apex Controller', null, null, ce.getMessage(), null,null,ce, null);
        }
        return p;
    }
    
    public PCMYields(){
        for(PCM_Administration__c p: [Select id, Catalog_ID__c,Version_ID__c From PCM_Administration__c limit 1]){
            setCatalog(p.Catalog_ID__c);    
            setVersion(p.Version_ID__c);
        }        
    }
}