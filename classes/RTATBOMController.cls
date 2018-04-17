/*
    Author: Ravindra Paliwal
    Description: Apex controller use to pull BOM and create RTAT BOM.
    History: 
        RPaliwal     04/19/2017    - Code creation.                                   
*/
public class RTATBOMController {
    
    public ID rtatSlotID {get;set;}
    public List<RtatBOMWrapper> wrappers{get;set;}
    public static Integer toDelIdent{get;set;}
    public static Integer addCount {get; set;}
    private Integer nextIdent=0;
    public RTAT_Slot__c rSlot;
    public String strRSlot{get;set;}
    public List<BOM__c> lstBOM;
    public boolean noBOM{get;set;}
 
    public RTATBOMController()
    {
         rtatSlotID = ApexPages.currentPage().getParameters().get('Id');//Parent rtatSlot ID
        //rtatSlotID ='aHgO00000008OJD';
        rSlot = new RTAT_Slot__c();
        getRTATBOMData();
        rSlot = [select ERP_Device_for_Slot__r.Part_Number__c,ERP_Device_Technology__c,ERP_Device_Deliverable_Type__c from RTAT_Slot__c where id =:rtatSlotID];
        strRSlot =rSlot.ERP_Device_Deliverable_Type__c;
        
        
    }
    public void getRTATBOMData(){
         nextIdent=0;
        noBOM=true;
         RTAT_BOM__c[]  rtatBOMObj = [SELECT id,Component__c,Create_Prefix_PN__c,Deliverable_PN__c,Level_code__c,Part_Classification__c,Prefix_PN__c,RTAT_Slot__c,Deliverable_P_Level_PN__c
                                     FROM RTAT_BOM__c
                                     WHERE RTAT_Slot__c =:rtatSlotID Order by Level_code__c];
       
        wrappers=new List<RtatBOMWrapper>();
        for (RTAT_BOM__c a:rtatBOMObj)
        {
            wrappers.add(new RtatBOMWrapper(nextIdent++,a));
            noBOM=false;
        } 
    }
    public void addPartToRTATBOM(){
            lstBOM = new List<BOM__c>();
            RTAT_BOM__c tempBOM; 
            List<RTAT_BOM__C> rtatBom = new List<RTAT_BOM__c>();
        try{  
        lstBOM=getPartNumbers(rSlot.ERP_Device_for_Slot__r.Part_Number__c,rSlot.ERP_Device_Technology__c);
            
            for(BOM__c bom:lstBOM){
                tempBOM = new RTAT_BOM__c();
                tempBOM.Component__c = bom.Component__c;
                tempBOM.Level_code__c = bom.Part_Level_Code__c;
                tempBOM.Part_Classification__c = bom.Part_Classification__c;
                tempBOM.RTAT_Slot__c = rtatSlotID;
                rtatBOM.add(tempBOM);
            }
        
        insert rtatBOM;
    
       
        getRTATBOMData(); 
                }
        catch(exception e){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error occured while copying BOM')); 
               
        }
        }
    
    public void delWrapper()
    {
        system.debug('toDelIdent===>' + toDelIdent);
        Integer toDelPos=-1;
         RTAT_BOM__c delRec = new  RTAT_BOM__c();
        for (Integer idx=0; idx<wrappers.size(); idx++)
        {
            system.debug('wrappers[idx].ident====>' +wrappers[idx].ident);
            if (wrappers[idx].ident==toDelIdent)
            {
                toDelPos=idx;
            }
        }
        if (-1!=toDelPos)
        {
         try{  
            delRec= wrappers.get(toDelPos).rTATBOM;
            wrappers.remove(toDelPos);
            
            delete delRec;
            nextIdent=0;
            getRTATBOMData();
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error occured while deleting data')); 
               
        }
            
        }
    }
    
    public void addRows()
    {
        for (Integer idx=0; idx<addCount; idx++)
        {
            wrappers.add(new RtatBOMWrapper(nextIdent++));
        }
    }
    
  public void save()
    {
       List<RTAT_BOM__c> rTATBOM =new List<RTAT_BOM__c>();
      try{       
       for (RtatBOMWrapper wrap : wrappers)
        {
            if (wrap.rtatBOM.RTAT_Slot__c==null) wrap.rtatBOM.RTAT_Slot__c = rtatSlotID;
            if(wrap.rtatBOM.Create_Prefix_PN__c){
               wrap.rtatBOM.Prefix_PN__C = (wrap.rtatBOM.component__C).subString(0,4) +'P'+(wrap.rtatBOM.component__C).substring(5,(wrap.rtatBOM.component__C).length()); 
            }
            else{
                wrap.rtatBOM.Prefix_PN__C = '';
            }
            rTATBOM.add(wrap.rtatBOM);
        }
        upsert rTATBOM; 
          getRTATBOMData(); 
      }
       catch(Exception e){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error while saving data.')); 
              
        }
        //return new PageReference('/' + Schema.getGlobalDescribe().get('Account').getDescribe().getKeyPrefix() + '/o');
    }
    public class RtatBOMWrapper
    {
        public RTAT_BOM__c rtatBOM {get; private set;}
        public Integer ident {get; private set;}
        public RtatBOMWrapper(Integer inIdent,RTAT_BOM__c bom)
        {
            ident=inIdent;
            rtatBOM=bom;
        }
         public RtatBOMWrapper(Integer inIdent)
        {
            ident=inIdent;
            rtatBOM=new RTAT_BOM__c();
        }
    }
 public List<BOM__c> getPartNumbers(String strPartNumber, String strTechnology) {
        Map<String,List<String>> bomMap = new Map<String,List<String>>(); 
        Map<String,BOM__C> dtlBOM = new Map<String, BOM__C>(); 
        List<String> bomList;
        for(BOM__C bom:[SELECT Component__c, Parent__c, Part_BasicName__c,Part_Classification__c,Part_Level_Code__c,Part_Short_Desc__c FROM Bom__c WHERE Part_Level_Code__c!=null ANd Technology__c=:strTechnology])
        {
            //Add Parent to Hierarchy
            if(bomMap.containsKey(bom.Parent__c)){
                bomList =new List<String>();
                bomList=bomMap.get(bom.Parent__c);
                bomList.add(bom.Component__c);
                bomMap.put(bom.Parent__c, bomList);
                
            }
            else{
                bomList =new List<String>();
                bomList.add(bom.Component__c);
                bomMap.put(bom.Parent__c, bomList);
                           }
            
            //Add Component to Hierarchy
            if(!bomMap.containsKey(bom.Component__c)){
                bomList =new List<String>();
                bomMap.put(bom.Component__c, bomList);
                 
            }
            if(!dtlBOM.containsKey(bom.Component__c)){
                dtlBOM.put(bom.Component__c,bom);
                
            }
        }
        //Preparing the list of part numbers under user supplied part.
        Set<String> bomParts = new Set<String>();
        List<BOM__c> bomPartsList = new List<BOM__c>();
        bomList =new List<String>();
        bomList = bomMap.get(strPartNumber);
        bomParts.add(strPartNumber);
       
       if(bomList!=null) {
           bomParts.addAll(bomList);
       
        while(bomList.size()>0){
            bomParts.addAll( bomMap.get(bomList.get(0)));
            bomList.addAll(bomMap.get(bomList.get(0)));
            bomList.remove(0);
        }
       }
       // 
        for(String a:bomParts){
            bomPartsList.add(dtlBOM.get(a));
        }
        return bomPartsList;
    }
  
}