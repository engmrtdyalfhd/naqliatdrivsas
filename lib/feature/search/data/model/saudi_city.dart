// lib/feature/search/data/model/saudi_city.dart

class SaudiCity {
  final String name;       // Arabic name used in display & Firestore queries
  final String region;     // Region/province in Arabic

  const SaudiCity({required this.name, required this.region});
}

/// All 13 Saudi regions with their major cities.
/// Names match what should be stored in Firestore `originCity` / `destinationCity`.
const List<SaudiCity> kSaudiCities = [
  // ── منطقة الرياض ─────────────────────────────────────
  SaudiCity(name: 'الرياض', region: 'منطقة الرياض'),
  SaudiCity(name: 'الخرج', region: 'منطقة الرياض'),
  SaudiCity(name: 'المجمعة', region: 'منطقة الرياض'),
  SaudiCity(name: 'الزلفي', region: 'منطقة الرياض'),
  SaudiCity(name: 'الدوادمي', region: 'منطقة الرياض'),
  SaudiCity(name: 'القويعية', region: 'منطقة الرياض'),
  SaudiCity(name: 'وادي الدواسر', region: 'منطقة الرياض'),
  SaudiCity(name: 'الأفلاج', region: 'منطقة الرياض'),
  SaudiCity(name: 'حوطة بني تميم', region: 'منطقة الرياض'),
  SaudiCity(name: 'السليل', region: 'منطقة الرياض'),
  SaudiCity(name: 'شقراء', region: 'منطقة الرياض'),
  SaudiCity(name: 'عفيف', region: 'منطقة الرياض'),
  SaudiCity(name: 'ضرما', region: 'منطقة الرياض'),

  // ── منطقة مكة المكرمة ────────────────────────────────
  SaudiCity(name: 'مكة المكرمة', region: 'منطقة مكة المكرمة'),
  SaudiCity(name: 'جدة', region: 'منطقة مكة المكرمة'),
  SaudiCity(name: 'الطائف', region: 'منطقة مكة المكرمة'),
  SaudiCity(name: 'القنفذة', region: 'منطقة مكة المكرمة'),
  SaudiCity(name: 'رابغ', region: 'منطقة مكة المكرمة'),
  SaudiCity(name: 'الليث', region: 'منطقة مكة المكرمة'),
  SaudiCity(name: 'الجموم', region: 'منطقة مكة المكرمة'),

  // ── منطقة المدينة المنورة ─────────────────────────────
  SaudiCity(name: 'المدينة المنورة', region: 'منطقة المدينة المنورة'),
  SaudiCity(name: 'ينبع', region: 'منطقة المدينة المنورة'),
  SaudiCity(name: 'العلا', region: 'منطقة المدينة المنورة'),
  SaudiCity(name: 'الحناكية', region: 'منطقة المدينة المنورة'),
  SaudiCity(name: 'بدر', region: 'منطقة المدينة المنورة'),
  SaudiCity(name: 'خيبر', region: 'منطقة المدينة المنورة'),

  // ── منطقة القصيم ─────────────────────────────────────
  SaudiCity(name: 'بريدة', region: 'منطقة القصيم'),
  SaudiCity(name: 'عنيزة', region: 'منطقة القصيم'),
  SaudiCity(name: 'الرس', region: 'منطقة القصيم'),
  SaudiCity(name: 'المذنب', region: 'منطقة القصيم'),
  SaudiCity(name: 'البكيرية', region: 'منطقة القصيم'),
  SaudiCity(name: 'رياض الخبراء', region: 'منطقة القصيم'),

  // ── منطقة الشرقية ────────────────────────────────────
  SaudiCity(name: 'الدمام', region: 'المنطقة الشرقية'),
  SaudiCity(name: 'الخبر', region: 'المنطقة الشرقية'),
  SaudiCity(name: 'الأحساء', region: 'المنطقة الشرقية'),
  SaudiCity(name: 'القطيف', region: 'المنطقة الشرقية'),
  SaudiCity(name: 'الجبيل', region: 'المنطقة الشرقية'),
  SaudiCity(name: 'حفر الباطن', region: 'المنطقة الشرقية'),
  SaudiCity(name: 'الخفجي', region: 'المنطقة الشرقية'),
  SaudiCity(name: 'أبقيق', region: 'المنطقة الشرقية'),
  SaudiCity(name: 'النعيرية', region: 'المنطقة الشرقية'),
  SaudiCity(name: 'رأس تنورة', region: 'المنطقة الشرقية'),

  // ── منطقة عسير ───────────────────────────────────────
  SaudiCity(name: 'أبها', region: 'منطقة عسير'),
  SaudiCity(name: 'خميس مشيط', region: 'منطقة عسير'),
  SaudiCity(name: 'بيشة', region: 'منطقة عسير'),
  SaudiCity(name: 'النماص', region: 'منطقة عسير'),
  SaudiCity(name: 'محايل عسير', region: 'منطقة عسير'),
  SaudiCity(name: 'سراة عبيدة', region: 'منطقة عسير'),
  SaudiCity(name: 'الحرجة', region: 'منطقة عسير'),

  // ── منطقة تبوك ───────────────────────────────────────
  SaudiCity(name: 'تبوك', region: 'منطقة تبوك'),
  SaudiCity(name: 'تيماء', region: 'منطقة تبوك'),
  SaudiCity(name: 'الوجه', region: 'منطقة تبوك'),
  SaudiCity(name: 'ضباء', region: 'منطقة تبوك'),

  // ── منطقة حائل ───────────────────────────────────────
  SaudiCity(name: 'حائل', region: 'منطقة حائل'),
  SaudiCity(name: 'بقعاء', region: 'منطقة حائل'),
  SaudiCity(name: 'الغزالة', region: 'منطقة حائل'),

  // ── منطقة الحدود الشمالية ─────────────────────────────
  SaudiCity(name: 'عرعر', region: 'منطقة الحدود الشمالية'),
  SaudiCity(name: 'رفحاء', region: 'منطقة الحدود الشمالية'),
  SaudiCity(name: 'طريف', region: 'منطقة الحدود الشمالية'),

  // ── منطقة جازان ──────────────────────────────────────
  SaudiCity(name: 'جازان', region: 'منطقة جازان'),
  SaudiCity(name: 'صبيا', region: 'منطقة جازان'),
  SaudiCity(name: 'أبو عريش', region: 'منطقة جازان'),
  SaudiCity(name: 'صامطة', region: 'منطقة جازان'),
  SaudiCity(name: 'الدرب', region: 'منطقة جازان'),

  // ── منطقة نجران ──────────────────────────────────────
  SaudiCity(name: 'نجران', region: 'منطقة نجران'),
  SaudiCity(name: 'شرورة', region: 'منطقة نجران'),

  // ── منطقة الباحة ─────────────────────────────────────
  SaudiCity(name: 'الباحة', region: 'منطقة الباحة'),
  SaudiCity(name: 'بلجرشي', region: 'منطقة الباحة'),
  SaudiCity(name: 'العقيق', region: 'منطقة الباحة'),

  // ── منطقة الجوف ──────────────────────────────────────
  SaudiCity(name: 'سكاكا', region: 'منطقة الجوف'),
  SaudiCity(name: 'القريات', region: 'منطقة الجوف'),
  SaudiCity(name: 'دومة الجندل', region: 'منطقة الجوف'),
];