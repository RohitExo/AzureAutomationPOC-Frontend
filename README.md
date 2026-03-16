🚀 Employee Management System: End-to-End Azure Automation POC
https://img.shields.io/badge/.NET-8.0-blue
https://img.shields.io/badge/Angular-17+-red
https://img.shields.io/badge/Azure-Cloud-blue
https://img.shields.io/badge/GitHub-Actions-green
This repository contains a full-stack Employee Management System built with .NET 8 and Angular 17+.
It serves as the functional layer for a Zero-Trust Azure deployment framework, leveraging OIDC, Private Networking, and Bicep-driven IaC.

🏗️ System Architecture
- Frontend: Angular SPA hosted on Azure App Service
- Backend: .NET Core Web API hosted on Azure App Service
- Database: Azure SQL Managed Instance (secured via Private Endpoints)
- Identity: Microsoft Entra ID with OIDC for GitHub Actions deployment

🖥️ Backend (.NET Core API)
Handles business logic and secure data persistence for employee records.
Key Features
- Clean Architecture: Controllers, Services, Repository patterns
- Entity Framework Core: Code-First with automated migrations via GitHub Actions (DACPAC)
- Security: Azure Key Vault integration (no local secrets)
- API Documentation: Swagger/OpenAPI
Tech Stack
- .NET 8.0 SDK
- EF Core (SQL Server Provider)
- AutoMapper
Local Setup
cd src/Backend
# Update appsettings.json with your local SQL connection string
dotnet ef database update
dotnet run



🎨 Frontend (Angular SPA)
A reactive dashboard for HR administrators to manage employee lifecycles.
Key Features
- CRUD Operations: Employee lifecycle management
- State Management: Services + RxJS Observables
- Environment Parity: Local, Dev, Prod via CI/CD pipeline
- Styling: Bootstrap 5 / Angular Material
Tech Stack
- Angular 17+
- TypeScript
- RxJS & HttpClient
Local Setup
cd src/Frontend
npm install
# Update environment.ts with local API URL
ng serve



🛠️ DevOps & Automation
This project doubles as a deployment framework.
1. Infrastructure as Code (Bicep)
Located in /infra, automates:
- VNet & Subnets (Web vs. Data Tier)
- App Service Plans (SKU optimization)
- NSG Rules (restrict SQL access to App Service subnet only)
2. GitHub Actions CI/CD (.github/workflows)
- Build Stage: Compiles .NET + Angular artifacts
- Security Stage: Azure OIDC authentication (Federated Credentials)
- Deploy Stage:
- Applies Bicep templates (idempotent)
- Deploys SQL schema changes
- Pushes Frontend/Backend code to Azure App Services

📈 Performance & Monitoring
- Application Insights: MTTR tracking & SQL bottleneck detection
- Health Checks: Custom .NET endpoints to validate DB connectivity before routing traffic

👨‍💻 Author
Rohit Budhe
Purpose: Proof of Concept for Secure, Automated Azure Microservices
