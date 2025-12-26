import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constant/enum.dart';

export '../features/auth/data/auth_repository.dart';
export '../features/auth/providers/auth_provider.dart';
export 'router.dart';

final itemFilterProvider = StateProvider<ItemFilter>((ref) {
  return ItemFilter.product;
});
