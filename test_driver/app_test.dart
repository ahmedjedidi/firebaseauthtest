import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

main(){

group("Flutter Auth with firebase test", (){

  //find all widget needed
  final emailField = find.byValueKey("email-field");
  final passwordField = find.byValueKey("password-field");
  final signInButton = find.text("Sign In");
  final userInfoPage = find.byType("UserInfoPage");
  final snackBar = find.byType("SnackBar");

  FlutterDriver? driver;

  setUpAll(() async {
      //init driver
      driver = await FlutterDriver.connect();
  });


  tearDownAll(()async{
    //close driver
    if(driver != null){
        driver?.close();
    }
  });

  test("login fails with incorrect email and password , and snackbar is shown", ()async{
      //tap email field
      await driver?.tap(emailField);
      //enter email field
      await driver?.enterText("ahmed.jedidi2@gmail.com");
      //tap password field
      await driver?.tap(passwordField);
      //enter password field
      await driver?.enterText("12345");
      //tap sign in button
      await driver?.tap(signInButton);
      //wait for snackbar to show
      await driver?.waitFor(snackBar);
      // verify that snackbar is not null
      assert(snackBar != null );
      // wait for all callbacks to finish
      await driver?.waitUntilNoTransientCallbacks();
      // verify user info page is  null
      assert(userInfoPage == null);
  });


    test("login in with correct email and password", ()async{
      //tap email field
      await driver?.tap(emailField);
       //enter email field
      await driver?.enterText("ahmed.jedidi92@gmail.com");
      //tap password field
      await driver?.tap(passwordField);
      //enter password field
      await driver?.enterText("123456");
      //tap sign in button
      await driver?.tap(signInButton);
      //wait for userInfoPage to show
      await driver?.waitFor(userInfoPage);
      // verify user info page is not null
      assert(userInfoPage != null);
      await driver?.waitUntilNoTransientCallbacks();
  });
});

}