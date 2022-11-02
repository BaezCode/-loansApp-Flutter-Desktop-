// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_app/models/archives_model.dart';
import 'package:my_app/services/db_services.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  List<ArchivesModel> archives = [];

  LoginBloc() : super(LoginState()) {
    on<SelectIndex>((event, emit) {
      emit(
          state.copyWith(indexHome: event.indexHome, isUpdate: event.isUpdate));
    });
    on<NuevoUser>((event, emit) {
      emit(state.copyWith(archives: event.archives));
    });

    on<DetectLogin>((event, emit) {
      emit(state.copyWith(isLoged: event.isLoged));
    });
  }

  void cargarUser(ArchivesModel user) {
    archives.clear();
    archives.add(user);
    add(NuevoUser(archives));
  }

  Future<ArchivesModel> nuevoFolder(String nombre, int cedula, String telefono,
      String trabaja, String direccion, String referencia) async {
    var rng = Random();

    final nuevoUser = ArchivesModel(
        cedula: cedula,
        nombre: nombre,
        telefono: telefono,
        trabaja: trabaja,
        idCliente: rng.nextInt(15478396).toString().substring(3),
        direccion: direccion,
        referencia: referencia);

    await DBProvider.db.nuevoFolder(nuevoUser);

    archives.add(nuevoUser);
    add(NuevoUser(archives));
    return nuevoUser;
  }

  void update(String nombre, int cedula, String telefono, String trabaja,
      String direccion, String referencia, int id, String idCliente) async {
    final nuevoUser = ArchivesModel(
        id: id,
        cedula: cedula,
        nombre: nombre,
        telefono: telefono,
        trabaja: trabaja,
        idCliente: idCliente,
        direccion: direccion,
        referencia: referencia);

    await DBProvider.db.updateScan(nuevoUser);

    cargarscans();
  }

  Future selectedIndex(int index, bool update) async {
    add(SelectIndex(index, update));
  }

  void borrarUsuarios(int id) async {
    await DBProvider.db.deleteScan(id);
    cargarscans();
  }

  void cargarscans() async {
    final folders = await DBProvider.db.getTodosLosScans();
    archives = [...folders];
    add(NuevoUser(archives));
  }

  Future<void> cargarScanPorID(int id) async {
    archives.clear();
    final folders = await DBProvider.db.getScansPorID(id);
    archives = [...folders];
    add(NuevoUser(archives));
  }
}
