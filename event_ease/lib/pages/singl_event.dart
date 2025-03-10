import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const SinglEvent());
}

class SinglEvent extends StatelessWidget {
  const SinglEvent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EventDetailsPage(
        event: EventModel(
          title: "Kamila's Birthday",
          date: DateTime(2024, 6, 15),
          time: TimeOfDay(hour: 19, minute: 00),
          location: "Sunset Ballroom, 123 Party Street",
          description: "Join us for an unforgettable celebration of Kamila's special day! We'll have great food, music, and memories to last a lifetime.",
          guests: 45,
          budget: 5000,
          tasks: [
            TaskModel(title: "Book Venue", completed: true),
            TaskModel(title: "Send Invitations", completed: false),
            TaskModel(title: "Order Cake", completed: false),
            TaskModel(title: "Arrange Catering", completed: true),
          ],
          invitedGuests: [
            GuestModel(name: "John Doe", status: GuestStatus.confirmed),
            GuestModel(name: "Jane Smith", status: GuestStatus.pending),
            GuestModel(name: "Mike Johnson", status: GuestStatus.declined),
          ],
        ),
      );
  }
}

enum GuestStatus { confirmed, pending, declined }

class GuestModel {
  final String name;
  final GuestStatus status;

  GuestModel({required this.name, required this.status});
}

class TaskModel {
  final String title;
  bool completed;

  TaskModel({required this.title, this.completed = false});
}

class EventModel {
  final String title;
  final DateTime date;
  final TimeOfDay time;
  final String location;
  final String description;
  final int guests;
  final double budget;
  final List<TaskModel> tasks;
  final List<GuestModel> invitedGuests;

  EventModel({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.guests,
    required this.budget,
    required this.tasks,
    required this.invitedGuests,
  });
}

class EventDetailsPage extends StatefulWidget {
  final EventModel event;

  const EventDetailsPage({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEventSummary(),
                  const SizedBox(height: 24),
                  _buildEventDetails(),
                  const SizedBox(height: 24),
                  _buildTaskSection(),
                  const SizedBox(height: 24),
                  _buildGuestList(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 250.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.event.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1519741497674-611481b9c1d7',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.amber.shade200,
                  child: const Center(
                    child: Icon(
                      Icons.celebration,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black54,
                    Colors.transparent,
                    Colors.black54,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummaryItem(
            icon: Icons.calendar_today,
            title: 'Date',
            value: DateFormat('MMM dd, yyyy').format(widget.event.date),
          ),
          _buildSummaryItem(
            icon: Icons.access_time,
            title: 'Time',
            value: widget.event.time.format(context),
          ),
          _buildSummaryItem(
            icon: Icons.people,
            title: 'Guests',
            value: '${widget.event.guests}',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.amber,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildEventDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                icon: Icons.location_on,
                text: widget.event.location,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: Icons.attach_money,
                text: 'Budget: \$${widget.event.budget.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 16),
              const Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.event.description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.amber,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Tasks',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.event.tasks.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final task = widget.event.tasks[index];
              return CheckboxListTile(
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.completed 
                      ? TextDecoration.lineThrough 
                      : TextDecoration.none,
                  ),
                ),
                value: task.completed,
                onChanged: (bool? value) {
                  setState(() {
                    task.completed = value ?? false;
                  });
                },
                activeColor: Colors.amber,
                checkColor: Colors.white,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGuestList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Guest List',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.event.invitedGuests.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final guest = widget.event.invitedGuests[index];
              return ListTile(
                title: Text(guest.name),
                trailing: _buildGuestStatusChip(guest.status),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGuestStatusChip(GuestStatus status) {
    Color chipColor;
    String chipText;

    switch (status) {
      case GuestStatus.confirmed:
        chipColor = Colors.green.shade100;
        chipText = 'Confirmed';
        break;
      case GuestStatus.pending:
        chipColor = Colors.amber.shade100;
        chipText = 'Pending';
        break;
      case GuestStatus.declined:
        chipColor = Colors.red.shade100;
        chipText = 'Declined';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        chipText,
        style: TextStyle(
          color: chipColor == Colors.green.shade100 
            ? Colors.green.shade700 
            : chipColor == Colors.amber.shade100 
              ? Colors.amber.shade700 
              : Colors.red.shade700,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        // Add event editing functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit Event')),
        );
      },
      backgroundColor: Colors.amber,
      child: const Icon(Icons.edit, color: Colors.white),
    );
  }
}