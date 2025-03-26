import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 2);
  
  // For tasks
  final List<String> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  
  // For guests
  final List<Guest> _guests = [];
  final TextEditingController _guestNameController = TextEditingController();
  final TextEditingController _guestEmailController = TextEditingController();
  
  // For categories
  final List<String> _categories = ['Personal', 'Work', 'Family', 'Friends', 'Other'];
  String _selectedCategory = 'Personal';
  
  // For reminders
  final List<int> _reminderOptions = [5, 10, 15, 30, 60, 1440]; // minutes (1440 = 1 day)
  int _selectedReminder = 30;
  
  // For priority
  final List<String> _priorityLevels = ['Low', 'Medium', 'High'];
  String _selectedPriority = 'Medium';

  // Define amber color theme
  final Color primaryAmber = Colors.amber;
  final Color darkAmber = const Color.fromARGB(255, 0, 0, 0);

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _taskController.dispose();
    _guestNameController.dispose();
    _guestEmailController.dispose();
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

  void _addGuest() {
    if (_guestNameController.text.isNotEmpty && _guestEmailController.text.isNotEmpty) {
      setState(() {
        _guests.add(
          Guest(
            name: _guestNameController.text,
            email: _guestEmailController.text,
          ),
        );
        _guestNameController.clear();
        _guestEmailController.clear();
      });
    }
  }

  void _removeGuest(int index) {
    setState(() {
      _guests.removeAt(index);
    });
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      // Create event object
      final event = Event(
        name: _nameController.text,
        description: _descriptionController.text,
        location: _locationController.text,
        date: _selectedDate,
        startTime: _startTime,
        endTime: _endTime,
        tasks: List.from(_tasks),
        guests: List.from(_guests),
        category: _selectedCategory,
        reminderMinutes: _selectedReminder,
        priority: _selectedPriority,
      );
      
      // Handle event saving (e.g., to local storage or backend)
      print('Event saved: ${event.toString()}');
      
      // Show success message with amber theme
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Event created successfully!'),
          backgroundColor: darkAmber,
        ),
      );
      
      // Navigate back or to event details page
      // Navigator.pop(context);
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
                
                const SizedBox(height: 12),
                
                // Priority selection
                Row(
                  children: [
                    Icon(Icons.priority_high, color: Colors.grey.shade600),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                        ),
                        value: _selectedPriority,
                        items: _priorityLevels.map((priority) {
                          return DropdownMenuItem<String>(
                            value: priority,
                            child: Text(priority),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedPriority = value;
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
                TextFormField(
                  controller: _guestNameController,
                  decoration: const InputDecoration(
                    labelText: 'Guest Name',
                    icon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _guestEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Guest Email',
                    icon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 8),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Guest'),
                    onPressed: _addGuest,
                  ),
                ),
                const SizedBox(height: 8),
                _buildGuestsList(),
                
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

  Widget _buildGuestsList() {
    return _guests.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No guests added yet'),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _guests.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.person, color: primaryAmber),
                  title: Text(_guests[index].name),
                  subtitle: Text(_guests[index].email),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeGuest(index),
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