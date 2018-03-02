@isTest
private class AuthorizeNetService_Test {

  static AuthorizeNetService ans = new AuthorizeNetService('123', '123', true);

  @isTest static void testCreateTransaction() {
    AuthorizeNetModels.creditCardType creditCard = new AuthorizeNetModels.creditCardType();
    creditCard.cardCode = '123';
    creditCard.cardNumber = '1234123412341234';
    creditCard.expirationDate = '2020-05';

    AuthorizeNetModels.paymentType payment = new AuthorizeNetModels.paymentType();
    payment.creditCard = creditCard;

    AuthorizeNetModels.orderType order = new AuthorizeNetModels.orderType();
    order.invoiceNumber = '123';
    order.description = '123';

    List<AuthorizeNetModels.lineItemType> lineItems = new List<AuthorizeNetModels.lineItemType>();
    AuthorizeNetModels.lineItemType lineItem = new AuthorizeNetModels.lineItemType();
    lineItem.itemId = '123';
    lineItem.name = '123';
    lineItem.description = '123';
    lineItem.quantity = 123;
    lineItem.unitPrice = 10.00;
    lineItems.add(lineItem);

    AuthorizeNetModels.extendedAmountType tax = new AuthorizeNetModels.extendedAmountType();
    tax.name = '123';
    tax.description = '123';
    tax.amount = 10.00;

    AuthorizeNetModels.extendedAmountType duty = new AuthorizeNetModels.extendedAmountType();
    duty.name = '123';
    duty.description = '123';
    duty.amount = 10.00;

    AuthorizeNetModels.extendedAmountType shipping = new AuthorizeNetModels.extendedAmountType();
    shipping.name = '123';
    shipping.description = '123';
    shipping.amount = 10.00;

    AuthorizeNetModels.customerType customer = new AuthorizeNetModels.customerType();
    customer.id = '123';

    AuthorizeNetModels.addressType address = new AuthorizeNetModels.addressType();
    address.firstName = '123';
    address.lastName = '123';
    address.company = '123';
    address.address = '123';
    address.city = '123';
    address.state = '123';
    address.zip = '123';
    address.country = '123';

    AuthorizeNetModels.transactionRequestType tr = new AuthorizeNetModels.transactionRequestType();
    tr.transactionType = 'authCaptureTransaction';
    tr.amount = 10.00;
    tr.payment = payment;
    tr.order = order;
    tr.lineItems = lineItems;
    tr.tax = tax;
    tr.duty = duty;
    tr.shipping = shipping;
    tr.poNumber = '123';
    tr.customer = customer;
    tr.billTo = address;
    tr.shipTo = address;
    tr.customerIP = '123';

    AuthorizeNetModels.solutionType solution = new AuthorizeNetModels.solutionType();
    solution.id = '123';
    solution.name = 'test';
    solution.vendorName = 'test';
    tr.solution = solution;

    AuthorizeNetModels.transRetailInfoType retail = new AuthorizeNetModels.transRetailInfoType();
    retail.customerSignature = 'test';
    retail.deviceType = 'test';
    retail.marketType = 'test';
    tr.retail = retail;

    AuthorizeNetModels.ccAuthenticationType ccAuth = new AuthorizeNetModels.ccAuthenticationType();
    ccAuth.authenticationIndicator = 'test';
    ccAuth.cardholderAuthenticationValue = 'test';
    tr.cardholderAuthentication = ccAuth;

    AuthorizeNetModels.settingType setting = new AuthorizeNetModels.settingType();
    setting.settingName = 'test';
    setting.settingValue = 'test';
    tr.transactionSettings = new List<AuthorizeNetModels.settingType>();
    tr.transactionSettings.add(setting);

    AuthorizeNetModels.userField userField = new AuthorizeNetModels.userField();
    userField.name = 'test';
    userField.value = 'test';
    tr.userFields = new List<AuthorizeNetModels.userField>();
    tr.userFields.add(userField);

    String responseString = '<?xml version="1.0" encoding="UTF-8"?><createTransactionResponse xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><refId>123456</refId><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful.</text></message></messages><transactionResponse><responseCode>1</responseCode><authCode>UGELQC</authCode><avsResultCode>E</avsResultCode><cavvResultCode /><transId>2148061808</transId><refTransID /><transHash>0B428D8A928AAC61121AF2F6EAC5FF3F</transHash><accountNumber>XXXX0015</accountNumber><accountType>MasterCard</accountType><message><code>1</code><description>This transaction has been approved.</description></message><userFields><userField><name>MerchantDefinedFieldName1</name><value>MerchantDefinedFieldValue1</value></userField><userField><name>favorite_color</name><value>lavender</value></userField></userFields></transactionResponse></createTransactionResponse>';
    Map<String, String> headers = new Map<String, String> {
      'Content-Type' => 'text/xml'
    };
    AuthorizeNetServiceMock mockResponse = new AuthorizeNetServiceMock(200, 'Complete', responseString, headers);
    Test.setMock(HttpCalloutMock.class, mockResponse);

    Test.startTest();
    AuthorizeNetModels.createTransactionResponse response = ans.createTransaction(tr, '123');
    Test.stopTest();
  }

