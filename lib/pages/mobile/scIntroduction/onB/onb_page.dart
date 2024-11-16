import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laborus_app/core/data/local_database.dart';
import 'package:laborus_app/core/routes/app_route_enum.dart';
import 'package:laborus_app/core/utils/theme/colors.dart';
import 'package:laborus_app/pages/mobile/scIntroduction/onB/widgets/build_continue_button.dart';
import 'package:laborus_app/pages/mobile/scIntroduction/onB/widgets/build_text_rich.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int activeIndex = 0;
  final PageController pageController = PageController();
  final List<String> urlImages = [
    'assets/img/laborus_light.png',
    'assets/img/welcome_onb.png',
    'assets/img/slide3.jpeg',
  ];
  final List<String> titles = ['Laborus', 'Compartilhe', 'Interaja'];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void refresh() async {
    await LocalDatabase.setOnboardingShown();
    final routePath = AppRouteEnum.welcome.name;
    if (mounted) {
      context.pushReplacement(routePath);
    }
  }

  Function()? refreshButton() {
    setState(() {});
    if (activeIndex == urlImages.length - 1) {
      return refresh;
    }
    return null;
  }

  Widget buildCarouselItem(
      String urlImage, String title, Widget label, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              image: DecorationImage(
                image: AssetImage(urlImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            child: label,
          ),
        ],
      ),
    );
  }

  Widget buildPageIndicator() {
    return AnimatedSmoothIndicator(
      onDotClicked: (index) {
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      effect: const ExpandingDotsEffect(
        dotWidth: 15,
        dotHeight: 15,
        activeDotColor: AppColors.darknessPurple,
        dotColor: Colors.grey,
      ),
      activeIndex: activeIndex,
      count: urlImages.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final labels = [
      buildRichText([
        'Sua plataforma de ',
        'gestão acadêmica ',
        'e',
        ' oportunidades profissionais!'
      ], [
        false,
        true,
        false,
        true
      ], context),
      buildRichText([
        'Compartilhe ',
        'trabalhos acadêmicos ',
        'e ',
        'converse ',
        'com outros estudantes.'
      ], [
        false,
        true,
        false,
        true,
        false
      ], context),
      buildRichText([
        'Encontre novas pessoas e ',
        'faça amizades ',
        'com base nos ',
        'interesses',
        ' similares'
      ], [
        false,
        true,
        false,
        true,
        false
      ], context),
    ];

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 320,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: urlImages.length,
                  onPageChanged: (index) {
                    setState(() => activeIndex = index);
                  },
                  itemBuilder: (context, index) {
                    return buildCarouselItem(
                      urlImages[index],
                      titles[index],
                      labels[index],
                      index,
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              buildPageIndicator(),
            ],
          ),
          buildContinueButton(activeIndex, urlImages, refreshButton, context),
        ],
      ),
    );
  }
}
