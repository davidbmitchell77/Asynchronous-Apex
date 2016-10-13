global class LeadProcessor implements Database.Batchable<sObject>, Database.Stateful {

    global Integer recs_processed = 0;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String sQuery = '';
        sQuery += 'SELECT Id, Name, Status,';
        sQuery += 'LeadSource ';
        sQuery += 'FROM Lead ';
        sQuery += 'LIMIT 100000';
        return Database.getQueryLocator(sQuery);
    }

    global void execute(Database.BatchableContext bc, List<Lead> scope) {
        for (Lead l : scope) {
            l.LeadSource = 'Dreamforce';
            recs_processed += 1;
        }
        update scope;
    }

    global void finish(Database.BatchableContext bc) {
        AsyncApexJob job = [SELECT Id,
                                   Status,
                                   NumberOfErrors,
                                   TotalJobItems,
                                   JobItemsProcessed,
                                   CreatedBy.Email
                              FROM AsyncApexJob
                             WHERE Id = :bc.getJobId()];
        String s = '';
        s += job.JobItemsProcessed + ' job items processed ';
        s += 'out of ' + job.TotalJobItems + ' total job items.  ';
        s += job.NumberOfErrors + ' error(s) encountered. ';
        System.debug(s);
        s = recs_processed + ' record(s) processed.';
        System.debug(s);
    }
}