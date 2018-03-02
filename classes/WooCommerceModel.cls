public without sharing class WooCommerceModel {
  public class WooCommercePayloadModel {
    public WooCommerceOrder order;
  }

  public class WooCommerceOrder {
    // public Integer customer_id;
    // public String customer_ip;
    public Boolean do_not_send_gifts;
    public DateTime completed_at;
    public DateTime created_at;
    public DateTime updated_at;
    public Decimal total;
    public Integer order_number;
    public List<WooCommerceLineItem> line_items;
    public String campaign_id;
    public String currency_code;
    public String shirt_size;
    public String status;
    public WooCommerceBillingAddress billing_address;
    public WooCommerceShippingAddress shipping_address;
    public WooCommerceCustomer customer;
  }

  public class WooCommerceLineItem {
    public Decimal price;
    public Decimal subtotal_tax;
    public Decimal subtotal;
    public Decimal total_tax;
    public Decimal total;
    public Integer id;
    public Integer product_id;
    public Integer quantity;
    public List<WooCommerceLineItemMetaData> meta;
    public Set<String> categories;
    public String campaign_id;
    public String color;
    public String gau_id;
    public String gau_name;
    public String membership_bundle_id;
    public String name;
    public String product_type;
    public String ticket_type;
    public String pa_size;
    public String sku;
    public String tax_class;
    public String years;
    public Integer ticket_weight;
    public String ticket_name;
  }

  public class WooCommerceLineItemMetaData {
    public String key;
    public String label;
    public String value;
  }

  public class WooCommerceCustomer {
    public String email;
    public String first_name;
    public String last_name;
    public String phone;
  }

  public class WooCommerceBillingAddress {
    public String first_name;
    public String last_name;
    public String company;
    public String address_1;
    public String address_2;
    public String city;
    public String state;
    public String postcode;
    public String country;
    public String email;
    public String phone;
  }

  public class WooCommerceShippingAddress {
    public String first_name;
    public String last_name;
    public String company;
    public String address_1;
    public String address_2;
    public String city;
    public String state;
    public String postcode;
    public String country;
    public String email;
    public String phone;
  }
}