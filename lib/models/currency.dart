enum Currency {
  usd('USD', '\$', 'US Dollar'),
  eur('EUR', '€', 'Euro'),
  gbp('GBP', '£', 'British Pound'),
  jpy('JPY', '¥', 'Japanese Yen'),
  cny('CNY', '¥', 'Chinese Yuan'),
  krw('KRW', '₩', 'South Korean Won'),
  rub('RUB', '₽', 'Russian Ruble'),
  inr('INR', '₹', 'Indian Rupee'),
  aud('AUD', 'A\$', 'Australian Dollar'),
  cad('CAD', 'C\$', 'Canadian Dollar'),
  chf('CHF', 'Fr', 'Swiss Franc'),
  try_('TRY', '₺', 'Turkish Lira'),
  brl('BRL', 'R\$', 'Brazilian Real'),
  mxn('MXN', 'Mex\$', 'Mexican Peso'),
  aed('AED', 'د.إ', 'UAE Dirham'),
  sar('SAR', 'ر.س', 'Saudi Riyal'),
  zar('ZAR', 'R', 'South African Rand'),
  thb('THB', '฿', 'Thai Baht'),
  sgd('SGD', 'S\$', 'Singapore Dollar'),
  hkd('HKD', 'HK\$', 'Hong Kong Dollar');

  final String code;
  final String symbol;
  final String name;

  const Currency(this.code, this.symbol, this.name);

  String get displayName => '$name ($code)';

  String formatAmount(double amount) {
    // Format with 2 decimal places for most currencies
    // JPY and KRW typically don't use decimal places
    if (this == Currency.jpy || this == Currency.krw) {
      return '$symbol${amount.toStringAsFixed(0)}';
    }
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  static Currency? fromCode(String? code) {
    if (code == null) return null;
    try {
      return Currency.values.firstWhere(
        (c) => c.code == code.toUpperCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
