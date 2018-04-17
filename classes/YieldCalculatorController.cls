/*
    Author: Zymark Ambat
    Description: This Class serves as the controller for YieldCalculatorVF.
    History: 
        ZAmbat      11272014    - Code creation.
*/

public class YieldCalculatorController {
    public string waferSize {get;set;}
    public double nValue {get;set;}
    public double defectDensity {get;set;}
    public double dieSizeX {get;set;}
    public double dieSizeY {get;set;}
    public double dieSizeArea {get;set;}
    public string sramDensity {get;set;}
    public string processName {get;set;}
    public New_Part_Creation_Form__c npcForm {get;set;}
    
    public YieldCalculatorController() {
        this.npcForm = new New_Part_Creation_Form__c();
    }

    public List<SelectOption> getWaferSizeOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('200', '200'));
        options.add(new SelectOption('300', '300'));
        
        return options;
    }
    
    public List<SelectOption> getSramDensityOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('<15%', '<15%'));
        options.add(new SelectOption('15-<30%', '15-<30%'));
        options.add(new SelectOption('30-<50%', '30-<50%'));
        options.add(new SelectOption('>50%', '>50%'));
        
        return options;
    }
    
    public double getEstimatedYield() {
        double result;
        if (this.sramDensity != null && this.dieSizeArea != null && this.defectDensity != null && this.nValue != null) {
            double x = getXValue();
            double y = getYValue();
            
            result = (y / Math.pow(double.valueOf(1 + (this.defectDensity * this.dieSizeArea * 0.03937 * 0.03937 * x)), this.nValue)) * 100;
        }
         
        return result;
    }
    
    public integer getGrossDiesPerWafer() {
        double result;
        if (this.waferSize != null && this.dieSizeX != null && this.dieSizeY != null) {
            result = (3.14 * Math.pow((double.valueOf(this.waferSize) - 2 * 4) - Math.pow(double.valueOf(this.dieSizeX + (0.08 / 2) * (this.dieSizeY + (0.08/2))), -2), 2) / (4 * (this.dieSizeX + (0.08/2)) * (this.dieSizeY + (0.08/2))) * 0.99);
        }
            
        return (result != null ? integer.valueOf(result.round()) : null);
    }
    
    public integer getNetDiesPerWafer() {
        double result;
        if (this.waferSize != null && this.sramDensity != null && this.dieSizeArea != null && this.defectDensity != null && this.nValue != null && this.dieSizeX != null && this.dieSizeY != null) {
            double x = getXValue();
            double y = getYValue();
            
            result = (y / Math.pow(double.valueOf(1 + (this.defectDensity * this.dieSizeArea * 0.03937 * 0.03937 * x)), this.nValue)) * (3.14 * Math.pow((double.valueOf(this.waferSize) - 2 * (4)) - Math.pow(double.valueOf(this.dieSizeX + (0.08 / 2) * (this.dieSizeY + 0.08 / 2)), double.valueOf(0.5)), 2) / ((4 * (this.dieSizeX + 0.08 / 2) * (this.dieSizeY + (0.08 / 2))) * 0.99));
        }
        
        return (result != null ? integer.valueOf(result.round()) : null);
    }
    
    public double getXValue() {
        double x = 2;
        if (this.sramDensity == '<15%') {
            x = 1;
        } else if (this.sramDensity == '15-<30%') {
            x = 1.4;
        } else if (this.sramDensity == '30-<50%') {
            x = 1.7;
        } 
        
        return x;
    }
    
    public double getYValue() {
        double y = 1;
        if (this.dieSizeArea < 30) {
            y = 0.97;
        }
        
        return y;
    }
    
    public void retrieveProcessDetails() {
        if (this.npcForm.Process_ID__c != null) {
            Process__c p = [
                SELECT    Name
                          , NVALUE__c
                FROM      Process__c
                WHERE     Id = :this.npcForm.Process_ID__c
            ];
            
            this.processName = p.Name;
            this.nValue = p.NVALUE__c;
        }
    }
    
    public void clearProcessId() {
        this.npcForm = new New_Part_Creation_Form__c();
        this.processName = '';
        this.nValue = null;
    }
    
    public void clearAll() {
        this.defectDensity = null;
        this.dieSizeX = null;
        this.dieSizeY = null;
        this.dieSizeArea = null;
        clearProcessId();
    }
}