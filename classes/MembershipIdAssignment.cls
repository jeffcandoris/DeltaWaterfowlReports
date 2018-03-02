public class MembershipIdAssignment {

  @Future
  public static void addMembershipId(List<Id> conIds) {
    List<Contact> cons = [select id, Auto_Membership_Id__c from Contact where id in: conIds];
    for (Contact con : cons) {
      con.Membership_Id__c = (String)con.get('Auto_Membership_Id__c');
    }
    update cons;
  }

  @InvocableMethod
  public static void addMembershipIdInvocable(List<Id> conIds) {
    addMembershipId(conIds);
  }
}