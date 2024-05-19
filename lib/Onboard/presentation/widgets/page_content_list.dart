/// The model representing onboarding content for the Idea Atlas application.
class OnBoardingContentModel {
  /// The title of the onboarding content.
  final String title;

  /// The description of the onboarding content.
  final String description;

  /// The image asset path for the onboarding content.
  final String image;

  /// Creates an instance of [OnBoardingContentModel].
  ///
  /// The [title], [description], and [image] parameters are required.
  OnBoardingContentModel({
    required this.title,
    required this.description,
    required this.image,
  });
}

/// A list of predefined onboarding content for the Idea Atlas application.
List<OnBoardingContentModel> onBoardingContentsList = [
  OnBoardingContentModel(
    title: "onboard_title_one",
    description: "onboard_desc_one",
    image: "Hosgeldin_4",
  ),
  OnBoardingContentModel(
    title: "onboard_title_two",
    description: "onboard_desc_two",
    image: "Hosgeldin_4",
  ),
  OnBoardingContentModel(
    title: "onboard_title_three",
    description: "onboard_desc_three",
    image: "Hosgeldin_4",
  ),
  OnBoardingContentModel(
    title: "onboard_title_four",
    description: "onboard_desc_four",
    image: "Hosgeldin_4",
  ),
  OnBoardingContentModel(
    title: "onboard_title_five",
    description: "onboard_desc_five",
    image: "Hosgeldin_4",
  ),
];
