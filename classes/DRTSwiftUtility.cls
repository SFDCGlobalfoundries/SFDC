/*
Type Name: SwiftUtility
Author: Cognizant 
Created Date: 18-March-2014
Reason: This is a general utility class used for all generic functionalities across the scope of the project, 
        not pertaining to any specific module.
Change History:
Cognizant            18032014     -      Apex code created
Cognizant            29042014     -      Modified method checkChipUniqueness.
 */

public class DRTSwiftUtility {

     /**
        This method checks whether DRT package objects are in sync or not.

        @method name: checkDRTpackageSync
        @parameter:   Set of DRT ID
        @return :     None.
     **/

         public static void checkDRTpackageSync(Set<String> DRTID){
                   
            map<id,list<PRIME_DRT_Layer_Association__c>> mapdrtLayAss = new map<id,list<PRIME_DRT_Layer_Association__c>>();
            map<id,list<PRIME_DRT_Chip_Association__c>> mapdrtChipAss = new map<id,list<PRIME_DRT_Chip_Association__c>>();
            map<id,list<PRIME_DRT_Chip_Layer_Summary__c>> mapdrtChipLayAss = new map<id,list<PRIME_DRT_Chip_Layer_Summary__c>>();
            map<id,list<DRT_PTRF_Association__c>> mapdrtPTRFAss = new map<id,list<DRT_PTRF_Association__c>>();
            map<id,list<Frame_DRT_Association__c>> mapdrtFrameAss = new map<id,list<Frame_DRT_Association__c>>();
            map<id,drt__c> mapDRT = new map<id,drt__c>();
            string[] objRecName;
            try
            {
            if(DRTID != null && DRTID.size()>0)
            {                              
                list<string> lstDRTIds = new list<string>();
                lstDRTIds.addAll(DRTID);
                
                //Create a map of all DRT IDs with corresponding child object records
                for(drt__c iDRT : [select Synced_with_Oracle_DB__c from DRT__c where Id  in : DRTID])
                    {
                        mapDRT.put(iDRT.id,iDRt);
                    }
                
                
                for(PRIME_DRT_Layer_Association__c dLayer : [select Synced_with_Oracle_DB__c,drt__c from PRIME_DRT_Layer_Association__c where DRT__c in :DRTID and IsSoftDeleted__c = False])
                {                 
                    if(mapdrtLayAss!=null && mapdrtLayAss.keySet().size()>0 && mapdrtLayAss.containskey(dLayer.drt__c)){
                        list<PRIME_DRT_Layer_Association__c> temp = new list<PRIME_DRT_Layer_Association__c>();
                        temp = mapdrtLayAss.get(dLayer.drt__c);
                        temp.add(dLayer);
                        mapdrtLayAss.put(dLayer.drt__c,temp);
                    }
                    else{
                        list<PRIME_DRT_Layer_Association__c> temp = new list<PRIME_DRT_Layer_Association__c>();
                        temp.add(dLayer);
                        mapdrtLayAss.put(dLayer.drt__c,temp);
                    }
                }
                
                
                for(PRIME_DRT_Chip_Association__c dChip :[select drt__c,Synced_with_Oracle_DB__c from PRIME_DRT_Chip_Association__c where drt__c in :DRTID and IsSoftDeleted__c = False])
                {                 
                    if(mapdrtChipAss!=null && mapdrtChipAss.keySet().size()>0 && mapdrtChipAss.containskey(dChip.drt__c)){
                        list<PRIME_DRT_Chip_Association__c> temp = new list<PRIME_DRT_Chip_Association__c>();
                        temp = mapdrtChipAss.get(dChip.drt__c);
                        temp.add(dChip);
                        mapdrtChipAss.put(dChip.drt__c,temp);
                    }
                    else{
                        list<PRIME_DRT_Chip_Association__c> temp = new list<PRIME_DRT_Chip_Association__c>();
                        temp.add(dChip);
                        mapdrtChipAss.put(dChip.drt__c,temp);
                    }
                }
                      
                
                for(PRIME_DRT_Chip_Layer_Summary__c dChipLayer : [select drt_ID__c,Synced_with_Oracle_DB__c from PRIME_DRT_Chip_Layer_Summary__c where Chip__r.IsSoftDeleted__c = False and Layer__r.IsSoftDeleted__c = False and Chip__r.DRT__c  in :DRTID])
                {                 
                    if(mapdrtChipLayAss!=null && mapdrtChipLayAss.keySet().size()>0 && mapdrtChipLayAss.containskey(dChipLayer.drt_ID__c)){
                        list<PRIME_DRT_Chip_Layer_Summary__c> temp = new list<PRIME_DRT_Chip_Layer_Summary__c>();
                        temp = mapdrtChipLayAss.get(dChipLayer.drt_ID__c);
                        temp.add(dChipLayer);
                        mapdrtChipLayAss.put(dChipLayer.drt_ID__c,temp);
                    }
                    else{
                        list<PRIME_DRT_Chip_Layer_Summary__c> temp = new list<PRIME_DRT_Chip_Layer_Summary__c>();
                        temp.add(dChipLayer);
                        mapdrtChipLayAss.put(dChipLayer.drt_ID__c,temp);
                    }
                }
                
                
                for(DRT_PTRF_Association__c dPTRF : [select drt__c,Synced_with_Oracle_DB__c from DRT_PTRF_Association__c where DRT__c in :DRTID])
                {                 
                    if(mapdrtPTRFAss!=null && mapdrtPTRFAss.keySet().size()>0 && mapdrtPTRFAss.containskey(dPTRF.drt__c)){
                        list<DRT_PTRF_Association__c> temp = new list<DRT_PTRF_Association__c>();
                        temp = mapdrtPTRFAss.get(dPTRF.drt__c);
                        temp.add(dPTRF);
                        mapdrtPTRFAss.put(dPTRF.drt__c,temp);
                    }
                    else{
                        list<DRT_PTRF_Association__c> temp = new list<DRT_PTRF_Association__c>();
                        temp.add(dPTRF);
                        mapdrtPTRFAss.put(dPTRF.drt__c,temp);
                    }
                }
                
                
                for(Frame_DRT_Association__c dFrame : [select drt__c,Synced_with_Oracle_DB__c from Frame_DRT_Association__c where DRT__c in :DRTID])
                {                 
                    if(mapdrtFrameAss!=null && mapdrtFrameAss.keySet().size()>0 && mapdrtFrameAss.containskey(dFrame.drt__c)){
                        list<Frame_DRT_Association__c> temp = new list<Frame_DRT_Association__c>();
                        temp = mapdrtFrameAss.get(dFrame.drt__c);
                        temp.add(dFrame);
                        mapdrtFrameAss.put(dFrame.drt__c,temp);
                    }
                    else{
                        list<Frame_DRT_Association__c> temp = new list<Frame_DRT_Association__c>();
                        temp.add(dFrame);
                        mapdrtFrameAss.put(dFrame.drt__c,temp);
                    }
                }
                set<ID> setDRToutofSync = new set<ID>();
                
            if(lstDRTIds!=null && lstDRTIds.size()>0){              

                for(DRT__C obj : mapDRT.values()){
                        if(obj.Synced_with_Oracle_DB__c == FALSE){
                            //
                            setDRToutofSync.add(obj.id);   
                        } 
                    }
                for(ID iDRTID :lstDRTIds){                   
                   if(mapdrtLayAss!=null && mapdrtLayAss.containskey(iDRTID) && mapdrtLayAss.get(iDRTID).size()>0){
                        for(PRIME_DRT_Layer_Association__c obj : mapdrtLayAss.get(iDRTID)){
                            //
                            if(obj.Synced_with_Oracle_DB__c == FALSE)
                                setDRToutofSync.add(obj.drt__c);
                        }        
                    }                  
                    if(mapdrtChipAss!=null && mapdrtChipAss.containskey(iDRTID) && mapdrtChipAss.get(iDRTID).size()>0){
                        for(PRIME_DRT_Chip_Association__c obj : mapdrtChipAss.get(iDRTID)){
                            if(obj.Synced_with_Oracle_DB__c == FALSE)
                                setDRToutofSync.add(obj.drt__c);
                        }        
                    }                   
                    if(mapdrtChipLayAss!=null && mapdrtChipLayAss.containskey(iDRTID) && mapdrtChipLayAss.get(iDRTID).size()>0){
                        for(PRIME_DRT_Chip_Layer_Summary__c obj : mapdrtChipLayAss.get(iDRTID)){
                            if(obj.Synced_with_Oracle_DB__c == FALSE)
                                setDRToutofSync.add(obj.drt_ID__c);
                        }        
                    }
                    
                    if(mapdrtPTRFAss!=null && mapdrtPTRFAss.containskey(iDRTID) && mapdrtPTRFAss.get(iDRTID).size()>0){
                        for(DRT_PTRF_Association__c obj : mapdrtPTRFAss.get(iDRTID)){
                            if(obj.Synced_with_Oracle_DB__c == FALSE)
                                setDRToutofSync.add(obj.drt__c);
                        }        
                    }
                    
                    if(mapdrtFrameAss!=null && mapdrtFrameAss.containskey(iDRTID) && mapdrtFrameAss.get(iDRTID).size()>0){
                        for(Frame_DRT_Association__c obj : mapdrtFrameAss.get(iDRTID)){
                            if(obj.Synced_with_Oracle_DB__c == FALSE)
                                setDRToutofSync.add(obj.drt__c);
                        }        
                    }
                }
            }

            list<DRT__c> lstDRTupdate = new list<DRT__c>();
            lstDRTupdate = [select id,Name from DRT__c where id in :DRTID and Id NOT in :setDRToutofSync];
            if(lstDRTupdate!=null && lstDRTupdate.size()>0){
                for(DRT__c temp:lstDRTupdate){
                     objRecName.add(temp.Name);
                    temp.DRT_Package_Sync__c = TRUE;                                  
                }
                
                update lstDRTupdate;
                
            }
           }
           }
           catch(Exception e)
           {
           DRTHandlerUtility.handleError(e,'Exception on DRT Sync',objRecName);
           } 
   }
   
