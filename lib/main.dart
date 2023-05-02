import 'package:flutter/material.dart';

void main() => runApp(MenuRestoran());

class MenuRestoran extends StatefulWidget {
  @override
  _MenuRestoranState createState() => _MenuRestoranState();
}

class _MenuRestoranState extends State<MenuRestoran> {
  // deklarasi daftar menu dengan menggunakan List<Map>
  final List<Map<String, dynamic>> daftarMenu = [
    {
      'nama': 'Bean & Sausage Hotpot',
      'harga': 25000,
      'gambar':
          'https:\/\/www.themealdb.com\/images\/media\/meals\/vxuyrx1511302687.jpg',
      'deskripsi':
          'This super-easy family favourite can be on the table in around half an hour - perfect for a mid-week meal!',
    },
    {
      'nama': 'Braised Beef Chilli',
      'harga': 20000,
      'gambar':
          'https:\/\/www.themealdb.com\/images\/media\/meals\/uuqvwu1504629254.jpg',
      'deskripsi':
          'A cozy pot of slowly Braised Beef Chili is the ultimate winter meal! Simply simmer hearty stew meat or chuck roast with peppers, tomatoes, beans, & smoky spices, resulting in a fall-apart-tender, full-flavored chuck roast chili.'
    },
    {
      'nama': 'French Omelette',
      'harga': 30000,
      'gambar':
          'https:\/\/www.themealdb.com\/images\/media\/meals\/yvpuuy1511797244.jpg',
      'deskripsi':
          'A true French omelette, or omelet as we Americans call it, is just eggs and butter, no filling. The egg is folded for a soft, tender texture.'
    },
    {
      'nama': 'Krispy Kreme Donut',
      'harga': 35000,
      'gambar':
          'https:\/\/www.themealdb.com\/images\/media\/meals\/4i5cnx1587672171.jpg',
      'deskripsi':
          'Krispy Kreme is best known for fresh, glazed, yeast-raised doughnuts, especially the "Krispy Kreme Original Glazed," its first and best-known doughnut. All of its doughnuts are made from a secret recipe that has been in the company since 1937.'
    },
    {
      'nama': 'Piri-piri chicken and slaw',
      'harga': 15000,
      'gambar':
          'https:\/\/www.themealdb.com\/images\/media\/meals\/hglsbl1614346998.jpg',
      'deskripsi':
          'https:\/\/www.themealdb.com\/images\/media\/meals\/hglsbl1614346998.jpg'
    },
  ];

  final hargaController = TextEditingController();

  @override
  void dispose() {
    // Membersihkan kontroler saan widged disposed
    hargaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu Restoran',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          // Tengahkan judul dan tambahkan icon restoran
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant),
              SizedBox(width: 10),
              Text('Menu Restoran'),
            ],
          ),
        ),
        // Membuat Body untuk daftar menu
        body: ListView.builder(
          itemCount: daftarMenu.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              // tambahkan widget Card pada daftar menu
              child: Column(
                children: [
                  // Darftar menu diambil dari index yang sudah dibuat
                  Image.network(
                    // menambahkan gambar dengan mengambil dari internet menggunakan Image.network
                    daftarMenu[index]['gambar'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  ListTile(
                    // Menggunakan listTile untuk menampilkan nama menu dan harga
                    title: Text(daftarMenu[index]['nama']),
                    subtitle: Text('Rp ${daftarMenu[index]['harga']}'),
                  ),
                  ButtonBar(
                    // Menambahkan ButtonBar untuk membuat tombol edit dan detail
                    children: [
                      // tambahkan tombol edit pada harga
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Masukkan Harga'),
                                content: TextField(
                                  // Membuat editor teks untuk menginput angka harga
                                  controller: hargaController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Harga',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // navigator untuk pindah ke halaman utama jika tombol Batal di tekan
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('BATAL'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // ubah harga pada daftar menu
                                      setState(() {
                                        daftarMenu[index]['harga'] =
                                            int.parse(hargaController.text);
                                      });
                                      // navigator untuk pindah ke halaman utama jika tombol Simpan di tekan
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('SIMPAN'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Icon(Icons.edit),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.white.withOpacity(0.4)),
                        ),
                      ),
                      // tambahkan tombol detail pada daftar menu
                      TextButton(
                        onPressed: () {
                          // Navigator untuk pindah kehalaman Detail
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                gambar: daftarMenu[index]['gambar'],
                                nama: daftarMenu[index]['nama'],
                                harga: daftarMenu[index]['harga'],
                                deskripsi: daftarMenu[index]['deskripsi'],
                              ),
                            ),
                          );
                        },
                        child: Text('DETAIL'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.white.withOpacity(0.4)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String gambar;
  final String nama;
  final int harga;
  final String deskripsi;

  const DetailScreen({
    Key? key,
    required this.gambar,
    required this.nama,
    required this.harga,
    required this.deskripsi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold untuk halaman detail
      appBar: AppBar(
        title: Text(nama),
      ),
      body: SingleChildScrollView(
        child: Column(
          // tambahkan gambar dan deskripsi pada halaman detail
          children: [
            Image.network(
              gambar,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              'Rp $harga',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                deskripsi,
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
