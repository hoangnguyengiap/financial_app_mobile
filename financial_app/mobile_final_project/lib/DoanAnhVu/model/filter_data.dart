class FilterData {
  String selectedType;
  String selectedCategory;
  DateTime? startDate;
  DateTime? endDate;
  double? minAmount;
  double? maxAmount;

  FilterData({
    this.selectedType = 'All types',
    this.selectedCategory = 'All Categories',
    this.startDate,
    this.endDate,
    this.minAmount,
    this.maxAmount,
  });

  FilterData copyWith({
    String? selectedType,
    String? selectedCategory,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
  }) {
    return FilterData(
      selectedType: selectedType ?? this.selectedType,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
    );
  }

  bool get hasActiveFilters {
    return selectedType != 'All types' ||
        selectedCategory != 'All Categories' ||
        startDate != null ||
        endDate != null ||
        minAmount != null ||
        maxAmount != null;
  }

  void reset() {
    selectedType = 'All types';
    selectedCategory = 'All Categories';
    startDate = null;
    endDate = null;
    minAmount = null;
    maxAmount = null;
  }
}