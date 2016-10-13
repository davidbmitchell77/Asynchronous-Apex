global class DailyLeadProcessor implements Schedulable {

    global void execute(SchedulableContext ctx) {
        List<Lead> leads = [SELECT Id,
                             LeadSource
                        FROM Lead
                       WHERE LeadSource = '' OR LeadSource = null
                       LIMIT 200];
        for (Lead l : leads) {
            l.LeadSource = 'Dreamforce';
        }

        if (leads.size() > 0) {
            update leads;
        }
    }
}