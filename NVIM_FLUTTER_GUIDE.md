# 🚀 Neovim Flutter Development Guide

## Table of Contents
1. [Basic Navigation](#basic-navigation)
2. [File Management](#file-management)
3. [Flutter-Specific Features](#flutter-specific-features)
4. [Code Editing](#code-editing)
5. [Search and Replace](#search-and-replace)
6. [Git Integration](#git-integration)
7. [Terminal Integration](#terminal-integration)
8. [LSP Features](#lsp-features)
9. [Debugging](#debugging)
10. [Essential Tips](#essential-tips)

---

## Basic Navigation

### Vim Motions (The Foundation)
- `h` `j` `k` `l` - Move left, down, up, right
- `w` `b` - Move word forward/backward
- `0` `$` - Move to beginning/end of line
- `gg` `G` - Move to beginning/end of file
- `{` `}` - Move paragraph up/down
- `%` - Jump to matching bracket/parenthesis

### Your Custom Keybindings
- `jk` - Exit insert mode (instead of ESC)
- `Space` - Your leader key
- `<C-h/j/k/l>` - Navigate between splits
- `<S-h/l>` - Navigate between buffers

---

## File Management

### File Explorer (NvimTree)
- `<leader>e` - Toggle file explorer
- `<leader>ef` - Find current file in explorer
- `<leader>ec` - Collapse all folders
- `<leader>er` - Refresh explorer

**Inside NvimTree:**
- `<Enter>` - Open file/folder
- `o` - Open file
- `a` - Create new file/folder
- `d` - Delete file/folder
- `r` - Rename file/folder
- `c` - Copy file/folder
- `p` - Paste file/folder
- `R` - Refresh
- `H` - Toggle hidden files
- `I` - Toggle git ignored files

### Fuzzy Finding (Telescope)
- `<leader>ff` - Find files in project
- `<leader>fr` - Find recent files
- `<leader>fs` - Find string/text in project
- `<leader>fc` - Find string under cursor
- `<leader>fb` - Find open buffers
- `<leader>fh` - Find help tags
- `<leader>fx` - Find diagnostics
- `<leader>fk` - Find keymaps

### Buffer Management
- `<S-h>` - Previous buffer
- `<S-l>` - Next buffer
- `<leader>bd` - Close buffer
- `<leader>bo` - Close other buffers
- `<leader>bp` - Pin buffer

---

## Flutter-Specific Features

### Flutter Commands
- `<leader>Fr` - Flutter Run
- `<leader>Fq` - Flutter Quit
- `<leader>FR` - Flutter Reload (Hot Reload)
- `<leader>FS` - Flutter Restart (Hot Restart)
- `<leader>FD` - Flutter Devices
- `<leader>FE` - Flutter Emulators
- `<leader>Fo` - Flutter Outline Toggle

### Flutter Development Workflow
1. **Start Development:**
   ```
   <leader>Fr  # Start Flutter run
   ```

2. **Make Changes:**
   - Edit your Dart files
   - Save with `<C-s>` or `<leader>w`

3. **Hot Reload:**
   ```
   <leader>FR  # Quick reload
   ```

4. **Hot Restart (if needed):**
   ```
   <leader>FS  # Full restart
   ```

### Flutter Widget Navigation
- `gd` - Go to definition
- `gi` - Go to implementation  
- `gr` - Go to references
- `K` - Hover documentation
- `<leader>ca` - Code actions (wrap with widget, etc.)

---

## Code Editing

### Insert Mode
- `i` - Insert before cursor
- `I` - Insert at beginning of line
- `a` - Insert after cursor
- `A` - Insert at end of line
- `o` - Open new line below
- `O` - Open new line above

### Visual Mode
- `v` - Character visual mode
- `V` - Line visual mode
- `<C-v>` - Block visual mode
- `J` - Move selected lines down
- `K` - Move selected lines up
- `<` `>` - Indent left/right (repeatable)

### Text Objects
- `diw` - Delete inner word
- `ciw` - Change inner word
- `di(` - Delete inside parentheses
- `da(` - Delete around parentheses
- `dit` - Delete inside tag
- `dat` - Delete around tag

### Auto-completion
- `<Tab>` - Accept completion
- `<C-n>` - Next completion
- `<C-p>` - Previous completion
- `<C-y>` - Confirm completion

### Comments
- `<leader>/` - Toggle line comment
- In visual mode: `<leader>/` - Toggle block comment

---

## Search and Replace

### Basic Search
- `/pattern` - Search forward
- `?pattern` - Search backward
- `n` - Next match
- `N` - Previous match
- `<leader>nh` - Clear highlights

### Advanced Search & Replace
- `:%s/old/new/g` - Replace all in file
- `:%s/old/new/gc` - Replace all with confirmation
- `:s/old/new/g` - Replace in current line

### Global Search (Telescope)
- `<leader>fs` - Live grep in project
- `<leader>fc` - Find word under cursor

---

## Git Integration

### Git Signs (in gutter)
- `]c` - Next git change
- `[c` - Previous git change
- `<leader>hp` - Preview hunk
- `<leader>hs` - Stage hunk
- `<leader>hu` - Undo hunk
- `<leader>hr` - Reset hunk

### Git Commands (Terminal)
- `<leader>tf` - Open terminal
- Then use: `git status`, `git add`, `git commit`, etc.

---

## Terminal Integration

### Terminal Management
- `<leader>tf` - Toggle floating terminal
- `<leader>th` - Toggle horizontal terminal
- `<leader>tv` - Toggle vertical terminal
- `<C-\>` - Quick terminal toggle

### Running Flutter Commands
```bash
# In terminal
flutter doctor
flutter clean
flutter pub get
flutter build apk
```

---

## LSP Features

### Navigation
- `gd` - Go to definition
- `gD` - Go to declaration  
- `gi` - Go to implementation
- `gr` - Go to references
- `K` - Hover documentation

### Code Actions
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `<leader>f` - Format document/selection

### Diagnostics
- `]d` - Next diagnostic
- `[d` - Previous diagnostic
- `gl` - Show diagnostic float
- `<leader>fx` - Show all diagnostics

---

## Debugging

### DAP (Debug Adapter Protocol)
- `<F5>` - Start/Continue debugging
- `<F10>` - Step over
- `<F11>` - Step into
- `<F12>` - Step out
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Clear breakpoints

---

## Essential Tips

### Modes
- **Normal Mode**: Navigation and commands (default)
- **Insert Mode**: Text editing (`i`, `a`, `o`)
- **Visual Mode**: Text selection (`v`, `V`, `<C-v>`)
- **Command Mode**: Vim commands (`:`)

### Saving and Quitting
- `<C-s>` - Save file (works in insert mode too)
- `<leader>w` - Save file
- `<leader>q` - Quit current buffer
- `<leader>Q` - Quit all
- `<leader>x` - Save and quit

### Window Management
- `<leader>sv` - Split vertically
- `<leader>sh` - Split horizontally
- `<leader>se` - Equal split sizes
- `<leader>sx` - Close current split

### Tab Management
- `<leader>to` - Open new tab
- `<leader>tx` - Close current tab
- `<leader>tn` - Next tab
- `<leader>tp` - Previous tab

### Productivity Shortcuts
- `<leader>e` - File explorer
- `<leader>ff` - Find files
- `<leader>fs` - Find text
- `<leader>Fr` - Flutter run
- `<leader>/` - Comment toggle

---

## Flutter Project Structure Navigation

### Common Patterns
1. **Main App Entry**: `lib/main.dart`
2. **Pages/Screens**: `lib/view/pages/`
3. **Widgets**: `lib/view/widget/`
4. **Controllers**: `lib/controller/`
5. **Models**: `lib/core/data/model/`
6. **Services**: `lib/core/data/service/`

### Quick Navigation Tips
- Use `<leader>ff` to quickly jump to any file
- Use `<leader>fs` to search for text across all files
- Use `gd` to jump to widget/function definitions
- Use `gr` to see all references to a symbol

---

## VS Code to Neovim Transition

### VS Code → Neovim Equivalents
- `Ctrl+P` → `<leader>ff` (Find files)
- `Ctrl+Shift+P` → `<leader>fc` (Find commands)
- `Ctrl+F` → `/` (Search in file)
- `Ctrl+Shift+F` → `<leader>fs` (Search in project)
- `F12` → `gd` (Go to definition)
- `Shift+F12` → `gr` (Find references)
- `Ctrl+Shift+O` → `<leader>fs` (Find symbols)
- `Ctrl+/` → `<leader>/` (Toggle comment)

### Getting Comfortable
1. **Start with file navigation**: Master `<leader>ff` and `<leader>fs`
2. **Learn basic movements**: `h`, `j`, `k`, `l`, `w`, `b`, `0`, `$`
3. **Practice inserting text**: `i`, `a`, `o`
4. **Use visual mode**: `v` for selection, then `y` (copy) or `d` (delete)
5. **Master the leader key**: Remember `<Space>` is your leader

---

## Next Steps

1. **Practice daily**: Use Neovim for your Flutter development
2. **Customize**: Modify `~/.config/nvim/init.lua` as needed
3. **Learn gradually**: Don't try to master everything at once
4. **Use help**: `:help <command>` for any vim command
5. **Join community**: Ask questions on Reddit r/neovim or GitHub

Remember: The power of Neovim comes from muscle memory. Give yourself 2-3 weeks of daily use to become comfortable!

---

## Quick Reference Card

### Most Important Commands
```
<Space>     Leader key
jk          Exit insert mode
<leader>ff  Find files
<leader>fs  Find text
<leader>e   File explorer
<leader>Fr  Flutter run
<leader>w   Save file
<leader>q   Quit
gd          Go to definition
<leader>ca  Code actions
<leader>/   Toggle comment
<C-s>       Save file
```

Happy coding with Neovim! 🚀
