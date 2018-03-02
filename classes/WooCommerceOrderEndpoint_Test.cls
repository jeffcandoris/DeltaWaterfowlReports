@isTest
global class WooCommerceOrderEndpoint_Test {

  // Test if a new Contact is created at the beginning of handler();
  @isTest
  static void testIfContactIsCreated() {
    WooCommerce_Test_Models wctm = new WooCommerce_Test_Models();

    RestRequest req = new RestRequest();
    req.requestURI = 'https://kendo-deltawaterfowl-kendo.cs26.force.com/services/apexrest/woocommerce/order';
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.request.requestBody = Blob.valueof(wctm.testOrder);
    Test.StartTest();
    String result = WooCommerceOrderEndpoint.handler();
    Test.StopTest();
    List<WooCommerce_Serializer__c> wss = [Select Id, Body__c, Account__c, Contact__c from WooCommerce_Serializer__c where Order_Number__c = 1];
    System.System.assertEquals(1, wss.size());
    Contact selectedContact = [SELECT FirstName, LastName FROM Contact WHERE Email = :wctm.testContact.Email];
    System.assertEquals(wctm.testContact.FirstName, selectedContact.FirstName);
    System.assertEquals(wctm.testContact.LastName, selectedContact.LastName);
    System.assertEquals('Order Number: 1 Created', result);
  }

  // Test if a new Contact is created from billing_address at the beginning of handler();
  @isTest
  static void testIfContactIsCreatedFromBilling() {
    WooCommerce_Test_Models wctm = new WooCommerce_Test_Models();

    RestRequest req = new RestRequest();
    req.requestURI = 'https://kendo-deltawaterfowl-kendo.cs26.force.com/services/apexrest/woocommerce/order';
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.request.requestBody = Blob.valueof(wctm.testOrderNoCustomer);
    Test.StartTest();
    String result = WooCommerceOrderEndpoint.handler();
    Test.StopTest();
    List<WooCommerce_Serializer__c> wss = [Select Id, Body__c, Account__c, Contact__c from WooCommerce_Serializer__c where Order_Number__c = 1];
    System.System.assertEquals(1, wss.size());
    Contact selectedContact = [SELECT FirstName, LastName FROM Contact WHERE Email = :wctm.testContact.Email];
    System.assertEquals('Test', selectedContact.FirstName);
    System.assertEquals('Test', selectedContact.LastName);
    System.assertEquals('Order Number: 1 Created', result);
  }

  @isTest
  static void testNewOrderWithNoData() {

    Test.StartTest();
    // testOrder String and JSON not created to expect 'No Data Found' returned from handler();
    RestRequest req = new RestRequest();
    req.requestURI = 'https://kendo-deltawaterfowl-kendo.cs6.force.com/services/apexrest/woocommerce/order';
    req.httpMethod = 'POST';
    RestContext.request = req;
    String result = WooCommerceOrderEndpoint.handler();
    Test.StopTest();
    System.assertEquals('No Data Found', result);
  }

  @isTest
  static void testNewOrderWithNoLineItems() {
    // Empty line items
    String testOrder = '{"order":{"id":1,"order_number":1,"order_key":"wc_order_57ead509d6361","created_at":"2016-09-27T20:22:35Z","updated_at":"2016-09-27T20:22:35Z","completed_at":"2016-09-27T19:22:35Z","status":"processing","currency":"USD","total":"0.00","subtotal":"0.00","total_line_items_quantity":0,"total_tax":"0.00","total_shipping":"0.00","cart_tax":"0.00","shipping_tax":"0.00","total_discount":"0.00","shipping_methods":"","payment_details":{"method_id":"authorize_net_cim_credit_card","method_title":"Credit Card","paid":true},"billing_address":{"first_name":"Test","last_name":"Test","company":"","address_1":"1 Main St","address_2":"","city":"Test","state":"PA","postcode":"17003","country":"US","email":"test@test.com","phone":"21321321321"},"shipping_address":{"first_name":"Test","last_name":"Test","company":"","address_1":"1 Main St","address_2":"","city":"Test","state":"PA","postcode":"17003","country":"US"},"note":"","customer_ip":"96.83.134.45","customer_user_agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36","customer_id":3,"view_order_url":"http://deltawaterfowl.wpengine.com/my-account/view-order/1","shipping_lines":[],"tax_lines":[],"fee_lines":[],"coupon_lines":[],"is_vat_exempt":false,"customer":{"id":3,"created_at":"2016-08-31T20:14:30Z","last_update":"2016-09-27T20:22:39Z","email":"test@test.com","first_name":"Test","last_name":"Admin","username":"test","role":"administrator","last_order_id":"1","last_order_date":"2016-09-27T20:22:35Z","orders_count":13,"total_spent":"2457.96","avatar_url":"http://0.gravatar.com/avatar/?s=96","billing_address":{"first_name":"Test","last_name":"Test","company":"","address_1":"1 Main St","address_2":"","city":"Test","state":"PA","postcode":"17003","country":"US","email":"test@test.com","phone":"21321321321"},"shipping_address":{"first_name":"","last_name":"","company":"","address_1":"","address_2":"","city":"","state":"","postcode":"","country":""}}}}';
    WooCommerceModel.WooCommercePayloadModel wcpmTest = (WooCommerceModel.WooCommercePayloadModel)JSON.deserialize(testOrder, WooCommerceModel.WooCommercePayloadModel.class);
    RestRequest req = new RestRequest();
    req.requestURI = 'https://kendo-deltawaterfowl-kendo.cs26.force.com/services/apexrest/woocommerce/order';
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.request.requestBody = Blob.valueof(testOrder);
    Test.StartTest();
    String result = WooCommerceOrderEndpoint.handler();
    Test.StopTest();
    System.assertEquals('No line items', result);
  }

  @isTest
  static void testUpdateOrder() {
    WooCommerce_Test_Models wctm = new WooCommerce_Test_Models();
    RestRequest req = new RestRequest();
    req.requestURI = 'https://kendo-deltawaterfowl-kendo.cs26.force.com/services/apexrest/woocommerce/order';
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.request.requestBody = Blob.valueof(wctm.testOrder);
    WooCommerceOrderEndpoint.handler();
    Test.StartTest();
    String result = WooCommerceOrderEndpoint.handler();
    Test.StopTest();
    List<WooCommerce_Serializer__c> wss = [Select Id, Body__c, Account__c, Contact__c from WooCommerce_Serializer__c where Order_Number__c = 1];
    System.System.assertEquals(1, wss.size());
    System.assertEquals('Order Number: 1 Updated', result);
  }
}