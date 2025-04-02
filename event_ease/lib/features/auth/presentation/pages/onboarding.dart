import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:event_ease/core/providers/auth_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    // Check if the user is already authenticated on page load
  Future.microtask(() => _checkAuthenticationStatus());
  }

  void _checkAuthenticationStatus() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Delay checking if the provider is still loading
    if (authProvider.isLoading) {
      Future.delayed(Duration(milliseconds: 500), () => _checkAuthenticationStatus());
      return;
    }
      
      // Wait until the user data is fully  loaded
    if (authProvider.isLoading) return;

    // Redirect only if user is NOT authenticated
    if (authProvider.userData == null) {
      context.go('/login');
    }
    else if (authProvider.userData!.status == true) {
      context.go('/dashboard');
    }
  }
  
  // Form values
  final Map<String, bool> _roleSelections = {
    'Personal Event Planner': false,
    'Small Business Owner': false,
    'Nonprofit Organization': false,
    'Professional Event Planner': false,
    'Tourism stakeholder': false,
    'Community Organizer': false,
  };
  
  final Map<String, bool> _eventTypeSelections = {
    'Birthdays': false,
    'Weddings': false,
    'Corporate': false,
    'Meetings': false,
    'Other': false,
  };
  
  String? _selectedBudget;
  bool _acceptedTerms = false;

  // Define the steps - fixed the type definition
  late final List<Widget Function()> _stepsBuilders = [
    _buildRoleSelectionStep,
    _buildEventTypeAndBudgetStep,
    _buildTermsAndConditionsStep,
  ];

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _goToNextStep() async {
    if (_currentStep < _stepsBuilders.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      // On the last step and pressed "Finish"
      if (_acceptedTerms) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.saveOnboardingData(
          role: _roleSelections.entries.where((entry) => entry.value).map((entry) => entry.key).toList(),
          preferedBudget: _selectedBudget,
          preferedCategory: _eventTypeSelections.entries.where((entry) => entry.value).map((entry) => entry.key).toList(),
        );
        context.push('/dashboard');
      } else {
        // Show error that terms must be accepted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept the terms and conditions to continue'))
        );
      }
    }
  }


  Widget _buildRoleSelectionStep() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Let's get to know you better!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "What role do you play in event planning?",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: _roleSelections.keys.map((role) {
              // Simple custom checkbox implementation
              return InkWell(
                onTap: () {
                  setState(() {
                    _roleSelections[role] = !(_roleSelections[role] ?? false);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                          color: _roleSelections[role] == true ? Colors.amber : Colors.white,
                        ),
                        child: _roleSelections[role] == true
                            ? const Icon(Icons.check, size: 18, color: Colors.white)
                            : null,
                      ),
                      Text(role),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventTypeAndBudgetStep() {
    final budgetRanges = ['High', 'Medium', 'Low', 'I don\'t know', 'Prefer not to say'];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Now, What are we planning?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "What events do you often plan?",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: _eventTypeSelections.keys.map((type) {
              // Simple custom checkbox implementation
              return InkWell(
                onTap: () {
                  setState(() {
                    _eventTypeSelections[type] = !(_eventTypeSelections[type] ?? false);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                          color: _eventTypeSelections[type] == true ? Colors.amber : Colors.white,
                        ),
                        child: _eventTypeSelections[type] == true
                            ? const Icon(Icons.check, size: 18, color: Colors.white)
                            : null,
                      ),
                      Text(type),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            "What is your preferred budget range",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: budgetRanges.map((budget) {
              // Simple custom radio implementation
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedBudget = budget;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          shape: BoxShape.circle,
                          color: _selectedBudget == budget ? Colors.amber : Colors.white,
                        ),
                        child: _selectedBudget == budget
                            ? const Center(
                                child: Icon(Icons.circle, size: 12, color: Colors.white),
                              )
                            : null,
                      ),
                      Text(budget),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditionsStep() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Terms and conditions",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "EventEase Terms and Conditions",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Last Updated: [Insert Date]"),
                SizedBox(height: 8),
                Text(
                  "Welcome to EventEase. The following terms and conditions govern your access and use of the EventEase application and services.",
                ),
                SizedBox(height: 8),
                Text(
                  "1. Acceptance of Terms\nBy using EventEase, you agree to comply with these terms. If you do not agree, please refrain from using our services.",
                ),
                SizedBox(height: 8),
                Text(
                  "2. Description of Service\nEventEase is an AI-powered event planning and management platform that helps users plan, manage, and coordinate events. The service provides tools for event space booking, vendor selection, guest list management, budgeting tools, collaboration, task automation, and post-event features.",
                ),
                SizedBox(height: 8),
                Text(
                  "3. User Eligibility\n- You must be at least 18 years old to use our services. If under 18, you must have parental consent.\n- You are responsible for maintaining the confidentiality of your account information.",
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              setState(() {
                _acceptedTerms = !_acceptedTerms;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                      color: _acceptedTerms ? Colors.amber : Colors.white,
                    ),
                    child: _acceptedTerms
                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                        : null,
                  ),
                  const Text("I agree to the terms and conditions"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.white, Color(0xFFFFF3E0)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator - full width
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: List.generate(_stepsBuilders.length * 2 - 1, (index) {
                    // Even indices are dots, odd indices are lines
                    if (index % 2 == 0) {
                      final stepIndex = index ~/ 2;
                      return Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: stepIndex <= _currentStep ? Colors.amber : Colors.grey,
                        ),
                      );
                    } else {
                      final beforeStepIndex = index ~/ 2;
                      return Expanded(
                        child: Container(
                          height: 2,
                          color: beforeStepIndex < _currentStep ? Colors.amber : Colors.grey,
                        ),
                      );
                    }
                  }),
                ),
              ),
              
              // Main content
              Expanded(
                child: SingleChildScrollView(
                  child: _stepsBuilders[_currentStep](),
                ),
              ),
              
              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button (hidden on first step)
                    _currentStep > 0
                        ? TextButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20)
                          ),
                            onPressed: _goToPreviousStep,
                            child: const Text('Back'),
                          )
                        : TextButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20)
                          ),
                            onPressed: null,
                            child: const Text(''),
                          ),
                    
                    // Next/Finish button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                      onPressed: _goToNextStep,
                      child: Text(
                        _currentStep < _stepsBuilders.length - 1 ? 'Next' : 'Finish',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
