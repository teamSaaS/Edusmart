public class TeacherDashboardController {    
    public Teacher__c tchr {get;set;}
    public Id userId{get;set;}
    public list<Course__c> courseList{get;set;}
    public Id crsId{get;set;}
    public List<Appointment__c>appList{get;set;}
    public Id appId{get;set;}
    public TeacherDashboardController(){
          UserId = UserInfo.getUserId();
          tchr = [SELECT ID,Name,Phone__c,Email__c,User__c from Teacher__c where User__c=:UserId];
          courseList = [SELECT ID,Name,Major__c,Course_Name__c,Days_of_the_week__c,Semester__c,Teacher__c,Timings__c,Venue__c FROM Course__c where Teacher__c=:tchr.id];
         Date tdy = Date.Today();
         appList = [SELECT ID,Name,Date__c,End_Time__c,Start_Time__c,Student__c,Teacher__c,Student__r.first_name__c,student__r.last_name__c from Appointment__c where Teacher__c=:tchr.id and Date__c >:tdy];
    }
    public pageReference viewCourseDetails(){
         PageReference pf = new PageReference('/apex/CourseDetailsTeacherView?att='+crsId);
        return pf;
    }
    public void cancelAppointment(){
        list<Appointment__c> newAppList = new list<Appointment__c>();
    Appointment__c appToBeDeleted;
    for(Appointment__c app: appList){
        if(app.Id == appId) {
            appToBeDeleted = app;
            
        }
        else{
            newAppList.add(app);
        }
    }
    
    database.delete(appToBeDeleted);
    appList = newAppList;
    }
}