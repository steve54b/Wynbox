    // The Browser API key obtained from the Google Developers Console.
    // Replace with your own Browser API key, or your own key.
    var developerKey = "AIzaSyBiqWNeWDMd1iL2qT76Ythcdw1owI_pMnY";

    // The Client ID obtained from the Google Developers Console. Replace with your own Client ID.
    var clientId = "769026199264-q50nf9etm9vf6a5d725m9qs6gfg9u438.apps.googleusercontent.com"

    // Replace with your own App ID. (Its the first number in your Client ID)
    var appId = "769026199264";

    // Scope to use to access user's Drive items.
    var scope = ['https://www.googleapis.com/auth/drive'];

    var pickerApiLoaded = false;
    var oauthToken;

    // Use the Google API Loader script to load the google.picker script.
    function loadPicker() {
      gapi.load('auth', {'callback': onAuthApiLoad});
      gapi.load('picker', {'callback': onPickerApiLoad});
    }

    function onAuthApiLoad() {
      window.gapi.auth.authorize(
          {
            'client_id': clientId,
            'scope': scope,
            'immediate': false
          },
          handleAuthResult);
    }

    function onPickerApiLoad() {
      pickerApiLoaded = true;
      createPicker();
    }

    function handleAuthResult(authResult) {
      if (authResult && !authResult.error) {
        oauthToken = authResult.access_token;
        createPicker();
      }
    }

    // Create and render a Picker object for searching images.
    function createPicker() {
      if (pickerApiLoaded && oauthToken) {
        var view = new google.picker.View(google.picker.ViewId.DOCS);
        view.setMimeTypes("application/pdf");
        var picker = new google.picker.PickerBuilder()
            .enableFeature(google.picker.Feature.NAV_HIDDEN)
            .enableFeature(google.picker.Feature.MULTISELECT_ENABLED)
            .setAppId(appId)
            .setOAuthToken(oauthToken)
            .addView(view)
            .addView(new google.picker.DocsUploadView())
            .setDeveloperKey(developerKey)
            .setCallback(pickerCallback)
            .build();
         picker.setVisible(true);
      }
    }

    // A simple callback implementation.
    function pickerCallback(data) {
      var url = 'nothing';
      if (data[google.picker.Response.ACTION] == google.picker.Action.PICKED) {
        var doc = data[google.picker.Response.DOCUMENTS][0];
        url = doc[google.picker.Document.URL];
        console.log(url);
        window.open(url);
      }
      // var message = 'You picked: ' + url;

      //document.getElementById('result').innerHTML = message;
    }
    // function pickerCallback(data) {
    //   if (data.action == google.picker.Action.PICKED) {
    //     var fileId = data.docs[0].id;
    //     alert('The user selected: ' + fileId);
    //   }
    // }
