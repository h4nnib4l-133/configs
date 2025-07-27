### Nvim Configs

# Neovim Keymap Reference

> Complete keymap reference for your Neovim configuration  
> **Leader Key**: `<Space>` (spacebar)  
> **Features**: Python development, Git workflow, inline markdown rendering, 135+ optimized keymaps

## Table of Contents

- [Basic & Diagnostic](#basic--diagnostic)
- [Search & Navigation](#search--navigation-telescope)
- [Harpoon](#harpoon-quick-file-navigation)
- [LSP](#lsp-language-server)
- [Debugging](#debugging-dap)
- [Git](#git-gitsigns)
- [Terminal](#terminal-toggleterm)
- [Formatting](#formatting-conform)
- [Markdown](#markdown)
- [File Explorer](#file-explorer-neotree)
- [Folding](#folding-ufo)
- [Sessions](#sessions-persistence)
- [Text Objects & Movement](#text-objects--movement-treesitter)
- [Editing](#editing)
- [Completion](#completion-nvim-cmp)
- [LeetCode](#leetcode)
- [System Commands](#system-commands)
- [Which-Key Groups](#which-key-groups)

---

## Basic & Diagnostic

| Keymap      | Description                       |
| ----------- | --------------------------------- |
| `<Esc>`     | Clear search highlights           |
| `[d`        | Go to previous diagnostic message |
| `]d`        | Go to next diagnostic message     |
| `<leader>e` | Show diagnostic error messages    |
| `<leader>q` | Open diagnostic quickfix list     |

## Search & Navigation (Telescope)

| Keymap             | Description                            |
| ------------------ | -------------------------------------- |
| `<leader>sf`       | **[S]earch [F]iles**                   |
| `<leader>sg`       | **[S]earch by [G]rep**                 |
| `<leader>sw`       | **[S]earch current [W]ord**            |
| `<leader>sr`       | [S]earch [R]esume                      |
| `<leader>s.`       | Search Recent Files                    |
| `<leader><leader>` | Find existing buffers                  |
| `<leader>sh`       | [S]earch [H]elp                        |
| `<leader>sm`       | [S]earch [M]an pages                   |
| `<leader>sk`       | **[S]earch [K]eymaps**                 |
| `<leader>sK`       | [S]earch All [K]eymaps (comprehensive) |
| `<leader>sn`       | [S]earch [N]eovim config files         |
| `<leader>ss`       | [S]earch [S]elect Telescope            |
| `<leader>sd`       | [S]earch [D]iagnostics                 |
| `<leader>sld`      | [S]earch [L]ocal [D]iagnostics         |
| `<leader>sgf`      | [S]earch [G]it [F]iles                 |
| `<leader>sgc`      | [S]earch [G]it [C]ommits               |
| `<leader>sgb`      | [S]earch [G]it [B]ranches              |
| `<leader>sgs`      | [S]earch [G]it [S]tatus                |
| `<leader>sc`       | [S]earch [C]ommands                    |
| `<leader>sco`      | [S]earch [C]ommand hist[O]ry           |
| `<leader>sj`       | [S]earch [J]umplist                    |
| `<leader>sl`       | [S]earch [L]ocation list               |
| `<leader>sq`       | [S]earch [Q]uickfix                    |
| `<leader>sr`       | [S]earch [R]egisters                   |
| `<leader>st`       | [S]earch [T]ags                        |
| `<leader>sp`       | [S]earch [P]lugin files                |
| `<leader>/`        | Fuzzily search in current buffer       |
| `<leader>s/`       | [S]earch [/] in Open Files             |
| `<leader>se`       | [S]earch by [E]xtension                |

## Harpoon (Quick File Navigation)

| Keymap       | Description                              |
| ------------ | ---------------------------------------- |
| `<leader>a`  | **Add file to Harpoon**                  |
| `<C-e>`      | **Toggle Harpoon menu**                  |
| `<C-h>`      | Harpoon file 1                           |
| `<C-t>`      | Harpoon file 2                           |
| `<C-n>`      | Harpoon file 3                           |
| `<C-s>`      | Harpoon file 4                           |
| `<C-S-P>`    | Previous Harpoon file                    |
| `<C-S-N>`    | Next Harpoon file                        |
| `<leader>sh` | [S]earch [H]arpoon files (via Telescope) |

## LSP (Language Server)

| Keymap       | Description                   |
| ------------ | ----------------------------- |
| `gd`         | **[G]oto [D]efinition**       |
| `gr`         | **[G]oto [R]eferences**       |
| `gI`         | [G]oto [I]mplementation       |
| `<leader>D`  | Type [D]efinition             |
| `<leader>ds` | [D]ocument [S]ymbols          |
| `<leader>ws` | [W]orkspace [S]ymbols         |
| `<leader>rn` | **[R]e[n]ame**                |
| `<leader>ca` | **[C]ode [A]ction**           |
| `K`          | **Hover Documentation**       |
| `gD`         | [G]oto [D]eclaration          |
| `<leader>oi` | [O]rganize [I]mports (Python) |

## Debugging (DAP)

| Keymap       | Description                       |
| ------------ | --------------------------------- |
| `<F5>`       | **Debug: Start/Continue**         |
| `<F1>`       | Debug: Step Into                  |
| `<F2>`       | Debug: Step Over                  |
| `<F3>`       | Debug: Step Out                   |
| `<F7>`       | Debug: Toggle UI                  |
| `<leader>b`  | **Debug: Toggle Breakpoint**      |
| `<leader>B`  | Debug: Set Conditional Breakpoint |
| `<leader>lp` | Debug: Set Log Point              |
| `<leader>dr` | Debug: Open REPL                  |
| `<leader>dl` | Debug: Run Last                   |
| `<leader>dn` | Debug: Test Method (Python)       |
| `<leader>df` | Debug: Test Class (Python)        |
| `<leader>ds` | Debug: Selection (visual mode)    |

## Git (Gitsigns)

| Keymap       | Description               |
| ------------ | ------------------------- |
| `]c`         | **Next git hunk**         |
| `[c`         | **Previous git hunk**     |
| `<leader>hs` | **Stage hunk**            |
| `<leader>hr` | Reset hunk                |
| `<leader>hS` | Stage buffer              |
| `<leader>hu` | Undo stage hunk           |
| `<leader>hR` | Reset buffer              |
| `<leader>hp` | **Preview hunk**          |
| `<leader>hb` | Blame line                |
| `<leader>tb` | Toggle line blame         |
| `<leader>hd` | Diff this                 |
| `<leader>hD` | Diff this ~               |
| `<leader>td` | Toggle deleted            |
| `ih`         | Select hunk (text object) |

## Terminal (ToggleTerm)

| Keymap       | Description            |
| ------------ | ---------------------- |
| `<C-\>`      | **Toggle terminal**    |
| `<leader>tp` | Toggle Python terminal |
| `<leader>tg` | Toggle Lazygit         |

### Terminal Mode Keymaps

| Keymap  | Description        |
| ------- | ------------------ |
| `<esc>` | Exit terminal mode |
| `jk`    | Exit terminal mode |
| `<C-h>` | Window left        |
| `<C-j>` | Window down        |
| `<C-k>` | Window up          |
| `<C-l>` | Window right       |
| `<C-w>` | Window commands    |

## Formatting (Conform)

| Keymap       | Description                    |
| ------------ | ------------------------------ |
| `<leader>f`  | **Format buffer**              |
| `<leader>F`  | Format selection (visual mode) |
| `<leader>fp` | Format Python (isort + black)  |
| `<leader>fl` | Format Lua (stylua)            |
| `<leader>fs` | Format Shell (shfmt)           |
| `<leader>fw` | Format Web files (prettier)    |

## Markdown

| Keymap       | Description                             |
| ------------ | --------------------------------------- |
| `<leader>mr` | **[M]arkdown [R]ender toggle (inline)** |
| `<leader>me` | [M]arkdown render [E]nable              |
| `<leader>md` | [M]arkdown render [D]isable             |

## File Explorer (NeoTree)

| Keymap | Description               |
| ------ | ------------------------- |
| `\`    | **Toggle NeoTree**        |
| `\\`   | Close NeoTree (from tree) |

## Folding (UFO)

| Keymap | Description         |
| ------ | ------------------- |
| `zR`   | **Open all folds**  |
| `zM`   | **Close all folds** |
| `zf`   | Create fold         |
| `za`   | Toggle fold         |
| `zo`   | Open fold           |
| `zc`   | Close fold          |

## Sessions (Persistence)

| Keymap       | Description                |
| ------------ | -------------------------- |
| `<leader>qs` | **Restore Session**        |
| `<leader>ql` | Restore Last Session       |
| `<leader>qd` | Don't Save Current Session |

## Text Objects & Movement (Treesitter)

### Text Objects

| Keymap      | Description             |
| ----------- | ----------------------- |
| `af` / `if` | Function outer/inner    |
| `ac` / `ic` | Class outer/inner       |
| `ai` / `ii` | Conditional outer/inner |
| `al` / `il` | Loop outer/inner        |
| `aa` / `ia` | Parameter outer/inner   |
| `a/` / `i/` | Comment outer/inner     |

### Navigation

| Keymap      | Description             |
| ----------- | ----------------------- |
| `]f` / `[f` | Next/previous function  |
| `]c` / `[c` | Next/previous class     |
| `]a` / `[a` | Next/previous parameter |

### Swapping

| Keymap       | Description                  |
| ------------ | ---------------------------- |
| `<leader>na` | Swap parameter with next     |
| `<leader>pa` | Swap parameter with previous |
| `<leader>nf` | Swap function with next      |
| `<leader>pf` | Swap function with previous  |

### Incremental Selection

| Keymap          | Description                         |
| --------------- | ----------------------------------- |
| `<C-space>`     | Incremental selection (init/expand) |
| `<C-s>`         | Scope incremental                   |
| `<C-backspace>` | Node decremental                    |

## Editing

### Comments (Comment.nvim)

| Keymap | Description                  |
| ------ | ---------------------------- |
| `gcc`  | **Toggle line comment**      |
| `gc`   | Toggle comment (with motion) |
| `gbc`  | Toggle block comment         |
| `gcA`  | Comment at end of line       |
| `gco`  | Comment below                |
| `gcO`  | Comment above                |

### Surround (nvim-surround)

| Keymap | Description                        |
| ------ | ---------------------------------- |
| `ys`   | **Add surround**                   |
| `ds`   | **Delete surround**                |
| `cs`   | **Change surround**                |
| `S`    | Surround selection (visual mode)   |
| `yss`  | Surround current line              |
| `yS`   | Surround on new lines              |
| `ySS`  | Surround current line on new lines |

## Completion (nvim-cmp)

### Insert Mode

| Keymap      | Description              |
| ----------- | ------------------------ |
| `<C-n>`     | Next completion          |
| `<C-p>`     | Previous completion      |
| `<C-b>`     | Scroll docs back         |
| `<C-f>`     | Scroll docs forward      |
| `<C-y>`     | **Accept completion**    |
| `<C-Space>` | Trigger completion       |
| `<C-l>`     | Jump forward in snippet  |
| `<C-h>`     | Jump backward in snippet |

## LeetCode

| Command     | Description         |
| ----------- | ------------------- |
| `:Leet`     | Open LeetCode menu  |
| `:LeetCode` | Alternative command |

## System Commands

| Command        | Description               |
| -------------- | ------------------------- |
| `:Lazy`        | Plugin manager            |
| `:Mason`       | LSP/tool installer        |
| `:checkhealth` | System health check       |
| `:LspInfo`     | LSP information           |
| `:TSUpdate`    | Update treesitter parsers |

## Which-Key Groups

The following prefixes will show which-key menus with available commands:

| Prefix       | Group             |
| ------------ | ----------------- |
| `<leader>b`  | Debug/Breakpoints |
| `<leader>c`  | Code              |
| `<leader>d`  | Document/Debug    |
| `<leader>f`  | Format            |
| `<leader>g`  | Git               |
| `<leader>h`  | Git Hunks         |
| `<leader>m`  | Markdown          |
| `<leader>q`  | Session           |
| `<leader>r`  | Rename            |
| `<leader>s`  | Search            |
| `<leader>sg` | Git Search        |
| `<leader>t`  | Terminal/Toggle   |
| `<leader>w`  | Workspace         |

---

## Quick Reference

### 🔥 Most Used

- **Files**: `<leader>sf` → `<leader>a` → `<C-e>`
- **Search**: `<leader>sg` → `<leader>sw` → `<leader>sr`
- **Git**: `]c`/`[c` → `<leader>hp` → `<leader>hs`
- **Code**: `gd` → `gr` → `<leader>ca` → `<leader>rn`
- **Debug**: `<F5>` → `<leader>b` → `<F2>`
- **Markdown**: `<leader>mr` → inline rendering toggle

### 💡 Memory Aids

- **`<leader>s*`** = Search operations
- **`<leader>h*`** = Git hunk operations
- **`<leader>m*`** = Markdown operations (inline rendering)
- **`<leader>t*`** = Terminal operations
- **`<leader>q*`** = Session (quit) operations

### 🆘 Help

- **Forgot a keymap?** → `<leader>sk`
- **All keymaps?** → `<leader>sK`
- **Which-key help?** → Press any `<leader>` prefix and wait
- **Markdown rendering?** → `<leader>mr` to toggle inline preview

**Total**: 135+ keymaps optimized for Python development and modern editing! 🚀
