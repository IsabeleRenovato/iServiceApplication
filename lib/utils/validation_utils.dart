import 'package:intl/intl.dart';

class ValidationUtils {
  // Expressões regulares para validação
  static final RegExp _emailRegExp = RegExp(
    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
  );
  static final RegExp _upperCaseLetterRegExp = RegExp(r'[A-Z]');
  static final RegExp _lowerCaseLetterRegExp = RegExp(r'[a-z]');
  static final RegExp _numberRegExp = RegExp(r'[0-9]');
  static final RegExp _symbolRegExp = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');

  // Validar o formato do e-mail
  static bool isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  // Validar a senha e retornar uma mensagem de erro se inválida
  static List<ValidationResult> validatePassword(String password) {
    List<ValidationResult> validations = [
      ValidationResult(
        message: 'Tamanho mínimo de 8 caracteres',
        isValid: password.length >= 8,
      ),
      ValidationResult(
        message: 'Pelo menos uma letra maiúscula',
        isValid: _upperCaseLetterRegExp.hasMatch(password),
      ),
      ValidationResult(
        message: 'Pelo menos uma letra minúscula',
        isValid: _lowerCaseLetterRegExp.hasMatch(password),
      ),
      ValidationResult(
        message: 'Pelo menos um número',
        isValid: _numberRegExp.hasMatch(password),
      ),
      ValidationResult(
        message: 'Pelo menos um símbolo',
        isValid: _symbolRegExp.hasMatch(password),
      ),
    ];
    return validations;
  }

  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, selecione sua data de nascimento';
    }

    try {
      DateTime birthDate = DateFormat('dd/MM/yyyy').parse(value);
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;

      if (birthDate.isAfter(DateTime(today.year, today.month, today.day))) {
        age--;
      }

      if (age < 18) {
        return 'Você deve ter pelo menos 18 anos';
      }

      return null;
    } catch (e) {
      return 'Data inválida';
    }
  }
}

// Estrutura de dados para manter resultados de validação
class ValidationResult {
  final String message;
  final bool isValid;

  ValidationResult({required this.message, required this.isValid});
}
