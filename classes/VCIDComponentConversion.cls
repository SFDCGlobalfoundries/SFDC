/*
    Author: Ariz Solito
    Description: Apex class for IP declaration form matching
    History: 
    Asolito      06/25/2013    - Apex coded created
    Asolito      10/07/2013    - Update codes to make the filter more general to make the conversion process more linient
                                 in terms of querying the data
    Asolito      10/10/2013    - added fix to 430    
    Asolito      10/31/2013    - added enhancement for task 436 (unmapped VCID sub comps should also be converted)                               
    Asolito      11/07/2013    - Modified overall conversion logic due to bug discovered in production                                   
*/
public with sharing class VCIDComponentConversion {
    public static Boolean hasConversionRun = false; 
    
    //Method will generate VCID component records
    //this will be called via trigger 
    public static void convertToVCIDComponent(List<String> processRecs){
        List<IP_VCID_Sub_Component__c> recs = [SELECT id,CRM_DID__c,processID__c,technology__c,library__c,vendor__c,
                                                      customer__c,converted_ip_vcid_component__c,remarks__c,deviceId__c
                                                 FROM IP_VCID_Sub_Component__c
                                                 WHERE id IN :processRecs
                                                 AND converted_ip_vcid_component__c = null];
        
        //clear current VCID Component                                       
        for(IP_VCID_Sub_Component__c r: recs){
            r.converted_IP_VCID_Component__c = null;
        }                                                
        convertToVCIDComponent(recs);                                               
    }
    
    //Method will generate VCID component records
    //this will be called via batch apex 
    public static void convertToVCIDComponent(List<IP_VCID_Sub_Component__c> newRecs){              
        List<IP_VCID_Sub_Component__c> VCIDSubComps = new List<IP_VCID_Sub_Component__c>();
        
        //filter records with CRMDID values only for VCID component conversion 
        for(IP_VCID_Sub_Component__c n: newRecs){
            if(UtilsString.isNotBlank(n.CRM_DID__c)){
                VCIDSubComps.add(n);
            }   
        }
        
        if(VCIDSubComps.size() > 0){
            //set the conversion to only run once on a given process instance
            hasConversionRun = true;
            
            //delete all VCID component records with no related IP VCID sub components
            List<ip_vcid_component__c> delRecs = new List<ip_vcid_component__c>(); 
            List<ip_vcid_component__c> delRecs1 = new List<ip_vcid_component__c>(); 
            delRecs1 = [SELECT id,(SELECT id FROM ip_vcid_sub_component__r limit 1 ) FROM ip_vcid_component__c limit 5000];
            if(delRecs1.size()>0)
            {
                for(integer v=0; v< delRecs1.size();v++)
                {
                    if(delRecs1[v].ip_vcid_sub_component__r.size() == 0){
                        delRecs.add(delRecs1[v]);
                    }
                }
            }                               
                                           
        /*    for(ip_vcid_component__c v :[SELECT id,(SELECT id 
                                                      FROM ip_vcid_sub_component__r ) 
                                           FROM ip_vcid_component__c limit 10000]){
                if(v.ip_vcid_sub_component__r.size() == 0){
                    delRecs.add(v);
                }
            }  */          
            
            try {
                delete delRecs;
            } catch (Exception e){
                System.debug('IP VCID Conversion : Deletion failed');
            }
                                    
            Conversion conversion = new Conversion(VCIDSubComps);
            conversion.convert();
        }                                                                 
    }
    
    //Sub class for VCID conversion process
    public class Conversion {        
        private Set<IP_VCID_Sub_Component__c> CRMDIDFilteredSubComps;       
        private Map<String,IP_VCID_Sub_Component__c> initialVCIDSubComps;
        
        public Conversion(List<IP_VCID_Sub_Component__c> VCIDSubComps){                                         
            this.CRMDIDFilteredSubComps = new Set<IP_VCID_Sub_Component__c>();
            this.initialVCIDSubComps = new Map<String,IP_VCID_Sub_Component__c>();
            
            for(IP_VCID_Sub_Component__c v :VCIDSubComps){
                this.initialVCIDSubComps.put(v.id,v);
            }              
          
            Map<String,List<IP_VCID_Sub_Component__c>> subCompMap = new Map<String,List<IP_VCID_Sub_Component__c>>();
            for(IP_VCID_Sub_Component__c v: VCIDSubComps){                      
                //get the CRMDIDs from the vcid sub components 
                if(subCompMap.containsKey(v.CRM_DID__c)){
                    subCompMap.get(v.CRM_DID__c).add(v);
                } else {
                    subCompMap.put(v.CRM_DID__c,new List<IP_VCID_Sub_Component__c>{v});
                }                                                                
            }                                   
            
            //add vcid sub components filtered by CRMDIDs
            for(String c: filterByCRMDID(subCompMap.keyset())){
                 if(subCompMap.containsKey(c)){
                    this.CRMDIDFilteredSubComps.addAll(subCompMap.get(c));
                 }
            }
        }
        
        //Method will filter the vcid sub component records with matching records from
        //Device, Process, Process Tech and IP OIC Mapping objects
        public void convert(){   
           
            Set<String> processIDs = new Set<String>();  
            Set<Decimal> technologies = new Set<Decimal>();
            Set<String> libraries = new Set<String>();
            Set<String> vendors = new Set<String>();
                        
            //generate the vcid sub component filter components for process, process technology and ip oic mapping    
            for(IP_VCID_Sub_Component__c v: this.CRMDIDFilteredSubComps){
                //for process filter
                //filter vcid sub component.processID to process.name  
                processIDs.add(v.processID__c);
                
                //for process technology filter
                //filter vcid sub component.technology to process technology.technology geometry
                if(UtilsString.isNotblank(v.technology__c)){
                    technologies.add(Decimal.valueOf(v.technology__c).stripTrailingZeros());                        
                }
                
                //for ip oic mapping filter
                //filter vcid sub component.library to ip oic mapping.vcid sub component
                libraries.add(v.library__c);
                
                //filter vcid sub component.vendor to ip oic mapping.vcid vendor                                
                if(UtilsString.isNotBlank(v.vendor__c)){
                    String regex = '\\,|\\.|\\;|\\s';                                        
                    vendors.add(v.vendor__c.replaceAll(regex,'').toUpperCase()); 
                }
            }
            
            //filter the process
            Map<String,Process__c> filteredProcess = filterByProcess(processIDs);
            System.debug('Filtered by IP Process: '+filteredProcess);
            
            //get the process.process technology to match it against process technology.PT number
            Set<String> PTNumbers = new Set<String>();
            for(Process__c p: filteredProcess.values()){
                PTNumbers.add(p.process_technology__c);
            }                      
     
            //filter the Process Tech
            Map<String,Process_Technology__c> filteredProcessTechnology = filterByProcessTech(technologies,PTNumbers);
            System.debug('Filtered by IP Process Tech: '+filteredProcessTechnology);
            
            //get the process technology.ip geometry technology to match it against ip oic mapping.program
            Set<String> programs = new Set<String>();
            for(Process_Technology__c p : filteredProcessTechnology.values()){
                if(UtilsString.isNotBlank(p.ip_geometry_technology__c)){
                    if(p.ip_geometry_technology__c.contains(';')){
                        for(String i :p.ip_geometry_technology__c.split('\\;')){
                            programs.add(i);
                        }   
                    } else {
                        programs.add(p.ip_geometry_technology__c);
                    }
                }
            }
            
            //filter the IP OIC Mapping
            Map<String,IP_OIC_Mapping__c> filteredIPOICMapping = filterByIPOIC(programs,libraries,vendors);
            System.debug('Filtered by IP OIC Mapping: '+filteredIPOICMapping);                                                             
                    
            generateVCIDComponents(this.CRMDIDFilteredSubComps,filteredProcess,filteredProcessTechnology,filteredIPOICMapping);                        
        }
        
        //Method will create VCID components if the VCID sub components have related records to 
        //Device, Process, Process Technology and OIC IP Mapping
        private void generateVCIDComponents(Set<IP_VCID_Sub_Component__c> subComps,
                                            Map<String,Process__c> filteredProcess,
                                            Map<String,Process_Technology__c> filteredProcessTech,
                                            Map<String,IP_OIC_Mapping__c> filteredIPOICMapping){
                                                
            List<IP_VCID_Component__c> newRec = new List<IP_VCID_Component__c>();
            List<VCIDPair> pairs = new List<VCIDPair>();  
                                                                                            
            for(IP_VCID_Sub_Component__c s: subComps){ 
                if(filteredProcess.containsKey(s.processID__c)){
                    System.debug('Matched Process');
                    Process__c proc = filteredProcess.get(s.processID__c);
                    
                    if(filteredProcessTech.containsKey(proc.process_technology__c)){
                        Process_Technology__c procTech = filteredProcessTech.get(proc.process_technology__c);
                        
                        if(UtilsString.isNotBlank(procTech.tech_geometry__c) && UtilsString.isNotBlank(s.technology__c)){
                            String res = procTech.tech_geometry__c.replace('UM','');   
                            Decimal convertedRes = Decimal.valueOf(res).stripTrailingZeros();
                            Decimal convertedResSubComp = Decimal.valueOf(s.technology__c).stripTrailingZeros();
                            
                            if(convertedRes == convertedResSubComp){
                                System.debug('Matched Process Technology');
                                
                                String regex = '\\,|\\.|\\;|\\s';                                        
                                String vendor = UtilsString.isNotBlank(s.vendor__c) ? 
                                                s.vendor__c.replaceAll(regex,'').toUpperCase() : 
                                                ''; 

                                //handle process technology with multiple ip geometry technology
                                List<String> programs = new List<String>();
                                if(UtilsString.isNotBlank(procTech.ip_geometry_technology__c)){                                                                                 
                                    if(procTech.ip_geometry_technology__c.contains(';')){
                                        for(String i :procTech.ip_geometry_technology__c.split('\\;')){
                                            programs.add(i);
                                        }   
                                    } else {
                                        programs.add(procTech.ip_geometry_technology__c);
                                    }
                                }                                                         
                                
                                for(String p :programs){
                                    //create the IP OIC Mapping filter key
                                    String key = p+s.library__c+vendor;
                                    
                                    if(filteredIPOICMapping.containsKey(key)){
                                        System.debug('Matched IP OIC Mapping');                                 
                                        IP_OIC_Mapping__c o = filteredIPOICMapping.get(key); 
                                        
                                        IP_VCID_Component__c temp = new IP_VCID_Component__c();                                     
                                        temp.process_ID__c = s.processID__c;
                                        temp.CRM_DID__c = s.CRM_DID__c;
                                        temp.vendor__c = s.vendor__c;
                                        temp.library__c = s.library__c;
                                        temp.customer__c = s.customer__c;
                                        temp.technology_geometry__c = s.technology__c;
                                        temp.deviceId__c = s.deviceId__c;
                                        temp.program__c = o.program__c;                                    
                                        temp.oic_ip_component__c = o.oic_ip_component__c;
                                        temp.lookup_code__c = o.lookup_code__c;
                                        temp.description__c = o.description__c;                                                                             
                                        newRec.add(temp);                                       
                                                    
                                        //store in sub class for creating VCID component in the sub component lookup after insert
                                        pairs.add( new VCIDPair(s,temp));   
                                        
                                    }
                                }                               
                            }
                        }                                       
                    }                   
                }
            }
            
            try {
                insert newRec;
                
                //update the converted VCID component lookup
                Map<String,IP_VCID_Sub_Component__c> updateMap = new Map<String,IP_VCID_Sub_Component__c>();
                for(VCIDPair p: pairs){
                    IP_VCID_Sub_Component__c temp = p.updateSubCompLookup();
                    
                    //ASOLITO 11112013 - Task 436, added remarks status for converted/unconverted VCIDs
                    temp.remarks__c = 'Converted';
                    
                    updateMap.put(temp.id,temp);
                }
                
                //flag the unconverted VCID sub components to Unmap
                for(IP_VCID_Sub_Component__c u :updateMap.values()){
                    this.initialVCIDSubComps.remove(u.id);
                }
                
                for(IP_VCID_Sub_Component__c u: this.initialVCIDSubComps.values()){                 
                    //ASOLITO 11112013 - Task 436, added remarks status for converted/unconverted VCIDs
                    u.remarks__c = 'Unmap';
                }
                
                List<IP_VCID_Sub_Component__c> updateRec = new List<IP_VCID_Sub_Component__c>();
                
                //add the converted and unconverted VCID sub components for update                
                updateRec.addAll(updateMap.values());
                updateRec.addAll(this.initialVCIDSubComps.values());
                update updateRec;
                                                
            } catch(Exception e){
                System.debug(e);
            }      
                                                    
        }            
         
        //Method will filter VCID Sub component records against IP OIC Mapping records
        //result will generate a Map<String,IP_OIC_Mapping__c> with the key being 
        //concatenated ip oic mapping.program,ip oic mapping.vcid sub component and ip oic mapping.vendor(transformed) 
        private Map<String,IP_OIC_Mapping__c> filterByIPOIC(Set<String> programs,Set<String> libraries,Set<String> vendors){
            Map<String,IP_OIC_Mapping__c> result = new Map<String,IP_OIC_Mapping__c>();
            
            for(IP_OIC_Mapping__c i: [SELECT oic_ip_component__c,lookup_code__c,program__c,vcid_vendor__c,vcid_sub_component__c,
                                             description__c
                                        FROM IP_OIC_Mapping__c                                                             
                                        WHERE vcid_sub_component__c IN :libraries
                                        AND program__c  IN :programs]){ 
                if(UtilsString.isNotBlank(i.vcid_vendor__c) && UtilsString.isNotBlank(i.program__c) && 
                   UtilsString.isNotBlank(i.vcid_sub_component__c)){                                                                                                                                      
                
                    //make the vendor upper case
                    String regex = '\\,|\\.|\\;|\\s';                                        
                    String IOCVendor = UtilsString.isNotBlank(i.vcid_vendor__c) ? 
                                       i.vcid_vendor__c.replaceAll(regex,'').toUpperCase() : 
                                       '';                                              
                    if(vendors.contains(IOCVendor)){ 
                        //create concatenated program,vcid sub component and parsed Vendor to create key
                        result.put((i.program__c+i.vcid_sub_component__c+IOCVendor),i);                                                                   
                    }
                }                           
            }
            return result;
        }     
        
        //Method will filter VCID Sub component records against Process Technology
        //result will generate a Map<String,Process_Technology__c> with the key being the process technology.pt number
        private Map<String,Process_Technology__c> filterByProcessTech(Set<Decimal> technologies,Set<String> processTechs){
            Map<String,Process_Technology__c> result = new Map<String,Process_Technology__c>();
            
            for(Process_Technology__c p: [SELECT tech_geometry__c,ip_geometry_technology__c,PT_number__c 
                                            FROM Process_Technology__c 
                                            WHERE PT_number__c IN :processTechs]){
                System.debug('Process Tech Test '+p.tech_geometry__c);
                if(UtilsString.isNotBlank(p.tech_geometry__c)){
                    String res = p.tech_geometry__c.replace('UM','');   
                    Decimal convertedRes = Decimal.valueOf(res).stripTrailingZeros();  
                                       
                    if(technologies.contains(convertedRes)){
                        result.put(p.PT_number__c,p); 
                    }        
                }                                               
            } 
            
            return result;
        }       
        
        //Method will filter VCID Sub component records against Process
        //result will generate a Map<String,Process__c> with the key being the process.name
        private Map<String,Process__c> filterByProcess(Set<String> processIDs){
            Map<String,Process__c> result = new Map<String,Process__c>();
            
            for(Process__c p: [SELECT name,process_technology__c 
                                 FROM Process__c 
                                 WHERE name IN :processIDs]){
                result.put(p.name,p);                                       
            }                                                           
            return result;           
        }              
        
        //Method will filter VCID Sub component records against Device
        private Set<String> filterByCRMDID(Set<String> CRMDIDs){
            Set<String> result = new Set<String>();
            
            for(Device__c d: [SELECT CRMDID__c 
                                FROM Device__c 
                                WHERE CRMDID__c IN :CRMDIDs]){
                result.add(d.CRMDID__c);                                                              
            }
            return result;
        }      
    }
    
    //Sub class for VCID sub component and VCID component
    public class VCIDPair {
        private IP_VCID_Sub_Component__c subComp;
        private IP_VCID_Component__c comp;
        
        public VCIDPair(IP_VCID_Sub_Component__c subComp, IP_VCID_Component__c comp){
            this.comp = comp;
            this.subComp = subComp;
        }
        
        public IP_VCID_Sub_Component__c updateSubCompLookup(){
            this.subComp.converted_IP_VCID_Component__c = this.comp.id;                        
            return this.subComp;
        }
    }       
}