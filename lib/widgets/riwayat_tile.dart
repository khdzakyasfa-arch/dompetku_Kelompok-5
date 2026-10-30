import 'package:flutter/material.dart';

class RiwayatTile extends StatelessWidget {
  final String judul;
  final String subjudul;
  final String nominal;
  final IconData ikon;
  final Color warnaIkon;
  final Color warnaBg;
  final VoidCallback? onDelete;

  const RiwayatTile({
    super.key,
    required this.judul,
    required this.subjudul,
    required this.nominal,
    required this.ikon,
    required this.warnaIkon,
    required this.warnaBg,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(judul + subjudul + nominal + DateTime.now().microsecondsSinceEpoch.toString()),
      direction: onDelete != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      onDismissed: (_) {
        if (onDelete != null) onDelete!();
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.redAccent,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Padding(
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
      ),
    );
  }
}