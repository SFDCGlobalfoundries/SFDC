/*
Type Name: MRS_Layer_Chip_Association_SWIFT_BINS
Author: Cognizant 
Created Date: 23-April-2014
Reason: MRS_Layer_Chip_Association__c  Before insert trigger
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date: 12-Nov-2014
Reason: Called the setLayerChipStatus() and setTimeStampForLayerChips() after performing all the operation in the trigger. modify value NA to N.A. Send_Prime_Data__c,Foundry_Prime_Remote_Jobview_Setup__c,Customer_Prime_Remote_Jobview_Setup__c,Foundry_Frame_Remote_Jobview_Setup__c,Customer_Frame_Remote_Jobview_Setup__c
??..
??..
 */


trigger MRS_Layer_Chip_Association_SWIFT_BINS on MRS_Layer_Chip_Association__c (before insert) {
    
    Set<String> setJobview = new Set<String>{'Not Required','Not gating mask release'};
    Set<String> setOrderType = new Set<String>{'New Prototype','Retrofit'};
    Set<String> setPTLP = new Set<String>{'M5 [Productization]','M6 [Technology Qualification]','M7 [Volume Qualification]','Production'};
     
    // Integration updating the DRW status when the status got updated before PTRF reached perform tapeout options
    list<MRS_Layer_Chip_Association__c > mrsListAsso = new list<MRS_Layer_Chip_Association__c>();
    map<string,string> mapMRS_PTRF = new map<string,string>();
    map<string,PTRF__c> mapPTRFNumber_PTRF = new map<string,PTRF__c>();
    mrsListAsso  = Trigger.new;
    for(MRS_Layer_Chip_Association__c mrsIns : mrsListAsso)
    {
        mapMRS_PTRF.put(mrsIns.id,mrsIns.PTRF__c);
    }
    if(mapMRS_PTRF.values() != null && mapMRS_PTRF.values().size() > 0)
    {
    /* Creating map of PTRF Id and PTRF object
    */
    for(PTRF__c ptrfIns : [select id,Customer_jobview__c,Foundry_Jobview__c,Order_Type__c,Mask_Set_Title_Name__c,MaskSetTitle__c,Process_Technology_Lifecycle_Phase__c,Status__c,Frame_Status__c,
                                    DRC_DRW_Status__c from PTRF__c where id IN : mapMRS_PTRF.values()]){
        mapPTRFNumber_PTRF.put(ptrfIns.id,ptrfIns);
       }
    } 
    for(MRS_Layer_Chip_Association__c mrsIns : mrsListAsso)
    {
      if(mapPTRFNumber_PTRF!=null && mapPTRFNumber_PTRF.containsKey(mrsIns.PTRF__c)){
      if(mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).MaskSetTitle__c!=null){
          mrsIns.Mask_Set_Title_Id__c = mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).MaskSetTitle__c;
          mrsIns.Mask_Set_Title_Id__c = mrsIns.Mask_Set_Title_Id__c.substring(0,15);
      }
      if(mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Status__c == 'Perform Tapeout Options' && mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).DRC_DRW_Status__c == 'DRW' && mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).DRC_DRW_Status__c != null && mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).DRC_DRW_Status__c != '' && mrsIns.Chip_Name__c != 'Frame' && mrsIns.DRT__c == null)
      {
       if(mrsIns.DRW__c == 'Not Ready') mrsIns.DRW__c = 'In Progress';
      }
      if(mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Status__c == 'Perform Tapeout Options' && mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).DRC_DRW_Status__c == 'Completed' && mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).DRC_DRW_Status__c != null && mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).DRC_DRW_Status__c != '' && mrsIns.Chip_Name__c != 'Frame' && mrsIns.DRT__c == null)
      {
        if(mrsIns.DRW__c == 'Not Ready') mrsIns.DRW__c = 'Done';
      }
      if(mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Status__c == 'Perform Tapeout Options' && mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Frame_Status__c == 'Completed' && mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Frame_Status__c != null && mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Frame_Status__c != '' && mrsIns.Chip_Name__c == 'Frame')
      {
           if(mrsIns.Foundry_Frame_Mockup__c == 'Not Ready')    mrsIns.Foundry_Frame_Mockup__c = 'Ready';
           if(mrsIns.Customer_Frame_Mockup__c == 'Not Ready')   mrsIns.Customer_Frame_Mockup__c = 'Ready';
           if(mrsIns.Foundry_Frame_Mockup__c == 'N.A.' && mrsIns.Customer_Frame_Mockup__c == 'N.A.' && mrsIns.Send_Frame_Data__c == 'Not Ready')    mrsIns.Send_Frame_Data__c = 'Ready';
      }
      if(mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Status__c == 'Perform Tapeout Options' && mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Frame_Status__c == 'Frame Generation' && mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Frame_Status__c != null && mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Frame_Status__c != '' && mrsIns.Chip_Name__c == 'Frame')
      {
       if(mrsIns.Customer_Frame_Mockup__c == 'Not Ready' || mrsIns.Foundry_Frame_Mockup__c == 'Not Ready' )
          {
          mrsIns.Send_Frame_Data__c = 'Not Ready';
          mrsIns.Send_Prime_Data__c = 'N.A.';
          mrsIns.Foundry_Prime_Remote_Jobview_Setup__c = 'N.A.';
          mrsIns.Customer_Prime_Remote_Jobview_Setup__c = 'N.A.';
          mrsIns.Foundry_Frame_Remote_Jobview_Setup__c= 'N.A.';
          mrsIns.Customer_Frame_Remote_Jobview_Setup__c= 'N.A.';
          if(mrsIns.Prime_MEBES_Received__c != 'N.A.')
            mrsIns.Prime_MEBES_Received__c = 'Not Ready';
          mrsIns.Frame_MEBES_Received__c = 'Not Done';
          if(mrsIns.Foundry_MEBES_Jobview__c!= 'N.A.')
            mrsIns.Foundry_MEBES_Jobview__c = 'Not Ready';
         if(mrsIns.Customer_MEBES_Jobview__c!= 'N.A.')
            mrsIns.Customer_MEBES_Jobview__c = 'Not Ready';
        if(mrsIns.Tech_Geo__c!=null){
            Double techGeo = Double.valueOf(mrsIns.Tech_Geo__c.toUppercase().substringBefore('UM').trim());
            /** Setting default values for Tapeout Centre,MDP,TDTI/MPW,Globalshuttle MEBES Jobviews. **/
            if(techGeo>0.02){
                mrsIns.TDTI_MPW_MEBES_Jobview__c = 'N.A.'; 
                if(mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Mask_Set_Title_Name__c.startsWith('MPW')) mrsIns.GlobalShuttle_MEBES_Jobview__c = 'Not Ready';
                else mrsIns.GlobalShuttle_MEBES_Jobview__c = 'N.A.';
            }else{
                mrsIns.GlobalShuttle_MEBES_Jobview__c = 'N.A.';
                if(mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Mask_Set_Title_Name__c.startsWith('MPW')) mrsIns.TDTI_MPW_MEBES_Jobview__c = 'Not Ready'; 
                else mrsIns.TDTI_MPW_MEBES_Jobview__c = 'N.A.';
            }
            //SWGP-347
            Double mdpTechGeoCutoff       = Double.valueOf( MRSHandlerUtilityExtn.loadEnvVariable('Swift_MDP_Tech_Geo_Cut_Off','0.022') );
            if(techGeo > mdpTechGeoCutoff){
                mrsIns.Tapeout_Centre_MEBES_Jobview__c = 'Not Ready';
                mrsIns.MDP_MEBES_Jobview__c = 'N.A.';
            }else{
                mrsIns.Tapeout_Centre_MEBES_Jobview__c = 'N.A.';
                mrsIns.MDP_MEBES_Jobview__c = 'Not Ready';
            }
            /** Setting default value for Tapeout Application MEBES Jobview. **/                                      
            if(techGeo<=0.18 && techGeo>=0.11 && (mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Order_Type__c == 'New Prototype') &&  setJobview.contains(mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Customer_jobview__c) && setJobview.contains(mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Foundry_Jobview__c)){                                  
                mrsIns.Tapeout_Applications_MEBES_Jobview__c = 'Not Ready';        
            }else if(techGeo<=0.09 && setOrderType.contains(mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Order_Type__c) && setJobview.contains(mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Customer_jobview__c) && setJobview.contains(mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Foundry_Jobview__c) && setPTLP.contains(mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Process_Technology_Lifecycle_Phase__c)){                                      
                mrsIns.Tapeout_Applications_MEBES_Jobview__c = 'Not Ready';    
            }else if(techGeo<=0.09 && (mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Order_Type__c == 'New Prototype') && setPTLP.contains(mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Process_Technology_Lifecycle_Phase__c) && ((mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Customer_jobview__c == 'Gating mask release') || (mapPTRFNumber_PTRF.get(mrsIns.PTRF__c).Foundry_Jobview__c == 'Gating mask release'))){
               mrsIns.Tapeout_Applications_MEBES_Jobview__c = 'N.A.'; 
            }else{                                       
                mrsIns.Tapeout_Applications_MEBES_Jobview__c = 'N.A.';
            } 
        }else{
            mrsIns.GlobalShuttle_MEBES_Jobview__c = 'N.A.';
            mrsIns.TDTI_MPW_MEBES_Jobview__c = 'N.A.';
            mrsIns.Tapeout_Centre_MEBES_Jobview__c = 'N.A.';
            mrsIns.MDP_MEBES_Jobview__c = 'N.A.';
            mrsIns.Tapeout_Applications_MEBES_Jobview__c = 'N.A.'; 
        }
       }
      }
      }
      //TASK-2440, TASK-2448
      if(mrsIns.Tech_Geo__c!=null){
            MRSHandlerUtilityExtn.setDefaultGDSOUTReview(mrsIns);//TASK-2440: Set Customer/Foundry GDSOUT REview as N.A. for all 22nm and below PTRF
            MRSHandlerUtilityExtn.setDefaultFrameMockupReview(mrsIns);//TASK-2448: Default Customer/Foundry Frame Mockup review to N.A. for 20nm and below
      }
      //End TASK-2440, TASK-2448
    }
    
    MRSHandlerUtility.setLayerChipStatus(trigger.new);
    MRSHandlerUtility.setTimeStampForLayerChips(trigger.new, null);
    
}