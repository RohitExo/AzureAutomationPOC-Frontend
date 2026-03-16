🚀 Employee Management System: End-to-End Azure Automation POC
This repository contains a full-stack Employee Management System built with .NET 8 and Angular 17+. This project serves as the functional layer for a "Zero-Trust" Azure deployment framework, utilizing OIDC, Private Networking, and Bicep-driven IaC.
🏗️ System Architecture
Frontend: Angular (SPA) hosted on Azure App Service.
Backend: .NET Core Web API (RESTful) hosted on Azure App Service.
Database: Azure SQL Managed Instance (shielded via Private Endpoints).
Identity: Microsoft Entra ID with OIDC for GitHub Actions deployment.
🖥️ Backend (.NET Core API)
The backend handles the business logic and secure data persistence for employee records.
Key Features
Clean Architecture: Separation of Concerns using Controllers, Services, and Repository patterns.
Entity Framework Core: Code-First approach with automated migrations via GitHub Actions (DACPAC).
Security: Integrated with Azure Key Vault for connection string management (no local secrets).
API Documentation: Swagger/OpenAPI integration for easy testing.
Tech Stack
.NET 8.0 SDK
EF Core (SQL Server Provider)
AutoMapper (for DTO mapping)
Local Setup
Navigate to /src/Backend.
Update appsettings.json with your local SQL connection string.
Run migrations: dotnet ef database update.
Start the API: dotnet run.
🎨 Frontend (Angular SPA)
A reactive dashboard designed for HR administrators to manage employee lifecycles.
Key Features
CRUD Operations: Create, Read, Update, and Delete employees with real-time validation.
State Management: Managed via Services and RxJS Observables.
Environment Parity: Uses environment.ts files to switch between Local, Dev, and Prod API endpoints automatically via the CI/CD pipeline.
Styling: Responsive UI using Bootstrap 5 / Angular Material.
Tech Stack
Angular 17+
TypeScript
RxJS & HttpClient
Local Setup
Navigate to /src/Frontend.
Install dependencies: npm install.
Ensure the Backend API is running and update environment.ts with the local URL.
Serve the app: ng serve.
🛠️ DevOps & Automation (The "Deep-Dive" Layer)
As detailed in the Presentation Script, this project is not just "code"—it's a deployment framework.
1. Infrastructure as Code (Bicep)
Located in /infra, the Bicep modules automate:
VNet & Subnets: (Web Tier vs. Data Tier).
App Service Plans: SKU right-sizing for cost optimization.
NSG Rules: Restricting SQL access to the App Service subnet only.
2. GitHub Actions CI/CD (.github/workflows)
Build Stage: Compiles .NET code and builds Angular production artifacts.
Security Stage: Authenticates to Azure via OIDC (Federated Credentials).
Deploy Stage:
Applies Bicep templates (Idempotent).
Deploys SQL Schema changes.
Pushes Frontend/Backend code to Azure App Services.
📈 Performance & Monitoring
Application Insights: Integrated to track MTTR and identify SQL connection bottlenecks.
Health Checks: Custom endpoints in .NET to ensure the database is reachable before traffic routing.
Author: Rohit Budhe
Purpose: Proof of Concept for Secure, Automated Azure Microservices.
