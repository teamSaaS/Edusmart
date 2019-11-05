public class CourseDetailsController {
    public Id courseId{get;set;}
    public Course__c course{get;set;}
    public list<Assignment__c>asnList {get;set;}
    
       public Id asnId{get;set;}

    
    public CourseDetailsController(){
        courseId = apexpages.currentpage().getparameters().get('att');
        //query the selected course details
        course = [SELECT ID,Name,Course_Name__c,Teacher__c,Teacher__r.Name,Teacher__r.Phone__c,Teacher__r.Email__c,Venue__c,
                Days_of_the_week__c,Timings__c from Course__c where id=:courseId];
           
        asnList =[SELECT ID,Name,Course__c,Due_Date__c,Questions__c,Total_Points__c FROM Assignment__c where Course__c=:courseId];
        
    }
    public pageReference viewAssignmentDetails(){
         PageReference pf = new PageReference('/apex/StudentAssignmentView?att='+asnId);
        return pf;
    }
}