  @isTest static void testCreateSubscription() {
    AuthorizeNetModels.paymentScheduleTypeInterval interval = new AuthorizeNetModels.paymentScheduleTypeInterval();
    interval.length = 123;
    interval.unit = '123';

    AuthorizeNetModels.paymentScheduleType paymentSchedule = new AuthorizeNetModels.paymentScheduleType();
    paymentSchedule.interval = interval;
    paymentSchedule.startDate = '123';
    paymentSchedule.totalOccurrences = 123;
    paymentSchedule.trialOccurrences = 123;

    AuthorizeNetModels.creditCardType creditCard = new AuthorizeNetModels.creditCardType();
    creditCard.cardCode = '123';
    creditCard.cardNumber = '1234123412341234';
    creditCard.expirationDate = '2020-05';
    AuthorizeNetModels.paymentType payment = new AuthorizeNetModels.paymentType();
    payment.creditCard = creditCard;

    AuthorizeNetModels.customerType customer = new AuthorizeNetModels.customerType();
    customer.id = '123';
    AuthorizeNetModels.addressType address = new AuthorizeNetModels.addressType();
    address.firstName = '123';
    address.lastName = '123';
    address.company = '123';
    address.address = '123';
    address.city = '123';
    address.state = '123';
    address.zip = '123';
    address.country = '123';

    AuthorizeNetModels.ARBSubscriptionType sub = new AuthorizeNetModels.ARBSubscriptionType();
    sub.name = '123';
    sub.paymentSchedule = paymentSchedule;
    sub.amount = 10.00;
    sub.trialAmount = 10.00;
    sub.payment = payment;
    sub.customer = customer;
    sub.billTo = address;
    sub.shipTo = address;

    String responseString = '<?xml version="1.0" encoding="utf-8"?><ARBCreateSubscriptionResponse xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd"><refId>Sample</refId><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful.</text></message></messages><subscriptionId>100748</subscriptionId><profile><customerProfileId>247150</customerProfileId><customerPaymentProfileId>215472</customerPaymentProfileId><customerAddressId>189691</customerAddressId></profile></ARBCreateSubscriptionResponse>';
    Map<String, String> headers = new Map<String, String> {
      'Content-Type' => 'text/xml'
    };
    AuthorizeNetServiceMock mockResponse = new AuthorizeNetServiceMock(200, 'Complete', responseString, headers);
    Test.setMock(HttpCalloutMock.class, mockResponse);

    Test.startTest();
    AuthorizeNetModels.ARBCreateSubscriptionResponse response = ans.createSubscription(sub, '123');
    Test.stopTest();
  }

