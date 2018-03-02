@isTest
private class ChapterController_Test {

	@isTest
	static void testGetChapters() {

		Contact directorContact = new Contact();
		directorContact.LastName = 'TestDirector';
		insert directorContact;

		Account acc = new Account();
		acc.Name = 'Test4';
		acc.Regional_Director__c = directorContact.Id;
		acc.Chapter_Number__c = '7';
		acc.RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Chapter').getRecordTypeId();
		acc.Website = 'www.test4website.com';
		acc.Facebook_page__c = 'test4forsure';
		insert acc;

		Account acc2 = new Account();
		acc2.Name = 'Test5';
		acc2.RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household Account').getRecordTypeId();
		insert acc2;

		Account acc3 = new Account();
		acc3.Name = 'Test6';
		acc3.Regional_Director__c = directorContact.Id;
		acc3.Chapter_Number__c = '12';
		acc3.RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Chapter').getRecordTypeId();
		acc3.Website = 'www.test6website.com';
		acc3.Facebook_page__c = 'test6site';
		insert acc3;

		Test.StartTest();
		List<Account> testList = ChapterController.getChapters();
		Test.StopTest();

		System.assertEquals(acc.Name, testList[0].Name);
		System.assertEquals(acc3.Name, testList[1].Name);
		System.assertEquals(acc.Regional_Director__c, testList[0].Regional_Director__c);
		System.assertEquals(acc3.Regional_Director__c, testList[1].Regional_Director__c);
		System.assertEquals(directorContact.LastName, testList[0].Regional_Director__r.Name);
		System.assertEquals(directorContact.LastName, testList[1].Regional_Director__r.Name);
		System.assertEquals(acc.Chapter_Number__c, testList[0].Chapter_Number__c);
		System.assertEquals(acc3.Chapter_Number__c, testList[1].Chapter_Number__c);
		System.assertEquals(acc.Website , testList[0].Website);
	 	System.assertEquals(acc3.Website , testList[1].Website);
		System.assertEquals(acc.Facebook_page__c, testList[0].Facebook_Page__c);
		System.assertEquals(acc3.Facebook_page__c, testList[1].Facebook_Page__c);
		System.assertEquals(2, testList.size());
	}
}