


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/bloc/prestamos/prestamos_bloc.dart';
import 'package:intl/intl.dart' as intl;


class BotonNav extends StatelessWidget {
  const BotonNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
       final size = MediaQuery.of(context).size;
           final formatter = intl.NumberFormat.decimalPattern();

    return BlocBuilder<PrestamosBloc, PrestamosState>(
      builder: (context, state) {
        return Container(
          height: size.height * 0.10,
          color: Colors.white,
          child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(
              "  Total a Pagar:  ${formatter.format(state.totalAPagar)} Gs",
              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
            ),
            SizedBox(width: size.width * 0.080,),
              Text(
              "  Total Interes: ${formatter.format(state.totalInteres)} Gs ",
              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
            ),
            SizedBox(width: size.width * 0.080,),
             Text(
              "  Total Capital: ${formatter.format(state.monto)} Gs",
              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
            ),
            SizedBox(width: size.width * 0.080,),
    
          ],
        )
        );
      },
    );
    
  } 
}