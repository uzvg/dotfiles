始终使用简体中文回复。除非用户明确要求使用其他语言，否则一律用中文作答（包括代码注释、解释说明）。

使用 `/init` 或任何方式生成 `AGENTS.md` 时，内容默认全部使用简体中文：标题、正文、列表和说明均用中文，仅保留代码、命令、路径、标识符、UI 字符串等必要的英文原文。除非用户明确要求使用其他语言。

## 配置文件

修改 `$HOME` 下的配置文件前，先加载 `chezmoi` skill 并按其流程判断。

## Git 分支策略

开始修改代码前先判断任务类型：

- **feature**（新功能、新增模块或依赖、跨多个文件的较大改动、较大重构）：必须先基于最新 main/master 创建分支，再改代码。
  - 有远端：`git fetch origin && git switch -c feat/<简短英文名> origin/main`
  - 无远端：`git switch -c feat/<简短英文名> main`
  - 命名用英文 kebab-case；修复用 `fix/`，重构用 `refactor/`。
- **小改动**（typo、注释、格式、chore、fixup、revert、单文件小修补）：可以直接在 main/master 上做，不必建分支。
- 拿不准时按 feature 处理，或先问用户。
- 建分支前先 `git status --short`；有未提交改动时先问用户，不要丢弃或覆盖任何改动。
- 已经在 `feat/*`、`fix/*` 等分支上时，不要重复建分支。
- 不自动 merge、不自动 push，除非用户明确要求。
