import 'package:event_ease/core/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/user_model.dart';

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

  TextEditingController? _usernameController;
  TextEditingController? _emailController;
  TextEditingController? _userRoleController;
  TextEditingController? _categoryController;

  bool _isInitialized = false;

  List<String> availableRoles = [
    'Personal Event Planner',
    'Small Business Owner',
    'Nonprofit Organization',
    'Professional Event Planner',
    'Tourism Stakeholder',
    'Community Organizer'
  ];
  List<String> selectedRoles = [];

  List<String> availableCategories = [
    'Birthdays', 'Weddings', 'Corporate', 'Meetings', 'Other'
  ];
  List<String> selectedCategories = [];

  List<String> budgetOptions = ['Low', 'Medium', 'High'];
  String selectedBudget = '';

  @override
  void dispose() {
    _usernameController?.dispose();
    _emailController?.dispose();
    _userRoleController?.dispose();
    _categoryController?.dispose();
    super.dispose();
  }

  void _toggleAccountEdit() => setState(() => _isEditingAccount = !_isEditingAccount);
  void _togglePersonalEdit() => setState(() => _isEditingPersonal = !_isEditingPersonal);

  void _saveChanges() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.updateUserData(
      name: _usernameController?.text,
      preferedBudget: selectedBudget,
      preferedCategory: selectedCategories,
      role: selectedRoles,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully"), backgroundColor: Colors.green),
    );

    setState(() {
      _isEditingAccount = false;
      _isEditingPersonal = false;
    });
  }

  void _initializeControllers(UserModel user) {
    if (_isInitialized) return;
    _usernameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _userRoleController = TextEditingController(text: user.role.join(", "));
    selectedBudget = user.preferedBudget;
    selectedCategories = List.from(user.preferedCategory);
    selectedRoles = List.from(user.role);
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading || authProvider.userData == null) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.amber)));
        }

        final user = authProvider.userData!;
        _initializeControllers(user);

        return Scaffold(
          appBar:PreferredSize(
            preferredSize: const Size.fromHeight(70.0),
            child: _buildAppBar(),
          ),
          body: _buildProfileBody(user),
          bottomNavigationBar: const CustomBottomBar(),
        );
      },
    );
  }

  Widget _buildProfileBody(UserModel user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ProfileHeader(username: user.name),
          const SizedBox(height: 30),
          ProfileSection(
            title: "Account Information",
            isEditing: _isEditingAccount,
            onEditPressed: _toggleAccountEdit,
            onSavePressed: _saveChanges,
            children: [
              ProfileTextField(label: "Full name", controller: _usernameController!, isEditing: _isEditingAccount),
              ProfileTextField(label: "Email", controller: _emailController!, isEditing: false),
            ],
          ),
          const SizedBox(height: 40),
          ProfileSection(
            title: "Personal Information",
            isEditing: _isEditingPersonal,
            onEditPressed: _togglePersonalEdit,
            onSavePressed: _saveChanges,
            children: [
              if (_isEditingPersonal) ...[
                const Text("Select Your Role"),
                ...availableRoles.map((role) => CheckboxListTile(
                      title: Text(role),
                      value: selectedRoles.contains(role),
                      onChanged: (bool? value) {
                        setState(() {
                          value == true ? selectedRoles.add(role) : selectedRoles.remove(role);
                        });
                      },
                      activeColor: Colors.amber,
                    )),
                const SizedBox(height: 20),
                const Text("Select Preferred Budget"),
                ...budgetOptions.map((budget) => RadioListTile(
                      title: Text(budget),
                      value: budget,
                      groupValue: selectedBudget,
                      onChanged: (String? value) {
                        setState(() => selectedBudget = value ?? '');
                      },
                      activeColor: Colors.amber,
                    )),
                const SizedBox(height: 20),
                const Text("Select Preferred Categories"),
                ...availableCategories.map((category) => CheckboxListTile(
                      title: Text(category),
                      value: selectedCategories.contains(category),
                      onChanged: (bool? value) {
                        setState(() {
                          value == true ? selectedCategories.add(category) : selectedCategories.remove(category);
                        });
                      },
                      activeColor: Colors.amber,
                    )),
              ] else ...[
                ProfileTextField(label: "User Role", controller: TextEditingController(text: selectedRoles.join(", ")), isEditing: false),
                ProfileTextField(label: "Preferred Budget", controller: TextEditingController(text: selectedBudget), isEditing: false),
                ProfileTextField(label: "Preferred Category", controller: TextEditingController(text: selectedCategories.join(", ")), isEditing: false),
              ],
            ],
          ),
          const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  await Provider.of<AuthProvider>(context, listen: false).signOut();
                  context.go('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade500,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Sign Out", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              const SizedBox(height: 20),
        ],
      ),
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
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  context.push('/profile');
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
