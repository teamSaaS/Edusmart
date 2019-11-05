public class AssignmentSubmissionController{
    public Id assnId{get;set;}
    public list<Submission__c> submissionList {get;set;}
    public set<Id> subIdSet{get;set;}
    public list<Attachment> docsList{get;set;}
    public Assignment__c assn{get;set;}
    public Id docId{get;set;}
    public AssignmentSubmissionController(){
        subIdSet = new set<Id>();
        assnId=apexpages.currentpage().getparameters().get('att');
        assn = [SELECT ID,Name from Assignment__c where ID=:assnId];
        submissionList = [SELECT ID,Name,Assignment__c,Grade__c,Student__c from Submission__c where Assignment__c =:assnId];
        if(!submissionList.isEmpty()){
            for(Submission__c sub: submissionList) {
                subIdSet.add(sub.Id);
            }
            docsList = [SELECT ID,Name,ParentId from Attachment where ParentID IN:subIdSet];
            System.System.debug('docsList...'+docsList);
        }
    }
    public pageReference viewSubmission(){
        PageReference pf = new PageReference('/'+docId);
        
        return pf;
    }
}