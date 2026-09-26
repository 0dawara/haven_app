import 'package:haven/bootstrap.dart';
import 'package:haven/data/data.dart';
import 'package:haven/haven_app.dart';

void main() =>
    bootstrap(() => HavenApp(wallhavenRepository: WallhavenRepository()));
