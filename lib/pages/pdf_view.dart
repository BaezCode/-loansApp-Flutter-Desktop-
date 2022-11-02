import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:printing/printing.dart';

class PDFViewPage extends StatefulWidget {
  final Uint8List data;

  const PDFViewPage({Key? key, required this.data}) : super(key: key);

  @override
  State<PDFViewPage> createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  late PdfController _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfController(
      document: PdfDocument.openData(widget.data),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Generando Documentos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () {
              _pdfController.previousPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
          PdfPageNumber(
            controller: _pdfController,
            builder: (_, loadingState, page, pagesCount) => Container(
              alignment: Alignment.center,
              child: Text(
                '$page/${pagesCount ?? 0}',
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: () {
              _pdfController.nextPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
          const SizedBox(
            width: 25,
          ),
          IconButton(
              onPressed: () async {
                await Printing.layoutPdf(onLayout: (format) => widget.data);
              },
              icon: const Icon(
                Icons.print,
                color: Colors.white,
              )),
          const SizedBox(
            width: 15,
          ),
          IconButton(
              onPressed: () async {
                await FileSaver.instance.saveFile("holaa", widget.data, ".pdf",
                    mimeType: MimeType.PDF);
              },
              icon: const Icon(
                Icons.download,
                color: Colors.white,
              )),
          const SizedBox(
            width: 25,
          )
        ],
      ),
      body: PdfView(pageSnapping: true, controller: _pdfController),
    );
  }
}
