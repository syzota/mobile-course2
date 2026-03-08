// lib/pages/input_widgets_page.dart
import 'package:flutter/material.dart';

class InputWidgetsPage extends StatefulWidget {
  const InputWidgetsPage({super.key});

  @override
  State<InputWidgetsPage> createState() => _InputWidgetsPageState();
}

class _InputWidgetsPageState extends State<InputWidgetsPage> {
  // Checkbox
  bool _agreeTerms = false;
  bool _subscribeNewsletter = false;

  // Radio
  String _selectedGender = 'Laki-laki';

  // Switch
  bool _darkMode = false;
  bool _notifications = true;

  // Slider
  double _satisfaction = 5.0;
  double _fontSize = 16.0;

  // Dropdown
  String? _selectedProdi;
  final List<String> _prodiList = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Teknik Komputer',
    'Data Science',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Widgets Showcase'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === CHECKBOX ===
            _buildSectionTitle('☑️ Checkbox'),
            CheckboxListTile(
              title: const Text('Saya setuju dengan syarat & ketentuan'),
              subtitle: const Text('Wajib dicentang'),
              value: _agreeTerms,
              onChanged: (value) {
                setState(() => _agreeTerms = value ?? false);
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text('Berlangganan newsletter'),
              subtitle: const Text('Opsional'),
              value: _subscribeNewsletter,
              onChanged: (value) {
                setState(() => _subscribeNewsletter = value ?? false);
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const Divider(),

            // === RADIO ===
            _buildSectionTitle('🔘 Radio Button'),
            const Text('Jenis Kelamin:'),
            RadioListTile<String>(
              title: const Text('Laki-laki'),
              value: 'Laki-laki',
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() => _selectedGender = value!);
              },
            ),
            RadioListTile<String>(
              title: const Text('Perempuan'),
              value: 'Perempuan',
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() => _selectedGender = value!);
              },
            ),
            const Divider(),

            // === SWITCH ===
            _buildSectionTitle('🔀 Switch'),
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: Text(_darkMode ? 'Aktif' : 'Nonaktif'),
              value: _darkMode,
              onChanged: (value) {
                setState(() => _darkMode = value);
              },
              secondary: Icon(
                _darkMode ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
            SwitchListTile(
              title: const Text('Notifikasi'),
              subtitle: Text(_notifications ? 'Aktif' : 'Nonaktif'),
              value: _notifications,
              onChanged: (value) {
                setState(() => _notifications = value);
              },
              secondary: const Icon(Icons.notifications),
            ),
            const Divider(),

            // === SLIDER ===
            _buildSectionTitle('🎚️ Slider'),
            const Text('Tingkat Kepuasan:'),
            Slider(
              value: _satisfaction,
              min: 0,
              max: 10,
              divisions: 10,
              label: _satisfaction.round().toString(),
              onChanged: (value) {
                setState(() => _satisfaction = value);
              },
            ),
            Text(
              'Nilai: ${_satisfaction.round()}/10',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text('Ukuran Font:'),
            Slider(
              value: _fontSize,
              min: 12,
              max: 32,
              divisions: 20,
              label: '${_fontSize.round()}px',
              onChanged: (value) {
                setState(() => _fontSize = value);
              },
            ),
            Text(
              'Preview: Hello World!',
              style: TextStyle(fontSize: _fontSize),
            ),
            const Divider(),

            // === DROPDOWN ===
            _buildSectionTitle('📋 DropdownButtonFormField'),
            DropdownButtonFormField<String>(
              initialValue: _selectedProdi,
              decoration: const InputDecoration(
                labelText: 'Program Studi',
                prefixIcon: Icon(Icons.school),
                border: OutlineInputBorder(),
              ),
              hint: const Text('Pilih Program Studi'),
              items: _prodiList.map((prodi) {
                return DropdownMenuItem<String>(
                  value: prodi,
                  child: Text(prodi),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedProdi = value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pilih program studi';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // === SUMMARY ===
            _buildSectionTitle('📊 Summary'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('✅ Setuju T&C: $_agreeTerms'),
                  Text('📧 Newsletter: $_subscribeNewsletter'),
                  Text('👤 Gender: $_selectedGender'),
                  Text('🌙 Dark Mode: $_darkMode'),
                  Text('🔔 Notifikasi: $_notifications'),
                  Text('⭐ Kepuasan: ${_satisfaction.round()}/10'),
                  Text('📏 Font Size: ${_fontSize.round()}px'),
                  Text('🎓 Prodi: ${_selectedProdi ?? "Belum dipilih"}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}