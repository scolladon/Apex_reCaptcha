public with sharing class reCaptcha {

  private static final reCaptchaGoogle__c recaptchaConfig = reCaptchaGoogle__c.getOrgDefaults();

  public static Boolean verify(String response, String remoteHost) {
    Boolean verif = false;
    final HttpResponse res = makeRequest(
      'secret=' + recaptchaConfig.secretKey__c +
      '&response='  + response +
      '&remoteip='  + remoteHost
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

  private static HttpResponse makeRequest(string body)  {
    HttpResponse response = null;
    HttpRequest req = new HttpRequest();
    req.setEndpoint(recaptchaConfig.endpoint__c);
    req.setMethod('POST');
    req.setBody (body);
    try {
      Http http = new Http();
      response = http.send(req);
    } catch(System.Exception e) {
      // Handle error here
    }
    return response;
  }

  public static String remoteHost(Map<String, String> hdrs) {
    String ret = '127.0.0.1';
    if (hdrs.get('x-original-remote-addr')!= null)
      ret =  hdrs.get('x-original-remote-addr');
    else if (hdrs.get('X-Salesforce-SIP')!= null)
      ret =  hdrs.get('X-Salesforce-SIP');
    return ret;
  }
}