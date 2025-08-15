import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:final_project/ThemeChanging_HaiAnh/current_theme.dart';
import 'package:final_project/DoanAnhVu/model/filter_data.dart';

class TransactionFilterModal extends StatefulWidget {
  final FilterData currentFilter;
  final Function(FilterData) onApplyFilters;
  final List<String> availableCategories;
  final List<String> availableTypes;

  const TransactionFilterModal({
    Key? key,
    required this.currentFilter,
    required this.onApplyFilters,
    required this.availableCategories,
    required this.availableTypes,
  }) : super(key: key);

  @override
  State<TransactionFilterModal> createState() => _TransactionFilterModalState();
}

class _TransactionFilterModalState extends State<TransactionFilterModal> {
  late FilterData _filterData;
  final TextEditingController _minAmountController = TextEditingController();
  final TextEditingController _maxAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filterData = FilterData(
      selectedType: widget.currentFilter.selectedType,
      selectedCategory: widget.currentFilter.selectedCategory,
      startDate: widget.currentFilter.startDate,
      endDate: widget.currentFilter.endDate,
      minAmount: widget.currentFilter.minAmount,
      maxAmount: widget.currentFilter.maxAmount,
    );
    
    if (_filterData.minAmount != null) {
      _minAmountController.text = _filterData.minAmount!.toStringAsFixed(0);
    }
    if (_filterData.maxAmount != null) {
      _maxAmountController.text = _filterData.maxAmount!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate 
          ? (_filterData.startDate ?? DateTime.now()) 
          : (_filterData.endDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: currentTheme.main_button_color,
              onPrimary: currentTheme.main_button_text_color,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _filterData.startDate = picked;
        } else {
          _filterData.endDate = picked;
        }
      });
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: currentTheme.main_text_color,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: currentTheme.sub_button_color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: currentTheme.sub_text_color.withOpacity(0.3),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: TextStyle(color: currentTheme.sub_text_color)),
          isExpanded: true,
          dropdownColor: currentTheme.sub_button_color,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(color: currentTheme.main_text_color),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: currentTheme.main_text_color,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: currentTheme.sub_button_color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: currentTheme.sub_text_color.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: currentTheme.sub_text_color,
                ),
                const SizedBox(width: 12),
                Text(
                  selectedDate != null
                      ? DateFormat('MMM dd, yyyy').format(selectedDate)
                      : 'Select date',
                  style: TextStyle(
                    color: selectedDate != null
                        ? currentTheme.main_text_color
                        : currentTheme.sub_text_color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountInput({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: currentTheme.main_text_color,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(color: currentTheme.main_text_color),
          decoration: InputDecoration(
            prefixText: 'VND ',
            prefixStyle: TextStyle(color: currentTheme.main_text_color),
            filled: true,
            fillColor: currentTheme.sub_button_color,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: currentTheme.sub_text_color.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: currentTheme.sub_text_color.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: currentTheme.main_button_color),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: currentTheme.background_color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: currentTheme.sub_text_color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Text(
                  'Filter Transactions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: currentTheme.main_text_color,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filterData.reset();
                      _minAmountController.clear();
                      _maxAmountController.clear();
                    });
                  },
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: currentTheme.main_button_color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Filter options
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transaction Type
                  _buildSectionTitle('Transaction Type'),
                  _buildDropdown(
                    value: _filterData.selectedType,
                    items: ['All types', ...widget.availableTypes],
                    onChanged: (value) {
                      setState(() {
                        _filterData.selectedType = value!;
                      });
                    },
                    hint: 'Select type',
                  ),
                  
                  // Category
                  _buildSectionTitle('Category'),
                  _buildDropdown(
                    value: _filterData.selectedCategory,
                    items: ['All Categories', ...widget.availableCategories],
                    onChanged: (value) {
                      setState(() {
                        _filterData.selectedCategory = value!;
                      });
                    },
                    hint: 'Select category',
                  ),
                  
                  // Date Range
                  _buildSectionTitle('Date Range'),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateSelector(
                          label: 'From',
                          selectedDate: _filterData.startDate,
                          onTap: () => _selectDate(context, true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDateSelector(
                          label: 'To',
                          selectedDate: _filterData.endDate,
                          onTap: () => _selectDate(context, false),
                        ),
                      ),
                    ],
                  ),
                  
                  // Amount Range
                  _buildSectionTitle('Amount Range'),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAmountInput(
                          label: 'Min Amount',
                          controller: _minAmountController,
                          onChanged: (value) {
                            _filterData.minAmount = double.tryParse(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAmountInput(
                          label: 'Max Amount',
                          controller: _maxAmountController,
                          onChanged: (value) {
                            _filterData.maxAmount = double.tryParse(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          
          // Action buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: currentTheme.background_color,
              border: Border(
                top: BorderSide(
                  color: currentTheme.sub_text_color.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(color: currentTheme.main_button_color),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: currentTheme.main_button_color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApplyFilters(_filterData);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentTheme.main_button_color,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Apply Filters',
                      style: TextStyle(
                        color: currentTheme.main_button_text_color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}