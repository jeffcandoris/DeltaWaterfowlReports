public without sharing class WooCommerceService {

  public static Opportunity generateGenericOpp(WooCommerceModel.WooCommerceOrder order, Id accountId, Decimal sum, Id tranId) {
    Opportunity opp = new Opportunity();
    opp.AccountId = accountId;
    opp.Amount = sum;
    opp.CampaignId = order.campaign_id;
    opp.CloseDate = date.newinstance(order.created_at.year(), order.created_at.month(), order.created_at.day());
    opp.CurrencyIsoCode = order.currency_code;
    opp.Is_Web_Purchase__c = true;
    opp.Market_Source_Code__c = 'Woocommerce Online';
    opp.Payment_Method__c = 'Credit Card';
    opp.Web_Order_Number__c = order.order_number;
    opp.Transaction_Number__c = tranId;
    opp.StageName = 'Closed Won - 100%';
    if (order.do_not_send_gifts != null) {
      opp.Do_Not_Send_Gifts__c = order.do_not_send_gifts;
    }
    opp.OwnerId = '00536000001teKUAAY';
    return opp;
  }

  public static Opportunity setupGenericOpp(WooCommerceModel.WooCommerceOrder order, Id accountId, Decimal sum, Id tranId, Id typeId) {
    List<Opportunity> opps = [select Id, CampaignId from Opportunity where Web_Order_Number__c =: order.order_number and recordTypeId =: typeId];
    Opportunity opp;
    if (opps.size() != 1) {
      opp = generateGenericOpp(order, accountId, sum, tranId);
      opp.RecordTypeID = typeId;
    } else {
      opp = opps[0];
    }
    return opp;
  }

  public static Opportunity generateDonation(WooCommerceModel.WooCommerceOrder order, Id accountId, Decimal sum, Id tranId) {
    Id typeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
    Opportunity opp = setupGenericOpp(order, accountId, sum, tranId, typeId);
    opp.Name = 'Web Donation';
    return opp;
  }

  public static Opportunity generateMembership(WooCommerceModel.WooCommerceOrder order, WooCommerceModel.WooCommerceLineItem li, Id accountId, Id tranId) {
    Id typeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId();
    Opportunity opp = setupGenericOpp(order, accountId, li.total, tranId, typeId);
    if (opp.CampaignId == null) {
      List<Campaign> camps = [Select id from Campaign where name = 'MEM-GEN-ONLNE'];
      if (camps.size() > 0) {
        opp.CampaignId = camps[0].Id;
      }
    }
    opp.Name = 'Web Membership';
    if (li.name.contains('&rarr;') == true) {
      li.name = li.name.remove('&rarr; ');
    }
    opp.Years__c = li.quantity;
    opp.Description = li.name;
    opp.Membership_Bundle__c = Id.valueOf(li.membership_bundle_id);
    if (order.shirt_size != null) {
      opp.Gift_Reference__c = order.shirt_size;
    }
    return opp;
  }

  public static Opportunity generateMerchandise(WooCommerceModel.WooCommerceOrder order, Id accountId, Decimal sum, Id tranId) {
    Id typeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Merchandise').getRecordTypeId();
    Opportunity opp = setupGenericOpp(order, accountId, sum, tranId, typeId);
    opp.Name = 'Web Merchandise';
    return opp;
  }

  public static Opportunity generateTicket(WooCommerceModel.WooCommerceOrder order, Id accountId, Decimal sum, Id tranId) {
    Id typeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Ticket Order').getRecordTypeId();
    Opportunity opp = setupGenericOpp(order, accountId, sum, tranId, typeId);
    opp.Name = 'Web Ticket';
    return opp;
  }

  public static void donationHandler(Opportunity opp, List<WooCommerceModel.WooCommerceLineItem> wooLineItems) {
    List<npsp__Allocation__c> allocations = new List<npsp__Allocation__c>();
    for (WooCommerceModel.WooCommerceLineItem wooLineItem : wooLineItems) {
      npsp__Allocation__c allocation = new npsp__Allocation__c();
      allocation.npsp__Amount__c = wooLineItem.total;
      allocation.npsp__General_Accounting_Unit__c = String.isBlank(wooLineItem.gau_id) ? 'a0e36000003mC5u' : wooLineItem.gau_id;
      allocation.npsp__Opportunity__c = opp.id;
      allocation.ownerId = '00536000001teKUAAY';
      allocations.add(allocation);
    }
    insert allocations;
  }

  public static void merchandiseHandler(Opportunity opp, List<WooCommerceModel.WooCommerceLineItem> wooLineItems) {
    List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
    Webstore__c ws = Webstore__c.getInstance('WooCommerce');
    for (WooCommerceModel.WooCommerceLineItem wooLineItem : wooLineItems) {
      OpportunityLineItem lineItem = new OpportunityLineItem();
      if (wooLineItem.name.contains(' &rarr;') == true) {
        wooLineItem.name = wooLineItem.name.remove(' &rarr;');
      }
      lineItem.Description = wooLineItem.name;
      lineItem.OpportunityId = opp.id;
      lineItem.PricebookEntryId = opp.CurrencyIsoCode == 'USD' ? ws.Web_Merchandise_Pricebook_ID__c : ws.Web_Merchandise_Pricebook_ID_CAD__c;
      lineItem.Quantity = wooLineItem.quantity;
      lineItem.TotalPrice = wooLineItem.total;

      for (WooCommerceModel.WooCommerceLineItemMetaData metaData : wooLineItem.meta) {
        if (String.isEmpty(metaData.key) == false && metaData.key.contains('size')) {
          if (String.isEmpty(metaData.value) == false) {
            lineItem.Size__c = metaData.value;
          }
        }
        if (String.isEmpty(metaData.key) == false && metaData.key.contains('color')) {
          if (String.isEmpty(metaData.value) == false) {
            lineItem.Color__c = metaData.value;
          }
        }
      }
      lineItems.add(lineItem);
    }
    insert lineItems;
  }

  public static void ticketHandler(Opportunity opp, List<WooCommerceModel.WooCommerceLineItem> wooLineItems) {
    List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
    Webstore__c ws = Webstore__c.getInstance('WooCommerce');
    for (WooCommerceModel.WooCommerceLineItem wooLineItem : wooLineItems) {
      OpportunityLineItem lineItem = new OpportunityLineItem();
      if (wooLineItem.name.contains(' &rarr;') == true) {
        wooLineItem.name = wooLineItem.name.remove(' &rarr;');
      }
      lineItem.Description = wooLineItem.name;
      lineItem.Event__c = wooLineItem.campaign_id;
      lineItem.OpportunityId = opp.id;
      lineItem.PricebookEntryId = opp.CurrencyIsoCode == 'USD' ? ws.Web_Ticket_Pricebook_ID__c : ws.Web_Ticket_Pricebook_ID_CAD__c;
      lineItem.Quantity = wooLineItem.quantity;
      lineItem.TotalPrice = wooLineItem.total;
      if (wooLineItem.ticket_weight == null) {
        wooLineItem.ticket_weight = 1;
      }
      lineItem.Ticket_Total__c = wooLineItem.ticket_weight * wooLineItem.quantity;
      for (WooCommerceModel.WooCommerceLineItemMetaData metaData : wooLineItem.meta) {
        if (String.isEmpty(metaData.key) == false && metaData.key.contains('ticket_name')) {
          if (String.isEmpty(metaData.value) == false) {
            lineItem.Description  += ' (' + metaData.value + ')';
          }
        }
      }
      lineItems.add(lineItem);
    }
    insert lineItems;
  }
}