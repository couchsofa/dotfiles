# prompt color depending on return status of last command
local ret_status="%(?:%{$fg_bold[green]%}λ⇒ :%{$fg_bold[red]%}λ⇒ )"

# custom git status
ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="]$reset_color"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]✗"
ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]"

# battery charge symbols
ZSH_BAT_PROMPT_CHR="◄"
ZSH_BAT_PROMPT_DSC="►"
ZSH_BAT_PROMPT_FLL="▮"
ZSH_BAT_PROMPT_UNK="?"

function get_pwd() {
  echo "${PWD/$HOME/~}"
}

function put_spacing() {
  local git=$(git_prompt_info)
  if [ ${#git} != 0 ]; then
      ((git=${#git} - 10))
  else
      git=0
  fi

  local bat=$(battery_charge)
  if [ ${#bat} != 0 ]; then
      ((bat = ${#bat} - 5))
  else
      bat=0
  fi

  # calculate spaces between left an right part of PROMPT
  local termwidth
  (( termwidth = ${COLUMNS} - 4 - ${#HOST} - 2 - ${#USER} - ${#$(get_pwd)} - ${bat} - ${git} ))

  # generate string with the amount of spaces calculated
  local spacing=""
  for i in {1..$termwidth}; do
      spacing="${spacing} "
  done
  echo $spacing
}

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function battery_charge() {
    # catch acpi no battery
    if [ "`acpi -b | grep -o "Battery"`" != 'Battery' ]
    then
      echo "$fg[yellow]✗✗✗✗✗✗✗✗✗✗"
    else

      local acpi_str=""
      local charge=""

      acpi_str=`acpi -b`
      charge=`echo $acpi_str | grep -oP "(\d+(\.\d+)?(?=%))"`
      charge=$(($charge / 10))

      local symbol=""
      local prefix=""

      # choose symbol according to state

      # Charging
      if [ "`echo $acpi_str | grep -o "Charging"`" != '' ]
      then
        symbol="$ZSH_BAT_PROMPT_CHR"
        prefix="$fg[green]"
      # Full
      elif [ "`echo $acpi_str | grep -o "Full"`" != '' ]
      then
        symbol="$ZSH_BAT_PROMPT_FLL"
        prefix="$fg[green]"
      # Unknown
      elif [ "`echo $acpi_str | grep -o "Unknown"`" != '' ]
      then
        symbol="$ZSH_BAT_PROMPT_UNK"
        prefix="$fg[yellow]"
      # Discharging
      else
        symbol="$ZSH_BAT_PROMPT_DSC"
        prefix="$fg[red]"
      fi

      # generate string

      local string=""

      # spaces
      local filler=""
      ((filler = 10 - $charge))
      if [ $filler != 0 ]
      then
        for i in {1..$filler}; do
          string="${string} "
        done
      fi

      # arrows
      for i in {1..$charge}; do
          string="${string}$symbol"
      done

      echo "${prefix}$string"
    fi
}

PROMPT='
%{$fg[cyan]%}%m%{$reset_color%}[%{$fg[blue]%}%n%{$reset_color%}]: %{$fg[yellow]%}$(get_pwd)$(put_spacing)$(git_prompt_info)%{$reset_color%}[$(battery_charge)%{$reset_color%}]
${ret_status}%{$reset_color%}'
