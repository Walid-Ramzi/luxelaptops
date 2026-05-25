# LuxeLaptops

Premium Flutter storefront for **high-end laptops only** — clean architecture, Provider state, mock data ready for API wiring.

## Structure

```
lib/
├── main.dart                 # App init, theme, routes only
├── core/                     # Theme, colors, route names
├── data/                     # Models, mock catalog, ProductService
└── presentation/             # Screens, reusable widgets, providers
```

## Run locally

1. Install [Flutter](https://docs.flutter.dev/get-started/install) and ensure `flutter` is on your PATH.
2. From this folder:

```bash
cd C:\Users\WALID\Projects\luxelaptops
flutter pub get
flutter run -d chrome
```

Phone on same Wi‑Fi (PC must stay on):

```bash
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

Then open `http://<your-pc-ip>:8080` on your phone.

## Deploy online (GitHub Pages)

See **[DEPLOY.md](DEPLOY.md)** for step-by-step instructions. After setup, the site stays online even when your PC is off.

## Features

- Web-first layout: top nav, centered max-width (1280px), no bottom bar
- Single-page scroll: Home hero carousel + Shop section with smooth anchor scroll
- Live search (name, brand, specs), price range slider, price sort
- English / Français / العربية with RTL for Arabic
- Local cart, product detail routes
- Glassmorphism UI, neon accents, hover micro-interactions

## Backend

Replace mock data in `lib/data/services/api_service.dart` — `ProductService.fetchProducts()` is the single integration point.
