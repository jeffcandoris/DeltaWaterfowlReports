global with sharing class WooCommerceOrderBatcher implements Database.Batchable <sObject>, Schedulable {

  private Integer batchSize = 1;

  global WooCommerceOrderBatcher() {}

  global WooCommerceOrderBatcher(Integer batchSize) {
    this.batchSize = batchSize;
  }

  global void execute(SchedulableContext sc) {
    Database.executebatch(this, batchSize);
  }

  global Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator([Select Id, Contact__c, Account__c, Body__c, Order_Number__c from WooCommerce_Serializer__c where Status__c = 'Not Processed']);
  }

  global void execute(Database.BatchableContext BC, List <sObject> scope) {
    Savepoint sp = Database.setSavepoint();
    WooCommerce_Serializer__c ws = (WooCommerce_Serializer__c)scope[0];
    try {
      handler(ws);
      ws.Status__c = 'Processed';
    } catch (Exception ex) {
      Database.rollback(sp);
      ws.Status__c = 'Failed';
      ws.Error__c = ex.getMessage() + '/n/n' + ex.getStackTraceString();
    }
    update ws;
  }

  global void finish(Database.BatchableContext BC) {}

  private static void handler(WooCommerce_Serializer__c ws) {
    WooCommerceModel.WooCommercePayloadModel wcpm = (WooCommerceModel.WooCommercePayloadModel)JSON.deserialize(ws.Body__c, WooCommerceModel.WooCommercePayloadModel.class);
    List<WooCommerceModel.WooCommerceLineItem> donationLineItems = new List<WooCommerceModel.WooCommerceLineItem>();
    List<WooCommerceModel.WooCommerceLineItem> merchandiseLineItems = new List<WooCommerceModel.WooCommerceLineItem>();
    List<WooCommerceModel.WooCommerceLineItem> ticketLineItems = new List<WooCommerceModel.WooCommerceLineItem>();
    Decimal donationTotalSum = 0.0;
    Decimal merchandiseTotalSum = 0.0;
    Decimal ticketTotalSum = 0.0;
    Transaction__c tran = new Transaction__c();
    tran.Payment_Method__c = 'Credit Card';
    tran.ownerId = '00536000001teKUAAY';
    insert tran;

    List<Opportunity> oppList = new List<Opportunity>();
    for (WooCommerceModel.WooCommerceLineItem li : wcpm.order.line_items) {
      if (li.product_type != null && li.product_type.toLowerCase() == 'membership') {
        oppList.add(WooCommerceService.generateMembership(wcpm.order, li, ws.Account__c, tran.Id));
      } else if (li.product_type != null && li.product_type.toLowerCase() == 'donation') {
        donationTotalSum += li.total;
        donationLineItems.add(li);
      } else if (li.product_type != null && li.product_type.toLowerCase() == 'merchandise') {
        merchandiseTotalSum += li.total;
        merchandiseLineItems.add(li);
      } else if (li.product_type != null && li.product_type.toLowerCase() == 'ticket') {
        ticketTotalSum += li.total;
        ticketLineItems.add(li);
      }
    }

    Opportunity donationOpp;
    Opportunity merchandiseOpp;
    Opportunity ticketOpp;
    Id donationId;
    Id merchandiseId;
    Id ticketId;
    if (donationLineItems.size() != 0) {
      donationOpp = WooCommerceService.generateDonation(wcpm.order, ws.Account__c, donationTotalSum, tran.Id);
      donationId = donationOpp.id;
      oppList.add(donationOpp);
    }
    if (merchandiseLineItems.size() != 0) {
      merchandiseOpp = WooCommerceService.generateMerchandise(wcpm.order, ws.Account__c, merchandiseTotalSum, tran.Id);
      merchandiseId = merchandiseOpp.id;
      oppList.add(merchandiseOpp);
    }
    if (ticketLineItems.size() != 0) {
      ticketOpp = WooCommerceService.generateTicket(wcpm.order, ws.Account__c, ticketTotalSum, tran.Id);
      ticketId = ticketOpp.id;
      oppList.add(ticketOpp);
    }

    upsert oppList;

    if (donationId == null && donationOpp != null) {
      WooCommerceService.donationHandler(donationOpp, donationLineItems);
      ws.Opportunity__c = donationOpp.Id;
    }
    if (merchandiseId == null && merchandiseOpp != null) {
      WooCommerceService.merchandiseHandler(merchandiseOpp, merchandiseLineItems);
      ws.Opportunity__c = merchandiseOpp.Id;
    }
    if (ticketId == null && ticketOpp != null) {
      WooCommerceService.ticketHandler(ticketOpp, ticketLineItems);
      ws.Opportunity__c = ticketOpp.Id;
    }
  }
}