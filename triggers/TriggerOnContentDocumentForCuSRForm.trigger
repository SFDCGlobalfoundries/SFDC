/*
Author: Shyam Ravindra Nair
Description: Trigger on ContentDocument for CuSR Form.
History:
SNair     23042015     - code creation
Inshu Misra 19-07-2017	- Added CUSR check against FMS 2.0 defect fix
*/
trigger TriggerOnContentDocumentForCuSRForm on ContentDocument (before delete) {

    TriggerOnContentDoForCuSRFormHandler handler = new TriggerOnContentDoForCuSRFormHandler();
    
    
    if (!IntegrationUserUtil.isSkipTrigger()){
        if(trigger.isBefore && trigger.isDelete){
            for(ContentDocument oldContentDocument: trigger.old){
                //19-07-2017 Added CUSR check against FMS 2.0 defect fix...#IM
                if(oldContentDocument.Title != null && oldContentDocument.Title.startsWith('CUSR')){
                    handler.onBeforeDelete(oldContentDocument.Title, trigger.old);
                }
                handler.deleteRMAAttachments(trigger.oldMap.keySet());
            }   
        }
    }
}