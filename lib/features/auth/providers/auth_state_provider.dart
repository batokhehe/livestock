import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';

final authStateProvider = FutureProvider<bool>((ref) async {
  final repo = ref.read(authRepositoryProvider);
  return await repo.isLoggedIn();
});
