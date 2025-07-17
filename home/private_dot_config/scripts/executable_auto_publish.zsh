#!/usr/bin/env zsh

# WikiSpace 公共版本构建和发布脚本
# 功能：
# 1. 切换到目标文件夹
# 2. 删除目标文件夹中的所有非必要内容
# 3. 导出需要发布的 tiddler 到目标文件夹
# 4. 设置目标 tiddler 的字段值
# 5. 生成最新版的公布文件
# 6. 只提交最新版本的文件

setopt ERR_EXIT          # 遇到错误立即退出
setopt NO_UNSET          # 使用未定义变量时报错
setopt PIPE_FAIL         # 管道中任何命令失败都返回非零
setopt EXTENDED_GLOB     # 启用扩展通配符
setopt NULL_GLOB         # 通配符无匹配时返回空列表而非错误

# ================================================================
# 配置变量
# ================================================================
typeset -r WIKISPACE_PATH="${HOME}/Documents/wikis/WikiSpace"
typeset -r PUBLIC_WIKISPACE_PATH="${HOME}/Documents/wikis/WikiSpace/output/public"
typeset -r SENSITIVE_WORDS_PATH="${HOME}/.config/zsh/wikispace_sensitive_words.zsh"
typeset -r OUTPUT_FILE="index.html"
typeset -r COMMIT_MESSAGE="latest version only"

# 必需的命令列表
# tiddlywiki git fd ripgrep
typeset -ra REQUIRED_COMMANDS=(tiddlywiki git fd rg)

# ================================================================
# 颜色输出函数（使用 zsh 的 print）
# ================================================================
print_info() {
    print -P "%F{blue}[INFO]%f $1"
}

print_success() {
    print -P "%F{green}[SUCCESS]%f $1"
}

print_error() {
    print -P "%F{red}[ERROR]%f $1" >&2
}

print_warning() {
    print -P "%F{yellow}[WARNING]%f $1"
}

# ================================================================
# 错误处理函数
# ================================================================
cleanup_on_error() {
    local exit_code=$?
    if (( exit_code != 0 )); then
        print_error "脚本执行失败，退出码: $exit_code"
        # 这里可以添加清理逻辑
    fi
    exit $exit_code
}

trap cleanup_on_error EXIT

