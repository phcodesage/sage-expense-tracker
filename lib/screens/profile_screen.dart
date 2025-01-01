import 'package:flutter/material.dart';
import 'package:sage_expense_tracker/widgets/bottom_navigation.dart';
import 'package:sage_expense_tracker/main.dart';
import 'package:sage_expense_tracker/widgets/circle_reveal_clipper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0097A7), // Teal
              Color(0xFFFFC67D), // Coral
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Image and Username
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/profile_avatar.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '@enjelin_morgeana',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Profile Options
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildProfileOption(
                      icon: Icons.diamond_outlined,
                      title: 'Invite Friends',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.person_outline,
                      title: 'Account info',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.people_outline,
                      title: 'Personal profile',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.message_outlined,
                      title: 'Message center',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.security_outlined,
                      title: 'Login and security',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.lock_outline,
                      title: 'Data and privacy',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0097A7),
              Color(0xFFFFC67D),
            ],
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return Material(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                      ),
                      child: AddExpenseScreen(
                        onExpenseAdded: (expense) {
                          // Handle the new expense if needed in profile screen
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 300),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  final screenSize = MediaQuery.of(context).size;
                  final fabPosition = MediaQuery.of(context).size.height - 80;
                  
                  return Stack(
                    children: [
                      child,
                      AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          return ClipPath(
                            clipper: CircleRevealClipper(
                              center: Offset(
                                screenSize.width / 2,
                                fabPosition,
                              ),
                              radius: animation.value * screenSize.height * 1.5,
                            ),
                            child: child,
                          );
                        },
                        child: child,
                      ),
                    ],
                  );
                },
              ),
            );
          },
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onIndexChanged: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.grey[600], size: 28),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }
} 