   /**
        This method creates Mask Set Title for PTRF if Mask Set Title is not already present in system.

        @method name: createMSTfromPTRF
        @parameter:   string Mask Set Title, string PTRF Number 
        @return :     void
   **/
   @future
   public static void createMSTfromPTRF(string mstvalue, string ptrfNumber, string reticleType){
       list<Mask_Set_Title__c> mst = new list<Mask_Set_Title__c>();
       list<ptrf__c> lstPTRF = new list<ptrf__c>();
       lstPTRF=[select id,status_from_dotNET__c,MaskSetTitle__c,Customer__c,Mask_Set_Title__c,status__c from ptrf__c where MaskSetTitle__c=null and Mask_Set_Title__c=:mstvalue and status__c='Open' and Name=:ptrfNumber];
       if(mstvalue!=null){
           mst =[select id,name from Mask_Set_Title__c where name =:mstvalue];
           if(mst.size()<1)
           {
              mst.add(new Mask_Set_Title__c(Name=mstvalue,Status__c='Active',Reticle_Type__c=reticleType));
              try{
                  insert mst;
              }catch(exception e){}
          }
       
       } 
       list<Mask_Set_Title__c> iMST = new list<Mask_Set_Title__c>();
       iMST=[select id from Mask_Set_Title__c where name=:mstvalue limit 1];
       if(lstPTRF.size()>0 && iMST.size()>0){
           for(ptrf__c ptrf :lstPTRF){
               if(ptrf.MaskSetTitle__c==Null){
                   ptrf.MaskSetTitle__c = iMST[0].id;
               }               
               if(ptrf.status_from_dotNET__c=='Perform Tapeout Options'){
                   ptrf.status__c = 'Perform Tapeout Options';
               }
           }
           update lstPTRF;
       }
           
   }

