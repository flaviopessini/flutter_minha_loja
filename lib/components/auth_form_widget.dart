import 'package:flutter/material.dart';
import 'package:flutter_minha_loja/exceptions/custom_auth_exception.dart';
import 'package:flutter_minha_loja/models/auth.dart';
import 'package:provider/provider.dart';

class AuthFormWidget extends StatefulWidget {
  const AuthFormWidget({Key? key}) : super(key: key);

  @override
  State<AuthFormWidget> createState() => _AuthFormWidgetState();
}

enum AuthMode {
  signUp,
  login,
}

class _AuthFormWidgetState extends State<AuthFormWidget>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLoading = false;
  AuthMode _authMode = AuthMode.login;
  AnimationController? _animationController;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _isLogin() ? 310.0 : 400.0,
        // height: _heightAnimation?.value.height ?? (_isLogin() ? 310.0 : 400.0),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email?.trim() ?? '',
                validator: (_value) {
                  final email = _value?.trim() ?? '';
                  if (email.isEmpty || !email.contains('@')) {
                    return 'Informe um e-mail válido!';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
                obscureText: true,
                validator: (_value) {
                  final password = _value?.trim() ?? '';
                  if (password.isEmpty || password.length < 6) {
                    return 'Informe uma senha válida!';
                  }
                  return null;
                },
                onSaved: (password) =>
                    _authData['password'] = password?.trim() ?? '',
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
                constraints: BoxConstraints(
                  minHeight: _isLogin() ? 0.0 : 60.0,
                  maxHeight: _isLogin() ? 0.0 : 120.0,
                ),
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: SlideTransition(
                    position: _slideAnimation!,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Confirmar senha',
                      ),
                      obscureText: true,
                      validator: _isLogin()
                          ? null
                          : (_value) {
                              final password = _value?.trim() ?? '';
                              if (password != _passwordController.text.trim()) {
                                return 'Senhas informadas não conferem!';
                              }
                              return null;
                            },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 8.0,
                    ),
                  ),
                  child: Text(
                    _authMode == AuthMode.login ? 'ENTRAR' : 'REGISTRAR',
                  ),
                ),
              const Spacer(),
              TextButton(
                onPressed: _changeAuthMode,
                child: Text(_isLogin() ? 'Registrar-se' : 'Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _animationController?.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
      ),
    );
  }

  void _changeAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signUp;
        _animationController?.forward();
      } else {
        _authMode = AuthMode.login;
        _animationController?.reverse();
      }
    });
  }

  bool _isLogin() => _authMode == AuthMode.login;

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Ocorreu um erro'),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    setState(() => _isLoading = true);
    _formKey.currentState?.save();
    final auth = Provider.of<Auth>(context, listen: false);
    try {
      if (_isLogin()) {
        await auth.login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        await auth.signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } on CustomAuthException catch (e) {
      _showErrorDialog(e.toString());
    } on Exception catch (_) {
      _showErrorDialog('Ocorreu um erro inesperado.');
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
