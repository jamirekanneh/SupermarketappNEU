import 'package:flutter/material.dart';
import 'My_orders_page.dart';

class ProfileMenuPage extends StatefulWidget {
  const ProfileMenuPage({super.key});

  @override
  State<ProfileMenuPage> createState() => _ProfileMenuPageState();
}

class _ProfileMenuPageState extends State<ProfileMenuPage>
    with SingleTickerProviderStateMixin {
  static const primaryBlue = Color(0xFF1E63FF);
  static const silverBlue = Color(0xFF5F7D8A);

  int rating = 4;

  late final AnimationController _avatarController;
  late final Animation<double> _avatarScale;
  late final Animation<double> _avatarOpacity;

  @override
  void initState() {
    super.initState();

    _avatarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _avatarScale =
        CurvedAnimation(parent: _avatarController, curve: Curves.easeOutBack);
    _avatarOpacity =
        CurvedAnimation(parent: _avatarController, curve: Curves.easeIn);

    _avatarController.forward();
  }

  @override
  void dispose() {
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1115) : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Center(
                child: Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 26),

              /// Animated Avatar + Name
              Center(
                child: FadeTransition(
                  opacity: _avatarOpacity,
                  child: ScaleTransition(
                    scale: _avatarScale,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor:
                              isDark ? silverBlue : const Color(0xFFFFD6C7),
                          child: Icon(
                            Icons.person,
                            size: 44,
                            color: isDark ? Colors.white : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Eric Starboy.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// Orders stat (Silver Bluish)
              Center(
                child: _StatCard(
                  value: "45",
                  label: "Orders",
                  isDark: isDark,
                ),
              ),

              const SizedBox(height: 26),

              /// MENU
              _sectionCard(
                isDark: isDark,
                children: [
                  _menuTile(
                    isDark: isDark,
                    icon: Icons.receipt_long_outlined,
                    title: "My Orders",
                    subtitle: "View past & ongoing orders",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyOrdersPage(),
                        ),
                      );
                    },
                  ),
                  _divider(isDark),
                  _menuTile(
                    isDark: isDark,
                    icon: Icons.credit_card_outlined,
                    title: "Payment Methods",
                    subtitle: "Manage cards & wallets",
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 26),

              /// EXPERIENCE
              _sectionTitle("Rate Your Experience", isDark),
              const SizedBox(height: 10),
              _sectionCard(
                isDark: isDark,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        Text(
                          "How was your experience?",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              onPressed: () => _submitRating(index + 1),
                              icon: Icon(
                                index < rating
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                color: Colors.amber,
                                size: 30,
                              ),
                            );
                          }),
                        ),
                        Text(
                          "$rating / 5",
                          style: TextStyle(
                            color:
                                isDark ? Colors.white70 : Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              /// SECURITY
              _sectionTitle("Security", isDark),
              const SizedBox(height: 10),
              _sectionCard(
                isDark: isDark,
                children: [
                  _menuTile(
                    isDark: isDark,
                    icon: Icons.logout,
                    title: "Logout",
                    subtitle: "Sign out of your account",
                    onTap: _confirmLogout,
                    customColor: silverBlue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= Actions =================

  void _submitRating(int value) {
    setState(() => rating = value);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Thank you for your feedback 💙"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Log out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: silverBlue),
            onPressed: () => Navigator.pop(context),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _sectionTitle(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 13,
        color: isDark ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _sectionCard({
    required List<Widget> children,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? const Color(0xFF1A1D23) : Colors.transparent,
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFEDEDED),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider(bool isDark) => Divider(
        height: 1,
        thickness: 1,
        color: isDark ? Colors.white12 : const Color(0xFFF1F1F1),
      );

  Widget _menuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
    Color? customColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color:
                    isDark ? Colors.white10 : const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: customColor ??
                    (isDark ? Colors.white : Colors.black87),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: customColor ??
                          (isDark ? Colors.white : Colors.black),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color:
                          isDark ? Colors.white70 : Colors.black54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? Colors.white38 : Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.isDark,
  });

  final String value;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 66,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF24303A)
            : const Color(0xFFE8EEF2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
