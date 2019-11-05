public class CourseDetailsTeacherViewController {
    public Id crsId{get;set;}
    public Date dat{get;set;}
    public Course__c crs{get;set;}
    public Boolean showPopup{get;set;}
    public String assmntId{get;set;}
    public list<Assignment__c> assgnmtList{get;set;}
    public Assignment__c newAssignment {get;set;}
    public CourseDetailsTeacherViewController(){
        crsId=apexpages.currentpage().getparameters().get('att');
        crs=[SELECT ID,Name,Course_Name__c from Course__c where id=:crsId];
        assgnmtList=[SELECT ID,Name,Course__c,Due_Date__c,Total_Points__c,Questions__c from Assignment__c where Course__c =:crsId];
    }
    public void createAssignment(){
         showPopup=true;
         System.debug('assmntId...'+assmntId);
         if(assmntId == NULL || assmntId=='') {
              newAssignment = new Assignment__c();
         }
         else{
             newAssignment = [SELECT ID,Name,Questions__c,Due_Date__c,Total_Points__c from Assignment__c where ID=:assmntId];
             dat = newAssignment.due_date__c;
         }
       
       
    }
    public pageReference viewSubmissions(){
         PageReference pf = new PageReference('/apex/AssignmentSubmission?att='+assmntId);
         return pf;
    }
    public void closePopup(){
        showpopup=false;
    }
    public void saveAssignment(){
        System.debug('newAssignment...'+newAssignment);
        if(newAssignment.Id == NULL) {
            if(newAssignment.Name != '' && newAssignment.Questions__c != '' && dat!=NULL && newAssignment.Total_Points__c != NULL) {
                System.debug('Create new assignment');
                newAssignment.course__c = crsId;
                newAssignment.Due_Date__c = dat;
                insert newAssignment;
                assgnmtList.add(newAssignment);
                showPopup = false;
            }
            else{
                System.debug('Entered else...');
            }
        }
        else{
            newAssignment.due_date__c = dat;
            update newAssignment;
            for(Assignment__c assn : assgnmtList){
                if(assn.Id == newAssignment.Id) {
                    assn.Name = newAssignment.name;
                    assn.Questions__c = newAssignment.Questions__c;
                    assn.due_date__c = newAssignment.due_date__c;
                    assn.Total_Points__c = newAssignment.Total_Points__c;
                    System.debug('assn...'+assn);
                    System.debug('NewAssignment....'+newAssignment);
                  
                }
            }
            System.debug('assgnmtList...'+assgnmtList);
            showPopup = false;
            assmntId = NULL;
            dat = NULL;
        }
    }
}