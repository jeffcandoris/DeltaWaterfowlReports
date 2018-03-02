@isTest
private class DeleteTransactionRecords_Test {

	@isTest
	static void testDeleteTransactionRecords() {
		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
		User u = new User(Alias = 'mytest', Email='candadmin@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId = p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='candadmin@testorg.com');

		System.runAs(u) {
			List<Transaction__c> transList = new List<Transaction__c>();

			for (Integer i = 0; i < 5; i++) {
				Transaction__c t = new Transaction__c();
				t.Opportunity_Count__c = 0;
				t.Amount__c = 0.00;
				t.CurrencyIsoCode = 'USD';
				transList.add(t);
			}

			insert transList;

			Test.StartTest();
			DeleteTransactionRecords del = new DeleteTransactionRecords();
			Database.executeBatch(del);
			Test.StopTest();

		}
	}
}