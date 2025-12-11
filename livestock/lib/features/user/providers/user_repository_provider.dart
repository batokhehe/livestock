import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock/features/user/providers/user_api_provider.dart';

import '../data/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final api = ref.watch(userApiProvider);
  return UserRepository(api);
});
