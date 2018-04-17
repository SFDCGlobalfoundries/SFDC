/* 
 Type Name: MDD_Part_InfoController
 Author: JKTechnosoft
 Created Date: 13-July-2016
 Reason: MDD Part Search and Detail display of PartInformation Controller.
 
 */
public without sharing class MDD_Part_InfoController{
    public Part__c prt {get; set;}
    public Boolean showExemp {get; set;}
    public Boolean showHomogenousInfo {get; set;}
    public Boolean showPrt {get; set;}
    public List<Exemption__c> Exemp {get; set;}
    public List<Homogenous_Information__c> homogenousInfo {get; set;}
    public String getPackageType {get; set;}
    public List<WrapHomo> wrap {get; set;}
    Id PartId1 = ApexPages.CurrentPage().GetParameters().get('partId');
    public Id familyId {get; set;}
    public Boolean isInternalUser {get; set;}
    public User loginUser; 
    public String gfView {get; set;}
    public String str4 {get; set;}
    public String str1 {get; set;}
    public String str2 {get; set;}
    public String str3 {get; set;}
    
    public MDD_Part_InfoController(){
        isInternalUser = true;
        gfView = '';
        String str = URL.getSalesforceBaseUrl().getHost();
        if(str.contains('globalfoundryview')){
            isInternalUser = false;
             gfView = '/GlobalfoundryView';
        }
        showExemp = false;
        showHomogenousInfo = false;
        showPrt = false;
        wrap = new List<WrapHomo>();
        Map<String,List<Homogenous_Information__c>> mapHomo = new Map<String,List<Homogenous_Information__c>>();
        Id PartId = ApexPages.CurrentPage().GetParameters().get('partId');
        str4 = '';
        for(MDD_ChinaROHS_Contents__c lstStatic : [Select Id,Name, Content__c from MDD_ChinaROHS_Contents__c where Name Like 'Line%' order By Name Asc ]){
            str4+=lstStatic.Content__c;
        }
        system.debug('str4===='+str4);
        str1 = '';
        for(MDD_ChinaROHS_Contents__c lstStatic1 : [Select Id,Name, Content__c from MDD_ChinaROHS_Contents__c where Name Like 'Section1%' order By Name Asc ]){
            str1+=lstStatic1.Content__c;
        }
        str2 = '';
        for(MDD_ChinaROHS_Contents__c lstStatic2 : [Select Id,Name, Content__c from MDD_ChinaROHS_Contents__c where Name Like 'Section2%' order By Name Asc ]){
            str2+=lstStatic2.Content__c;
        }
        str3 = '';
        for(MDD_ChinaROHS_Contents__c lstStatic3 : [Select Id,Name, Content__c from MDD_ChinaROHS_Contents__c where Name Like 'Section3%' order By Name Asc ]){
            str3+=lstStatic3.Content__c;
        }
        prt = [Select Id,Name,Base_Alloy__c,Chip_size_x__c,Chip_Size_y__c,Family_Weight__c,Folder_Link__c,Max_Reflow_Time__c,
                        MSL_Rating__c,Number_of_reflow_Cycles__c,Package_x__c,Package_y__c,Part_Family__c,Part_Number__c,Part_Type__c,Package_Type__c,
                        LastModifiedDate,Lead_Level__c,Peak_process_Body_Temp__c,Plating_grid_material__c,Wafer_Size__c from Part__c where Id =: PartId];
        if(prt != null)
        showPrt = true;
        getPackageType = prt.Package_Type__c;
        Exemp = [Select Id,Name , Part__c, Is_Active__c from Exemption__c where Part__c =: PartId and Is_Active__c = true];
        if(Exemp.size() > 0)
        showExemp = true;
        homogenousInfo = [Select Id,Name,CAS_Number__c,Homogenous_material__c,Part__c,PPM_of_substance__c,Concentration_Percent__c,Homogenous_Material_Weight__c,Weight__c,
                            Substance_group__c,Substance_name__c,Substance_type__c, IsActive__c from Homogenous_Information__c
                            where Part__c =: PartId and IsActive__c = true order By Homogenous_material__c Asc];
        for(Homogenous_Information__c h :homogenousInfo){
            List<Homogenous_Information__c> temp = new List<Homogenous_Information__c>();
            if(mapHomo.containsKey(h.Homogenous_material__c)){
                temp.addAll(mapHomo.get(h.Homogenous_material__c));
                temp.add(h);
            }
            else{
                temp.add(h);
            }
            mapHomo.put(h.Homogenous_material__c,temp);
        }
        if(mapHomo.size() > 0)
        showHomogenousInfo = true;
        List<Part_Family__c> partFamilyRec = [Select Id,Name from Part_Family__c where Name =: prt.Part_Family__c];
        if(partFamilyRec.size() > 0)
        familyId = partFamilyRec[0].Id;
        AggregateResult[] groupedResults = [Select SUM(Weight__c) sum ,Homogenous_material__c from Homogenous_Information__c where Part__c =: PartId and IsActive__c = true Group By Homogenous_material__c]; 
        List<wrapWeightHomoInfo> listTemp;
        for (AggregateResult ar : groupedResults)  {
            WrapHomo w = new WrapHomo();
            listTemp = new List<wrapWeightHomoInfo>();
            for(Homogenous_Information__c homo: mapHomo.get(String.valueOf(ar.get('Homogenous_material__c')))){
                wrapWeightHomoInfo harmo = new wrapWeightHomoInfo();
                harmo.homoInfo = homo;
                if(homo.Homogenous_material__c != null && homo.Homogenous_material__c != '' && string.valueof(homo.Homogenous_material__c).toLowerCase() == 'ink')
                    harmo.weight = (((homo.PPM_of_substance__c / 10000)/100) * homo.Homogenous_Material_Weight__c);
                else
                    harmo.weight = (((homo.PPM_of_substance__c / 10000)/100) * homo.Homogenous_Material_Weight__c).setScale(4);
                listTemp.add(harmo);
            }
            w.homo = listTemp;
            decimal tempD;
            if(String.valueOf(ar.get('Homogenous_material__c')).toLowerCase() == 'ink'){
                tempD = (decimal) ar.get('sum');
                w.totalWeight = tempD.setScale(10);
            }
            else{
                tempD = ((decimal) ar.get('sum'));
                w.totalWeight = tempD.setScale(4);
            }
            wrap.add(w);
        }
    }
    public PageReference ExportWord(){
        pagereference pgref=new pagereference('/apex/MDDExportPartInfo?param='+PartId1);
        return pgref;
    }
    public PageReference DownloadXML(){
        pagereference pgref=new pagereference('/apex/MDD_XML_Download?id='+PartId1);
        return pgref;
    }
    public PageReference callPartFamily(){
        pagereference pgref=new pagereference('/apex/MDD_PartFamilyOverride?id='+familyId);
        return pgref;
    }
    public class WrapHomo{
        public List<wrapWeightHomoInfo> homo {get; set;}
        public decimal totalWeight {get; set;}
    }
    public class wrapWeightHomoInfo{
        public Homogenous_Information__c homoInfo {get; set;}
        public decimal weight {get; set;}
    }
}