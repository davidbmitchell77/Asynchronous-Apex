@isTest
private class AddPrimaryContactTest {
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        for (Integer i=0; i<50; i++) {
            Account ny = new Account();
            ny.Name = 'Test Account (NY)';
            ny.BillingState = 'NY';
            accounts.add(ny);
            Account ca = new Account();
            ca.Name = 'Test Account (CA)';
            ca.BillingState = 'CA';
            accounts.add(ca);
        }
        insert accounts;
    }

    static void myTest() {
        Contact contactObj = new Contact(
            FirstName = 'California',
            LastName = 'Bob'
        );
        String state_abbrev = 'CA';

        Test.startTest();
        AddPrimaryContact apc = new AddPrimaryContact(contactObj, state_abbrev);
        Id jobId = System.enqueueJob(apc);
        Test.stopTest();

        List<Account> accounts = [SELECT Id, (SELECT Contact.Name FROM Account.Contacts) FROM Account WHERE BillingState = 'CA'];
        System.assertEquals(50, accounts.size());
        for (Account a : accounts) {
            System.assertEquals(a.Contacts.size(), 1);
        }
    }
}