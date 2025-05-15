/// Form field validators for the app
class Validators {
  /// Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    // Use a regex to validate email format
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }
  
  /// Validate confirm password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }
  
  /// Validate name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    return null;
  }
  
  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    return null;
  }
  
  /// Validate phone number
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    
    // Allow + and digits only
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }
  
  /// Validate amount
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    
    // Try to parse as double
    try {
      final amount = double.parse(value);
      if (amount <= 0) {
        return 'Amount must be greater than zero';
      }
    } catch (e) {
      return 'Please enter a valid amount';
    }
    
    return null;
  }
  
  /// Validate integer
  static String? validateInteger(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    // Try to parse as int
    try {
      final number = int.parse(value);
      if (number < 0) {
        return '$fieldName cannot be negative';
      }
    } catch (e) {
      return 'Please enter a valid number for $fieldName';
    }
    
    return null;
  }
  
  /// Validate date
  static String? validateDate(DateTime? value, String fieldName) {
    if (value == null) {
      return '$fieldName is required';
    }
    
    // Check if date is in the future
    if (value.isAfter(DateTime.now())) {
      return '$fieldName cannot be in the future';
    }
    
    return null;
  }
  
  /// Validate age
  static String? validateAge(DateTime? value) {
    if (value == null) {
      return 'Date of birth is required';
    }
    
    // Check if age is reasonable (between 3 and 100 years)
    final now = DateTime.now();
    final difference = now.difference(value);
    final age = difference.inDays ~/ 365;
    
    if (age < 3) {
      return 'Student must be at least 3 years old';
    }
    
    if (age > 100) {
      return 'Please check the date of birth';
    }
    
    return null;
  }
}