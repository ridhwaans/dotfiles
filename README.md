# dotfiles
 https://github.com/ridhwaans/dotfiles

![screenfetch_mac](https://github.com/ridhwaans/dotfiles/raw/master/media/screenfetch-mac.png)
![screenfetch_windows](https://github.com/ridhwaans/dotfiles/raw/master/media/screenfetch-windows.png)

## prerequisites
macOS
- **GET** Mojave Update `https://www.apple.com/ca/macos/how-to-upgrade/`
- **GET** Xcode Command Line Tools `xcode-select --install`

windowsOS
- **GET** Windows 10 Creators Update `https://support.microsoft.com/en-ca/help/4028685/windows-10-get-the-fall-creators-update`
- **GET** Windows Subsystem for Linux `https://docs.microsoft.com/en-us/windows/wsl/install-win10`
- **GET** `Ubuntu 18.04 (Bionic Beaver)` from the Microsoft Store
- To remove legacy linux distributions, see `https://docs.microsoft.com/en-us/windows/wsl/wsl-config#managing-multiple-linux-distributions`

## installation
[Adding a new SSH key to your GitHub account](https://help.github.com/en/articles/adding-a-new-ssh-key-to-your-github-account)
git
```sh
git clone git@github.com:ridhwaans/dotfiles.git ~/dotfiles
cd ~/dotfiles
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

## todo
1. unify and automate setting color schemes for
    - terminal emulator (iterm, hyperterm), 
    - shell (zsh),
    - editor (vim),
    - promptline (zsh, vim)
