#!/bin/sh
# Read-only chezmoi inspection helper for the chezmoi OpenCode skill.
# Usage: inspect.sh <target-path>
#
# Output is key=value lines. Nothing is modified; temporary files are created
# under TMPDIR and removed before exit.

set -u

usage() {
  printf 'usage: %s <target-path>\n' "$0" >&2
  exit 2
}

[ "$#" -eq 1 ] || usage

target=$1

resolve_path() {
  _p=$1
  case $_p in
    /*) ;;
    *) _p=$PWD/$_p ;;
  esac
  _d=$(dirname -- "$_p")
  _b=$(basename -- "$_p")
  if [ -d "$_d" ]; then
    _d=$(cd "$_d" 2>/dev/null && pwd) || _d=$(dirname -- "$_p")
    printf '%s/%s\n' "$_d" "$_b"
  else
    printf '%s\n' "$_p"
  fi
}

target=$(resolve_path "$target")

have_chezmoi=1
if ! command -v chezmoi >/dev/null 2>&1; then
  have_chezmoi=0
fi

if [ "$have_chezmoi" -eq 1 ]; then
  home=$(chezmoi execute-template '{{ .chezmoi.homeDir }}' 2>/dev/null) || home=${HOME:-}
  os=$(chezmoi execute-template '{{ .chezmoi.os }}' 2>/dev/null) || os=unknown
  source_dir=$(chezmoi source-path 2>/dev/null) || source_dir=
else
  home=${HOME:-}
  os=unknown
  source_dir=
fi

[ -n "$home" ] || home=${HOME:-}

printf 'target=%s\n' "$target"
printf 'home=%s\n' "$home"
printf 'os=%s\n' "$os"
printf 'source_dir=%s\n' "$source_dir"

if [ "$have_chezmoi" -eq 0 ]; then
  printf 'state=no-chezmoi\n'
  printf 'source=\n'
  printf 'kind=unknown\n'
  printf 'drift=unknown\n'
  printf 'rel_target=\n'
  printf 'linux=unknown\n'
  printf 'windows=unknown\n'
  exit 0
fi

case "$target" in
  "$home"/*) ;;
  "$home") ;;
  *)
    printf 'state=outside-home\n'
    printf 'source=\n'
    printf 'kind=unknown\n'
    printf 'drift=unknown\n'
    printf 'rel_target=\n'
    printf 'linux=unknown\n'
    printf 'windows=unknown\n'
    exit 0
    ;;
esac

rel=${target#"$home"/}
[ "$rel" = "$target" ] && rel=.

match_ignored() {
  _rel=$1
  chezmoi ignored 2>/dev/null | while IFS= read -r _p; do
    [ -n "$_p" ] || continue
    _p=${_p%/}
    case $_rel in
      "$_p"|"$_p"/*) printf '%s\n' "$_p"; break ;;
    esac
  done
}

# Return 0 if rel is ignored for the given OS, 1 if not, 2 if unknown.
is_ignored_for() {
  _os=$1
  _rel=$2
  _tmp=$(mktemp "${TMPDIR:-/tmp}/chezmoi-inspect.XXXXXX" 2>/dev/null) || return 2

  if [ -z "$source_dir" ] || [ ! -f "$source_dir/.chezmoiignore.tmpl" ]; then
    rm -f "$_tmp"
    return 2
  fi

  if ! chezmoi execute-template \
      --override-data "{\"chezmoi\":{\"os\":\"$_os\"}}" \
      < "$source_dir/.chezmoiignore.tmpl" > "$_tmp" 2>/dev/null; then
    rm -f "$_tmp"
    return 2
  fi

  _rc=1
  while IFS= read -r _p; do
    [ -n "$_p" ] || continue
    case $_p in \#*) continue ;; esac
    _p=${_p%/}
    case $_rel in
      "$_p"|"$_p"/*) _rc=0; break ;;
    esac
  done < "$_tmp"
  rm -f "$_tmp"
  return $_rc
}

kind=unknown
wrapper_template=
redirect=
redirect_kind=
encrypted_source=

classify_source() {
  _src=$1
  kind=plain
  wrapper_template=
  redirect=
  redirect_kind=
  encrypted_source=

  case $_src in
    */encrypted_*|*.age) kind=encrypted ;;
  esac

  if [ "$kind" = plain ]; then
    _is_enc=0
    case $_src in
      */.chezmoitemplates/*)
        grep -q 'include.*decrypt' "$_src" 2>/dev/null && _is_enc=1
        ;;
      *)
        head -n 1 "$_src" 2>/dev/null | grep -q 'include.*decrypt' && _is_enc=1
        ;;
    esac

    if [ "$_is_enc" -eq 1 ]; then
      kind=encrypted-template
      _enc=$(grep -o -E '[^"[:space:]]+\.age' "$_src" 2>/dev/null | head -n 1)
      if [ -n "$_enc" ]; then
        case $_enc in
          /*) encrypted_source=$_enc ;;
          *) encrypted_source=$source_dir/$_enc ;;
        esac
      fi
    fi
  fi

  if [ "$kind" = plain ] && head -n 1 "$_src" 2>/dev/null | grep -q '{{.*template[[:space:]]*"'; then
    kind=wrapper
    _tpl=$(sed -n 's/.*template[[:space:]]*"\([^"]*\)".*/\1/p' "$_src" 2>/dev/null | head -n 1)
    if [ -n "$_tpl" ]; then
      wrapper_template=$_tpl
      redirect=$source_dir/.chezmoitemplates/$_tpl
      if [ -f "$redirect" ]; then
        if grep -q 'include.*decrypt' "$redirect" 2>/dev/null; then
          redirect_kind=encrypted-template
          _enc=$(grep -o -E '[^"[:space:]]+\.age' "$redirect" 2>/dev/null | head -n 1)
          if [ -n "$_enc" ]; then
            case $_enc in
              /*) encrypted_source=$_enc ;;
              *) encrypted_source=$source_dir/$_enc ;;
            esac
          fi
        else
          redirect_kind=template
        fi
      else
        redirect_kind=missing
      fi
    fi
  fi

  if [ "$kind" = plain ] && [ "${_src#*/.chezmoitemplates/}" != "$_src" ]; then
    kind=shared-template
  fi

  if [ "$kind" = plain ] && [ "${_src%.tmpl}" != "$_src" ]; then
    kind=template
  fi
}

