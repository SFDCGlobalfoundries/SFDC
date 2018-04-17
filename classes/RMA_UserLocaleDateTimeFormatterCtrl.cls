/**
 * Author: Surendranadh Nune
 * Company: GlobalFoundries,India
 * Project: Return Material Authorization
 * Description: This class is used to convert the Date time fields
 * 				displayed in visualforce page in logged in user time zone.
 * History:
 *    SurendranadhNune 10122015  -   Created.
 *                           
 **/
public with sharing class RMA_UserLocaleDateTimeFormatterCtrl {
    public DateTime dateTimeValue { get; set; }
    /**
     * Author: Surendranadh Nune
     * Description: Method used to format timezone.
     */
    public String getTimeZoneValue() {
        if( dateTimeValue != null ) {
            String localeFormatDT = dateTimeValue.format('MM/dd/Y hh:mm a');
            return localeFormatDT;
        }
        return null;
    }
}