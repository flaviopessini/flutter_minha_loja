class CustomAuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'O endereço de e-mail já está sendo usado.',
    'OPERATION_NOT_ALLOWED': 'O login de senha está desativado.',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Bloqueamos todas as solicitações deste dispositivo devido a atividade incomum. Tente mais tarde.',
    'EMAIL_NOT_FOUND':
        'Não há registro de usuário correspondente a este e-mail. O usuário pode ter sido excluído.',
    'INVALID_PASSWORD': 'A senha é inválida.',
    'USER_DISABLED': 'A conta do usuário foi desativada.',
  };

  final String key;

  CustomAuthException(this.key);

  @override
  String toString() {
    return errors[key] ??
        'Ocorreu um erro desconhecido no processo de autenticação.';
  }
}
