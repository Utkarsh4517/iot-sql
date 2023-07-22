import 'package:mysql1/mysql1.dart';

class MySqlServer {
  static String host = 'sql6.freemysqlhosting.net';
  static String user = 'sql6634330';
  static String password = '2hKfFh5NxP';
  static String name = 'sql6634330';
  static int port = 3306;

  MySqlServer();

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
      host: host,
      user: user,
      password: password,
      db: name,
      port: port,
    );
    return await MySqlConnection.connect(settings);
  }
}
