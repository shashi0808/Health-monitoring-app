class MockUser {
  final String uid;
  final String email;
  
  MockUser({required this.uid, required this.email});
}

class MockAuthService {
  static final MockAuthService _instance = MockAuthService._internal();
  factory MockAuthService() => _instance;
  MockAuthService._internal();

  MockUser? _currentUser;
  final List<Map<String, String>> _users = [];

  MockUser? get currentUser => _currentUser;

  Future<MockUser?> signUp(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (_users.any((user) => user['email'] == email)) {
      throw Exception('User already exists');
    }
    
    final user = {
      'uid': 'mock_${DateTime.now().millisecondsSinceEpoch}',
      'email': email,
      'password': password,
    };
    
    _users.add(user);
    _currentUser = MockUser(uid: user['uid']!, email: user['email']!);
    
    return _currentUser;
  }

  Future<MockUser?> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final user = _users.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
      orElse: () => {},
    );
    
    if (user.isEmpty) {
      throw Exception('Invalid email or password');
    }
    
    _currentUser = MockUser(uid: user['uid']!, email: user['email']!);
    return _currentUser;
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }
}