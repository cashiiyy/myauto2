import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/location_provider.dart';
import '../providers/auto_provider.dart';
import '../providers/auth_provider.dart';
import '../models/auto_model.dart';
import '../widgets/auto_details_sheet.dart';
import 'activity_screen.dart';
import 'profile_screen.dart';
import '../providers/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final MapController _mapController = MapController();
  int _currentIndex = 0;
  AutoModel? _selectedAuto;
  double _distanceToAuto = 0.0;
  


  void _selectAuto(AutoModel auto, Position? currentPos) {
    if (currentPos != null) {
      _distanceToAuto = Geolocator.distanceBetween(
        currentPos.latitude, currentPos.longitude, 
        auto.latitude, auto.longitude
      ) / 1000.0;
    }
    setState(() {
      _selectedAuto = auto;
    });
  }

  void _callSos() async {
    final sosNumber = ref.read(sosContactProvider);
    final Uri url = Uri(scheme: 'tel', path: sosNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _reloadMap() {
    final pos = ref.read(currentLocationProvider).value;
    if (pos != null) {
      _mapController.move(LatLng(pos.latitude, pos.longitude), _mapController.camera.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: [
              _buildMapTab(),
              const ActivityScreen(),
              const ProfileScreen(),
            ],
          ),
          
          // Hide bottom bar slightly if auto is selected so they don't overlap,
          // but user said "make the bottom bar pop up only when user selects an auto". 
          // Wait, if bottom tabs pop up ONLY when auto is selected? No, bottom tabs are navigation.
          // The DETAILS pop up. I'll animate the details.
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            bottom: _selectedAuto == null ? 30 : -100, // slide out of view if details are up
            left: 20,
            right: 20,
            child: _buildCustomBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapTab() {
    final locationAsync = ref.watch(currentLocationProvider);
    final userAsync = ref.watch(currentUserProvider);
    
    // Determine which stream to listen to based on current user role
    final role = userAsync.value?.role ?? 'passenger';
    final mapMarkersAsync = role == 'passenger' 
        ? ref.watch(autoListStreamProvider) 
        : ref.watch(activePassengerListStreamProvider);

    return Stack(
      children: [
        locationAsync.when(
          data: (position) {
            if (position == null) return const Center(child: Text('Location Denied.'));
            final userLocation = LatLng(position.latitude, position.longitude);

            return GestureDetector(
              onTap: () {
                if (_selectedAuto != null) {
                   setState(() => _selectedAuto = null);
                }
              },
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: userLocation,
                  initialZoom: 15.0,
                  onTap: (tapPosition, point) {
                    setState(() => _selectedAuto = null);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.my_auto',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: userLocation,
                        width: 40, height: 40,
                        child: const Icon(Icons.my_location, color: Colors.blue, size: 30),
                      ),
                      
                      // Map active targets from corresponding stream
                      ...mapMarkersAsync.when(
                        data: (targetList) => targetList.map((target) {
                          final isSelected = _selectedAuto?.id == target.id;
                          return Marker(
                            point: LatLng(target.latitude, target.longitude),
                            width: isSelected ? 60 : 50,
                            height: isSelected ? 60 : 50,
                            child: GestureDetector(
                              onTap: () => _selectAuto(target, position),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: target.isAvailable ? Colors.green.withValues(alpha: 0.5) : Colors.red.withValues(alpha: 0.4),
                                      shape: BoxShape.circle,
                                      border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
                                    ),
                                    width: isSelected ? 50 : 40, 
                                    height: isSelected ? 50 : 40,
                                  ),
                                  Text(role == 'passenger' ? '🛺' : '🧍', style: TextStyle(fontSize: isSelected ? 30 : 24)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        loading: () => [],
                        error: (_, __) => [],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),

        if (_currentIndex == 0) ...[
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            right: 20,
            child: FloatingActionButton(
              heroTag: 'refresh',
              backgroundColor: const Color(0xFFFFDDBA).withValues(alpha: 0.9),
              elevation: 4,
              mini: true,
              onPressed: _reloadMap,
              child: const Icon(Icons.refresh, color: Colors.black87),
            ),
          ),
          
          Positioned(
            top: MediaQuery.of(context).padding.top + 70,
            right: 20,
            child: FloatingActionButton(
              heroTag: 'locate',
              backgroundColor: const Color(0xFFD0E4FF).withValues(alpha: 0.9),
              elevation: 4,
              mini: true,
              onPressed: () {
                final pos = ref.read(currentLocationProvider).value;
                if (pos != null) {
                  _mapController.move(LatLng(pos.latitude, pos.longitude), 15.0);
                }
              },
              child: const Icon(Icons.my_location, color: Colors.black87),
            ),
          ),

          Positioned(
            bottom: _selectedAuto == null ? 120 : 350, // Move up if details are shown
            left: 20,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: FloatingActionButton(
                heroTag: 'sos',
                backgroundColor: const Color(0xFFFF4B4B),
                elevation: 4,
                shape: const CircleBorder(),
                onPressed: _callSos,
                child: const Icon(Icons.call, color: Colors.white, size: 28),
              ),
            ),
          ),

          // Sliding Auto Details Sheet
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            bottom: _selectedAuto == null ? -400 : 0,
            left: 0,
            right: 0,
            height: 350,
            child: _selectedAuto != null 
              ? AutoDetailsSheet(
                  auto: _selectedAuto!, 
                  distance: _distanceToAuto,
                  onClose: () => setState(() => _selectedAuto = null),
                )
              : const SizedBox(),
          ),
        ],
      ],
    );
  }

  Widget _buildCustomBottomBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16), // Heavy Glass
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.black.withValues(alpha: 0.4) 
                : Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabItem(0, 'Map', Icons.place),
                  _buildTabItem(1, 'Activity', Icons.notes),
                  _buildTabItem(2, 'Profile', Icons.person),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String label, IconData icon) {
    bool isSelected = _currentIndex == index;
    const activeColor = Color(0xFF007AFF); // Vivid Blue for selected
    return GestureDetector(
      onTap: () => setState(() {
        _currentIndex = index;
        if(index != 0) _selectedAuto = null; 
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
             ? (Theme.of(context).brightness == Brightness.dark ? activeColor.withValues(alpha: 0.2) : activeColor.withValues(alpha: 0.1))
             : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : (Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.grey[600]),
              size: 20,
            ),
            if (isSelected)
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: activeColor,
                ),
              )
          ],
        ),
      ),
    );
  }
}
