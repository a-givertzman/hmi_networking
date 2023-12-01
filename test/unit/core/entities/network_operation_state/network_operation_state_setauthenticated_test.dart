import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/hmi_networking.dart';

void main() {
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
  group('NetworkOperationState.setAuthenticated()', () {
    test(
      'with default, correct flag values after calling',
      () {
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
            state.setAuthenticated();
            expect(
              state.isEditing,
              isEditing,
              reason: 'isEditing should not change',
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
              isLoading,
              reason: 'isLoaded should should not change',
            );
            expect(
              state.isAuthenticating,
              false,
              reason: 'isAuthenticating should be false',
            );
            expect(
              state.isAuthenticeted,
              true,
              reason: 'isAuthenticeted should be true',
            );
          }
        }
      },
    );
    test(
      'setAuthenticated with false, correct flag values after calling',
      () {
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
            state.setAuthenticated(authenticated: false);
            expect(
              state.isEditing,
              isEditing,
              reason: 'isEditing should not change',
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
              isLoading,
              reason: 'isLoaded should should not change',
            );
            expect(
              state.isAuthenticating,
              false,
              reason: 'isAuthenticating should be true',
            );
            expect(
              state.isAuthenticeted,
              false,
              reason: 'isAuthenticeted should be false',
            );
          }
        }
      },
    );
    test(
      'setAuthenticated with true, correct flag values after calling',
      () {
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
            state.setAuthenticated(authenticated: true);
            expect(
              state.isEditing,
              isEditing,
              reason: 'isEditing should not change',
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
              isLoading,
              reason: 'isLoaded should should not change',
            );
            expect(
              state.isAuthenticating,
              false,
              reason: 'isAuthenticating should be true',
            );
            expect(
              state.isAuthenticeted,
              true,
              reason: 'isAuthenticeted should be true',
            );
          }
        }
      },
    );
  });
}
