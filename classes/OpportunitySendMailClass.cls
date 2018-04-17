/********************************************************************
* Author: Abhishek
* Project: Opportunity Management
* Name: OpportunitySendMailClass
* Description: Class is created for sending mail to FAE/AM/Market Segment users
* CreatedDate:
* Modified By : Abhishek
* Modified date : 03-Mar-2017  
*********************************************************************/
Public Class OpportunitySendMailClass{
    
    Public List<Opportunity> listofOptyRec;
    Public boolean checkflag1 = false ;
    Public boolean checkflag2 = false;
    Public boolean checkflag3 = false;
    
    Public OpportunitySendMailClass(){
    }
    
    /**
    * @description Method for checking the control point and sending mail to FAE/AM/PLM/MarketSegment User 
    * @param  opoortunity record
    * @return No
    */   
    Public void opportunitychecklistmember(List<Opportunity> optyrec){
        listofOptyRec = new List<Opportunity>();
        for(Opportunity opty : optyrec){
            system.debug('Inside email method :' +opty);
            listofOptyRec.add(opty);
            if(opty.StageName == '0.Pre-Discovery'){
                If(opty.AM_CP1__c == true && opty.FAE_CP1__c==false && opty.AM_CP2__c==false && opty.FAE_CP2__c==false && opty.PLM_CP2__c == false && opty.MarketSegment_CP2__c==false && opty.AM_CP3__c==false && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
                    checkflag1=true;
                    sendemailtochecklistmember();
                }
                else if(opty.AM_CP1__c == true && opty.FAE_CP1__c==true && opty.AM_CP2__c==false && opty.FAE_CP2__c==false && opty.PLM_CP2__c == false && opty.MarketSegment_CP2__c==false && opty.AM_CP3__c==false && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
                    checkflag2 =true;
                    sendemailtochecklistmember();
                }          
                else if(opty.AM_CP1__c == true && opty.FAE_CP1__c==true && opty.AM_CP2__c==true && opty.FAE_CP2__c==false && opty.PLM_CP2__c == false && opty.MarketSegment_CP2__c==false && opty.AM_CP3__c==false && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
                    checkflag3=true;
                    sendemailtochecklistmember();
                }
                else if(opty.AM_CP1__c == true && opty.FAE_CP1__c==true && opty.AM_CP2__c==true && opty.FAE_CP2__c==true && opty.PLM_CP2__c == true && opty.MarketSegment_CP2__c==true && opty.AM_CP3__c==false && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
                    checkflag1 = true;
                    sendemailtochecklistmember();
                }    
                else if(opty.AM_CP1__c == true && opty.FAE_CP1__c==true && opty.AM_CP2__c==true && opty.FAE_CP2__c==true && opty.PLM_CP2__c == true && opty.MarketSegment_CP2__c==true && opty.AM_CP3__c==true && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
                    checkflag3 = true;
                    sendemailtochecklistmember();
                }
            }
            else{                
                if(opty.AM_CP2__c==true && opty.FAE_CP2__c==false&& opty.PLM_CP2__c == false && opty.MarketSegment_CP2__c==false && opty.AM_CP3__c==false && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
                    checkflag3 = true;
                    system.debug('Inside CCP2 AE :' +checkflag3);
                    sendemailtochecklistmember();
                }
                else if(opty.AM_CP2__c==true && opty.FAE_CP2__c==true && opty.PLM_CP2__c == true && opty.MarketSegment_CP2__c==true && opty.AM_CP3__c==false && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
                    checkflag1 = true;
                    sendemailtochecklistmember();
                }    
                else if(opty.AM_CP2__c==true && opty.FAE_CP2__c==true && opty.PLM_CP2__c == true && opty.MarketSegment_CP2__c==true && opty.AM_CP3__c==true && opty.FAE_CP3__c==false && opty.PLM_CP3__c == false && opty.MarketSegment_CP3__c==false){
                    checkflag3 = true;
                    sendemailtochecklistmember();
                }           
            }
        }
    }
        
    Public void sendemailtochecklistmember(){
        try{
            system.debug('&&enter1&&' );
            List<User> userlist = new List<User>();
            String toAddressStr='' ;
            String targetid='';
            Opportunity opp =  listofOptyRec.get(0);
            if(checkflag1 == true){
                Opportunity optydetails = [select id,FAE_Head__c, FAE_Head__r.email,FAE_Head__r.id from opportunity where Id =: opp.id];
                //Set To address
                if(optydetails.FAE_Head__r.email != null){
                    //toAddressStr += optydetails.FAE_Head__r.email +',';
                    toAddressStr += optydetails.FAE_Head__r.id +',';
                }
            }
            
            if(checkflag2 == true){
                Opportunity optydetails = [select id,Accountid from opportunity where Id =: opp.id];
                Account_Team_Proxy__c atp = [select id,User__c,User__r.Email, User__r.id from Account_Team_Proxy__c where Account__c =: optydetails.accountid and ((Team_Role__c='Account Manager') OR(Team_Role__c='Primary Account Manager'))];
                if(atp.User__r.Email != null){
                    //toAddressStr += atp.User__r.Email + ',';
                    toAddressStr += atp.User__r.id + ',';
                }
            }
            
            if(checkflag3==true){
                List<Opportunity> listofoptyrec = [select id,Assigned_PLM__c,Assigned_Segment_Marketing__c,Assigned_PLM_UserId__c,Assigned_Segment_Marketing_UserId__c, FAE_Head__c, FAE_Head__r.email, FAE_Head__r.id from opportunity where Id =: opp.id];
                //List<String> listofuseremail = new List<String>();
                List<String> listofuserid = new List<String>();
                List<String> listofuser = new List<String>();
                for(Opportunity opt: listofoptyrec ){
                    /*if(opt.Assigned_PLM__c != null && opt.Assigned_PLM__c != ''){
                        listofuser.addAll(opt.Assigned_PLM__c.split('[,;]'));
                    }
                    if(opt.Assigned_Segment_Marketing__c != null && opt.Assigned_Segment_Marketing__c != ''){
                        listofuser.addAll(opt.Assigned_Segment_Marketing__c.split('[,;]'));
                    }*/
                    if(opt.Assigned_PLM_UserId__c != null && opt.Assigned_PLM_UserId__c != ''){
                        listofuser.addAll(opt.Assigned_PLM_UserId__c.split('[,;]'));
                    }
                    if(opt.Assigned_Segment_Marketing_UserId__c != null && opt.Assigned_Segment_Marketing_UserId__c != ''){
                        listofuser.addAll(opt.Assigned_Segment_Marketing_UserId__c.split('[,;]'));
                    }
                    if(opt.FAE_Head__r.email != null){
                        //listofuseremail.add(opt.FAE_Head__r.email);
                        listofuserid.add(opt.FAE_Head__r.id);
                    }
                }
                Set<String> listofuniqueuser = new Set<String>();
                listofuniqueuser.addAll(listofuser);
                //List<User> listofalluser = [Select id, email, name from user where name in: listofuser and UserType='Standard' and isActive=True and email LIKE '%globalfoundries.com'];
                List<User> listofalluser = [Select id, email, name from user where id in: listofuser and UserType='Standard' and isActive=True and email LIKE '%globalfoundries.com'];
                for(User us: listofalluser){
                    //listofuseremail.add(us.email);
                    listofuserid.add(us.id);

                }
                if(listofuserid.size() > 0){
                system.debug('List of user id : ' +listofuserid);
                    for(String st: listofuserid){
                        toAddressStr += st+',';
                    }    
                }
                system.debug('User Id list :' +toAddressStr);
            }
            
            
            //set<string> setEmailAddresses = new set<string>();
            set<string> setuserIds = new set<string>();
            system.debug('toAddressStr::'+toAddressStr);
            if(toAddressStr != null && toAddressStr != ''){ 
                setuserIds.addAll(toAddressStr.split('[,;]'));
            } 
            List<String> userEmailListToNotify = new List<String>();
            List<id> userIdListToNotify = new List<id>();
            if(setuserIds.size() > 0){
                userlist = [Select id, Email from User where id IN : setuserIds and UserType='Standard' and isActive=True and email LIKE '%globalfoundries.com'];
            }

            //Set Email Template
            EmailTemplate templateId = [Select id from EmailTemplate where name = 'OpportunityReviewChecklist'];
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            for(User usr: userlist ){
                userEmailListToNotify.add(usr.Email);
                userIdListToNotify.add(usr.id);
            }
            Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
            //String[] toAddresses = new String[] {usr.Email};
            String[] ccAddresses = new String[] {userInfo.getUserId()};
            mail.setWhatId(opp.id);
            mail.setTemplateID(templateId.Id); 
            //mail.setTargetObjectId(usr.id);
            mail.setTargetObjectId(userInfo.getUserId());
            //mail.setToAddresses(toAddresses);
            mail.setToAddresses(userEmailListToNotify);
            mail.setCcAddresses(ccAddresses);
            mail.setSaveAsActivity(false);
            mails.add(mail);
            Integer mailsCount = mails.size();
            if(mailsCount < 12)
            Messaging.sendEmail(mails);
            
        }catch(Exception e){
            GlobalUtility.logMessage('Error','Opportunity Control Point Approval','sendOpportunityEmail','','Exception while sending Email',String.valueof(e.getMessage()),'','Opportunity Management',e,0);
        }
    }
}