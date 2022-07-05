abstract class Validator {
  static final _emailRegex = RegExp(
    r"^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$",
  );

  static final _nameRegex = RegExp(
    r"(([A-Z]\.?\s?)*([A-Za-z]+\.?'?\s?)+([A-Z]\.?\s?[a-z]*)*)",
  );

  static bool isEmail(String email) => _emailRegex.hasMatch(email);

  static bool isName(String name) => _nameRegex.hasMatch(name);
}
