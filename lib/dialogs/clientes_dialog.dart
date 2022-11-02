import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/bloc/login/login_bloc.dart';
import 'package:my_app/helpers/custom_input.dart';
import 'package:flutter/services.dart';

class ClientesDialog extends StatefulWidget {
  const ClientesDialog({Key? key}) : super(key: key);

  @override
  State<ClientesDialog> createState() => _ClientesDialogState();
}

class _ClientesDialogState extends State<ClientesDialog> {
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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  const Text(
                    "Formulario Nuevo Cliente",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: _submit,
                      icon: const Icon(
                        Icons.save,
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.020,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              width: size.width * 0.60,
              child: _formularioNombre(),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              width: size.width * 0.60,
              child: _formularioCI(),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              width: size.width * 0.60,
              child: _celular(),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              width: size.width * 0.60,
              child: _lugarTrabajo(),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              width: size.width * 0.60,
              child: _direccio(),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              width: size.width * 0.60,
              child: _referencia(),
            )
          ],
        ),
      ),
    );
  }

  Widget _formularioNombre() {
    return TextFormField(
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
          return 'El nombre debe de ser de dos letras como mínimo.';
        }
        return null;
      },
    );
  }

  Widget _formularioCI() {
    return TextFormField(
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

    loginBloc.nuevoFolder(_nombre, int.parse(_cedula), _telefono, _trabajo,
        _direccion, _referencias);
    Navigator.pop(context);
  }
}
