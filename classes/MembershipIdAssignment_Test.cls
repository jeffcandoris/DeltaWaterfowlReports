@isTest
private class MembershipIdAssignment_Test {
  static testMethod void testExample() {
    Contact con = new Contact();
    con.lastname = 'test';
    insert con;
    List<Id> ids = new List<Id>();
    ids.add(con.id);
    Test.StartTest();
    MembershipIdAssignment.addMembershipIdInvocable(ids);
    Test.StopTest();
    Contact selectedCon = [SELECT id, Membership_Id__c from Contact where id =: con.id];
    system.assertNotEquals(null, selectedCon.Membership_Id__c);
  }
}