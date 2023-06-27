import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // Memastikan inisialisasi Flutter telah selesai dan Firebase telah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// Aplikasi utama
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'menurestoran',
      home: LoginScreen(),
    );
  }
}

// Halaman menu restoran
class MenuRestoran extends StatefulWidget {
  @override
  _MenuRestoranState createState() => _MenuRestoranState();
}

class _MenuRestoranState extends State<MenuRestoran> {
  // Menyimpan daftar menu
  List<Map<String, dynamic>> daftarMenu = [];
  // Controller untuk input harga
  final hargaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Memanggil fungsi fetchData saat aplikasi dimulai
    fetchData();
  }

  @override
  void dispose() {
    // Membuang controller saat widget dihapus
    hargaController.dispose();
    super.dispose();
  }

  // Mengambil data menu dari API
  Future<void> fetchData() async {
    final response = await http.get(
        // Melakukan HTTP GET request ke API
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?f=e'));

    if (response.statusCode == 200) {
      // Mendecode data JSON
      final data = jsonDecode(response.body);
      // Mendapatkan daftar makanan dari data
      final meals = data['meals'];

      if (meals != null) {
        setState(() {
          // Mengubah data menu menjadi list of maps
          daftarMenu = meals
              .map<Map<String, dynamic>>((meal) => {
                    // Mengambil nama makanan dari API
                    'nama': meal['strMeal'],
                    // Set harga dengan 0
                    'harga': 0,
                    // Mengambil URL gambar makanan dari API
                    'gambar': meal['strMealThumb'] ?? '',
                    // Mengambil deskripsi makanan dari API
                    'deskripsi': meal['strInstructions'],
                  })
              // Mengubah daftar makanan menjadi list yang dapat digunakan oleh ListView
              .toList();
        });
      }
    } else {
      // Menampilkan pesan error jika gagal mengambil data dari API
      throw Exception('Failed to fetch data from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: ListTile(
              leading: Image.network(
                // Menampilkan gambar makanan yang diambil dari API menggunakan Image.network
                daftarMenu[index]['gambar'],
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              // Menampilkan nama makanan diambil dari API
              title: Text(daftarMenu[index]['nama']),
              subtitle: Text('Rp ${daftarMenu[index]['harga']}'),
              // Menambahkan ButtonBar untuk membuat tombol edit dan detail
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Edit Harga'),
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
                            // ubah harga pada daftar menu
                            onPressed: () {
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
              ),
              onTap: () {
                // Navigator untuk pindah kehalaman Detail
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      // Mengirim URL gambar ke layar detail
                      gambar: daftarMenu[index]['gambar'],
                      // Mengirim nama makanan ke layar detail
                      nama: daftarMenu[index]['nama'],
                      // Mengirim harga makanan ke layar detail
                      harga: daftarMenu[index]['harga'],
                      // Mengirim deskripsi makanan ke layar detail
                      deskripsi: daftarMenu[index]['deskripsi'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Halaman detail menu
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
    // Scaffold untuk halaman detail
    return Scaffold(
      appBar: AppBar(
        // Menampilkan nama makanan pada AppBar
        title: Text(nama),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              // Mengatur tinggi gambar sesuai lebar layar
              height: MediaQuery.of(context).size.width * 0.6,
              child: Image.network(
                // Menampilkan gambar makanan
                gambar,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              // Menampilkan harga makanan
              'Harga: Rp $harga',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              // Menampilkan label "Deskripsi"
              'Deskripsi:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  // Menampilkan deskripsi makanan
                  deskripsi,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman login
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Fungsi untuk melakukan login pengguna
  Future<void> loginUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Jika login berhasil, navigasikan pengguna ke halaman utama MenuRestoran
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenuRestoran(),
        ),
      );
    } catch (e) {
      // Jika login gagal, tampilkan pesan kesalahan
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                loginUser();
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('Registrasi'),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman registrasi
class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Fungsi untuk melakukan registrasi pengguna
  Future<void> registerUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Jika registrasi berhasil, tampilkan pesan sukses
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registrasi Berhasil'),
            content: Text('Akun berhasil didaftarkan.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Jika registrasi gagal, tampilkan pesan kesalahan
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrasi'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                registerUser();
              },
              child: Text('Registrasi'),
            ),
          ],
        ),
      ),
    );
  }
}
