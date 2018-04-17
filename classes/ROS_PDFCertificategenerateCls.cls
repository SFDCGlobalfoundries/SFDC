public class ROS_PDFCertificategenerateCls {

	public PageReference createFile(){

		  ROS_Disposal_Certificate__c disposalCertificate = [Select id,PDF_Generated__c,Scrap_Date__c from 
		  													  ROS_Disposal_Certificate__c 
		  													  where Id =: ApexPages.CurrentPage().getparameters().get('id')];	

		  String filename=disposalCertificate.Scrap_Date__c+'_Scrap_Certificate.pdf';     
     	  Savepoint sp = Database.setSavepoint();
          try{
              
              pagereference P=page.rosvf_scrappdf; 
              P.getparameters().put('resultId',disposalCertificate.Id);       
              blob body = P.getContent();
              attachment pdf = new attachment();
              pdf.body=body;
              pdf.Name=filename;
              pdf.ParentId =disposalCertificate.Id;
              pdf.isPrivate = false;
              //insert pdf;
              Database.SaveResult resultreS = Database.insert(pdf,false);
               if(resultreS.isSuccess()){
                  disposalCertificate.PDF_Generated__c =  true;
                  update disposalCertificate;
               }
          } 
          catch(exception ex){
            Database.rollback(sp);
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
          }      
          return new Pagereference('/'+disposalCertificate.Id);
	}	
}