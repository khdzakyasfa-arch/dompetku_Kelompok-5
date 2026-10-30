import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';

class TambahPengeluaranPage extends ConsumerStatefulWidget {
  const TambahPengeluaranPage({super.key});

  @override
  ConsumerState<TambahPengeluaranPage> createState() =>
      _TambahPengeluaranPageState();
}

class _TambahPengeluaranPageState
    extends ConsumerState<TambahPengeluaranPage> {
  final TextEditingController nominalController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  bool isPengeluaran = true;

  final kategoriOptions = [
    {
      'nama': 'Food',
      'ikon': Icons.restaurant,
      'warnaIkon': const Color(0xFFDC143C),
      'warnaBg': const Color(0xFFFFE4E1),
    },
    {
      'nama': 'Transport',
      'ikon': Icons.directions_subway,
      'warnaIkon': const Color(0xFF228B22),
      'warnaBg': const Color(0xFFE8F5E9),
    },
    {
      'nama': 'Campus',
      'ikon': Icons.menu_book,
      'warnaIkon': const Color(0xFF1E3A8A),
      'warnaBg': const Color(0xFFE0F2FE),
    },
    {
      'nama': 'Others',
      'ikon': Icons.grid_view_rounded,
      'warnaIkon': const Color(0xFF475569),
      'warnaBg': const Color(0xFFF1F5F9),
    },
  ];

  late Map<String, dynamic> selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = kategoriOptions[0];
  }

  @override
  void dispose() {
    nominalController.dispose();
    catatanController.dispose();
    super.dispose();
  }

  String _formatTanggalInput(DateTime date) {
    final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agt',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          now.hour,
          now.minute,
        );
      });
    }
  }

  void _simpanTransaksi() {
    String textNominal =
        nominalController.text.replaceAll('.', '').replaceAll(',', '');
    double nominal = double.tryParse(textNominal) ?? 0.0;

    if (nominal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nominal transaksi yang valid!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    String catatan = catatanController.text.trim();

    String finalKategori;
    IconData finalIkon;
    Color finalWarnaIkon;
    Color finalWarnaBg;

    if (isPengeluaran) {
      finalKategori = selectedCategory['nama'] as String;
      finalIkon = selectedCategory['ikon'] as IconData;
      finalWarnaIkon = selectedCategory['warnaIkon'] as Color;
      finalWarnaBg = selectedCategory['warnaBg'] as Color;
      if (catatan.isEmpty) {
        catatan = finalKategori;
      }
    } else {
      // Preset Otomatis untuk Pemasukan (Muka Senyum + Light Yellow)
      finalKategori = 'Pemasukan';
      finalIkon = Icons.sentiment_satisfied_alt_rounded;
      finalWarnaIkon = const Color(0xFFD97706);
      finalWarnaBg = const Color(0xFFFEF9C3);
      if (catatan.isEmpty) {
        catatan = 'Pemasukan';
      }
    }

    final newExpense = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      judul: catatan,
      kategori: finalKategori,
      date: selectedDate,
      nominal: nominal,
      isPengeluaran: isPengeluaran,
      ikon: finalIkon,
      warnaIkon: finalWarnaIkon,
      warnaBg: finalWarnaBg,
    );

    ref.read(transactionProvider.notifier).addTransaction(newExpense);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Color colorNominal =
        isPengeluaran ? const Color(0xFFEF4444) : const Color(0xFF10B981);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Tambah Transaksi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Toggle Segmented Control (Pemasukan vs Pengeluaran)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isPengeluaran = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isPengeluaran
                                ? const Color(0xFFEF4444)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Pengeluaran (-)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isPengeluaran
                                    ? Colors.white
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isPengeluaran = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !isPengeluaran
                                ? const Color(0xFF10B981)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Pemasukan (+)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: !isPengeluaran
                                    ? Colors.white
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Input Tanggal (Google Form Style)
              const Text(
                'Tanggal Transaksi',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pilihTanggal,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatTanggalInput(selectedDate),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const Icon(Icons.calendar_month_rounded,
                          color: Color(0xFF0F172A), size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Input Nominal dengan Warna Dinamis
              const Text(
                'Nominal',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Rp ',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: colorNominal,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: nominalController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: colorNominal,
                      ),
                      decoration: const InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 1, color: Color(0xFFE2E8F0)),
              const SizedBox(height: 24),

              // Pilih Kategori (HANYA MUNCUL JIKA PENGELUARAN)
              if (isPengeluaran) ...[
                const Text(
                  'Kategori',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: kategoriOptions.map((item) {
                    bool isSelected =
                        selectedCategory['nama'] == item['nama'];
                    final Color itemWarnaBg = item['warnaBg'] as Color;
                    final Color itemWarnaIkon = item['warnaIkon'] as Color;
                    final IconData itemIkon = item['ikon'] as IconData;
                    final String itemNama = item['nama'] as String;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = item;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? itemWarnaBg : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? itemWarnaIkon
                                : const Color(0xFFE2E8F0),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              itemIkon,
                              size: 18,
                              color: itemWarnaIkon,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              itemNama,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: isSelected
                                    ? itemWarnaIkon
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],

              // Input Catatan
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: TextField(
                  controller: catatanController,
                  maxLines: 3,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0F172A),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Catatan',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _simpanTransaksi,
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}