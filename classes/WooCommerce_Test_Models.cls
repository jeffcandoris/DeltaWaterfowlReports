@isTest
public class WooCommerce_Test_Models {
  public Benefit__c testBenefit;
  public Campaign testCampaign;
  public Contact testContact;
  public Decimal donationTotalSum;
  public Decimal merchandiseTotalSum;
  public Decimal ticketTotalSum;
  public Id testAccountId;
  public List<WooCommerceModel.WooCommerceLineItem> testDonationLineItems;
  public List<WooCommerceModel.WooCommerceLineItem> testMerchandiseLineItems;
  public List<WooCommerceModel.WooCommerceLineItem> testTicketLineItems;
  public Membership_Bundle__c testMembershipBundle;
  public Opportunity oppForDonation;
  public Opportunity oppForMembership;
  public Opportunity oppForMerchandise;
  public Opportunity oppForTicket;
  public OpportunityLineItem merchandiseOppLineItem;
  public OpportunityLineItem merchandiseOppLineItem2;
  public OpportunityLineItem ticketOppLineItem;
  public OpportunityLineItem ticketOppLineItem2;
  public npsp__General_Accounting_Unit__c gau;
  public npsp__General_Accounting_Unit__c gau2;
  public PricebookEntry testPbe;
  public Product2 testProduct;
  public Profile nonMemberProfile;
  public Profile memberProfile;
  public String testOrder;
  public String testCADOrder;
  public String testOrderFailed;
  public String testOrderNoCustomer;
  public Transaction__c testTransaction;
  public Webstore__c testWebstoreMerchandise;
  public WooCommerceModel.WooCommercePayloadModel testWcpm;
  public WooCommerceModel.WooCommerceLineItem testMerchandiseLi;
  public WooCommerceModel.WooCommerceLineItem testAnotherMerchandiseLi;
  public WooCommerceModel.WooCommerceLineItem testTicketLi;
  public WooCommerceModel.WooCommerceLineItem testAnotherTicketLi;
  public WooCommerceModel.WooCommerceLineItem testMembershipLi;
  public WooCommerceModel.WooCommerceLineItem testDonationLi;
  public WooCommerceModel.WooCommerceLineItem testAnotherDonationLi;

