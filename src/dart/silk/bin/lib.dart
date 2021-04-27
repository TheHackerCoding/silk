import 'dart:io';
import 'dart:math';

Map<String, String> envVars = Platform.environment;
// envVars.forEach((k, v) => print("Key=$k Value=$v"));
String? log(x) {
  if (envVars['DEV'] == '1') {
    print(x);
  }
}

List<List<T>> chunk<T>(List<T> lst, int size) {
  return List.generate((lst.length / size).ceil(),
      (i) => lst.sublist(i * size, min(i * size + size, lst.length)));
}
