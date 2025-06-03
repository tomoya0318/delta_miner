# --- Stage 1: ダウンロードandビルド ---
FROM debian:bookworm-slim AS downloader

# ARGでバージョンを指定
ARG NODE_VERSION=22.16.0

# ダウンロードと展開に必要なツールをインストール
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    wget \
    unzip \
    ca-certificates \
    xz-utils \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 成果物を格納するディレクトリを作成
WORKDIR /artifacts

# GumTreeのダウンロードと展開
RUN wget "https://github.com/GumTreeDiff/gumtree/releases/download/v4.0.0-beta2/gumtree-4.0.0-beta2.zip" \
    && unzip "gumtree-4.0.0-beta2.zip" \
    && mv "gumtree-4.0.0-beta2" "gumtree"

# Node.jsの公式バイナリをダウンロードし展開
RUN wget "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-arm64.tar.xz" \
        -O nodejs.tar.xz && \
    tar -xJf nodejs.tar.xz && \
    rm nodejs.tar.xz && \
    mv "node-v${NODE_VERSION}-linux-arm64" nodejs_dist

# --- Stage 2: アプリケーション環境のセットアップ ---
FROM debian:bookworm-slim

# ARGで指定した値の再定義
ARG NODE_VERSION=22.16.0
ARG UID
ARG GID
ARG USERNAME
ARG GROUPNAME

# 環境設定
ENV LANG=C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_HOME=/opt/nodejs
ENV PATH=${NODE_HOME}/bin:${PATH}
COPY --from=downloader /artifacts/nodejs_dist ${NODE_HOME}

# タイムゾーン設定
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# ランタイムに必要な依存パッケージをインストール
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    sudo \
    openjdk-17-jre \
    procps \
    make \
    git \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# GumTreeのセットアップ
COPY --from=downloader /artifacts/gumtree /opt/gumtree

# uvのインストール
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    mkdir -p /usr/local/bin && \
    mv /root/.local/bin/uv /usr/local/bin/uv && \
    rm -rf /root/.local

# グループとユーザーを作成
RUN (getent group ${GROUPNAME} || groupadd -g ${GID} ${GROUPNAME}) && \
    (getent passwd ${USERNAME} || useradd -u ${UID} -g ${GROUPNAME} -d /home/${USERNAME} -m -s /bin/bash ${USERNAME}) && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

# ユーザーを切り替え
USER ${USERNAME}
# ユーザー切り替え後の作業ディレクトリ
ENV WORK_DIR=/works
WORKDIR ${WORK_DIR}

COPY --chown=${USERNAME}:${GROUPNAME} pyproject.toml uv.lock ./
COPY --chown=${USERNAME}:${GROUPNAME} package.json package-lock.json ./
# python3.13の環境を整備
RUN uv python install 3.13

# .venv 仮想環境の作成と依存関係のインストール
RUN uv venv .venv && \
. .venv/bin/activate && \
uv sync --frozen

# jsの依存関係のインストール
RUN npm install

# ★ ユーザーの環境変数を設定 (PATHに /works/.venv/bin を追加)
ENV PATH="/opt/gumtree/bin:${WORK_DIR}/.venv/bin:${PATH}"
