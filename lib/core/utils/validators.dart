/// Utility class for form field validations
class Validators {
  /// Validates that a field is not empty
  static String? validateNotEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  /// Validates an email address
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  /// Validates a password
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }
  
  /// Validates that passwords match
  static String? validatePasswordMatch(String? value, String? confirmValue) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirmation password is required';
    }
    
    if (value != confirmValue) {
      return 'Passwords do not match';
    }
    
    return null;
  }
  
  /// Validates that confirmation password matches
  static String? validateConfirmPassword(String password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return 'Confirmation password is required';
    }
    
    if (confirmPassword != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  /// Validates a phone number
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove spaces, dashes, and parentheses
    final cleanPhone = value.replaceAll(RegExp(r'[\s\-()]'), '');
    
    // Check for numeric values and proper length
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanPhone)) {
      return 'Please enter a valid phone number';
    }
    
    // Validate length (can be adjusted based on country)
    if (cleanPhone.length < 10 || cleanPhone.length > 15) {
      return 'Phone number should be between 10 and 15 digits';
    }
    
    return null;
  }

  /// Validates an amount (currency)
  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }
    
    // Check for valid decimal number
    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) {
      return 'Please enter a valid amount';
    }
    
    // Check that amount is greater than zero
    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return 'Amount must be greater than zero';
    }
    
    return null;
  }
  
  /// Validates a numeric value
  static String? validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    
    // Check for valid numeric value
    if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
      return 'Please enter a valid number';
    }
    
    return null;
  }
  
  /// Validates an integer value
  static String? validateInteger(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    
    // Check for valid integer
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Please enter a valid integer';
    }
    
    return null;
  }
  
  /// Validates a date of birth
  static String? validateDateOfBirth(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Date of birth is required';
    }
    
    try {
      final dob = DateTime.parse(value);
      final now = DateTime.now();
      
      if (dob.isAfter(now)) {
        return 'Date of birth cannot be in the future';
      }
      
      // Check if person is too old (e.g., more than 120 years)
      final maxAge = now.subtract(const Duration(days: 365 * 120));
      if (dob.isBefore(maxAge)) {
        return 'Please enter a valid date of birth';
      }
    } catch (e) {
      return 'Please enter a valid date format';
    }
    
    return null;
  }
  
  /// Validates a name
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    // Check for valid name (letters, spaces, hyphens, and apostrophes)
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(value)) {
      return 'Please enter a valid name';
    }
    
    return null;
  }
  
  /// Validates a ZIP/Postal code
  static String? validateZipCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'ZIP/Postal code is required';
    }
    
    // Simple validation for generic postal codes
    if (value.length < 3 || value.length > 10) {
      return 'Please enter a valid ZIP/Postal code';
    }
    
    return null;
  }
  
  /// Validates a URL
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL is required';
    }
    
    // Simple URL validation
    final urlRegExp = RegExp(
      r'^(https?:\/\/)?(www\.)?[a-zA-Z0-9]+([\-\.]{1}[a-zA-Z0-9]+)*\.[a-zA-Z]{2,}(:[0-9]{1,5})?(\/[^\s]*)?$',
    );
    
    if (!urlRegExp.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }
  
  /// Validates that a value is within a range
  static String? validateRange(String? value, double min, double max) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    
    if (number < min || number > max) {
      return 'Value must be between $min and $max';
    }
    
    return null;
  }
}