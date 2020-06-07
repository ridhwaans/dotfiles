# dotfiles
 https://github.com/ridhwaans/dotfiles

![screenfetch_mac](https://github.com/ridhwaans/dotfiles/raw/master/media/screenfetch-mac.png)
![screenfetch_windows](https://github.com/ridhwaans/dotfiles/raw/master/media/screenfetch-windows.png)

## prerequisites
macOS
- **GET** Catalina Update `https://www.apple.com/macos/how-to-upgrade/`
- **GET** Xcode Command Line Tools `xcode-select --install`

windowsOS
- **GET** Windows Subsystem for Linux `https://docs.microsoft.com/en-us/windows/wsl/install-win10#update-to-wsl-2`
- **GET** `Ubuntu 20.04 LTS (Focal Fossa)` from the Microsoft Store

[Adding a new SSH key to your GitHub account](https://help.github.com/en/articles/adding-a-new-ssh-key-to-your-github-account)  
[Managing multiple Linux Distributions](https://docs.microsoft.com/en-us/windows/wsl/wsl-config#managing-multiple-linux-distributions)

## installation
git
```sh
cd ~
mkdir Source
git clone git@github.com:ridhwaans/dotfiles.git
cd dotfiles
./setup.sh
```
or, curl
```sh
bash -c "`curl -fsSL https://raw.github.com/ridhwaans/dotfiles/master/remote-setup.sh`"
```
or, wget
```sh
bash -c "`wget -O - --no-check-certificate https://raw.githubusercontent.com/ridhwaans/dotfiles/master/remote-setup.sh`"
```
Windows directory,
- `ln -s /mnt/c/Users/<USERNAME>/dotfiles ~`  
- `ln -s /mnt/c/Users/<USERNAME>/Source ~`  
- pin `C:\Users\<USERNAME>\dotfiles` to Quick Access  
- pin `C:\Users\<USERNAME>\Source` to Quick Access  

not a Windows directory,
- pin `\\wsl$\Ubuntu\home\<USERNAME>\dotfiles` to Quick Access  
- pin `\\wsl$\Ubuntu\home\<USERNAME>\Source` to Quick Access  
- pin `~/dotfiles`, `~/Source` to Favorites  

## todo
1. color schemes for
    - terminal emulator (iterm, hyper),
    - shell (zsh),
    - editor (vim, sublimetext),
    - promptline (zsh, vim)
2. notion, datagrip, vscode
