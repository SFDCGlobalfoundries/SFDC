/*
 @class: EmailTemplateGeneral
 @CreatedBy: Inshu Misra
 @CreatedDate: 24 Aug, 2016
 @Description: Class created to have general type for Email Template generation...#IM
 @Modifications-
 *
 */
public class EmailTemplateGeneral {
	private String subject;
    private String body;
    
    public String getSubject(){
        return subject;
    }
    public void setSubject(String subject){
        this.subject = subject;
    }
    public String getBody(){
        return body;
    }
    public void setBody(String body){
        this.body = body;
    }
}