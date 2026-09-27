/// Portfolio facts and asset references. Keep content changes here.
class AppScreenshot {
  const AppScreenshot(this.asset, this.label, {this.framed = false});
  final String asset;
  final String label;

  /// Some supplied screenshots already include their original device frame.
  final bool framed;
}

class PortfolioProject {
  const PortfolioProject({
    required this.name,
    required this.category,
    required this.description,
    required this.tags,
    this.repository,
    this.screenshots = const [],
  });
  final String name;
  final String category;
  final String description;
  final List<String> tags;
  final String? repository;
  final List<AppScreenshot> screenshots;
}

const github = 'https://github.com/fagerhu03';
const linkedin = 'https://www.linkedin.com/in/fagerhu';
const email = 'mailto:fagerhu03@gmail.com';

const featuredProject = PortfolioProject(
  name: 'Lost in Egypt',
  category: 'GRADUATION PROJECT · FLUTTER / AI',
  description:
      'A more thoughtful way to explore Egypt. A mobile travel companion that brings discovery, planning and local knowledge together.',
  repository: '$github/lost_in_egypt',
  tags: [
    'Flutter',
    'Firebase',
    'Google Maps',
    'BLoC / Provider',
    'Clean architecture',
  ],
  screenshots: [
    AppScreenshot(
      'assets/images/lost_in_egypt/home.webp',
      'Home & discovery',
      framed: true,
    ),
    AppScreenshot(
      'assets/images/lost_in_egypt/ai_camera.webp',
      'AI camera',
      framed: true,
    ),
    AppScreenshot(
      'assets/images/lost_in_egypt/map.webp',
      'Map exploration',
      framed: true,
    ),
    AppScreenshot(
      'assets/images/lost_in_egypt/community.webp',
      'Travel community',
      framed: true,
    ),
    AppScreenshot(
      'assets/images/lost_in_egypt/solo_trip.webp',
      'Solo trip',
      framed: true,
    ),
    AppScreenshot(
      'assets/images/lost_in_egypt/tour.webp',
      'Tours',
      framed: true,
    ),
  ],
);

// Team participation is verified by the repository's contributor list.
// Replace with specific responsibilities only when confirmed by Fager.
const contribution =
    'I contributed to Lost in Egypt as part of my graduation project team, bringing mobile development and intelligent travel features into one shared product.';

const mobileProjects = [
  PortfolioProject(
    name: 'Islami App',
    category: 'DAILY COMPANION',
    description:
        'Quran suras, prayer times and religious resources in an Arabic Flutter experience, with search and a responsive interface.',
    tags: ['Flutter', 'Dart', 'Arabic UI'],
    repository: '$github/islami',
    screenshots: [AppScreenshot('assets/images/islami.png', 'Hadith reader')],
  ),
  PortfolioProject(
    name: 'My Shopping App',
    category: 'MOBILE COMMERCE',
    description:
        'A straightforward shopping experience, from discovering products to managing a cart with persistent state.',
    tags: ['Flutter', 'State management', 'Commerce'],
    repository: '$github/My_Shopping',
    screenshots: [
      AppScreenshot('assets/images/shopping.png', 'Product collection'),
    ],
  ),
  PortfolioProject(
    name: 'Petal View',
    category: 'NASA SPACE APPS CHALLENGE',
    description:
        'Explore Earth and environmental data through interactive maps and visualizations, built for the NASA Space Apps Challenge.',
    tags: ['Flutter', 'Maps', 'Data visualization'],
    repository: '$github/petalview_nasa_spaceapp',
    screenshots: [AppScreenshot('assets/images/petal.png', 'Vegetation map')],
  ),
  PortfolioProject(
    name: 'Movie App',
    category: 'MOVIE DISCOVERY',
    description:
        'Discover popular, top-rated and upcoming films through a focused mobile interface connected to a public movie API.',
    tags: ['Flutter', 'REST API', 'Dart'],
    repository: '$github/movie_app',
    screenshots: [AppScreenshot('assets/images/movie.png', 'Movie discovery')],
  ),
];
const otherProjects = [
  PortfolioProject(
    name: 'AI-Based Chatbot',
    category: '01 / ARTIFICIAL INTELLIGENCE',
    description:
        'A university FAQ chatbot using natural language processing and a Flask backend to help students find answers.',
    tags: ['Python', 'NLTK / spaCy', 'Flask'],
  ),
  PortfolioProject(
    name: 'Smart Irrigation System',
    category: '02 / CONNECTED HARDWARE',
    description:
        'An Arduino system that uses soil moisture sensors and GSM-based monitoring to support more informed water use.',
    tags: ['Arduino', 'C++', 'IoT'],
  ),
  PortfolioProject(
    name: 'Cloud File Sharing Web App',
    category: '03 / CLOUD & WEB',
    description:
        'Co-developed a collaborative file-sharing app with authentication, Firestore and role-based access.',
    tags: ['React', 'Firebase', 'Google Cloud'],
  ),
  PortfolioProject(
    name: 'Computer Vision Object Detection',
    category: '04 / COMPUTER VISION',
    description:
        'Real-time object detection experiments with OpenCV, Haar cascades and HOG + SVM methods.',
    tags: ['Python', 'OpenCV', 'Machine learning'],
  ),
];
const skillGroups = [
  (
    'Mobile engineering',
    [
      'Flutter',
      'Dart',
      'BLoC / Cubit',
      'Provider',
      'Clean architecture',
      'Localization & RTL',
      'Material 3 & Custom UI',
      'Responsive Design',
    ],
  ),
  (
    'Data & integration',
    [
      'Firebase Ecosystem',
      'REST APIs',
      'SQLite / Hive',
      'Google Cloud',
      'Git & CI/CD',
      'Webhooks',
    ],
  ),
  (
    'Intelligent technologies',
    [
      'Python',
      'OpenCV',
      'TensorFlow',
      'scikit-learn',
      'IoT & Sensors',
      'NLP Basics',
    ],
  ),
  (
    'Soft skills',
    [
      'Problem Solving',
      'Teamwork',
      'Technical Writing',
      'Time Management',
      'Agile / Scrum',
      'Critical Thinking',
    ],
  ),
];
const training = [
  (
    '2025',
    'Mobile Development Diploma',
    'Route Academy',
    'Flutter applications, Firebase, Hive, APIs and state management.',
  ),
  (
    'SUMMER 2025',
    'Mobile Development Summer Camp',
    'Microsoft × Sprints',
    'Cross-platform development, responsive interfaces and practical Flutter projects.',
  ),
  (
    'SUMMER 2025',
    'Computer Vision & IoT',
    'Arab Organization for Industrialization',
    'Connecting computer vision with microcontrollers, sensors and MQTT.',
  ),
  (
    'SUMMER 2024',
    'Software Testing',
    'WE Telecom',
    'QA, the software development lifecycle, Selenium, JIRA and Postman.',
  ),
  (
    'SUMMER 2023',
    'Cloud Computing',
    'WE Telecom',
    'Google Cloud, virtual machines, serverless functions and Kubernetes.',
  ),
  (
    'SUMMER 2023',
    'AI Fundamentals',
    'Impact @ Zewail City',
    'Machine learning, neural networks and natural language processing.',
  ),
];
