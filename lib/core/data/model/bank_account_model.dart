class BankAccount {
  final int id;
  final String? bankName;
  final String? accountNumber;
  final String? accountHolderName;
  final String? branchName;
  final String? accountType;
  final String? balance;
  final String? currency;

  BankAccount({
    required this.id,
    this.bankName,
    this.accountNumber,
    this.accountHolderName,
    this.branchName,
    this.accountType,
    this.balance,
    this.currency,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'] ?? 0,
      bankName: json['bank_name'],
      accountNumber: json['account_number'],
      accountHolderName: json['account_holder_name'],
      branchName: json['branch_name'],
      accountType: json['account_type'],
      balance: json['balance'],
      currency: json['currency'],
    );
  }

  String get displayName => "$bankName - $accountNumber ($accountHolderName)";
}