  public WooCommerce_Test_Models() {
    Benefit__c b1 = new Benefit__c();
    b1.name = 'Bundle Benefit 1';
    b1.Count__c = 5;
    insert b1;

    Benefit__c b2 = new Benefit__c();
    b2.name = 'Campaign Benefit 1';
    b2.Count__c = 5;
    insert b2;

    Membership_Bundle__c mb1 = new Membership_Bundle__c();
    mb1.name = 'Bundle 1';
    mb1.Membership_Level__c = 'Youth';
    insert mb1;

    testCampaign = new Campaign();
    testCampaign.Name = 'TestCampaign';
    insert testCampaign;

    Membership_Bundle_Benefit__c mbb1 = new Membership_Bundle_Benefit__c();
    mbb1.Membership_Bundle__c = mb1.id;
    mbb1.Benefit__c = b1.id;
    insert mbb1;

    Campaign_Benefit__c cb1 = new Campaign_Benefit__c();
    cb1.Campaign__c = testCampaign.id;
    cb1.Benefit__c = b1.id;
    insert cb1;

    gau = new npsp__General_Accounting_Unit__c();
    insert gau;

    gau2 = new npsp__General_Accounting_Unit__c();
    insert gau2;

    testMembershipBundle = new Membership_Bundle__c();
    testMembershipBundle.Membership_Level__c = 'President';
    testMembershipBundle.Name = 'testMembershipBundle';
    insert testMembershipBundle;
    testOrder = '{"order":{"id":1,"order_number":1,"order_key":"wc_order_57ead509d6361","created_at":"2016-09-27T20:22:35Z","updated_at":"2016-09-27T20:22:35Z","completed_at":"2016-09-27T19:22:35Z","status":"processing","currency_code":"USD","total":"275.98","subtotal":"275.98","total_line_items_quantity":9,"total_tax":"0.00","total_shipping":"0.00","cart_tax":"0.00","shipping_tax":"0.00","total_discount":"0.00","shipping_methods":"","payment_details":{"method_id":"authorize_net_cim_credit_card","method_title":"Credit Card","paid":true},"billing_address":{"first_name":"Test","last_name":"Test","company":"","address_1":"1 Main St","address_2":"","city":"Test","state":"PA","postcode":"17003","country":"US","email":"test@test.com","phone":"21321321321"},"shipping_address":{"first_name":"Test","last_name":"Test","company":"","address_1":"1 Main St","address_2":"","city":"Test","state":"PA","postcode":"17003","country":"US"},"note":"","customer_ip":"96.83.134.45","customer_user_agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36","customer_id":3,"view_order_url":"http://deltawaterfowl.wpengine.com/my-account/view-order/1","line_items":[{"id":99,"subtotal":"12.00","subtotal_tax":"0.00","total":"12.00","total_tax":"0.00","price":"12.00","quantity":1,"tax_class":null,"name":"Test Tshirt","product_id":10,"sku":"0123","meta":[{"key":"pa_size","label":"Size","value":"M"},{"key":"color","label":"Color","value":"Green"}],"pa_size":"M","color":"Green","product_type":"merchandise"},{"id":100,"subtotal":"33.98","subtotal_tax":"0.00","total":"33.98","total_tax":"0.00","price":"16.99","quantity":2,"tax_class":null,"name":"Mesh Trucker Hat","product_id":940,"sku":"OFAO","meta":[],"product_type":"merchandise"},{"id":101,"subtotal":"60.00","subtotal_tax":"0.00","total":"60.00","total_tax":"0.00","price":"20.00","quantity":2,"tax_class":null,"name":"Test Raffle","product_id":1205,"sku":"","meta":[{"key":"ticket_name","label":"Ticket Name","value":"3 for $20"}],"product_type":"ticket","campaign_id":"'+ testCampaign.Id + '","ticket_weight":"3","ticket_name":"3 for $20"},{"id":102,"subtotal":"40.00","subtotal_tax":"0.00","total":"40.00","total_tax":"0.00","price":"20.00","quantity":2,"tax_class":null,"name":"Test Event","product_id":1206,"sku":"","meta":[{"key":"ticket_name","label":"Ticket Name","value":"Couple"}],"product_type":"ticket","campaign_id":"'+ testCampaign.Id + '","ticket_weight":"1","ticket_name":"Couple"},{"id":103,"subtotal":"20.00","subtotal_tax":"0.00","total":"20.00","total_tax":"0.00","price":"20.00","quantity":2,"tax_class":null,"name":"Membership &rarr; Youth","product_id":1113,"sku":"","meta":[],"membership_bundle_id":"' + testMembershipBundle.id + '","product_type":"membership"},{"id":104,"subtotal":"50.00","subtotal_tax":"0.00","total":"50.00","total_tax":"0.00","price":"50.00","quantity":1,"tax_class":"zero-rate","name":"Breeding Duck Habitat Donation","product_id":998,"sku":"","meta":[],"gau_id":"' + gau.id +  '","product_type":"donation"},{"id":105,"subtotal":"60.00","subtotal_tax":"0.00","total":"60.00","total_tax":"0.00","price":"60.00","quantity":1,"tax_class":"zero-rate","name":"Hen House Donation","product_id":993,"sku":"","meta":[],"membership_bundle_id":"","gau_id":"' + gau2.id + '","product_type":"donation"}],"shipping_lines":[],"tax_lines":[],"fee_lines":[],"coupon_lines":[],"is_vat_exempt":false,"customer":{"id":3,"created_at":"2016-08-31T20:14:30Z","last_update":"2016-09-27T20:22:39Z","email":"test@test.com","first_name":"Test","last_name":"Admin","username":"test","role":"administrator","last_order_id":"1","last_order_date":"2016-09-27T20:22:35Z","orders_count":13,"total_spent":"2457.96","avatar_url":"http://0.gravatar.com/avatar/?s=96","billing_address":{"first_name":"Test","last_name":"Test","company":"","address_1":"1 Main St","address_2":"","city":"Test","state":"PA","postcode":"17003","country":"US","email":"test@test.com","phone":"21321321321"},"shipping_address":{"first_name":"","last_name":"","company":"","address_1":"","address_2":"","city":"","state":"","postcode":"","country":""}}}}';
    testCADOrder = '{"order":{"id":1,"order_number":1,"order_key":"wc_order_57ead509d6361","created_at":"2016-09-27T20:22:35Z","updated_at":"2016-09-27T20:22:35Z","completed_at":"2016-09-27T19:22:35Z","status":"processing","currency_code":"CAD","total":"275.98","subtotal":"275.98","total_line_items_quantity":9,"total_tax":"0.00","total_shipping":"0.00","cart_tax":"0.00","shipping_tax":"0.00","total_discount":"0.00","shipping_methods":"","payment_details":{"method_id":"authorize_net_cim_credit_card","method_title":"Credit Card","paid":true},"billing_address":{"first_name":"Test","last_name":"Test","company":"","address_1":"1 Main St","address_2":"","city":"Test","state":"PA","postcode":"17003","country":"US","email":"test@test.com","phone":"21321321321"},"shipping_address":{"first_name":"Test","last_name":"Test","company":"","address_1":"1 Main St","address_2":"","city":"Test","state":"PA","postcode":"17003","country":"US"},"note":"","customer_ip":"96.83.134.45","customer_user_agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36","customer_id":3,"view_order_url":"http://deltawaterfowl.wpengine.com/my-account/view-order/1","line_items":[{"id":103,"subtotal":"20.00","subtotal_tax":"0.00","total":"20.00","total_tax":"0.00","price":"20.00","quantity":1,"tax_class":null,"name":"Membership &rarr; Youth","product_id":1113,"sku":"","meta":[],"membership_bundle_id":"' + testMembershipBundle.id + '","product_type":"membership"},{"id":104,"subtotal":"50.00","subtotal_tax":"0.00","total":"50.00","total_tax":"0.00","price":"50.00","quantity":1,"tax_class":"zero-rate","name":"Breeding Duck Habitat Donation","product_id":998,"sku":"","meta":[],"gau_id":"' + gau.id +  '","product_type":"donation"},{"id":105,"subtotal":"60.00","subtotal_tax":"0.00","total":"60.00","total_tax":"0.00","price":"60.00","quantity":1,"tax_class":"zero-rate","name":"Hen House Donation","product_id":993,"sku":"","meta":[],"membership_bundle_id":"","gau_id":"' + gau2.id + '","product_type":"donation"}],"shipping_lines":[],"tax_lines":[],"fee_lines":[],"coupon_lines":[],"is_vat_exempt":false,"customer":{"id":3,"created_at":"2016-08-31T20:14:30Z","last_update":"2016-09-27T20:22:39Z","email":"test@test.com","first_name":"Test","last_name":"Admin","username":"test","role":"administrator","last_order_id":"1","last_order_date":"2016-09-27T20:22:35Z","orders_count":13,"total_spent":"2457.96","avatar_url":"http://0.gravatar.com/avatar/?s=96","billing_address":{"first_name":"Test","last_name":"Test","company":"","address_1":"1 Main St","address_2":"","city":"Test","state":"PA","postcode":"17003","country":"US","email":"test@test.com","phone":"21321321321"},"shipping_address":{"first_name":"","last_name":"","company":"","address_1":"","address_2":"","city":"","state":"","postcode":"","country":""}}}}';
    testOrderNoCustomer = '{"order":{"id":1,"order_number":1,"order_key":"wc_order_57ead509d6361","created_at":"2016-09-27T20:22:35Z","updated_at":"2016-09-27T20:22:35Z","completed_at":"2016-09-27T19:22:35Z","status":"processing","currency_code":"USD","total":"275.98","subtotal":"275.98","total_line_items_quantity":9,"total_tax":"0.00","total_shipping":"0.00","cart_tax":"0.00","shipping_tax":"0.00","total_discount":"0.00","shipping_methods":"","payment_details":{"method_id":"authorize_net_cim_credit_card","method_title":"Credit Card","paid":true},"billing_address":{"first_name":"Test","last_name":"Test","company":"","address_1":"1 Main St","address_2":"","city":"Test","state":"PA","postcode":"17003","country":"US","email":"test@test.com","phone":"21321321321"},"shipping_address":{"first_name":"Test","last_name":"Test","company":"","address_1":"1 Main St","address_2":"","city":"Test","state":"PA","postcode":"17003","country":"US"},"note":"","customer_ip":"96.83.134.45","customer_user_agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36","customer_id":3,"view_order_url":"http://deltawaterfowl.wpengine.com/my-account/view-order/1","line_items":[{"id":99,"subtotal":"12.00","subtotal_tax":"0.00","total":"12.00","total_tax":"0.00","price":"12.00","quantity":1,"tax_class":null,"name":"Test Tshirt","product_id":10,"sku":"0123","meta":[{"key":"pa_size","label":"Size","value":"M"},{"key":"color","label":"Color","value":"Green"}],"pa_size":"M","color":"Green","product_type":"merchandise"},{"id":100,"subtotal":"33.98","subtotal_tax":"0.00","total":"33.98","total_tax":"0.00","price":"16.99","quantity":2,"tax_class":null,"name":"Mesh Trucker Hat","product_id":940,"sku":"OFAO","meta":[],"product_type":"merchandise"},{"id":101,"subtotal":"60.00","subtotal_tax":"0.00","total":"60.00","total_tax":"0.00","price":"20.00","quantity":2,"tax_class":null,"name":"Test Raffle","product_id":1205,"sku":"","meta":[{"key":"ticket_name","label":"Ticket Name","value":"3 for $20"}],"product_type":"ticket","campaign_id":"'+ testCampaign.Id + '","ticket_weight":"3","ticket_name":"3 for $20"},{"id":102,"subtotal":"40.00","subtotal_tax":"0.00","total":"40.00","total_tax":"0.00","price":"20.00","quantity":2,"tax_class":null,"name":"Test Event","product_id":1206,"sku":"","meta":[{"key":"ticket_name","label":"Ticket Name","value":"Couple"}],"product_type":"ticket","campaign_id":"'+ testCampaign.Id + '","ticket_weight":"1","ticket_name":"Couple"},{"id":103,"subtotal":"20.00","subtotal_tax":"0.00","total":"20.00","total_tax":"0.00","price":"20.00","quantity":1,"tax_class":null,"name":"Membership &rarr; Youth","product_id":1113,"sku":"","meta":[],"membership_bundle_id":"' + testMembershipBundle.id + '","product_type":"membership"},{"id":104,"subtotal":"50.00","subtotal_tax":"0.00","total":"50.00","total_tax":"0.00","price":"50.00","quantity":1,"tax_class":"zero-rate","name":"Breeding Duck Habitat Donation","product_id":998,"sku":"","meta":[],"gau_id":"' + gau.id +  '","product_type":"donation"},{"id":105,"subtotal":"60.00","subtotal_tax":"0.00","total":"60.00","total_tax":"0.00","price":"60.00","quantity":1,"tax_class":"zero-rate","name":"Hen House Donation","product_id":993,"sku":"","meta":[],"membership_bundle_id":"","gau_id":"' + gau2.id + '","product_type":"donation"}],"shipping_lines":[],"tax_lines":[],"fee_lines":[],"coupon_lines":[],"is_vat_exempt":false}}';
    testOrderFailed = '{"order":{"id":1,"order_number":1,"order_key":"wc_order_57ead509d6361","created_at":"2016-09-27T20:22:35Z","updated_at":"2016-09-27T20:22:35Z","completed_at":"2016-09-27T19:22:35Z","status":"failed","currency_code":"USD","total":"275.98","subtotal":"275.98","total_line_items_quantity":9,"total_tax":"0.00","total_shipping":"0.00","cart_tax":"0.00","shipping_tax":"0.00","total_discount":"0.00","shipping_methods":"","payment_details":{"method_id":"authorize_net_cim_credit_card","method_title":"Credit Card","paid":true},"billing_address":{"first_name":"Test","last_name":"Test","company":"","address_1":"1 Main St","address_2":"","city":"Test","state":"PA","postcode":"17003","country":"US","email":"test@test.com","phone":"21321321321"},"shipping_address":{"first_name":"Test","last_name":"Test","company":"","address_1":"1 Main St","address_2":"","city":"Test","state":"PA","postcode":"17003","country":"US"},"note":"","customer_ip":"96.83.134.45","customer_user_agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36","customer_id":3,"view_order_url":"http://deltawaterfowl.wpengine.com/my-account/view-order/1","line_items":[{"id":99,"subtotal":"12.00","subtotal_tax":"0.00","total":"12.00","total_tax":"0.00","price":"12.00","quantity":1,"tax_class":null,"name":"Test Tshirt","product_id":10,"sku":"0123","meta":[{"key":"pa_size","label":"Size","value":"M"},{"key":"color","label":"Color","value":"Green"}],"pa_size":"M","color":"Green","product_type":"merchandise"},{"id":100,"subtotal":"33.98","subtotal_tax":"0.00","total":"33.98","total_tax":"0.00","price":"16.99","quantity":2,"tax_class":null,"name":"Mesh Trucker Hat","product_id":940,"sku":"OFAO","meta":[],"product_type":"merchandise"},{"id":101,"subtotal":"60.00","subtotal_tax":"0.00","total":"60.00","total_tax":"0.00","price":"20.00","quantity":2,"tax_class":null,"name":"Test Raffle","product_id":1205,"sku":"","meta":[{"key":"ticket_name","label":"Ticket Name","value":"3 for $20"}],"product_type":"ticket","campaign_id":"'+ testCampaign.Id + '","ticket_weight":"3","ticket_name":"3 for $20"},{"id":102,"subtotal":"40.00","subtotal_tax":"0.00","total":"40.00","total_tax":"0.00","price":"20.00","quantity":2,"tax_class":null,"name":"Test Event","product_id":1206,"sku":"","meta":[{"key":"ticket_name","label":"Ticket Name","value":"Couple"}],"product_type":"ticket","campaign_id":"'+ testCampaign.Id + '","ticket_weight":"1","ticket_name":"Couple"},{"id":103,"subtotal":"20.00","subtotal_tax":"0.00","total":"20.00","total_tax":"0.00","price":"20.00","quantity":1,"tax_class":null,"name":"Membership &rarr; Youth","product_id":1113,"sku":"","meta":[],"membership_bundle_id":"' + testMembershipBundle.id + '","product_type":"membership"},{"id":104,"subtotal":"50.00","subtotal_tax":"0.00","total":"50.00","total_tax":"0.00","price":"50.00","quantity":1,"tax_class":"zero-rate","name":"Breeding Duck Habitat Donation","product_id":998,"sku":"","meta":[],"gau_id":"' + gau.id +  '","product_type":"donation"},{"id":105,"subtotal":"60.00","subtotal_tax":"0.00","total":"60.00","total_tax":"0.00","price":"60.00","quantity":1,"tax_class":"zero-rate","name":"Hen House Donation","product_id":993,"sku":"","meta":[],"membership_bundle_id":"","gau_id":"' + gau2.id + '","product_type":"donation"}],"shipping_lines":[],"tax_lines":[],"fee_lines":[],"coupon_lines":[],"is_vat_exempt":false}}';
    testWcpm = (WooCommerceModel.WooCommercePayloadModel)JSON.deserialize(testOrder, WooCommerceModel.WooCommercePayloadModel.class);
    testMerchandiseLi = testWcpm.order.line_items[0];
    testAnotherMerchandiseLi = testWcpm.order.line_items[1];
    testTicketLi = testWcpm.order.line_items[2];
    testAnotherTicketLi = testWcpm.order.line_items[3];
    testMembershipLi = testWcpm.order.line_items[4];
    testDonationLi = testWcpm.order.line_items[5];
    testAnotherDonationLi = testWcpm.order.line_items[6];
    testContact = new Contact();
    testContact.FirstName = testWcpm.order.customer.first_name;
    testContact.LastName = testWcpm.order.customer.last_name;
    testContact.Email = testWcpm.order.customer.email;

    testDonationLineItems = new List<WooCommerceModel.WooCommerceLineItem>();
    testDonationLineItems.add(testDonationLi);
    testDonationLineItems.add(testAnotherDonationLi);
    donationTotalSum = testDonationLi.total + testAnotherDonationLi.total;

    testMerchandiseLineItems = new List<WooCommerceModel.WooCommerceLineItem>();
    testMerchandiseLineItems.add(testMerchandiseLi);
    testMerchandiseLineItems.add(testAnotherMerchandiseLi);
    merchandiseTotalSum = testMerchandiseLi.total + testAnotherMerchandiseLi.total;

    testTicketLineItems = new List<WooCommerceModel.WooCommerceLineItem>();
    testTicketLineItems.add(testTicketLi);
    testTicketLineItems.add(testAnotherTicketLi);
    ticketTotalSum = testTicketLi.total + testAnotherTicketLi.total;

    testTransaction = new Transaction__c();
    testTransaction.Payment_Method__c = 'Credit Card';

    oppForDonation = new Opportunity();
    oppForDonation.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
    oppForDonation.Amount = donationTotalSum;
    oppForDonation.CampaignId = testWcpm.order.campaign_id;
    oppForDonation.CloseDate = date.newinstance(2016, 9, 27);
    oppForDonation.Name = 'Web Donation';
    oppForDonation.Payment_Method__c = 'Credit Card';
    oppForDonation.StageName = 'Closed Won - 100%';

    oppForMembership = new Opportunity();
    oppForMembership.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId();
    oppForMembership.Amount = testMembershipLi.total;
    oppForMembership.CampaignId = testWcpm.order.campaign_id;
    oppForMembership.CloseDate = date.newinstance(2016, 9, 27);
    oppForMembership.Name = 'Web Membership';
    oppForMembership.Payment_Method__c = 'Credit Card';
    oppForMembership.StageName = 'Closed Won - 100%';

    oppForMerchandise = new Opportunity();
    oppForMerchandise.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Merchandise').getRecordTypeId();
    oppForMerchandise.Amount = merchandiseTotalSum;
    oppForMerchandise.CampaignId = testWcpm.order.campaign_id;
    oppForMerchandise.Name = 'Web Merchandise';
    oppForMerchandise.CloseDate = date.newinstance(2016, 9, 27);
    oppForMerchandise.Payment_Method__c = 'Credit Card';
    oppForMerchandise.StageName = 'Closed Won - 100%';

    oppForTicket = new Opportunity();
    oppForTicket.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Ticket Order').getRecordTypeId();
    oppForTicket.Amount = ticketTotalSum;
    oppForTicket.CampaignId = testWcpm.order.campaign_id;
    oppForTicket.Name = 'Web Ticket';
    oppForTicket.CloseDate = date.newinstance(2016, 9, 27);
    oppForTicket.Payment_Method__c = 'Credit Card';
    oppForTicket.StageName = 'Closed Won - 100%';

    testProduct = new Product2();
    testProduct.Description = 'Product Name';
    testProduct.IsActive = true;
    testProduct.Name = 'Generic Product';
    testProduct.ProductCode = '1';
    insert testProduct;

    testPbe = new PricebookEntry();
    testPbe.IsActive = true;
    testpbe.Pricebook2Id = Test.getStandardPricebookId();
    testpbe.Product2Id = testProduct.Id;
    testpbe.UnitPrice = 0;
    insert testPbe;

    testBenefit = new Benefit__c();
    testBenefit.Name = 'Benefit 1';
    testBenefit.Count__c = 1;
    testBenefit.Total_Value__c = 1;
    testBenefit.Unit_Cost__c = 1;
    insert testBenefit;

    nonMemberProfile = [SELECT Id FROM Profile WHERE Name='Delta Non-Member'][0];
    memberProfile = [SELECT Id FROM Profile WHERE Name='Delta Member'][0];

    testWebstoreMerchandise = new Webstore__c();
    testWebstoreMerchandise.Name = 'WooCommerce';
    testWebstoreMerchandise.Web_Merchandise_Pricebook_ID__c = testPbe.Id;
    testWebstoreMerchandise.Web_Ticket_Pricebook_ID_CAD__c = testPbe.Id;
    testWebstoreMerchandise.Web_Merchandise_Pricebook_ID_CAD__c = testPbe.Id;
    testWebstoreMerchandise.Web_Ticket_Pricebook_ID__c = testPbe.Id;
    testWebstoreMerchandise.Delta_Member_Profile_ID__c = memberProfile.id;
    testWebstoreMerchandise.Delta_Non_Member_Profile_ID__c = nonMemberProfile.id;
    testWebstoreMerchandise.X3_Year_Benefit_Id__c = testBenefit.id;
    insert testWebstoreMerchandise;

    merchandiseOppLineItem = new OpportunityLineItem();
    merchandiseOppLineItem.PricebookEntryId = testWebstoreMerchandise.Web_Merchandise_Pricebook_ID__c;
    merchandiseOppLineItem.Quantity = testMerchandiseLi.quantity;
    merchandiseOppLineItem.TotalPrice = testMerchandiseLi.total;
    merchandiseOppLineItem.Description = testMerchandiseLi.name;
    merchandiseOppLineItem.Color__c = testMerchandiseLi.color;
    merchandiseOppLineItem.Size__c = testMerchandiseLi.pa_size;

    merchandiseOppLineItem2 = new OpportunityLineItem();
    merchandiseOppLineItem2.PricebookEntryId = testWebstoreMerchandise.Web_Merchandise_Pricebook_ID__c;
    merchandiseOppLineItem2.Quantity = testAnotherMerchandiseLi.quantity;
    merchandiseOppLineItem2.TotalPrice = testAnotherMerchandiseLi.total;
    merchandiseOppLineItem2.Description = testAnotherMerchandiseLi.name;
    merchandiseOppLineItem2.Color__c = testAnotherMerchandiseLi.color;
    merchandiseOppLineItem2.Size__c = testAnotherMerchandiseLi.pa_size;

    ticketOppLineItem = new OpportunityLineItem();
    ticketOppLineItem.PricebookEntryId = testWebstoreMerchandise.Web_Ticket_Pricebook_ID__c;
    ticketOppLineItem.Quantity = testTicketLi.quantity;
    ticketOppLineItem.TotalPrice = testTicketLi.total;
    ticketOppLineItem.Description = testTicketLi.name + ' (' + testTicketLi.ticket_name + ')';
    ticketOppLineItem.Event__c = testTicketLi.campaign_id;

    ticketOppLineItem2 = new OpportunityLineItem();
    ticketOppLineItem2.PricebookEntryId = testWebstoreMerchandise.Web_Ticket_Pricebook_ID__c;
    ticketOppLineItem2.Quantity = testAnotherTicketLi.quantity;
    ticketOppLineItem2.TotalPrice = testAnotherTicketLi.total;
    ticketOppLineItem2.Description = testAnotherTicketLi.name + ' (' + testAnotherTicketLI.ticket_name + ')';
    ticketOppLineItem2.Event__c = testAnotherTicketLi.campaign_id;
  }
}