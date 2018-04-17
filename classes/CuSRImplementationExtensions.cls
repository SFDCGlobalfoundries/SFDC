/*
Author: Shyam Ravindra Nair
Description: Apex class will act as extension to following pages
1) CuSRImplementationViewPage
2) CuSRImplementationEditPage
History:
SNair     30122014     - code creation
SNair     09012015     - added logic for new Implementation Form.
PSamal    06122017     - Case-00051184(Changes for new site - Essex Junction, East Fishkill, ASIC)
*/
public class CuSRImplementationExtensions{
    public CuSR_Implementation__c implementation{get;set;}
    public CuSR_Form__c cusrForm{get;set;}
    public Id recID{get;set;}
    public pageReference pgRef{get;set;}
    public String sourceFab{get;set;}
    public Id cusrFormRecordID{get;set;}
    public User currentUser{get;set;}
    public Profile currentUserProfile{get;set;}
    public boolean enableEdit{get;set;}
    public boolean creator{get;set;}
    public boolean showAttachmentError{get;set;}
    public List<Attachment> attachmentList{get;set;}
    public String attachmentId{get;set;}
    public boolean disableEditWhenVoided{get;set;}
    
    //Constructor
    public CuSRImplementationExtensions(ApexPages.StandardController sc){
        implementation = (CuSR_Implementation__c)sc.getRecord();
        recID = implementation.Id;
        UtilClassToGetAllFields utilClass = new UtilClassToGetAllFields();
        String implementationQueryFields = utilClass.getAllFields('CuSR_Implementation__c');
        String cusrFormQueryFields = utilClass.getAllFields('CuSR_Form__c');
        currentUser = [select id, Department from User where Id=: userinfo.getUserId()]; 
        currentUserProfile = [select Id, Name from Profile where Id =: userInfo.getProfileId()];
        showAttachmentError = true;
        attachmentList = new List<Attachment>();
        if(recID != null){
            String implementationQuery = 'select '+implementationQueryFields+' from CuSR_Implementation__c where Id = \''+recID+'\'';
            implementation = Database.query(implementationQuery);
            sourceFab = implementation.Fab__c;
            String cusrFormQuery = 'select '+cusrFormQueryFields+' from CuSR_Form__c where Id = \''+implementation.CuSR_Form__c+'\'';
            cusrForm = Database.query(cusrFormQuery);
            cusrFormRecordID = cusrForm.Id;
            checkUserForEdit();
            checkCreator();
            attachmentList = [select Id, Name, OwnerId from Attachment where ParentId =: implementation.Id];
            disableEditWhenVoidedMethod();
        }
        else{
            implementation = new CuSR_Implementation__c();
            cusrFormRecordID = ApexPages.currentPage().getParameters().get('CuSRFormId');
            sourceFab = ApexPages.currentPage().getParameters().get('selectedfab');
            implementation.CuSR_Form__c = cusrFormRecordID;
            implementation.Fab__c = sourceFab;
            //checkCreator();
        }
    }
    
    public void disableEditWhenVoidedMethod(){
        disableEditWhenVoided = false;
        if(cusrForm.Status__c == 'Void'){
            disableEditWhenVoided = true;
        }
        if(implementation.Fab__c == 'FAB 1' && cusrForm.FAB_1_Void__c){
            disableEditWhenVoided = true;
        }
        if(implementation.Fab__c == 'FAB 2' && cusrForm.FAB_2_Void__c){
            disableEditWhenVoided = true;
        }
        if(implementation.Fab__c == 'FAB 3' && cusrForm.FAB_3_Void__c){
            disableEditWhenVoided = true;
        }
        if(implementation.Fab__c == 'FAB 3E' && cusrForm.FAB_3E_Void__c){
            disableEditWhenVoided = true;
        }
        if(implementation.Fab__c == 'FAB 5' && cusrForm.FAB_5_Void__c){
            disableEditWhenVoided = true;
        }
        if(implementation.Fab__c == 'FAB 6' && cusrForm.FAB_6_Void__c){
            disableEditWhenVoided = true;
        }
        if(implementation.Fab__c == 'FAB 7' && cusrForm.FAB_7_Void__c){
            disableEditWhenVoided = true;
        }
        if(implementation.Fab__c == 'FAB 8' && cusrForm.FAB_8_Void__c){
            disableEditWhenVoided = true;
        }
        if(implementation.Fab__c == 'FAB 9' && cusrForm.FAB_9_Void__c){
            disableEditWhenVoided = true;
        }
        if(implementation.Fab__c == 'FAB 10' && cusrForm.FAB_10_Void__c){
            disableEditWhenVoided = true;
        }
        if(implementation.Fab__c == 'ASIC' && cusrForm.ASIC_Void__c){
            disableEditWhenVoided = true;
        }
    }
    
    public void checkCreator(){
        creator = false;
        if(currentUser.Id == cusrForm.OwnerId || currentUser.Id == implementation.CreatedById || currentUserProfile.Name == 'System Administrator' || currentUserProfile.Name == 'GF System Admin' || currentUserProfile.Name == 'GF Integration' || currentUserProfile.Name == 'CTS Developers'){
            creator = true;
        }
    }
    
    public void checkUserForEdit(){
        enableEdit = false;
        if(currentUser.Id == cusrForm.OwnerId || currentUser.Id == implementation.Assignee__c || currentUser.Id == implementation.CreatedById || currentUserProfile.Name == 'System Administrator' || currentUserProfile.Name == 'GF System Admin' || currentUserProfile.Name == 'GF Integration' || currentUserProfile.Name == 'CTS Developers'){
            enableEdit = true;
        }
    }
    
