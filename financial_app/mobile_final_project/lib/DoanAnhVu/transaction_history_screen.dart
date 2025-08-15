import 'package:final_project/DataConverter.dart';
import 'package:final_project/DoanAnhVu/transaction_filter_modal.dart';
import 'package:final_project/DoanAnhVu/services/transaction_filter_service.dart';
import 'package:final_project/DoanAnhVu/model/filter_data.dart';
import 'package:final_project/ThemeChanging_HaiAnh/current_theme.dart';
import 'package:final_project/ThemeChanging_HaiAnh/theme.dart';
import 'package:final_project/global_variable/number_format.dart';
import 'package:final_project/model/User.dart';
import 'package:flutter/material.dart';
import 'package:final_project/QuynhAnh_screens/add_transaction_screen.dart';
import 'package:final_project/DoanAnhVu/DTO/TransactionHistoryDTO.dart'; // Import model mới
import 'package:final_project/DoanAnhVu/services/transaction_service.dart';
import 'package:intl/intl.dart'; // Import service mới

// Dùng TransactionHistory thay vì Transaction cũ
class TransactionHistoryScreen extends StatefulWidget {
  final bool? showAppBar;
  TransactionHistoryScreen({this.showAppBar});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Dataconverter dtc =
      Dataconverter(); // Giữ lại nếu cần cho việc chuyển đổi màu
  final TransactionService _transactionService =
      TransactionService(); // Khởi tạo service

  List<TransactionHistory> _allTransactions =
      []; // Lưu trữ tất cả giao dịch từ API
  List<TransactionHistory> _filteredTransactions =
      []; // Danh sách giao dịch đã lọc
  bool isLoading = true;
  String _errorMessage = ''; // Để hiển thị lỗi nếu có

  // Re-enable FilterData usage
  FilterData _currentFilter = FilterData();
  int? _currentUserId; // Thay thế bằng ID người dùng thực tế

  @override
  void initState() {
    super.initState();
    _fetchTransactions(); // Gọi API khi khởi tạo màn hình
    _searchController.addListener(() {
      _applyFilters(); // Áp dụng bộ lọc khi có thay đổi tìm kiếm
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Phương thức để lấy dữ liệu từ API
  Future<void> _fetchTransactions() async {
    setState(() {
      isLoading = true;
      _errorMessage = '';
    });
    try {
      _currentUserId = await User.getStoredUserId();
      final fetchedTransactions = await _transactionService
          .getUserTransactionHistory(_currentUserId!);
      setState((
      ) {
        _allTransactions = fetchedTransactions;
        isLoading = false;
        _applyFilters(); // Áp dụng bộ lọc ngay sau khi tải dữ liệu
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        _errorMessage = 'Error loading transactions: ${e.toString()}';
        print(_errorMessage);
      });
    }
  }


  // Delete transaction function - Call API to delete transaction by ID
  Future<void> _deleteTransaction(int transactionId) async {
    try {
      // Show loading indicator during deletion
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              color: currentTheme.main_button_color,
            ),
          );
        },
      );

      // Call API to delete transaction
      final success = await _transactionService.deleteTransaction(transactionId);
      
      // Hide loading dialog
      Navigator.of(context).pop();

      if (success) {
        // Remove transaction from local lists to update UI immediately
        setState(() {
          _allTransactions.removeWhere((transaction) => 
              transaction.transactionID == transactionId);
          _applyFilters(); // Reapply filters to update filtered list
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaction deleted successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Show error message if deletion failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete transaction'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Hide loading dialog if still showing
      Navigator.of(context).pop();
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting transaction: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      print('Delete transaction error: ${e.toString()}');
    }
  }

  // Show confirmation dialog before deleting transaction
  Future<void> _showDeleteConfirmation(TransactionHistory transaction) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: currentTheme.sub_button_color,
          title: Text(
            'Delete Transaction',
            style: TextStyle(color: currentTheme.main_text_color),
          ),
        content: Text(
            'Are you sure you want to delete this transaction?\n\n'
            '${transaction.categoryType} - ${transaction.categoryName}\n'
            '${transaction.amount.toStringAsFixed(0)} VND',
            style: TextStyle(color: currentTheme.sub_text_color),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(color: currentTheme.sub_text_color),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    // If user confirmed deletion, proceed with delete
    if (shouldDelete == true) {
      await _deleteTransaction(transaction.transactionID);
    }
  }

  //// end of delete function

  // Phương thức để áp dụng tất cả các bộ lọc (tìm kiếm, loại, danh mục, ngày, số tiền)
  void _applyFilters() {
    // Use the TransactionFilterService to apply all filters
    final filtered = TransactionFilterService.applyFilters(
      _allTransactions,
      _currentFilter,
      _searchController.text,
    );

    setState(() {
      _filteredTransactions = filtered;
    });
  }

  Map<String, List<TransactionHistory>> get groupedTransactions {
    Map<String, List<TransactionHistory>> grouped = {};
    for (var transaction in _filteredTransactions) {
      String dateKey =
          '${transaction.transactionDate.day}/${transaction.transactionDate.month}/${transaction.transactionDate.year}';
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(transaction);
    }
    // Sắp xếp các key (ngày) theo thứ tự giảm dần
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        final formatter = DateFormat('dd/MM/yyyy');
        final dateA = formatter.parse(a);
        final dateB = formatter.parse(b);
        return dateB.compareTo(
          dateA,
        ); // Sắp xếp giảm dần (ngày gần nhất lên đầu)
      });

    // Tạo map mới với các key đã sắp xếp
    final sortedGrouped = <String, List<TransactionHistory>>{};
    for (final key in sortedKeys) {
      // Sắp xếp các giao dịch trong mỗi ngày theo thời gian (nếu có) hoặc theo id
      grouped[key]!.sort((a, b) => b.transactionID.compareTo(a.transactionID));
      sortedGrouped[key] = grouped[key]!;
    }
    return sortedGrouped;
  }

