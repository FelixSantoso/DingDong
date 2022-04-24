import 'package:email_validator/email_validator.dart';

class UserId {
  final String uid;
  UserId({required this.uid});
}

class UserData {
  final String uid;
  final String id;
  UserData({required this.uid, required this.id});
}

bool? validateEmail(email) {
  if (!EmailValidator.validate(email)) {
    return false;
  } else {
    return true;
  }
}

class Data {
  final String dId;
  final String email;
  final String name;

  Data({required this.dId, required this.email, required this.name});
}

class FutureData {
  final String uid;
  final String email;
  final String dId;
  final String name;

  FutureData({
    required this.email,
    required this.dId,
    required this.uid,
    required this.name,
  });
}
