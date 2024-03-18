///
class DsFilters {
  final double threshold;
  final double? factor;
  ///
  const DsFilters({required this.threshold, this.factor});
  ///
  factory DsFilters.fromMap(Map<String, dynamic> map) {
    return DsFilters(
      threshold: map['threshold'], 
      factor: map['factor'],
    );
  }
  ///
  Map<String, dynamic> toMap() => {
    'threshold': threshold,
    if(factor != null)
      'factor': factor,
  };
}