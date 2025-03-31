import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/bottom_bar.dart';
import 'package:provider/provider.dart';
import '../../../../../core/providers/event_provider.dart';
import '../../../../core/models/task_model.dart';
import '../../../../core/models/event_model.dart';
import 'package:go_router/go_router.dart';


class EditEventPage extends StatefulWidget {
  final EventModel event;

  const EditEventPage({super.key, required this.event});

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  bool isLoading = false; 
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _participantController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 2);
  
  // For tasks
  final List<TaskModel> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  
  // For guests range
  final List<String> _guestOptions = ['1-10', '11-30', '31-50', '51-100', '101+'];
  String _selectedGuestRange = '1-10';
  
  // For budget range
  final List<String> _budgetOptions = ['> \$100', '\$101-\$500', '\$501-\$1000', '\$1001-\$5000', '\$5001+'];
  String _selectedBudget = '> \$100';
  
  // For categories
  final List<String> _categories = ['Wedding', 'Conference', 'Birthday', 'Party', 'Burial', 'Graduation', 'Other'];
  String _selectedCategory = 'Other';
  
  // For reminders
  final List<int> _reminderOptions = [5, 10, 15, 30, 60, 1440]; // minutes (1440 = 1 day)
  int _selectedReminder = 30;
  

  // Define amber color theme
  final Color primaryAmber = Colors.amber;
  final Color darkAmber = const Color.fromARGB(255, 0, 0, 0);
  
 // For participants
 final List<String> _participants = [];

 @override
void initState() {
  super.initState();
  _nameController.text = widget.event.title;
  _descriptionController.text = widget.event.description;
  _locationController.text = widget.event.location;
  _selectedDate = widget.event.date;
  _startTime = widget.event.startTime;
  _endTime = widget.event.endTime;
  _tasks.addAll(widget.event.tasks);
  _selectedGuestRange = widget.event.guestRange;
  _selectedBudget = widget.event.budget;
  _selectedCategory = widget.event.category;
  _selectedReminder = widget.event.reminder;
  _participants.addAll(widget.event.participants);
}


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


  void _addTask(String taskTitle) {
  setState(() {
    // Add the task as a TaskModel with default completed as false
    _tasks.add(TaskModel(title: taskTitle));
  });
}

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Start loading
      });

      try {
        final eventProvider = Provider.of<EventProvider>(context, listen: false);

        // Call the createEvent method from your provider
        bool success = await eventProvider.updateEvent(
          context: context,
          eventId: widget.event.id,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          location: _locationController.text.trim(),
          selectedDate: _selectedDate,
          startTime: _startTime,
          endTime: _endTime,
          tasks: _tasks,
          selectedGuestRange: _selectedGuestRange,
          selectedBudget: _selectedBudget,
          selectedCategory: _selectedCategory,
          selectedReminder: _selectedReminder,
          participants: _participants,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event updated successfully!')),
          );
          context.go('/single_event/${widget.event.id}');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create event.')),
          );
        }
      } catch (e) {
        print("Error creating event: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create event: $e')),
        );
      } finally {
        setState(() {
          isLoading = false; // Stop loading
        });
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
             icon: isLoading
                ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.amber)) // Show loader
                : const Icon(Icons.check),
            onPressed: isLoading ? null : _saveEvent,
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
                      onPressed: () {
                        // Only call _addTask if the text field is not empty
                        if (_taskController.text.isNotEmpty) {
                          _addTask(_taskController.text.trim());
                          _taskController.clear(); // Optionally clear the text field after adding the task
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildTasksList(),
                
                const SizedBox(height: 20),

                // Guests Section
                _buildSectionTitle('Guests'),
                Row(
                  children: [
                    Icon(Icons.group, color: Colors.grey.shade600),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
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
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // Budget Section
                _buildSectionTitle('Budget'),
                Row(
                  children: [
                    Icon(Icons.attach_money, color: Colors.grey.shade600),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
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
                    ),
                  ],
                ),
                const SizedBox(height: 8),


                // Participants Section
                _buildSectionTitle('Participants'),
                Row(
                  children: [
                    Icon(Icons.person_add, color: Colors.grey.shade600),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
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
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

              const SizedBox(height: 32),                
              Center(
                child: ElevatedButton(
                  onPressed: isLoading ? null : _saveEvent, // Disable button while loading
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                  ),
                  child: isLoading ? const CircularProgressIndicator() : const Text('Create Event', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
                 ],
            ),
          ),
          // Bottom Navigation
        ),
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
                  title: Text(_tasks[index].title),
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