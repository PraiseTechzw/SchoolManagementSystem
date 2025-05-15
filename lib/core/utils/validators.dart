/// Utility class for form validation
class Validators {
  /// Validate email address
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
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
  
  /// Confirm passwords match
  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirm password is required';
    }
    
    if (password != confirmPassword) {
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
  
  /// Validate phone number
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Allow for international formats
    final phoneRegExp = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegExp.hasMatch(value.replaceAll(RegExp(r'\s+'), ''))) {
      return 'Enter a valid phone number';
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
  
  /// Validate amount (numeric and positive)
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    
    final numericValue = double.tryParse(value);
    if (numericValue == null) {
      return 'Enter a valid number';
    }
    
    if (numericValue <= 0) {
      return 'Amount must be greater than zero';
    }
    
    return null;
  }
  
  /// Validate grade (0-100)
  static String? validateGrade(String? value) {
    if (value == null || value.isEmpty) {
      return 'Grade is required';
    }
    
    final numericValue = double.tryParse(value);
    if (numericValue == null) {
      return 'Enter a valid number';
    }
    
    if (numericValue < 0 || numericValue > 100) {
      return 'Grade must be between 0 and 100';
    }
    
    return null;
  }
  
  /// Validate date
  static String? validateDate(DateTime? value) {
    if (value == null) {
      return 'Date is required';
    }
    
    return null;
  }
  
  /// Validate student ID format
  static String? validateStudentId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Student ID is required';
    }
    
    final idRegExp = RegExp(r'^[A-Za-z0-9-]+$');
    if (!idRegExp.hasMatch(value)) {
      return 'Enter a valid student ID';
    }
    
    return null;
  }
}
