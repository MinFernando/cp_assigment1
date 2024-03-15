
 //provides validation utilities for forms or user inputs.
mixin ValidationMixin {
  bool isPasswordValid(String inputpassword) => inputpassword.length == 6; // max length is 6 characters

  // Validates if an email address is considered valid.
  bool isEmailValid(String email) {    
    return email.contains('@');
  }
}
