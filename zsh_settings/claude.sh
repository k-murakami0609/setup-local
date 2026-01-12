cc() {
  export AWS_REGION=ap-northeast-1

  # SSO セッションの有効性を確認
  if ! aws sts get-caller-identity --profile developer &>/dev/null; then
    aws sso login --profile developer
  fi
  AWS_PROFILE=developer claude-dev
}

ccc() {
  export AWS_REGION=ap-northeast-1

  # SSO セッションの有効性を確認
  if ! aws sts get-caller-identity --profile developer &>/dev/null; then
    aws sso login --profile developer
  fi
  AWS_PROFILE=developer claude-dev --continue
}

ccd() {
  export AWS_REGION=ap-northeast-1

  # SSO セッションの有効性を確認
  if ! aws sts get-caller-identity --profile developer &>/dev/null; then
    aws sso login --profile developer
  fi
  AWS_PROFILE=developer claude-dev --dangerously-skip-permissions
}

claude-dev() {
  local current_dir=$(pwd)
  local pinnacles_root="$HOME/Desktop/project/github.com/pinnacles"

  # 現在のディレクトリが pinnacles 配下かチェック
  if [[ "$current_dir" == "$pinnacles_root"* ]]; then
    # pinnacles からの相対パスを取得 (例: tebiki-skp/frontend)
    local relative_path="${current_dir#$pinnacles_root/}"

    # pinnacles 直下の場合（プロジェクト名がない）
    if [[ -z "$relative_path" || "$relative_path" == "$current_dir" ]]; then
      echo "Running claude in dev workspace (pinnacles root)"
      (cd "$pinnacles_root" && dev workspace exec -- bash -c "cd /workspace && claude $*")
      return
    fi

    # プロジェクト名を取得 (例: tebiki-skp, setup-local)
    local project_name="${relative_path%%/*}"

    # プロジェクトルート
    local project_root="$pinnacles_root/$project_name"

    # プロジェクトルートからの相対パス (例: /frontend)
    local subdir="${current_dir#$project_root}"

    # サブシェルでプロジェクトルートに移動して dev workspace exec を実行
    # サブシェルなので、終了後は元のディレクトリに戻る
    echo "Running claude in dev workspace ($project_name)"
    (cd "$pinnacles_root" && dev workspace exec -- bash -c "cd /workspace/$project_name$subdir && claude $*")
  else
    # pinnacles 配下でない場合はローカルで実行
    echo "Running claude locally"
    claude $*
  fi
}
