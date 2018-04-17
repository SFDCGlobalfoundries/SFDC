/**
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Functionality to create disposal certificates for the selected customer.
* History       :   

        Initials        Date          Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    09-Aug-14       Created the Class  
        DBiswal        03112016        Changes the refinedCDID                                 
**/

public without sharing class ROS_DisposalCertificate {
    
    public List<CertificateWrapper> lstCertificateWrapper{get;set;}
    public List<Attachment> lstAttachments = new List<Attachment>();    
    public Reticle__c reticleRec{get;set;}
    
    public ROS_DisposalCertificate(){
        reticleRec = new Reticle__c();
    }
    
    public pageReference Generate(){
        lstCertificateWrapper = new List<CertificateWrapper>();
        
        List<Reticle_Device__c> lstReticles = [ SELECT id, GF_Device_Id__c, 
                                                      Reticle__r.ROS_Status__c, Reticle__r.name
                                                FROM  Reticle_Device__c 
                                                WHERE Reticle__r.Account__c = :reticleRec.Account__c
                                                      AND Reticle__r.ROS_Cycle__c = :reticleRec.ROS_Cycle__c
                                                      AND Reticle__r.Reticle_Workflow_Status__c = 'Pending for Customer Feedback'
                                                      ];                                      
        
        if(lstReticles == NULL || lstReticles.isEmpty()){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Devices found under the selected filters.');
            ApexPages.addMessage(myMsg);
            return NULL;
        }
        
        system.debug('#######lstReticles ########'+lstReticles.size());
        Set<String> setRefinedCustId = new Set<String>();
        map<String,CertificateWrapper> mapCustIdInfo = new map<String,CertificateWrapper>();
        
        Pattern ischaracters = Pattern.Compile('^[a-zA-Z]+$');
        Pattern myPattern    = Pattern.Compile('\\w\\d+.(?=\\d*$)+[0-9]');
        Pattern revisionPat  = Pattern.Compile('.(?=\\d*$)\\w+');
        Pattern specialChar  = Pattern.Compile('^(.*?)[.^$*+?()\\[\\]{\\|\\-_\\s]');
        
        for(Reticle_Device__c ret:lstReticles){
            string refinedCDID;
            if(ret.GF_Device_Id__c != NULL && !ret.GF_Device_Id__c.toLowerCase().contains('dummy')){
                Matcher m= specialChar.matcher(ret.GF_Device_Id__c.replace('*',''));
                while (m.find()){
                    if(m.group(0) != NULL && m.group(0) != ''){
                        refinedCDID = m.group(0).substring(0,m.group().length()-1);
                    }
                }
                if(refinedCDID == NULL || refinedCDID.length()<2){
                    refinedCDID = ret.GF_Device_Id__c;
                }
                system.debug('####refined####'+refinedCDID);
                
                setRefinedCustId.add(refinedCDID);
                if(!mapCustIdInfo.containsKey(refinedCDID)){
                    mapCustIdInfo.put(refinedCDID,new CertificateWrapper());
                    mapCustIdInfo.get(refinedCDID).refinedCDID = '; ';
                    mapCustIdInfo.get(refinedCDID).PartNumber  = '; ';
                    mapCustIdInfo.get(refinedCDID).RevNumber   = '; ';
                    mapCustIdInfo.get(refinedCDID).MaskMaterial= '; ';
                    mapCustIdInfo.get(refinedCDID).NoOfMasks   = 0;
                }
                if(!mapCustIdInfo.get(refinedCDID).refinedCDID.contains('; '+refinedCDID+'; ')){
                    mapCustIdInfo.get(refinedCDID).refinedCDID   = refinedCDID;
                }
                if(!mapCustIdInfo.get(refinedCDID).PartNumber.contains('; '+ret.GF_Device_Id__c+'; ')){
                    mapCustIdInfo.get(refinedCDID).PartNumber   += ret.GF_Device_Id__c + '; ';
                }
                if(!mapCustIdInfo.get(refinedCDID).MaskMaterial.contains('; '+ret.Reticle__r.name+'; ')){
                    mapCustIdInfo.get(refinedCDID).MaskMaterial += ret.Reticle__r.name + '; ';
                    string noOfMask = (mapCustIdInfo.get(refinedCDID).MaskMaterial).trim();
                    system.debug('?????' +noOfMask);
                    list<string>noOfMaskList=noOfMask.split(';');
                    system.debug('?????' +noOfMaskList);
                    system.debug('?????' +mapCustIdInfo.get(refinedCDID).NoOfMasks);
                    mapCustIdInfo.get(refinedCDID).NoOfMasks=((noOfMaskList).size())-1;
                    system.debug('?????' +mapCustIdInfo.get(refinedCDID).NoOfMasks);
                    
                }
               // mapCustIdInfo.get(refinedCDID).NoOfMasks    += 1;
                string tempRevision = '';
                
                //----------------------------------------------------------------------------
                /*if(refinedCDID != NULL && refinedCDID != '' && refinedCDID.length()>1){
                    system.debug('###Refined###'+refinedCDID);
                    for(Integer i=refinedCDID.length();i>=1;i--){
                        String s= refinedCDID.substring(i-1,i);
                        if(ischaracters.matcher(s).Matches()){
                            if(i == refinedCDID.length()){
                                tempRevision = refinedCDID.substring(i-2,refinedCDID.length());
                            }else{
                                tempRevision = refinedCDID.substring(i-1,refinedCDID.length());
                            }
                            break;
                        }
                    }
                }*/                            
                //++New Logic
                Matcher m2= revisionPat.matcher(refinedCDID);
                while (m2.find()){
                    if(m2.group(0) != NULL && m2.group(0) != ''){
                        tempRevision = m2.group(0);
                    }
                }
                if((tempRevision == NULL || tempRevision == '' ) && refinedCDID.length()>2){
                    tempRevision = refinedCDID.substring(refinedCDID.length()-2,refinedCDID.length());
                }
                system.debug('###tempRevision ###'+tempRevision );
                //-- New Logic
                //----------------------------------------------------------------------------
                
                if(!mapCustIdInfo.get(refinedCDID).RevNumber.contains('; '+tempRevision+'; ') && tempRevision !=''){
                    mapCustIdInfo.get(refinedCDID).RevNumber += tempRevision +'; ';
                }
                
            }
             
        }
        
         
        lstCertificateWrapper.addAll(mapCustIdInfo.Values());
        
        //Inserting the Parent Record
        ROS_DisposalCertificate__c disposalRecord = new ROS_DisposalCertificate__c();
        disposalRecord.Account__c = reticleRec.Account__c;
        if(reticleRec.ROS_Cycle__c != NULL){
            disposalRecord.ROS_Cycle__c = reticleRec.ROS_Cycle__c;
        }
        insert disposalRecord;
        
        lstAttachments.clear();
        createFile(lstCertificateWrapper,disposalRecord.Id);
        insert lstAttachments;
        
        return new PageReference('/apex/ROSVF_DisposalZipExport?disposalId='+disposalRecord.Id);
    }
    
    public class CertificateWrapper{
        public String  refinedCDID{get;set;}
        public String  PartNumber{get;set;}
        public String  RevNumber{get;set;}
        public Integer NoOfMasks{get;set;}
        public String  MaskMaterial{get;set;}       
    }

    public void createFile(List<CertificateWrapper> lstCertificateWrapper, Id disposalRecordId){
        try{
            for(CertificateWrapper cRec: lstCertificateWrapper){
                String filename = 'DeviceID_'+cRec.refinedCDID.replace('*','')+'.doc';
                
                PageReference P = Page.ROSVF_DisposalCertificateFormat; 
                P.getparameters().put('cdid',cRec.refinedCDID.substring(0,cRec.refinedCDID.length()));    //DBiswal
                P.getparameters().put('part',cRec.PartNumber.substring(1,cRec.PartNumber.length()));
                P.getparameters().put('rev',cRec.RevNumber.substring(1,cRec.RevNumber.length()));
                P.getparameters().put('count',string.valueOf(cRec.NoOfMasks));
                P.getparameters().put('mask',cRec.MaskMaterial.substring(1,cRec.MaskMaterial.length()));
                
                blob body;
                if(!Test.isRunningTest()){
                    body = P.getContent();
                }else{
                    body = blob.valueOf('test');
                }
                attachment doc = new attachment();
                doc.body = body;
                doc.Name = filename;
                doc.ParentId = disposalRecordId;
                doc.isPrivate = false;
                lstAttachments.add(doc);
            }
        }catch(exception ex){   
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
        }    
    }
    
    public Pagereference returnToReticleSearch(){    
        pagereference BacktoReticleSearch=page.ROSVF_SearchReticlesGFForm;
        BacktoReticleSearch.setRedirect(true); 
        return BacktoReticleSearch;  
    }
    
}