  @isTest static void testUpdateSubscription() {
    AuthorizeNetModels.paymentScheduleTypeInterval interval = new AuthorizeNetModels.paymentScheduleTypeInterval();
    interval.length = 123;
    interval.unit = '123';

    AuthorizeNetModels.paymentScheduleType paymentSchedule = new AuthorizeNetModels.paymentScheduleType();
    paymentSchedule.interval = interval;
    paymentSchedule.startDate = '123';
    paymentSchedule.totalOccurrences = 123;
    paymentSchedule.trialOccurrences = 123;

    AuthorizeNetModels.creditCardType creditCard = new AuthorizeNetModels.creditCardType();
    creditCard.cardCode = '123';
    creditCard.cardNumber = '1234123412341234';
    creditCard.expirationDate = '2020-05';
    AuthorizeNetModels.paymentType payment = new AuthorizeNetModels.paymentType();
    payment.creditCard = creditCard;

    AuthorizeNetModels.customerType customer = new AuthorizeNetModels.customerType();
    customer.id = '123';
    AuthorizeNetModels.addressType address = new AuthorizeNetModels.addressType();
    address.firstName = '123';
    address.lastName = '123';
    address.company = '123';
    address.address = '123';
    address.city = '123';
    address.state = '123';
    address.zip = '123';
    address.country = '123';

    AuthorizeNetModels.ARBSubscriptionType sub = new AuthorizeNetModels.ARBSubscriptionType();
    sub.name = '123';
    sub.paymentSchedule = paymentSchedule;
    sub.amount = 10.00;
    sub.trialAmount = 10.00;
    sub.payment = payment;
    sub.customer = customer;
    sub.billTo = address;
    sub.shipTo = address;
    String responseString = '<?xml version="1.0" encoding="utf-8"?><ARBUpdateSubscriptionResponse xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd"><refId>Sample</refId><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful.</text></message></messages><profile><customerProfileId>247150</customerProfileId><customerPaymentProfileId>215472</customerPaymentProfileId><customerAddressId>189691</customerAddressId></profile></ARBUpdateSubscriptionResponse>';
    Map<String, String> headers = new Map<String, String> {
      'Content-Type' => 'text/xml'
    };
    AuthorizeNetServiceMock mockResponse = new AuthorizeNetServiceMock(200, 'Complete', responseString, headers);
    Test.setMock(HttpCalloutMock.class, mockResponse);

    Test.startTest();
    AuthorizeNetModels.ARBUpdateSubscriptionResponse response = ans.updateSubscription(sub, '123', '123');
    Test.stopTest();
  }

  @isTest static void testCancelSubscription() {
    String responseString = '<?xml version="1.0" encoding="utf-8"?><ARBCancelSubscriptionResponse xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd"><refId>Sample</refId><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful.</text></message></messages></ARBCancelSubscriptionResponse>';
    Map<String, String> headers = new Map<String, String> {
      'Content-Type' => 'text/xml'
    };
    AuthorizeNetServiceMock mockResponse = new AuthorizeNetServiceMock(200, 'Complete', responseString, headers);
    Test.setMock(HttpCalloutMock.class, mockResponse);

    Test.startTest();
    AuthorizeNetModels.ARBCancelSubscriptionResponse response = ans.cancelSubscription('123', '123');
    Test.stopTest();
  }

  @isTest static void testGetSubscription() {
    String responseString = '<?xml version="1.0" encoding="UTF-8"?><ARBGetSubscriptionResponse xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><refId>Sample</refId><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful.</text></message></messages><subscription><name>Sample subscription</name><paymentSchedule><interval><length>1</length><unit>months</unit></interval><startDate>2020-12-30</startDate><totalOccurrences>12</totalOccurrences><trialOccurrences>1</trialOccurrences></paymentSchedule><amount>10.29</amount><trialAmount>0.00</trialAmount><status>active</status><profile><description>Profile created by Subscription: 2930242</description><customerProfileId>37978171</customerProfileId><paymentProfile><customerType>individual</customerType><billTo><firstName>John</firstName><lastName>Smith</lastName></billTo><customerPaymentProfileId>34531293</customerPaymentProfileId><payment><creditCard><cardNumber>XXXX1111</cardNumber><expirationDate>XXXX</expirationDate></creditCard></payment></paymentProfile></profile></subscription></ARBGetSubscriptionResponse>';
    Map<String, String> headers = new Map<String, String> {
      'Content-Type' => 'text/xml'
    };
    AuthorizeNetServiceMock mockResponse = new AuthorizeNetServiceMock(200, 'Complete', responseString, headers);
    Test.setMock(HttpCalloutMock.class, mockResponse);

    Test.startTest();
    AuthorizeNetModels.ARBGetSubscriptionResponse response = ans.getSubscription('123', '123');
    Test.stopTest();
  }

  @isTest static void testGetSubscriptionStatus() {
    String responseString = '<?xml version="1.0" encoding="UTF-8"?><ARBGetSubscriptionStatusResponse xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/ XMLSchema-instance"><refId>Sample</refId><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful</text></message></messages><Status>active</Status></ARBGetSubscriptionStatusResponse>';
    Map<String, String> headers = new Map<String, String> {
      'Content-Type' => 'text/xml'
    };
    AuthorizeNetServiceMock mockResponse = new AuthorizeNetServiceMock(200, 'Complete', responseString, headers);
    Test.setMock(HttpCalloutMock.class, mockResponse);

    Test.startTest();
    AuthorizeNetModels.ARBGetSubscriptionStatusResponse response = ans.getSubscriptionStatus('123', '123');
    Test.stopTest();
  }

