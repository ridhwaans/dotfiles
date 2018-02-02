# dotfiles
 https://github.com/ridhwaans/dotfiles

![screenfetch_mac](https://github/ridhwaans/dotfiles/raw/master/images/screenfetch_mac.png)
![screenfetch_windows](https://github.com/ridhwaans/dotfiles/raw/master/images/screenfetch_windows.png)

## prerequisites
macOS
- **GET** Xcode Command Line Tools `xcode-select --install`
- **GET** Latest JDK `java -version`
windowsOS
- **GET** Windows Subsystem for Linux `https://docs.microsoft.com/en-us/windows/wsl/install-win10`

## installation
git:
```sh
git clone git@github.com:ridhwaans/dotfiles.git ~/dotfiles
cd ~/dotfiles
sh setup.sh
```
or, curl:
```sh
sh -c "`curl -fsSL https://raw.github.com/ridhwaans/dotfiles/master/remote-setup.sh`"
```
or, wget:
```sh
sh -c "`wget -O - --no-check-certificate https://raw.githubusercontent.com/ridhwaans/dotfiles/master/remote-setup.sh`"
```

## todo
1. unify and automate setting color schemes for
- terminal emulator (iterm, hyperterm), 
- shell (zsh),
- editor (vim),
- promptline (zsh, vim)
