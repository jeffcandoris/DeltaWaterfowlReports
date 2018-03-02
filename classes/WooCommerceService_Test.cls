@isTest
private class WooCommerceService_Test {

  @isTest
  static void testWooCommerceModels() {
    Test.StartTest();
    WooCommerceModel.WooCommercePayloadModel WooCommercePayloadModelInstance = new WooCommerceModel.WooCommercePayloadModel();
    WooCommerceModel.WooCommerceOrder WooCommerceOrderInstance = new WooCommerceModel.WooCommerceOrder();
    WooCommerceModel.WooCommerceLineItem WooCommerceLineItemInstance = new WooCommerceModel.WooCommerceLineItem();
    WooCommerceModel.WooCommerceLineItemMetaData WooCommerceLineItemMetaDataInstance = new WooCommerceModel.WooCommerceLineItemMetaData();
    WooCommerceModel.WooCommerceCustomer WooCommerceCustomerInstance = new WooCommerceModel.WooCommerceCustomer();
    Test.StopTest();
  }

  @isTest
  static void testGenerateGenericOpp() {
    WooCommerce_Test_Models wctm = new WooCommerce_Test_Models();
    insert wctm.testContact;
    List<Contact> testContactList = [SELECT AccountId FROM Contact WHERE Email = :wctm.testWcpm.order.customer.email];
    Id testAccountId = testContactList[0].AccountId;
    insert wctm.testTransaction;

    Test.StartTest();
    // Use order.total to verify total order amount
    Opportunity opp = WooCommerceService.generateGenericOpp(wctm.testWcpm.order, testAccountId, wctm.testWcpm.order.total, wctm.testTransaction.Id);
    System.assertEquals(testAccountId, opp.AccountId);
    System.assertEquals(wctm.testWcpm.order.total, opp.Amount);
    System.assertEquals(wctm.testWcpm.order.campaign_id, opp.CampaignId);
    System.assertEquals(date.newinstance(wctm.testWcpm.order.completed_at.year(), wctm.testWcpm.order.completed_at.month(), wctm.testWcpm.order.completed_at.day()), opp.CloseDate);
    System.assertEquals('Credit Card', opp.Payment_Method__c);
    System.assertEquals(wctm.testTransaction.Id, opp.Transaction_Number__c);
    Test.StopTest();
  }

  @isTest
  static void testGenerateDonation() {
    WooCommerce_Test_Models wctm = new WooCommerce_Test_Models();
    insert wctm.testContact;
    List<Contact> testContactList = [SELECT AccountId FROM Contact WHERE Email = :wctm.testWcpm.order.customer.email];
    Id testAccountId = testContactList[0].AccountId;
    insert wctm.testTransaction;

    Test.StartTest();
    Opportunity opp = WooCommerceService.generateDonation(wctm.testWcpm.order, testAccountId, wctm.donationTotalSum, wctm.testTransaction.Id);
    System.assertEquals('Web Donation', opp.Name);
    System.assertEquals(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId(), opp.RecordTypeID);
    System.assertEquals(testAccountId, opp.AccountId);
    System.assertEquals(wctm.donationTotalSum, opp.Amount);
    System.assertEquals(wctm.testWcpm.order.campaign_id, opp.CampaignId);
    System.assertEquals('Credit Card', opp.Payment_Method__c);
    System.assertEquals('Closed Won - 100%', opp.StageName);
    System.assertEquals(wctm.testTransaction.Id, opp.Transaction_Number__c);
    Test.StopTest();
  }

  @isTest
  static void testGenerateMembership() {
    WooCommerce_Test_Models wctm = new WooCommerce_Test_Models();
    insert wctm.testContact;
    List<Contact> testContactList = [SELECT AccountId FROM Contact WHERE Email = :wctm.testWcpm.order.customer.email];
    Id testAccountId = testContactList[0].AccountId;
    insert wctm.testTransaction;

    Test.StartTest();
    Opportunity opp = WooCommerceService.generateMembership(wctm.testWcpm.order, wctm.testMembershipLi, testAccountId, wctm.testTransaction.Id);
    System.assertEquals(wctm.oppForMembership.Name, opp.Name);
    System.assertEquals(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId(), opp.RecordTypeID);
    System.assertEquals(wctm.testMembershipLi.name, opp.Description);
    System.assertEquals(Id.valueOf(wctm.testMembershipLi.membership_bundle_id), opp.Membership_Bundle__c);
    System.assertEquals(testAccountId, opp.AccountId);
    System.assertEquals(wctm.testMembershipLi.total, opp.Amount);
    System.assertEquals(wctm.testWcpm.order.campaign_id, opp.CampaignId);
    System.assertEquals(2, opp.Years__c);
    System.assertEquals('Credit Card', opp.Payment_Method__c);
    System.assertEquals('Closed Won - 100%', opp.StageName);
    System.assertEquals(wctm.testTransaction.Id, opp.Transaction_Number__c);
    Test.StopTest();
  }

