import 'package:flutter/material.dart';

void main() {
  runApp(const DompetkuApp());
}

class DompetkuApp extends StatelessWidget {
  const DompetkuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dompetku',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

// ==========================================
// HALAMAN UTAMA (HOME PAGE)
// ==========================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // State Keuangan Real-time
  double sisaSaldo = 255000.0;
  double totalPemasukan = 1500000.0;
  double totalPengeluaran = 1245000.0;

  // Filter Aktif
  String selectedFilter = 'Hari ini';

  // Master Data Kategori
  final List<Map<String, dynamic>> kategoriList = [
    {
      'nama': 'Food',
      'ikon': Icons.restaurant,
      'warnaIkon': const Color(0xFFDC143C), // Crimson
      'warnaBg': const Color(0xFFFFE4E1),   // Soft Pink
    },
    {
      'nama': 'Transport',
      'ikon': Icons.directions_subway,      // Kereta
      'warnaIkon': const Color(0xFF228B22), // Forest Green
      'warnaBg': const Color(0xFFE8F5E9),   // Light Green
    },
    {
      'nama': 'Campus',
      'ikon': Icons.menu_book,              // Buku
      'warnaIkon': const Color(0xFF1E3A8A), // Cobalt
      'warnaBg': const Color(0xFFE0F2FE),   // Soft Blue
    },
    {
      'nama': 'Others',
      'ikon': Icons.grid_view_rounded,      // 4 Kotak
      'warnaIkon': const Color(0xFF475569), // Dark Grey
      'warnaBg': const Color(0xFFF1F5F9),   // Light Gray
    },
  ];

  // Data Riwayat Pengeluaran
  List<Map<String, dynamic>> riwayatList = [
    {
      'judul': 'Geprek MRP',
      'kategori': 'Food',
      'jam': '07.30',
      'nominal': 15000.0,
      'ikon': Icons.restaurant,
      'warnaIkon': const Color(0xFFDC143C),
      'warnaBg': const Color(0xFFFFE4E1),
    },
    {
      'judul': 'Gojek ke kampus',
      'kategori': 'Transport',
      'jam': '08.10',
      'nominal': 12000.0,
      'ikon': Icons.directions_subway,
      'warnaIkon': const Color(0xFF228B22),
      'warnaBg': const Color(0xFFE8F5E9),
    },
    {
      'judul': 'Print surat komitmen',
      'kategori': 'Campus',
      'jam': '10.45',
      'nominal': 3000.0,
      'ikon': Icons.menu_book,
      'warnaIkon': const Color(0xFF1E3A8A),
      'warnaBg': const Color(0xFFE0F2FE),
    },
    {
      'judul': 'Bayar hutang teman',
      'kategori': 'Others',
      'jam': '12.15',
      'nominal': 5000.0,
      'ikon': Icons.grid_view_rounded,
      'warnaIkon': const Color(0xFF475569),
      'warnaBg': const Color(0xFFF1F5F9),
    },
  ];

  // Helper Format Rupiah
  String formatRupiah(num number, {bool isMinus = false}) {
    String strVal = number.abs().toStringAsFixed(0);
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String formatted = strVal.replaceAllMapped(reg, (Match m) => '${m[1]}.');
    return isMinus ? '-Rp$formatted' : 'Rp$formatted';
  }

