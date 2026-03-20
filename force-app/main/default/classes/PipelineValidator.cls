public with sharing class PipelineValidator {

    /**
     * Validates and updates Opportunities
     * Example logic:
     * - If Amount > 100000 → mark as 'High Value'
     * - If CloseDate is past → mark stage as 'Closed Lost'
     */
    public static void validateAndUpdate(List<Opportunity> oppList) {
        
        List<Opportunity> oppToUpdate = new List<Opportunity>();

        for (Opportunity opp : oppList) {

            Boolean isModified = false;

            // Example 1: High value deal tagging
            if (opp.Amount != null && opp.Amount > 100000) {
                opp.Description = 'High Value Opportunity';
                isModified = true;
            }

            // Example 2: Past close date handling
            if (opp.CloseDate != null && opp.CloseDate < Date.today()) {
                opp.StageName = 'Closed Lost';
                isModified = true;
            }

            if (isModified) {
                oppToUpdate.add(opp);
            }
        }

        if (!oppToUpdate.isEmpty()) {
            update oppToUpdate;
        }
    }
}