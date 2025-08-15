// import 'package:final_project/DataConverter.dart';
// import 'package:final_project/ThemeChanging_HaiAnh/current_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:final_project/DoanAnhVu/transaction_history_screen.dart'; // Import Transaction model
// import 'package:final_project/DoanAnhVu/model/Transaction.dart';
// import 'package:final_project/DoanAnhVu/services/transaction_service.dart';

// class AddTransactionScreen extends StatefulWidget {
//   final bool? showTabbar;
//   AddTransactionScreen({this.showTabbar});

//   @override
//   State<AddTransactionScreen> createState() => _AddTransactionScreenState();
// }

// class _AddTransactionScreenState extends State<AddTransactionScreen> {
//   bool _isIncome = true;
//   final TextEditingController _amountController = TextEditingController();
//   final TextEditingController _notesController = TextEditingController();
//   String? _selectedCategory;
//   DateTime _selectedDate = DateTime.now();
//   final Dataconverter dtc = Dataconverter();
//   final _formKey = GlobalKey<FormState>();

//   final List<String> _categories = [
//     'Food',
//     'Transport',
//     'Shopping',
//     'Utilities',
//     'Salary',
//     'Gift',
//     'Investment',
//     'Other',
//   ];

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _amountController.dispose();
//     _notesController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: currentTheme.background_color,
//       appBar: (widget.showTabbar == true)? AppBar(
//         backgroundColor: currentTheme.tab_bar_color,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: currentTheme.main_button_text_color,
//           ),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           'Add Transaction',
//           style: TextStyle(color: currentTheme.main_button_text_color),
//         ),
//       ):null,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Transaction Details',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: currentTheme.main_text_color,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Transaction Type',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: currentTheme.sub_text_color,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 _buildTransactionTypeToggle(),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Amount',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: currentTheme.sub_text_color,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 _buildAmountField(),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Category',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: currentTheme.sub_text_color,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 _buildCategoryDropdown(),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Date',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: currentTheme.sub_text_color,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 _buildDatePicker(),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Notes (Optional)',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: currentTheme.sub_text_color,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 _buildNotesField(),
//                 const SizedBox(height: 30),
//                 _buildSubmitButton(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTransactionTypeToggle() {
//     return Container(
//       decoration: BoxDecoration(
//         color: currentTheme.sub_button_color,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: GestureDetector(
//               onTap: () => setState(() => _isIncome = false),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 decoration: BoxDecoration(
//                   color: !_isIncome
//                       ? currentTheme.main_button_color
//                       : Colors.transparent,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   '- Expense',
//                   style: TextStyle(
//                     color: !_isIncome
//                         ? currentTheme.main_button_text_color
//                         : currentTheme.main_text_color,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: GestureDetector(
//               onTap: () => setState(() => _isIncome = true),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 decoration: BoxDecoration(
//                   color: _isIncome
//                       ? currentTheme.main_button_color
//                       : Colors.transparent,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   '+ Income',
//                   style: TextStyle(
//                     color: _isIncome
//                         ? currentTheme.main_button_text_color
//                         : currentTheme.main_text_color,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAmountField() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: currentTheme.sub_button_color,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: TextFormField(
//         controller: _amountController,
//         keyboardType: const TextInputType.numberWithOptions(decimal: true),
//         inputFormatters: [
//           FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
//         ],
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//           color: currentTheme.main_text_color,
//         ),
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           hintText: '0.00',
//           hintStyle: TextStyle(color: currentTheme.sub_text_color),
//           suffixIcon: Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: Text(
//               'VND',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: currentTheme.sub_text_color,
//               ),
//             ),
//           ),
//           suffixIconConstraints: const BoxConstraints(
//             minWidth: 0,
//             minHeight: 0,
//           ),
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) return 'Amount is required';
//           final amount = double.tryParse(value);
//           if (amount == null || amount <= 0) return 'Enter a valid amount';
//           return null;
//         },
//       ),
//     );
//   }

//   Widget _buildCategoryDropdown() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: currentTheme.sub_button_color,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: DropdownButtonFormField<String>(
//         value: _selectedCategory,
//         decoration: const InputDecoration(border: InputBorder.none),
//         hint: Text(
//           'Select a category',
//           style: TextStyle(color: currentTheme.sub_text_color),
//         ),
//         icon: Icon(Icons.arrow_drop_down, color: currentTheme.sub_text_color),
//         onChanged: (String? newValue) =>
//             setState(() => _selectedCategory = newValue),
//         style: TextStyle(color: currentTheme.main_text_color),
//         dropdownColor: currentTheme.sub_button_color,
//         items: _categories.map<DropdownMenuItem<String>>((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(
//               value,
//               style: TextStyle(color: currentTheme.main_text_color),
//             ),
//           );
//         }).toList(),
//         validator: (value) => value == null ? 'Please select a category' : null,
//       ),
//     );
//   }

