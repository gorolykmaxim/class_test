import 'package:class_test/class_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

abstract class TestListener {
  setUpAll();
  setUp();
  test1();
  test2();
  test3();
  doNotExecuteThisTest();
  tearDown();
  tearDownAll();
}

class TestListenerMock extends Mock implements TestListener {}

class DummyTest extends Test {
  final TestListenerMock listener = TestListenerMock();

  DummyTest() : super('Dummy test');


  @override
  void declareTests() {
    declareTest('test1', listener.test1);
    declareTest('test2', listener.test2);
    // Declare the same test twice by mistake.
    declareTest('test2', listener.test2);
    declareTest('test3', listener.test3);
    declareTest('test4', listener.doNotExecuteThisTest);
    // Remove unnecessary test.
    removeTest('test4');
  }

  @override
  void setUp() {
    listener.setUp();
  }

  @override
  void setUpAll() {
    listener.setUpAll();
  }

  @override
  void tearDown() {
    listener.tearDown();
  }

  @override
  void tearDownAll() {
    listener.tearDownAll();
  }

}

void main() {
  final dummyTest = DummyTest();
  dummyTest.run();
  test('calls all methods of the test listener', () {
    final listener = dummyTest.listener;
    verify(listener.setUpAll()).called(1);
    verify(listener.tearDownAll()).called(1);
    verify(listener.setUp()).called(3);
    verify(listener.tearDown()).called(3);
    verify(listener.test1()).called(1);
    verify(listener.test2()).called(1);
    verify(listener.test3()).called(1);
    verifyNever(listener.doNotExecuteThisTest());
  });
}