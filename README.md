### **A Stellar Flutter Web Project\!**

It's clear you've poured a lot of effort into this **modern Interior Design Studio landing page** built with Flutter. The project really shines in several key areas:

  \* **Pixel-Perfect & Adaptive UI:** This is crucial for today's web, and your focus on a UI that **flawlessly adapts across desktop, tablet, and mobile** with intelligent content wrapping is a testament to strong responsive design.

  \* **Engaging User Flow:** From the **bold Hero Section** to key business statistics and dynamic navigation with an **integrated Drawer menu for mobile**, you've thought about how users will interact and engage with the site.

  \* **Exemplary Code Architecture:** Building for **maintainability and scalability** using Flutter best practices and centralized theming demonstrates a professional and forward-thinking approach to development.

  \* **Flutter's Web Prowess:** You're showcasing a powerful example of **high-performance web applications from a single codebase**, efficiently deployed via **GitHub Actions**. This really highlights Flutter's strength as a full-stack solution.

-----
## 📸 Screenshots

Here's a glimpse of the NEXT E-commerce App in action:


# Android Screen
<img height="480px" src="assets/images/mobile_drawer.png">
<img height="480px" src="assets/images/response.png">

### **Experience It Yourself\!**

You've made it super easy for anyone to see your work in action:

  \* **Live Webpage Demo:** https://anikitdeveloper96.github.io/Flutter-Web-Responsive-Design-Anikit-Grover/

  \* **Video Walkthrough:** https://www.youtube.com/watch?v=xSGi7VRSf9w

-----

### **How to Publish This Project to GitHub Pages (Manual Git Method)**

This section outlines the steps to build and deploy your Flutter web application to GitHub Pages using standard Git commands, without relying on `npm` or other package managers for the deployment step itself.

**Prerequisites:**

  * **Flutter SDK installed:** Ensure Flutter is set up on your machine.
  * **Git installed:** You'll need Git for version control.
  * **GitHub account:** A GitHub account is required to create repositories and host pages.

**Workflow Overview:**

Your Flutter project's source code will reside on the `main` branch. The compiled web assets (from the `build/web` directory) will be pushed to a separate `gh-pages` branch, which GitHub Pages will then serve.

**Step-by-Step Guide:**

1.  **Ensure Flutter Web Support is Enabled (One-time Setup):**
    If this is a new project or you haven't enabled web support yet:

    ```bash
    flutter config --enable-web
    flutter create . --platform web # Run in your project root if adding web to existing project
    ```

2.  **Develop Your Flutter Web App:**
    Build your application as usual. Test it locally to ensure it functions as expected:

    ```bash
    flutter run -d chrome
    ```

3.  **Prepare Your `.gitignore`:**
    It's crucial that your `build/` directory is ignored by your `main` branch. Open your `.gitignore` file (in your project's root) and ensure it contains the line:

    ```
    /build/
    ```

    This prevents your compiled web app from being committed alongside your source code.

4.  **Push Your Flutter Source Code to `main`:**
    Regularly commit and push your Flutter project's source code to your GitHub repository's `main` branch:

    ```bash
    # Go to your project's root directory if you're not already there
    # cd your_flutter_project_name

    git add .
    git commit -m "feat: My awesome new Flutter feature"
    git push origin main # Or 'master' if that's your default branch
    ```

    *(At this point, only your source code is on GitHub; your web app is not yet live.)*

5.  **Build Your Flutter Web App for Release:**
    This command compiles your Flutter code into static web files. **Remember to replace `<YOUR_REPO_NAME>` with the exact name of your GitHub repository.** For this project, it would be `/Flutter-Web-Responsive-Design-Anikit-Grover/`.

    ```bash
    flutter build web --release --base-href /<YOUR_REPO_NAME>/
    ```

    This generates the deployable files in the `build/web` directory.

6.  **Manually Deploy `build/web` to the `gh-pages` Branch:**
    This set of Git commands will create/update a `gh-pages` branch in your remote repository with *only* the contents of your `build/web` folder.

    ```bash
    # Ensure you are in your Flutter project's root directory
    cd <your_flutter_project_name>

    # 6.1. Optional: Ensure your main branch is clean before temporary operations
    git status
    # If there are uncommitted changes, commit or stash them.

    # 6.2. Create and switch to a temporary orphan branch for deployment
    # The --orphan flag creates a new branch without any commit history.
    git checkout --orphan gh-pages-temp

    # 6.3. Remove all files from this temporary branch's working directory
    # (Since it's an orphan branch, this ensures a clean slate)
    git rm -rf .

    # 6.4. Copy the *contents* of your built web app into the current directory
    # (which is the root of your temporary branch's working directory)
    cp -r build/web/* .

    # 6.5. Add all the copied files
    git add .

    # 6.6. Commit these files to the temporary branch
    git commit -m "Deploy Flutter web app to GitHub Pages"

    # 6.7. Push the temporary branch to the remote 'gh-pages' branch
    # The --force flag is used because you are replacing the entire history
    # of the 'gh-pages' branch with this new build. This is standard for static
    # site deployment branches.
    git push origin gh-pages-temp:gh-pages --force

    # 6.8. Switch back to your 'main' branch and delete the temporary branch
    git checkout main
    git branch -D gh-pages-temp
    ```

7.  **Configure GitHub Pages on GitHub.com (One-time Setup/Verification):**
    This step tells GitHub to serve your website from the `gh-pages` branch.

      * Go to your repository on GitHub.com.
      * Click on the **`Settings`** tab.
      * In the left sidebar, click on **`Pages`**.
      * Under "Build and deployment," for "Source," select the **`gh-pages`** branch.
      * For "Folder," select `/ (root)`.
      * Click the **`Save`** button.
