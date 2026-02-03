class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException([this.message = 'Sesi Anda telah berakhir']);
}
