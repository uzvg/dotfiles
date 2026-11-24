---
name: TiddlyWiki 永久笔记
description: 在 WikiSpace（/home/uzvg/Documents/wikis/WikiSpace）写笔记时使用，尤其是把知识点、文章或问答总结为 PermanentNotes 永久笔记；涵盖 .tid 格式、字段与枚举、标签、时间戳、wikitext 写法与内部链接校验。
---

# WikiSpace 永久笔记

## 何时使用

- 用户要求把某知识点总结、整理、归档成笔记，写入 WikiSpace。
- 新建、改写 PermanentNotes，或给它补标签、补链接。
- 不适用：Journal、FleetingNotes、ProjectNotes 等日常记录，图片，插件与系统 tiddler。

## 仓库

默认 `/home/uzvg/Documents/wikis/WikiSpace`，笔记在 `tiddlers/`；用户给了别的路径就用给的。

一条笔记 = 一个 `.tid` 文件，文件名即 `title`：`:` 和 `/` 写成 `_`，`$` 保留（`$:/a/b` → `$__a_b.tid`）。以 `$__` 开头的是系统 tiddler，不要动。

## 流程

1. **查重**：`ls tiddlers | grep -F '<关键词>'`，再 `grep -l '^title: .*<关键词>' tiddlers/*.tid`。同名笔记已存在就先问是改写还是另起标题，不要造重名。
2. **定标题**：一句话说清一个观点，不加日期（只有 LiteratureNotes 才带 `(时间戳)`）。
3. **找链接**：先确认目标标题真实存在（`grep -h '^title:' tiddlers/*.tid`），只链接存在的笔记；外部资源写 `[[显示文本|https://...]]`。
4. **写文件**：`tiddlers/<标题>.tid`，字段按字母序，UTF-8 无 BOM，空行后接正文。
5. **校验**：`python3 ~/.config/opencode/skills/tiddlywiki-permanent-notes/scripts/check_note.py "<文件>"`。
6. **汇报**：文件路径、新建了哪些链接、文件尚未提交。不要自动 `git add` / `commit` / `push`。

## 字段模板

```
created: <17位时间戳>
creator: uzvg
description: <一句话，供检索和列表展示>
modified: <17位时间戳>
modifier: uzvg
progress: Completed
rating: Plain
tags: PermanentNotes <主题标签>
title: <标题>
type: text/vnd.tiddlywiki
visibility: Public
```

- 时间戳用 `date +%Y%m%d%H%M%S%3N`；首次写入时 `created` 与 `modified` 相同。
- 可选字段：`source: <衍生自哪条笔记的标题>`、`cover: <图片文件名>`。
- 整篇由 AI 生成时，默认**不加** `AI-Generated`，用户要求标注时再加。
- 主题标签优先复用仓库已有词表（`Git`、`Python`、`zsh`、`tiddlywiki` 等），不要自造近义词。

枚举的常用值（改动前先 `grep -h '^<字段>:' tiddlers/*.tid | sort | uniq -c` 复核，仓库里也有历史遗留值）：

| 字段 | 常用值 |
|---|---|
| `progress` | `Pending` `Building` `Completed` `Paused` `Archived` |
| `rating` | `Plain` `Valuable` `Personal` `Promising` `Doubtful` |
| `visibility` | `Public`（默认） `Private`（不进公开构建） |

## 正文

- 中文，WikiText（不是 Markdown），`type: text/vnd.tiddlywiki`。
- 分节 `!! 标题`、`!!! 小标题`；强调 `''粗体''`；代码块带语言；行内代码用反引号。
- 表格首行写 `|tc-max-width|k`，下一行写 `|!表头|!表头|`。
- 内部链接 `[[显示文本|目标标题]]`；显示文本与标题相同时直接 `[[目标标题]]`。
- 一条笔记只讲一个观点；开头先给结论，再展开；能删的句子就删。

## 不要

- 改 `$__*`、`*.meta`、`$:/Storage/`、`$:/config/` 这些系统 tiddler。
- 用 Markdown 语法（`##`、`**粗体**`、`[文字](url)`）——这条笔记里不生效。
- 为了凑链接而链到不存在的 tiddler，或顺手把用户其他未提交改动一起提交。
- 自动跑 `pnpm build-site`；需要预览时提示用户执行 `pnpm start`（端口 9191）。

可参考的现成范例：`tiddlers/Zsh 数组切片的两种用法.tid`、`tiddlers/git worktree 的使用场景与工作流程.tid`。
