import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _imageQuality = 'High (Best Quality)';
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    return _buildDesktopLayout();
                  } else {
                    return _buildMobileLayout();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Theme.of(context).primaryColor, Colors.orangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            'Settings',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white, // This color is necessary for ShaderMask to work
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Customize your Wallpaper Studio experience',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: _buildSettingsCard(),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 2,
          child: _buildPhoneMockup(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildSettingsCard(),
        const SizedBox(height: 32),
        _buildPhoneMockup(),
      ],
    );
  }

  Widget _buildSettingsCard() {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wallpaper Setup',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              'Configure your wallpaper settings and enable auto-rotation',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 32),
            _buildImageQualityDropdown(),
            const SizedBox(height: 24),
            _buildNotificationSwitch(),
            const SizedBox(height: 40),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageQualityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Image Quality', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black87)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _imageQuality,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'High (Best Quality)', child: Text('High (Best Quality)')),
            DropdownMenuItem(value: 'Medium (Balanced)', child: Text('Medium (Balanced)')),
            DropdownMenuItem(value: 'Low (Fast)', child: Text('Low (Fast)')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _imageQuality = value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notification', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black87)),
              const SizedBox(height: 4),
              Text(
                'Get notified about new wallpapers and updates',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),
              ),
            ],
          ),
        ),
        Switch(
          value: _notificationsEnabled,
          onChanged: (value) => setState(() => _notificationsEnabled = value),
          activeColor: Theme.of(context).primaryColor,
          activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.5),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {},
          child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Settings Saved!')),
            );
          },
          child: const Text('Save Settings'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneMockup() {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final phone = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(48),
        border: Border.all(color: Colors.grey.shade300, width: 8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 9 / 19.5,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(36),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.link, color: Colors.green, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Connected to device',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Click to disconnect',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );

    if (isMobile) {
      return SizedBox(
        width: 258,
        height: 300,
        child: phone,
      );
    } else {
      return phone;
    }
  }
}