state=unmanaged
source=
ignored_by=
if src=$(chezmoi source-path -- "$target" 2>/dev/null); then
  state=managed
  source=$src
else
  ignored_by=$(match_ignored "$rel")
  [ -n "$ignored_by" ] && state=ignored
fi

if [ -n "$source" ]; then
  classify_source "$source"
fi

drift=unknown
if [ "$state" = managed ]; then
  if chezmoi verify -- "$target" >/dev/null 2>&1; then
    drift=clean
  else
    drift=dirty
  fi
fi

check_os() {
  _o=$1
  _r=$2
  if is_ignored_for "$_o" "$_r"; then
    printf 'ignore\n'
  else
    _rc=$?
    if [ "$_rc" -eq 1 ]; then
      printf 'deploy\n'
    else
      printf 'unknown\n'
    fi
  fi
}

# For a shared-template wrapper, include the other platform wrappers that
# reference the same template. This makes linux/windows reflect the logical
# config, not just the current platform's target path.
related=$rel
if [ -n "$wrapper_template" ]; then
  _matches=$(grep -rl --include='*.tmpl' -F "template \"$wrapper_template\"" "$source_dir" 2>/dev/null)
  while IFS= read -r _f; do
    [ -n "$_f" ] || continue
    _abs=$(chezmoi target-path -- "$_f" 2>/dev/null) || continue
    [ -n "$_abs" ] || continue
    _r=${_abs#"$home"/}
    [ "$_r" = "$_abs" ] && continue
    case "|$related|" in
      *"|$_r|"*) ;;
      *) related="$related|$_r" ;;
    esac
  done <<EOF
$_matches
EOF
fi

linux=unknown
windows=unknown
if [ "$state" = managed ] || [ "$state" = ignored ]; then
  _any_linux=0
  _ignore_linux=0
  _known_linux=1
  _any_windows=0
  _ignore_windows=0
  _known_windows=1

  _old_ifs=$IFS
  IFS='|'
  for _r in $related; do
    case $(check_os linux "$_r") in
      deploy) _any_linux=1 ;;
      ignore) _ignore_linux=1 ;;
      *) _known_linux=0 ;;
    esac
    case $(check_os windows "$_r") in
      deploy) _any_windows=1 ;;
      ignore) _ignore_windows=1 ;;
      *) _known_windows=0 ;;
    esac
  done
  IFS=$_old_ifs

  if [ "$_any_linux" -eq 1 ]; then
    linux=deploy
  elif [ "$_known_linux" -eq 1 ] && [ "$_ignore_linux" -eq 1 ]; then
    linux=ignore
  fi

  if [ "$_any_windows" -eq 1 ]; then
    windows=deploy
  elif [ "$_known_windows" -eq 1 ] && [ "$_ignore_windows" -eq 1 ]; then
    windows=ignore
  fi
fi

printf 'state=%s\n' "$state"
printf 'source=%s\n' "$source"
printf 'kind=%s\n' "$kind"
[ -n "$wrapper_template" ] && printf 'wrapper_template=%s\n' "$wrapper_template"
[ -n "$redirect" ] && printf 'redirect=%s\n' "$redirect"
[ -n "$redirect_kind" ] && printf 'redirect_kind=%s\n' "$redirect_kind"
[ -n "$encrypted_source" ] && printf 'encrypted_source=%s\n' "$encrypted_source"
[ -n "$ignored_by" ] && printf 'ignored_by=%s\n' "$ignored_by"
printf 'drift=%s\n' "$drift"
printf 'rel_target=%s\n' "$rel"
printf 'targets=%s\n' "$related"
printf 'linux=%s\n' "$linux"
printf 'windows=%s\n' "$windows"

exit 0
