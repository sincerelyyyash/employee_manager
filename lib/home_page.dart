import 'package:employee_manager/add_detail.dart';
import 'package:flutter/material.dart';
import 'dphelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Employee> employees = [];
  late List<Employee> currentEmployees;
  late List<Employee> previousEmployees;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    employees = await DatabaseHelper.fetchEmployees();

    currentEmployees =
        employees.where((employee) => employee.endDate == 'No date').toList();

    previousEmployees =
        employees.where((employee) => employee.endDate != 'No date').toList();

    setState(() {});
  }

  void _updateEmployees() async {
    await _loadEmployees();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Employee List",
          style: TextStyle(color: Colors.white, fontSize: 21),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (employees.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Center(
                  child: Image.asset('assets/no_record.png'),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 1,
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 15),
                      child: Container(
                        height: 25,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Current employees",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1DA1F2)),
                        ),
                      ),
                    ),
                  ),
                  Builder(builder: (context) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: currentEmployees.length,
                      itemBuilder: (context, index) {
                        return _employeeDetailCurrent(
                          context,
                          currentEmployees[index],
                        );
                      },
                    );
                  }),
                  Card(
                    elevation: 1,
                    color: Colors.white.withOpacity(0.8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 15),
                      child: Container(
                        height: 25,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Previous employees",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1DA1F2)),
                        ),
                      ),
                    ),
                  ),
                  Builder(builder: (context) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: previousEmployees.length,
                      itemBuilder: (context, index) {
                        return _employeeDetailPrevious(
                          context,
                          previousEmployees[index],
                        );
                      },
                    );
                  }),
                ],
              ),
            // SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddEmpDetails();
          }));
        },
        child: const Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  Widget _employeeDetailCurrent(BuildContext context, employee) {
    return Dismissible(
      key: Key(employee.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) async {
        // Delete the employee from the database
        await DatabaseHelper.deleteEmployee(employee.id);
        _updateEmployees();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.only(right: 16, left: 16, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "${employee.name}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        "${employee.role}",
                        style: TextStyle(
                            color: Color(0xFF949C9E),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "From ${employee.startDate.substring(0, 10)}",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF949C9E)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider()
        ],
      ),
    );
  }

  Widget _employeeDetailPrevious(BuildContext context, employee) {
    return Dismissible(
      key: Key(employee.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) async {
        // Delete the employee from the database
        await DatabaseHelper.deleteEmployee(employee.id);
        _updateEmployees();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.only(right: 16, left: 16, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "${employee.name}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        "${employee.role}",
                        style: TextStyle(
                            color: Color(0xFF949C9E),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "From ${employee.startDate.substring(0, 10)} - ${employee.endDate.substring(0, 10)}",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF949C9E)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
