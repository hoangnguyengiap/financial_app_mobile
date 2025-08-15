import 'package:final_project/BudgetPlanningScreen_HaiAnh/PrefixScreen.dart';
import 'package:final_project/global_variable/number_format.dart';
import 'package:final_project/model/Budget.dart';
import 'package:final_project/BudgetPlanningScreen_HaiAnh/service/budget_service.dart';
import 'package:final_project/ThemeChanging_HaiAnh/current_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'AddBudgetScreen.dart';
import 'package:final_project/model/User.dart';

class BudgetPlanning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentTheme.background_color,
      body: BudgetPlanningBody(),
    );
  }
}


class BudgetPlanningBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BudgetPlannignBodyState();
}



class _BudgetPlannignBodyState extends State<BudgetPlanningBody> {
  int? userID;
  int? editingIndex;
  final TextEditingController editingController = TextEditingController();
  final budgetService = budget_service();
  bool isLoading = false;
  List<Budget>? allBudgets;

  final DateFormat dateFormat = DateFormat("MM/yyyy");
  DateTime currentDate = DateTime.now();
  DateTime pickedDate = DateTime.now();

  bool isEditable(DateTime date) {
    final now = currentDate;
    final lastMonth = DateTime(now.year, now.month - 1);
    return (date.year == now.year && date.month == now.month) ||
        (date.year == lastMonth.year && date.month == lastMonth.month);
  }

  void _loadInitialBudgets() async {
    setState(() {
      isLoading = true;
    });

    userID = await User.getStoredUserId();
    print("Loaded userId: $userID");

    final budgets = await budgetService.getbudgetList(
      userID!,
      pickedDate.month,
      pickedDate.year,
    );

    setState(() {
      allBudgets = budgets;
      isLoading = false;
    });
  }

  void _showMonthPicker() async {
    final selected = await showMonthPicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(currentDate.year - 1,currentDate.month),
      lastDate: currentDate,
    );
    if (selected != null) {
      setState(() {
        isLoading = true;
      });

      final budgets = await budgetService.getbudgetList(
        userID!,
        selected.month,
        selected.year,
      );

      setState(() {
        pickedDate = selected;
        allBudgets = budgets;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadInitialBudgets();
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }


  Widget _screenIfNoBudgetExist() {
    if (isLoading) {
      return Center(child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 30,),
          Text("First few run might take a while, please wait...", style: TextStyle(
            color: currentTheme.main_text_color,
            fontWeight: FontWeight.bold,
            fontSize: 15
            ),
          )
        ],
      ));
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.radio_button_checked, size: 200, color: Colors.deepPurple),

          const SizedBox(height: 5),

            Text(
              "No Budgets Set In ${pickedDate.month}/${pickedDate.year}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: currentTheme.main_text_color),
            ),

