
mixin ValidationMixin {
  bool isPasswordValid(String inputpassword) => inputpassword.length == 6;

  bool isEmailValid(String email) {    
    return email.contains('@');
  }
}
