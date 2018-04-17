public class checkRecursive{
    public static Boolean run = true;
    public static Boolean run1s = true;
    public static Boolean runOnceAgain = true;
    public static Boolean runOnceAgainForlookup = true;
    public static Boolean run1sMet(){
             
        if(run1s){
            run1s = false;
            return true;
        }
        else {
            return run1s;
        }
    }
    public static Boolean runOnce(){
           
        if(run){
            run = false;
            return true;
        }
        else {
            return run;
        }
    }
    public static Boolean runOnceAgain(){
        
        if(runOnceAgain){
            runOnceAgain = false;
            return true;
        }
        else {
            return runOnceAgain;
        }
    }
    
    public static Boolean runOnceAgainForlookup(){
        
        if(runOnceAgainForlookup){
            runOnceAgainForlookup = false;
            return true;
        }
        else {
            return runOnceAgainForlookup;
        }
    }    
}