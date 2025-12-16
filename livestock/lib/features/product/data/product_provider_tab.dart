import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'product_tab.dart';

final productTabProvider = StateProvider<ProductTab>(
  (ref) => ProductTab.product,
);