  @isTest static void testGetSettledBatchList() {
    String responseString = '<?xml version="1.0" encoding="UTF-8"?><getSettledBatchListResponse xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd"><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful.</text></message></messages><batchList><batch><batchId>12345678</batchId><settlementTimeUTC>2010-05-30T09:00:00</settlementTimeUTC><settlementTimeLocal>2010-05-30T03:00:00</settlementTimeLocal><settlementState>settledSuccessfully</settlementState><marketType>eCommerce</marketType><product>Card Not Present</product><statistics><statistic><accountType>Visa</accountType><!-- accountTypeEnum --><chargeAmount>200.00</chargeAmount><chargeCount>13</chargeCount><refundAmount>10.00</refundAmount><refundCount>1</refundCount><voidCount>2</voidCount><declineCount>4</declineCount><errorCount>6</errorCount><returnedItemAmount>0.00</returnedItemAmount><returnedItemCount>0</returnedItemCount><chargebackAmount>0.00</chargebackAmount><chargebackCount>0</chargebackCount><correctionNoticeCount>0</correctionNoticeCount><chargeChargeBackAmount>0.00</chargeChargeBackAmount><chargeChargeBackCount>0</chargeChargeBackCount><getBatchStatisticsResponseAmount>0.00</getBatchStatisticsResponseAmount><getBatchStatisticsResponseCount>0</getBatchStatisticsResponseCount><chargeReturnedItemsAmount>0.00</chargeReturnedItemsAmount><chargeReturnedItemsCount>0</chargeReturnedItemsCount><refundReturnedItemsAmount>0.00</refundReturnedItemsAmount><refundReturnedItemsCount>0</refundReturnedItemsCount></statistic><statistic><accountType>MasterCard</accountType><chargeAmount>200.00</chargeAmount><chargeCount>13</chargeCount><refundAmount>10.00</refundAmount><refundCount>1</refundCount><voidCount>2</voidCount><declineCount>4</declineCount><errorCount>6</errorCount><chargebackAmount>0.00</chargebackAmount><chargebackCount>0</chargebackCount><correctionNoticeCount>0</correctionNoticeCount><chargeChargeBackAmount>0.00</chargeChargeBackAmount><chargeChargeBackCount>0</chargeChargeBackCount><getBatchStatisticsResponseAmount>0.00</getBatchStatisticsResponseAmount><getBatchStatisticsResponseCount>0</getBatchStatisticsResponseCount></statistic></statistics></batch><batch><batchId>23456789</batchId><settlementTimeUTC>2010-05-30T09:00:00</settlementTimeUTC><settlementTimeLocal>2010-05-30T03:00:00</settlementTimeLocal><settlementState>settledSuccessfully</settlementState><statistics><statistic><accountType>eCheck</accountType><chargeAmount>200.00</chargeAmount><chargeCount>13</chargeCount><refundAmount>10.00</refundAmount><refundCount>1</refundCount><voidCount>2</voidCount><declineCount>4</declineCount><errorCount>6</errorCount><returnedItemAmount>0.00</returnedItemAmount><returnedItemCount>0</returnedItemCount><correctionNoticeCount>0</correctionNoticeCount><chargeReturnedItemsAmount>0.00</chargeReturnedItemsAmount><chargeReturnedItemsCount>0</chargeReturnedItemsCount><refundReturnedItemsAmount>0.00</refundReturnedItemsAmount><refundReturnedItemsCount>0</refundReturnedItemsCount></statistic></statistics></batch></batchList></getSettledBatchListResponse>';
    Map<String, String> headers = new Map<String, String> {
      'Content-Type' => 'text/xml'
    };
    AuthorizeNetServiceMock mockResponse = new AuthorizeNetServiceMock(200, 'Complete', responseString, headers);
    Test.setMock(HttpCalloutMock.class, mockResponse);

    Test.startTest();
    AuthorizeNetModels.getSettledBatchListResponse response = ans.getSettledBatchList(Datetime.now(), Datetime.now(), true, '123');
    Test.stopTest();
  }

