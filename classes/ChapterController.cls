global with sharing class ChapterController {
	@RemoteAction
	global static List<Account> getChapters() {
		List<Account> accountsByChapters = [select Id, Name, Type,
		Regional_Director__r.Name, Chapter_Number__c, Website, Facebook_Page__c,
		BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,
		BillingLatitude, BillingLongitude from Account where RecordType.Name = 'Chapter'];
		return accountsByChapters;
	}
}