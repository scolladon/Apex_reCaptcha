public with sharing class reCaptcha {

  private static final reCaptchaGoogle__c recaptchaConfig = reCaptchaGoogle__c.getOrgDefaults();

  public static Boolean verify(final String response, final Map<String, String> hdrs) {
    Boolean verif = false;
    final HttpResponse res = makeRequest(
      'secret=' + recaptchaConfig.secretKey__c +
      '&response='  + response +
      '&remoteip='  + reCaptcha.remoteHost(hdrs)
    );
    if (res != null) {
      if ( res.getStatusCode() == 200 ) {
        final System.JSONParser parser = System.JSON.createParser(res.getBody());
        while (parser.nextToken() != null) {
          if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'success')) {
            parser.nextToken();
            verif = parser.getText() == 'true';
            break;
          }
        }
      }
    }
    return verif;
  }

  public static Boolean verify(final String response) {
    return reCaptcha.verify(response, ApexPages.currentPage().getHeaders());
  }

  private static HttpResponse makeRequest(final string body)  {
    final HttpRequest req = new HttpRequest();
    req.setEndpoint(recaptchaConfig.endpoint__c);
    req.setMethod('POST');
    req.setBody (body);
    try {
      final Http http = new Http();
      return http.send(req);
    } catch(System.Exception e) {
      req = null;
    }
    return req;
  }

  @TestVisible
  private static String remoteHost(final Map<String, String> hdrs) {
    String ret = '127.0.0.1';
    if (hdrs.get('x-original-remote-addr')!= null)
      ret =  hdrs.get('x-original-remote-addr');
    else if (hdrs.get('X-Salesforce-SIP')!= null)
      ret =  hdrs.get('X-Salesforce-SIP');
    return ret;
  }
}
