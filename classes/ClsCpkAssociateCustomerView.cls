/*------------------------------------------------------------  
Author:        Amar Smruti Pattanaik
Company:       CTS
Description:   This class is to show Report type value in inline vf page.
  History:
  ASPattanaik 24102016 - Class Creation.
--------------------------------------------------------------*/

public without sharing class ClsCpkAssociateCustomerView {

    public CPK_Report__c cpkReport{get; set;}
    public ClsCpkAssociateCustomerView(Apexpages.StandardController stdController){
        cpkReport = new CPK_Report__c();
        if(ApexPages.currentPage().getParameters().get('Id') != null){
            cpkReport = [select Id,Name ,ASIC_Report__c,Geometry__c from CPK_Report__c where Id = :ApexPages.currentPage().getParameters().get('Id')];
        }
    }
    
}