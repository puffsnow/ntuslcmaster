FROM ruby:2.6.3

# 安裝必要的系統相依套件
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    postgresql-client

# 設定工作目錄
WORKDIR /app

# 複製 Gemfile
COPY Gemfile Gemfile.lock ./

# 安裝 Ruby gems
RUN bundle install

# 複製應用程式程式碼
COPY . .

# 設定環境變數
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true

# 編譯 assets
RUN bundle exec rake assets:precompile

# 設定 port
EXPOSE 3000

# 啟動 Rails 伺服器
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
