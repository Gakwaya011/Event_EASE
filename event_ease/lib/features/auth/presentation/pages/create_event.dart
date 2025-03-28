import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _participantController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 2);
  
  // For tasks
  final List<String> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  
  // For guests range
  final List<String> _guestOptions = ['1-5', '6-10', '11-20', '21-50', '50+'];
  String _selectedGuestRange = '1-5';
  
  // For budget range
  final List<String> _budgetOptions = ['< \$100', '\$100-\$500', '\$500-\$1000', '\$1000+'];
  String _selectedBudget = '< \$100';
  
  // For categories
  final List<String> _categories = ['Personal', 'Work', 'Family', 'Friends', 'Other'];
  String _selectedCategory = 'Personal';
  
  // For reminders
  final List<int> _reminderOptions = [5, 10, 15, 30, 60, 1440]; // minutes (1440 = 1 day)
  int _selectedReminder = 30;
  

  // Define amber color theme
  final Color primaryAmber = Colors.amber;
  final Color darkAmber = const Color.fromARGB(255, 0, 0, 0);
  
 // For participants
 final List<String> _participants = [];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _taskController.dispose();
    _participantController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryAmber,
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryAmber,
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(_taskController.text);
        _taskController.clear();
      });
    }
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        String formattedStartTime = _startTime.format(context);
        String formattedEndTime = _endTime.format(context);

        await firestore.collection('events').add({
          "name": _nameController.text,
          "description": _descriptionController.text,
          "location": _locationController.text,
          "date": Timestamp.fromDate(_selectedDate),
          "startTime": formattedStartTime,
          "endTime": formattedEndTime,
          "tasks": _tasks,
          "guestRange": _selectedGuestRange,
          "budget": _selectedBudget,
          "category": _selectedCategory,
          "reminderMinutes": _selectedReminder,
          "participants": _participants,
          "createdAt": FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        print("Error saving event: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create event: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primarySwatch: Colors.amber,
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryAmber),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryAmber,
            foregroundColor: Colors.black,
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create New Event', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveEvent,
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Event Information
                _buildSectionTitle('Event Details'),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Event Name',
                    icon: Icon(Icons.event),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    icon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                
                // Category dropdown
                Row(
                  children: [
                    Icon(Icons.category, color: Colors.grey.shade600),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                        value: _selectedCategory,
                        items: _categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Date and Time section
                _buildSectionTitle('Date & Time'),
                ListTile(
                  leading: Icon(Icons.calendar_today, color: primaryAmber),
                  title: const Text('Date'),
                  subtitle: Text(DateFormat.yMMMMd().format(_selectedDate)),
                  onTap: () => _selectDate(context),
                ),
                ListTile(
                  leading: Icon(Icons.access_time, color: primaryAmber),
                  title: const Text('Start Time'),
                  subtitle: Text(_startTime.format(context)),
                  onTap: () => _selectTime(context, true),
                ),
                ListTile(
                  leading: Icon(Icons.timer_off, color: primaryAmber),
                  title: const Text('End Time'),
                  subtitle: Text(_endTime.format(context)),
                  onTap: () => _selectTime(context, false),
                ),
                
                // Reminder selection
                Row(
                  children: [
                    Icon(Icons.notifications, color: Colors.grey.shade600),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Reminder',
                        ),
                        value: _selectedReminder,
                        items: _reminderOptions.map((minutes) {
                          String text = minutes == 1440 
                              ? '1 day before' 
                              : minutes == 60 
                                  ? '1 hour before' 
                                  : '$minutes minutes before';
                          return DropdownMenuItem<int>(
                            value: minutes,
                            child: Text(text),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedReminder = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Location Section
                _buildSectionTitle('Location'),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    icon: Icon(Icons.location_on),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Tasks Section
                _buildSectionTitle('Tasks'),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _taskController,
                        decoration: const InputDecoration(
                          labelText: 'Add a task',
                          icon: Icon(Icons.task),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: primaryAmber),
                      onPressed: _addTask,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildTasksList(),
                
                const SizedBox(height: 20),
                
                // Guests Section
                _buildSectionTitle('Guests'),
                DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Guest Range'),
                value: _selectedGuestRange,
                items: _guestOptions.map((range) {
                  return DropdownMenuItem<String>(
                    value: range,
                    child: Text(range),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedGuestRange = value!),
              ),

                const SizedBox(height: 20),

              // Budget Section
              _buildSectionTitle('Budget'),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Budget'),
                value: _selectedBudget,
                items: _budgetOptions.map((budget) {
                  return DropdownMenuItem<String>(
                    value: budget,
                    child: Text(budget),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedBudget = value!),
              ),

              const SizedBox(height: 20),

              // Budget Section
              _buildSectionTitle('Participants'),

              TextField(
                controller: _participantController,
                decoration: InputDecoration(
                  labelText: "Add Participant Email",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      if (_participantController.text.isNotEmpty) {
                        setState(() {
                          _participants.add(_participantController.text);
                          _participantController.clear();
                        });
                      }
                    },
                  ),
                ),
              ),
              Wrap(
                children: _participants.map((email) => Chip(
                  label: Text(email),
                  onDeleted: () {
                    setState(() {
                      _participants.remove(email);
                    });
                  },
                )).toList(),
              ),
              
              const SizedBox(height: 32),
                
              Center(
                child: ElevatedButton(
                  onPressed: _saveEvent,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                  ),
                  child: const Text('Create Event', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              ],
            ),
          ),
        ),
        // Bottom Navigation
        bottomNavigationBar: CustomBottomBar(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkAmber,
            ),
          ),
          Divider(color: primaryAmber.withOpacity(0.3)),
        ],
      ),
    );
  }

  Widget _buildTasksList() {
    return _tasks.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No tasks added yet'),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.check_circle_outline, color: primaryAmber),
                  title: Text(_tasks[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeTask(index),
                  ),
                ),
              );
            },
          );
  }


}

// Models
class Event {
  final String name;
  final String description;
  final String location;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<String> tasks;
  final List<Guest> guests;
  final String category;
  final int reminderMinutes;
  final String priority;

  Event({
    required this.name,
    required this.description,
    required this.location,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.tasks,
    required this.guests,
    required this.category,
    required this.reminderMinutes,
    required this.priority,
  });

  @override
  String toString() {
    return 'Event: $name, Date: ${DateFormat.yMMMMd().format(date)}, Tasks: ${tasks.length}, Guests: ${guests.length}';
  }
}

class Guest {
  final String name;
  final String email;

  Guest({
    required this.name,
    required this.email,
  });
}