import 'package:druna_app/app/session_controller.dart';
import 'package:druna_app/core/theme/druna_theme.dart';
import 'package:druna_app/shared/ui/druna_widgets.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({required this.session, super.key});
  final SessionController session;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _loginMode = false;
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    try {
      await widget.session.signIn(_username.text, _password.text);
    } catch (error) {
      if (mounted) showMessage(context, error.toString(), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => GradientScaffold(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 4),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    const BrandMark(),
                    const SizedBox(height: 44),
                    Text(
                      'DRUNA',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 22),
                    Text(
                      _loginMode
                          ? 'С возвращением'
                          : 'Найдём время\nдля встречи',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Сверим календари и покажем удобные окна',
                      style: TextStyle(color: DrunaColors.muted, height: 1.55),
                    ),
                    const Spacer(),
                    if (_loginMode) ...[
                      TextFormField(
                        controller: _username,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        autofillHints: const [
                          AutofillHints.username,
                          AutofillHints.email,
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Ник или почта',
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Введи ник'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _password,
                        obscureText: _obscure,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        onFieldSubmitted: (_) => _signIn(),
                        decoration: InputDecoration(
                          labelText: 'Пароль',
                          suffixIcon: IconButton(
                            tooltip: _obscure
                                ? 'Показать пароль'
                                : 'Скрыть пароль',
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                            ),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Введи пароль'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      DrunaButton(
                        label: 'Войти',
                        onPressed: _signIn,
                        loading: _loading,
                      ),
                      TextButton(
                        onPressed: () => showMessage(
                          context,
                          'Восстановление пароля пока не поддерживается сервером',
                        ),
                        child: const Text(
                          'Не помню пароль',
                          style: TextStyle(color: DrunaColors.muted),
                        ),
                      ),
                    ] else ...[
                      DrunaButton(
                        label: 'Войти',
                        onPressed: () => setState(() => _loginMode = true),
                      ),
                      const SizedBox(height: 12),
                      DrunaButton(
                        label: 'Создать аккаунт',
                        secondary: true,
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                SignupScreen(session: widget.session),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => showMessage(
                          context,
                          'Гостевые опросы появятся после добавления endpoint на сервере',
                        ),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: const Text(
                          'Ответить на приглашение без аккаунта →',
                          style: TextStyle(
                            color: DrunaColors.muted,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({required this.session, super.key});
  final SessionController session;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _key = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_key.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    try {
      await widget.session.signUp(
        name: _name.text,
        username: _username.text,
        email: _email.text,
        password: _password.text,
      );
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (error) {
      if (mounted) showMessage(context, error.toString(), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Создать аккаунт')),
    body: SafeArea(
      top: false,
      child: Form(
        key: _key,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 28,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 5),
                for (var i = 0; i < 2; i++) ...[
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF38383D),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ],
            ),
            const SizedBox(height: 34),
            Text(
              'Создать профиль',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 10),
            const Text(
              'После регистрации Druna автоматически назначит твой постоянный цвет',
              style: TextStyle(color: DrunaColors.muted),
            ),
            const SizedBox(height: 28),
            TextFormField(
              controller: _name,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Имя',
                hintText: 'Как к тебе обращаться',
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Введи имя' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Почта',
                hintText: 'you@example.com',
              ),
              validator: (value) =>
                  value != null && RegExp(r'^.+@.+\..+$').hasMatch(value.trim())
                  ? null
                  : 'Проверь адрес почты',
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _username,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Ник',
                hintText: 'Как тебя найдут друзья',
              ),
              validator: (value) => value == null || value.trim().length < 3
                  ? 'Минимум 3 символа'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _password,
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: 'Пароль',
                hintText: 'Минимум 8 символов',
                suffixIcon: IconButton(
                  tooltip: _obscure ? 'Показать пароль' : 'Скрыть пароль',
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                  ),
                ),
              ),
              validator: (value) => value == null || value.length < 8
                  ? 'Пароль должен быть не короче 8 символов'
                  : null,
            ),
            const SizedBox(height: 36),
            DrunaButton(
              label: 'Создать профиль',
              onPressed: _submit,
              loading: _loading,
            ),
            const SizedBox(height: 12),
            const Text(
              'Продолжая, ты принимаешь условия использования',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF626269), fontSize: 10),
            ),
          ],
        ),
      ),
    ),
  );
}