  // Integrasi Tambah Pengeluaran & Update Dynamic
  Future<void> _bukaTambahPengeluaran() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TambahPengeluaranPage(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        double nominalBaru = result['nominal'];
        sisaSaldo -= nominalBaru;
        totalPengeluaran += nominalBaru;
        riwayatList.insert(0, result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER PROFIL ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFF00796B),
                        backgroundImage: AssetImage('assets/la peace.jpeg'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Selamat Pagi,',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Lapeace',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- KARTU SISA SALDO (LIGHT PASTEL YELLOW) ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF08A), // Light Pastel Yellow
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFEF08A).withAlpha(120),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sisa Saldo',
                          style: TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B).withAlpha(15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                color: Color(0xFF047857),
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Aktif',
                                style: TextStyle(
                                  color: Color(0xFF1E293B),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatRupiah(sisaSaldo),
                      style: const TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: const Color(0xFF1E293B).withAlpha(30)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 12,
                              backgroundColor: Color(0xFF10B981),
                              child: Icon(Icons.arrow_downward,
                                  size: 14, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Pemasukan',
                                    style: TextStyle(
                                        color: Color(0xFF475569),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                  formatRupiah(totalPemasukan),
                                  style: const TextStyle(
                                      color: Color(0xFF1E293B),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          height: 24,
                          width: 1,
                          color: const Color(0xFF1E293B).withAlpha(30),
                        ),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 12,
                              backgroundColor: Color(0xFFEF4444),
                              child: Icon(Icons.arrow_upward,
                                  size: 14, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Pengeluaran',
                                    style: TextStyle(
                                        color: Color(0xFF475569),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                  formatRupiah(totalPengeluaran),
                                  style: const TextStyle(
                                      color: Color(0xFF1E293B),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E293B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _bukaTambahPengeluaran,
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                        label: const Text(
                          'Catat Pengeluaran',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // --- KATEGORI ---
              const Text(
                'Kategori',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: kategoriList
                      .map(
                        (item) => KategoriCard(
                          nama: item['nama'],
                          ikon: item['ikon'],
                          warnaIkon: item['warnaIkon'],
                          warnaBg: item['warnaBg'],
                        ),
                      )
                      .toList(),
                ),
              ),

              const SizedBox(height: 28),

              // --- RIWAYAT PENGELUARAN ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Riwayat Pengeluaran',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFilter = 'Hari ini';
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: selectedFilter == 'Hari ini'
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Hari ini',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: selectedFilter == 'Hari ini'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFilter = 'Minggu ini';
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: selectedFilter == 'Minggu ini'
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Minggu ini',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: selectedFilter == 'Minggu ini'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: selectedFilter == 'Minggu ini'
                                    ? const Color(0xFF0F172A)
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(
                    riwayatList.length,
                    (index) => Column(
                      children: [
                        RiwayatTile(
                          judul: riwayatList[index]['judul'],
                          subjudul:
                              '${riwayatList[index]['kategori']} • ${riwayatList[index]['jam']}',
                          nominal: formatRupiah(
                              riwayatList[index]['nominal'],
                              isMinus: true),
                          ikon: riwayatList[index]['ikon'],
                          warnaIkon: riwayatList[index]['warnaIkon'],
                          warnaBg: riwayatList[index]['warnaBg'],
                        ),
                        if (index != riwayatList.length - 1)
                          const Divider(
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                            color: Color(0xFFF1F5F9),
                          ),
                      ],
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

// ==========================================
// CUSTOM WIDGET 1: KategoriCard
// ==========================================
class KategoriCard extends StatelessWidget {
  final String nama;
  final IconData ikon;
  final Color warnaIkon;
  final Color warnaBg;

  const KategoriCard({
    super.key,
    required this.nama,
    required this.ikon,
    required this.warnaIkon,
    required this.warnaBg,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: warnaBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            ikon,
            color: warnaIkon,
            size: 22,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          nama,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// CUSTOM WIDGET 2: RiwayatTile
// ==========================================
class RiwayatTile extends StatelessWidget {
  final String judul;
  final String subjudul;
  final String nominal;
  final IconData ikon;
  final Color warnaIkon;
  final Color warnaBg;

  const RiwayatTile({
    super.key,
    required this.judul,
    required this.subjudul,
    required this.nominal,
    required this.ikon,
    required this.warnaIkon,
    required this.warnaBg,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: warnaBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              ikon,
              color: warnaIkon,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subjudul,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            nominal,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// HALAMAN DUA: TambahPengeluaranPage
// ==========================================
class TambahPengeluaranPage extends StatefulWidget {
  const TambahPengeluaranPage({super.key});

  @override
  State<TambahPengeluaranPage> createState() => _TambahPengeluaranPageState();
}

class _TambahPengeluaranPageState extends State<TambahPengeluaranPage> {
  final TextEditingController nominalController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();

  final List<Map<String, dynamic>> kategoriOptions = [
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

  void _simpanPengeluaran() {
    String textNominal =
        nominalController.text.replaceAll('.', '').replaceAll(',', '');
    double nominal = double.tryParse(textNominal) ?? 0.0;

    if (nominal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nominal pengeluaran yang valid!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    String catatan = catatanController.text.trim();
    if (catatan.isEmpty) {
      catatan = selectedCategory['nama'];
    }

    DateTime now = DateTime.now();
    String jam =
        '${now.hour.toString().padLeft(2, '0')}.${now.minute.toString().padLeft(2, '0')}';

    final newExpense = {
      'judul': catatan,
      'kategori': selectedCategory['nama'],
      'jam': jam,
      'nominal': nominal,
      'ikon': selectedCategory['ikon'],
      'warnaIkon': selectedCategory['warnaIkon'],
      'warnaBg': selectedCategory['warnaBg'],
    };

    Navigator.pop(context, newExpense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Back + Judul
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Tambah Pengeluaran',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Section Nominal
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
                  const Text(
                    'Rp ',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: nominalController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
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
              const SizedBox(height: 28),

              // Section Kategori
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
                  bool isSelected = selectedCategory['nama'] == item['nama'];
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
                        color: isSelected ? item['warnaBg'] : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? item['warnaIkon']
                              : const Color(0xFFE2E8F0),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item['ikon'],
                            size: 18,
                            color: item['warnaIkon'],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item['nama'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: isSelected
                                  ? item['warnaIkon']
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              // Section Catatan
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
                  maxLines: 4,
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

              const Spacer(),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _simpanPengeluaran,
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
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}