   public static void syncdrtPTRFdeletion(list<string> lstdrtPTRF){
       if(system.isFuture() || system.isBatch()){
           syncdrtPTRFdeletionNonFuture(lstdrtPTRF);
       }
       else if (limits.getLimitFutureCalls() >0){
           syncdrtPTRFdeletionFuture(lstdrtPTRF);    
       }
   }
   @Future(callout=true)
   public static void syncdrtPTRFdeletionFuture(list<string> lstdrtPTRF){
       syncdrtPTRFdeletionNonFuture(lstdrtPTRF);
   }
   public static void syncdrtPTRFdeletionNonFuture(list<string> lstdrtPTRF){
        list<SWIFTDRTPTRFDeleteService.ProcessType> lstdelrecords = new list<SWIFTDRTPTRFDeleteService.ProcessType>();
        system.debug('****lstdrtPTRF[0]'+lstdrtPTRF[0]);
        for(string temp :lstdrtPTRF){
            if(temp.split('::',4)[0]!=null && temp.split('::',4)[0]!='' && temp.split('::',4)[1]!=null && temp.split('::',4)[1]!='' && temp.split('::',4)[2]!=null && temp.split('::',4)[2]!='' && temp.split('::',4)[3]!=null && temp.split('::',4)[3]!=''){
                SWIFTDRTPTRFDeleteService.ProcessType rec = new SWIFTDRTPTRFDeleteService.ProcessType();
                rec.SFDCID = temp.split('::',4)[0];
                rec.DRTNAME = temp.split('::',4)[1];
                rec.PTRFNUMBER = temp.split('::',4)[2];
                rec.SYNCREQUESTTIMESTAMP = temp.split('::',4)[3].replaceFirst(' ','T')+'.000Z';
                //rec.SYNCREQUESTTIMESTAMP = temp.split('::',4)[3];
                rec.OrgID = UserInfo.getOrganizationId();
                lstdelrecords.add(rec);
            }
        }
        SWIFTDRTPTRFDeleteService.SFOraclePTRFDelete_pt stub = new SWIFTDRTPTRFDeleteService.SFOraclePTRFDelete_pt();
         //Including SSL Certificate      
        String certificate = Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE').value__c;
        if(certificate != NULL && certificate != 'NO'){
            stub.clientCertName_x = certificate ;
        }
        /******/
        stub.timeout_x = 100000;
        if(!Test.isRunningTest() && lstdelrecords.size()>0 ){
            system.debug('***lstdelrecords:'+lstdelrecords[0].SYNCREQUESTTIMESTAMP);
            stub.process(lstdelrecords);
        }
   }
   
   
   
}