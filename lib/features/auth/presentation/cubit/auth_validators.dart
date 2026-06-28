class AuthValidators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name Required';
    }
    if (value.trim().length < 3) {
      return 'Name Must Contain 3 chars';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email Required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email Not valied';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password Required';
    }
    if (value.length < 8) {
      return 'Password Must Contain 8 chars';
    }
    return null;
  }

  static String? validatePasswordConfirmation(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confrmation Required';
    }
    if (value != password) {
      return "Passwrod dosen't match";
    }
    return null;
  }
}
