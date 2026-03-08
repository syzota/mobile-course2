// lib/pages/registrant_list_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/registration_provider.dart';

class RegistrantListPage extends StatefulWidget {
  const RegistrantListPage({super.key});

  @override
  State<RegistrantListPage> createState() => _RegistrantListPageState();
}

class _RegistrantListPageState extends State<RegistrantListPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<RegistrationProvider>(
          builder: (context, provider, _) {
            return Text('Daftar Peserta (${provider.count})');
          },
        ),
      ),

      body: Consumer<RegistrationProvider>(
        builder: (context, provider, child) {
          // FILTER DATA BERDASARKAN SEARCH
          final filteredRegistrants = provider.registrants.where((r) {
            return r.name.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          if (provider.registrants.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada pendaftar',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Daftar sekarang di halaman registrasi!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // SEARCH BAR
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Cari nama pendaftar...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),

              // LIST DATA
              Expanded(
                child: filteredRegistrants.isEmpty
                    ? const Center(child: Text('Data tidak ditemukan'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: filteredRegistrants.length,
                        itemBuilder: (context, index) {
                          final registrant = filteredRegistrants[index];

                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(registrant.name[0].toUpperCase()),
                              ),
                              title: Text(
                                registrant.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${registrant.programStudi} • ${registrant.email}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Hapus Pendaftar?'),
                                      content: Text(
                                        'Yakin hapus ${registrant.name}?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: const Text('Batal'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            provider.removeRegistrant(
                                              registrant.id,
                                            );
                                            Navigator.pop(ctx);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          child: const Text('Hapus'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/detail',
                                  arguments: registrant.id,
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
