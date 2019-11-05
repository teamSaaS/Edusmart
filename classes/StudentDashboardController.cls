public class StudentDashboardController{
    public String accountId {get;set;}
    public String type {get;set;}
    public Student__c stud{get;set;}
    public list <Course_Assignment__c> course_assignment{get;set;}
    public boolean showpopup {get;set;}
    public list <CourseWrapper>courseList{get;set;}
    public boolean showCourses {get;set;}
    public String UserId {get;set;}
    public Id crsId{get;set;}
    public list<Appointment__c> appList{get;set;}
    public Id appId{get;set;}
    public Decimal dueAmount{get;set;}
    public list<Invoice__c> invoiceList{get;set;}
    public Id invId{get;set;}
    public StudentDashboardController() {   
    showCourses=true;
        
      accountId = Apexpages.currentpage().getparameters().get('id'); 
      type = Apexpages.currentpage().getparameters().get('Type'); 
     
    
         UserId = UserInfo.getUserId();
        stud = [SELECT ID,First_Name__c,Last_Name__c,Address__c,Email__c,Date_Of_Birth__c,GRE_Score__c,Major__c,Phone__c,User__c,Semester__c FROM Student__c where User__c=:userId];
          course_assignment = [SELECT ID,Student__c,Course__c from Course_Assignment__c where Student__c =:stud.Id];
        Date tdy = Date.Today();
     appList = [SELECT ID,Name,Date__c,End_Time__c,Start_Time__c,Student__c,Teacher__c,Teacher__r.name from Appointment__c where Student__c=:stud.id and Date__c >:tdy];
    invoiceList = [SELECT ID,Name,Amount__c,Student__c,Transaction_Id__c from Invoice__c where Student__c =:stud.id];
  }
  
   public PageReference viewCourseDetails() {
       PageReference pf = new PageReference('/apex/CourseDetails?att='+crsId);
        return pf;
    }
  public PageReference viewInvoice(){
      PageReference pf = new PageReference('/'+invId);
      return pf;
  }
  public List<courseWrapper> getCourses() {
      set<Id>courseIdSet=new set<Id>();
      if(course_assignment.size() > 0) {
          for(Course_assignment__c ca : course_assignment){
              courseIdSet.add(ca.course__c);
          }
      }
    if(courseList == null) {
        courseList = new List<CourseWrapper>();
        for(Course__c c: [select Id, Name,Course_Name__c, Major__c,Semester__c from Course__c where Major__c=:stud.Major__c and Semester__c=:stud.semester__c and id not in:courseIdset]) {
            // As each contact is processed we create a new cContact object and add it to the contactList
            courseList.add(new courseWrapper(c));
        }
    }
    return courseList;
}
public pageReference removeCourse(){
Course_assignment__c CrsToBeDeleted;
list<Course_assignment__c> newList = new list<Course_assignment__c>();
    for(Course_assignment__c ca:course_assignment){
        if(ca.course__c == crsId) {
            CrsToBeDeleted = ca;
        }
        else{
            newList.add(ca);
        }
    }
    delete CrsToBeDeleted;
    course_assignment = newList;
    return null;
    
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
public list<Course__c> getEnrolledCourses(){
set<Id>courseIdSet=new set<Id>();
    for(course_assignment__c ca: course_assignment){
        courseIdSet.add(ca.course__c);
    }
    list<Course__c> cr = [SELECT ID,Name,Course_Name__c from Course__c where Id in:courseIdSet ];
    dueAmount = cr.size() *2000 ;
    return cr;
   
    
}
  public pageReference edit(){
      return new PageReference ('/'+stud.Id+'/e');
  }
  public pageReference payFees(){
      PageReference pf = new PageReference('/apex/FeePayment?att='+stud.Id+','+dueAmount);
      return pf;
  }
  public void enroll(){
      showpopup=true;
  }
  public void closePopup(){
      showpopup=false;
  }
  public pageReference saveCourses(){
      List<Course_Assignment__c> caList = new list<Course_Assignment__c>();
       List<Course__c> selectedCourses = new List<Course__c>();

    //We will cycle through our list of cContacts and will check to see if the selected property is set to true, if it is we add the Contact to the selectedContacts list
    for(CourseWrapper cCon: getCourses()) {
        if(cCon.selected == true) {
            selectedCourses.add(cCon.crs);
        }
    }
    for(Course__c c: selectedCourses){
        Course_Assignment__c ca = new Course_Assignment__c(Student__c = stud.Id, Course__c = c.id);
        caList.add(ca);
    }
    insert caList;
    //course_assignment.clear();
    if(course_assignment.size() == 0){
        course_assignment = caList;
    }
    else{
        course_assignment.addAll(caList);
    }
    showpopup = false;
    courseList=null; // we need this line if we performed a write operation  because getContacts gets a fresh list now
    return null;
  }
  public class courseWrapper {
    public Course__c crs {get; set;}
    public Boolean selected {get; set;}

    //This is the contructor method. When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false
    public courseWrapper(Course__c c) {
        crs = c;
        selected = false;
    }
}

}