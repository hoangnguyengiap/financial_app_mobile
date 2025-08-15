// Import class TransactionHistoryDTO chứa thông tin 1 giao dịch cụ thể
import 'package:final_project/DoanAnhVu/DTO/TransactionHistoryDTO.dart';
// Import class FilterData chứa tiêu chí lọc được chọn bởi người dùng
import 'package:final_project/DoanAnhVu/model/filter_data.dart';
class TransactionFilterService {
  static List<TransactionHistory> applyFilters(
    List<TransactionHistory> transactions,
    FilterData filterData,
    String searchQuery,
  ) {
    List<TransactionHistory> filtered = List.from(transactions);

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((transaction) {
        return transaction.categoryName.toLowerCase().contains(searchQuery.toLowerCase()) ||
            transaction.categoryType.toLowerCase().contains(searchQuery.toLowerCase()) ||
            transaction.amount.toString().contains(searchQuery);
      }).toList();
    }

    // Apply type filter
    if (filterData.selectedType != 'All types') {
      filtered = filtered.where((transaction) {
        return transaction.categoryType == filterData.selectedType;
      }).toList();
    }

    // Apply category filter
    if (filterData.selectedCategory != 'All Categories') {
      filtered = filtered.where((transaction) {
        return transaction.categoryName == filterData.selectedCategory;
      }).toList();
    }

    // Apply date range filter
    if (filterData.startDate != null) {
      filtered = filtered.where((transaction) {
        return transaction.transactionDate.isAfter(
          filterData.startDate!.subtract(const Duration(days: 1)),
        );
      }).toList();
    }

    if (filterData.endDate != null) {
      filtered = filtered.where((transaction) {
        return transaction.transactionDate.isBefore(
          filterData.endDate!.add(const Duration(days: 1)),
        );
      }).toList();
    }

    // Apply amount range filter
    if (filterData.minAmount != null) {
      filtered = filtered.where((transaction) {
        return transaction.amount >= filterData.minAmount!;
      }).toList();
    }

    if (filterData.maxAmount != null) {
      filtered = filtered.where((transaction) {
        return transaction.amount <= filterData.maxAmount!;
      }).toList();
    }

    // Apply default sorting: Date descending (latest first)
    filtered.sort((a, b) {
      return b.transactionDate.compareTo(a.transactionDate);
    });

    return filtered;
  }

  static List<String> getUniqueCategories(List<TransactionHistory> transactions) {
    return transactions
        .map((t) => t.categoryName)
        .toSet()
        .toList()
        ..sort();
  }

  static List<String> getUniqueTypes(List<TransactionHistory> transactions) {
    return transactions
        .map((t) => t.categoryType)
        .toSet()
        .toList()
        ..sort();
  }
}