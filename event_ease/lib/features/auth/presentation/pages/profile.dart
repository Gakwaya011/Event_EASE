import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_section.dart';
import '../widgets/profile/profile_text_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditingAccount = false;
  bool _isEditingPersonal = false;

  final TextEditingController _usernameController = TextEditingController(text: "Scarlet Deadpool");
  final TextEditingController _emailController = TextEditingController(text: "scardead@gmail.com");
  final TextEditingController _userRoleController = TextEditingController(text: "Planner, Stakeholder");
  final TextEditingController _eventsController = TextEditingController(text: "Birthday, Weddings");

  void _toggleAccountEdit() => setState(() => _isEditingAccount = !_isEditingAccount);
  void _togglePersonalEdit() => setState(() => _isEditingPersonal = !_isEditingPersonal);
  
  void _saveChanges() => ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully"), backgroundColor: Colors.green));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: _buildAppBar(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ProfileHeader(username: _usernameController.text),
            const SizedBox(height: 30),
            
            ProfileSection(
              title: "Account Information",
              isEditing: _isEditingAccount,
              onEditPressed: _toggleAccountEdit,
              onSavePressed: _saveChanges,
              children: [
                ProfileTextField(label: "Username", controller: _usernameController, isEditing: _isEditingAccount),
                ProfileTextField(label: "Email", controller: _emailController, isEditing: _isEditingAccount),
              ],
            ),

            const SizedBox(height: 40),

            ProfileSection(
              title: "Personal Information",
              isEditing: _isEditingPersonal,
              onEditPressed: _togglePersonalEdit,
              onSavePressed: _saveChanges,
              children: [
                ProfileTextField(label: "User Role", controller: _userRoleController, isEditing: _isEditingPersonal),
                ProfileTextField(label: "Your Events", controller: _eventsController, isEditing: _isEditingPersonal),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              // Navigate back to homepage (/)
              context.push('/dashboard');
            },
          ),
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/profile',
                  );
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

}
