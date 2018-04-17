/*
Test class:
- MRS_Layer_Association_SWIFT_AINS_Test
*/
public class MRSCheckRecursive { 
    
    private static boolean run = true;
    
    public static boolean isFirstRun(){
	    if(run){
	        run = false;
	        return true;
	    }else {
	        return run;
        }
    }
}