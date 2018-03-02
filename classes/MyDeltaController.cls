global without sharing class MyDeltaController {
  @AuraEnabled
  public static User getUserInfo(Id userId) {
    if (userId == null) userId = UserInfo.getUserId();
    return [SELECT
            Id,
            Name,
            Contact.npo02__AverageAmount__c,
            Contact.npo02__Best_Gift_Year__c,
            Contact.npo02__Best_Gift_Year_Total__c,
            Contact.npo02__FirstCloseDate__c,
            Contact.npo02__LargestAmount__c,
            Contact.npo02__LastOppAmount__c,
            Contact.npo02__LastCloseDate__c,
            Contact.npo02__LastCloseDateHH__c,
            Contact.npo02__LastMembershipAmount__c,
            Contact.npo02__LastMembershipDate__c,
            Contact.npo02__LastMembershipLevel__c,
            Contact.npo02__LastMembershipOrigin__c,
            Contact.npo02__MembershipEndDate__c,
            Contact.npo02__MembershipJoinDate__c,
            Contact.npo02__OppsClosedLastNDays__c,
            Contact.npo02__OppsClosedLastYear__c,
            Contact.npo02__OppsClosedThisYear__c,
            Contact.npo02__OppsClosed2YearsAgo__c,
            Contact.npo02__NumberOfMembershipOpps__c,
            Contact.npo02__TotalOppAmount__c,
            Contact.npo02__OppAmountLastNDays__c,
            Contact.npo02__OppAmountLastYear__c,
            Contact.npo02__OppAmountThisYear__c,
            Contact.npo02__OppAmount2YearsAgo__c,
            Contact.npo02__Total_Household_Gifts__c,
            Contact.npo02__OppAmountLastYearHH__c,
            Contact.npo02__OppAmountThisYearHH__c,
            Contact.npo02__TotalMembershipOppAmount__c,
            Contact.npo02__NumberOfClosedOpps__c
            FROM User WHERE Id = :userId];
  }

  @AuraEnabled
  public static List<Opportunity> getDonations(Id userId) {
    if (userId == null) userId = UserInfo.getUserId();
    User conId = [SELECT Contact.Id FROM User WHERE Id = :userId];
    return [SELECT
            Id,
            Amount,
            npe01__Membership_End_Date__c,
            CloseDate
            FROM Opportunity
            WHERE npsp__Primary_Contact__c = :conId.Contact.Id
            AND RecordType.Name = 'Donation'
            AND StageName = 'Closed Won'
            ORDER BY CloseDate DESC];
  }

  @AuraEnabled
  public static List<Opportunity> getMemberships(Id userId) {
    if (userId == null) userId = UserInfo.getUserId();
    User conId = [SELECT Contact.Id FROM User WHERE Id = :userId];
    return [SELECT
            Id,
            Amount,
            npe01__Member_Level__c,
            Membership_Bundle__c,
            npe01__Membership_Start_Date__c,
            npe01__Membership_End_Date__c,
            Membership_Transaction_Type__c
            FROM Opportunity
            WHERE npsp__Primary_Contact__c = :conId.Contact.Id
            AND RecordType.Name = 'Membership'
            AND StageName = 'Closed Won'
            ORDER BY CloseDate DESC];
  }
}