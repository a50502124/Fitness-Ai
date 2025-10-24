import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'failures.dart';
import 'exceptions.dart';

class ErrorHandler {
  static Failure handleError(dynamic error) {
    if (error is AuthException) {
      return AuthFailure(
        message: error.message,
        code: error.code,
      );
    }
    
    if (error is NetworkException) {
      return NetworkFailure(
        message: error.message,
        code: error.code,
      );
    }
    
    if (error is ServerException) {
      return ServerFailure(
        message: error.message,
        code: error.code,
      );
    }
    
    if (error is ValidationException) {
      return ValidationFailure(
        message: error.message,
        code: error.code,
      );
    }
    
    if (error is CacheException) {
      return CacheFailure(
        message: error.message,
        code: error.code,
      );
    }
    
    if (error is PermissionException) {
      return PermissionFailure(
        message: error.message,
        code: error.code,
      );
    }
    
    if (error is supabase.PostgrestException) {
      return ServerFailure(
        message: error.message,
        code: error.code,
      );
    }
    
    if (error is AuthException) {
      return AuthFailure(
        message: error.message,
        code: error.code,
      );
    }
    
    return UnknownFailure(
      message: error.toString(),
    );
  }
  
  static String getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return 'No internet connection. Please check your network and try again.';
      case ServerFailure:
        return 'Server error. Please try again later.';
      case AuthFailure:
        return 'Authentication failed. Please log in again.';
      case ValidationFailure:
        return failure.message;
      case CacheFailure:
        return 'Failed to save data. Please try again.';
      case PermissionFailure:
        return 'Permission denied. Please check app permissions.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
  
  static void showErrorSnackBar(BuildContext context, Failure failure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(getErrorMessage(failure)),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
  
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
