class OtpRouteArgs {
  const OtpRouteArgs({required this.phone, required this.registration});
  final String phone;
  final bool registration;
}

class RegistrationRouteArgs {
  const RegistrationRouteArgs({required this.phone, required this.firstName, required this.lastName});
  final String phone, firstName, lastName;
}