    //to navigate to CuSR Form
    public pageReference navigateToCuSRForm(){
        pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrFormRecordID);
        if(sourceFab == 'FAB 1'){
            pgRef.getParameters().put('tabname','dresden');
            pgRef.getParameters().put('dresdensubtabname','dresdenimplementation');
        }
        else if(sourceFab == 'FAB 8'){
            pgRef.getParameters().put('tabname','malta');
            pgRef.getParameters().put('maltasubtabname','maltaimplementation');
        }
        else if(sourceFab == 'FAB 9'){
            pgRef.getParameters().put('tabname','essexjunction');
            pgRef.getParameters().put('essexjunctionsubtabname','essexjunctionimplementation');
        }
        else if(sourceFab == 'FAB 10'){
            pgRef.getParameters().put('tabname','eastfishkill');
            pgRef.getParameters().put('eastfishkillsubtabname','eastfishkillimplementation');
        }
        else if(sourceFab == 'ASIC'){
            pgRef.getParameters().put('tabname','asic');
            pgRef.getParameters().put('asicsubtabname','asicimplementation');
        }
        else{
            pgRef.getParameters().put('tabname','singapore');
            pgRef.getParameters().put('singaporesubtabname','singaporeimplementation');
        }
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    //method to delete attachment
    public void deleteAttachment(){
        try{
            Integer index = 0;
            for(Attachment attach: attachmentList){
                if(attach.Id == attachmentId){
                    break;
                }
                index++;    
            } 
            attachmentList.remove(index);
            if(attachmentId == null){
                return;
            }
            delete [select Id from Attachment where Id =: attachmentId];
        }
        catch(Exception e){
            
        }
    }
    
    // save/update implementation record
    public pageReference saveImplementation(){
        boolean validateFields = true;
        showAttachmentError = true;
        if(implementation.Id == null){
                if(implementation.Action__c == '' || implementation.Action__c == null){
                        validateFields = false;
                        implementation.Action__c.addError('Please mention the actions.');
                }
                if(implementation.Planned_End_Date__c == null){
                        validateFields = false;
                        implementation.Planned_End_Date__c.addError('Please mention the planned end date.');
                }
        }
        if(!validateFields){
                return null;
        }
        else{
                if(implementation.Id == null){
                    implementation.Status__c = 'Pending';
                }
                insert Implementation;
                pgRef = new pageReference('/apex/CuSRImplementationViewPage?Id='+implementation.Id);
                pgRef.setRedirect(true);
                return pgRef;
        }
    }
    
    //method for update
    public pageReference updateImplementation(){
        boolean validateFields = true;
        if(implementation.Status__c == 'Completed'){
                if(implementation.Comments__c == '' || implementation.Comments__c == null){
                        validateFields = false;
                        implementation.Comments__c.addError('Please mention comments.');
                }
                if(implementation.Actual_End_Date__c == null){
                        validateFields = false;
                        implementation.Actual_End_Date__c.addError('Please select actual end date.');
                }
                List<Attachment> attachmentList = [select Id from Attachment where ParentId =: implementation.Id];
                if(attachmentList.isEmpty()){
                    showAttachmentError = false;
                    validateFields = false;
                }
        }
        if(implementation.Status__c == 'Cancelled'){
                if(implementation.Comments__c == '' || implementation.Comments__c == null){
                        validateFields = false;
                        implementation.Comments__c.addError('Please mention comments.');
                }
        }
        if(!validateFields){
                return null;
        }
        else{
                upsert implementation;
                pgRef = new pageReference('/apex/CuSRImplementationViewPage?Id='+implementation.Id);
                pgRef.setRedirect(true);
                return pgRef;
        }
    }
    
    public pageReference cancelAction(){
        if(implementation.Id == null){
                pgRef = new pageReference('/apex/CuSRFormViewPage?Id='+cusrFormRecordID);
                if(sourceFab == 'FAB 1'){
                    pgRef.getParameters().put('tabname','dresden');
                    pgRef.getParameters().put('dresdensubtabname','dresdenimplementation');
                }
                else if(sourceFab == 'FAB 8'){
                    pgRef.getParameters().put('tabname','malta');
                    pgRef.getParameters().put('maltasubtabname','maltaimplementation');
                }
                else if(sourceFab == 'FAB 9'){
                    pgRef.getParameters().put('tabname','essexjunction');
                    pgRef.getParameters().put('essexjunctionsubtabname','essexjunctionimplementation');
                }
                else if(sourceFab == 'FAB 10'){
                    pgRef.getParameters().put('tabname','eastfishkill');
                    pgRef.getParameters().put('eastfishkillsubtabname','eastfishkillimplementation');
                }
                else if(sourceFab == 'ASIC'){
                    pgRef.getParameters().put('tabname','asic');
                    pgRef.getParameters().put('asicsubtabname','asicimplementation');
                }
                else{
                    pgRef.getParameters().put('tabname','singapore');
                    pgRef.getParameters().put('singaporesubtabname','singaporeimplementation');
                }
            }
        else{
                pgRef = new pageReference('/apex/CuSRImplementationViewPage?Id='+implementation.Id);    
        }
        
        pgRef.setRedirect(true);
                return pgRef;           
    }
}