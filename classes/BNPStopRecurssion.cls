public class BNPStopRecurssion{
//public static Boolean isNotRecursive = true;
private static boolean run = true;
    public static boolean runOnce(){
    if(run){
        run=false;
        if (Test.isRunningTest()){run=true;}
        return true;
    }else{
        return run;
    }
    }
}