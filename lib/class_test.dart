import 'package:flutter_test/flutter_test.dart' as flutter_test;

/// Class that represents [flutter_test.group(description, body)] of tests.
/// Inherit it and override [declareTests]. Use [declareTest] calls inside
/// of it just as if you were using [flutter_test.test(description, body)].
/// In the main() function just instantiate your implementation of [Test] and
/// call [run].
abstract class Test {
  String _groupName;
  List<_TestCase> _testCases = [];

  /// Create a test with a [_groupName].
  Test(this._groupName);

  /// Override this method to define body of [flutter_test.setUp(body)].
  void setUp() {}

  /// Override this method to define body of [flutter_test.setUpAll(body)].
  void setUpAll() {}

  /// Override this method to define body of [flutter_test.tearDown(body)].
  void tearDown() {}

  /// Override this method to define body of [flutter_test.tearDownAll(body)].
  void tearDownAll() {}

  /// Declare all your tests inside this method.
  void declareTests();

  /// Declare a test.
  ///
  /// Each test should have it's unique [description]. Declaring a test with
  /// a [description] of another test will override the latter one.
  ///
  /// Treat this method just as if it were the
  /// [flutter_test.test(description, body)].
  void declareTest(String description, Function body,
      [String testOn,
      flutter_test.Timeout timeout,
      dynamic skip,
      dynamic tags,
      Map<String, dynamic> onPlatform,
      int retry]) {
    removeTest(description);
    final testCase = _TestCase(description, body,
        testOn: testOn,
        timeout: timeout,
        skip: skip,
        tags: tags,
        onPlatform: onPlatform,
        retry: retry);
    _testCases.add(testCase);
  }

  /// Remove declaration of a test with the [description].
  void removeTest(String description) {
    _testCases.removeWhere((tc) => tc.description == description);
  }

  /// Run all tests, that were declared in [declareTests].
  void run() {
    declareTests();
    flutter_test.group(_groupName, () {
      flutter_test.setUpAll(setUpAll);
      flutter_test.setUp(setUp);
      flutter_test.tearDown(tearDown);
      flutter_test.tearDownAll(tearDownAll);
      _testCases.forEach((tc) => tc.declare());
    });
  }
}

class _TestCase {
  String description;
  Function _body;
  String _testOn;
  flutter_test.Timeout _timeout;
  dynamic _skip;
  dynamic _tags;
  Map<String, dynamic> _onPlatform;
  int _retry;

  _TestCase(this.description, this._body,
      {String testOn,
      flutter_test.Timeout timeout,
      dynamic skip,
      dynamic tags,
      Map<String, dynamic> onPlatform,
      int retry})
      : _testOn = testOn,
        _timeout = timeout,
        _skip = skip,
        _tags = tags,
        _onPlatform = onPlatform,
        _retry = retry;

  void declare() {
    flutter_test.test(description, _body,
        testOn: _testOn,
        timeout: _timeout,
        skip: _skip,
        tags: _tags,
        onPlatform: _onPlatform,
        retry: _retry);
  }
}
