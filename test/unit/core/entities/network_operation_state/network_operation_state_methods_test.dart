import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/hmi_networking.dart';

void main() {
  group('NetworkOperationState calling of method', () {
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
      'setEditing, correct flag values after calling',
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
            nos.setEditing();
            expect(
              nos.isEditing,
              true,
              reason: 'isEditing should be true',
            );
            expect(
              nos.isChanged,
              isChanged,
              reason: 'isChanged should not change',
            );
            expect(
              nos.isSaving,
              isSaving,
              reason: 'isSaving should not change',
            );
            expect(
              nos.isSaved,
              isSaved,
              reason: 'isSaved should not change',
            );
            expect(
              nos.isLoading,
              isLoading,
              reason: 'isLoading should not change',
            );
            expect(
              nos.isLoaded,
              isLoaded,
              reason: 'isLoaded should not change',
            );
            expect(
              nos.isAuthenticating,
              isAuthenticating,
              reason: 'isAuthenticating should not change',
            );
            expect(
              nos.isAuthenticeted,
              isAuthenticeted,
              reason: 'isAuthenticeted should not change',
            );
          }
        }
      },
    );

    test(
      'setChanged, correct flag values after calling',
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
            nos.setChanged();
            expect(
              nos.isEditing,
              false,
              reason: 'isEditing should be false',
            );
            expect(
              nos.isChanged,
              true,
              reason: 'isChanged should be true',
            );
            expect(
              nos.isSaving,
              isSaving,
              reason: 'isSaving should not change',
            );
            expect(
              nos.isSaved,
              false,
              reason: 'isSaved should be false',
            );
            expect(
              nos.isLoading,
              isLoading,
              reason: 'isLoading should not change',
            );
            expect(
              nos.isLoaded,
              isLoaded,
              reason: 'isLoaded should not change',
            );
            expect(
              nos.isAuthenticating,
              isAuthenticating,
              reason: 'isAuthenticating should not change',
            );
            expect(
              nos.isAuthenticeted,
              isAuthenticeted,
              reason: 'isAuthenticeted should not change',
            );
          }
        }
      },
    );

    test(
      'setSaving, correct flag values after calling',
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
            nos.setSaving();
            expect(
              nos.isEditing,
              isEditing,
              reason: 'isEditing should not change',
            );
            expect(
              nos.isChanged,
              isChanged,
              reason: 'isChanged should not change',
            );
            expect(
              nos.isSaving,
              true,
              reason: 'isSaving should be true',
            );
            expect(
              nos.isSaved,
              false,
              reason: 'isSaved should be false',
            );
            expect(
              nos.isLoading,
              isLoading,
              reason: 'isLoading should not change',
            );
            expect(
              nos.isLoaded,
              isLoaded,
              reason: 'isLoaded should not change',
            );
            expect(
              nos.isAuthenticating,
              isAuthenticating,
              reason: 'isAuthenticating should not change',
            );
            expect(
              nos.isAuthenticeted,
              isAuthenticeted,
              reason: 'isAuthenticeted should not change',
            );
          }
        }
      },
    );

    test(
      'setSaved, correct flag values after calling',
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
            nos.setSaved();
            expect(
              nos.isEditing,
              isEditing,
              reason: 'isEditing should not change',
            );
            expect(
              nos.isChanged,
              false,
              reason: 'isChanged should be false',
            );
            expect(
              nos.isSaving,
              false,
              reason: 'isSaving should be false',
            );
            expect(
              nos.isSaved,
              true,
              reason: 'isSaved should be true',
            );
            expect(
              nos.isLoading,
              isLoading,
              reason: 'isLoading should not change',
            );
            expect(
              nos.isLoaded,
              isLoaded,
              reason: 'isLoaded should not change',
            );
            expect(
              nos.isAuthenticating,
              isAuthenticating,
              reason: 'isAuthenticating should not change',
            );
            expect(
              nos.isAuthenticeted,
              isAuthenticeted,
              reason: 'isAuthenticeted should not change',
            );
          }
        }
      },
    );

    test(
      'setLoading, correct flag values after calling',
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
            nos.setLoading();
            expect(
              nos.isEditing,
              isEditing,
              reason: 'isEditing should not change',
            );
            expect(
              nos.isChanged,
              isChanged,
              reason: 'isChanged should not change',
            );
            expect(
              nos.isSaving,
              isSaving,
              reason: 'isSaving should not change',
            );
            expect(
              nos.isSaved,
              isSaved,
              reason: 'isSaved should not change',
            );
            expect(
              nos.isLoading,
              true,
              reason: 'isLoading should be true',
            );
            expect(
              nos.isLoaded,
              false,
              reason: 'isLoaded should be false',
            );
            expect(
              nos.isAuthenticating,
              isAuthenticating,
              reason: 'isAuthenticating should not change',
            );
            expect(
              nos.isAuthenticeted,
              isAuthenticeted,
              reason: 'isAuthenticeted should not change',
            );
          }
        }
      },
    );

    test(
      'setLoaded, correct flag values after calling',
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
            nos.setLoaded();
            expect(
              nos.isEditing,
              isEditing,
              reason: 'isEditing should not change',
            );
            expect(
              nos.isChanged,
              false,
              reason: 'isChanged should be false',
            );
            expect(
              nos.isSaving,
              isSaving,
              reason: 'isSaving should not change',
            );
            expect(
              nos.isSaved,
              isSaved,
              reason: 'isSaved should not change',
            );
            expect(
              nos.isLoading,
              false,
              reason: 'isLoading should be false',
            );
            expect(
              nos.isLoaded,
              true,
              reason: 'isLoaded should be true',
            );
            expect(
              nos.isAuthenticating,
              isAuthenticating,
              reason: 'isAuthenticating should not change',
            );
            expect(
              nos.isAuthenticeted,
              isAuthenticeted,
              reason: 'isAuthenticeted should not change',
            );
          }
        }
      },
    );

    test(
      'setAuthenticating, correct flag values after calling',
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
            nos.setAuthenticating();
            expect(
              nos.isEditing,
              isEditing,
              reason: 'isEditing should not change',
            );
            expect(
              nos.isChanged,
              isChanged,
              reason: 'isChanged should not change',
            );
            expect(
              nos.isSaving,
              isSaving,
              reason: 'isSaving should not change',
            );
            expect(
              nos.isSaved,
              isSaved,
              reason: 'isSaved should not change',
            );
            expect(
              nos.isLoading,
              isLoading,
              reason: 'isLoading should not change',
            );
            expect(
              nos.isLoaded,
              isLoading,
              reason: 'isLoaded should should not change',
            );
            expect(
              nos.isAuthenticating,
              true,
              reason: 'isAuthenticating should be true',
            );
            expect(
              nos.isAuthenticeted,
              false,
              reason: 'isAuthenticeted should be false',
            );
          }
        }
      },
    );

    test(
      'setAuthenticated with default, correct flag values after calling',
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
            nos.setAuthenticated();
            expect(
              nos.isEditing,
              isEditing,
              reason: 'isEditing should not change',
            );
            expect(
              nos.isChanged,
              isChanged,
              reason: 'isChanged should not change',
            );
            expect(
              nos.isSaving,
              isSaving,
              reason: 'isSaving should not change',
            );
            expect(
              nos.isSaved,
              isSaved,
              reason: 'isSaved should not change',
            );
            expect(
              nos.isLoading,
              isLoading,
              reason: 'isLoading should not change',
            );
            expect(
              nos.isLoaded,
              isLoading,
              reason: 'isLoaded should should not change',
            );
            expect(
              nos.isAuthenticating,
              false,
              reason: 'isAuthenticating should be false',
            );
            expect(
              nos.isAuthenticeted,
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
            nos.setAuthenticated(authenticated: false);
            expect(
              nos.isEditing,
              isEditing,
              reason: 'isEditing should not change',
            );
            expect(
              nos.isChanged,
              isChanged,
              reason: 'isChanged should not change',
            );
            expect(
              nos.isSaving,
              isSaving,
              reason: 'isSaving should not change',
            );
            expect(
              nos.isSaved,
              isSaved,
              reason: 'isSaved should not change',
            );
            expect(
              nos.isLoading,
              isLoading,
              reason: 'isLoading should not change',
            );
            expect(
              nos.isLoaded,
              isLoading,
              reason: 'isLoaded should should not change',
            );
            expect(
              nos.isAuthenticating,
              false,
              reason: 'isAuthenticating should be true',
            );
            expect(
              nos.isAuthenticeted,
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
            nos.setAuthenticated(authenticated: true);
            expect(
              nos.isEditing,
              isEditing,
              reason: 'isEditing should not change',
            );
            expect(
              nos.isChanged,
              isChanged,
              reason: 'isChanged should not change',
            );
            expect(
              nos.isSaving,
              isSaving,
              reason: 'isSaving should not change',
            );
            expect(
              nos.isSaved,
              isSaved,
              reason: 'isSaved should not change',
            );
            expect(
              nos.isLoading,
              isLoading,
              reason: 'isLoading should not change',
            );
            expect(
              nos.isLoaded,
              isLoading,
              reason: 'isLoaded should should not change',
            );
            expect(
              nos.isAuthenticating,
              false,
              reason: 'isAuthenticating should be true',
            );
            expect(
              nos.isAuthenticeted,
              true,
              reason: 'isAuthenticeted should be true',
            );
          }
        }
      },
    );
  });
}
