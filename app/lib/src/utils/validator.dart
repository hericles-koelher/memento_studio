abstract class Validator {
  static final _emailRegex = RegExp(
    r"^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$",
  );

  static final _nameRegex = RegExp(
    r"(([A-Z]\.?\s?)*([A-Za-z]+\.?'?\s?)+([A-Z]\.?\s?[a-z]*)*)",
  );

  static const int deckNameMaxLength = 32;
  static const int deckDescriptionMaxLength = 128;

  static bool isEmail(String email) => _emailRegex.hasMatch(email);

  static bool isUserName(String name) => _nameRegex.hasMatch(name);
}
