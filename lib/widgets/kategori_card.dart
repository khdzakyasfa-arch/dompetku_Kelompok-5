import 'package:flutter/material.dart';

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