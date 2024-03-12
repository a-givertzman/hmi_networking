class DsFilters {
  final double? threshold;
  final double? factor;
  ///
  const DsFilters({this.threshold, this.factor});
  ///
  factory DsFilters.fromMap(Map<String, dynamic> map) {
    return DsFilters(
      threshold: map['threshold'], 
      factor: map['factor'],
    );
  }
}