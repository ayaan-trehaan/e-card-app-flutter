# E-Card App Flutter Migration Guide

I have successfully converted your React project to Flutter. Below are the details of the migration and instructions for setting up your new environment.

## 1. Key Changes
- **Framework**: Migrated from React (Vite) to **Flutter 3.24.3**.
- **State Management**: Implemented using the `provider` package.
- **Routing**: Implemented using `go_router` to support clean URLs like `e-cardapp.vercel.app/@username`.
- **Database**: Integrated **Supabase** for authentication and data storage.
- **URLs**: All references to Lovable have been replaced with `https://e-cardapp.vercel.app`.

## 2. Supabase Setup
You need to set up your Supabase project to work with the Flutter app.

1.  **Create a Supabase Project**: Go to [supabase.com](https://supabase.com) and create a new project.
2.  **Run SQL Migrations**: Copy the content of `supabase_setup.sql` (included in the root of the Flutter project) and run it in the Supabase SQL Editor. This will create the `profiles` and `links` tables and set up the `avatars` storage bucket.
3.  **Authentication**:
    -   Enable **Email/Password** authentication in the Supabase Dashboard.
    -   To set up **Google Auth**, follow the [Supabase Google Auth Guide](https://supabase.com/docs/guides/auth/social-login/auth-google).
4.  **Update Flutter Config**:
    -   Open `lib/main.dart`.
    -   Replace `'https://your-project-url.supabase.co'` and `'your-anon-key'` with your actual Supabase project URL and Anon Key found in the API settings of your dashboard.

## 3. Running the App
To run the app locally:
```bash
flutter run -d chrome
```

## 4. Deployment
Since you mentioned using **Vercel** for hosting:
1.  Build the web version:
    ```bash
    flutter build web
    ```
2.  Deploy the contents of the `build/web` folder to Vercel. You can use the Vercel CLI or connect your GitHub repository.

## 5. Next Steps
- **User Data**: Once you provide the user data, I can help you write a script to import it into your new Supabase database.
- **Custom Domain**: Ensure `e-cardapp.vercel.app` is correctly configured in your Vercel dashboard.

Your complete Flutter project is ready in the `e_card_app_flutter` directory.
