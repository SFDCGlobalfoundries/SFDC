/**********************************************************************************************************************************
    Class:         CPQIPDataUpdateReportController
    -----------------------------------------------------------------------------------------------------------------------------------
    Author:         Shuchismita Mallik
    Description:    It will display the IP to be inserted/Updated/deleted in the configurator database.
    History:        Ravi Teja.B Modified On 22/02/17 for Case#00061409
                    Ravi Teja.B Modified On 08012017 for Case#00073306
***********************************************************************************************************************************/
public class CPQIPDataUpdateReportController {
    Public Map<String,Product2> MapbundlePTs = new Map<String,Product2>() ;
    Public Map<String,list<String>> MapIPnumbersfromIPPTMap = new Map<String,list<String>>();
    Transient Public Map<String,Map<string, Product2>> MapIPProdCompfromConfig = new Map<String,Map<string, Product2>>();
    Transient Public Map<String,BaseIPandDesignKit> PTnumvsIPWrapMap = new Map<String,BaseIPandDesignKit>();
    Public Map<string,map<string,List<string>>> validatedIPDataMap {get;set;}    
    Transient Public set<string> SetIPNums = new set<string>();
    Public Map<String, map<string,CPQIPDataUpdateReportController.BaseIPandDesignKit>> finalUpsertMap = new Map<String, map<string,CPQIPDataUpdateReportController.BaseIPandDesignKit>> () ;
    Public Map<String, List<String>> finalDeleteMap = new Map<String, List<String>>() ; 
    Public boolean isDisableFlag{get;set;}
    public Map<string,Product2> deviceVsProductMap = new Map<string,Product2>();
    public CPQIPDataUpdateReportController(){
        for(Product2 prod :  [SELECT    ID
                                        , Apttus_Config2__ConfigurationType__c
                                        , PT_Number__c
                                        , Product_External_ID__c
                                        , family
                                        , Geometry__c
                                        , Catalog_Type__c
                              FROM      Product2
                              WHERE     (Apttus_Config2__ConfigurationType__c = 'Bundle'
                              AND       PT_Number__c != null
                              AND       Catalog_Type__c = 'First Source')
                              //OR        (family = 'Devices'
                              //AND        Apttus_Config2__ConfigurationType__c = 'Option')
                              ]){
            if(prod.Apttus_Config2__ConfigurationType__c == 'Bundle'){
                MapbundlePTs.put(prod.PT_Number__c,prod);                           
            }
            system.debug('MapbundlePTs'+MapbundlePTs);
            /*else{
                deviceVsProductMap.put(prod.Product_External_ID__c, prod);
            }*/    
        }
        if(MapbundlePTs.size() > 0){
            MapIPnumbersfromIPPTMap = getIPnumfromIPPTMap (MapbundlePTs.keyset()) ; 
            MapIPProdCompfromConfig = getIPProdComponents (MapbundlePTs.keyset()) ; 
            system.debug('MapIPProdCompfromConfig'+MapIPProdCompfromConfig );           
            for(List <String> IPnumslist : MapIPnumbersfromIPPTMap.values()){
                for(String IPnumber : IPnumslist){
                   SetIPNums.add(IPnumber );
               }
            }
            PTnumvsIPWrapMap = IPdataGenerator(SetIPNums); 
            system.debug('[debug:MapIPnumbersfromIPPTMap  ]'+ MapIPnumbersfromIPPTMap ); 
            system.debug('[debug:MapIPProdCompfromConfig  ]'+ MapIPProdCompfromConfig);
            system.debug('[debug:PTnumvsIPWrapMap         ]'+ PTnumvsIPWrapMap);
            system.debug('[debug:]');
            validatedIPDataMap = validateIPData(  MapIPnumbersfromIPPTMap 
                                                , MapIPProdCompfromConfig
                                                , PTnumvsIPWrapMap);
            system.debug('finalUpsertMap'+finalUpsertMap);                              
            if(validatedIPDataMap.isEmpty()){
                isDisableFlag = true;
                apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'There is no record to display');
                apexpages.addmessage(msg);                 
            }                                        
        }
    }
    /*
        Apex Method Name :  getIPnumfromIPPTMap
       parameter:          List of PT numbers - String
        Return Type:        Map of PT number and correspoding IPs related to that. 
        Reason:             To retrieve the data related to PT and related IP IDs - Updated in PLM.
    */
    public Map<String,list<String>> getIPnumfromIPPTMap (Set<String> ListbundlePTs){
        Map<String,list<String>> MapIPnumbers = new Map<String,list<String>>();
        if(ListbundlePTs.size() > 0){
            for(IP_PT_Map__c ipnum : [SELECT    ID
                                                , IPNumber__r.name  
                                                , IPNumber__r.Lifecycle__c
                                                , IP_PT_Number__c
                                                , PT_Number__r.name
                                      FROM      IP_PT_Map__c
                                      WHERE     PT_Number__r.name 
                                      IN        :ListbundlePTs
                                      ]){
                    if( ! MapIPnumbers.containsKey(ipnum.PT_Number__r.name)){
                        list<String> tempIPList = new list<String>();
                        tempIPList.add(ipnum.IPNumber__r.name) ; 
                        MapIPnumbers.put(   ipnum.PT_Number__r.name
                                            , tempIPList )  ;   
                    }
                    else{
                        MapIPnumbers.get(ipnum.PT_Number__r.name).add(ipnum.IPNumber__r.name); 
                    }                  
            }
        }   
        return MapIPnumbers ; 
    }
    /*
        Apex Method Name :  getIPProdComponents
        parameter:          List of PT numbers - String
        Return Type:        Map of PT number and correspoding Map of IP ID and related data updated for configurator.
        Reason:             To retrieve the data related to PT and related IP data already updated in Configurator.
    */
    public map<string, Map<String,Product2>> getIPProdComponents (set<String> bundlePTs){
        map<string, Map<String,Product2>> MapPTnum2IPlist  = new map<string, Map<String,Product2>>();
        for (Apttus_Config2__ProductOptionComponent__c comp :   [SELECT id
                                                                            , Apttus_Config2__ComponentProductId__c
                                                                            , Apttus_Config2__ComponentProductId__r.name
                                                                            , Apttus_Config2__ComponentProductId__r.ProductCode
                                                                            , Apttus_Config2__ComponentProductId__r.IP_Design_Kit_Name__c
                                                                            , Apttus_Config2__ComponentProductId__r.IP_Device_List__c
                                                                            , Apttus_Config2__ComponentProductId__r.APTPS_IP_Lifecycle__c
                                                                            , Apttus_Config2__ComponentProductId__r.APTPS_IP_Type__c
                                                                            , Apttus_Config2__ComponentProductId__r.APTPS_IP_Vendors__c
                                                                            , Apttus_Config2__ParentProductId__c
                                                                            , Apttus_Config2__ParentProductId__r.PT_Number__c
                                                                            , Apttus_Config2__ParentProductId__r.Catalog_Type__c 
                                                                            , Apttus_Config2__ComponentProductId__r.APTPS_Metal_Stack__c
                                                                            , Apttus_Config2__ComponentProductId__r.Product_External_ID__c
                                                                    FROM    Apttus_Config2__ProductOptionComponent__c
                                                                    WHERE   Apttus_Config2__ParentProductId__r.PT_Number__c 
                                                                    IN      :bundlePTs 
                                                                    AND     Apttus_Config2__ComponentProductId__r.family = 'IPs'
                                                                    AND     Apttus_Config2__ParentProductId__r.Catalog_Type__c = 'First Source'] ){ 
            if(!MapPTnum2IPlist.containskey(comp.Apttus_Config2__ParentProductId__r.PT_Number__c))  {
                Map<String,Product2> IPnummap = new Map<String,Product2>();
                IPnummap.put(   comp.Apttus_Config2__ComponentProductId__r.ProductCode
                                , new product2(id = comp.Apttus_Config2__ComponentProductId__r.id
                                                , name = comp.Apttus_Config2__ComponentProductId__r.name
                                                , ProductCode = comp.Apttus_Config2__ComponentProductId__r.ProductCode
                                                , IP_Design_Kit_Name__c = comp.Apttus_Config2__ComponentProductId__r.IP_Design_Kit_Name__c
                                                , IP_Device_List__c = comp.Apttus_Config2__ComponentProductId__r.IP_Device_List__c
                                                , APTPS_IP_Lifecycle__c = comp.Apttus_Config2__ComponentProductId__r.APTPS_IP_Lifecycle__c
                                                , APTPS_IP_Type__c = comp.Apttus_Config2__ComponentProductId__r.APTPS_IP_Type__c
                                                , APTPS_Metal_Stack__c = comp.Apttus_Config2__ComponentProductId__r.APTPS_Metal_Stack__c
                                                , Product_External_ID__c = comp.Apttus_Config2__ComponentProductId__r.Product_External_ID__c
                                                , APTPS_IP_Vendors__c = comp.Apttus_Config2__ComponentProductId__r.APTPS_IP_Vendors__c));
               MapPTnum2IPlist.put(    comp.Apttus_Config2__ParentProductId__r.PT_Number__c
                                        ,IPnummap);
            }   
            else{
                MapPTnum2IPlist.get(comp.Apttus_Config2__ParentProductId__r.PT_Number__c).put(  comp.Apttus_Config2__ComponentProductId__r.ProductCode
                                                                                                , new Product2 (id=  comp.Apttus_Config2__ComponentProductId__r.id
                                                                                                                , name = comp.Apttus_Config2__ComponentProductId__r.name
                                                                                                                , ProductCode = comp.Apttus_Config2__ComponentProductId__r.ProductCode
                                                                                                                , IP_Design_Kit_Name__c = comp.Apttus_Config2__ComponentProductId__r.IP_Design_Kit_Name__c
                                                                                                                , IP_Device_List__c = comp.Apttus_Config2__ComponentProductId__r.IP_Device_List__c
                                                                                                                , APTPS_IP_Lifecycle__c = comp.Apttus_Config2__ComponentProductId__r.APTPS_IP_Lifecycle__c
                                                                                                                , APTPS_IP_Type__c = comp.Apttus_Config2__ComponentProductId__r.APTPS_IP_Type__c
                                                                                                                , APTPS_Metal_Stack__c = comp.Apttus_Config2__ComponentProductId__r.APTPS_Metal_Stack__c
                                                                                                                , Product_External_ID__c = comp.Apttus_Config2__ComponentProductId__r.Product_External_ID__c
                                                                                                                , APTPS_IP_Vendors__c = comp.Apttus_Config2__ComponentProductId__r.APTPS_IP_Vendors__c));
            }                                                   
        }
        return MapPTnum2IPlist ; 
    }   
    public Map<String,BaseIPandDesignKit> IPdataGenerator(set<string> SetIPNums){
        Map<String,BaseIPandDesignKit> PTnumvsIPWrapMap = new Map<String,BaseIPandDesignKit> (); 
        if(SetIPNums.size() > 0){
            //CPQ_Settings__c cpqSetting2 = CPQ_Settings__c.getValues('IP_Lifecycle_Validation');
            for(base_ip__c baseIPrec : [SELECT  (SELECT name,IP_Vendor__c,Lifecycle__c,IP_Device_List__c,Metal_Stack_List__c,Latest_Design_Kit__c FROM IP_Design_Kit__R WHERE Latest_Design_Kit__c = true), 
                                                IP_Type__c,
                                                name,
                                               description__c,
                                                Lifecycle__c,
                                                Ip_Vendor__c,
                                                IP_Number__c,
                                                id
                                     FROM       base_ip__c 
                                     where      name
                                     IN         : SetIPNums]){
                if(baseIPrec.IP_Design_Kit__r.size() > 0){
                    IP__c ipDk = baseIPrec.IP_Design_Kit__r[0];
                    if( !String.isblank(ipDk.LifeCycle__c) && (ipDk.Latest_Design_Kit__c == true) && (ipDk.Lifecycle__c == 'FB Design Kit Approved' || ipDk.Lifecycle__c == 'Silicon Char certified')){  
                        BaseIPandDesignKit tempIP = new BaseIPandDesignKit();
                            tempIP.baseIP.IP_Number__c              = baseIPrec.IP_Number__c;
                            tempIP.baseIP.id                        = baseIPrec.ID;
                            tempIP.baseIP.IP_Type__c                = baseIPrec.IP_Type__c ; 
                            tempIP.baseIP.name                      = baseIPrec.name; 
                            tempIP.baseIP.description__c            = baseIPrec.description__c;
                            //tempIP.baseIP.Ip_Vendor__c              = baseIPrec.Ip_Vendor__c;
                            tempIP.designkitIP.Ip_Vendor__c         = ipDk.Ip_Vendor__c;
                            tempIP.designkitIP.Lifecycle__c         = ipDk.Lifecycle__c;
                            tempIP.designkitIP.Metal_Stack_List__c  = ipDk.Metal_Stack_List__c ; 
                            tempIP.designkitIP.IP_Device_List__c    = ipDk.IP_Device_List__c ; 
                        PTnumvsIPWrapMap.put(baseIPrec.name , tempIP);
                    }
                }
            }
        }
        return PTnumvsIPWrapMap ;
    }
    /*
        Apex Method Name :  validateIPData
        parameter:          1. MapIPnumbersfromIPPTMap
                            2. MapIPProdCompfromConfig
                            3. PTnumvsIPWrapMap 
        Return Type:        Map<string,map<string,List<string>>>
        Reason:             Create mapping of PT and related IP data to update in the configurator.
    */
    public Map<string,map<string,List<string>>> validateIPData( Map<String,list<String>> MapIPnumbersfromIPPTMap
                                                              , Map<String,Map<string, Product2>> MapIPProdCompfromConfig
                                                              , Map<String,BaseIPandDesignKit> PTnumvsIPWrapMap ){                                            
        Map<String,map<string,List<string>>> finalMap = new Map<String,map<string,List<string>>>();  // Map<PT Number, MAP<Action, IP List >>                                                                                                                    
        for(String PTnum : MapIPnumbersfromIPPTMap.keyset() ){ 
            system.debug('PTnumvsIPWrapMap'+ PTnumvsIPWrapMap);
            Map<string,List<string>> tempMap = new Map<string,List<string>>();          
            List<string> IpListUpdated = new List<string>(); 
            map<string,BaseIPandDesignKit> UpsertMap = new map<string,BaseIPandDesignKit>() ; 
            List<string> IpListInserted = new List<string>();
            set<string> IpListInsertedSet = new set<string>();
            for(String IPID : MapIPnumbersfromIPPTMap.get(PTnum)){
                system.debug('IPID'+IPID);
                if(MapIPProdCompfromConfig.containsKey(PTnum)){
                    if( MapIPProdCompfromConfig.get(PTnum).containskey(IPID)
                        && PTnumvsIPWrapMap.containsKey(IPID)){                 
                        system.debug('[Debug: Update Block]' + PTnumvsIPWrapMap.containskey(IPID)); 
                        //Added  by sSharma1 : Bug in Case#00061409
                        String formattedIPDescription = ('('+PTnumvsIPWrapMap.get(IPID).baseIP.name+')' + ' ' + '('+PTnumvsIPWrapMap.get(IPID).baseIP.description__c.replaceAll('[^\\x00-\\x7F]', ' ')+')').replaceAll('  ',' ');
                        //check field updates                            
                        if(
                            MapIPProdCompfromConfig.get(PTnum).get(IPID).IP_Device_List__c          != PTnumvsIPWrapMap.get(IPID).designkitIP.IP_Device_List__c
                            || MapIPProdCompfromConfig.get(PTnum).get(IPID).APTPS_IP_Lifecycle__c   != PTnumvsIPWrapMap.get(IPID).designkitIP.Lifecycle__c
                            || MapIPProdCompfromConfig.get(PTnum).get(IPID).APTPS_IP_Type__c        != PTnumvsIPWrapMap.get(IPID).baseIP.IP_Type__c 
                            || MapIPProdCompfromConfig.get(PTnum).get(IPID).APTPS_IP_Vendors__c     != PTnumvsIPWrapMap.get(IPID).designkitIP.Ip_Vendor__c   
                            || MapIPProdCompfromConfig.get(PTnum).get(IPID).name                    != formattedIPDescription
                            || MapIPProdCompfromConfig.get(PTnum).get(IPID).APTPS_Metal_Stack__c    != PTnumvsIPWrapMap.get(IPID).designkitIP.Metal_Stack_List__c
                            || MapIPProdCompfromConfig.get(PTnum).get(IPID).Product_External_ID__c  != PTnumvsIPWrapMap.get(IPID).baseIP.IP_Number__c
                        ){   
                            UpsertMap.put(IPID,PTnumvsIPWrapMap.get(IPID));                
                            IpListUpdated.add(IPID);
                         } 
                    }
                    else if(!MapIPProdCompfromConfig.get(PTnum).containskey(IPID)
                            &&  PTnumvsIPWrapMap.containsKey(IPID)){
                        UpsertMap.put(IPID,PTnumvsIPWrapMap.get(IPID));                   
                        system.debug('[Debug: Insert Block]' + PTnumvsIPWrapMap.containskey(IPID));
                        IpListInserted.add(IPID);
                       system.debug('IPID1'+IPID);
                    }
                                                    
                }  
                else if(!MapIPProdCompfromConfig.containskey(PTnum)
                            &&  PTnumvsIPWrapMap.containsKey(IPID)){
                        system.debug('IPID2'+IPID);
                        UpsertMap.put(IPID,PTnumvsIPWrapMap.get(IPID));
                        IpListInserted.add(IPID);
                }                                                   
            }
            if(!UpsertMap.isEmpty()){
               finalUpsertMap.put(PTnum,UpsertMap); 
            }
            if(!IpListUpdated.isEmpty()){
                tempMap.put('Update',IpListUpdated);
           }
            if(!IpListInserted.isEmpty()){
                tempMap.put('Insert',IpListInserted);
            }  
            //system.debug(finalUpsertMap+'finalUpsertMap');
            system.debug(UpsertMap+'UpsertMap');                
            List<string> IpListDeleted = new List<string>();
            for(string PTs : MapIPProdCompfromConfig.keyset()){
                if(PTnum == PTs){
                    Map<string,Product2> innerMap = MapIPProdCompfromConfig.get(PTs);
                    List<string> tempIPs = MapIPnumbersfromIPPTMap.get(PTnum);
                    set<String> tempIpSet = new set<String>();
                        if(!tempIPs.isEmpty()){
                            for(string Ips:tempIPs){
                                tempIpSet.add(Ips);
                            }
                        }
                        for(string Ips: innerMap.keyset()){
                            if(!tempIpSet.contains(Ips) || tempIPs.isEmpty()){
                                IpListDeleted.add(Ips);
                            }
                        }
                }
            }
            system.debug('IpListInserted'+IpListInserted);
            system.debug('IpListUpdated'+IpListUpdated);
            system.debug('IpListDeleted'+IpListDeleted);

            if(!IpListDeleted.isEmpty()){
                tempMap.put('Delete',IpListDeleted);
                finalDeleteMap.put(PTnum,IpListDeleted);
                
            }
            if(!tempMap.isEmpty()){
                finalMap.put(PTnum,tempMap);
            }
            system.debug('finalDeleteMap1'+finalDeleteMap);                    
        } 
        system.debug(finalUpsertMap+'finalUpsertMap1'); 
        system.debug('finalMap'+finalMap);  
        return finalMap ;
    }
    public class BaseIPandDesignKit{
        public base_ip__c baseIP {get ; set; }
        public IP__c designkitIP {get ; set; }
        
        public BaseIPandDesignKit(){
            this.baseIP = new base_ip__c() ; 
            this.designkitIP = new  IP__c(); 
        }
    }
    /*
        Apex Method Name :  updateIPData
        parameter:          No Parameter
        Return Type:        PageReference
        Reason:             This method handles all IP data Update/insert/Delete
    */
    public void updateIPData(string PTNumEach){
        string PTnumEach1 = PTNumEach;
        Map<String, List<String>> validatedIPDataDeleteMap = new Map<String, List<String>>() ; 
        Map<String, map<string,CPQIPDataUpdateReportController.BaseIPandDesignKit>> validatedIPDataUpsertMap = new Map<String, map<string,CPQIPDataUpdateReportController.BaseIPandDesignKit>>();
        if(finalUpsertMap.containsKey(PTnumEach1)){
            map<string,CPQIPDataUpdateReportController.BaseIPandDesignKit> tempMap1 = new map<string,CPQIPDataUpdateReportController.BaseIPandDesignKit>();
            tempMap1 = finalUpsertMap.get(PTnumEach1);
            validatedIPDataUpsertMap.put(PTnumEach1,tempMap1);
            
        }
        if(finalDeleteMap.containsKey(PTnumEach1)){
            List<String> tempList = new List<String>();
            tempList = finalDeleteMap.get(PTnumEach1);
            validatedIPDataDeleteMap.put(PTnumEach1,tempList);          
        }    
        //Map<string,Product2> deviceVsProductMap = new Map<string,Product2>();
        //Map<String, map<string,CPQIPDataUpdateReportController.BaseIPandDesignKit>> validatedIPDataUpsertMap = finalUpsertMap;
        system.debug('validatedIPDataUpsertMap'+validatedIPDataUpsertMap);
        system.debug('MapbundlePTs'+MapbundlePTs);
        system.debug('validatedIPDataDeleteMap'+validatedIPDataDeleteMap);

        Map<String,Product2> UpsertIPProductMap = new Map<String,Product2>();
        List<Apttus_Config2__PriceListItem__c> UpsertPricelistItems = new List<Apttus_Config2__PriceListItem__c>();
        List<Apttus_Config2__PriceList__c> ListPriceList = new List<Apttus_Config2__PriceList__c> (); 
        List<Apttus_Config2__ProductOptionComponent__c> InsertProdOptionComp = new List<Apttus_Config2__ProductOptionComponent__c>();
        Map<String,Id> MapProductOption = new Map<String,Id>();
        List<Apttus_Config2__ProductClassification__c> prodClassificationToDelete = new List<Apttus_Config2__ProductClassification__c>();
        //Delete Apttus_Config2__ProductOptionComponent__c associated to IPs
        list<Apttus_Config2__ProductOptionComponent__c> ipDeleteList = new list<Apttus_Config2__ProductOptionComponent__c>();
        set<string> tempDeleteList = new set<string>();
        system.debug('validatedIPDataDeleteMap'+validatedIPDataDeleteMap);
        if(!validatedIPDataDeleteMap.isEmpty()){
            for(List<String> ipToBeDeleted: validatedIPDataDeleteMap.values()){
                 tempDeleteList.addAll(ipToBeDeleted); 
            }
            system.debug('tempDeleteList'+tempDeleteList);            
            ipDeleteList = [select id from Apttus_Config2__ProductOptionComponent__c where Apttus_Config2__ComponentProductId__r.ProductCode IN: tempDeleteList];
            if(!ipDeleteList.isEmpty()){
                delete ipDeleteList;
            }
            prodClassificationToDelete = [select id from Apttus_Config2__ProductClassification__c where Apttus_Config2__ProductId__r.Productcode IN: tempDeleteList];
            system.debug('ipDeleteList'+ipDeleteList);
            system.debug('prodClassificationToDelete'+prodClassificationToDelete);
        }
        if(!prodClassificationToDelete.isEmpty()){       
            delete prodClassificationToDelete;
            system.debug('prodClassificationToDelete1'+prodClassificationToDelete);
        }
       system.debug('validatedIPDataUpsertMap'+validatedIPDataUpsertMap);
        if(!validatedIPDataUpsertMap.isEmpty()){
        for(Product2 prod :  [SELECT    ID
                                        , Apttus_Config2__ConfigurationType__c
                                        , PT_Number__c
                                        , Product_External_ID__c
                                        , family
                                        , Geometry__c
                                        , Description
                              FROM      Product2
                              WHERE       (family = 'Devices'
                              AND        Apttus_Config2__ConfigurationType__c = 'Option')
                              ]){
                //deviceVsProductMap.put(prod.Product_External_ID__c, prod);//Uncommented by Ravi Teja 08012017 Case#00073306
                //Added by Ravi Teja 08012017 Case#00073306
                for(Product2 bp: MapbundlePTs.values()){
                    if(prod.Product_External_ID__c.contains(bp.Product_External_ID__c) && prod.Description != null){
                        for(String device: prod.Description.split(',')){
                            deviceVsProductMap.put(bp.Product_External_ID__c+'_'+device,prod);
                        }
                    }
                }
        }        
        system.debug('deviceVsProductMap'+deviceVsProductMap); 
        system.debug('validatedIPDataUpsertMap'+validatedIPDataUpsertMap);
        for(String PTnumber : validatedIPDataUpsertMap.keyset()){
            for(String IPNum : validatedIPDataUpsertMap.get(PTnumber).keyset()){
                if(!UpsertIPProductMap.keyset().contains(IPNum)){
                    UpsertIPProductMap.put(IPNum,getIPProduct(validatedIPDataUpsertMap.get(PTnumber).get(IPNum),MapbundlePTs.get(PTnumber)));
                }
            }
        }
        system.debug('[debug: IP Product Map]'+UpsertIPProductMap);
        upsert UpsertIPProductMap.values() Product_External_ID__c ; 
        if(!UpsertIPProductMap.isEmpty()){
            ListPriceList = [SELECT id,name from Apttus_Config2__PriceList__c];
            integer ComponentCount = 1;
            for(Product2 IpProd : UpsertIPProductMap.values()){
                UpsertPricelistItems.addAll(getPriceListItem(ListPriceList ,IpProd));
                
            }
            for(Apttus_Config2__ProductOptionGroup__c prodOptionGrp: [select    id
                                                                                ,name
                                                                                ,Apttus_Config2__ProductId__r.PT_Number__c 
                                                                                , Product_Option_Grp_External_ID__c
                                                                      from      Apttus_Config2__ProductOptionGroup__c 
                                                                      where     Apttus_Config2__ProductId__r.PT_Number__c IN :validatedIPDataUpsertMap.keyset()] ){
                MapProductOption.put(prodOptionGrp.Product_Option_Grp_External_ID__c, prodOptionGrp.ID);
                system.debug('[debug: Product Option Group Name]'+prodOptionGrp.Product_Option_Grp_External_ID__c);
            }
            system.debug('MapProductOption'+MapProductOption);
            for(String PTnumber : validatedIPDataUpsertMap.keyset()){
                for(String IPNum : validatedIPDataUpsertMap.get(PTnumber).keyset()){
                    system.debug('[debug: Bundle Product]'+MapbundlePTs.get(PTnumber));
                    InsertProdOptionComp.add(getProductOptionComponent(MapProductOption,UpsertIPProductMap.get(IPNum) ,MapbundlePTs.get(PTnumber), ComponentCount ++ ));
                }
            }
            system.debug('InsertProdOptionComp'+InsertProdOptionComp);
        }
        system.debug('[debug: IP Product Price List Items ]'+UpsertPricelistItems);
        system.debug('[debug: IP Product Product option component]'+InsertProdOptionComp);
        upsert UpsertPricelistItems PriceListItemExternal_ID__c ; 
        upsert InsertProdOptionComp Option_Component_External_ID__c ; 
        system.debug('[UpsertPricelistItems]'+ UpsertPricelistItems);
        system.debug('[InsertProdOptionComp]'+ InsertProdOptionComp);
        /*:::: Constraint Rule section::::*/
        map<String ,string> ConstraintRuleMap = new map<String ,string>();
        ConstraintRuleMap = getConstraintRule(validatedIPDataUpsertMap,UpsertIPProductMap,MapbundlePTs);
        
        List<Apttus_Config2__ConstraintRuleCondition__c> FinalConstraintRuleCondition = new List<Apttus_Config2__ConstraintRuleCondition__c>();
        List<Apttus_Config2__ConstraintRuleAction__c> FinalListConstraintRuleAction = new List<Apttus_Config2__ConstraintRuleAction__c>();
        for(String PTnumber : validatedIPDataUpsertMap.keyset()){
            for(String IPNum : validatedIPDataUpsertMap.get(PTnumber).keyset()){
                if(UpsertIPProductMap.get(IPNum) != NULL && UpsertIPProductMap.get(IPNum).IP_Device_List__c != NULL){
                    FinalConstraintRuleCondition.add(getTempConstraintRuleCondition(MapbundlePTs.get(PTnumber).Product_External_ID__c+'_'+ IPNum , ConstraintRuleMap,UpsertIPProductMap.get(IPNum) ));
                    FinalListConstraintRuleAction.addAll(getConstraintRuleAction(UpsertIPProductMap.get(IPNum) 
                                                                                 , ConstraintRuleMap
                                                                                 , IPnum
                                                                                 , MapbundlePTs.get(PTnumber).Product_External_ID__c 
                                                                                 , deviceVsProductMap));
                }
            }
        }
        system.debug('FinalConstraintRuleCondition'+FinalConstraintRuleCondition);
        system.debug('FinalListConstraintRuleAction'+FinalListConstraintRuleAction);
        Upsert FinalConstraintRuleCondition Constraint_Rule_Condition_External_ID__c;
        upsert FinalListConstraintRuleAction Constraint_Rule_Action_External_ID__c ;
        system.debug('[FinalConstraintRuleCondition]'+ FinalConstraintRuleCondition);
        system.debug('[FinalListConstraintRuleAction]'+ FinalListConstraintRuleAction); 
        //Upsert Product Classification
        Map<String,String> MapClassificationHierarchyIP = new Map<String,String>();
        List<Apttus_Config2__ProductClassification__c> IPProdClassification = new List<Apttus_Config2__ProductClassification__c>();
        for(Apttus_Config2__ClassificationHierarchy__c classHierarchy : [SELECT    ID,
                                                                                   NAME,
                                                                                   Category_Hierarchy_External_ID__c
                                                                         FROM      Apttus_Config2__ClassificationHierarchy__c 
                                                                         WHERE     Category_Hierarchy_External_ID__c
                                                                         IN        ('Phys','AMS','Other','IO','Logic','Memory','14nm','20nm','28nm','35nm', '40nm','55nm','65nm','130nm','160nm','180nm','>180nm')]){
            MapClassificationHierarchyIP.put(classHierarchy.Category_Hierarchy_External_ID__c.toUpperCase(),classHierarchy.ID);
        }
        for(product2 prod : UpsertIPProductMap.values()){
            IPProdClassification.add(getProductClassification('IP',prod,MapClassificationHierarchyIP));
        } 
        //Putting in try catch because of the exception in managed class
        try{
        upsert IPProdClassification Product_Classification_External_ID__c ;
        }catch(exception e){}
        system.debug('[IPProdClassification]'+ IPProdClassification );
        }
        //PageReference VFPage = new PageReference('/apex/CPQIPDataUpdateReport');
        //return VFPage.setRedirect(true);
    }
    public Apttus_Config2__ProductClassification__c getProductClassification(String TypeProd, Product2 IPProd, Map<String,String> MapClassificationHierarchyIP){
        //variable to store geometry value. 
        String strGeom; 
        //if the geometry contains nm then change the geomerty value to UM format.
        if( !IPProd.Geometry__c.contains('>') 
            && IPProd.Geometry__c.contains('UM')){
            Integer geom = Integer.valueOf(decimal.valueOf(IPProd.Geometry__c.replace('UM',''))*1000);
            system.debug('DEBUG: PS: Length of the string'+String.valueOf(geom).length());
            String geomValue = String.valueOf(geom); 
            
            system.debug('DEBUG: PS: geomvalue string'+ geomValue);
            strGeom = geomValue + 'nm';
        }
        //else UM value would be considered
        else{
            strGeom = IPProd.Geometry__c == '>0.18UM' 
                        ? '>180nm'
                        : IPProd.Geometry__c;
        }
        system.debug('strGeom'+strGeom);
        system.debug('MapClassificationHierarchyIP'+MapClassificationHierarchyIP);
        Apttus_Config2__ProductClassification__c TempProdCalssification = new Apttus_Config2__ProductClassification__c ();
        
        //if(TypeProd == 'IP'){
            String ipType = MapClassificationHierarchyIP.containsKey(IPProd.APTPS_IP_Type__c) ? IPProd.APTPS_IP_Type__c : 'OTHER';
            system.debug('ipType'+ipType);
            TempProdCalssification.Apttus_Config2__ClassificationId__c    = MapClassificationHierarchyIP.get(ipType);
            TempProdCalssification.Product_Classification_External_ID__c  = IPProd.Product_External_ID__c + '_'+ ipType;
        //}
       
        /*else{
            TempProdCalssification.Apttus_Config2__ClassificationId__c    = MapClassificationHierarchyIP.get(strGeom.toUpperCase());    
            TempProdCalssification.Product_Classification_External_ID__c  = IPProd.Product_External_ID__c  + '_' +  strGeom.toUpperCase();
        }*/
        system.debug('Product_Classification_External_ID__c'+TempProdCalssification.Product_Classification_External_ID__c );
        system.debug('Apttus_Config2__ClassificationId__c '+TempProdCalssification.Apttus_Config2__ClassificationId__c );
        TempProdCalssification.Apttus_Config2__DefaultQuantity__c         = 1; 
        TempProdCalssification.Apttus_Config2__MaxQuantity__c             = 1;
        TempProdCalssification.Apttus_Config2__MinQuantity__c             = 0;
        TempProdCalssification.Apttus_Config2__Modifiable__c              = TRUE;
        TempProdCalssification.Apttus_Config2__ProductId__c               = IPProd.ID;
        if(TempProdCalssification.Apttus_Config2__ClassificationId__c != null){
            return TempProdCalssification;
        }
        else{
            return null;
        }
    }   
    public product2 getIPProduct(BaseIPandDesignKit IPDetails,product2 ParentProduct){
        system.debug('IPDetails'+IPDetails);
        
        if(IPDetails != null){
            product2 prod = new product2();
            //if(IPDetails.baseIP.description__c != null){
                    prod.Product_External_ID__c                 = IPDetails.baseIP.name;
                    prod.ProductCode                            = IPDetails.baseIP.name;
                    prod.Description__c                         = IPDetails.baseIP.name + '\r\nIP Type:'+IPDetails.baseIP.IP_Type__c+'\r\nVendor: '+IPDetails.designkitIP.Ip_Vendor__c+'\r\nLifecycle: '+IPDetails.designkitIP.Lifecycle__c  ;
                    prod.IsActive                               = TRUE;
                    prod.Geometry__c                            = ParentProduct.Geometry__c;
                    prod.Apttus_Config2__ConfigurationType__c   = 'Option';
                    prod.Apttus_Config2__HasAttributes__c       = FALSE;
                    prod.Apttus_Config2__HasDefaults__c         = FALSE;
                    prod.Apttus_Config2__HasOptions__c          = FALSE;
                    prod.Apttus_Config2__HasSearchAttributes__c = FALSE;
                    prod.APTPS_IP_Lifecycle__c                  = IPDetails.designkitIP.Lifecycle__c ;
                    prod.APTPS_IP_Type__c                       = IPDetails.baseIP.IP_Type__c ; 
                    prod.APTPS_IP_Vendors__c                    = IPDetails.designkitIP.Ip_Vendor__c;
                    prod.Apttus_Config2__Customizable__c        = FALSE;
                    prod.Family                                 = 'IPs';
                    //prod.Name                                   = IPDetails.baseIP.description__c ;
                    //Added By Ravi Teja.B On 22/02/17 for Case#00061409
                    if(IPDetails.baseIP.description__c != null && IPDetails.baseIP.description__c != ''){
                        prod.Name = ('('+IPDetails.baseIP.name+')' + ' ' + '('+IPDetails.baseIP.description__c.replaceAll('[^\\x00-\\x7F]', ' ')+')').replaceAll('  ',' ');
                    }
                    prod.Apttus_Config2__Uom__c                 = 'Each';
                    prod.IP_Device_List__c                      = IPDetails.designkitIP.IP_Device_List__c;
                    prod.APTPS_Metal_Stack__c                   = IPDetails.designkitIP.Metal_Stack_List__c;
                    prod.Description                            = IPDetails.designkitIP.Metal_Stack_List__c;
                    prod.IP_PT_ID__c                            = IPDetails.baseIP.id;
                    prod.Apttus_Config2__IconId__c              = null;                
            return prod;
        }
        else{
            return null;
        }
    }
    public List<Apttus_Config2__PriceListItem__c> getPriceListItem (List<Apttus_Config2__PriceList__c> ListPriceList , product2 prod ){
        List<Apttus_Config2__PriceListItem__c> FinalPrcList = new List<Apttus_Config2__PriceListItem__c>();
        for(Apttus_Config2__PriceList__c PrcList : ListPriceList){
            Apttus_Config2__PriceListItem__c TempPriceListItem = new Apttus_Config2__PriceListItem__c ();
                TempPriceListItem.Apttus_Config2__Active__c                        = TRUE;
                TempPriceListItem.Apttus_Config2__AllocateGroupAdjustment__c       = TRUE;
                TempPriceListItem.Apttus_Config2__AllowManualAdjustment__c         = TRUE;
                TempPriceListItem.Apttus_Config2__AllowProration__c                = FALSE;
                TempPriceListItem.Apttus_Config2__AutoCascadeQuantity__c           = FALSE;
                TempPriceListItem.Apttus_Config2__AutoCascadeSellingTerm__c        = FALSE;
                TempPriceListItem.Apttus_Config2__RollupPriceToBundle__c           = TRUE;
                TempPriceListItem.Apttus_Config2__ChargeType__c                    = 'Standard Price';
                TempPriceListItem.Apttus_Config2__EnableCommitment__c              = FALSE;
                TempPriceListItem.Apttus_Config2__EnablePriceRamp__c               = FALSE;
                TempPriceListItem.Apttus_Config2__IsQuantityReadOnly__c            = FALSE;
                TempPriceListItem.Apttus_Config2__IsSellingTermReadOnly__c         = FALSE;
                TempPriceListItem.Apttus_Config2__IsUsageTierModifiable__c         = FALSE;
                TempPriceListItem.Apttus_Config2__ListPrice__c                     = 0;
                TempPriceListItem.Apttus_Config2__PriceIncludedInBundle__c         = FALSE;
                TempPriceListItem.Apttus_Config2__PriceListId__c                   = PrcList.ID;
                TempPriceListItem.Apttus_Config2__PriceMethod__c                   = 'Per Unit';
                TempPriceListItem.Apttus_Config2__PriceType__c                     = 'One Time';
                TempPriceListItem.Apttus_Config2__PriceUom__c                      = 'Each';
                TempPriceListItem.Apttus_Config2__ProductId__c                     = prod.id; 
                TempPriceListItem.PriceListItemExternal_ID__c                      = prod.Product_External_ID__c +'_'+PrcList.name;
            FinalPrcList.add(TempPriceListItem);
        }
        Return FinalPrcList;
    }
    public Apttus_Config2__ProductOptionComponent__c getProductOptionComponent(Map<String,Id>MapProductOption, product2 prod,product2 ParentProduct, integer ComponentCount ){
        Apttus_Config2__ProductOptionComponent__c TempProdOptionComponent = new Apttus_Config2__ProductOptionComponent__c();
            TempProdOptionComponent.Apttus_Config2__AllowCloning__c        = FALSE;
            TempProdOptionComponent.Apttus_Config2__ComponentProductId__c  = prod.id;
            TempProdOptionComponent.Apttus_Config2__Default__c             = FALSE;
            TempProdOptionComponent.Apttus_Config2__Modifiable__c          = FALSE;
            TempProdOptionComponent.Apttus_Config2__ParentProductId__c     = ParentProduct.id;
            if(prod.family == 'IPs' && (prod.APTPS_IP_Type__c != 'NVM' && prod.APTPS_IP_Type__c != 'LOGIC' && prod.APTPS_IP_Type__c != 'MEMORY' && prod.APTPS_IP_Type__c != 'OTHER' && prod.APTPS_IP_Type__c != 'IO' && prod.APTPS_IP_Type__c != 'PHYS' && prod.APTPS_IP_Type__c != 'AMS')){
                TempProdOptionComponent.Apttus_Config2__ProductOptionGroupId__c= MapProductOption.get(ParentProduct.Product_External_ID__c +'_OTHER');              
            }
            else if(prod.family == 'IPs'){
                if(!prod.ProductCode.contains('IPE'))
                TempProdOptionComponent.Apttus_Config2__ProductOptionGroupId__c= MapProductOption.get(ParentProduct.Product_External_ID__c +'_'+prod.APTPS_IP_Type__c);
                else
                TempProdOptionComponent.Apttus_Config2__ProductOptionGroupId__c= MapProductOption.get(ParentProduct.Product_External_ID__c +'_ASIC_'+prod.APTPS_IP_Type__c);
            }
            TempProdOptionComponent.Option_Component_External_ID__c        = prod.Product_External_ID__c.contains(ParentProduct.Product_External_ID__c)? prod.Product_External_ID__c: ParentProduct.Product_External_ID__c+ '_'+ prod.Product_External_ID__c;
            TempProdOptionComponent.Apttus_Config2__RelationshipType__c    = 'Option';
            TempProdOptionComponent.Apttus_Config2__Required__c            = FALSE;
            TempProdOptionComponent.Apttus_Config2__Sequence__c            = ComponentCount;
        return TempProdOptionComponent;
    }
    public Map<String,String> getConstraintRule(Map<String, map<string,BaseIPandDesignKit>> MapPTvsIPs , Map<String,Product2> IPProductMap,  Map<String,product2> MapbundlePTs){
        List<Apttus_Config2__ConstraintRule__c> FinalConstraintRuleList = new List<Apttus_Config2__ConstraintRule__c>();
        Map<String,String> FinalConstraintRuleMap = new Map<String,string>(); //Key: Constraint rule name && Value: Constraint rule ID;
        for(String PTnum: MapPTvsIPs.keyset()){
            for(String IPnum: MapPTvsIPs.get(PTnum).keyset()){
                if(IPProductMap.get(IPnum).IP_Device_List__c != NULL ){
                    FinalConstraintRuleList.add(getTempConstraintRule(MapbundlePTs.get(PTnum).Product_External_ID__c+'_'+IPnum)); 
                }
            }
        }
        upsert FinalConstraintRuleList Constraint_Rule_External_Id__c;
        
        for(Apttus_Config2__ConstraintRule__c crule : FinalConstraintRuleList){
           FinalConstraintRuleMap.put(crule.Constraint_Rule_External_Id__c, crule.id);
        }
        return FinalConstraintRuleMap;
    }
    public Apttus_Config2__ConstraintRuleCondition__c getTempConstraintRuleCondition(String ConstraintRuleName , map<String ,string> ConstraintRuleMap, product2 ProductCon ){
        Apttus_Config2__ConstraintRuleCondition__c TempConstraintRuleCond = new Apttus_Config2__ConstraintRuleCondition__c();
        TempConstraintRuleCond.Apttus_Config2__ConstraintRuleId__c             = ConstraintRuleMap.get(ConstraintRuleName);
        TempConstraintRuleCond.Name                                            = ConstraintRuleName;
        TempConstraintRuleCond.Constraint_Rule_Condition_External_ID__c        = ConstraintRuleName;
        TempConstraintRuleCond.Apttus_Config2__MatchInAsset__c                 = FALSE;
        TempConstraintRuleCond.Apttus_Config2__MatchInCartOptions__c           = FALSE;
        TempConstraintRuleCond.Apttus_Config2__MatchInLocation__c              = FALSE;
        TempConstraintRuleCond.Apttus_Config2__MatchInOptions__c               = TRUE;
       TempConstraintRuleCond.Apttus_Config2__MatchInPrimaryLines__c          = FALSE;
        TempConstraintRuleCond.Apttus_Config2__ProductId__c                    = ProductCon.Id;
        TempConstraintRuleCond.Apttus_Config2__ProductScope__c                 = 'Product';
        return TempConstraintRuleCond;
    }
    public List<Apttus_Config2__ConstraintRuleAction__c> getConstraintRuleAction (Product2 IPProd, map<String ,string> ConstraintRuleMap, String ConstraintRule, String ParentProductExtID, Map<string,Product2> deviceVsProductMap){
        String ConstraintRuleName = ParentProductExtID+'_'+ConstraintRule ;
        system.debug('[Debug: Constraint rule name:]'+ConstraintRuleName);
        List<Apttus_Config2__ConstraintRuleAction__c> ConstraintRuleActionRetunList = new List<Apttus_Config2__ConstraintRuleAction__c>();  
        system.debug('IPProd.IP_Device_List__c'+IPProd.IP_Device_List__c);
        if(ConstraintRuleMap.containsKey(ConstraintRuleName) && IPProd.IP_Device_List__c != NULL ) {
        system.debug('Inside loop'+ConstraintRuleMap.containsKey(ConstraintRuleName));
            for(String devCode : IPProd.IP_Device_List__c.split(',')){
                devCode = devCode.trim();
                Product2 DevPord = deviceVsProductMap.get(ParentProductExtID+'_'+devCode);
                system.debug('devCodeCheck'+devCode);
                system.debug('String.isEmpty(devCode)'+String.isEmpty(devCode));
                system.debug('deviceVsProductMap'+deviceVsProductMap);
                system.debug('DevPord'+DevPord);
                system.debug('deviceVsProductMap.containsKey(ParentProductExtID+devCode.trim())'+deviceVsProductMap.containsKey(ParentProductExtID+'_'+devCode.trim()));
                if(!String.isEmpty(devCode) && DevPord != NULL && deviceVsProductMap.containsKey(ParentProductExtID+'_'+devCode.trim())){
                //if(!String.isEmpty(devCode) && DevPord != NULL){
                    
                    Apttus_Config2__ConstraintRuleAction__c TempConstraintRuleAction         = new Apttus_Config2__ConstraintRuleAction__c ();
                    TempConstraintRuleAction.Apttus_Config2__ActionDisposition__c            = 'Warning';
                    TempConstraintRuleAction.Apttus_Config2__ActionIntent__c                 = 'Auto Include';
                    TempConstraintRuleAction.Apttus_Config2__ActionType__c                   = 'Inclusion';
                    TempConstraintRuleAction.Apttus_Config2__AutoInclude__c                  = FALSE;              
                    TempConstraintRuleAction.Apttus_Config2__ConstraintRuleId__c             = ConstraintRuleMap.get(ConstraintRuleName);
                    TempConstraintRuleAction.Name                                            = ConstraintRuleName+'_'+ devCode;
                    TempConstraintRuleAction.Constraint_Rule_Action_External_ID__c           = ConstraintRuleName+'_'+ devCode;
                    TempConstraintRuleAction.Apttus_Config2__AutoExclude__c                  = FALSE;
                    TempConstraintRuleAction.Apttus_Config2__MatchInAsset__c                 = FALSE;
                    TempConstraintRuleAction.Apttus_Config2__MatchInCartOptions__c           = FALSE;
                    TempConstraintRuleAction.Apttus_Config2__MatchInOptions__c               = TRUE;
                    TempConstraintRuleAction.Apttus_Config2__MatchInPrimaryLines__c          = FALSE;
                    TempConstraintRuleAction.Apttus_Config2__ProductId__c                    = DevPord.id;
                    TempConstraintRuleAction.Apttus_Config2__ProductScope__c                 = 'Product';
                    ConstraintRuleActionRetunList.add(TempConstraintRuleAction);
                }
            }
            
        }
        system.debug('ConstraintRuleActionRetunList'+ConstraintRuleActionRetunList);
        return ConstraintRuleActionRetunList;
    } 
     public Apttus_Config2__ConstraintRule__c getTempConstraintRule(String ConstraintRuleName){
        Apttus_Config2__ConstraintRule__c TempConstraintRule = new Apttus_Config2__ConstraintRule__c();
            TempConstraintRule.Apttus_Config2__Active__c                = TRUE;
            TempConstraintRule.Constraint_Rule_External_Id__c           = ConstraintRuleName;
            TempConstraintRule.Name                                     = ConstraintRuleName;
            TempConstraintRule.Apttus_Config2__MatchInAsset__c          = FALSE;
            TempConstraintRule.Apttus_Config2__MatchInOptions__c        = FALSE;
            TempConstraintRule.Apttus_Config2__MatchInPrimaryLines__c   = FALSE;
       return TempConstraintRule;
    }
    public PageReference processIPData()
    {
        set<string> PTno = new set<string>();
        for(string PT: validatedIPDataMap.keyset()){
             PTno.add(PT);
        }
        system.debug('PTno'+PTno );
        BatchProcessIpData b = new BatchProcessIpData(PTno);
        database.executebatch(b,1);
        PageReference VFPage = new PageReference('/apex/CPQUpdateMonitor?PageType=CPQIPUpdate');
        return VFPage.setRedirect(true);
    }
}