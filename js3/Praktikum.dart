void main() {
  for (int number = 0; number <= 201; number++) {
    if (isPrime(number)) {
      print('Prime number: $number' + ' | Renathan | 2241720239');
    }
  }
}
bool isPrime(int number) {
  if (number < 2) {
    return false;
  }
  for (int i = 2; i <= number / 2; i++) {
    if (number % i == 0) {
      return false;
    }
  }
  return true;
}