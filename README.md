# dotfiles
macOS environment https://github.com/ridhwaans/dotfiles

![screenfetch](https://github.com/ridhwaans/dotfiles/raw/master/images/screenfetch.png)

## prerequisites
- **GET** Xcode Command Line Tools `xcode-select --install`
- **GET** Latest JDK `java -version`

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
- terminal emulator (`.itermcolors`), 
- shell (`.zsh-theme`),
- editor (`.vim`)
- promptline (`zsh`, `vim`)