import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauthtest/model/user_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'user_repository_test.mocks.dart';

//Mock external Firebase dependencies
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

@GenerateMocks([MockFirebaseAuth])
@GenerateMocks([MockUser])
@GenerateMocks([MockUserCredential])
void main() {
  group("User Repository test", () {
    //create instance of generated firebase dependencies Mocks
    MockFirebaseAuth _auth = MockMockFirebaseAuth();
    BehaviorSubject<MockMockUser?> _user = BehaviorSubject<MockMockUser?>();

    //when Method authStateChanges is called answer with the stream of Mock user Generated
    when(_auth.authStateChanges()).thenAnswer((_) {
      return _user;
    });
    //generate user repository instance
    UserRepository _userRepository = UserRepository.instance(auth: _auth);

    //when Method signInWithEmailAndPassword is called with correct inputs answer with the MockMockUserCredential generated
    when(_auth.signInWithEmailAndPassword(
            email: 'ahmed.jedidi92@gmail.com', password: '123456'))
        .thenAnswer((_) async {
      _user.add(MockMockUser());
      return MockMockUserCredential();
    });

    //when Method signInWithEmailAndPassword is called with incorrect inputs answer with null
    when(_auth.signInWithEmailAndPassword(
            email: 'ahmed.jedidi@gmail.com', password: '123'))
        .thenThrow((_) async {
      return null;
    });
    test("Sign In With Email and password", () async {
      //call signIn Method in userRepo with correct inputs
      bool signedIn =
          await _userRepository.signIn('ahmed.jedidi92@gmail.com', '123456');
      //expect Results
      expect(signedIn, true);
      expect(_userRepository.status, Status.Authenticated);
    });

    test("Sign In Fails With incorrect Email and password", () async {
      //call signIn Method in userRepo with incorrect inputs
      bool signedIn =
          await _userRepository.signIn('ahmed.jedidi@gmail.com', '123');
      //expect Results
      expect(signedIn, false);
      expect(_userRepository.status, Status.Unauthenticated);
    });

    test("sign out", () async {
      //call signOut Method in userRepo
      await _userRepository.signOut();
      //expect result
      expect(_userRepository.status, Status.Unauthenticated);
    });
  });
}
