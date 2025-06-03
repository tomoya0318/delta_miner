
# Delta Miner　

<p style="display: inline">
<!-- 技術スタック一覧 -->
<img src="https://img.shields.io/badge/-Docker-2496ED.svg?logo=docker&style=for-the-badge&logoColor=white">
<img src="https://img.shields.io/badge/-Python-3776AB.svg?logo=python&style=for-the-badge&logoColor=white">
<img src="https://img.shields.io/badge/-Node.js-339933.svg?logo=node.js&style=for-the-badge&logoColor=white">
<img src="https://img.shields.io/badge/-JavaScript-F7DF1E.svg?logo=javascript&style=for-the-badge&logoColor=black">
<img src="https://img.shields.io/badge/-Java-007396.svg?logo=java&style=for-the-badge&logoColor=white">
<img src="https://img.shields.io/badge/-uv-7C4DFF.svg?style=for-the-badge&logoColor=white">
<img src="https://img.shields.io/badge/-GumTree-4B32C3.svg?style=for-the-badge&logoColor=white">
</p>

## 目次
1. [環境](#環境)
2. [開発環境構築](#開発環境構築)

## 環境
| 言語・フレームワーク  | バージョン  |
| --------------------- | ----------- |
| Docker                | 27.4.0      |
| Python                | 3.13.0      |
| Node.js               | 22.16.0     |
| Java                  | 17.0.15     |
| GumTree               | 4.0.0-beta2 |

その他のパッケージはpackage.jsonとpyproject.tomlを確認してください

### devcontainerの利用
基本的にはdevcontainerにて，コンテナ環境を提供しているため，そちらを使用してください

### ローカル環境
一部python，jsのみで動くコードに対しては実行が可能です

**uvのセットアップ**
- 仮想環境の有効化
```
source .venv/bin/activate
```
- 仮想環境の無効化
```
deactivate
```
- uvのlockファイルの作成
```
uv lock
```
- パッケージのインストール
```
uv sync
```
