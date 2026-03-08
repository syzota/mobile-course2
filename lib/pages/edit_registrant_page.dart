import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/registrant_model.dart';
import '../providers/registration_provider.dart';

class EditRegistrantPage extends StatefulWidget {
  const EditRegistrantPage({super.key});

  @override
  State<EditRegistrantPage> createState() => _EditRegistrantPageState();
}

class _EditRegistrantPageState extends State<EditRegistrantPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedProdi;

  final List<String> _prodiList = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Teknik Komputer',
    'Data Science',
    'Desain Komunikasi Visual',
  ];

  late Registrant registrant;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final id = ModalRoute.of(context)!.settings.arguments as String;
    final provider = context.read<RegistrationProvider>();

    registrant = provider.getById(id)!;

    _nameController.text = registrant.name;
    _emailController.text = registrant.email;
    _selectedProdi = registrant.programStudi;
  }

  void _submitEdit() {
    if (!_formKey.currentState!.validate()) return;

    final updated = Registrant(
      id: registrant.id,
      name: _nameController.text,
      email: _emailController.text,
      gender: registrant.gender,
      programStudi: _selectedProdi!,
      dateOfBirth: registrant.dateOfBirth,
      registeredAt: registrant.registeredAt,
    );

    context.read<RegistrationProvider>().updateRegistrant(updated);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Pendaftar")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama tidak boleh kosong";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedProdi,
                items: _prodiList.map((prodi) {
                  return DropdownMenuItem(value: prodi, child: Text(prodi));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProdi = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Program Studi",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submitEdit,
                child: const Text("Simpan Perubahan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