  @isTest static void testGetTransactionList() {
    String responseString = '<?xml version="1.0" encoding="UTF-8"?><getTransactionListResponse xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd"><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful.</text></message></messages><transactions><transaction><transId>12345</transId><submitTimeUTC>2009-05-30T09:00:00</submitTimeUTC><submitTimeLocal>2009-05-30T04:00:00</submitTimeLocal><transactionStatus>settledSuccessfully</transactionStatus><invoice>INV00001</invoice><firstName>John</firstName><lastName>Doe</lastName><amount>2.00</amount><accountType>Visa</accountType><accountNumber>XXXX1111</accountNumber><settleAmount>2.00</settleAmount><subscription><id>145521</id><payNum>1</payNum></subscription></transaction><transaction><transId>12345</transId><submitTimeUTC>2009-05-30T09:00:00</submitTimeUTC><submitTimeLocal>2009-05-30T04:00:00</submitTimeLocal><transactionStatus>settledSuccessfully</transactionStatus><invoice>INV00001</invoice><firstName>John</firstName><lastName>Doe</lastName><amount>2.00</amount><accountType>Visa</accountType><accountNumber>XXXX1111</accountNumber><marketType>eCommerce</marketType><product>Card Not Present</product><mobileDeviceId>2354578983274523978</mobileDeviceId></transaction></transactions></getTransactionListResponse>';
    Map<String, String> headers = new Map<String, String> {
      'Content-Type' => 'text/xml'
    };
    AuthorizeNetServiceMock mockResponse = new AuthorizeNetServiceMock(200, 'Complete', responseString, headers);
    Test.setMock(HttpCalloutMock.class, mockResponse);

    Test.startTest();
    AuthorizeNetModels.getTransactionListResponse response = ans.getTransactionList('123', '123');
    Test.stopTest();
  }

  @isTest static void testGetUnsettledTransactionList() {
    String responseString = '<?xml version="1.0" encoding="UTF-8"?><getUnsettledTransactionListResponse xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful.</text></message></messages><transactions><transaction><transId>2158982012</transId><submitTimeUTC>2011-04-05T17:30:21Z</submitTimeUTC><submitTimeLocal>2011-04-05T18:30:21</submitTimeLocal><transactionStatus>authorizedPendingCapture</transactionStatus><invoiceNumber>123124123432</invoiceNumber><firstName>Unit</firstName><lastName>Tests</lastName><accountType>Visa</accountType><accountNumber>XXXX1111</accountNumber><settleAmount>1.11</settleAmount></transaction></transactions></getUnsettledTransactionListResponse>';
    Map<String, String> headers = new Map<String, String> {
      'Content-Type' => 'text/xml'
    };
    AuthorizeNetServiceMock mockResponse = new AuthorizeNetServiceMock(200, 'Complete', responseString, headers);
    Test.setMock(HttpCalloutMock.class, mockResponse);

    Test.startTest();
    AuthorizeNetModels.getUnsettledTransactionListResponse response = ans.getUnsettledTransactionList();
    Test.stopTest();
  }

