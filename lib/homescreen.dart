import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webpage_demo/constant.dart'; // Assuming this holds AppColors and WebpageText

// --- Home Page Widget ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Define constant breakpoints for easier management and clarity
  static const double _kSmallScreenBreakpoint = 600.0; // E.g., for phones
  static const double _kMediumScreenBreakpoint = 900.0; // E.g., for tablets

  @override
  void initState() {
    super.initState();
    // Optional: Set system UI overlay style for a cleaner look
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Make status bar transparent
        statusBarIconBrightness:
            Brightness.dark, // Dark icons on light background
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // Determine screen size based on breakpoints
    final bool isSmallScreen = screenWidth < _kSmallScreenBreakpoint;
    final bool isMediumScreen =
        screenWidth >= _kSmallScreenBreakpoint &&
        screenWidth < _kMediumScreenBreakpoint;
    final bool isLargeScreen = screenWidth >= _kMediumScreenBreakpoint;

    // This ensures font is picked up from main.dart's ThemeData
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Determine horizontal padding based on screen size for consistent look
    final double horizontalPadding =
        isLargeScreen
            ? 80.0 // Adjusted for consistency with main content
            : (isSmallScreen ? 20.0 : 40.0);

    return Scaffold(
      // Drawer for small and medium screens (Hamburger menu)
      drawer: isLargeScreen ? null : _buildDrawer(context),

      // Use AppBar for the header, which automatically handles the drawer icon
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          80.0,
        ), // Custom height for the AppBar
        child: _buildAppBar(
          context,
          isLargeScreen,
          isSmallScreen,
          horizontalPadding,
        ),
      ),

      // IMPORTANT: Wrap the entire content in SingleChildScrollView to prevent vertical overflow.
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: _buildMainContent(context, isLargeScreen, isSmallScreen),
            ),
            // Add other sections of your page here (e.g., footer, additional content)
            // Consider adding a footer here, also with responsive padding
            // Example:
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 40.0),
            //   child: Text('© 2025 Your Company', style: textTheme.bodySmall),
            // ),
          ],
        ),
      ),
    );
  }

  // --- Helper Methods for Building UI Sections ---

  Widget _buildAppBar(
    BuildContext context,
    bool isLargeScreen,
    bool isSmallScreen,
    double horizontalPadding, // Pass padding for consistency
  ) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0, // No shadow for a flat look
      toolbarHeight:
          80, // Matches PreferredSize height - fixed for AppBar standard
      centerTitle: false, // Align title to the start (left)
      // Flutter automatically adds the leading hamburger icon if 'drawer' is present in Scaffold
      automaticallyImplyLeading:
          !isLargeScreen, // Only show hamburger if not large screen
      // Use a Padding widget to apply the consistent horizontal padding to the title
      title: Padding(
        // Adjust left padding for the title to align with main content.
        // AppBar has its own internal padding for leading widget, so we subtract it out.
        // A common default for leading is around 56-48px. Fine-tune this.
        padding: EdgeInsets.all(
          isLargeScreen ? 80 : 0,
        ), // Already `titleSpacing: 0` below
        child: Text(
          WebpageText.headerLogoText,
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.accentColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            fontSize: isLargeScreen ? 24 : (isSmallScreen ? 18 : 20),
          ),
          overflow: TextOverflow.ellipsis, // Ensure text wraps nicely
        ),
      ),
      actions: [
        if (isLargeScreen)
          // Navigation links for large screens as actions in the AppBar
          // Apply padding to this Row for consistency.
          // AppBar's default right padding is often around 16.0, adjust `horizontalPadding` accordingly.
          Padding(
            padding: EdgeInsets.only(
              right: horizontalPadding,
            ), // Align with main content
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:
                  WebpageText.navLinks.map((linkText) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ), // Fixed small gap
                      child: TextButton(
                        onPressed: () {
                          _handleNavLinkPress(linkText);
                        },
                        child: Text(
                          linkText,
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.accentColor,
                            fontFamily: 'Inter',
                            fontSize:
                                16, // Fixed font size for navigation links
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
      ],
      // The `titleSpacing` property of AppBar can also be used for fine-tuning
      // how much space there is between the leading icon and the title.
      // Set to 0 to remove default padding and apply your own via Padding widget for title.
      titleSpacing:
          0, // Remove default title spacing to apply custom padding via AppBar's content
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // Remove default ListView padding
        children: [
          // DrawerHeader - Keep it for branding/logo
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.accentColor, // Background color for the header
            ),
            child: Align(
              // Use Align to control placement within header
              alignment: Alignment.bottomLeft,
              child: Text(
                WebpageText.headerLogoText,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Navigation links as ListTiles, *below* the DrawerHeader
          ...WebpageText.navLinks.map((linkText) {
            return ListTile(
              title: Text(
                linkText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryColor, // Adjusted color for contrast
                  fontFamily: 'Inter',
                ),
              ),
              onTap: () {
                _handleNavLinkPress(linkText);
                Navigator.pop(context); // Close the drawer
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    bool isLargeScreen,
    bool isSmallScreen,
  ) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return isLargeScreen
        ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 18.0,
                ), // Fixed small gap on right
                child: _buildTextContentAndButtons(isLargeScreen, textTheme),
              ),
            ),
            const SizedBox(
              width: 40,
            ), // Fixed gap between two Expanded sections
            Expanded(
              flex: 2,
              child: _buildMainImage(
                480.0, // Fixed height for main image on large screen
                null, // Width controlled by Expanded
              ),
            ),
          ],
        )
        : Column(
          // Column for medium and small screens
          crossAxisAlignment:
              CrossAxisAlignment
                  .start, // Align entire column content to the start
          children: [
            // No extra Padding here as it's applied outside this method in build
            _buildTextContentAndButtons(
              isLargeScreen,
              textTheme,
            ), // This helper now includes the image conditionally
          ],
        );
  }

  // New helper method for the main image with responsive sizing
  Widget _buildMainImage(double height, double? width) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.network(
        'https://images.unsplash.com/photo-1750672951701-b9dcb289ea29?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1phvdg-ZmVlZHwzfHx8ZW58MHx8fHx8',
        height: height,
        width: width, // Use the provided width (e.g., double.infinity for fill)
        filterQuality: FilterQuality.high,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            color: AppColors.lightGreyBackground,
            child: const Center(
              child: Text(
                'Image Failed to Load',
                style: TextStyle(color: AppColors.greyTextColor),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextContentAndButtons(bool isLargeScreen, TextTheme textTheme) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen =
        screenWidth < _kSmallScreenBreakpoint; // Need this info here too

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Align content to the start (left)
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          WebpageText.pageHeaderTitle,
          style: textTheme.displayMedium?.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            fontSize:
                isLargeScreen
                    ? 60
                    : (screenWidth > 450
                        ? 48
                        : 36), // More granular font size adjustment
            height: 1.1,
          ),
          maxLines:
              isLargeScreen
                  ? 5
                  : 5, // Allow more lines on smaller screens if needed
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: isLargeScreen ? 30 : 20), // Fixed vertical space
        Text(
          WebpageText.pageDescription,
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',

            fontSize: isLargeScreen ? 18 : 16,
            height: 1.5,
          ),
          maxLines: isLargeScreen ? 8 : 8,
          overflow: TextOverflow.ellipsis,
        ),
        // --- IMAGE PLACEMENT FOR SMALLER SCREENS ---
        if (!isLargeScreen) // Only add image here if it's NOT a large screen
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
            ), // Add vertical spacing around the image
            child: _buildMainImage(
              isSmallScreen
                  ? 250.0
                  : 350.0, // Dynamic height for image on smaller screens
              double.infinity, // Image fills width
            ),
          ),

        // --- END IMAGE PLACEMENT ---
        SizedBox(height: isLargeScreen ? 30 : 20), // Fixed vertical space
        _buildActionButtons(isLargeScreen, textTheme),
        SizedBox(height: isLargeScreen ? 30 : 30), // Fixed vertical space
        _buildStatisticsSection(isLargeScreen),
      ],
    );
  }

  // This widget now intelligently uses Wrap for responsiveness without static widths
  Widget _buildActionButtons(bool isLargeScreen, TextTheme textTheme) {
    return Padding(
      padding:
          isLargeScreen
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(vertical: 10.0),
      child: Wrap(
        spacing: isLargeScreen ? 50 : 20, // Spacing between buttons
        runSpacing: 20, // Spacing for wrapped rows of buttons
        alignment: WrapAlignment.start, // Align items to the start (left)
        crossAxisAlignment: WrapCrossAlignment.center, // Align items vertically
        children: [
          // ElevatedButton adapts its width based on content and parent constraints
          ElevatedButton(
            onPressed: () {
              print('Explore Now Pressed');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 15,
              ), // Consistent padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 5,
            ),
            child: Text(
              WebpageText.exploreNowButton,
              style: textTheme.labelLarge?.copyWith(
                color: AppColors.white,
                fontSize: 18, // Fixed font size for button label
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
          // This Row will act as a single item within the Wrap
          Row(
            mainAxisSize:
                MainAxisSize
                    .min, // Keep this row compact to allow Wrap to manage it
            children: [
              Container(
                // Minimum size for the interactive play button area (usability/accessibility)
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.accentColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.greyTextColor.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.play_arrow),
                  color: AppColors.accentColor,
                  iconSize: 30, // Fixed icon size
                  onPressed: () {
                    print('Watch Video Pressed');
                  },
                ),
              ),
              const SizedBox(width: 10), // Fixed small gap
              Text(
                WebpageText.watchVideoButton,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.primaryColor,
                  fontSize: isLargeScreen ? 18 : 16, // Dynamic font size
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // This widget is naturally responsive due to Column and Text
  Widget _buildStatisticsSection(bool isLargeScreen) {
    return Padding(
      padding:
          isLargeScreen
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(vertical: 20.0),
      child: Wrap(
        spacing:
            isLargeScreen ? 80 : 30, // Horizontal spacing between stats items
        runSpacing: 20, // Vertical spacing if stats items wrap
        alignment:
            WrapAlignment
                .start, // Always start alignment for items within the Wrap
        children: [
          _buildStatisticItem(
            WebpageText.statsFurnitureCount,
            WebpageText.statsFurnitureLabel,
            isLargeScreen,
          ),
          _buildStatisticItem(
            WebpageText.statsInteriorCount,
            WebpageText.statsInteriorLabel,
            isLargeScreen,
          ),
          _buildStatisticItem(
            WebpageText.statsHappyClientsCount,
            WebpageText.statsHappyClientsLabel,
            isLargeScreen,
          ),
        ],
      ),
    );
  }

  // This widget (Column of Texts) inherently adapts to content and parent constraints
  Widget _buildStatisticItem(String count, String label, bool isLargeScreen) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Always start for individual stat items
      children: [
        Text(
          count,
          style: textTheme.headlineMedium?.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            fontSize: isLargeScreen ? 36 : 28, // Dynamic font size
          ),
        ),
        const SizedBox(height: 5), // Fixed small gap
        Text(
          label,
          textAlign: TextAlign.start, // Always start align label
          style: textTheme.titleSmall?.copyWith(
            color: AppColors.greyTextColor,
            fontWeight: FontWeight.w400,
            fontFamily: 'Inter',
            fontSize: isLargeScreen ? 16 : 14, // Dynamic font size
          ),
        ),
      ],
    );
  }

  // --- Event Handlers ---
  void _handleNavLinkPress(String linkText) {
    print('Navigating to $linkText');
  }
}
