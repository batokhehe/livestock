/// Asset paths constants for the application
/// This class provides centralized access to all asset paths
/// organized by asset type (audio, icons, images)
class AppAssets {
  AppAssets._();

  // Base paths
  static const String _iconsBasePath = 'assets/icons';
  static const String _imagesBasePath = 'assets/images';

  /// Icon assets
  static const AppIcons icons = AppIcons._();

  /// Image assets
  static const AppImages images = AppImages._();
}

class AppIcons {
  const AppIcons._();

  // Add more icon assets here as needed
  // Example:
  // String get profileIcon => '${AppAssets._iconsBasePath}/ic_profile.svg';
  String get search => '${AppAssets._iconsBasePath}/ic_search.svg';
}

class AppImages {
  const AppImages._();

  // Add image assets here as needed
  // Example usage - uncomment and modify as you add actual images:
  // String get placeholder => '${AppAssets._imagesBasePath}/placeholder.png';
}
