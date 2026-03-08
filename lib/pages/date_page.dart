// lib/pages/date_page.dart
import 'package:flutter/material.dart';

// Contoh penggunaan DatePicker & TimePicker (PART 4 - Pertemuan 5)
class DateTimePickerDemo extends StatefulWidget {
  const DateTimePickerDemo({super.key});

  @override
  State<DateTimePickerDemo> createState() => _DateTimePickerDemoState();
}

class _DateTimePickerDemoState extends State<DateTimePickerDemo> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Fungsi untuk menampilkan DatePicker
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1990),       // Batas awal
      lastDate: DateTime(2030),        // Batas akhir
      helpText: 'Pilih Tanggal Lahir', // Judul dialog
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // Fungsi untuk menampilkan TimePicker
  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      helpText: 'Pilih Waktu',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  // Format tanggal manual (tanpa package intl)
  String _formatDate(DateTime date) {
    final months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Date & Time Picker')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === DATE PICKER ===
            _buildSectionTitle('📅 Date Picker'),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.blue),
              title: const Text('Tanggal Lahir'),
              subtitle: Text(
                _selectedDate != null
                    ? _formatDate(_selectedDate!)
                    : 'Belum dipilih',
              ),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: _pickDate,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 16),

            // === TIME PICKER ===
            _buildSectionTitle('⏰ Time Picker'),
            ListTile(
              leading: const Icon(Icons.access_time, color: Colors.orange),
              title: const Text('Waktu'),
              subtitle: Text(
                _selectedTime != null
                    ? _selectedTime!.format(context)
                    : 'Belum dipilih',
              ),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: _pickTime,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
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
                  Text(
                    '📅 Tanggal: ${_selectedDate != null ? _formatDate(_selectedDate!) : "Belum dipilih"}',
                  ),
                  Text(
                    '⏰ Waktu: ${_selectedTime != null ? _selectedTime!.format(context) : "Belum dipilih"}',
                  ),
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
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}