void main() {
  // var list = [1, 2, 3];
  // assert(list.length == 3);
  // assert(list[1] == 2);
  // print(list.length);
  // print(list[1]);

  // list[1] = 1;
  // assert(list[1] == 1);
  // print(list[1]);
  
  // Membuat list final dengan panjang 5 dan nilai awal null, serta tipe data dynamic
final List<dynamic> dataMahasiswa = List.filled(5, null);

// Mengisi data mahasiswa pada indeks yang sesuai
dataMahasiswa[0] = "RenathanAAW";  // Indeks 0 untuk nama
dataMahasiswa[1] = 2241720239;       // Indeks 1 untuk NIM

// Menampilkan data mahasiswa
print(dataMahasiswa);
}