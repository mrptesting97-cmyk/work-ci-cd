import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/routes/app_pages.dart';
import 'presentation/widgets/global_chat_wrapper.dart';
import 'presentation/controllers/property_form_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const HostApp());
}

class HostApp extends StatelessWidget {
  const HostApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Host App',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.lazyPut(() => PropertyFormController(), fenix: true);
      }),
      builder: (context, child) {
        return GlobalChatWrapper(child: child ?? const SizedBox());
      },
    );
  }
}
