# dotfiles
 https://github.com/ridhwaans/dotfiles

![screenfetch_mac](https://github.com/ridhwaans/dotfiles/raw/master/images/screenfetch_mac.png)
![screenfetch_windows](https://github.com/ridhwaans/dotfiles/raw/master/images/screenfetch_windows.png)

## prerequisites
macOS
- **GET** High Sierra Update `https://www.apple.com/ca/macos/how-to-upgrade/`
- **GET** Xcode Command Line Tools `xcode-select --install`

windowsOS
- **GET** Windows 10 Creators Update `https://support.microsoft.com/en-ca/help/4028685/windows-10-get-the-fall-creators-update`
- **GET** Windows Subsystem for Linux `https://docs.microsoft.com/en-us/windows/wsl/install-win10`
- **GET** ubuntuOS `Ubuntu 17.10 (Artful Aardvark)`

## installation
git
```sh
git clone git@github.com:ridhwaans/dotfiles.git ~/dotfiles
cd ~/dotfiles
sh setup.sh
```
or, curl
```sh
sh -c "`curl -fsSL https://raw.github.com/ridhwaans/dotfiles/master/remote-setup.sh`"
```
or, wget
```sh
sh -c "`wget -O - --no-check-certificate https://raw.githubusercontent.com/ridhwaans/dotfiles/master/remote-setup.sh`"
```

## todo
1. unify and automate setting color schemes for
    - terminal emulator (iterm, hyperterm), 
    - shell (zsh),
    - editor (vim),
    - promptline (zsh, vim)
