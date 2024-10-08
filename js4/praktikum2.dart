void main(){
  //var halogens = {'fluorine', 'chlorine', 'bromine', 'iodine', 'astatine'};
//print(halogens);

// var names1 = <String>{};
// Set<String> names2 = {}; // This works, too.
// var names3 = {}; // Creates a map, not a set.

// print(names1);
// print(names2);
// print(names3);

  //PERBAIKAN LANGKAH-3
  var names1 = <String>{};
  Set<String> names2 = {};

  names1.add('RenathanAAW'); 
  names1.add('2241720239');

  names2.addAll({'RenathanAAW', '2241720239'}); 

  print(names1); 
  print(names2);

}