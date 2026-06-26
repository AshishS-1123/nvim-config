# What this config contains?

1. Syntax highlighting for C/C++, Rust, Dart, Javascript/TypeScript.
2. Uses **neo-tree** to display files and folders.
3. Shows relative line numbers and absolute line numbers for each file. Use relative line numbers for commands, and absolute line numbers when debugging code.
4. Code folding for functions, classes, etc based on language.
5. Interactive breadcrumbs for each file to view different functions in file and move around them.
6. Git Gutters to see which lines changes for current file.
7. Display definition of function using `<Ctrl+k>`.
8. Open definition of function/variable using `<Ctrl+Click>`. If function is in same file, opens a preview window, otherwise opens a new tab.
9. Implement file search using `<Space-f>` and `<Space-F>` for global search.
10. Highlight **matching brackets**. If you place your cursor on a bracket, highlight its matching one.
11. Auto format brackets when typing code blocks.

# Setup Instructions

```bash
# Install neovim
sudo snap install nvim --classic

# Cleanup existing configs
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim

# Setup directories
mkdir -p ~/.config/nvim/lua/config ~/.config/nvim/lua/plugins
cd ~/.config/nvim
```

