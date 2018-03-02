public class AuthorizeNetService {
  private AuthorizeNetModels.merchantAuthenticationType merchantAuthentication;
  private String url;

  public AuthorizeNetService(String apiLoginId, String transactionKey, Boolean sandbox) {
    this.merchantAuthentication = new AuthorizeNetModels.merchantAuthenticationType(apiLoginId, transactionKey);
    this.url = 'https://api' + (sandbox ? 'test' : '') + '.authorize.net/xml/v1/request.api';
  }

  private HttpResponse sendRequest(String body) {
    HttpRequest req = new HttpRequest();
    req.setBody(body);
    req.setEndpoint(this.url);
    req.setHeader('Content-Type', 'text/xml');
    req.setMethod('POST');
    req.setTimeout(30000);
    Http http = new Http();
    return http.send(req);
  }

  // public String createTransaction(AuthorizeNetModels.transactionRequestType tr, String refId) {
  //   return new AuthorizeNetModels.createTransactionRequest(this.merchantAuthentication, refId, tr).toXML();
  // }

  public AuthorizeNetModels.createTransactionResponse createTransaction(AuthorizeNetModels.transactionRequestType tr, String refId) {
    System.debug(new AuthorizeNetModels.createTransactionRequest(this.merchantAuthentication, refId, tr).toXML());
    HttpResponse res = sendRequest(new AuthorizeNetModels.createTransactionRequest(this.merchantAuthentication, refId, tr).toXML());
    return new AuthorizeNetModels.createTransactionResponse(res);
  }

  public AuthorizeNetModels.ARBGetSubscriptionResponse getSubscription(String subscriptionId, String refId) {
    HttpResponse res = sendRequest(new AuthorizeNetModels.ARBGetSubscriptionRequest(this.merchantAuthentication, refId, subscriptionId).toXML());
    return new AuthorizeNetModels.ARBGetSubscriptionResponse(res);
  }

  public AuthorizeNetModels.ARBGetSubscriptionStatusResponse getSubscriptionStatus(String subscriptionId, String refId) {
    HttpResponse res = sendRequest(new AuthorizeNetModels.ARBGetSubscriptionStatusRequest(this.merchantAuthentication, refId, subscriptionId).toXML());
    return new AuthorizeNetModels.ARBGetSubscriptionStatusResponse(res);
  }

  public AuthorizeNetModels.ARBCreateSubscriptionResponse createSubscription(AuthorizeNetModels.ARBSubscriptionType sub, String refId) {
    HttpResponse res = sendRequest(new AuthorizeNetModels.ARBCreateSubscriptionRequest(this.merchantAuthentication, refId, sub).toXML());
    return new AuthorizeNetModels.ARBCreateSubscriptionResponse(res);
  }

  public AuthorizeNetModels.ARBUpdateSubscriptionResponse updateSubscription(AuthorizeNetModels.ARBSubscriptionType sub, String subscriptionId, String refId) {
    HttpResponse res = sendRequest(new AuthorizeNetModels.ARBUpdateSubscriptionRequest(this.merchantAuthentication, refId, subscriptionId, sub).toXML());
    return new AuthorizeNetModels.ARBUpdateSubscriptionResponse(res);
  }

  public AuthorizeNetModels.ARBCancelSubscriptionResponse cancelSubscription(String subscriptionId, String refId) {
    HttpResponse res = sendRequest(new AuthorizeNetModels.ARBCancelSubscriptionRequest(this.merchantAuthentication, refId, subscriptionId).toXML());
    return new AuthorizeNetModels.ARBCancelSubscriptionResponse(res);
  }

  public AuthorizeNetModels.getSettledBatchListResponse getSettledBatchList(Datetime firstSettlementDate, Datetime lastSettlementDate, Boolean includeStatistics, String refId) {
    String firstSettlementDateStr = firstSettlementDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    String lastSettlementDateStr = lastSettlementDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    HttpResponse res = sendRequest(new AuthorizeNetModels.getSettledBatchListRequest(this.merchantAuthentication, refId, firstSettlementDateStr, lastSettlementDateStr, includeStatistics).toXML());
    return new AuthorizeNetModels.getSettledBatchListResponse(res);
  }

  public AuthorizeNetModels.getUnsettledTransactionListResponse getUnsettledTransactionList() {
    HttpResponse res = sendRequest(new AuthorizeNetModels.getUnsettledTransactionListRequest(this.merchantAuthentication).toXML());
    return new AuthorizeNetModels.getUnsettledTransactionListResponse(res);
  }

  public AuthorizeNetModels.getTransactionListResponse getTransactionList(String batchId, String refId) {
    HttpResponse res = sendRequest(new AuthorizeNetModels.getTransactionListRequest(this.merchantAuthentication, refId, batchId).toXML());
    return new AuthorizeNetModels.getTransactionListResponse(res);
  }

  public AuthorizeNetModels.getTransactionDetailsResponse getTransactionDetails(String transId, String refId) {
    HttpResponse res = sendRequest(new AuthorizeNetModels.getTransactionDetailsRequest(this.merchantAuthentication, refId, transId).toXML());
    return new AuthorizeNetModels.getTransactionDetailsResponse(res);
  }

  public AuthorizeNetModels.getBatchStatisticsResponse getBatchStatistics(String batchId) {
    HttpResponse res = sendRequest(new AuthorizeNetModels.getBatchStatisticsRequest(this.merchantAuthentication, batchId).toXML());
    return new AuthorizeNetModels.getBatchStatisticsResponse(res);
  }
}