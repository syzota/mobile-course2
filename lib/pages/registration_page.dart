// lib/pages/registration_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/registrant_model.dart';
import '../providers/registration_provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  int _currentStep = 0;

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dateController = TextEditingController();

  // State
  bool _obscurePassword = true;
  String _selectedGender = 'Laki-laki';
  String? _selectedProdi;
  DateTime? _selectedDate;
  bool _agreeTerms = false;

  final List<String> _prodiList = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Teknik Komputer',
    'Data Science',
    'Desain Komunikasi Visual',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2004, 1, 1),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      helpText: 'Pilih Tanggal Lahir',
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  void _submitForm() {
    // Validate form
    if (!_formKey.currentState!.validate()) return;

    // Check checkbox
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap setujui syarat & ketentuan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check email duplicate
    final provider = context.read<RegistrationProvider>();
    if (provider.isEmailRegistered(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email sudah terdaftar!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Create registrant
    final registrant = Registrant(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      gender: _selectedGender,
      programStudi: _selectedProdi!,
      dateOfBirth: _selectedDate!,
    );

    // Add to provider
    provider.addRegistrant(registrant);

    // Show success
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Registrasi Berhasil!'),
        content: Text('${registrant.name} berhasil didaftarkan.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _resetForm();
            },
            child: const Text('Daftar Lagi'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushNamed(context, '/list');
            },
            child: const Text('Lihat Daftar'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _dateController.clear();
    setState(() {
      _selectedGender = 'Laki-laki';
      _selectedProdi = null;
      _selectedDate = null;
      _agreeTerms = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi Event'),
        actions: [
          // Badge jumlah pendaftar
          Consumer<RegistrationProvider>(
            builder: (context, provider, child) {
              return Badge(
                label: Text('${provider.count}'),
                isLabelVisible: provider.count > 0,
                child: IconButton(
                  icon: const Icon(Icons.people),
                  onPressed: () => Navigator.pushNamed(context, '/list'),
                ),
              );
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Stepper(
          currentStep: _currentStep,

          onStepContinue: () {
            if (_currentStep == 0) {
              if (_nameController.text.isEmpty ||
                  _emailController.text.isEmpty ||
                  _passwordController.text.isEmpty) {
                _formKey.currentState!.validate();
                return;
              }
            }

            if (_currentStep == 1) {
              if (_selectedProdi == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pilih program studi dulu')),
                );
                return;
              }
            }

            if (_currentStep == 2) {
              if (_dateController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pilih tanggal lahir')),
                );
                return;
              }

              if (!_agreeTerms) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Setujui syarat & ketentuan')),
                );
                return;
              }

              _submitForm();
              return;
            }

            setState(() {
              _currentStep++;
            });
          },

          steps: [
            Step(
              title: const Text('Data Diri'),
              isActive: _currentStep >= 0,
              content: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama wajib diisi';
                      }
                      if (value.length < 3) {
                        return 'Nama minimal 3 karakter';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email wajib diisi';
                      }

                      final emailRegex = RegExp(
                        r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
                      );

                      if (!emailRegex.hasMatch(value)) {
                        return 'Format email tidak valid';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password wajib diisi';
                      }
                      if (value.length < 6) {
                        return 'Password minimal 6 karakter';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            Step(
              title: const Text('Informasi Akademik'),
              isActive: _currentStep >= 1,
              content: Column(
                children: [
                  const Text('Jenis Kelamin'),

                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Laki-laki'),
                          value: 'Laki-laki',
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                        ),
                      ),

                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Perempuan'),
                          value: 'Perempuan',
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _selectedProdi,
                    hint: const Text('Pilih Program Studi'),
                    decoration: const InputDecoration(
                      labelText: 'Program Studi',
                      border: OutlineInputBorder(),
                    ),
                    items: _prodiList.map((prodi) {
                      return DropdownMenuItem(value: prodi, child: Text(prodi));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedProdi = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Pilih program studi';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            Step(
              title: const Text('Konfirmasi'),
              isActive: _currentStep >= 2,
              content: Column(
                children: [
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Lahir',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    onTap: _pickDate,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tanggal lahir wajib dipilih';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  CheckboxListTile(
                    title: const Text('Saya setuju dengan syarat & ketentuan'),
                    value: _agreeTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreeTerms = value ?? false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
