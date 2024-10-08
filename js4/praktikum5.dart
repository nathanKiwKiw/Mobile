(int, int) tukar((int, int) record) {
  var (a, b) = record;
  return (b, a);
}
void main(){
  // var record = ('first', a: 2, b: true, 'last');
  // print(record);

  var record = (1, 3);
  print("Sebelum ditukar: $record");

  var hasilTukar = tukar(record);
  print("Setelah ditukar: $hasilTukar");
  
  // (String, int) mahasiswa;
  // print(mahasiswa);
  (String, int) mahasiswa = ('RenathanAAW', 2241720239);
  print("Record Mahasiswa: $mahasiswa");

  var mahasiswa2 = ('first', a: 2, b: true, 'last');

  print(mahasiswa2.$1); // Prints 'first'
  print(mahasiswa2.a); // Prints 2
  print(mahasiswa2.b); // Prints true
  print(mahasiswa2.$2); // Prints 'last'
}