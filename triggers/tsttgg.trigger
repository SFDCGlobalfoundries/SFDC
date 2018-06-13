trigger tsttgg on Contact (before update) {

    for(contact con : trigger.new){
        
        String strLink = '<a href=' +System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+con.id+' >'+ con.firstname+'</a> <br/>'; 
                     con.addError('Error Record Link: ' + strLink , false); 
    
    }

}