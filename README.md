# dot-net-docker
This repository publishes Docker containers to run .NET applications

## Docker Image

This repository provides a development-ready Docker image based on .NET SDK 8.0 with the following features:
- .NET SDK 8.0
- Entity Framework Core tools (dotnet-ef) version 8.0.10
- Hot reload enabled with `dotnet watch run`
- Exposed on port 8080

## Usage

### Using the Published Image

The Docker image is automatically built and published to GitHub Container Registry on each push to the main branch.

Pull the image:
```bash
docker pull ghcr.io/afaryab/dot-net-docker:latest
```

Run a .NET application by mounting your source code:
```bash
docker run -it --rm -v $(pwd):/app -p 8080:8080 ghcr.io/afaryab/dot-net-docker:latest
```

### Building Locally

Build the Docker image:
```bash
docker build -t dotnet-dev .
```

Run your .NET application:
```bash
docker run -it --rm -v $(pwd)/your-app:/app -p 8080:8080 dotnet-dev
```

## GitHub Workflow

The repository includes a GitHub Actions workflow that automatically:
- Builds the Docker image on push to main/master branches
- Publishes the image to GitHub Container Registry (ghcr.io)
- Tags images with branch name, commit SHA, and 'latest' for the default branch
- Builds (but doesn't push) images on pull requests for validation

## Notes

- This image is designed for development use with hot reload enabled
- Mount your .NET application source code to `/app` to use this container
- The container runs `dotnet watch run` by default
- For production use, consider creating a production Dockerfile with compiled binaries

