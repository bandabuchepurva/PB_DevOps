@isTest
public class PipelineValidatorTest {

    @isTest
    static void testValidateAndUpdate() {

        // Create test Account (required for Opportunity)
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Create test Opportunities
        List<Opportunity> oppList = new List<Opportunity>();

        // Case 1: High value opportunity
        oppList.add(new Opportunity(
            Name = 'Big Deal',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            Amount = 150000,
            AccountId = acc.Id
        ));

        // Case 2: Past close date
        oppList.add(new Opportunity(
            Name = 'Old Deal',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(-5),
            Amount = 5000,
            AccountId = acc.Id
        ));

        insert oppList;

        Test.startTest();
        PipelineValidator.validateAndUpdate(oppList);
        Test.stopTest();

        // Fetch updated records
        List<Opportunity> updatedOpps = [
            SELECT Id, StageName, Description 
            FROM Opportunity 
            WHERE Id IN :oppList
        ];

        for (Opportunity opp : updatedOpps) {

            if (opp.Name == 'Big Deal') {
                System.assertEquals(
                    'High Value Opportunity',
                    opp.Description,
                    'High value opportunity not tagged correctly'
                );
            }

            if (opp.Name == 'Old Deal') {
                System.assertEquals(
                    'Closed Lost',
                    opp.StageName,
                    'Past close date opportunity not updated correctly'
                );
            }
        }
    }
}