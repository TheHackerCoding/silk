import 'dart:io';
import 'dart:math';
import 'package:args/command_runner.dart';
import 'package:args/args.dart';
/**/
Map<String, String> envVars = Platform.environment;
// envVars.forEach((k, v) => print("Key=$k Value=$v"));
String log(x) {
	if (envVars['DEV'] == '1') {
		print(x);
	}
}
List<List<T>> chunk<T>(List<T> lst, int size) {
  return List.generate((lst.length / size).ceil(),
      (i) => lst.sublist(i * size, min(i * size + size, lst.length)));
}

void main(List<String> args) {
  
  /* <argument_parser_config> */
  var p = ArgParser();
  p.addSeparator("silk - Something to split and join files.");
  p.addSeparator("usage: silk [options] [file(s)]");
  p.addOption('mode', help: 'What operation silk will do', allowed: ['split', 'join'], defaultsTo: 'split');
  p.addOption('chunks', help: 'How many chunks you want silk to do', abbr: 'c');
  p.addOption('out', help: 'The output path', valueHelp: 'path', defaultsTo: '.');
  p.addFlag('help', abbr: 'h', negatable: false, help: 'Print this usage information.', callback: (help) {
  	if (help) print(p.usage);
  	});
  var r = p.parse(args);
  /* </argument_parser_config> */

  if (args == null || args.length != 2) {
  	print(p.usage);
    exit(1);
  }

  /* <argument_parser_var_config> */
  var out = r['out'].toString();
  var mode = r['mode'].toString();
  /* </argument_parser_var_config> */

  /* <split_argument> */
  if (mode == 'split') {
  	// var chunks = int.parse(r!['chunks'].toString());
  	var chunks = r!['chunks'];
  	if (chunks != null) {
  		if (int.tryParse(chunks) == null || int.parse(chunks) < 1) {
  		  print('--chunks value must be a positive integer.');
  		  exit(64);
  		}
		}

  	r.rest.forEach((k) {
  		var _k = k.toString();
  		var file = File(k);
  		var _file = file.readAsBytesSync();

  		/* <chunk_calculation> */
  		var chunkSize = _file.length  / chunks;
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
  			var part = File(k + '.part.' + i.toString() + '.silk');
  			var _part = part.writeAsBytesSync(x);
  			i++;
  		});
  		/* </file_splitter_creator> */
  		log(_file);
  	});
  } else {
  	/* */
  	return null;
  }
  /* </split_argument> */

  // log(r);
  // var file = File(r.res.toString());
  // var _file = file.readAsBytesSync();
  // print(_file);
 }