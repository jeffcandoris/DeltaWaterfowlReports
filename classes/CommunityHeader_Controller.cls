public with sharing class CommunityHeader_Controller {
  public User uInfo {get; private set;}
  public CommunityHeader_Controller() {
    List<User> uList = [SELECT
    Id,
    Name,
    Email,
    UserType,
    ContactId,
    Contact.npo02__MembershipEndDate__c,
    Contact.npo02__TotalOppAmount__c
    FROM User WHERE Id = :UserInfo.getUserId()];
    uInfo = uList.isEmpty() ? null : uList[0];
  }
	@AuraEnabled
  public static String fetchUserType() {
    return UserInfo.getUserType();
  }
  @AuraEnabled
  public static String fetchUserID() {
    return UserInfo.getUserId();
  }
  @AuraEnabled
  public static String fetchName() {
    return UserInfo.getName();
  }
}