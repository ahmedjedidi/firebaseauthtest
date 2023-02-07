import 'package:firebaseauthtest/model/user_repository.dart';
import 'package:firebaseauthtest/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../models/user_repository_test.mocks.dart';

main() {
  //create instance of generated firebase dependencies Mocks
  MockMockFirebaseAuth _auth = MockMockFirebaseAuth();
  BehaviorSubject<MockMockUser?> _user = BehaviorSubject<MockMockUser?>();

  //when Method authStateChanges is called answer with the stream of Mock user Generated
  when(_auth.authStateChanges()).thenAnswer((_) {
    return _user;
  });
  //generate user repository instance
  UserRepository _userRepository = UserRepository.instance(auth: _auth);

  //method created for making widget testable (inject provider in the widget)
  Widget _makeWidgetTestable(Widget child) {
    return ChangeNotifierProvider.value(
      value: _userRepository,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  // find all widget needed
  var emailField = find.byKey(Key("email-field"));
  var passwordField = find.byKey(Key("password-field"));
  var signInButton = find.text("Sign In");

  group("test login page", () {
    testWidgets('email, password and sign in button are found',
        (WidgetTester tester) async {
      // call the widget that will be tested
      await tester.pumpWidget(_makeWidgetTestable(LoginPage()));
      // expect Results
      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(signInButton, findsOneWidget);
    });

    testWidgets('validate empty email and password',
        (WidgetTester tester) async {
      // call the widget that will be tested    
      await tester.pumpWidget(_makeWidgetTestable(LoginPage()));
      // Tap button sign in
      await tester.tap(signInButton);
      // refresh the widget
      await tester.pumpAndSettle();
      // expect Results
      expect(find.text("Please Enter Password"), findsOneWidget);
      expect(find.text("Please Enter Email"), findsOneWidget);
    });

    testWidgets('call sign in method when email and password are entered',
        (WidgetTester tester) async {
      // call the widget that will be tested     
      await tester.pumpWidget(_makeWidgetTestable(LoginPage()));
      // enter email value
      await tester.enterText(emailField,"ahmed.jedidi92@gmail.com");
      //enter password value
      await tester.enterText(passwordField,"123456");
      // tap button sign in
      await tester.tap(signInButton);
      // refresh the widget
      await tester.pumpAndSettle();
      // expect Results ( the method sign in is called once )
      verify(_userRepository.signIn("ahmed.jedidi92@gmail.com", "123456")).called(1);
    });
  });
}
