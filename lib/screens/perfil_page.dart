import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/bloc/login/login_bloc.dart';
import 'package:my_app/helpers/custom_input.dart';
import 'package:my_app/helpers/dialog.dart';
import 'package:my_app/helpers/snackbar.dart';
import 'package:my_app/models/archives_model.dart';
import 'package:my_app/widgets/white_card.dart';

class PerfilPage extends StatefulWidget {
  final ArchivesModel archivesModel;

  const PerfilPage({Key? key, required this.archivesModel}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _cedula = "";
  String _nombre = "";
  String _telefono = "";
  String _trabajo = "Notas";
  String _direccion = "";
  String _referencias = "";

  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
    _cedula = widget.archivesModel.cedula.toString();
    _nombre = widget.archivesModel.nombre;
    _telefono = widget.archivesModel.telefono;
    _trabajo = widget.archivesModel.trabaja;
    _direccion = widget.archivesModel.direccion!;
    _referencias = widget.archivesModel.referencia!;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: _submit,
        child: const Icon(Icons.save),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 35,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.archivesModel.nombre,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () async {
                final action = await Dialogs.yesAbortDialog(
                    context,
                    'Eliminar Usuario',
                    'Deseas Eliminar a ${widget.archivesModel.nombre} y todo su historial de Prestamos?');
                if (action == DialogAction.yes && mounted) {
                  loginBloc.borrarUsuarios(widget.archivesModel.id!);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  CustomWidgets.buildSnackbar(
                      context, "Usuario Eliminado Correctamente", Icons.check);
                } else {}
              },
              icon: const Icon(CupertinoIcons.delete)),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: WhiteCard(
          child: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Configuracion De Cuenta",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            SizedBox(width: size.width * 0.50, child: _formularioNombre()),
            const SizedBox(
              height: 30,
            ),
            SizedBox(width: size.width * 0.50, child: _formularioCI()),
            const SizedBox(
              height: 30,
            ),
            SizedBox(width: size.width * 0.50, child: _celular()),
            const SizedBox(
              height: 30,
            ),
            SizedBox(width: size.width * 0.50, child: _lugarTrabajo()),
            const SizedBox(
              height: 30,
            ),
            SizedBox(width: size.width * 0.50, child: _direccio()),
            const SizedBox(
              height: 30,
            ),
            SizedBox(width: size.width * 0.50, child: _referencia()),
          ],
        ),
      )),
    );
  }

  Widget _formularioNombre() {
    return TextFormField(
      initialValue: _nombre,
      decoration: CustomInputs.formInputDecoration(
          hint: 'Nombre del usuario',
          label: 'Nombre',
          icon: Icons.supervised_user_circle_outlined),
      onSaved: (value) => _nombre = value!,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese un nombre.';
        }
        if (value.length < 2) {
          return 'El nombre debe de ser de  dos letras como mínimo.';
        }
        return null;
      },
    );
  }

  Widget _formularioCI() {
    return TextFormField(
      initialValue: _cedula,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      decoration: CustomInputs.formInputDecoration(
          hint: 'Numero de Cedula', label: 'C.I', icon: Icons.account_box),
      onSaved: (value) => _cedula = value!,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese un numero de C.i.';
        }
        if (value.length < 3) {
          return 'EL numerode CI deve tener minimo 2 Caracteres.';
        }
        return null;
      },
    );
  }

  Widget _celular() {
    return TextFormField(
      initialValue: _telefono,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      decoration: CustomInputs.formInputDecoration(
          hint: 'Numero de Celular',
          label: 'Celular',
          icon: Icons.phone_android_rounded),
      onSaved: (value) => _telefono = value!,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese un numero de Celular.';
        }
        if (value.length < 3) {
          return 'EL numerode Celular deve tener minimo 2 Caracteres.';
        }
        return null;
      },
    );
  }

  Widget _lugarTrabajo() {
    return TextFormField(
      initialValue: _trabajo,
      decoration: CustomInputs.formInputDecoration(
          hint: 'Lugar de Trabajo', label: 'Trabajo', icon: Icons.work),
      onSaved: (value) => _trabajo = value!,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese un numero de Celular.';
        }
        if (value.length < 3) {
          return 'EL numerode Celular deve tener minimo 2 Caracteres.';
        }
        return null;
      },
    );
  }

  Widget _direccio() {
    return TextFormField(
      initialValue: _direccion,
      decoration: CustomInputs.formInputDecoration(
          hint: 'Lugar donde vive', label: 'Domicilio', icon: Icons.house),
      onSaved: (value) => _direccion = value!,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese un numero de Celular.';
        }
        if (value.length < 3) {
          return 'EL numerode Celular deve tener minimo 2 Caracteres.';
        }
        return null;
      },
    );
  }

  Widget _referencia() {
    return TextFormField(
      initialValue: _referencias,
      decoration: CustomInputs.formInputDecoration(
          hint: 'Nombre de Referencia', label: 'Referencias', icon: Icons.info),
      onSaved: (value) => _referencias = value!,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese un numero de Celular.';
        }
        if (value.length < 3) {
          return 'EL numerode Celular deve tener minimo 2 Caracteres.';
        }
        return null;
      },
    );
  }

  void _submit() {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    loginBloc.update(
        _nombre,
        int.parse(_cedula),
        _telefono,
        _trabajo,
        _direccion,
        _referencias,
        widget.archivesModel.id!,
        widget.archivesModel.idCliente!);
    Navigator.pop(context);
    CustomWidgets.buildSnackbar(
        context, "Usuario Modificado Correctamente", Icons.check);
  }
}
