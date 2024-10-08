void main() {
  var gifts = {
    // Key:    Value
    'first': 'partridge',
    'second': 'turtledoves',
    'fifth': 1,
    'name' : 'RenathanAAW',
    'nim' : '2241720239',
  };
  var nobleGases = {
    2: 'helium',
    10: 'neon',
    18: 2,
    20: 'RenathanAAW',
    22: '2241720239',
  };

  var mhs1 = Map<String, String>();
  mhs1['first'] = 'partridge';
  mhs1['second'] = 'turtledoves';
  mhs1['fifth'] = 'golden rings';
  mhs1['name'] = 'RenathanAAW';
  mhs1['nim'] = '2241720239';

  var mhs2 = Map<int, String>();
  mhs2[2] = 'helium';
  mhs2[10] = 'neon';
  mhs2[18] = 'argon';
  mhs2[20] = 'RenathanAAW';
  mhs2[22] = '2241720239';

  print(mhs1);
  print(mhs2);

  print(gifts);
  print(nobleGases);
}