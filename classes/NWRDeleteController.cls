public class NWRDeleteController {
    
    public NWRDeleteController(ApexPages.StandardController controller) {
        
        
    }
    
    public PageReference deleteRecord(){
        
        PageReference pageRef;
        
        String urlString;
        
        try{
            /*Id id;
            
            if(ApexPages.currentPage().getParameters().get('id') != null
               && ApexPages.currentPage().getParameters().get('id').split('\\?').size() > 0){
                
                id = ApexPages.currentPage().getParameters().get('id').split('\\?')[0];
            }
            */
            Id id = ApexPages.currentPage().getParameters().get('id');
            
            if(id != null){
                 
                if(ApexPages.currentPage().getHeaders().get('Referer') != null){

                    List<String> urlList = ApexPages.currentPage().getHeaders().get('Referer').split('/');

                    if(urlList != null
                      && urlList.size() >= 4){
                        try{
                            if((Id)urlList[3] == id){
                                urlString = URL.getSalesforceBaseUrl().toExternalForm() + '/' + String.valueOf(id).subString(0, 3);
                            }
                            else{
                                urlString = ApexPages.currentPage().getHeaders().get('Referer');
                            }
                        }
                        catch(Exception e){
                            urlString = URL.getSalesforceBaseUrl().toExternalForm() + '/' + String.valueOf(id).subString(0, 3);
                        }
                    }
					else{
						urlString = URL.getSalesforceBaseUrl().toExternalForm() + '/' + String.valueOf(id).subString(0, 3);
					}
                }
                else{
                
                    urlString = URL.getSalesforceBaseUrl().toExternalForm() + '/' + String.valueOf(id).subString(0, 3);
                }
                 
                pageRef = New PageReference(urlString);

                Non_Wafer_Revenue__c nfrObj = new Non_Wafer_Revenue__c(Id = id);

                delete nfrObj;
            }
        }
        catch(Exception e){
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage() + ', ' +  e.getLineNumber() + ', ' + e.getStackTraceString() ) );
        }
        
        return pageRef;    
    }
}