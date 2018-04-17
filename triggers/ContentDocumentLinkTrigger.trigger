/*
Type Name: ContentDocumentLinkTrigger 
Author: Dinesh Suggala(Global Foundries)
Created Date: 23-Feb-2018
Reason: This trigger calls the class ContentDocumentLinkHelper Class

……..
*/
trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
  
  new ContentDocumentLinkHandler().run();
  
}