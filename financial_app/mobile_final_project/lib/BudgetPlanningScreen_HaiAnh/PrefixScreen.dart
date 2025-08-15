import 'package:final_project/BudgetPlanningScreen_HaiAnh/AddPrefixScreen.dart';
import 'package:final_project/BudgetPlanningScreen_HaiAnh/service/prefix_service.dart';
import 'package:final_project/ThemeChanging_HaiAnh/current_theme.dart';
import 'package:final_project/global_variable/number_format.dart';
import 'package:final_project/model/Prefix.dart';
import 'package:final_project/model/User.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrefixScreen extends StatefulWidget{
  final DateTime pickedDate;

  const PrefixScreen({super.key, required this.pickedDate});

  @override
  State<StatefulWidget> createState() => _PrefixScreenState();
}

class _PrefixScreenState extends State<PrefixScreen> {
  int? userID;

  void _loadUserID() async {
    int? id = await User.getStoredUserId();
    setState(() {
      userID = id;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserID();
  }

  final prefix_service prefixService = prefix_service();

  Future<void> _fetchApplyPrefix() async {
    prefixService.applyPrefix(userID!, widget.pickedDate.month, widget.pickedDate.year);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.pickedDate);
    if (userID == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: currentTheme.background_color,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        title: const Text(
          "Prefixes",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(onPressed: (){
            //ADD MODAL OR NAVIAGTE TO ADDING PAGE
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (builder) => AddPrefixScreen())
            );
          }, 
          icon: Icon(Icons.add, color: Colors.white,))
        ],
        backgroundColor: currentTheme.tab_bar_color,
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          // Show confirmation dialog
          bool? confirmed = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Apply Prefixes'),
                content: const Text('Applying Prefixes will override any budget with the same type, are your sure?',
                  style: TextStyle(color: Colors.redAccent),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.deepPurple
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Yes', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                    ),
                  ),
                ],
              );
            },
          );

          if (confirmed == true) {
            await _fetchApplyPrefix();
            Navigator.pop(context, true);
          }
        },
        child: const Text(
          "Apply Prefixes",
          style: TextStyle(color: Colors.white, fontSize: 15),
          textAlign: TextAlign.center,
        ),
      ),
      body: PrefixScreenBody(pickedDate: widget.pickedDate, userID: userID!,),
    );
  }
}

class PrefixScreenBody extends StatefulWidget{
  final DateTime pickedDate;
  final int userID;

  const PrefixScreenBody({super.key, required this.pickedDate, required this.userID});

  @override
  State<StatefulWidget> createState() => _PrefixScreenBodyState();
}

class _PrefixScreenBodyState extends State<PrefixScreenBody>{
  final prefix_service prefixService = prefix_service();
  final DateFormat dateFormat = DateFormat("MM/yyyy");

  List<Prefix> allPrefix = [];

  void _fetchUserPrefixes() async {
    final result = await prefixService.getPrefixList(widget.userID);
    setState(() {
      allPrefix = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserPrefixes();
  }

  @override
  Widget build(BuildContext context) {
    if(allPrefix.isEmpty){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 50, color: currentTheme.main_text_color,),
            const SizedBox(height: 10,),
            Text("You're having no prefix yet!", 
              style: TextStyle(color: currentTheme.main_text_color, fontSize: 20),),
            const SizedBox(height: 10,),
            ElevatedButton(onPressed: (){
              //Navigate or turn on modal for adding
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (builder) => AddPrefixScreen())
              ).then((result){
                if(result == true){
                  _fetchUserPrefixes();
                }
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: currentTheme.main_button_color), 
            child: Text("Create new prefix +", style: TextStyle(color: currentTheme.main_button_text_color),))
          ],
        ),
      );
    }
    return Column(
        children: [
          const SizedBox(height: 20,),

          Text("MY PREFIXES",
            style: TextStyle(color: currentTheme.main_text_color, fontWeight: FontWeight.bold, fontSize: 30),
          ),

          const SizedBox(height: 10,),

          Text(dateFormat.format(widget.pickedDate), style: TextStyle(color: currentTheme.main_text_color, fontSize: 20),),

          const SizedBox(height: 20,),

          Expanded(
            child: ListView.builder(
            itemCount: allPrefix.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(allPrefix[index].prefixId.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  decoration: const BoxDecoration(
                    color: Colors.redAccent
                  ),
                  alignment: AlignmentDirectional.centerEnd,
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.delete,color: Colors.white,),
                ),
                onDismissed: (direction) async {
                  try {
                    String result = await prefixService.deletePrefix(allPrefix[index].prefixId); // Wait for success

                    setState(() {
                      allPrefix.removeAt(index);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(result),
                    ));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Failed to delete prefix'),
                    ));
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: currentTheme.elevated_background_color,
                    border: Border.all(
                      width: 2,
                      color: currentTheme.sub_button_text_color
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        allPrefix[index].categoryName,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: currentTheme.sub_button_text_color),
                      ),
                      Text(
                        '${numFormat.format(allPrefix[index].amount)} VND',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: currentTheme.sub_button_text_color),
                      ),
                    ],
                  ),
                ),
              );        
            },
                    ),
          )
      ]  
    );
  }
}