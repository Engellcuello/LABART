import 'dart:math';

class RandomService {
  // Generates a random ID consisting of 8 characters,
  //using lowercase letters and digits.
  static String generateRandomId() {
    // Define a string of characters to choose from
    //(lowercase letters and digits).
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';

    // Create an instance of the Random class to generate random numbers.
    final rand = Random();

    // Generate a list of 8 random characters from
    //the chars string, then join them into a single string.
    return List.generate(
      8,
      (index) => chars[rand.nextInt(chars.length)],
    ) // Generate the random characters.
        .join(); // Join the list of characters into a single string.
  }
}
