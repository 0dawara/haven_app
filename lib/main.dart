import 'package:haven_app/bootstrap.dart';
import 'package:haven_app/haven_app.dart';
import 'package:haven_app/data/data.dart';

void main() =>
    bootstrap(() => HavenApp(wallhavenRepository: WallhavenRepository()));
