public class FeePaymentController{
    public String attr{get;set;}
    public Id studId{get;set;}
    public String Amount{get;set;}
    public PayPalTestClass p{get;set;}
    public String txnId{get;set;}
    public Student__c stud{get;set;}
    public FeePaymentController(){
       
        txnId = null;
         attr = apexpages.currentpage().getparameters().get('att');
         list<String> tempList = new List<String>();
         tempList = attr.split(',');
        studId = tempList[0];
        Amount =tempList[1];
         stud = [SELECT ID, First_Name__c,Last_Name__c from Student__c where id=:studId];
        p = new PayPalTestClass();
    }
    public PageReference MakePayment()
    {
        PageReference pf = null;
        System.debug('firstName..'+p.FirstName);
        p.amount = amount;
        p.FirstName = stud.first_name__c;
        p.LastName = stud.last_name__c;
        string message = p.pay();
       txnId = p.transid;
        system.debug('#### Message::' + message);
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,message));

        system.debug('#### Transaction Id::' + txnId);
        if(txnId != NULL) {
            Invoice__c inv = new Invoice__c();
            inv.Student__c = studId;
            inv.amount__c = Decimal.valueOf(amount);
            inv.Transaction_ID__c = txnId;
            insert inv;
            pf = new PageReference('/'+inv.Id);
        }
        return pf;
    }
}