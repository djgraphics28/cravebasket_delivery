import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/provider/splash_provider.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/view/base/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class HtmlViewerScreen extends StatelessWidget {

  final bool isPrivacyPolicy;
  HtmlViewerScreen({@required this.isPrivacyPolicy});

  @override
  Widget build(BuildContext context) {
    String _data = isPrivacyPolicy ? Provider.of<SplashProvider>(context, listen: false).configModel.privacyPolicy ?? ''
        : Provider.of<SplashProvider>(context, listen: false).configModel.termsAndConditions ?? '';
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(title: getTranslated(isPrivacyPolicy ? 'privacy_policy' : 'terms_and_condition', context)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        physics: BouncingScrollPhysics(),
        child: HtmlWidget(
          _data ?? '',
          key: Key(_data.toString()),
          onTapUrl: (String url) {
            return launch(url);
          },
        ),
      ),
    );
  }
}