          if(isEditable(pickedDate)) ...[
            Text("Create your first budget to track spending!", style: TextStyle(color: currentTheme.main_text_color),),

            const SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => AddBudgetScreen(selectedMonthFromPlanningScreen: pickedDate,))
                  ).then((result){
                    if(result == true){
                      setState(() {
                        _loadInitialBudgets();
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: currentTheme.main_button_color),
                child: Text("Set New Budget +", style: TextStyle(color: currentTheme.main_button_text_color)),
              ),
            ),

            const SizedBox(height: 5,),

            TextButton.icon(
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (builder) => PrefixScreen(pickedDate: pickedDate,))
                ).then((result) async {
                  if(result == true){
                    await Future.delayed(Duration(seconds: 2));
                    _loadInitialBudgets();
                  }
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: currentTheme.sub_button_color,
                side: BorderSide(color: currentTheme.sub_button_text_color, width: 2),
              ), 
              icon: Icon(Icons.build_circle, color: currentTheme.sub_button_text_color,),
              label: Text("Prefix", style: TextStyle(color: currentTheme.sub_button_text_color),),
            ),
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //If no budget found will return a blank page
    if (allBudgets == null || allBudgets!.isEmpty) {
      return Column(
        children: [
            Container(
              width: 400,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.fromLTRB(20,20,20,10),
              decoration: BoxDecoration(
                  gradient: currentTheme.elevated_background_color,
                  boxShadow: const [BoxShadow(color: Colors.grey, spreadRadius: 2, blurRadius: 6)],
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Monthly Overview", 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 20,
                      color: Colors.white70
                    )
                  ),
                  TextButton.icon(
                    onPressed: _showMonthPicker,
                    icon: const Icon(Icons.calendar_today, color: Colors.white),
                    label: Text(
                      dateFormat.format(pickedDate),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            _screenIfNoBudgetExist()
        ],
      );
    }

    double totalBudget = allBudgets!.fold(0.0, (total, budget) => total + budget.amount);
    double totalSpent = allBudgets!.fold(0.0, (total, budget) => total + budget.spentAmount);
    double remaining = totalBudget - totalSpent;

    return Column(
      children: [
        

        //Monthly Overview
        Container(
          width: 400,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.fromLTRB(20,20,20,10),
          decoration: BoxDecoration(
              gradient: currentTheme.elevated_background_color,
              boxShadow: const [BoxShadow(color: Colors.grey, spreadRadius: 2, blurRadius: 6)],
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with month picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Monthly Overview", 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 20,
                      color: Colors.white70
                    )
                  ),
                  TextButton.icon(
                    onPressed: _showMonthPicker,
                    icon: const Icon(Icons.calendar_today, color: Colors.white),
                    label: Text(
                      dateFormat.format(pickedDate),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Total budget:", style: TextStyle(color: Colors.white70),),
                Text("${numFormat.format(totalBudget)} đ", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ]),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Total spent:", style: TextStyle(color: Colors.white70)),
                Text("${numFormat.format(totalSpent)} đ", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ]),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Remaining:", style: TextStyle(color: Colors.white70)),
                Text("${numFormat.format(remaining)} đ", style: TextStyle(fontWeight: FontWeight.bold,color: (remaining<0)? Colors.redAccent:Colors.greenAccent)),
              ]),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple.shade700),
                ),
                child: LinearProgressIndicator(
                  value: totalBudget == 0 ? 0 : totalSpent / totalBudget,
                  backgroundColor: Colors.deepPurple.shade100,
                  color: Colors.deepPurple,
                ),
              )
            ],
          ),
        ),

        //Navigate to adding budget screen
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => AddBudgetScreen(selectedMonthFromPlanningScreen: pickedDate,))
                    ).then((result){
                      if(result == true){
                        setState(() {
                          _loadInitialBudgets();
                        });
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: currentTheme.main_button_color),
                  child: Text("Set new budget +",style: TextStyle(color: currentTheme.main_button_text_color, fontWeight: FontWeight.bold),),
                ),
              ),
          
              Expanded(flex: 1, child: SizedBox(),),
          
              Expanded(
                flex: 5,
                child: TextButton.icon(
                  onPressed: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (builder) => PrefixScreen(pickedDate: pickedDate,))
                    ).then((result) async {
                      if(result == true){
                        await Future.delayed(Duration(seconds: 2));
                        _loadInitialBudgets();
                      }
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: currentTheme.sub_button_color,
                    side: BorderSide(color: currentTheme.sub_button_text_color, width: 2),
                  ), 
                  icon: Icon(Icons.build_circle, color: currentTheme.sub_button_text_color,),
                  label: Text("Prefix", style: TextStyle(color: currentTheme.sub_button_text_color),),
                ),
              )
            ],
          ),
        ),

        const SizedBox(height: 10,),


        const Divider(height: 10, thickness: 2, color: Colors.grey, indent: 22, endIndent: 22),


        //Budget List
        Expanded(
          child: ListView.builder(
            itemCount: allBudgets!.length,
            itemBuilder: (context, index) {
              bool isEditing = editingIndex == index;
              var budget = allBudgets![index];

              return Dismissible(
                key: Key(allBudgets![index].budgetId.toString()),
                direction: (!isEditable(pickedDate))? DismissDirection.none:DismissDirection.endToStart,
                background: Container(
                  decoration: const BoxDecoration(
                    color: Colors.redAccent
                  ),
                  alignment: AlignmentDirectional.centerEnd,
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.delete,color: Colors.white,),
                ),
                onDismissed: (direction) async {
                  final budget = allBudgets![index];

                  try {
                    String result = await budgetService.deleteBudget(budget.budgetId); // Wait for success

                    setState(() {
                      if (editingIndex != null) {
                        if (editingIndex == index) {
                          editingIndex = null;
                        } else if (editingIndex! > index) {
                          editingIndex = editingIndex! - 1;
                        }
                      }
                      allBudgets!.removeAt(index); // Now safe to update local state
                    });

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(result),
                    ));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Failed to delete budget'),
                    ));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: currentTheme.sub_button_text_color,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: currentTheme.sub_button_color,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // === Top Row: Icon | Category Name | Edit Button ===
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            IconData(budget.iconCode, fontFamily: 'MaterialIcons'),
                            color: currentTheme.sub_button_text_color,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              budget.categoryName,
                              style: TextStyle(
                                color: currentTheme.sub_button_text_color,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (isEditable(pickedDate))
                            IconButton(
                              onPressed: () async {
                                if (isEditing) {
                                  try{
                                    final amt = double.parse(editingController.text);
                                    String result = await budgetService.editBudget(allBudgets![editingIndex!].budgetId,amt);

                                    setState(() {
                                        // Update data logic here
                                        allBudgets![index].amount = amt;
                                        editingIndex = null;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(result),
                                    ));
                                  }catch(e){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('Failed to update budget'),
                                    ));
                                  }
                                } else {
                                  setState(() {
                                    editingIndex = index;
                                    editingController.text = budget.amount.toString();
                                  });
                                }
                              },
                              icon: Icon(
                                isEditing ? Icons.save : Icons.edit,
                                color: currentTheme.sub_button_text_color,
                              ),
                              tooltip: isEditing ? "Save" : "Edit",
                            ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // === Amount Row ===
                      (isEditing)?
                          TextField(
                              controller: editingController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              style: TextStyle(color: currentTheme.sub_button_text_color),
                              decoration: const InputDecoration(
                                hintText: "Enter new amount",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            )
                          : Text(
                              "${numFormat.format(budget.spentAmount)} / ${numFormat.format(budget.amount)} đ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: (budget.spentAmount > budget.amount)
                                    ? Colors.red
                                    : Colors.green,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),

                      const SizedBox(height: 10),

                      // === Editing Message ===
                      if (isEditing)
                        Text(
                          "Editing ${budget.categoryName} budget",
                          style: const TextStyle(color: Colors.grey),
                        ),

                      const SizedBox(height: 10),

                      // === Progress Bar ===
                      LinearProgressIndicator(
                        value: (budget.amount == 0)
                            ? 0
                            : (budget.spentAmount / budget.amount).clamp(0.0, 1.0),
                        backgroundColor: Colors.deepPurple.shade100,
                        color: Colors.deepPurple,
                      ),
                    ],
                  ),
                )
              );
            },
          ),
        ),
      ],
    );
  }
}
