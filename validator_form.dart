class ValidatorController {
  // Validate username
  String? validateUsername(String value) {
    if (value.isEmpty) {
      return 'Username is required';
    } else if (value.length < 3) {
      return 'Username must be at least 3 characters long';
    }
    return null;
  }

  // Validate email
  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email address is required';
    } else if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

// email verification code
String? validateEmailVerfy(String value) {
    if (value.isEmpty) {
      return 'verify code is required';
    } else {
      return 'Enter a valid verification code ';
    }
}

  // Validate password
  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 5) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }
// validate city name
  String? validateCity(String value) {
    if (value.isEmpty) {
      return 'City name is required';
    } else if (value.length < 3) {
      return 'Username must be at least 3 characters long';
    }
    return null;
  }

// validate conf password
  String? validateconfPassword(String value) {
    if (value.isEmpty) {
      return 'New Password is required';
    }
     else if (value.length < 4) {
      return 'Password must be at least 4 characters long';
    }
    return null;
  }

  // Validate mobile phone
  String? validateMobile(String value) {
    if (value.isEmpty) {
      return 'Mobile phone is required';
    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }
}
