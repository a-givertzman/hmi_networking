///
/// Класс для храанения текущих состояний [TextFormField] / [NetworkEditField]
class NetworkOperationState {
  bool _isEditing;
  bool _isChanged;
  bool _isSaved;
  bool _isSaving;
  bool _isLoading;
  bool _isLoaded;
  bool _isAuthenticating;
  bool _isAuthenticeted;
  ///
  NetworkOperationState({
    bool isEditing = false,
    bool isChanged = false,
    bool isSaved = false,
    bool isSaving = false,
    bool isLoading = false,
    bool isLoaded = false,
    bool isAuthenticating = false,
    bool isAuthenticeted = false,
  }) :
    _isEditing = isEditing,
    _isChanged = isChanged,
    _isSaved = isSaved,
    _isSaving = isSaving,
    _isLoading = isLoading,
    _isLoaded = isLoaded,
    _isAuthenticating = isAuthenticating,
    _isAuthenticeted = isAuthenticeted,
    super();
  ///
  void setEditing() {
    _isEditing = true;
  }
  ///
  void setChanged() {
    _isChanged = true;
    _isEditing = false;
    _isSaved = false;
  }
  ///
  void setSaved() {
    _isSaving = false;
    _isSaved = true;
    _isChanged = false;
  }
  ///
  void setLoaded() {
    _isLoading = false;
    _isLoaded = true;
    _isChanged = false;
  }
  ///
  void setLoading() {
    _isLoaded = false;
    _isLoading = true;
  }
  ///    
  void setSaving() {
    _isSaved = false;
    _isSaving = true;
  }
  ///    
  void setAuthenticating() {
    _isAuthenticeted = false;
    _isAuthenticating = true;
  }
  ///    
  void setAuthenticated({bool authenticated = true}) {
    _isAuthenticeted = authenticated;
    _isAuthenticating = false;
  }
  ///    
  bool get isEditing => _isEditing;
  bool get isChanged => _isChanged;
  bool get isSaved => _isSaved;
  bool get isSaving => _isSaving;
  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;
  bool get isAuthenticating => _isAuthenticating;
  bool get isAuthenticeted => _isAuthenticeted;
}