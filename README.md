# dotfiles
 https://github.com/ridhwaans/dotfiles

## install
macOS
- **GET** [Sonoma Update](https://support.apple.com/macos/upgrade)  
- **GET** Xcode Command Line Tools `xcode-select --install`

windows
- **GET** [Windows Subsystem for Linux (WSL2)](https://learn.microsoft.com/en-us/windows/wsl/install#update-to-wsl-2)  
- **GET** `Ubuntu 22.04 LTS (Jammy Jellyfish)` from the Microsoft Store
    - optional: upgrade to the interim release
    - [managing multiple linux distributions](https://learn.microsoft.com/en-us/windows/wsl/wsl-config#managing-multiple-linux-distributions)   

curl
```
bash -c "`curl -fsSL https://raw.github.com/ridhwaans/dotfiles/master/install.sh`"
```
or, wget
```
bash -c "`wget -O - --no-check-certificate https://raw.githubusercontent.com/ridhwaans/dotfiles/master/install.sh`"
```

## as a docker workspace
- **GET** [Docker Desktop](https://www.docker.com/products/docker-desktop/)  
- **GET** [VS Code Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)  

in VS Code, select `Dev Containers: Reopen in Container`, or  
`Dev Containers: Rebuild Without Cache and Reopen in Container`  

## as a github codespace
[Personalizing GitHub Codespaces for your account](https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-github-codespaces-for-your-account)

[Troubleshooting personalization options for GitHub Codespaces](https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-personalization-for-codespaces)

## see also
https://github.com/ridhwaans/devcontainer-features
