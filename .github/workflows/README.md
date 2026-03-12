# CI/CD Setup

The workflow in `.github/workflows/deploy.yml` builds and deploys the app container to Azure App Service on every push to `main`.

## Prerequisites

1. **Create a Microsoft Entra ID app registration** with federated credentials for GitHub Actions OIDC ([docs](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure-openid-connect)).
2. Grant the service principal **AcrPush** on the container registry and **Contributor** on the App Service.

## GitHub Secrets

Set these under **Settings → Secrets and variables → Actions → Secrets**:

| Secret | Value |
|---|---|
| `AZURE_CLIENT_ID` | App registration (service principal) client ID |
| `AZURE_TENANT_ID` | Microsoft Entra tenant ID |
| `AZURE_SUBSCRIPTION_ID` | Azure subscription ID |

## GitHub Variables

Set these under **Settings → Secrets and variables → Actions → Variables**:

| Variable | Value |
|---|---|
| `ACR_NAME` | Container registry name (e.g. `crdev1e894c`) |
| `APP_SERVICE_NAME` | App Service name (e.g. `app-dev-1e894c`) |
