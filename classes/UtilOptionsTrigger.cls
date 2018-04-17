/**
@Author < Gopi koka >
@name <utilOptionsTrigger>
@CreateDate < 04/19/2017 >
@Description < utility class for Optiontrigger>
@Version <1.0>
*/
global class UtilOptionsTrigger{
    public static String create_ERP_DEVICE(List<Customer_Requirement__c> opts){
        List<ERP_Device__c> edListInsUpdate = new List<ERP_Device__c>();
        Map<String,ERP_Device__c> existingERP =  new Map<String,ERP_Device__c>();
        List<String> lstdpn = New List<String>();
        String updatedERP = '';
        ERP_Device__c ed = new ERP_Device__c();
        
        for(Customer_Requirement__c customreq : opts){
            String partNumber = customreq.Deliverable_Part_Number_DPN_Formula__c;
            String device = customreq.Device__c;
            if(partNumber != null && partNumber != ''){
                lstdpn.add(partNumber);
            }
        }
        for(ERP_Device__c existing:[Select Id,Name,Part_Number__c from ERP_Device__c where Part_Number__c IN : lstdpn]){
            existingERP.put(existing.Part_Number__c,existing);
        }
        
       
        for(Customer_Requirement__c customerReq:[Select id,Name,Device__c,Device__r.PSC_Read__c,Device__r.PSA_Read__c,FAB__c,Option_Stage__c,Deliverable_Part_Number_DPN_Formula__c,Deliverable_Type__c,
                                                           Product_Type__c,Reliability_Grade__c,End_customer_project__c,Deliverable_Type_Formula__c,SiTechnology__c,Sub_Brand__c,Brand__c,Wafer_FAB_sourcing_location_wafer_size__c,
                                                           Device__r.Is_ITAR__c,Device__r.ITAR_Flag__c,Device__r.Market_Segment__c,Device__r.Stage__c,Manufacturing_Deliverables__c,
                                                           Device__r.Business_Unit__c,Device__r.Product_Line__c,Device__r.End_Application__c,
                                                           Device__r.CRMDID__c,Device__r.Fab__c,Device__r.Process_Geometry_NM__c,Device__r.Base_Device__c,
                                                           Design__c,Design__r.Package_total_lead_count__c,Device__r.Assigned_Process_ID__c,Brand_and_Sub_brand__c,
                                                           Design__r.Last_Metal_Indicator__c,Design__r.Package_style__c,Device__r.STF_Process_ID__c,
                                                           Device__r.Back_Side_Grind__c,MD_part_name__c,Device__r.Deliverable_Type__c,Deliverable_Part_Number_DPN__c,
                                                           Device__r.No_of_Mask_Layers__c,Device__r.Geometry__c,Device__r.Assigned_Process_ID__r.Name,Device__r.Primary_Option__c,
                                                           Opportunity__c,Opportunity__r.Net_Parts_Per_Wafer__c,Opportunity__r.Target_Process_Node__c,Design__r.Total_Levels_of_Metal__c,
                                                           Modules__c,Modules__r.Module_test_type_platform__c,Modules__r.Module_Burn_In__c,Device__r.Primary_Option__r.Name,Opportunity__r.Name,SiTechnology__r.Name,
                                                           (SELECT id,Back_side_grind__c,Total_number_of_masks_required_to_build__c,Active_side_interconnect_technology__c FROM Wafer_Data__r),
                                                           (SELECT Device__c,Product_Type__c,Part_Reliability_Grade__c,Name,Opportunity__c,Deliverable_Type__c,Part_Number__c,Technology__c,Subbrand__c,
                                                           MD_part_name__c,Brand__c,Option_ID__c,PSCNew__c,PSANew__c,ITARNew__c,Market_Segment__c,Business_Unit__c,Product_Line__c,CRMDID__c,Fab__c,Geometry__c,
                                                           Stage__c,Base_Device__c,End_Application__c,Process_ID__c,Process_Id_Name__c,Device_Life_Cycle_Stage__c,Mask_Layer_Count__c,Chips_per_Wafer__c,Target_Process_Node__c,
                                                           Last_Level_of_Metal__c,Levels_Of_Metal__c,Package_Type__c,Module_Tester_Type__c,Test_wafer__c,Module_Test_Flag__c,Burn_In__c,Back_Side_Grind__c,Wafer_Diameter__c,Bonding_Type__c FROM ERP_Devices__r)
                              FROM Customer_Requirement__c WHERE id in : opts]){                              
            if((customerReq.Option_Stage__c == 'Reconciliation' || customerReq.Option_Stage__c == 'Design Execution' || customerReq.Option_Stage__c == 'Prototype Fulfillment' || customerReq.Option_Stage__c == 'Customer Decision' || customerReq.Option_Stage__c == 'Production')  && customerReq.Deliverable_Part_Number_DPN_Formula__c != null ){                
                
                if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Device__c != customerReq.Device__c){                    
                    updatedERP += 'Device, ';
                }                
                ed.Device__c = customerReq.Device__c;                
                
                if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Product_Type__c != customerReq.Product_Type__c){                    
                    updatedERP += 'Product Type, ';
                }                
                ed.Product_Type__c =customerReq.Product_Type__c;                
                
                if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Part_Reliability_Grade__c != customerReq.Reliability_Grade__c){                    
                    updatedERP += 'Reliability Grade, ';
                }
                ed.Part_Reliability_Grade__c = customerReq.Reliability_Grade__c;
               
                ed.Name = customerReq.End_customer_project__c;
                
                if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Opportunity__c != customerReq.Opportunity__c){                    
                    updatedERP += 'Opportunity, ';
                }
                ed.Opportunity__c = customerReq.Opportunity__c;
                
                if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Deliverable_Type__c != customerReq.Deliverable_Type__c){                    
                    updatedERP += 'Deliverable Type, ';
                }
                ed.Deliverable_Type__c = customerReq.Deliverable_Type__c;
                
                if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Part_Number__c != customerReq.Deliverable_Part_Number_DPN__c){                    
                    updatedERP += 'Part Number, ';
                }
                ed.Part_Number__c = customerReq.Deliverable_Part_Number_DPN__c; //ed.partnumber length should increase
                                
                if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Technology__c != customerReq.SiTechnology__r.Name){                    
                    updatedERP += 'Technology, ';
                }
                ed.Technology__c = customerReq.SiTechnology__r.Name;
                
                if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Name != customerReq.MD_part_name__c){                   
                    updatedERP += 'Name, ';
                }
                ed.Name = customerReq.MD_part_name__c;
               
                if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Subbrand__c != customerReq.Sub_Brand__c){                     
                    updatedERP += 'Subbrand, ';
                }
                ed.Subbrand__c = customerReq.Sub_Brand__c;
                
                if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].MD_part_name__c != customerReq.MD_part_name__c){                   
                    updatedERP += 'MD Part Name, ';
                }
                ed.MD_part_name__c = customerReq.MD_part_name__c;
                
                if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Brand__c != customerReq.Brand__c){                    
                    updatedERP += 'Brand, ';
                }
                ed.Brand__c = customerReq.Brand__c;
                
                Set<String> multiselectValues = new Set<String>();
                if(customerReq.Manufacturing_Deliverables__c!=null){
                    multiSelectValues.addAll(customerReq.Manufacturing_Deliverables__c.split(';'));
                }
                if(multiSelectValues.contains('Wafer Test')){                                        
                    ed.Test_wafer__c = 'Y'; 
                }else{                    
                    ed.Test_wafer__c = 'N';
                }                
                if(multiSelectValues.contains('Module Test')){                                  
                    ed.Module_Test_Flag__c = 'Y';
                }else{                     
                    ed.Module_Test_Flag__c = 'N'; 
                }
                
                if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Option_ID__c != customerReq.Name){                    
                    updatedERP += 'Option, ';
                }
                ed.Option_ID__c = customerReq.Name;
                
                ed.Option__c = customerReq.id;
                                
                if(customerReq.Wafer_FAB_sourcing_location_wafer_size__c != null && customerReq.Wafer_FAB_sourcing_location_wafer_size__c.contains('300')){                     
                    ed.Wafer_Diameter__c = 300;                                        
                }                
                else if(customerReq.Wafer_FAB_sourcing_location_wafer_size__c != null && customerReq.Wafer_FAB_sourcing_location_wafer_size__c.contains('200')){                                        
                    ed.Wafer_Diameter__c = 200;                    
                }
                /*if(customerReq.Fab__c != null){
                    if(customerReq.Fab__c == 'FAB 1' || customerReq.Fab__c == 'FAB 7' || customerReq.Fab__c == 'FAB 8' || customerReq.Fab__c == 'FAB 10'){
                        ed.Wafer_Diameter__c = 300;
                    }else{
                        ed.Wafer_Diameter__c = 200;
                    }
                }*/
                //Device Mapping
                if(customerReq.Device__c!=null){
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].PSCNew__c != customerReq.Device__r.PSC_Read__c){                        
                        updatedERP += 'PSC, ';
                    }
                    ed.PSCNew__c = customerReq.Device__r.PSC_Read__c;
                    
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].PSANew__c != customerReq.Device__r.PSA_Read__c){                        
                        updatedERP += 'PSA, ';
                    }
                    ed.PSANew__c = customerReq.Device__r.PSA_Read__c;
                    
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].ITARNew__c != customerReq.Device__r.ITAR_Flag__c){                        
                        updatedERP += 'ITAR, ';
                    }
                    ed.ITARNew__c = customerReq.Device__r.ITAR_Flag__c;
                    
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Market_Segment__c != customerReq.Device__r.Market_Segment__c){                        
                        updatedERP += 'Market Segment, ';
                    }
                    ed.Market_Segment__c = customerReq.Device__r.Market_Segment__c;
                   
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Business_Unit__c != customerReq.Device__r.Business_Unit__c){                        
                        updatedERP += 'Business Unit, ';
                    }
                    ed.Business_Unit__c = customerReq.Device__r.Business_Unit__c;
                    
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Product_Line__c != customerReq.Device__r.Product_Line__c){                        
                        updatedERP += 'Product Line, ';
                    }
                    ed.Product_Line__c = customerReq.Device__r.Product_Line__c;
                    
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].CRMDID__c != customerReq.Device__r.CRMDID__c){                        
                        updatedERP += 'CRMDID, ';
                    }
                    ed.CRMDID__c = customerReq.Device__r.CRMDID__c;
                    
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Fab__c != customerReq.Device__r.Fab__c){                        
                        updatedERP += 'Fab, ';
                    }
                    ed.Fab__c = customerReq.Device__r.Fab__c;
                    
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Geometry__c != customerReq.Device__r.Geometry__c){                        
                        updatedERP += 'Geometry, ';
                    }
                    ed.Geometry__c = customerReq.Device__r.Geometry__c;
                    
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Stage__c != customerReq.Device__r.Stage__c){                        
                        updatedERP += 'Stage, ';
                    }
                    ed.Stage__c = customerReq.Device__r.Stage__c;
                    
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Base_Device__c != customerReq.Device__r.Base_Device__c){                        
                        updatedERP += 'Base Device, ';
                    }
                    ed.Base_Device__c = customerReq.Device__r.Base_Device__c;
                    
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].End_Application__c != customerReq.Device__r.End_Application__c){                        
                        updatedERP += 'End Application, ';
                    }
                    ed.End_Application__c = customerReq.Device__r.End_Application__c;
                    
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Process_ID__c != customerReq.Device__r.Assigned_Process_ID__c){                        
                        updatedERP += 'Process ID, ';
                    }
                    ed.Process_ID__c = customerReq.Device__r.Assigned_Process_ID__c;
                    
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Process_Id_Name__c != customerReq.Device__r.Assigned_Process_ID__r.Name){                        
                        updatedERP += 'Process ID Name, ';
                    }
                    ed.Process_Id_Name__c = customerReq.Device__r.Assigned_Process_ID__r.Name;
                    
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Device_Life_Cycle_Stage__c != customerReq.Device__r.Stage__c){                        
                        updatedERP += 'Device Life Cycle Stage, ';
                    }
                    ed.Device_Life_Cycle_Stage__c = customerReq.Device__r.Stage__c;
                    
                    if(customerReq.Device__r.No_of_Mask_Layers__c!=null){
                        if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Mask_Layer_Count__c != String.valueOF(customerReq.Device__r.No_of_Mask_Layers__c)){                            
                            updatedERP += 'Mask Layer Count, ';
                        }
                        ed.Mask_Layer_Count__c = String.valueOF(customerReq.Device__r.No_of_Mask_Layers__c);                        
                    }
                }
                
                //Opportunity Mapping
                if(customerReq.Opportunity__c!=null){                    
                    ed.Opportunity__c = customerReq.Opportunity__c;
                   
                    ed.Opportunity_ID__c = customerReq.Opportunity__r.Name;
                    
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Chips_per_Wafer__c != customerReq.Opportunity__r.Net_Parts_Per_Wafer__c){                        
                        updatedERP += 'Chips per Wafer, ';
                    }
                    ed.Chips_per_Wafer__c = customerReq.Opportunity__r.Net_Parts_Per_Wafer__c;
                    
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Target_Process_Node__c != customerReq.Opportunity__r.Target_Process_Node__c){                        
                        updatedERP += 'Target Process Node, ';
                    }
                    ed.Target_Process_Node__c = customerReq.Opportunity__r.Target_Process_Node__c;                                       
                }
                
                //Design Mapping
                if(customerReq.Design__c!=null){
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Last_Level_of_Metal__c != customerReq.Design__r.Last_Metal_Indicator__c){                        
                        updatedERP += 'Last Level of Metal, ';
                    }
                    ed.Last_Level_of_Metal__c = customerReq.Design__r.Last_Metal_Indicator__c;
                    
                    if(customerReq.Design__r.Total_Levels_of_Metal__c != null && 
                       customerReq.Design__r.Total_Levels_of_Metal__c.isNumeric()){
                            
                        if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Levels_Of_Metal__c != Decimal.valueof(customerReq.Design__r.Total_Levels_of_Metal__c)){
                            updatedERP += 'Levels of Metal, ';
                        }
                        ed.Levels_Of_Metal__c = Decimal.valueOF(customerReq.Design__r.Total_Levels_of_Metal__c);
                    }
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Package_Type__c != customerReq.Design__r.Package_style__c){                        
                        updatedERP += 'Package Type, ';
                    }
                    ed.Package_Type__c = customerReq.Design__r.Package_style__c;                   
                }
                
                //module Mapping
                if(customerReq.Modules__c !=null){
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Module_Tester_Type__c != customerReq.Modules__r.Module_test_type_platform__c){                        
                        updatedERP += 'Module Tester Type, ';
                    }
                    ed.Module_Tester_Type__c = customerReq.Modules__r.Module_test_type_platform__c;
                   
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Burn_In__c != customerReq.Modules__r.Module_Burn_In__c){                        
                        updatedERP += 'Burn In, ';
                    }
                    ed.Burn_In__c = customerReq.Modules__r.Module_Burn_In__c;                    
                }
                
                //Wafer Data
                if(customerReq.Wafer_Data__r.size()>0){
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Mask_Layer_Count__c != customerReq.Wafer_Data__r[0].Total_number_of_masks_required_to_build__c){                        
                        updatedERP += 'Mask Layer Count, ';
                    }
                    ed.Mask_Layer_Count__c = customerReq.Wafer_Data__r[0].Total_number_of_masks_required_to_build__c;
                    
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Back_Side_Grind__c != customerReq.Wafer_Data__r[0].Back_Side_Grind__c){                        
                        updatedERP += 'Back Side Grind, ';
                    }
                    ed.Back_Side_Grind__c = customerReq.Wafer_Data__r[0].Back_Side_Grind__c;    
                    
                    if(customerReq.ERP_Devices__r.size()>0 && customerReq.ERP_Devices__r[0].Bonding_Type__c != customerReq.Wafer_Data__r[0].Active_side_interconnect_technology__c){
                        updatedERP += 'Bonding Type, ';
                    } 
                    ed.Bonding_Type__c = customerReq.Wafer_Data__r[0].Active_side_interconnect_technology__c;              
                }
                
                //Valiating Existing ERP device with part number
                if(existingERP.containsKey(customerReq.Deliverable_Part_Number_DPN_Formula__c)){
                    ed.id = existingERP.get(customerReq.Deliverable_Part_Number_DPN_Formula__c).id;
                    if(updatedERP.length()>1){
                        updatedERP = updatedERP.substring(0,updatedERP.length()-2) + ' updated on ERP Device';
                    }
                }                
                edListInsUpdate.add(ed);
            }

        }
      
        if(edListInsUpdate.size()>0){
            try{
                if(updatedERP.length()>1 || ed.id == null){
                    database.upsert(edListInsUpdate); 
                }               
            }catch(Exception e){
                GlobalUtility.logMessage('Error','UtilOptionsTrigger','create_ERP_DEVICE','','Exception : ',String.valueof(e.getMessage()),'','Device Management',e,0);
            }
        }
        return updatedERP;
     }
     
     webservice static String syncERPDevice(String opts)
    { 
        
        try{
        List<Customer_Requirement__c> optionList = [Select id,name,Deliverable_Part_Number_DPN_Formula__c,Device__c from Customer_Requirement__c where id =: opts];
        String updatedERP = create_ERP_DEVICE(optionList);
        return updatedERP;
        }catch(Exception e){
            return e.getMessage();
        }
    }
}