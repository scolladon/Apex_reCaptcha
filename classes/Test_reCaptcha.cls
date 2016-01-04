@isTest
private class Test_reCaptcha {

  @testSetup static void init() {
    insert new reCaptchaGoogle__c(PublicKey__c = 'public',SecretKey__c = 'private');
  }

  @isTest static void testVerify() {
    Test.setMock(HttpCalloutMock.class, new Test_reCaptcha.GoogleHTTPCalloutMock());
    Test.startTest();
    reCaptcha.verify('response', new Map<String,String>{'X-Salesforce-SIP' => 'Salesforce'});
    Test.stopTest();
  }

  @isTest static void testVerifyOverload() {
    Test.setMock(HttpCalloutMock.class, new Test_reCaptcha.GoogleHTTPCalloutMock());
    Test.startTest();
    reCaptcha.verify('response');
    Test.stopTest();
  }

  @isTest static void testRemoteHost() {
    reCaptcha.remoteHost(new Map<String, String>{'x-original-remote-addr'=>''});
    reCaptcha.remoteHost(new Map<String, String>{'X-Salesforce-SIP'=>''});
  }

  @isTest static void testVerifyError() {
    reCaptcha.verify('response', new Map<String,String>{'X-Salesforce-SIP' => 'Salesforce'});
  }

  public class GoogleHTTPCalloutMock implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest req) {
      // Create a fake response
      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setBody('{"success":"true"}');
      res.setStatusCode(200);
      return res;
    }
  }
}