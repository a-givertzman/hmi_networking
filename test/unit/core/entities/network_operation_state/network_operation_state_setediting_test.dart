import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/hmi_networking.dart';

void main() {
  test(
    'NetworkOperationState.setEditing(), correct flag values after calling',
    () {
      final constructorArgsList = [
        {
          'isEditing': false,
          'isChanged': false,
          'isSaving': false,
          'isSaved': false,
          'isLoading': false,
          'isLoaded': false,
          'isAuthenticating': false,
          'isAuthenticeted': false,
        },
        {
          'isEditing': true,
          'isChanged': true,
          'isSaving': true,
          'isSaved': true,
          'isLoading': true,
          'isLoaded': true,
          'isAuthenticating': true,
          'isAuthenticeted': true,
        },
      ];
      for (final args in constructorArgsList) {
        if (args
            case {
              'isEditing': final bool isEditing,
              'isChanged': final bool isChanged,
              'isSaving': final bool isSaving,
              'isSaved': final bool isSaved,
              'isLoading': final bool isLoading,
              'isLoaded': final bool isLoaded,
              'isAuthenticating': final bool isAuthenticating,
              'isAuthenticeted': final bool isAuthenticeted,
            }) {
          final state = NetworkOperationState(
            isEditing: isEditing,
            isChanged: isChanged,
            isSaving: isSaving,
            isSaved: isSaved,
            isLoading: isLoading,
            isLoaded: isLoaded,
            isAuthenticating: isAuthenticating,
            isAuthenticeted: isAuthenticeted,
          );
          state.setEditing();
          expect(
            state.isEditing,
            true,
            reason: 'isEditing should be true',
          );
          expect(
            state.isChanged,
            isChanged,
            reason: 'isChanged should not change',
          );
          expect(
            state.isSaving,
            isSaving,
            reason: 'isSaving should not change',
          );
          expect(
            state.isSaved,
            isSaved,
            reason: 'isSaved should not change',
          );
          expect(
            state.isLoading,
            isLoading,
            reason: 'isLoading should not change',
          );
          expect(
            state.isLoaded,
            isLoaded,
            reason: 'isLoaded should not change',
          );
          expect(
            state.isAuthenticating,
            isAuthenticating,
            reason: 'isAuthenticating should not change',
          );
          expect(
            state.isAuthenticeted,
            isAuthenticeted,
            reason: 'isAuthenticeted should not change',
          );
        }
      }
    },
  );
}
