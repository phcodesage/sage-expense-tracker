import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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