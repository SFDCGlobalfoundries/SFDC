/* 
    Company       :   Cognizant Technologies PTE Ltd.
 
    Initials        Date          Description
-----------------------------------------------------------------------------------------------------------------------
    Onkar Kumar     01/12/2014    Created the Class
    Sameer Matale   03/05/2014    Changes to avoid showing duplicate reticle id in a row in device based view
    NJain           04/29/2014    Method return type changed for returning Device as key of Map for displaying unique
                                  'FAB' and 'Device Type' of the reticles associated with it.
*/

public class ROS_STFObsolescenceProcess {

    public void STFObsolescenceProcess(list<SelectedReticleWrapper> reticleList) {
       
    }
    
    //Nikhil-- Commenting old method
    /*public static Map<string,STFclassWrapper> reticlDeviceLevelDisplay(List<Reticle__c> recList){    
        Set<String> deviceId = new Set<String>();

        Map<string,STFclassWrapper> retcileMap = new Map<string,STFclassWrapper>();

        MAP<Id,Reticle__c> recMap =  new Map<Id,Reticle__c>();
        for(Reticle__c resObj : recList){
            recMap.put(resObj.id,resObj);
        }   

        for(AggregateResult  obj : [Select GF_Device_Id__c from reticle_device__c where 
                                Reticle__c in : recList group by GF_Device_Id__c]){
            if((string)obj.get('GF_Device_Id__c') != null){
                deviceId.add((string)obj.get('GF_Device_Id__c'));
            }
        }
        List<reticle_device__c> GF = [Select id,Reticle__c,GF_Device_Id__c from reticle_device__c where GF_Device_Id__c in : deviceId and Reticle__r.Reticle_workflow_Status__c =: 'Pending for STF Obsolescence'];
        for(string str : deviceId){
            Set<Reticle__c> GFR = new Set<Reticle__c>();
            List<STFclassWrapper> GFRList = new List<STFclassWrapper>();
            for(reticle_device__c obj : GF){
                if(obj.GF_Device_Id__c == str){
                    if(recMap.get(obj.Reticle__c) != null){
                        GFR.add(recMap.get(obj.Reticle__c));    
                    }
                    
                }
            }
            retcileMap.put(str,new STFclassWrapper(new List<Reticle__c>(GFR)));
        }
        return retcileMap;
    }*/
    /*
    //Nikhil-- New method for displaying Fab/Device Type/Customer Device Id
    public static Map<Device__c,STFclassWrapper> reticlDeviceLevelDisplay(List<Reticle__c> recList){    
        Set<String> deviceId = new Set<String>();

        Map<Device__c,STFclassWrapper> retcileMap = new Map<Device__c,STFclassWrapper>();

        MAP<Id,Reticle__c> recMap =  new Map<Id,Reticle__c>();
        for(Reticle__c resObj : recList){
            recMap.put(resObj.id,resObj);
        }   

        for(AggregateResult  obj : [Select GF_Device_Id__c from reticle_device__c where 
                                Reticle__c in : recList group by GF_Device_Id__c limit 50000]){
            if((string)obj.get('GF_Device_Id__c') != null){
                deviceId.add((string)obj.get('GF_Device_Id__c'));
            }
        }
        //DBiswal 12072015
        List<reticle_device__c> GF = [Select id,Reticle__c,GF_Device_Id__c from reticle_device__c where GF_Device_Id__c in : deviceId and (Reticle__r.Reticle_Workflow_Status__c =:'Pending for STF Obsolescence' OR Reticle__r.Reticle_Workflow_Status__c =:'Pending for EUC Form,Pending for STF Obsolescence') limit 50000];
        
        String strFabs;
        String strDeviceTypes;
        String strCustomerDevID;
        Id strAccountName;
        
        Set<String> setFabs = new Set<String>();
        Set<String> setDeviceTypes = new Set<String>();
        Set<String> setCustomerDevID = new Set<String>();
        
        for(string str : deviceId){
            Set<Reticle__c> GFR = new Set<Reticle__c>();
            List<STFclassWrapper> GFRList = new List<STFclassWrapper>();
            strFabs = '';
            strDeviceTypes = '';
            strCustomerDevID = '';
            
            setFabs.clear();
            setDeviceTypes.clear();
            setCustomerDevID.clear();
            
            for(reticle_device__c obj : GF){
                if(obj.GF_Device_Id__c == str){
                    if(recMap.get(obj.Reticle__c) != null){
                        GFR.add(recMap.get(obj.Reticle__c));
                        if(recMap.get(obj.Reticle__c).FabStr__c !=NULL && recMap.get(obj.Reticle__c).FabStr__c != ''){
                            setFabs.addAll(recMap.get(obj.Reticle__c).FabStr__c.split(','));
                        }
                        setDeviceTypes.add(recMap.get(obj.Reticle__c).Device_Type__c);
                        if(recMap.get(obj.Reticle__c).Device_ID__c !=NULL && recMap.get(obj.Reticle__c).Device_ID__c != ''){
                            setCustomerDevID.addAll(recMap.get(obj.Reticle__c).Device_ID__c.split(','));
                        }
                        strAccountName   = recMap.get(obj.Reticle__c).Account__c;
                    }
                }
            }
            for(String fabName: setFabs){
                strFabs = strFabs+ fabName+',';
            }
            for(String deviceType: setDeviceTypes){
                strDeviceTypes = strDeviceTypes + deviceType +',';
            }
            for(String customerDevId: setCustomerDevID){
                strCustomerDevID = strCustomerDevID + customerDevId +',';
            }
            
            if(strFabs.length()>0)
                strFabs = strFabs.subString(0,strFabs.length() -1);
            if(strDeviceTypes.length()>0)
                strDeviceTypes = strDeviceTypes.subString(0,strDeviceTypes.length() -1);
            if(strCustomerDevID.length()>0)
                strCustomerDevID = strCustomerDevID.subString(0,strCustomerDevID.length() -1);
            
            retcileMap.put(new Device__c(Name            = str,
                                         fab__c          = strFabs,
                                         Device_Type__c  = strDeviceTypes,
                                         Account__c      = strAccountName,
                                         CRMDID__c       = strCustomerDevID
                                         ),
                             new STFclassWrapper(new List<Reticle__c>(GFR)));
        }
        return retcileMap;
    }*/
    
