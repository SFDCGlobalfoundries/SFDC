/*
Author: Cognizant
Company: Cognizant Tech Solutions
Description: Test Class for Trigger PTRF_SWIFT_AUPD
History: Modified by Meenakshmi Goswami to increase code coverage
created     06/15/2014     
*====================================================================
*/
@isTest(SeeAllData=TRUE)
private class PTRF_SWIFT_AUPD_Test{
public static testmethod void testPTRFDRWupdate()
{
Mask_Set_Title__c mst = SwiftDataUtilityTest.createMST('TESTU');
insert mst;                                

list<DRT__c> lstDRT = new list<DRT__c>();
lstDRT.add( new DRT__c(Name='DRT_PRIME_prtf1',Type__c = 'PRIME'));
lstDRT.add(new DRT__c(Name='DRT_FRAME_prtf1',Type__c = 'FRAME'));
lstDRT.add( new DRT__c(Name='DRT_PRIME_prtf2',Type__c = 'PRIME'));
lstDRT.add(new DRT__c(Name='DRT_FRAME_prtf2',Type__c = 'FRAME'));
insert lstDRT; 

PTRF__c ptrf1 = new PTRF__c(Name='ACOU1',Order_Type__c = 'testOrder',Frame_Mockup__c=true,
                        Recticle_Type__c='Multi Layer Reticle (MLR)',Customer_jobview__c='Gating Mask Release',
                        DRC_Only__c=true);
insert ptrf1;

MRS__c mrs1 = new MRS__c(Full_Sync__c =true, Synced_with_Oracle_DB__c=false,MRS_Package_Sync__c=false, Mask_Set_Title__c=mst.Id);
insert mrs1; 
MRS_Layer_Association__c mrsLayer1 = new MRS_Layer_Association__c(Name ='layer001',Tech_Geo__c = '0.065UM',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '899',
                                                                           Layer_Name__c = 'testLayer001',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs1.id);
insert mrslayer1;

MRS_Layer_Association__c mrsLayer2 = new MRS_Layer_Association__c(Name ='layer002',Tech_Geo__c = '0.065UM',
                                                                           Synced_with_Oracle_DB__c=false,
                                                                           Mask_Layer_Rev__c = '899',
                                                                           Layer_Name__c = 'testLayer002',
                                                                           Layer_Status__c = 'Not Ready',
                                                                           mrs__c = mrs1.id);
insert mrslayer2;  
                                                                                                                                          
MRS_Chip_Details__c mrsChip1 = new MRS_Chip_Details__c(Name='chip001',mrs__c = mrs1.id);
insert mrsChip1;  
MRS_Chip_Details__c mrsChip2 = new MRS_Chip_Details__c(Name='Frame',mrs__c = mrs1.id);
insert mrsChip2;   
list<MRS_Layer_Chip_Association__c> lstLayerChip = new list<MRS_Layer_Chip_Association__c>();                                                 
MRS_Layer_Chip_Association__c layerChip1 = new MRS_Layer_Chip_Association__c (Name='layerChip001',Send_Prime_Data__c = 'Not Done',DRW__c = 'In Progress',Tech_Geo__c='0.03',Layer__c=mrsLayer1.Id, Chip__c=mrsChip1.Id,PTRF__c=ptrf1.Id);
MRS_Layer_Chip_Association__c layerChip2 = new MRS_Layer_Chip_Association__c (Name='layerFrameChip',Send_Prime_Data__c = 'Not Done',Tech_Geo__c='0.18',Layer__c=mrsLayer1.Id, Chip__c=mrsChip2.Id,PTRF__c=ptrf1.Id,Customer_Frame_Mockup__c = 'Not Ready');

MRS_Layer_Chip_Association__c layerChip3 = new MRS_Layer_Chip_Association__c (Name='layerChip002',Send_Prime_Data__c = 'Not Done',DRW__c = 'Not Ready',Tech_Geo__c='0.09',Layer__c=mrsLayer2.Id, Chip__c=mrsChip1.Id,PTRF__c=ptrf1.Id);
MRS_Layer_Chip_Association__c layerChip4 = new MRS_Layer_Chip_Association__c (Name='layerFrameChip2',Send_Prime_Data__c = 'Not Done',Tech_Geo__c='0.03',Layer__c=mrsLayer1.Id, Chip__c=mrsChip2.Id,PTRF__c=ptrf1.Id,Customer_Frame_Mockup__c = 'Not Ready');
lstLayerChip.add(layerChip1);
lstLayerChip.add(layerChip2);
insert lstLayerChip ;


ptrf1.DRW_Disposition__c = 'Violations waive';
ptrf1.PTRF_DRC_Option__c ='Foundry run and gating mask release';
ptrf1.DRC_DRW_Status__c  ='DRW';
ptrf1.DRC_Rerun__c = false;
ptrf1.Frame_DRT__c='DRT_FRAME_prtf2';
ptrf1.Prime_DRT__c = 'DRT_PRIME_prtf2';
update ptrf1;
set<string> ptrfName = new set<string>();
ptrfName.add('PTRF');
set<id> ptrfId = new set<id>();
ptrfId.add(ptrf1.id);

Test.setReadOnlyApplicationMode(true);
    try{
    PTRF_FrameGen_DRW_StatusUpdate.FrameGen_FGRerunStatus(ptrfId,ptrfName);
    }catch(exception exp){}
    Test.setReadOnlyApplicationMode(false);
    PTRF_FrameGen_DRW_StatusUpdate.FrameGen_DRWStartStatus(ptrfId,ptrfName);


list<DRT_PTRF_Association__c> lstDRTptrf = new list<DRT_PTRF_Association__c>();
lstDRTptrf.add(new DRT_PTRF_Association__c(DRT__c=lstDRT[0].id,PTRF__c=ptrf1.id));
lstDRTptrf.add(new DRT_PTRF_Association__c(DRT__c=lstDRT[1].id,PTRF__c=ptrf1.id));
lstDRTptrf.add(new DRT_PTRF_Association__c(DRT__c=lstDRT[2].id,PTRF__c=ptrf1.id));
lstDRTptrf.add(new DRT_PTRF_Association__c(DRT__c=lstDRT[3].id,PTRF__c=ptrf1.id));
insert lstDRTptrf;

ptrf1.Frame_Status__c='Completed';
ptrf1.Frame_DRT__c='DRT_FRAME_prtf1';
ptrf1.Prime_DRT__c = 'DRT_PRIME_prtf1';
update ptrf1;

ptrfName = new set<string>();
ptrfName.add('PTRF');
ptrfId = new set<id>();
ptrfId.add(ptrf1.id);

Test.setReadOnlyApplicationMode(true);
    try{
    PTRF_FrameGen_DRW_StatusUpdate.FrameGen_FGRerunStatus(ptrfId,ptrfName);
    }catch(exception exp){}
    Test.setReadOnlyApplicationMode(false);
    PTRF_FrameGen_DRW_StatusUpdate.FrameGen_DRWCompletedStatus(ptrfId,ptrfName);


ptrf1.DRC_DRW_Status__c  ='DRW';
ptrf1.DRC_Rerun__c = true;
ptrf1.Frame_DRT__c=null;
ptrf1.Prime_DRT__c = null;
update ptrf1;

ptrf1.DRC_DRW_Status__c  ='Completed';
ptrf1.DRC_Rerun__c = false;
ptrf1.PTRF_DRC_Option__c ='Foundry run and gating mask release';
ptrf1.DRW_Disposition__c = 'Violations waive';
ptrf1.Frame_DRT__c='DRT_FRAME_prtf3';
ptrf1.Prime_DRT__c = 'DRT_PRIME_prtf3';
update ptrf1;

ptrfName = new set<string>();
ptrfName.add('PTRF');
ptrfId = new set<id>();
ptrfId.add(ptrf1.id);

Test.setReadOnlyApplicationMode(true);
    try{
    PTRF_FrameGen_DRW_StatusUpdate.FrameGen_FGRerunStatus(ptrfId,ptrfName);
    }catch(exception exp){}
    Test.setReadOnlyApplicationMode(false);
    PTRF_FrameGen_DRW_StatusUpdate.FrameGen_DRWNoOrderStatus(ptrfId,ptrfName);


//***********
ptrf1.DRC_DRW_Status__c='Rerun';
ptrf1.DRC_Rerun__c = true;
ptrf1.Frame_DRT__c=null;
ptrf1.Prime_DRT__c = null;
update ptrf1;

ptrf1.DRC_DRW_Status__c='Completed';
ptrf1.DRC_Rerun__c = true;
ptrf1.Frame_DRT__c=null;
ptrf1.Prime_DRT__c = null;
update ptrf1;

ptrf1.DRC_DRW_Status__c='Start';
ptrf1.DRC_Rerun__c = true;
ptrf1.Frame_DRT__c=null;
ptrf1.Prime_DRT__c = null;
update ptrf1;

//*********

ptrf1.Frame_Status__c='Completed';
update ptrf1;
ptrfName = new set<string>();
ptrfName.add('PTRF');
ptrfId = new set<id>();
ptrfId.add(ptrf1.id);

    Test.setReadOnlyApplicationMode(true);
    try{
    PTRF_FrameGen_DRW_StatusUpdate.FrameGen_FGRerunStatus(ptrfId,ptrfName);
    }catch(exception exp){}
    Test.setReadOnlyApplicationMode(false);
    PTRF_FrameGen_DRW_StatusUpdate.FrameGen_FGStatus(ptrfId,ptrfName);



ptrf1.Frame_Status__c='Frame Generation';
update ptrf1;
ptrfName = new set<string>();
ptrfName.add('PTRF');
ptrfId = new set<id>();
ptrfId.add(ptrf1.id);

   Test.setReadOnlyApplicationMode(true);
    try{
    PTRF_FrameGen_DRW_StatusUpdate.FrameGen_FGRerunStatus(ptrfId,ptrfName);
    }catch(exception exp){}
    Test.setReadOnlyApplicationMode(false);
    PTRF_FrameGen_DRW_StatusUpdate.FrameGen_FGRerunStatus(ptrfId,ptrfName);

    

ptrf1.Prime_TapeOut__c =true;
ptrf1.PTRF_DRC_Option__c = 'Foundry run and gating mask release' ;
ptrf1.DRC_DRW_Status__c = 'Completed';
update ptrf1;

}
}