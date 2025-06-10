#!/bin/bash

set -e

echo -e "Onboarding Start\n"

# 기본값 세팅
DEFAULT_APP_IDENTIFIER="com.noweekend.app"
DEFAULT_TEAM_ID="SQ5T25W9V5"
DEFAULT_ITC_TEAM_ID="123584421"

# .env 파일 체크 및 생성
if [ -f .env ]; then
  echo -e".env 파일이 이미 존재합니다. 기존 파일을 사용합니다."
else
  echo "=== .env 파일이 없습니다. 아래 정보를 입력해 주세요 ==="
  read -p "MATCH_PASSWORD (인증서 비밀번호): " MATCH_PASSWORD
  read -p "APPLE_ID (Apple 개발자 이메일): " APPLE_ID

  # 입력값 체크
  if [ -z "$MATCH_PASSWORD" ] || [ -z "$APPLE_ID" ]; then
    echo "MATCH_PASSWORD와 APPLE_ID는 반드시 입력해야 합니다."
    exit 1
  fi

  cat <<EOF > .env
MATCH_PASSWORD=$MATCH_PASSWORD
APPLE_ID=$APPLE_ID
APP_IDENTIFIER=$DEFAULT_APP_IDENTIFIER
TEAM_ID=$DEFAULT_TEAM_ID
ITC_TEAM_ID=$DEFAULT_ITC_TEAM_ID
EOF

  echo ".env 파일이 생성되었습니다!"
fi

# mise 설치
if ! command -v mise &> /dev/null; then
  echo -e "[mise] mise is not installed. Installing..."
  curl https://mise.run | sh
else
  echo -e "[mise] mise is already installed."
fi

# mise 활성화 (zsh)
if ! grep -q 'mise activate zsh' ~/.zshrc; then
  echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
  eval "$(~/.local/bin/mise activate zsh)"
fi

# Homebrew 설치 및 업데이트
if ! command -v brew &> /dev/null; then
  echo -e "[brew] Homebrew is not installed. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo -e "[brew] Homebrew is already installed. Updating..."
  brew update
fi

# tuist 설치 (mise.toml에 버전 명시 시 mise로 설치, 아니면 brew)
if [ -f .mise.toml ]; then
  TUIST_VERSION=$(grep 'tuist' .mise.toml | awk -F'"' '{print $2}')
  echo -e "[tuist] tuist version specified in mise.toml: $TUIST_VERSION"
  mise install tuist
else
  if ! command -v tuist &> /dev/null; then
    echo -e "[tuist] Installing tuist..."
    brew install tuist
  else
    echo -e "[tuist] tuist is already installed."
  fi
fi

# rbenv, Ruby 설치
if ! command -v rbenv &> /dev/null; then
  echo -e "[rbenv] Installing rbenv..."
  brew install rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
fi

# rbenv 환경을 현재 셸에 즉시 적용
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

# .ruby-version
RUBY_VERSION=$(cat .ruby-version)
if ! rbenv versions | grep -q "$RUBY_VERSION"; then
  echo -e "[ruby] Installing Ruby $RUBY_VERSION..."
  rbenv install "$RUBY_VERSION"
fi
rbenv global "$RUBY_VERSION"
export PATH="$HOME/.rbenv/shims:$PATH"
echo -e "[ruby] Ruby version: $(ruby -v)"

# bundler 설치 (Gemfile.lock에 맞는 버전)
BUNDLER_VERSION=$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1 | xargs)
if ! gem list bundler -i -v "$BUNDLER_VERSION" > /dev/null; then
  echo -e "[bundler] Installing bundler $BUNDLER_VERSION..."
  gem install bundler -v "$BUNDLER_VERSION"
else
  echo -e "[bundler] bundler $BUNDLER_VERSION is already installed."
fi

# 번들 의존성 설치
echo -e "[bundle] Running bundle install..."
bundle install

# tuist generate
echo -e "[tuist] Running tuist generate..."
tuist generate

# fastlane match로 인증서/프로비저닝 설치
echo -e "[fastlane] Installing development, appstore certificates/provisioning profiles..."
bundle exec fastlane match development --readonly
bundle exec fastlane match appstore --readonly

echo -e "\n✅ Onboarding completed"