//   Widget _buildDatePicker() {
//     return GestureDetector(
//       onTap: () => _selectDate(context),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: currentTheme.sub_button_color,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               '${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.year}',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: currentTheme.main_text_color,
//               ),
//             ),
//             Icon(Icons.calendar_today, color: currentTheme.sub_text_color),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNotesField() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: currentTheme.sub_button_color,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: TextFormField(
//         controller: _notesController,
//         maxLines: 3,
//         style: TextStyle(color: currentTheme.main_text_color),
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           hintText: 'Add a note...',
//           hintStyle: TextStyle(color: currentTheme.sub_text_color),
//         ),
//         validator: (value) {
//           if (value != null && value.length > 200) {
//             return 'Notes can\'t exceed 200 characters';
//           }
//           return null;
//         },
//       ),
//     );
//   }

//   Widget _buildSubmitButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: () {
//           if (_formKey.currentState!.validate()) {
//             final newTransaction = Transaction(
//               id: DateTime.now().millisecondsSinceEpoch.toString(),
//               type: _selectedCategory ?? 'Other',
//               category: _notesController.text.isNotEmpty
//                   ? _notesController.text
//                   : 'No note',
//               amount: double.parse(_amountController.text),
//               date: _selectedDate,
//               icon: _isIncome ? Icons.attach_money.codePoint : Icons.shopping_cart.codePoint,
//               iconColor: _isIncome ? dtc.colorToHex(Colors.green) : dtc.colorToHex(Colors.red),
//               isIncome: _isIncome,
//             );
//             ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text("sucess")),
//                       );
//             Navigator.push(context
//             , MaterialPageRoute(builder: (builder) => TransactionHistoryScreen(showAppBar: true,)));
//           }
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: currentTheme.main_button_color,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         child: Text(
//           _isIncome ? 'Add Income' : 'Add Expense',
//           style: TextStyle(
//             fontSize: 18,
//             color: currentTheme.main_button_text_color,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }
// lib/DoanAnhVu/add_transaction_screen.dart (Cập nhật)

import 'package:final_project/DataConverter.dart';
import 'package:final_project/ThemeChanging_HaiAnh/current_theme.dart';
import 'package:final_project/model/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:final_project/DoanAnhVu/transaction_history_screen.dart';
import 'package:final_project/DoanAnhVu/model/transaction.dart';
import 'package:final_project/DoanAnhVu/services/transaction_service.dart';
import 'package:final_project/DoanAnhVu/services/category_service.dart'; // Import CategoryService mới
import 'package:final_project/DoanAnhVu/DTO/CategorySimpleDTO.dart'; // Import CategorySimpleDTO mới

class AddTransactionScreen extends StatefulWidget {
  final bool? showTabbar;
  AddTransactionScreen({this.showTabbar});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  int? userID;
  bool _isIncome = true;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  

  // Thay đổi để lưu trữ CategorySimpleDTO thay vì chỉ String tên
  CategorySimpleDTO? _selectedCategory;

  DateTime _selectedDate = DateTime.now();
  final Dataconverter dtc = Dataconverter();
  final _formKey = GlobalKey<FormState>();

  final TransactionService _transactionService = TransactionService();
  final CategoryService _categoryService =
      CategoryService(); // Khởi tạo CategoryService

  List<CategorySimpleDTO> _incomeCategories = [];
  List<CategorySimpleDTO> _expenseCategories = [];
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // Hàm để tải danh mục từ API
  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });
    try {
      userID = await User.getStoredUserId();
      final incomeCats = await _categoryService.getIncomeCategories(userID!);
      final expenseCats = await _categoryService.getExpenseCategories(userID!);
      setState(() {
        _incomeCategories = incomeCats;
        _expenseCategories = expenseCats;
        _isLoadingCategories = false;
        // Đặt danh mục mặc định ban đầu nếu có
        if (_isIncome && _incomeCategories.isNotEmpty) {
          _selectedCategory = _incomeCategories.first;
        } else if (!_isIncome && _expenseCategories.isNotEmpty) {
          _selectedCategory = _expenseCategories.first;
        }
      });
    } catch (e) {
      print('Error loading categories: $e');
      setState(() {
        _isLoadingCategories = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Categories cannot be loaded: $e")));
    }
  }

  void _onTransactionTypeChanged(bool isIncome) {
    setState(() {
      _isIncome = isIncome;
      // Khi loại giao dịch thay đổi, reset category và chọn lại category mặc định
      _selectedCategory = null;
      if (_isIncome && _incomeCategories.isNotEmpty) {
        _selectedCategory = _incomeCategories.first;
      } else if (!_isIncome && _expenseCategories.isNotEmpty) {
        _selectedCategory = _expenseCategories.first;
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitTransaction() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Please select a category")));
        return;
      }

      final double amount = double.parse(_amountController.text);
      final String note = _notesController.text.isNotEmpty
          ? _notesController.text
          : 'No note';
      final int userId =
          userID!;
      final int categoryId =
          _selectedCategory!.categoryId; // Lấy categoryId từ đối tượng đã chọn

      final newTransaction = Transaction(
        amount: amount,
        date: _selectedDate,
        note: note,
        isIncome: _isIncome,
        userId: userId,
        categoryId: categoryId,
      );

      final String results = await _transactionService.createTransaction(
        newTransaction,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(results)));

      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => TransactionHistoryScreen(showAppBar: true,)));
      if (results.contains("Succeed")) {
        setState(() {
          _amountController.clear();
          _notesController.clear();
          _selectedDate = DateTime.now();
          _isIncome = true;
          if (_incomeCategories.isNotEmpty) {
            _selectedCategory = _incomeCategories.first;
          } else {
            _selectedCategory = null;
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentTheme.background_color,
      appBar: (widget.showTabbar == true)
          ? AppBar(
              backgroundColor: currentTheme.tab_bar_color,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: currentTheme.main_button_text_color,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'Add Transaction',
                style: TextStyle(color: currentTheme.main_button_text_color),
              ),
            )
          : null,
      body: _isLoadingCategories
          ? Center(
              child: CircularProgressIndicator(
                color: currentTheme.main_button_color,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: currentTheme.main_text_color,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Transaction Type',
                        style: TextStyle(
                          fontSize: 16,
                          color: currentTheme.sub_text_color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTransactionTypeToggle(),
                      const SizedBox(height: 20),
                      Text(
                        'Amount',
                        style: TextStyle(
                          fontSize: 16,
                          color: currentTheme.sub_text_color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildAmountField(),
                      const SizedBox(height: 20),
                      Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 16,
                          color: currentTheme.sub_text_color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildCategoryDropdown(),
                      const SizedBox(height: 20),
                      Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 16,
                          color: currentTheme.sub_text_color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDatePicker(),
                      const SizedBox(height: 20),
                      Text(
                        'Notes (Optional)',
                        style: TextStyle(
                          fontSize: 16,
                          color: currentTheme.sub_text_color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildNotesField(),
                      const SizedBox(height: 30),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTransactionTypeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: currentTheme.sub_button_color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _onTransactionTypeChanged(false), // Gọi hàm mới
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isIncome
                      ? currentTheme.main_button_color
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  '- Expense',
                  style: TextStyle(
                    color: !_isIncome
                        ? currentTheme.main_button_text_color
                        : currentTheme.main_text_color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _onTransactionTypeChanged(true), // Gọi hàm mới
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isIncome
                      ? currentTheme.main_button_color
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  '+ Income',
                  style: TextStyle(
                    color: _isIncome
                        ? currentTheme.main_button_text_color
                        : currentTheme.main_text_color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: currentTheme.sub_button_color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: _amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: currentTheme.main_text_color,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '0.00',
          hintStyle: TextStyle(color: currentTheme.sub_text_color),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              'VND',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: currentTheme.sub_text_color,
              ),
            ),
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Amount is required';
          final amount = double.tryParse(value);
          if (amount == null || amount <= 0) return 'Enter a valid amount';
          return null;
        },
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    // Chọn danh sách danh mục phù hợp (income hoặc expense)
    final List<CategorySimpleDTO> categoriesToShow = _isIncome
        ? _incomeCategories
        : _expenseCategories;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: currentTheme.sub_button_color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<CategorySimpleDTO>(
        value: _selectedCategory,
        decoration: const InputDecoration(border: InputBorder.none),
        hint: Text(
          'Select a category',
          style: TextStyle(color: currentTheme.sub_text_color),
        ),
        icon: Icon(Icons.arrow_drop_down, color: currentTheme.sub_text_color),
        onChanged: (CategorySimpleDTO? newValue) =>
            setState(() => _selectedCategory = newValue),
        style: TextStyle(color: currentTheme.main_text_color),
        dropdownColor: currentTheme.sub_button_color,
        items: categoriesToShow.map<DropdownMenuItem<CategorySimpleDTO>>((
          CategorySimpleDTO category,
        ) {
          return DropdownMenuItem<CategorySimpleDTO>(
            value: category,
            child: Row(
              children: [
                Icon(
                  IconData(category.iconCode, fontFamily: 'MaterialIcons'),
                  color: dtc.hexToColor(category.iconColor),
                ),
                SizedBox(width: 10),
                Text(
                  category.categoryName,
                  style: TextStyle(color: currentTheme.main_text_color),
                ),
              ],
            ),
          );
        }).toList(),
        validator: (value) => value == null ? 'Please select a category' : null,
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: currentTheme.sub_button_color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.year}',
              style: TextStyle(
                fontSize: 16,
                color: currentTheme.main_text_color,
              ),
            ),
            Icon(Icons.calendar_today, color: currentTheme.sub_text_color),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: currentTheme.sub_button_color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: _notesController,
        maxLines: 3,
        style: TextStyle(color: currentTheme.main_text_color),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Add a note...',
          hintStyle: TextStyle(color: currentTheme.sub_text_color),
        ),
        validator: (value) {
          if (value != null && value.length > 200) {
            return 'Notes can\'t exceed 200 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitTransaction,
        style: ElevatedButton.styleFrom(
          backgroundColor: currentTheme.main_button_color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          _isIncome ? 'Add Income' : 'Add Expense',
          style: TextStyle(
            fontSize: 18,
            color: currentTheme.main_button_text_color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
