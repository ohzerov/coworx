abstract class RegValidationEvent {}

class RegValidationChanged extends RegValidationEvent {
  String password;
  String checkPassword;

  RegValidationChanged({required this.password, required this.checkPassword});
}
