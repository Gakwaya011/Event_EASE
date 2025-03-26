import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.amber,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    debugShowCheckedModeBanner: false, 
    home: ProfilePage()
  ));
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0;
  bool _isEditingAccount = false;
  bool _isEditingPersonal = false;

  // Controllers for editable fields
  final TextEditingController _usernameController = TextEditingController(text: "Scarlet Deadpool");
  final TextEditingController _emailController = TextEditingController(text: "scardead@gmail.com");
  final TextEditingController _userRoleController = TextEditingController(text: "Planner, Stakeholder, Small Business");
  final TextEditingController _eventsController = TextEditingController(text: "Birthday, Weddings, Meetings, Burials");

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleAccountEdit() {
    setState(() {
      _isEditingAccount = !_isEditingAccount;
    });
  }

  void _togglePersonalEdit() {
    setState(() {
      _isEditingPersonal = !_isEditingPersonal;
    });
  }

  void _saveAccountChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Account Information Updated Successfully!'),
        backgroundColor: Colors.green,
      )
    );
    setState(() {
      _isEditingAccount = false;
    });
  }

  void _savePersonalChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Personal Information Updated Successfully!'),
        backgroundColor: Colors.green,
      )
    );
    setState(() {
      _isEditingPersonal = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: _buildAppBar(),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFFFF2D6),
              Color(0xFFFFE4B3),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(),
                SizedBox(height: 30),
                _buildSectionTitle(
                  "Account Information", 
                  allowEdit: true, 
                  isEditing: _isEditingAccount, 
                  onEditPressed: _toggleAccountEdit,
                  onSavePressed: _saveAccountChanges
                ),
                _isEditingAccount 
                  ? _buildEditableInfoSection("Username", _usernameController)
                  : _buildInfoSection("Username", _usernameController.text),
                _isEditingAccount 
                  ? _buildEditableInfoSection("Email", _emailController)
                  : _buildInfoSection("Email", _emailController.text),
                SizedBox(height: 40),
                _buildSectionTitle(
                  "Personal Information", 
                  allowEdit: true, 
                  isEditing: _isEditingPersonal, 
                  onEditPressed: _togglePersonalEdit,
                  onSavePressed: _savePersonalChanges
                ),
                _isEditingPersonal 
                  ? _buildEditableFullWidthInfoSection("User Role", _userRoleController)
                  : _buildFullWidthInfoSection("User Role", _userRoleController.text),
                _isEditingPersonal 
                  ? _buildEditableFullWidthInfoSection("Your Events", _eventsController)
                  : _buildFullWidthInfoSection("Your Events", _eventsController.text),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 70,
            backgroundImage: AssetImage("assets/edffd94c476e8e57f4b604fe5ea2aafe.jpg"),
            child: (_isEditingAccount || _isEditingPersonal) ? 
              Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt, 
                  color: Colors.white, 
                  size: 50,
                ),
              ) : null,
          ),
          SizedBox(height: 15),
          Text(
            "Scarlet Deadpool",
            style: TextStyle(
              fontSize: 24,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    String title, {
    bool allowEdit = false, 
    bool isEditing = false, 
    VoidCallback? onEditPressed,
    VoidCallback? onSavePressed,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[800],
            ),
          ),
          if (allowEdit)
            IconButton(
              icon: Icon(
                isEditing ? Icons.check : Icons.edit, 
                color: Colors.amber,
              ),
              onPressed: isEditing ? onSavePressed : onEditPressed,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14, 
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableInfoSection(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14, 
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 5),
          TextField(
            controller: controller,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthInfoSection(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableFullWidthInfoSection(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 5),
          TextField(
            controller: controller,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, index: 0),
          _buildNavItem(Icons.add, index: 1),
          _buildNavItem(Icons.settings, index: 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, {required int index}) {
    final bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber.withOpacity(0.1) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.amber : Colors.grey,
        ),
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