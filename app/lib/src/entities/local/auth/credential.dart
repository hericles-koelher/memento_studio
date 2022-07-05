abstract class Credential {
  static Credential fromEmail({
    required String email,
    required String password,
  }) {
    return EmailCredential(email, password);
  }

  static Credential fromFacebook(String accessToken) {
    return FacebookCredential(accessToken);
  }

  static Credential fromGoogle({
    required String? accessToken,
    required String? idToken,
  }) {
    return GoogleCredential(accessToken, idToken);
  }
}

class EmailCredential implements Credential {
  final String email;
  final String password;

  EmailCredential(this.email, this.password);
}

class FacebookCredential implements Credential {
  final String accessToken;

  FacebookCredential(this.accessToken);
}

class GoogleCredential implements Credential {
  final String? accessToken;
  final String? idToken;

  GoogleCredential(this.accessToken, this.idToken);
}
