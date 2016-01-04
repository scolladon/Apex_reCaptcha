Apex reCaptcha
===

Google reCaptcha Apex implementation for Salesforce.
Visualforce integration + Apex helper class

Test Coverage : 100%

<a href="https://githubsfdeploy.herokuapp.com?owner=ForceComDeveloper&repo=Apex_reCaptcha">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

#How to use

In your visualforce page include the component in the
form you want to ensure it is completed by a human being
```
<c:reCaptcha/> <!-- Use your rendering condition -->
```

In your controller when validating the form
```
Boolean isSuccess;
// First paramter is the user recaptcha answer transmitted to the form
// Second parameter is a string,string map with the headers values
isSuccess = reCaptcha.verify(
  ApexPages.currentPage().getParameters().get('g-recaptcha-response'),
  new map<String,String>{'headerKey'=>'headerValue'}
);

// Here is a shortcut to directly
// deal with the Current page headers
isSuccess = reCaptcha.verify(
  ApexPages.currentPage().getParameters().get('g-recaptcha-response')
);

// Then check isSuccess to validate the human filled form
if(isSuccess) {
  // then validate the form
} else {
  // handle the error
}
```

#How to configure

If you deployed via the "deploy to Salesforce" button, Remote Site Settings to
google and custom settings should be added. You just have to configure the
Custom Settings accordingly to your Google reCaptcha account

You have to define the default value of the custom settings "reCaptchaGoogle".

Go to Setup => Quick Find Box => Custom Settings => reCaptchaGoogle => Manage
Set the default organisation level value :
* PublicKey => Put the value of your google recaptcha public key account
* PrivateKey => Put the value of your google recaptcha private key account
* libraryUrl => Put the value of the js library from google (default value : https://www.google.com/recaptcha/api.js it is the right one at writing time)
* endPoint => Put the value of the endpoint service for verification from google (default value : https://www.google.com/recaptcha/api/siteverify it is the right one at writing time)
