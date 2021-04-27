import 'dart:io';
import 'dart:convert';
import 'package:ansicolor/ansicolor.dart';
import 'package:args/command_runner.dart';
import 'lib.dart';

/* <init_stuff> */
AnsiPen red = new AnsiPen()..red(bold: true);

error(x) {
  print('Something went wrong...');
  print(red(x));
}
/* </init_stuff> */

void main(List<String> args) {
  var r = CommandRunner('silk', 'something to manage files')
    ..addCommand(SplitCommand())
    ..addCommand(JoinCommand());
  r.run(args).catchError((error) {
    if (error is! UsageException) throw error;
    print(error);
    exit(64);
  });
}

class SplitCommand extends Command {
  final name = 'split';
  final description = 'Split files';

  SplitCommand() {
    argParser.addOption('chunks',
        help: 'How many chunks you want silk to do',
        abbr: 'c',
        defaultsTo: '5');
  }

  void run() {
    Map checksum = {};
    var chunks = argResults?['chunks'];
    chunks = int.parse(chunks);
    checksum['chunks'] = chunks;
    checksum['files'] = [];
    argResults?.rest.forEach((k) {
      var _k = k.toString();
      var file = File(k);
      var _file = file.readAsBytesSync();

      /* <chunk_calculation> */
      var chunkSize = _file.length / chunks;
      log(chunkSize);
      var _chunkSize = _file.length % chunks;
      var __file = chunk(_file, chunkSize.toInt());
      log(_chunkSize);
      if (_chunkSize != 0) {
        var last = __file.last;
        __file[__file.length - 2] = __file[__file.length - 2] + last;
        __file.removeLast();
        log(__file);
      }
      /* </chunk_calculation> */

      /* <file_splitter_creator> */
      var i = 1;
      __file.forEach((x) {
        print(x.hashCode);
        var fileName = k + '.part' + i.toString() + '.silk';
        checksum['files'].add(fileName);
        var part = File(fileName);
        var _part = part.writeAsBytesSync(x);
        i++;
        _part = null;
      });
      /* </file_splitter_creator> */
      log(_file);
      log(checksum);
      var _checksum = json.encode(checksum);
      var _checksumFile = File(k + '.silk.checksum');
      _checksumFile.writeAsStringSync(_checksum);
    });
  }
}

class JoinCommand extends Command {
  final name = 'join';
  final description = 'join files together';

  JoinCommand() {}

  void run() {
    var i;    
    argResults?.rest.forEach((k) {
      var _k = k.toString();
      var file = File(_k);
      var _file;
      try {
        _file = file.readAsStringSync();      
      } catch (e) {
        error(e);
      }
      var _checksum = json.decode(_file);
      print(_checksum['chunks']);
    });
    
  }
}