  // Check if any filters are active
  bool get hasActiveFilters {
    return _currentFilter.hasActiveFilters || _searchController.text.isNotEmpty;
  }

  Widget _buildSettingsMenu() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.settings, color: currentTheme.sub_text_color, size: 28),
      onSelected: (value) {
        if (value == 'signout') {
          Navigator.pop(context);
        }
      },
      color: currentTheme.sub_button_color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'signout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text(
                "Sign Out",
                style: TextStyle(color: currentTheme.main_text_color),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFilterModal() {
    // Get unique categories and types from current transactions
    final availableCategories = TransactionFilterService.getUniqueCategories(_allTransactions);
    final availableTypes = TransactionFilterService.getUniqueTypes(_allTransactions);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return TransactionFilterModal(
          currentFilter: _currentFilter,
          availableCategories: availableCategories,
          availableTypes: availableTypes,
          onApplyFilters: (filterData) {
            setState(() {
              _currentFilter = filterData;
            });
            _applyFilters(); // Áp dụng bộ lọc sau khi nhận dữ liệu từ modal
            Navigator.pop(context);
          },
        );
      },
    );
  }

  // Add method to clear filters
  void _clearFilters() {
    setState(() {
      _currentFilter.reset();
      _searchController.clear();
    });
    _applyFilters(); // Áp dụng bộ lọc để hiển thị lại tất cả giao dịch
  }

  // Helper method to show which filters are active
  String _getActiveFiltersText() {
    List<String> activeFilters = [];

    if (_searchController.text.isNotEmpty) {
      activeFilters.add('Search');
    }

    if (_currentFilter.selectedType != 'All types') {
      activeFilters.add(_currentFilter.selectedType);
    }

    if (_currentFilter.selectedCategory != 'All Categories') {
      activeFilters.add(_currentFilter.selectedCategory);
    }

    if (_currentFilter.startDate != null || _currentFilter.endDate != null) {
      activeFilters.add('Date range');
    }

    if (_currentFilter.minAmount != null || _currentFilter.maxAmount != null) {
      activeFilters.add('Amount range');
    }

    return activeFilters.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = currentTheme;

    return Scaffold(
      backgroundColor: theme.background_color,
      appBar: (widget.showAppBar == true)
          ? AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
                color: currentTheme.main_text_color,
              ),
              backgroundColor: currentTheme.background_color,
              elevation: 0,
              title: 
                  Text(
                    "Transaction\nHistory",
                    style: TextStyle(
                      color: currentTheme.main_text_color,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              actions: [
                IconButton(
                  icon: Icon(
                    (currentTheme == lightTheme)
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: currentTheme.sub_text_color,
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() {
                      currentTheme = (currentTheme == lightTheme)
                          ? darkTheme
                          : lightTheme;
                    });
                  },
                ),
                _buildSettingsMenu(),
                const SizedBox(width: 8),
              ],
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: theme.main_text_color),
              decoration: InputDecoration(
                hintText: 'Search transactions...',
                hintStyle: TextStyle(color: theme.sub_text_color),
                prefixIcon: Icon(Icons.search, color: theme.sub_text_color),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.sub_text_color.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.sub_text_color.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.main_button_color),
                ),
                filled: true,
                fillColor: theme.sub_button_color,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            alignment: AlignmentDirectional.topEnd,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Show clear filter button if filters are active
                if (hasActiveFilters)
                  TextButton.icon(
                    onPressed: _clearFilters,
                    icon: Icon(Icons.clear, size: 18, color: Colors.red),
                    label: Text(
                      "Clear Filter",
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                TextButton.icon(
                  onPressed: () => _showFilterModal(),
                  icon: Icon(
                    Icons.filter_list,
                    size: 18,
                    color: currentTheme.main_text_color,
                  ),
                  label: Text(
                    "Filter",
                    style: TextStyle(
                      fontSize: 18,
                      color: currentTheme.main_text_color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Show active filter indicator
          if (hasActiveFilters)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.main_button_color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.main_button_color.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    size: 16,
                    color: theme.main_button_color,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Filters active: ${_getActiveFiltersText()} (${_filteredTransactions.length} results)',
                      style: TextStyle(
                        color: theme.main_text_color,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 5),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: currentTheme.main_button_color,
                    ),
                  )
                : _errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                : groupedTransactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: theme.main_button_color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.bar_chart,
                            size: 40,
                            color: theme.main_button_color,
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          hasActiveFilters
                              ? 'No Matching Transactions'
                              : 'No Transactions Found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: theme.main_text_color,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          hasActiveFilters
                              ? 'Try adjusting your search or filters'
                              : 'No transactions available to display',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.sub_text_color,
                          ),
                        ),
                        if (hasActiveFilters) ...[
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _clearFilters,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.main_button_color,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Clear All Filters',
                              style: TextStyle(
                                color: theme.main_button_text_color,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: groupedTransactions.keys.length,
                    itemBuilder: (context, index) {
                      String dateKey = groupedTransactions.keys.elementAt(
                        index,
                      );
                      List<TransactionHistory> dayTransactions =
                          groupedTransactions[dateKey]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: theme.main_text_color,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  dateKey,
                                  style: TextStyle(
                                    color: theme.main_text_color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Wrap each transaction in Dismissible widget for swipe-to-delete functionality
                          ...dayTransactions.map(
                            (transaction) => Dismissible(
                              // Unique key for each transaction based on transaction ID
                              key: Key('transaction_${transaction.transactionID}'),
                              // Only allow left-to-right swipe for deletion
                              direction: DismissDirection.endToStart,
                              // Custom dismiss thresholds - require 40% swipe to trigger
                              dismissThresholds: const {
                                DismissDirection.endToStart: 0.4,
                              },
                              // Background widget shown while swiping (red background with delete icon)
                              background: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.red, // Red background for delete action
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.delete, // White garbage/delete icon
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Delete', // Delete text
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Handle dismiss action - show confirmation dialog
                              onDismissed: (direction) {
                                // This is called after the swipe is complete
                                // We don't actually delete here, we show confirmation first
                                _showDeleteConfirmation(transaction);
                              },
                              // Confirm dismiss - show confirmation dialog before actual deletion
                              confirmDismiss: (direction) async {
                                // Return false to prevent automatic dismissal
                                // We handle the deletion manually after confirmation
                                if (direction == DismissDirection.startToEnd) {
                                  // Show confirmation dialog and return the result
                                  final bool? shouldDelete = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: currentTheme.sub_button_color,
                                        title: Text(
                                          'Delete Transaction',
                                          style: TextStyle(color: currentTheme.main_text_color),
                                        ),
                                        content: Text(
                                          'Are you sure you want to delete this transaction?\n\n'
                                          '${transaction.categoryType} - ${transaction.categoryName}\n'
                                          '${transaction.amount.toStringAsFixed(0)} VND',
                                          style: TextStyle(color: currentTheme.sub_text_color),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(color: currentTheme.sub_text_color),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  // If user confirmed, proceed with API deletion
                                  if (shouldDelete == true) {
                                    await _deleteTransaction(transaction.transactionID);
                                    return true; // Allow dismissal
                                  }
                                  return false; // Cancel dismissal
                                }
                                return false;
                              },
                              // The actual transaction widget
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: theme.sub_button_color,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: theme.sub_text_color.withOpacity(0.1),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: dtc
                                            .hexToColor(transaction.colorCode)
                                            .withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        IconData(
                                          transaction.iconCode,
                                          fontFamily: 'MaterialIcons',
                                        ),
                                        color: dtc.hexToColor(
                                          transaction.colorCode,
                                        ),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            transaction
                                                .categoryType, // Hiển thị loại giao dịch
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: theme.main_text_color,
                                            ),
                                          ),
                                          Text(
                                            transaction
                                                .categoryName, // Hiển thị tên danh mục
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: theme.sub_text_color,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${transaction.isIncome ? '+' : '-'}${numFormat.format(transaction.amount)} VND',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: transaction.isIncome
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}