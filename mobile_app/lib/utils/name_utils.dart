class NameUtils {
  /// Capitalizes the first letter of each word in a name
  static String capitalizeName(String name) {
    if (name.isEmpty) return name;
    return name
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  /// Formats a full name from first and last name components
  static String formatFullName(String? firstName, String? lastName) {
    final first = firstName ?? '';
    final last = lastName ?? '';
    final fullName = '$first $last'.trim();
    return capitalizeName(fullName);
  }

  /// Formats a name from fName and lName fields (handles different field name variations)
  static String formatPatientName(Map<String, dynamic> patient) {
    final firstName =
        patient['fName'] ?? patient['FName'] ?? patient['fname'] ?? '';
    final lastName =
        patient['lName'] ?? patient['LName'] ?? patient['lname'] ?? '';
    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      return formatFullName(firstName, lastName);
    }
    // Fallback to 'name' field if first/last name not present
    final name = patient['name'] ?? patient['Name'] ?? '';
    return capitalizeName(name);
  }
}
