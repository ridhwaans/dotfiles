# dotfiles
 https://github.com/ridhwaans/dotfiles

![screenfetch_mac](https://github.com/ridhwaans/dotfiles/raw/master/media/screenfetch-mac.png)
![screenfetch_windows](https://github.com/ridhwaans/dotfiles/raw/master/media/screenfetch-windows.png)

## prerequisites
macOS
- **GET** Ventura Update `https://support.apple.com/macos/upgrade`
- **GET** Xcode Command Line Tools `xcode-select --install`

windowsOS
- **GET** Windows Subsystem for Linux (WSL2) `https://learn.microsoft.com/en-us/windows/wsl/install#update-to-wsl-2`
- **GET** `Ubuntu 22.04 LTS (Jammy Jellyfish)` from the Microsoft Store
    - optional: upgrade to the interim release

[Managing multiple Linux Distributions](https://learn.microsoft.com/en-us/windows/wsl/wsl-config#managing-multiple-linux-distributions)   
[Adding a new SSH key to your GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)   

## installation
**Warning: Please back up your terminal files before running installation**  
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

## links
[Roboto Mono for Powerline.ttf](https://github.com/powerline/fonts/blob/master/RobotoMono/Roboto%20Mono%20for%20Powerline.ttf)  
[gotham-contrib](https://github.com/whatyouhide/gotham-contrib)  
