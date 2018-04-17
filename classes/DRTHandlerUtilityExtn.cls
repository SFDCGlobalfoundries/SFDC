public without sharing class DRTHandlerUtilityExtn {
    
    public static string getLayerUniqueIdentifier(DRT__c objDRTDetail, String layerNo, String retroMaskRev, String retroROMCode) {
            
        Pattern techGeoPattern = Pattern.compile('(\\d*\\.\\d+)(.*)');
        String rCode = retroROMCode == '---' ? '' : retroROMCode;
        String indentifier = objDRTDetail.Mask_Set_Title__c + layerNo + retroMaskRev + rCode;

        if(!string.isBlank(objDRTDetail.Tech_Geo__c)) {
            decimal dcmtechgeo;
            
            if(!string.isBlank(objDRTDetail.Tech_Geo__c)) {
                Matcher pm = techGeoPattern.matcher(objDRTDetail.Tech_Geo__c);
                if(pm.matches() && !string.isBlank(pm.group(1))) dcmtechgeo = Decimal.valueOf(pm.group(1));
            }

            indentifier += (dcmtechgeo!=null) ? string.valueOf(dcmtechgeo) : '';
        }
            
        return indentifier;
    }
}