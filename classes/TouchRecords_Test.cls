@isTest
private class TouchRecords_Test {

  @isTest static void testTouchRecords() {
    List<Account> accountsToInsert = new List<Account>();
    for (Integer i = 0; i < 100; i++) {
      accountsToInsert.add(new Account(Name = 'Test Account ' + i));
    }
    insert accountsToInsert;

    Test.startTest();
    Database.executeBatch(new TouchRecords('SELECT Id FROM Account'));
    Test.stopTest();
  }

}