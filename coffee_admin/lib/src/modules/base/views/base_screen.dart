import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../auth/blocs/sing_in_bloc/sign_in_bloc.dart';

class BaseScreen extends StatefulWidget {
  final Widget child;
  const BaseScreen(this.child, {super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  static const List<_NavItem> _navItems = <_NavItem>[
    _NavItem(
      label: 'Dashboard',
      route: '/home',
      icon: CupertinoIcons.chart_bar_alt_fill,
    ),
    _NavItem(
      label: 'Products',
      route: '/create',
      icon: CupertinoIcons.cube_box_fill,
    ),
    _NavItem(
      label: 'Orders',
      route: '/orders',
      icon: CupertinoIcons.list_bullet_below_rectangle,
    ),
    _NavItem(
      label: 'Users',
      route: '/profile',
      icon: CupertinoIcons.person_2_fill,
    ),
  ];

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/create')) return 1;
    if (location.startsWith('/orders')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _goToIndex(BuildContext context, int index) {
    context.go(_navItems[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final isWide = MediaQuery.of(context).size.width >= 1000;
    final title = _navItems[selectedIndex].label;

    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignOutSuccess) {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: isWide
            ? null
            : Drawer(
                child: SafeArea(
                  child: _NavigationPanel(
                    selectedIndex: selectedIndex,
                    onSelected: (index) {
                      Navigator.of(context).pop();
                      _goToIndex(context, index);
                    },
                  ),
                ),
              ),
        bottomNavigationBar: isWide
            ? null
            : NavigationBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: (index) {
                  _goToIndex(context, index);
                },
                destinations: _navItems
                    .map(
                      (item) => NavigationDestination(
                        icon: Icon(item.icon),
                        label: item.label,
                      ),
                    )
                    .toList(growable: false),
              ),
        body: SafeArea(
          child: isWide
              ? Row(
                  children: [
                    SizedBox(
                      width: 280,
                      child: _NavigationPanel(
                        selectedIndex: selectedIndex,
                        onSelected: (index) {
                          _goToIndex(context, index);
                        },
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          _TopBar(
                            title: title,
                            onLogout: () {
                              context.read<SignInBloc>().add(SignOutRequired());
                            },
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 24, 24),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: widget.child,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _TopBar(
                      title: title,
                      showMenu: true,
                      onLogout: () {
                        context.read<SignInBloc>().add(SignOutRequired());
                      },
                    ),
                    Expanded(child: widget.child),
                  ],
                ),
        ),
      ),
    );
  }
}

class _NavigationPanel extends StatelessWidget {
  const _NavigationPanel({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2C1B16),
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DrinkHub Admin',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Quản lý đồ uống, đơn hàng và khách hàng trong một không gian.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ..._BaseScreenState._navItems.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _SideNavTile(
                    item: entry.value,
                    selected: entry.key == selectedIndex,
                    onTap: () => onSelected(entry.key),
                  ),
                ),
              ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFD8A66A),
                  child: Icon(CupertinoIcons.person_fill, color: Colors.black),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Admin workspace',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.onLogout,
    this.showMenu = false,
  });

  final String title;
  final VoidCallback onLogout;
  final bool showMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
      child: Row(
        children: [
          if (showMenu)
            Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu_rounded),
              ),
            ),
          if (showMenu) const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Operational dashboard for products, orders, and users.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const CircleAvatar(
            backgroundColor: Color(0xFFD8A66A),
            child: Icon(CupertinoIcons.person_fill, color: Colors.black),
          ),
          const SizedBox(width: 12),
          FilledButton.tonalIcon(
            onPressed: onLogout,
            icon: const Icon(CupertinoIcons.arrow_right_to_line),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _SideNavTile extends StatelessWidget {
  const _SideNavTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withValues(alpha: 0.14)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? Colors.white.withValues(alpha: 0.16)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(item.icon, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              item.label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.route,
    required this.icon,
  });

  final String label;
  final String route;
  final IconData icon;
}
