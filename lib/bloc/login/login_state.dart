part of 'login_bloc.dart';


class LoginState {
  final List<ArchivesModel> archives;
  final int indexHome;
  final bool isUpdate;
  final bool isLoged;

  LoginState({
    this.indexHome = 0,
    this.archives = const [],
    this.isUpdate = false,
    this.isLoged = false,
  });

  LoginState copyWith({
    int? indexHome,
    List<ArchivesModel>? archives,
     bool? isUpdate,
     bool? isLoged
  }) =>
      LoginState(
        indexHome: indexHome ?? this.indexHome,
        archives: archives ?? this.archives,
        isUpdate: isUpdate ?? this.isUpdate,
        isLoged: isLoged ?? this.isLoged
      );
}