# ================================================================
# 环境检查函数（使用 zsh 的 (( )) 和 ${+commands[cmd]} ）
# ================================================================
check_dependencies() {
    local -a missing_deps=()
    
    # 使用 zsh 的 commands 关联数组检查命令是否存在
    for cmd in $REQUIRED_COMMANDS; do
        if ! (( ${+commands[$cmd]} )); then
            missing_deps+=($cmd)
        fi
    done
    
    # 使用 zsh 的数组长度检查
    if (( ${#missing_deps} > 0 )); then
        print_error "缺少必需的依赖: ${(j: :)missing_deps}"
        print_error "请安装缺失的依赖后重试"
        exit 1
    fi
    
    print_success "依赖检查通过"
}

# ================================================================
# 路径和目录检查函数（使用 zsh 的路径测试）
# ================================================================
validate_paths() {
    # 使用 zsh 的路径测试操作符
    if [[ ! -d $PUBLIC_WIKISPACE_PATH ]]; then
        print_error "目标路径不存在: $PUBLIC_WIKISPACE_PATH"
        exit 1
    fi
    
    if [[ ! -f $PUBLIC_WIKISPACE_PATH/tiddlywiki.info ]]; then
        print_error "tiddlywiki.info 文件不存在于: $PUBLIC_WIKISPACE_PATH"
        exit 1
    fi
    
    # 检查是否在 git 仓库中
    if ! git -C $PUBLIC_WIKISPACE_PATH rev-parse --git-dir &>/dev/null; then
        print_error "目标目录不是一个 git 仓库: $PUBLIC_WIKISPACE_PATH"
        exit 1
    fi
    
    print_success "路径验证通过"
}

# ================================================================
# WikiSpace 字段设置函数（使用 zsh 的参数扩展）
# ================================================================
# tiddlywiki --setfield <filter> <fieldname> <templatetitle> <rendertype>
# 参数:
# $1 - filter: 筛选要修改的 tiddlers 的过滤器表达式
# $2 - fieldname: 要修改的字段名称（默认为 "text"）
# $3 - templatetitle: 用于 wikify 到指定字段的 tiddler 标题（如果为空，则删除该字段）
# $4 - rendertype: 渲染的文本类型（默认为 "text/plain"，也可使用 "text/html"）
#
wikispace_set_field() {
    local filter=${1:?"filter 参数不能为空"}
    local fieldname=${2:-text}
    local templatetitle=${3:-}
    local rendertype=${4:-text/plain}
    
    print_info "设置字段: filter='$filter', field='$fieldname', template='$templatetitle'"
    
    tiddlywiki $PUBLIC_WIKISPACE_PATH --setfield $filter $fieldname $templatetitle $rendertype >/dev/null || {
        print_error "设置字段失败"
        return 1
    }
}

# ================================================================
# Git 提交函数（只保留最新版本）
# ================================================================
# 出于安全考虑，为了避免含有敏感词汇的tiddler被保存在历史提交中，只保留最新版的提交
commit_latest_version_only() {
    print_info "开始 Git 操作：只保留最新版本..."
    
    # 使用 zsh 的命令替换和错误处理
    local current_branch
    current_branch=$(git symbolic-ref --short HEAD 2>/dev/null) || current_branch="HEAD"
    
    # 检查工作区是否干净
    # if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    if [[ -z $(git status --porcelain) ]]; then
        print_info "公开版wikispace没有任何修改，无需提交，即将退出"
        exit
    fi
    
    # 切换到主分支
    git checkout main 2>/dev/null || {
        print_warning "无法切换到 main 分支，尝试创建..."
        git checkout -b main
    }
    
    # 创建临时 orphan 分支
    git checkout --orphan temp-branch || {
        print_error "创建临时分支失败"
        return 1
    }
    
    # 添加所有文件并提交
    git add .
    git commit -m $COMMIT_MESSAGE >/dev/null || {
        print_error "提交失败"
        return 1
    }
    
    # 删除原 main 分支并重命名当前分支
    git branch -D main 2>/dev/null || true
    git branch -m main
    
    # 强制推送（谨慎使用）
    print_warning "即将强制推送到远程仓库，这将覆盖远程历史"
    git push origin main --force || {
        print_error "推送失败"
        return 1
    }
    
    print_success "Git 操作完成"
}

# ================================================================
# 清理目标目录函数（使用 zsh 的通配符特性）
# ================================================================
# ℹ️ tiddlywiki 的 save命令，并不会删除目标仓库中已经存在的文件
# 出于安全考虑，每次构建之前，清空目标文件夹中的tiddler，以确保生成全新的 index.html 文件
clean_target_directory() {
    print_info "清理目标目录..."
    
    # 使用 zsh 的扩展通配符和 NULL_GLOB
    if (( ${+commands[fd]} )); then
        # 删除除了 tiddlywiki.info 的所有文件
        fd -t f -E tiddlywiki.info -E '.git*' -E '.gitignore' -x rm -f

        # 删除所有除了 .git 以外的所有目录
        fd -t d -E .git -x rm -rf
    else
        # 使用 zsh 的通配符特性作为备用方案
        print_warning "fd 命令不可用，使用 zsh 内置通配符"
        
        # 删除文件（排除 tiddlywiki.info 和 .git 相关）
        # 使用 zsh 的 EXTENDED_GLOB 和 NULL_GLOB
        local -a files_to_delete
        files_to_delete=(^(tiddlywiki.info|.git*)(D))
        
        if (( ${#files_to_delete} > 0 )); then
            rm -rf $files_to_delete
        fi
    fi
    
    print_success "目录清理完成"
}

# ================================================================
# 导出 TiddlyWiki 内容函数
# ================================================================
# 使用的是tiddlywiki的子命令：save
# tiddlywiki <wikifolder> --save <tiddler-filter> <filename-filter>

export_tiddlers() {
    print_info "导出需要发布的 tiddlers..."
    
    # 系统tiddler <tiddler-filter>
    local system_tiddler_filter_expression='[all[tiddlers]is[system]!prefix[$:/plugins/]]'
    # 系统tiddler <filename-filter>
    local system_filename_filter_expression='[removeprefix[$:/]addprefix[tiddlers/_System/]]'

    # 非系统tiddler <tiddler-filter>
    local non_system_tiddler_filter_expression='[all[tiddlers]!is[system]!tag[Journal]!tag[密码(Passwords)]!visibility[Private]!prefix[$:/state/]!prefix[$:/temp/]!prefix[$:/plugins]]'
    # 非系统tiddler <filename-filter>
    local non_system_filename_filter_expression='[addprefix[tiddlers/]]'
    
    tiddlywiki $WIKISPACE_PATH --output $PUBLIC_WIKISPACE_PATH --save $system_tiddler_filter_expression $system_filename_filter_expression >/dev/null || {
        print_error "系统 tiddlers 导出失败"
        return 1
    }
    tiddlywiki $WIKISPACE_PATH --output $PUBLIC_WIKISPACE_PATH --save $non_system_tiddler_filter_expression $non_system_filename_filter_expression >/dev/null || {
        print_error "非系统 tiddlers 导出失败"
        return 1
    }
    
    print_success "Tiddlers 导出完成"
}

# ================================================================
# 敏感词汇检测和清理函数（使用 ripgrep）
# ================================================================
scan_and_remove_sensitive_files() {
    
    # 如果保存敏感词汇的文件存在，或者为空，则跳过该步骤
    if [[ ! -s $SENSITIVE_WORDS_PATH ]]; then
        print_info "$SENSITIVE_WORDS_PATH 文件不存在，跳过敏感词汇检查"
        return 0
    else
        # 读取敏感词汇数组变量
        source $SENSITIVE_WORDS_PATH  
        if [[ -z $SENSITIVE_WORDS ]]; then 
            print_info "'SENSITIVE_WORDS'数组敏感词汇为空，跳过敏感词汇检查"
            return 0
        fi
        print_success "敏感词汇读取成功"
        print_info "开始扫描敏感词汇..."
    fi
    # 检查 ripgrep 是否可用
    if ! (( ${+commands[rg]} )); then
        print_error "ripgrep (rg) 命令不可用，无法进行敏感词汇检测"
        return 1
    fi
    
    local -a sensitive_files=()
    local -a rg_patterns=()
    
    # 构建 ripgrep 搜索模式（使用正则表达式边界匹配）
    for word in $SENSITIVE_WORDS; do
        rg_patterns+=("-e" "\\b${word}\\b")
    done
    
    print_info "检测敏感词汇: ${(j:, :)SENSITIVE_WORDS}"
    
    # 使用 ripgrep 搜索敏感词汇
    # -l: 只输出包含匹配内容的文件名
    # -i: 忽略大小写
    # -U: 多行模式
    # --type-not: 排除特定类型文件
    # 排除 .git 目录和 tiddlywiki.info 文件
    # 使用 || true，确保即使没有搜索到任何文件，程序也能继续执行
    local rg_output
    rg_output=$(rg -l -s -U --no-messages\
        --glob '!.git/**' \
        --glob '!tiddlers/_System/**' \
        --glob '!tiddlywiki.info' \
        "${rg_patterns[@]}" .) || true
    
    # 将输出转换为数组
    if [[ -n $rg_output ]]; then
        # 使用 zsh 的参数扩展将换行分隔的字符串转换为数组
        sensitive_files=(${(fu)rg_output})
        # 调试：显示原始输出和数组内容
        print_info "调试 - 原始rg输出行数: $(echo "$rg_output" | wc -l)"
        print_info "调试 - 数组元素个数: ${#sensitive_files}"
    
        # 检查是否有重复
        local unique_count=$(printf '%s\n' "${sensitive_files[@]}" | sort -u | wc -l)
        print_info "调试 - 去重后元素个数: $unique_count"
        
        if (( ${#sensitive_files} != unique_count )); then
            print_warning "检测到重复文件路径！"
        fi
    fi
    
    # 检查是否发现敏感文件
    if (( ${#sensitive_files} == 0 )); then
        print_success "未发现包含敏感词汇的文件"
        return 0
    fi
    
    print_warning "发现 ${#sensitive_files} 个包含敏感词汇的文件:"
    
    # 显示发现的敏感文件及其包含的敏感词汇
    for file in $sensitive_files; do
        print_warning "  文件: $file"
        
        # 显示该文件中匹配的敏感词汇（用于调试）
        local matched_words
        matched_words=$(rg -i -o --no-messages \
            "${rg_patterns[@]}" \
            "$file" | sort -u) || true
        
        if [[ -n $matched_words ]]; then
            local -a words_array=(${(f)matched_words})
            print_warning "    包含敏感词: ${(j:, :)words_array}"
        fi
    done
    
    # 删除包含敏感词汇的文件
    print_info "正在删除包含敏感词汇的文件..."
    
    local deleted_count=0
    for file in $sensitive_files; do
        if [[ -f $file ]]; then
            rm -f "$file" && {
                print_info "已删除: $file"
                (( ++deleted_count ))
            } || {
                print_error "删除失败: $file"
            }
        fi
    done
    
    if (( deleted_count > 0 )); then
        print_warning "共删除了 $deleted_count 个包含敏感词汇的文件"
        print_warning "请检查是否有重要文件被误删，必要时请调整敏感词汇列表"
    fi
    
    print_success "敏感词汇检测和清理完成"
}

# ================================================================
# 设置特殊字段函数
# ================================================================
configure_special_fields() {
    print_info "配置特殊 tiddler 字段..."
    
    # 在浏览器中浏览时不会 trigger the dirty state
    wikispace_set_field '[[$:/config/SaverFilter]]' 'text' '<PLACEHOLDER>' || return 1
    # 打开tab的同时，更新地址栏地址
    wikispace_set_field '[[$:/config/Navigation/UpdateHistory]]' 'text' '$:/uzvg/FieldsValueTemplates/yes' || return 1
    # 自动添加modifier为uzvg 
    wikispace_set_field '[[$:/status/UserName]]' 'text' '$:/uzvg/FieldsValueTemplates/uzvg' || return 1
    # 从 Page Control 栏删除文件状态按钮
    wikispace_set_field '[[$:/core/ui/Buttons/save-wiki]]' 'tags' '<PLACEHOLDER>' || return 1
    # 设置默认tiddler为Home & Reading
    wikispace_set_field '[[$:/DefaultTiddlers]]' 'text' '$:/uzvg/FieldsValueTemplates/DefaultTiddlers' || return 1
    
    # Disable Recent Tab In SideBar
    # wikispace_set_field '[[$:/core/ui/SideBar/Recent]]' 'text' '<PLACEHOLDER>' || return 1
    # 关闭More SideBar中的非必要Tab
    wikispace_set_field '[[$:/core/ui/SideBar/Recent]]' 'tags' '<PLACEHOLDER>'|| return 1
    wikispace_set_field '[[$:/core/ui/MoreSideBar/Recent]]' 'tags' '<PLACEHOLDER>' || return 1
    wikispace_set_field '[[$:/core/ui/MoreSideBar/All]]' 'tags' '<PLACEHOLDER>' || return 1
    wikispace_set_field '[[$:/core/ui/MoreSideBar/Missing]]' 'tags' '<PLACEHOLDER>' || return 1
    wikispace_set_field '[[$:/core/ui/MoreSideBar/Types]]' 'tags' '<PLACEHOLDER>' || return 1
    wikispace_set_field '[[$:/core/ui/MoreSideBar/Orphans]]' 'tags' '<PLACEHOLDER>' || return 1
    # 关闭 tools SideBar
    wikispace_set_field '[[$:/core/ui/SideBar/Tools]]' 'tags' '<PLACEHOLDER>' || return 1
    # 关闭 Settings 按钮
    wikispace_set_field '[[$:/core/ui/Buttons/control-panel]]' 'tags' '<PLACEHOLDER>' || return 1
    # 关闭 new-Journal 按钮
    wikispace_set_field '[[$:/core/ui/Buttons/new-journal]]' 'tags' '<PLACEHOLDER>' || return 1
    # 关闭 new-markdown 按钮
    wikispace_set_field '[[$:/plugins/tiddlywiki/markdown/new-markdown-button]]' 'tags' '<PLACEHOLDER>' || return 1

    print_success "特殊字段配置完成"
}

# ================================================================
# 构建输出文件函数
# ================================================================
build_output_file() {
    print_info "构建输出文件 $OUTPUT_FILE..."
    
    tiddlywiki --render  '.' $OUTPUT_FILE 'text/plain' '$:/plugins/tiddlywiki/tiddlyweb/save/offline' >/dev/null || {
        print_error "构建输出文件失败"
        return 1
    }
    
    # 使用 zsh 的路径测试
    if [[ ! -f output/$OUTPUT_FILE ]]; then
        print_error "输出文件未生成: $OUTPUT_FILE"
        print_error "$PWD"
        return 1
    fi
    
    print_success "输出文件构建完成: $OUTPUT_FILE"
}

# ================================================================
# 主要构建函数（使用 zsh 的 pushd/popd）
# ================================================================
build_public_wikispace() {
    print_info "开始构建公共 WikiSpace..."
    
    # 使用 zsh 的 pushd 自动管理目录栈
    pushd $PUBLIC_WIKISPACE_PATH || {
        print_error "无法切换到目标目录: $PUBLIC_WIKISPACE_PATH"
        return 1
    }
    
    # 使用 zsh 的 always 块确保总是执行 popd
    {
        print_info "当前工作目录: $PWD"
        
        # 执行构建步骤
        clean_target_directory
        export_tiddlers
        scan_and_remove_sensitive_files
        configure_special_fields
        build_output_file
        commit_latest_version_only
        
        print_success "公共 WikiSpace 构建完成！"
    } always {
        popd
    }
}

# ================================================================
# 主函数
# ================================================================
main() {
    print_info "开始执行 WikiSpace 公共版本构建脚本"
    
    # 执行预检查
    check_dependencies
    validate_paths
    
    # 执行主要构建流程
    build_public_wikispace
    
    print_success "脚本执行完成！"
}

# ================================================================
# 脚本入口点（使用 zsh 的 $ZSH_EVAL_CONTEXT 检查）
# ================================================================
# 只有在直接执行此脚本时才运行 main 函数
if [[ ${ZSH_EVAL_CONTEXT:-file} == (file|toplevel) ]]; then
    main "$@"
fi
