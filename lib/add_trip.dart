import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTripPage extends StatefulWidget {
  const AddTripPage({super.key});

  @override
  State<AddTripPage> createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _travelersController = TextEditingController();

  String? _selectedTripType;

  Future<void> _pickDate(TextEditingController controller, {bool isStart = false}) async {
    final DateTime now = DateTime.now();
    DateTime firstDate = now;
    DateTime? initialDate = now;

    // If selecting end date, make sure it starts after selected start date
    if (!isStart && _startDateController.text.isNotEmpty) {
      final startDate = DateFormat('dd/MM/yyyy').parse(_startDateController.text);
      firstDate = startDate.add(const Duration(days: 1));
      initialDate = firstDate;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate!,
      firstDate: firstDate,
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Trip"),
        backgroundColor: const Color(0xFF6A5AE0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trip Name
              const Text("Trip Name *",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _tripNameController,
                decoration: InputDecoration(
                  hintText: "e.g., Summer Vacation 2025",
                  filled: true,
                  fillColor: const Color(0xFFF7F7F9),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                ),
                validator: (value) {
                  if (value==null||value.isEmpty) {
                    return "Enter the trip name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Destination
              const Text("Destination *", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _destinationController,
                validator: (value) {
                  if (value==null||value.isEmpty) {
                    return "Enter the destination name";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Where are you going?",
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  filled: true,
                  fillColor: const Color(0xFFF7F7F9),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),

              // Start and End Date
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Start Date", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _startDateController,
                          readOnly: true,
                          onTap: () => _pickDate(_startDateController, isStart: true),
                          decoration: InputDecoration(
                            hintText: "dd/mm/yyyy",
                            prefixIcon: const Icon(Icons.calendar_today_outlined),
                            filled: true,
                            fillColor: const Color(0xFFF7F7F9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter the start date";
                            }

                            final startDate = DateFormat('dd/MM/yyyy').parse(value);
                            if (startDate.isBefore(DateTime.now())) {
                              return "Start date cannot be before today";
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("End Date", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _endDateController,
                          readOnly: true,
                          onTap: () => _pickDate(_endDateController),
                          decoration: InputDecoration(
                            hintText: "dd/mm/yyyy",
                            prefixIcon: const Icon(Icons.calendar_today_outlined),
                            filled: true,
                            fillColor: const Color(0xFFF7F7F9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter the end date";
                            }

                            if (_startDateController.text.isNotEmpty) {
                              final startDate = DateFormat('dd/MM/yyyy').parse(_startDateController.text);
                              final endDate = DateFormat('dd/MM/yyyy').parse(value);
                              if (!endDate.isAfter(startDate)) {
                                return "End date must be after the start date";
                              }
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Budget and Travelers
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Budget", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _budgetController,
                          validator: (value) {
                            if(value==null||value.isEmpty) {
                              return "Enter the budget";
                            }
                            final number = int.tryParse(value);
                            if (number == null) {
                              return "Enter a valid number";
                            }
                            if (number <= 0) {
                              return "Budget must be greater than 0";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            errorMaxLines: 2,
                            hintText: "0",
                            filled: true,
                            fillColor: const Color(0xFFF7F7F9),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Travelers", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _travelersController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if(value==null||value.isEmpty) {
                              return "Enter the number of travelers";
                            }
                            final number = int.tryParse(value);
                            if (number == null) {
                              return "Enter a valid number";
                            }
                            if (number <= 0) {
                              return "no of travelers must be greater than 0";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            errorMaxLines: 2,
                            hintText: "1",
                            filled: true,
                            fillColor: const Color(0xFFF7F7F9),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Trip Type
              const Text("Trip Type", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _tripTypeButton("Beach", Icons.beach_access_outlined),
                  _tripTypeButton("Adventure", Icons.terrain),
                  _tripTypeButton("Cultural", Icons.account_balance_outlined),
                  _tripTypeButton("City", Icons.location_city_outlined),
                ],
              ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedTripType == null) {
                        // Trip type not selected
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select a trip type before submitting."),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      } else {
                        // All valid
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Trip created successfully! (${_selectedTripType!})",
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Fill out all the required fields."),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A5AE0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Create Trip",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tripTypeButton(String type, IconData icon) {
    final bool isSelected = _selectedTripType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTripType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6A5AE0) : const Color(0xFFF7F7F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.black87),
            const SizedBox(width: 6),
            Text(
              type,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
