import 'package:flutter/material.dart';
import 'package:sage_expense_tracker/screens/wallet_screen.dart';
import 'package:sage_expense_tracker/screens/profile_screen.dart';
import 'package:sage_expense_tracker/main.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              const SizedBox(width: 24),
              Expanded(
                child: _buildNavItem(
                  context,
                  index: 0,
                  icon: Icons.home_outlined,
                  label: 'Home',
                  onTap: () {
                    if (selectedIndex != 0) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (route) => false,
                      );
                    }
                    onIndexChanged(0);
                  },
                ),
              ),
              const Spacer(flex: 2),
              Expanded(
                child: _buildNavItem(
                  context,
                  index: 1,
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Wallet',
                  onTap: () {
                    if (selectedIndex != 1) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const WalletScreen()),
                        (route) => false,
                      );
                    }
                    onIndexChanged(1);
                  },
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  context,
                  index: 2,
                  icon: Icons.person_outline,
                  label: 'Profile',
                  onTap: () {
                    if (selectedIndex != 2) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                        (route) => false,
                      );
                    }
                    onIndexChanged(2);
                  },
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
} 