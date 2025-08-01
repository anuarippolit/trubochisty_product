import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/culvert_data.dart';
import 'package:frontend/providers/culvert_provider.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/widgets/pipe_card.dart';
import 'package:frontend/widgets/culvert_sidebar.dart';
import 'package:frontend/widgets/settings/settings_screen.dart';
import 'package:frontend/screens/culvert_map_screen.dart';


class CulvertManagementScreen extends StatefulWidget {
  const CulvertManagementScreen({super.key});

  @override
  State<CulvertManagementScreen> createState() => _CulvertManagementScreenState();
}

class _CulvertManagementScreenState extends State<CulvertManagementScreen> {
  late CulvertProvider culvertProvider;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      culvertProvider = Provider.of<CulvertProvider>(context, listen: false);
      authProvider = Provider.of<AuthProvider>(context, listen: false);
      _fetchCulverts();
    });
  }

  Future<void> _fetchCulverts() async {
    if (authProvider.user != null) {
      await culvertProvider.fetchCulverts(authProvider.user!);
    }
  }

  void _createCulvert() {
    if (authProvider.user != null) {
      culvertProvider.createNewCulvertWithSave(context, authProvider.user!);
    }
  }

  void _editCulvert(CulvertData culvert) {
    if (authProvider.user != null) {
      culvertProvider.editCulvert(context, authProvider.user!, culvert);
    }
  }

  void _deleteCulvert(String id) async {
    if (authProvider.user != null) {
      await culvertProvider.deleteCulvert(id, authProvider.user!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final culvertList = context.watch<CulvertProvider>().culverts;
    final isDesktop = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление трубами'),
        actions: [
          IconButton(
  icon: const Icon(Icons.map_outlined),
  tooltip: 'Открыть карту',
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CulvertMapScreen(),
      ),
    );
  },
),

          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(isFullScreen: true),
                ),
              );
            },
          ),
        ],
      ),
      drawer: isDesktop ? null : const CulvertSidebar(),
      body: Row(
        children: [
          if (isDesktop) const CulvertSidebar(),
          Expanded(
            child: culvertList.isEmpty
                ? const Center(child: Text('Нет данных о трубах.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: culvertList.length,
                    itemBuilder: (context, index) {
                      final culvert = culvertList[index];
                      return Padding(
  padding: const EdgeInsets.symmetric(vertical: 8),
  child: PipeCard(
  culvert: culvert,
  onEdit: () {
    culvertProvider.editCulvert(context, authProvider.user!, culvert);
  },
  onDelete: () {
    culvertProvider.deleteCulvert(culvert.id!, authProvider.user!);
  },
),
);

                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createCulvert,
        icon: const Icon(Icons.add),
        label: const Text('Добавить трубу'),
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/culvert_provider.dart';
// import '../widgets/culvert_sidebar.dart';
// import '../widgets/pipe_card.dart';
// import '../widgets/gesture_wrapper.dart';
// import '../widgets/settings/settings_screen.dart';
// import '../screens/culvert_map_screen.dart';
// import '../services/shortcuts_service.dart';

// class CulvertManagementScreen extends StatefulWidget {
//   const CulvertManagementScreen({super.key});

//   @override
//   State<CulvertManagementScreen> createState() => _CulvertManagementScreenState();
// }

// class _CulvertManagementScreenState extends State<CulvertManagementScreen>
//     with TickerProviderStateMixin {
//   bool _isSidebarOpen = false;
//   late AnimationController _sidebarAnimationController;
//   late AnimationController _headerAnimationController;
//   late Animation<Offset> _sidebarSlideAnimation;
//   late Animation<double> _headerFadeAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _sidebarAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _headerAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );

//     _sidebarSlideAnimation = Tween<Offset>(
//       begin: const Offset(-1.0, 0.0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _sidebarAnimationController,
//       curve: Curves.easeInOut,
//     ));

//     _headerFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _headerAnimationController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     // Start header animation
//     _headerAnimationController.forward();
//   }

//   @override
//   void dispose() {
//     _sidebarAnimationController.dispose();
//     _headerAnimationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isMobile = screenWidth < 768;
//     final isTablet = screenWidth >= 768 && screenWidth < 1200;
//     final isDesktop = screenWidth >= 1200;

//     return Scaffold(
//   backgroundColor: Theme.of(context).colorScheme.surface,
//   appBar: isMobile
//     ? AppBar(
//         title: const Text('Трубы'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.map),
//             tooltip: 'Показать на карте',
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const CulvertMapScreen(),
//                 ),
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               // Handle add culvert
//             },
//           ),
//         ],
//       )
//     : null,

//   floatingActionButton: !isMobile
//       ? Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             FloatingActionButton(
//               heroTag: "map_button",
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const CulvertMapScreen()),
//                 );
//               },
//               child: const Icon(Icons.map),
//               tooltip: 'Открыть карту',
//             ),
//             const SizedBox(width: 16),
//             FloatingActionButton(
//               heroTag: "add_button",
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Добавить трубу — логика не реализована')),
//                 );
//               },
//               child: const Icon(Icons.add),
//               tooltip: 'Добавить трубу',
//             ),
//           ],
//         )
//       : null,
//       body: SafeArea(
//         child: GestureWrapper(
//           sidebarVisible: _isSidebarOpen,
//           onOpenSidebar: _openSidebar,
//           onCloseSidebar: _closeSidebar,
//           child: Row(
//             children: [
//               if (isDesktop || (isTablet && !_isSidebarOpen))
//                 const CulvertSidebar(),
//               Expanded(
//                 child: Stack(
//                   children: [
//                     _buildMainContent(isMobile, isTablet, isDesktop),
//                     if (isMobile && _isSidebarOpen) _buildMobileSidebar(),
//                     if (isMobile) _buildMobileHeader(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _openSidebar() {
//     setState(() {
//       _isSidebarOpen = true;
//     });
//     _sidebarAnimationController.forward();
//   }

//   void _closeSidebar() {
//     _sidebarAnimationController.reverse().then((_) {
//       if (mounted) {
//         setState(() {
//           _isSidebarOpen = false;
//         });
//       }
//     });
//   }

//   Widget _buildMainContent(bool isMobile, bool isTablet, bool isDesktop) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//       constraints: BoxConstraints(
//         maxWidth: isDesktop ? 1200 : double.infinity,
//       ),
//       child: Center(
//         child: Consumer<CulvertProvider>(
//           builder: (context, provider, _) {
//             if (provider.selectedCulvert == null) {
//               return _buildEmptyState();
//             }

//             return AnimatedSwitcher(
//               duration: const Duration(milliseconds: 400),
//               transitionBuilder: (child, animation) {
//                 return FadeTransition(
//                   opacity: animation,
//                   child: SlideTransition(
//                     position: Tween<Offset>(
//                       begin: const Offset(0.05, 0),
//                       end: Offset.zero,
//                     ).animate(CurvedAnimation(
//                       parent: animation,
//                       curve: Curves.easeOutCubic,
//                     )),
//                     child: child,
//                   ),
//                 );
//               },
//               child: Padding(
//                 key: ValueKey('${provider.selectedCulvert!.serialNumber}_${provider.selectedCulvert!.address}'),
//                 padding: EdgeInsets.only(
//                   top: isMobile ? 60 : 0,
//                   left: isMobile ? 16 : 24,
//                   right: isMobile ? 16 : 24,
//                   bottom: 16,
//                 ),
//                 child: PipeCard(
//                   initialData: provider.selectedCulvert,
//                   onDataChanged: provider.updateCulvert,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildMobileHeader() {
//     // unchanged
//     return const SizedBox.shrink();
//   }

//   Widget _buildMobileSidebar() {
//     return Positioned.fill(
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         color: Colors.black.withOpacity(_isSidebarOpen ? 0.6 : 0),
//         child: GestureDetector(
//           onTap: _closeSidebar,
//           child: Material(
//             color: Colors.transparent,
//             child: SlideTransition(
//               position: _sidebarSlideAnimation,
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: CulvertSidebar(
//                   isMobile: true,
//                   onClose: _closeSidebar,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 600),
//       curve: Curves.easeOutCubic,
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(32),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TweenAnimationBuilder<double>(
//                 tween: Tween(begin: 0, end: 1),
//                 duration: const Duration(milliseconds: 800),
//                 curve: Curves.elasticOut,
//                 builder: (context, value, child) {
//                   return Transform.scale(
//                     scale: value,
//                     child: Container(
//                       padding: const EdgeInsets.all(24),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             colorScheme.primaryContainer.withOpacity(0.2),
//                             colorScheme.secondaryContainer.withOpacity(0.1),
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(24),
//                         boxShadow: [
//                           BoxShadow(
//                             color: colorScheme.primary.withOpacity(0.1),
//                             blurRadius: 20,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                       ),
//                       child: Icon(
//                         Icons.water_rounded,
//                         size: 64,
//                         color: colorScheme.primary.withOpacity(0.7),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 24),
//               TweenAnimationBuilder<double>(
//                 tween: Tween(begin: 0, end: 1),
//                 duration: const Duration(milliseconds: 1000),
//                 curve: Curves.easeOutCubic,
//                 builder: (context, value, child) {
//                   return Opacity(
//                     opacity: value,
//                     child: Transform.translate(
//                       offset: Offset(0, (1 - value) * 20),
//                       child: child,
//                     ),
//                   );
//                 },
//                 child: Column(
//                   children: [
//                     Text(
//                       'Выберите трубу для просмотра',
//                       style: theme.textTheme.headlineSmall?.copyWith(
//                         color: colorScheme.onSurface.withOpacity(0.8),
//                         fontWeight: FontWeight.w600,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       ShortcutsService.isMobile
//                           ? 'Свайпните вправо или нажмите на иконку поиска'
//                           : 'Используйте боковую панель для поиска и выбора трубы',
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         color: colorScheme.onSurface.withOpacity(0.6),
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     if (ShortcutsService.isDesktop) ...[
//                       const SizedBox(height: 16),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: colorScheme.primaryContainer.withOpacity(0.3),
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(
//                             color: colorScheme.primary.withOpacity(0.2),
//                           ),
//                         ),
//                         child: Text(
//                           '${ShortcutsService.modifierKey}+N для создания новой трубы',
//                           style: theme.textTheme.labelSmall?.copyWith(
//                             color: colorScheme.primary,
//                             fontFamily: 'monospace',
//                           ),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showSettings() {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => const SettingsScreen(isFullScreen: true),
//       ),
//     );
//   }
// }
