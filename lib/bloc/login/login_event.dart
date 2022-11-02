part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class SelectIndex extends LoginEvent {

  final int indexHome;
  final bool isUpdate;

  SelectIndex(this.indexHome, this.isUpdate);
  
}


class NuevoUser extends LoginEvent {

  final List<ArchivesModel> archives;

  NuevoUser(this.archives);
  
}


class DetectLogin extends LoginEvent {
   final bool isLoged;

  DetectLogin(this.isLoged);
}