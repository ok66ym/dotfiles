# 🍎Install chezmoi(macOS)
[Install chezmoi](https://www.chezmoi.io/install/) with Homebrew.
(need to have Homebrew installed)
```sh
brew install chezmoi
```
# ⚙️setup
place repo under chezmoi management
```
chezmoi init https://github.com/ok66ym/dotfiles.git
```

# 🚀apply dotfiles
Extract dotfile with verbose output

```sh
chezmoi apply -v
```
# 🛠️Debug
Output details when run chezmoi apply
```sh
chezmoi apply -v --debug
```
