public class RecursionPrevent {
	// initialize a variable to hold state
	public static boolean alreadyModified = false;
	public static Boolean run = true;
	// get the state
	public static boolean isAlreadyModified(){ 
		return alreadyModified;
	}

	// set this to true to keep track of and avoid recursive updates. Generally set after first time through
	// a trigger. We can access this in the trigger and avoid recursive updates...
	// This class is used for Deal Grading also.
	public static void setAlreadyModified(){
		alreadyModified = true;
	}
	public static void resetAlreadyModified() {
		alreadyModified = false;
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
}