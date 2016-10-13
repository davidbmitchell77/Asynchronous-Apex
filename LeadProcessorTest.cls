@isTest
private class LeadProcessorTest {

    @testSetup
    static void createLeads() {
        List<Lead> leads = new List<Lead>();
        for (Integer i=0; i<200; i++) {
            Lead l = new Lead();
            l.FirstName = 'Test';
            l.LastName = 'Lead';
            l.Company = 'Test Lead ' + i;
            leads.add(l);
        }
        insert leads;
    }

    static TestMethod void myTest() {
        Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Id batchId = Database.executeBatch(lp);
        Test.stopTest();

        System.assertEquals(200, [SELECT Count()
                                    FROM Lead
                                   WHERE Name = 'Test Lead'
                                     AND LeadSource = 'Dreamforce']);
    }
}