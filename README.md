# dotfiles
 https://github.com/ridhwaans/dotfiles

![screenfetch_mac](images/screenfetch-mac.png)
![screenfetch_windows](images/screenfetch-windows.png)

## fresh installation
**Warning: Please back up your files before running setup**  
macOS
- **GET** [Ventura Update](https://support.apple.com/macos/upgrade)  
- **GET** Xcode Command Line Tools `xcode-select --install`

windows
- **GET** [Windows Subsystem for Linux (WSL2)](https://learn.microsoft.com/en-us/windows/wsl/install#update-to-wsl-2)  
- **GET** `Ubuntu 22.04 LTS (Jammy Jellyfish)` from the Microsoft Store
    - optional: upgrade to the interim release
    - [managing multiple linux distributions](https://learn.microsoft.com/en-us/windows/wsl/wsl-config#managing-multiple-linux-distributions)   

curl
```
bash -c "`curl -fsSL https://raw.github.com/ridhwaans/dotfiles/master/setup.sh`"
```
or, wget
```
bash -c "`wget -O - --no-check-certificate https://raw.githubusercontent.com/ridhwaans/dotfiles/master/setup.sh`"
```

## as a docker workspace
- **GET** [Docker Desktop](https://www.docker.com/products/docker-desktop/)  
- **GET** [VS Code Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)  

in VS Code, select `Dev Containers: Reopen in Container`, or  
`Dev Containers: Rebuild Without Cache and Reopen in Container`, or  

### manual build
build and run a container instance in background and interactive mode
```
docker build github.com/ridhwaans/dotfiles -t name:tag --progress=plain --no-cache
docker run -d -i -t <name:tag>
<or>
docker run --detach --interactive --tty <name:tag>
```
in VS Code, select `Dev Containers: Attach to Running Container...`  

## as a github codespace
see [Personalizing GitHub Codespaces for your account](https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-github-codespaces-for-your-account)

sf there are issues, see https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-personalization-for-codespaces