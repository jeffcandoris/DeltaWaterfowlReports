/**
 * An apex page controller that exposes the change password functionality
 */
public with sharing class ChangePasswordController {
  public String oldPassword {get; set; }
  public String newPassword {get; set; }
  public String verifyNewPassword {get; set; }

  private boolean isValidPassword() {
    return newPassword == verifyNewPassword;
  }

  public PageReference changePassword() {

    if (!isValidPassword()) {
      ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
      ApexPages.addMessage(msg);
      return null;
    }

    PageReference pr = Site.changePassword(newPassword, verifyNewPassword, oldpassword);
    if (pr == null) {
      return null;
    }
    PageReference redirectPage = new PageReference('https://deltawaterfowl.auth0.com/authorize?scope=openid%20&response_type=code&connection=salesforce-community&sso=false&client_id=CMFcxkdVCQQzQDbKaveHyZNQz61VI48p&redirect_uri=https%3A%2F%2Fdeltawaterfowl.org%2Findex.php%3Fauth0%3D1&auth0Client=eyJuYW1lIjoibG9jay5qcyIsInZlcnNpb24iOiIxMC4wLjIiLCJsaWJfdmVyc2lvbiI6IjcuMC4zIn0');
    redirectPage.setRedirect(true);
    return redirectPage;
  }

  public ChangePasswordController() {
  }
}