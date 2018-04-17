public class UCMZipUtil {

    //Normal Status Code
    private static String API_STATUS_NORMAL = '200';
    //Error Status Code
    private static String API_STATUS_ERROR  = '400';

    /**
     * Normal JSON Response
     */
    public static String normalJson( Object respData ) {
        Map<String, Object> response = new Map<String, Object>();
        response.put('status', API_STATUS_NORMAL);
        if( respData != null ) response.put('data', respData);
        return JSON.serialize( response );
    }
    
    /**
     * Success JSON Response
     
    public static String successJson( String message ) {
        Map<String, Object> response = new Map<String, Object>();
        response.put('status', API_STATUS_ERROR);
        if( message != null ) response.put('success', message);
        return JSON.serialize( response );
    }
	*/
    /**
     * Error JSON Response
     */
    public static String errorJson( String message ) {
        Map<String, Object> response = new Map<String, Object>();
        response.put('status', API_STATUS_ERROR);
        if( message != null ) response.put('error', message);
        return JSON.serialize( response );
    }

}