  @isTest
  static void testGenerateMerchandise() {
    WooCommerce_Test_Models wctm = new WooCommerce_Test_Models();
    insert wctm.testContact;
    List<Contact> testContactList = [SELECT AccountId FROM Contact WHERE Email = :wctm.testWcpm.order.customer.email];
    Id testAccountId = testContactList[0].AccountId;
    insert wctm.testTransaction;

    Test.StartTest();
    Opportunity opp = WooCommerceService.generateMerchandise(wctm.testWcpm.order, testAccountId, wctm.merchandiseTotalSum, wctm.testTransaction.Id);
    System.assertEquals(wctm.oppForMerchandise.Name, opp.Name);
    System.assertEquals(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Merchandise').getRecordTypeId(), opp.RecordTypeID);
    System.assertEquals(wctm.merchandiseTotalSum, opp.Amount);
    System.assertEquals(wctm.testWcpm.order.campaign_id, opp.CampaignId);
    System.assertEquals('Credit Card', opp.Payment_Method__c);
    System.assertEquals('Closed Won - 100%', opp.StageName);
    System.assertEquals(wctm.testTransaction.Id, opp.Transaction_Number__c);
    Test.StopTest();
  }

  @isTest
  static void testGenerateTicket() {
    WooCommerce_Test_Models wctm = new WooCommerce_Test_Models();
    insert wctm.testContact;
    List<Contact> testContactList = [SELECT AccountId FROM Contact WHERE Email = :wctm.testWcpm.order.customer.email];
    Id testAccountId = testContactList[0].AccountId;
    insert wctm.testTransaction;

    Test.StartTest();
    Opportunity opp = WooCommerceService.generateTicket(wctm.testWcpm.order, testAccountId, wctm.ticketTotalSum, wctm.testTransaction.Id);
    System.assertEquals(wctm.oppForTicket.Name, opp.Name);
    System.assertEquals(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Ticket Order').getRecordTypeId(), opp.RecordTypeID);
    System.assertEquals(wctm.ticketTotalSum, opp.Amount);
    System.assertEquals(wctm.testWcpm.order.campaign_id, opp.CampaignId);
    System.assertEquals('Credit Card', opp.Payment_Method__c);
    System.assertEquals('Closed Won - 100%', opp.StageName);
    System.assertEquals(wctm.testTransaction.Id, opp.Transaction_Number__c);
    Test.StopTest();
  }

  @isTest
  static void testDonationHandler() {
    WooCommerce_Test_Models wctm = new WooCommerce_Test_Models();
    insert wctm.testContact;

    Opportunity opp = wctm.oppForDonation;
    insert opp;

    insert wctm.testTransaction;

    Test.StartTest();
    WooCommerceService.donationHandler(opp, wctm.testDonationLineItems);
    List<npsp__Allocation__c> testAllocationList = [SELECT Id, npsp__Amount__c, npsp__General_Accounting_Unit__c, npsp__Opportunity__c FROM npsp__Allocation__c WHERE npsp__Opportunity__c = :opp.id];
    System.assertEquals(wctm.testDonationLineItems.size(), testAllocationList.size());
    System.assertEquals(wctm.testDonationLineItems[0].total, testAllocationList[0].npsp__Amount__c);
    System.assertEquals(wctm.testDonationLineItems[1].total, testAllocationList[1].npsp__Amount__c);
    System.assertEquals(wctm.testDonationLineItems[0].gau_id, testAllocationList[0].npsp__General_Accounting_Unit__c);
    System.assertEquals(wctm.testDonationLineItems[1].gau_id, testAllocationList[1].npsp__General_Accounting_Unit__c);
    System.assertEquals(opp.id, testAllocationList[0].npsp__Opportunity__c);
    System.assertEquals(opp.id, testAllocationList[1].npsp__Opportunity__c);

    System.assertEquals(2, testAllocationList.size());
    Test.StopTest();
  }

  @isTest
  static void testMerchandiseHandler() {
    WooCommerce_Test_Models wctm = new WooCommerce_Test_Models();
    insert wctm.testContact;
    Opportunity opp = wctm.oppForMerchandise;
    insert opp;

    insert wctm.testTransaction;

    wctm.merchandiseOppLineItem.OpportunityId = opp.id;
    wctm.merchandiseOppLineItem2.OpportunityId = opp.id;

    Test.StartTest();
    WooCommerceService.merchandiseHandler(opp, wctm.testMerchandiseLineItems);
    List<OpportunityLineItem> selectedItems = [SELECT Id, OpportunityId, PricebookEntryId, Quantity, TotalPrice, Description, Color__c, Size__c FROM OpportunityLineItem WHERE OpportunityId = :opp.Id];

    System.assertEquals(wctm.merchandiseOppLineItem.OpportunityId, selectedItems[0].OpportunityId);
    System.assertEquals(wctm.merchandiseOppLineItem.PricebookEntryId, selectedItems[0].PriceBookEntryId);
    System.assertEquals(wctm.merchandiseOppLineItem.Quantity, selectedItems[0].Quantity);
    System.assertEquals(wctm.merchandiseOppLineItem.TotalPrice, selectedItems[0].TotalPrice);
    System.assertEquals(wctm.merchandiseOppLineItem.Description, selectedItems[0].Description);
    System.assertEquals(wctm.merchandiseOppLineItem.Color__c, selectedItems[0].Color__c);
    System.assertEquals(wctm.merchandiseOppLineItem.Size__c, selectedItems[0].Size__c);

    System.assertEquals(wctm.merchandiseOppLineItem2.OpportunityId, selectedItems[1].OpportunityId);
    System.assertEquals(wctm.merchandiseOppLineItem2.PricebookEntryId, selectedItems[1].PriceBookEntryId);
    System.assertEquals(wctm.merchandiseOppLineItem2.Quantity, selectedItems[1].Quantity);
    System.assertEquals(wctm.merchandiseOppLineItem2.TotalPrice, selectedItems[1].TotalPrice);
    System.assertEquals(wctm.merchandiseOppLineItem2.Description, selectedItems[1].Description);
    System.assertEquals(wctm.merchandiseOppLineItem2.Color__c, selectedItems[1].Color__c);
    System.assertEquals(wctm.merchandiseOppLineItem2.Size__c, selectedItems[1].Size__c);

    System.assertEquals(2, selectedItems.size());
    Test.StopTest();
  }

  @isTest
  static void testTicketHandler() {
    WooCommerce_Test_Models wctm = new WooCommerce_Test_Models();
    insert wctm.testContact;
    Opportunity opp = wctm.oppForTicket;
    insert opp;

    insert wctm.testTransaction;

    wctm.ticketOppLineItem.OpportunityId = opp.id;
    wctm.ticketOppLineItem2.OpportunityId = opp.id;

    Test.StartTest();
    WooCommerceService.ticketHandler(opp, wctm.testTicketLineItems);
    List<OpportunityLineItem> selectedItems = [SELECT Id, Description, Event__c, OpportunityId, PricebookEntryId, Quantity, TotalPrice FROM OpportunityLineItem WHERE OpportunityId = :opp.Id];

    System.assertEquals(wctm.ticketOppLineItem.Description, selectedItems[0].Description);
    System.assertEquals(wctm.ticketOppLineItem.Event__c, selectedItems[0].Event__c);
    System.assertEquals(wctm.ticketOppLineItem.OpportunityId, selectedItems[0].OpportunityId);
    System.assertEquals(wctm.ticketOppLineItem.PricebookEntryId, selectedItems[0].PriceBookEntryId);
    System.assertEquals(wctm.ticketOppLineItem.Quantity, selectedItems[0].Quantity);
    System.assertEquals(wctm.ticketOppLineItem.TotalPrice, selectedItems[0].TotalPrice);

    System.assertEquals(wctm.ticketOppLineItem2.Description, selectedItems[1].Description);
    System.assertEquals(wctm.ticketOppLineItem2.Event__c, selectedItems[1].Event__c);
    System.assertEquals(wctm.ticketOppLineItem2.OpportunityId, selectedItems[1].OpportunityId);
    System.assertEquals(wctm.ticketOppLineItem2.PricebookEntryID, selectedItems[1].PriceBookEntryId);
    System.assertEquals(wctm.ticketOppLineItem2.Quantity, selectedItems[1].Quantity);
    System.assertEquals(wctm.ticketOppLineItem2.TotalPrice, selectedItems[1].TotalPrice);

    System.assertEquals(2, selectedItems.size());
    Test.StopTest();
  }
}