@RestResource(urlMapping='/woocommerce/order')
global without sharing class WooCommerceOrderEndpoint {
  // Wordpress table query
  // select meta_id, meta_value from wp_commentmeta where meta_key = '_request_body' and meta_value like '%6280%'

  @HttpPost
  global static String handler() {

    if (RestContext.request.requestBody == null || String.isEmpty(RestContext.request.requestBody.toString())) {
      return 'No Data Found';
    }
    WooCommerceModel.WooCommercePayloadModel wcpm = (WooCommerceModel.WooCommercePayloadModel)JSON.deserialize(RestContext.request.requestBody.toString(), WooCommerceModel.WooCommercePayloadModel.class);
    if (!(wcpm.order.status == 'processing' || wcpm.order.status == 'completed')) {
      return 'Only Need Processing or Completed Orders';
    }
    if (wcpm.order.line_items == null) {
      return 'No line items';
    }

    List<WooCommerce_Serializer__c> wss = [Select id, Order_Number__c from WooCommerce_Serializer__c where Order_Number__c =: wcpm.order.order_number];
    if (wss.size() > 0) {
      WooCommerce_Serializer__c ws = wss[0];
      ws.Body__c = RestContext.request.requestBody.toString();
      ws.Status__c = 'Not Processed';
      update ws;
      return 'Order Number: ' + String.valueOf(ws.Order_Number__c) + ' Updated';
    }

    WooCommerce_Serializer__c ws = new WooCommerce_Serializer__c(
      Order_Number__c = wcpm.order.order_number,
      Body__c = RestContext.request.requestBody.toString(),
      Status__c = 'Not Processed'
      );

    String email;
    String firstName;
    String lastName;
    String phone;
    if (wcpm.order.customer != null && wcpm.order.customer.email != null) {
      email = wcpm.order.customer.email;
      firstName = wcpm.order.customer.first_name;
      lastName = wcpm.order.customer.last_name;
      phone = wcpm.order.customer.phone;
    } else {
      email = wcpm.order.billing_address.email;
      firstName = wcpm.order.billing_address.first_name;
      lastName = wcpm.order.billing_address.last_name;
      phone = wcpm.order.billing_address.phone;
    }

    // 1. Single Match
    // 2. Multiple Matches
    // 3. New Contact
    List<Contact> contactList = [SELECT Id, FirstName, LastName, AccountId FROM Contact WHERE Email = :email];
    if (contactList.size() == 1) {
      ws.Account__c = contactList[0].AccountId;
      ws.Contact__c = contactList[0].Id;
    } else if (contactList.size() > 1) {
      for (Contact con : contactList) {
        if (con.firstname != null && con.lastname != null &&
            firstName != null && lastName != null) {
          if ((con.firstname.toLowerCase()) == (firstName.toLowerCase()) &&
              (con.lastname.toLowerCase()) == (lastName.toLowerCase())) {
            ws.Account__c = con.AccountId;
            ws.Contact__c = con.Id;
            break;
          }
        }
      }
    }

    if (ws.Account__c == null) {
      Contact newCon = new Contact();
      newCon.Email = email;
      newCon.FirstName = Utils.capitalizeEachFirstLetter(firstName);
      newCon.LastName = Utils.capitalizeEachFirstLetter(lastName);
      newCon.Phone = phone;
      newCon.ownerId = '00536000001teKUAAY';
      newCon.MailingCity = Utils.capitalizeEachFirstLetter(wcpm.order.billing_address.city);
      if (wcpm.order.billing_address.country == 'US') {
        newCon.MailingCountry = 'United States';
      } else if (wcpm.order.billing_address.country == 'CA') {
        newCon.MailingCountry = 'Canada';
      } else {
        newCon.MailingCountry = wcpm.order.billing_address.country;
      }
      newCon.MailingPostalCode = Utils.capitalizeEachFirstLetter(wcpm.order.billing_address.postcode);
      newCon.MailingState = wcpm.order.billing_address.state;
      newCon.MailingStreet = Utils.capitalizeEachFirstLetter(wcpm.order.billing_address.address_1 + ' ' + wcpm.order.billing_address.address_2);
      insert newCon;
      contactList = [SELECT AccountId FROM Contact WHERE id =: newCon.id];
      ws.Account__c  = contactList[0].AccountId;
      ws.Contact__c = newCon.id;
    }
    insert ws;
    return 'Order Number: ' + String.valueOf(ws.Order_Number__c) + ' Created';
  }
}