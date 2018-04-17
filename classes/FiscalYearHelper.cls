/*
    Author: Nino Bustillos
    Description: This helper class generates the fiscal quarter based on date.
                 Moving forward this class should read directly from the standard
                 FiscalYear object.
    History: 
        Nbustillos  03072013    - code creation.
        ARoy        09112013    - code modified to support the fiscal year conversion to follow Gregorian calendar.
*/
public class FiscalYearHelper {
    public static string getFiscalQuarter(date d1stProdProductionDate){
        string retVal = null;
        
        if(d1stProdProductionDate>=Date.newInstance(2014,1,1)){
            retVal = getYearAndQuarter(d1stProdProductionDate);
        }else if(d1stProdProductionDate>=Date.newInstance(2013,9,29)){
            retVal = '2013-Q4';     
        }else if(d1stProdProductionDate>=Date.newInstance(2013,6,30)){
            retVal = '2013-Q3';
        }else if(d1stProdProductionDate>=Date.newInstance(2013,3,31)){
            retVal = '2013-Q2';
        }else if(d1stProdProductionDate>=Date.newInstance(2012,12,30)){
            retVal = '2013-Q1';
        }else if(d1stProdProductionDate>=Date.newInstance(2012,9,30)){
            retVal = '2012-Q4';
        }else if(d1stProdProductionDate>=Date.newInstance(2012,7,1)){
            retVal = '2012-Q3';
        }else if(d1stProdProductionDate>=Date.newInstance(2012,4,1)){
            retVal = '2012-Q2';
        }else if(d1stProdProductionDate>=Date.newInstance(2012,1,1)){
            retVal = '2012-Q1';
        }else if(d1stProdProductionDate>=Date.newInstance(2011,10,2)){
            retVal = '2011-Q4';
        }else if(d1stProdProductionDate>=Date.newInstance(2011,7,3)){
            retVal = '2011-Q3';
        }else if(d1stProdProductionDate>=Date.newInstance(2011,4,3)){
            retVal = '2011-Q2';
        }else if(d1stProdProductionDate>=Date.newInstance(2010,12,26)){
            retVal = '2011-Q1';
        }else if(d1stProdProductionDate>=Date.newInstance(2010,9,26)){
            retVal = '2010-Q4';
        }else if(d1stProdProductionDate>=Date.newInstance(2010,6,27)){
            retVal = '2010-Q3';
        }else if(d1stProdProductionDate>=Date.newInstance(2010,3,28)){
            retVal = '2010-Q2';
        }else if(d1stProdProductionDate>=Date.newInstance(2009,12,27)){
            retVal = '2010-Q1';
        }
        return retVal;
    }
    
    public static String getYearAndQuarter(Date d1stProdProductionDate){
        String value = null;
        if(d1stProdProductionDate != null){
            Integer yr = d1stProdProductionDate.year();
            Integer month = d1stProdProductionDate.month();         
            String qtr='';
            if(month<=3){
                qtr = 'Q1';
            }else if(month>3 && month<=6){
                qtr = 'Q2';
            }else if(month>6 && month<=9){
                qtr = 'Q3';
            }else if(month>9 && month<=12){
                qtr = 'Q4';
            }
            value = yr + '-'+ qtr;
        }
        return value;
    } 
}