  @isTest static void testGetTransactionDetails() {
    String responseString = '<?xml version="1.0" encoding="UTF-8"?><getTransactionDetailsResponse xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful.</text></message></messages><transaction><transId>12345</transId><refTransId>12345</refTransId><splitTenderId>12345</splitTenderId><submitTimeUTC>2010-08-30T17:49:20.757Z</submitTimeUTC><submitTimeLocal>2010-08-30T13:49:20.757</submitTimeLocal><transactionType>authOnlyTransaction</transactionType><transactionStatus>settledSuccessfully</transactionStatus><responseCode>1</responseCode><responseReasonCode>1</responseReasonCode><responseReasonDescription>Approval</responseReasonDescription><authCode>000000</authCode><AVSResponse>X</AVSResponse><cardCodeResponse>M</cardCodeResponse><CAVVResponse>2</CAVVResponse><FDSFilterAction>authAndHold</FDSFilterAction><FDSFilters><FDSFilter><name>Hourly Velocity Filter</name><action>authAndHold</action></FDSFilter><FDSFilter><name>Amount Filter</name><action>report</action></FDSFilter></FDSFilters><batch><batchId>12345</batchId><settlementTimeUTC>2010-08-30T17:49:20.757Z</settlementTimeUTC><settlementTimeLocal>2010-08-30T13:49:20.757</settlementTimeLocal><settlementState>settledSuccessfully</settlementState></batch><order><invoiceNumber>INV00001</invoiceNumber><description>some description</description><purchaseOrderNumber>PO000001</purchaseOrderNumber></order><requestedAmount>5.00</requestedAmount><authAmount>2.00</authAmount><settleAmount>2.00</settleAmount><tax><amount>1.00</amount><name>WA state sales tax</name><description>Washington state sales tax</description></tax><shipping><amount>2.00</amount><name>ground based shipping</name><description>Ground based 5 to 10 day shipping</description></shipping><duty><amount>1.00</amount></duty><lineItems><lineItem><itemId>ITEM00001</itemId><name>name of item sold</name><description>Description of item sold</description><quantity>1</quantity><unitPrice>6.95</unitPrice><taxable>true</taxable></lineItem><lineItem><itemId>ITEM00001</itemId><name>name of item sold</name><description>Description of item sold</description><quantity>1</quantity><unitPrice>6.95</unitPrice><taxable>true</taxable></lineItem></lineItems><prepaidBalanceRemaining>30.00</prepaidBalanceRemaining><taxExempt>false</taxExempt><payment><creditCard><cardNumber>XXXX1111</cardNumber><expirationDate>XXXX</expirationDate><accountType>Visa</accountType></creditCard></payment><customer><type>individual</type><id>ABC00001</id><email>mark@example.com</email></customer><billTo><firstName>John</firstName><lastName>Doe</lastName><company /><address>123 Main St.</address><city>Bellevue</city><state>WA</state><zip>98004</zip><country>USA</country><phoneNumber>000-000-0000</phoneNumber><faxNumber /></billTo><shipTo><firstName>John</firstName><lastName>Doe</lastName><company /><address>123 Main St.</address><city>Bellevue</city><state>WA</state><zip>98004</zip><country>USA</country></shipTo><recurringBilling>false</recurringBilling><customerIP>0.0.0.0</customerIP><subscription><id>145521</id><payNum>1</payNum><marketType>eCommerce</marketType><product>Card Not Present</product><returnedItems><returnedItem><id>2148878904</id><dateUTC>2014-05-12T21:22:44Z</dateUTC><dateLocal>2014-05-12T14:22:44</dateLocal><code>R02</code><description>Account Closed</description></returnedItem></returnedItems><solution><id>A1000004</id><name>Shopping Cart</name></solution><mobileDeviceId>2354578983274523978</mobileDeviceId></subscription></transaction></getTransactionDetailsResponse>';
    Map<String, String> headers = new Map<String, String> {
      'Content-Type' => 'text/xml'
    };
    AuthorizeNetServiceMock mockResponse = new AuthorizeNetServiceMock(200, 'Complete', responseString, headers);
    Test.setMock(HttpCalloutMock.class, mockResponse);

    Test.startTest();
    AuthorizeNetModels.getTransactionDetailsResponse response = ans.getTransactionDetails('123', '123');
    Test.stopTest();
  }

  @isTest static void testGetBatchStatistics() {
    String responseString = '<?xml version="1.0" encoding="UTF-8"?><getBatchStatisticsResponse xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful.</text></message></messages><batch><batchId>24</batchId><settlementTimeUTC>2011-01-13T20:58:33Z</settlementTimeUTC><settlementTimeLocal>2011-01-13T12:58:33</settlementTimeLocal><settlementState>settledSuccessfully</settlementState><paymentMethod>creditCard</paymentMethod><statistics><statistic><accountType>Visa</accountType><chargeAmount>30.15</chargeAmount><chargeCount>7</chargeCount><refundAmount>0.00</refundAmount><refundCount>0</refundCount><voidCount>0</voidCount><declineCount>0</declineCount><errorCount>0</errorCount></statistic></statistics></batch></getBatchStatisticsResponse>';
    Map<String, String> headers = new Map<String, String> {
      'Content-Type' => 'text/xml'
    };
    AuthorizeNetServiceMock mockResponse = new AuthorizeNetServiceMock(200, 'Complete', responseString, headers);
    Test.setMock(HttpCalloutMock.class, mockResponse);

    Test.startTest();
    AuthorizeNetModels.getBatchStatisticsResponse response = ans.getBatchStatistics('123');
    Test.stopTest();
  }
}