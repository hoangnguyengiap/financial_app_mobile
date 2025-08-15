import 'package:final_project/DataConverter.dart';
import 'package:final_project/model/User.dart';
import 'package:final_project/screens_Giap/service/category_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../ThemeChanging_HaiAnh/current_theme.dart';
import '../model/Category.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  int? userID;
  List<Category> _categories = [];
  final category_service categoryService = category_service();
  final TextEditingController _nameController = TextEditingController();
  final Dataconverter converter = Dataconverter();

  IconData? _selectedIcon;
  Color _selectedColor = const Color(0xFFFF6B6B);
  String? _selectedType;
  int? selectedCategory;

  final List<IconData> commonIcons = [
    Icons.fastfood,
    Icons.directions_car,
    Icons.shopping_bag,
    Icons.lightbulb,
    Icons.movie,
    Icons.attach_money,
    Icons.home,
    Icons.smartphone,
    Icons.medical_services,
    Icons.school,
    Icons.flight,
    Icons.sports_esports,
  ];

  final List<Color> commonColors = [
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFF45B7D1),
    Color(0xFF96CEB4),
    Color(0xFFFFEAA7),
    Color(0xFFDDA0DD),
    Color(0xFFFFB6C1),
    Color(0xFF98D8C8),
  ];

  void _fetchCategories() async {
    userID = await User.getStoredUserId();
    final result = await categoryService.getCategoriesList(userID!);
    setState(() {
      _categories = result;
    });
  }

  Future<String> _fetchAddCategory(
    String name,
    String type,
    int iconCode,
    String colorCode,
  ) async {
    String result = await categoryService.addCategory(
      userID!,
      name,
      type,
      iconCode,
      colorCode,
    );
    return result;
  }

  Future<String> _fetchUpdateCategory(
    int id,
    String name,
    int iconCode,
    String colorCode,
  ) async {
    String result = await categoryService.editCategory(
      id,
      name,
      iconCode,
      colorCode,
    );
    return result;
  }

  Future<String> _fetchDeleteCategory(int id) async {
    String result = await categoryService.deleteCategory(id);
    return result;
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _showCategoryDialog({Category? existing}) {
    final theme = currentTheme;
    final _formKey = GlobalKey<FormState>();
    bool _showIconError = false;
    bool _showTypeError = false;

    _nameController.text = existing?.name ?? '';
    _selectedIcon = existing?.icon;
    _selectedColor = existing?.color ?? const Color(0xFFFF6B6B);
    _selectedType = existing?.type;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          backgroundColor: Colors.grey[100],
          title: Text(
            existing == null ? "Add New Category" : "Edit Category",
            style: TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (existing == null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Category Type",
                          style: TextStyle(color: Colors.black),
                        ),
                        Row(
                          children: ["Income", "Expense"].map((type) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<String>(
                                  value: type,
                                  groupValue: _selectedType,
                                  onChanged: (value) {
                                    setStateDialog(() {
                                      _selectedType = value;
                                      _showTypeError = false;
                                    });
                                  },
                                ),
                                Text(type),
                              ],
                            );
                          }).toList(),
                        ),
                        if (_showTypeError)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Please select a type",
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    )
                  else
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "Type: ${existing.type}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Category Name",
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.main_button_color),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter category name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Choose Icon",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: commonIcons.map((icon) {
                      final isSelected = _selectedIcon == icon;
                      return RawChip(
                        label: Icon(
                          icon,
                          size: 20,
                          color: isSelected
                              ? Colors.white
                              : theme.main_text_color,
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          setStateDialog(() {
                            _selectedIcon = icon;
                            _showIconError = false;
                          });
                        },
                        selectedColor: Colors.lightBlueAccent,
                        backgroundColor: theme.background_color,
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }).toList(),
                  ),
                  if (_showIconError)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Please select an icon",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Choose Color",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: commonColors.map((color) {
                      return GestureDetector(
                        onTap: () =>
                            setStateDialog(() => _selectedColor = color),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedColor == color
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: theme.main_button_color),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.main_button_color,
              ),
              onPressed: () async {
                bool formValid = _formKey.currentState!.validate();
                bool iconValid = _selectedIcon != null;
                bool typeValid = existing != null || _selectedType != null;

                setStateDialog(() {
                  _showIconError = !iconValid;
                  _showTypeError = !typeValid;
                });

                if (!formValid || !iconValid || !typeValid) return;

                final name = _nameController.text.trim();
                final nameExists = _categories.any(
                  (cat) =>
                      cat.name.toLowerCase() == name.toLowerCase() &&
                      (existing == null || cat.id != existing.id),
                );

                if (nameExists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Name already exists')),
                  );
                  return;
                }

                if (existing != null) {
                  final result = await _fetchUpdateCategory(
                    selectedCategory!,
                    name,
                    _selectedIcon!.codePoint,
                    converter.colorToHex(_selectedColor),
                  );
                  _fetchCategories();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(result)));
                } else {
                  final result = await _fetchAddCategory(
                    name,
                    _selectedType!,
                    _selectedIcon!.codePoint,
                    converter.colorToHex(_selectedColor),
                  );
                  _fetchCategories();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(result)));
                }

                Navigator.pop(context);
              },
              child: Text(
                existing == null ? "Add" : "Save",
                style: TextStyle(color: theme.main_button_text_color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = currentTheme;

    return Scaffold(
      backgroundColor: theme.background_color,
      appBar: AppBar(
        title: Text(
          "Category Management",
          style: TextStyle(color: theme.main_text_color),
        ),
        backgroundColor: theme.background_color,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: theme.main_button_color),
            onPressed: () => _showCategoryDialog(),
          ),
        ],
      ),
      body: _categories.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.folder_open,
                    size: 48,
                    color: theme.sub_text_color,
                  ),
                  Text(
                    "No Categories Yet",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.main_text_color,
                    ),
                  ),
                  Text(
                    "Add your first category to get started",
                    style: TextStyle(color: theme.sub_text_color),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Card(
                  color: theme.sub_button_color,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: category.color,
                      child: Icon(
                        category.icon,
                        color: currentTheme.sub_button_color,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      category.name,
                      style: TextStyle(color: theme.main_text_color),
                    ),
                    subtitle: Text(
                      category.type,
                      style: TextStyle(color: theme.sub_text_color),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: theme.main_button_color,
                          ),
                          onPressed: () {
                            selectedCategory = int.parse(_categories[index].id);
                            _showCategoryDialog(existing: category);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: theme.main_button_color.withOpacity(0.7),
                          ),
                          onPressed: () async {
                            final result = await _fetchDeleteCategory(
                              int.parse(_categories[index].id),
                            );
                            setState(() {
                              _categories.removeAt(index);
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text(result)));
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
