enum ReceivingItemStatus {
  pending,
  checked,
  received,
}

class ReceivingItem {
  final String id;
  final String code;

  /// contoh: "Limosin • Jantan • Sapi Besar"
  final String subtitle;

  /// contoh: "14 Bulan"
  final String age;

  /// contoh: "315 kg"
  final String weight;

  /// contoh: "31.5 kg"
  final String cutWeight;

  /// contoh: "Rp 23.000.000"
  final String price;

  /// optional
  final String? vaccine;

  /// optional
  final String? note;

  final ReceivingItemStatus status;

  const ReceivingItem({
    required this.id,
    required this.code,
    required this.subtitle,
    required this.age,
    required this.weight,
    required this.cutWeight,
    required this.price,
    this.vaccine,
    this.note,
    required this.status,
  });

  /// =====================
  /// Helper
  /// =====================
  bool get isChecked => status == ReceivingItemStatus.checked;
  bool get isReceived => status == ReceivingItemStatus.received;

  String get statusText {
    switch (status) {
      case ReceivingItemStatus.checked:
        return 'Diperiksa';
      case ReceivingItemStatus.received:
        return 'Diterima';
      case ReceivingItemStatus.pending:
      default:
        return 'Menunggu';
    }
  }
}
