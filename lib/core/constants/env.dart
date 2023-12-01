import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
  static final String supabaseUrl = _Env.supabaseUrl;
  @EnviedField(varName: 'ANON_KEY', obfuscate: true)
  static final String anonKey = _Env.anonKey;
}
