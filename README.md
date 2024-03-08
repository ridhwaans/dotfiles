# dotfiles
 https://github.com/ridhwaans/dotfiles

macOS
- **GET** [Sonoma Update](https://support.apple.com/macos/upgrade)  
- **GET** Xcode Command Line Tools `xcode-select --install`

windows
- **GET** [Windows Subsystem for Linux (WSL2)](https://learn.microsoft.com/en-us/windows/wsl/install#update-to-wsl-2)  
- **GET** `Ubuntu 22.04 LTS (Jammy Jellyfish)` from the Microsoft Store
    - optional: upgrade to the interim release
    - [managing multiple linux distributions](https://learn.microsoft.com/en-us/windows/wsl/wsl-config#managing-multiple-linux-distributions)   

- **GET** [Docker Desktop](https://www.docker.com/products/docker-desktop/)  
- **GET** [VS Code Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)  
 
## development

| development image                                                                   | supported-features                                                                                       | 
|-------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|
| [javascript-node:20](https://hub.docker.com/_/microsoft-devcontainers-javascript-node) | [docker-in-docker](https://github.com/devcontainers/features/pkgs/container/features%2Fdocker-in-docker) |

in VS Code, select `Dev Containers: Reopen in Container`, or  
`Dev Containers: Rebuild Without Cache and Reopen in Container` 

## release
 
| runner image                                     |
|--------------------------------------------------|
| [ubuntu-22.04](https://github.com/actions/runner-images/blob/main/images/ubuntu/Ubuntu2204-Readme.md) |
