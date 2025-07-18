# 🎯 Practical Neovim Flutter Session

## Let's Start Your First Neovim Flutter Session!

### Step 1: Launch Neovim
```bash
cd /mnt/Variety/Flutter_Projects/Athkarix
nvim .
```

### Step 2: First Things to Try

1. **Open the Dashboard**
   - When you start Neovim, you'll see the Alpha dashboard
   - Press `f` to find files
   - Press `e` to create a new file
   - Press `r` to see recent files

2. **Navigate to Main File**
   - Press `Space` + `f` + `f` (your leader key + find files)
   - Type `main.dart` and press Enter
   - You're now in your main Flutter file!

### Step 3: Practice Basic Navigation

**In main.dart:**
1. **Move around:**
   - `j` - Move down
   - `k` - Move up
   - `h` - Move left
   - `l` - Move right
   - `w` - Jump to next word
   - `b` - Jump to previous word

2. **Jump to specific lines:**
   - `gg` - Go to top of file
   - `G` - Go to bottom of file
   - `12G` - Go to line 12

3. **Jump to matching brackets:**
   - Place cursor on `{` or `(` and press `%`

### Step 4: File Explorer Practice

1. **Open file explorer:**
   - Press `Space` + `e`
   - Navigate with `j`/`k`
   - Press `Enter` to open files/folders
   - Press `a` to create new files
   - Press `d` to delete files

2. **Navigate your project structure:**
   ```
   lib/
   ├── main.dart (your app entry)
   ├── view/
   │   ├── pages/ (your screens)
   │   └── widget/ (your widgets)
   ├── controller/ (your controllers)
   └── core/
       └── data/
           ├── model/
           └── service/
   ```

### Step 5: Flutter Development Workflow

1. **Open a terminal:**
   - Press `Space` + `t` + `f` (floating terminal)
   - Run: `flutter pub get`
   - Run: `flutter doctor`

2. **Start Flutter development:**
   - In Neovim: `Space` + `F` + `r` (Flutter run)
   - Or in terminal: `flutter run`

3. **Edit code and hot reload:**
   - Make a change to any Dart file
   - Save with `Ctrl + s`
   - Hot reload with `Space` + `F` + `R`

### Step 6: Code Navigation Practice

1. **Open a controller file:**
   - `Space` + `f` + `f`
   - Type `home_controller.dart`
   - Press Enter

2. **Practice LSP features:**
   - Place cursor on any function/class
   - Press `gd` - Go to definition
   - Press `gr` - Go to references
   - Press `K` - Show hover documentation

### Step 7: Search and Find

1. **Search in current file:**
   - Press `/` and type search term
   - Press `n` for next match
   - Press `N` for previous match

2. **Search across project:**
   - Press `Space` + `f` + `s`
   - Type your search term
   - Navigate results with `j`/`k`

### Step 8: Editing Practice

1. **Enter insert mode:**
   - `i` - Insert before cursor
   - `a` - Insert after cursor
   - `o` - New line below
   - `O` - New line above

2. **Exit insert mode:**
   - Press `jk` (your custom shortcut)
   - Or press `Esc`

3. **Visual mode:**
   - Press `v` to start visual mode
   - Select text with `j`/`k`/`h`/`l`
   - Press `y` to copy
   - Press `d` to delete

### Step 9: Flutter-Specific Features

1. **Flutter outline:**
   - Press `Space` + `F` + `o`
   - See widget tree structure

2. **Flutter devices:**
   - Press `Space` + `F` + `D`
   - See available devices

3. **Flutter emulators:**
   - Press `Space` + `F` + `E`
   - Launch emulators

### Step 10: Buffer and Window Management

1. **Open multiple files:**
   - Open file explorer (`Space` + `e`)
   - Open several Dart files
   - Navigate between them with `Shift` + `h`/`l`

2. **Split windows:**
   - Press `Space` + `s` + `v` (vertical split)
   - Press `Space` + `s` + `h` (horizontal split)
   - Navigate between splits with `Ctrl` + `h`/`j`/`k`/`l`

### Step 11: Comments and Code Actions

1. **Toggle comments:**
   - Select line(s) in visual mode
   - Press `Space` + `/`

2. **Code actions:**
   - Place cursor on widget
   - Press `Space` + `c` + `a`
   - See available actions (wrap with widget, etc.)

### Step 12: Save and Quit

1. **Save file:**
   - `Ctrl + s`
   - Or `Space` + `w`

2. **Quit:**
   - `Space` + `q` (quit current buffer)
   - `Space` + `Q` (quit all)

## Common Mistakes to Avoid

1. **Don't use arrow keys** - Use `hjkl` instead
2. **Don't stay in insert mode** - Get comfortable switching modes
3. **Don't ignore the leader key** - `Space` is your friend
4. **Don't forget to save** - `Ctrl + s` frequently

## Your Flutter Development Flow

```
1. nvim .                  # Open project
2. Space + f + f          # Find files
3. Space + F + r          # Start Flutter run
4. Edit code              # Make changes
5. Ctrl + s               # Save
6. Space + F + R          # Hot reload
7. Repeat steps 4-6
```

## Daily Practice Routine

**Week 1: Basic Navigation**
- Focus on `hjkl` movement
- Practice entering/exiting insert mode
- Use `Space + f + f` for file navigation

**Week 2: File Management**
- Master file explorer (`Space + e`)
- Practice split windows
- Use telescope for searching

**Week 3: Flutter Features**
- Use Flutter commands
- Practice LSP features (`gd`, `gr`, `K`)
- Use code actions

**Week 4: Advanced Features**
- Master visual mode
- Use advanced search/replace
- Customize your config

## Tips for Success

1. **Start small** - Don't try to learn everything at once
2. **Practice daily** - Even 15 minutes helps
3. **Use the cheatsheet** - Keep it handy
4. **Be patient** - It takes time to build muscle memory
5. **Ask for help** - Use `:help` command

## Emergency Commands

If you get stuck:
- `Esc` - Get back to normal mode
- `:q!` - Quit without saving
- `u` - Undo last change
- `Ctrl + r` - Redo

## Next Session Goals

After this session, try to:
1. Navigate your Flutter project without using a mouse
2. Edit a simple widget using only keyboard
3. Use hot reload through Neovim
4. Search for text across multiple files

Remember: The goal is not to be perfect, but to build habits!

---

Good luck with your Neovim journey! 🚀
