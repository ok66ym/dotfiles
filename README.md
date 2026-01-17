# 🍎Install chezmoi(macOS)
[Install chezmoi](https://www.chezmoi.io/install/) with Homebrew.
(need to have Homebrew installed)
```sh
brew install chezmoi
```
# ⚙️chezmoi setup
place repo under chezmoi management
```
chezmoi init https://github.com/ok66ym/dotfiles.git
```

# 🚀apply dotfiles
Extract dotfile with verbose output

```sh
chezmoi apply
```
## 🛠️Debug
Output details when run chezmoi apply
```sh
chezmoi apply -v --debug
```

# apply dotfiles
serup dotfiles and install tools
```sh
sh run_once_setup.sh
```
