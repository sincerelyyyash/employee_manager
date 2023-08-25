import 'package:employee_manager/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dphelper.dart';

class AddEmpDetails extends StatefulWidget {
  const AddEmpDetails({Key? key}) : super(key: key);

  @override
  State<AddEmpDetails> createState() => _AddEmpDetailsState();
}

class _AddEmpDetailsState extends State<AddEmpDetails> {
  TextEditingController _nameField = TextEditingController();
  String? selectedRole;
  DateTime? startDate;
  DateTime? endDate;

  void _saveDetails() async {
    if (_nameField.text.isNotEmpty &&
        selectedRole != null &&
        startDate != null) {
      final employee = Employee(
        name: _nameField.text,
        role: selectedRole!,
        startDate: startDate!.toString(),
        endDate: endDate != null ? endDate!.toString() : 'No date',
      );

      await DatabaseHelper.insertEmployee(employee);

      setState(() {
        _nameField.clear();
        selectedRole = null;
        startDate = null;
        endDate = null;
      });

      // TODO: Show a success message or navigate to another screen
    } else {
      // Show an error message if any of the required fields are missing
    }
  }

  void _showDatePickerDialog(bool isStartDate) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? DateTime.now() : endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = selectedDate;
        } else {
          endDate = selectedDate;
        }
      });
    }
  }

  void _showRoleBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRoleOption('Product Designer'),
            Divider(),
            _buildRoleOption('Flutter Developer'),
            Divider(),
            _buildRoleOption('QA Tester'),
            Divider(),
            _buildRoleOption('Product Owner'),
          ],
        );
      },
    );
  }

  Widget _buildRoleOption(String role) {
    return ListTile(
      title: Center(child: Text(role)),
      onTap: () {
        setState(() {
          selectedRole = role;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text(
          "Add Employee Details",
          style: TextStyle(fontSize: 21, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: 50,
              child: TextFormField(
                keyboardType: TextInputType.name,
                style: TextStyle(color: Colors.black),
                controller: _nameField,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: SvgPicture.asset(
                      "assets/person.svg",
                      height: 15,
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                  hintText: "Employee name",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFE5E5E5)),
                    gapPadding: 10,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFE5E5E5)),
                    gapPadding: 5,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: 50,
              child: TextFormField(
                readOnly: true,
                style: TextStyle(color: Colors.black),
                controller: TextEditingController(text: selectedRole),
                onTap: _showRoleBottomSheet,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: SvgPicture.asset(
                      "assets/role.svg",
                      height: 15,
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: SvgPicture.asset(
                      "assets/dropdown_arrow.svg",
                      height: 15,
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                  hintText: "Select role",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFE5E5E5)),
                    gapPadding: 10,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFFE5E5E5)),
                    gapPadding: 5,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showDatePickerDialog(true),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFE5E5E5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child:
                                Icon(Icons.calendar_today, color: Colors.blue),
                          ),
                          SizedBox(width: 8),
                          Center(
                            child: startDate == null
                                ? Text('Today')
                                : Text(
                                    '${startDate!.day}/${startDate!.month}/${startDate!.year}',
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showDatePickerDialog(false),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFE5E5E5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child:
                                Icon(Icons.calendar_today, color: Colors.blue),
                          ),
                          SizedBox(width: 8),
                          Center(
                            child: endDate == null
                                ? Text('No date',
                                    style: TextStyle(color: Colors.grey))
                                : Text(
                                    '${endDate!.day}/${endDate!.month}/${endDate!.year}',
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
          Column(
            children: [
              Divider(),
              Row(
                children: [
                  SizedBox(
                    width: 230,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEDF8FF),
                      side: BorderSide(width: 0, color: Color(0xFFEDF8FF)),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _saveDetails();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const HomePage();
                      }));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1DA1F2),
                      side: BorderSide(width: 0, color: Color(0xFFEDF8FF)),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
