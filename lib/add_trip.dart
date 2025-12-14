import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/user_trips_data.dart';
import '../models/user_trip.dart';
import '../data/explore_trips_data.dart';

class AddTripPage extends StatefulWidget {
  // 1. Add this optional parameter
  final String? initialDestination;

  const AddTripPage({super.key, this.initialDestination});

  @override
  State<AddTripPage> createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  final _formKey = GlobalKey<FormState>();

  final user = FirebaseAuth.instance.currentUser;
  String? get currentUserId => user?.uid;

  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _travelersController = TextEditingController();

  String? _selectedTripType;
  String? _selectedDestination;

  // 2. Add initState to handle the pre-selection
  @override
  void initState() {
    super.initState();
    // If a destination was passed from the previous page, set it here
    if (widget.initialDestination != null) {
      _selectedDestination = widget.initialDestination;
      _destinationController.text = widget.initialDestination!;
    }
  }

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

  Future<void> _pickDate(TextEditingController controller, {bool isStart = false}) async {
    final DateTime now = DateTime.now();
    DateTime firstDate = now;
    DateTime? initialDate = now;

    if (!isStart && _startDateController.text.isNotEmpty) {
      try {
        final startDate = DateFormat('dd/MM/yyyy').parse(_startDateController.text);
        firstDate = startDate.add(const Duration(days: 1));
        initialDate = firstDate;
      } catch (e) {
        firstDate = now;
        initialDate = now;
      }
    }

    if (initialDate!.isBefore(firstDate)) {
      initialDate = firstDate;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate.subtract(const Duration(days: 1)),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
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

      final newUserTrip = UserTrip(
        id: DateTime.now().toString(),
        tripId: DateTime.now().toString(),
        userId: currentUserId!,
        tripName: _tripNameController.text,
        destination: _destinationController.text,
        startDate: _startDateController.text,
        endDate: _endDateController.text,
        budget: _budgetController.text,
        travelers: _travelersController.text,
        tripType: _selectedTripType,
      );

      userTrips.add(newUserTrip);
      _formKey.currentState!.reset();

      _tripNameController.clear();
      _destinationController.clear();
      _budgetController.clear();
      _travelersController.clear();
      _startDateController.clear();
      _endDateController.clear();

      setState(() {
        _selectedTripType = null;
        _selectedDestination = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trip created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Optional: Go back to previous screen after creation
      // Navigator.pop(context);
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
              const Text("Trip Name *", style: TextStyle(fontWeight: FontWeight.bold)),
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
                  if (value == null || value.isEmpty) {
                    return "Enter the trip name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              const Text("Destination *", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: _selectedDestination,
                decoration: InputDecoration(
                  hintText: "Select a destination",
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  filled: true,
                  fillColor: const Color(0xFFF7F7F9),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                ),
                items: exploreTrips.map((trip) {
                  return DropdownMenuItem<String>(
                    value: trip.name,
                    child: Text(trip.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDestination = value;
                    _destinationController.text = value ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select a destination";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ... (The rest of your date pickers, budget, and trip type UI remains exactly the same)
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
                            try {
                              final startDate = DateFormat('dd/MM/yyyy').parse(value);
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter the number of travelers";
                            }
                            final number = int.tryParse(value);
                            if (number == null) {
                              return "Enter a valid number";
                            }
                            if (number <= 0) {
                              return "Travelers must be greater than 0";
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
                  onPressed: _submitTrip,
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