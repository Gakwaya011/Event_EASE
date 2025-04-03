import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:event_ease/core/providers/event_provider.dart';
import 'package:event_ease/core/models/event_model.dart';
import 'package:event_ease/features/auth/presentation/widgets/bottom_bar.dart';


class SinglEvent extends StatefulWidget {
  final String eventId;

  const SinglEvent({super.key, required this.eventId});

  @override
  _SinglEventState createState() => _SinglEventState();
}

class _SinglEventState extends State<SinglEvent> {
  
@override
Widget build(BuildContext context) {
  final eventProvider = Provider.of<EventProvider>(context);

  // If events are empty, fetch first (prevents null return)
  if (eventProvider.events.isEmpty) {
    return FutureBuilder(
      future: eventProvider.fetchEventById(widget.eventId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.amber)));
        }
        final event = eventProvider.getEventById(widget.eventId);
        if (event == null) {
          return const Center(child: Text("Event not found!"));
        }
        return EventDetailsPage(event: event);
      },
    );
  }

  // Fetch event normally
  final event = eventProvider.getEventById(widget.eventId);
  if (event == null) {
    return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.amber)));
  }

  return EventDetailsPage(event: event);
}
}

class EventDetailsPage extends StatefulWidget {
  final EventModel event;

  const EventDetailsPage({super.key, required this.event});

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
                  _buildParticipantsList(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: const CustomBottomBar(),
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
            Container(
                  color: Colors.amber.shade200,
                  child: const Center(
                    child: Icon(
                      Icons.celebration,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
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
            value: widget.event.startTime.format(context),
          ),
          _buildSummaryItem(
            icon: Icons.people,
            title: 'Guests',
            value: widget.event.guestRange,
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
                text: widget.event.location.isEmpty ? 'No location added' : widget.event.location,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: Icons.attach_money,
                text: widget.event.budget.isEmpty ? 'No budget set' : 'Budget: "${widget.event.budget}"',
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
                widget.event.description.isEmpty ? 'No description available' : widget.event.description,
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
  final eventProvider = Provider.of<EventProvider>(context, listen: false);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Event Tasks',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      widget.event.tasks.isNotEmpty
          ? Container(
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
                        decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none,
                        color: task.completed ? Colors.grey : Colors.black,
                      ),
                    ),
                    value: task.completed,
                    onChanged: (bool? value) async {
                      setState(() {
                        task.completed = value ?? false;
                      });

                      // Save to Firestore via EventProvider
                      await eventProvider.updateTaskStatus(widget.event.id, task);
                    },
                    activeColor: Colors.amber,
                    checkColor: Colors.white,
                  );
                },
              ),
            )
          : Text(
            'No tasks assigned yet.',
            style: TextStyle(color: Colors.grey),
          ),],
  );
}

  Widget _buildParticipantsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Participants',
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
          child: widget.event.participants.isNotEmpty
              ? Column(
                  children: widget.event.participants
                      .map((participant) => ListTile(
                            leading: const Icon(Icons.person, color: Colors.amber),
                            title: Text(participant),
                          ))
                      .toList(),
                )
              : const Center(
                  child: Text(
                    'No participants yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
        ),
      ],
    );
  }


  FloatingActionButton _buildFloatingActionButton() {
  return FloatingActionButton(
    onPressed: () {
      context.go('/edit_event/${widget.event.id}');
    },
    backgroundColor: Colors.amber,
    child: const Icon(Icons.edit, color: Colors.white),
  );
}
}