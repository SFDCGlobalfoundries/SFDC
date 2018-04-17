/* 
 Type Name: MDD_XML_DownloadCont
 Author: JKTechnosoft
 Created Date: 13-July-2016
 Reason: XML download controller in MDD Part Search Application.
 
 */
public class MDD_XML_DownloadCont{
    public String s {get; set;}
    Map<String,Map<String,Homogenous_Information__c>> mapOuter = new Map<String,Map<String,Homogenous_Information__c>>();
    Part__c prt;
    public MDD_XML_DownloadCont(){
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=PartReportXml.xml');
    } 
    public PageReference XFDFInit() {
    
        Id PartId = ApexPages.currentPage().getParameters().get('id');
        //Pass the partId of the particular part to obtain the information
        prt = [Select Id,Name,Base_Alloy__c,Chip_size_x__c,Chip_Size_y__c,Family_Weight__c,Folder_Link__c,Max_Reflow_Time__c,
                        MSL_Rating__c,Number_of_reflow_Cycles__c,Package_x__c,Package_y__c,Part_Family__c,Part_Number__c,Part_Type__c,Package_Type__c,
                        LastModifiedDate,Lead_Level__c,Peak_process_Body_Temp__c,Plating_grid_material__c,Wafer_Size__c from Part__c where Id =: PartId];
                        
        List<Homogenous_Information__c> homogenousInfo = [Select Id,Name,CAS_Number__c,Homogenous_material__c,Part__c,PPM_of_substance__c,Homogenous_Material_Weight__c,Weight__c,
                            Substance_group__c,Substance_name__c,Substance_type__c from Homogenous_Information__c
                            where Part__c =: PartId order By Homogenous_material__c Asc];
                            
        
        for(Homogenous_Information__c h : homogenousInfo){
            if(mapOuter.containsKey(h.Homogenous_material__c)){
                Map<String,Homogenous_Information__c> mapInner = new Map<String,Homogenous_Information__c>(mapOuter.get(h.Homogenous_material__c));
                mapInner.put(h.Substance_group__c,h);
                mapOuter.put(h.Homogenous_material__c,mapInner);
            }
            else{
                Map<String,Homogenous_Information__c> mapInner = new Map<String,Homogenous_Information__c>();
                mapInner.put(h.Substance_group__c,h);
                mapOuter.put(h.Homogenous_material__c,mapInner);
            }
        }        
        String xmlContent = getXmlString();
       
        return null;
        
    }


    private String getXmlString()
    {
        
        s = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
        '<MCD xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" formType="Distribute" declarationType="All" ipcStandard="1752-2" version="1.1" xsi:noNamespaceSchemaLocation="IPC 1752 Schema_V1_1.xsd">' +
        '<ProductID manufacturerItemName="NA" manufacturerItemNumber="0000000CW502" manufacturingSite="NA" effectiveDate="2016-05-10-06:00" version="NA" requesterItemNumber="NA">' +
        '<AlternateItem itemNumber="NA" itemName="NA" comments="NA"/>' +
        '</ProductID>' +
        '<PIP pipVersion="D11.00.00" tpirVersion="01.00" pipIdentifier="2A13"/>' +
        '<Response docID="NA" fieldLock="false" comments="material.declaration@globalfoundries.com">' +
        '<Authorizer name="Thomas Jagielski" title="Site Operations Manager, Environmental Programs, Product Stewardship" phone="802-769-4747" email="thomas.jagielski@globalfoundries.com"/>' +
        '<Supplier name="GLOBALFOUNDARIES">' +
        '<UniqueID identity="NA" authority="NA"/>' +
        '</Supplier>' +
        '<Contact name="Ruma Kohli" title="Product Stewardship Program Manager" phone="802-769-4269" email="ruma.kohli@globalfoundries.com"/>' +
        '<Product unitVolume="Each">' +
        '<Amount weight="'+prt.Family_Weight__c+'" unitOfMeasure="g"/>'+
        '<RoHSDeclaration legalType="Custom" legalDef="The assertions and information that GLOBALFOUNDRIES US2 LLC provides in the RoHS Material Composition Declaration and Homogeneous Material Composition Declaration for Electronic Products sections of this document are based on data contained in Material Safety Data Sheets, GLOBALFOUNDRIES US2 LLC design manuals, and material specifications. The Homogeneous Material Composition Declaration for Electronic Products section identifies estimated concentrations of substances at the homogeneous material level of the part-family at issue. With respect to Leaded parts, Option 2 in the RoHS Declaration below applies, though an EU RoHS Directive exemption may be available depending on a customers use of the part (e.g., if a customer incorporates the part in a server, an exemption for lead in solders for servers would apply, assuming that exemption remains a part of the directive).&#13;&#13;The following applies to all of the assertions and information in all sections of this document: GLOBALFOUNDRIES US2 LLC makes no promise, commitment, warranty, affirmation, description, or certification with respect to the assertions and information it provides in this document. Rather, GLOBALFOUNDRIES US2 LLC provides the assertions and information on an &quot;AS IS&quot; basis, without any express or implied warranty of any kind. GLOBALFOUNDRIES US2 LLC may have provided a customer with an GLOBALFOUNDRIES US2 LLC RoHS Certificate for the part covered by this document. GLOBALFOUNDRIES US2 LLC sole and exclusive obligations, and a customers sole and exclusive remedies, with respect to the substance content of such part are as expressly set forth in that document." supplierAcceptance="false" rohsDeclaration="2 - Item(s) contains RoHS restricted substances above the limits per the definition above and is not under exemption"/>' +
        '<MfgInfo comments="Information derived from GLOBALFOUNDRIES US2 LLC quality and reliability manuals." numberProcessingCycles="'+prt.Number_of_reflow_Cycles__c+'" maxTime="'+prt.Max_Reflow_Time__c+'" peakProcessingTemp="'+prt.Peak_process_Body_Temp__c+'" mslRating="'+prt.MSL_Rating__c+'" terminalBaseAlloy="'+prt.Base_Alloy__c+'" gridArrayMaterial="'+prt.Plating_grid_material__c+'"/>' +
        '<SubItem name="IC">' ;
        for(Integer i=0; i<mapOuter.size(); i++){
            s += '<SubstanceCategory name="'+mapOuter.values()[i].values()[0].Homogenous_material__c+'">' ;
            for(Integer j=0; j< mapOuter.values()[i].size() ; j++){
                s += '<Substance name="'+mapOuter.values()[i].values()[j].Substance_group__c+'" cas="'+mapOuter.values()[i].values()[j].CAS_Number__c+'" >';
                s += '<Amount unitOfMeasure="mg" weight="'+mapOuter.values()[i].values()[j].Weight__c+'" ppm="'+mapOuter.values()[i].values()[j].PPM_of_substance__c+'"/>';
                s += '</Substance>';
            }
            s += '</SubstanceCategory>' ;
        }
        s += '</SubItem>' ;
        s += '</Product>' ;
        s += '</Response>' ;
        s += '</MCD>' ;
        return s; 
    }      
 
}