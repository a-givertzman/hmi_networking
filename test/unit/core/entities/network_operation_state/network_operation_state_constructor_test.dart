import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/hmi_networking.dart';

void main() {
  group('NetworkOperationState constructor', () {
    test(
      'created with correct default flags value',
      () {
        final state = NetworkOperationState();
        expect(
          state.isEditing,
          false,
          reason: 'Default value of isEditing should be false',
        );
        expect(
          state.isChanged,
          false,
          reason: 'Default value of isChanged should be false',
        );
        expect(
          state.isSaving,
          false,
          reason: 'Default value of isSaving should be false',
        );
        expect(
          state.isSaved,
          false,
          reason: 'Default value of isSaved should be false',
        );
        expect(
          state.isLoading,
          false,
          reason: 'Default value of isLoading should be false',
        );
        expect(
          state.isLoaded,
          false,
          reason: 'Default value of isLoaded should be false',
        );
        expect(
          state.isAuthenticating,
          false,
          reason: 'Default value of isAuthenticating should be false',
        );
        expect(
          state.isAuthenticeted,
          false,
          reason: 'Default value of isAuthenticeted should be false',
        );
      },
    );
    test(
      'created with correctly passed flags value',
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
            expect(
              state.isEditing,
              isEditing,
              reason: 'isEditing should be the same as passed value',
            );
            expect(
              state.isChanged,
              isChanged,
              reason: 'isChanged should be the same as passed value',
            );
            expect(
              state.isSaving,
              isSaving,
              reason: 'isSaving should be the same as passed value',
            );
            expect(
              state.isSaved,
              isSaved,
              reason: 'isSaved should be the same as passed value',
            );
            expect(
              state.isLoading,
              isLoading,
              reason: 'isLoading should be the same as passed value',
            );
            expect(
              state.isLoaded,
              isLoaded,
              reason: 'isLoaded should be the same as passed value',
            );
            expect(
              state.isAuthenticating,
              isAuthenticating,
              reason: 'isAuthenticating should be the same as passed value',
            );
            expect(
              state.isAuthenticeted,
              isAuthenticeted,
              reason: 'isAuthenticeted should be the same as passed value',
            );
          }
        }
      },
    );
  });
}
