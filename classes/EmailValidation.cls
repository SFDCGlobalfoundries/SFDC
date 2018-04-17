/**
* This class is intended for validating a set of emails
**/
public class EmailValidation {
    // email regex
    private static string emailRegex;
    // email pattern
    private static Pattern emailPattern;
    static {        
        emailRegex  = '[A-Za-z0-9._%+-/!#$%&\'*=?^_`{|}~]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,4}$';
        emailPattern = Pattern.compile(emailRegex);
    }
    /**
    * This method validates emails
    * @param: set<string> {set of emails to validate}
    * @return: set<string> {valid set of emails}
    **/
    public static set<string> parseValidEmails(set<string> setEmail) {         
        Matcher emailMatcher;
        Boolean isValid;
        set<string> setValidEmail = new set<string>();
        if(setEmail!=null) {
            for(string email : setEmail) {
                emailMatcher = emailPattern.matcher(email);
                if(emailMatcher.matches()) {
                   isValid = true;
                   string beforeDomainPart = email.substringBefore('@');
                   if(email.startsWith('.'))  {
                        isValid=false;
                    }else if(beforeDomainPart.endsWith('.')){
                        isValid=false;
                    }
                    if(isValid){
                       setValidEmail.add(email);
                    }
                }
            }
        }
        return setValidEmail;
    }
}