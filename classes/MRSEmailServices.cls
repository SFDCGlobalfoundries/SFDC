/*
Type Name: MRSEmailServices
Author: Cognizant 
Created Date: 23-April-2014
Reason: This class is used for email service.
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:21/12/2014- Modified for Email Template Phase-II
??..
??..
*/
global class MRSEmailServices implements Messaging.InboundEmailHandler {
    public Boolean frameMockupFlag=false;
    public Boolean gdsoutFlag=false;
    public Boolean mebesFlag = false;
    String plainTextBody = '';
    String emailSentTime = '';
    String emailSubject = '';
    String senderName='';
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope){
        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        plainTextBody = email.plainTextBody;
        String subject = email.subject;
        String htmlBody = email.htmlBody;
        String fromname = email.fromname;
        String fromemail = email.fromaddress;
        String maskSetTitle;
        String ptrf;
        String chip;
        String layer;
        String maskLayer;
        String[] maskLayerArray;
        senderName = fromemail;
        if(!Test.isRunningTest()){
            for(Messaging.InboundEmail.Header h : email.headers){
                if(h.name == 'Date'){
                    emailSentTime = h.value;
                }
                if(h.name == 'Subject'){
                    emailSubject = h.value;
                }
            }
        }
        else {
            emailSentTime = 'Thu, 23 Apr 2015 09:09:49 +0000 GMT';
            emailSubject = 'RE: Sandbox: Task: Device MPW741';
        }
        List<User> userObject =[SELECT FirstName,LastName,AccountId,Id FROM User WHERE Email=:fromemail AND IsActive=true];
        if(userObject != null && userObject.size() > 0){
           senderName = userObject[0].FirstName+' '+userObject[0].LastName;
        }
        if(plainTextBody.length()!=0){
          if(!subject.containsIgnoreCase('Reminder Notification')){
              system.debug('plain::'+plainTextBody );
              String approvarId= plainTextBody.substringBetween('Approval Id :','#');
              if(approvarId != null){
                approvarId = approvarId.trim();
                if(approvarId.contains('>')){
                    approvarId = approvarId.substringAfter('>');
                    approvarId = approvarId.trim();
                }
              }
              system.debug('Approval Id:::'+approvarId);
              String b64Decrypted;
              if(!Test.isRunningTest()){
                b64Decrypted = decryptCode(approvarId);
              }
              else {
                b64Decrypted = approvarId;
              }
              Approval_Helper__c appHelper = [SELECT Field_to_Update__c,MRSLCA_Id_to_approve__c,Mask_Set_Title__c,PTRF_Number__c FROM Approval_Helper__c WHERE Id=:b64Decrypted ];
              List<String> mrslcaIdlst = appHelper.MRSLCA_Id_to_approve__c.split(';');
              if(appHelper.Field_to_Update__c.containsIgnoreCase('Frame_Mockup')){
                 if(plainTextBody.trim().startsWithIgnoreCase('Approved') || plainTextBody.trim().startsWithIgnoreCase('Approve')){
                     approveChips(fromemail,appHelper.Field_to_Update__c,'Approve',mrslcaIdlst,appHelper);
                     //delete appHelper ;
                 }else if(plainTextBody.startsWithIgnoreCase('Disapprove') || plainTextBody.startsWithIgnoreCase('Disapproved')){ 
                      approveChips(fromemail,appHelper.Field_to_Update__c,'Disapprove',mrslcaIdlst,appHelper);
                      //delete appHelper ;
                 }else{
                      sendEmailToJobviewer('Cannot approve because keyword Approved/Approve or Disapproved/ Disapprove is not correct',appHelper.PTRF_Number__c,appHelper.Mask_Set_Title__c,fromemail,true);
                 }
              }else if(appHelper.Field_to_Update__c.containsIgnoreCase('GDSOUT_Review')){
                  System.debug('$$$PlainText:::'+plainTextBody);
                 if(plainTextBody.startsWithIgnoreCase('Approved') || plainTextBody.startsWithIgnoreCase('Approve')){
                      approveChips(fromemail,appHelper.Field_to_Update__c,'Approve',mrslcaIdlst,appHelper);
                      //delete appHelper ;
                  }else{
                      sendEmailToJobviewer('Cannot approve because keyword Approved/Approve or Disapproved/ Disapprove is not correct',appHelper.PTRF_Number__c,appHelper.Mask_Set_Title__c,fromemail,true);
                  }
              }else if(appHelper.Field_to_Update__c.containsIgnoreCase('MEBES')){
                  if(plainTextBody.startsWithIgnoreCase('Approved') || plainTextBody.startsWithIgnoreCase('Approve')){
                      approveChips(fromemail,appHelper.Field_to_Update__c,'Approve',mrslcaIdlst,appHelper);
                      //delete appHelper ;
                  }else{
                      sendEmailToJobviewer('Cannot approve because keyword Approved/Approve or Disapproved/ Disapprove is not correct',appHelper.PTRF_Number__c,appHelper.Mask_Set_Title__c,fromemail,true);
                  }
              }
               /*if(plainTextBody.containsIgnoreCase('frame mockup'))
               {
                 Boolean customerOrFoundry;
                  if(plainTextBody.startsWithIgnoreCase('Approved') || plainTextBody.startsWithIgnoreCase('Approve')){
                          frameMockupFlag = true;
                          
                          maskSetTitle = plainTextBody.substringBetween('Mask Set Title:','PTRF Number:');
                          if(maskSetTitle.contains('>'))
                          {
                              maskSetTitle = maskSetTitle.substringBefore('>');
                          }
                          if(plainTextBody.substringBetween('PTRF Number:','___')!=null){
                              ptrf = plainTextBody.substringBetween('PTRF Number:','___');
                          }else if(plainTextBody.substringBetween('Number:','\n')!=null){
                              ptrf = plainTextBody.substringBetween('Number:','\n'); 
                          }
                          if(ptrf.contains('>'))
                          {
                              ptrf  = ptrf.substringBefore('>');
                          }
                          if(plainTextBody.substringBetween('type=','&') != null && plainTextBody.substringBetween('type=','&').toUpperCase().trim()  == 'CUSTOMER'){
                            customerOrFoundry = true;
                          }else{
                            customerOrFoundry = false;
                          }
                             approveChips(plainTextBody,fromemail,ptrf,maskSetTitle,null,null,null,'Frame Mockup','Approve',null,subject,customerOrFoundry,'');
                   }
                   else if(plainTextBody.startsWithIgnoreCase('Disapprove') || plainTextBody.startsWithIgnoreCase('Disapproved')){
                      frameMockupFlag = true;
                      
                      maskSetTitle = plainTextBody.substringBetween('Mask Set Title:','PTRF Number:');
                      if(maskSetTitle.contains('>'))
                      {
                          maskSetTitle = maskSetTitle.substringBefore('>');
                      }
                      
                      System.debug('maskSetTitle:::'+maskSetTitle);
                       if(plainTextBody.substringBetween('PTRF Number:','___')!=null){
                          ptrf = plainTextBody.substringBetween('PTRF Number:','___');
                      }else if(plainTextBody.substringBetween('Number:','\n')!=null){
                          ptrf = plainTextBody.substringBetween('Number:','\n'); 
                      }
                      if(ptrf.contains('>'))
                      {
                          ptrf  = ptrf.substringBefore('>');
                      }
                      if(plainTextBody.substringBetween('type=','&') != null && plainTextBody.substringBetween('type=','&').toUpperCase().trim()  == 'CUSTOMER'){
                        customerOrFoundry = true;
                      }else{
                        customerOrFoundry = false;
                      }
                          approveChips(plainTextBody,fromemail,ptrf,maskSetTitle,null,null,null,'Frame Mockup','Disapprove',null,subject,customerOrFoundry,'');
                    }else{
                        sendEmailToJobviewer('Cannot approve because keyword Approved/Approve or Disapproved/ Disapprove is not correct',fromemail,true);
                    }
                   
                }
                else if(plainTextBody.containsIgnoreCase('GDSOUT')){
                    Boolean customerOrFoundry;
                    if(plainTextBody.startsWithIgnoreCase('Approved') || plainTextBody.startsWithIgnoreCase('Approve')){
                      
                      gdsoutFlag = true;
                      maskSetTitle =plainTextBody.substringBetween('Mask Set Title:','Mask Layer:');
                      if(maskSetTitle.contains('>'))
                      {
                        maskSetTitle = maskSetTitle.substringBefore('>');
                      }
                      maskLayer = plainTextBody.substringBetween('Mask Layer:','PTRF Number:');
                      if(maskLayer.contains('>'))
                      {
                          maskLayer = maskLayer.substringBefore('>');
                      }
                      if(plainTextBody.substringBetween('PTRF Number:','___')!=null){
                          ptrf = plainTextBody.substringBetween('PTRF Number:','___');
                      }else if(plainTextBody.substringBetween('Number:','\n')!=null){
                          ptrf = plainTextBody.substringBetween('Number:','\n'); 
                      }
                      if(ptrf.contains('>'))
                      {
                          String ptrfDuplicate;
                         ptrfDuplicate= ptrf.substringAfter('>');
                          if(ptrfDuplicate.trim() == '' || ptrfDuplicate  == null)
                          {
                               ptrfDuplicate= ptrf.substringBefore('>');
                          }
                          ptrf = ptrfDuplicate;
                      }
                       if(plainTextBody.substringBetween('type=','&') != null && plainTextBody.substringBetween('type=','&').toUpperCase().trim()  == 'CUSTOMER'){
                        customerOrFoundry = true;
                        }else{
                          customerOrFoundry = false;
                        }
                      
                           approveChips(plainTextBody,fromemail,ptrf,maskSetTitle,null,null,null,'GDSOUT','Approve',null,subject,customerOrFoundry,'');
                   }else{
                      sendEmailToJobviewer('Cannot approve because keyword Approved/Approve or Disapproved/ Disapprove is not correct',fromemail,true);
                   }
                   
                }
               else if( plainTextBody.containsIgnoreCase('MEBES')){
                       String mailBody;
                       Boolean customerOrFoundry;
                    if(plainTextBody.startsWithIgnoreCase('Approved') || plainTextBody.startsWithIgnoreCase('Approve')){
                       mebesFlag = true;
                          maskSetTitle =plainTextBody.substringBetween('Mask Set Title:','Mask Layer:');
                          if(maskSetTitle.contains('>'))
                          {
                            maskSetTitle = maskSetTitle.substringBefore('>');
                          }
                          maskLayer = plainTextBody.substringBetween('Mask Layer:','Chip Name:');
                         if(maskLayer.contains('>'))
                          {
                              maskLayer = maskLayer.substringBefore('>');
                          }
                          system.debug('plainbody$$$'+plainTextBody);
                          String chipName = plainTextBody.substringBetween('Chip Name:','PTRF Number:');
                          system.debug('$$$Chip Name$$$$'+chipName);
                          if(chipName.contains('>')){
                              chipName = chipName.substringBefore('>');
                          }
                          Set<String> chipNameSt = new Set<String>();
                          if(chipName.contains(',')){
                              String[] chipArray = chipName.split(',');
                              for(String chipNameObject : chipArray){
                                  chipNameSt.add(chipNameObject.trim());
                              }
                          }else{
                              chipNameSt.add(chipName.trim());
                          }
                          String maskLayerName='';
                          String maskRev='';
                          String romCode='';
                          maskLayer = maskLayer.trim();
                          Set<String> maskLayerNameSt = new Set<String>();
                          Set<String> maskRevSt = new Set<String>();
                          Set<String> romCodeSt = new Set<String>();
                          if(maskLayer.contains(',')){
                              maskLayerArray = maskLayer.split(',');
                              for(String maskLayerObj : maskLayerArray){
                                  
                                  String maskLayerTrimed = maskLayerObj.trim();
                                  if(maskLayerTrimed.contains('(')){
                                      romCodeSt.add(maskLayerTrimed.substringBetween('(',')'));
                                  }else{
                                      romCodeSt.add('null');
                                      romCodeSt.add('NULL');
                                      romCodeSt.add('');
                                      romCodeSt.add('####');
                                  }
                                  String maskLayerNameMaskRev;
                                  if(maskLayer.containsAny('(')){
                                      maskLayerNameMaskRev = maskLayerTrimed.substringBefore('(');
                                  }else{
                                      maskLayerNameMaskRev = maskLayerTrimed;
                                  }
                                  Integer length = maskLayerNameMaskRev.length();
                                  maskRevSt.add(maskLayerNameMaskRev.substring(length-2,length));
                                  maskLayerNameSt.add(maskLayerNameMaskRev.substring(0,length-2));
                              }
                          }else{
                              String maskLayerNameMaskRev;
                              if(maskLayer.containsAny('(')){
                                  maskLayerNameMaskRev = maskLayer.substringBefore('(');
                              }else{
                                  maskLayerNameMaskRev = maskLayer;
                              }
                              Integer length = maskLayerNameMaskRev.length();
                              
                             maskLayerNameSt.add(maskLayerNameMaskRev.substring(0,length-2));
                             maskRevSt.add(maskLayerNameMaskRev.substring(length-2,length));
                              if(maskLayer.containsAny('(')){
                                  romCodeSt.add(maskLayer.substringBetween('(',')'));
                              }else{
                                  romCodeSt.add('null');
                                  romCodeSt.add('NULL');
                                  romCodeSt.add('');
                              }
                          }
                          if(plainTextBody.substringBetween('PTRF Number:','___')!=null){
                              ptrf = plainTextBody.substringBetween('PTRF Number:','___');
                          }else if(plainTextBody.substringBetween('Number:','\n')!=null){
                              ptrf = plainTextBody.substringBetween('Number:','\n'); 
                          }
                          system.debug('ptrf : '+ptrf);
                          if(ptrf.contains('>'))
                          {
                              String ptrfDuplicate;
                              ptrfDuplicate= ptrf.substringAfter('>');
                              System.debug(':::::::ptrfDuplicate :::'+ptrfDuplicate );
                              if(ptrfDuplicate.trim() == '' || ptrfDuplicate  == null)
                              {
                                  System.debug(':::::::ptrfDuplicate :111::'+ptrfDuplicate );
                                   ptrfDuplicate= ptrf.substringBefore('>');
                              }
                              ptrf = ptrfDuplicate;
                          }
                          mailBody = plainTextBody;
                           String groupName ='';
                           //system.debug('$$$entershere$$$'+subject.substringBetween('Gating','MEBES') );
                        if((subject.substringBetween('Gating','MEBES') != null && subject.substringBetween('Gating','MEBES').toUpperCase().trim()  == 'CUSTOMER')
                           || (subject.substringBetween('gating','MEBES') != null && subject.substringBetween('gating','MEBES').toUpperCase().trim()  == 'CUSTOMER')){
                          customerOrFoundry = true;
                          groupName ='Customer';
                        }else if((subject.substringBetween('Gating','MEBES') != null && subject.substringBetween('Gating','MEBES').toUpperCase().trim()  == 'FOUNDRY')
                           || (subject.substringBetween('gating','MEBES') != null && subject.substringBetween('gating','MEBES').toUpperCase().trim()  == 'FOUNDRY')){
                          customerOrFoundry = false;
                          groupName ='Foundry';
                        }else if((subject.substringBetween('Gating','MEBES') != null && subject.substringBetween('Gating','MEBES').toUpperCase().trim().containsIgnoreCase('TAPEOUT CENTER'))
                           || (subject.substringBetween('gating','MEBES') != null && subject.substringBetween('gating','MEBES').toUpperCase().trim().containsIgnoreCase('TAPEOUT CENTER'))){
                          groupName ='TapeoutCentre';
                        }else if((subject.substringBetween('Gating','MEBES') != null && subject.substringBetween('Gating','MEBES').toUpperCase().trim().containsIgnoreCase('TAPEOUT APPLICATION'))
                               || (subject.substringBetween('gating','MEBES') != null && subject.substringBetween('gating','MEBES').toUpperCase().trim().containsIgnoreCase('TAPEOUT APPLICATION'))){
                          groupName ='TapeoutApp';
                          system.debug('$$$$groupName $$$'+groupName );
                        }else if((subject.substringBetween('Gating','MEBES') != null && subject.substringBetween('Gating','MEBES').toUpperCase().trim().containsIgnoreCase('GLOBALSHUTTLE'))
                             || (subject.substringBetween('gating','MEBES') != null && subject.substringBetween('gating','MEBES').toUpperCase().trim().containsIgnoreCase('GLOBALSHUTTLE'))){
                          groupName ='GlobalShuttle';
                        }else if((subject.substringBetween('Gating','MEBES') != null && subject.substringBetween('Gating','MEBES').toUpperCase().trim().containsIgnoreCase('MDP'))
                           || (subject.substringBetween('gating','MEBES') != null && subject.substringBetween('gating','MEBES').toUpperCase().trim().containsIgnoreCase('MDP'))){
                          groupName ='MDP';
                        }else if((subject.substringBetween('Gating','MEBES') != null && subject.substringBetween('Gating','MEBES').toUpperCase().trim().containsIgnoreCase('TDTI-MPW'))
                             || (subject.substringBetween('gating','MEBES') != null && subject.substringBetween('gating','MEBES').toUpperCase().trim().containsIgnoreCase('TDTI-MPW'))){
                          groupName ='MPWTDTI';
                        }
                         approveChips(mailBody,fromemail,ptrf,maskSetTitle,maskLayerNameSt,maskRevSt,romCodeSt,'MEBES','Approve',chipNameSt,subject,customerOrFoundry,groupName);
                          
                    }else{
                        sendEmailToJobviewer('Cannot approve because keyword Approved/Approve or Disapproved/ Disapprove is not correct',fromemail,true);
                    }
                   
               }*/
             }else{
               Boolean isFrameMockup = false;
               Boolean customerOrFoundry = false;
               if(plainTextBody.containsIgnoreCase('frame mockup'))
               {
                 maskSetTitle = plainTextBody.substringBetween('Mask Set Title:','PTRF Number:');
                    if(maskSetTitle.contains('>'))
                    {
                        maskSetTitle = maskSetTitle.substringBefore('>');
                    }
                    if(plainTextBody.substringBetween('PTRF Number:','___')!=null){
                        ptrf = plainTextBody.substringBetween('PTRF Number:','___');
                    }else if(plainTextBody.substringBetween('Number:','\n')!=null){
                        ptrf = plainTextBody.substringBetween('Number:','\n'); 
                    }
                    if(ptrf.contains('>'))
                    {
                        ptrf  = ptrf.substringBefore('>');
                    }
                    if(plainTextBody.substringBetween('type=','&') != null && plainTextBody.substringBetween('type=','&').toUpperCase().trim()  == 'CUSTOMER'){
                      customerOrFoundry = true;
                    }else{
                      customerOrFoundry = false;
                    }
                 if(plainTextBody.startsWithIgnoreCase('Approved') || plainTextBody.startsWithIgnoreCase('Approve')){
                   isFrameMockup = true;
                   approveChipsForReviewerNotification(plainTextBody,fromemail,ptrf,maskSetTitle,'Approve',customerOrFoundry,'');
                 }
                 
                 else if(plainTextBody.startsWithIgnoreCase('Disapprove') || plainTextBody.startsWithIgnoreCase('Disapproved')){
                    isFrameMockup = true;
                   approveChipsForReviewerNotification(plainTextBody,fromemail,ptrf,maskSetTitle,'Disapprove',customerOrFoundry,'');
                 }else{
                    sendEmailToJobviewer('Cannot approve because keyword Approved/Approve or Disapproved/ Disapprove is not correct',ptrf,maskSetTitle,fromemail,true);
                 }
               }else if(plainTextBody.containsIgnoreCase('GDSOUT')){
                 if(plainTextBody.substringBetween('Mask Set Title: ','___')!=null){
                        maskSetTitle = plainTextBody.substringBetween('Mask Set Title: ','___');
                    }else if(plainTextBody.substringBetween('Mask Set Title: ','\n')!=null){
                        maskSetTitle = plainTextBody.substringBetween('Mask Set Title: ','\n'); 
                    }
                    system.debug('$$maskSetTitle$$'+maskSetTitle);
                    ptrf = plainTextBody.substringBetween('PTRF:','Chip Name:');
                    if(ptrf == null || ptrf.trim() == ''){
                      ptrf = plainTextBody.substringBetween('PTRF:','Please');
                    }
                    if(plainTextBody.substringBetween('type=','&') != null && plainTextBody.substringBetween('type=','&').toUpperCase().trim()  == 'CUSTOMER'){
                      customerOrFoundry = true;
                    }else{
                      customerOrFoundry = false;
                    }
                     if(plainTextBody.startsWithIgnoreCase('Approved') || plainTextBody.startsWithIgnoreCase('Approve')){
                        approveChipsForReviewerNotification(plainTextBody,fromemail,ptrf,maskSetTitle,'Approve',customerOrFoundry,'');
                     }else{
                        sendEmailToJobviewer('Cannot approve because keyword Approved/Approve or Disapproved/ Disapprove is not correct',ptrf,maskSetTitle,fromemail,true);
                     }
                 
               }else if(plainTextBody.containsIgnoreCase('MEBES')){
                 String groupName='';
                 if(plainTextBody.substringBetween('Mask Set Title: ','___')!=null){
                        maskSetTitle = plainTextBody.substringBetween('Mask Set Title: ','___');
                    }else if(plainTextBody.substringBetween('Mask Set Title: ','\n')!=null){
                        maskSetTitle = plainTextBody.substringBetween('Mask Set Title: ','\n'); 
                    }
                    ptrf = plainTextBody.substringBetween('PTRF:','Chip Name:');
                    if(ptrf == null || ptrf.trim() == ''){
                      ptrf = plainTextBody.substringBetween('PTRF:','Please');
                    }
                    if(plainTextBody.substringBetween('jobview=','&') != null && plainTextBody.substringBetween('jobview=','&').toUpperCase().trim()  == 'CUSTOMER'){
                      customerOrFoundry = true;
                      groupName ='Customer';
                    }else if(plainTextBody.substringBetween('jobview=','&') != null && plainTextBody.substringBetween('jobview=','&').toUpperCase().trim()  == 'FOUNDRY'){
                      customerOrFoundry = false;
                      groupName ='Foundry';
                    }else if(plainTextBody.substringBetween('jobview=','&') != null && plainTextBody.substringBetween('jobview=','&').toUpperCase().trim()  == 'TAPEOUTCENTRE'){
                      groupName ='TapeoutCentre';
                    }else if(plainTextBody.substringBetween('jobview=','&') != null && plainTextBody.substringBetween('jobview=','&').toUpperCase().trim()  == 'TAPEOUTAPP'){
                      groupName ='TapeoutApp';
                    }else if(plainTextBody.substringBetween('jobview=','&') != null && plainTextBody.substringBetween('jobview=','&').toUpperCase().trim()  == 'GLOBALSHUTTLE'){
                      groupName ='GlobalShuttle';
                    }else if(plainTextBody.substringBetween('jobview=','&') != null && plainTextBody.substringBetween('jobview=','&').toUpperCase().trim()  == 'MDP'){
                      groupName ='MDP';
                    }else if(plainTextBody.substringBetween('jobview=','&') != null && plainTextBody.substringBetween('jobview=','&').toUpperCase().trim()  == 'MPWTDTI'){
                      groupName ='MPWTDTI';
                    }
                     if(plainTextBody.startsWithIgnoreCase('Approved') || plainTextBody.startsWithIgnoreCase('Approve')){
                        approveChipsForReviewerNotification(plainTextBody,fromemail,ptrf,maskSetTitle,'Approve',customerOrFoundry,groupName);
                     }else{
                        sendEmailToJobviewer('Cannot approve because keyword Approved/Approve or Disapproved/ Disapprove is not correct',ptrf,maskSetTitle,fromemail,true);
                     }
               }
             }
          }
       
        result.success = true;
        return result;
    }
  /**
     @Method: approveChips
     @param: null
     @return : void
     @descrption: This method is used to update MRS_Layer_Chip_Association__c records depending upon conditions
 **/   
    public void approveChips(String fromemail,String page,String keyWord,List<String> mrslcaIdlst,Approval_Helper__c appHelper) {
              List<User> userObj =[SELECT FirstName,LastName,AccountId,Id FROM User WHERE Email=:fromemail AND IsActive=true];
              
              Boolean jobViewer = false;
              Set<String> groupNameSt = new Set<String>();
              String mebesRealease;
              Boolean isEmailSent = false;
              String fieldToUpdate;
              String selectedCustomer;
              Boolean approveOrDisapprove;
              Boolean isUpdated = false;
              Boolean isNotApprover = false;
              
              Set<Id> layerIdSt = new Set<Id>();
              List<MRS_Layer_Chip_Association__c> mrsLayerChipAssociationlst = [SELECT PTRF__c,PTRF__r.MaskSetTitle__r.Name,Layer__c,PTRF__r.Name FROM MRS_Layer_Chip_Association__c WHERE Id IN:mrslcaIdlst];
              Id ptrfId ;
              String maskSetTitle ='';
              String ptrf = '';
              for(MRS_Layer_Chip_Association__c mrsLayerChipObject : mrsLayerChipAssociationlst){
                  if(!layerIdSt.contains(mrsLayerChipObject.Layer__c))
                  {
                     ptrfId = mrsLayerChipObject.PTRF__c;
                     layerIdSt.add(mrsLayerChipObject.Layer__c);
                     maskSetTitle = mrsLayerChipObject.PTRF__r.MaskSetTitle__r.Name;
                     ptrf = mrsLayerChipObject.PTRF__r.Name;
                  }
                  
              }
              PTRF__c ptrfObj = [SELECT Id,Customer__c,Name,Status__c,Frame_Tapeout__c,Prime_Tapeout__c FROM PTRF__c  WHERE Id = :ptrfId limit 1] ;

              Id ptrfObjid;
              if(ptrfObj != null){
                ptrfObjid = ptrfObj.Id;
              }
              if(page.containsIgnoreCase('MEBES'))
                 {
                     Set<Id> groupIdlst = new Set<Id>();
                    
                     List<GroupMember> groupMemeber = [SELECT GroupId,UserOrGroupId FROM GroupMember WHERE UserOrGroupId IN:userObj];
                     if(groupMemeber != null && groupMemeber.size()>0)
                     {
                         for(GroupMember groupMemberObj : groupMemeber )
                         {
                             groupIdlst.add(groupMemberObj.GroupId);
                         }
                         List<Group> grouplst =[SELECT DeveloperName,Id FROM Group WHERE Id IN :groupIdlst];
                         for(Group groupObj : grouplst)
                         {
                             if(groupObj.DeveloperName == 'Swift_Tapeout_Application')
                             {
                                 mebesRealease ='Tapeout_Application';
                                 groupNameSt.add('Tapeout_Application');
                             }else if(groupObj.DeveloperName == 'Swift_Tapeout_Centre')
                             {
                                 mebesRealease ='Tapeout_Centre';
                                 groupNameSt.add('Tapeout_Centre');
                             }else if(groupObj.DeveloperName == 'Swift_TDTI_MPW')
                             {
                                 mebesRealease  ='TDTI_MPW';
                                 groupNameSt.add('TDTI_MPW');
                             }else if(groupObj.DeveloperName == 'Swift_MDP')
                             {
                                 mebesRealease  = 'MDP';
                                 groupNameSt.add('MDP');
                             }else if(groupObj.DeveloperName == 'Swift_GlobalShuttle')
                             {
                                 mebesRealease  = 'GlobalShuttle';
                                 groupNameSt.add('GlobalShuttle');
                             }
                          
                         }
                     }
                 }
          
          String   ptrfJobView ;
         
              ptrfJobView = ' SELECT Jobview__c,Jobview_Type__c,PTRF__c FROM PTRF_JobViewer_Info__c\n'+
                                     ' WHERE PTRF__c = :ptrfObjid';
             if(page != null && page.containsIgnoreCase('Customer')){
               ptrfJobView = ptrfJobView + ' AND (Jobview__c=\'Customer\')';
             }else if(page != null &&  page.containsIgnoreCase('Foundry')){
               ptrfJobView = ptrfJobView + ' AND (Jobview__c=\'Foundry\')';
             }
              if(page.containsIgnoreCase('Frame_Mockup')) {
                  
              ptrfJobView = ptrfJobView + ' AND Jobview_Type__c INCLUDES (\'Frame Mockup\')';
              }
              if(page.containsIgnoreCase('GDSOUT')){
                  ptrfJobView = ptrfJobView + ' AND Jobview_Type__c INCLUDES (\'Prime GDSOUT Review\')';
              }
              if(page.containsIgnoreCase('MEBES')){
                  ptrfJobView = ptrfJobView + ' AND Jobview_Type__c INCLUDES (\'MEBES Jobview\')';
              }
              ptrfJobView = ptrfJobView + ' AND User__c IN:userObj ';
              List<PTRF_JobViewer_Info__c> lstPTRFJobviewInfo = Database.Query(ptrfJobView);
              if(lstPTRFJobviewInfo != null && lstPTRFJobviewInfo.size()>0)
              {
                  jobViewer = true;
              }
              List<String> teamRole =  Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');     
              List<Account_Team_Proxy__c> lstAccountTeamProxy = [SELECT Account__c,User__c,User_Email__c FROM Account_Team_Proxy__c WHERE Account__c =:ptrfObj.Customer__c AND User__c IN:userObj AND Team_Role__c IN:teamRole];
              if(lstAccountTeamProxy != null && lstAccountTeamProxy.size() > 0){
                 if(page!= null && page.containsIgnoreCase('Customer')){
                    jobViewer = true;
                 }
              }     
              system.debug('Enter JobViewer'+jobViewer );        
                    List<MRS_Layer_Chip_Association__c> mrsLayerChipList;
                    List<MRS_Layer_Chip_Association__c> mrsLayerChipListToUpdate = new List<MRS_Layer_Chip_Association__c>();
                    List<String> plainBodyArray = new List<String>();
                    //plainBodyArray.addAll(plainTextBody.split('Chip Name:'));
                   // system.debug('$$plainBodyArray$$'+plainBodyArray);
                    if(page.containsIgnoreCase('Frame_Mockup')) {
                        set<String> setOfLCStatus =  new set<String>{'Cancel','Void','Hold'}; 
                        set<String> setOfStatus =  new set<String>{'N.A.','Released','Hold','Shipped'};
                        mrsLayerChipList = [SELECT Id,Customer_Frame_Mockup__c,Foundry_Frame_Mockup__c,PTRF__r.Name,PTRF__r.MaskSetTitle__r.Name,Chip__r.Name,PTRF__c,Customer_Name__c,PTRF__r.Tech_Geo__c,
                                                   layer__r.MRS__r.Mask_Set_Title__r.Name,ROM_Code__c,Layer__r.ROM_Code__c,Layer__r.Mask_Layer_Rev__c,Layer__r.Name,LastModifiedById
                                            FROM MRS_Layer_Chip_Association__c
                                            WHERE /*PTRF__r.Name=:ptrf.trim()
                                            AND Mask_Set_Title_Name__c=:maskSetTitle.trim()
                                            AND Chip__r.Name ='Frame' 
                                            AND Layer__r.Layer_Status__c NOT IN:setOfStatus
                                            AND Layer_Chip_Status__c NOT IN:setOfLCStatus*/
                                                 Id IN:mrslcaIdlst
                                                for update];
                        //mrsLayerChipListToUpdate.addAll(mrsLayerChipList);
                        for(MRS_Layer_Chip_Association__c msrLayerChipObj : mrsLayerChipList){
                            if(Test.isRunningTest()){
                                //msrLayerChipObj.Customer_Frame_Mockup__c = 'Ready';
                                //msrLayerChipObj.Foundry_Frame_Mockup__c = 'Ready';
                            }
                            mrsLayerChipListToUpdate.add(msrLayerChipObj);
                        }
                    }
                    if(page.containsIgnoreCase('GDSOUT')){
                        set<String> setOfLCStatus =  new set<String>{'Cancel','Void','Hold'}; 
                        set<String> setOfStatus =  new set<String>{'N.A.','Released','Hold','Shipped'};
                            mrsLayerChipList = [SELECT Id,Customer_GDSOUT_Review__c,Foundry_GDSOUT_Review__c,PTRF__r.Name,PTRF__r.MaskSetTitle__r.Name,Chip__r.Name,PTRF__c,Customer_Name__c,PTRF__r.Tech_Geo__c,
                                                layer__r.MRS__r.Mask_Set_Title__r.Name,ROM_Code__c,Layer__r.ROM_Code__c,Layer__r.Mask_Layer_Rev__c,Layer__r.Name,LastModifiedById
                                                FROM MRS_Layer_Chip_Association__c
                                                WHERE /*PTRF__r.Name=:ptrf.trim()
                                                AND Mask_Set_Title_Name__c=:maskSetTitle.trim()
                                                AND Chip__r.Name !='Frame' 
                                                AND Layer__r.Layer_Status__c NOT IN:setOfStatus
                                                AND Layer_Chip_Status__c NOT IN:setOfLCStatus*/
                                                Id IN:mrslcaIdlst
                                                for update
                                                ];
                       Set<Id> stIds = new Set<Id>();
                        for(MRS_Layer_Chip_Association__c msrLayerChipObj : mrsLayerChipList){
                            if(Test.isRunningTest()){
                                //msrLayerChipObj.Customer_GDSOUT_Review__c = 'Ready';
                                //msrLayerChipObj.Foundry_GDSOUT_Review__c = 'Ready';
                            }
                            mrsLayerChipListToUpdate.add(msrLayerChipObj);
                            stIds.add(msrLayerChipObj.Id); 
                        }
                    }

                    if(page.containsIgnoreCase('MEBES')){
                        set<String> setOfLCStatus =  new set<String>{'Cancel','Void','Hold'}; 
                        set<String> setOfStatus =  new set<String>{'N.A.','Released','Hold','Shipped'};
                        String romCodeBlank;
                        List<MRS_Layer_Chip_Association__c> mrsLayerChipListDuplicate = new List<MRS_Layer_Chip_Association__c>();
                        List<MRS_Layer_Chip_Association__c> mrsLayerChipListForCombination = [SELECT Id,Customer_MEBES_Jobview__c,Foundry_MEBES_Jobview__c,
                                                   Tapeout_Applications_MEBES_Jobview__c,Tapeout_Centre_MEBES_Jobview__c,
                                                   Tapeout_Applications_MEBES_Jobview_Date__c,Tapeout_Centre_MEBES_Jobview_Date__c,
                                                   TDTI_MPW_MEBES_Jobview__c,TDTI_MPW_MEBES_Date__c,MDP_MEBES_Jobview__c,
                                                   MDP_MEBES_Jobview_Date__c,Tech_Geo__c,Mask_Set_Title_Id__c,
                                                   GlobalShuttle_MEBES_Jobview__c,GlobalShuttle_MEBES_Jobview_Date__c,
                                                   PTRF__r.Name,PTRF__r.MaskSetTitle__r.Name,Chip__r.Name,Layer__r.Name,Layer__r.Mask_Layer_Rev__c,Layer__r.ROM_Code__c,PTRF__c,Customer_Name__c,PTRF__r.Tech_Geo__c,
                                                   layer__r.MRS__r.Mask_Set_Title__r.Name,ROM_Code__c,LastModifiedById
                                            FROM MRS_Layer_Chip_Association__c
                                            WHERE /*PTRF__r.Name=:ptrf.trim()
                                            AND Mask_Set_Title_Name__c=:maskSetTitle.trim()*/
                                            //AND Layer__r.Name IN :maskLayer
                                           // AND Layer__r.Mask_Layer_Rev__c IN:maskRev
                                           // AND Layer__r.ROM_Code__c IN:romCode
                                            //AND Chip__r.Name IN:chipNameSt 
                                           /* AND Layer__r.Layer_Status__c NOT IN:setOfStatus
                                            AND Layer_Chip_Status__c NOT IN:setOfLCStatus*/
                                            Id IN:mrslcaIdlst
                                            for update];
                       mrsLayerChipList = new List<MRS_Layer_Chip_Association__c>();
                      mrsLayerChipList.clear();
                      Set<Id> stIds = new Set<Id>();
                       for(MRS_Layer_Chip_Association__c mrsLayerChipObject : mrsLayerChipListForCombination) {
                          //for(String chipLayerCombination : plainBodyArray){
                          
                               //  if(chipLayerCombination.containsIgnoreCase(mrsLayerChipObject.Chip__r.Name)){
                                    //  List<String> layersArray = new List<String>();
                                     // system.debug('$$$chipLayerCombination$$'+chipLayerCombination);
                                     // layersArray.addAll(chipLayerCombination.substringAfter('layer(s)').split(','));
                                     // system.debug('$$layersArray$'+layersArray);
                                     // for(String layerName : layersArray){
                                        //  if(layerName.containsIgnoreCase(mrsLayerChipObject.Layer__r.Name) && layerName.containsIgnoreCase(mrsLayerChipObject.Layer__r.Mask_Layer_Rev__c)){
                                             if(!stIds.contains(mrsLayerChipObject.Id)){
                                                mrsLayerChipList.add(mrsLayerChipObject);
                                                stIds.add(mrsLayerChipObject.Id);
                                             }
                                             //break;
                                         // }
                                      // }
                                      // break;
                              // }
                            //}
                       } 
                       system.debug('list of mrsLayerChipList'+mrsLayerChipList.size());                                
                       /** Code added for Duplicate Chips/Frames **/
                       set<String> setUniqueCombo = new set<String>();
                       set<String> setMaskLayerNums = new set<String>();
                       set<String> setMaskRevs = new set<String>();
                       set<String> setTechGeos = new set<String>();
                       set<String> setChipNames = new set<String>();
                       String maskSetTitleId = '';
                       map<String,Integer> mapUniqueLayerChips = new map<String,Integer>();
                       for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipList){
                            setMaskLayerNums.add(mrsLayerChipObj.Layer__r.Name);
                            maskSetTitleId = mrsLayerChipObj.Mask_Set_Title_Id__c;
                            if(mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c!=null){
                                setMaskRevs.add(mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c);    
                            }
                            if(mrsLayerChipObj.PTRF__r.Tech_Geo__c!=null){
                                setTechGeos.add(mrsLayerChipObj.PTRF__r.Tech_Geo__c);   
                            }
                            if(mrsLayerChipObj.Chip__r.Name!=null){
                                setChipNames.add(mrsLayerChipObj.Chip__r.Name);   
                            }
                            String uniqueCombo;
                            if(mrsLayerChipObj.Layer__r.ROM_Code__c!=null && mrsLayerChipObj.Layer__r.ROM_Code__c!='####' && mrsLayerChipObj.Layer__r.ROM_Code__c.toUppercase()!='NULL'){
                                uniqueCombo = maskSetTitleId + mrsLayerChipObj.Layer__r.Name +mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+mrsLayerChipObj.Layer__r.ROM_Code__c+mrsLayerChipObj.Chip__r.Name+mrsLayerChipObj.PTRF__r.Tech_Geo__c;
                            }else{
                                uniqueCombo = maskSetTitleId + mrsLayerChipObj.Layer__r.Name +mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+mrsLayerChipObj.Chip__r.Name+mrsLayerChipObj.PTRF__r.Tech_Geo__c;   
                            }
                            setUniqueCombo.add(uniqueCombo);
                        }
                       for(MRS_Layer_Chip_Association__c mrsLayerChipObj:[select Id,Layer__r.Name,PTRF__r.MaskSetTitle__r.Name,Chip__r.Name,Mask_Set_Title_Id__c, 
                       Layer__r.Mask_Layer_Rev__c,Layer__r.ROM_Code__c,Tech_Geo__c,Layer_Chip_Status__c,PTRF__r.Tech_Geo__c from MRS_Layer_Chip_Association__c where
                       Layer_Chip_Status__c NOT IN ('Hold','Cancel','Void') and /*Layer__r.Mask_Layer_Rev__c IN:setMaskRevs and Chip__r.Name IN:setChipNames
                       and Layer__r.Name IN:setMaskLayerNums and PTRF__r.Tech_Geo__c IN:setTechGeos AND Mask_Set_Title_Id__c=:maskSetTitleId*/ Layer__c IN:layerIdSt ]){
                            String uniqueCombo;
                            Integer counterUniqueLayerChip;
                            if(mrsLayerChipObj.Layer__r.ROM_Code__c!=null && mrsLayerChipObj.Layer__r.ROM_Code__c!='####' && mrsLayerChipObj.Layer__r.ROM_Code__c.toUppercase()!='NULL'){
                                uniqueCombo = mrsLayerChipObj.Mask_Set_Title_Id__c +mrsLayerChipObj.Layer__r.Name +mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+mrsLayerChipObj.Layer__r.ROM_Code__c+mrsLayerChipObj.Chip__r.Name+mrsLayerChipObj.PTRF__r.Tech_Geo__c;
                            }else{
                                uniqueCombo = mrsLayerChipObj.Mask_Set_Title_Id__c +mrsLayerChipObj.Layer__r.Name +mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+mrsLayerChipObj.Chip__r.Name+mrsLayerChipObj.PTRF__r.Tech_Geo__c;   
                            }
                            if(setUniqueCombo!=null && setUniqueCombo.size()>0 && setUniqueCombo.contains(uniqueCombo)){                                
                                if(mapUniqueLayerChips.containsKey(uniqueCombo)){
                                    counterUniqueLayerChip = mapUniqueLayerChips.get(uniqueCombo);
                                    counterUniqueLayerChip = counterUniqueLayerChip +1;
                                }else{
                                    counterUniqueLayerChip = 1; 
                                }                
                                mapUniqueLayerChips.put(uniqueCombo, counterUniqueLayerChip);                                           
                            }
                       }
                       /** Code added for Duplicate Chips/Frames **/
                       
                       for(MRS_Layer_Chip_Association__c msrLayerChipObj : mrsLayerChipList){
                        String uniqueCombo;
                            if(msrLayerChipObj.Layer__r.ROM_Code__c!=null && msrLayerChipObj.Layer__r.ROM_Code__c!='####' && msrLayerChipObj.Layer__r.ROM_Code__c.toUppercase()!='NULL'){
                                uniqueCombo = msrLayerChipObj.Mask_Set_Title_Id__c +msrLayerChipObj.Layer__r.Name+msrLayerChipObj.Layer__r.Mask_Layer_Rev__c+msrLayerChipObj.Layer__r.ROM_Code__c+msrLayerChipObj.Chip__r.Name+msrLayerChipObj.PTRF__r.Tech_Geo__c;
                            }else{
                                uniqueCombo = msrLayerChipObj.Mask_Set_Title_Id__c +msrLayerChipObj.Layer__r.Name+msrLayerChipObj.Layer__r.Mask_Layer_Rev__c+msrLayerChipObj.Chip__r.Name+msrLayerChipObj.PTRF__r.Tech_Geo__c;    
                            }
                            system.debug('$$$msrLayerChipObj.Chip__r.Name@@'+msrLayerChipObj.Chip__r.Name+'%%%%mapUniqueLayerChips.get(uniqueCombo)%%'+mapUniqueLayerChips.get(uniqueCombo)+'##PAGE##'+page);
                            //Update For Unique Chips
                            if( msrLayerChipObj.Chip__r.Name != 'Frame' && mapUniqueLayerChips.containsKey(uniqueCombo) && (mapUniqueLayerChips.get(uniqueCombo)==1)){
                                mrsLayerChipListToUpdate.add(msrLayerChipObj);
                            //Send Error Message For Duplicate Chips
                            }else if(msrLayerChipObj.Chip__r.Name!='Frame' /*&& plainTextBody.contains(msrLayerChipObj.Chip__r.Name)*/ && mapUniqueLayerChips.containsKey(uniqueCombo) && mapUniqueLayerChips.get(uniqueCombo)>1){
                                mrsLayerChipListDuplicate.add(msrLayerChipObj);              
                            //Update for Unique Frames when User is not part of Tapeout Centre and MDP
                            }else if(msrLayerChipObj.Chip__r.Name=='Frame'  && !page.containsIgnoreCase('Tapeout_Centre') && !page.containsIgnoreCase('MDP') ){
                                mrsLayerChipListToUpdate.add(msrLayerChipObj);                            
                            //Send Error Message For Duplicate Frames when User is part of Tapeout Centre
                            }else if(msrLayerChipObj.Chip__r.Name=='Frame' && page.containsIgnoreCase('Tapeout_Centre') &&  msrLayerChipObj.Tech_Geo__c != null && ((msrLayerChipObj.Tech_Geo__c.contains('UM') && Double.valueOf(msrLayerChipObj.Tech_Geo__c.toUpperCase().substringBefore('UM')) > 0.02)||(!msrLayerChipObj.Tech_Geo__c.contains('UM') && Double.valueOf(msrLayerChipObj.Tech_Geo__c.toUpperCase()) > 0.02))  && mapUniqueLayerChips.containsKey(uniqueCombo) && mapUniqueLayerChips.get(uniqueCombo)>1){
                                mrsLayerChipListDuplicate.add(msrLayerChipObj);
                            //Send Error Message For Duplicate Frames when User is part of MDP     
                            }else if(msrLayerChipObj.Chip__r.Name=='Frame' && page.containsIgnoreCase('MDP') &&  msrLayerChipObj.Tech_Geo__c != null && ((msrLayerChipObj.Tech_Geo__c.contains('UM') && Double.valueOf(msrLayerChipObj.Tech_Geo__c.toUpperCase().substringBefore('UM')) <= 0.02)||(!msrLayerChipObj.Tech_Geo__c.contains('UM') && Double.valueOf(msrLayerChipObj.Tech_Geo__c.toUpperCase()) <= 0.02)) &&  mapUniqueLayerChips.containsKey(uniqueCombo) && mapUniqueLayerChips.get(uniqueCombo)>1){
                                mrsLayerChipListDuplicate.add(msrLayerChipObj);
                            //Update For Unique Frames when User is part of Tapeout Centre or MDP     
                            }else if(msrLayerChipObj.Chip__r.Name=='Frame' && (page.containsIgnoreCase('MDP') || page.containsIgnoreCase('Tapeout_Centre')) && mapUniqueLayerChips.containsKey(uniqueCombo) && mapUniqueLayerChips.get(uniqueCombo)==1){
                                system.debug('$$$msrLayerChipObj.Chip__r.Name@@ iNSIDE::'+msrLayerChipObj.Chip__r.Name+'%%%%mapUniqueLayerChips.get(uniqueCombo)%%'+mapUniqueLayerChips.get(uniqueCombo));
                                mrsLayerChipListToUpdate.add(msrLayerChipObj);     
                            }
                        }
                        if(mrsLayerChipListDuplicate.size()>0){
                            sendEmailToResponderWithError(mrsLayerChipListDuplicate,fromemail,maskSetTitle,ptrf); 
                        }
                    
                    }
                    system.debug('$$size$$$'+mrsLayerChipListToUpdate.size());
                    Notes__c notesObj;
                    List<Notes__c> noteslst = new List<Notes__c>();
                    String body = fromemail+'  disapproved frame mockup through email.';
                    List<MRS_Layer_Chip_Association__c> lstForEmail = new List<MRS_Layer_Chip_Association__c>();
                    if(mrsLayerChipList != null)
                    {
                     if( page != null && page.containsIgnoreCase('Customer')){
                        system.debug('Customer ::::'+page +'::jobViewer'+jobViewer);
                       if(jobViewer){
                         if(page.containsIgnoreCase('Frame_Mockup')){
                           if(keyWord.equalsIgnoreCase('Approve')){
                             for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipListToUpdate)
                                {
                                  if(mrsLayerChipObj.Customer_Frame_Mockup__c == 'Ready'){
                                    if(mrsLayerChipObj.Foundry_Frame_Mockup__c =='Approve' || mrsLayerChipObj.Foundry_Frame_Mockup__c =='N.A.'){
                                         isEmailSent = true;
                                             fieldToUpdate ='CustomerFrameMockup';
                                             selectedCustomer = mrsLayerChipObj.Customer_Name__c;
                                             approveOrDisapprove = true;
                                             
                                    }
                                    isUpdated = true;
                                    mrsLayerChipObj.CustomerFrameMockupApprover__c = userObj.get(0).Id;
                                    mrsLayerChipObj.Customer_Frame_Mockup__c='Approve';
                                    mrsLayerChipObj.Customer_Frame_Mockup_Date__c = System.now();
                                    lstForEmail.add(mrsLayerChipObj);
                                  }
                                }
                           }
                           if(keyWord.equalsIgnoreCase('Disapprove')){
                             for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipListToUpdate)
                                {
                                  if(mrsLayerChipObj.Customer_Frame_Mockup__c == 'Ready'){
                                     isEmailSent = true;
                                       fieldToUpdate ='CustomerFrameMockup';
                                       selectedCustomer = mrsLayerChipObj.Customer_Name__c;
                                       approveOrDisapprove = false;
                                       mrsLayerChipObj.Customer_Frame_Mockup__c='Disapprove';
                                       mrsLayerChipObj.Customer_Frame_Mockup_Date__c = System.now();
                                       if(ptrfObj.Prime_Tapeout__c){
                                         ptrfObj.Frame_Tapeout__c = false;
                                       }else{
                                        ptrfObj.Status__c ='Cancel';
                                       }
                                       isUpdated = true;
                                       mrsLayerChipObj.CustomerFrameMockupApprover__c = userObj.get(0).Id;
                                       notesObj = new Notes__c(Body__c = body,Category__c='Customer Frame Mockup Disapproval',ParentId__c=mrsLayerChipObj.Id);
                                       noteslst.add(notesObj);
                                       lstForEmail.add(mrsLayerChipObj);
                                  }
                              }
                           }
                           
                         }else if(page.containsIgnoreCase('GDSOUT')){
                           if(keyWord.equalsIgnoreCase('Approve')){
                             for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipListToUpdate)
                                {
                                    System.debug('Value:::'+mrsLayerChipObj.Customer_GDSOUT_Review__c);
                                    if(mrsLayerChipObj.Customer_GDSOUT_Review__c == 'Ready'){
                                         if(mrsLayerChipObj.Foundry_GDSOUT_Review__c =='Approve' || mrsLayerChipObj.Foundry_GDSOUT_Review__c =='N.A.'){
                                             isEmailSent = true;
                                             fieldToUpdate ='GDSOUTReview';
                                             approveOrDisapprove = true;
                                             selectedCustomer = mrsLayerChipObj.Customer_Name__c;
                                          }
                                         isUpdated = true;
                                         mrsLayerChipObj.CustomerGDSOUTReviewApprover__c = userObj.get(0).Id;
                                         mrsLayerChipObj.Customer_GDSOUT_Review__c='Approve';
                                         mrsLayerChipObj.Customer_GDSOUT_Review_Date__c = System.now();
                                         lstForEmail.add(mrsLayerChipObj);
                                    }
                                }
                                
                           }
                         }else if(page.containsIgnoreCase('MEBES')){
                           if(keyWord.equalsIgnoreCase('Approve')){
                             for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipListToUpdate)
                                {
                                  if(mrsLayerChipObj.Customer_MEBES_Jobview__c == 'Ready'){
                                        system.debug('$$$Customer_MEBES_Jobview__c $$$' );
                                        mrsLayerChipObj.Customer_MEBES_Jobview__c='Released';
                                        mrsLayerChipObj.Customer_MEBES_Jobview_Date__c= System.now();
                                        isEmailSent = true;
                                        fieldToUpdate ='CustomerMEBES';
                                        selectedCustomer = mrsLayerChipObj.Customer_Name__c;
                                        approveOrDisapprove = true;
                                        lstForEmail.add(mrsLayerChipObj);
                                        isUpdated = true;
                                        mrsLayerChipObj.CustomerMebesJobViewApprover__c = userObj.get(0).Id;
                                        
                                  }
                                   
                                }
                           }
                         }    
                       }else{
                          isNotApprover = true;
                          sendEmailToJobviewer('Cannot approve because '+fromemail+' is not a jobviewer',appHelper.PTRF_Number__c,appHelper.Mask_Set_Title__c,fromemail,false);
                       }
                     }else{
                       if(page != null && page.containsIgnoreCase('Foundry') && jobViewer){
                         if(page.containsIgnoreCase('Frame_Mockup')){
                           if(keyWord.equalsIgnoreCase('Approve')){
                             for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipListToUpdate)
                                {
                                  if(mrsLayerChipObj.Foundry_Frame_Mockup__c == 'Ready'){
                                    if(mrsLayerChipObj.Customer_Frame_Mockup__c =='Approve' || mrsLayerChipObj.Customer_Frame_Mockup__c =='N.A.'){
                                         isEmailSent = true;
                                             fieldToUpdate ='CustomerFrameMockup';
                                             selectedCustomer = mrsLayerChipObj.Customer_Name__c;
                                             approveOrDisapprove = true;
                                    }
                                    mrsLayerChipObj.Foundry_Frame_Mockup__c='Approve';
                                     mrsLayerChipObj.Foundry_Frame_Mockup_Date__c = System.now();
                                     lstForEmail.add(mrsLayerChipObj);
                                     isUpdated = true;
                                     mrsLayerChipObj.FoundryFrameMockupApprover__c = userObj.get(0).Id;
                                  }
                                }
                           }
                           if(keyWord.equalsIgnoreCase('Disapprove')){
                             for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipListToUpdate)
                                {
                                  if(mrsLayerChipObj.Foundry_Frame_Mockup__c == 'Ready'){
                                     isEmailSent = true;
                                       fieldToUpdate ='CustomerFrameMockup';
                                       selectedCustomer = mrsLayerChipObj.Customer_Name__c;
                                       approveOrDisapprove = false;
                                       mrsLayerChipObj.Foundry_Frame_Mockup__c='Disapprove';
                                       mrsLayerChipObj.Foundry_Frame_Mockup_Date__c = System.now();
                                       if(ptrfObj.Prime_Tapeout__c){
                                         ptrfObj.Frame_Tapeout__c = false;
                                       }else{
                                        ptrfObj.Status__c ='Cancel';
                                       }
                                       isUpdated = true;
                                       notesObj = new Notes__c(Body__c = body,Category__c='Foundry Frame Mockup Disapproval',ParentId__c=mrsLayerChipObj.Id);
                                       noteslst.add(notesObj);
                                       lstForEmail.add(mrsLayerChipObj);
                                       mrsLayerChipObj.FoundryFrameMockupApprover__c = userObj.get(0).Id;
                                  }
                              }
                           }
                           
                         }else if(page.containsIgnoreCase('GDSOUT')){
                           if(keyWord.equalsIgnoreCase('Approve')){
                             for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipListToUpdate)
                                {
                                  if(mrsLayerChipObj.Foundry_GDSOUT_Review__c == 'Ready'){
                                  if(mrsLayerChipObj.Customer_GDSOUT_Review__c =='Approve' || mrsLayerChipObj.Customer_GDSOUT_Review__c =='N.A.'){
                                         isEmailSent = true;
                                         fieldToUpdate ='GDSOUTReview';
                                         approveOrDisapprove = true;
                                         selectedCustomer = mrsLayerChipObj.Customer_Name__c;
                                      }
                                     mrsLayerChipObj.Foundry_GDSOUT_Review__c='Approve';
                                     mrsLayerChipObj.Foundry_GDSOUT_Review_Date__c = System.now();
                                     lstForEmail.add(mrsLayerChipObj);
                                     isUpdated = true;
                                     mrsLayerChipObj.FoundryGDSOUTReviewApprover__c = userObj.get(0).Id;
                                  }
                                }
                           }
                         }else if(page.containsIgnoreCase('MEBES')){
                           if(keyWord.equalsIgnoreCase('Approve')){
                             for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipListToUpdate)
                                {
                                 system.debug('$$$ enter into mebes::');
                                  if(mrsLayerChipObj.Foundry_MEBES_Jobview__c == 'Ready'){
                                   mrsLayerChipObj.Foundry_MEBES_Jobview__c='Released';
                                          mrsLayerChipObj.Foundry_MEBES_Jobview_Date__c= System.now();
                                          isEmailSent = true;
                                          fieldToUpdate ='FoundryMEBES';
                                          selectedCustomer = mrsLayerChipObj.Customer_Name__c;
                                          approveOrDisapprove = true;
                                          lstForEmail.add(mrsLayerChipObj);
                                          isUpdated = true;
                                          mrsLayerChipObj.FoundryMebesJobViewApprover__c = userObj.get(0).Id;
                                  }
                                }
                           }
                         }
                       }else if(page!= null && (page.containsIgnoreCase('Customer') || page.containsIgnoreCase('Foundry')) && !jobViewer){
                           isNotApprover = true;
                           sendEmailToJobviewer('Cannot approve because '+fromemail+' is not a jobviewer',appHelper.PTRF_Number__c,appHelper.Mask_Set_Title__c,fromemail,false);
                       }
                     }
                     system.debug('$$groupUser$$$'+page);
                     String reason ;
                     if(!page.containsIgnoreCase('Customer') && !page.containsIgnoreCase('Foundry')){
                       if(keyWord.equalsIgnoreCase('Approve')){
                         
                           for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipListToUpdate)
                            {
                              if(groupNameSt.contains('Tapeout_Application') && page.containsIgnoreCase('Tapeout_Applications')){
                                if(mrsLayerChipObj.Tapeout_Applications_MEBES_Jobview__c == 'Ready'){
                                    isEmailSent = true;
                                    system.debug('TapeoutApplication::');
                                    mrsLayerChipObj.Tapeout_Applications_MEBES_Jobview__c='Released';
                                    mrsLayerChipObj.Tapeout_Applications_MEBES_Jobview_Date__c= System.now();
                                    fieldToUpdate ='TapeoutApplicationMEBES';
                                    lstForEmail.add(mrsLayerChipObj);
                                    isUpdated = true;
                                    mrsLayerChipObj.TapeoutApplicationsMebesJobviewApprover__c = userObj.get(0).Id;
                                }    
                              }else if(page.containsIgnoreCase('Tapeout_Applications') && !groupNameSt.contains('Tapeout_Application')){
                                reason = 'Cannot approve because '+fromemail+' is not a Tapeout Application group user';
                                //sendEmailToJobviewer('Cannot approve because '+fromemail+' is not a Tapeout Application group user',fromemail,false);
                                isNotApprover = true;
                              }
                              if(groupNameSt.contains('Tapeout_Centre') && page.containsIgnoreCase('Tapeout_Centre')){
                                if(mrsLayerChipObj.Tapeout_Centre_MEBES_Jobview__c == 'Ready'){
                                      isEmailSent = true;
                                      mrsLayerChipObj.Tapeout_Centre_MEBES_Jobview__c='Released';
                                      mrsLayerChipObj.Tapeout_Centre_MEBES_Jobview_Date__c= System.now();
                                      fieldToUpdate ='TapeoutCenterMEBES';
                                      lstForEmail.add(mrsLayerChipObj);
                                      isUpdated = true;
                                      mrsLayerChipObj.TapeoutCentreMebesJobViewApprover__c = userObj.get(0).Id;
                                }  
                              }else if(!groupNameSt.contains('Tapeout_Centre') && page.containsIgnoreCase('Tapeout_Centre')){
                                reason = 'Cannot approve because '+fromemail+' is not a Tapeout Center group user';
                                //sendEmailToJobviewer('Cannot approve because '+fromemail+' is not a Tapeout Center group user',fromemail,false);
                                isNotApprover = true;
                              }
                              if(groupNameSt.contains('TDTI_MPW') && page.containsIgnoreCase('TDTI_MPW')){
                                if(mrsLayerChipObj.TDTI_MPW_MEBES_Jobview__c == 'Ready'){
                                      mrsLayerChipObj.TDTI_MPW_MEBES_Jobview__c='Released';
                                      mrsLayerChipObj.TDTI_MPW_MEBES_Date__c= System.now();
                                      isEmailSent = true;
                                      fieldToUpdate ='TDTIMPWMEBES';
                                      lstForEmail.add(mrsLayerChipObj);
                                      isUpdated = true;
                                      mrsLayerChipObj.TDTIMPWMebesJobviewApprover__c = userObj.get(0).Id;
                                }  
                              }else if(!groupNameSt.contains('TDTI_MPW') &&  page.containsIgnoreCase('TDTI_MPW')){
                                reason = 'Cannot approve because '+fromemail+' is not a TDTI-MPW group user';
                               // sendEmailToJobviewer('Cannot approve because '+fromemail+' is not a TDTI-MPW group user',fromemail,false);
                                isNotApprover = true;
                              }
                              if(groupNameSt.contains('MDP') &&  page.containsIgnoreCase('MDP')){
                                if(mrsLayerChipObj.MDP_MEBES_Jobview__c == 'Ready'){
                                      mrsLayerChipObj.MDP_MEBES_Jobview__c='Released';
                                      mrsLayerChipObj.MDP_MEBES_Jobview_Date__c= System.now();
                                      isEmailSent = true;
                                      fieldToUpdate ='MDPMEBES';
                                      lstForEmail.add(mrsLayerChipObj);
                                      isUpdated = true;
                                      mrsLayerChipObj.MDPMebesJobviewApprover__c = userObj.get(0).Id;
                                }  
                              }else if(!groupNameSt.contains('MDP') && page.containsIgnoreCase('MDP')){
                                //sendEmailToJobviewer('Cannot approve because '+fromemail+' is not a MDP group user',fromemail,false);
                                reason = 'Cannot approve because '+fromemail+' is not a MDP group user';
                                isNotApprover = true;
                              }
                              if(groupNameSt.contains('GlobalShuttle') && page.containsIgnoreCase('GlobalShuttle')){
                                if(mrsLayerChipObj.GlobalShuttle_MEBES_Jobview__c == 'Ready'){
                                     mrsLayerChipObj.GlobalShuttle_MEBES_Jobview__c='Released';
                                     mrsLayerChipObj.GlobalShuttle_MEBES_Jobview_Date__c= System.now();
                                     isEmailSent = true;
                                     fieldToUpdate ='GlobalShuttleMEBES';
                                     lstForEmail.add(mrsLayerChipObj);
                                     isUpdated = true;
                                     mrsLayerChipObj.GlobalShuttleMebesJobviewApprover__c = userObj.get(0).Id;
                                }  
                              }else if(!groupNameSt.contains('GlobalShuttle') && page.containsIgnoreCase('GlobalShuttle')){
                                reason = 'Cannot approve because '+fromemail+' is not a globalshuttle group user';
                                //sendEmailToJobviewer('Cannot approve because '+fromemail+' is not a globalshuttle group user',fromemail,false);
                                isNotApprover = true;
                              }  
                            }
                            if(isNotApprover){
                                sendEmailToJobviewer(reason,appHelper.PTRF_Number__c,appHelper.Mask_Set_Title__c,fromemail,false);
                            }
                         
                       }
                       
                     }  
                        try{
                         system.debug('$$$Before Insert$$'+mrsLayerChipListToUpdate.size());
                         if(isUpdated){
                              update mrsLayerChipListToUpdate;
                              system.debug('$$$After Insert$$'+mrsLayerChipListToUpdate.size());
                              update ptrfObj;
                              insert noteslst;
                              Map<Id,List<MRS_Layer_Chip_Association__c>> mapOfPTRFIdAndMrsLayerChipObj =new Map<Id,List<MRS_Layer_Chip_Association__c>>();
                              for(MRS_Layer_Chip_Association__c mrsLayerChipObj : lstForEmail){
                                  if(mapOfPTRFIdAndMrsLayerChipObj.get(mrsLayerChipObj.PTRF__c) == null){
                                      List<MRS_Layer_Chip_Association__c> mrsLayerChiplst = new List<MRS_Layer_Chip_Association__c>();
                                      mrsLayerChiplst.add(mrsLayerChipObj);
                                      mapOfPTRFIdAndMrsLayerChipObj.put(mrsLayerChipObj.PTRF__c,mrsLayerChiplst);
                                  }else{
                                      mapOfPTRFIdAndMrsLayerChipObj.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                                  }
                              }
                              if(isEmailSent){
                                  MRSHandlerUtility.sendEmailToReviewers(mapOfPTRFIdAndMrsLayerChipObj,fieldToUpdate,selectedCustomer,approveOrDisapprove,'',fromemail);
                              }
                         }else if(!isNotApprover && !isUpdated){
                            sendEmailToJobviewer('It is already approved',appHelper.PTRF_Number__c,appHelper.Mask_Set_Title__c,fromEmail,true);
                         }
                        }catch(Exception e){
                            sendEmailToJobviewer(e.getMessage(),appHelper.PTRF_Number__c,appHelper.Mask_Set_Title__c,fromEmail,false);
                        }
                    }
               
           }
  /**
     @Method: approveChipsForReviewerNotification
     @param: null
     @return : void
     @descrption: This method is used to approve the MRS_Layer_Chip_Association when email of Remider notification comes.
     **/ 
   public void approveChipsForReviewerNotification(String plainBody,String fromemail,String ptrf,String maskSetTitle,String keyWord,Boolean customerOrFoundry,String groupName){
        List<PTRF__c> ptrfObjlst;
        Id ptrfObjId;
        Set<Id> accountIdSt = new Set<Id>();
        Boolean disapprove = false;
        Boolean isUpdated = false;
       if(ptrf != null && ptrf.trim() != ''){
         ptrf = ptrf.trim();
         String[] stptrf;
         if(ptrf.contains(',')){
           stptrf = ptrf.split(',');
         }else{
           stptrf = new String[1];
           stptrf[0] = ptrf;
         }
             ptrfObjlst = [SELECT Id,Customer__c,Name,Status__c,Frame_Tapeout__c,Prime_Tapeout__c FROM PTRF__c  WHERE Name IN:stptrf] ;
             if(ptrfObjlst != null && ptrfObjlst.size() > 0){
                ptrfObjId = ptrfObjlst.get(0).Id;
                for(PTRF__c ptrfObj : ptrfObjlst){
                    accountIdSt.add(ptrfObj.Customer__c);
                }
             }
       }
       Boolean isWrongJobviewer = false;
       List<MRS_Layer_Chip_Association__c> mrsLayerChipList;
       List<MRS_Layer_Chip_Association__c> mrsLayerChipListToUpdate = new List<MRS_Layer_Chip_Association__c>();
       Boolean sendEmail = false;
       String fieldToUpdate ;
       String selectedCustomer;
       Boolean approveOrDisapprove = false;
       Notes__c notesObj;
       List<Notes__c> noteslst = new List<Notes__c>();
       String mebesRealease;
       Set<String> groupNameSt = new Set<String>();
       List<User> userObj =[SELECT FirstName,LastName,AccountId,Id FROM User WHERE Email=:fromemail AND IsActive=true];
       
       String body = fromemail+'  disapproved frame mockup through email.';
       set<String> setOfLCStatus =  new set<String>{'Cancel','Void','Hold'}; 
       set<String> setOfStatus =  new set<String>{'N.A.','Released','Hold','Shipped'};
       if(plainBody.containsIgnoreCase('MEBES'))
       {
           Set<Id> groupIdlst = new Set<Id>();
           List<GroupMember> groupMemeber = [SELECT GroupId,UserOrGroupId FROM GroupMember WHERE UserOrGroupId IN:userObj];
           if(groupMemeber != null && groupMemeber.size()>0)
           {
               for(GroupMember groupMemberObj : groupMemeber )
               {
                   groupIdlst.add(groupMemberObj.GroupId);
               }
               List<Group> grouplst =[SELECT DeveloperName,Id FROM Group WHERE Id IN :groupIdlst];
               for(Group groupObj : grouplst)
               {
                   if(groupObj.DeveloperName == 'Swift_Tapeout_Application')
                   {
                       mebesRealease ='Tapeout_Application';
                       groupNameSt.add('Tapeout_Application');
                   }else if(groupObj.DeveloperName == 'Swift_Tapeout_Centre')
                   {
                       mebesRealease ='Tapeout_Centre';
                       groupNameSt.add('Tapeout_Centre');
                   }else if(groupObj.DeveloperName == 'Swift_TDTI_MPW')
                   {
                       mebesRealease  ='TDTI_MPW';
                       groupNameSt.add('TDTI_MPW');
                   }else if(groupObj.DeveloperName == 'Swift_MDP')
                   {
                       mebesRealease  = 'MDP';
                       groupNameSt.add('MDP');
                   }else if(groupObj.DeveloperName == 'Swift_GlobalShuttle')
                   {
                       mebesRealease  = 'GlobalShuttle';
                       groupNameSt.add('GlobalShuttle');
                   }
                 
               }
           }
      
     }
    
    Boolean jobViewer = false;
    String   ptrfJobView ;
      ptrfJobView = ' SELECT Jobview__c,Jobview_Type__c,PTRF__c FROM PTRF_JobViewer_Info__c\n'+
                             ' WHERE PTRF__c = :ptrfObjid';
      if(customerOrFoundry){
        ptrfJobView = ptrfJobView + ' AND Jobview__c=\'Customer\'';
      }else if(!customerOrFoundry){
        ptrfJobView = ptrfJobView + ' AND Jobview__c=\'Foundry\'';
      }
      if(plainBody.containsIgnoreCase('Frame Mockup')) {
          ptrfJobView = ptrfJobView + ' AND Jobview_Type__c INCLUDES (\'Frame Mockup\')';
      }
      if(plainBody.containsIgnoreCase('GDSOUT')){
          ptrfJobView = ptrfJobView + ' AND Jobview_Type__c INCLUDES (\'Prime GDSOUT Review\')';
      }
      if(plainBody.containsIgnoreCase('MEBES')){
          ptrfJobView = ptrfJobView + ' AND Jobview_Type__c INCLUDES (\'MEBES Jobview\')';
      }
      ptrfJobView = ptrfJobView + ' AND User__c IN:userObj ';
      List<PTRF_JobViewer_Info__c> lstPTRFJobviewInfo = Database.Query(ptrfJobView);
      if(lstPTRFJobviewInfo != null && lstPTRFJobviewInfo.size()>0)
      {
          jobViewer = true;
      }
     
    List<String> teamRole = Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');
    List<Account_Team_Proxy__c> lstAccountTeamProxy = [SELECT Account__c,User__c,User_Email__c FROM Account_Team_Proxy__c WHERE Account__c IN :accountIdSt AND User__c IN:userObj AND Team_Role__c IN:teamRole];
    if(lstAccountTeamProxy != null && lstAccountTeamProxy.size() > 0){
          if(customerOrFoundry != null && customerOrFoundry){
              jobViewer = true;
           }
    }
                
       List<String> plainBodyArray = new List<String>();
       plainBodyArray.addAll(plainBody.split('Chip Name:'));
       if(plainBody.containsIgnoreCase('Frame Mockup'))
        {
            mrsLayerChipList = [SELECT Id,Customer_Frame_Mockup__c,Foundry_Frame_Mockup__c,PTRF__r.Name,PTRF__r.MaskSetTitle__r.Name,Chip__r.Name,PTRF__c,Customer_Name__c,PTRF__r.Tech_Geo__c,
                                                   layer__r.MRS__r.Mask_Set_Title__r.Name,ROM_Code__c,Layer__r.ROM_Code__c,Layer__r.Mask_Layer_Rev__c,Layer__r.Name,LastModifiedById
                                            FROM MRS_Layer_Chip_Association__c
                                            WHERE  Mask_Set_Title_Name__c=:maskSetTitle.trim()
                                            AND Chip__r.Name ='Frame' 
                                            AND Layer__r.Layer_Status__c NOT IN:setOfStatus
                                            AND Layer_Chip_Status__c NOT IN:setOfLCStatus
                                            for update];
            if(mrsLayerChipList != null && mrsLayerChipList.size() > 0){
              for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipList){
                if(plainBody.containsIgnoreCase(mrsLayerChipObj.PTRF__r.Name)){
                  mrsLayerChipListToUpdate.add(mrsLayerChipObj);
                }
              }
            }
          }
        if(plainBody.containsIgnoreCase('GDSOUT')){
          mrsLayerChipList = [SELECT Id,Customer_GDSOUT_Review__c,Foundry_GDSOUT_Review__c,PTRF__r.Name,PTRF__r.MaskSetTitle__r.Name,Chip__r.Name,PTRF__c,Customer_Name__c,PTRF__r.Tech_Geo__c,
                                                   layer__r.MRS__r.Mask_Set_Title__r.Name,ROM_Code__c,Layer__r.ROM_Code__c,Layer__r.Mask_Layer_Rev__c,Layer__r.Name,LastModifiedById
                                            FROM MRS_Layer_Chip_Association__c
                                            WHERE Mask_Set_Title_Name__c=:maskSetTitle.trim()
                                            AND Chip__r.Name !='Frame' 
                                            AND Layer__r.Layer_Status__c NOT IN:setOfStatus
                                            AND Layer_Chip_Status__c NOT IN:setOfLCStatus for update];
      if(mrsLayerChipList != null && mrsLayerChipList.size() > 0){
        Set<Id> stIds = new Set<Id>();
        for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipList){
          /*if(plainBody.containsIgnoreCase(mrsLayerChipObj.PTRF__r.Name) && plainBody.containsIgnoreCase(mrsLayerChipObj.Chip__r.Name)
           && plainBody.containsIgnoreCase(mrsLayerChipObj.Layer__r.Name) && plainBody.containsIgnoreCase(mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c)){
             mrsLayerChipListToUpdate.add(mrsLayerChipObj);
           }*/
           for(String chipLayerCombination : plainBodyArray){
               if(chipLayerCombination.containsIgnoreCase(mrsLayerChipObj.Chip__r.Name)){
                  if(chipLayerCombination.substringAfter('PTRF').containsIgnoreCase(mrsLayerChipObj.PTRF__r.Name)){
                      List<String> layersArray = new List<String>();
                      layersArray.addAll(chipLayerCombination.substringBetween('layer(s)','PTRF').split(','));
                      for(String layerName : layersArray){
                          if(layerName.containsIgnoreCase(mrsLayerChipObj.Layer__r.Name) && layerName.containsIgnoreCase(mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c)){
                             if(!stIds.contains(mrsLayerChipObj.Id)){
                                 mrsLayerChipListToUpdate.add(mrsLayerChipObj);
                                 stIds.add(mrsLayerChipObj.Id);
                             }
                             //break;
                           }
                       }
                  }
                 // break;
               }
            }
        }
      }
        }
        if(plainBody.containsIgnoreCase('MEBES')){
          List<MRS_Layer_Chip_Association__c> mrsLayerChipListDuplicate = new List<MRS_Layer_Chip_Association__c>();
            List<MRS_Layer_Chip_Association__c>    mrsLayerChipListForDuplicate = [SELECT Id,Customer_MEBES_Jobview__c,Foundry_MEBES_Jobview__c,
                                                                 Tapeout_Applications_MEBES_Jobview__c,Tapeout_Centre_MEBES_Jobview__c,
                                                                 Tapeout_Applications_MEBES_Jobview_Date__c,Tapeout_Centre_MEBES_Jobview_Date__c,
                                                                 TDTI_MPW_MEBES_Jobview__c,TDTI_MPW_MEBES_Date__c,MDP_MEBES_Jobview__c,
                                                                 MDP_MEBES_Jobview_Date__c,Tech_Geo__c,Mask_Set_Title_Id__c,
                                                                 GlobalShuttle_MEBES_Jobview__c,GlobalShuttle_MEBES_Jobview_Date__c,
                                                                 PTRF__r.Name,PTRF__r.MaskSetTitle__r.Name,Chip__r.Name,Layer__r.Name,Layer__r.Mask_Layer_Rev__c,Layer__r.ROM_Code__c,PTRF__c,Customer_Name__c,PTRF__r.Tech_Geo__c,
                                                                 layer__r.MRS__r.Mask_Set_Title__r.Name,ROM_Code__c,LastModifiedById
                                                          FROM MRS_Layer_Chip_Association__c
                                                          WHERE  Mask_Set_Title_Name__c=:maskSetTitle.trim()
                                                          AND Layer__r.Layer_Status__c NOT IN:setOfStatus
                                                          AND Layer_Chip_Status__c NOT IN:setOfLCStatus
                                                          for update];
      mrsLayerChipList = new List<MRS_Layer_Chip_Association__c>();
      if(mrsLayerChipListForDuplicate != null && mrsLayerChipListForDuplicate.size() > 0 ){
        Set<Id> stIds = new Set<Id>();
        for(MRS_Layer_Chip_Association__c mrsLayerChipObject : mrsLayerChipListForDuplicate){
          /*if(plainBody.containsIgnoreCase(mrsLayerChipObject.PTRF__r.Name) && plainBody.containsIgnoreCase(mrsLayerChipObject.Chip__r.Name)
            && plainBody.containsIgnoreCase(mrsLayerChipObject.Layer__r.Name) && plainBody.containsIgnoreCase(mrsLayerChipObject.Layer__r.Mask_Layer_Rev__c)){
               mrsLayerChipList.add(mrsLayerChipObject);
            }*/
             for(String chipLayerCombination : plainBodyArray){
               if(chipLayerCombination.containsIgnoreCase(mrsLayerChipObject.Chip__r.Name)){
                  if(chipLayerCombination.substringAfter('PTRF').containsIgnoreCase(mrsLayerChipObject.PTRF__r.Name)){
                      List<String> layersArray = new List<String>();
                      layersArray.addAll(chipLayerCombination.substringAfter('layer(s)').split(','));
                      for(String layerName : layersArray){
                          if(layerName.containsIgnoreCase(mrsLayerChipObject.Layer__r.Name) && layerName.containsIgnoreCase(mrsLayerChipObject.Layer__r.Mask_Layer_Rev__c)){
                             if(!stIds.contains(mrsLayerChipObject.Id)){
                                mrsLayerChipList.add(mrsLayerChipObject);
                                stIds.add(mrsLayerChipObject.Id);
                             }
                             //break;
                           }
                       }
                  }
                  //break;
               }
            }
          
        }
      }
               
                       /** Code added for Duplicate Chips/Frames **/
                       set<String> setUniqueCombo = new set<String>();
                       set<String> setMaskLayerNums = new set<String>();
                       set<String> setMaskRevs = new set<String>();
                       set<String> setTechGeos = new set<String>();
                       set<String> setChipNames = new set<String>();
                       String maskSetTitleId = '';
                       map<String,Integer> mapUniqueLayerChips = new map<String,Integer>();
                       for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipList){
                            setMaskLayerNums.add(mrsLayerChipObj.Layer__r.Name);
                            maskSetTitleId = mrsLayerChipObj.Mask_Set_Title_Id__c;
                            if(mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c!=null){
                                setMaskRevs.add(mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c);    
                            }
                            if(mrsLayerChipObj.PTRF__r.Tech_Geo__c!=null){
                                setTechGeos.add(mrsLayerChipObj.PTRF__r.Tech_Geo__c);   
                            }
                            if(mrsLayerChipObj.Chip__r.Name!=null){
                                setChipNames.add(mrsLayerChipObj.Chip__r.Name);   
                            }
                            String uniqueCombo;
                            if(mrsLayerChipObj.Layer__r.ROM_Code__c!=null && mrsLayerChipObj.Layer__r.ROM_Code__c!='####' && mrsLayerChipObj.Layer__r.ROM_Code__c.toUppercase()!='NULL'){
                                uniqueCombo = maskSetTitleId + mrsLayerChipObj.Layer__r.Name +mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+mrsLayerChipObj.Layer__r.ROM_Code__c+mrsLayerChipObj.Chip__r.Name+mrsLayerChipObj.PTRF__r.Tech_Geo__c;
                            }else{
                                uniqueCombo = maskSetTitleId + mrsLayerChipObj.Layer__r.Name +mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+mrsLayerChipObj.Chip__r.Name+mrsLayerChipObj.PTRF__r.Tech_Geo__c;   
                            }
                            setUniqueCombo.add(uniqueCombo);
                        }
                       for(MRS_Layer_Chip_Association__c mrsLayerChipObj:[select Id,Layer__r.Name,PTRF__r.MaskSetTitle__r.Name,Chip__r.Name,Mask_Set_Title_Id__c, 
                       Layer__r.Mask_Layer_Rev__c,Layer__r.ROM_Code__c,Tech_Geo__c,Layer_Chip_Status__c,PTRF__r.Tech_Geo__c from MRS_Layer_Chip_Association__c where
                       Layer_Chip_Status__c NOT IN ('Hold','Cancel','Void') and Layer__r.Mask_Layer_Rev__c IN:setMaskRevs and Chip__r.Name IN:setChipNames
                       and Layer__r.Name IN:setMaskLayerNums and PTRF__r.Tech_Geo__c IN:setTechGeos AND Mask_Set_Title_Id__c=:maskSetTitleId ]){
                            String uniqueCombo;
                            Integer counterUniqueLayerChip;
                            if(mrsLayerChipObj.Layer__r.ROM_Code__c!=null && mrsLayerChipObj.Layer__r.ROM_Code__c!='####' && mrsLayerChipObj.Layer__r.ROM_Code__c.toUppercase()!='NULL'){
                                uniqueCombo = mrsLayerChipObj.Mask_Set_Title_Id__c +mrsLayerChipObj.Layer__r.Name +mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+mrsLayerChipObj.Layer__r.ROM_Code__c+mrsLayerChipObj.Chip__r.Name+mrsLayerChipObj.PTRF__r.Tech_Geo__c;
                            }else{
                                uniqueCombo = mrsLayerChipObj.Mask_Set_Title_Id__c +mrsLayerChipObj.Layer__r.Name +mrsLayerChipObj.Layer__r.Mask_Layer_Rev__c+mrsLayerChipObj.Chip__r.Name+mrsLayerChipObj.PTRF__r.Tech_Geo__c;   
                            }
                            if(setUniqueCombo!=null && setUniqueCombo.size()>0 && setUniqueCombo.contains(uniqueCombo)){                                
                                if(mapUniqueLayerChips.containsKey(uniqueCombo)){
                                    counterUniqueLayerChip = mapUniqueLayerChips.get(uniqueCombo);
                                    counterUniqueLayerChip = counterUniqueLayerChip +1;
                                }else{
                                    counterUniqueLayerChip = 1; 
                                }                
                                mapUniqueLayerChips.put(uniqueCombo, counterUniqueLayerChip);                                           
                            }
                       }
                       /** Code added for Duplicate Chips/Frames **/
                       Double mdpTechGeoCutoff       = Double.valueOf( MRSHandlerUtilityExtn.loadEnvVariable('Swift_MDP_Tech_Geo_Cut_Off','0.022') );
                       for(MRS_Layer_Chip_Association__c msrLayerChipObj : mrsLayerChipList){
                        String uniqueCombo;
                            if(msrLayerChipObj.Layer__r.ROM_Code__c!=null && msrLayerChipObj.Layer__r.ROM_Code__c!='####' && msrLayerChipObj.Layer__r.ROM_Code__c.toUppercase()!='NULL'){
                                uniqueCombo = msrLayerChipObj.Mask_Set_Title_Id__c +msrLayerChipObj.Layer__r.Name+msrLayerChipObj.Layer__r.Mask_Layer_Rev__c+msrLayerChipObj.Layer__r.ROM_Code__c+msrLayerChipObj.Chip__r.Name+msrLayerChipObj.PTRF__r.Tech_Geo__c;
                            }else{
                                uniqueCombo = msrLayerChipObj.Mask_Set_Title_Id__c +msrLayerChipObj.Layer__r.Name+msrLayerChipObj.Layer__r.Mask_Layer_Rev__c+msrLayerChipObj.Chip__r.Name+msrLayerChipObj.PTRF__r.Tech_Geo__c;    
                            }
                            //Update For Unique Chips
                            if(plainBody.contains(msrLayerChipObj.Chip__r.Name) && msrLayerChipObj.Chip__r.Name != 'Frame' && mapUniqueLayerChips.containsKey(uniqueCombo) && mapUniqueLayerChips.get(uniqueCombo)==1){
                                mrsLayerChipListToUpdate.add(msrLayerChipObj);
                            //Send Error Message For Duplicate Chips
                            }else if(msrLayerChipObj.Chip__r.Name!='Frame' && plainBody.contains(msrLayerChipObj.Chip__r.Name) && mapUniqueLayerChips.containsKey(uniqueCombo) && mapUniqueLayerChips.get(uniqueCombo)>1){
                                mrsLayerChipListDuplicate.add(msrLayerChipObj);              
                            //Update for Unique Frames when User is not part of Tapeout Centre and MDP
                            }else if(msrLayerChipObj.Chip__r.Name=='Frame'  && !groupName.equalsIgnoreCase('TapeoutCentre') && !groupName.equalsIgnoreCase('MDP')  && plainBody.contains(msrLayerChipObj.Chip__r.Name)){
                                mrsLayerChipListToUpdate.add(msrLayerChipObj);                            
                            //Send Error Message For Duplicate Frames when User is part of Tapeout Centre
                            }else if(msrLayerChipObj.Chip__r.Name=='Frame' && groupName.equalsIgnoreCase('TapeoutCentre') &&  msrLayerChipObj.Tech_Geo__c != null && ((msrLayerChipObj.Tech_Geo__c.contains('UM') && Double.valueOf(msrLayerChipObj.Tech_Geo__c.toUpperCase().substringBefore('UM')) > 0.02)||(!msrLayerChipObj.Tech_Geo__c.contains('UM') && Double.valueOf(msrLayerChipObj.Tech_Geo__c.toUpperCase()) > mdpTechGeoCutoff)) && plainBody.contains(msrLayerChipObj.Chip__r.Name) && mapUniqueLayerChips.containsKey(uniqueCombo) && mapUniqueLayerChips.get(uniqueCombo)>1){
                                mrsLayerChipListDuplicate.add(msrLayerChipObj);
                            //Send Error Message For Duplicate Frames when User is part of MDP     
                            }else if(msrLayerChipObj.Chip__r.Name=='Frame' && groupName.equalsIgnoreCase('MDP') &&  msrLayerChipObj.Tech_Geo__c != null && ((msrLayerChipObj.Tech_Geo__c.contains('UM') && Double.valueOf(msrLayerChipObj.Tech_Geo__c.toUpperCase().substringBefore('UM')) <= mdpTechGeoCutoff)||(!msrLayerChipObj.Tech_Geo__c.contains('UM') && Double.valueOf(msrLayerChipObj.Tech_Geo__c.toUpperCase()) <= mdpTechGeoCutoff)) && plainBody.contains(msrLayerChipObj.Chip__r.Name) && mapUniqueLayerChips.containsKey(uniqueCombo) && mapUniqueLayerChips.get(uniqueCombo)>1){
                                mrsLayerChipListDuplicate.add(msrLayerChipObj);
                            //Update For Unique Frames when User is part of Tapeout Centre or MDP     
                            }else if(msrLayerChipObj.Chip__r.Name=='Frame' && (groupName.equalsIgnoreCase('MDP') || groupName.equalsIgnoreCase('TapeoutCentre')) && plainBody.contains(msrLayerChipObj.Chip__r.Name) && mapUniqueLayerChips.containsKey(uniqueCombo) && mapUniqueLayerChips.get(uniqueCombo)==1){
                                mrsLayerChipListToUpdate.add(msrLayerChipObj);     
                            }
                        }
                        if(mrsLayerChipListDuplicate.size()>0){
                            sendEmailToResponderWithError(mrsLayerChipListDuplicate,fromemail,maskSetTitle,ptrf); 
                        }
                    
                    
         }
          List<MRS_Layer_Chip_Association__c> lstForEmail = new List<MRS_Layer_Chip_Association__c>();

        if(mrsLayerChipListToUpdate != null && mrsLayerChipListToUpdate.size() > 0){
           if(plainBody.containsIgnoreCase('Frame Mockup')){
               if((plainBody.startsWithIgnoreCase('Approve') || plainBody.startsWithIgnoreCase('Approved'))  && jobViewer){
                 for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipListToUpdate){
                   selectedCustomer = mrsLayerChipObj.Customer_Name__c;
                   approveOrDisapprove = true;
                   if(customerOrFoundry){
                     if(mrsLayerChipObj.Customer_Frame_Mockup__c == 'Ready'){
                          mrsLayerChipObj.Customer_Frame_Mockup__c ='Approve';
                          if(mrsLayerChipObj.Foundry_Frame_Mockup__c == 'Approve'  || mrsLayerChipObj.Foundry_Frame_Mockup__c =='N.A.'){
                             sendEmail = true;
                             fieldToUpdate ='CustomerFrameMockup';
                          }
                          isUpdated = true;
                          mrsLayerChipObj.Customer_Frame_Mockup_Date__c = System.now();
                          lstForEmail.add(mrsLayerChipObj);
                          mrsLayerChipObj.CustomerFrameMockupApprover__c = userObj.get(0).Id;
                     }
                   }else{
                     if(mrsLayerChipObj.Foundry_Frame_Mockup__c == 'Ready'){
                          mrsLayerChipObj.Foundry_Frame_Mockup__c ='Approve';
                          if(mrsLayerChipObj.Customer_Frame_Mockup__c == 'Approve'  || mrsLayerChipObj.Customer_Frame_Mockup__c =='N.A.'){
                             sendEmail = true;
                             fieldToUpdate ='FoundryFrameMockup';
                          }
                           isUpdated = true;
                           mrsLayerChipObj.Foundry_Frame_Mockup_Date__c = System.now();
                           lstForEmail.add(mrsLayerChipObj);
                           mrsLayerChipObj.FoundryFrameMockupApprover__c = userObj.get(0).Id;
                     }
                   }
                 }
               }else if((plainBody.startsWithIgnoreCase('Disapprove') || plainBody.startsWithIgnoreCase('Disapproved')) && jobViewer){
                 for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipListToUpdate){
                   selectedCustomer = mrsLayerChipObj.Customer_Name__c;
                   approveOrDisapprove = true;
                   if(customerOrFoundry){
                     if(mrsLayerChipObj.Customer_Frame_Mockup__c == 'Ready'){
                          mrsLayerChipObj.Customer_Frame_Mockup__c ='Disapprove';
                          sendEmail = true;
                          isUpdated = true;
                          fieldToUpdate ='CustomerFrameMockup';
                          mrsLayerChipObj.Customer_Frame_Mockup_Date__c = System.now();
                          disapprove = true;
                          mrsLayerChipObj.CustomerFrameMockupApprover__c = userObj.get(0).Id;
                          notesObj = new Notes__c(Body__c = body,Category__c='Customer Frame Mockup Disapproval',ParentId__c=mrsLayerChipObj.Id);
                          noteslst.add(notesObj);
                          lstForEmail.add(mrsLayerChipObj);
                          mrsLayerChipObj.CustomerFrameMockupApprover__c = userObj.get(0).Id;
                     }
                   }else{
                     if(mrsLayerChipObj.Foundry_Frame_Mockup__c == 'Ready'){
                          mrsLayerChipObj.Foundry_Frame_Mockup__c ='Disapprove';
                          sendEmail = true;
                          fieldToUpdate ='FoundryFrameMockup';
                          mrsLayerChipObj.Foundry_Frame_Mockup_Date__c = System.now();
                          disapprove = true;
                          notesObj = new Notes__c(Body__c = body,Category__c='Foundry Frame Mockup Disapproval',ParentId__c=mrsLayerChipObj.Id);
                          noteslst.add(notesObj);
                          isUpdated = true;
                          lstForEmail.add(mrsLayerChipObj);
                          mrsLayerChipObj.FoundryFrameMockupApprover__c = userObj.get(0).Id;
                     }
                   }
                 }
                 
               }else{
                  isWrongJobviewer = true;
                  sendEmailToJobviewer('Cannot approve because'+fromemail+'is not a jobviewer',ptrf,maskSetTitle,fromemail,false);
               }
             
           }else if(plainBody.containsIgnoreCase('GDSOUT')){
                     if((plainBody.startsWithIgnoreCase('Approve') || plainBody.startsWithIgnoreCase('Approved')) && jobViewer){
                       for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipListToUpdate){
                           selectedCustomer = mrsLayerChipObj.Customer_Name__c;
                     approveOrDisapprove = true;
                     if(customerOrFoundry){
                       if(mrsLayerChipObj.Customer_GDSOUT_Review__c == 'Ready'){
                            mrsLayerChipObj.Customer_GDSOUT_Review__c ='Approve';
                            if(mrsLayerChipObj.Foundry_GDSOUT_Review__c == 'Approve'  || mrsLayerChipObj.Foundry_GDSOUT_Review__c =='N.A.'){
                               sendEmail = true;
                               fieldToUpdate ='GDSOUTReview';
                            }
                            isUpdated = true;
                            mrsLayerChipObj.Customer_GDSOUT_Review_Date__c = System.now();
                            lstForEmail.add(mrsLayerChipObj);
                            mrsLayerChipObj.CustomerGDSOUTReviewApprover__c = userObj.get(0).Id;
                       }
                     }else{
                       if(mrsLayerChipObj.Foundry_GDSOUT_Review__c == 'Ready'){
                            mrsLayerChipObj.Foundry_GDSOUT_Review__c ='Approve';
                            if(mrsLayerChipObj.Customer_GDSOUT_Review__c == 'Approve'  || mrsLayerChipObj.Customer_GDSOUT_Review__c =='N.A.'){
                               sendEmail = true;
                               fieldToUpdate ='GDSOUTReview';
                            }
                             isUpdated = true;
                             mrsLayerChipObj.Foundry_GDSOUT_Review_Date__c = System.now();
                             lstForEmail.add(mrsLayerChipObj);
                             mrsLayerChipObj.FoundryGDSOUTReviewApprover__c = userObj.get(0).Id;
                       }
                     }
                       }
                     }else{
                        isWrongJobviewer = true;
                        sendEmailToJobviewer('Cannot approve because '+fromemail+' is not a jobviewer',ptrf,maskSetTitle,fromemail,false);
                     }
           }else if(plainBody.containsIgnoreCase('MEBES')){
                if((plainBody.startsWithIgnoreCase('Approve') || plainBody.startsWithIgnoreCase('Approved'))){
                     if(jobViewer && (groupName == 'Customer' || groupName == 'Foundry')){
                      for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipListToUpdate){
                           selectedCustomer = mrsLayerChipObj.Customer_Name__c;
                           approveOrDisapprove = true;
                           if(customerOrFoundry){
                              if(mrsLayerChipObj.Customer_MEBES_Jobview__c == 'Ready'){
                                 mrsLayerChipObj.Customer_MEBES_Jobview__c ='Released';
                                 sendEmail = true;
                                 fieldToUpdate ='CustomerMEBES';
                                 isUpdated = true;
                                 mrsLayerChipObj.Customer_MEBES_Jobview_Date__c = system.now();
                                 lstForEmail.add(mrsLayerChipObj);
                                 mrsLayerChipObj.CustomerMebesJobViewApprover__c = userObj.get(0).Id;
                          }  
                        }else if(!customerOrFoundry){
                           if(mrsLayerChipObj.Foundry_MEBES_Jobview__c == 'Ready'){
                               mrsLayerChipObj.Foundry_MEBES_Jobview__c ='Released';
                               sendEmail = true;
                               fieldToUpdate ='FoundryMEBES';
                               isUpdated = true;
                               mrsLayerChipObj.Foundry_MEBES_Jobview_Date__c = system.now();
                               lstForEmail.add(mrsLayerChipObj);
                               mrsLayerChipObj.FoundryMebesJobViewApprover__c = userObj.get(0).Id;
                            }  
                          
                        }
                      }
                   }else if(!jobViewer && (groupName == 'Customer' || groupName == 'Foundry')){
                       isWrongJobviewer = true;
                       sendEmailToJobviewer('Cannot approve because '+fromemail+' is not a jobviewer',ptrf,maskSetTitle,fromemail,false);
                   }else if(groupName != 'Customer' && groupName != 'Foundry'){
                     String reason;
                     for(MRS_Layer_Chip_Association__c mrsLayerChipObj : mrsLayerChipListToUpdate){
                         selectedCustomer = mrsLayerChipObj.Customer_Name__c;
                         approveOrDisapprove = true;
                         if(groupNameSt.contains('Tapeout_Application') && groupName.containsIgnoreCase('TapeoutApp') && mrsLayerChipObj.Tapeout_Applications_MEBES_Jobview__c == 'Ready'){
                           // sendEmail = true;
                            fieldToUpdate ='TapeoutApplicationMEBES';
                            isUpdated = true;
                            mrsLayerChipObj.Tapeout_Applications_MEBES_Jobview__c = 'Released';
                            mrsLayerChipObj.Tapeout_Applications_MEBES_Jobview_Date__c = system.now();
                            lstForEmail.add(mrsLayerChipObj);
                            mrsLayerChipObj.TapeoutApplicationsMebesJobviewApprover__c = userObj.get(0).Id;
                        }else if(!groupNameSt.contains('Tapeout_Application') && groupName.containsIgnoreCase('TapeoutApp') && mrsLayerChipObj.Tapeout_Applications_MEBES_Jobview__c == 'Ready'){
                           // sendEmailToJobviewer('Cannot approve because '+fromemail+' is not a tapeout Application group user',fromemail,false);
                            isWrongJobviewer = true;
                            reason = 'Cannot approve because '+fromemail+' is not a tapeout Application group user';
                        }
                        if(groupNameSt.contains('Tapeout_Centre') && groupName.containsIgnoreCase('TapeoutCentre') &&  mrsLayerChipObj.Tapeout_Centre_MEBES_Jobview__c == 'Ready'){
                           //sendEmail = true;
                           fieldToUpdate ='TapeoutCenterMEBES';
                           isUpdated = true;
                           mrsLayerChipObj.Tapeout_Centre_MEBES_Jobview__c = 'Released';
                           mrsLayerChipObj.Tapeout_Centre_MEBES_Jobview_Date__c = system.now();
                           lstForEmail.add(mrsLayerChipObj);
                           mrsLayerChipObj.TapeoutCentreMebesJobViewApprover__c = userObj.get(0).Id;
                        }else if(!groupNameSt.contains('Tapeout_Centre') && groupName.containsIgnoreCase('TapeoutCentre') &&  mrsLayerChipObj.Tapeout_Centre_MEBES_Jobview__c == 'Ready'){
                            //sendEmailToJobviewer('Cannot approve because '+fromemail+' is not a tapeout center group user',fromemail,false);
                            isWrongJobviewer = true;
                            reason = 'Cannot approve because '+fromemail+' is not a tapeout center group user';
                        }
                        if(groupNameSt.contains('TDTI_MPW') && groupName.containsIgnoreCase('MPWTDTI') &&  mrsLayerChipObj.TDTI_MPW_MEBES_Jobview__c == 'Ready'){
                           //sendEmail = true;
                           fieldToUpdate ='TDTIMPWMEBES';
                           isUpdated = true;
                           mrsLayerChipObj.TDTI_MPW_MEBES_Jobview__c = 'Released';
                           mrsLayerChipObj.TDTI_MPW_MEBES_Date__c = system.now();
                           lstForEmail.add(mrsLayerChipObj);
                           mrsLayerChipObj.TDTIMPWMebesJobviewApprover__c = userObj.get(0).Id;
                        }else if(!groupNameSt.contains('TDTI_MPW') && groupName.containsIgnoreCase('MPWTDTI') &&  mrsLayerChipObj.TDTI_MPW_MEBES_Jobview__c == 'Ready'){
                            //sendEmailToJobviewer('Cannot approve because '+fromemail+' is not a tdti mpw group user',fromemail,false);
                            reason = 'Cannot approve because '+fromemail+' is not a tdti mpw group user';
                            isWrongJobviewer = true;
                        }
                        if(groupNameSt.contains('MDP') && groupName.containsIgnoreCase('MDP') &&  mrsLayerChipObj.MDP_MEBES_Jobview__c == 'Ready'){
                           //sendEmail = true;
                           fieldToUpdate ='MDPMEBES';
                           isUpdated = true;
                           mrsLayerChipObj.MDP_MEBES_Jobview__c = 'Released';
                           mrsLayerChipObj.MDP_MEBES_Notified_Date__c = system.now();
                           lstForEmail.add(mrsLayerChipObj);
                           mrsLayerChipObj.MDPMebesJobviewApprover__c = userObj.get(0).Id;
                        }else if(!groupNameSt.contains('MDP') && groupName.containsIgnoreCase('MDP') &&  mrsLayerChipObj.MDP_MEBES_Jobview__c == 'Ready'){
                           // sendEmailToJobviewer('Cannot approve because '+fromemail+' is not a MDP group user',fromemail,false);
                            isWrongJobviewer = true;
                            reason = 'Cannot approve because '+fromemail+' is not a MDP group user';
                        }
                        if(groupNameSt.contains('GlobalShuttle') && groupName.containsIgnoreCase('GlobalShuttle') &&  mrsLayerChipObj.GlobalShuttle_MEBES_Jobview__c == 'Ready'){
                           sendEmail = true;
                           fieldToUpdate ='GlobalShuttleMEBES';
                           isUpdated = true;
                           mrsLayerChipObj.GlobalShuttle_MEBES_Jobview__c = 'Released';
                           mrsLayerChipObj.GlobalShuttle_MEBES_Jobview_Date__c = system.now();
                           lstForEmail.add(mrsLayerChipObj);
                           mrsLayerChipObj.GlobalShuttleMebesJobviewApprover__c = userObj.get(0).Id;
                        }else if(!groupNameSt.contains('GlobalShuttle') && groupName.containsIgnoreCase('GlobalShuttle') &&  mrsLayerChipObj.GlobalShuttle_MEBES_Jobview__c == 'Ready'){
                            //sendEmailToJobviewer('Cannot approve because '+fromemail+' is not a globalshuttle group user',fromemail,false);
                            isWrongJobviewer = true;
                            reason = 'Cannot approve because '+fromemail+' is not a globalshuttle group user';
                        }
                      }
                      if(isWrongJobviewer){
                         sendEmailToJobviewer(reason,ptrf,maskSetTitle,fromemail,false);
                      }
                   }
                   
                  
                }
           }
           try{
            if(isUpdated){
                 update mrsLayerChipListToUpdate;
                 insert noteslst;
                 if(disapprove){
                   if(ptrfObjlst != null && ptrfObjlst.size() > 0){
                     for(PTRF__c ptrfObj : ptrfObjlst){
                       if(ptrfObj.Prime_Tapeout__c){
                               ptrfObj.Frame_Tapeout__c = false;
                             }else{
                              ptrfObj.Status__c ='Cancel';
                             }
                     }
                     
                     update ptrfObjlst;
                   }
                 }
                 Map<Id,List<MRS_Layer_Chip_Association__c>> mapOfPTRFIdAndMrsLayerChipObj =new Map<Id,List<MRS_Layer_Chip_Association__c>>();
                  for(MRS_Layer_Chip_Association__c mrsLayerChipObj : lstForEmail){
                      if(mapOfPTRFIdAndMrsLayerChipObj.get(mrsLayerChipObj.PTRF__c) == null){
                          List<MRS_Layer_Chip_Association__c> mrsLayerChiplst = new List<MRS_Layer_Chip_Association__c>();
                          mrsLayerChiplst.add(mrsLayerChipObj);
                          mapOfPTRFIdAndMrsLayerChipObj.put(mrsLayerChipObj.PTRF__c,mrsLayerChiplst);
                      }else{
                          mapOfPTRFIdAndMrsLayerChipObj.get(mrsLayerChipObj.PTRF__c).add(mrsLayerChipObj);
                      }
                  }
                  if(sendEmail){
                  MRSHandlerUtility.sendEmailToReviewers(mapOfPTRFIdAndMrsLayerChipObj,fieldToUpdate,selectedCustomer,approveOrDisapprove,'',fromemail);
                 }
            }else if(!isWrongJobviewer && !isUpdated){
                sendEmailToJobviewer('It is already approved',ptrf,maskSetTitle,fromEmail,true);
            }
             
           }catch(Exception e){
              sendEmailToJobviewer(e.getMessage(),ptrf,maskSetTitle,fromEmail,false);
           }
           
        }
     
   }
   
   /**
        This method will send Email to the responder with the Error Message when Duplicate chips are found for the same Layer and Tech Geo. 
        @method name: sendEmailToResponderWithError
        @parameter:   1. List of MRS Layer Association records having duplicate.
                      2. From Email
                      3. Mask Set Title
                      4. PTRF Number
        @return :     None.
   **/            
   public void sendEmailToResponderWithError(list<MRS_Layer_Chip_Association__c> listMRSLayerChip,String fromemail,String maskSetTitle,String ptrf){
        //Fetching Org Wide Email Addresses
        OrgWideEmailAddress Orgid=[Select id, DisplayName From OrgWideEmailAddress where DisplayName=:'GLOBALFOUNDRIES' LIMIT 1];
        //Fetching Email Template
        EmailTemplate template = [SELECT DeveloperName,Subject,Body,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Swift_Device_MEBES_Duplicate_Chips_Frames'];
        //To Address -  Start
        List<String> lstToAddress = new List<String>();        
        lstToAddress.add(fromemail);     
        //To Address -  End
        String[] toAddress ;
        Integer counter;
        if(lstToAddress != null){
            toAddress  =new String[lstToAddress.size()];
            counter =0;            
            for(String email : lstToAddress){
                toAddress[counter] = email ;
                counter++;
            }
        }  
        String subject;
        String plainBody;
        String layerChipName;
        Integer layerChipCounter =0;
        subject = template.subject;
        subject=subject.replace('<MRS.Mask Set Title>',maskSetTitle);
        plainBody = template.Body;          
        plainBody =plainBody.replace('<MRS.Mask Set Title>',maskSetTitle);
        plainBody =plainBody.replace('<PTRF.Number>',ptrf);        
        Set<String> layerNameSt = new Set<String>();   
        for(MRS_Layer_Chip_Association__c obj : listMRSLayerChip){                                  
            if(layerChipCounter ==0){ 
                if(obj.Layer__r.ROM_Code__c!=null  && obj.Layer__r.ROM_Code__c.toUppercase()!='NULL' && obj.Layer__r.ROM_Code__c !='####'){
                    layerChipName = 'Chip Name: '+obj.Chip__r.Name+' layer(s) '+obj.Layer__r.Name+obj.Layer__r.Mask_Layer_Rev__c+'('+obj.Layer__r.ROM_Code__c+')';
                }else{
                    layerChipName = 'Chip Name: '+obj.Chip__r.Name+' layer(s) '+obj.Layer__r.Name+obj.Layer__r.Mask_Layer_Rev__c;
                }               
            }else{
                if(obj.Layer__r.ROM_Code__c!=null  && obj.Layer__r.ROM_Code__c.toUppercase()!='NULL' && obj.Layer__r.ROM_Code__c !='####'){
                    layerChipName = layerChipName +'\n'+'Chip Name: '+obj.Chip__r.Name+' layer(s) '+obj.Layer__r.Name+obj.Layer__r.Mask_Layer_Rev__c+'('+obj.Layer__r.ROM_Code__c+')';
                }else{
                    layerChipName = layerChipName +'\n'+'Chip Name: '+obj.Chip__r.Name+' layer(s) '+obj.Layer__r.Name+obj.Layer__r.Mask_Layer_Rev__c;
                }  
            }
            layerChipCounter  = layerChipCounter +1;  
            String layerName;     
            if(obj.Layer__r.ROM_Code__c!=null  && obj.Layer__r.ROM_Code__c.toUppercase()!='NULL' && obj.Layer__r.ROM_Code__c !='####'){
                layerName = obj.Layer__r.Name+obj.Layer__r.Mask_Layer_Rev__c+'('+obj.Layer__r.ROM_Code__c+')';
            }else{
                layerName = obj.Layer__r.Name+obj.Layer__r.Mask_Layer_Rev__c;
            }  
            layerNameSt.add(layerName) ;                                  
        }
        counter = 0;
        String layerName;
        if(layerNameSt != null && layerNameSt.size() > 0){
            for(String layer : layerNameSt){
                if(counter == 0){
                    layerName = layer;
                }else{
                    layerName = layerName+ ' ,' + layer;
                }
                counter++;
            }
        }
        plainBody =plainBody.replace('<MRS.Mask Layer>',layerName);        
        plainBody =plainBody.replace('<Chip.Details>',layerChipName);        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setOrgWideEmailAddressId(Orgid.Id) ;             
        mail.setUseSignature(false);
        mail.setToAddresses(toAddress); 
        mail.setSubject(subject);
        mail.setPlainTextBody(plainBody);
        try{
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        }catch(Exception ex){            
        }
     }  
  /**
        This method will send Email to the jobviewer
        @method name: sendEmailToJobviewer
        @parameter:   
        @return :     None.
   **/            
   public void sendEmailToJobviewer(String reason,String ptrfName,String mstName,String fromEmail,Boolean isKeyWrong){
       //Fetching Org Wide Email Addresses
        OrgWideEmailAddress Orgid=[Select id, DisplayName From OrgWideEmailAddress where DisplayName=:'GLOBALFOUNDRIES' LIMIT 1];
        //Fetching Email Template
        EmailTemplate template = [SELECT DeveloperName,Subject,Body,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Email_For_Error_Message_During_Approval' AND isActive = true];
        if(template != null){
            String[] toAddress = new String[]{};
            if(isKeyWrong){
               toAddress.add(fromEmail);
            }else{
                if(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c.contains(';')){
                      toAddress.addAll(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c.split(';'));
                }else{
                      toAddress.add(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c);
                }
            }
            String[] ccAddress = new String[]{};
            if(isKeyWrong){
                if(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c.contains(';')){
                      ccAddress.addAll(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c.split(';'));
                }else{
                      ccAddress.add(Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c);
                }
            }
            
            String[] bccAddress = new String[]{};
            if(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.contains(';')){
                 bccAddress.addAll(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.split(';'));
               }else{
                  bccAddress.add(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c);
               }
            
            String plainBody = template.Body;
            if(mstName != null){
                plainBody = plainBody.replace('<MSTName>',mstName);
            }
            else {
                plainBody = plainBody.replace('<MSTName>','');
            }
            if(ptrfName != null){
                plainBody = plainBody.replace('<PTRFName>',ptrfName);
            }
            else {
                plainBody = plainBody.replace('<PTRFName>','');
            }
            plainBody = plainBody.replace('Reason:','Reason:'+reason);
            plainBody = plainBody + '\n\nApproval Sent By : '+senderName+'\nSent Time : '+emailSentTime+'\nSubject: '+emailSubject+'\n\n'+plainTextBody;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setToAddresses(toAddress); 
            mail.setCcAddresses(ccAddress);   
            mail.setBccAddresses(bccAddress); 
            mail.setSubject(template.Subject);
            mail.setPlainTextBody(plainBody);
            mail.setOrgWideEmailAddressId(orgId.Id);
            mail.setReplyTo(Label.SWIFT_ReplyTo_Address);
            try{
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            }catch(Exception ex){            
            }
        }
   }
    public String  decryptCode(String approvarId){
        //Blob cryptoKey = EncodingUtil.base64Decode(Environment_Variable__c.getInstance('SWIFT_Encrypted_Key').Value__c) ;
        
        system.debug('$$$Label:::'+Label.Swift_Email_Encryption_Decryption_Key);
        Blob cryptoKey = EncodingUtil.base64Decode(Label.Swift_Email_Encryption_Decryption_Key) ;
        Blob decryptedData;
        
        decryptedData = Crypto.decryptWithManagedIV('AES256',cryptoKey,EncodingUtil.base64Decode(EncodingUtil.urlDecode(approvarId,'UTF-8')));
        
        system.debug('@@@decryptedData @@'+decryptedData);
        
        String b64Decrypted = EncodingUtil.base64Encode(decryptedData);
        system.debug('b64Decrypted&&&&'+decryptedData.toString());
      //  b64Decrypted = b64Decrypted.trim().substring(0, 15);
        system.debug('$$$b64Decrypted$$'+b64Decrypted); 
        return decryptedData.toString(); 
       
     }
}