@isTest
private class DailyLeadProcessorTest {

    @testSetup
    static void setup() {
        List<Lead> leads = new List<Lead>();
        for (Integer i=0; i<200; i++) {
            Lead l = new Lead();
            l.FirstName = 'Test';
            l.LastName = 'Lead ' + i;
            l.Company = 'Test Company ' + i;
            leads.add(l);
        }
        insert leads;
    }

    static TestMethod void myTest() {
        String jobName = 'Daily Lead Processor - Test';
        String CRON_EXP = '0 0 0 15 3 ? 2017'; // dummy cron entry

        test.startTest();
        DailyLeadProcessor dp = new DailyLeadProcessor();
        String JobId = System.schedule(jobName, CRON_EXP, dp);
        test.stopTest();

        List<Lead> results = [SELECT Id FROM Lead WHERE LeadSource = 'Dreamforce'];
        System.assertEquals(200, results.size());
    }
}