import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/hmi_networking.dart';

void main() {
  group('NetworkOperationState constructor', () {
    test(
      'created with correct default flags value',
      () {
        final nos = NetworkOperationState();
        expect(
          nos.isEditing,
          false,
          reason: 'Default value of isEditing should be false',
        );
        expect(
          nos.isChanged,
          false,
          reason: 'Default value of isChanged should be false',
        );
        expect(
          nos.isSaving,
          false,
          reason: 'Default value of isSaving should be false',
        );
        expect(
          nos.isSaved,
          false,
          reason: 'Default value of isSaved should be false',
        );
        expect(
          nos.isLoading,
          false,
          reason: 'Default value of isLoading should be false',
        );
        expect(
          nos.isLoaded,
          false,
          reason: 'Default value of isLoaded should be false',
        );
        expect(
          nos.isAuthenticating,
          false,
          reason: 'Default value of isAuthenticating should be false',
        );
        expect(
          nos.isAuthenticeted,
          false,
          reason: 'Default value of isAuthenticeted should be false',
        );
      },
    );

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

    test(
      'created with correctly passed flags value',
      () {
        for (final args in constructorArgsList) {
          if (args
              case {
                'isEditing': bool isEditing,
                'isChanged': bool isChanged,
                'isSaving': bool isSaving,
                'isSaved': bool isSaved,
                'isLoading': bool isLoading,
                'isLoaded': bool isLoaded,
                'isAuthenticating': bool isAuthenticating,
                'isAuthenticeted': bool isAuthenticeted,
              }) {
            final nos = NetworkOperationState(
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
              nos.isEditing,
              isEditing,
              reason: 'isEditing should be the same as passed value',
            );
            expect(
              nos.isChanged,
              isChanged,
              reason: 'isChanged should be the same as passed value',
            );
            expect(
              nos.isSaving,
              isSaving,
              reason: 'isSaving should be the same as passed value',
            );
            expect(
              nos.isSaved,
              isSaved,
              reason: 'isSaved should be the same as passed value',
            );
            expect(
              nos.isLoading,
              isLoading,
              reason: 'isLoading should be the same as passed value',
            );
            expect(
              nos.isLoaded,
              isLoaded,
              reason: 'isLoaded should be the same as passed value',
            );
            expect(
              nos.isAuthenticating,
              isAuthenticating,
              reason: 'isAuthenticating should be the same as passed value',
            );
            expect(
              nos.isAuthenticeted,
              isAuthenticeted,
              reason: 'isAuthenticeted should be the same as passed value',
            );
          }
        }
      },
    );
  });
}
