import 'package:dio/dio.dart';
import 'package:druna_app/app/druna_app.dart';
import 'package:druna_app/core/api/api_client.dart';
import 'package:druna_app/core/config/app_config.dart';
import 'package:druna_app/core/storage/token_store.dart';
import 'package:druna_app/repositories/druna_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the welcome screen when there is no saved session', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    expect(find.text('Найдём время\nдля встречи'), findsOneWidget);
    expect(find.text('Войти'), findsOneWidget);
    expect(find.text('Создать аккаунт'), findsOneWidget);
  });

  testWidgets('sign-up validates the minimum password length', (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Создать аккаунт'));
    await tester.pumpAndSettle();
    final fields = find.byType(EditableText);
    await tester.enterText(fields.at(0), 'Алиса');
    await tester.enterText(fields.at(1), 'alice@example.com');
    await tester.enterText(fields.at(2), 'alice');
    await tester.enterText(fields.at(3), 'short');
    await tester.tap(find.widgetWithText(FilledButton, 'Создать профиль'));
    await tester.pump();

    expect(
      find.text('Пароль должен быть не короче 8 символов'),
      findsOneWidget,
    );
  });
}

DrunaApp _testApp() {
  final store = MemoryTokenStore();
  final repository = DrunaRepository(
    ApiClient(baseUrl: 'https://example.test', tokenStore: store, dio: Dio()),
  );
  return DrunaApp(
    repository: repository,
    tokenStore: store,
    config: const AppConfig(
      apiBaseUrl: 'https://example.test',
      environment: 'test',
    ),
  );
}
