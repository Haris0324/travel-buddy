import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart'; // From File 2
import '../data/user_trips_data.dart'; // Assuming this path is correct from File 2
import '../models/user_trip.dart'; // Assuming this path is correct from File 2

class AddTripPage extends StatefulWidget {
  const AddTripPage({super.key});

  @override
  State<AddTripPage> createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  final _formKey = GlobalKey<FormState>();

  // User and ID retrieval (from File 2)
  final user = FirebaseAuth.instance.currentUser;
  String? get currentUserId => user?.uid;

  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _travelersController = TextEditingController();

  String? _selectedTripType;

  // Dispose controllers to prevent memory leaks
  @override
  void dispose() {
    _tripNameController.dispose();
    _destinationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _budgetController.dispose();
    _travelersController.dispose();
    super.dispose();
  }

  // Date Picker Logic (Optimized from File 1's logic)
  Future<void> _pickDate(TextEditingController controller, {bool isStart = false}) async {
    final DateTime now = DateTime.now();
    DateTime firstDate = now;
    DateTime? initialDate = now;

    // Logic from File 1: Set minimum date for end date based on start date
    if (!isStart && _startDateController.text.isNotEmpty) {
      try {
        final startDate = DateFormat('dd/MM/yyyy').parse(_startDateController.text);
        firstDate = startDate.add(const Duration(days: 1));
        initialDate = firstDate;
      } catch (e) {
        // If start date is invalid, fall back to today
        firstDate = now;
        initialDate = now;
      }
    }

    // Adjust initialDate if it's before firstDate
    if (initialDate!.isBefore(firstDate)) {
      initialDate = firstDate;
    }


    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate.subtract(const Duration(days: 1)), // Allow selecting today for start date
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      // If picking start date, and it's after the current end date, clear the end date
      if (isStart && _endDateController.text.isNotEmpty) {
        final newStartDate = pickedDate;
        final currentEndDate = DateFormat('dd/MM/yyyy').parse(_endDateController.text);
        if (!currentEndDate.isAfter(newStartDate)) {
          _endDateController.clear();
        }
      }
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  // Submission Logic (Combining validation from File 1 and data handling from File 2)
  void _submitTrip() {
    if (_formKey.currentState!.validate()) {
      if (_selectedTripType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select a trip type before submitting."),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      if (currentUserId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User not logged in. Cannot create trip."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Create new trip object (from File 2)
      final newUserTrip = UserTrip(
        userId: currentUserId!,
        tripName: _tripNameController.text,
        destination: _destinationController.text,
        startDate: _startDateController.text,
        endDate: _endDateController.text,
        budget: _budgetController.text,
        travelers: _travelersController.text,
        tripType: _selectedTripType,
      );

      // Add to data source (from File 2)
      userTrips.add(newUserTrip);

      // Reset the form (from File 2)
      _formKey.currentState!.reset();

      // Manually clear the controllers and reset the trip type state
      // This is necessary because reset() only works on FormFields with initialValue
      // and for the trip type state variable.
      _tripNameController.clear();
      _destinationController.clear();
      _budgetController.clear();
      _travelersController.clear();
      setState(() {
        _selectedTripType = null;
      });


      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trip created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Optionally navigate back after success
      // Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Fill out all the required fields correctly."),
          backgroundColor: Colors.orange,
        ),
      );
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
                // Validation from File 1
                validator: (value) {
                  if (value == null || value.isEmpty) {
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
                decoration: InputDecoration(
                  hintText: "Where are you going?",
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  filled: true,
                  fillColor: const Color(0xFFF7F7F9),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                ),
                // Validation from File 1
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter the destination name";
                  }
                  return null;
                },
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
                          // Validation from File 1
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter the start date";
                            }
                            try {
                              final startDate = DateFormat('dd/MM/yyyy').parse(value);
                              // Clear the time part for accurate comparison with 'now'
                              final today = DateTime.now().subtract(const Duration(hours: 24));
                              if (startDate.isBefore(today)) {
                                return "Start date cannot be before today";
                              }
                            } catch (e) {
                              return "Invalid Date Format";
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
                          // Validation from File 1
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter the end date";
                            }
                            if (_startDateController.text.isEmpty) {
                              return "Select a start date first";
                            }
                            try {
                              final startDate = DateFormat('dd/MM/yyyy').parse(_startDateController.text);
                              final endDate = DateFormat('dd/MM/yyyy').parse(value);
                              if (!endDate.isAfter(startDate)) {
                                return "End date must be after the start date";
                              }
                            } catch (e) {
                              return "Invalid Date Format";
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
                          // Validation from File 1
                          validator: (value) {
                            if (value == null || value.isEmpty) {
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
                          decoration: InputDecoration(
                            errorMaxLines: 2,
                            hintText: "1",
                            filled: true,
                            fillColor: const Color(0xFFF7F7F9),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                          ),
                          // Validation from File 1
                          validator: (value) {
                            if (value == null || value.isEmpty) {
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
                  onPressed: _submitTrip, // Call the merged submission function
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

  // Trip Type Button Widget (identical in both files)
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