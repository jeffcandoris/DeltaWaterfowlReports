@isTest
private class WooCommerceOrderBatcher_Test {

  static WooCommerce_Serializer__c setup(Contact con, String body) {
    Account acc = new Account();
    acc.Name = 'Test';
    insert acc;
    con.AccountId = acc.id;
    insert con;
    WooCommerce_Serializer__c ws = new WooCommerce_Serializer__c(
      Account__c = acc.id,
      Contact__c = con.id,
      Order_Number__c = 1,
      Body__c = body,
      Status__c = 'Not Processed'
    );
    insert ws;
    return ws;
  }

  @isTest
  static void testBatcher() {
    WooCommerce_Test_Models wctm = new WooCommerce_Test_Models();
    WooCommerce_Serializer__c ws = setup(wctm.testContact, wctm.testOrder);
    WooCommerceOrderBatcher wob = new WooCommerceOrderBatcher();
    Test.StartTest();
    wob.execute((SchedulableContext)null);
    Test.StopTest();

    List<Opportunity> oppList = [SELECT Id, Amount, CampaignId, CloseDate, Payment_Method__c, StageName, Name, RecordType.Name FROM Opportunity WHERE Web_Order_Number__c = 1];
    Integer numDonationOpps = 0;
    Integer numMembershipOpps = 0;
    Integer numMerchandiseOpps = 0;
    Integer numTicketOpps = 0;
    for (Opportunity opp : oppList) {
      String recordtypename = opp.RecordType.Name;
      Opportunity compareOpp;
      if (recordtypename == 'Donation') {
        numDonationOpps++;
        compareOpp = wctm.oppForDonation;
      } else if (recordtypename == 'Membership') {
        numMembershipOpps++;
        compareOpp = wctm.oppForMembership;
      } else if (recordtypename == 'Merchandise') {
        numMerchandiseOpps++;
        compareOpp = wctm.oppForMerchandise;
      } else if (recordtypename == 'Ticket Order') {
        numTicketOpps++;
        compareOpp = wctm.oppForTicket;
      }
      System.assertEquals(compareOpp.Amount, opp.Amount);
      System.assertEquals(compareOpp.CampaignId, opp.CampaignId);
      System.assertEquals(compareOpp.CloseDate, opp.CloseDate);
      System.assertEquals(compareOpp.Name, opp.Name);
      System.assertEquals(compareOpp.Payment_Method__c, opp.Payment_Method__c);
      System.assertEquals(compareOpp.StageName, opp.StageName);
    }
    System.assertEquals(1, numDonationOpps);
    System.assertEquals(1, numMembershipOpps);
    System.assertEquals(1, numMerchandiseOpps);
    System.assertEquals(1, numTicketOpps);
  }

  @isTest
  static void testCadOrder() {
    WooCommerce_Test_Models wctm = new WooCommerce_Test_Models();
    WooCommerce_Serializer__c ws = setup(wctm.testContact, wctm.testCADOrder);
    WooCommerceOrderBatcher wob = new WooCommerceOrderBatcher();
    Test.StartTest();
    wob.execute((SchedulableContext)null);
    Test.StopTest();

    List<Opportunity> oppList = [SELECT Id, CurrencyIsoCode FROM Opportunity WHERE Web_Order_Number__c = 1];
    for (Opportunity opp : oppList) {
      system.assertEquals('CAD', opp.CurrencyIsoCode);
    }
  }
}