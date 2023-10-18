String? validateEmail(String value) {
  if (!RegExp(
          r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
      .hasMatch(value)) {
    return 'Please enter a valid email address';
  }
  return null;
}

String? validatePassword(String value) {
  if (value.trim().isEmpty) {
    return 'Please enter a password';
  }else if (value.length<8) {
    return 'Weak password';
  }
  return null;
}
