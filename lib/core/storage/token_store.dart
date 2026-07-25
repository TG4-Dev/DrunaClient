import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenPair {
  const TokenPair({required this.accessToken, required this.refreshToken});

  factory TokenPair.fromJson(Map<String, dynamic> json) => TokenPair(
    accessToken: json['accessToken'] as String,
    refreshToken: json['refreshToken'] as String,
  );

  final String accessToken;
  final String refreshToken;
}

abstract interface class TokenStore {
  Future<TokenPair?> read();
  Future<void> write(TokenPair tokens);
  Future<void> clear();
}

class SecureTokenStore implements TokenStore {
  SecureTokenStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _accessKey = 'druna_access_token';
  static const _refreshKey = 'druna_refresh_token';
  final FlutterSecureStorage _storage;

  @override
  Future<TokenPair?> read() async {
    final values = await _storage.readAll();
    final access = values[_accessKey];
    final refresh = values[_refreshKey];
    if (access == null || refresh == null) return null;
    return TokenPair(accessToken: access, refreshToken: refresh);
  }

  @override
  Future<void> write(TokenPair tokens) async {
    await Future.wait([
      _storage.write(key: _accessKey, value: tokens.accessToken),
      _storage.write(key: _refreshKey, value: tokens.refreshToken),
    ]);
  }

  @override
  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _accessKey),
      _storage.delete(key: _refreshKey),
    ]);
  }
}

class MemoryTokenStore implements TokenStore {
  MemoryTokenStore([this.tokens]);

  TokenPair? tokens;

  @override
  Future<void> clear() async => tokens = null;

  @override
  Future<TokenPair?> read() async => tokens;

  @override
  Future<void> write(TokenPair value) async => tokens = value;
}