    //DBiswal - for Apex time limit exceeded error
    public static Map<Device__c,STFclassWrapper> reticlDeviceLevelDisplay(List<Reticle__c> recList){    
        Map<Device__c,STFclassWrapper> retcileMap = new Map<Device__c,STFclassWrapper>();

        MAP<Id,Reticle__c> recMap =  new Map<Id,Reticle__c>();
        for(Reticle__c resObj : recList){
            recMap.put(resObj.id,resObj);
        }
               
        Map<String,List<Reticle__c>> retdevReticleMap = new Map<String,List<Reticle__c>>();
        
        for(reticle_device__c retdev : [Select id,Reticle__c,GF_Device_Id__c from reticle_device__c where Reticle__c in : recMap.keySet() AND GF_Device_Id__c != null and (Reticle__r.Reticle_Workflow_Status__c =:'Pending for STF Obsolescence' OR Reticle__r.Reticle_Workflow_Status__c =:'Pending for EUC Form,Pending for STF Obsolescence') limit 50000]){
            if(!retdevReticleMap.containskey(retdev.GF_Device_Id__c)){
                retdevReticleMap.put(retdev.GF_Device_Id__c, new List<Reticle__c>{recMap.get(retdev.Reticle__c)});
            } else {
                Set<Reticle__c> uniqueRets = new Set<Reticle__c>(retdevReticleMap.get(retdev.GF_Device_Id__c));
                uniqueRets.add(recMap.get(retdev.Reticle__c));
                retdevReticleMap.put(retdev.GF_Device_Id__c, new List<Reticle__c>(uniqueRets));
            }
        }
        
        String strFabs;
        String strDeviceTypes;
        String strCustomerDevID;
        Id strAccountName;
        
        Set<String> setFabs = new Set<String>();
        Set<String> setDeviceTypes = new Set<String>();
        Set<String> setCustomerDevID = new Set<String>();
        
        for(string str : retdevReticleMap.keySet()){
            Set<Reticle__c> GFR = new Set<Reticle__c>();
            List<STFclassWrapper> GFRList = new List<STFclassWrapper>();
            strFabs = '';
            strDeviceTypes = '';
            strCustomerDevID = '';
            
            setFabs.clear();
            setDeviceTypes.clear();
            setCustomerDevID.clear();
            
            for(Reticle__c ret : retdevReticleMap.get(str)){
                if(ret.FabStr__c !=NULL && ret.FabStr__c != ''){
                    setFabs.addAll(ret.FabStr__c.split(','));
                }
                setDeviceTypes.add(ret.Device_Type__c);
                if(ret.Device_ID__c !=NULL && ret.Device_ID__c != ''){
                    setCustomerDevID.addAll(ret.Device_ID__c.split(','));
                }
                strAccountName = ret.Account__c;
            }
            for(String fabName: setFabs){
                strFabs = strFabs+ fabName+',';
            }
            for(String deviceType: setDeviceTypes){
                strDeviceTypes = strDeviceTypes + deviceType +',';
            }
            for(String customerDevId: setCustomerDevID){
                strCustomerDevID = strCustomerDevID + customerDevId +',';
            }
            
            if(strFabs.length()>0)
                strFabs = strFabs.subString(0,strFabs.length() -1);
            if(strDeviceTypes.length()>0)
                strDeviceTypes = strDeviceTypes.subString(0,strDeviceTypes.length() -1);
            if(strCustomerDevID.length()>0)
                strCustomerDevID = strCustomerDevID.subString(0,strCustomerDevID.length() -1);
            
            retcileMap.put(new Device__c(Name            = str,
                                         fab__c          = strFabs,
                                         Device_Type__c  = strDeviceTypes,
                                         Account__c      = strAccountName,
                                         CRMDID__c       = strCustomerDevID
                                         ),
                             new STFclassWrapper(new List<Reticle__c>(retdevReticleMap.get(str))));
        }
        return retcileMap;
    }
    public class STFclassWrapper {
        public boolean isSelected {get;set;}
        public List<Reticle__c>  deviveRetcileList  {get;set;}

        public STFclassWrapper(List<Reticle__c> deviveRetcileList){
            this.deviveRetcileList = deviveRetcileList;
            isSelected = false;
        }
    }
}