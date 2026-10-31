# TaskManagerClient

This project was generated using [Angular CLI](https://github.com) version 22.2.3.

## SSL / HTTPS Local Setup

Before starting the development server for the first time, you must generate a local SSL certificate and trust it on your machine. This script automates creating the certificate files inside `src/assets/ssl/` and imports them into your system's trust store to avoid browser security warnings.

### Windows (PowerShell)

1. Open PowerShell as an **Administrator**.
2. Run the setup script:

   ```powershell
   .\scripts\Setup-SSL-files.ps1
   ```

### Git Bash

1. Open Git Bash as an **Administrator**.
2. Run the setup script:

   ```bash
   ./scripts/setup-ssl.sh
   ```

_Note: Restart your browser completely after running either script so it registers the new trust rule._

## Environment & Backend API Configuration

The application uses Angular environment files to point to the Task Manager backend server API.

1. Navigate to `src/environments/`.
2. Open `environment.development.ts` (for local development) or `environment.ts` (for production).
3. Update or verify the base API endpoint URL:

   ```typescript
   export const environment = {
     production: false,
     apiUrl: 'https://localhost:5001/api', // Point this to your local backend server port
   };
   ```

## Development server

To start your local development server over secure HTTPS, run:

```bash
ng serve
```

Once the server is running, open your browser and navigate to `https://localhost:4300/`. The application will automatically reload whenever you modify any of the source files.

## Code scaffolding

Angular CLI includes powerful code scaffolding tools. To generate a new component, run:

```bash
ng generate component component-name
```

For a complete list of available schematics (such as `components`, `directives`, or `pipes`), run:

```bash
ng generate --help
```

## Building

To build the project run:

```bash
ng build
```

This will compile your project and store the build artifacts in the `dist/` directory. By default, the production build optimizes your application for performance and speed.

## Running unit tests

To execute unit tests with the [Vitest](https://vitest.dev) test runner, use the following command:

```bash
ng test
```

## Running end-to-end tests

For end-to-end (e2e) testing, run:

```bash
ng e2e
```

Angular CLI does not come with an end-to-end testing framework by default. You can choose one that suits your needs.

## Additional Resources

For more information on using the Angular CLI, including detailed command references, visit the [Angular CLI Overview and Command Reference](https://angular.dev) page.
